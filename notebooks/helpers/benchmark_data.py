def process_snapshot(json_files):
    
#     print(json_files)
    
    concurrency_per_func = [json.loads(file)['concurrency'] for file in json_files]
    rps_per_func = [json.loads(file)['rps'] for file in json_files]
    
    nr_workers_per_func = [json.loads(file)['nr_workers'] for file in json_files]
    nr_idle_workers_per_func = [json.loads(file)['nr_idle_workers'] for file in json_files]
    nr_in_flight_per_func = [json.loads(file)['nr_in_flight'] for file in json_files]
    
    nr_done_per_func = [json.loads(file)['nr_done'] for file in json_files]
    lat_p95_per_func = [json.loads(file)['lat']['p95'] for file in json_files]
    lat_p50_per_func = [json.loads(file)['lat']['p50'] for file in json_files]


    print('concurrency_per_func', concurrency_per_func, sum(concurrency_per_func))
    print('rps_per_func', rps_per_func, sum(rps_per_func))
    
    print('nr_workers_per_func', nr_workers_per_func, sum(nr_workers_per_func))
    print('nr_idle_workers_per_func', nr_idle_workers_per_func,sum(nr_idle_workers_per_func))
    print('nr_in_flight_per_func', nr_in_flight_per_func, sum(nr_in_flight_per_func))    
    
    print('nr_done_per_func', nr_done_per_func, sum(nr_done_per_func))
    
    print('lat_p95_per_func', lat_p95_per_func, max(lat_p95_per_func))        
    print('lat_p50_per_func', lat_p50_per_func, max(lat_p50_per_func))     
    
    return [sum(concurrency_per_func),sum(rps_per_func),
            sum(nr_done_per_func),
            max(lat_p95_per_func),
            max(lat_p50_per_func)]

# def hashd_report_snapshot():
    
#     try:
#         single = rd_hashd_benchmark_reports()
#         json.loads(single)
        
#         json_files = [single]
#         print("single json file")
#     except:
  
#         raw_data = [row for row in rd_hashd_benchmark_reports().split("==> /local/scratch/rd-hashd/")[1:]]

#         json_filenames = [row.split(" <==")[0] for row in raw_data ]
#         json_files = [row.split(" <==")[1] for row in raw_data ]

#         print("fetched the following JSON files", len(json_filenames),json_filenames)
#     # print("with the following keys",  json.loads(json_files[0]).keys())
    
#     process_snapshot(json_files)
    
#     return json_files

# latencies_raw = rd_hashd_benchmark_latencies_all_funcs()



# process_latencies(latencies_raw)