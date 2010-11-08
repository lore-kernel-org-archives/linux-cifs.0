From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Kernel oops: NULL pointer dereference in cifs_ioctl on
 2.6.37-rc1
Date: Mon, 8 Nov 2010 08:08:43 -0500
Message-ID: <20101108080843.7aeca566@tlielax.poochiereds.net>
References: <484246.91210.qm@web27103.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <484246.91210.qm-ZxlQ8pIuIvXGRxTy+Q50vsz6deESKz/lQQ4Iyu8u01E@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 7 Nov 2010 16:44:46 +0000 (GMT)
Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org> wrote:

> After upgrading from 2.6.36 for other reasons, starting certain apps like wine utorrent.exe will cause a kernel oops. I run the x86_64 version of Ubuntu 10.10 with various modified packages all around and the 2.6.37-rc1 kernel from the kernel PPA team. I experienced the same with a kernel I tried compiling myself too.
> 
> Nov  7 17:25:50 wodan kernel: [77498.450787] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> Nov  7 17:25:50 wodan kernel: [77498.450883] IP: [<ffffffffa0395729>] cifs_ioctl+0x39/0x2f0 [cifs]
> Nov  7 17:25:50 wodan kernel: [77498.450987] PGD 1836a067 PUD 5bfac067 PMD 17d2b067 PTE 0
> Nov  7 17:25:50 wodan kernel: [77498.451234] CPU 4 
> Nov  7 17:25:50 wodan kernel: [77498.451264] Modules linked in: binfmt_misc vboxnetadp vboxnetflt vboxdrv snd_hda_codec_hdmi snd_hda_codec_realtek nls_cp437 cifs snd_hda_intel snd_hda_codec snd_seq_midi snd_rawmidi snd_hwdep snd_pcm snd_seq_midi_event snd_seq snd_timer snd_seq_device ppdev lp parport_pc serio_raw snd shpchp soundcore parport joydev snd_page_alloc sha256_generic cryptd aes_x86_64 aes_generic dm_crypt radeon ttm usbhid ahci hid drm_kms_helper r8169 libahci pata_jmicron drm mii floppy i2c_algo_bit
> Nov  7 17:25:50 wodan kernel: [77498.451845] 
> Nov  7 17:25:50 wodan kernel: [77498.451865] Pid: 4386, comm: utorrent.exe Not tainted 2.6.37-020637rc1-generic #201011020905 P55-UD3R/P55-UD3R
> Nov  7 17:25:50 wodan kernel: [77498.451971] RIP: 0010:[<ffffffffa0395729>]  [<ffffffffa0395729>] cifs_ioctl+0x39/0x2f0 [cifs]
> Nov  7 17:25:50 wodan kernel: [77498.452074] RSP: 0018:ffff880018899e98  EFLAGS: 00010282
> Nov  7 17:25:50 wodan kernel: [77498.452131] RAX: ffff880207a08300 RBX: ffff88005c884780 RCX: 0000000000222000
> Nov  7 17:25:50 wodan kernel: [77498.452207] RDX: 0000000000222000 RSI: 0000000082187201 RDI: ffff88005c884780
> Nov  7 17:25:50 wodan kernel: [77498.452282] RBP: ffff880018899ee8 R08: 000000000000001c R09: 00000000007bf700
> Nov  7 17:25:50 wodan kernel: [77498.452358] R10: ffff880018898000 R11: 0000000000000000 R12: 0000000082187201
> Nov  7 17:25:50 wodan kernel: [77498.452433] R13: 0000000000000000 R14: 0000000000222000 R15: ffff880207a4c2c0
> Nov  7 17:25:50 wodan kernel: [77498.452510] FS:  000000007ffd8000(0063) GS:ffff8800df900000(006b) knlGS:00000000f74426c0
> Nov  7 17:25:50 wodan kernel: [77498.452595] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> Nov  7 17:25:50 wodan kernel: [77498.452656] CR2: 0000000000000040 CR3: 000000005b77e000 CR4: 00000000000026e0
> Nov  7 17:25:50 wodan kernel: [77498.452732] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Nov  7 17:25:50 wodan kernel: [77498.452808] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Nov  7 17:25:50 wodan kernel: [77498.452884] Process utorrent.exe (pid: 4386, threadinfo ffff880018898000, task ffff8800188bdb00)
> Nov  7 17:25:50 wodan kernel: [77498.452999]  00000000fffffff7 ffff880018899ef8 0000000000000000 0000000000000000
> Nov  7 17:25:50 wodan kernel: [77498.453084]  ffff880018899ee8 0000000000000000 0000000000222000 ffff88005c884780
> Nov  7 17:25:50 wodan kernel: [77498.453169]  0000000000222000 000000000000001c ffff880018899ef8 ffffffff8116e94d
> Nov  7 17:25:50 wodan kernel: [77498.453287]  [<ffffffff8116e94d>] vfs_ioctl+0x1d/0x50
> Nov  7 17:25:50 wodan kernel: [77498.453343]  [<ffffffff8116f52d>] do_vfs_ioctl+0x7d/0x1f0
> Nov  7 17:25:50 wodan kernel: [77498.453405]  [<ffffffff811a5c62>] compat_sys_ioctl+0x122/0x200
> Nov  7 17:25:50 wodan kernel: [77498.453470]  [<ffffffff81048560>] sysenter_dispatch+0x7/0x2e
> Nov  7 17:25:50 wodan kernel: [77498.454010]  RSP <ffff880018899e98>
> Nov  7 17:25:50 wodan kernel: [77498.478707] ---[ end trace 4e689dcb8ba02a93 ]---
> 
> Hopefully this makes more sense to someone than it does to me :)
> 

Ok, the patch I just sent to the list seems to fix this for me and this
is clearly our bug. But, I have to wonder -- what is wine doing running
ioctls against files?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
