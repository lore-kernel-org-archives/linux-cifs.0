From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs: panic in crypto_shash_init
Date: Mon, 30 Aug 2010 21:15:33 -0400
Message-ID: <20100830211533.3392980c@corrin.poochiereds.net>
References: <20100830123510.30ed304f@tlielax.poochiereds.net>
	<AANLkTimmdCrMsYxB3tUa6MiLZ4sMmv_3hEn5Er2tpiw+@mail.gmail.com>
	<20100830133857.05b3c128@tlielax.poochiereds.net>
	<AANLkTi=DSoRyA5ndqyxjU0_2T4krArT=upz=BcmeFB9L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=DSoRyA5ndqyxjU0_2T4krArT=upz=BcmeFB9L-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 30 Aug 2010 12:42:44 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Aug 30, 2010 at 12:38 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > On Mon, 30 Aug 2010 11:49:04 -0500
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Mon, Aug 30, 2010 at 11:35 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =
wrote:
> >> > Testing recent kernel based on Steve's current tree (with the mu=
ltiuser
> >> > patchset on top). At unmount, I just got this panic. Known bug?
> >> >
> >> > fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 29 with ui=
d: 0
> >> > fs/cifs/cifssmb.c: In tree disconnect
> >> > fs/cifs/transport.c: For smb_command 113
> >> > general protection fault: 0000 [#1] SMP
> >> > last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/share=
d_cpu_map
> >> > CPU 1
> >> > Modules linked in: nls_utf8 cifs fscache nfsd lockd nfs_acl expo=
rtfs rpcsec_gss_krb5 auth_rpcgss des_generic sunrpc microcode virtio_ne=
t joydev virtio_balloon i2c_piix4 i2c_core ipv6 virtio_blk virtio_pci v=
irtio_ring virtio [last unloaded: cifs]
> >> >
> >> > Pid: 2197, comm: umount Not tainted 2.6.36-0.10.rc2.git4.fc15.x8=
6_64 #1 /
> >> > RIP: 0010:[<ffffffffa02eb048>] =A0[<ffffffffa02eb048>] crypto_sh=
ash_init+0xc/0x15 [cifs]
> >> > RSP: 0018:ffff88003c2a5be8 =A0EFLAGS: 00010286
> >> > RAX: 6b6b6b6b6b6b6b6b RBX: ffff88003d3e5158 RCX: ffff88003bcaf19=
4
> >> > RDX: 00000000010e010d RSI: 0000000000000001 RDI: ffff88003e2f4bb=
8
> >> > RBP: ffff88003c2a5be8 R08: ffff88003bdf06c0 R09: ffff88003c2a5bb=
8
> >> > R10: ffffffffa0302d58 R11: 0000000000000000 R12: ffff88003c2a5ce=
8
> >> > R13: 0000000000000001 R14: ffff88003bdf06c0 R15: 00000000ffffffe=
a
> >> > FS: =A000007f12c4ad1760(0000) GS:ffff880004800000(0000) knlGS:00=
00000000000000
> >> > CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >> > CR2: 000000000264a068 CR3: 0000000039e67000 CR4: 00000000000006e=
0
> >> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000000=
0
> >> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000000040=
0
> >> > Process umount (pid: 2197, threadinfo ffff88003c2a4000, task fff=
f88003e6b48a0)
> >> > Stack:
> >> > =A0ffff88003c2a5c58 ffffffffa02eb338 ffff88003c2a5ca0 ffff88003b=
caf194
> >> > <0> ffff88003c2a5c28 ffffffff8149b6b7 ffff88003d3e5158 000000000=
ff1c636
> >> > <0> ffff88003c2a5c58 ffff88003ab29b60 0000000000000000 000000000=
0000000
> >> > Call Trace:
> >> > =A0[<ffffffffa02eb338>] cifs_sign_smb2+0xce/0x1da [cifs]
> >> > =A0[<ffffffff8149b6b7>] ? _raw_spin_unlock+0x2b/0x2f
> >> > =A0[<ffffffffa02e758d>] SendReceive2+0x11f/0x438 [cifs]
> >> > =A0[<ffffffffa02e78d9>] SendReceiveNoRsp+0x33/0x35 [cifs]
> >> > =A0[<ffffffffa02cda85>] CIFSSMBTDis+0x90/0xd2 [cifs]
> >> > =A0[<ffffffffa02d6562>] cifs_put_tcon+0xda/0x102 [cifs]
> >> > =A0[<ffffffffa02d7ee6>] cifs_put_tlink+0x4f/0x5c [cifs]
> >> > =A0[<ffffffffa02d8b59>] cifs_umount+0xa0/0xdc [cifs]
> >> > =A0[<ffffffff8149b7b9>] ? _lock_kernel+0x84/0x9c
> >> > =A0[<ffffffffa02cc7a1>] cifs_put_super+0x84/0xf7 [cifs]
> >> > =A0[<ffffffff8112c659>] generic_shutdown_super+0x5b/0xe1
> >> > =A0[<ffffffff8112c734>] kill_anon_super+0x16/0x54
> >> > =A0[<ffffffff8112c981>] deactivate_locked_super+0x26/0x46
> >> > =A0[<ffffffff8112d4d1>] deactivate_super+0x3a/0x3e
> >> > =A0[<ffffffff81142050>] mntput_no_expire+0xa7/0xd3
> >> > =A0[<ffffffff81142b91>] sys_umount+0x2cf/0x301
> >> > =A0[<ffffffff81133787>] ? path_put+0x22/0x27
> >> > =A0[<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b
> >> > Code: c3 90 90 55 48 89 e5 0f 1f 44 00 00 83 c8 ff 48 ff cf 48 c=
1 ef 0b ff c0 48 d1 ef 75 f9 c9 c3 55 48 89 e5 0f 1f 44 00 00 48 8b 07 =
<48> 8b 40 58 ff 50 b0 c9 c3 55 48 89 e5 41 56 41 55 41 54 53 0f
> >> > RIP =A0[<ffffffffa02eb048>] crypto_shash_init+0xc/0x15 [cifs]
> >> > =A0RSP <ffff88003c2a5be8>
> >> > ---[ end trace 14b58c65d94d711c ]---
> >> > Kernel panic - not syncing: Fatal exception
> >> > Pid: 2197, comm: umount Tainted: G =A0 =A0 =A0D =A0 =A0 2.6.36-0=
=2E10.rc2.git4.fc15.x86_64 #1
> >> > Call Trace:
> >> > =A0[<ffffffff814985ec>] panic+0x91/0x1a7
> >> > =A0[<ffffffff81052850>] ? kmsg_dump+0x149/0x165
> >> > =A0[<ffffffff8149c94b>] oops_end+0xb7/0xc7
> >> > =A0[<ffffffff8100d77c>] die+0x5a/0x66
> >> > =A0[<ffffffff8149c2fa>] do_general_protection+0x133/0x13b
> >> > =A0[<ffffffff8149ba40>] ? irq_return+0x0/0x10
> >> > =A0[<ffffffff8149bc65>] general_protection+0x25/0x30
> >> > =A0[<ffffffffa02eb048>] ? crypto_shash_init+0xc/0x15 [cifs]
> >> > =A0[<ffffffffa02eb338>] cifs_sign_smb2+0xce/0x1da [cifs]
> >> > =A0[<ffffffff8149b6b7>] ? _raw_spin_unlock+0x2b/0x2f
> >> > =A0[<ffffffffa02e758d>] SendReceive2+0x11f/0x438 [cifs]
> >> > =A0[<ffffffffa02e78d9>] SendReceiveNoRsp+0x33/0x35 [cifs]
> >> > =A0[<ffffffffa02cda85>] CIFSSMBTDis+0x90/0xd2 [cifs]
> >> > =A0[<ffffffffa02d6562>] cifs_put_tcon+0xda/0x102 [cifs]
> >> > =A0[<ffffffffa02d7ee6>] cifs_put_tlink+0x4f/0x5c [cifs]
> >> > =A0[<ffffffffa02d8b59>] cifs_umount+0xa0/0xdc [cifs]
> >> > =A0[<ffffffff8149b7b9>] ? _lock_kernel+0x84/0x9c
> >> > =A0[<ffffffffa02cc7a1>] cifs_put_super+0x84/0xf7 [cifs]
> >> > =A0[<ffffffff8112c659>] generic_shutdown_super+0x5b/0xe1
> >> > =A0[<ffffffff8112c734>] kill_anon_super+0x16/0x54
> >> > =A0[<ffffffff8112c981>] deactivate_locked_super+0x26/0x46
> >> > =A0[<ffffffff8112d4d1>] deactivate_super+0x3a/0x3e
> >> > =A0[<ffffffff81142050>] mntput_no_expire+0xa7/0xd3
> >> > =A0[<ffffffff81142b91>] sys_umount+0x2cf/0x301
> >> > =A0[<ffffffff81133787>] ? path_put+0x22/0x27
> >> > =A0[<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b
> >> >
> >> >
> >> > --
> >> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> >
> >>
> >>
> >> Jeff, never saw this oops while unmounting a share but I do nothav=
e
> >> multiuser mount code.
> >> It is possible that sdescmd5 was freed.
> >>
> >
> > This code is clearly broken. You have this:
> >
> > =A0 =A0int cifs_crypto_shash_allocate(struct TCP_Server_Info *serve=
r)
> >
> > It's called from cifs_get_smb_ses, and it sets up some stuff that h=
angs
> > off the TCP_Server_Info struct. That implies that this stuff is
> > intended to be shared by any SMB session that's riding on this sock=
et.
> >
> > Then, you call cifs_crypto_shash_release from cifs_put_smb_ses. So =
the
> > stuff that you allocated before is being freed whenever the *first*=
 SMB
> > session on the socket is dropped. As soon as someone tries to send
> > another frame using a different SMB session, then you'll be using t=
he
> > now-released shash.
> >
> > Perhaps we should revert this patch until this code has been better
> > tested and reviewed? Breaking this patch up into smaller changes as=
 I
> > requested before would make it easier to do that.
>=20
> Let's look at how hard it is to fix first, and give Shirish a few day=
s on this.
> In general the kernel crypto APIs should be safer than our own implem=
entation
> was, and if this turns out to be easy/obvious to fix we have enough t=
ime.
>=20

I agree that using the kernel crypto APIs are the right approach. My
concern is that the patch Shirish posted is too large to be effectively
reviewed. Hence, it was not adequately reviewed before being merged.

We might fix this bug, but how many others are lurking in there? We'll
never know until someone trips over them. That's not the way to mange a
successful software project.

Please, back out this patch and have Shirish re-post it as a set of
distinct changes so we can review the design and implementation.
There's no rush for this code. Let's take our time and make sure this
is correct.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
