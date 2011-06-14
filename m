From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Tue, 14 Jun 2011 06:59:08 +0400
Message-ID: <BANLkTinvcQP3BCNtxXtdrOEbXiBDUZK0iQ@mail.gmail.com>
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
	<20110613114831.37c90109@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>,
	Connor Hansen <cmdkhh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110613114831.37c90109-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/6/13 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Sun, 12 Jun 2011 00:31:47 +0200 (CEST)
> Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org> wrote:
>
>>
>>
>>
>> <snip>
>> >
>> > Yep, mea culpa. This patch should fix it. Martin, can you test it?
>> > Anyone else have comments?
>> >
>> > Thanks...
>>
>>
>> Unfortunately, I have to quote Britney: "Oops! I did it again"
>> Well, not entirely true, the OOPS changed into a BUG, but my samba m=
ount
>> still doesn't work.
>>
>> The OOPS to BUG has a interesting diff. Don't know if it really matt=
ers,
>> but some more info about my samba setup. Never such a thing as to mu=
ch
>> info. Note, the SAMBA hostname and DNS hostname of the server are
>> NOT the same.
>>
>>
>> ######## <samba setup> #############
>> SERVER:
>> -DNS_hostname =A0 =A0 =A0 =A0 : sarijopen.student.utwente.nl
>> -SAMBA_hostname =A0 =A0 =A0 =A0 =A0 =A0 =A0 : duckman-tm
>> -ipv4 only =A0 =A0 =A0 =A0 =A0 =A0:
>> testparm -v|grep wins :
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 name res=
olve order =3D lmhosts wins host bcast
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 max wins=
 ttl =3D 518400
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 min wins=
 ttl =3D 21600
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wins pro=
xy =3D No
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wins ser=
ver =3D 130.89.4.21, 130.89.4.22
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wins sup=
port =3D No
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wins hoo=
k =3D
>> No Domain Controller or anything. This a student LAN of circa 1000
>> computers where you can set your SAMBA hostname and workgroup to any=
thing you like. Browse masters
>> of ad hoc workgroups are decided by elections. Only the WINS servers=
 are
>> provided as a service of the IT department. I dont have very deep
>> knowledge of samba, but when I read some specs, my first thought was=
 "this stuff is NOT designed for the way we use it".
>> However, it works. (Well, with a s*#%load of legitimate samba broadc=
ast
>> traffic)
>>
>> CLIENT:
>> -DNS_hostname =3D xxxx.student.utwente.nl
>> -SAMBA_hostname =3D xxxx
>> -ipv4/ipv6 dual stack
>> -fstab: =A0 =A0 =A0 //sarijopen.student.utwente.nl/sysadmin /home/XX=
XX/docs_sysadmin
>> cifs =A0 =A0guest,uid=3DXXXX,gid=3DXXXX,users,auto,nounix,nobrl =A0 =
=A0 0
>> 0
>> ######### </samba setup> #########
>>
>>
>>
>> diff -up OOPS BUG
>>
>> CIFS VFS: default security mechanism requested. =A0The default secur=
ity
>> mechanism will be upgraded from ntlm to ntlmv2 in kernel release 2.6=
=2E41
>> -BUG: unable to handle kernel NULL pointer dereference at 0000000000=
0000a0
>> -IP: [<ffffffffa041e286>] CIFSTCon+0xf6/0x4d0 [cifs]
>> -PGD 127393067 PUD 129c80067 PMD 0
>> -Oops: 0000 [#1] SMP
>> +CIFS VFS: dns_resolve_server_name_to_ip: unable to resolve:
>> sarijopen.student.utwente.nl
>> +CIFS VFS: cifs_compose_mount_options: Failed to resolve server part=
 of
>> \\sarijopen.student.utwente.nl\sysadmin to IP: -2
>> +------------[ cut here ]------------
>> +kernel BUG at mm/slab.c:501!
>> +invalid opcode: 0000 [#1] SMP
>>
>> BUG:
>>
>> Registering the dns_resolver key type
>> CIFS VFS: default security mechanism requested. =A0The default secur=
ity
>> mechanism will be upgraded from ntlm to ntlmv2 in kernel release 2.6=
=2E41
>> CIFS VFS: dns_resolve_server_name_to_ip: unable to resolve:
>> sarijopen.student.utwente.nl
>> CIFS VFS: cifs_compose_mount_options: Failed to resolve server part =
of
>> \\sarijopen.student.utwente.nl\sysadmin to IP: -2
>> ------------[ cut here ]------------
>> kernel BUG at mm/slab.c:501!
>> invalid opcode: 0000 [#1] SMP
>> CPU 0
>> Modules linked in: des_generic ecb md4 hmac nls_utf8 cifs dns_resolv=
er
>> nfsd nfs lockd fscache sunrpc xfs fuse radeon ttm drm_kms_helper drm
>> i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect loop sg asus_atk0110 =
usbhid
>> sr_mod cdrom hid evdev pata_marvell sky2 skge snd_hda_codec_hdmi
>> snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm t=
pm_tis
>> snd_seq_midi snd_rawmidi tpm snd_seq_midi_event pcspkr tpm_bios snd_=
seq
>> uhci_hcd snd_timer snd_seq_device snd i2c_i801 i2c_core ehci_hcd int=
el_agp
>> intel_gtt soundcore snd_page_alloc
>>
>> Pid: 2085, comm: mount.cifs Not tainted 3.0.0-rc1-debug-patched #1 S=
ystem
>> manufacturer P5Q-E/P5Q-E
>> RIP: 0010:[<ffffffff810d19f4>] =A0[<ffffffff810d19f4>] kfree+0x134/0=
x170
>> RSP: 0018:ffff880129251cc8 =A0EFLAGS: 00010046
>> RAX: ffffea000070f420 RBX: ffff8801287e2e00 RCX: ffff88012f3c8800
>> RDX: 4000000000000000 RSI: 00000000000000d0 RDI: ffffffffa045cebb
>> RBP: ffff880129251d18 R08: b018000000000000 R09: 000000000000000a
>> R10: 0000000000000006 R11: dead000000200200 R12: ffffffffa045cebb
>> R13: 0000000000000282 R14: ffff88012a903400 R15: ffff88012a903800
>> FS: =A000007f6d20b9f700(0000) GS:ffff88012fc00000(0000)
>> knlGS:0000000000000000
>> CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 00007fb9903dfc58 CR3: 0000000128b43000 CR4: 00000000000406f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process mount.cifs (pid: 2085, threadinfo ffff880129250000, task
>> ffff88012aba6100)
>> Stack:
>> =A0 ffff880129251c5c ffffffff810ec545 ffff88012f3c8800 ffff88010f876=
d10
>> =A0 ffff88012f3c8800 ffff8801287e2e00 ffff880129251d80 ffff88010f876=
d10
>> =A0 ffff88012a903400 ffff88012a903800 ffff880129251d38 ffffffffa043d=
19f
>> Call Trace:
>> =A0 [<ffffffff810ec545>] ? __d_instantiate+0x85/0xf0
>> =A0 [<ffffffffa043d19f>] cifs_cleanup_volume_info+0x1f/0x70 [cifs]
>> =A0 [<ffffffffa043123b>] cifs_do_mount+0x11b/0x3b0 [cifs]
>> =A0 [<ffffffff810db35b>] mount_fs+0x1b/0xd0
>> =A0 [<ffffffff810f5c6e>] vfs_kern_mount+0x5e/0xd0
>> =A0 [<ffffffff810f5d4d>] do_kern_mount+0x4d/0x110
>> =A0 [<ffffffff810f732b>] do_mount+0x2cb/0x7d0
>> =A0 [<ffffffff810f78c3>] sys_mount+0x93/0xe0
>> =A0 [<ffffffff8138bdbb>] system_call_fastpath+0x16/0x1b
>> Code: c8 44 01 09 4c 8b 45 c0 41 fe 46 40 8b 13 4b 8d 34 38 29 c2 4c=
 89 c7
>> 89 13 89 d2 48 c1 e2 03 e8 53 d2 0c 00 8b 03 e9 47 ff ff ff <0f> 0b =
eb fe
>> 48 8b 40 10 e9 16 ff ff ff 4c 8d 43 18 89 c2 4c 89
>> RIP =A0[<ffffffff810d19f4>] kfree+0x134/0x170
>> =A0 RSP <ffff880129251cc8>
>> ---[ end trace cffbbd6be8c5a0f3 ]---
>>
>>
>>
>> So, we're from OOPS to BUG. I tried gdb, but it won't decode the
>> kfree+0x134 into something, which I could with the real OOPS.
>> Some pointers how I can help with gdb?
>>
>> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Oopses men=
tions
>> only OOPS, no BUG.
>>
>> Greetz Martijn
>> (BTW, I will mostly be of the net a couple of days, so my reply's ca=
n take
>> a while)
>>
>
> (cc'ing Pavel)
>
> Ok, I've been able to reproduce on -rc2 as well, simply by mounting
> with -o sec=3Dnone. Pavel, I'm pretty sure this got broken by commit
> 724d9f1cfb. That patch doesn't handle the "null user" case correctly.
> There are probably several different ways to fix it:
>
>
> [ =A0249.418776] ------------[ cut here ]------------
> [ =A0249.419050] kernel BUG at mm/slub.c:2948!
> [ =A0249.419050] invalid opcode: 0000 [#1] SMP
> [ =A0249.419050] CPU 1
> [ =A0249.419050] Modules linked in: des_generic md4 nls_utf8 cifs fsc=
ache sunrpc ipx p8022 psnap llc p8023 rose ax25 joydev i2c_piix4 i2c_co=
re virtio_balloon virtio_net virtio_blk [last unloaded: cifs]
> [ =A0249.419050]
> [ =A0249.419050] Pid: 1058, comm: mount.cifs Not tainted 3.0-0.rc2.gi=
t0.2.fc16.x86_64 #1 Bochs Bochs
> [ =A0249.419050] RIP: 0010:[<ffffffff81126249>] =A0[<ffffffff81126249=
>] kfree+0x60/0xfc
> [ =A0249.419050] RSP: 0018:ffff88003ba2bce8 =A0EFLAGS: 00010246
> [ =A0249.419050] RAX: 0020000000000000 RBX: ffffffffa013d46d RCX: fff=
f880034380930
> [ =A0249.419050] RDX: 0020000000000000 RSI: ffff8800314a4ea0 RDI: fff=
fffffa013d46d
> [ =A0249.419050] RBP: ffff88003ba2bd08 R08: ffff88003e002500 R09: 000=
000000000005a
> [ =A0249.419050] R10: ffffffff82421ed0 R11: 00000000000003a7 R12: fff=
fea0000704558
> [ =A0249.419050] R13: ffff88002f1a8050 R14: ffff88003140c2d0 R15: fff=
f88003a40d330
> [ =A0249.419050] FS: =A000007f89290dc740(0000) GS:ffff88003fc00000(00=
00) knlGS:0000000000000000
> [ =A0249.419050] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ =A0249.419050] CR2: 00007f804783a240 CR3: 000000003aea9000 CR4: 000=
00000000006e0
> [ =A0249.419050] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> [ =A0249.419050] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
> [ =A0249.419050] Process mount.cifs (pid: 1058, threadinfo ffff88003b=
a2a000, task ffff8800314a47a0)
> [ =A0249.419050] Stack:
> [ =A0249.419050] =A0ffff88003c312000 ffff88003ba2bd70 ffff88002f1a805=
0 ffff88003140c2d0
> [ =A0249.419050] =A0ffff88003ba2bd28 ffffffffa011e1a7 ffff88003ba1c24=
0 ffff88003140c240
> [ =A0249.419050] =A0ffff88003ba2bda8 ffffffffa0112107 ffff88003ba2bd9=
8 ffff880034380930
> [ =A0249.419050] Call Trace:
> [ =A0249.419050] =A0[<ffffffffa011e1a7>] cifs_cleanup_volume_info+0x2=
4/0x72 [cifs]
> [ =A0249.419050] =A0[<ffffffffa0112107>] cifs_do_mount+0x34e/0x364 [c=
ifs]
> [ =A0249.419050] =A0[<ffffffff8113a2dd>] mount_fs+0x69/0x158
> [ =A0249.419050] =A0[<ffffffff81103e6c>] ? __alloc_percpu+0x10/0x12
> [ =A0249.419050] =A0[<ffffffff8114f35e>] vfs_kern_mount+0x63/0xa0
> [ =A0249.419050] =A0[<ffffffff81150032>] do_kern_mount+0x4d/0xdf
> [ =A0249.419050] =A0[<ffffffff811516c8>] do_mount+0x63c/0x69f
> [ =A0249.419050] =A0[<ffffffff811519ac>] sys_mount+0x88/0xc2
> [ =A0249.419050] =A0[<ffffffff814fb002>] system_call_fastpath+0x16/0x=
1b
> [ =A0249.419050] Code: e9 ae 00 00 00 48 83 fb 10 0f 86 af 00 00 00 4=
8 89 df e8 11 dd ff ff 49 89 c4 48 8b 00 a8 80 75 19 49 f7 04 24 00 c0 =
00 00 75 02 <0f> 0b 4c 89 e7 e8 78 e1 fc ff e9 84 00 00 00 4d 8b 6c 24 =
10 48
> [ =A0249.419050] RIP =A0[<ffffffff81126249>] kfree+0x60/0xfc
> [ =A0249.419050] =A0RSP <ffff88003ba2bce8>
> [ =A0249.474238] ---[ end trace 48c6ff1e268f2f6a ]---
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Ok, I will look at it soon.

--=20
Best regards,
Pavel Shilovsky.
