From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: panic at umount in fscache code
Date: Fri, 23 Jul 2010 09:52:29 -0400
Message-ID: <20100723095229.2c5bd562@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I built a kernel based on Steve's tree, enabled the fscache option and
got the following panic at umount. I didn't mount with -o fsc or
anything. I have some other patches on top of Steve's tree, but I'm
fairly certain they wouldn't affect this.

For the record, here's the fstab entry (with anonymized names):

//server.example.com/scratch	/mnt/anonymous		cifs	sec=none,user,noperm,noauto 0 0

Disabling the fscache stuff at build time makes the problem go away.

------------------------------[snip]------------------------------

general protection fault: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
CPU 0 
Modules linked in: cifs fscache nls_utf8 nfsd lockd nfs_acl exportfs rpcsec_gss_krb5 auth_rpcgss des_generic sunrpc ipv6 joydev i2c_piix4 microcode virtio_balloon i2c_core virtio_net virtio_blk virtio_pci virtio_ring virtio [last unloaded: cifs]

Pid: 1400, comm: umount Not tainted 2.6.35-0.49.rc5.git2.fc14.x86_64 #1 /
RIP: 0010:[<ffffffffa0227dc7>]  [<ffffffffa0227dc7>] __fscache_relinquish_cookie+0x4f/0x246 [fscache]
RSP: 0018:ffff880036ef5d78  EFLAGS: 00010202
RAX: 00200000000040c3 RBX: 6b6b6b6b6b6b6b6b RCX: 00000000001c0013
RDX: ffff8800370c5ff0 RSI: 0000000000000000 RDI: ffffffffa022eca0
RBP: ffff880036ef5da8 R08: ffffffff81a2e938 R09: 000000000000005a
R10: ffffffff828d7eb8 R11: ffff880036ef5ba8 R12: 0000000000000000
R13: ffff8800370c6fe8 R14: 0000000000000000 R15: ffff8800373388c0
FS:  00007fb2909d5760(0000) GS:ffff880004600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fb2900577e3 CR3: 000000003be47000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 1400, threadinfo ffff880036ef4000, task ffff88003ca548a0)
Stack:
 ffffffffa02b91f8 ffff8800370c7230 00000000000003b9 ffff8800370c6fe8
<0> 0000000000000000 ffff8800373388c0 ffff880036ef5db8 ffffffffa02a7246
<0> ffff880036ef5dd8 ffffffffa02a73b5 ffff880036ef5dd8 ffff8800370c7230
Call Trace:
 [<ffffffffa02a7246>] fscache_relinquish_cookie+0x13/0x15 [cifs]
 [<ffffffffa02a73b5>] cifs_fscache_release_super_cookie+0x44/0x53 [cifs]
 [<ffffffffa028e035>] cifs_put_tcon+0xf2/0x102 [cifs]
 [<ffffffffa0290410>] cifs_umount+0x19/0x3e [cifs]
 [<ffffffffa028477e>] cifs_put_super+0x84/0xee [cifs]
 [<ffffffff8112af62>] generic_shutdown_super+0x5b/0xe1
 [<ffffffff8112b03d>] kill_anon_super+0x16/0x54
 [<ffffffff8112b604>] deactivate_locked_super+0x26/0x46
 [<ffffffff8112bd57>] deactivate_super+0x3a/0x3e
 [<ffffffff81140554>] mntput_no_expire+0x81/0xb2
 [<ffffffff811410f3>] sys_umount+0x2da/0x30c
 [<ffffffff81497f7e>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Code: 54 fb ff ff 45 85 e4 74 0c 48 c7 c7 ac ec 22 a0 e8 43 fb ff ff 48 85 db 75 11 48 c7 c7 a4 ec 22 a0 e8 32 fb ff ff e9 eb 01 00 00 <8b> 43 04 85 c0 74 17 48 8b b3 90 00 00 00 48 c7 c7 5b cd 22 a0 
RIP  [<ffffffffa0227dc7>] __fscache_relinquish_cookie+0x4f/0x246 [fscache]
 RSP <ffff880036ef5d78>
---[ end trace f2d78e2c68d1be76 ]---
------------[ cut here ]------------
WARNING: at kernel/exit.c:896 do_exit+0x46/0x7d0()
Hardware name: 
Modules linked in: cifs fscache nls_utf8 nfsd lockd nfs_acl exportfs rpcsec_gss_krb5 auth_rpcgss des_generic sunrpc ipv6 joydev i2c_piix4 microcode virtio_balloon i2c_core virtio_net virtio_blk virtio_pci virtio_ring virtio [last unloaded: cifs]
Pid: 1400, comm: umount Tainted: G      D     2.6.35-0.49.rc5.git2.fc14.x86_64 #1
Call Trace:
 [<ffffffff810510ba>] warn_slowpath_common+0x85/0x9d
 [<ffffffff810510ec>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff81054a07>] do_exit+0x46/0x7d0
 [<ffffffff81498aef>] ? _raw_spin_unlock_irqrestore+0x4d/0x52
 [<ffffffff81499d2a>] ? oops_end+0x73/0xc7
 [<ffffffff81499d76>] oops_end+0xbf/0xc7
 [<ffffffff8100d718>] die+0x5a/0x66
 [<ffffffff8149971a>] do_general_protection+0x133/0x13b
 [<ffffffff81498e40>] ? irq_return+0x0/0x10
 [<ffffffff81499085>] general_protection+0x25/0x30
 [<ffffffffa0227dc7>] ? __fscache_relinquish_cookie+0x4f/0x246 [fscache]
 [<ffffffffa0227da0>] ? __fscache_relinquish_cookie+0x28/0x246 [fscache]
 [<ffffffffa02a7246>] fscache_relinquish_cookie+0x13/0x15 [cifs]
 [<ffffffffa02a73b5>] cifs_fscache_release_super_cookie+0x44/0x53 [cifs]
 [<ffffffffa028e035>] cifs_put_tcon+0xf2/0x102 [cifs]
 [<ffffffffa0290410>] cifs_umount+0x19/0x3e [cifs]
 [<ffffffffa028477e>] cifs_put_super+0x84/0xee [cifs]
 [<ffffffff8112af62>] generic_shutdown_super+0x5b/0xe1
 [<ffffffff8112b03d>] kill_anon_super+0x16/0x54
 [<ffffffff8112b604>] deactivate_locked_super+0x26/0x46
 [<ffffffff8112bd57>] deactivate_super+0x3a/0x3e
 [<ffffffff81140554>] mntput_no_expire+0x81/0xb2
 [<ffffffff811410f3>] sys_umount+0x2da/0x30c
 [<ffffffff81497f7e>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
---[ end trace f2d78e2c68d1be77 ]---

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
