From: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: 3.3.0-rc2+: oops went mounting via cifs
Date: Thu, 2 Feb 2012 16:21:16 +0000
Message-ID: <201202021621.16500.chris2553@googlemail.com>
References: <CAGGLNVgbJSRsb5S_3ZF64LzE8yhTWHHQ_xvPoEiKdkdMZAakZQ@mail.gmail.com> <CADT32eJGV2LwTaqB7eUCpBv-hyUxtFdPsk7N_2g92yG4KoVruw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJGV2LwTaqB7eUCpBv-hyUxtFdPsk7N_2g92yG4KoVruw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thursday 02 February 2012 15:38:47 Shirish Pargaonkar wrote:
> On Thu, Feb 2, 2012 at 9:20 AM, Chris Clayton <chris2553@googlemail.c=
om> wrote:
> > Hi.
> > I'm not subscribed, so please cc me on any replies.
> >
> > I'm getting an oops when trying to mount a FAT32 partition hosted o=
n
> > another machine on my home network. The kernel is built from a pull=
 of
> > from kernel.org this morning. "git describe" gives
> > v3.3-rc2-37-gbd3ce7d.
> >
> > The oops message is:
> >
> > CIFS VFS: default security mechanism requested. =A0The default secu=
rity
> > mechanism will be upgraded from ntlm to ntlmv2in kernel release 3.3
> > BUG: unable to handle kernel NULL pointer dereference at =A0 (null)
> > IP: [<c116b146>] strnlen+0x6/0x20
> > *pdpt =3D 0000000033f0c001 *pde =3D 0000000000000000
> > Oops: 0000 [#1] PREEMPT SMP
> > Modules linked in: md4 cifs ipt_LOG xt_state iptable_filter
> > ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> > nf_conntrack psmouse r8169 [last unloaded: microcode]
> >
> > Pid: 811, comm: mount.cifs Not tainted 3.3.0-rc2+ #94 Hewlett-Packa=
rd
> > HP G61 Notebook PC/3069
> > EIP: 0060:[<c116b146>] EFLAGS: 00010207 CPU: 0
> > EIP is at strnlen+0x6/0x20
> > EAX: 00000000 EBX: f31149ac ECX: 00000000 EDX: 000000ff
> > ESI: f32a1df4 EDI: f31149b0 EBP: f1a63830 ESP: f32a1d88
> > =A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > Process mount.cifs (pid: 811, ti=3Df32a0000 task=3Df1a78380 task.ti=
=3Df32a0000)
> > Stack:
> > =A0f943a9aa f3114900 9a734c2c 00000000 f1a63800 f943b64a f32a1df0 0=
0000001
> > =A0c1047be2 00000000 00000001 00000000 00000001 c1087bf1 f1bfc380 c=
14d9a80
> > =A000000000 00000007 00000001 f3da7a40 f45dc1c0 00000041 00000000 0=
0000000
> > Call Trace:
> > =A0[<f943a9aa>] ? ascii_ssetup_strings.isra.7+0x3a/0xd0 [cifs]
> > =A0[<f943b64a>] ? CIFS_SessSetup+0xc0a/0x115c [cifs]
> > =A0[<c1047be2>] ? __wake_up+0x42/0x60
> > =A0[<c1087bf1>] ? mempool_free+0x41/0xa0
> > =A0[<f941937a>] ? CIFSSMBNegotiate+0x1ca/0x750 [cifs]
> > =A0[<f9426b3d>] ? cifs_setup_session+0x4d/0x1b0 [cifs]
> > =A0[<f9426ac1>] ? cifs_negotiate_protocol+0x71/0xa0 [cifs]
> > =A0[<f9426fb6>] ? cifs_get_smb_ses+0x316/0x4d0 [cifs]
> > =A0[<f94271f7>] ? cifs_mount+0x87/0x5a0 [cifs]
> > =A0[<f94175f6>] ? cifs_do_mount+0x66/0x460 [cifs]
> > =A0[<c1097150>] ? kstrndup+0x40/0x60
> > =A0[<f9417617>] ? cifs_do_mount+0x87/0x460 [cifs]
> > =A0[<c10b8c0d>] ? mount_fs+0x1d/0xd0
> > =A0[<c10ce616>] ? alloc_vfsmnt+0x96/0x130
> > =A0[<c10ce8d1>] ? vfs_kern_mount+0x51/0xd0
> > =A0[<c10cecef>] ? do_kern_mount+0x3f/0xe0
> > =A0[<c10d03d4>] ? do_mount+0x474/0x730
> > =A0[<c1020d90>] ? vmalloc_sync_all+0x10/0x10
> > =A0[<c10d07a2>] ? sys_mount+0x72/0xb0
> > =A0[<c13b57d0>] ? sysenter_do_call+0x12/0x26
> > Code: 26 00 00 00 00 85 c9 57 89 c7 74 07 89 d0 f2 ae 75 01 4f 89 f=
8
> > 5f c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 0089 c1 89 c8 eb 06 <8=
0>
> > 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 c3 90 90 90 90 90 90
> > EIP: [<c116b146>] strnlen+0x6/0x20 SS:ESP 0068:f32a1d88
> > CR2: 0000000000000000
> > ---[ end trace 9f3a2989281718b5 ]---
> >
> > The full dmesg is attached, in case it helps.
> >
> > Let me know if I can help in any way to fix this.
> >
> > Chris
> >
> > --
> > The more I see, the more I know. The more I know, the less I
> > understand. Changing Man - Paul Weller
>
> Does this attached patch fix the oops?

Yes, that fixes it. Thanks for the speedy fix - very impressive!

Tested-by: Chris Clayton  <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>



--=20
The more I see, the more I know. The more I know, the less I understand=
=2E Changing Man - Paul Weller
