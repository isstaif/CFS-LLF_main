#scp ~/cfs_patch/setup_patch_clean.sh aati2@caelum-406.cl.cam.ac.uk:/home/aati2

#scp ~/cfs_patch/*.c aati2@caelum-406.cl.cam.ac.uk:/local/scratch/linux/kernel/sched

sudo sysctl -w vm.drop_caches=3
sudo sysctl kernel.sched_energy_aware=1
sudo sysctl kernel.sched_schedstats=1
echo "-----"

sudo sysctl kernel.sched_disable_calc_group_shares=0
sudo sysctl kernel.sched_disable_vruntime_preemption=0
# sudo sysctl kernel.sched_slice_static_period=0
echo "-----"

# echo "#sched_entity_before_policy == 0 entity_before(a,b)"
# echo "#sched_entity_before_policy == 1 entity_before_tg_load_avg(a,b)"
# echo "#sched_entity_before_policy == 10 entity_before_tg_load_avg_dynamic(a,b)"
# echo "#sched_entity_before_policy == 2 entity_before_se_load_avg_least(a,b)"
# echo "#sched_entity_before_policy == 3 entity_before_static_priority(a,b)"
# echo "#sched_entity_before_policy == 4 entity_before_relaxed_fairness(a,b)"
# echo "#sched_entity_before_policy == 40  entity_before_unfair(a,b) //this destroys performance" 
# echo "#sched_entity_before_policy == 20  entity_before_se_load_avg_most(a,b) //this destroys performance"
sudo sysctl kernel.sched_entity_before_policy=0
sudo sysctl kernel.sched_check_preempt_wakeup_latency_awareness=0
sudo sysctl kernel.sched_cpu_has_higher_load_task=0
echo "-----"

# sudo sysctl kernel.sched_tg_load_avg_sticky=0
# sudo sysctl kernel.sched_epochs_before_next_tg_load_avg_update=1000000000;
# echo "-----"

sudo sysctl kernel.sched_tg_load_avg_ema=0
sudo sysctl kernel.sched_tg_load_avg_ema_window=1000
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
#echo '0' | sudo tee -a /sys/fs/cgroup/cpu/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/*/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/*/*/*/cpu.latency_awareness
echo '0' | sudo tee -a /sys/fs/cgroup/*/*/*/*/cpu.latency_awareness


# sudo sysctl kernel.sched_cfs_rq_is_idle_if_no_latency_awareness=1
echo "-----"

# echo "setting latency awawreness flags"
#echo "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/*/cpu.latency_awareness"
#echo '1' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/*/cpu.latency_awareness
#echo "--------"

# echo "pytorch-classifier-1-cfspatched-00001-deployment-75d9676f5dg66s"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pode54b1867_f8f6_41cd_97d7_7dd9eb04dfe5.slice/cpu.latency_awareness

# echo "pytorch-classifier-11-cfspatched-00001-deployment-5ff84d7czbxqj"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod9a627dab_5bfc_42c2_9419_b9f71f69397e.slice/cpu.latency_awareness

# echo "pytorch-classifier-21-cfspatched-00001-deployment-b757bc99vn9qm"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf978ca1d_9607_4f51_a933_b00d590643ca.slice/cpu.latency_awareness

# echo "pytorch-classifier-31-cfspatched-00001-deployment-b49564b84f78p"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7e6110d0_e7b6_4d40_b9f6_99739c462157.slice/cpu.latency_awareness

# echo "pytorch-classifier-41-cfspatched-00001-deployment-676c77cbpg27q"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod37bf25e8_d433_4060_8c00_80c6963f7086.slice/cpu.latency_awareness

# echo "pytorch-classifier-51-cfspatched-00001-deployment-5fd9978bz58l7"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podd1dd4f2d_2aed_434e_8e14_6ead74a986e6.slice/cpu.latency_awareness

# echo "pytorch-classifier-61-cfspatched-00001-deployment-797b4d4fgj4r7"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod8c1abeb5_1c7c_45c9_817b_a9fbd2c6e068.slice/cpu.latency_awareness

# echo "pytorch-classifier-71-cfspatched-00001-deployment-845fcff44rqkt"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod58501376_72ed_4ad2_a675_7970e63c9f4f.slice/cpu.latency_awareness

# echo "pytorch-classifier-81-cfspatched-00001-deployment-6f8bfff72hm24"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podb12419a5_e920_4502_a4c0_0933ba938e51.slice/cpu.latency_awareness

# echo "pytorch-classifier-91-cfspatched-00001-deployment-7b46d9ff5bmlj"
# echo "100" | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pode9631ce0_b6e7_4c0d_9922_cf47aa5a62b2.slice/cpu.latency_awareness

# echo "pytorch-classifier-1-cfspatched-00001-deployment-75d9676f5tr9xf"
# echo '100' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2989b7a6_3bfa_45b7_825a_bea4005c7085.slice/cpu.latency_awareness
# echo '100' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2989b7a6_3bfa_45b7_825a_bea4005c7085.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-2-cfspatched-00001-deployment-86b74c88cmbp8v"
# echo '90' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pode3b1cc07_2e9d_4d04_9928_cfc435c85783.slice/cpu.latency_awareness
# echo '90' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pode3b1cc07_2e9d_4d04_9928_cfc435c85783.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-3-cfspatched-00001-deployment-f7fb47776m64pm"
# echo '80' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod98c0dc91_670d_49e7_9f2d_45102aff9a68.slice/cpu.latency_awareness
# echo '80' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod98c0dc91_670d_49e7_9f2d_45102aff9a68.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-4-cfspatched-00001-deployment-56d4bd7cbfmlbb"
# echo '70' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod9cf21229_6552_479b_b210_1686e20648e7.slice/cpu.latency_awareness
# echo '70' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod9cf21229_6552_479b_b210_1686e20648e7.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-5-cfspatched-00001-deployment-6bb45d5c6w7256"
# echo '60' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podd6cb85ee_d754_45a2_8ea2_bdbaec55b631.slice/cpu.latency_awareness
# echo '60' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podd6cb85ee_d754_45a2_8ea2_bdbaec55b631.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-6-cfspatched-00001-deployment-5dcd74f98qp8dn"
# echo '50' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda537ce0f_c3ad_4ca4_b446_e2d9e4c48bae.slice/cpu.latency_awareness
# echo '50' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda537ce0f_c3ad_4ca4_b446_e2d9e4c48bae.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-7-cfspatched-00001-deployment-6b6cd4b8fjjfh2"
# echo '40' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod274f64d0_3b6f_47e0_a0ac_c4c314a958e0.slice/cpu.latency_awareness
# echo '40' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod274f64d0_3b6f_47e0_a0ac_c4c314a958e0.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-8-cfspatched-00001-deployment-6859888d9clhzt"
# echo '30' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod26c88d0b_ffa9_48be_9583_83ac6173c900.slice/cpu.latency_awareness
# echo '30' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod26c88d0b_ffa9_48be_9583_83ac6173c900.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-9-cfspatched-00001-deployment-77df9c4d4w5x4w"
# echo '20' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7e194f2d_0009_49cb_8a73_096755995d98.slice/cpu.latency_awareness
# echo '20' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7e194f2d_0009_49cb_8a73_096755995d98.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-10-cfspatched-00001-deployment-7cd8c78cg6msl"
# echo '10' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod39367895_2995_4bf0_b7c1_0896a5650d14.slice/cpu.latency_awareness
# echo '10' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod39367895_2995_4bf0_b7c1_0896a5650d14.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-11-cfspatched-00001-deployment-5ff84d7cx7tzx"
# echo '99' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podfd1c693d_d9c2_4351_a2ca_430c0bd43fd7.slice/cpu.latency_awareness
# echo '99' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podfd1c693d_d9c2_4351_a2ca_430c0bd43fd7.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-12-cfspatched-00001-deployment-6ffd6454jdl96"
# echo '89' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6853db3d_957d_4b8c_8307_18227423e5b0.slice/cpu.latency_awareness
# echo '89' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6853db3d_957d_4b8c_8307_18227423e5b0.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-13-cfspatched-00001-deployment-664b8dc4wgchc"
# echo '79' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podef3d85c6_a94b_45ac_8df7_b4604e061ce2.slice/cpu.latency_awareness
# echo '79' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podef3d85c6_a94b_45ac_8df7_b4604e061ce2.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-14-cfspatched-00001-deployment-b56c9bd546bj5"
# echo '69' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2841188e_9cc4_47ee_9aaa_93a5d1df1c43.slice/cpu.latency_awareness
# echo '69' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2841188e_9cc4_47ee_9aaa_93a5d1df1c43.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-15-cfspatched-00001-deployment-74c95c95nwdmq"
# echo '59' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podacc3ec4d_e4fe_4a1b_852f_1ae293866543.slice/cpu.latency_awareness
# echo '59' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podacc3ec4d_e4fe_4a1b_852f_1ae293866543.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-16-cfspatched-00001-deployment-dd4fbd952672s"
# echo '49' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda94a6464_a395_46de_b7a8_44b01f47aa92.slice/cpu.latency_awareness
# echo '49' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda94a6464_a395_46de_b7a8_44b01f47aa92.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-17-cfspatched-00001-deployment-6f49c55b957gg"
# echo '39' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod3bcae7b1_2a3a_4387_b20c_3f1c4e994e03.slice/cpu.latency_awareness
# echo '39' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod3bcae7b1_2a3a_4387_b20c_3f1c4e994e03.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-18-cfspatched-00001-deployment-8558b679wzmh7"
# echo '29' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf093353f_87ec_4f02_be98_dffe1e5e17cc.slice/cpu.latency_awareness
# echo '29' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf093353f_87ec_4f02_be98_dffe1e5e17cc.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-19-cfspatched-00001-deployment-5897777557tjq"
# echo '19' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6b212288_dfc6_4478_8c50_04a745691805.slice/cpu.latency_awareness
# echo '19' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6b212288_dfc6_4478_8c50_04a745691805.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-20-cfspatched-00001-deployment-6d877db8qwrc9"
# echo '9' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7dd1991e_174b_4c23_a0a0_6eb4a29947f4.slice/cpu.latency_awareness
# echo '9' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7dd1991e_174b_4c23_a0a0_6eb4a29947f4.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-21-cfspatched-00001-deployment-b757bc99zxpl2"
# echo '98' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2c14200f_bfdd_454b_86d8_df9e386f56ab.slice/cpu.latency_awareness
# echo '98' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2c14200f_bfdd_454b_86d8_df9e386f56ab.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-22-cfspatched-00001-deployment-59ff5f78f4vdz"
# echo '88' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod35f7df33_c273_4ab8_99b8_fed9469c25bf.slice/cpu.latency_awareness
# echo '88' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod35f7df33_c273_4ab8_99b8_fed9469c25bf.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-23-cfspatched-00001-deployment-76f84475nk5ns"
# echo '78' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podfab142dd_896e_420f_8f50_1e0a3b650cbe.slice/cpu.latency_awareness
# echo '78' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podfab142dd_896e_420f_8f50_1e0a3b650cbe.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-24-cfspatched-00001-deployment-864b566dmbjz6"
# echo '68' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6f71832e_e1b9_491b_b264_c65364bd48ff.slice/cpu.latency_awareness
# echo '68' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6f71832e_e1b9_491b_b264_c65364bd48ff.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-25-cfspatched-00001-deployment-5f957bfdrcmtq"
# echo '58' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod56052e91_dc88_4964_9c23_f7c541749c8a.slice/cpu.latency_awareness
# echo '58' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod56052e91_dc88_4964_9c23_f7c541749c8a.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-26-cfspatched-00001-deployment-8c4d8765jsjlz"
# echo '48' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod36e8bea2_8337_404f_8fc4_d5dc247108f8.slice/cpu.latency_awareness
# echo '48' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod36e8bea2_8337_404f_8fc4_d5dc247108f8.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-27-cfspatched-00001-deployment-8bb8d6d8h5xlk"
# echo '38' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod4b68824d_d089_48fa_9b89_225e8432d0a2.slice/cpu.latency_awareness
# echo '38' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod4b68824d_d089_48fa_9b89_225e8432d0a2.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-28-cfspatched-00001-deployment-8794dbf8bkr28"
# echo '28' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod93d3aef5_8b76_4f86_a094_490ebdce1c6a.slice/cpu.latency_awareness
# echo '28' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod93d3aef5_8b76_4f86_a094_490ebdce1c6a.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-29-cfspatched-00001-deployment-6c5cd78br5m29"
# echo '18' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda02af8b9_20ae_4d73_861d_63ec2994525a.slice/cpu.latency_awareness
# echo '18' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda02af8b9_20ae_4d73_861d_63ec2994525a.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-30-cfspatched-00001-deployment-856dc5d7gfbc7"
# echo '8' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod17790efc_951a_40ab_b84f_d2ee5777b011.slice/cpu.latency_awareness
# echo '8' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod17790efc_951a_40ab_b84f_d2ee5777b011.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-31-cfspatched-00001-deployment-b49564b8mnxjn"
# echo '97' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod533d1e5d_6a93_4f7e_b900_6a121929b2ae.slice/cpu.latency_awareness
# echo '97' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod533d1e5d_6a93_4f7e_b900_6a121929b2ae.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-32-cfspatched-00001-deployment-56876465gblx7"
# echo '87' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod689620f9_33e7_44b8_b6e0_2a76095b7b81.slice/cpu.latency_awareness
# echo '87' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod689620f9_33e7_44b8_b6e0_2a76095b7b81.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-33-cfspatched-00001-deployment-7ddf856ftpqgs"
# echo '77' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod31d22e9c_c503_4c84_a9f8_186efbae32f8.slice/cpu.latency_awareness
# echo '77' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod31d22e9c_c503_4c84_a9f8_186efbae32f8.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-34-cfspatched-00001-deployment-6f978ff4cdxgk"
# echo '67' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod1016819d_8501_4cd9_897d_abf01b2b08f2.slice/cpu.latency_awareness
# echo '67' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod1016819d_8501_4cd9_897d_abf01b2b08f2.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-35-cfspatched-00001-deployment-76b5cdfbq8bgj"
# echo '57' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod9e8f732e_3cd3_4889_b927_fdc8fa609f76.slice/cpu.latency_awareness
# echo '57' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod9e8f732e_3cd3_4889_b927_fdc8fa609f76.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-36-cfspatched-00001-deployment-767858fczmc45"
# echo '47' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod797cc6c1_a9fa_4e7b_8b8a_58072b94559f.slice/cpu.latency_awareness
# echo '47' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod797cc6c1_a9fa_4e7b_8b8a_58072b94559f.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-37-cfspatched-00001-deployment-5ff965876c6mb"
# echo '37' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod08ed6f6c_4466_483c_a525_97d4d1a4ffd1.slice/cpu.latency_awareness
# echo '37' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod08ed6f6c_4466_483c_a525_97d4d1a4ffd1.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-38-cfspatched-00001-deployment-7f4f84659wzrk"
# echo '27' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod5c9565be_5bc4_4512_b003_3e825f18d7f9.slice/cpu.latency_awareness
# echo '27' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod5c9565be_5bc4_4512_b003_3e825f18d7f9.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-39-cfspatched-00001-deployment-779648b42zxfg"
# echo '17' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod34a093c9_f25f_499a_8093_be00401b8026.slice/cpu.latency_awareness
# echo '17' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod34a093c9_f25f_499a_8093_be00401b8026.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-40-cfspatched-00001-deployment-77c4c5bbdc9dl"
# echo '7' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0b155d3a_be02_42bd_8c8f_4d20e3eff61b.slice/cpu.latency_awareness
# echo '7' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0b155d3a_be02_42bd_8c8f_4d20e3eff61b.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-41-cfspatched-00001-deployment-676c77cbrvl7d"
# echo '96' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podaf2a3c2b_fe8a_493e_9ac7_7833ebfb7f5a.slice/cpu.latency_awareness
# echo '96' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podaf2a3c2b_fe8a_493e_9ac7_7833ebfb7f5a.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-42-cfspatched-00001-deployment-5c6c589b6nddp"
# echo '86' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod27fcbace_1789_4996_b899_88ec4a81b215.slice/cpu.latency_awareness
# echo '86' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod27fcbace_1789_4996_b899_88ec4a81b215.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-43-cfspatched-00001-deployment-58f484694sq2f"
# echo '76' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod952b46a0_e1be_4066_bb87_b6feb0f1d863.slice/cpu.latency_awareness
# echo '76' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod952b46a0_e1be_4066_bb87_b6feb0f1d863.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-44-cfspatched-00001-deployment-6c488656tnvqf"
# echo '66' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2632bfeb_b46b_41a6_9e37_c8fc4e6f7505.slice/cpu.latency_awareness
# echo '66' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2632bfeb_b46b_41a6_9e37_c8fc4e6f7505.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-45-cfspatched-00001-deployment-cfbc96bf4bmqw"
# echo '56' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf8b7a6c8_af97_4ba7_a0eb_7a178b65efe3.slice/cpu.latency_awareness
# echo '56' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf8b7a6c8_af97_4ba7_a0eb_7a178b65efe3.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-46-cfspatched-00001-deployment-7fc68cb4g7l4f"
# echo '46' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf2fa9dfc_a198_4124_89f3_bab98952f197.slice/cpu.latency_awareness
# echo '46' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf2fa9dfc_a198_4124_89f3_bab98952f197.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-47-cfspatched-00001-deployment-c9c7d57fckdxf"
# echo '36' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf39b480b_6f96_4876_b421_0cc4428eaafe.slice/cpu.latency_awareness
# echo '36' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf39b480b_6f96_4876_b421_0cc4428eaafe.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-48-cfspatched-00001-deployment-5646bbc7f5kjn"
# echo '26' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod161b3c9f_22c3_4f99_a019_dda6a368faad.slice/cpu.latency_awareness
# echo '26' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod161b3c9f_22c3_4f99_a019_dda6a368faad.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-49-cfspatched-00001-deployment-857c8bf5qkqcl"
# echo '16' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podfd5f800e_eb0c_4b19_8391_1b80e8531803.slice/cpu.latency_awareness
# echo '16' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podfd5f800e_eb0c_4b19_8391_1b80e8531803.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-50-cfspatched-00001-deployment-57f95596hs8sd"
# echo '6' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podab0bbf3b_3d97_4a8a_87bc_d02c459b34aa.slice/cpu.latency_awareness
# echo '6' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podab0bbf3b_3d97_4a8a_87bc_d02c459b34aa.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-51-cfspatched-00001-deployment-5fd9978bs5pfj"
# echo '95' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2ed8766b_9af9_4f00_9bdd_06bccfb489e6.slice/cpu.latency_awareness
# echo '95' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2ed8766b_9af9_4f00_9bdd_06bccfb489e6.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-52-cfspatched-00001-deployment-75d58f95zsbcd"
# echo '85' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod576dd023_a9e1_4b12_9495_c446ab41416c.slice/cpu.latency_awareness
# echo '85' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod576dd023_a9e1_4b12_9495_c446ab41416c.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-53-cfspatched-00001-deployment-59d8fc4cttkhz"
# echo '75' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podd2591ec3_429b_41ac_95b6_d0f7ca517d13.slice/cpu.latency_awareness
# echo '75' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podd2591ec3_429b_41ac_95b6_d0f7ca517d13.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-54-cfspatched-00001-deployment-56bfd87d7hc4n"
# echo '65' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf6fc3577_a775_4a4c_9206_6c1d43d84743.slice/cpu.latency_awareness
# echo '65' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podf6fc3577_a775_4a4c_9206_6c1d43d84743.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-55-cfspatched-00001-deployment-5d4bc57dbtbn9"
# echo '55' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod52f53d36_5f61_4cf4_8fb4_8a62c8d540d2.slice/cpu.latency_awareness
# echo '55' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod52f53d36_5f61_4cf4_8fb4_8a62c8d540d2.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-56-cfspatched-00001-deployment-75cf5d78gw6sw"
# echo '45' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7b8710a4_44ea_4c66_889d_d9dba2556ef7.slice/cpu.latency_awareness
# echo '45' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7b8710a4_44ea_4c66_889d_d9dba2556ef7.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-57-cfspatched-00001-deployment-56fd5db6mkjkj"
# echo '35' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod16f77e31_47bf_4f26_be9d_3b6fcb87ac75.slice/cpu.latency_awareness
# echo '35' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod16f77e31_47bf_4f26_be9d_3b6fcb87ac75.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-58-cfspatched-00001-deployment-6c8454bdkwl9k"
# echo '25' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod8b839b1c_c473_4f86_84bd_bfcf6c143225.slice/cpu.latency_awareness
# echo '25' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod8b839b1c_c473_4f86_84bd_bfcf6c143225.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-59-cfspatched-00001-deployment-6c749666h7x2h"
# echo '15' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod44a85665_5459_4318_bd67_27c42df13c72.slice/cpu.latency_awareness
# echo '15' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod44a85665_5459_4318_bd67_27c42df13c72.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-60-cfspatched-00001-deployment-5b7c4b84hhsj5"
# echo '5' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod85a14a03_8b5f_4a7b_b52e_ef2fcc0494da.slice/cpu.latency_awareness
# echo '5' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod85a14a03_8b5f_4a7b_b52e_ef2fcc0494da.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-61-cfspatched-00001-deployment-797b4d4f4q48g"
# echo '94' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod327f1109_6c85_443e_81ed_1a6bb4513f28.slice/cpu.latency_awareness
# echo '94' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod327f1109_6c85_443e_81ed_1a6bb4513f28.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-62-cfspatched-00001-deployment-9c6fd5bbv29f2"
# echo '84' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podee0e067b_9554_4669_9b5c_2a726a4bd900.slice/cpu.latency_awareness
# echo '84' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podee0e067b_9554_4669_9b5c_2a726a4bd900.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-63-cfspatched-00001-deployment-5879cb4dx4kmf"
# echo '74' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6d67abdf_78bf_4ec7_bf67_1c3c22e7d558.slice/cpu.latency_awareness
# echo '74' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6d67abdf_78bf_4ec7_bf67_1c3c22e7d558.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-64-cfspatched-00001-deployment-7c85d66cdpl2k"
# echo '64' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podd202ea76_01d9_4e73_8a79_e97201847cb9.slice/cpu.latency_awareness
# echo '64' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podd202ea76_01d9_4e73_8a79_e97201847cb9.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-65-cfspatched-00001-deployment-6855d9ffdnrd7"
# echo '54' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod5b225164_5ae4_4820_a115_bfccf5646805.slice/cpu.latency_awareness
# echo '54' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod5b225164_5ae4_4820_a115_bfccf5646805.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-66-cfspatched-00001-deployment-6d69c8ddf82hb"
# echo '44' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod95758eea_58f0_451d_97ba_890c7b536420.slice/cpu.latency_awareness
# echo '44' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod95758eea_58f0_451d_97ba_890c7b536420.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-67-cfspatched-00001-deployment-78d59455xd7db"
# echo '34' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podeec9ae7e_0c4a_4482_9be7_b7157865a651.slice/cpu.latency_awareness
# echo '34' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podeec9ae7e_0c4a_4482_9be7_b7157865a651.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-68-cfspatched-00001-deployment-7f47859c7mddw"
# echo '24' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podadb19ff0_06e5_4136_ba1e_03480034c6db.slice/cpu.latency_awareness
# echo '24' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podadb19ff0_06e5_4136_ba1e_03480034c6db.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-69-cfspatched-00001-deployment-5f868b8dchfwx"
# echo '14' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod77dba2ec_5429_41ad_96be_6231bf4d1033.slice/cpu.latency_awareness
# echo '14' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod77dba2ec_5429_41ad_96be_6231bf4d1033.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-70-cfspatched-00001-deployment-77795dd6g7s6w"
# echo '4' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podc74ec0e9_83c1_41f7_9f89_b599bcbf96b3.slice/cpu.latency_awareness
# echo '4' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podc74ec0e9_83c1_41f7_9f89_b599bcbf96b3.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-71-cfspatched-00001-deployment-845fcff4rdrkn"
# echo '93' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podca1ee341_188d_4dcb_a74e_ab5f4a0823e3.slice/cpu.latency_awareness
# echo '93' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podca1ee341_188d_4dcb_a74e_ab5f4a0823e3.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-72-cfspatched-00001-deployment-64ff65f6xxrmf"
# echo '83' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod47a82c81_0e1f_4260_a5cf_08ef7df91262.slice/cpu.latency_awareness
# echo '83' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod47a82c81_0e1f_4260_a5cf_08ef7df91262.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-73-cfspatched-00001-deployment-5cbdc6d5tzq2c"
# echo '73' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod201b1747_34d0_4df8_a546_889f5679eabc.slice/cpu.latency_awareness
# echo '73' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod201b1747_34d0_4df8_a546_889f5679eabc.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-74-cfspatched-00001-deployment-5bf6f669xq24j"
# echo '63' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pode4c88c1c_1068_4965_9a0e_dffb3463144a.slice/cpu.latency_awareness
# echo '63' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pode4c88c1c_1068_4965_9a0e_dffb3463144a.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-75-cfspatched-00001-deployment-5995d564pgntj"
# echo '53' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod805b674f_3234_4ff6_84f4_1e25522bb7a1.slice/cpu.latency_awareness
# echo '53' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod805b674f_3234_4ff6_84f4_1e25522bb7a1.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-76-cfspatched-00001-deployment-5bf48b44fxdxg"
# echo '43' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod837cfc66_3c4b_4bc5_9d6c_cacb94b62d75.slice/cpu.latency_awareness
# echo '43' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod837cfc66_3c4b_4bc5_9d6c_cacb94b62d75.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-77-cfspatched-00001-deployment-c7f4dc5cvpggx"
# echo '33' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda34955f9_dd4a_49c2_988b_6eed38a75ab9.slice/cpu.latency_awareness
# echo '33' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda34955f9_dd4a_49c2_988b_6eed38a75ab9.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-78-cfspatched-00001-deployment-77c85c459mpqw"
# echo '23' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod974a9ea1_8a43_4cb0_9508_0f02999c3f59.slice/cpu.latency_awareness
# echo '23' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod974a9ea1_8a43_4cb0_9508_0f02999c3f59.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-79-cfspatched-00001-deployment-744f84f9v2w8c"
# echo '13' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podd68bb793_9c70_4cef_81fa_c8dc5c7e6025.slice/cpu.latency_awareness
# echo '13' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podd68bb793_9c70_4cef_81fa_c8dc5c7e6025.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-80-cfspatched-00001-deployment-6cdf49f9mszmr"
# echo '3' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod09357965_f16f_4853_aca8_a4f64e8e5b8e.slice/cpu.latency_awareness
# echo '3' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod09357965_f16f_4853_aca8_a4f64e8e5b8e.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-81-cfspatched-00001-deployment-6f8bfff7q9wkd"
# echo '92' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2d2ec1d3_e7fc_4255_9679_040fb5ee8a4e.slice/cpu.latency_awareness
# echo '92' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod2d2ec1d3_e7fc_4255_9679_040fb5ee8a4e.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-82-cfspatched-00001-deployment-859ff76dbzlqn"
# echo '82' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0ee9307f_abf2_4186_8141_114305353709.slice/cpu.latency_awareness
# echo '82' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0ee9307f_abf2_4186_8141_114305353709.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-83-cfspatched-00001-deployment-6b565cbbfhbbg"
# echo '72' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod3ccf7450_b928_4163_b0ad_7a7f9267c274.slice/cpu.latency_awareness
# echo '72' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod3ccf7450_b928_4163_b0ad_7a7f9267c274.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-84-cfspatched-00001-deployment-58b888d5bj9kg"
# echo '62' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod65780904_2c95_4e73_a685_6f8dbf5f7377.slice/cpu.latency_awareness
# echo '62' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod65780904_2c95_4e73_a685_6f8dbf5f7377.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-85-cfspatched-00001-deployment-ff4d6bccsrqpn"
# echo '52' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod22913641_bd56_4e3a_8e13_02841345fd69.slice/cpu.latency_awareness
# echo '52' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod22913641_bd56_4e3a_8e13_02841345fd69.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-86-cfspatched-00001-deployment-65c6b4b5s9ssk"
# echo '42' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod1486525d_70db_430e_8322_830f2b85f7aa.slice/cpu.latency_awareness
# echo '42' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod1486525d_70db_430e_8322_830f2b85f7aa.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-87-cfspatched-00001-deployment-75bb56bfs5hxq"
# echo '32' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod30572aa6_e181_4864_81c6_17d4c1225711.slice/cpu.latency_awareness
# echo '32' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod30572aa6_e181_4864_81c6_17d4c1225711.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-88-cfspatched-00001-deployment-58cb7978fdbkc"
# echo '22' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod3e119ee4_2584_4f95_ab7f_2d88aff5c07e.slice/cpu.latency_awareness
# echo '22' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod3e119ee4_2584_4f95_ab7f_2d88aff5c07e.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-89-cfspatched-00001-deployment-66c856fdpttp8"
# echo '12' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7610586f_3d47_4243_b899_a081da7c770e.slice/cpu.latency_awareness
# echo '12' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7610586f_3d47_4243_b899_a081da7c770e.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-90-cfspatched-00001-deployment-76f47579qpgqc"
# echo '2' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podfcc1b3c3_4dae_4454_a17d_95da9d2f72be.slice/cpu.latency_awareness
# echo '2' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podfcc1b3c3_4dae_4454_a17d_95da9d2f72be.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-91-cfspatched-00001-deployment-7b46d9ffl5hsg"
# echo '91' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda1598ec7_3ab2_42f6_b3a7_ab9cd9f5dc1a.slice/cpu.latency_awareness
# echo '91' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poda1598ec7_3ab2_42f6_b3a7_ab9cd9f5dc1a.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-92-cfspatched-00001-deployment-6bb4888cxtjwj"
# echo '81' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poddf5b743e_0908_4d2d_a41a_ebb1f0357ef2.slice/cpu.latency_awareness
# echo '81' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-poddf5b743e_0908_4d2d_a41a_ebb1f0357ef2.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-93-cfspatched-00001-deployment-565c588dgnzzk"
# echo '71' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podff55f819_a1f1_4473_977c_3609c85f8d60.slice/cpu.latency_awareness
# echo '71' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podff55f819_a1f1_4473_977c_3609c85f8d60.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-94-cfspatched-00001-deployment-659f65c87vdkc"
# echo '61' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod80865dd8_d74d_48b2_999b_06a3f6b38d88.slice/cpu.latency_awareness
# echo '61' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod80865dd8_d74d_48b2_999b_06a3f6b38d88.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-95-cfspatched-00001-deployment-5dbb465f6lhq7"
# echo '51' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6f8aeceb_0015_4aa5_ae73_95088378ba72.slice/cpu.latency_awareness
# echo '51' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6f8aeceb_0015_4aa5_ae73_95088378ba72.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-96-cfspatched-00001-deployment-7b5748947thtg"
# echo '41' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6d6c2cd4_4d79_4132_afaf_feedc58cb102.slice/cpu.latency_awareness
# echo '41' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6d6c2cd4_4d79_4132_afaf_feedc58cb102.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-97-cfspatched-00001-deployment-999664ccl26z9"
# echo '31' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod661a8066_342c_4c5a_a45f_c51856671872.slice/cpu.latency_awareness
# echo '31' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod661a8066_342c_4c5a_a45f_c51856671872.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-98-cfspatched-00001-deployment-7fbb66b5khn5t"
# echo '21' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0d12075a_77ed_4f38_8225_1b4b78fe8347.slice/cpu.latency_awareness
# echo '21' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0d12075a_77ed_4f38_8225_1b4b78fe8347.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-99-cfspatched-00001-deployment-54bcff98mr2ps"
# echo '11' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7960dc5e_81bb_4b36_9363_466675c92ac2.slice/cpu.latency_awareness
# echo '11' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod7960dc5e_81bb_4b36_9363_466675c92ac2.slice/*/cpu.latency_awareness

# echo "pytorch-classifier-100-cfspatched-00001-deployment-657fcd6bgqzb"
# echo '1' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod8bf44922_5c1a_44da_afd0_2ca2eeb6bfe8.slice/cpu.latency_awareness
# echo '1' | sudo tee -a /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod8bf44922_5c1a_44da_afd0_2ca2eeb6bfe8.slice/*/cpu.latency_awareness
