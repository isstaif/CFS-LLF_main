#scp ~/cfs_patch/setup_patch_clean.sh aati2@caelum-406.cl.cam.ac.uk:/home/aati2

#scp ~/cfs_patch/*.c aati2@caelum-406.cl.cam.ac.uk:/local/scratch/linux/kernel/sched

sudo sysctl kernel.sched_disable_calc_group_shares=1
sudo sysctl kernel.sched_disable_vruntime_preemption=1
# sudo sysctl kernel.sched_slice_static_period=0
echo "-----"

# echo "#sched_entity_before_policy == 0 entity_before(a,b)"
# echo "#sched_entity_before_policy == 1 entity_before_tg_load_avg(a,b)"
# echo "#sched_entity_before_policy == 10 entity_before_tg_load_avg_dynamic(a,b)"
# # echo "#sched_entity_before_policy == 2 entity_before_se_load_avg_least(a,b)"
# # echo "#sched_entity_before_policy == 3 entity_before_static_priority(a,b)"
# # echo "#sched_entity_before_policy == 4 entity_before_relaxed_fairness(a,b)"
# # echo "#sched_entity_before_policy == 40  entity_before_unfair(a,b) //this destroys performance" 
# # echo "#sched_entity_before_policy == 20  entity_before_se_load_avg_most(a,b) //this destroys performance"
sudo sysctl kernel.sched_entity_before_policy=100
sudo sysctl kernel.sched_check_preempt_wakeup_latency_awareness=100
sudo sysctl kernel.sched_cpu_has_higher_load_task=100
echo "-----"

# sudo sysctl kernel.sched_tg_load_avg_sticky=0
# sudo sysctl kernel.sched_epochs_before_next_tg_load_avg_update=1000000000;
# echo "-----"

sudo sysctl kernel.sched_tg_load_avg_ema=1
sudo sysctl kernel.sched_tg_load_avg_ema_window=$1
echo "-----"

echo "setting default shares"
echo "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/*/cpu.idle"
echo '0' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/*/cpu.idle
echo "/sys/fs/cgroup/cpu/*/cpu.shares"
echo "/sys/fs/cgroup/cpu/*/*/cpu.shares"
echo "/sys/fs/cgroup/cpu/*/*/*/cpu.shares"
echo "/sys/fs/cgroup/cpu/*/*/*/*/cpu.shares"
echo "/sys/fs/cgroup/cpu/*/*/*/*/cpu.shares"
echo '1024' | sudo tee -a /sys/fs/cgroup/cpu/*/cpu.shares
echo '1024' | sudo tee -a /sys/fs/cgroup/cpu/*/*/cpu.shares
echo '1024' | sudo tee -a /sys/fs/cgroup/cpu/*/*/*/cpu.shares
echo '1024' | sudo tee -a /sys/fs/cgroup/cpu/*/*/*/*/cpu.shares
echo "--------"

echo "resetting latency awawreness flags"
echo "/sys/fs/cgroup/cpu/cpu.latency_awareness"
echo "/sys/fs/cgroup/cpu/*/cpu.latency_awareness"
echo "/sys/fs/cgroup/cpu/*/*/cpu.latency_awareness"
echo "/sys/fs/cgroup/cpu/*/*/*/cpu.latency_awareness"
echo "/sys/fs/cgroup/cpu/*/*/*/*/cpu.latency_awareness"
echo '0' | sudo tee -a /sys/fs/cgroup/cpu/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/cpu/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/cpu/*/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/cpu/*/*/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/cpu/*/*/*/*/cpu.latency_awareness
echo "-----"

# echo "setting latency awawreness flags"
# echo "/sys/fs/cgroup/cpu/kubepods.slice/cpu.latency_awareness"
# echo "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/cpu.latency_awareness"
echo "/sys/fs/cgroup/cpu/faas.slice/*/cpu.latency_awareness"
# echo "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/*/*/cpu.latency_awareness"
# echo '1' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/cpu.latency_awareness
# echo '1' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/cpu.latency_awareness
echo '1' | sudo tee -a /sys/fs/cgroup/cpu/faas.slice/*/cpu.latency_awareness
# echo '1' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/*/*/cpu.latency_awareness
echo "--------"

