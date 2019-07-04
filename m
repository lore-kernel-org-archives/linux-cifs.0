Return-Path: <SRS0=KBsq=VB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E57A6C0651F
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 21:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9157921852
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 21:35:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7NEqin1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfGDVfF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Jul 2019 17:35:05 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40163 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfGDVfE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Jul 2019 17:35:04 -0400
Received: by mail-lf1-f66.google.com with SMTP id b17so1406209lff.7
        for <linux-cifs@vger.kernel.org>; Thu, 04 Jul 2019 14:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5vMv2RKI5icttEQ0rSbn9FAmiaNIh1uFO8Xs31jykvA=;
        b=Z7NEqin1Ok+dZEU5rRBsaxdi+hzFsT5H9FJAVmf55AcZOkCJAETGwEeO8kh0a9MdNa
         0psBaPZN7hfVM2mSkEF5PW9iP5peLXDddFjBq/upzWb5mM1Z0xDxKlFh1CxkwCsREZzH
         +P169C1feozjom7QW0JJ8B37xU9f6f1ARMrGXXIDqVZ5V/4IRVLKD4qa9/b2BN2q4xR7
         UmZbFJ7VoM5k1z+NAMP3c+MIDm5P1sChJscWt60jHfP29KQM/3Yor+PeIdjdI+6CHDt5
         TKAneVWpkqoo9xLboDGXZZFFvqqtsaZcrrKI8EINcxmj9LHwbnx49Nm4yNb1Kuy/pmUQ
         PZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5vMv2RKI5icttEQ0rSbn9FAmiaNIh1uFO8Xs31jykvA=;
        b=mL/OlxELwCetRiEoKkRmNfTbY/Ez1M6kmJCxQ9thD4Z+6f1LqDlvLcW9A8Mty7Bkir
         Fwv6AdMcDvFDJ0XO6Lvpz6FwdGAhjaDHMrjDqrWo7pFketnSYjJFt2cxCcVQAHPCQTD+
         HdZYV0UIY2+LZkf73ypJJslEmasRKUKKNllPMM/l4wMOBTQcA4yzKhAGkWcKVYa0P/cY
         8xXXg9PHR8qk3PMLR2JglivcJbDBULXoOFZ9YjNxl+RYKy0ICY3TZaIeW9/xIDUZxP3p
         gVjAbTDZNVgnCSXto2yk1dAPCGUCz4ek9D3R33s4MATKu+m9CHmoNQzEeOVaPT7VzAin
         NxjA==
X-Gm-Message-State: APjAAAUWLC3ZhZCYIYcKwGmAVqI8D5moRfR1EMqIAYbDPuMdRsIyx6yi
        3oxjP8KV+/Y+WEpSg5qRoz3wdtAlDxY3lkMUkQ==
X-Google-Smtp-Source: APXvYqwOjkB5GahH4AoSxnmi8J22n4IkFmWM+tbaeBn81Z5dVnktGrucbwuzOqjOf37CBrhrs24VXZNo6bt0Gz0kIZw=
X-Received: by 2002:ac2:5595:: with SMTP id v21mr284015lfg.54.1562276101318;
 Thu, 04 Jul 2019 14:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com>
 <875zojx70t.fsf@suse.com> <1fc4f6d0-6cdc-69a5-4359-23484d6bdfc9@prodrive-technologies.com>
 <8736jmxcwi.fsf@suse.com> <5d4fd393-9c6c-c407-462e-441cd46bbdd8@prodrive-technologies.com>
In-Reply-To: <5d4fd393-9c6c-c407-462e-441cd46bbdd8@prodrive-technologies.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 4 Jul 2019 14:34:49 -0700
Message-ID: <CAKywueTpgXyFMxveRj6Hm-=vuCC6xh1z0W9bqAFcpCiREe6Vwg@mail.gmail.com>
Subject: Re: Many processes end up in uninterruptible sleep accessing cifs mounts
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Martijn,

Thanks for reporting the problem. Have you tried v5.1.5 kernel and
above? That one has many reconnect fixes. If yes, could you please
provide the kernel stack / panic traces when running new versions of
the kernel?

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 4 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 06:36, Martijn de G=
ouw
<martijn.de.gouw@prodrive-technologies.com>:
>
> Hi,
>
> On 04-07-2019 13:22, Aur=C3=A9lien Aptel wrote:
> > Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
> >>> Are there any kernel oops/panic with stack traces and register dumps =
in
> >>> the log?
> >>>
> >>> You can inspect the kernel stack trace of the hung processes (to see =
where
> >>> they are stuck) by printing the file /proc/<pid>/stack.
> >>
> >> These are the stacks of all processes that are D, most of them being d=
f.
> >> I also attached the cifs Stats output below.
> >
> > Ok thanks. What about Oops or BUG or panic in dmesg logs, did you see
> > any?
>
> I did find the following messages in the dmesg of one of the servers:
>
> [    4.797893] FS-Cache: Duplicate cookie detected
> [    4.797915] FS-Cache: O-cookie c=3D000000001a791554 [p=3D00000000fb6f3=
1ee fl=3D222 nc=3D0 na=3D1]
> [    4.797934] FS-Cache: O-cookie d=3D0000000020a06fab n=3D00000000654600=
e7
> [    4.797949] FS-Cache: O-key=3D[8] '020001bd0a010102'
> [    4.797963] FS-Cache: N-cookie c=3D000000005d0bf4a5 [p=3D00000000fb6f3=
1ee fl=3D2 nc=3D0 na=3D1]
> [    4.797982] FS-Cache: N-cookie d=3D0000000020a06fab n=3D000000004e1e47=
aa
> [    4.797997] FS-Cache: N-key=3D[8] '020001bd0a010102'
> [    4.798643] FS-Cache: Duplicate cookie detected
> [    4.798659] FS-Cache: O-cookie c=3D000000001a791554 [p=3D00000000fb6f3=
1ee fl=3D222 nc=3D0 na=3D1]
> [    4.798679] FS-Cache: O-cookie d=3D0000000020a06fab n=3D00000000654600=
e7
> [    4.798695] FS-Cache: O-key=3D[8] '020001bd0a010102'
> [    4.798714] FS-Cache: N-cookie c=3D00000000cbe44971 [p=3D00000000fb6f3=
1ee fl=3D2 nc=3D0 na=3D1]
> [    4.798733] FS-Cache: N-cookie d=3D0000000020a06fab n=3D00000000ab0e78=
a6
> [    4.798747] FS-Cache: N-key=3D[8] '020001bd0a010102'
> [    4.906667] FS-Cache: Netfs 'nfs' registered for caching
> [12738.729173] CIFS VFS: Send error in SessSetup =3D -126
> [99125.480751] CIFS VFS: Send error in SessSetup =3D -126
> [185517.295175] CIFS VFS: Send error in SessSetup =3D -126
> [250515.749714] kernel tried to execute NX-protected page - exploit attem=
pt? (uid: 0)
> [250515.749740] BUG: unable to handle kernel paging request at ffff8ec52a=
6fe1d0
> [250515.749757] PGD 1b2602067 P4D 1b2602067 PUD 42dbff063 PMD 42a357063 P=
TE 800000042a6fe063
> [250515.749779] Oops: 0011 [#1] PREEMPT SMP PTI
> [250515.749792] CPU: 1 PID: 796 Comm: cifsd Tainted: G            E     4=
.20.17-pd-4.20.y #20190611
> [250515.749812] Hardware name: VMware, Inc. VMware Virtual Platform/440BX=
 Desktop Reference Platform, BIOS 6.00 09/19/2018
> [250515.749844] RIP: 0010:0xffff8ec52a6fe1d0
> [250515.749860] Code: ff ff 00 00 00 00 fd 01 00 00 00 7d 00 00 01 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
<d0> e1 6f 2a c5 8e ff ff d0 e1 6f 2a c5 8e ff ff 80 70 82 2b c5 8e
> [250515.749914] RSP: 0018:ffff9e60c2e2bdc0 EFLAGS: 00010202
> [250515.749927] RAX: ffff8ec52a6fe1d0 RBX: ffff8ec526fce800 RCX: dead0000=
00000200
> [250515.749944] RDX: ffff8ec52d3e6800 RSI: 0000000000000246 RDI: ffff8ec5=
2a6fe198
> [250515.749962] RBP: ffff8ec52d3e6800 R08: 0000000000000002 R09: ffff8ec5=
2a6fe170
> [250515.749979] R10: ffff9e60c2e2bc10 R11: ffff8ec527088000 R12: ffff8ec5=
26fce9c0
> [250515.749997] R13: ffff8ec52d3e6800 R14: ffff9e60c2e2bdd8 R15: ffff8ec5=
2d3e6b80
> [250515.750014] FS:  0000000000000000(0000) GS:ffff8ec52fa80000(0000) knl=
GS:0000000000000000
> [250515.750033] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [250515.750048] CR2: ffff8ec52a6fe1d0 CR3: 000000042a53c005 CR4: 00000000=
003606e0
> [250515.750100] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
> [250515.750102] CIFS VFS: No task to wake, unknown frame received! NumMid=
s 3
> [250515.750119] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
> [250515.750120] Call Trace:
> [250515.750149] 00000000: 424d53fe 00010040 00000000 00000005  .SMB@.....=
......
> [250515.750193]  ? cifs_reconnect+0x337/0x880 [cifs]
> [250515.750201]  ? cifs_handle_standard+0x169/0x190 [cifs]
> [250515.750216] 00000010: 10000009 00000098 00000db2 00000000  ..........=
......
> [250515.750234]  ? cifs_demultiplex_thread+0x9e5/0xbc0 [cifs]
> [250515.750240] 00000020: 0000025c 00000001 640002e9 0000c81d  \.........=
.d....
> [250515.750259]  ? finish_task_switch+0x7d/0x290
> [250515.750271] 00000030: 5a9e63f3 6204a9b0 587058e3 0d45419b  .c.Z...b.X=
pX.AE.
> [250515.750295]  ? cifs_handle_standard+0x190/0x190 [cifs]
> [250515.750728] CIFS VFS: No task to wake, unknown frame received! NumMid=
s 3
> [250515.751200]  ? kthread+0xf8/0x130
> [250515.751639] 00000000: 424d53fe 00010040 00000000 00000010  .SMB@.....=
......
> [250515.752102]  ? kthread_create_worker_on_cpu+0x70/0x70
> [250515.752554] 00000010: 0000000d 00000068 00000db3 00000000  ....h.....=
......
> [250515.752997]  ? ret_from_fork+0x35/0x40
> [250515.753429] 00000020: 0000025c 00000001 640002e9 0000c81d  \.........=
.d....
> [250515.753874] Modules linked in: cpufreq_userspace(E) cpufreq_powersave=
(E) cpufreq_conservative(E) arc4(E) ecb(E) md4(E) nfsv3(E) nfs_acl(E) nfs(E=
) sha512_ssse3(E) sha512_generic(E) lockd(E) cmac(E) grace(E) hmac(E) nls_u=
tf8(E) cifs(E) ccm(E) dns_resolver(E) fscache(E) vmw_vsock_vmci_transport(E=
) vsock(E) sb_edac(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_int=
el(E) aesni_intel(E) vmw_balloon(E) aes_x86_64(E) joydev(E) evdev(E) crypto=
_simd(E) vmwgfx(E) serio_raw(E) cryptd(E) glue_helper(E) ttm(E) sg(E) vmw_v=
mci(E) drm_kms_helper(E) drm(E) button(E) ac(E) auth_rpcgss(E) sunrpc(E) ip=
_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E) mbcach=
e(E) jbd2(E) sr_mod(E) cdrom(E) ata_generic(E) sd_mod(E) ata_piix(E) crc32c=
_intel(E) psmouse(E) libata(E) vmw_pvscsi(E) vmxnet3(E) scsi_mod(E) i2c_pii=
x4(E)
> [250515.754336] 00000030: 49d4fd21 858665a2 fde5288f 01d2d919  !..I.e...(=
......
> [250515.754766] CR2: ffff8ec52a6fe1d0
> [250515.758927] CIFS VFS: No task to wake, unknown frame received! NumMid=
s 3
> [250515.759389] ---[ end trace 92ea62cd080150de ]---
> [250515.759879] 00000000: 424d53fe 00010040 00000000 00030006  .SMB@.....=
......
> [250515.760357] RIP: 0010:0xffff8ec52a6fe1d0
> [250515.761841] Code: ff ff 00 00 00 00 fd 01 00 00 00 7d 00 00 01 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
<d0> e1 6f 2a c5 8e ff ff d0 e1 6f 2a c5 8e ff ff 80 70 82 2b c5 8e
> [250515.763287] RSP: 0018:ffff9e60c2e2bdc0 EFLAGS: 00010202
> [250515.763778] RAX: ffff8ec52a6fe1d0 RBX: ffff8ec526fce800 RCX: dead0000=
00000200
> [250515.764060] 00000010: 0000000d 00000000 00000db4 00000000  ..........=
......
> [250515.764310] RDX: ffff8ec52d3e6800 RSI: 0000000000000246 RDI: ffff8ec5=
2a6fe198
> [250515.764311] RBP: ffff8ec52d3e6800 R08: 0000000000000002 R09: ffff8ec5=
2a6fe170
> [250515.764312] R10: ffff9e60c2e2bc10 R11: ffff8ec527088000 R12: ffff8ec5=
26fce9c0
> [250515.764314] R13: ffff8ec52d3e6800 R14: ffff9e60c2e2bdd8 R15: ffff8ec5=
2d3e6b80
> [250515.765491] 00000020: 0000025c 00000001 640002e9 0000c81d  \.........=
.d....
> [250515.765836] FS:  0000000000000000(0000) GS:ffff8ec52fa80000(0000) knl=
GS:0000000000000000
> [250515.767899] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [250515.768367] CR2: ffff8ec52a6fe1d0 CR3: 000000042a53c005 CR4: 00000000=
003606e0
> [250515.768919] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
> [250515.769419] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
> [250515.769591] 00000030: 879543e1 572c0574 e53861ba 97ccc40b  .C..t.,W.a=
8.....
> [271909.743603] CIFS VFS: Send error in SessSetup =3D -126
> [358301.908585] CIFS VFS: Send error in SessSetup =3D -126
> [444693.566453] CIFS VFS: Send error in SessSetup =3D -126
> [531086.090040] CIFS VFS: Send error in SessSetup =3D -126
> [617477.785390] CIFS VFS: Send error in SessSetup =3D -126
> [703869.556705] CIFS VFS: Send error in SessSetup =3D -126
> [790261.656853] CIFS VFS: Send error in SessSetup =3D -126
> [876653.496928] CIFS VFS: Send error in SessSetup =3D -126
> [963045.816742] CIFS VFS: Send error in SessSetup =3D -126
> [1049437.566219] CIFS VFS: Send error in SessSetup =3D -126
>
>
> And from another server:
> [    4.253091] FS-Cache: Duplicate cookie detected
> [    4.253120] FS-Cache: O-cookie c=3D000000004cc29d26 [p=3D0000000017dbb=
bc0 fl=3D222 nc=3D0 na=3D1]
> [    4.253153] FS-Cache: O-cookie d=3D00000000e8e68765 n=3D0000000012869f=
a7
> [    4.253179] FS-Cache: O-key=3D[8] '020001bd0a010102'
> [    4.253201] FS-Cache: N-cookie c=3D00000000c3bbbddd [p=3D0000000017dbb=
bc0 fl=3D2 nc=3D0 na=3D1]
> [    4.253235] FS-Cache: N-cookie d=3D00000000e8e68765 n=3D00000000335882=
b3
> [    4.253262] FS-Cache: N-key=3D[8] '020001bd0a010102'
> [    4.254107] FS-Cache: Duplicate cookie detected
> [    4.254130] FS-Cache: O-cookie c=3D000000004cc29d26 [p=3D0000000017dbb=
bc0 fl=3D222 nc=3D0 na=3D1]
> [    4.254161] FS-Cache: O-cookie d=3D00000000e8e68765 n=3D0000000012869f=
a7
> [    4.254185] FS-Cache: O-key=3D[8] '020001bd0a010102'
> [    4.254230] FS-Cache: N-cookie c=3D000000000ec2f0bb [p=3D0000000017dbb=
bc0 fl=3D2 nc=3D0 na=3D1]
> [    4.254261] FS-Cache: N-cookie d=3D00000000e8e68765 n=3D00000000247062=
10
> [    4.254285] FS-Cache: N-key=3D[8] '020001bd0a010102'
> [    4.329147] CIFS VFS: BAD_NETWORK_NAME: \\stor02.bk.prodrive.nl\userda=
ta$
> [    4.330107] CIFS VFS: cifs_mount failed w/return code =3D -2
> [65206.127542] CIFS VFS: Send error in SessSetup =3D -126
> [151597.808064] CIFS VFS: Send error in SessSetup =3D -126
> [237989.956447] CIFS VFS: Send error in SessSetup =3D -126
> [324380.937984] CIFS VFS: Send error in SessSetup =3D -126
> [402750.869518] kernel tried to execute NX-protected page - exploit attem=
pt? (uid: 0)
> [402750.869594] BUG: unable to handle kernel paging request at ffff909bf6=
1609d0
> [402750.869650] PGD 1ac02067 P4D 1ac02067 PUD 1385f5063 PMD 136142063 PTE=
 8000000136160063
> [402750.869716] Oops: 0011 [#1] PREEMPT SMP PTI
> [402750.869753] CPU: 0 PID: 797 Comm: cifsd Tainted: G            E     4=
.20.17-pd-4.20.y #20190611
> [402750.869818] Hardware name: VMware, Inc. VMware Virtual Platform/440BX=
 Desktop Reference Platform, BIOS 6.00 09/19/2018
> [402750.869926] CIFS VFS: No task to wake, unknown frame received! NumMid=
s 3
> [402750.869947] RIP: 0010:0xffff909bf61609d0
> [402750.870013] 00000000: 424d53fe 00010040 00000000 00000005  .SMB@.....=
......
> [402750.870198] Code: ff ff 00 00 00 00 4e 01 00 00 00 7d 00 00 03 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
<d0> 09 16 f6 9b 90 ff ff d0 09 16 f6 9b 90 ff ff c0 40 1f f2 9b 90
> [402750.870275] 00000010: 10000009 00000098 000002b5 00000000  ..........=
......
> [402750.870450] RSP: 0000:ffffa18d41adbd28 EFLAGS: 00010202
> [402750.870469] 00000020: 000001cd 00000001 44000cd9 0000c824  ..........=
.D$...
> [402750.870509] RAX: ffff909bf61609d0 RBX: ffff909bf6c3f800 RCX: dead0000=
00000200
> [402750.870511] RDX: ffff909bf74fa980 RSI: 0000000000000246 RDI: ffff909b=
f6160998
> [402750.870530] 00000030: 79955e4a 0dacb8eb 025edebd 4efa7788  J^.y......=
^..w.N
> [402750.870582] RBP: ffff909bf74fa980 R08: 0000000000000000 R09: ffff909b=
f6c3f970
> [402750.870585] R10: ffffa18d406a7cc0 R11: 0000000000000000 R12: ffff909b=
f6c3f9c0
> [402750.870605] CIFS VFS: No task to wake, unknown frame received! NumMid=
s 3
> [402750.870656] R13: ffff909bf74fa980 R14: ffffa18d41adbd40 R15: ffff909b=
f74fa100
> [402750.870660] FS:  0000000000000000(0000) GS:ffff909bf9c00000(0000) knl=
GS:0000000000000000
> [402750.870677] 00000000: 424d53fe 00010040 00000000 00000010  .SMB@.....=
......
> [402750.870731] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [402750.870733] CR2: ffff909bf61609d0 CR3: 0000000136e56004 CR4: 00000000=
003606f0
> [402750.870752] 00000010: 0000000d 00000068 000002b6 00000000  ....h.....=
......
> [402750.870888] 00000020: 000001cd 00000001 44000cd9 0000c824  ..........=
.D$...
> [402750.870894] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
> [402750.870907] 00000030: f063942a cae9f6e1 d5327c26 91fc6f33  *.c.....&|=
2.3o..
> [402750.872321] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
> [402750.872324] Call Trace:
> [402750.872381]  ? cifs_reconnect+0x337/0x880 [cifs]
> [402750.872410]  ? cifs_readv_from_socket+0x211/0x260 [cifs]
> [402750.875687]  ? cifs_read_from_socket+0x4a/0x70 [cifs]
> [402750.876128]  ? _raw_spin_unlock_irqrestore+0x20/0x40
> [402750.876555]  ? try_to_wake_up+0x54/0x540
> [402750.876991]  ? cifs_small_buf_get+0x16/0x20 [cifs]
> [402750.877426]  ? cifs_demultiplex_thread+0xdd/0xbc0 [cifs]
> [402750.877834]  ? finish_task_switch+0x7d/0x290
> [402750.878252]  ? cifs_handle_standard+0x190/0x190 [cifs]
> [402750.878651]  ? kthread+0xf8/0x130
> [402750.879034]  ? kthread_create_worker_on_cpu+0x70/0x70
> [402750.879412]  ? ret_from_fork+0x35/0x40
> [402750.879786] Modules linked in: cpufreq_conservative(E) cpufreq_powers=
ave(E) cpufreq_userspace(E) arc4(E) ecb(E) md4(E) sha512_ssse3(E) sha512_ge=
neric(E) cmac(E) hmac(E) nfsv3(E) nfs_acl(E) nls_utf8(E) nfs(E) lockd(E) gr=
ace(E) cifs(E) ccm(E) dns_resolver(E) fscache(E) sb_edac(E) crct10dif_pclmu=
l(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) aes_x86_64(E) cr=
ypto_simd(E) joydev(E) cryptd(E) vmw_balloon(E) evdev(E) glue_helper(E) ser=
io_raw(E) vmwgfx(E) ttm(E) drm_kms_helper(E) sg(E) drm(E) vmw_vsock_vmci_tr=
ansport(E) vsock(E) vmw_vmci(E) ac(E) button(E) auth_rpcgss(E) sunrpc(E) ip=
_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E) mbcach=
e(E) jbd2(E) sr_mod(E) cdrom(E) sd_mod(E) ata_generic(E) ata_piix(E) vmw_pv=
scsi(E) libata(E) crc32c_intel(E) psmouse(E) vmxnet3(E) i2c_piix4(E) scsi_m=
od(E)
> [402750.883384] CR2: ffff909bf61609d0
> [402750.883783] ---[ end trace 08b06875e82513eb ]---
> [402750.884200] RIP: 0010:0xffff909bf61609d0
> [402750.884598] Code: ff ff 00 00 00 00 52 01 00 00 00 7d 00 00 02 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
<d0> 09 16 f6 9b 90 ff ff d0 09 16 f6 9b 90 ff ff c0 40 1f f2 9b 90
> [402750.885822] RSP: 0000:ffffa18d41adbd28 EFLAGS: 00010202
> [402750.886229] RAX: ffff909bf61609d0 RBX: ffff909bf6c3f800 RCX: dead0000=
00000200
> [402750.886651] RDX: ffff909bf74fa980 RSI: 0000000000000246 RDI: ffff909b=
f6160998
> [402750.887065] RBP: ffff909bf74fa980 R08: 0000000000000000 R09: ffff909b=
f6c3f970
> [402750.887478] R10: ffffa18d406a7cc0 R11: 0000000000000000 R12: ffff909b=
f6c3f9c0
> [402750.887883] R13: ffff909bf74fa980 R14: ffffa18d41adbd40 R15: ffff909b=
f74fa100
> [402750.888285] FS:  0000000000000000(0000) GS:ffff909bf9c00000(0000) knl=
GS:0000000000000000
> [402750.888692] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [402750.889093] CR2: ffff909bf61609d0 CR3: 0000000136e56004 CR4: 00000000=
003606f0
> [402750.889559] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
> [402750.889972] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
> [410772.901264] CIFS VFS: Send error in SessSetup =3D -126
> [497165.194662] CIFS VFS: Send error in SessSetup =3D -126
> [583557.492304] CIFS VFS: Send error in SessSetup =3D -126
> [669948.937016] CIFS VFS: Send error in SessSetup =3D -126
> [756341.390112] CIFS VFS: Send error in SessSetup =3D -126
> [842733.557002] CIFS VFS: Send error in SessSetup =3D -126
> [929125.303428] CIFS VFS: Send error in SessSetup =3D -126
> [1015516.629380] CIFS VFS: Send error in SessSetup =3D -126
> [1101908.464697] CIFS VFS: Send error in SessSetup =3D -126
> [1188300.531261] CIFS VFS: Send error in SessSetup =3D -126
> [1274692.583049] CIFS VFS: Send error in SessSetup =3D -126
>
>
> >
> > The individual stack dumps are pretty useful. Here is my theory:
> >
> >> pid: 9505
> >> syscall: 4 0x56550a2ec470 0x7ffede42e9a0 0x7ffede42e9a0 0x83a 0x3 0x20
> >> 0x7ffede42e8f8 0x7f7f8928f295
> >> [<0>] open_shroot+0x43/0x200 [cifs]
> >> [<0>] smb2_query_path_info+0x93/0x220 [cifs]
> >
> > Almost all of the processes have the same stack trace. They are stuck a=
t
> > open_shroot()+0x43 which is probably
> >
> >      mutex_lock(&tcon->crfid.fid_mutex);
> >
> > Then there are only 2 other processes stuck somewhere in the same code =
path
> > (open_shroot) but deeper, meaning they have the locks that the other
> > processes are waiting for:
> >
> >
> >> pid: 22858
> >> syscall: 4 0x564b46285d10 0x7ffcea3f9a80 0x7ffcea3f9a80 0x83a 0x3 0x20
> >> 0x7ffcea3f99d8 0x7f6cc78c7295
> >> [<0>] cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
> >> [<0>] smb2_reconnect+0x2d6/0x4b0 [cifs]
> >> [<0>] smb2_plain_req_init+0x30/0x240 [cifs]
> >> [<0>] SMB2_open_init+0x6d/0x7c0 [cifs]
> >> [<0>] SMB2_open+0x150/0x520 [cifs]
> >> [<0>] open_shroot+0x12f/0x200 [cifs]
> >> [<0>] smb2_query_path_info+0x93/0x220 [cifs]
> >> [<0>] cifs_get_inode_info+0x580/0xb10 [cifs]
> >> [<0>] cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
> >> [<0>] cifs_getattr+0x5b/0x1b0 [cifs]
> >> [<0>] vfs_statx+0x89/0xe0
> >> [<0>] __do_sys_newstat+0x39/0x70
> >> [<0>] do_syscall_64+0x55/0x100
> >> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >> [<0>] 0xffffffffffffffff
> >
> >
> >> pid: 20027
> >> syscall: 4 0x55a3c7d767d0 0x7ffe51432ab0 0x7ffe51432ab0 0x83a
> >> 0x55a3c7d75c40 0x20 0x7ffe51432a08 0x7f5f7c4e7295
> >> [<0>] cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
> >> [<0>] smb2_reconnect+0x2d6/0x4b0 [cifs]
> >> [<0>] smb2_plain_req_init+0x30/0x240 [cifs]
> >> [<0>] SMB2_open_init+0x6d/0x7c0 [cifs]
> >> [<0>] SMB2_open+0x150/0x520 [cifs]
> >> [<0>] open_shroot+0x12f/0x200 [cifs]
> >> [<0>] smb2_query_path_info+0x93/0x220 [cifs]
> >> [<0>] cifs_get_inode_info+0x580/0xb10 [cifs]
> >> [<0>] cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
> >> [<0>] cifs_getattr+0x5b/0x1b0 [cifs]
> >> [<0>] vfs_statx+0x89/0xe0
> >> [<0>] __do_sys_newstat+0x39/0x70
> >> [<0>] do_syscall_64+0x55/0x100
> >> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >> [<0>] 0xffffffffffffffff
> >
> > Due to timeouts maybe the Open request needs
> > to reconnect the server/ses/tcon and to do this it calls
> > cifs_mark_open_files_invalid() and gets stuck somewhere there.
> >
> >          spin_lock(&tcon->open_file_lock);
> >          list_for_each_safe(tmp, tmp1, &tcon->openFileList) {
> >                  open_file =3D list_entry(tmp, struct cifsFileInfo, tli=
st);
> >                  open_file->invalidHandle =3D true;
> >                  open_file->oplock_break_cancelled =3D true;
> >          }
> >          spin_unlock(&tcon->open_file_lock);
> >
> >          mutex_lock(&tcon->crfid.fid_mutex); <=3D=3D=3D most likely her=
e
> >          tcon->crfid.is_valid =3D false;
> >          memset(tcon->crfid.fid, 0, sizeof(struct cifs_fid));
> >          mutex_unlock(&tcon->crfid.fid_mutex);
> >
> > I think these processes are trying to lock the same lock twice: one in
> > open_shroot() and since Open ends up having to reconnect, once again in
> > mark_open_files_invalid(). I think it's the same lock because I don't
> > see why the tcon pointers would be different in those 2 spots. Kernel
> > mutexes are not reentrant so this is a deadlock.
>
> Is there anything we can do about this? Is this maybe already fixed in ne=
wer kernels?
>
> Regards, Martijn
>
> >
> > Cheers,
> >
>
> --
> Martijn de Gouw
> Designer
> Prodrive Technologies
> Mobile: +31 63 17 76 161
> Phone:  +31 40 26 76 200
