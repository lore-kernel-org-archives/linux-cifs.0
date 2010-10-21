From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 oops at small_smb2_init
Date: Thu, 21 Oct 2010 16:08:00 -0500
Message-ID: <AANLkTimRKBucjze3TTMFh+9F3KGcnx7pKR6WrwHwFjTN@mail.gmail.com>
References: <4CAF34C2.9050404@suse.de>
	<AANLkTimr0d-N_xBPrvB=2tRVrhYMX=kKECRsbaNS_urb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimr0d-N_xBPrvB=2tRVrhYMX=kKECRsbaNS_urb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 21, 2010 at 4:07 PM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Oct 8, 2010 at 10:12 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org=
> wrote:
>> Hi Steve,
>>
>> When I try to mount a smb2 share and do an `ls' and basic file opera=
tions
>> I get this oops. My smb2 git tree up-to-date with top-most commit:
>>
>> commit 17e0c71f49f98c1fc0e8eb34775eb05d2388edd2
>> Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>> Date: =A0 Mon Sep 27 11:22:40 2010 -0500
>>
>>
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211947] BUG: unable to h=
andle kernel NULL pointer dereference at (null)
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] IP: [<e0b1859a>]=
 small_smb2_init+0x48a/0x570 [smb2]
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] *pdpt =3D 000000=
001cc22001 *pde =3D 0000000000000000
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] Oops: 0000 [#1] =
PREEMPT SMP
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] last sysfs file:=
 /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/PNP0C0A:00/power_suppl=
y/BAT0/energy_full
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] Modules linked i=
n: smb2 fscache snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd af=
_packet mperf fuse loop dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd=
_pcm snd_timer ppdev snd parport_pc soundcore parport battery ac button=
 snd_page_alloc sg e1000 pcspkr joydev i2c_piix4 fan processor thermal =
thermal_sys
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396]
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] Pid: 3098, comm:=
 df Not tainted 2.6.36-rc4-12-desktop #2 /VirtualBox
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] EIP: 0060:[<e0b1=
859a>] EFLAGS: 00010213 CPU: 0
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] EIP is at small_=
smb2_init+0x48a/0x570 [smb2]
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] EAX: df9fe2c0 EB=
X: df98a400 ECX: df98a40c EDX: 00000000
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] ESI: 00000000 ED=
I: dfbcde54 EBP: dfbcde18 ESP: dfbcddd0
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A0DS: 007b ES: =
007b FS: 00d8 GS: 0033 SS: 0068
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] Process df (pid:=
 3098, ti=3Ddfbcc000 task=3Dde5d0130 task.ti=3Ddfbcc000)
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] Stack:
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A03939312e 5d32=
3438 00000020 dfbcde25 dfbcde54 00000202 dfbcde16 df98a414
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] <0> c07c5f80 000=
30005 dfbcde16 dfbcde9a dfbcded8 df98a400 dfbcde18 dfbcde9a
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] <0> fffffffb df9=
8a400 dfbcde64 e0b19081 e0b2c2be e0b2c1f1 de11921c dfbcded4
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] Call Trace:
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A0[<e0b19081>] =
? SMB2_open+0x61/0x210 [smb2]
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A0[<c0303d2f>] =
? link_path_walk+0x2df/0x8f0
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A0[<e0b174e6>] =
? smb2_statfs+0x96/0x180 [smb2]
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A0[<c031cf4d>] =
? statfs_by_dentry+0x5d/0x80
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A0[<c031cf8d>] =
? vfs_statfs+0x1d/0xc0
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A0[<c031d04b>] =
? do_statfs64+0x1b/0x40
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A0[<c031d27a>] =
? sys_statfs64+0x5a/0x90
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] =A0[<c0202dd8>] =
? sysenter_do_call+0x12/0x28
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] Code: d0 5a ae d=
f e9 e1 fb ff ff b8 5c 77 b3 e0 e8 8e 86 ae df 8b 43 0c 8d 4b 0c 39 c1 =
8b 10 75 06 eb 0e 89 d0 89 f2 80 48 4c 02 39 ca <8b> 32 75 f2 b8 5c 77 =
b3 e0 e8 98 83 ae df 8b 45 d8 8b 4b 2c 8b
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] EIP: [<e0b1859a>=
] small_smb2_init+0x48a/0x570 [smb2] SS:ESP 0068:dfbcddd0
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.212396] CR2: 00000000000=
00000
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.238770] ---[ end trace 1=
f484c3add74651c ]---
>>
>>
>> sFYI output (snipped)
>>
>> <snip>
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.207890] fs/smb2/smb2pdu.=
c: negotiated smb2 dialect
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.207892] fs/smb2/sess.c: =
Security Mode: 0x1 Capabilities: 0x1 TimeAdjust: 0
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.207894] fs/smb2/smb2pdu.=
c: Session Setup
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.207896] fs/smb2/smb2pdu.=
c: sec_flags 0x7
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.207899] fs/smb2/transpor=
t.c: Credits: 20
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.207900] fs/smb2/transpor=
t.c: For smb_command 1
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.207902] fs/smb2/transpor=
t.c: Sending smb: total_len 124
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultip=
lex.c: rfc1002 length 0x10e
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultip=
lex.c: num_bytes to read from socket 64
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultip=
lex.c: read from socket returns 0 with total_read 64
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultip=
lex.c: before find owner for 119
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultip=
lex.c: After find owner for 119
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultip=
lex.c: num_bytes to read from socket 202
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209018] Status code retu=
rned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/maperror=
=2Ec: Mapping SMB2 status code -1073741802 to POSIX err -5
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/misc.c: =
Null buffer passed to smb2_small_buf_release
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/smb2pdu.=
c: sess setup returned buftype 1 with rc -5 status 0xc0000016
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/smb2pdu.=
c: sec_flags 0x7
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/transpor=
t.c: Credits: 39
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/transpor=
t.c: For smb_command 1
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/transpor=
t.c: Sending smb: total_len 196
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211763] fs/smb2/demultip=
lex.c: rfc1002 length 0x4c
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211779] fs/smb2/demultip=
lex.c: num_bytes to read from socket 64
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211794] fs/smb2/demultip=
lex.c: read from socket returns 0 with total_read 64
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211807] fs/smb2/demultip=
lex.c: before find owner for 120
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211820] fs/smb2/demultip=
lex.c: After find owner for 120
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211832] fs/smb2/demultip=
lex.c: num_bytes to read from socket 8
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211882] fs/smb2/misc.c: =
Null buffer passed to smb2_small_buf_release
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211895] fs/smb2/smb2pdu.=
c: sess setup returned buftype 1 with rc 0 status 0x0
>> Oct =A08 20:21:34 linux-duw1 kernel: [ 2040.211907] fs/smb2/sess.c: =
SMB2 Session Established successfully
>> </snip>
>>
>>
>> --
>> Suresh Jayaraman
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> Suresh, I do not see an oops just by doing ls or ls -l against an smb=
2
> mounted share.
> Is there a particular command that you execute that results in oops? =
I
> can try that
> to recreate here.
>

I see tons of slab errors logged but no oops just for doing ls or ls -l
