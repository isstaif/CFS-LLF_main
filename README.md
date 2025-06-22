
# CFS-LLF\_main

CFS-Lightest Load First (CFS-LLF) extends Linux's Completely Fair Scheduler to prioritise lighter-load tasks, reducing CPU contention and resource waste in clusters with many colocated containers.

## Overview

CPU resource units, such as [Kubernetes’ millicores](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) or virtual CPUs (vCPUs), are essential for sharing physical CPU resources among multiple workloads. These abstractions specify the approximate CPU time a task or group of tasks (e.g., containers) will receive within a reference period of 1000 milliseconds. However, when managing a large number of containers (e.g., [50-100 or more](https://dl.acm.org/doi/abs/10.1145/3592533.3592807)), a notable discrepancy can arise between the allocated and actual CPU time due to the overhead introduced by [Linux group scheduling](https://lwn.net/Articles/240474/). One common approach to address this issue is to reserve additional CPU capacity. However, this often leads to significant resource waste, with unused headroom [sometimes reaching as high as 55%](https://dl.acm.org/doi/10.1145/3542929.3563465).

CFS-LLF extends CFS to mitigate the CPU contention that arises when a large number of containers are co-located in a Linux cluster. The design of LLF is inspired by the Shortest Remaining Time First (SRTF) policy but differs by prioritising containers with the lightest load over a reference period, which corresponds to one millicore (i.e., 1 second). CFS-LLF employs a load credit mechanism to prioritise corresponding cgroups based on their recent load, favouring those with lower load credit consumption. This mechanism approximates the LLF policy by scheduling cgroups according to the CPU time they have already received, assuming this reflects their remaining demand. This approach is particularly effective for serverless workloads, which are typically short-lived and have minimal concurrent invocations.

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


## Publications

Al Amjad Tawfiq Isstaif and Richard Mortier. 2023. **Towards Latency-Aware Linux Scheduling for Serverless Workloads**. In Proceedings of the 1st Workshop on SErverless Systems, Applications and MEthodologies (SESAME '23). Association for Computing Machinery, New York, NY, USA, 19–26. https://doi.org/10.1145/3592533.3592807

## Copywrite

CFS-LLF extension by Al Amjad Tawfiq Isstaif

Copyright (C) 2023 Al Amjad Tawfiq Isstaif <alamjad.isstaif@cl.cam.ac.uk>
