import time
import subprocess
import os
import csv
import re
import json

import multiprocessing as mp
import argparse
import threading


from flask import Flask, request
app = Flask(__name__)

parser = argparse.ArgumentParser(description='Optional app description')
parser.add_argument('--ip_address', type=str, default="192.168.14.13",
                    help='A required integer positional argument')
parser.add_argument('--node_name', type=str, default="caelum-605",
                    help='A required integer positional argument')

parser.add_argument('--overload_loop', type=bool, default=False,
                    help='A required integer positional argument')

parser.add_argument('--cgroups_loop', type=bool, default=False,
                    help='A required integer positional argument')

parser.add_argument('--port', type=str, default="5000",
                    help='A required integer positional argument')
args = parser.parse_args()
print(args)

def autoscale_pod(ksvc_name):
    print('scaling', ksvc_name)
    # cmd = f"/home/aati2/scale_pod.sh {ksvc_name}"
    # my_env = os.environ.copy()
    # my_env["KUBECONFIG"] = "/home/aati2/.kube/config"
    # process = subprocess.Popen(
    #     [cmd], stdout=subprocess.PIPE, shell=True, env=my_env)
    # output, error = process.communicate()
    # print(cmd)
    # print(output, error)
    # result.append((pod, output, error)) 

def cordon_node(cordon=True):
    print('cordon', cordon)

    if cordon:
        cmd = f"kubectl cordon {args.node_name}"
    else:
        cmd = f"kubectl uncordon {args.node_name}"

    my_env = os.environ.copy()
    my_env["KUBECONFIG"] = "/home/aati2/.kube/config"
    process = subprocess.Popen(
        [cmd], stdout=subprocess.PIPE, shell=True, env=my_env)
    output, error = process.communicate()
    print(cmd)
    print(output, error)
    # result.append((pod, output, error))   

def load_cgroups():

    # fetching cgroup information
    cmd1 = "crictl --runtime-endpoint=/run/containerd/containerd.sock pods --namespace default | grep -v NotReady | grep Ready | grep deployment | awk '{print  $1, $6}' > /home/aati2/pods_names"
    cmd2 = "cat /home/aati2/pods_names | awk '{print  $1}' | xargs crictl --runtime-endpoint=/run/containerd/containerd.sock  inspectp | grep cgroup_parent > /home/aati2/pods_cgroups"
    process = subprocess.Popen(
        [cmd1], stdout=subprocess.PIPE, shell=True)
    time.sleep(0.5)
    process = subprocess.Popen(
        [cmd2], stdout=subprocess.PIPE, shell=True)

    # loading cgroup information
    f = open(f'/home/aati2/pods_names')
    pods_raw = f.read().strip().split('\n')
    f = open(f'/home/aati2/pods_cgroups')
    cgroups_raw = f.read().strip().split('\n')

    pod_ids = [line.split(" ")[0] for line in pods_raw if len(line) > 0]
    # print(pod_ids)

    cmds = [f"crictl --runtime-endpoint=/run/containerd/containerd.sock inspectp {pod_id}" for pod_id in pod_ids]

    child_processes = []
    for index, cmd in enumerate(cmds):
        p = subprocess.Popen([cmd], stdout=subprocess.PIPE, stderr=subprocess.PIPE,shell=True)
        child_processes.append(p)    # start this one, and immediately return to start another

    # now you can join them together
    local_ksvcs = []
    local_cgroups = []
    for cp in child_processes:
        output, error = cp.communicate()
        try:
            result = json.loads(output)
            cgroup = result["info"]['config']["linux"]["cgroup_parent"]
            app_name = result["info"]['config']["labels"]["app"]
            pod_name = result["info"]['config']["labels"]["io.kubernetes.pod.name"]
            local_ksvcs.append(app_name)
            local_cgroups.append(cgroup)
            # print(app_name, cgroup)
        except Exception:
            print("no output")

    # local_ksvcs = [re.findall("(pytorch-classifier-.*)-.*-deployment-.*", pod)[0] for pod in pods_raw if len(re.findall("pytorch-classifier-.*-deployment-.*", pod)) > 0 ]
    # local_cgroups = [re.findall('.*kubepods-burstable.slice/(.*)\"', cgroup)[0] for cgroup in cgroups_raw if len(re.findall('.*kubepods-burstable.slice/(.*)\"', cgroup)) > 0 ]
    
    try:
        assert(len(local_ksvcs) == len(local_cgroups))
    except Exception:
        print("unsynchronised data, bypassed")
        print(local_ksvcs)
        print(local_cgroups)
        return None,None

    # print(local_cgroups)
    # print(local_ksvcs)

    print("load_cgroups", len(local_cgroups), "cgroups")
    return local_ksvcs, local_cgroups    



def load_cgroups_rr(offset=300):

    ksvcs, cgroups = load_cgroups()

    ksvc_ids = [int(re.findall('.*-(\d+)-.*', ksvc)[0]) for ksvc in ksvcs]
    indices = [index for index, x in enumerate(ksvc_ids) if x in range(offset,600)]

    subset  = [cgroup for index, cgroup in enumerate(cgroups) if index in indices]

    subset_cgroups = [re.findall(".*(kubepods-burstable.*)",cgroup)[0] for cgroup in subset]

    lines = [line+"\n" for line in subset_cgroups]

    cgroups_rr = open('/home/aati2/cgroups_rr', 'w',buffering=1)

    cgroups_rr.writelines(lines)



def get_snapshot(ksvcs, cgroups):
    data = []
    ts = int(time.time())
    for index, cgroup in enumerate(cgroups):
        try:
            f = open(
                f'/sys/fs/cgroup/cpu/{cgroup}/cpuacct.usage')
            usage = f.read().strip()
            f = open(
                f'/sys/fs/cgroup/cpu/{cgroup}/cpu.stat')
            wait_sum = f.read().split('\n')[3].split(' ')[1]
            # print(usage,wait_sum)
            data.append({'ksvc': f"{ksvcs[index]}-{cgroup}", 'usage': int(
                usage), 'wait_sum': int(wait_sum), "timestamp": ts, "node": args.node_name})
            # print("reading metrics of valid cgroup #", index)
        except Exception:
            # print("warning: invalid cgroup #", index)
            data.append({'ksvc': f"{ksvcs[index]}-{cgroup}", 'usage': 0, 'wait_sum': 0, "timestamp": ts, "node": args.node_name})   
    print("get_snapshot", len(data), "cgroups")         
    return data  

overload_loop_log = open('/home/aati2/overload_loop_log', 'w',buffering=1)
writer = csv.writer(overload_loop_log)

def overload_loop(
    duration=10,
    contention_metric_window=5,
    overload_threshold=300,
    scaling_threshold=100,
    cooldown_period=15):

    snapshots = []
    cooldown_counter = 0

    ksvcs = []
    cgroups = []
    dftick = None

    # for tick in range(duration):
    while (True):

        # collect a snapshot of cgroup metrics
        if(int(time.time()) % 10 == 0):
            tmp_ksvcs, tmp_cgroups = load_cgroups()

            #we only update the values if we receive new consistent data
            if (tmp_ksvcs is not None) and (tmp_cgroups is not None):
                ksvcs = tmp_ksvcs
                cgroups = tmp_cgroups

            cmd = "echo '1' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/*/cpu.latency_awareness"
            process = subprocess.Popen(
                [cmd], stdout=subprocess.PIPE, shell=True)             

        snapshot_data = get_snapshot(ksvcs, cgroups)
        if len(snapshot_data)  == 0:
            #no pods, nothing to be done
            writer.writerow([time.time(), "NULL"])

        else:

            dftick = pd.DataFrame(snapshot_data)
            dftick_tranposed = pd.DataFrame(
                [dftick['wait_sum'].values/1000000], columns=dftick['ksvc'].values)
            snapshots.append(dftick_tranposed)

            # process metrics
            dfmeasurements = pd.concat(snapshots).reset_index()
            dfdiff = (dfmeasurements.shift(0) - dfmeasurements.shift(1))
            dfdiff = dfdiff.applymap(lambda x: x if x > 0 else None)
            dfmetrics = dfdiff.rolling(contention_metric_window, min_periods=1).mean()
            # dfdiff.sum(axis=1).plot(figsize=(15, 5), xlim=(0, 100))
            # dfmetrics.sum(axis=1).plot(figsize=(15,5),xlim=(0,100))
            # plt.show()

            node_contention = dfmetrics.iloc[-1].sum()
            # print("overload_loop",time.time(),node_contention,node_contention > overload_threshold, flush=True)

            # overload control loop
            if cooldown_counter == 0:

                # most recent sum of contention across all pods
                if node_contention > overload_threshold:
                    # cordon_node(True)
                    cooldown_counter = cooldown_period

                    # most 15 pods suffering from contention
                    # to_be_scaled = dfmetrics.iloc[-1].sort_values(ascending=False)[:15]
                    # print("to be considered for scaling", len(to_be_scaled), to_be_scaled.index)
                    # for ksvc,pod_contention in to_be_scaled.items(): 
                    #     if (pod_contention > scaling_threshold):
                    #         autoscale_pod(ksvc)
            else:            
                if cooldown_counter == 1:                 
                    cordon_node(False)
                cooldown_counter = cooldown_counter - 1
                print('cooldown', cooldown_counter) 

            writer.writerow([time.time(), node_contention, node_contention > overload_threshold, cooldown_counter])

        time.sleep(1)   

    if cooldown_counter > 0: cordon_node(False)


if args.overload_loop:
    loverload_oop_thread = threading.Thread(target=overload_loop, name="overload_loop", args=[])
    loverload_oop_thread.start()


def record_latency(result):
    raise Exception("Done")

@app.route('/overload_loop')
def get_activate():

    duration = int(request.args.to_dict()['duration'])
    contention_metric_window = int(request.args.to_dict()['contention_metric_window'])
    overload_threshold = int(request.args.to_dict()['overload_threshold'])
    scaling_threshold = int(request.args.to_dict()['scaling_threshold'])
    cooldown_period = int(request.args.to_dict()['cooldown_period'])

    return str(loop_thread.is_alive())



def get_snapshot_schedstat():
    cmd = f"cat /proc/schedstat  | grep cpu"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    cpustats =[cpustat for cpustat in str(output).split('\\n')[:12]]
    return {'timestamp': time.time(), 'schedstat': cpustats, 'node': args.node_name}


def metrics_loop():

    ksvcs, cgroups = load_cgroups()
    open('/home/aati2/metrics_dump', 'w').close()
    metrics_dump = open('/home/aati2/metrics_dump', 'a',buffering=1)

    open('/home/aati2/metrics_dump_schedstat', 'w').close()
    metrics_dump_schedstat = open('/home/aati2/metrics_dump_schedstat', 'a',buffering=1)    

    while(True):

        if (int(time.time()) % 1 == 0):
            #enabling contention-resilience scheduling
            cmd = "echo '1' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/*/cpu.latency_awareness"
            process = subprocess.Popen(
                [cmd], stdout=subprocess.PIPE, shell=True)   
                  
        if (int(time.time()) % 60 == 0):
            ksvcs, cgroups = load_cgroups()            

        snapshot = get_snapshot(ksvcs, cgroups)
        metrics_dump.write(json.dumps(snapshot) + "\n")

        snapshot_schedstat = get_snapshot_schedstat()
        metrics_dump_schedstat.write(json.dumps(snapshot_schedstat) + "\n")

        time.sleep(1)


metrics_loop_thread = threading.Thread(target=metrics_loop, name="metrics_loop", args=[])
# metrics_loop_thread.start()

@app.route('/metrics_dump')
def get_metrics_dump():

    f = open("/home/aati2/metrics_dump", "r")
    return (f.read())


@app.route('/metrics_dump_schedstat')
def get_metrics_dump_schedstat():

    f = open("/home/aati2/metrics_dump_schedstat", "r")
    return (f.read())    

@app.route('/metrics_dump_reset')
def get_metrics_dump_reset():

    ksvcs, cgroups = load_cgroups()
    open('/home/aati2/metrics_dump', 'w').close()
    metrics_dump = open('/home/aati2/metrics_dump', 'a',buffering=1)

    open('/home/aati2/metrics_dump_schedstat', 'w').close()
    metrics_dump = open('/home/aati2/metrics_dump_schedstat', 'a',buffering=1)

    return "Done"

@app.route('/overload_metrics')
def get_slowdown():

    # data = []
    # for index, cgroup in enumerate(cgroups):
    #     f = open(
    #         f'/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/{cgroup}/cpuacct.usage')
    #     usage = f.read().strip()
    #     f = open(
    #         f'/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/{cgroup}/cpu.stat')
    #     wait_sum = f.read().split('\n')[3].split(' ')[1]
    #     # print(usage,wait_sum)
    #     data.append({'ksvc': ksvcs[index], 'usage': int(
    #         usage), 'wait_sum': int(wait_sum)})
    # return json.dumps(data)

    snapshots = []

    snapshot_data = get_snapshot(ksvcs, cgroups)

    return json.dumps(snapshot_data)

    # dftick = pd.DataFrame(snapshot_data)
    # dftick_tranposed = pd.DataFrame(
    #     [dftick['wait_sum'].values/1000000], columns=dftick['ksvc'].values)
    # snapshots.append(dftick_tranposed)

    # # process metrics
    # dfmeasurements = pd.concat(snapshots).reset_index()
    # dfdiff = (dfmeasurements.shift(0) - dfmeasurements.shift(1))
    # dfmetrics = dfdiff.rolling(contention_metric_window).mean()    


@app.route('/pod_status')
def get_pod_status():

    my_env = os.environ.copy()
    my_env["KUBECONFIG"] = "/home/aati2/.kube/config"

    cmd1 = f"kubectl get pods -o wide  | grep Running | grep  {args.node_name} | wc -l"
    process = subprocess.Popen(
        [cmd1], stdout=subprocess.PIPE, shell=True, env=my_env)
    output1, error = process.communicate()
    return str(output1) 

# @app.route('/overload_metrics_internal')
# def get_slowdown_internal():

#     data = []
#     for index,(cgroup,user_cgroup,proxy_cgroup) in enumerate(cgroups_internal):
#         f = open(f'/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/{cgroup}/{user_cgroup}/cpu.stat')
#         wait_sum1 = f.read().split('\n')[3].split(' ')[1]

#         f = open(f'/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/{cgroup}/{proxy_cgroup}/cpu.stat')
#         wait_sum2 = f.read().split('\n')[3].split(' ')[1]

#         data.append({'pod':index+1, 'wait_sum_user':int(wait_sum1), 'wait_sum_proxy':int(wait_sum2)})
#     return json.dumps(data)


@app.route('/nr_switches')
def get_nr_switches():
    cmd = f"sudo cat /sys/kernel/debug/sched/debug | grep nr_switches"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error

@app.route('/setup_patch')
def setup_patch():

    script = request.args.to_dict()['script']
    ema = request.args.to_dict()['ema']
    cmd = f"./scripts/{script} {ema}"

    # offset = 300
    # if 'offset' in request.args.to_dict().keys():
    #     offset = int(request.args.to_dict()['offset'])
    # load_cgroups_rr(offset)

    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error

@app.route('/schedstat')
def get_schedstat():
    cmd = f"cat /proc/schedstat  | grep cpu"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error

@app.route('/schedstat_domains')
def get_schedstat_domains():
    cmd = f"cat /proc/schedstat  | grep domain0"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error


@app.route('/sched_debug/wait_count_per_cfs_rq')
def get_sched_debug_wait_count_per_cfs_rq():
    cmd = f"sudo cat /sys/kernel/debug/sched/debug  | grep 'wait_count\\|cfs_rq'"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error


@app.route('/rd_hashd_benchmark_start')
def rd_hashd_benchmark_start():

    funcs_count = request.args.to_dict()['funcs_count']
    duration = request.args.to_dict()['duration']
    llf = request.args.to_dict()['llf']
    llf_str = request.args.get('llf', 'false').lower()  # Default to 'false' if the key is not present
    llf = llf_str == 'true'  # Convert string to boolean

    cmd = f"./scripts/rd_hashd_benchmark_start.sh {funcs_count} {duration}"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()    

    print('llf',llf)
    if (llf):
        cmd = f"./scripts/setup_patch_clean_systemd.sh 1000"
        process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
        output_llf, error_llf = process.communicate()
        return output+output_llf, error
    else:
        return output, error


@app.route('/rd_hashd_benchmark_killall')
def rd_hashd_benchmark_killall():
    cmd = f"sudo killall rd-hashd"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error    

@app.route('/rd_hashd_benchmark_reports')
def rd_hashd_benchmark_reports():
    cmd = f"tail -n +1 ./rd-hashd/results/report-* | grep -v '\/\/'"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error    

@app.route('/rd_hashd_benchmark_latencies_all_funcs')
def rd_hashd_benchmark_latencies_all_funcs():
    cmd = f"tail -n +1 ./rd-hashd/results/logs-*/*  | grep -a -oE '[0-9]+\.[0-9]+ms|logs-sm-[0-9]+|logs-[0-9]+'"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error        

@app.route('/rd_hashd_benchmark_end')
def rd_hashd_benchmark_end():

    funcs_count = request.args.to_dict()['funcs_count']
    duration = request.args.to_dict()['duration']
    cmd = f"./scripts/rd_hashd_benchmark_end.sh {funcs_count} {duration}"

    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error

@app.route('/rd_hashd_benchmark_hetro_start')
def rd_hashd_benchmark_hetro_start():

    funcs_count = request.args.to_dict()['funcs_count']
    funcs_sm_count = request.args.to_dict()['funcs_sm_count']
    cmd = f"./scripts/rd_hashd_benchmark_hetro_start.sh {funcs_count} {funcs_sm_count}"

    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error

@app.route('/rd_hashd_benchmark_hetro_end')
def rd_hashd_benchmark_hetro_end():

    funcs_count = request.args.to_dict()['funcs_count']
    funcs_sm_count = request.args.to_dict()['funcs_sm_count']
    cmd = f"./scripts/rd_hashd_benchmark_hetro_end.sh {funcs_count} {funcs_sm_count}"

    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error    

@app.route('/rd_hashd_benchmark_singlecgroup_start')
def rd_hashd_benchmark_singlecgroup_start():

    funcs_count = request.args.to_dict()['funcs_count']
    cmd = f"./scripts/rd_hashd_benchmark_10processes_singlecgroup.sh {funcs_count}"

    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error

@app.route('/rd_hashd_benchmark_singlecgroup_end')
def rd_hashd_benchmark_singlecgroup_end():

    funcs_count = request.args.to_dict()['funcs_count']
    cmd = f"./scripts/rd_hashd_benchmark_10processes_singlecgroup_end.sh {funcs_count}"

    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error

@app.route('/function_profile_enabled')
def function_profile_enabled():
    enabled = request.args.to_dict()['enabled']

    cmd = "./ftrace_schedule_overhead.sh"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()

    return output,error

@app.route('/enable_schedstats')
def enable_schedstats():

    enabled = request.args.to_dict()['enabled']
    cmd = f"sudo sysctl kernel.sched_schedstats={enabled}"

    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error    

@app.route('/rd_hashd_benchmark_args_workload')
def rd_hashd_benchmark_args_workload():
    workload = request.args.to_dict()['workload']
    functions = int(request.args.to_dict()['functions'])


    for i in range(functions):
        file = open(f"./rd-hashd/args-{i}.json", 'r', encoding='utf-8')
        # print(file.read())
        lines = file.readlines()
        file.close()        

        if workload == "none":
            trace_path_line = f"//\"trace_path\": \"/local/scratch/rd-hashd/{workload}/trace-{i}\",\n"
        else:
            # copy = file.copy()
            trace_path_line = f"\"trace_path\": \"/local/scratch/rd-hashd/{workload}/trace-{i}\",\n"

    #     print(trace_path_line)
        lines[10] = trace_path_line
    #     copy.insert(10, line)
    #     print(copy)

        f = open(f"./rd-hashd/args/args-{i}.json", "w")
        f.writelines(lines)
        f.close()    

    cmd = f"tail -n +1 ./rd-hashd/args/args* | grep 'trace_path'"
    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output,error

@app.route('/reboot')
def restart():

    cmd = f"sudo reboot"

    process = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    return output, error    

# @app.route('/get_sched_debug')
# def get_sched_debug():

#     for i in range(300):
#         cmd = f"cat /proc/sched_debug > /home/aati2/sched_debug-{i}"
#         print(cmd)
#         p = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True, preexec_fn=os.setsid)
#         time.sleep(1)
#     #    commands.append(p)


app.run(host=args.ip_address, port=args.port, processes=200, threaded=False)
