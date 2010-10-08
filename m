From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: smb2 oops at small_smb2_init
Date: Fri, 08 Oct 2010 20:42:02 +0530
Message-ID: <4CAF34C2.9050404@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

When I try to mount a smb2 share and do an `ls' and basic file operations 
I get this oops. My smb2 git tree up-to-date with top-most commit:

commit 17e0c71f49f98c1fc0e8eb34775eb05d2388edd2
Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Mon Sep 27 11:22:40 2010 -0500


Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211947] BUG: unable to handle kernel NULL pointer dereference at (null)
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] IP: [<e0b1859a>] small_smb2_init+0x48a/0x570 [smb2]
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] *pdpt = 000000001cc22001 *pde = 0000000000000000
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] Oops: 0000 [#1] PREEMPT SMP
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/PNP0C0A:00/power_supply/BAT0/energy_full
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] Modules linked in: smb2 fscache snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd af_packet mperf fuse loop dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer ppdev snd parport_pc soundcore parport battery ac button snd_page_alloc sg e1000 pcspkr joydev i2c_piix4 fan processor thermal thermal_sys
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] Pid: 3098, comm: df Not tainted 2.6.36-rc4-12-desktop #2 /VirtualBox
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] EIP: 0060:[<e0b1859a>] EFLAGS: 00010213 CPU: 0
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] EIP is at small_smb2_init+0x48a/0x570 [smb2]
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] EAX: df9fe2c0 EBX: df98a400 ECX: df98a40c EDX: 00000000
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] ESI: 00000000 EDI: dfbcde54 EBP: dfbcde18 ESP: dfbcddd0
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] Process df (pid: 3098, ti=dfbcc000 task=de5d0130 task.ti=dfbcc000)
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] Stack:
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  3939312e 5d323438 00000020 dfbcde25 dfbcde54 00000202 dfbcde16 df98a414
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] <0> c07c5f80 00030005 dfbcde16 dfbcde9a dfbcded8 df98a400 dfbcde18 dfbcde9a
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] <0> fffffffb df98a400 dfbcde64 e0b19081 e0b2c2be e0b2c1f1 de11921c dfbcded4
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] Call Trace:
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  [<e0b19081>] ? SMB2_open+0x61/0x210 [smb2]
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  [<c0303d2f>] ? link_path_walk+0x2df/0x8f0
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  [<e0b174e6>] ? smb2_statfs+0x96/0x180 [smb2]
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  [<c031cf4d>] ? statfs_by_dentry+0x5d/0x80
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  [<c031cf8d>] ? vfs_statfs+0x1d/0xc0
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  [<c031d04b>] ? do_statfs64+0x1b/0x40
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  [<c031d27a>] ? sys_statfs64+0x5a/0x90
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396]  [<c0202dd8>] ? sysenter_do_call+0x12/0x28
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] Code: d0 5a ae df e9 e1 fb ff ff b8 5c 77 b3 e0 e8 8e 86 ae df 8b 43 0c 8d 4b 0c 39 c1 8b 10 75 06 eb 0e 89 d0 89 f2 80 48 4c 02 39 ca <8b> 32 75 f2 b8 5c 77 b3 e0 e8 98 83 ae df 8b 45 d8 8b 4b 2c 8b
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] EIP: [<e0b1859a>] small_smb2_init+0x48a/0x570 [smb2] SS:ESP 0068:dfbcddd0
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.212396] CR2: 0000000000000000
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.238770] ---[ end trace 1f484c3add74651c ]---


sFYI output (snipped)

<snip>
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.207890] fs/smb2/smb2pdu.c: negotiated smb2 dialect
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.207892] fs/smb2/sess.c: Security Mode: 0x1 Capabilities: 0x1 TimeAdjust: 0
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.207894] fs/smb2/smb2pdu.c: Session Setup
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.207896] fs/smb2/smb2pdu.c: sec_flags 0x7
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.207899] fs/smb2/transport.c: Credits: 20
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.207900] fs/smb2/transport.c: For smb_command 1
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.207902] fs/smb2/transport.c: Sending smb: total_len 124
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultiplex.c: rfc1002 length 0x10e
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultiplex.c: num_bytes to read from socket 64
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultiplex.c: read from socket returns 0 with total_read 64
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultiplex.c: before find owner for 119
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultiplex.c: After find owner for 119
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209018] fs/smb2/demultiplex.c: num_bytes to read from socket 202
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209018] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/maperror.c: Mapping SMB2 status code -1073741802 to POSIX err -5
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/misc.c: Null buffer passed to smb2_small_buf_release
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/smb2pdu.c: sess setup returned buftype 1 with rc -5 status 0xc0000016
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/smb2pdu.c: sec_flags 0x7
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/transport.c: Credits: 39
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/transport.c: For smb_command 1
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.209282] fs/smb2/transport.c: Sending smb: total_len 196
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211763] fs/smb2/demultiplex.c: rfc1002 length 0x4c
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211779] fs/smb2/demultiplex.c: num_bytes to read from socket 64
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211794] fs/smb2/demultiplex.c: read from socket returns 0 with total_read 64
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211807] fs/smb2/demultiplex.c: before find owner for 120
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211820] fs/smb2/demultiplex.c: After find owner for 120
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211832] fs/smb2/demultiplex.c: num_bytes to read from socket 8
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211882] fs/smb2/misc.c: Null buffer passed to smb2_small_buf_release
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211895] fs/smb2/smb2pdu.c: sess setup returned buftype 1 with rc 0 status 0x0
Oct  8 20:21:34 linux-duw1 kernel: [ 2040.211907] fs/smb2/sess.c: SMB2 Session Established successfully
</snip>


-- 
Suresh Jayaraman
