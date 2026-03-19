import requests
import time

import kernel_metrics

backend_endpoint ="127.0.0.1:5000"

import pandas as pd
import requests

import re

backend_endpoint ="127.0.0.1:5000"


# domain<N> <name> <cpumask> 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45

def schedstat_domains_snapshot():
    
    df = pd.DataFrame()
    
    backend=backend_endpoint
    r = requests.get(f"http://{backend}/schedstat_domains", params={}, headers={})
    schedstat_data = r.text    

    cpu = 0
    for line in schedstat_data.split('\n'):
        if len(line) > 0: 
#             print(line)
            cpu_entry = line.split(" ")
#             print([(a,b) for a,b in enumerate(cpu_entry)][:2])
#             print(cpu_entry[2:])
        
#             print([(a,b) for a,b in enumerate(cpu_entry)][2:])
#             print(cpu_entry[1],cpu_entry[4+1], cpu_entry[12+1], cpu_entry[20+1])
            entry = {
#                 "id": cpu_entry[1],
                "imbalances": int(cpu_entry[4+1]) + int(cpu_entry[12+1]) + int(cpu_entry[20+1]),
                
                "imbalance_idle":int(cpu_entry[4+1]),
                "pull_task_idle": int(cpu_entry[5+1]),
#                 "pull_task_idle_hotcache": int(cpu_entry[5+2]),
                
                "imbalance_busy": int(cpu_entry[12+1]),
                "pull_task_busy": int(cpu_entry[13+1]),
#                 "pull_task_busy_hotcache": int(cpu_entry[13+2]),
                
                "imbalance_newly_idle": int(cpu_entry[20+1]),
                "pull_task_newly_idle": int(cpu_entry[21+1]),
#                 "pull_task_newly_idle_hotcache": int(cpu_entry[21+1]),
                "active_load_balance": cpu_entry[27+1],
                "passive_load_balance": cpu_entry[36+1],
#                 "try_to_wake_up": cpu_entry[5],
#                 "try_to_wake_up local": cpu_entry[6],
#                 "tasks_running": cpu_entry[7],
#                 "tasks_waiting": cpu_entry[8],
#                 "timeslices": cpu_entry[9]
            }
            
            df[cpu] = cpu_entry[2:]
            cpu = cpu+1
                
#             for entry in range(1,9+1):
#                 value = cpu_entry[entry] # 3 of times schedule() was called
#     #             print("schedule()", value) 
#                 df[entry] = df[entry] + int(value)
            
    return df


def nr_switches_snapshot():
    df = pd.DataFrame()

    r = requests.get(f"http://{backend_endpoint}/nr_switches", params={}, headers={})
    nr_switches_data = r.text    
    
    data = []
    for line in nr_switches_data.split("\n"):
        if len(line) > 0: 
            data.append(int(line.split(":")[1]))
            
            
    df['nr_switches'] = data
            
            
    return df


# First field is a sched_yield() statistic:

# 0 of times sched_yield() was called

# Next three are schedule() statistics:

# 1 This field is a legacy array expiration count field used in the O(1) scheduler. We kept it for ABI compatibility, but it is always set to zero.

# 2 # of times schedule() was called

# 3 # of times schedule() left the processor idle

# Next two are try_to_wake_up() statistics:

# # 4 of times try_to_wake_up() was called

# # 5 of times try_to_wake_up() was called to wake up the local cpu

# Next three are statistics describing scheduling latency:

# 6 sum of all time spent running by tasks on this processor (in nanoseconds)

# 7 sum of all time spent waiting to run by tasks on this processor (in nanoseconds)

# 8 # of timeslices run on this cpu

def schedstat_snapshot():
    
    df = pd.DataFrame()
    
    r = requests.get(f"http://{backend_endpoint}/schedstat", params={}, headers={})
    schedstat_data = r.text    

    for line in schedstat_data.split('\n'):
        if len(line) > 0: 
            cpu_entry = line.split(" ")
#             print(len(cpu_entry), cpu_entry)
            entry = {
                "yield": cpu_entry[1],
                "schedule": cpu_entry[3],
                "idle": cpu_entry[4],
                "try_to_wake_up": cpu_entry[5],
                "try_to_wake_up local": cpu_entry[6],
                "tasks_running": cpu_entry[7],
                "tasks_waiting": cpu_entry[8],
                "timeslices": cpu_entry[9]
            }
            
            # df = df.append(entry,ignore_index=True)
            new_row_df = pd.DataFrame([entry])
            df = pd.concat([df, new_row_df], ignore_index=True)
            
            
                
#             for entry in range(1,9+1):
#                 value = cpu_entry[entry] # 3 of times schedule() was called
#     #             print("schedule()", value) 
#                 df[entry] = df[entry] + int(value)
            
    return df

def process_latencies(latencies_raw):
    
    logs_per_func = [s for s in latencies_raw.split("\n") if re.match(r'logs-\d+|logs-sm-\d+',s)]
    latencies_per_func_raw = re.split(r'logs-\d+|logs-sm-\d+', latencies_raw)[1:]

    # the number of log file names should be equal to the actual number of files
    assert (len(logs_per_func) == len(latencies_per_func_raw))
    
    if (len(logs_per_func) == 0):
        logs_per_func = [s for s in [latencies_raw.split("\n")]]
        latencies_per_func_raw = [latencies_raw]  
    

    per_func_latencies_raw = [group.split("\n")[1:-1] for group in latencies_per_func_raw]
    
    
    def extract_latencies(group):
        return [float(r.strip("ms")) for r in group]

    data = [extract_latencies(group) for group in per_func_latencies_raw]
        
    if (len(logs_per_func) == 1):
        df = pd.DataFrame(data[0],columns=["logs-0"])
        df.hist(cumulative=True, density=1, bins=1000,histtype='step',figsize=(3,2))
        plt.show()
        
    else:

        df = pd.DataFrame(data).transpose()

        df.columns = logs_per_func
#         axs = df.hist(cumulative=True, density=1, bins=1000,histtype='step',figsize=(15,10))

#         plt.tight_layout()
#         for row in axs:
#             for ax in row:
#                 ax.set_xlim(0,1500)

#         plt.show()
#         pd.Series(df.to_numpy().flatten()).hist(cumulative=True, density=0, bins=1000,histtype='step',figsize=(4,2))
#         plt.show()
    return df


def enable_schedstats(backend=backend_endpoint,enabled=1):
    params = { "enabled":enabled }
    r = requests.get(f"http://{backend}/enable_schedstats", params=params, headers={})
    print(r.text) 


def reset_shares_cfs(backend=backend_endpoint):
    params = { 'script': 'setup_patch_clean_cfs.sh', "ema":"1000" }
    r = requests.get(f"http://{backend}/setup_patch", params=params, headers={})
    print(r.text)    

def reset_shares_llf(backend=backend_endpoint, ema=1000):
    params = { 'script': 'setup_patch_clean_systemd.sh', "ema":ema }
    r = requests.get(f"http://{backend}/setup_patch", params=params, headers={})
    print(r.text)       
    
def reset_shares_llf_static(backend=backend_endpoint):
    params = { 'script': 'setup_patch_clean_withrr_systemd.sh', "ema":1000 }
    r = requests.get(f"http://{backend}/setup_patch", params=params, headers={})
    print(r.text)        
    
def rd_hashd_benchmark_start(backend=backend_endpoint, func_count=0,duration=100,llf=False, ftrace_enabled=False):
    params = { "funcs_count": func_count, "duration":duration, "llf": llf, "ema":1000  }
    r = requests.get(f"http://{backend}/rd_hashd_benchmark_start", params=params, headers={})
    print(r.text)  
    
def rd_hashd_benchmark_reports(backend=backend_endpoint):
    r = requests.get(f"http://{backend}/rd_hashd_benchmark_reports", params={}, headers={})
    return r.text      

def rd_hashd_benchmark_killall(backend=backend_endpoint):
    r = requests.get(f"http://{backend}/rd_hashd_benchmark_killall", params={}, headers={})
    return r.text     

def rd_hashd_benchmark_latencies_all_funcs(backend=backend_endpoint):
    r = requests.get(f"http://{backend}/rd_hashd_benchmark_latencies_all_funcs", params={}, headers={})
    return r.text   
    
def rd_hashd_benchmark_end(backend=backend_endpoint, func_count=0,duration=100):
    params = { "funcs_count": func_count, "duration":duration }
    r = requests.get(f"http://{backend}/rd_hashd_benchmark_end", params=params, headers={})
    print(r.text)       

def rd_hashd_benchmark_end(backend=backend_endpoint, func_count=0,duration=100):
    params = { "funcs_count": func_count, "duration":duration }
    r = requests.get(f"http://{backend}/rd_hashd_benchmark_end", params=params, headers={})
    print(r.text)           

def rd_hashd_benchmark_hetro_start(backend=backend_endpoint, func_count=0,func_sm_count=0):
    params = { "funcs_count": func_count, "funcs_sm_count": func_sm_count, }
    r = requests.get(f"http://{backend}/rd_hashd_benchmark_hetro_start", params=params, headers={})
    print(r.text)  
    
def rd_hashd_benchmark_hetro_end(backend=backend_endpoint, func_count=0,func_sm_count=0):
    params = { "funcs_count": func_count, "funcs_sm_count": func_sm_count, }
    r = requests.get(f"http://{backend}/rd_hashd_benchmark_hetro_end", params=params, headers={})
    print(r.text)       

def run_host_script(backend=backend_endpoint,script='setup_patch_clean_systemd.sh'):
    params = { 'script': script, "ema":"1000" }
    r = requests.get(f"http://{backend}/setup_patch", params=params, headers={})
    print(r.text)    


def rd_hashd_benchmark_args_workload(backend=backend_endpoint,workload='none',functions=3000):
    params = { 'workload': workload, "functions":functions }
    r = requests.get(f"http://{backend}/rd_hashd_benchmark_args_workload", params=params, headers={})
    print(r.text.split('\n')[-10:])   
    
def rd_hashd_experiment(func_count = 20,
                        llf=False, 
                        llf_static=False,
                        script ='setup_patch_clean_cfs.sh',
                        ema=1000,
                        duration=150,
                        workload='none',
                        schedstats_enabled=False, 
                        ftrace_enabled=False):

    #machine reset
    reset_shares_cfs()
    a = int(func_count)
    print(a, "functions")
    
    rd_hashd_benchmark_args_workload(workload=workload,functions=360)  
    
    #benchmark kickoff
    rd_hashd_benchmark_start(func_count=(a-1),llf=llf, ftrace_enabled=ftrace_enabled)
#     if (llf): reset_shares_llf(ema=ema)
#     if (llf_static): reset_shares_llf_static()
    # time.sleep(10)    
    print(f"running script {script}")
    run_host_script(script=script)
        
    #instrumentation begins here
    ts_start = time.time()    
    if ftrace_enabled:
#         function_profile_enabled(enabled=0)    
        function_profile_enabled(enabled=1)
        cat_trace_stat()
    if schedstats_enabled:
        enable_schedstats(enabled=1)
    schedstat_start = schedstat_snapshot()
    schedstat_domains_start = schedstat_domains_snapshot()
    nr_switches_start = nr_switches_snapshot()

    #experiment timer        
    interval=10
    snapshots = []
    for i in range(0,duration,interval):
        print("tick",i)
#         snapshots.append(hashd_report_snapshot())
        time.sleep(interval)
    snapshots_hetro = snapshots

    #instrumentation end    
    ts_end = time.time()    
    schedstat_end = schedstat_snapshot()
    schedstat_domains_end = schedstat_domains_snapshot()
    nr_switches_end = nr_switches_snapshot()
    if ftrace_enabled:
        ftrace_data_raw = cat_trace_stat()
    
    #benchmark killed
    rd_hashd_benchmark_killall()
    rd_hashd_benchmark_end(func_count=(a-1))
    
    #machine reset
    reset_shares_cfs()    
    
    #display results
    print('duration', ts_end-ts_start, 'seconds')
    schedstat_hetro = (schedstat_end.astype(int) - schedstat_start.astype(int)).sum()
    # scheddomain_hetro = (schedstat_domains_end.astype(int) - schedstat_domains_start.astype(int)).sum(axis=1)
    scheddomain_hetro = None
    display((nr_switches_end - nr_switches_start).sum())

    display(schedstat_hetro)
    # display(scheddomain_hetro) 
    if ftrace_enabled:
        ftrace_data = process_ftrace_data(ftrace_data_raw)
    else: ftrace_data = None

    latencies_raw = rd_hashd_benchmark_latencies_all_funcs()
    df = process_latencies(latencies_raw)

    return (df,
        schedstat_hetro,
        scheddomain_hetro, 
        ftrace_data,
        ts_end-ts_start)