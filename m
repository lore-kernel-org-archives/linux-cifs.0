Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CB622C6DC
	for <linux-cifs@vger.kernel.org>; Fri,  6 Dec 2024 23:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527710; cv=none; b=UIOe2ItC9ahzRmb7eImI7OCTHMngJ9DGoM87ivLVtGesd3xhdddV+3TLD+ChCxYfqoaBSCxmOQiUJuaqEaXhYJ0vSU03JDz3jl76TkX7zOTQY+sh4ICq7yAEGQyFt75atUIRzf2BOB26t6CRX97txR1ZASzlhAkpyo1MB9mI0kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527710; c=relaxed/simple;
	bh=3ngUohD/2ekqxDgt+twCjWAXRTl2m2f6ImWR5EloYwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=HQvqeqR+yrdQd5r75hdq/vfcVWBsTpZa7Gs+ge0CGUR9I7ltcmTOPJPfEYLgZJ9RDTLrOcebZUSuyjyejRMjtXNgUqph66lgCFHQZUzQ5Dte/woGRUI5Ig0PnAhhlSGd6+48b7oBtNPgYPpT+q63S8IhS8/E6ASxjDp9y9omgz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=isNFvhMp; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="isNFvhMp"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3000b64fbe9so26509211fa.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Dec 2024 15:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733527704; x=1734132504; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JFnZIhQvQ5EVDfTXwUy0briCmJAeA31/575tzhBbFs8=;
        b=isNFvhMpPBAnTFX788qX4+M6uUXVkGR/p+oAxF7l6qxh+tbCwFv5WoPpW1eYb3AhA+
         xp0NnnHkn0Kpmi5luWuOFmrD//3E4de2Z59q7vYiQZdS+B2i6R1458IS0AGgKMoe+tmY
         nso14KW0G4fsnvi9aTZ0hY4PVyWUgWDZbxQCf+hyjx3HtjAig3wl9a/T9Rea0XftX1ko
         OTbj9e9McvMqf+RZhjKMF1BBSTFrybcUKzSbfyAbzNUzHsiVPKUDk7HHf7tVMmvYFFac
         kMQhb5eFx0bosv+gubSngO+eoIpcxyPDrMCPVYX6MTRrcqC5ih6dEXcXBTNLnjrRu/gD
         KS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733527704; x=1734132504;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JFnZIhQvQ5EVDfTXwUy0briCmJAeA31/575tzhBbFs8=;
        b=PuAROlsukraaSZtCUlfyByv5TF3vQ0FBFPkQ6Ywx6JsOc9M7uDf4YNb3TCzNdx2kiW
         D2r1aTPx2Yn0AnGCVcgqQiNB17TSgtFcyu7cbt2FvCFtj5QRmWD6e8CnQS+Z97rjrcEh
         WzIGBg6QrUr5n+I0AIbuDVPz18jpmRkZQDg6lfS+s0RP7/eqagL8NgthDvSklvFMXNeq
         fM9naOcU1bFJ1t5mjNgdT84X/8CrytWmm0l0sJZ70Rje5EG36Gr/M2sKHgt7DK9jix4V
         DNgpKAJ7E3AlCTjK3E/GCXxlJqjomhnyDgY8fzGz/46Z7W1FgqY4BP6JE4xSxb9YO6IA
         rq3A==
X-Forwarded-Encrypted: i=1; AJvYcCXZISOF5AQmaH8zwlUR6E28MsQLPJd5d8Z2m6BYN7PRUmrn0Hu6xvrdzr24//0uE5dZzD/fE8MkGajy@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0JK9r9yBL5c1Km1kzt9ZBEshtAH3LF3pfDsNv1svQ9CbJGOo9
	8ZWGzfDDO21Jv0EPimVYDMQHMT0w2H3u4PJtAjHAmqnuiKL6Js81IjuP7FQHxPPCm4MVz3NOt0g
	UZ0i+po4lDYxKLsCJgECnQ8iDuG8=
X-Gm-Gg: ASbGncu4t0N61RNl3LSqj/0xVvDNQ33RKMhdRoBeGE3qgv2vKUw4TW6ivvHdMa1gNr0
	Rv7YikbQI8z9GfgORpT27U9WV48Z1E3Y0FfgBkLZU770RfSO29u1iRth8jJdleTURXQ==
X-Google-Smtp-Source: AGHT+IF6JlFKasURsNf1W8NQHPMAPTMBr8uHZbrI/CDZ/m+mvExe/Id7LYfLhwttabuljRw/EiXfKexzBE4M5FGLQL8=
X-Received: by 2002:a05:6512:ea4:b0:53e:3a73:d179 with SMTP id
 2adb3069b0e04-53e3a73d1d5mr508454e87.31.1733527703954; Fri, 06 Dec 2024
 15:28:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118215028.1066662-1-paul@darkrain42.org> <20241118215028.1066662-5-paul@darkrain42.org>
 <2a818d91e9f3c392b2739a4c2a018085@manguebit.com> <Z0FL4kIUiCMFDVfe@vaarsuvius.home.arpa>
 <Z0Y_o2nH16BynCO5@haley.home.arpa> <CAH2r5ms8TmNZ+7DCY8RzUoL+v4Yhnu7BVh--H+PoYrdFDji5+g@mail.gmail.com>
 <CAH2r5mstxfPJE+KSRkjmCvQ_YvMdfNHHafkzbxrxan49WHPamA@mail.gmail.com>
 <CAH2r5mt8CRRc0nJ_t+wxSaC860cPwEufgfp2Qa1j233Dj=CHkQ@mail.gmail.com> <CAH2r5msXKWK7_Q1Jizb_XTe4GLOU=_yv_rjLVVzLBWHbauQTsg@mail.gmail.com>
In-Reply-To: <CAH2r5msXKWK7_Q1Jizb_XTe4GLOU=_yv_rjLVVzLBWHbauQTsg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 6 Dec 2024 17:28:11 -0600
Message-ID: <CAH2r5msnx_t=7w27Ssaxtiun7T7kA5xMvbNyQnqNRvMMxQYfNA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] smb: During unmount, ensure all cached dir
 instances drop their dentry
To: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000000c5850628a25fe0"

--00000000000000c5850628a25fe0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I see the attached umount check warning to current Samba (presumably
due to enabling directory leases) but it is rare - I saw once in test
generic/337 once in generic/339


On Thu, Nov 28, 2024 at 8:16=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> The unmount crash also happens with mainline so not related to patches
> in for-next
>
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
6/builds/128/steps/94/logs/stdio
>
> On Wed, Nov 27, 2024 at 11:00=E2=80=AFPM Steve French <smfrench@gmail.com=
> wrote:
> >
> > And also see it without patch "smb: During unmount, ensure all cached
> > dir instances drop their dentry"
> >
> > On Wed, Nov 27, 2024 at 7:10=E2=80=AFPM Steve French <smfrench@gmail.co=
m> wrote:
> > >
> > > I see this error at the end of generic/241 (in dmesg) even without th=
e
> > > more recent dir lease patch:
> > >
> > > "smb: Initialize cfid->tcon before performing network ops"
> > >
> > > so it is likely unrelated (earlier bug)
> > >
> > >
> > >
> > > Nov 27 18:07:46 fedora29 kernel: Call Trace:
> > > Nov 27 18:07:46 fedora29 kernel: <TASK>
> > > Nov 27 18:07:46 fedora29 kernel: ? __warn+0xa9/0x220
> > > Nov 27 18:07:46 fedora29 kernel: ? umount_check+0xc3/0xf0
> > > Nov 27 18:07:46 fedora29 kernel: ? report_bug+0x1d4/0x1e0
> > > Nov 27 18:07:46 fedora29 kernel: ? handle_bug+0x5b/0xa0
> > > Nov 27 18:07:46 fedora29 kernel: ? exc_invalid_op+0x18/0x50
> > > Nov 27 18:07:46 fedora29 kernel: ? asm_exc_invalid_op+0x1a/0x20
> > > Nov 27 18:07:46 fedora29 kernel: ? irq_work_claim+0x1e/0x40
> > > Nov 27 18:07:46 fedora29 kernel: ? umount_check+0xc3/0xf0
> > > Nov 27 18:07:46 fedora29 kernel: ? __pfx_umount_check+0x10/0x10
> > > Nov 27 18:07:46 fedora29 kernel: d_walk+0xf3/0x4e0
> > > Nov 27 18:07:46 fedora29 kernel: ? d_walk+0x4b/0x4e0
> > > Nov 27 18:07:46 fedora29 kernel: shrink_dcache_for_umount+0x6d/0x220
> > > Nov 27 18:07:46 fedora29 kernel: generic_shutdown_super+0x4a/0x1c0
> > > Nov 27 18:07:46 fedora29 kernel: kill_anon_super+0x22/0x40
> > > Nov 27 18:07:46 fedora29 kernel: cifs_kill_sb+0x78/0x90 [cifs]
> > >
> > > On Wed, Nov 27, 2024 at 10:38=E2=80=AFAM Steve French <smfrench@gmail=
.com> wrote:
> > > >
> > > > I did see the generic/241 failure again with current for-next
> > > > (unrelated to this patch though).  Will try to repro it again - but
> > > > any ideas how to narrow it down or fix it would be helpful.
> > > >
> > > > SECTION -- smb3
> > > > FSTYP -- cifs
> > > > PLATFORM -- Linux/x86_64 fedora29 6.12.0 #1 SMP PREEMPT_DYNAMIC Wed
> > > > Nov 27 01:02:07 UTC 2024
> > > > MKFS_OPTIONS -- //win16.vm.test/Scratch
> > > > generic/241 73s
> > > > Ran: generic/241
> > > > Passed all 1 tests
> > > > SECTION -- smb3
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > > > Ran: generic/241
> > > > Passed all 1 tests
> > > > Number of reconnects: 0
> > > > Test completed smb3 generic/241 at Wed Nov 27 06:38:47 AM UTC 2024
> > > > dmesg output during the test:
> > > > [Wed Nov 27 00:37:32 2024] CIFS: Attempting to mount //win16.vm.tes=
t/Share
> > > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: generate_smb3signingkey: dump=
ing
> > > > generated AES session keys
> > > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: Session Id 45 00 00 08 00 c8 =
00 00
> > > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: Cipher type 2
> > > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: Session Key 00 bf ed c7 f1 95=
 0e
> > > > 29 06 e8 82 87 b5 c8 72 06
> > > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: Signing Key a4 0f 15 64 d2 69=
 02
> > > > 2f 4e 78 60 7a fe 3e 31 4e
> > > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: ServerIn Key a6 fd 04 f6 04 e=
a
> > > > 0e 6e 60 c0 1b b1 ee 63 38 e9
> > > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: ServerOut Key a6 e3 e3 22 8c =
c2
> > > > b0 6e b1 9d 40 ea d0 89 6d d8
> > > > [Wed Nov 27 00:37:32 2024] CIFS: Attempting to mount //win16.vm.tes=
t/Scratch
> > > > [Wed Nov 27 00:37:32 2024] CIFS: Attempting to mount //win16.vm.tes=
t/Scratch
> > > > [Wed Nov 27 00:37:32 2024] run fstests generic/241 at 2024-11-27 00=
:37:33
> > > > [Wed Nov 27 00:38:46 2024] ------------[ cut here ]------------
> > > > [Wed Nov 27 00:38:46 2024] BUG: Dentry
> > > > 00000000318d67d4{i=3D11000000033f68,n=3D~dmtmp} still in use (1) [u=
nmount
> > > > of cifs cifs]
> > > > [Wed Nov 27 00:38:46 2024] WARNING: CPU: 2 PID: 316177 at
> > > > fs/dcache.c:1546 umount_check+0xc3/0xf0
> > > > [Wed Nov 27 00:38:46 2024] Modules linked in: cifs ccm cmac nls_utf=
8
> > > > cifs_arc4 nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4
> > > > dns_resolver nfs lockd grace netfs nf_conntrack_netbios_ns
> > > > nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_f=
ib
> > > > nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> > > > nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat
> > > > ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
> > > > nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_r=
aw
> > > > iptable_security ip_set ebtable_filter ebtables ip6table_filter
> > > > ip6_tables iptable_filter ip_tables sunrpc kvm_intel kvm virtio_net
> > > > net_failover failover virtio_balloon loop fuse dm_multipath nfnetli=
nk
> > > > zram xfs bochs drm_client_lib drm_shmem_helper drm_kms_helper
> > > > crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel drm
> > > > sha512_ssse3 sha256_ssse3 sha1_ssse3 floppy virtio_blk qemu_fw_cfg
> > > > virtio_console [last unloaded: cifs]
> > > > [Wed Nov 27 00:38:46 2024] CPU: 2 UID: 0 PID: 316177 Comm: umount N=
ot
> > > > tainted 6.12.0 #1
> > > > [Wed Nov 27 00:38:46 2024] Hardware name: Red Hat KVM, BIOS
> > > > 1.16.3-2.el9 04/01/2014
> > > > [Wed Nov 27 00:38:46 2024] RIP: 0010:umount_check+0xc3/0xf0
> > > > [Wed Nov 27 00:38:46 2024] Code: db 74 0d 48 8d 7b 40 e8 db df f5 f=
f
> > > > 48 8b 53 40 41 55 4d 89 f1 45 89 e0 48 89 e9 48 89 ee 48 c7 c7 80 9=
9
> > > > ba ad e8 2d 27 a2 ff <0f> 0b 58 31 c0 5b 5d 41 5c 41 5d 41 5e c3 cc=
 cc
> > > > cc cc 41 83 fc 01
> > > > [Wed Nov 27 00:38:46 2024] RSP: 0018:ff1100012197fd20 EFLAGS: 00010=
282
> > > > [Wed Nov 27 00:38:46 2024] RAX: dffffc0000000000 RBX: ff1100010c574=
ce0
> > > > RCX: 0000000000000027
> > > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000027 RSI: 0000000000000=
004
> > > > RDI: ff110004cb131a48
> > > > [Wed Nov 27 00:38:46 2024] RBP: ff1100012c76bd60 R08: ffffffffac3fd=
2fe
> > > > R09: ffe21c0099626349
> > > > [Wed Nov 27 00:38:46 2024] R10: ff110004cb131a4b R11: 0000000000000=
001
> > > > R12: 0000000000000001
> > > > [Wed Nov 27 00:38:46 2024] R13: ff110001238b6668 R14: ffffffffc1d6e=
6c0
> > > > R15: ff1100012c76be18
> > > > [Wed Nov 27 00:38:46 2024] FS: 00007fddc1dcc800(0000)
> > > > GS:ff110004cb100000(0000) knlGS:0000000000000000
> > > > [Wed Nov 27 00:38:46 2024] CS: 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
> > > > [Wed Nov 27 00:38:46 2024] CR2: 00007fc6440095d0 CR3: 0000000142146=
005
> > > > CR4: 0000000000373ef0
> > > > [Wed Nov 27 00:38:46 2024] DR0: 0000000000000000 DR1: 0000000000000=
000
> > > > DR2: 0000000000000000
> > > > [Wed Nov 27 00:38:46 2024] DR3: 0000000000000000 DR6: 00000000fffe0=
ff0
> > > > DR7: 0000000000000400
> > > > [Wed Nov 27 00:38:46 2024] Call Trace:
> > > > [Wed Nov 27 00:38:46 2024] <TASK>
> > > > [Wed Nov 27 00:38:46 2024] ? __warn+0xa9/0x220
> > > > [Wed Nov 27 00:38:46 2024] ? umount_check+0xc3/0xf0
> > > > [Wed Nov 27 00:38:46 2024] ? report_bug+0x1d4/0x1e0
> > > > [Wed Nov 27 00:38:46 2024] ? handle_bug+0x5b/0xa0
> > > > [Wed Nov 27 00:38:46 2024] ? exc_invalid_op+0x18/0x50
> > > > [Wed Nov 27 00:38:46 2024] ? asm_exc_invalid_op+0x1a/0x20
> > > > [Wed Nov 27 00:38:46 2024] ? irq_work_claim+0x1e/0x40
> > > > [Wed Nov 27 00:38:46 2024] ? umount_check+0xc3/0xf0
> > > > [Wed Nov 27 00:38:46 2024] ? __pfx_umount_check+0x10/0x10
> > > > [Wed Nov 27 00:38:46 2024] d_walk+0xf3/0x4e0
> > > > [Wed Nov 27 00:38:46 2024] ? d_walk+0x4b/0x4e0
> > > > [Wed Nov 27 00:38:46 2024] shrink_dcache_for_umount+0x6d/0x220
> > > > [Wed Nov 27 00:38:46 2024] generic_shutdown_super+0x4a/0x1c0
> > > > [Wed Nov 27 00:38:46 2024] kill_anon_super+0x22/0x40
> > > > [Wed Nov 27 00:38:46 2024] cifs_kill_sb+0x78/0x90 [cifs]
> > > > [Wed Nov 27 00:38:46 2024] deactivate_locked_super+0x69/0xf0
> > > > [Wed Nov 27 00:38:46 2024] cleanup_mnt+0x195/0x200
> > > > [Wed Nov 27 00:38:46 2024] task_work_run+0xec/0x150
> > > > [Wed Nov 27 00:38:46 2024] ? __pfx_task_work_run+0x10/0x10
> > > > [Wed Nov 27 00:38:46 2024] ? mark_held_locks+0x24/0x90
> > > > [Wed Nov 27 00:38:46 2024] syscall_exit_to_user_mode+0x269/0x2a0
> > > > [Wed Nov 27 00:38:46 2024] do_syscall_64+0x81/0x180
> > > > [Wed Nov 27 00:38:46 2024] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > > [Wed Nov 27 00:38:46 2024] RIP: 0033:0x7fddc1ff43eb
> > > > [Wed Nov 27 00:38:46 2024] Code: c3 66 2e 0f 1f 84 00 00 00 00 00 0=
f
> > > > 1f 40 00 f3 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e f=
a
> > > > b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b=
 15
> > > > f9 a9 0c 00 f7 d8
> > > > [Wed Nov 27 00:38:46 2024] RSP: 002b:00007ffe64be88d8 EFLAGS: 00000=
246
> > > > ORIG_RAX: 00000000000000a6
> > > > [Wed Nov 27 00:38:46 2024] RAX: 0000000000000000 RBX: 00005632106d4=
c20
> > > > RCX: 00007fddc1ff43eb
> > > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000000 RSI: 0000000000000=
000
> > > > RDI: 00005632106d9410
> > > > [Wed Nov 27 00:38:46 2024] RBP: 00007ffe64be89b0 R08: 00005632106d4=
010
> > > > R09: 0000000000000007
> > > > [Wed Nov 27 00:38:46 2024] R10: 0000000000000000 R11: 0000000000000=
246
> > > > R12: 00005632106d4d28
> > > > [Wed Nov 27 00:38:46 2024] R13: 0000000000000000 R14: 00005632106d9=
410
> > > > R15: 00005632106d5030
> > > > [Wed Nov 27 00:38:46 2024] </TASK>
> > > > [Wed Nov 27 00:38:46 2024] irq event stamp: 8317
> > > > [Wed Nov 27 00:38:46 2024] hardirqs last enabled at (8323):
> > > > [<ffffffffac230dce>] __up_console_sem+0x5e/0x70
> > > > [Wed Nov 27 00:38:46 2024] hardirqs last disabled at (8328):
> > > > [<ffffffffac230db3>] __up_console_sem+0x43/0x70
> > > > [Wed Nov 27 00:38:46 2024] softirqs last enabled at (6628):
> > > > [<ffffffffac135745>] __irq_exit_rcu+0x135/0x160
> > > > [Wed Nov 27 00:38:46 2024] softirqs last disabled at (6539):
> > > > [<ffffffffac135745>] __irq_exit_rcu+0x135/0x160
> > > > [Wed Nov 27 00:38:46 2024] ---[ end trace 0000000000000000 ]---
> > > > [Wed Nov 27 00:38:46 2024] VFS: Busy inodes after unmount of cifs (=
cifs)
> > > > [Wed Nov 27 00:38:46 2024] ------------[ cut here ]------------
> > > > [Wed Nov 27 00:38:46 2024] kernel BUG at fs/super.c:650!
> > > > [Wed Nov 27 00:38:46 2024] Oops: invalid opcode: 0000 [#1] PREEMPT =
SMP
> > > > KASAN NOPTI
> > > > [Wed Nov 27 00:38:46 2024] CPU: 2 UID: 0 PID: 316177 Comm: umount
> > > > Tainted: G W 6.12.0 #1
> > > > [Wed Nov 27 00:38:46 2024] Tainted: [W]=3DWARN
> > > > [Wed Nov 27 00:38:46 2024] Hardware name: Red Hat KVM, BIOS
> > > > 1.16.3-2.el9 04/01/2014
> > > > [Wed Nov 27 00:38:46 2024] RIP: 0010:generic_shutdown_super+0x1b7/0=
x1c0
> > > > [Wed Nov 27 00:38:46 2024] Code: 7b 28 e8 5c ca f8 ff 48 8b 6b 28 4=
8
> > > > 89 ef e8 50 ca f8 ff 48 8b 55 00 48 8d b3 68 06 00 00 48 c7 c7 e0 3=
8
> > > > ba ad e8 d9 c1 b5 ff <0f> 0b 0f 1f 80 00 00 00 00 90 90 90 90 90 90=
 90
> > > > 90 90 90 90 90 90
> > > > [Wed Nov 27 00:38:46 2024] RSP: 0018:ff1100012197fdf0 EFLAGS: 00010=
282
> > > > [Wed Nov 27 00:38:46 2024] RAX: 000000000000002d RBX: ff110001238b6=
000
> > > > RCX: 0000000000000027
> > > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000027 RSI: 0000000000000=
004
> > > > RDI: ff110004cb131a48
> > > > [Wed Nov 27 00:38:46 2024] RBP: ffffffffc1c6ac00 R08: ffffffffac3fd=
2fe
> > > > R09: ffe21c0099626349
> > > > [Wed Nov 27 00:38:46 2024] R10: ff110004cb131a4b R11: 0000000000000=
001
> > > > R12: ff110001238b69c0
> > > > [Wed Nov 27 00:38:46 2024] R13: ff110001238b6780 R14: 1fe220002432f=
fd4
> > > > R15: 0000000000000000
> > > > [Wed Nov 27 00:38:46 2024] FS: 00007fddc1dcc800(0000)
> > > > GS:ff110004cb100000(0000) knlGS:0000000000000000
> > > > [Wed Nov 27 00:38:46 2024] CS: 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
> > > > [Wed Nov 27 00:38:46 2024] CR2: 00007fc6440095d0 CR3: 0000000142146=
005
> > > > CR4: 0000000000373ef0
> > > > [Wed Nov 27 00:38:46 2024] DR0: 0000000000000000 DR1: 0000000000000=
000
> > > > DR2: 0000000000000000
> > > > [Wed Nov 27 00:38:46 2024] DR3: 0000000000000000 DR6: 00000000fffe0=
ff0
> > > > DR7: 0000000000000400
> > > > [Wed Nov 27 00:38:46 2024] Call Trace:
> > > > [Wed Nov 27 00:38:46 2024] <TASK>
> > > > [Wed Nov 27 00:38:46 2024] ? die+0x37/0x90
> > > > [Wed Nov 27 00:38:46 2024] ? do_trap+0x133/0x230
> > > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > > [Wed Nov 27 00:38:46 2024] ? do_error_trap+0x94/0x130
> > > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > > [Wed Nov 27 00:38:46 2024] ? handle_invalid_op+0x2c/0x40
> > > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > > [Wed Nov 27 00:38:46 2024] ? exc_invalid_op+0x2f/0x50
> > > > [Wed Nov 27 00:38:46 2024] ? asm_exc_invalid_op+0x1a/0x20
> > > > [Wed Nov 27 00:38:46 2024] ? irq_work_claim+0x1e/0x40
> > > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > > [Wed Nov 27 00:38:46 2024] kill_anon_super+0x22/0x40
> > > > [Wed Nov 27 00:38:46 2024] cifs_kill_sb+0x78/0x90 [cifs]
> > > > [Wed Nov 27 00:38:46 2024] deactivate_locked_super+0x69/0xf0
> > > > [Wed Nov 27 00:38:46 2024] cleanup_mnt+0x195/0x200
> > > > [Wed Nov 27 00:38:46 2024] task_work_run+0xec/0x150
> > > > [Wed Nov 27 00:38:46 2024] ? __pfx_task_work_run+0x10/0x10
> > > > [Wed Nov 27 00:38:46 2024] ? mark_held_locks+0x24/0x90
> > > > [Wed Nov 27 00:38:46 2024] syscall_exit_to_user_mode+0x269/0x2a0
> > > > [Wed Nov 27 00:38:46 2024] do_syscall_64+0x81/0x180
> > > > [Wed Nov 27 00:38:46 2024] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > > [Wed Nov 27 00:38:46 2024] RIP: 0033:0x7fddc1ff43eb
> > > > [Wed Nov 27 00:38:46 2024] Code: c3 66 2e 0f 1f 84 00 00 00 00 00 0=
f
> > > > 1f 40 00 f3 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e f=
a
> > > > b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b=
 15
> > > > f9 a9 0c 00 f7 d8
> > > > [Wed Nov 27 00:38:46 2024] RSP: 002b:00007ffe64be88d8 EFLAGS: 00000=
246
> > > > ORIG_RAX: 00000000000000a6
> > > > [Wed Nov 27 00:38:46 2024] RAX: 0000000000000000 RBX: 00005632106d4=
c20
> > > > RCX: 00007fddc1ff43eb
> > > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000000 RSI: 0000000000000=
000
> > > > RDI: 00005632106d9410
> > > > [Wed Nov 27 00:38:46 2024] RBP: 00007ffe64be89b0 R08: 00005632106d4=
010
> > > > R09: 0000000000000007
> > > > [Wed Nov 27 00:38:46 2024] R10: 0000000000000000 R11: 0000000000000=
246
> > > > R12: 00005632106d4d28
> > > > [Wed Nov 27 00:38:46 2024] R13: 0000000000000000 R14: 00005632106d9=
410
> > > > R15: 00005632106d5030
> > > > [Wed Nov 27 00:38:46 2024] </TASK>
> > > > [Wed Nov 27 00:38:46 2024] Modules linked in: cifs ccm cmac nls_utf=
8
> > > > cifs_arc4 nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4
> > > > dns_resolver nfs lockd grace netfs nf_conntrack_netbios_ns
> > > > nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_f=
ib
> > > > nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> > > > nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat
> > > > ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
> > > > nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_r=
aw
> > > > iptable_security ip_set ebtable_filter ebtables ip6table_filter
> > > > ip6_tables iptable_filter ip_tables sunrpc kvm_intel kvm virtio_net
> > > > net_failover failover virtio_balloon loop fuse dm_multipath nfnetli=
nk
> > > > zram xfs bochs drm_client_lib drm_shmem_helper drm_kms_helper
> > > > crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel drm
> > > > sha512_ssse3 sha256_ssse3 sha1_ssse3 floppy virtio_blk qemu_fw_cfg
> > > > virtio_console [last unloaded: cifs]
> > > > [Wed Nov 27 00:38:46 2024] ---[ end trace 0000000000000000 ]---
> > > > [Wed Nov 27 00:38:46 2024] RIP: 0010:generic_shutdown_super+0x1b7/0=
x1c0
> > > > [Wed Nov 27 00:38:46 2024] Code: 7b 28 e8 5c ca f8 ff 48 8b 6b 28 4=
8
> > > > 89 ef e8 50 ca f8 ff 48 8b 55 00 48 8d b3 68 06 00 00 48 c7 c7 e0 3=
8
> > > > ba ad e8 d9 c1 b5 ff <0f> 0b 0f 1f 80 00 00 00 00 90 90 90 90 90 90=
 90
> > > > 90 90 90 90 90 90
> > > > [Wed Nov 27 00:38:46 2024] RSP: 0018:ff1100012197fdf0 EFLAGS: 00010=
282
> > > > [Wed Nov 27 00:38:46 2024] RAX: 000000000000002d RBX: ff110001238b6=
000
> > > > RCX: 0000000000000027
> > > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000027 RSI: 0000000000000=
004
> > > > RDI: ff110004cb131a48
> > > > [Wed Nov 27 00:38:46 2024] RBP: ffffffffc1c6ac00 R08: ffffffffac3fd=
2fe
> > > > R09: ffe21c0099626349
> > > > [Wed Nov 27 00:38:46 2024] R10: ff110004cb131a4b R11: 0000000000000=
001
> > > > R12: ff110001238b69c0
> > > > [Wed Nov 27 00:38:46 2024] R13: ff110001238b6780 R14: 1fe220002432f=
fd4
> > > > R15: 0000000000000000
> > > > [Wed Nov 27 00:38:46 2024] FS: 00007fddc1dcc800(0000)
> > > > GS:ff110004cb100000(0000) knlGS:0000000000000000
> > > > [Wed Nov 27 00:38:46 2024] CS: 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
> > > > [Wed Nov 27 00:38:46 2024] CR2: 00007fc6440095d0 CR3: 0000000142146=
005
> > > > CR4: 0000000000373ef0
> > > > [Wed Nov 27 00:38:46 2024] DR0: 0000000000000000 DR1: 0000000000000=
000
> > > > DR2: 0000000000000000
> > > > [Wed Nov 27 00:38:46 2024] DR3: 0000000000000000 DR6: 00000000fffe0=
ff0
> > > > DR7: 0000000000000400
> > > >
> > > > On Tue, Nov 26, 2024 at 3:50=E2=80=AFPM Paul Aurich <paul@darkrain4=
2.org> wrote:
> > > > >
> > > > > On 2024-11-22 19:28:34 -0800, Paul Aurich wrote:
> > > > > >On 2024-11-21 23:05:51 -0300, Paulo Alcantara wrote:
> > > > > >>Hi Paul,
> > > > > >>
> > > > > >>Thanks for looking into this!  Really appreciate it.
> > > > > >>
> > > > > >>Paul Aurich <paul@darkrain42.org> writes:
> > > > > >>
> > > > > >>>The unmount process (cifs_kill_sb() calling close_all_cached_d=
irs()) can
> > > > > >>>race with various cached directory operations, which ultimatel=
y results
> > > > > >>>in dentries not being dropped and these kernel BUGs:
> > > > > >>>
> > > > > >>>BUG: Dentry ffff88814f37e358{i=3D1000000000080,n=3D/}  still i=
n use (2) [unmount of cifs cifs]
> > > > > >>>VFS: Busy inodes after unmount of cifs (cifs)
> > > > > >>>------------[ cut here ]------------
> > > > > >>>kernel BUG at fs/super.c:661!
> > > > > >>>
> > > > > >>>This happens when a cfid is in the process of being cleaned up=
 when, and
> > > > > >>>has been removed from the cfids->entries list, including:
> > > > > >>>
> > > > > >>>- Receiving a lease break from the server
> > > > > >>>- Server reconnection triggers invalidate_all_cached_dirs(), w=
hich
> > > > > >>>  removes all the cfids from the list
> > > > > >>>- The laundromat thread decides to expire an old cfid.
> > > > > >>>
> > > > > >>>To solve these problems, dropping the dentry is done in queued=
 work done
> > > > > >>>in a newly-added cfid_put_wq workqueue, and close_all_cached_d=
irs()
> > > > > >>>flushes that workqueue after it drops all the dentries of whic=
h it's
> > > > > >>>aware. This is a global workqueue (rather than scoped to a mou=
nt), but
> > > > > >>>the queued work is minimal.
> > > > > >>
> > > > > >>Why does it need to be a global workqueue?  Can't you make it p=
er tcon?
> > > > > >
> > > > > >The problem with a per-tcon workqueue is I didn't see clean way =
to
> > > > > >deal with multiuser mounts and flushing the workqueue in
> > > > > >close_all_cached_dirs() -- when dealing with each individual tco=
n,
> > > > > >we're still holding tlink_tree_lock, so an arbitrary sleep seems
> > > > > >problematic.
> > > > > >
> > > > > >There could be a per-sb workqueue (stored in cifs_sb or the mast=
er
> > > > > >tcon) but is there a way to get back to the superblock / master =
tcon
> > > > > >with just a tcon (e.g. cached_dir_lease_break, when processing a=
 lease
> > > > > >break)?
> > > > > >
> > > > > >>>The final cleanup work for cleaning up a cfid is performed via=
 work
> > > > > >>>queued in the serverclose_wq workqueue; this is done separate =
from
> > > > > >>>dropping the dentries so that close_all_cached_dirs() doesn't =
block on
> > > > > >>>any server operations.
> > > > > >>>
> > > > > >>>Both of these queued works expect to invoked with a cfid refer=
ence and
> > > > > >>>a tcon reference to avoid those objects from being freed while=
 the work
> > > > > >>>is ongoing.
> > > > > >>
> > > > > >>Why do you need to take a tcon reference?
> > > > > >
> > > > > >In the existing code (and my patch, without the refs), I was see=
ing an
> > > > > >intermittent use-after-free of the tcon or cached_fids struct by
> > > > > >queued work processing a lease break -- the cfid isn't linked fr=
om
> > > > > >cached_fids, but smb2_close_cached_fid invoking SMB2_close can r=
ace
> > > > > >with the unmount and cifs_put_tcon
> > > > > >
> > > > > >Something like:
> > > > > >
> > > > > >    t1                              t2
> > > > > >cached_dir_lease_break
> > > > > >smb2_cached_lease_break
> > > > > >smb2_close_cached_fid
> > > > > >SMB2_close starts
> > > > > >                                    cifs_kill_sb
> > > > > >                                    cifs_umount
> > > > > >                                    cifs_put_link
> > > > > >                                    cifs_put_tcon
> > > > > >SMB2_close continues
> > > > > >
> > > > > >I had a version of the patch that kept the 'in flight lease brea=
ks' on
> > > > > >a second list in cached_fids so that they could be cancelled
> > > > > >synchronously from free_cached_fids(), but I struggled with it (=
I
> > > > > >can't remember exactly, but I think I was struggling to get the =
linked
> > > > > >list membership / removal handling and num_entries handling
> > > > > >consistent).
> > > > > >
> > > > > >>Can't you drop the dentries
> > > > > >>when tearing down tcon in cifs_put_tcon()?  No concurrent mount=
s would
> > > > > >>be able to access or free it.
> > > > > >
> > > > > >The dentries being dropped must occur before kill_anon_super(), =
as
> > > > > >that's where the 'Dentry still in use' check is. All the tcons a=
re put
> > > > > >in cifs_umount(), which occurs after:
> > > > > >
> > > > > >    kill_anon_super(sb);
> > > > > >    cifs_umount(cifs_sb);
> > > > > >
> > > > > >The other thing is that cifs_umount_begin() has this comment, wh=
ich
> > > > > >made me think a tcon can actually be tied to two distinct mount
> > > > > >points:
> > > > > >
> > > > > >        if ((tcon->tc_count > 1) || (tcon->status =3D=3D TID_EXI=
TING)) {
> > > > > >                /* we have other mounts to same share or we have
> > > > > >                   already tried to umount this and woken up
> > > > > >                   all waiting network requests, nothing to do *=
/
> > > > > >
> > > > > >Although, as I'm thinking about it again, I think I've misunders=
tood
> > > > > >(and that comment is wrong?).
> > > > > >
> > > > > >It did cross my mind to pull some of the work out of cifs_umount=
 into
> > > > > >cifs_kill_sb (specifically, I wanted to cancel prune_tlinks earl=
ier)
> > > > > >-- no prune_tlinks would make it more feasible to drop tlink_tre=
e_lock
> > > > > >in close_all_cached_dirs(), at which point a per-tcon workqueue =
is
> > > > > >more practical.
> > > > > >
> > > > > >>After running xfstests I've seen a leaked tcon in
> > > > > >>/proc/fs/cifs/DebugData with no CIFS superblocks, which might b=
e related
> > > > > >>to this.
> > > > > >>
> > > > > >>Could you please check if there is any leaked connection in
> > > > > >>/proc/fs/cifs/DebugData after running your tests?
> > > > > >
> > > > > >After I finish with my tests (I'm not using xfstests, although p=
erhaps
> > > > > >I should be) and unmount the share, DebugData doesn't show any
> > > > > >connections for me.
> > > > >
> > > > > I was able to reproduce this leak.  I believe the attached patch =
addresses it.
> > > > >
> > > > > I'm able to intermittently see a 'Dentry still in use' bug with x=
fstests
> > > > > generic/241 (what Steve saw) (the attached patch doesn't help wit=
h that). I'm
> > > > > still unsure what's going on there.
> > > > >
> > > > > >~Paul
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--00000000000000c5850628a25fe0
Content-Type: application/octet-stream; name="337.dmesg"
Content-Disposition: attachment; filename="337.dmesg"
Content-Transfer-Encoding: base64
Content-ID: <f_m4ddmiks0>
X-Attachment-Id: f_m4ddmiks0

WzI0NTcwLjAzODQ1Ml0gcnVuIGZzdGVzdHMgZ2VuZXJpYy8zMzcgYXQgMjAyNC0xMi0wNiAxNjo0
NTo1MgpbMjQ1NzAuNDU5MTYwXSBDSUZTOiBBdHRlbXB0aW5nIHRvIG1vdW50IC8vbG9jYWxob3N0
L3NjcmF0Y2gKWzI0NTcxLjYyNTYyNl0gQ0lGUzogQXR0ZW1wdGluZyB0byBtb3VudCAvL2xvY2Fs
aG9zdC9zY3JhdGNoClsyNDU3MS42NjU1OTldIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQpbMjQ1NzEuNjY1NjAyXSBCVUc6IERlbnRyeSAwMDAwMDAwMDlhZTQ4M2Fie2k9MTAw
YzkzZTksbj1XT1JEfSAgc3RpbGwgaW4gdXNlICgyKSBbdW5tb3VudCBvZiBjaWZzIGNpZnNdClsy
NDU3MS42NjU2MTBdIFdBUk5JTkc6IENQVTogNCBQSUQ6IDEzNjUwNjkgYXQgZnMvZGNhY2hlLmM6
MTUzNiB1bW91bnRfY2hlY2srMHg2Ny8weDkwClsyNDU3MS42NjU2MTVdIE1vZHVsZXMgbGlua2Vk
IGluOiBjaWZzIHJmY29tbSBzbmRfc2VxX2R1bW15IHNuZF9ocnRpbWVyIHNuZF9zZXFfbWlkaSBz
bmRfc2VxX21pZGlfZXZlbnQgc25kX3Jhd21pZGkgc25kX3NlcSBzbmRfc2VxX2RldmljZSB4dF9j
b25udHJhY2sgbmZ0X2NoYWluX25hdCB4dF9NQVNRVUVSQURFIG5mX25hdCBuZl9jb25udHJhY2tf
bmV0bGluayBuZl9jb25udHJhY2sgbmZfZGVmcmFnX2lwdjYgbmZfZGVmcmFnX2lwdjQgeGZybV91
c2VyIHhmcm1fYWxnbyB4dF9hZGRydHlwZSBuZnRfY29tcGF0IG5mX3RhYmxlcyBicl9uZXRmaWx0
ZXIgYnJpZGdlIHN0cCBsbGMgbmxzX3V0ZjggY2lmc19hcmM0IG5sc191Y3MyX3V0aWxzIGNpZnNf
bWQ0IGNhY2hlZmlsZXMgbmV0ZnMgY2NtIG92ZXJsYXkgcXJ0ciBjbWFjIGFsZ2lmX2hhc2ggYWxn
aWZfc2tjaXBoZXIgYWZfYWxnIGJuZXAgc2NoX2ZxX2NvZGVsIGJpbmZtdF9taXNjIG5sc19pc284
ODU5XzEgaW50ZWxfdW5jb3JlX2ZyZXF1ZW5jeSBpbnRlbF91bmNvcmVfZnJlcXVlbmN5X2NvbW1v
biBpbnRlbF90Y2NfY29vbGluZyB4ODZfcGtnX3RlbXBfdGhlcm1hbCBzbmRfc29mX3BjaV9pbnRl
bF9jbmwgc25kX3NvZl9pbnRlbF9oZGFfZ2VuZXJpYyBzb3VuZHdpcmVfaW50ZWwgaW50ZWxfcG93
ZXJjbGFtcCBzb3VuZHdpcmVfY2FkZW5jZSBjb3JldGVtcCBzbmRfc29mX2ludGVsX2hkYV9jb21t
b24gc25kX3NvY19oZGFjX2hkYSBlbGFuX2kyYyBzbmRfc29mX2ludGVsX2hkYV9tbGluayBrdm1f
aW50ZWwgc25kX3NvZl9pbnRlbF9oZGEgc25kX3NvZl9wY2kgc25kX3NvZl94dGVuc2FfZHNwIHNu
ZF9zb2Yga3ZtIHNuZF9zb2ZfdXRpbHMgZWUxMDA0IGNtZGxpbmVwYXJ0IHNuZF9zb2NfYWNwaV9p
bnRlbF9tYXRjaCBzb3VuZHdpcmVfZ2VuZXJpY19hbGxvY2F0aW9uIHNuZF9zb2NfYWNwaSBjcmN0
MTBkaWZfcGNsbXVsIHBvbHl2YWxfY2xtdWxuaSBtZWlfaGRjcCBzcGlfbm9yIHBvbHl2YWxfZ2Vu
ZXJpYyBzb3VuZHdpcmVfYnVzIGdoYXNoX2NsbXVsbmlfaW50ZWwKWzI0NTcxLjY2NTY2NV0gIHNo
YTI1Nl9zc3NlMyBtdGQgbWVpX3B4cCBpbnRlbF9yYXBsX21zciBzaGExX3Nzc2UzIHNuZF9zb2Nf
YXZzIGFlc25pX2ludGVsIHNuZF9zb2NfaGRhX2NvZGVjIGNyeXB0b19zaW1kIHNuZF9oZGFfZXh0
X2NvcmUgY3J5cHRkIGl3bG12bSByYXBsIHNuZF9oZGFfY29kZWNfcmVhbHRlayBzbmRfc29jX2Nv
cmUgdGhpbmtfbG1pIHNuZF9oZGFfY29kZWNfZ2VuZXJpYyBmaXJtd2FyZV9hdHRyaWJ1dGVzX2Ns
YXNzIGludGVsX2NzdGF0ZSBzbmRfaGRhX2NvZGVjX2hkbWkgc25kX2hkYV9zY29kZWNfY29tcG9u
ZW50IHNuZF9jdGxfbGVkIHNuZF9jb21wcmVzcyBhYzk3X2J1cyBwcm9jZXNzb3JfdGhlcm1hbF9k
ZXZpY2VfcGNpX2xlZ2FjeSBtYWM4MDIxMSBzbmRfcGNtX2RtYWVuZ2luZSBwcm9jZXNzb3JfdGhl
cm1hbF9kZXZpY2UgcHJvY2Vzc29yX3RoZXJtYWxfd3RfaGludCB1dmN2aWRlbyBwcm9jZXNzb3Jf
dGhlcm1hbF9yZmltIHZpZGVvYnVmMl92bWFsbG9jIGxpYmFyYzQgdXZjIHNuZF9oZGFfaW50ZWwg
c25kX2ludGVsX2RzcGNmZyBwcm9jZXNzb3JfdGhlcm1hbF9yYXBsIHZpZGVvYnVmMl9tZW1vcHMg
c25kX2ludGVsX3Nkd19hY3BpIGludGVsX3dtaV90aHVuZGVyYm9sdCB3bWlfYm1vZiBidHVzYiB2
aWRlb2J1ZjJfdjRsMiBpbnRlbF9yYXBsX2NvbW1vbiBpd2x3aWZpIGJ0cnRsIGkyY19pODAxIHNu
ZF9oZGFfY29kZWMgcHJvY2Vzc29yX3RoZXJtYWxfd3RfcmVxIGludGVsX3BtY19jb3JlIHZpZGVv
YnVmMl9jb21tb24gbnZpZGlhZmIgYnRpbnRlbCBpMmNfbXV4IHNwaV9pbnRlbF9wY2kgcHJvY2Vz
c29yX3RoZXJtYWxfcG93ZXJfZmxvb3Igc3BpX2ludGVsIHNuZF9oZGFfY29yZSBpMmNfc21idXMg
c25kX2h3ZGVwIHRoaW5rcGFkX2FjcGkgaW50ZWxfdnNlYyBidGJjbSB2aWRlb2RldiBwcm9jZXNz
b3JfdGhlcm1hbF9tYm94IGludDM0MDNfdGhlcm1hbCBqb3lkZXYgdmdhc3RhdGUgaW5wdXRfbGVk
cyBpbnQzNDAwX3RoZXJtYWwgYnRtdGsgbWVpX21lIHBtdF90ZWxlbWV0cnkKWzI0NTcxLjY2NTcx
M10gIHNuZF9wY20gY2ZnODAyMTEgbWVpIGJsdWV0b290aCBtYyBmYl9kZGMgc25kX3RpbWVyIGlu
dGVsX3BjaF90aGVybWFsIGludGVsX3NvY19kdHNfaW9zZiBudnJhbSBpbnQzNDB4X3RoZXJtYWxf
em9uZSBhY3BpX3BhZCBhY3BpX3RoZXJtYWxfcmVsIHBtdF9jbGFzcyBtYWNfaGlkIHNlcmlvX3Jh
dyBub3V2ZWF1IG14bV93bWkgZHJtX2dwdXZtIGRybV9leGVjIGdwdV9zY2hlZCBkcm1fdHRtX2hl
bHBlciB0dG0gZHJtX2Rpc3BsYXlfaGVscGVyIGNlYyByY19jb3JlIGkyY19hbGdvX2JpdCBuZnNk
IG1zciBwYXJwb3J0X3BjIGF1dGhfcnBjZ3NzIG5mc19hY2wgcHBkZXYgbG9ja2QgZ3JhY2UgbHAg
bnZtZV9mYWJyaWNzIHBhcnBvcnQgbnZtZV9rZXlyaW5nIGVmaV9wc3RvcmUgc3VucnBjIG5mbmV0
bGluayBkbWlfc3lzZnMgaXBfdGFibGVzIHhfdGFibGVzIGF1dG9mczQgeGZzIGJ0cmZzIGJsYWtl
MmJfZ2VuZXJpYyByYWlkMTAgcmFpZDQ1NiBhc3luY19yYWlkNl9yZWNvdiBhc3luY19tZW1jcHkg
YXN5bmNfcHEgYXN5bmNfeG9yIGFzeW5jX3R4IHhvciByYWlkNl9wcSBsaWJjcmMzMmMgcmFpZDEg
cmFpZDAgd2Fjb20gaGlkX21pY3Jvc29mdCBmZl9tZW1sZXNzIGhpZF9nZW5lcmljIHVzYmhpZCBo
aWQgODI1MF9kdyBydHN4X3BjaV9zZG1tYyBudm1lIHVjc2lfYWNwaSBwc21vdXNlIGNyYzMyX3Bj
bG11bCB0eXBlY191Y3NpIGludGVsX2xwc3NfcGNpIG52bWVfY29yZSBlMTAwMGUgaW50ZWxfbHBz
cyBydHN4X3BjaSBudm1lX2F1dGggc25kIHR5cGVjIGlkbWE2NCBzb3VuZGNvcmUgdmlkZW8gc3Bh
cnNlX2tleW1hcCBwbGF0Zm9ybV9wcm9maWxlIHdtaSBwaW5jdHJsX2Nhbm5vbmxha2UgW2xhc3Qg
dW5sb2FkZWQ6IGNpZnMoT0UpXQpbMjQ1NzEuNjY1NzczXSBDUFU6IDQgVUlEOiAwIFBJRDogMTM2
NTA2OSBDb21tOiB1bW91bnQgVGFpbnRlZDogRyAgICBCICAgVyAgT0UgICAgICA2LjEyLjMtMDYx
MjAzLWdlbmVyaWMgIzIwMjQxMjA2MDYzOApbMjQ1NzEuNjY1Nzc3XSBUYWludGVkOiBbQl09QkFE
X1BBR0UsIFtXXT1XQVJOLCBbT109T09UX01PRFVMRSwgW0VdPVVOU0lHTkVEX01PRFVMRQpbMjQ1
NzEuNjY1Nzc4XSBIYXJkd2FyZSBuYW1lOiBMRU5PVk8gMjBNQVMwODUwMC8yME1BUzA4NTAwLCBC
SU9TIE4yQ0VUNzBXICgxLjUzICkgMDMvMTEvMjAyNApbMjQ1NzEuNjY1Nzc5XSBSSVA6IDAwMTA6
dW1vdW50X2NoZWNrKzB4NjcvMHg5MApbMjQ1NzEuNjY1NzgyXSBDb2RlOiAwMyAwMCAwMCA0OCA4
YiA0MCAyOCA0OCA4OSBlNSA0YyA4YiAwOCA0OCA4YiA0NiAzMCA0OCA4NSBjMCA3NCAwNCA0OCA4
YiA1MCA0MCA1MSA0OCBjNyBjNyBhMCBlYiBlYyBiNyA0OCA4OSBmMSBlOCA0OSBlOSBiYiBmZiA8
MGY+IDBiIDU4IDMxIGMwIGM5IDMxIGQyIDMxIGM5IDMxIGY2IDMxIGZmIDQ1IDMxIGMwIDQ1IDMx
IGM5IGMzIGNjClsyNDU3MS42NjU3ODRdIFJTUDogMDAxODpmZmZmYWU3MWNiZDBmYjY4IEVGTEFH
UzogMDAwMTAyNDYKWzI0NTcxLjY2NTc4Nl0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAw
MDAwMDAwMDA1NzVmYSBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWzI0NTcxLjY2NTc4N10gUkRYOiAw
MDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAwMCBSREk6IDAwMDAwMDAwMDAwMDAw
MDAKWzI0NTcxLjY2NTc4OF0gUkJQOiBmZmZmYWU3MWNiZDBmYjcwIFIwODogMDAwMDAwMDAwMDAw
MDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWzI0NTcxLjY2NTc5MF0gUjEwOiAwMDAwMDAwMDAw
MDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY5NzdjMDA0M2Y2MDAKWzI0NTcx
LjY2NTc5MV0gUjEzOiBmZmZmZmZmZmI2NzQ1YmEwIFIxNDogZmZmZjk3N2MwMDQzZjY4MCBSMTU6
IGZmZmY5NzdjNDAxOGQ5YzAKWzI0NTcxLjY2NTc5Ml0gRlM6ICAwMDAwNzM0YTYwMmQzODAwKDAw
MDApIEdTOmZmZmY5NzgzN2JhMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbMjQ1
NzEuNjY1Nzk0XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUw
MDMzClsyNDU3MS42NjU3OTVdIENSMjogMDAwMDdmZmUzZTJmMGNmMCBDUjM6IDAwMDAwMDAxMjAz
NDAwMDEgQ1I0OiAwMDAwMDAwMDAwMzcyNmYwClsyNDU3MS42NjU3OTddIERSMDogMDAwMDAwMDAw
MDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwClsyNDU3
MS42NjU3OThdIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZTBmZjAgRFI3
OiAwMDAwMDAwMDAwMDAwNDAwClsyNDU3MS42NjU4MDBdIENhbGwgVHJhY2U6ClsyNDU3MS42NjU4
MDFdICA8VEFTSz4KWzI0NTcxLjY2NTgwM10gID8gc2hvd190cmFjZV9sb2dfbHZsKzB4MWJlLzB4
MzEwClsyNDU3MS42NjU4MDZdICA/IHNob3dfdHJhY2VfbG9nX2x2bCsweDFiZS8weDMxMApbMjQ1
NzEuNjY1ODA5XSAgPyBkX3dhbGsrMHhjNS8weDJiMApbMjQ1NzEuNjY1ODEyXSAgPyBzaG93X3Jl
Z3MucGFydC4wKzB4MjIvMHgzMApbMjQ1NzEuNjY1ODE0XSAgPyBzaG93X3JlZ3MuY29sZCsweDgv
MHgxMApbMjQ1NzEuNjY1ODE2XSAgPyB1bW91bnRfY2hlY2srMHg2Ny8weDkwClsyNDU3MS42NjU4
MThdICA/IF9fd2Fybi5jb2xkKzB4YWMvMHgxMGMKWzI0NTcxLjY2NTgyMF0gID8gdW1vdW50X2No
ZWNrKzB4NjcvMHg5MApbMjQ1NzEuNjY1ODIzXSAgPyByZXBvcnRfYnVnKzB4MTE0LzB4MTYwClsy
NDU3MS42NjU4MjZdICA/IGhhbmRsZV9idWcrMHg2ZS8weGIwClsyNDU3MS42NjU4MjldICA/IGV4
Y19pbnZhbGlkX29wKzB4MTgvMHg4MApbMjQ1NzEuNjY1ODMxXSAgPyBhc21fZXhjX2ludmFsaWRf
b3ArMHgxYi8weDIwClsyNDU3MS42NjU4MzRdICA/IF9fcGZ4X3Vtb3VudF9jaGVjaysweDEwLzB4
MTAKWzI0NTcxLjY2NTgzN10gID8gdW1vdW50X2NoZWNrKzB4NjcvMHg5MApbMjQ1NzEuNjY1ODQw
XSAgPyB1bW91bnRfY2hlY2srMHg2Ny8weDkwClsyNDU3MS42NjU4NDJdICBkX3dhbGsrMHhjNS8w
eDJiMApbMjQ1NzEuNjY1ODQ1XSAgc2hyaW5rX2RjYWNoZV9mb3JfdW1vdW50KzB4NGMvMHgxMzAK
WzI0NTcxLjY2NTg0OF0gIGdlbmVyaWNfc2h1dGRvd25fc3VwZXIrMHgyNS8weDFhMApbMjQ1NzEu
NjY1ODUxXSAga2lsbF9hbm9uX3N1cGVyKzB4MTgvMHg1MApbMjQ1NzEuNjY1ODUyXSAgY2lmc19r
aWxsX3NiKzB4NGEvMHg2MCBbY2lmc10KWzI0NTcxLjY2NTkwMl0gIGRlYWN0aXZhdGVfbG9ja2Vk
X3N1cGVyKzB4MzIvMHhjMApbMjQ1NzEuNjY1OTA0XSAgZGVhY3RpdmF0ZV9zdXBlcisweDQ2LzB4
NjAKWzI0NTcxLjY2NTkwN10gIGNsZWFudXBfbW50KzB4YzMvMHgxNzAKWzI0NTcxLjY2NTkxMF0g
IF9fY2xlYW51cF9tbnQrMHgxMi8weDIwClsyNDU3MS42NjU5MTJdICB0YXNrX3dvcmtfcnVuKzB4
NWQvMHhhMApbMjQ1NzEuNjY1OTE3XSAgc3lzY2FsbF9leGl0X3RvX3VzZXJfbW9kZSsweDFjYS8w
eDFkMApbMjQ1NzEuNjY1OTIxXSAgZG9fc3lzY2FsbF82NCsweDhhLzB4MTcwClsyNDU3MS42NjU5
MjNdICA/IGdlbmVyaWNfcGVybWlzc2lvbisweDM5LzB4MjMwClsyNDU3MS42NjU5MjddICA/IG1u
dHB1dCsweDI0LzB4NTAKWzI0NTcxLjY2NTkyOV0gID8gcGF0aF9wdXQrMHgxZS8weDMwClsyNDU3
MS42NjU5MzJdICA/IGRvX2ZhY2Nlc3NhdCsweDFlMy8weDJlMApbMjQ1NzEuNjY1OTM1XSAgPyBh
cmNoX2V4aXRfdG9fdXNlcl9tb2RlX3ByZXBhcmUuaXNyYS4wKzB4MjIvMHhkMApbMjQ1NzEuNjY1
OTM5XSAgPyBzeXNjYWxsX2V4aXRfdG9fdXNlcl9tb2RlKzB4MzgvMHgxZDAKWzI0NTcxLjY2NTk0
MV0gID8gZG9fc3lzY2FsbF82NCsweDhhLzB4MTcwClsyNDU3MS42NjU5NDRdICA/IGFyY2hfZXhp
dF90b191c2VyX21vZGVfcHJlcGFyZS5pc3JhLjArMHgyMi8weGQwClsyNDU3MS42NjU5NDddICA/
IHN5c2NhbGxfZXhpdF90b191c2VyX21vZGUrMHgzOC8weDFkMApbMjQ1NzEuNjY1OTUwXSAgPyBk
b19zeXNjYWxsXzY0KzB4OGEvMHgxNzAKWzI0NTcxLjY2NTk1Ml0gID8gaXJxZW50cnlfZXhpdF90
b191c2VyX21vZGUrMHgyZC8weDFkMApbMjQ1NzEuNjY1OTU1XSAgPyBpcnFlbnRyeV9leGl0KzB4
NDMvMHg1MApbMjQ1NzEuNjY1OTU3XSAgPyBleGNfcGFnZV9mYXVsdCsweDk2LzB4MWMwClsyNDU3
MS42NjU5NjBdICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg3Ni8weDdlClsyNDU3
MS42NjU5NjNdIFJJUDogMDAzMzoweDczNGE2MDEyYTlmYgpbMjQ1NzEuNjY1OTY2XSBDb2RlOiBj
MyA2NiAyZSAwZiAxZiA4NCAwMCAwMCAwMCAwMCAwMCAwZiAxZiA0MCAwMCBmMyAwZiAxZSBmYSAz
MSBmNiBlOSAwNSAwMCAwMCAwMCAwZiAxZiA0NCAwMCAwMCBmMyAwZiAxZSBmYSBiOCBhNiAwMCAw
MCAwMCAwZiAwNSA8NDg+IDNkIDAwIGYwIGZmIGZmIDc3IDA1IGMzIDBmIDFmIDQwIDAwIDQ4IDhi
IDE1IGU5IDgzIDBkIDAwIGY3IGQ4ClsyNDU3MS42NjU5NjhdIFJTUDogMDAyYjowMDAwN2ZmZTNl
MmYyNGE4IEVGTEFHUzogMDAwMDAyNDYgT1JJR19SQVg6IDAwMDAwMDAwMDAwMDAwYTYKWzI0NTcx
LjY2NTk3MV0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAwMDYzOTE0NGY2N2E2MCBSQ1g6
IDAwMDA3MzRhNjAxMmE5ZmIKWzI0NTcxLjY2NTk3M10gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJT
STogMDAwMDAwMDAwMDAwMDAwMCBSREk6IDAwMDA2MzkxNDRmNzQwNzAKWzI0NTcxLjY2NTk3NF0g
UkJQOiAwMDAwN2ZmZTNlMmYyNTgwIFIwODogMDAwMDczNGE2MDIwM2IyMCBSMDk6IDAwMDAwMDAw
MDAwMDAwMjAKWzI0NTcxLjY2NTk3Nl0gUjEwOiAwMDAwMDAwMDAwMDAwMDAxIFIxMTogMDAwMDAw
MDAwMDAwMDI0NiBSMTI6IDAwMDA2MzkxNDRmNjdiNjAKWzI0NTcxLjY2NTk3N10gUjEzOiAwMDAw
MDAwMDAwMDAwMDAwIFIxNDogMDAwMDYzOTE0NGY3NDA3MCBSMTU6IDAwMDA2MzkxNDRmNjdlNzAK
WzI0NTcxLjY2NTk4MV0gIDwvVEFTSz4KWzI0NTcxLjY2NTk4Ml0gLS0tWyBlbmQgdHJhY2UgMDAw
MDAwMDAwMDAwMDAwMCBdLS0tClsyNDU3MS42ODI5NzJdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbMjQ1NzEuNjgyOTc1XSBWRlM6IEJ1c3kgaW5vZGVzIGFmdGVyIHVubW91
bnQgb2YgY2lmcyAoY2lmcykKWzI0NTcxLjY4Mjk4MV0gV0FSTklORzogQ1BVOiA0IFBJRDogMTM2
NTA2OSBhdCBmcy9zdXBlci5jOjY1MCBnZW5lcmljX3NodXRkb3duX3N1cGVyKzB4MTI3LzB4MWEw
ClsyNDU3MS42ODI5ODZdIE1vZHVsZXMgbGlua2VkIGluOiBjaWZzIHJmY29tbSBzbmRfc2VxX2R1
bW15IHNuZF9ocnRpbWVyIHNuZF9zZXFfbWlkaSBzbmRfc2VxX21pZGlfZXZlbnQgc25kX3Jhd21p
ZGkgc25kX3NlcSBzbmRfc2VxX2RldmljZSB4dF9jb25udHJhY2sgbmZ0X2NoYWluX25hdCB4dF9N
QVNRVUVSQURFIG5mX25hdCBuZl9jb25udHJhY2tfbmV0bGluayBuZl9jb25udHJhY2sgbmZfZGVm
cmFnX2lwdjYgbmZfZGVmcmFnX2lwdjQgeGZybV91c2VyIHhmcm1fYWxnbyB4dF9hZGRydHlwZSBu
ZnRfY29tcGF0IG5mX3RhYmxlcyBicl9uZXRmaWx0ZXIgYnJpZGdlIHN0cCBsbGMgbmxzX3V0Zjgg
Y2lmc19hcmM0IG5sc191Y3MyX3V0aWxzIGNpZnNfbWQ0IGNhY2hlZmlsZXMgbmV0ZnMgY2NtIG92
ZXJsYXkgcXJ0ciBjbWFjIGFsZ2lmX2hhc2ggYWxnaWZfc2tjaXBoZXIgYWZfYWxnIGJuZXAgc2No
X2ZxX2NvZGVsIGJpbmZtdF9taXNjIG5sc19pc284ODU5XzEgaW50ZWxfdW5jb3JlX2ZyZXF1ZW5j
eSBpbnRlbF91bmNvcmVfZnJlcXVlbmN5X2NvbW1vbiBpbnRlbF90Y2NfY29vbGluZyB4ODZfcGtn
X3RlbXBfdGhlcm1hbCBzbmRfc29mX3BjaV9pbnRlbF9jbmwgc25kX3NvZl9pbnRlbF9oZGFfZ2Vu
ZXJpYyBzb3VuZHdpcmVfaW50ZWwgaW50ZWxfcG93ZXJjbGFtcCBzb3VuZHdpcmVfY2FkZW5jZSBj
b3JldGVtcCBzbmRfc29mX2ludGVsX2hkYV9jb21tb24gc25kX3NvY19oZGFjX2hkYSBlbGFuX2ky
YyBzbmRfc29mX2ludGVsX2hkYV9tbGluayBrdm1faW50ZWwgc25kX3NvZl9pbnRlbF9oZGEgc25k
X3NvZl9wY2kgc25kX3NvZl94dGVuc2FfZHNwIHNuZF9zb2Yga3ZtIHNuZF9zb2ZfdXRpbHMgZWUx
MDA0IGNtZGxpbmVwYXJ0IHNuZF9zb2NfYWNwaV9pbnRlbF9tYXRjaCBzb3VuZHdpcmVfZ2VuZXJp
Y19hbGxvY2F0aW9uIHNuZF9zb2NfYWNwaSBjcmN0MTBkaWZfcGNsbXVsIHBvbHl2YWxfY2xtdWxu
aSBtZWlfaGRjcCBzcGlfbm9yIHBvbHl2YWxfZ2VuZXJpYyBzb3VuZHdpcmVfYnVzIGdoYXNoX2Ns
bXVsbmlfaW50ZWwKWzI0NTcxLjY4MzAzNl0gIHNoYTI1Nl9zc3NlMyBtdGQgbWVpX3B4cCBpbnRl
bF9yYXBsX21zciBzaGExX3Nzc2UzIHNuZF9zb2NfYXZzIGFlc25pX2ludGVsIHNuZF9zb2NfaGRh
X2NvZGVjIGNyeXB0b19zaW1kIHNuZF9oZGFfZXh0X2NvcmUgY3J5cHRkIGl3bG12bSByYXBsIHNu
ZF9oZGFfY29kZWNfcmVhbHRlayBzbmRfc29jX2NvcmUgdGhpbmtfbG1pIHNuZF9oZGFfY29kZWNf
Z2VuZXJpYyBmaXJtd2FyZV9hdHRyaWJ1dGVzX2NsYXNzIGludGVsX2NzdGF0ZSBzbmRfaGRhX2Nv
ZGVjX2hkbWkgc25kX2hkYV9zY29kZWNfY29tcG9uZW50IHNuZF9jdGxfbGVkIHNuZF9jb21wcmVz
cyBhYzk3X2J1cyBwcm9jZXNzb3JfdGhlcm1hbF9kZXZpY2VfcGNpX2xlZ2FjeSBtYWM4MDIxMSBz
bmRfcGNtX2RtYWVuZ2luZSBwcm9jZXNzb3JfdGhlcm1hbF9kZXZpY2UgcHJvY2Vzc29yX3RoZXJt
YWxfd3RfaGludCB1dmN2aWRlbyBwcm9jZXNzb3JfdGhlcm1hbF9yZmltIHZpZGVvYnVmMl92bWFs
bG9jIGxpYmFyYzQgdXZjIHNuZF9oZGFfaW50ZWwgc25kX2ludGVsX2RzcGNmZyBwcm9jZXNzb3Jf
dGhlcm1hbF9yYXBsIHZpZGVvYnVmMl9tZW1vcHMgc25kX2ludGVsX3Nkd19hY3BpIGludGVsX3dt
aV90aHVuZGVyYm9sdCB3bWlfYm1vZiBidHVzYiB2aWRlb2J1ZjJfdjRsMiBpbnRlbF9yYXBsX2Nv
bW1vbiBpd2x3aWZpIGJ0cnRsIGkyY19pODAxIHNuZF9oZGFfY29kZWMgcHJvY2Vzc29yX3RoZXJt
YWxfd3RfcmVxIGludGVsX3BtY19jb3JlIHZpZGVvYnVmMl9jb21tb24gbnZpZGlhZmIgYnRpbnRl
bCBpMmNfbXV4IHNwaV9pbnRlbF9wY2kgcHJvY2Vzc29yX3RoZXJtYWxfcG93ZXJfZmxvb3Igc3Bp
X2ludGVsIHNuZF9oZGFfY29yZSBpMmNfc21idXMgc25kX2h3ZGVwIHRoaW5rcGFkX2FjcGkgaW50
ZWxfdnNlYyBidGJjbSB2aWRlb2RldiBwcm9jZXNzb3JfdGhlcm1hbF9tYm94IGludDM0MDNfdGhl
cm1hbCBqb3lkZXYgdmdhc3RhdGUgaW5wdXRfbGVkcyBpbnQzNDAwX3RoZXJtYWwgYnRtdGsgbWVp
X21lIHBtdF90ZWxlbWV0cnkKWzI0NTcxLjY4MzA5MV0gIHNuZF9wY20gY2ZnODAyMTEgbWVpIGJs
dWV0b290aCBtYyBmYl9kZGMgc25kX3RpbWVyIGludGVsX3BjaF90aGVybWFsIGludGVsX3NvY19k
dHNfaW9zZiBudnJhbSBpbnQzNDB4X3RoZXJtYWxfem9uZSBhY3BpX3BhZCBhY3BpX3RoZXJtYWxf
cmVsIHBtdF9jbGFzcyBtYWNfaGlkIHNlcmlvX3JhdyBub3V2ZWF1IG14bV93bWkgZHJtX2dwdXZt
IGRybV9leGVjIGdwdV9zY2hlZCBkcm1fdHRtX2hlbHBlciB0dG0gZHJtX2Rpc3BsYXlfaGVscGVy
IGNlYyByY19jb3JlIGkyY19hbGdvX2JpdCBuZnNkIG1zciBwYXJwb3J0X3BjIGF1dGhfcnBjZ3Nz
IG5mc19hY2wgcHBkZXYgbG9ja2QgZ3JhY2UgbHAgbnZtZV9mYWJyaWNzIHBhcnBvcnQgbnZtZV9r
ZXlyaW5nIGVmaV9wc3RvcmUgc3VucnBjIG5mbmV0bGluayBkbWlfc3lzZnMgaXBfdGFibGVzIHhf
dGFibGVzIGF1dG9mczQgeGZzIGJ0cmZzIGJsYWtlMmJfZ2VuZXJpYyByYWlkMTAgcmFpZDQ1NiBh
c3luY19yYWlkNl9yZWNvdiBhc3luY19tZW1jcHkgYXN5bmNfcHEgYXN5bmNfeG9yIGFzeW5jX3R4
IHhvciByYWlkNl9wcSBsaWJjcmMzMmMgcmFpZDEgcmFpZDAgd2Fjb20gaGlkX21pY3Jvc29mdCBm
Zl9tZW1sZXNzIGhpZF9nZW5lcmljIHVzYmhpZCBoaWQgODI1MF9kdyBydHN4X3BjaV9zZG1tYyBu
dm1lIHVjc2lfYWNwaSBwc21vdXNlIGNyYzMyX3BjbG11bCB0eXBlY191Y3NpIGludGVsX2xwc3Nf
cGNpIG52bWVfY29yZSBlMTAwMGUgaW50ZWxfbHBzcyBydHN4X3BjaSBudm1lX2F1dGggc25kIHR5
cGVjIGlkbWE2NCBzb3VuZGNvcmUgdmlkZW8gc3BhcnNlX2tleW1hcCBwbGF0Zm9ybV9wcm9maWxl
IHdtaSBwaW5jdHJsX2Nhbm5vbmxha2UgW2xhc3QgdW5sb2FkZWQ6IGNpZnMoT0UpXQpbMjQ1NzEu
NjgzMTg3XSBDUFU6IDQgVUlEOiAwIFBJRDogMTM2NTA2OSBDb21tOiB1bW91bnQgVGFpbnRlZDog
RyAgICBCICAgVyAgT0UgICAgICA2LjEyLjMtMDYxMjAzLWdlbmVyaWMgIzIwMjQxMjA2MDYzOApb
MjQ1NzEuNjgzMTkxXSBUYWludGVkOiBbQl09QkFEX1BBR0UsIFtXXT1XQVJOLCBbT109T09UX01P
RFVMRSwgW0VdPVVOU0lHTkVEX01PRFVMRQpbMjQ1NzEuNjgzMTkyXSBIYXJkd2FyZSBuYW1lOiBM
RU5PVk8gMjBNQVMwODUwMC8yME1BUzA4NTAwLCBCSU9TIE4yQ0VUNzBXICgxLjUzICkgMDMvMTEv
MjAyNApbMjQ1NzEuNjgzMTkzXSBSSVA6IDAwMTA6Z2VuZXJpY19zaHV0ZG93bl9zdXBlcisweDEy
Ny8weDFhMApbMjQ1NzEuNjgzMTk2XSBDb2RlOiBjYyBjYyBlOCAxYyAzZiBmMCBmZiA0OCA4YiBi
YiAwMCAwMSAwMCAwMCBlYiBjZCA0OCA4YiA0MyAyOCA0OCA4ZCBiMyBjMCAwMyAwMCAwMCA0OCBj
NyBjNyBhMCBlNSBlYyBiNyA0OCA4YiAxMCBlOCBkOSAxNCBiZSBmZiA8MGY+IDBiIDRjIDhkIGFi
IDQwIDA1IDAwIDAwIDRjIDg5IGVmIGU4IGE4IDE2IGRkIDAwIDQ4IDhiIDhiIDQ4IDA1ClsyNDU3
MS42ODMxOThdIFJTUDogMDAxODpmZmZmYWU3MWNiZDBmYzA4IEVGTEFHUzogMDAwMTAyNDYKWzI0
NTcxLjY4MzIwMF0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjk3N2MwMDk2ZDAwMCBS
Q1g6IDAwMDAwMDAwMDAwMDAwMDAKWzI0NTcxLjY4MzIwMl0gUkRYOiAwMDAwMDAwMDAwMDAwMDAw
IFJTSTogMDAwMDAwMDAwMDAwMDAwMCBSREk6IDAwMDAwMDAwMDAwMDAwMDAKWzI0NTcxLjY4MzIw
M10gUkJQOiBmZmZmYWU3MWNiZDBmYzIwIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAw
MDAwMDAwMDAwMDAKWzI0NTcxLjY4MzIwNF0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAw
MDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY5NzdjMDA5NmQ1NDgKWzI0NTcxLjY4MzIwNl0gUjEzOiBm
ZmZmOTc3ZGI4ZjBiODM0IFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAw
MDAKWzI0NTcxLjY4MzIwN10gRlM6ICAwMDAwNzM0YTYwMmQzODAwKDAwMDApIEdTOmZmZmY5Nzgz
N2JhMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbMjQ1NzEuNjgzMjA5XSBDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsyNDU3MS42ODMy
MTBdIENSMjogMDAwMDdmZmUzZTJmMGNmMCBDUjM6IDAwMDAwMDAxMjAzNDAwMDEgQ1I0OiAwMDAw
MDAwMDAwMzcyNmYwClsyNDU3MS42ODMyMTJdIERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAw
MDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwClsyNDU3MS42ODMyMTNdIERSMzog
MDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZTBmZjAgRFI3OiAwMDAwMDAwMDAwMDAw
NDAwClsyNDU3MS42ODMyMTRdIENhbGwgVHJhY2U6ClsyNDU3MS42ODMyMTZdICA8VEFTSz4KWzI0
NTcxLjY4MzIxOF0gID8gc2hvd190cmFjZV9sb2dfbHZsKzB4MWJlLzB4MzEwClsyNDU3MS42ODMy
MjFdICA/IHNob3dfdHJhY2VfbG9nX2x2bCsweDFiZS8weDMxMApbMjQ1NzEuNjgzMjI1XSAgPyBr
aWxsX2Fub25fc3VwZXIrMHgxOC8weDUwClsyNDU3MS42ODMyMjddICA/IHNob3dfcmVncy5wYXJ0
LjArMHgyMi8weDMwClsyNDU3MS42ODMyMjldICA/IHNob3dfcmVncy5jb2xkKzB4OC8weDEwClsy
NDU3MS42ODMyMzFdICA/IGdlbmVyaWNfc2h1dGRvd25fc3VwZXIrMHgxMjcvMHgxYTAKWzI0NTcx
LjY4MzIzM10gID8gX193YXJuLmNvbGQrMHhhYy8weDEwYwpbMjQ1NzEuNjgzMjM1XSAgPyBnZW5l
cmljX3NodXRkb3duX3N1cGVyKzB4MTI3LzB4MWEwClsyNDU3MS42ODMyMzhdICA/IHJlcG9ydF9i
dWcrMHgxMTQvMHgxNjAKWzI0NTcxLjY4MzI0MV0gID8gaGFuZGxlX2J1ZysweDZlLzB4YjAKWzI0
NTcxLjY4MzI0NF0gID8gZXhjX2ludmFsaWRfb3ArMHgxOC8weDgwClsyNDU3MS42ODMyNDddICA/
IGFzbV9leGNfaW52YWxpZF9vcCsweDFiLzB4MjAKWzI0NTcxLjY4MzI1MV0gID8gZ2VuZXJpY19z
aHV0ZG93bl9zdXBlcisweDEyNy8weDFhMApbMjQ1NzEuNjgzMjUzXSAgPyBnZW5lcmljX3NodXRk
b3duX3N1cGVyKzB4MTI3LzB4MWEwClsyNDU3MS42ODMyNTZdICBraWxsX2Fub25fc3VwZXIrMHgx
OC8weDUwClsyNDU3MS42ODMyNThdICBjaWZzX2tpbGxfc2IrMHg0YS8weDYwIFtjaWZzXQpbMjQ1
NzEuNjgzMzA4XSAgZGVhY3RpdmF0ZV9sb2NrZWRfc3VwZXIrMHgzMi8weGMwClsyNDU3MS42ODMz
MTBdICBkZWFjdGl2YXRlX3N1cGVyKzB4NDYvMHg2MApbMjQ1NzEuNjgzMzEyXSAgY2xlYW51cF9t
bnQrMHhjMy8weDE3MApbMjQ1NzEuNjgzMzE0XSAgX19jbGVhbnVwX21udCsweDEyLzB4MjAKWzI0
NTcxLjY4MzMxNV0gIHRhc2tfd29ya19ydW4rMHg1ZC8weGEwClsyNDU3MS42ODMzMTddICBzeXNj
YWxsX2V4aXRfdG9fdXNlcl9tb2RlKzB4MWNhLzB4MWQwClsyNDU3MS42ODMzMjBdICBkb19zeXNj
YWxsXzY0KzB4OGEvMHgxNzAKWzI0NTcxLjY4MzMyMl0gID8gZ2VuZXJpY19wZXJtaXNzaW9uKzB4
MzkvMHgyMzAKWzI0NTcxLjY4MzMyNV0gID8gbW50cHV0KzB4MjQvMHg1MApbMjQ1NzEuNjgzMzI2
XSAgPyBwYXRoX3B1dCsweDFlLzB4MzAKWzI0NTcxLjY4MzMyOV0gID8gZG9fZmFjY2Vzc2F0KzB4
MWUzLzB4MmUwClsyNDU3MS42ODMzMzFdICA/IGFyY2hfZXhpdF90b191c2VyX21vZGVfcHJlcGFy
ZS5pc3JhLjArMHgyMi8weGQwClsyNDU3MS42ODMzMzRdICA/IHN5c2NhbGxfZXhpdF90b191c2Vy
X21vZGUrMHgzOC8weDFkMApbMjQ1NzEuNjgzMzM2XSAgPyBkb19zeXNjYWxsXzY0KzB4OGEvMHgx
NzAKWzI0NTcxLjY4MzMzOV0gID8gYXJjaF9leGl0X3RvX3VzZXJfbW9kZV9wcmVwYXJlLmlzcmEu
MCsweDIyLzB4ZDAKWzI0NTcxLjY4MzM0MV0gID8gc3lzY2FsbF9leGl0X3RvX3VzZXJfbW9kZSsw
eDM4LzB4MWQwClsyNDU3MS42ODMzNDNdICA/IGRvX3N5c2NhbGxfNjQrMHg4YS8weDE3MApbMjQ1
NzEuNjgzMzQ1XSAgPyBpcnFlbnRyeV9leGl0X3RvX3VzZXJfbW9kZSsweDJkLzB4MWQwClsyNDU3
MS42ODMzNDddICA/IGlycWVudHJ5X2V4aXQrMHg0My8weDUwClsyNDU3MS42ODMzNDldICA/IGV4
Y19wYWdlX2ZhdWx0KzB4OTYvMHgxYzAKWzI0NTcxLjY4MzM1Ml0gIGVudHJ5X1NZU0NBTExfNjRf
YWZ0ZXJfaHdmcmFtZSsweDc2LzB4N2UKWzI0NTcxLjY4MzM1NF0gUklQOiAwMDMzOjB4NzM0YTYw
MTJhOWZiClsyNDU3MS42ODMzNTZdIENvZGU6IGMzIDY2IDJlIDBmIDFmIDg0IDAwIDAwIDAwIDAw
IDAwIDBmIDFmIDQwIDAwIGYzIDBmIDFlIGZhIDMxIGY2IGU5IDA1IDAwIDAwIDAwIDBmIDFmIDQ0
IDAwIDAwIGYzIDBmIDFlIGZhIGI4IGE2IDAwIDAwIDAwIDBmIDA1IDw0OD4gM2QgMDAgZjAgZmYg
ZmYgNzcgMDUgYzMgMGYgMWYgNDAgMDAgNDggOGIgMTUgZTkgODMgMGQgMDAgZjcgZDgKWzI0NTcx
LjY4MzM1OF0gUlNQOiAwMDJiOjAwMDA3ZmZlM2UyZjI0YTggRUZMQUdTOiAwMDAwMDI0NiBPUklH
X1JBWDogMDAwMDAwMDAwMDAwMDBhNgpbMjQ1NzEuNjgzMzYwXSBSQVg6IDAwMDAwMDAwMDAwMDAw
MDAgUkJYOiAwMDAwNjM5MTQ0ZjY3YTYwIFJDWDogMDAwMDczNGE2MDEyYTlmYgpbMjQ1NzEuNjgz
MzYxXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMDAwIFJESTogMDAw
MDYzOTE0NGY3NDA3MApbMjQ1NzEuNjgzMzYzXSBSQlA6IDAwMDA3ZmZlM2UyZjI1ODAgUjA4OiAw
MDAwNzM0YTYwMjAzYjIwIFIwOTogMDAwMDAwMDAwMDAwMDAyMApbMjQ1NzEuNjgzMzY0XSBSMTA6
IDAwMDAwMDAwMDAwMDAwMDEgUjExOiAwMDAwMDAwMDAwMDAwMjQ2IFIxMjogMDAwMDYzOTE0NGY2
N2I2MApbMjQ1NzEuNjgzMzY1XSBSMTM6IDAwMDAwMDAwMDAwMDAwMDAgUjE0OiAwMDAwNjM5MTQ0
Zjc0MDcwIFIxNTogMDAwMDYzOTE0NGY2N2U3MApbMjQ1NzEuNjgzMzY4XSAgPC9UQVNLPgpbMjQ1
NzEuNjgzMzY5XSAtLS1bIGVuZCB0cmFjZSAwMDAwMDAwMDAwMDAwMDAwIF0tLS0K
--00000000000000c5850628a25fe0--
