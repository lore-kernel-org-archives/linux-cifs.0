From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: kernel drop_nlink warning
Date: Thu, 9 Feb 2012 21:43:55 +0400
Message-ID: <CAKywueSh9WM5u2JuDE_Q4DaOsYecrPK1VkTD8wzmmDC80kjyLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all!

Got it on current master (several mkdir/rmdir reproduces it) against Wi=
ndows 7.

[ 3474.795977] WARNING: at /home/apw/COD/linux/fs/inode.c:290
drop_nlink+0x3b/0x40()
[ 3474.795980] Hardware name: MS-7309
[ 3474.795982] Modules linked in: cifs(O) des_generic md4 nls_utf8
binfmt_misc snd_hda_codec_realtek snd_hda_intel snd_hda_codec ppdev
snd_hwdep snd_pcm nouveau ttm drm_kms_helper drm lp mxm_wmi video
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device snd i2c_nforce2 k8temp parport_pc soundcore parport wmi
mac_hid snd_page_alloc serio_raw floppy skge pata_amd forcedeth
sata_nv [last unloaded: cifs]
[ 3474.796056] Pid: 8508, comm: rmdir Tainted: G =A0 =A0 =A0 =A0W =A0O
3.3.0-030300rc2-generic-pae #201201311735
[ 3474.796060] Call Trace:
[ 3474.796069] =A0[<c1042792>] warn_slowpath_common+0x72/0xa0
[ 3474.796076] =A0[<c115f63b>] ? drop_nlink+0x3b/0x40
[ 3474.796082] =A0[<c115f63b>] ? drop_nlink+0x3b/0x40
[ 3474.796089] =A0[<c10427e2>] warn_slowpath_null+0x22/0x30
[ 3474.796095] =A0[<c115f63b>] drop_nlink+0x3b/0x40
[ 3474.796108] =A0[<f874bbc7>] cifs_rmdir+0x107/0x1e0 [cifs]
[ 3474.796116] =A0[<c1153f80>] vfs_rmdir+0xa0/0xf0
[ 3474.796122] =A0[<c115756f>] do_rmdir+0xef/0x100
[ 3474.796129] =A0[<c1147012>] ? filp_close+0x52/0x80
[ 3474.796135] =A0[<c11575d5>] sys_rmdir+0x15/0x20
[ 3474.796142] =A0[<c15a6c5f>] sysenter_do_call+0x12/0x28
[ 3474.796147] ---[ end trace b449c0b09a984281 ]---

I also, saw something like this for inc_nlink in mkdir call (when we
try to inc zero nlink value).

The problem is that POSIX filesystems increment nlink value for
directory on every mkdir call - Samba with posix extensions enabled
does the same thing and return the right value on query info. But as
for Windows semantic - Links for directory is ordinary link - the
value stay the same and doesn't depend on the number of child
directoris.

I think we need to do two thing to avoid problems like that:

1)  do inc/drop nlink value in posix case only.

2) add if (nlink > 2) check before drop_nlink to work around possible
broken servers (we can raise cERROR in zero case).

--=20
Best regards,
Pavel Shilovsky.
