From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: guest mount crashes current git HEAD
Date: Wed, 25 May 2011 09:27:55 -0400
Message-ID: <20110525132755.GA21369@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Trying to mount a local shared in my VM I can trivially crash cifs:

qemu1:~# mount -t cifs 127.0.0.1:test /mnt/scratch/ -o guest
[   55.477707] CIFS VFS: default security mechanism requested.  The default security mechanism will be upgraded from ntlm to ntlmv2 in kernel release 2.6.41
[   55.499858] ------------[ cut here ]------------
[   55.501683] kernel BUG at /home/hch/work/linux-2.6/mm/slab.c:501!
[   55.502109] invalid opcode: 0000 [#1] SMP 
[   55.502109] CPU 0 
[   55.502109] Modules linked in:
[   55.502109] 
[   55.502109] Pid: 2129, comm: mount.cifs Not tainted 2.6.39+ #164 Bochs Bochs
[   55.502109] RIP: 0010:[<ffffffff81135bf0>]  [<ffffffff81135bf0>] kfree+0x120/0x140
[   55.502109] RSP: 0018:ffff8800575bfc78  EFLAGS: 00010046
[   55.502109] RAX: ffff88005bf5d258 RBX: ffffffff81c9d757 RCX: ffff88005dbfc000
[   55.502109] RDX: 0000000000000000 RSI: 0000000000001c9d RDI: 0000000000000000
[   55.502109] RBP: ffff8800575bfc98 R08: ffe20016af0c0000 R09: ffff8800590796c0
[   55.502109] R10: ffff880059f35b60 R11: 0000000000000000 R12: 0000000000000286
[   55.502109] R13: ffffffff8131711d R14: ffff88005af44200 R15: 0000000000000000
[   55.502109] FS:  0000000000000000(0000) GS:ffff88005d800000(0063) knlGS:00000000f75ac8d0
[   55.502109] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[   55.502109] CR2: 00000000f7016100 CR3: 0000000059cca000 CR4: 00000000000006f0
[   55.502109] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   55.502109] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   55.502109] Process mount.cifs (pid: 2129, threadinfo ffff8800575be000, task ffff8800593401c0)
[   55.502109] Stack:
[   55.502109]  ffff880059c0be00 ffff88005abc3400 0000000000000000 ffff88005af44200
[   55.502109]  ffff8800575bfd58 ffffffff8131711d ffff880000000000 ffff8800575bfd08
[   55.502109]  ffff880059396140 ffff880059f35b60 ffff880059c0be88 ffff88005d51bdb9
[   55.502109] Call Trace:
[   55.502109]  [<ffffffff8131711d>] cifs_mount+0x7ad/0x2980
[   55.502109]  [<ffffffff81308d44>] cifs_do_mount+0xf4/0x310
[   55.502109]  [<ffffffff8113d84b>] mount_fs+0x1b/0xd0
[   55.502109]  [<ffffffff811565ee>] vfs_kern_mount+0x5e/0xd0
[   55.502109]  [<ffffffff81156a2f>] do_kern_mount+0x4f/0x100
[   55.502109]  [<ffffffff81158436>] do_mount+0x436/0x790
[   55.502109]  [<ffffffff811050f2>] ? __get_free_pages+0x12/0x80
[   55.502109]  [<ffffffff8117e83f>] compat_sys_mount+0x12f/0x280
[   55.502109]  [<ffffffff81941225>] sysenter_dispatch+0x7/0x2b
[   55.502109] Code: 48 89 da 49 83 c4 10 4c 89 ee ff d0 49 8b 04 24 48 85 c0 75 e6 e9 08 ff ff ff 4c 89 ee 4c 89 f7 e8 06 fe ff ff 41 8b 45 00 eb 98 <0f> 0b 48 8b 40 10 e9 56 ff ff ff 48 8b 40 10 e9 41 ff ff ff 66 
[   55.502109] RIP  [<ffffffff81135bf0>] kfree+0x120/0x140
[   55.502109]  RSP <ffff8800575bfc78>
[   55.502109] ---[ end trace 7876191bfcd639e3 ]---
