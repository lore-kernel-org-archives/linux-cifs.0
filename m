From: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Wed, 17 Aug 2011 15:47:23 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1108171547110.5877@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <alpine.DEB.2.02.1108171545190.5877@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1108171545190.5877-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On Wed, 17 Aug 2011, Justin Piszcz wrote:

>
>
> On Wed, 17 Aug 2011, Justin Piszcz wrote:
>
>> 
>> 
>> On Mon, 15 Aug 2011, Justin Piszcz wrote:
>
>
> Better output of crash: (again)
>
> [  214.557063] CIFS VFS: cifs_mount failed w/return code = -22
> [  216.607556] CIFS VFS: cifs_mount failed w/return code = -22
> [  222.637424] CIFS VFS: cifs_mount failed w/return code = -22
> [  228.988734] ------------[ cut here ]------------
> [  228.988752] kernel BUG at mm/slab.c:3111!
> [  228.988759] invalid opcode: 0000 [#1] SMP [  228.988769] CPU 1 [ 
> 228.988774] Modules linked in: netconsole rfcomm bnep bluetooth speedstep_lib 
> cryptd aes_x86_64 aes_generic configfs ath9k mac80211 uvcvideo ath9k_common 
> ath9k_hw ath ohci_hcd ssb videodev mmc_core edac_core v4l2_compat_ioctl32 
> i2c_piix4 edac_mce_amd k10temp battery ac cfg80211 pcmcia shpchp video rfkill 
> pci_hotplug wmi pcmcia_core
> [  228.988873] [  228.988880] Pid: 2869, comm: mount Not tainted 3.1.0-rc2 #2 
> Acer            Aspire 7551                    /Aspire 7551 [  228.988901] 
> RIP: 0010:[<ffffffff81646526>]  [<ffffffff81646526>] 
> cache_alloc_refill+0x111/0x4a6
> [  228.988922] RSP: 0018:ffff8801322e3cf8  EFLAGS: 00010046
> [  228.988929] RAX: ffff8801399b9000 RBX: ffff88013f000080 RCX: 
> 0000000000000007
> [  228.988936] RDX: 0000000000000070 RSI: dead000000200200 RDI: 
> 0000000000000035
> [  228.988944] RBP: ffff8801322e3d58 R08: 0000000000000033 R09: 
> ffff88013f004450
> [  228.988950] R10: ffff88013f004460 R11: ffff8801322e3d60 R12: 
> 00000000000000d0
> [  228.988956] R13: ffff88013f0c1400 R14: 00000000000000d0 R15: 
> ffff88013f004440
> [  228.988964] FS:  00007f421e4957e0(0000) GS:ffff88013fc80000(0000) 
> knlGS:0000000000000000
> [  228.988972] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  228.988979] CR2: 000000000130d000 CR3: 0000000132205000 CR4: 
> 00000000000006e0
> [  228.988986] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [  228.988993] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> 0000000000000400
> [  228.989001] Process mount (pid: 2869, threadinfo ffff8801322e2000, task 
> ffff88013f278620)
> [  228.989005] Stack:
> [  228.989005]  ffff8801322e3d28 000000000000003c 000000000000001c 
> 0000000000000000
> [  228.989005]  000000d00000001c 0000001000000000 ffff8801322e3dc8 
> 0000000000000010
> [  228.989005]  0000000000000202 ffff88013f000080 00000000000000d0 
> ffff880139a94940
> [  228.989005] Call Trace:
> [  228.989005]  [<ffffffff810ae053>] __kmalloc+0xb3/0xe0
> [  228.989005]  [<ffffffff810911e5>] kstrdup+0x35/0x60
> [  228.989005]  [<ffffffff810d1e51>] alloc_vfsmnt+0xa1/0x190
> [  228.989005]  [<ffffffff810d21dd>] vfs_kern_mount+0x2d/0xa0
> [  228.989005]  [<ffffffff810d260f>] do_kern_mount+0x4f/0x100
> [  228.989005]  [<ffffffff810d4002>] do_mount+0x532/0x830
> [  228.989005]  [<ffffffff810d3955>] ? copy_mount_options+0x35/0x170
> [  228.989005]  [<ffffffff810d46c3>] sys_mount+0x93/0xe0
> [  228.989005]  [<ffffffff8164df3b>] system_call_fastpath+0x16/0x1b
> [  228.989005] Code: 00 e9 d2 00 00 00 49 8b 07 49 39 c7 75 15 49 8b 47 20 41 
> c7 47 60 01 00 00 00 4c 39 d0 0f 84 ad 00 00 00 8b 53 18 39 50 20 72 2f <0f> 
> 0b 44 8b 40 24 8b 53 0c ff c6 41 8b 7d 00 89 70 20 41 0f af [  228.989005] 
> RIP  [<ffffffff81646526>] cache_alloc_refill+0x111/0x4a6
> [  228.989005]  RSP <ffff8801322e3cf8>
> [  228.989005] ---[ end trace 8859f1f50ceed0f6 ]---
>
> Justin.
>
>
