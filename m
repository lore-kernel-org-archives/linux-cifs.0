From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: cifs: panic in crypto_shash_init
Date: Mon, 30 Aug 2010 12:35:10 -0400
Message-ID: <20100830123510.30ed304f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Testing recent kernel based on Steve's current tree (with the multiuser
patchset on top). At unmount, I just got this panic. Known bug?

fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 29 with uid: 0
fs/cifs/cifssmb.c: In tree disconnect
fs/cifs/transport.c: For smb_command 113
general protection fault: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
CPU 1 
Modules linked in: nls_utf8 cifs fscache nfsd lockd nfs_acl exportfs rpcsec_gss_krb5 auth_rpcgss des_generic sunrpc microcode virtio_net joydev virtio_balloon i2c_piix4 i2c_core ipv6 virtio_blk virtio_pci virtio_ring virtio [last unloaded: cifs]

Pid: 2197, comm: umount Not tainted 2.6.36-0.10.rc2.git4.fc15.x86_64 #1 /
RIP: 0010:[<ffffffffa02eb048>]  [<ffffffffa02eb048>] crypto_shash_init+0xc/0x15 [cifs]
RSP: 0018:ffff88003c2a5be8  EFLAGS: 00010286
RAX: 6b6b6b6b6b6b6b6b RBX: ffff88003d3e5158 RCX: ffff88003bcaf194
RDX: 00000000010e010d RSI: 0000000000000001 RDI: ffff88003e2f4bb8
RBP: ffff88003c2a5be8 R08: ffff88003bdf06c0 R09: ffff88003c2a5bb8
R10: ffffffffa0302d58 R11: 0000000000000000 R12: ffff88003c2a5ce8
R13: 0000000000000001 R14: ffff88003bdf06c0 R15: 00000000ffffffea
FS:  00007f12c4ad1760(0000) GS:ffff880004800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000264a068 CR3: 0000000039e67000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 2197, threadinfo ffff88003c2a4000, task ffff88003e6b48a0)
Stack:
 ffff88003c2a5c58 ffffffffa02eb338 ffff88003c2a5ca0 ffff88003bcaf194
<0> ffff88003c2a5c28 ffffffff8149b6b7 ffff88003d3e5158 000000000ff1c636
<0> ffff88003c2a5c58 ffff88003ab29b60 0000000000000000 0000000000000000
Call Trace:
 [<ffffffffa02eb338>] cifs_sign_smb2+0xce/0x1da [cifs]
 [<ffffffff8149b6b7>] ? _raw_spin_unlock+0x2b/0x2f
 [<ffffffffa02e758d>] SendReceive2+0x11f/0x438 [cifs]
 [<ffffffffa02e78d9>] SendReceiveNoRsp+0x33/0x35 [cifs]
 [<ffffffffa02cda85>] CIFSSMBTDis+0x90/0xd2 [cifs]
 [<ffffffffa02d6562>] cifs_put_tcon+0xda/0x102 [cifs]
 [<ffffffffa02d7ee6>] cifs_put_tlink+0x4f/0x5c [cifs]
 [<ffffffffa02d8b59>] cifs_umount+0xa0/0xdc [cifs]
 [<ffffffff8149b7b9>] ? _lock_kernel+0x84/0x9c
 [<ffffffffa02cc7a1>] cifs_put_super+0x84/0xf7 [cifs]
 [<ffffffff8112c659>] generic_shutdown_super+0x5b/0xe1
 [<ffffffff8112c734>] kill_anon_super+0x16/0x54
 [<ffffffff8112c981>] deactivate_locked_super+0x26/0x46
 [<ffffffff8112d4d1>] deactivate_super+0x3a/0x3e
 [<ffffffff81142050>] mntput_no_expire+0xa7/0xd3
 [<ffffffff81142b91>] sys_umount+0x2cf/0x301
 [<ffffffff81133787>] ? path_put+0x22/0x27
 [<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b
Code: c3 90 90 55 48 89 e5 0f 1f 44 00 00 83 c8 ff 48 ff cf 48 c1 ef 0b ff c0 48 d1 ef 75 f9 c9 c3 55 48 89 e5 0f 1f 44 00 00 48 8b 07 <48> 8b 40 58 ff 50 b0 c9 c3 55 48 89 e5 41 56 41 55 41 54 53 0f 
RIP  [<ffffffffa02eb048>] crypto_shash_init+0xc/0x15 [cifs]
 RSP <ffff88003c2a5be8>
---[ end trace 14b58c65d94d711c ]---
Kernel panic - not syncing: Fatal exception
Pid: 2197, comm: umount Tainted: G      D     2.6.36-0.10.rc2.git4.fc15.x86_64 #1
Call Trace:
 [<ffffffff814985ec>] panic+0x91/0x1a7
 [<ffffffff81052850>] ? kmsg_dump+0x149/0x165
 [<ffffffff8149c94b>] oops_end+0xb7/0xc7
 [<ffffffff8100d77c>] die+0x5a/0x66
 [<ffffffff8149c2fa>] do_general_protection+0x133/0x13b
 [<ffffffff8149ba40>] ? irq_return+0x0/0x10
 [<ffffffff8149bc65>] general_protection+0x25/0x30
 [<ffffffffa02eb048>] ? crypto_shash_init+0xc/0x15 [cifs]
 [<ffffffffa02eb338>] cifs_sign_smb2+0xce/0x1da [cifs]
 [<ffffffff8149b6b7>] ? _raw_spin_unlock+0x2b/0x2f
 [<ffffffffa02e758d>] SendReceive2+0x11f/0x438 [cifs]
 [<ffffffffa02e78d9>] SendReceiveNoRsp+0x33/0x35 [cifs]
 [<ffffffffa02cda85>] CIFSSMBTDis+0x90/0xd2 [cifs]
 [<ffffffffa02d6562>] cifs_put_tcon+0xda/0x102 [cifs]
 [<ffffffffa02d7ee6>] cifs_put_tlink+0x4f/0x5c [cifs]
 [<ffffffffa02d8b59>] cifs_umount+0xa0/0xdc [cifs]
 [<ffffffff8149b7b9>] ? _lock_kernel+0x84/0x9c
 [<ffffffffa02cc7a1>] cifs_put_super+0x84/0xf7 [cifs]
 [<ffffffff8112c659>] generic_shutdown_super+0x5b/0xe1
 [<ffffffff8112c734>] kill_anon_super+0x16/0x54
 [<ffffffff8112c981>] deactivate_locked_super+0x26/0x46
 [<ffffffff8112d4d1>] deactivate_super+0x3a/0x3e
 [<ffffffff81142050>] mntput_no_expire+0xa7/0xd3
 [<ffffffff81142b91>] sys_umount+0x2cf/0x301
 [<ffffffff81133787>] ? path_put+0x22/0x27
 [<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
