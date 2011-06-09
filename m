From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Thu, 9 Jun 2011 18:30:45 -0400
Message-ID: <20110609183045.01f6f9fc@tlielax.poochiereds.net>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1106092211500.19687-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 9 Jun 2011 22:15:05 +0200 (CEST)
Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org> wrote:

> 
> Ave People
> 
> 
> I've got an oops with 3.0-rc1. (The same Oops also occurs with 3.0-rc2 and
> the git snapshot of today linux-2.6-06e8684.)
> The Oops occurs at boot time while the boot scripts try to automount a samba
> share.
> 
> Last (tested)  working kernel	:	2.6.39
> First (tested) oopsing kernel	:	3.0-rc1
> 
> I'm willing to try patches, and if it's needed, I can try to
> git-bisect the kernel. However, I'm short on time and thought maybe somebody
> already has some idea. I did a diff between 2.6.39/3.0-rc1 and there seems
> to be a lot of code churn in cifs.
> 
> Details of client/server and the Oops attached. If there are any questions
> please ask and CC: to my mail address. I'm not subscribed to
> linux-cifs/linux-kernel
> 
> Martijn Uffing
> 
> 
> 
> CLIENT:
> 
> -Debian squeeze (64 bits)
> -kernel vanilla 2.6.39 working   (core 2 duo)
> -kernel vanilla 3.0-rc1 crashing (core 2 duo)
> -fstab
>   X.X.X.X/sysadmin /home/XXXX/docs_sysadmin	cifs	guest,uid=XXXX,gid=XXXX,users,auto,nounix,nobrl     0  0
> -cat kernelconfig|grep CIFS
>   CONFIG_CIFS=m
>   CONFIG_CIFS_STATS=y
>   # CONFIG_CIFS_STATS2 is not set
>   CONFIG_CIFS_WEAK_PW_HASH=y
>   CONFIG_CIFS_UPCALL=y
>   # CONFIG_CIFS_XATTR is not set
>   # CONFIG_CIFS_DEBUG2 is not set
>   CONFIG_CIFS_DFS_UPCALL=y
>   # CONFIG_CIFS_FSCACHE is not set
>   CONFIG_CIFS_NFSD_EXPORT=y
> 
> 
> SERVER:
> -Debian etch (32 bits)
> -kernel vanilla 2.6.27.59
> -samba 3.0.24-6etch10
> -samba share:
> [sysadmin]
>      path = /root/sysadmin/docs
>      guest ok = yes
>      guest only = yes
>      force user = root
>      writable = yes
>      printable = no
>      browseable = yes
>      hosts deny = ALL
>      hosts allow = X.X.X.X
> 
> OOPS:
> Installing knfsd (copyright (C) 1996 okir-pn4DOG8n3UYbFoVRYvo4fw@public.gmane.org).
> svc: failed to register lockdv1 RPC service (errno 97).
> Registering the dns_resolver key type
> CIFS VFS: default security mechanism requested.  The default security mechanism will be upgraded from ntlm to ntlmv2 in kernel release 2.6.41
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
> IP: [<ffffffffa0413286>] CIFSTCon+0xf6/0x4d0 [cifs]
> PGD 12a9a1067 PUD 1270ef067 PMD 0 
> Oops: 0000 [#1] SMP 
> CPU 1 
> Modules linked in: des_generic ecb md4 hmac nls_utf8 cifs dns_resolver nfsd nfs lockd fscache sunrpc xfs fuse radeon ttm drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect loop sg asus_atk0110 sr_mod cdrom usbhid hid pata_marvell sky2 skge evdev snd_hda_codec_hdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi intel_agp intel_gtt snd_seq_midi_event snd_seq tpm_tis tpm snd_timer snd_seq_device i2c_i801 snd i2c_core uhci_hcd soundcore snd_page_alloc ehci_hcd tpm_bios pcspkr
> 
> Pid: 2065, comm: mount.cifs Not tainted 3.0.0-rc1 #1 System manufacturer P5Q-E/P5Q-E
> RIP: 0010:[<ffffffffa0413286>]  [<ffffffffa0413286>] CIFSTCon+0xf6/0x4d0 [cifs]
> RSP: 0018:ffff880127d17b48  EFLAGS: 00010282
> RAX: ffff88012a905400 RBX: ffff880129dc4200 RCX: 0000000000000000
> RDX: 0000000000000811 RSI: ffff88012a9055ea RDI: ffff88012a905578
> RBP: ffff880127d17ba8 R08: 0000000000000005 R09: 0000000000000001
> R10: ffff88012638d600 R11: ffffffffa00600c0 R12: ffff880128bd0140
> R13: 0000000000000000 R14: ffff880128bd016f R15: 0000000000000000
> FS:  00007f4cbf033700(0000) GS:ffff88012fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000000000a0 CR3: 000000012a9f1000 CR4: 00000000000406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount.cifs (pid: 2065, threadinfo ffff880127d16000, task ffff880127b26880)
> Stack:
>   ffff8801273a5900 ffff88012638d600 ffffffffa00600c0 0000000300000001
>   ffff880127d17b78 ffff88012a905560 ffff880127d17ba8 ffff880127d17c74
>   ffff880127d17c68 ffff880129dc4200 00000000fffffff4 ffff8801279b7f01
> Call Trace:
>   [<ffffffffa041479e>] get_dfs_path+0x11e/0x190 [cifs]
>   [<ffffffffa041492c>] expand_dfs_referral+0x11c/0x220 [cifs]
>   [<ffffffffa0425b55>] ? cifs_buf_release+0x15/0x20 [cifs]
>   [<ffffffffa040d211>] ? CIFSSMBQFSAttributeInfo+0x1b1/0x260 [cifs]
>   [<ffffffffa0415dc5>] cifs_mount+0x2c5/0x5d0 [cifs]
>   [<ffffffff810b2c7d>] ? bdi_setup_and_register+0x7d/0xa0
>   [<ffffffffa0408311>] cifs_do_mount+0x1f1/0x3b0 [cifs]
>   [<ffffffff810db35b>] mount_fs+0x1b/0xd0
>   [<ffffffff810f5c6e>] vfs_kern_mount+0x5e/0xd0
>   [<ffffffff810f5d4d>] do_kern_mount+0x4d/0x110
>   [<ffffffff810f732b>] do_mount+0x2cb/0x7d0
>   [<ffffffff810f78c3>] sys_mount+0x93/0xe0
>   [<ffffffff8138bdbb>] system_call_fastpath+0x16/0x1b
> Code: b4 02 00 10 0f 84 e7 02 00 00 48 8b 73 40 8b be cc 01 00 00 85 ff 0f 84 de 02 00 00 4c 89 55 a8 4c 89 5d b0 48 81 c6 ea 01 00 00
>   8b bd a0 00 00 00 4c 89 f2 e8 3b 37 01 00 4c 8b 5d b0 4c 8b 
> RIP  [<ffffffffa0413286>] CIFSTCon+0xf6/0x4d0 [cifs]
>   RSP <ffff880127d17b48>
> CR2: 00000000000000a0
> ---[ end trace 64d92145e3df4829 ]---
> 

Thanks for the bug report, Martin. Can you do the following to get us a
listing of the place where it fell down?

http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Oopses

That should give us a better idea of what went wrong.

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
