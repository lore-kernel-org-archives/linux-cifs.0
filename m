From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 14 Mar 2012 14:30:23 -0500
Message-ID: <CAH2r5muUm-E5n6Le4JPnBZmKNJ46OJ8dYZdS9b79=O3UGif4Rg@mail.gmail.com>
References: <4F5A2CCD.6010808@gmail.com>
	<24dc471d-42ca-45cf-89eb-26dc3117fa1a@zmail17.collab.prod.int.phx2.redhat.com>
	<20120314151811.65838f6b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120314151811.65838f6b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I don't mind reviewing this, but it does appear to change behaviour
significantly from existing code.  Does this fix a reported bug?

The linux cifs kernel driver, like some other
network clients, allows partial option matching to ease
usability for users of other platforms (e.g. "pass" or
"passwd" or "password" are intentionally all accepted
since we match on the first four bytes of that keyword).
Is there a way to get that to work with your patchset.
I worry that some users will be confused that their
mount options won't work if this is taken.

On Wed, Mar 14, 2012 at 2:18 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 14 Mar 2012 14:17:26 -0400 (EDT)
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Thanks Scott,
>>
>> Steve/Jeff, can I get your comments on this patch please.
>>
>> Sachin Prabhu
>>
>
> Does it address the oops that we saw with Scott's patch? Here's what =
I
> wrote when I hit that oops before.
>
> ----------------------------[snip]---------------------------
>
> Finally got around to trying this out and I get the following oops wh=
en
> mounting a share with these options:
>
> =A0 =A0sec=3Dkrb5i,multises,noauto
>
> general protection fault: 0000 [#1] SMP
> last sysfs file: /sys/devices/virtual/bdi/cifs-1/uevent
> CPU 0
> Modules linked in: cifs nfsd lockd nfs_acl exportfs rpcsec_gss_krb5 a=
uth_rpcgss des_generic sunrpc ipv6 microcode i2c_piix4 i2c_core virtio_=
net joydev virtio_balloon virtio_blk virtio_pci virtio_ring virtio [las=
t unloaded: mperf]
>
> Pid: 1542, comm: mount.cifs Not tainted 2.6.35-0.2.rc3.git0.fc14.x86_=
64 #1 /
> RIP: 0010:[<ffffffff8123728c>] =A0[<ffffffff8123728c>] strchr+0x14/0x=
1d
> RSP: 0018:ffff880039a65bd8 =A0EFLAGS: 00010246
> RAX: 7365735f626d735f RBX: 0000000000000000 RCX: ffff88003cb4d041
> RDX: ffff880039a65c6d RSI: 0000000000000025 RDI: 7365735f626d735f
> RBP: ffff880039a65bd8 R08: 000000000000002c R09: 000000000000002c
> R10: 00000000000080d0 R11: ffffffff8113bc6c R12: ffff88003cb4d041
> R13: ffffffffa0219d40 R14: 0000000000000000 R15: 7365735f626d735f
> FS: =A000007f1fbcba6720(0000) GS:ffff880004600000(0000) knlGS:0000000=
000000000
> CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000001a31818 CR3: 000000003a287000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount.cifs (pid: 1542, threadinfo ffff880039a64000, task ffff=
880039adc8a0)
> Stack:
> =A0ffff880039a65c48 ffffffff8123b1ee ffff88003a18b990 ffff880039a65cd=
8
> <0> ffff88003cb4d041 ffffffff8111cd42 ffffffffa0202f86 7365735f626d73=
5f
> <0> ffff88003997de30 ffff88003997de30 ffff88003cc94840 00000000ffffff=
ff
> Call Trace:
> =A0[<ffffffff8123b1ee>] match_token+0x4b/0x1a8
> =A0[<ffffffff8111cd42>] ? __kmalloc+0x17c/0x18e
> =A0[<ffffffffa0202f86>] ? cifs_mount+0x639/0x1737 [cifs]
> =A0[<ffffffffa0202c11>] cifs_mount+0x2c4/0x1737 [cifs]
> =A0[<ffffffffa01f5aa4>] ? cifs_get_sb+0x110/0x2e4 [cifs]
> =A0[<ffffffffa01f5b00>] cifs_get_sb+0x16c/0x2e4 [cifs]
> =A0[<ffffffff8112c946>] vfs_kern_mount+0xbd/0x19b
> =A0[<ffffffff8112ca8c>] do_kern_mount+0x4d/0xed
> =A0[<ffffffff8114368a>] do_mount+0x776/0x7ed
> =A0[<ffffffff811128aa>] ? alloc_pages_current+0xa7/0xca
> =A0[<ffffffff81143789>] sys_mount+0x88/0xc2
> =A0[<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
> Code: 14 84 c0 74 0e 48 ff c7 48 ff c6 48 ff ca 48 85 d2 75 e1 31 c0 =
c9 c3 55 48 89 f8 48 89 e5 eb 0b 84 d2 75 04 31 c0 eb 0a 48 ff c0 <8a> =
10 40 38 f2 75 ee c9 c3 55 48 89 f8 48 89 e5 eb 03 48 ff c0
> RIP =A0[<ffffffff8123728c>] strchr+0x14/0x1d
> =A0RSP <ffff880039a65bd8>
> ---[ end trace 50d173d44b64b1d9 ]---
>
> It's crashing in this match_token() call:
>
> gdb) list *(cifs_mount+0x2c4)
> 0xdcf7 is in cifs_mount (fs/cifs/connect.c:1094).
> 1089 =A0 =A0 =A0 =A0 =A0 =A0while ((data =3D strsep(&options, separat=
or)) !=3D NULL) {
> 1090 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!*data)
> 1091 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> 1092 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((value =3D strchr(dat=
a, '=3D')) !=3D NULL)
> 1093 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*value++ =
=3D '\0';
> 1094 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (match_token(data,=
 cifs_mount_options, args)) {
> 1095 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_user_xattr:
> 1096 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->no_x=
attr =3D 0;
> 1097 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> 1098 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_nouser_xattr:
> (gdb) quit
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Thanks,

Steve
