
# CFS-LLF\_main

CFS-Lightest Load First (CFS-LLF) extends Linux's Completely Fair Scheduler to prioritise lighter-load tasks, reducing CPU contention and resource waste in clusters with many colocated containers.

## Overview

CPU resource units, such as [Kubernetes’ millicores](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) or virtual CPUs (vCPUs), are essential for sharing physical CPU resources among multiple workloads. These abstractions specify the approximate CPU time a task or group of tasks (e.g., containers) will receive within a reference period of 1000 milliseconds. However, when managing a large number of containers (e.g., [50-100 or more](https://dl.acm.org/doi/abs/10.1145/3592533.3592807)), a notable discrepancy can arise between the allocated and actual CPU time due to the overhead introduced by [Linux group scheduling](https://lwn.net/Articles/240474/). One common approach to address this issue is to reserve additional CPU capacity. However, this often leads to significant resource waste, with unused headroom [sometimes reaching as high as 55%](https://dl.acm.org/doi/10.1145/3542929.3563465).

CFS-LLF extends CFS to mitigate the CPU contention that arises when a large number of containers are co-located in a Linux cluster. The design of LLF is inspired by the Shortest Remaining Time First (SRTF) policy but differs by prioritising containers with the lightest load over a reference period, which corresponds to one millicore (i.e., 1 second). CFS-LLF employs a load credit mechanism to prioritise corresponding cgroups based on their recent load, favouring those with lower load credit consumption. This mechanism approximates the LLF policy by scheduling cgroups according to the CPU time they have already received, assuming this reflects their remaining demand. This approach is particularly effective for serverless workloads, which are typically short-lived and have minimal concurrent invocations.

## Resources

* [**Mitigating Context Switching in Densely Packed Linux Clusters with Latency-Aware Group Scheduling** *(arXiv)*](https://arxiv.org/abs/2508.15703)
  The preprint introducing the CFS‑LLF scheduler extension, including the motivating case study and evaluation for serverless function scheduling.

* [**Technical Report**](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-1004.html)
  Full technical report from the University of Cambridge Computer Laboratory based on Amjad's PhD, presenting the complete theoretical and technical details underlying CFS‑LLF.

* [**FOSDEM 2026: Unlocking Extra Cluster Capacity with Enhanced Linux cgroup Scheduling**](https://fosdem.org/2026/schedule/event/F33P7S-unlocking_extra_cluster_capacity_with_enhanced_linux_cgroup_scheduling/)
  A conference talk at FOSDEM 2026 providing a high-level overview of CFS‑LLF and its impact on cluster performance.

* [**Kubernetes Could Use a Different Linux Scheduler** *(CloudNativeNow)*](https://cloudnativenow.com/features/kubernetes-could-use-a-different-linux-scheduler/)
  An article highlighting the FOSDEM 2026 talk and the limitations of the standard Linux scheduler for Kubernetes workloads.
  
## Demo 

The LLF scheduler increases throughput by 26% over CFS and 12% over EEVDF while reducing latency by around sixfold for both median and tail metrics. This improvement is achieved by mitigating CPU overhead in the kernel scheduler, which lowers CPU utilisation from 75–90% under CFS and EEVDF to 40–50% under LLF, more accurately reflecting actual CPU usage. A demonstration further illustrates this effect, showing in real time how CPU utilisation drops significantly when the LLF scheduler is activated.

Further details can be found [here](./cluster/README.md).

![til](./cluster/cluster-demo.gif)

## Repository Structure

This repository contains the following components:

* **linux/**: A custom Linux kernel with CFS-LLF modifications.
* **scripts/**: Scripts used to run experiments.
* **resctl-demo/**: A fork of Meta's `resctl-demo` benchmarking framework.
* **rd-hashd/**: Files necessary to run the forked `resctl-demo`.

## Setup

Clone the repository along with its submodules:

```bash
git clone --recurse-submodules git@github.com:isstaif/CFS-LLF_main.git
```

**Install Dependencies**

Update package lists and install the required development tools and libraries:

```bash
sudo apt update
sudo apt install -y git build-essential libncurses5-dev bison flex libssl-dev libelf-dev gcc make git gawk
```

**Compile the Kernel**

Navigate to the kernel source directory and prepare kernel configurations based on the currently running kernel. Unless this is your first time building the kernel, make sure you start from a clean build directory.

```bash
cd linux
git checkout CFS-LLF
sudo make mrproper
sudo make clean
```

You are now ready to configure and build the kernel with CFS-LLF. You may need to disable Ubuntu certificate-related configuration before building the kernel.
```bash
cp /boot/config-$(uname -r) .config
sudo ./scripts/config --disable CONFIG_MODULE_SIG_KEY
sudo ./scripts/config --disable CONFIG_SYSTEM_TRUSTED_KEYS
sudo ./scripts/config --disable CONFIG_SYSTEM_REVOCATION_KEYS
sudo make olddefconfig
```

Begin the build process:
```bash
sudo make -j$(nproc) 2> make_stderr.txt
sudo make modules_install 2> make_stderr.txt
sudo make install
sudo update-initramfs -c -k 5.18.0+
sudo update-grub 
sudo reboot
```
Since the kernel build process is parallel, it may continue even when an error occurs. You can detect such errors by monitoring the error output file separately:
```bash
tail -f make_stderr.txt
```

This process can be repeated for each of the following kernel branches:
- CFS-LLF (based on v5.18)
- v5.18 (baseline for CFS-LLF)
- CFS-LLF-ported (based on v6.12)
- v.6.12 (baseline for CFS-LLF-ported)


## Quick Start

Follow these steps to install and run the benchmark setup:

**1. Install the Service and Binary**

Update the working directory in `rd-hashd/func@.service` as required, then install the systemd service and benchmark binary:

```bash
sudo cp rd-hashd/func@.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo cp rd-hashd/rd-hashd /usr/local/bin/
```

**2. Run the Benchmark (Initial Setup)**

Run the benchmark manually once to download the hash data for the original `resctl-demo`. This may take a few minutes:

```bash
cd rd-hashd
/usr/local/bin/rd-hashd --args args/args-0.json
```

**3. Install Notebook Dependencies**

Install Python and the required Python packages:

```bash
sudo apt-get install python3 python3-pip
sudo pip3 install flask jupyter pandas numpy matplotlib
```

However, using a Python virtual environment is preferable:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install python3 python3-pip python3-venv -y
```

```bash
python3 -m venv jupyter_env
source jupyter_env/bin/activate
```

```bash
cd jupyter_env
pip install jupyter pandas numpy matplotlib
```

**4. Remote Setup** 

You can set up the experiment scripts remotely using ssh and tmux:

```bash
ssh aati2@helios.cl.cam.ac.uk "tmux new-session -d -c /home/aati2/CFS-LLF_main/ 'sudo python3 scripts/backend.py --ip_address 127.0.0.1'"
ssh aati2@helios.cl.cam.ac.uk "tmux new-session -d -c /home/aati2/CFS-LLF_main/notebooks/ 'jupyter notebook'"
```

Alternatively, run as systemd services:
```bash
sudo cp scripts/*.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl start backend
sudo systemctl start jupyter
```

Check that the services are running:
```bash
sudo systemctl status backend
sudo systemctl status jupyter
```

After confirming that Jupyter is running, you can access it via your browser at `localhost:8888/tree?token=TOKEN` by setting up an SSH tunnel:
```bash
ssh -N -L 8888:localhost:8888 aati2@helios.cl.cam.ac.uk &
```




## Publications

Al Amjad Tawfiq Isstaif and Richard Mortier. 2023. **Towards Latency-Aware Linux Scheduling for Serverless Workloads**. In Proceedings of the 1st Workshop on SErverless Systems, Applications and MEthodologies (SESAME '23). Association for Computing Machinery, New York, NY, USA, 19–26. https://doi.org/10.1145/3592533.3592807

## Copywrite

CFS-LLF extension by Al Amjad Tawfiq Isstaif

Copyright (C) 2023 Al Amjad Tawfiq Isstaif <alamjad.isstaif@cl.cam.ac.uk>
