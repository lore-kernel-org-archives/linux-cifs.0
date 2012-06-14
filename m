From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs fails on v3.5
Date: Thu, 14 Jun 2012 14:47:14 +0400
Message-ID: <CAKywueThq0Pgg7rqy1rM69+NT8Cj40Ms01q7SBUW0owKu3kNuw@mail.gmail.com>
References: <CAKywueS=iWT21dvx8z2Yrp_ZHMAaHwZgckgFXDoctk1y=ov+JA@mail.gmail.com>
	<20120614063932.5be8d8f5@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120614063932.5be8d8f5-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/14 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 14 Jun 2012 14:29:38 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I upgraded the kernel to v3.5-rc2 on my Ubuntu (from
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/) and faced with the
>> problem: if I build the module and load it (even without any using o=
f
>> it) I can't unload it with 'module is busy' message. Sometimes the
>> rmmod command returns with 'Killed' and I get this in dmesg:
>>
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849739] BUG: unable to
>> handle kernel paging request at 35af7004
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849765] IP: [<c109f965>=
]
>> module_refcount+0x25/0x90
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849775] *pdpt =3D
>> 000000002c8d8001 *pde =3D 0000000000000000
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849786] Oops: 0000 [#1]=
 SMP
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849816] Modules linked =
in:
>> cifs(O) fscache binfmt_misc snd_hda_codec_realtek snd_hd
>> a_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
>> snd_seq_midi_event snd_seq snd_timer snd_seq_device snd nouve
>> au ttm drm_kms_helper drm i2c_algo_bit kvm_amd mxm_wmi soundcore vid=
eo
>> snd_page_alloc kvm i2c_nforce2 wmi k8temp serio_raw mac
>> _hid ppdev parport_pc lp parport floppy skge pata_amd sata_nv
>> forcedeth [last unloaded: cifs]
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849854]
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849865] Pid: 3180, comm=
:
>> rmmod Tainted: G =A0 =A0 =A0 =A0 =A0 O 3.5.0-030500rc2-generic #2012
>> 06082235 MSI MS-7309/MS-7309
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849877] EIP:
>> 0060:[<c109f965>] EFLAGS: 00010293 CPU: 0
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849887] EIP is at
>> module_refcount+0x25/0x90
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849894] EAX: 00000000 E=
BX:
>> ecbe21e0 ECX: 35af7000 EDX: 00000000
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849903] ESI: 00000000 E=
DI:
>> fa0be780 EBP: f5801ec4 ESP: f5801eb8
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849912] =A0DS: 007b ES:=
 007b
>> FS: 00d8 GS: 00e0 SS: 0068
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849920] CR0: 8005003b C=
R2:
>> 35af7004 CR3: 2c8a0000 CR4: 000007f0
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849929] DR0: 00000000 D=
R1:
>> 00000000 DR2: 00000000 DR3: 00000000
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849937] DR6: ffff0ff0 D=
R7: 00000400
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849945] Process rmmod (=
pid:
>> 3180, ti=3Df5800000 task=3Df6c7a5e0 task.ti=3Df5800000)
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849954] Stack:
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849965] =A0ecbe21e0 ecb=
e21e0
>> fa0be784 f5801efc c109fa28 ecbe21e0 c177e6da fa0be78c
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849978] =A00004321e fa0=
be780
>> fa0be784 f5801f20 ecbe21e0 20bfff3c fffffff4 ecbe21e0
>> Jun 14 13:30:10 workstation kernel: [ =A0527.849992] =A0fa0be784 f58=
01f3c
>> c116ab35 00000000 00000000 b7791000 ecbe2208 00000400
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850001] Call Trace:
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850010] =A0[<c109fa28>]
>> m_show+0x58/0x1b0
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850020] =A0[<c116ab35>]
>> seq_read+0x145/0x380
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850029] =A0[<c116a9f0>]=
 ?
>> seq_lseek+0x170/0x170
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850040] =A0[<c119c2a4>]
>> proc_reg_read+0x64/0xa0
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850053] =A0[<c114dd5c>]
>> vfs_read+0x8c/0x160
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850061] =A0[<c119c240>]=
 ?
>> proc_reg_write+0xa0/0xa0
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850071] =A0[<c114de6d>]
>> sys_read+0x3d/0x70
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850081] =A0[<c15cf89f>]
>> sysenter_do_call+0x12/0x28
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850120] Code: 5b 5d c3 =
8d
>> 76 00 55 89 e5 57 56 53 3e 8d 74 26 00 31 f6 89 c7 b8 ff
>> ff ff ff eb 13 66 90 8b 0c 85 a0 c6 8a c1 8b 97 78 01 00 00 <03> 74 =
0a
>> 04 8d 48 01 a1 0c 59 5d c1 ba 08 00 00 00 e8 f5 ad 22
>> Jun 14 13:30:10 workstation kernel: [ =A0527.850567] EIP: [<c109f965=
>]
>> module_refcount+0x25/0x90 SS:ESP 0068:f5801eb8
>>
>>
>> Another thing I noticed is /proc/fs/cifs/traceSMB is set to some big
>> negative value - very strange.
>>
>> If I use the module from the package everything is ok. Also with all
>> previous kernels everything goes fine too.
>>
>> Any thoughts on what can be broken in v3.5 from v3.4?
>>
>> fyi: v3.5-rc2 doesn't make any difference.
>>
>
> Sounds sort of like the kabi got borked.
>
> So were you patching the sources that were used to build the original
> module? Or are you building from a different tree altogether? If it's
> the latter, then most likely there's a difference that breaks the
> kernel's ABI.
>

I just checkout'ed v3.5-rc2 commit and build it with kernel-headers
from Ubuntu package (as I usually do).

> Maybe try building another module altogether and see if you get the
> same result. In any case, you might want to try building an entire
> kernel and see if the problem goes away.

Ok - will try, thanks.

--=20
Best regards,
Pavel Shilovsky.
