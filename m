From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Wed, 17 Aug 2011 17:53:04 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1108171751570.11234@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <alpine.DEB.2.02.1108171545190.5877@p34.internal.lan> <alpine.DEB.2.02.1108171547110.5877@p34.internal.lan> <20110817161349.072e1452@tlielax.poochiereds.net>
 <alpine.DEB.2.02.1108171644050.11234@p34.internal.lan> <CACqU3MXWRRGydeb1g80X8+rdSv0i0UFYQVTm0Eq4bsYnbRwf=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-682518914-1313617984=:11234"
Cc: Jeff Layton <jlayton@samba.org>, Jesper Juhl <jj@chaosbits.net>,
	linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
To: Arnaud Lacombe <lacombar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACqU3MXWRRGydeb1g80X8+rdSv0i0UFYQVTm0Eq4bsYnbRwf=w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-682518914-1313617984=:11234
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 17 Aug 2011, Arnaud Lacombe wrote:

> Hi,
>
> On Wed, Aug 17, 2011 at 4:45 PM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
>>
>>
>> On Wed, 17 Aug 2011, Jeff Layton wrote:
>>
>>> The crash is happening in the bowels of the slab allocator.
>>> Specifically, it looks like it's hitting this:
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The slab was either on partial or free=
 list so
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* there must be at least one object avai=
lable for
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* allocation.
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(slabp->inuse >=3D cachep->num);
>>>
>>> ...which looks like maybe the accounting of in-use objects is off. This
>>> really sounds like some sort of memory corruption. I've not been able
>>> to reproduce this so far, but I also had someone report panic here that
>>> might be related:
>>>
>>> =A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D731278
>>>
>>> One thing that might be helpful is turning on page poisoning and
>>> redoing this test, that might make it crash sooner and point out the
>>> source of the corruption.
>>>
>>> Even better would be a bisect to track down the cause...
>>
>>
>> Hi Jeff,
>>
>> root@acerlw:/usr/src/linux# grep CONFIG_PAGE_POISONING .config
>> root@acerlw:/usr/src/linux# ls -l ../linux
>> lrwxrwxrwx 1 root root 13 Aug 17 14:41 ../linux -> linux-3.1-rc2/
>> root@acerlw:/usr/src/linux#
>>
>> In what kernel is that feature available, or, how do I enable it?
>>
> It is selected by "Kernel hacking" -> "Debug page memory allocations",
> provided your arch support pagealloc debug.
>
> - Arnaud

Hi,

Thanks, a larger dump below with that option enabled:

[  478.103032] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[  478.103049] CPU 1=20
[  478.103052] Modules linked in: bnep rfcomm bluetooth speedstep_lib crypt=
d aes_x86_64 aes_generic configfs ohci_hcd ssb ath9k mac80211 uvcvideo ath9=
k_common ath9k_hw ath videodev mmc_core video edac_core k10temp edac_mce_am=
d v4l2_compat_ioctl32 i2c_piix4 battery cfg80211 ac pcmcia shpchp pci_hotpl=
ug wmi pcmcia_core rfkill
[  478.103107]=20
[  478.103113] Pid: 3978, comm: echo Not tainted 3.1.0-rc2 #3 Acer         =
   Aspire 7551                    /Aspire 7551=20
[  478.103126] RIP: 0010:[<ffffffff8134e839>]  [<ffffffff8134e839>] tty_par=
anoia_check+0x9/0x70
[  478.103144] RSP: 0018:ffff88012e0f1e88  EFLAGS: 00010282
[  478.103150] RAX: ffff88013b65d740 RBX: 000000000000002a RCX: ffff88012e0=
f1f48
[  478.103155] RDX: ffffffff8199c18c RSI: ffff88013b7da490 RDI: 9440ffff880=
13273
[  478.103161] RBP: ffff88012e0f1e88 R08: 00007fcc4da01700 R09: ffff88013b7=
da490
[  478.103166] R10: 0000000000000000 R11: 0000000000000246 R12: 9440ffff880=
13273
[  478.103172] R13: 00007fcc4da0e000 R14: ffff8801388e7bc0 R15: ffff8801388=
e7bc0
[  478.103179] FS:  00007fcc4da01700(0000) GS:ffff88013fc80000(0000) knlGS:=
0000000000000000
[  478.103185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  478.103190] CR2: 00007fcc4d538380 CR3: 000000013277c000 CR4: 00000000000=
006e0
[  478.103195] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  478.103201] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  478.103207] Process echo (pid: 3978, threadinfo ffff88012e0f0000, task f=
fff88012e15a150)
[  478.103212] Stack:
[  478.103215]  ffff88012e0f1ef8 ffffffff8134f17b 0000000000000022 00000007=
fcc4da0e
[  478.103227]  ffff88012e0f1f18 ffffffff8109f2c7 000000002308a472 ffff8801=
3a9df800
[  478.103237]  0000000000000003 000000000000002a 00007fcc4da0e000 ffff8801=
2e0f1f48
[  478.103246] Call Trace:
[  478.103255]  [<ffffffff8134f17b>] tty_write+0x3b/0x290
[  478.103266]  [<ffffffff8109f2c7>] ? do_mmap_pgoff+0x357/0x370
[  478.103274]  [<ffffffff810b6e6a>] vfs_write+0xaa/0x160
[  478.103280]  [<ffffffff810b7155>] sys_write+0x45/0x90
[  478.103290]  [<ffffffff8164debb>] system_call_fastpath+0x16/0x1b
[  478.103295] Code: 00 00 00 00 00 48 89 df e8 c5 f0 d5 ff 48 8b 5d f0 4c =
8b 65 f8 c9 c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 ff 48 89 e5 74 0c=
=20
[  478.103336]  3f 01 54 00 00 75 2b 31 c0 5d c3 8b 76 44 48 89 d1 48 c7 c7=
=20
[  478.103357] RIP  [<ffffffff8134e839>] tty_paranoia_check+0x9/0x70
[  478.103366]  RSP <ffff88012e0f1e88>
[  478.103372] ---[ end trace df8e9f10dc5e941d ]---
[  478.103700] general protection fault: 0000 [#2] SMP DEBUG_PAGEALLOC
[  478.103711] CPU 0=20
[  478.103715] Modules linked in: bnep rfcomm bluetooth speedstep_lib crypt=
d aes_x86_64 aes_generic configfs ohci_hcd ssb ath9k mac80211 uvcvideo ath9=
k_common ath9k_hw ath videodev mmc_core video edac_core k10temp edac_mce_am=
d v4l2_compat_ioctl32 i2c_piix4 battery cfg80211 ac pcmcia shpchp pci_hotpl=
ug wmi pcmcia_core rfkill
[  478.103766]=20
[  478.103772] Pid: 3933, comm: atd Tainted: G      D     3.1.0-rc2 #3 Acer=
            Aspire 7551                    /Aspire 7551=20
[  478.103785] RIP: 0010:[<ffffffff8134e839>]  [<ffffffff8134e839>] tty_par=
anoia_check+0x9/0x70
[  478.103803] RSP: 0018:ffff880139749e88  EFLAGS: 00010282
[  478.103808] RAX: ffff88013b65d740 RBX: 0000000000000013 RCX: ffff8801397=
49f48
[  478.103814] RDX: ffffffff8199c18c RSI: ffff88013b7da490 RDI: 9440ffff880=
13273
[  478.103820] RBP: ffff880139749e88 R08: 0000000000000000 R09: ffff88013b7=
da490
[  478.103825] R10: 0000000000000000 R11: 0000000000000246 R12: 9440ffff880=
13273
[  478.103831] R13: 00007fff04275cb0 R14: ffff8801388e7bc0 R15: ffff8801388=
e7bc0
[  478.103838] FS:  00007fd613e52700(0000) GS:ffff88013fc00000(0000) knlGS:=
0000000000000000
[  478.103844] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  478.103849] CR2: 00007fd613a051d5 CR3: 000000013a034000 CR4: 00000000000=
006f0
[  478.103854] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  478.103859] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  478.103866] Process atd (pid: 3933, threadinfo ffff880139748000, task ff=
ff88013f2c3910)
[  478.103870] Stack:
[  478.103873]  ffff880139749ef8 ffffffff8134f17b 0000000000000f8a 00000000=
00000000
[  478.103885]  ffffffff810349fd 00007fff04275cec 0000000000000004 00000000=
00000000
[  478.103894]  0000000000000000 0000000000000013 00007fff04275cb0 ffff8801=
39749f48[  478.103903] Call Trace:
[  478.103913]  [<ffffffff8134f17b>] tty_write+0x3b/0x290
[  478.103924]  [<ffffffff810349fd>] ? do_fork+0x13d/0x210
[  478.103932]  [<ffffffff810b6e6a>] vfs_write+0xaa/0x160
[  478.103938]  [<ffffffff810b7155>] sys_write+0x45/0x90
[  478.103948]  [<ffffffff8164debb>] system_call_fastpath+0x16/0x1b
[  478.103953] Code: 00 00 00 00 00 48 89 df e8 c5 f0 d5 ff 48 8b 5d f0 4c =
8b 65 f8 c9 c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 ff 48 89 e5 74 0c=
=20
[  478.103995]  3f 01 54 00 00 75 2b 31 c0 5d c3 8b 76 44 48 89 d1 48 c7 c7=
=20
[  478.104016] RIP  [<ffffffff8134e839>] tty_paranoia_check+0x9/0x70
[  478.104025]  RSP <ffff880139749e88>
[  478.104072] ---[ end trace df8e9f10dc5e941e ]---
[  478.104333] general protection fault: 0000 [#3] SMP DEBUG_PAGEALLOC
[  478.104352] CPU 0=20
[  478.104357] Modules linked in: bnep rfcomm bluetooth speedstep_lib crypt=
d aes_x86_64 aes_generic configfs ohci_hcd ssb ath9k mac80211 uvcvideo ath9=
k_common ath9k_hw ath videodev mmc_core video edac_core k10temp edac_mce_am=
d v4l2_compat_ioctl32 i2c_piix4 battery cfg80211 ac pcmcia shpchp pci_hotpl=
ug wmi pcmcia_core rfkill
[  478.104405]=20
[  478.104410] Pid: 3933, comm: atd Tainted: G      D     3.1.0-rc2 #3 Acer=
            Aspire 7551                    /Aspire 7551=20
[  478.104422] RIP: 0010:[<ffffffff8134e839>]  [<ffffffff8134e839>] tty_par=
anoia_check+0x9/0x70
[  478.104434] RSP: 0018:ffff880139749b28  EFLAGS: 00010282
[  478.104439] RAX: ffff88013f344382 RBX: 9440ffff88013273 RCX: 00000000000=
00000
[  478.104444] RDX: ffffffff8199c20d RSI: ffff88013b7da490 RDI: 9440ffff880=
13273
[  478.104450] RBP: ffff880139749b28 R08: 0000000000000000 R09: 00000000000=
00000
[  478.104455] R10: ffff8801388e7bd0 R11: 0000000000000001 R12: 00000000000=
00008
[  478.104460] R13: ffff8801388e7bc0 R14: ffff88013b65d740 R15: ffff88013b7=
da490
[  478.104467] FS:  00007fd613e52700(0000) GS:ffff88013fc00000(0000) knlGS:=
0000000000000000
[  478.104473] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  478.104478] CR2: 00007fd613a051d5 CR3: 0000000001c1d000 CR4: 00000000000=
006f0
[  478.104483] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  478.104488] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  478.104494] Process atd (pid: 3933, threadinfo ffff880139748000, task ff=
ff88013f2c3910)
[  478.104498] Stack:
[  478.104501]  ffff880139749bd8 ffffffff8134fe31 ffff880139749b48 ffffffff=
810d259a
[  478.104512]  ffff880139749b98 ffffffff810b85df ffff88012e08b288 ffff8801=
3a154390
[  478.104520]  0000000000000000 ffff8801388e7bd0 ffff88013b7da490 00000008=
00000001
[  478.104529] Call Trace:
[  478.104538]  [<ffffffff8134fe31>] tty_release+0x41/0x550
[  478.104546]  [<ffffffff810d259a>] ? mntput+0x1a/0x30
[  478.104554]  [<ffffffff810b85df>] ? fput+0x15f/0x200
[  478.104561]  [<ffffffff810b8552>] fput+0xd2/0x200
[  478.104570]  [<ffffffff810b50c1>] filp_close+0x61/0x90
[  478.104578]  [<ffffffff810384bf>] put_files_struct+0x7f/0xe0
[  478.104585]  [<ffffffff810385c4>] exit_files+0x44/0x50
[  478.104591]  [<ffffffff81038bc4>] do_exit+0x5f4/0x790
[  478.104600]  [<ffffffff81036e94>] ? kmsg_dump+0x44/0xe0
[  478.104609]  [<ffffffff81004f25>] oops_end+0x75/0xa0
[  478.104615]  [<ffffffff81005093>] die+0x53/0x80
[  478.104623]  [<ffffffff81002854>] do_general_protection+0x154/0x160
[  478.104631]  [<ffffffff8164da7f>] general_protection+0x1f/0x30
[  478.104641]  [<ffffffff8134e839>] ? tty_paranoia_check+0x9/0x70
[  478.104649]  [<ffffffff8134f17b>] tty_write+0x3b/0x290
[  478.104657]  [<ffffffff810349fd>] ? do_fork+0x13d/0x210
[  478.104664]  [<ffffffff810b6e6a>] vfs_write+0xaa/0x160
[  478.104670]  [<ffffffff810b7155>] sys_write+0x45/0x90
[  478.104679]  [<ffffffff8164debb>] system_call_fastpath+0x16/0x1b
[  478.104683] Code: 00 00 00 00 00 48 89 df e8 c5 f0 d5 ff 48 8b 5d f0 4c =
8b 65 f8 c9 c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 ff 48 89 e5 74 0c=
=20
[  478.104724]  3f 01 54 00 00 75 2b 31 c0 5d c3 8b 76 44 48 89 d1 48 c7 c7=
=20
[  478.104744] RIP  [<ffffffff8134e839>] tty_paranoia_check+0x9/0x70
[  478.104753]  RSP <ffff880139749b28>
[  478.104757] ---[ end trace df8e9f10dc5e941f ]---
[  478.104761] Fixing recursive fault but reboot is needed!
[  478.152105] general protection fault: 0000 [#4] SMP DEBUG_PAGEALLOC
[  478.152117] CPU 1=20
[  478.152120] Modules linked in: bnep rfcomm bluetooth speedstep_lib crypt=
d aes_x86_64 aes_generic configfs ohci_hcd ssb ath9k mac80211 uvcvideo ath9=
k_common ath9k_hw ath videodev mmc_core video edac_core k10temp edac_mce_am=
d v4l2_compat_ioctl32 i2c_piix4 battery cfg80211 ac pcmcia shpchp pci_hotpl=
ug wmi pcmcia_core rfkill
[  478.152171] [  478.152177] Pid: 3936, comm: danted Tainted: G      D    =
 3.1.0-rc2 #3 Acer            Aspire 7551                    /Aspire 7551=
=20
[  478.152190] RIP: 0010:[<ffffffff8134e839>]  [<ffffffff8134e839>] tty_par=
anoia_check+0x9/0x70
[  478.152208] RSP: 0018:ffff880138abdd18  EFLAGS: 00010286
[  478.152213] RAX: ffff88013f344300 RBX: 88012e1400003000 RCX: 00000000000=
00000
[  478.152219] RDX: ffffffff8199c20d RSI: ffff88013b5732f0 RDI: 88012e14000=
03000
[  478.152224] RBP: ffff880138abdd18 R08: 0000000000000000 R09: 00000000000=
00000
[  478.152229] R10: ffff8801388e7150 R11: 0000000000000001 R12: 00000000000=
00008
[  478.152235] R13: ffff8801388e7140 R14: ffff88012fa19d80 R15: ffff88013b5=
732f0
[  478.152241] FS:  00007fe3e8099700(0000) GS:ffff88013fc80000(0000) knlGS:=
0000000000000000
[  478.152247] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  478.152253] CR2: 00007fe3e7bad520 CR3: 0000000001c1d000 CR4: 00000000000=
006e0
[  478.152258] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  478.152263] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  478.152269] Process danted (pid: 3936, threadinfo ffff880138abc000, task=
 ffff88012e0c1810)
[  478.152274] Stack:
[  478.152277]  ffff880138abddc8 ffffffff8134fe31 ffff880138abdd38 ffffffff=
810d259a
[  478.152288]  ffff880138abdd88 ffffffff810b85df ffff8801326ea3d8 ffff8801=
325a5250
[  478.152297]  0000000000000000 ffff8801388e7150 ffff88013b5732f0 00000008=
00000001
[  478.152307] Call Trace:
[  478.152317]  [<ffffffff8134fe31>] tty_release+0x41/0x550
[  478.152326]  [<ffffffff810d259a>] ? mntput+0x1a/0x30
[  478.152334]  [<ffffffff810b85df>] ? fput+0x15f/0x200
[  478.152341]  [<ffffffff810b8552>] fput+0xd2/0x200
[  478.152350]  [<ffffffff810b50c1>] filp_close+0x61/0x90
[  478.152358]  [<ffffffff810384bf>] put_files_struct+0x7f/0xe0
[  478.152365]  [<ffffffff810385c4>] exit_files+0x44/0x50
[  478.152372]  [<ffffffff81038bc4>] do_exit+0x5f4/0x790
[  478.152380]  [<ffffffff810baf46>] ? vfs_stat+0x16/0x20
[  478.152387]  [<ffffffff810bb285>] ? sys_newstat+0x15/0x30
[  478.152394]  [<ffffffff810b7040>] ? vfs_read+0x120/0x160
[  478.152402]  [<ffffffff8103908f>] do_group_exit+0x3f/0xa0
[  478.152409]  [<ffffffff81039102>] sys_exit_group+0x12/0x20
[  478.152418]  [<ffffffff8164debb>] system_call_fastpath+0x16/0x1b
[  478.152423] Code: 00 00 00 00 00 48 89 df e8 c5 f0 d5 ff 48 8b 5d f0 4c =
8b 65 f8 c9 c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 ff 48 89 e5 74 0c=
=20
[  478.152464]  3f 01 54 00 00 75 2b 31 c0 5d c3 8b 76 44 48 89 d1 48 c7 c7=
=20
[  478.152485] RIP  [<ffffffff8134e839>] tty_paranoia_check+0x9/0x70
[  478.152495]  RSP <ffff880138abdd18>
[  478.152501] ---[ end trace df8e9f10dc5e9420 ]---
[  478.152505] Fixing recursive fault but reboot is needed!

Justin.

--655872-682518914-1313617984=:11234--
