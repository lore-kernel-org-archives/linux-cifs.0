From: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Wed, 17 Aug 2011 18:13:59 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1108171813460.11234@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <alpine.DEB.2.02.1108171545190.5877@p34.internal.lan> <alpine.DEB.2.02.1108171547110.5877@p34.internal.lan> <20110817161349.072e1452@tlielax.poochiereds.net>
 <alpine.DEB.2.02.1108171644050.11234@p34.internal.lan> <CACqU3MXWRRGydeb1g80X8+rdSv0i0UFYQVTm0Eq4bsYnbRwf=w@mail.gmail.com> <alpine.DEB.2.02.1108171751570.11234@p34.internal.lan>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-385324938-1313619239=:11234"
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnaud Lacombe <lacombar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1108171751570.11234-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-385324938-1313619239=:11234
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 17 Aug 2011, Justin Piszcz wrote:

>
>
> On Wed, 17 Aug 2011, Arnaud Lacombe wrote:
>
>> Hi,
>>=20
>> On Wed, Aug 17, 2011 at 4:45 PM, Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>=
=20
>> wrote:
>>>=20
>>>=20
>>> On Wed, 17 Aug 2011, Jeff Layton wrote:
>>>=20
>>>> The crash is happening in the bowels of the slab allocator.
>>>> Specifically, it looks like it's hitting this:
>>>>=20
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The slab was either on partial or fre=
e list so
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* there must be at least one object ava=
ilable for
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* allocation.
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(slabp->inuse >=3D cachep->num);
>>>>=20
>>>> ...which looks like maybe the accounting of in-use objects is off. Thi=
s
>>>> really sounds like some sort of memory corruption. I've not been able
>>>> to reproduce this so far, but I also had someone report panic here tha=
t
>>>> might be related:
>>>>=20
>>>> =A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D731278

Hi,

Got a better one here:

[   98.386992] CIFS VFS: cifs_mount failed w/return code =3D -22
[  562.565161] CIFS VFS: cifs_mount failed w/return code =3D -22
[  596.277441] ------------[ cut here ]------------
[  596.277450] kernel BUG at mm/slab.c:3111!
[  596.277456] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[  596.277463] CPU 2=20
[  596.277466] Modules linked in: rfcomm bnep bluetooth speedstep_lib crypt=
d aes_x86_64 aes_generic configfs ath9k mac80211 ath9k_common ath9k_hw ohci=
_hcd ssb ath mmc_core cfg80211 shpchp uvcvideo i2c_piix4 videodev v4l2_comp=
at_ioctl32 pci_hotplug wmi pcmcia rfkill pcmcia_core edac_core k10temp edac=
_mce_amd video battery ac
[  596.277517]=20
[  596.277523] Pid: 4157, comm: ps Not tainted 3.1.0-rc2 #3 Acer           =
 Aspire 7551                    /Aspire 7551=20
[  596.277536] RIP: 0010:[<ffffffff816464a6>]  [<ffffffff816464a6>] cache_a=
lloc_refill+0x111/0x4a6
[  596.277554] RSP: 0018:ffff88012e231b88  EFLAGS: 00010046
[  596.277559] RAX: ffff8801394d5000 RBX: ffff88013f000080 RCX: 00000000000=
00033
[  596.277565] RDX: 0000000000000070 RSI: dead000000200200 RDI: 00000000000=
00009
[  596.277570] RBP: ffff88012e231be8 R08: 000000000000005f R09: ffff88013f0=
04450
[  596.277576] R10: ffff88013f004460 R11: ffff88012e231d80 R12: 00000000000=
000d0
[  596.277581] R13: ffff88013f0d1400 R14: 00000000000000d0 R15: ffff88013f0=
04440
[  596.277588] FS:  00007f8bf016c700(0000) GS:ffff88013fd00000(0000) knlGS:=
0000000000000000
[  596.277594] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  596.277599] CR2: 00007f8befd44328 CR3: 000000012e27b000 CR4: 00000000000=
006e0
[  596.277605] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  596.277610] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  596.277616] Process ps (pid: 4157, threadinfo ffff88012e230000, task fff=
f88013f3f78d0)
[  596.277621] Stack:
[  596.277624]  ffff88013f045c00 ffff88010000003c ffff88012e231bb8 ffff8801=
2f491088
[  596.277635]  000000d02e231bc8 0000001000000000 ffff88012f491118 ffff8801=
32266a40
[  596.277645]  00000000000000d0 0000000000000202 ffff88013f000080 ffff8801=
32266a40
[  596.277654] Call Trace:
[  596.277666]  [<ffffffff810ae0e6>] kmem_cache_alloc+0x76/0xa0
[  596.277675]  [<ffffffff8110bb80>] ? meminfo_proc_open+0x30/0x30
[  596.277684]  [<ffffffff810d58e2>] single_open+0x32/0xa0
[  596.277694]  [<ffffffff8110a095>] ? proc_lookup_de+0xa5/0x100
[  596.277701]  [<ffffffff8110bb65>] meminfo_proc_open+0x15/0x30
[  596.277709]  [<ffffffff811044e8>] proc_reg_open+0x88/0x150
[  596.277717]  [<ffffffff810d4c50>] ? seq_release_private+0x50/0x50
[  596.277726]  [<ffffffff81104460>] ? proc_alloc_inode+0xa0/0xa0
[  596.277735]  [<ffffffff810b5339>] __dentry_open.isra.17+0xf9/0x2d0
[  596.277744]  [<ffffffff810b625e>] nameidata_to_filp+0x4e/0x60
[  596.277753]  [<ffffffff810c4804>] do_last.isra.48+0x204/0x830
[  596.277760]  [<ffffffff810c50a6>] path_openat+0xc6/0x370
[  596.277769]  [<ffffffff8109a965>] ? handle_mm_fault+0x165/0x300
[  596.277776]  [<ffffffff810c53ad>] do_filp_open+0x3d/0xa0
[  596.277786]  [<ffffffff810d0697>] ? alloc_fd+0x47/0x130
[  596.277795]  [<ffffffff810b6362>] do_sys_open+0xf2/0x1d0
[  596.277803]  [<ffffffff810b645b>] sys_open+0x1b/0x20
[  596.277812]  [<ffffffff8164debb>] system_call_fastpath+0x16/0x1b
[  596.277817] Code: 00 e9 d2 00 00 00 49 8b 07 49 39 c7 75 15 49 8b 47 20 =
41 c7 47 60 01 00 00 00 4c 39 d0 0f 84 ad 00 00 00 8b 53 18 39 50 20 72 2f =
<0f> 0b 44 8b 40 24 8b 53 0c ff c6 41 8b 7d 00 89 70 20 41 0f af=20
[  596.277879] RIP  [<ffffffff816464a6>] cache_alloc_refill+0x111/0x4a6
[  596.277888]  RSP <ffff88012e231b88>
[  596.277894] ---[ end trace 01e175dd97a8992b ]---


Justin.

--655872-385324938-1313619239=:11234--
