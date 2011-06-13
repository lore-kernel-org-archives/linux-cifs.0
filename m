From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Mon, 13 Jun 2011 11:48:31 -0400
Message-ID: <20110613114831.37c90109@tlielax.poochiereds.net>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
	<20110609183045.01f6f9fc@tlielax.poochiereds.net>
	<BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>
	<Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>
	<20110610073702.061bc014@corrin.poochiereds.net>
	<BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com>
	<4DF20A97.8010405@suse.de>
	<BANLkTimAauVsqX1JZucG1cg3-MAtqCrZFQ@mail.gmail.com>
	<20110611074113.5a05f919@tlielax.poochiereds.net>
	<Pine.LNX.4.64.1106112356500.12565@sarijopen.student.utwente.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Connor Hansen <cmdkhh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1106112356500.12565-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 12 Jun 2011 00:31:47 +0200 (CEST)
Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org> wrote:

> 
> 
> 
> <snip>
> >
> > Yep, mea culpa. This patch should fix it. Martin, can you test it?
> > Anyone else have comments?
> >
> > Thanks...
> 
> 
> Unfortunately, I have to quote Britney: "Oops! I did it again"
> Well, not entirely true, the OOPS changed into a BUG, but my samba mount 
> still doesn't work.
> 
> The OOPS to BUG has a interesting diff. Don't know if it really matters, 
> but some more info about my samba setup. Never such a thing as to much 
> info. Note, the SAMBA hostname and DNS hostname of the server are 
> NOT the same.
> 
> 
> ######## <samba setup> #############
> SERVER:
> -DNS_hostname		: sarijopen.student.utwente.nl
> -SAMBA_hostname		: duckman-tm
> -ipv4 only		:
> testparm -v|grep wins	:
>  			        name resolve order = lmhosts wins host bcast
>  			        max wins ttl = 518400
>  			        min wins ttl = 21600
>  			        wins proxy = No
>  			        wins server = 130.89.4.21, 130.89.4.22
>  			        wins support = No
>  			        wins hook =
> No Domain Controller or anything. This a student LAN of circa 1000
> computers where you can set your SAMBA hostname and workgroup to anything you like. Browse masters 
> of ad hoc workgroups are decided by elections. Only the WINS servers are 
> provided as a service of the IT department. I dont have very deep 
> knowledge of samba, but when I read some specs, my first thought was "this stuff is NOT designed for the way we use it". 
> However, it works. (Well, with a s*#%load of legitimate samba broadcast 
> traffic)
> 
> CLIENT:
> -DNS_hostname = xxxx.student.utwente.nl
> -SAMBA_hostname = xxxx
> -ipv4/ipv6 dual stack
> -fstab:	//sarijopen.student.utwente.nl/sysadmin /home/XXXX/docs_sysadmin 
> cifs    guest,uid=XXXX,gid=XXXX,users,auto,nounix,nobrl     0 
> 0
> ######### </samba setup> #########
> 
> 
> 
> diff -up OOPS BUG
> 
> CIFS VFS: default security mechanism requested.  The default security 
> mechanism will be upgraded from ntlm to ntlmv2 in kernel release 2.6.41
> -BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
> -IP: [<ffffffffa041e286>] CIFSTCon+0xf6/0x4d0 [cifs]
> -PGD 127393067 PUD 129c80067 PMD 0
> -Oops: 0000 [#1] SMP
> +CIFS VFS: dns_resolve_server_name_to_ip: unable to resolve: 
> sarijopen.student.utwente.nl
> +CIFS VFS: cifs_compose_mount_options: Failed to resolve server part of 
> \\sarijopen.student.utwente.nl\sysadmin to IP: -2
> +------------[ cut here ]------------
> +kernel BUG at mm/slab.c:501!
> +invalid opcode: 0000 [#1] SMP
> 
> BUG:
> 
> Registering the dns_resolver key type
> CIFS VFS: default security mechanism requested.  The default security 
> mechanism will be upgraded from ntlm to ntlmv2 in kernel release 2.6.41
> CIFS VFS: dns_resolve_server_name_to_ip: unable to resolve: 
> sarijopen.student.utwente.nl
> CIFS VFS: cifs_compose_mount_options: Failed to resolve server part of 
> \\sarijopen.student.utwente.nl\sysadmin to IP: -2
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:501!
> invalid opcode: 0000 [#1] SMP
> CPU 0
> Modules linked in: des_generic ecb md4 hmac nls_utf8 cifs dns_resolver 
> nfsd nfs lockd fscache sunrpc xfs fuse radeon ttm drm_kms_helper drm 
> i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect loop sg asus_atk0110 usbhid 
> sr_mod cdrom hid evdev pata_marvell sky2 skge snd_hda_codec_hdmi 
> snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm tpm_tis 
> snd_seq_midi snd_rawmidi tpm snd_seq_midi_event pcspkr tpm_bios snd_seq 
> uhci_hcd snd_timer snd_seq_device snd i2c_i801 i2c_core ehci_hcd intel_agp 
> intel_gtt soundcore snd_page_alloc
> 
> Pid: 2085, comm: mount.cifs Not tainted 3.0.0-rc1-debug-patched #1 System 
> manufacturer P5Q-E/P5Q-E
> RIP: 0010:[<ffffffff810d19f4>]  [<ffffffff810d19f4>] kfree+0x134/0x170
> RSP: 0018:ffff880129251cc8  EFLAGS: 00010046
> RAX: ffffea000070f420 RBX: ffff8801287e2e00 RCX: ffff88012f3c8800
> RDX: 4000000000000000 RSI: 00000000000000d0 RDI: ffffffffa045cebb
> RBP: ffff880129251d18 R08: b018000000000000 R09: 000000000000000a
> R10: 0000000000000006 R11: dead000000200200 R12: ffffffffa045cebb
> R13: 0000000000000282 R14: ffff88012a903400 R15: ffff88012a903800
> FS:  00007f6d20b9f700(0000) GS:ffff88012fc00000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fb9903dfc58 CR3: 0000000128b43000 CR4: 00000000000406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount.cifs (pid: 2085, threadinfo ffff880129250000, task 
> ffff88012aba6100)
> Stack:
>   ffff880129251c5c ffffffff810ec545 ffff88012f3c8800 ffff88010f876d10
>   ffff88012f3c8800 ffff8801287e2e00 ffff880129251d80 ffff88010f876d10
>   ffff88012a903400 ffff88012a903800 ffff880129251d38 ffffffffa043d19f
> Call Trace:
>   [<ffffffff810ec545>] ? __d_instantiate+0x85/0xf0
>   [<ffffffffa043d19f>] cifs_cleanup_volume_info+0x1f/0x70 [cifs]
>   [<ffffffffa043123b>] cifs_do_mount+0x11b/0x3b0 [cifs]
>   [<ffffffff810db35b>] mount_fs+0x1b/0xd0
>   [<ffffffff810f5c6e>] vfs_kern_mount+0x5e/0xd0
>   [<ffffffff810f5d4d>] do_kern_mount+0x4d/0x110
>   [<ffffffff810f732b>] do_mount+0x2cb/0x7d0
>   [<ffffffff810f78c3>] sys_mount+0x93/0xe0
>   [<ffffffff8138bdbb>] system_call_fastpath+0x16/0x1b
> Code: c8 44 01 09 4c 8b 45 c0 41 fe 46 40 8b 13 4b 8d 34 38 29 c2 4c 89 c7 
> 89 13 89 d2 48 c1 e2 03 e8 53 d2 0c 00 8b 03 e9 47 ff ff ff <0f> 0b eb fe 
> 48 8b 40 10 e9 16 ff ff ff 4c 8d 43 18 89 c2 4c 89
> RIP  [<ffffffff810d19f4>] kfree+0x134/0x170
>   RSP <ffff880129251cc8>
> ---[ end trace cffbbd6be8c5a0f3 ]---
> 
> 
> 
> So, we're from OOPS to BUG. I tried gdb, but it won't decode the 
> kfree+0x134 into something, which I could with the real OOPS.
> Some pointers how I can help with gdb?
> 
> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Oopses mentions 
> only OOPS, no BUG.
> 
> Greetz Martijn
> (BTW, I will mostly be of the net a couple of days, so my reply's can take 
> a while)
> 

(cc'ing Pavel)

Ok, I've been able to reproduce on -rc2 as well, simply by mounting
with -o sec=none. Pavel, I'm pretty sure this got broken by commit
724d9f1cfb. That patch doesn't handle the "null user" case correctly.
There are probably several different ways to fix it:


[  249.418776] ------------[ cut here ]------------
[  249.419050] kernel BUG at mm/slub.c:2948!
[  249.419050] invalid opcode: 0000 [#1] SMP 
[  249.419050] CPU 1 
[  249.419050] Modules linked in: des_generic md4 nls_utf8 cifs fscache sunrpc ipx p8022 psnap llc p8023 rose ax25 joydev i2c_piix4 i2c_core virtio_balloon virtio_net virtio_blk [last unloaded: cifs]
[  249.419050] 
[  249.419050] Pid: 1058, comm: mount.cifs Not tainted 3.0-0.rc2.git0.2.fc16.x86_64 #1 Bochs Bochs
[  249.419050] RIP: 0010:[<ffffffff81126249>]  [<ffffffff81126249>] kfree+0x60/0xfc
[  249.419050] RSP: 0018:ffff88003ba2bce8  EFLAGS: 00010246
[  249.419050] RAX: 0020000000000000 RBX: ffffffffa013d46d RCX: ffff880034380930
[  249.419050] RDX: 0020000000000000 RSI: ffff8800314a4ea0 RDI: ffffffffa013d46d
[  249.419050] RBP: ffff88003ba2bd08 R08: ffff88003e002500 R09: 000000000000005a
[  249.419050] R10: ffffffff82421ed0 R11: 00000000000003a7 R12: ffffea0000704558
[  249.419050] R13: ffff88002f1a8050 R14: ffff88003140c2d0 R15: ffff88003a40d330
[  249.419050] FS:  00007f89290dc740(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[  249.419050] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  249.419050] CR2: 00007f804783a240 CR3: 000000003aea9000 CR4: 00000000000006e0
[  249.419050] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  249.419050] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  249.419050] Process mount.cifs (pid: 1058, threadinfo ffff88003ba2a000, task ffff8800314a47a0)
[  249.419050] Stack:
[  249.419050]  ffff88003c312000 ffff88003ba2bd70 ffff88002f1a8050 ffff88003140c2d0
[  249.419050]  ffff88003ba2bd28 ffffffffa011e1a7 ffff88003ba1c240 ffff88003140c240
[  249.419050]  ffff88003ba2bda8 ffffffffa0112107 ffff88003ba2bd98 ffff880034380930
[  249.419050] Call Trace:
[  249.419050]  [<ffffffffa011e1a7>] cifs_cleanup_volume_info+0x24/0x72 [cifs]
[  249.419050]  [<ffffffffa0112107>] cifs_do_mount+0x34e/0x364 [cifs]
[  249.419050]  [<ffffffff8113a2dd>] mount_fs+0x69/0x158
[  249.419050]  [<ffffffff81103e6c>] ? __alloc_percpu+0x10/0x12
[  249.419050]  [<ffffffff8114f35e>] vfs_kern_mount+0x63/0xa0
[  249.419050]  [<ffffffff81150032>] do_kern_mount+0x4d/0xdf
[  249.419050]  [<ffffffff811516c8>] do_mount+0x63c/0x69f
[  249.419050]  [<ffffffff811519ac>] sys_mount+0x88/0xc2
[  249.419050]  [<ffffffff814fb002>] system_call_fastpath+0x16/0x1b
[  249.419050] Code: e9 ae 00 00 00 48 83 fb 10 0f 86 af 00 00 00 48 89 df e8 11 dd ff ff 49 89 c4 48 8b 00 a8 80 75 19 49 f7 04 24 00 c0 00 00 75 02 <0f> 0b 4c 89 e7 e8 78 e1 fc ff e9 84 00 00 00 4d 8b 6c 24 10 48 
[  249.419050] RIP  [<ffffffff81126249>] kfree+0x60/0xfc
[  249.419050]  RSP <ffff88003ba2bce8>
[  249.474238] ---[ end trace 48c6ff1e268f2f6a ]---


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
