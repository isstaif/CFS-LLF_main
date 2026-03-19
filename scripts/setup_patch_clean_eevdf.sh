sudo sysctl -w vm.drop_caches=3
sudo sysctl kernel.sched_energy_aware=1
sudo sysctl kernel.sched_schedstats=1
echo "-----"

echo '3000000' | sudo tee -a /sys/kernel/debug/sched/base_slice_ns

sudo head /sys/kernel/debug/sched/debug -n 16

sudo sysctl kernel.sched_disable_calc_group_shares=0
sudo sysctl kernel.sched_disable_vruntime_preemption=0
sudo sysctl kernel.sched_disable_entity_eligible=0
echo "-----"

sudo sysctl kernel.sched_entity_before_policy=0
sudo sysctl kernel.sched_check_preempt_wakeup_latency_awareness=0
sudo sysctl kernel.sched_cpu_has_higher_load_task=0
echo "-----"

sudo sysctl kernel.sched_tg_load_avg_ema=0
sudo sysctl kernel.sched_tg_load_avg_ema_window=1000
echo "-----"

echo "setting default shares"
echo "/sys/fs/cgroup/*/cpu.weight"
echo "/sys/fs/cgroup/*/*/cpu.weight"
echo "/sys/fs/cgroup/*/*/*/cpu.weight"
echo "/sys/fs/cgroup/*/*/*/*/cpu.weight"
echo '1024' | sudo tee -a /sys/fs/cgroup/*/cpu.weight
echo '1024' | sudo tee -a /sys/fs/cgroup/*/*/cpu.weight
echo '1024' | sudo tee -a /sys/fs/cgroup/*/*/*/cpu.weight
echo '1024' | sudo tee -a /sys/fs/cgroup/*/*/*/*/cpu.weight
echo "--------"

echo "resetting latency awawreness flags"
echo "/sys/fs/cgroup/*/cpu.latency_awareness"
echo "/sys/fs/cgroup/*/*/cpu.latency_awareness"
echo "/sys/fs/cgroup/*/*/*/cpu.latency_awareness"
echo "/sys/fs/cgroup/*/*/*/*/cpu.latency_awareness"
echo '0' | sudo tee -a /sys/fs/cgroup/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/*/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/*/*/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/*/*/*/*/cpu.latency_awareness

systemd-cgls | grep 'rd-hashd' | tail -n +2 | grep -Eo '[[:digit:]]+ ' > /tmp/pids
while read pid; do sudo chrt -o -a -p 0 $pid; done < /tmp/pids
while read pid; do sudo chrt -o -p $pid; done < /tmp/pids
