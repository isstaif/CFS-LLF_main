sudo sysctl kernel.sched_disable_calc_group_shares=1
sudo sysctl kernel.sched_disable_vruntime_preemption=1
sudo sysctl kernel.sched_disable_entity_eligible=1
echo "-----"

sudo sysctl kernel.sched_entity_before_policy=1
sudo sysctl kernel.sched_check_preempt_wakeup_latency_awareness=100
sudo sysctl kernel.sched_cpu_has_higher_load_task=100
echo "-----"

sudo sysctl kernel.sched_tg_load_avg_ema=1
sudo sysctl kernel.sched_tg_load_avg_ema_window=$1
echo "-----"

echo "setting default shares"
echo "/sys/fs/cgroup/*/cpu.weight"
echo "/sys/fs/cgroup/*/*/cpu.weight"
echo '1024' | sudo tee -a /sys/fs/cgroup/*/cpu.weight
echo '1024' | sudo tee -a /sys/fs/cgroup/*/*/cpu.weight
echo "--------"

echo "resetting latency awawreness flags"
echo "/sys/fs/cgroup/*/cpu.latency_awareness"
echo "/sys/fs/cgroup/*/*/cpu.latency_awareness"
echo '0' | sudo tee -a /sys/fs/cgroup/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/*/*/cpu.latency_awareness
echo "-----"

echo "setting latency awawreness flags"
echo "/sys/fs/cgroup/faas.slice/*/cpu.latency_awareness"
echo '1' | sudo tee -a /sys/fs/cgroup/faas.slice/*/cpu.latency_awareness
echo "--------"