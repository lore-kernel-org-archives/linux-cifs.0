From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: smb2 oops at small_smb2_init
Date: Fri, 22 Oct 2010 12:09:23 +0530
Message-ID: <4CC1319B.5020504@suse.de>
References: <4CAF34C2.9050404@suse.de>	<AANLkTimr0d-N_xBPrvB=2tRVrhYMX=kKECRsbaNS_urb@mail.gmail.com> <AANLkTimRKBucjze3TTMFh+9F3KGcnx7pKR6WrwHwFjTN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimRKBucjze3TTMFh+9F3KGcnx7pKR6WrwHwFjTN-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/22/2010 02:38 AM, Shirish Pargaonkar wrote:
> On Thu, Oct 21, 2010 at 4:07 PM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Fri, Oct 8, 2010 at 10:12 AM, Suresh Jayaraman <sjayaraman@suse.d=
e> wrote:
>>> Hi Steve,
>>>
>>> When I try to mount a smb2 share and do an `ls' and basic file oper=
ations
>>> I get this oops. My smb2 git tree up-to-date with top-most commit:
>>>
>>> commit 17e0c71f49f98c1fc0e8eb34775eb05d2388edd2
>>> Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>> Date: =EF=BF=BD Mon Sep 27 11:22:40 2010 -0500
>>>
>>>
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211947] BUG: unab=
le to handle kernel NULL pointer dereference at (null)
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] IP: [<e0b=
1859a>] small_smb2_init+0x48a/0x570 [smb2]
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] *pdpt =3D=
 000000001cc22001 *pde =3D 0000000000000000
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] Oops: 000=
0 [#1] PREEMPT SMP
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] last sysf=
s file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/PNP0C0A:00/powe=
r_supply/BAT0/energy_full
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] Modules l=
inked in: smb2 fscache snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device=
 edd af_packet mperf fuse loop dm_mod snd_intel8x0 snd_ac97_codec ac97_=
bus snd_pcm snd_timer ppdev snd parport_pc soundcore parport battery ac=
 button snd_page_alloc sg e1000 pcspkr joydev i2c_piix4 fan processor t=
hermal thermal_sys
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396]
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] Pid: 3098=
, comm: df Not tainted 2.6.36-rc4-12-desktop #2 /VirtualBox
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] EIP: 0060=
:[<e0b1859a>] EFLAGS: 00010213 CPU: 0
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] EIP is at=
 small_smb2_init+0x48a/0x570 [smb2]
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] EAX: df9f=
e2c0 EBX: df98a400 ECX: df98a40c EDX: 00000000
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] ESI: 0000=
0000 EDI: dfbcde54 EBP: dfbcde18 ESP: dfbcddd0
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] Process d=
f (pid: 3098, ti=3Ddfbcc000 task=3Dde5d0130 task.ti=3Ddfbcc000)
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] Stack:
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
3939312e 5d323438 00000020 dfbcde25 dfbcde54 00000202 dfbcde16 df98a414
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] <0> c07c5=
f80 00030005 dfbcde16 dfbcde9a dfbcded8 df98a400 dfbcde18 dfbcde9a
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] <0> fffff=
ffb df98a400 dfbcde64 e0b19081 e0b2c2be e0b2c1f1 de11921c dfbcded4
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] Call Trac=
e:
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
[<e0b19081>] ? SMB2_open+0x61/0x210 [smb2]
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
[<c0303d2f>] ? link_path_walk+0x2df/0x8f0
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
[<e0b174e6>] ? smb2_statfs+0x96/0x180 [smb2]
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
[<c031cf4d>] ? statfs_by_dentry+0x5d/0x80
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
[<c031cf8d>] ? vfs_statfs+0x1d/0xc0
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
[<c031d04b>] ? do_statfs64+0x1b/0x40
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
[<c031d27a>] ? sys_statfs64+0x5a/0x90
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] =EF=BF=BD=
[<c0202dd8>] ? sysenter_do_call+0x12/0x28
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] Code: d0 =
5a ae df e9 e1 fb ff ff b8 5c 77 b3 e0 e8 8e 86 ae df 8b 43 0c 8d 4b 0c=
 39 c1 8b 10 75 06 eb 0e 89 d0 89 f2 80 48 4c 02 39 ca <8b> 32 75 f2 b8=
 5c 77 b3 e0 e8 98 83 ae df 8b 45 d8 8b 4b 2c 8b
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] EIP: [<e0=
b1859a>] small_smb2_init+0x48a/0x570 [smb2] SS:ESP 0068:dfbcddd0
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.212396] CR2: 0000=
000000000000
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.238770] ---[ end =
trace 1f484c3add74651c ]---
>>>
>>>
>>> sFYI output (snipped)
>>>
>>> <snip>
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.207890] fs/smb2/s=
mb2pdu.c: negotiated smb2 dialect
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.207892] fs/smb2/s=
ess.c: Security Mode: 0x1 Capabilities: 0x1 TimeAdjust: 0
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.207894] fs/smb2/s=
mb2pdu.c: Session Setup
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.207896] fs/smb2/s=
mb2pdu.c: sec_flags 0x7
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.207899] fs/smb2/t=
ransport.c: Credits: 20
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.207900] fs/smb2/t=
ransport.c: For smb_command 1
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.207902] fs/smb2/t=
ransport.c: Sending smb: total_len 124
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/d=
emultiplex.c: rfc1002 length 0x10e
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/d=
emultiplex.c: num_bytes to read from socket 64
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/d=
emultiplex.c: read from socket returns 0 with total_read 64
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/d=
emultiplex.c: before find owner for 119
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/d=
emultiplex.c: After find owner for 119
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/d=
emultiplex.c: num_bytes to read from socket 202
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209018] Status co=
de returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/m=
aperror.c: Mapping SMB2 status code -1073741802 to POSIX err -5
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/m=
isc.c: Null buffer passed to smb2_small_buf_release
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/s=
mb2pdu.c: sess setup returned buftype 1 with rc -5 status 0xc0000016
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/s=
mb2pdu.c: sec_flags 0x7
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/t=
ransport.c: Credits: 39
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/t=
ransport.c: For smb_command 1
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/t=
ransport.c: Sending smb: total_len 196
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211763] fs/smb2/d=
emultiplex.c: rfc1002 length 0x4c
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211779] fs/smb2/d=
emultiplex.c: num_bytes to read from socket 64
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211794] fs/smb2/d=
emultiplex.c: read from socket returns 0 with total_read 64
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211807] fs/smb2/d=
emultiplex.c: before find owner for 120
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211820] fs/smb2/d=
emultiplex.c: After find owner for 120
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211832] fs/smb2/d=
emultiplex.c: num_bytes to read from socket 8
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211882] fs/smb2/m=
isc.c: Null buffer passed to smb2_small_buf_release
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211895] fs/smb2/s=
mb2pdu.c: sess setup returned buftype 1 with rc 0 status 0x0
>>> Oct =EF=BF=BD8 20:21:34 linux-duw1 kernel: [ 2040.211907] fs/smb2/s=
ess.c: SMB2 Session Established successfully
>>> </snip>
>>>
>>>>
>>
>> Suresh, I do not see an oops just by doing ls or ls -l against an sm=
b2
>> mounted share.
>> Is there a particular command that you execute that results in oops?=
 I
>> can try that
>> to recreate here.
>>

No, it just `ls -l' that is causing the system to oops. Do you have smb=
2
=46SCACHE configured in your kernel config?


Thanks,


--=20
Suresh Jayaraman
