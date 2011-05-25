From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: guest mount crashes current git HEAD
Date: Wed, 25 May 2011 08:46:56 -0500
Message-ID: <BANLkTim7dUKNxfHFrb1v2Ebt0WUvKDr8_w@mail.gmail.com>
References: <20110525132755.GA21369@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110525132755.GA21369-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel made a fix (now applied to cifs-2.6.git)

Author: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Date:   Wed May 25 13:35:34 2011 +0400

    CIFS: Fix undefined behavior when mount fails


On Wed, May 25, 2011 at 8:27 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
> Trying to mount a local shared in my VM I can trivially crash cifs:
>
> qemu1:~# mount -t cifs 127.0.0.1:test /mnt/scratch/ -o guest
> [ =A0 55.477707] CIFS VFS: default security mechanism requested. =A0T=
he default security mechanism will be upgraded from ntlm to ntlmv2 in k=
ernel release 2.6.41
> [ =A0 55.499858] ------------[ cut here ]------------
> [ =A0 55.501683] kernel BUG at /home/hch/work/linux-2.6/mm/slab.c:501=
!
> [ =A0 55.502109] invalid opcode: 0000 [#1] SMP
> [ =A0 55.502109] CPU 0
> [ =A0 55.502109] Modules linked in:
> [ =A0 55.502109]
> [ =A0 55.502109] Pid: 2129, comm: mount.cifs Not tainted 2.6.39+ #164=
 Bochs Bochs
> [ =A0 55.502109] RIP: 0010:[<ffffffff81135bf0>] =A0[<ffffffff81135bf0=
>] kfree+0x120/0x140
> [ =A0 55.502109] RSP: 0018:ffff8800575bfc78 =A0EFLAGS: 00010046
> [ =A0 55.502109] RAX: ffff88005bf5d258 RBX: ffffffff81c9d757 RCX: fff=
f88005dbfc000
> [ =A0 55.502109] RDX: 0000000000000000 RSI: 0000000000001c9d RDI: 000=
0000000000000
> [ =A0 55.502109] RBP: ffff8800575bfc98 R08: ffe20016af0c0000 R09: fff=
f8800590796c0
> [ =A0 55.502109] R10: ffff880059f35b60 R11: 0000000000000000 R12: 000=
0000000000286
> [ =A0 55.502109] R13: ffffffff8131711d R14: ffff88005af44200 R15: 000=
0000000000000
> [ =A0 55.502109] FS: =A00000000000000000(0000) GS:ffff88005d800000(00=
63) knlGS:00000000f75ac8d0
> [ =A0 55.502109] CS: =A00010 DS: 002b ES: 002b CR0: 000000008005003b
> [ =A0 55.502109] CR2: 00000000f7016100 CR3: 0000000059cca000 CR4: 000=
00000000006f0
> [ =A0 55.502109] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> [ =A0 55.502109] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
> [ =A0 55.502109] Process mount.cifs (pid: 2129, threadinfo ffff880057=
5be000, task ffff8800593401c0)
> [ =A0 55.502109] Stack:
> [ =A0 55.502109] =A0ffff880059c0be00 ffff88005abc3400 000000000000000=
0 ffff88005af44200
> [ =A0 55.502109] =A0ffff8800575bfd58 ffffffff8131711d ffff88000000000=
0 ffff8800575bfd08
> [ =A0 55.502109] =A0ffff880059396140 ffff880059f35b60 ffff880059c0be8=
8 ffff88005d51bdb9
> [ =A0 55.502109] Call Trace:
> [ =A0 55.502109] =A0[<ffffffff8131711d>] cifs_mount+0x7ad/0x2980
> [ =A0 55.502109] =A0[<ffffffff81308d44>] cifs_do_mount+0xf4/0x310
> [ =A0 55.502109] =A0[<ffffffff8113d84b>] mount_fs+0x1b/0xd0
> [ =A0 55.502109] =A0[<ffffffff811565ee>] vfs_kern_mount+0x5e/0xd0
> [ =A0 55.502109] =A0[<ffffffff81156a2f>] do_kern_mount+0x4f/0x100
> [ =A0 55.502109] =A0[<ffffffff81158436>] do_mount+0x436/0x790
> [ =A0 55.502109] =A0[<ffffffff811050f2>] ? __get_free_pages+0x12/0x80
> [ =A0 55.502109] =A0[<ffffffff8117e83f>] compat_sys_mount+0x12f/0x280
> [ =A0 55.502109] =A0[<ffffffff81941225>] sysenter_dispatch+0x7/0x2b
> [ =A0 55.502109] Code: 48 89 da 49 83 c4 10 4c 89 ee ff d0 49 8b 04 2=
4 48 85 c0 75 e6 e9 08 ff ff ff 4c 89 ee 4c 89 f7 e8 06 fe ff ff 41 8b =
45 00 eb 98 <0f> 0b 48 8b 40 10 e9 56 ff ff ff 48 8b 40 10 e9 41 ff ff =
ff 66
> [ =A0 55.502109] RIP =A0[<ffffffff81135bf0>] kfree+0x120/0x140
> [ =A0 55.502109] =A0RSP <ffff8800575bfc78>
> [ =A0 55.502109] ---[ end trace 7876191bfcd639e3 ]---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
