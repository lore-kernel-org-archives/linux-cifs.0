From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: smb2 kernel panic on module unload
Date: Wed, 08 Sep 2010 11:37:05 -0700
Message-ID: <4C87D7D1.806@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I saw this when attempting to rmmod smb2.

Thanks,
Ben


------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'DebugData'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Not tainted 2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034ab20>] smb2_proc_clean+0x20/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420c5 ]---
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'smb2FYI'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034ab33>] smb2_proc_clean+0x33/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420c6 ]---
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'traceSMB2'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034ab46>] smb2_proc_clean+0x46/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420c7 ]---
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'Stats'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034ab59>] smb2_proc_clean+0x59/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420c8 ]---
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'MultiuserMount'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034ab6c>] smb2_proc_clean+0x6c/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420c9 ]---
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'OplockEnabled'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034ab7f>] smb2_proc_clean+0x7f/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420ca ]---
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'SecurityFlags'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034ab92>] smb2_proc_clean+0x92/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420cb ]---
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'Experimental'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034aba5>] smb2_proc_clean+0xa5/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420cc ]---
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'LookupCacheEnabled'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034abb8>] smb2_proc_clean+0xb8/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420cd ]---
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
Hardware name: X8STi
name 'fs/smb2'
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]
Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1
Call Trace:
  [<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
  [<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
  [<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffffa034abc6>] smb2_proc_clean+0xc6/0xc8 [smb2]
  [<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
---[ end trace 8d1d6075190420ce ]---
------------[ cut here ]------------
kernel BUG at mm/mempool.c:26!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda1/stat
CPU 6
Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_connmark 
8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput ixgbe ioatdma e1000e ghes dca mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microcode i7core_edac edac_core [last unloaded: 
ipt_addrtype]

Pid: 12935, comm: rmmod Tainted: G        W   2.6.36-rc2+ #1 X8STi/X8STi
RIP: 0010:[<ffffffff810a70e9>]  [<ffffffff810a70e9>] free_pool+0x10/0x47
RSP: 0018:ffff88032c9cbe98  EFLAGS: 00010286
RAX: 00000000ffffffff RBX: ffff88031abd3600 RCX: 0000000000000000
RDX: ffffffff00000001 RSI: 0000000000000001 RDI: ffff88031abd3600
RBP: ffff88032c9cbea8 R08: 0000000000000246 R09: 0000000000000000
R10: ffffffff81c8a5f0 R11: 0000000000000000 R12: 0000000000000880
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
FS:  00007facdcd23700(0000) GS:ffff880002580000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000037e2677900 CR3: 000000031024e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 12935, threadinfo ffff88032c9ca000, task ffff88032f200000)
Stack:
  ffff88032c9cbec8 ffffffffa036dce0 ffff88032c9cbeb8 ffffffff810a7135
<0> ffff88032c9cbec8 ffffffffa034dc0f ffff88032c9cbed8 ffffffffa035383b
<0> ffff88032c9cbf78 ffffffff8107375b ffff880032626d73 ffffffff81407bf9
Call Trace:
  [<ffffffff810a7135>] mempool_destroy+0x15/0x17
  [<ffffffffa034dc0f>] smb2_destroy_mids+0x10/0x1e [smb2]
  [<ffffffffa035383b>] exit_smb2+0x7f/0x86 [smb2]
  [<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
  [<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
Code: e8 e7 25 03 00 c9 c3 55 48 89 f8 48 89 f7 48 89 c6 48 89 e5 e8 0e 2a 03 00 c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 eb 1c 7f 04 <0f> 0b eb fe 48 8b 53 38 
ff c8 48 8b 73 40 89 43 34 48 98 48 8b
RIP  [<ffffffff810a70e9>] free_pool+0x10/0x47
  RSP <ffff88032c9cbe98>
---[ end trace 8d1d6075190420cf ]---

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
