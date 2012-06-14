From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs fails on v3.5
Date: Thu, 14 Jun 2012 14:29:38 +0400
Message-ID: <CAKywueS=iWT21dvx8z2Yrp_ZHMAaHwZgckgFXDoctk1y=ov+JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I upgraded the kernel to v3.5-rc2 on my Ubuntu (from
http://kernel.ubuntu.com/~kernel-ppa/mainline/) and faced with the
problem: if I build the module and load it (even without any using of
it) I can't unload it with 'module is busy' message. Sometimes the
rmmod command returns with 'Killed' and I get this in dmesg:

Jun 14 13:30:10 workstation kernel: [  527.849739] BUG: unable to
handle kernel paging request at 35af7004
Jun 14 13:30:10 workstation kernel: [  527.849765] IP: [<c109f965>]
module_refcount+0x25/0x90
Jun 14 13:30:10 workstation kernel: [  527.849775] *pdpt =
000000002c8d8001 *pde = 0000000000000000
Jun 14 13:30:10 workstation kernel: [  527.849786] Oops: 0000 [#1] SMP
Jun 14 13:30:10 workstation kernel: [  527.849816] Modules linked in:
cifs(O) fscache binfmt_misc snd_hda_codec_realtek snd_hd
a_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd nouve
au ttm drm_kms_helper drm i2c_algo_bit kvm_amd mxm_wmi soundcore video
snd_page_alloc kvm i2c_nforce2 wmi k8temp serio_raw mac
_hid ppdev parport_pc lp parport floppy skge pata_amd sata_nv
forcedeth [last unloaded: cifs]
Jun 14 13:30:10 workstation kernel: [  527.849854]
Jun 14 13:30:10 workstation kernel: [  527.849865] Pid: 3180, comm:
rmmod Tainted: G           O 3.5.0-030500rc2-generic #2012
06082235 MSI MS-7309/MS-7309
Jun 14 13:30:10 workstation kernel: [  527.849877] EIP:
0060:[<c109f965>] EFLAGS: 00010293 CPU: 0
Jun 14 13:30:10 workstation kernel: [  527.849887] EIP is at
module_refcount+0x25/0x90
Jun 14 13:30:10 workstation kernel: [  527.849894] EAX: 00000000 EBX:
ecbe21e0 ECX: 35af7000 EDX: 00000000
Jun 14 13:30:10 workstation kernel: [  527.849903] ESI: 00000000 EDI:
fa0be780 EBP: f5801ec4 ESP: f5801eb8
Jun 14 13:30:10 workstation kernel: [  527.849912]  DS: 007b ES: 007b
FS: 00d8 GS: 00e0 SS: 0068
Jun 14 13:30:10 workstation kernel: [  527.849920] CR0: 8005003b CR2:
35af7004 CR3: 2c8a0000 CR4: 000007f0
Jun 14 13:30:10 workstation kernel: [  527.849929] DR0: 00000000 DR1:
00000000 DR2: 00000000 DR3: 00000000
Jun 14 13:30:10 workstation kernel: [  527.849937] DR6: ffff0ff0 DR7: 00000400
Jun 14 13:30:10 workstation kernel: [  527.849945] Process rmmod (pid:
3180, ti=f5800000 task=f6c7a5e0 task.ti=f5800000)
Jun 14 13:30:10 workstation kernel: [  527.849954] Stack:
Jun 14 13:30:10 workstation kernel: [  527.849965]  ecbe21e0 ecbe21e0
fa0be784 f5801efc c109fa28 ecbe21e0 c177e6da fa0be78c
Jun 14 13:30:10 workstation kernel: [  527.849978]  0004321e fa0be780
fa0be784 f5801f20 ecbe21e0 20bfff3c fffffff4 ecbe21e0
Jun 14 13:30:10 workstation kernel: [  527.849992]  fa0be784 f5801f3c
c116ab35 00000000 00000000 b7791000 ecbe2208 00000400
Jun 14 13:30:10 workstation kernel: [  527.850001] Call Trace:
Jun 14 13:30:10 workstation kernel: [  527.850010]  [<c109fa28>]
m_show+0x58/0x1b0
Jun 14 13:30:10 workstation kernel: [  527.850020]  [<c116ab35>]
seq_read+0x145/0x380
Jun 14 13:30:10 workstation kernel: [  527.850029]  [<c116a9f0>] ?
seq_lseek+0x170/0x170
Jun 14 13:30:10 workstation kernel: [  527.850040]  [<c119c2a4>]
proc_reg_read+0x64/0xa0
Jun 14 13:30:10 workstation kernel: [  527.850053]  [<c114dd5c>]
vfs_read+0x8c/0x160
Jun 14 13:30:10 workstation kernel: [  527.850061]  [<c119c240>] ?
proc_reg_write+0xa0/0xa0
Jun 14 13:30:10 workstation kernel: [  527.850071]  [<c114de6d>]
sys_read+0x3d/0x70
Jun 14 13:30:10 workstation kernel: [  527.850081]  [<c15cf89f>]
sysenter_do_call+0x12/0x28
Jun 14 13:30:10 workstation kernel: [  527.850120] Code: 5b 5d c3 8d
76 00 55 89 e5 57 56 53 3e 8d 74 26 00 31 f6 89 c7 b8 ff
ff ff ff eb 13 66 90 8b 0c 85 a0 c6 8a c1 8b 97 78 01 00 00 <03> 74 0a
04 8d 48 01 a1 0c 59 5d c1 ba 08 00 00 00 e8 f5 ad 22
Jun 14 13:30:10 workstation kernel: [  527.850567] EIP: [<c109f965>]
module_refcount+0x25/0x90 SS:ESP 0068:f5801eb8


Another thing I noticed is /proc/fs/cifs/traceSMB is set to some big
negative value - very strange.

If I use the module from the package everything is ok. Also with all
previous kernels everything goes fine too.

Any thoughts on what can be broken in v3.5 from v3.4?

fyi: v3.5-rc2 doesn't make any difference.

-- 
Best regards,
Pavel Shilovsky.
