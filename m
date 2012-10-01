From: Suresh Jayaraman <sjayaraman@suse.com>
Subject: Re: OOPS:  Kernel 3.5.4-1.fc17.i686 freezes up when copying to CIFS
 mount
Date: Mon, 01 Oct 2012 11:40:55 +0530
Message-ID: <506933EF.7000908@suse.com>
References: <1348898071.15703.5.camel@rajhome2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	linux-cifs <linux-cifs@vger.kernel.org>
To: Raj Upadhyaya <raj.upadhyaya@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348898071.15703.5.camel@rajhome2>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

(Cc linux-cifs mailinglist and inlining the original oops)

On 09/29/2012 11:24 AM, Raj Upadhyaya wrote:
> [1.] OOPS:  Kernel 3.5.4-1.fc17.i686 freezes up when copying to CIFS 
> mount [2.] I yum updated to this kernel from Fedora.  It froze up 
> when I was backing up a some files to a CIFS mounted Windows XP 
> machine.  It wasn't totally frozen as the MP3 player was still 
> going.

> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.170233] ------------[ cut here ]------------
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] kernel BUG at fs/dcache.c:552!
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] invalid opcode: 0000 [#1] SMP 
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] Modules linked in: fuse des_generic md4 nls_utf8 cifs fscache bnep bluetooth nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_REJECT rfkill nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter xt_state nf_conntrack ip6_tables binfmt_misc e100 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mii ppdev parport_pc parport lpc_ich snd_page_alloc snd_timer snd i2c_i801 serio_raw microcode soundcore uinput firewire_ohci firewire_core crc_itu_t usb_storage i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] 
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] Pid: 13515, comm: flush-cifs-1 Tainted: G        W    3.5.4-1.fc17.i686 #1 HP Pavilion 061 EX278AA-ABA a1560n/LEUCITE
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] EIP: 0060:[<c0550f15>] EFLAGS: 00010246 CPU: 1
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] EIP is at dput+0x165/0x170

BUG_ON due to d_count being 0 already when we call dput(). The "No
writable handles for inode" error indicates that the filehandle is
invalid and the attempted cifs_reopen_file() seems to have failed. Later
in the dmesg output, there is an indication of cifs sending data on
socket being stuck for more than 15 seconds.

A few questions:

a) Is this the first oops? Because abrt-dump-oops reports 3 oopses
   found.

b) The timestamps doesn't seem to be in order. Is this is the full
   dmesg output or you missed any failures before this?

c) Was the server and the network up when you observed the error?

d) If it is reproducible, can you try enabling cifs debugging by doing
     echo 7 > /proc/fs/cifs/cifsFYI

and attach the dmesg output. That might give a little more clues..

Thanks
Suresh

> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] EAX: 00000000 EBX: dd12b280 ECX: 000000ee EDX: 0000eeee
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] ESI: f00a2a90 EDI: dd12b2cc EBP: cfefbd78 ESP: cfefbd68
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] CR0: 8005003b CR2: b7671000 CR3: 311ac000 CR4: 000007d0
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] DR6: ffff0ff0 DR7: 00000400
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] Process flush-cifs-1 (pid: 13515, ti=cfefa000 task=d7b1bed0 task.ti=cfefa000)
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] Stack:
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  cfefbd78 f00a2a80 f00a2a90 f00a2a90 cfefbda8 f812a006 c0ad7f2c cfefbd9c
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  cfefbda8 c066ff20 c0ad76ac d56ed18c f00a2a90 00000000 d56ed1a0 f00a2a80
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  cfefbde4 f812c075 00000000 d7b1bed0 00000001 d56ed188 d7b1bed0 c04f7c00
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] Call Trace:
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<f812a006>] cifsFileInfo_put+0xe6/0x1f0 [cifs]
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c066ff20>] ? __list_del_entry+0x60/0xe0
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<f812c075>] find_writable_file+0x135/0x1b0 [cifs]
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c04f7c00>] ? set_page_dirty_lock+0x50/0x50
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<f812c3c8>] cifs_writepages+0x2d8/0x550 [cifs]
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c046b400>] ? sched_clock_local+0xc0/0x1e0
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c04f96fa>] do_writepages+0x1a/0x40
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c055f4cf>] __writeback_single_inode.isra.31+0x2f/0x130
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c0458403>] ? wake_up_bit+0x23/0x30
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c05602db>] writeback_sb_inodes+0x15b/0x2d0
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c05604cc>] __writeback_inodes_wb+0x7c/0xb0
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c05606f2>] wb_writeback+0x1f2/0x270
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c056177a>] wb_do_writeback+0x13a/0x1c0
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c0446c40>] ? internal_add_timer+0xc0/0xc0
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c0561871>] bdi_writeback_thread+0x71/0x1e0
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c0561800>] ? wb_do_writeback+0x1c0/0x1c0
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c0458082>] kthread+0x72/0x80
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c0458010>] ? flush_kthread_worker+0x70/0x70
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767]  [<c094b87e>] kernel_thread_helper+0x6/0x10
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] Code: 88 00 00 00 8d 90 88 00 00 00 89 f0 e8 c5 f0 11 00 8b 43 54 83 05 88 f1 b8 c0 01 83 80 90 00 00 00 01 80 05 c0 7c b6 c0 01 eb b9 <0f> 0b 89 f6 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 ec 08 3e 
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.171767] EIP: [<c0550f15>] dput+0x165/0x170 SS:ESP 0068:cfefbd68
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.304954] ---[ end trace c6c1279a9d630fb2 ]---
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.317001] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.330439] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.343865] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.357093] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.370395] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.383576] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.396739] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.409914] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.423147] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.436437] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.449657] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.462858] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.476034] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.489595] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.502794] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.516094] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.529644] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.542954] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.556192] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.569427] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.582631] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.595829] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.609047] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.622402] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.635735] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.648996] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.662199] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.675413] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.688612] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.702047] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.715346] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.728547] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.741726] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.754923] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.768134] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.781470] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.794692] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.807889] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.821058] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.834218] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.847457] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.860654] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.873840] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.887039] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.900227] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.913516] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.926777] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.939984] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.953217] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.966413] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.979621] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2686.992804] CIFS VFS: No writable handles for inode
> Sep 28 23:19:47 adsl-108-199-65-102 kernel: [ 2687.005986] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.019194] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.032717] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.045907] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.059123] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.072282] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.085424] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.098551] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.111814] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.125047] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.138169] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.151273] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.164378] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.177537] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.190749] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.203896] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.217040] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.230191] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.243319] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.256445] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.269606] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.282730] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.295861] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.309021] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.322316] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.335950] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.349062] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.362217] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.375613] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.388735] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.401878] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.415035] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.428154] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.441312] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.454412] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.467556] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.480778] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.493980] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.507166] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.520665] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 sh[658]: abrt-dump-oops: Found oopses: 3
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.535560] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.549044] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.562738] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.575922] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 sh[658]: abrt-dump-oops: Creating dump directories
> Sep 28 23:19:48 adsl-108-199-65-102 abrtd: Directory 'oops-2012-09-28-23:19:48-27440-1' creation detected
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.589143] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.602349] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.615586] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.628860] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.643605] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.657480] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.670706] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 abrt-dump-oops: Reported 3 kernel oopses to Abrt
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.684565] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 abrtd: Directory 'oops-2012-09-28-23:19:48-27440-2' creation detected
> Sep 28 23:19:48 adsl-108-199-65-102 abrtd: Directory 'oops-2012-09-28-23:19:48-27440-3' creation detected
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.697857] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.711056] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 abrtd: Can't open file '/var/spool/abrt/oops-2012-09-28-23:19:48-27440-1/uid': No such file or directory
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.724382] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.737550] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.750743] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.763920] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.777168] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.790349] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.803508] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.816702] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.829898] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.843051] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.856235] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.869548] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.882741] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.895964] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.909183] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.922481] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.935700] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.948957] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.962136] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.975280] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2687.988465] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2688.001604] CIFS VFS: No writable handles for inode
> Sep 28 23:19:48 adsl-108-199-65-102 kernel: [ 2688.014751] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.028476] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.041629] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.054742] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.067896] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.081077] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.094251] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.107458] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.121434] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.134571] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.147661] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.160761] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.173994] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.187142] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.200256] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.213347] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.226457] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.239675] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.252845] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.265959] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.279058] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.292212] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.305361] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.318702] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.332161] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.345389] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.358564] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.371739] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.384906] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.398112] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.411381] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.424599] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.437768] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.451088] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.464241] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.477406] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.490553] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.515431] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.529209] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.542544] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.555881] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.569025] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.582179] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.595492] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: Can't open file './executable': No such file or directory
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.608695] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: New problem directory /var/spool/abrt/oops-2012-09-28-23:19:48-27440-1, processing
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: Can't open file '/var/spool/abrt/oops-2012-09-28-23:19:48-27440-1/uid': No such file or directory
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.621969] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.639131] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.652328] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.666386] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: Can't open file '/var/spool/abrt/oops-2012-09-28-23:19:48-27440-2/uid': No such file or directory
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.679890] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.693246] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.706428] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.721201] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.734588] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.747807] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.760942] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.774102] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: Can't open file './executable': No such file or directory
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: New problem directory /var/spool/abrt/oops-2012-09-28-23:19:48-27440-2, processing
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: Can't open file '/var/spool/abrt/oops-2012-09-28-23:19:48-27440-2/uid': No such file or directory
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.787514] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.800881] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: Can't open file '/var/spool/abrt/oops-2012-09-28-23:19:48-27440-3/uid': No such file or directory
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.814185] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.827445] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.840692] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.854048] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.867237] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.880409] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.893537] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: Can't open file './executable': No such file or directory
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: Unable to find offset & function length: '[<c0550f15>] EFLAGS: 00010246 CPU: 1'
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.906777] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: New problem directory /var/spool/abrt/oops-2012-09-28-23:19:48-27440-3, processing
> Sep 28 23:19:49 adsl-108-199-65-102 abrtd: Can't open file '/var/spool/abrt/oops-2012-09-28-23:19:48-27440-3/uid': No such file or directory
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.921895] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.935241] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.948435] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.961598] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.974780] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2688.987931] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2689.001069] CIFS VFS: No writable handles for inode
> Sep 28 23:19:49 adsl-108-199-65-102 kernel: [ 2689.014254] CIFS VFS: No writable handles for inode
> Sep 28 23:19:50 adsl-108-199-65-102 kernel: [ 2689.027691] CIFS VFS: No writable handles for inode
> Sep 28 23:19:50 adsl-108-199-65-102 kernel: [ 2689.040863] CIFS VFS: No writable handles for inode
> Sep 28 23:19:50 adsl-108-199-65-102 kernel: [ 2689.053977] CIFS VFS: No writable handles for inode
> Sep 28 23:19:50 adsl-108-199-65-102 kernel: [ 2689.067131] CIFS VFS: No writable handles for inode
> Sep 28 23:19:50 adsl-108-199-65-102 kernel: [ 2689.080294] CIFS VFS: No writable handles for inode
> Sep 28 23:19:50 adsl-108-199-65-102 kernel: [ 2689.093454] CIFS VFS: No writable handles for inode
> Sep 28 23:19:50 adsl-108-199-65-102 kernel: [ 2689.106597] CIFS VFS: No writable handles for inode
> Sep 28 23:19:50 adsl-108-199-65-102 kernel: [ 2689.119775] CIFS VFS: No writable handles for inode
> Sep 28 23:19:50 adsl-108-199-65-102 kernel: [ 2689.132960] CIFS VFS: No writable handles fSep 28 19:50:46 adsl-108-199-65-102 kernel: imklog 5.8.10, log source = /proc/kmsg started.
> Sep 28 19:50:46 adsl-108-199-65-102 rsyslogd: [origin software="rsyslogd" swVersion="5.8.10" x-pid="624" x-info="http://www.rsyslog.com"] start
> Sep 28 19:50:46 adsl-108-199-65-102 systemd-vconsole-setup[329]: Cannot open font file True
> Sep 28 19:50:46 adsl-108-199-65-102 udevd[322]: specified group 'plugdev' unknown
> Sep 28 19:50:46 adsl-108-199-65-102 systemd-vconsole-setup[329]: /bin/setfont failed with error code 66.
> Sep 28 19:50:46 adsl-108-199-65-102 mtp-probe: checking bus 1, device 4: "/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-7"
> Sep 28 19:50:46 adsl-108-199-65-102 mtp-probe: checking bus 2, device 2: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1"
> Sep 28 19:50:46 adsl-108-199-65-102 mtp-probe: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-2"
> Sep 28 19:50:46 adsl-108-199-65-102 mtp-probe: bus: 2, device: 3 was not an MTP device
> Sep 28 19:50:46 adsl-108-199-65-102 mtp-probe: bus: 2, device: 2 was not an MTP device
> Sep 28 19:50:46 adsl-108-199-65-102 mtp-probe: bus: 1, device: 4 was not an MTP device
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Initializing cgroup subsys cpuset
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Initializing cgroup subsys cpu
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Linux version 3.6.0-rc6 (raj@rajhome2) (gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC) ) #1 SMP Sun Sep 23 22:09:37 CDT 2012
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] e820: BIOS-provided physical RAM map:
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000987ff] usable
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] BIOS-e820: [mem 0x0000000000098800-0x000000000009ffff] reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007f6dffff] usable
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] BIOS-e820: [mem 0x000000007f6e0000-0x000000007f6e2fff] ACPI NVS
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] BIOS-e820: [mem 0x000000007f6e3000-0x000000007f6effff] ACPI data
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] BIOS-e820: [mem 0x000000007f6f0000-0x000000007f6fffff] reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] DMI present.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] e820: last_pfn = 0x7f6e0 max_arch_pfn = 0x100000
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] total RAM covered: 2039M
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Found optimal setting for mtrr clean up
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 3  	lose cover RAM: 0G
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] found SMP MP-table at [mem 0x000f5f90-0x000f5f9f] mapped at [c00f5f90]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] init_memory_mapping: [mem 0x00000000-0x373fdfff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] RAMDISK: [mem 0x36220000-0x37107fff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: RSDP 000f82d0 00014 (v00 HP-CPC)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: RSDT 7f6e3040 00038 (v01 HP-CPC AWRDACPI 42302E31 AWRD 00000000)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: FACP 7f6e30c0 00074 (v01 HP-CPC AWRDACPI 42302E31 AWRD 00000000)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: DSDT 7f6e3180 056ED (v01 HP-CPC AWRDACPI 00001000 MSFT 0100000E)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: FACS 7f6e0000 00040
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: MCFG 7f6e89c0 0003C (v01 HP-CPC AWRDACPI 42302E31 AWRD 00000000)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: APIC 7f6e88c0 00084 (v01 HP-CPC AWRDACPI 42302E31 AWRD 00000000)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: SSDT 7f6e8a40 0015C (v01 HP-CPC  Cpu0Ist 00003000 INTL 20040311)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: SSDT 7f6e8ed0 00275 (v01 HP-CPC    CpuPm 00003000 INTL 20040311)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] 1154MB HIGHMEM available.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] 883MB LOWMEM available.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]   mapped low ram: 0 - 373fe000
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]   low ram: 0 - 373fe000
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Zone ranges:
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]   Normal   [mem 0x01000000-0x373fdfff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]   HighMem  [mem 0x373fe000-0x7f6dffff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Movable zone start for each node
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Early memory node ranges
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]   node   0: [mem 0x00010000-0x00097fff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]   node   0: [mem 0x00100000-0x7f6dffff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Using APIC driver default
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] PM: Registered nosave memory: 0000000000098000 - 0000000000099000
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] PM: Registered nosave memory: 0000000000099000 - 00000000000a0000
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] e820: [mem 0x7f700000-0xefffffff] available for PCI devices
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] PERCPU: Embedded 13 pages/cpu @f73bd000 s32256 r0 d20992 u53248
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517754
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.6.0-rc6 root=/dev/mapper/vg_rajhome2-lv_root ro rd.md=0 rd.dm=0 rd.lvm.lv=vg_rajhome2/lv_swap SYSFONT=True rd.lvm.lv=vg_rajhome2/lv_root KEYTABLE=us rd.luks=0 LANG=en_US.UTF-8
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] __ex_table already sorted, skipping sort
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Initializing CPU#0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Initializing HighMem for node 0 (000373fe:0007f6e0)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Memory: 2044880k/2087808k available (5436k kernel code, 42448k reserved, 2708k data, 624k init, 1182600k highmem)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] virtual kernel memory layout:
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]     fixmap  : 0xffa96000 - 0xfffff000   (5540 kB)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]       .init : 0xc0bf5000 - 0xc0c91000   ( 624 kB)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]       .data : 0xc094f12d - 0xc0bf4140   (2708 kB)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000]       .text : 0xc0400000 - 0xc094f12d   (5436 kB)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Hierarchical RCU implementation.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] 	RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=4.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] NR_IRQS:2304 nr_irqs:712 16
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] Console: colour dummy device 80x25
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] console [tty0] enabled
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] tsc: Fast TSC calibration using PIT
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.000000] tsc: Detected 2800.717 MHz processor
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.001002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5601.43 BogoMIPS (lpj=2800717)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.001016] pid_max: default: 32768 minimum: 301
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.001064] Security Framework initialized
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.001077] SELinux:  Initializing.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002055] Mount-cache hash table entries: 512
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002379] Initializing cgroup subsys cpuacct
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002388] Initializing cgroup subsys devices
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002395] Initializing cgroup subsys freezer
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002402] Initializing cgroup subsys net_cls
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002407] Initializing cgroup subsys blkio
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002413] Initializing cgroup subsys perf_event
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002468] CPU: Physical Processor ID: 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002475] CPU: Processor Core ID: 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002481] mce: CPU supports 4 MCE banks
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002498] CPU0: Thermal monitoring enabled (TM1)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002507] process: using mwait in idle threads
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002524] Last level iTLB entries: 4KB 128, 2MB 128, 4MB 128
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002524] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 64
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.002524] tlb_flushall_shift is 0x6
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.004116] ACPI: Core revision 20120711
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.010032] ftrace: allocating 22521 entries in 44 pages
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.019084] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.019477] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.029839] smpboot: CPU0: Intel(R) Pentium(R) D CPU 2.80GHz stepping 04
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.029995] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.029995] ... version:                0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.029995] ... bit width:              40
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.029995] ... generic registers:      18
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.029995] ... value mask:             000000ffffffffff
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.029995] ... max period:             0000007fffffffff
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.029995] ... fixed-purpose events:   0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.029995] ... event mask:             000000000003ffff
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.030145] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.001999] Initializing CPU#1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.030346] smpboot: Booting Node   0, Processors  #1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.042058] Brought up 2 CPUs
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.042072] smpboot: Total of 2 processors activated (11202.86 BogoMIPS)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.043141] devtmpfs: initialized
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.044208] PM: Registering ACPI NVS region [mem 0x7f6e0000-0x7f6e2fff] (12288 bytes)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.045975] atomic64 test passed for i586+ platform with CX8 and with SSE
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.046023] RTC time:  0:50:04, date: 09/29/12
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.046100] NET: Registered protocol family 16
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.046572] ACPI: bus type pci registered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.046663] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xf0000000-0xffffffff] (base 0xf0000000)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.046675] PCI: MMCONFIG at [mem 0xf0000000-0xffffffff] reserved in E820
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.046682] PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000) (size reduced!)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.046689] PCI: Using MMCONFIG for extended config space
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.046694] PCI: Using configuration type 1 for base access
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.048598] bio: create slab <bio-0> at 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.048598] ACPI: Added _OSI(Module Device)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.048598] ACPI: Added _OSI(Processor Device)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.048598] ACPI: Added _OSI(3.0 _SCP Extensions)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.048598] ACPI: Added _OSI(Processor Aggregator Device)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.057368] ACPI: SSDT 7f6e8e40 00087 (v01 HP-CPC  Cpu1Ist 00003000 INTL 20040311)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.057768] ACPI: Dynamic OEM Table Load:
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.057777] ACPI: SSDT   (null) 00087 (v01 HP-CPC  Cpu1Ist 00003000 INTL 20040311)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.058167] ACPI: Interpreter enabled
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.058187] ACPI: (supports S0 S1 S3 S4 S5)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.058226] ACPI: Using IOAPIC for interrupt routing
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.064169] ACPI: No dock devices found.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.064185] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.064285] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.064442] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.064507] PCI host bridge to bus 0000:00
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.064520] pci_bus 0000:00: root bus resource [bus 00-ff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.064526] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.064533] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.066492] pci 0000:00:1e.0: PCI bridge to [bus 01] (subtractive decode)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.067063]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.067072]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.077585] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.077686] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.077789] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.077890] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.077996] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12 14 15)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078095] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078197] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078298] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] vgaarb: loaded
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] vgaarb: bridge control possible 0000:00:02.0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] SCSI subsystem initialized
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] ACPI: bus type scsi registered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] ACPI: bus type usb registered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] usbcore: registered new interface driver usbfs
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] usbcore: registered new interface driver hub
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] usbcore: registered new device driver usb
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.078393] PCI: Using ACPI for IRQ routing
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.081100] NetLabel: Initializing
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.081106] NetLabel:  domain hash size = 128
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.081110] NetLabel:  protocols = UNLABELED CIPSOv4
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.081129] NetLabel:  unlabeled traffic allowed by default
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.093417] pnp: PnP ACPI init
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.093450] ACPI: bus type pnp registered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.093946] system 00:01: [io  0x04d0-0x04d1] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.093954] system 00:01: [io  0x0800-0x087f] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.093961] system 00:01: [io  0x0880-0x088f] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095060] system 00:07: [io  0x0400-0x04bf] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095552] system 00:09: [mem 0xf0000000-0xf3ffffff] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095917] system 00:0a: [mem 0x000d0800-0x000d3fff] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095926] system 00:0a: [mem 0x000f0000-0x000f7fff] could not be reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095933] system 00:0a: [mem 0x000f8000-0x000fbfff] could not be reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095941] system 00:0a: [mem 0x000fc000-0x000fffff] could not be reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095949] system 00:0a: [mem 0x7f6e0000-0x7f6fffff] could not be reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095956] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095963] system 00:0a: [mem 0x00100000-0x7f6dffff] could not be reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095971] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095979] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.095992] system 00:0a: [mem 0xffb00000-0xffb7ffff] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.096000] system 00:0a: [mem 0xfff00000-0xffffffff] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.096008] system 00:0a: [mem 0x000e0000-0x000effff] has been reserved
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.096030] pnp: PnP ACPI: found 11 devices
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.096036] ACPI: ACPI bus type pnp unregistered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.134285] Switching to clocksource acpi_pm
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.134342] pci 0000:00:1e.0: PCI bridge to [bus 01]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.134352] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.134362] pci 0000:00:1e.0:   bridge window [mem 0xfde00000-0xfdefffff]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.134458] NET: Registered protocol family 2
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.134680] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.134998] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.135323] TCP: Hash tables configured (established 131072 bind 65536)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.135362] TCP: reno registered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.135370] UDP hash table entries: 512 (order: 2, 16384 bytes)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.135384] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.135479] NET: Registered protocol family 1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.135696] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.135791] Unpacking initramfs...
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.602477] Freeing initrd memory: 15264k freed
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.611451] apm: BIOS not found.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.611916] audit: initializing netlink socket (disabled)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.611939] type=2000 audit(1348879803.610:1): initialized
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.635334] bounce pool size: 64 pages
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.635356] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.637983] VFS: Disk quotas dquot_6.5.2
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.638077] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.638840] msgmni has been set to 1713
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.639839] alg: No test for stdrng (krng)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.639873] NET: Registered protocol family 38
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.639936] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.639992] io scheduler noop registered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.639999] io scheduler deadline registered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.640030] io scheduler cfq registered (default)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.640251] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.640287] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.640294] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.640738] vesafb: mode is 1280x1024x32, linelength=5120, pages=0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.640745] vesafb: scrolling: redraw
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.640752] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.641262] vesafb: framebuffer at 0xe0000000, mapped to 0xf7c80000, using 5120k, total 5120k
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.739385] Console: switching to colour frame buffer device 160x64
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.831343] fb0: VESA VGA frame buffer device
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.831956] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.832868] ACPI: Power Button [PWRB]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.833360] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.834185] ACPI: Power Button [PWRF]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.834650] ACPI: Fan [FAN] (on)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.835268] ACPI: Requesting acpi_cpufreq
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.848124] thermal LNXTHERM:00: registered as thermal_zone0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.848742] ACPI: Thermal Zone [THRM] (40 C)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.849282] GHES: HEST is not enabled!
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.849801] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.851373] Non-volatile memory driver v1.3
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.851839] Linux agpgart interface v0.103
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.852437] agpgart-intel 0000:00:00.0: Intel 945G Chipset
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.853111] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.854832] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.855758] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.858078] loop: module loaded
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.858674] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl RAID mode
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.859575] ahci 0000:00:1f.2: flags: 64bit ncq led clo 
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.861001] scsi0 : ahci
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.861432] scsi1 : ahci
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.861828] scsi2 : ahci
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.862245] scsi3 : ahci
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.862587] ata1: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe100 irq 40
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.863411] ata2: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe180 irq 40
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.864232] ata3: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe200 irq 40
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.865052] ata4: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe280 irq 40
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.866475] scsi4 : ata_piix
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.867316] scsi5 : ata_piix
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.867708] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.868488] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.869375] libphy: Fixed MDIO Bus: probed
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.869938] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.895835] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.921734] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.951757] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdfff000
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    0.983035] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.008775] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.030495] ata5.00: ATAPI: HL-DT-STDVDRRW GSA-H20L, S632, max UDMA/33
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.060740] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.063355] ata5.00: configured for UDMA/33
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.112929] usb usb1: Product: EHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.139116] usb usb1: Manufacturer: Linux 3.6.0-rc6 ehci_hcd
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.165452] usb usb1: SerialNumber: 0000:00:1d.7
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.191467] ata2: SATA link down (SStatus 0 SControl 300)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.191496] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.215038] ata3: SATA link down (SStatus 0 SControl 300)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.215064] ata4: SATA link down (SStatus 0 SControl 300)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217608] hub 1-0:1.0: USB hub found
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217614] hub 1-0:1.0: 8 ports detected
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217746] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217767] uhci_hcd: USB Universal Host Controller Interface driver
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217813] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217884] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217916] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fe00
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217964] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217966] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217968] usb usb2: Product: UHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217971] usb usb2: Manufacturer: Linux 3.6.0-rc6 uhci_hcd
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.217973] usb usb2: SerialNumber: 0000:00:1d.0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218128] hub 2-0:1.0: USB hub found
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218133] hub 2-0:1.0: 2 ports detected
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218231] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218285] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218328] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fd00
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218368] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218371] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218373] usb usb3: Product: UHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218375] usb usb3: Manufacturer: Linux 3.6.0-rc6 uhci_hcd
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218377] usb usb3: SerialNumber: 0000:00:1d.1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218515] hub 3-0:1.0: USB hub found
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218519] hub 3-0:1.0: 2 ports detected
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218614] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218672] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218709] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fc00
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218755] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218757] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218759] usb usb4: Product: UHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218762] usb usb4: Manufacturer: Linux 3.6.0-rc6 uhci_hcd
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218764] usb usb4: SerialNumber: 0000:00:1d.2
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218903] hub 4-0:1.0: USB hub found
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.218907] hub 4-0:1.0: 2 ports detected
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219015] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219068] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219105] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000fb00
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219144] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219147] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219149] usb usb5: Product: UHCI Host Controller
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219151] usb usb5: Manufacturer: Linux 3.6.0-rc6 uhci_hcd
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219153] usb usb5: SerialNumber: 0000:00:1d.3
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219283] hub 5-0:1.0: USB hub found
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219288] hub 5-0:1.0: 2 ports detected
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219440] usbcore: registered new interface driver usbserial
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219458] usbcore: registered new interface driver usbserial_generic
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219468] USB Serial support registered for generic
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219472] usbserial: USB Serial Driver core
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.219535] i8042: PNP: No PS/2 controller found. Probing ports directly.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.243543] ata1.00: ATA-7: WDC WD3000JS-60PDB0, 21.00M21, max UDMA/100
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.243547] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 1), AA
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.244584] serio: i8042 KBD port at 0x60,0x64 irq 1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.244591] serio: i8042 AUX port at 0x60,0x64 irq 12
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.244720] mousedev: PS/2 mouse device common for all mice
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.244957] rtc_cmos 00:03: RTC can wake from S4
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.245117] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.245145] rtc0: alarms up to one month, 242 bytes nvram
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.245297] device-mapper: uevent: version 1.0.3
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.245402] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.245471] cpuidle: using governor ladder
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.245473] cpuidle: using governor menu
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.245887] EFI Variables Facility v0.08 2004-May-17
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.246064] usbcore: registered new interface driver usbhid
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.246065] usbhid: USB HID core driver
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.246105] drop_monitor: Initializing network drop monitor service
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    1.246240] ip_tables: (C) 2000-2006 Netfilter Core Team
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    2.894708] tsc: Refined TSC clocksource calibration: 2800.795 MHz
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    2.919612] TCP: cubic registered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    2.919615] Switching to clocksource tsc
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    2.968410] Initializing XFRM netlink socket
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    2.993113] ata1.00: configured for UDMA/100
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.017830] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3000JS-60P 21.0 PQ: 0 ANSI: 5
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.017951] NET: Registered protocol family 10
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.018220] mip6: Mobile IPv6
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.018223] NET: Registered protocol family 17
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.018236] Key type dns_resolver registered
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.018546] Using IPI No-Shortcut mode
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.018683] registered taskstats version 1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.019114]   Magic number: 12:980:810
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.217033] rtc_cmos 00:03: setting system clock to 2012-09-29 00:50:07 UTC (1348879807)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.242418] sd 0:0:0:0: [sda] 586072368 512-byte logical blocks: (300 GB/279 GiB)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.268165] sd 0:0:0:0: [sda] Write Protect is off
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.297930] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.324565] sd 0:0:0:0: Attached scsi generic sg0 type 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.350738]  sda: sda1 sda2
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.376963] sd 0:0:0:0: [sda] Attached SCSI disk
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.403891] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRRW GSA-H20L  S632 PQ: 0 ANSI: 5
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.433527] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.450041] usb 1-7: new high-speed USB device number 4 using ehci_hcd
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.486949] cdrom: Uniform CD-ROM driver Revision: 3.20
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.514177] sr 4:0:0:0: Attached scsi generic sg1 type 5
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.542193] Freeing unused kernel memory: 624k freed
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.570530] Write protecting the kernel text: 5440k
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.602381] Write protecting the kernel read-only data: 2188k
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.615019] usb 1-7: New USB device found, idVendor=058f, idProduct=6362
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.615022] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.615025] usb 1-7: Product: Mass Storage Device
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.615028] usb 1-7: Manufacturer: Generic
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    3.615030] usb 1-7: SerialNumber: 058F312D81B1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.026046] usb 2-1: new low-speed USB device number 2 using uhci_hcd
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.057489] [drm] Initialized drm 1.1.0 20060810
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.126680] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.155842] Console: switching to colour dummy device 80x25
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.156350] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.156359] [drm] Driver supports precise vblank timestamp query.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.156950] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.207311] [drm] initialized overlay support
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.234065] usb 2-1: New USB device found, idVendor=04ca, idProduct=004f
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.234075] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.234084] usb 2-1: Product: USB Multimedia Keyboard
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.234091] usb 2-1: Manufacturer: Lite-On Technology Corp.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.252953] input: Lite-On Technology Corp. USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input2
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.253130] hid-generic 0003:04CA:004F.0001: input,hidraw0: USB HID v1.10 Keyboard [Lite-On Technology Corp. USB Multimedia Keyboard] on usb-0000:00:1d.0-1/input0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.262474] fbcon: inteldrmfb (fb0) is primary device
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.276212] input: Lite-On Technology Corp. USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.1/input/input3
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.276353] hid-generic 0003:04CA:004F.0002: input,hidraw1: USB HID v1.10 Device [Lite-On Technology Corp. USB Multimedia Keyboard] on usb-0000:00:1d.0-1/input1
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.291131] Console: switching to colour frame buffer device 160x64
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.298338] fb0: inteldrmfb frame buffer device
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.298378] drm: registered panic notifier
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.298421] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.482050] usb 2-2: new low-speed USB device number 3 using uhci_hcd
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.506743] Initializing USB Mass Storage driver...
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.508093] scsi6 : usb-storage 1-7:1.0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.508303] usbcore: registered new interface driver usb-storage
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.508362] USB Mass Storage support registered.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.566085] firewire_ohci 0000:01:01.0: added OHCI v1.0 device as card 0, 4 IR + 8 IT contexts, quirks 0x11
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.644083] usb 2-2: New USB device found, idVendor=046d, idProduct=c05a
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.644155] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.644220] usb 2-2: Product: USB Optical Mouse
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.644263] usb 2-2: Manufacturer: Logitech
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.660889] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input4
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    4.661198] hid-generic 0003:046D:C05A.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.0-2/input0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.067162] firewire_core 0000:01:01.0: created device fw0: GUID 0011d80000b1c0a5, S400
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.362183] EXT4-fs (dm-1): INFO: recovery required on readonly filesystem
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.362256] EXT4-fs (dm-1): write access will be enabled during recovery
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.510862] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.511608] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.512356] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.513108] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.515557] sd 6:0:0:0: Attached scsi generic sg2 type 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.516759] sd 6:0:0:1: Attached scsi generic sg3 type 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.518048] sd 6:0:0:2: Attached scsi generic sg4 type 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.518774] sd 6:0:0:3: Attached scsi generic sg5 type 0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.519972] sd 6:0:0:0: [sdb] Attached SCSI removable disk
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.521224] sd 6:0:0:1: [sdc] Attached SCSI removable disk
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.523719] sd 6:0:0:2: [sdd] Attached SCSI removable disk
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    5.527994] sd 6:0:0:3: [sde] Attached SCSI removable disk
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    6.339566] EXT4-fs (dm-1): orphan cleanup on readonly fs
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    6.342858] EXT4-fs (dm-1): 19 orphan inodes deleted
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    6.345462] EXT4-fs (dm-1): recovery complete
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    6.439314] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    6.739252] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    7.555879] type=1404 audit(1348879812.036:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    7.989940] SELinux:  Permission wake_alarm in class capability2 not defined in policy.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    7.992652] SELinux:  Permission block_suspend in class capability2 not defined in policy.
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    7.995362] SELinux: the above unknown classes and permissions will be allowed
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [    8.026275] type=1403 audit(1348879812.506:3): policy loaded auid=4294967295 ses=4294967295
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   11.263075] EXT4-fs (dm-1): re-mounted. Opts: (null)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   13.778671] microcode: CPU0 sig=0xf64, pf=0x4, revision=0x4
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   13.930135] microcode: CPU1 sig=0xf64, pf=0x4, revision=0x4
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   13.933646] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.256536] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.280805] input: PC Speaker as /devices/platform/pcspkr/input/input5
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.702212] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts with Region \PM2S 1 (20120711/utaddress-251)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.704547] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts with Region \PM1K 2 (20120711/utaddress-251)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.706745] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts with Region \GPE1 3 (20120711/utaddress-251)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.708863] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.711024] ACPI Warning: 0x00000480-0x000004bf SystemIO conflicts with Region \GPIV 1 (20120711/utaddress-251)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.713189] ACPI Warning: 0x00000480-0x000004bf SystemIO conflicts with Region \GPO2 2 (20120711/utaddress-251)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.715381] ACPI Warning: 0x00000480-0x000004bf SystemIO conflicts with Region \GPO_ 3 (20120711/utaddress-251)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.717562] ACPI Warning: 0x00000480-0x000004bf SystemIO conflicts with Region \PALD 4 (20120711/utaddress-251)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.719735] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.721829] lpc_ich: Resource conflict(s) found affecting gpio_ich
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.783882] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.786276] e100: Copyright(c) 1999-2006 Intel Corporation
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.813734] e100 0000:01:08.0: eth0: addr 0xfdefe000, irq 20, MAC addr 00:17:31:ab:7c:51
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.843272] parport_pc 00:06: reported by Plug and Play ACPI
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.845581] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   14.867141] ppdev: user-space parallel port driver
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   15.478149] leds_ss4200: no LED devices found
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   15.680740] iTCO_vendor_support: vendor-support=0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   15.767433] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   15.769709] iTCO_wdt: Found a ICH7DH TCO device (Version=2, TCOBASE=0x0460)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   15.772218] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   17.689589] Adding 9404412k swap on /dev/mapper/vg_rajhome2-lv_swap.  Priority:0 extents:1 across:9404412k 
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   18.566550] hda_codec: ALC882: SKU not ready 0x411111f0
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   18.593257] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   18.596072] input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   18.598823] input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   22.654321] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   41.112673] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   41.703417] ip6_tables: (C) 2000-2006 Netfilter Core Team
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   41.790422] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> Sep 28 19:50:46 adsl-108-199-65-102 chronyd[656]: chronyd version 1.27-pre1 starting
> Sep 28 19:50:46 adsl-108-199-65-102 chronyd[656]: Linux kernel major=3 minor=6 patch=0
> Sep 28 19:50:46 adsl-108-199-65-102 chronyd[656]: hz=100 shift_hz=7 freq_scale=1.00000000 nominal_tick=10000 slew_delta_tick=833 max_tick_bias=1000 shift_pll=2
> Sep 28 19:50:46 adsl-108-199-65-102 chronyd[656]: Frequency 10.340 +/- 1.392 ppm read from /var/lib/chrony/drift
> Sep 28 19:50:46 adsl-108-199-65-102 iptables.init[566]: iptables: Applying firewall rules: [  OK  ]
> Sep 28 19:50:46 adsl-108-199-65-102 ip6tables.init[565]: ip6tables: Applying firewall rules: [  OK  ]
> Sep 28 19:50:46 adsl-108-199-65-102 iptables.init[566]: iptables: Loading additional modules: nf_conntrack_netbios_ns [  OK  ]
> Sep 28 19:50:46 adsl-108-199-65-102 ip6tables.init[565]: ip6tables: Loading additional modules: nf_conntrack_netbios_ns [  OK  ]
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> VPN: loaded org.freedesktop.NetworkManager.openconnect
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> VPN: loaded org.freedesktop.NetworkManager.openvpn
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> VPN: loaded org.freedesktop.NetworkManager.pptp
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> VPN: loaded org.freedesktop.NetworkManager.vpnc
> Sep 28 19:50:46 adsl-108-199-65-102 systemd-logind[617]: New seat seat0.
> Sep 28 19:50:46 adsl-108-199-65-102 avahi-daemon[621]: Successfully called chroot().
> Sep 28 19:50:46 adsl-108-199-65-102 avahi-daemon[621]: Successfully dropped remaining capabilities.
> Sep 28 19:50:46 adsl-108-199-65-102 avahi-daemon[621]: Loading service file /services/udisks.service.
> Sep 28 19:50:46 adsl-108-199-65-102 avahi-daemon[621]: Network interface enumeration completed.
> Sep 28 19:50:46 adsl-108-199-65-102 avahi-daemon[621]: Registering HINFO record with values 'I686'/'LINUX'.
> Sep 28 19:50:46 adsl-108-199-65-102 avahi-daemon[621]: Server startup complete. Host name is adsl-108-199-65-102.local. Local service cookie is 590836940.
> Sep 28 19:50:46 adsl-108-199-65-102 avahi-daemon[621]: Service "adsl-108-199-65-102" (/services/udisks.service) successfully established.
> Sep 28 19:50:46 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
> Sep 28 19:50:46 adsl-108-199-65-102 dbus[686]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
> Sep 28 19:50:46 adsl-108-199-65-102 util-vserver[680]: Creating required directories...[  OK  ]
> Sep 28 19:50:46 adsl-108-199-65-102 util-vserver[680]: Setting path to vshelper...[PASSED]
> Sep 28 19:50:46 adsl-108-199-65-102 util-vserver[680]: Loading default device map...[  OK  ]
> Sep 28 19:50:46 adsl-108-199-65-102 polkitd[722]: started daemon version 0.104 using authority implementation `local' version `0.104'
> Sep 28 19:50:46 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.PolicyKit1'
> Sep 28 19:50:46 adsl-108-199-65-102 TCSD TDDL[737]: TrouSerS ERROR: Could not find a device to open!
> Sep 28 19:50:46 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.PolicyKit1'
> Sep 28 19:50:46 adsl-108-199-65-102 tcsd[676]: Starting tcsd: [FAILED]
> Sep 28 19:50:46 adsl-108-199-65-102 systemd[1]: tcsd.service: control process exited, code=exited status=137
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]:    ifcfg-rh: Acquired D-Bus service com.redhat.ifcfgrh1
> Sep 28 19:50:46 adsl-108-199-65-102 systemd[1]: Unit tcsd.service entered failed state.
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Loaded plugin ifcfg-rh: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
> Sep 28 19:50:46 adsl-108-199-65-102 util-vserver[680]: Mounting cgroup-hierarchy...mount: vserver is already mounted or /dev/cgroup busy
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Loaded plugin keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]:    ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-eth0 ...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <warn> failed to allocate link cache: (-10) Operation not supported
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]:    ifcfg-rh:     read connection 'System eth0'
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]:    ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-lo ...
> Sep 28 19:50:46 adsl-108-199-65-102 util-vserver[680]: [FAILED]
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> trying to start the modem manager...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> monitoring kernel firmware directory '/lib/firmware'.
> Sep 28 19:50:46 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='org.freedesktop.ModemManager' (using servicehelper)
> Sep 28 19:50:46 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating via systemd: service name='org.bluez' unit='dbus-org.bluez.service'
> Sep 28 19:50:46 adsl-108-199-65-102 dbus[686]: [system] Activating service name='org.freedesktop.ModemManager' (using servicehelper)
> Sep 28 19:50:46 adsl-108-199-65-102 dbus[686]: [system] Activating via systemd: service name='org.bluez' unit='dbus-org.bluez.service'
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> WiFi enabled by radio killswitch; enabled by state file
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> WWAN enabled by radio killswitch; enabled by state file
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> WiMAX enabled by radio killswitch; enabled by state file
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Networking is enabled by state file
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Setting system hostname to 'rajhome2' (from system configuration)
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  ModemManager (version 0.6.0.0-1.fc17) starting...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <warn> failed to allocate link cache: (-10) Operation not supported
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): carrier is OFF
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): new Ethernet device (driver: 'e100' ifindex: 2)
> Sep 28 19:50:46 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  ModemManager (version 0.6.0.0-1.fc17) starting...
> Sep 28 19:50:46 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='org.freedesktop.nm_dispatcher' (using servicehelper)
> Sep 28 19:50:46 adsl-108-199-65-102 dbus[686]: [system] Activating service name='org.freedesktop.nm_dispatcher' (using servicehelper)
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): exported as /org/freedesktop/NetworkManager/Devices/0
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): now managed
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   42.367434] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   42.369375] e100 0000:01:08.0: eth0: NIC Link is Up 100 Mbps Full Duplex
> Sep 28 19:50:46 adsl-108-199-65-102 kernel: [   42.371536] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): bringing up device.
> Sep 28 19:50:46 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.ModemManager'
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): carrier now ON (device state 20)
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): preparing device.
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): deactivating device (reason 'managed') [2]
> Sep 28 19:50:46 adsl-108-199-65-102 bluetoothd[748]: Bluetooth daemon 4.99
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <warn> /sys/devices/virtual/net/lo: couldn't determine device driver; ignoring...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <warn> /sys/devices/virtual/net/lo: couldn't determine device driver; ignoring...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): carrier now OFF (device state 20)
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): carrier now ON (device state 20)
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: (nm-device.c:4478):nm_device_queue_state: runtime check failed: (priv->queued_state.id == 0)
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): device state change: unavailable -> disconnected (reason 'carrier-changed') [20 30 40]
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> modem-manager is now available
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Auto-activating connection 'System eth0'.
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) starting connection 'System eth0'
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): device state change: disconnected -> prepare (reason 'none') [30 40 0]
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 1 of 5 (Device Prepare) scheduled...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 1 of 5 (Device Prepare) started...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 2 of 5 (Device Configure) scheduled...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 1 of 5 (Device Prepare) complete.
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 2 of 5 (Device Configure) starting...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): device state change: prepare -> config (reason 'none') [40 50 0]
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 2 of 5 (Device Configure) successful.
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 3 of 5 (IP Configure Start) scheduled.
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 2 of 5 (Device Configure) complete.
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 3 of 5 (IP Configure Start) started...
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): device state change: config -> ip-config (reason 'none') [50 70 0]
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Beginning DHCPv4 transaction (timeout in 45 seconds)
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> dhclient started with pid 761
> Sep 28 19:50:46 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 3 of 5 (IP Configure Start) complete.
> Sep 28 19:50:46 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
> Sep 28 19:50:46 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.bluez'
> Sep 28 19:50:46 adsl-108-199-65-102 bluetoothd[748]: Starting SDP server
> Sep 28 19:50:46 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.ModemManager'
> Sep 28 19:50:46 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
> Sep 28 19:50:46 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.bluez'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'SimTech'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'AnyData'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Huawei'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Wavecom'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'X22X'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Samsung'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Sierra'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Gobi'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Nokia'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Longcheer'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Novatel'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Ericsson MBM'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'MotoC'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Linktop'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Option High-Speed'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Option'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'ZTE'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Iridium'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Cinterion'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Loaded plugin 'Generic'
> Sep 28 19:50:46 adsl-108-199-65-102 modem-manager[747]: <info>  Successfully loaded 20 plugins
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: Internet Systems Consortium DHCP Client 4.2.4-P2
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: Copyright 2004-2012 Internet Systems Consortium.
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: All rights reserved.
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: For info, please visit https://www.isc.org/software/dhcp/
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: 
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'SimTech'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'AnyData'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Huawei'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Wavecom'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'X22X'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Samsung'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Sierra'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Gobi'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Nokia'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Longcheer'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Novatel'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Ericsson MBM'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'MotoC'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Linktop'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Option High-Speed'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Option'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'ZTE'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Iridium'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Cinterion'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Loaded plugin 'Generic'
> Sep 28 19:50:47 adsl-108-199-65-102 dbus-daemon[686]: modem-manager[747]: <info>  Successfully loaded 20 plugins
> Sep 28 19:50:47 adsl-108-199-65-102 bluetoothd[748]: bluetoothd[748]: Bluetooth daemon 4.99
> Sep 28 19:50:47 adsl-108-199-65-102 bluetoothd[748]: bluetoothd[748]: Starting SDP server
> Sep 28 19:50:47 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): DHCPv4 state changed nbi -> preinit
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: Listening on LPF/eth0/00:17:31:ab:7c:51
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: Sending on   LPF/eth0/00:17:31:ab:7c:51
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: Sending on   Socket/fallback
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: DHCPREQUEST on eth0 to 255.255.255.255 port 67 (xid=0xe5a9543)
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: DHCPACK from 192.168.1.254 (xid=0xe5a9543)
> Sep 28 19:50:47 adsl-108-199-65-102 vservers-default[753]: Starting vservers of type 'default'...[  OK  ]
> Sep 28 19:50:47 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): DHCPv4 state changed preinit -> reboot
> Sep 28 19:50:47 adsl-108-199-65-102 NetworkManager[575]: <info>   address 192.168.1.104
> Sep 28 19:50:47 adsl-108-199-65-102 NetworkManager[575]: <info>   prefix 24 (255.255.255.0)
> Sep 28 19:50:47 adsl-108-199-65-102 NetworkManager[575]: <info>   gateway 192.168.1.254
> Sep 28 19:50:47 adsl-108-199-65-102 NetworkManager[575]: <info>   nameserver '192.168.1.254'
> Sep 28 19:50:47 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
> Sep 28 19:50:47 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 5 of 5 (IPv4 Commit) started...
> Sep 28 19:50:47 adsl-108-199-65-102 avahi-daemon[621]: Joining mDNS multicast group on interface eth0.IPv4 with address 192.168.1.104.
> Sep 28 19:50:47 adsl-108-199-65-102 kernel: [   42.665698] Bluetooth: Core ver 2.16
> Sep 28 19:50:47 adsl-108-199-65-102 kernel: [   42.668012] NET: Registered protocol family 31
> Sep 28 19:50:47 adsl-108-199-65-102 kernel: [   42.670118] Bluetooth: HCI device and connection manager initialized
> Sep 28 19:50:47 adsl-108-199-65-102 dhclient[761]: bound to 192.168.1.104 -- renewal in 1591 seconds.
> Sep 28 19:50:47 adsl-108-199-65-102 avahi-daemon[621]: New relevant interface eth0.IPv4 for mDNS.
> Sep 28 19:50:47 adsl-108-199-65-102 kernel: [   42.676089] Bluetooth: HCI socket layer initialized
> Sep 28 19:50:47 adsl-108-199-65-102 kernel: [   42.677947] Bluetooth: L2CAP socket layer initialized
> Sep 28 19:50:47 adsl-108-199-65-102 kernel: [   42.679787] Bluetooth: SCO socket layer initialized
> Sep 28 19:50:47 adsl-108-199-65-102 avahi-daemon[621]: Registering new address record for 192.168.1.104 on eth0.IPv4.
> Sep 28 19:50:47 adsl-108-199-65-102 kernel: [   42.731402] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> Sep 28 19:50:47 adsl-108-199-65-102 kernel: [   42.733829] Bluetooth: BNEP filters: protocol multicast
> Sep 28 19:50:47 adsl-108-199-65-102 bluetoothd[748]: bluetoothd[748]: Parsing /etc/bluetooth/input.conf failed: No such file or directory
> Sep 28 19:50:47 adsl-108-199-65-102 bluetoothd[748]: Parsing /etc/bluetooth/input.conf failed: No such file or directory
> Sep 28 19:50:47 adsl-108-199-65-102 bluetoothd[748]: Parsing /etc/bluetooth/audio.conf failed: No such file or directory
> Sep 28 19:50:47 adsl-108-199-65-102 bluetoothd[748]: bluetoothd[748]: Parsing /etc/bluetooth/audio.conf failed: No such file or directory
> Sep 28 19:50:48 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating via systemd: service name='org.freedesktop.Accounts' unit='accounts-daemon.service'
> Sep 28 19:50:48 adsl-108-199-65-102 dbus[686]: [system] Activating via systemd: service name='org.freedesktop.Accounts' unit='accounts-daemon.service'
> Sep 28 19:50:48 adsl-108-199-65-102 accounts-daemon[843]: started daemon version 0.6.21
> Sep 28 19:50:48 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.Accounts'
> Sep 28 19:50:48 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.Accounts'
> Sep 28 19:50:48 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): device state change: ip-config -> activated (reason 'none') [70 100 0]
> Sep 28 19:50:48 adsl-108-199-65-102 NetworkManager[575]: <info> Policy set 'System eth0' (eth0) as default for IPv4 routing and DNS.
> Sep 28 19:50:48 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) successful, device activated.
> Sep 28 19:50:48 adsl-108-199-65-102 NetworkManager[575]: <info> Activation (eth0) Stage 5 of 5 (IPv4 Commit) complete.
> Sep 28 19:50:48 adsl-108-199-65-102 avahi-daemon[621]: Registering new address record for fe80::217:31ff:feab:7c51 on eth0.*.
> Sep 28 19:50:48 adsl-108-199-65-102 systemd-logind[617]: New session 1 of user gdm.
> Sep 28 19:50:48 adsl-108-199-65-102 systemd-logind[617]: Linked /tmp/.X11-unix/X0 to /run/user/gdm/X11-display.
> Sep 28 19:50:48 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating via systemd: service name='org.freedesktop.UPower' unit='upower.service'
> Sep 28 19:50:48 adsl-108-199-65-102 dbus[686]: [system] Activating via systemd: service name='org.freedesktop.UPower' unit='upower.service'
> Sep 28 19:50:48 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.UPower'
> Sep 28 19:50:48 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.UPower'
> Sep 28 19:50:49 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating via systemd: service name='org.freedesktop.RealtimeKit1' unit='rtkit-daemon.service'
> Sep 28 19:50:49 adsl-108-199-65-102 dbus[686]: [system] Activating via systemd: service name='org.freedesktop.RealtimeKit1' unit='rtkit-daemon.service'
> Sep 28 19:50:49 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.RealtimeKit1'
> Sep 28 19:50:49 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.RealtimeKit1'
> Sep 28 19:50:49 adsl-108-199-65-102 rtkit-daemon[923]: Successfully made thread 922 of process 922 (/usr/bin/pulseaudio) owned by '42' high priority at nice level -11.
> Sep 28 19:50:49 adsl-108-199-65-102 rtkit-daemon[923]: Successfully made thread 937 of process 922 (/usr/bin/pulseaudio) owned by '42' RT at priority 5.
> Sep 28 19:50:49 adsl-108-199-65-102 rtkit-daemon[923]: Successfully made thread 938 of process 922 (/usr/bin/pulseaudio) owned by '42' RT at priority 5.
> Sep 28 19:50:50 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='net.reactivated.Fprint' (using servicehelper)
> Sep 28 19:50:50 adsl-108-199-65-102 dbus[686]: [system] Activating service name='net.reactivated.Fprint' (using servicehelper)
> Sep 28 19:50:50 adsl-108-199-65-102 dbus-daemon[686]: Launching FprintObject
> Sep 28 19:50:51 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'net.reactivated.Fprint'
> Sep 28 19:50:51 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'net.reactivated.Fprint'
> Sep 28 19:50:51 adsl-108-199-65-102 dbus-daemon[686]: ** Message: D-Bus service launched with name: net.reactivated.Fprint
> Sep 28 19:50:51 adsl-108-199-65-102 dbus-daemon[686]: ** Message: entering main loop
> Sep 28 23:50:57 adsl-108-199-65-102 chronyd[656]: Selected source 132.163.4.102
> Sep 28 23:50:57 adsl-108-199-65-102 chronyd[656]: System clock wrong by 14398.722032 seconds, adjustment started
> Sep 28 23:50:57 adsl-108-199-65-102 chronyd[656]: System clock was stepped by 14398.722 seconds
> Sep 28 23:50:59 adsl-108-199-65-102 systemd-logind[617]: New session 2 of user raj.
> Sep 28 23:51:00 adsl-108-199-65-102 systemd-logind[617]: Linked /tmp/.X11-unix/X0 to /run/user/raj/X11-display.
> Sep 28 23:51:00 adsl-108-199-65-102 systemd-logind[617]: Removed session 1.
> Sep 28 23:51:00 adsl-108-199-65-102 gdm-simple-slave[816]: WARNING: Child process 865 was already dead.
> Sep 28 23:51:00 adsl-108-199-65-102 kernel: [   57.307100] FS-Cache: Loaded
> Sep 28 23:51:00 adsl-108-199-65-102 kernel: [   57.537972] FS-Cache: Netfs 'cifs' registered for caching
> Sep 28 23:51:00 adsl-108-199-65-102 kernel: [   57.538201] Key type cifs.spnego registered
> Sep 28 23:51:00 adsl-108-199-65-102 kernel: [   57.538220] Key type cifs.idmap registered
> Sep 28 23:51:00 adsl-108-199-65-102 kernel: [   57.539366] CIFS: no cache= option specified, using "cache=loose". This default will change to "cache=strict" in 3.7.
> Sep 28 23:51:00 adsl-108-199-65-102 kernel: [   57.581184] CIFS VFS: default security mechanism requested.  The default security mechanism will be upgraded from ntlm to ntlmv2 in kernel release 3.3
> Sep 28 23:51:00 adsl-108-199-65-102 kernel: [   57.718403] fuse init (API version 7.20)
> Sep 28 23:51:01 adsl-108-199-65-102 rtkit-daemon[923]: Successfully made thread 1168 of process 1168 (/usr/bin/pulseaudio) owned by '1000' high priority at nice level -11.
> Sep 28 23:51:01 adsl-108-199-65-102 pulseaudio[1168]: [pulseaudio] pid.c: Stale PID file, overwriting.
> Sep 28 23:51:01 adsl-108-199-65-102 rtkit-daemon[923]: Successfully made thread 1173 of process 1168 (/usr/bin/pulseaudio) owned by '1000' RT at priority 5.
> Sep 28 23:51:01 adsl-108-199-65-102 rtkit-daemon[923]: Successfully made thread 1174 of process 1168 (/usr/bin/pulseaudio) owned by '1000' RT at priority 5.
> Sep 28 23:51:01 adsl-108-199-65-102 rtkit-daemon[923]: Successfully made thread 1178 of process 1178 (/usr/bin/pulseaudio) owned by '1000' high priority at nice level -11.
> Sep 28 23:51:01 adsl-108-199-65-102 pulseaudio[1178]: [pulseaudio] pid.c: Daemon already running.
> Sep 28 23:51:02 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating via systemd: service name='org.freedesktop.ColorManager' unit='colord.service'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus[686]: [system] Activating via systemd: service name='org.freedesktop.ColorManager' unit='colord.service'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.ColorManager'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.ColorManager'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating via systemd: service name='org.freedesktop.colord-sane' unit='colord-sane.service'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus[686]: [system] Activating via systemd: service name='org.freedesktop.colord-sane' unit='colord-sane.service'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating via systemd: service name='org.freedesktop.UDisks2' unit='udisks2.service'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus[686]: [system] Activating via systemd: service name='org.freedesktop.UDisks2' unit='udisks2.service'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.colord-sane'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.colord-sane'
> Sep 28 23:51:02 adsl-108-199-65-102 udisksd[1196]: udisks daemon version 1.94.0 starting
> Sep 28 23:51:02 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.UDisks2'
> Sep 28 23:51:02 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.UDisks2'
> Sep 28 23:51:02 adsl-108-199-65-102 udisksd[1196]: Acquired the name org.freedesktop.UDisks2 on the system message bus
> Sep 28 23:51:03 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='org.freedesktop.PackageKit' (using servicehelper)
> Sep 28 23:51:03 adsl-108-199-65-102 dbus[686]: [system] Activating service name='org.freedesktop.PackageKit' (using servicehelper)
> Sep 28 23:51:03 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.PackageKit'
> Sep 28 23:51:03 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.PackageKit'
> Sep 28 23:51:06 adsl-108-199-65-102 goa[1354]: goa-daemon version 3.4.2 starting [main.c:112, main()]
> Sep 28 23:51:20 adsl-108-199-65-102 dbus-daemon[686]: ** Message: No devices in use, exit
> Sep 28 23:51:47 adsl-108-199-65-102 systemd[1]: PID file /run/sendmail.pid not readable (yet?) after start.
> Sep 28 23:52:00 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='net.reactivated.Fprint' (using servicehelper)
> Sep 28 23:52:00 adsl-108-199-65-102 dbus[686]: [system] Activating service name='net.reactivated.Fprint' (using servicehelper)
> Sep 28 23:52:00 adsl-108-199-65-102 dbus-daemon[686]: Launching FprintObject
> Sep 28 23:52:00 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'net.reactivated.Fprint'
> Sep 28 23:52:00 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'net.reactivated.Fprint'
> Sep 28 23:52:00 adsl-108-199-65-102 dbus-daemon[686]: ** Message: D-Bus service launched with name: net.reactivated.Fprint
> Sep 28 23:52:00 adsl-108-199-65-102 dbus-daemon[686]: ** Message: entering main loop
> Sep 28 23:52:30 adsl-108-199-65-102 dbus-daemon[686]: ** Message: No devices in use, exit
> Sep 28 23:52:47 adsl-108-199-65-102 systemd[1]: Startup finished in 3s 786ms 555us (kernel) + 4s 609ms 295us (initrd) + 2min 36s 17ms 248us (userspace) = 2min 44s 413ms 98us.
> Sep 28 23:53:39 adsl-108-199-65-102 kernel: [  216.134355] nf_conntrack: automatic helper assignment is deprecated and it will be removed soon. Use the iptables CT target to attach helpers instead.
> Sep 28 23:54:17 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): DHCPv4 state changed reboot -> expire
> Sep 28 23:54:17 adsl-108-199-65-102 dhclient[761]: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 7 (xid=0x6227788e)
> Sep 28 23:54:17 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): DHCPv4 state changed expire -> preinit
> Sep 28 23:54:17 adsl-108-199-65-102 dhclient[761]: DHCPREQUEST on eth0 to 255.255.255.255 port 67 (xid=0x6227788e)
> Sep 28 23:54:17 adsl-108-199-65-102 dhclient[761]: DHCPOFFER from 192.168.1.254
> Sep 28 23:54:17 adsl-108-199-65-102 dhclient[761]: DHCPACK from 192.168.1.254 (xid=0x6227788e)
> Sep 28 23:54:17 adsl-108-199-65-102 dhclient[761]: bound to 192.168.1.104 -- renewal in 1721 seconds.
> Sep 28 23:54:17 adsl-108-199-65-102 NetworkManager[575]: <info> (eth0): DHCPv4 state changed preinit -> bound
> Sep 28 23:54:17 adsl-108-199-65-102 NetworkManager[575]: <info>   address 192.168.1.104
> Sep 28 23:54:17 adsl-108-199-65-102 NetworkManager[575]: <info>   prefix 24 (255.255.255.0)
> Sep 28 23:54:17 adsl-108-199-65-102 NetworkManager[575]: <info>   gateway 192.168.1.254
> Sep 28 23:54:17 adsl-108-199-65-102 NetworkManager[575]: <info>   nameserver '192.168.1.254'
> Sep 28 23:54:17 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='org.freedesktop.nm_dispatcher' (using servicehelper)
> Sep 28 23:54:17 adsl-108-199-65-102 dbus[686]: [system] Activating service name='org.freedesktop.nm_dispatcher' (using servicehelper)
> Sep 28 23:54:17 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
> Sep 28 23:54:17 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
> Sep 28 23:55:25 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='net.reactivated.Fprint' (using servicehelper)
> Sep 28 23:55:25 adsl-108-199-65-102 dbus[686]: [system] Activating service name='net.reactivated.Fprint' (using servicehelper)
> Sep 28 23:55:25 adsl-108-199-65-102 dbus-daemon[686]: Launching FprintObject
> Sep 28 23:55:25 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'net.reactivated.Fprint'
> Sep 28 23:55:25 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'net.reactivated.Fprint'
> Sep 28 23:55:25 adsl-108-199-65-102 dbus-daemon[686]: ** Message: D-Bus service launched with name: net.reactivated.Fprint
> Sep 28 23:55:25 adsl-108-199-65-102 dbus-daemon[686]: ** Message: entering main loop
> Sep 28 23:55:55 adsl-108-199-65-102 dbus-daemon[686]: ** Message: No devices in use, exit
> Sep 28 23:57:19 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='org.freedesktop.problems' (using servicehelper)
> Sep 28 23:57:19 adsl-108-199-65-102 dbus[686]: [system] Activating service name='org.freedesktop.problems' (using servicehelper)
> Sep 28 23:57:19 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'org.freedesktop.problems'
> Sep 28 23:57:19 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'org.freedesktop.problems'
> Sep 28 23:58:05 adsl-108-199-65-102 abrtd: New client connected
> Sep 28 23:58:05 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Activating service name='net.reactivated.Fprint' (using servicehelper)
> Sep 28 23:58:05 adsl-108-199-65-102 dbus[686]: [system] Activating service name='net.reactivated.Fprint' (using servicehelper)
> Sep 28 23:58:05 adsl-108-199-65-102 dbus-daemon[686]: Launching FprintObject
> Sep 28 23:58:05 adsl-108-199-65-102 dbus-daemon[686]: dbus[686]: [system] Successfully activated service 'net.reactivated.Fprint'
> Sep 28 23:58:05 adsl-108-199-65-102 dbus[686]: [system] Successfully activated service 'net.reactivated.Fprint'
> Sep 28 23:58:05 adsl-108-199-65-102 dbus-daemon[686]: ** Message: D-Bus service launched with name: net.reactivated.Fprint
> Sep 28 23:58:05 adsl-108-199-65-102 dbus-daemon[686]: ** Message: entering main loop
> Sep 28 23:58:11 adsl-108-199-65-102 dbus-daemon[686]: abrt-dbus: '/var/spool/abrt/oops-2012-09-28-23:19:48-27440-2' does not exist
> Sep 28 23:58:21 adsl-108-199-65-102 abrtd: New client connected
> Sep 28 23:58:36 adsl-108-199-65-102 dbus-daemon[686]: ** Message: No devices in use, exit
> Sep 28 23:59:53 adsl-108-199-65-102 abrtd: New client connected
> Sep 29 00:02:16 adsl-108-199-65-102 kernel: [  733.187021] CIFS VFS: sends on sock f4b3d800 stuck for 15 seconds
> Sep 29 00:02:16 adsl-108-199-65-102 kernel: [  733.187029] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:02:46 adsl-108-199-65-102 kernel: [  763.754032] CIFS VFS: sends on sock f0358780 stuck for 15 seconds
> Sep 29 00:02:46 adsl-108-199-65-102 kernel: [  763.754038] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:03:01 adsl-108-199-65-102 kernel: [  778.762036] CIFS VFS: sends on sock f0358780 stuck for 15 seconds
> Sep 29 00:03:01 adsl-108-199-65-102 kernel: [  778.762045] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:05:03 adsl-108-199-65-102 systemd-tmpfiles[25035]: stat(/run/user/raj/gvfs) failed: Permission denied
> Sep 29 00:10:30 adsl-108-199-65-102 kernel: [ 1227.455026] CIFS VFS: sends on sock f0358780 stuck for 15 seconds
> Sep 29 00:10:30 adsl-108-199-65-102 kernel: [ 1227.455032] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:10:45 adsl-108-199-65-102 kernel: [ 1242.463033] CIFS VFS: sends on sock f0358780 stuck for 15 seconds
> Sep 29 00:10:45 adsl-108-199-65-102 kernel: [ 1242.463040] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:11:19 adsl-108-199-65-102 kernel: [ 1275.853059] CIFS VFS: sends on sock ecb51080 stuck for 15 seconds
> Sep 29 00:11:19 adsl-108-199-65-102 kernel: [ 1275.853067] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:11:34 adsl-108-199-65-102 kernel: [ 1290.861034] CIFS VFS: sends on sock ecb51080 stuck for 15 seconds
> Sep 29 00:11:34 adsl-108-199-65-102 kernel: [ 1290.861042] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:12:07 adsl-108-199-65-102 kernel: [ 1324.721030] CIFS VFS: sends on sock ecb51080 stuck for 15 seconds
> Sep 29 00:12:07 adsl-108-199-65-102 kernel: [ 1324.721039] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:12:22 adsl-108-199-65-102 kernel: [ 1339.729078] CIFS VFS: sends on sock ecb51080 stuck for 15 seconds
> Sep 29 00:12:22 adsl-108-199-65-102 kernel: [ 1339.729084] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:12:54 adsl-108-199-65-102 kernel: [ 1371.718024] CIFS VFS: sends on sock ecb51080 stuck for 15 seconds
> Sep 29 00:12:54 adsl-108-199-65-102 kernel: [ 1371.718032] CIFS VFS: Error -11 sending data on socket to server
> Sep 29 00:13:09 adsl-108-199-65-102 kernel: [ 1386.727037] CIFS VFS: sends on sock ecb51080 stuck for 15 seconds
> Sep 29 00:13:09 adsl-108-199-65-102 kernel: [ 1386.727044] CIFS VFS: Error -11 sending data on socket to server
