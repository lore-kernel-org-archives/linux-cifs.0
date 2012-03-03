From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nlink warning
Date: Sat, 3 Mar 2012 13:58:34 +0400
Message-ID: <CAKywueRFgM4z4fzHjo4vDrL7jKSunw9onx39-1zx=0C2SzmqfQ@mail.gmail.com>
References: <CAKywueRvoQgcWefU+xJeN-o3UNLK1FZSnCwRf55hYVm5tMAohQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRvoQgcWefU+xJeN-o3UNLK1FZSnCwRf55hYVm5tMAohQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/3/3 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> FYI: Noted such warnings running dbench 3
>
> [11030.790449] WARNING: at /home/apw/COD/linux/fs/inode.c:290
> drop_nlink+0x3b/0x40()
> [11030.790452] Hardware name: MS-7309
> [11030.790454] Modules linked in: cifs(O) des_generic md4 nls_utf8
> binfmt_misc snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_pcm nouveau ttm drm_kms_helper drm snd_seq_midi
> snd_rawmidi snd_seq_midi_event k8temp snd_seq snd_timer snd_seq_devic=
e
> mxm_wmi video i2c_nforce2 snd wmi ppdev soundcore lp snd_page_alloc
> parport_pc mac_hid serio_raw parport floppy skge sata_nv pata_amd
> forcedeth [last unloaded: cifs]
> [11030.790491] Pid: 19338, comm: dbench Tainted: G =A0 =A0 =A0 =A0W =A0=
O
> 3.3.0-030300rc2-generic-pae #201201311735
> [11030.790495] Call Trace:
> [11030.790502] =A0[<c1042792>] warn_slowpath_common+0x72/0xa0
> [11030.790506] =A0[<c115f63b>] ? drop_nlink+0x3b/0x40
> [11030.790510] =A0[<c115f63b>] ? drop_nlink+0x3b/0x40
> [11030.790515] =A0[<c10427e2>] warn_slowpath_null+0x22/0x30
> [11030.790519] =A0[<c115f63b>] drop_nlink+0x3b/0x40
> [11030.790530] =A0[<fa01d9f4>] cifs_unlink+0xe4/0x650 [cifs]
> [11030.790534] =A0[<c11563b0>] ? path_lookupat+0xb0/0x5c0
> [11030.790539] =A0[<c159fb1d>] ? _raw_spin_lock+0xd/0x10
> [11030.790543] =A0[<c159fb1d>] ? _raw_spin_lock+0xd/0x10
> [11030.790548] =A0[<c1153e73>] vfs_unlink+0x83/0xf0
> [11030.790552] =A0[<c1157434>] do_unlinkat+0x154/0x180
> [11030.790556] =A0[<c1157475>] sys_unlink+0x15/0x20
> [11030.790561] =A0[<c15a6c5f>] sysenter_do_call+0x12/0x28
> [11030.790564] ---[ end trace 71953eb479f2ec1b ]---
>

=2E..against Samba-3.5.4.

--=20
Best regards,
Pavel Shilovsky.
