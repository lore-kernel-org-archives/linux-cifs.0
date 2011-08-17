From: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Wed, 17 Aug 2011 18:18:58 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1108171817320.11234@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <alpine.DEB.2.02.1108171545190.5877@p34.internal.lan> <alpine.DEB.2.02.1108171547110.5877@p34.internal.lan> <20110817161349.072e1452@tlielax.poochiereds.net>
 <alpine.DEB.2.02.1108171644050.11234@p34.internal.lan> <CACqU3MXWRRGydeb1g80X8+rdSv0i0UFYQVTm0Eq4bsYnbRwf=w@mail.gmail.com> <alpine.DEB.2.02.1108171751570.11234@p34.internal.lan> <alpine.DEB.2.02.1108171813460.11234@p34.internal.lan>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1925465709-1313619538=:11234"
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnaud Lacombe <lacombar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1108171813460.11234-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1925465709-1313619538=:11234
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 17 Aug 2011, Justin Piszcz wrote:

>
>
> On Wed, 17 Aug 2011, Justin Piszcz wrote:
>
>>=20
>>=20
>> On Wed, 17 Aug 2011, Arnaud Lacombe wrote:
>>=20
>>> Hi,
>>>=20
>>> On Wed, Aug 17, 2011 at 4:45 PM, Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org=
>=20
>>> wrote:
>>>>=20
>>>>=20
>>>> On Wed, 17 Aug 2011, Jeff Layton wrote:
>>>>=20
>>>>> The crash is happening in the bowels of the slab allocator.
>>>>> Specifically, it looks like it's hitting this:
>>>>>=20
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The slab was either on partial or fr=
ee list so
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* there must be at least one object av=
ailable for
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* allocation.
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(slabp->inuse >=3D cachep->num);
>>>>>=20
>>>>> ...which looks like maybe the accounting of in-use objects is off. Th=
is
>>>>> really sounds like some sort of memory corruption. I've not been able
>>>>> to reproduce this so far, but I also had someone report panic here th=
at
>>>>> might be related:
>>>>>=20
>>>>> =A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D731278
>
> Hi,
>
> Got a better one here:
>
> [   98.386992] CIFS VFS: cifs_mount failed w/return code =3D -22
> [  562.565161] CIFS VFS: cifs_mount failed w/return code =3D -22
> [  596.277441] ------------[ cut here ]------------
> [  596.277450] kernel BUG at mm/slab.c:3111!
> [  596.277456] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  596.277463] CPU 2 [  596.277466] Modules linked in: rfcomm bnep blueto=
oth=20
> speedstep_lib cryptd aes_x86_64 aes_generic configfs ath9k mac80211=20
> ath9k_common ath9k_hw ohci_hcd ssb ath mmc_core cfg80211 shpchp uvcvideo=
=20
> i2c_piix4 videodev v4l2_compat_ioctl32 pci_hotplug wmi pcmcia rfkill=20
> pcmcia_core edac_core k10temp edac_mce_amd video battery ac
> [  596.277517] [  596.277523] Pid: 4157, comm: ps Not tainted 3.1.0-rc2 #=
3=20
> Acer            Aspire 7551                    /Aspire 7551 [  596.277536=
]=20
> RIP: 0010:[<ffffffff816464a6>]  [<ffffffff816464a6>]=20
> cache_alloc_refill+0x111/0x4a6
> [  596.277554] RSP: 0018:ffff88012e231b88  EFLAGS: 00010046
> [  596.277559] RAX: ffff8801394d5000 RBX: ffff88013f000080 RCX:=20
> 0000000000000033
> [  596.277565] RDX: 0000000000000070 RSI: dead000000200200 RDI:=20
> 0000000000000009
> [  596.277570] RBP: ffff88012e231be8 R08: 000000000000005f R09:=20
> ffff88013f004450
> [  596.277576] R10: ffff88013f004460 R11: ffff88012e231d80 R12:=20
> 00000000000000d0
> [  596.277581] R13: ffff88013f0d1400 R14: 00000000000000d0 R15:=20
> ffff88013f004440
> [  596.277588] FS:  00007f8bf016c700(0000) GS:ffff88013fd00000(0000)=20
> knlGS:0000000000000000
> [  596.277594] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  596.277599] CR2: 00007f8befd44328 CR3: 000000012e27b000 CR4:=20
> 00000000000006e0
> [  596.277605] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
> 0000000000000000
> [  596.277610] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
> 0000000000000400
> [  596.277616] Process ps (pid: 4157, threadinfo ffff88012e230000, task=
=20
> ffff88013f3f78d0)
> [  596.277621] Stack:
> [  596.277624]  ffff88013f045c00 ffff88010000003c ffff88012e231bb8=20
> ffff88012f491088
> [  596.277635]  000000d02e231bc8 0000001000000000 ffff88012f491118=20
> ffff880132266a40
> [  596.277645]  00000000000000d0 0000000000000202 ffff88013f000080=20
> ffff880132266a40
> [  596.277654] Call Trace:
> [  596.277666]  [<ffffffff810ae0e6>] kmem_cache_alloc+0x76/0xa0
> [  596.277675]  [<ffffffff8110bb80>] ? meminfo_proc_open+0x30/0x30
> [  596.277684]  [<ffffffff810d58e2>] single_open+0x32/0xa0
> [  596.277694]  [<ffffffff8110a095>] ? proc_lookup_de+0xa5/0x100
> [  596.277701]  [<ffffffff8110bb65>] meminfo_proc_open+0x15/0x30
> [  596.277709]  [<ffffffff811044e8>] proc_reg_open+0x88/0x150
> [  596.277717]  [<ffffffff810d4c50>] ? seq_release_private+0x50/0x50
> [  596.277726]  [<ffffffff81104460>] ? proc_alloc_inode+0xa0/0xa0
> [  596.277735]  [<ffffffff810b5339>] __dentry_open.isra.17+0xf9/0x2d0
> [  596.277744]  [<ffffffff810b625e>] nameidata_to_filp+0x4e/0x60
> [  596.277753]  [<ffffffff810c4804>] do_last.isra.48+0x204/0x830
> [  596.277760]  [<ffffffff810c50a6>] path_openat+0xc6/0x370
> [  596.277769]  [<ffffffff8109a965>] ? handle_mm_fault+0x165/0x300
> [  596.277776]  [<ffffffff810c53ad>] do_filp_open+0x3d/0xa0
> [  596.277786]  [<ffffffff810d0697>] ? alloc_fd+0x47/0x130
> [  596.277795]  [<ffffffff810b6362>] do_sys_open+0xf2/0x1d0
> [  596.277803]  [<ffffffff810b645b>] sys_open+0x1b/0x20
> [  596.277812]  [<ffffffff8164debb>] system_call_fastpath+0x16/0x1b
> [  596.277817] Code: 00 e9 d2 00 00 00 49 8b 07 49 39 c7 75 15 49 8b 47 2=
0 41=20
> c7 47 60 01 00 00 00 4c 39 d0 0f 84 ad 00 00 00 8b 53 18 39 50 20 72 2f <=
0f>=20
> 0b 44 8b 40 24 8b 53 0c ff c6 41 8b 7d 00 89 70 20 41 0f af [  596.277879=
]=20
> RIP  [<ffffffff816464a6>] cache_alloc_refill+0x111/0x4a6
> [  596.277888]  RSP <ffff88012e231b88>
> [  596.277894] ---[ end trace 01e175dd97a8992b ]---

(it is spewing new errors below)

[  598.897157]=20
[  598.897157] Pid: 1097, comm: kworker/2:2 Tainted: G      D W   3.1.0-rc2=
 #3 Acer            Aspire 7551                    /Aspire 7551=20
[  598.897157] RIP: 0010:[<ffffffff8164d491>]  [<ffffffff8164d491>] _raw_sp=
in_lock_irq+0x11/0x20
[  598.897157] RSP: 0018:ffff88013947dd90  EFLAGS: 00000097
[  598.897157] RAX: 0000000000003332 RBX: ffff88013f0d1400 RCX: 00000000000=
00000
[  598.897157] RDX: ffff88013f0d1400 RSI: ffff88013f004440 RDI: ffff88013f0=
04480
[  598.897157] RBP: ffff88013947dd90 R08: 0000000000000000 R09: ffff88013aa=
0b440
[  598.897157] R10: ffff88013aa0b440 R11: ffff880139dec7c0 R12: ffff88013f0=
04440
[  598.897157] R13: ffff88013f000080 R14: 0000000000000000 R15: ffffffff810=
adc80
[  598.897157] FS:  00007f5e69cc4700(0000) GS:ffff88013fd00000(0000) knlGS:=
0000000000000000
[  598.897157] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  598.897157] CR2: 00007f5e693b02c0 CR3: 0000000001c1d000 CR4: 00000000000=
006e0
[  598.897157] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  598.897157] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  598.897157] Process kworker/2:2 (pid: 1097, threadinfo ffff88013947c000,=
 task ffff88013f25e250)
[  598.897157] Stack:
[  598.897157]  ffff88013947dde0 ffffffff810adc09 ffff880100000000 ffffffff=
00000000
[  598.897157]  ffff88013947dde0 ffff88013f000080 ffff88013f004440 ffff8801=
3fd0d720
[  598.897157]  0000000000000000 ffffffff810adc80 ffff88013947de10 ffffffff=
810add08
[  598.897157] Call Trace:
[  598.897157]  [<ffffffff810adc09>] drain_array+0x69/0xe0
[  598.897157]  [<ffffffff810adc80>] ? drain_array+0xe0/0xe0
[  598.897157]  [<ffffffff810add08>] cache_reap+0x88/0x120
[  598.897157]  [<ffffffff8104ae61>] process_one_work+0x101/0x380
[  598.897157]  [<ffffffff8104b68d>] worker_thread+0x15d/0x330
[  598.897157]  [<ffffffff8104b530>] ? manage_workers.isra.32+0x210/0x210
[  598.897157]  [<ffffffff8104f6a7>] kthread+0x87/0x90
[  598.897157]  [<ffffffff8164f074>] kernel_thread_helper+0x4/0x10
[  598.897157]  [<ffffffff8104f620>] ? kthread_worker_fn+0x140/0x140
[  598.897157]  [<ffffffff8164f070>] ? gs_change+0xb/0xb
[  598.897157] Code: fa ba 00 01 00 00 f0 66 0f c1 17 38 f2 74 06 f3 90 8a =
17 eb f6 5d c3 0f 1f 00 55 48 89 e5 fa b8 00 01 00 00 f0 66 0f c1 07 38 e0=
=20
[  598.897157]  06 f3 90 8a 07 eb f6 5d c3 0f 1f 44 00 00 55 48 89 e5 fe 07=
=20
[  598.897157] Call Trace:
[  598.897157]  [<ffffffff810adc09>] drain_array+0x69/0xe0
[  598.897157]  [<ffffffff810adc80>] ? drain_array+0xe0/0xe0
[  598.897157]  [<ffffffff810add08>] cache_reap+0x88/0x120
[  598.897157]  [<ffffffff8104ae61>] process_one_work+0x101/0x380
[  598.897157]  [<ffffffff8104b68d>] worker_thread+0x15d/0x330
[  598.897157]  [<ffffffff8104b530>] ? manage_workers.isra.32+0x210/0x210
[  598.897157]  [<ffffffff8104f6a7>] kthread+0x87/0x90
[  598.897157]  [<ffffffff8164f074>] kernel_thread_helper+0x4/0x10
[  598.897157]  [<ffffffff8104f620>] ? kthread_worker_fn+0x140/0x140
[  598.897157]  [<ffffffff8164f070>] ? gs_change+0xb/0xb
[  726.242532] NMI backtrace for cpu 1
[  726.242541] CPU 1=20
[  726.242545] Modules linked in: rfcomm bnep bluetooth speedstep_lib crypt=
d aes_x86_64 aes_generic configfs ath9k mac80211 ath9k_common ath9k_hw ohci=
_hcd ssb ath mmc_core cfg80211 shpchp uvcvideo i2c_piix4 videodev v4l2_comp=
at_ioctl32 pci_hotplug wmi pcmcia rfkill pcmcia_core edac_core k10temp edac=
_mce_amd video battery ac
[  726.242601]=20
[  726.242608] Pid: 0, comm: kworker/0:0 Tainted: G      D W   3.1.0-rc2 #3=
 Acer            Aspire 7551                    /Aspire 7551=20
[  726.242622] RIP: 0010:[<ffffffff810090b4>]  [<ffffffff810090b4>] default=
_idle+0x24/0x40
[  726.242639] RSP: 0018:ffff88013f0e3ed8  EFLAGS: 00000246
[  726.242644] RAX: 0000000000000000 RBX: ffff88013f0e3ef4 RCX: 00000000000=
00001
[  726.242650] RDX: 0000000000000909 RSI: 0000000000000086 RDI: ffffffff81d=
58aac
[  726.242656] RBP: ffff88013f0e3ed8 R08: 0000000000000000 R09: 00000000000=
00000
[  726.242661] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81c=
75e70
[  726.242666] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[  726.242673] FS:  00007f30e9aa3700(0000) GS:ffff88013fc80000(0000) knlGS:=
0000000000000000
[  726.242679] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  726.242684] CR2: 00007f5e692fce02 CR3: 0000000139f11000 CR4: 00000000000=
006e0
[  726.242689] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  726.242694] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  726.242700] Process kworker/0:0 (pid: 0, threadinfo ffff88013f0e2000, ta=
sk ffff88013f0dd240)
[  726.242705] Stack:[  726.242708]  ffff88013f0e3f08 ffffffff810091c4 ffff=
88013f0e3ef8 0000000181054bd5
[  726.242719]  ffff88013f0e3fd8 ffff88013f0e3fd8 ffff88013f0e3f28 ffffffff=
81000818
[  726.242729]  0000000000000001 0000000000000000 ffff88013f0e3f48 ffffffff=
81cc6199
[  726.242738] Call Trace:
[  726.242748]  [<ffffffff810091c4>] amd_e400_idle+0x54/0x100
[  726.242756]  [<ffffffff81000818>] cpu_idle+0x78/0xc0
[  726.242765]  [<ffffffff81cc6199>] start_secondary+0x19a/0x19e
[  726.242771] Code: 1f 84 00 00 00 00 00 55 65 48 8b 04 25 08 b6 00 00 83 =
a0 3c e0 ff ff fb 48 89 e5 0f ae f0 48 8b 80 38 e0 ff ff a8 08 75 14 fb f4=
=20
[  726.242812]  48 8b 04 25 08 b6 00 00 83 88 3c e0 ff ff 04 5d c3 fb eb eb=
=20
[  726.242834] Call Trace:
[  726.242841]  [<ffffffff810091c4>] amd_e400_idle+0x54/0x100
[  726.242848]  [<ffffffff81000818>] cpu_idle+0x78/0xc0
[  726.242855]  [<ffffffff81cc6199>] start_secondary+0x19a/0x19e
[  726.242866] NMI backtrace for cpu 3
[  726.242875] CPU 3=20
[  726.242879] Modules linked in: rfcomm bnep bluetooth speedstep_lib crypt=
d aes_x86_64 aes_generic configfs ath9k mac80211 ath9k_common ath9k_hw ohci=
_hcd ssb ath mmc_core cfg80211 shpchp uvcvideo i2c_piix4 videodev v4l2_comp=
at_ioctl32 pci_hotplug wmi pcmcia rfkill pcmcia_core edac_core k10temp edac=
_mce_amd video battery ac
[  726.242936]=20
[  726.242942] Pid: 0, comm: kworker/0:1 Tainted: G      D W   3.1.0-rc2 #3=
 Acer            Aspire 7551                    /Aspire 7551=20
[  726.242956] RIP: 0010:[<ffffffff810090b4>]  [<ffffffff810090b4>] default=
_idle+0x24/0x40
[  726.242974] RSP: 0018:ffff88013f129ed8  EFLAGS: 00000246
[  726.242979] RAX: 0000000000000000 RBX: ffff88013f129ef4 RCX: 00000000000=
00020
[  726.242985] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffffffff81d=
58aac
[  726.242990] RBP: ffff88013f129ed8 R08: ffffffff81c2a3c0 R09: 00000000000=
00000
[  726.242996] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81c=
75e70
[  726.243001] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[  726.243007] FS:  00007f0e9311c700(0000) GS:ffff88013fd80000(0000) knlGS:=
0000000000000000
[  726.243013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  726.243018] CR2: ffffffffff600400 CR3: 0000000139d87000 CR4: 00000000000=
006e0
[  726.243024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  726.243029] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  726.243035] Process kworker/0:1 (pid: 0, threadinfo ffff88013f128000, ta=
sk ffff88013f1252c0)
[  726.243040] Stack:
[  726.243043]  ffff88013f129f08 ffffffff810091c4 ffff88013f129ef8 00000003=
81054bd5
[  726.243054]  ffff88013f129fd8 ffff88013f129fd8 ffff88013f129f28 ffffffff=
81000818
[  726.243061]  0000000000000003 0000000000000000 ffff88013f129f48 ffffffff=
81cc6199
[  726.243061] Call Trace:
[  726.243061]  [<ffffffff810091c4>] amd_e400_idle+0x54/0x100
[  726.243061]  [<ffffffff81000818>] cpu_idle+0x78/0xc0
[  726.243061]  [<ffffffff81cc6199>] start_secondary+0x19a/0x19e
[  726.243061] Code: 1f 84 00 00 00 00 00 55 65 48 8b 04 25 08 b6 00 00 83 =
a0 3c e0 ff ff fb 48 89 e5 0f ae f0 48 8b 80 38 e0 ff ff a8 08 75 14 fb f4=
=20
[  726.243061]  48 8b 04 25 08 b6 00 00 83 88 3c e0 ff ff 04 5d c3 fb eb eb=
=20
[  726.243061] Call Trace:
[  726.243061]  [<ffffffff810091c4>] amd_e400_idle+0x54/0x100
[  726.243061]  [<ffffffff81000818>] cpu_idle+0x78/0xc0
[  726.243061]  [<ffffffff81cc6199>] start_secondary+0x19a/0x19e
[  726.243089] NMI backtrace for cpu 0
[  726.243089] CPU 0=20
[  726.243089] Modules linked in: rfcomm bnep bluetooth speedstep_lib crypt=
d aes_x86_64 aes_generic configfs ath9k mac80211 ath9k_common ath9k_hw ohci=
_hcd ssb ath mmc_core cfg80211 shpchp uvcvideo i2c_piix4 videodev v4l2_comp=
at_ioctl32 pci_hotplug wmi pcmcia rfkill pcmcia_core edac_core k10temp edac=
_mce_amd video battery ac
[  726.243089]=20
[  726.243089] Pid: 0, comm: swapper Tainted: G      D W   3.1.0-rc2 #3 Ace=
r            Aspire 7551                    /Aspire 7551=20
[  726.243089] RIP: 0010:[<ffffffff812d4e30>]  [<ffffffff812d4e30>] __delay=
+0x10/0x10
[  726.243089] RSP: 0018:ffff88013fc03e00  EFLAGS: 00000006
[  726.243089] RAX: 0000000000000c00 RBX: 0000000000002710 RCX: 00000000000=
00006
[  726.243089] RDX: ffffffff81c2add8 RSI: 0000000000000002 RDI: 00000000004=
18958
[  726.243089] RBP: ffff88013fc03e18 R08: 000000000000000a R09: 00000000000=
00000
[  726.243089] R10: 0000000000000000 R11: 000000000000000d R12: ffffffff81c=
2f080
[  726.243089] R13: ffffffff81c2f080 R14: ffffffff81c2f140 R15: 00000000000=
00004
[  726.243089] FS:  00007f30e92a2700(0000) GS:ffff88013fc00000(0000) knlGS:=
0000000000000000
[  726.243089] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  726.243089] CR2: 00007fcdc5b391a0 CR3: 0000000139f11000 CR4: 00000000000=
006f0
[  726.243089] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  726.243089] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400[  726.243089] Process swapper (pid: 0, threadinfo ffffffff81c00000, t=
ask ffffffff81c25020)
[  726.243089] Stack:
[  726.243089]  ffffffff8101a342 000000000000000a ffff88013fc0cd40 ffff8801=
3fc03e68
[  726.243089]  ffffffff810720eb 0000000000010740 ffffffff81c2f140 00000000=
ffffffff
[  726.243089]  0000000000000000 0000000000000000 0000000000000000 7fffffff=
ffffffff
[  726.243089] Call Trace:
[  726.243089]  <IRQ>=20
[  726.243089]  [<ffffffff8101a342>] ? arch_trigger_all_cpu_backtrace+0x62/=
0x80
[  726.243089]  [<ffffffff810720eb>] __rcu_pending+0x35b/0x380
[  726.243089]  [<ffffffff81072e53>] rcu_check_callbacks+0x103/0x120
[  726.243089]  [<ffffffff81041a83>] update_process_times+0x43/0x80
[  726.243089]  [<ffffffff8105ebbf>] tick_sched_timer+0x5f/0xb0
[  726.243089]  [<ffffffff8105326d>] __run_hrtimer.isra.34+0x4d/0x100
[  726.243089]  [<ffffffff81053a6f>] hrtimer_interrupt+0xdf/0x1f0
[  726.243089]  [<ffffffff810197c4>] smp_apic_timer_interrupt+0x64/0xa0
[  726.243089]  [<ffffffff8164e8cb>] apic_timer_interrupt+0x6b/0x70
[  726.243089]  <EOI>=20
[  726.243089]  [<ffffffff810090b4>] ? default_idle+0x24/0x40
[  726.243089]  [<ffffffff810091c4>] amd_e400_idle+0x54/0x100
[  726.243089]  [<ffffffff81000818>] cpu_idle+0x78/0xc0
[  726.243089]  [<ffffffff8162cd99>] rest_init+0x6d/0x74
[  726.243089]  [<ffffffff81c91a76>] start_kernel+0x2ae/0x2b9
[  726.243089]  [<ffffffff81c912ee>] x86_64_start_reservations+0xfe/0x102
[  726.243089]  [<ffffffff81c913e2>] x86_64_start_kernel+0xf0/0xf7
[  726.243089] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 48 ff c8 75 fb 48 ff =
c8 5d c3 66 0f 1f 44 00 00 55 48 89 e5 ff 15 0e 8d 96 00 5d c3 0f 1f 40 00=
=20
[  726.243089]  48 8d 04 bd 00 00 00 00 65 48 8b 14 25 d8 06 01 00 48 69 d2=
=20
[  726.243089] Call Trace:
[  726.243089]  <IRQ>  [<ffffffff8101a342>] ? arch_trigger_all_cpu_backtrac=
e+0x62/0x80
[  726.243089]  [<ffffffff810720eb>] __rcu_pending+0x35b/0x380
[  726.243089]  [<ffffffff81072e53>] rcu_check_callbacks+0x103/0x120
[  726.243089]  [<ffffffff81041a83>] update_process_times+0x43/0x80
[  726.243089]  [<ffffffff8105ebbf>] tick_sched_timer+0x5f/0xb0
[  726.243089]  [<ffffffff8105326d>] __run_hrtimer.isra.34+0x4d/0x100
[  726.243089]  [<ffffffff81053a6f>] hrtimer_interrupt+0xdf/0x1f0
[  726.243089]  [<ffffffff810197c4>] smp_apic_timer_interrupt+0x64/0xa0
[  726.243089]  [<ffffffff8164e8cb>] apic_timer_interrupt+0x6b/0x70
[  726.243089]  <EOI>  [<ffffffff810090b4>] ? default_idle+0x24/0x40
[  726.243089]  [<ffffffff810091c4>] amd_e400_idle+0x54/0x100
[  726.243089]  [<ffffffff81000818>] cpu_idle+0x78/0xc0
[  726.243089]  [<ffffffff8162cd99>] rest_init+0x6d/0x74
[  726.243089]  [<ffffffff81c91a76>] start_kernel+0x2ae/0x2b9
[  726.243089]  [<ffffffff81c912ee>] x86_64_start_reservations+0xfe/0x102
[  726.243089]  [<ffffffff81c913e2>] x86_64_start_kernel+0xf0/0xf7


Justin.

--655872-1925465709-1313619538=:11234--
