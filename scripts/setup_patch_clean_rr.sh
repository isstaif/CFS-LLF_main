sudo sysctl -w vm.drop_caches=3
sudo sysctl kernel.sched_energy_aware=1
sudo sysctl kernel.sched_schedstats=1
echo "-----"

echo '24000000' | sudo tee -a /sys/kernel/debug/sched/latency_ns
echo '3000000' | sudo tee -a /sys/kernel/debug/sched/min_granularity_ns
echo '4000000' | sudo tee -a /sys/kernel/debug/sched/wakeup_granularity_ns
echo '750000' | sudo tee -a /sys/kernel/debug/sched/idle_min_granularity_ns

sudo head /sys/kernel/debug/sched/debug -n 16

sudo sysctl kernel.sched_disable_calc_group_shares=0
sudo sysctl kernel.sched_disable_vruntime_preemption=0
# sudo sysctl kernel.sched_slice_static_period=0
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
echo '1024' | sudo tee -a /sys/fs/cgroup/*/cpu.weight
echo '1024' | sudo tee -a /sys/fs/cgroup/*/*/cpu.weight
echo "--------"

echo "resetting latency awawreness flags"
echo "/sys/fs/cgroup/cpu/*/cpu.latency_awareness"
echo "/sys/fs/cgroup/cpu/*/*/cpu.latency_awareness"
echo '0' | sudo tee -a /sys/fs/cgroup/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/*/*/cpu.latency_awareness

FILE="pids"

# Desired number of lines
TARGET_LINES=12

# Loop until the file reaches the target number of lines
while true; do
    if [ -f "$FILE" ]; then
        LINE_COUNT=$(wc -l < "$FILE")
        echo "Current line count: $LINE_COUNT"
        if [ "$LINE_COUNT" -ge "$TARGET_LINES" ]; then
            echo "File has reached or exceeded $TARGET_LINES lines!"
            break
        fi
    else
        echo "File does not exist yet, waiting..."
    fi
    sleep 1
    sudo systemd-cgls | grep 'rd-hashd' | tail -n +2 | grep -Eo '[[:digit:]]+ ' > pids
done
echo "File is no longer empty!"

while read pid; do sudo chrt -r -a -p 99 $pid; done < pids
while read pid; do sudo chrt -o -p $pid; done < pids
cat pids
rm pids
