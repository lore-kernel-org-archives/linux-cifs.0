From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nlink warning
Date: Fri, 16 Mar 2012 18:25:14 +0400
Message-ID: <CAKywueT4ng_7NHmjbwvomJG2M-g5Gmj0L8QTYo=qxJMmWCn7rQ@mail.gmail.com>
References: <CAKywueRvoQgcWefU+xJeN-o3UNLK1FZSnCwRf55hYVm5tMAohQ@mail.gmail.com>
	<CAKywueRFgM4z4fzHjo4vDrL7jKSunw9onx39-1zx=0C2SzmqfQ@mail.gmail.com>
	<CAKywueTtE+bEPH43KFNbPq10ewvfbQP4VpHU5r7Gaw5jVJjN9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTtE+bEPH43KFNbPq10ewvfbQP4VpHU5r7Gaw5jVJjN9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

3 =CD=C1=D2=D4=C1 2012=9A=C7. 14:03 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Pavel Shilovsky
<piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> 2012/3/3 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> 2012/3/3 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> FYI: Noted such warnings running dbench 3
>>>
>>> [11030.790449] WARNING: at /home/apw/COD/linux/fs/inode.c:290
>>> drop_nlink+0x3b/0x40()
>>> [11030.790452] Hardware name: MS-7309
>>> [11030.790454] Modules linked in: cifs(O) des_generic md4 nls_utf8
>>> binfmt_misc snd_hda_codec_realtek snd_hda_intel snd_hda_codec
>>> snd_hwdep snd_pcm nouveau ttm drm_kms_helper drm snd_seq_midi
>>> snd_rawmidi snd_seq_midi_event k8temp snd_seq snd_timer snd_seq_dev=
ice
>>> mxm_wmi video i2c_nforce2 snd wmi ppdev soundcore lp snd_page_alloc
>>> parport_pc mac_hid serio_raw parport floppy skge sata_nv pata_amd
>>> forcedeth [last unloaded: cifs]
>>> [11030.790491] Pid: 19338, comm: dbench Tainted: G =9A =9A =9A =9AW=
 =9AO
>>> 3.3.0-030300rc2-generic-pae #201201311735
>>> [11030.790495] Call Trace:
>>> [11030.790502] =9A[<c1042792>] warn_slowpath_common+0x72/0xa0
>>> [11030.790506] =9A[<c115f63b>] ? drop_nlink+0x3b/0x40
>>> [11030.790510] =9A[<c115f63b>] ? drop_nlink+0x3b/0x40
>>> [11030.790515] =9A[<c10427e2>] warn_slowpath_null+0x22/0x30
>>> [11030.790519] =9A[<c115f63b>] drop_nlink+0x3b/0x40
>>> [11030.790530] =9A[<fa01d9f4>] cifs_unlink+0xe4/0x650 [cifs]
>>> [11030.790534] =9A[<c11563b0>] ? path_lookupat+0xb0/0x5c0
>>> [11030.790539] =9A[<c159fb1d>] ? _raw_spin_lock+0xd/0x10
>>> [11030.790543] =9A[<c159fb1d>] ? _raw_spin_lock+0xd/0x10
>>> [11030.790548] =9A[<c1153e73>] vfs_unlink+0x83/0xf0
>>> [11030.790552] =9A[<c1157434>] do_unlinkat+0x154/0x180
>>> [11030.790556] =9A[<c1157475>] sys_unlink+0x15/0x20
>>> [11030.790561] =9A[<c15a6c5f>] sysenter_do_call+0x12/0x28
>>> [11030.790564] ---[ end trace 71953eb479f2ec1b ]---
>>>
>>
>> ...against Samba-3.5.4.
>>
>> --
>> Best regards,
>> Pavel Shilovsky.
>
> NFS code does this in unlink codepath:
>
> 1224 >-------spin_lock(&inode->i_lock);
> 1225 >-------if (inode->i_nlink > 0)
> 1226 >------->-------drop_nlink(inode);
> 1227 >-------spin_unlock(&inode->i_lock);
>
> May be we should something like it?
>
> --
> Best regards,
> Pavel Shilovsky.

Any thoughts on this?

--=20
Best regards,
Pavel Shilovsky.
