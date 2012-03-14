From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 14 Mar 2012 15:58:04 -0400 (EDT)
Message-ID: <90445c03-bbcc-4faf-afbf-fde4b1d17f05@zmail17.collab.prod.int.phx2.redhat.com>
References: <CAH2r5muUm-E5n6Le4JPnBZmKNJ46OJ8dYZdS9b79=O3UGif4Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muUm-E5n6Le4JPnBZmKNJ46OJ8dYZdS9b79=O3UGif4Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

----- Original Message -----
> I don't mind reviewing this, but it does appear to change behaviour
> significantly from existing code.  Does this fix a reported bug?
>=20
> The linux cifs kernel driver, like some other
> network clients, allows partial option matching to ease
> usability for users of other platforms (e.g. "pass" or
> "passwd" or "password" are intentionally all accepted
> since we match on the first four bytes of that keyword).
> Is there a way to get that to work with your patchset.
> I worry that some users will be confused that their
> mount options won't work if this is taken.
>=20

The reason I was looking at this code was because I was helping Jeff in=
clude in the sloppy mount option for cifs. The current if/elseif block =
is difficult to read through. There are also hidden gotchas like orderi=
ng the if blocks correctly if in case a mount option is also a substrin=
g in a different mount option. The decision to use the standard token p=
arser was simply for consistency and to make the code easier to underst=
and.

Multiple versions of mount options can be accepted for the same mount o=
ption. For example, in the patch sent earlier, for the password, we acc=
ept the following mount options to pass the password.


+       { Opt_pass, "pass=3D%s" },
+       { Opt_pass, "password=3D%s" },

So the user can use pass or password and they will both be accepted as =
the mount option to set the password.
We can add more options if I have missed any.

The only difference I see is that the options matching is case sensitiv=
e and therefore will reject upper case mount options.

Also, in my opinion the number of mount options is large at the moment =
and we should consider deprecating a few of the mount options.=20
=20
Sachin Prabhu


> On Wed, Mar 14, 2012 at 2:18 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > On Wed, 14 Mar 2012 14:17:26 -0400 (EDT)
> > Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> >> Thanks Scott,
> >>
> >> Steve/Jeff, can I get your comments on this patch please.
> >>
> >> Sachin Prabhu
> >>
> >
> > Does it address the oops that we saw with Scott's patch? Here's
> > what I
> > wrote when I hit that oops before.
> >
> > ----------------------------[snip]---------------------------
> >
> > Finally got around to trying this out and I get the following oops
> > when
> > mounting a share with these options:
> >
> > =C2=A0 =C2=A0sec=3Dkrb5i,multises,noauto
> >
> > general protection fault: 0000 [#1] SMP
> > last sysfs file: /sys/devices/virtual/bdi/cifs-1/uevent
> > CPU 0
> > Modules linked in: cifs nfsd lockd nfs_acl exportfs rpcsec_gss_krb5
> > auth_rpcgss des_generic sunrpc ipv6 microcode i2c_piix4 i2c_core
> > virtio_net joydev virtio_balloon virtio_blk virtio_pci virtio_ring
> > virtio [last unloaded: mperf]
> >
> > Pid: 1542, comm: mount.cifs Not tainted
> > 2.6.35-0.2.rc3.git0.fc14.x86_64 #1 /
> > RIP: 0010:[<ffffffff8123728c>] =C2=A0[<ffffffff8123728c>]
> > strchr+0x14/0x1d
> > RSP: 0018:ffff880039a65bd8 =C2=A0EFLAGS: 00010246
> > RAX: 7365735f626d735f RBX: 0000000000000000 RCX: ffff88003cb4d041
> > RDX: ffff880039a65c6d RSI: 0000000000000025 RDI: 7365735f626d735f
> > RBP: ffff880039a65bd8 R08: 000000000000002c R09: 000000000000002c
> > R10: 00000000000080d0 R11: ffffffff8113bc6c R12: ffff88003cb4d041
> > R13: ffffffffa0219d40 R14: 0000000000000000 R15: 7365735f626d735f
> > FS: =C2=A000007f1fbcba6720(0000) GS:ffff880004600000(0000)
> > knlGS:0000000000000000
> > CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000001a31818 CR3: 000000003a287000 CR4: 00000000000006f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process mount.cifs (pid: 1542, threadinfo ffff880039a64000, task
> > ffff880039adc8a0)
> > Stack:
> > =C2=A0ffff880039a65c48 ffffffff8123b1ee ffff88003a18b990
> > =C2=A0ffff880039a65cd8
> > <0> ffff88003cb4d041 ffffffff8111cd42 ffffffffa0202f86
> > 7365735f626d735f
> > <0> ffff88003997de30 ffff88003997de30 ffff88003cc94840
> > 00000000ffffffff
> > Call Trace:
> > =C2=A0[<ffffffff8123b1ee>] match_token+0x4b/0x1a8
> > =C2=A0[<ffffffff8111cd42>] ? __kmalloc+0x17c/0x18e
> > =C2=A0[<ffffffffa0202f86>] ? cifs_mount+0x639/0x1737 [cifs]
> > =C2=A0[<ffffffffa0202c11>] cifs_mount+0x2c4/0x1737 [cifs]
> > =C2=A0[<ffffffffa01f5aa4>] ? cifs_get_sb+0x110/0x2e4 [cifs]
> > =C2=A0[<ffffffffa01f5b00>] cifs_get_sb+0x16c/0x2e4 [cifs]
> > =C2=A0[<ffffffff8112c946>] vfs_kern_mount+0xbd/0x19b
> > =C2=A0[<ffffffff8112ca8c>] do_kern_mount+0x4d/0xed
> > =C2=A0[<ffffffff8114368a>] do_mount+0x776/0x7ed
> > =C2=A0[<ffffffff811128aa>] ? alloc_pages_current+0xa7/0xca
> > =C2=A0[<ffffffff81143789>] sys_mount+0x88/0xc2
> > =C2=A0[<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
> > Code: 14 84 c0 74 0e 48 ff c7 48 ff c6 48 ff ca 48 85 d2 75 e1 31
> > c0 c9 c3 55 48 89 f8 48 89 e5 eb 0b 84 d2 75 04 31 c0 eb 0a 48 ff
> > c0 <8a> 10 40 38 f2 75 ee c9 c3 55 48 89 f8 48 89 e5 eb 03 48 ff
> > c0
> > RIP =C2=A0[<ffffffff8123728c>] strchr+0x14/0x1d
> > =C2=A0RSP <ffff880039a65bd8>
> > ---[ end trace 50d173d44b64b1d9 ]---
> >
> > It's crashing in this match_token() call:
> >
> > gdb) list *(cifs_mount+0x2c4)
> > 0xdcf7 is in cifs_mount (fs/cifs/connect.c:1094).
> > 1089 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while ((data =3D strs=
ep(&options, separator)) !=3D
> > NULL) {
> > 1090 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (!*data)
> > 1091 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;
> > 1092 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if ((value =3D strchr(data, '=3D')) !=3D NULL)
> > 1093 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*value++ =3D '\0';
> > 1094 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0switch (match_token(data,
> > cifs_mount_options, args)) {
> > 1095 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0case Opt_user_xattr:
> > 1096 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vol->no_xattr =3D 0;
> > 1097 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> > 1098 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0case Opt_nouser_xattr:
> > (gdb) quit
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
>=20
>=20
> --
> Thanks,
>=20
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
