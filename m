From: Matt <mbedynek-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: CIFS in 2.6.32.24 kernel
Date: Mon, 25 Oct 2010 09:15:49 -0700 (PDT)
Message-ID: <818626.80657.qm@web38104.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

All,

Running into a problem with CIFS mounts in fairly recent kernel and was looking for some input.  kernel from kernel.org (2.6.32.24) and get the following when umounting a CIFS mounted volume.

Our mount command looks like :

mount.cifs <MntTarget> <MntPoint> -o directio,user=<User>,pass=<Pass>,uid=<Uid>,gid=<Gid>,ro


[89125.200088]  CIFS VFS: Unexpected lookup error -88
[89125.234556]  CIFS VFS: cifs_mount failed w/return code = -6
[89125.241708]  CIFS VFS: cifs_mount failed w/return code = -6
[89125.252051]  CIFS VFS: Send error in SessSetup = -88
[89125.252082]  CIFS VFS: Unexpected lookup error -88
[89125.252528]  CIFS VFS: Send error in SessSetup = -88
[89125.252557]  CIFS VFS: Unexpected lookup error -88
[89125.253476]  CIFS VFS: Send error in SessSetup = -88
[89125.253504]  CIFS VFS: Unexpected lookup error -88
[89125.254072]  CIFS VFS: Send error in SessSetup = -88
[89125.254100]  CIFS VFS: Unexpected lookup error -88
[89125.255142]  CIFS VFS: Send error in SessSetup = -88
[89125.282478]  CIFS VFS: Error connecting to socket. Aborting operation
[89125.282515]  CIFS VFS: cifs_mount failed w/return code = -111
[89316.202504]  CIFS VFS: Send error in SessSetup = -88
[89316.203716]  CIFS VFS: Send error in SessSetup = -88
[89316.206972]  CIFS VFS: Send error in SessSetup = -88
[89316.208560]  CIFS VFS: Send error in SessSetup = -88
[89316.209965]  CIFS VFS: Send error in SessSetup = -88
[89316.211410]  CIFS VFS: Send error in SessSetup = -88
[89316.212959]  CIFS VFS: Send error in SessSetup = -88
[89316.214355]  CIFS VFS: Send error in SessSetup = -88
[89316.215728]  CIFS VFS: Send error in SessSetup = -88
[89316.218465]  CIFS VFS: Send error in SessSetup = -88
[89316.219759]  CIFS VFS: Send error in SessSetup = -88
[89316.221649]  CIFS VFS: Send error in SessSetup = -88
[89316.222994]  CIFS VFS: Send error in SessSetup = -88
[89316.224448]  CIFS VFS: Send error in SessSetup = -88
[89316.225796]  CIFS VFS: Send error in SessSetup = -88

[89425.205640]  CIFS VFS: Unexpected lookup error -88
[89425.240725]  CIFS VFS: cifs_mount failed w/return code = -6
[89425.247891]  CIFS VFS: cifs_mount failed w/return code = -6
[89425.259433]  CIFS VFS: Send error in SessSetup = -88
[89425.259465]  CIFS VFS: Unexpected lookup error -88
[89425.259908]  CIFS VFS: Send error in SessSetup = -88
[89425.259937]  CIFS VFS: Unexpected lookup error -88
[89425.260690]  CIFS VFS: Send error in SessSetup = -88
[89425.260719]  CIFS VFS: Unexpected lookup error -88
[89425.261203]  CIFS VFS: Send error in SessSetup = -88
[89425.261232]  CIFS VFS: Unexpected lookup error -88
[89425.262539]  CIFS VFS: Send error in SessSetup = -88
[89425.293154]  CIFS VFS: Error connecting to socket. Aborting operation
[89425.293191]  CIFS VFS: cifs_mount failed w/return code = -111
[89464.504075]  CIFS VFS: Send error in SessSetup = -88
[89464.504215]  CIFS VFS: Send error in SessSetup = -88
[89464.504315] BUG: unable to handle kernel NULL pointer dereference at 00000504
[89464.504352] IP: [<c11eba7c>] _spin_lock_irqsave+0x8/0x1a
[89464.504387] *pdpt = 00000000313a3001 *pde = 0000000000000000
[89464.504421] Oops: 0002 [#2] SMP
[89464.504449] last sysfs file: /sys/devices/system/cpu/cpu1/topology/core_id
[89464.504480] Modules linked in: vmnet vsock vmci vmmon w83627hf_wdt nls_utf8 cifs cls_u32 sch_cbq dm_snapshot dm_mirror dm_region_hash
dm_log dm_mod ide_generic ide_gd_mod ide_cd_mod ide_core cdrom e1000 container evdev pcspkr i2c_i801 button processor rng_core shpchp p
ci_hotplug i3000_edac e1000e edac_core ext3 jbd mbcache sd_mod crc_t10dif ata_generic ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore
nls_base thermal fan thermal_sys [last unloaded: vmnet]
[89464.504752]
[89464.504775] Pid: 6478,  : G      D    (2.6.32.24 #1) PDSMi
[89464.504825] EIP: 0060:[<c11eba7c>] EFLAGS: 00010002 CPU: 0
[89464.504854] EIP is at _spin_lock_irqsave+0x8/0x1a
[89464.504881] EAX: 00000504 EBX: 000000b4 ECX: 00000202 EDX: 00000100
[89464.504911] ESI: f6da41c0 EDI: 00000009 EBP: f741da80 ESP: e3893f28
[89464.504940]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[89464.504970] Process umount.cifs (pid: 6478, ti=e3893000 task=f7791490 task.ti=e3893000)
[89464.505016] Stack:
[89464.505037]  c102cf92 00000001 f6da9900 f706ba00 f87fce20 f741da80 f87e84a6 f6da9900
[89464.505084] <0> f87df3f6 f706ba00 f7791490 c107b340 00000010 c10a87a4 f880c120 c107b3e9
[89464.505149] <0> f706ba00 c107b654 f741da80 f741da80 f741da98 c108b5a9 00000000 00000000

[89464.505231] Call Trace:
[89464.505257]  [<c102cf92>] ? force_sig_info+0x21/0x93
[89464.505295]  [<f87e84a6>] ? cifs_umount+0xe/0x2e [cifs]
[89464.505326]  [<f87df3f6>] ? cifs_put_super+0x46/0x8c [cifs]
[89464.505358]  [<c107b340>] ? generic_shutdown_super+0x41/0xb5
[89464.505389]  [<c10a87a4>] ? vfs_quota_off+0x0/0xd
[89464.505417]  [<c107b3e9>] ? kill_anon_super+0x9/0x40
[89464.505445]  [<c107b654>] ? deactivate_super+0x4a/0x5f
[89464.505475]  [<c108b5a9>] ? sys_umount+0x268/0x2aa
[89464.505504]  [<c100278b>] ? sysenter_do_call+0x12/0x22
[89464.505531] Code: 94 c0 84 c0 b9 01 00 00 00 75 09 f0 81 02 00 00 00 01 30 c9 89 c8 c3 f0 83 28 01 79 05 e8 59 ff ff ff c3 9c 59 fa b
a 00 01 00 00 <f0> 66 0f c1 10 38 f2 74 06 f3 90 8a 10 eb f6 89 c8 c3 fa ba 00
[89464.505763] EIP: [<c11eba7c>] _spin_lock_irqsave+0x8/0x1a SS:ESP 0068:e3893f28
[89464.505813] CR2: 0000000000000504
[89464.506087] ---[ end trace cfb0e600464a4d92 ]---
[89464.506146] ------------[ cut here ]------------
[89464.506207] WARNING: at kernel/exit.c:895 do_exit+0x29/0x589()
[89464.506268] Hardware name: PDSMi
[89464.506324] Modules linked in: vmnet vsock vmci vmmon w83627hf_wdt nls_utf8 cifs cls_u32 sch_cbq dm_snapshot dm_mirror dm_region_hash
dm_log dm_mod ide_generic ide_gd_mod ide_cd_mod ide_core cdrom e1000 container evdev pcspkr i2c_i801 button processor rng_core shpchp p
ci_hotplug i3000_edac e1000e edac_core ext3 jbd mbcache sd_mod crc_t10dif ata_generic ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore
nls_base thermal fan thermal_sys [last unloaded: vmnet]
[89464.508003] Pid: 6478, comm: umount.cifs Tainted: G      D    2.6.32.24 #1
[89464.508003] Call Trace:
[89464.508003]  [<c102399c>] ? warn_slowpath_common+0x41/0x71
[89464.508003]  [<c10239b9>] ? warn_slowpath_common+0x5e/0x71
[89464.508003]  [<c10239d6>] ? warn_slowpath_null+0xa/0xc
[89464.508003]  [<c1026015>] ? do_exit+0x29/0x589
[89464.508003]  [<c10244b3>] ? printk+0x14/0x18
[89464.508003]  [<c10056fe>] ? oops_end+0x72/0x75
[89464.508003]  [<c10140f8>] ? no_context+0x147/0x151
[89464.508003]  [<c101442e>] ? do_page_fault+0x0/0x1da
[89464.508003]  [<c10142df>] ? bad_area+0xa/0xc
[89464.508003]  [<c11ebcdb>] ? error_code+0x73/0x78
[89464.508003]  [<c103007b>] ? flush_work+0x3c/0x62
[89464.508003]  [<c11eba7c>] ? _spin_lock_irqsave+0x8/0x1a
[89464.508003]  [<c102cf92>] ? force_sig_info+0x21/0x93
[89464.508003]  [<f87e84a6>] ? cifs_umount+0xe/0x2e [cifs]
[89464.508003]  [<f87df3f6>] ? cifs_put_super+0x46/0x8c [cifs]
[89464.508003]  [<c107b340>] ? generic_shutdown_super+0x41/0xb5
[89464.508003]  [<c10a87a4>] ? vfs_quota_off+0x0/0xd
[89464.508003]  [<c107b3e9>] ? kill_anon_super+0x9/0x40
[89464.508003]  [<c107b654>] ? deactivate_super+0x4a/0x5f
[89464.508003]  [<c108b5a9>] ? sys_umount+0x268/0x2aa
[89464.508003]  [<c100278b>] ? sysenter_do_call+0x12/0x22
[89464.508003] ---[ end trace cfb0e600464a4d93 ]---

If there is anything else I can provide, please let me know.

Thank you.


-matt



      
