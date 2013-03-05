From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: 3.7.10+:  BUG Dentry still in use [unmount of cifs cifs]
Date: Tue, 05 Mar 2013 10:54:56 -0800
Message-ID: <51363F80.8070609@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In doing some CIFS testing (utilizing it's feature to bind to local
address..but not sure that matters), we saw this error when trying
to un-mount.

Our kernel is patched (nfs, some networking related patches), but there
are no out-of-kernel patches to CIFS, so I don't *think* this is anything
we could have caused.

This problem appears to be easily reproducible, so we will be happy
to test patches if anyone has any suggestions.

BUG: Dentry ffff8800c07e43c0{i=45762,n=cifs2-01.7.lf-data} still in use (1) [unmount of cifs cifs]
------------[ cut here ]------------
kernel BUG at /home/greearb/git/linux-3.7.dev.y/fs/dcache.c:967!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: nls_utf8 cifs 8021q garp stp llc iptable_raw xt_CT veth nf_nat_ipv4 nf_nat fuse macvlan wanlink(O) pktgen nfsv3 nfs_acl nfsv4 auth_rpcgss nfs 
fscache lockd sunrpc be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core 
w83793 iscsi_tcp w83627hf libiscsi_tcp hwmon_vid libiscsi scsi_transport_iscsi coretemp mperf kvm_intel kvm i5k_amb uinput i5000_edac gpio_ich edac_core 
iTCO_wdt e1000e iTCO_vendor_support lpc_ich i2c_i801 pcspkr ioatdma dca microcode shpchp ipv6 floppy radeon i2c_algo_bit hwmon drm_kms_helper ttm drm i2c_core 
[last unloaded: iptable_nat]
CPU 6
Pid: 6610, comm: umount Tainted: G         C O 3.7.10+ #74 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff811591c9>]  [<ffffffff811591c9>] shrink_dcache_for_umount_subtree+0x84/0x194
RSP: 0018:ffff8800c0085dc8  EFLAGS: 00010296
RAX: 0000000000000062 RBX: ffff8800c07e43c0 RCX: 0000000000000059
RDX: ffffffff81bc25a8 RSI: 0000000000000046 RDI: 0000000000000246
RBP: ffff8800c0085de8 R08: 0000000000000001 R09: ffff8800c0085cc8
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800c050e9c0
R13: ffff880128ee8000 R14: 0000000000000000 R15: ffff8800c0085f28
FS:  00007f6084847840(0000) GS:ffff88012fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f608442c3a0 CR3: 00000000c7c2d000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 6610, threadinfo ffff8800c0084000, task ffff88012a6a0000)
Stack:
  ffff880128ee8310 00000000000128c0 ffff880128ee8000 ffffffffa06b96b0
  ffff8800c0085e08 ffffffff81159310 ffff8800c0084000 ffff880128ee8000
  ffff8800c0085e38 ffffffff81149afe ffff8800c0085e38 0000000000000021
Call Trace:
  [<ffffffff81159310>] shrink_dcache_for_umount+0x37/0x49
  [<ffffffff81149afe>] generic_shutdown_super+0x20/0xd2
  [<ffffffff81149c25>] kill_anon_super+0x11/0x1c
  [<ffffffffa068b1ea>] cifs_kill_sb+0x15/0x21 [cifs]
  [<ffffffff81149e48>] deactivate_locked_super+0x32/0x5e
  [<ffffffff8114a942>] deactivate_super+0x40/0x46
  [<ffffffff8115fdb3>] mntput_no_expire+0x12d/0x136
  [<ffffffff81160b59>] sys_umount+0x321/0x34c
  [<ffffffff8114f846>] ? path_put+0x1d/0x21
  [<ffffffff81525229>] system_call_fastpath+0x16/0x1b
Code: 50 28 4c 8b 0a 31 d2 48 85 f6 74 04 48 8b 56 40 48 05 10 03 00 00 48 89 de 48 c7 c7 9d d0 7b 81 48 89 04 24 31 c0 e8 b9 4e 3c 00 <0f> 0b eb fe 4c 8b 63 18 
4c 39 e3 75 3c 48 8b 93 90 00 00 00 48
RIP  [<ffffffff811591c9>] shrink_dcache_for_umount_subtree+0x84/0x194
  RSP <ffff8800c0085dc8>
---[ end trace 9b2978a89532c292 ]---
-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
