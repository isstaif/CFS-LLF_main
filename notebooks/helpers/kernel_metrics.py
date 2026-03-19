import pandas as pd
import requests

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


def enable_schedstats(backend=backend_endpoint,enabled=1):
    params = { "enabled":enabled }
    r = requests.get(f"http://{backend}/enable_schedstats", params=params, headers={})
    print(r.text) 