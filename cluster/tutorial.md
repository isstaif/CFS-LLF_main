```
aati2@caelum-408:/local/scratch/CFS-LLF_main$ sudo less /sys/kernel/debug/sched/debug | grep cfs_rq  | grep kubepods-burstable-pod7966c3d1_8d77_46ad_b25d_8a91402c55d2.slice
cfs_rq[2]:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7966c3d1_8d77_46ad_b25d_8a91402c55d2.slice/cri-containerd-1a993bf7d2350d5228f937df8ccec82bfd96dd9723ade0d45f8d10241f433d7c.scope
cfs_rq[2]:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7966c3d1_8d77_46ad_b25d_8a91402c55d2.slice
cfs_rq[4]:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7966c3d1_8d77_46ad_b25d_8a91402c55d2.slice/cri-containerd-eff20946fe2bbac1c742562f23c4aa09a7bbf5bcd5249aef9beee5c3fcd25e23.scope
cfs_rq[4]:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7966c3d1_8d77_46ad_b25d_8a91402c55d2.slice
cfs_rq[8]:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7966c3d1_8d77_46ad_b25d_8a91402c55d2.slice/cri-containerd-eff20946fe2bbac1c742562f23c4aa09a7bbf5bcd5249aef9beee5c3fcd25e23.scope
cfs_rq[8]:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7966c3d1_8d77_46ad_b25d_8a91402c55d2.slice
cfs_rq[9]:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7966c3d1_8d77_46ad_b25d_8a91402c55d2.slice/cri-containerd-eff20946fe2bbac1c742562f23c4aa09a7bbf5bcd5249aef9beee5c3fcd25e23.scope
cfs_rq[9]:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7966c3d1_8d77_46ad_b25d_8a91402c55d2.slice
```

```
aati2@caelum-408:/local/scratch/CFS-LLF_main$ sudo less /sys/kernel/debug/sched/debug | grep cfs_rq | wc -l
967
aati2@caelum-408:/local/scratch/CFS-LLF_main$ sudo less /sys/kernel/debug/sched/debug | grep cfs_rq | wc -l
1076
aati2@caelum-408:/local/scratch/CFS-LLF_main$ sudo less /sys/kernel/debug/sched/debug | grep cfs_rq | wc -l
1214
```
