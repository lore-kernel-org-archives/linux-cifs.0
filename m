Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7B9199EA3
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731951675; cv=none; b=ag29+ouZbmunIB1/929y1Ji/H3Fehlw1FVD/HC5RjmYro178qlOULsX4CRtp9NOeyecB7tUaAJhCMuc8cgF7WHVswQlEwqx+LqBdrwEkOu1rMfCowm0HmRTOz5R4cXfXZu9joAkJ4/yjObHKltpxsaksMz2P/GmVQdqSst9ddnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731951675; c=relaxed/simple;
	bh=Ok7AldR92SKcnl3mWph2yWKHP4lFlXpUKnKkWSasH1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WRFndK7F0aZ0GKa/bFUYuCQEQ0HtKeSbyAjioBdp0nP0iRrI3md36uNcx3ScUKAcq3nwmABYeRpv/TNemSj8MIxwD7mgWlskRBDKja/Bn8QaKLGIK61kjmkdEVwwXOyX6OcsUJfH8oxOFiw3KtVsHEeg0Ydufxs80upLfOJ1WRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XkIliZil; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XkIliZil"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fb4af0b6beso30332611fa.3
        for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 09:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731951671; x=1732556471; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wO1DzPC+Vom9Yfv6H2v2MnESoojRbUzXfFdm7oH1Hyg=;
        b=XkIliZilhGsYxX/EmQLMgJ1nlPXOwCPKdz1pDPMcCkh/TIJqrBkHs/qdV/9XqGJlI3
         VqpQUHYpwz/bYLPYVBxONvSepEqmRJkZbrrL2JZP31e7acscclJTjkDROekVRC9aZ/PG
         0pCjyeAcTHFnEQSqtjJDXQFB/fjUJ8+b//ejG/MgRPkGMww+9zPvjlGMuYNyif43FIXi
         iQcCtqHZ8fc8KhhYARknENaOdjMi1zduUoCDPx63nTO1r3o3875LdlMlNUGkPYz+wTYd
         iu/ujXWiqLhndFbEwhsHp+Zz05bmA9IGOKJdYKanuQCeKMnO3fOp7vb1f49JK/+LrXbz
         tmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731951671; x=1732556471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wO1DzPC+Vom9Yfv6H2v2MnESoojRbUzXfFdm7oH1Hyg=;
        b=hNBcfuUc7vAULR821FRHODRNVLPIYG2ArQUQFeANZPL5NoA+WIwKwrLNc8zGBqvf4e
         lwEauMiKukBJSiUtSJqZdsiNhSVH8/fsUE0pTsFBOB7ZpZbVGXD/bolRF4MsdOU6uww1
         D7eMP+zofmj6ku8E3Vw3NKZKp1ZXkae0jSCna6wl3QEBBfl7iApP3sJoLmi1cQmsEJKp
         8ihQzJ+BMxKA+qn8OrPKsf5CSwwLBH0J78CqUD1ECmwrDRXDDWULVbDtiEAPtN55WKdl
         Sv2sx3tP/ZjjJjmFgN6TDKxzkK/osiKT1Fjn0mysQ5XCR7h5+W0c+PG+M2+W4EakQx+c
         EfYg==
X-Gm-Message-State: AOJu0YwFmEdpz3UNzKXC8X+enx59QYYfBjBiPyBljkUh1k+ASB6/cQVb
	GtbUWJukrw6eWUYi2fiQM/DIsruZIyWMlg9QslJDRXkMn/IwlXYNJSPEfEPKLFwt0WpRx3tomqG
	OaPMi5JAjtzWlIj6oevexrO3OH/o=
X-Google-Smtp-Source: AGHT+IGP+Pii0d9k/rYcAdjNlIcIUS4OYSu+oqtfClJov6e/jBVK4bFCMiY09iXmywPgZJx/NNkVqNQ6Pe4qKLeK+5E=
X-Received: by 2002:a2e:9a0f:0:b0:2fb:6110:c5df with SMTP id
 38308e7fff4ca-2ff606db449mr98000331fa.31.1731951670533; Mon, 18 Nov 2024
 09:41:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108222906.3257172-1-paul@darkrain42.org> <CAH2r5muDRhy2gsy7kz9GHC3maGxcxAcam8B3pgCmnS8xcEQX1w@mail.gmail.com>
 <Zy6UW5fuva5VdIWk@haley.home.arpa> <igo6lqdjrldrgv5lq344yfsxrrgfwffdrxga3uh3umr324o3zb@icma7vfguafs>
 <CAH2r5muas7-EAyZa6LnaWNEtSc3MyB7TtGZrW=WgxRMUgb5e0Q@mail.gmail.com> <ZzT5RlV3chHYYF8G@haley.home.arpa>
In-Reply-To: <ZzT5RlV3chHYYF8G@haley.home.arpa>
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Nov 2024 11:40:58 -0600
Message-ID: <CAH2r5mvZN6mFP_BZa=Yk4112iPhwTnWgfUVKi40KBzsxszu42w@mail.gmail.com>
Subject: Re: [PATCH 0/5] SMB cached directory fixes around reconnection/unmounting
To: Paul Aurich <paul@darkrain42.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Let me know if any of the patches are ready for merging or any
additional patches.  I will add at least one to fix the R vs RH dir
lease issue Ralph pointed out.

On Wed, Nov 13, 2024 at 1:08=E2=80=AFPM Paul Aurich <paul@darkrain42.org> w=
rote:
>
> I'm working on a v2 set of patches that I hope would address this (I'm
> guessing it's somehow caused by the flush_workqueue() call, although to b=
e
> honest, I have no idea).
>
> My testing has also turned up another issue that needs fixing (the laundr=
omat
> thread can also race with cifs_kill_sb, resulting in yet another 'Dentry =
still
> in use' oops).
>
> ~Paul
>
> On 2024-11-09 18:49:54 -0600, Steve French wrote:
> >Running the buildbot on these against Windows with directory leases
> >enabled (ie not using "nohandlecache") I see a crash in generic/246 in
> >cifs_mount (see call trace at end of the email for more details). The
> >series does improve things, it fixes the oops that would cause e.g.
> >generic/048 to crash e.g. it fixes this one
> >
> >[ 2039.224037] BUG: Dentry 00000000114e5018{i=3D6000000019c6c,n=3D/}
> >still in use (2) [unmount of cifs cifs]
> >[ 2039.224086] WARNING: CPU: 1 PID: 123637 at fs/dcache.c:1536
> >umount_check+0xc3/0xf0
> >[ 2039.224112] Modules linked in: cifs ccm cmac nls_utf8 cifs_arc4
> >nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver
> >nfs lockd grace netfs nf_conntrack_netbios_ns nf_conntrack_broadcast
> >nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet
> >nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat
> >nf_tables ebtable_nat ebtable_broute ip6table_nat ip6table_mangle
> >ip6table_raw ip6table_security iptable_nat nf_nat nf_conntrack
> >nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw
> >iptable_security ip_set ebtable_filter ebtables ip6table_filter
> >ip6_tables iptable_filter ip_tables sunrpc kvm_intel kvm virtio_net
> >net_failover failover virtio_balloon loop fuse dm_multipath nfnetlink
> >zram xfs bochs drm_vram_helper drm_ttm_helper ttm drm_kms_helper
> >crct10dif_pclmul crc32_pclmul crc32c_intel drm ghash_clmulni_intel
> >sha512_ssse3 sha256_ssse3 floppy virtio_blk sha1_ssse3 qemu_fw_cfg
> >virtio_console [last unloaded: cifs]
> >[ 2039.224382] CPU: 1 UID: 0 PID: 123637 Comm: rm Not tainted 6.12.0-rc6=
 #1
> >[ 2039.224390] Hardware name: Red Hat KVM, BIOS 1.16.3-2.el9 04/01/2014
> >[ 2039.224395] RIP: 0010:umount_check+0xc3/0xf0
> >[ 2039.224401] Code: db 74 0d 48 8d 7b 40 e8 9b e3 f5 ff 48 8b 53 40
> >41 55 4d 89 f1 45 89 e0 48 89 e9 48 89 ee 48 c7 c7 80 74 ba a2 e8 dd
> >e8 a2 ff <0f> 0b 58 31 c0 5b 5d 41 5c 41 5d 41 5e c3 cc cc cc cc 41 83
> >fc 01
> >[ 2039.224408] RSP: 0018:ff11000128bcf968 EFLAGS: 00010282
> >[ 2039.224416] RAX: dffffc0000000000 RBX: ff11000110ba3d80 RCX: 00000000=
00000027
> >[ 2039.224422] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ff110004=
cb0b1a08
> >[ 2039.224427] RBP: ff11000112ebb8f8 R08: ffffffffa13f759e R09: ffe21c00=
99616341
> >[ 2039.224432] R10: ff110004cb0b1a0b R11: 0000000000000001 R12: 00000000=
00000002
> >[ 2039.224437] R13: ff1100013fe0c668 R14: ffffffffc1dee340 R15: ffffffff=
c2094200
> >[ 2039.224442] FS:  00007fdc92c66740(0000) GS:ff110004cb080000(0000)
> >knlGS:0000000000000000
> >[ 2039.224447] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[ 2039.224452] CR2: 0000556c6a58d488 CR3: 00000001229ec006 CR4: 00000000=
00373ef0
> >[ 2039.224465] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
> >[ 2039.224470] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
> >[ 2039.224475] Call Trace:
> >[ 2039.224479]  <TASK>
> >[ 2039.224485]  ? __warn+0xa9/0x220
> >[ 2039.224497]  ? umount_check+0xc3/0xf0
> >[ 2039.224506]  ? report_bug+0x1d4/0x1e0
> >[ 2039.224521]  ? handle_bug+0x5b/0xa0
> >[ 2039.224529]  ? exc_invalid_op+0x18/0x50
> >[ 2039.224537]  ? asm_exc_invalid_op+0x1a/0x20
> >[ 2039.224556]  ? irq_work_claim+0x1e/0x40
> >[ 2039.224568]  ? umount_check+0xc3/0xf0
> >[ 2039.224577]  ? umount_check+0xc3/0xf0
> >[ 2039.224586]  ? __pfx_umount_check+0x10/0x10
> >[ 2039.224594]  d_walk+0x71/0x4e0
> >[ 2039.224604]  ? d_walk+0x4b/0x4e0
> >[ 2039.224616]  shrink_dcache_for_umount+0x6d/0x220
> >[ 2039.224629]  generic_shutdown_super+0x4a/0x1c0
> >[ 2039.224640]  kill_anon_super+0x22/0x40
> >[ 2039.224649]  cifs_kill_sb+0x78/0x90 [cifs]
> >[ 2039.224848]  deactivate_locked_super+0x69/0xf0
> >[ 2039.224858]  cifsFileInfo_put_final+0x25a/0x290 [cifs]
> >[ 2039.225019]  _cifsFileInfo_put+0x5f9/0x770 [cifs]
> >[ 2039.225172]  ? __pfx__cifsFileInfo_put+0x10/0x10 [cifs]
> >[ 2039.225319]  ? mark_held_locks+0x65/0x90
> >[ 2039.225339]  ? kfree+0x1e5/0x490
> >[ 2039.225349]  ? cifs_close_deferred_file_under_dentry+0x2e5/0x350 [cif=
s]
> >[ 2039.225494]  cifs_close_deferred_file_under_dentry+0x26d/0x350 [cifs]
> >[ 2039.225639]  ? __pfx_cifs_close_deferred_file_under_dentry+0x10/0x10 =
[cifs]
> >[ 2039.225821]  ? cifs_sb_master_tcon+0x23/0x30 [cifs]
> >[ 2039.225970]  cifs_unlink+0x21d/0x7b0 [cifs]
> >[ 2039.226121]  vfs_unlink+0x1bf/0x4a0
> >[ 2039.226131]  ? lookup_one_qstr_excl+0x24/0xd0
> >[ 2039.226143]  do_unlinkat+0x380/0x450
> >[ 2039.226154]  ? __pfx_do_unlinkat+0x10/0x10
> >[ 2039.226161]  ? kasan_save_track+0x14/0x30
> >[ 2039.226171]  ? rcu_is_watching+0x20/0x50
> >[ 2039.226180]  ? strncpy_from_user+0x126/0x180
> >[ 2039.226201]  __x64_sys_unlinkat+0x5e/0xa0
> >[ 2039.226211]  do_syscall_64+0x75/0x180
> >[ 2039.226222]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >[ 2039.226230] RIP: 0033:0x7fdc92d7784b
> >[ 2039.226237] Code: 77 05 c3 0f 1f 40 00 48 8b 15 c9 85 0d 00 f7 d8
> >64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 07 01 00
> >00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d 85 0d 00 f7 d8 64 89
> >01 48
> >[ 2039.226244] RSP: 002b:00007ffd51debe58 EFLAGS: 00000206 ORIG_RAX:
> >0000000000000107
> >[ 2039.226253] RAX: ffffffffffffffda RBX: 0000556c6a58d5a0 RCX: 00007fdc=
92d7784b
> >[ 2039.226258] RDX: 0000000000000000 RSI: 0000556c6a58c380 RDI: 00000000=
ffffff9c
> >[ 2039.226263] RBP: 00007ffd51debf20 R08: 0000556c6a58c380 R09: 00007ffd=
51debf7c
> >[ 2039.226268] R10: 0000556c6a58d7d0 R11: 0000000000000206 R12: 0000556c=
6a58c2f0
> >[ 2039.226273] R13: 0000000000000000 R14: 00007ffd51debf80 R15: 00000000=
00000000
> >[ 2039.226297]  </TASK>
> >[ 2039.226301] irq event stamp: 5933
> >[ 2039.226305] hardirqs last  enabled at (5939): [<ffffffffa122e2de>]
> >__up_console_sem+0x5e/0x70
> >[ 2039.226314] hardirqs last disabled at (5944): [<ffffffffa122e2c3>]
> >__up_console_sem+0x43/0x70
> >[ 2039.226320] softirqs last  enabled at (3096): [<ffffffffa11340ce>]
> >__irq_exit_rcu+0xfe/0x120
> >[ 2039.226327] softirqs last disabled at (2941): [<ffffffffa11340ce>]
> >__irq_exit_rcu+0xfe/0x120
> >[ 2039.226333] ---[ end trace 0000000000000000 ]---
> >[ 2040.931627] VFS: Busy inodes after unmount of cifs (cifs)
> >[ 2040.931693] ------------[ cut here ]------------
> >[ 2040.931699] kernel BUG at fs/super.c:650!
> >[ 2040.932770] Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> >[ 2040.932846] CPU: 1 UID: 0 PID: 123637 Comm: rm Tainted: G        W
> >        6.12.0-rc6 #1
> >[ 2040.932936] Tainted: [W]=3DWARN
> >[ 2040.932969] Hardware name: Red Hat KVM, BIOS 1.16.3-2.el9 04/01/2014
> >[ 2040.933028] RIP: 0010:generic_shutdown_super+0x1b7/0x1c0
> >[ 2040.933086] Code: 7b 28 e8 cc ca f8 ff 48 8b 6b 28 48 89 ef e8 c0
> >ca f8 ff 48 8b 55 00 48 8d b3 68 06 00 00 48 c7 c7 60 14 ba a2 e8 d9
> >6c b6 ff <0f> 0b 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90
> >90 90
> >[ 2040.933252] RSP: 0018:ff11000128bcfa38 EFLAGS: 00010282
> >[ 2040.933305] RAX: 000000000000002d RBX: ff1100013fe0c000 RCX: ffffffff=
a12c915e
> >[ 2040.933370] RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ff110004=
cb0b7080
> >[ 2040.933436] RBP: ffffffffc20529a0 R08: 0000000000000001 R09: ffe21c00=
25179f0f
> >[ 2040.933500] R10: ff11000128bcf87f R11: 0000000000000001 R12: ff110001=
3fe0c9c0
> >[ 2040.933565] R13: ff1100013fe0c780 R14: ff11000168113378 R15: ffffffff=
c2094200
> >[ 2040.933630] FS:  00007fdc92c66740(0000) GS:ff110004cb080000(0000)
> >knlGS:0000000000000000
> >[ 2040.933703] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[ 2040.933757] CR2: 0000556c6a58d488 CR3: 00000001229ec006 CR4: 00000000=
00373ef0
> >[ 2040.933828] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
> >[ 2040.933905] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
> >[ 2040.933972] Call Trace:
> >[ 2040.934000]  <TASK>
> >[ 2040.934024]  ? die+0x37/0x90
> >[ 2040.934058]  ? do_trap+0x133/0x230
> >[ 2040.934094]  ? generic_shutdown_super+0x1b7/0x1c0
> >[ 2040.934144]  ? do_error_trap+0x94/0x130
> >[ 2040.934182]  ? generic_shutdown_super+0x1b7/0x1c0
> >[ 2040.934229]  ? generic_shutdown_super+0x1b7/0x1c0
> >[ 2040.934277]  ? handle_invalid_op+0x2c/0x40
> >[ 2040.934318]  ? generic_shutdown_super+0x1b7/0x1c0
> >[ 2040.934364]  ? exc_invalid_op+0x2f/0x50
> >[ 2040.934405]  ? asm_exc_invalid_op+0x1a/0x20
> >[ 2040.934453]  ? tick_nohz_tick_stopped+0x1e/0x40
> >[ 2040.934502]  ? generic_shutdown_super+0x1b7/0x1c0
> >[ 2040.934551]  ? generic_shutdown_super+0x1b7/0x1c0
> >[ 2040.934600]  kill_anon_super+0x22/0x40
> >[ 2040.934641]  cifs_kill_sb+0x78/0x90 [cifs]
> >[ 2040.934851]  deactivate_locked_super+0x69/0xf0
> >[ 2040.934915]  cifsFileInfo_put_final+0x25a/0x290 [cifs]
> >[ 2040.935125]  _cifsFileInfo_put+0x5f9/0x770 [cifs]
> >[ 2040.935331]  ? __pfx__cifsFileInfo_put+0x10/0x10 [cifs]
> >[ 2040.935537]  ? mark_held_locks+0x65/0x90
> >[ 2040.935581]  ? kfree+0x1e5/0x490
> >[ 2040.937096]  ? cifs_close_deferred_file_under_dentry+0x2e5/0x350 [cif=
s]
> >[ 2040.938778]  cifs_close_deferred_file_under_dentry+0x26d/0x350 [cifs]
> >[ 2040.940478]  ? __pfx_cifs_close_deferred_file_under_dentry+0x10/0x10 =
[cifs]
> >[ 2040.942193]  ? cifs_sb_master_tcon+0x23/0x30 [cifs]
> >[ 2040.943865]  cifs_unlink+0x21d/0x7b0 [cifs]
> >[ 2040.945527]  vfs_unlink+0x1bf/0x4a0
> >[ 2040.947008]  ? lookup_one_qstr_excl+0x24/0xd0
> >[ 2040.948451]  do_unlinkat+0x380/0x450
> >[ 2040.949889]  ? __pfx_do_unlinkat+0x10/0x10
> >[ 2040.951306]  ? kasan_save_track+0x14/0x30
> >[ 2040.952708]  ? rcu_is_watching+0x20/0x50
> >[ 2040.954135]  ? strncpy_from_user+0x126/0x180
> >[ 2040.955494]  __x64_sys_unlinkat+0x5e/0xa0
> >[ 2040.956779]  do_syscall_64+0x75/0x180
> >[ 2040.958053]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> >
> >
> >but I did see a crash in generic/246 with current mainline + the five
> >directory lease patches (see below).  Any ideas?
> >
> >[ 4315.917270] CIFS: Attempting to mount //win16.vm.test/Share
> >[ 4315.928088] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >[ 4315.930402] BUG: KASAN: slab-use-after-free in
> >rwsem_down_write_slowpath+0xa34/0xaf0
> >[ 4315.932655] Read of size 4 at addr ff1100012ad38034 by task mount.cif=
s/340968
> >
> >[ 4315.937119] CPU: 2 UID: 0 PID: 340968 Comm: mount.cifs Tainted: G
> >   D W          6.12.0-rc6 #1
> >[ 4315.939454] Tainted: [D]=3DDIE, [W]=3DWARN
> >[ 4315.941747] Hardware name: Red Hat KVM, BIOS 1.16.3-2.el9 04/01/2014
> >[ 4315.944094] Call Trace:
> >[ 4315.946425]  <TASK>
> >[ 4315.948724]  dump_stack_lvl+0x79/0xb0
> >[ 4315.951046]  print_report+0xcb/0x620
> >[ 4315.953359]  ? __virt_addr_valid+0x19a/0x300
> >[ 4315.955682]  ? rwsem_down_write_slowpath+0xa34/0xaf0
> >[ 4315.957994]  kasan_report+0xbd/0xf0
> >[ 4315.960317]  ? rwsem_down_write_slowpath+0xa34/0xaf0
> >[ 4315.962610]  rwsem_down_write_slowpath+0xa34/0xaf0
> >[ 4315.964835]  ? kasan_save_stack+0x34/0x50
> >[ 4315.967030]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> >[ 4315.969221]  ? cifs_mount+0xfb/0x3b0 [cifs]
> >[ 4315.971586]  ? cifs_smb3_do_mount+0x1a5/0xc10 [cifs]
> >[ 4315.974108]  ? smb3_get_tree+0x1f0/0x430 [cifs]
> >[ 4315.976511]  ? rcu_is_watching+0x20/0x50
> >[ 4315.978712]  ? trace_lock_acquire+0x116/0x150
> >[ 4315.980884]  ? lock_acquire+0x40/0x90
> >[ 4315.982989]  ? super_lock+0xea/0x1d0
> >[ 4315.985036]  ? super_lock+0xea/0x1d0
> >[ 4315.986997]  down_write+0x15b/0x160
> >[ 4315.988893]  ? __pfx_down_write+0x10/0x10
> >[ 4315.990751]  ? __mod_timer+0x407/0x590
> >[ 4315.992531]  super_lock+0xea/0x1d0
> >[ 4315.994231]  ? __pfx_super_lock+0x10/0x10
> >[ 4315.995891]  ? __pfx_lock_release+0x10/0x10
> >[ 4315.997528]  ? rcu_is_watching+0x20/0x50
> >[ 4315.999137]  ? lock_release+0xa5/0x3d0
> >[ 4316.000705]  ? cifs_match_super+0x177/0x650 [cifs]
> >[ 4316.002385]  grab_super+0x80/0x1e0
> >[ 4316.003884]  ? __pfx_grab_super+0x10/0x10
> >[ 4316.005351]  ? cifs_put_tlink+0xa1/0xc0 [cifs]
> >[ 4316.006990]  ? cifs_match_super+0x17f/0x650 [cifs]
> >[ 4316.008620]  ? __pfx_cifs_match_super+0x10/0x10 [cifs]
> >[ 4316.010236]  sget+0x121/0x350
> >[ 4316.011694]  ? __pfx_cifs_set_super+0x10/0x10 [cifs]
> >[ 4316.013293]  cifs_smb3_do_mount+0x293/0xc10 [cifs]
> >[ 4316.014933]  ? __pfx___mutex_lock+0x10/0x10
> >[ 4316.016333]  ? cred_has_capability.isra.0+0xd4/0x1a0
> >[ 4316.017752]  ? __pfx_cifs_smb3_do_mount+0x10/0x10 [cifs]
> >[ 4316.019338]  smb3_get_tree+0x1f0/0x430 [cifs]
> >[ 4316.020910]  vfs_get_tree+0x50/0x180
> >[ 4316.022292]  path_mount+0x5d6/0xf20
> >[ 4316.023668]  ? __pfx_path_mount+0x10/0x10
> >[ 4316.024983]  ? user_path_at+0x45/0x60
> >[ 4316.026275]  __x64_sys_mount+0x174/0x1b0
> >[ 4316.027552]  ? __pfx___x64_sys_mount+0x10/0x10
> >[ 4316.028794]  ? rcu_is_watching+0x20/0x50
> >[ 4316.030021]  do_syscall_64+0x75/0x180
> >[ 4316.031226]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >[ 4316.032476] RIP: 0033:0x7f979fa7b8fe
> >[ 4316.033742] Code: 48 8b 0d 1d a5 0c 00 f7 d8 64 89 01 48 83 c8 ff
> >c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00
> >00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ea a4 0c 00 f7 d8 64 89
> >01 48
> >[ 4316.036462] RSP: 002b:00007fffbaa4f598 EFLAGS: 00000246 ORIG_RAX:
> >00000000000000a5
> >[ 4316.037874] RAX: ffffffffffffffda RBX: 0000557684547471 RCX: 00007f97=
9fa7b8fe
> >[ 4316.039284] RDX: 0000557684547471 RSI: 00005576845474d7 RDI: 00007fff=
baa50caf
> >[ 4316.040701] RBP: 000000000000000a R08: 00005576847deeb0 R09: 00000000=
00000000
> >[ 4316.042106] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff=
baa50caf
> >[ 4316.043522] R13: 00005576847dff20 R14: 00005576847deeb0 R15: 00007f97=
9fb75000
> >[ 4316.044928]  </TASK>
> >
> >[ 4316.047670] Allocated by task 340820:
> >[ 4316.049036]  kasan_save_stack+0x24/0x50
> >[ 4316.050414]  kasan_save_track+0x14/0x30
> >[ 4316.051771]  __kasan_slab_alloc+0x59/0x70
> >[ 4316.053139]  kmem_cache_alloc_node_noprof+0x116/0x330
> >[ 4316.054529]  copy_process+0x299/0x45e0
> >[ 4316.055915]  kernel_clone+0xf2/0x4b0
> >[ 4316.057299]  __do_sys_clone+0x90/0xb0
> >[ 4316.058708]  do_syscall_64+0x75/0x180
> >[ 4316.060095]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> >[ 4316.062893] Freed by task 0:
> >[ 4316.064283]  kasan_save_stack+0x24/0x50
> >[ 4316.065695]  kasan_save_track+0x14/0x30
> >[ 4316.067076]  kasan_save_free_info+0x3b/0x60
> >[ 4316.068462]  __kasan_slab_free+0x38/0x50
> >[ 4316.069841]  kmem_cache_free+0x239/0x5a0
> >[ 4316.071213]  delayed_put_task_struct+0x149/0x1b0
> >[ 4316.072608]  rcu_do_batch+0x2f4/0x880
> >[ 4316.073979]  rcu_core+0x3d6/0x510
> >[ 4316.075340]  handle_softirqs+0x10f/0x580
> >[ 4316.076708]  __irq_exit_rcu+0xfe/0x120
> >[ 4316.078052]  irq_exit_rcu+0xe/0x20
> >[ 4316.079400]  sysvec_apic_timer_interrupt+0x76/0x90
> >[ 4316.080747]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> >
> >[ 4316.083488] Last potentially related work creation:
> >[ 4316.084845]  kasan_save_stack+0x24/0x50
> >[ 4316.086188]  __kasan_record_aux_stack+0x8e/0xa0
> >[ 4316.087564]  __call_rcu_common.constprop.0+0x87/0x920
> >[ 4316.088932]  release_task+0x836/0xc60
> >[ 4316.090296]  wait_consider_task+0x9db/0x19c0
> >[ 4316.091682]  __do_wait+0xe9/0x390
> >[ 4316.093046]  do_wait+0xcb/0x230
> >[ 4316.094412]  kernel_wait4+0xe4/0x1a0
> >[ 4316.095767]  __do_sys_wait4+0xce/0xe0
> >[ 4316.097110]  do_syscall_64+0x75/0x180
> >[ 4316.098455]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> >[ 4316.100994] The buggy address belongs to the object at ff1100012ad380=
00
> >                which belongs to the cache task_struct of size 14656
> >[ 4316.103497] The buggy address is located 52 bytes inside of
> >                freed 14656-byte region [ff1100012ad38000, ff1100012ad3b=
940)
> >
> >[ 4316.107248] The buggy address belongs to the physical page:
> >[ 4316.108537] page: refcount:1 mapcount:0 mapping:0000000000000000
> >index:0x0 pfn:0x12ad38
> >[ 4316.109846] head: order:3 mapcount:0 entire_mapcount:0
> >nr_pages_mapped:0 pincount:0
> >[ 4316.111193] memcg:ff11000100d2c6c1
> >[ 4316.112543] anon flags:
> >0x17ffffc0000040(head|node=3D0|zone=3D2|lastcpupid=3D0x1fffff)
> >[ 4316.113945] page_type: f5(slab)
> >[ 4316.115364] raw: 0017ffffc0000040 ff11000100280a00 0000000000000000
> >0000000000000001
> >[ 4316.116852] raw: 0000000000000000 0000000000020002 00000001f5000000
> >ff11000100d2c6c1
> >[ 4316.118329] head: 0017ffffc0000040 ff11000100280a00
> >0000000000000000 0000000000000001
> >[ 4316.119818] head: 0000000000000000 0000000000020002
> >00000001f5000000 ff11000100d2c6c1
> >[ 4316.121302] head: 0017ffffc0000003 ffd4000004ab4e01
> >ffffffffffffffff 0000000000000000
> >[ 4316.122818] head: 0000000000000008 0000000000000000
> >00000000ffffffff 0000000000000000
> >[ 4316.124323] page dumped because: kasan: bad access detected
> >
> >[ 4316.127318] Memory state around the buggy address:
> >[ 4316.128847]  ff1100012ad37f00: ff ff ff ff ff ff ff ff ff ff ff ff
> >ff ff ff ff
> >[ 4316.130427]  ff1100012ad37f80: ff ff ff ff ff ff ff ff ff ff ff ff
> >ff ff ff ff
> >[ 4316.132006] >ff1100012ad38000: fa fb fb fb fb fb fb fb fb fb fb fb
> >fb fb fb fb
> >[ 4316.133594]                                      ^
> >[ 4316.135170]  ff1100012ad38080: fb fb fb fb fb fb fb fb fb fb fb fb
> >fb fb fb fb
> >[ 4316.136796]  ff1100012ad38100: fb fb fb fb fb fb fb fb fb fb fb fb
> >fb fb fb fb
> >[ 4316.138399] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >
> >On Fri, Nov 8, 2024 at 5:12=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.d=
e> wrote:
> >>
> >> On 11/08, Paul Aurich wrote:
> >> >No, this series doesn't try to address that. I was just focused on th=
e
> >> >issues around the lifecycle of the cfids and the dentry:s.
> >>
> >> I'll be reviewing the patches next week, but for now I can say +1.
> >>
> >> We've been debugging this issue for the past month or so, and it's bee=
n
> >> quite hard to understand/debug who was racing who.
> >>
> >> The 'dentry still in use' bug seems to appear only for the root dentry=
,
> >> whereas cached_fids for subdirectories sometimes can get duplicates, a=
nd
> >> thus one dangling, where in the end an underflow + double list_del()
> >> happens to it, e.g.:
> >>
> >> (this is coming from cifs_readdir())
> >> crash> cached_fid.entry,cfids,path,has_lease,is_open,on_list,time,tcon=
,refcount 0xffff892f4b5b3e00
> >>    entry =3D {
> >>      next =3D 0xffff892e053ed400,
> >>      prev =3D 0xffff892d8e3ecb88
> >>    },
> >>    cfids =3D 0xffff892d8e3ecb80,
> >>    path =3D 0xffff892f48b7b3b0 "\\dir1\\dir2\\dir3",
> >>    has_lease =3D 0x0,
> >>    is_open =3D 0x0,
> >>    on_list =3D 0x1,
> >>    time =3D 0x0,
> >>    tcon =3D 0x0,
> >>    refcount =3D { ... counter =3D 0x2 ... }
> >>
> >> (this is at the crashing frame on smb2_close_cached_fid())
> >> crash> cached_fid.entry,cfids,path,has_lease,is_open,on_list,time,tcon=
,refcount ffff892e053ee000
> >>    entry =3D {
> >>      next =3D 0xdead000000000100,
> >>      prev =3D 0xdead000000000122
> >>    },
> >>    cfids =3D 0xffff892d8e3ecb80,
> >>    path =3D 0xffff892f825ced30 "\\dir1\\dir2\\dir3",
> >>    has_lease =3D 0x0,
> >>    is_open =3D 0x1,
> >>    on_list =3D 0x1,
> >>    time =3D 0x1040998fc,
> >>    tcon =3D 0xffff892fe0b4d000,
> >>    refcount =3D { ... counter =3D 0x0 ... }
> >>
> >> You can see that the second one had already been deleted (refcount=3D0=
,
> >> ->entry is poisoned), but the first one hasn't been filled in by
> >> open_cached_dir() yet, but already has 2 references to it.
> >>
> >> A reliable reproducer I found for this was running xfstests '-g
> >> generic/dir' in one terminal, and generic/072 some seconds later.
> >>
> >> (in the beginning I thought that a reconnect was required to trigger
> >> this bug, but any kind of interruption (I could trigger it with ctrl-c
> >> mid-xfstests a few times) should trigger it)
> >>
> >> actimeo >=3D 0 seems to play a role as well, because things can get qu=
ite
> >> complicated (unsure if problematic though) with a callchain such as:
> >>
> >> open_cached_dir
> >>    -> path_to_dentry
> >>      -> lookup_positive_unlocked
> >>        -> lookup_dcache
> >>          -> cifs_d_revalidate (dentry->d_op->d_revalidate)
> >>            -> cifs_revalidate_dentry
> >>              -> cifs_revalidate_dentry_attr
> >>                -> cifs_dentry_needs_reval
> >>                  -> open_cached_dir_by_dentry
> >>
> >>
> >> Anyway, thanks a lot for you patches, Paul.  Like I said, I'll be
> >> testing + reviewing them soon.
> >>
> >>
> >> Cheers,
> >>
> >> Enzo
> >>
> >> >On 2024-11-08 16:39:03 -0600, Steve French wrote:
> >> >>The perf improvement allowing caching of directories (helping "ls"
> >> >>then "ls" again for same dir) not just the perf improvement with "ls
> >> >>"then "stat" could be very important.
> >> >>
> >> >>Did this series also address Ralph's point about missing requesting
> >> >>"H" (handle caching) flag when requesting directory leases from the
> >> >>server?
> >> >>
> >> >>On Fri, Nov 8, 2024 at 4:35=E2=80=AFPM Paul Aurich <paul@darkrain42.=
org> wrote:
> >> >>>
> >> >>>The SMB client cached directory functionality has a few problems ar=
ound
> >> >>>flaky/lost server connections, which manifest as a pair of BUGs whe=
n
> >> >>>eventually unmounting the server connection:
> >> >>>
> >> >>>    [18645.013550] BUG: Dentry ffff888140590ba0{i=3D1000000000080,n=
=3D/}  still in use (2) [unmount of cifs cifs]
> >> >>>    [18645.789274] VFS: Busy inodes after unmount of cifs (cifs)
> >> >>>
> >> >>>Based on bisection, these issues started with the lease directory c=
ache
> >> >>>handling introduced in commit ebe98f1447bb ("cifs: enable caching o=
f
> >> >>>directories for which a lease is held"), and go away if I mount wit=
h
> >> >>>'nohandlecache'.  I started seeing these on Debian Bookworm stable =
kernel
> >> >>>(v6.1.x), but the issues persist even in current git versions.  I t=
hink the
> >> >>>situation was improved (occurrence frequency went down) with
> >> >>>commit 5c86919455c1 ("smb: client: fix use-after-free in
> >> >>>smb2_query_info_compound()").
> >> >>>
> >> >>>
> >> >>>I'm able to reproduce the "Dentry still in use" errors by connectin=
g to an
> >> >>>actively-used SMB share (the server organically generates lease bre=
aks) and
> >> >>>leaving these running for 'a while':
> >> >>>
> >> >>>- while true; do cd ~; sleep 1; for i in {1..3}; do cd /mnt/test/su=
bdir; echo $PWD; sleep 1; cd ..; echo $PWD; sleep 1; done; echo ...; done
> >> >>>- while true; do iptables -F OUTPUT; mount -t cifs -a; for _ in {0.=
.2}; do ls /mnt/test/subdir/ | wc -l; done; iptables -I OUTPUT -p tcp --dpo=
rt 445 -j DROP; sleep 10; echo "unmounting"; umount -l -t cifs -a; echo "do=
ne unmounting"; sleep 20; echo "recovering"; iptables -F OUTPUT; sleep 10; =
done
> >> >>>
> >> >>>('a while' is anywhere from 10 minutes to overnight. Also, it's not=
 the
> >> >>>cleanest reproducer, but I stopped iterating once I had something t=
hat was
> >> >>>even remotely reliable for me...)
> >> >>>
> >> >>>This series attempts to fix these, as well as a use-after-free that=
 could
> >> >>>occur because open_cached_dir() explicitly frees the cached_fid, ra=
ther than
> >> >>>relying on reference counting.
> >> >>>
> >> >>>
> >> >>>The last patch in this series (smb: During umount, flush any pendin=
g lease
> >> >>>breaks for cached dirs) is a work-in-progress, and should not be ta=
ken as-is.
> >> >>>The issue there:
> >> >>>
> >> >>>Unmounting an SMB share (cifs_kill_sb) can race with a queued lease=
 break from
> >> >>>the server for a cached directory.  When this happens, the cfid is =
removed
> >> >>>from the linked list, so close_all_cached_dirs() cannot drop the de=
ntry.  If
> >> >>>cifs_kill_sb continues on before the queued work puts the dentry, w=
e trigger
> >> >>>the "Dentry still in use" BUG splat.  Flushing the cifsiod_wq seems=
 to help
> >> >>>this, but some thoughts:
> >> >>>
> >> >>>1. cifsiod_wq is a global workqueue, rather than per-mount.  Flushi=
ng the
> >> >>>   entire workqueue is potentially doing more work that necessary. =
 Should
> >> >>>   there be a workqueue that's more appropriately scoped?
> >> >>>2. With an unresponsive server, this causes umount (even umount -l)=
 to hang
> >> >>>   (waiting for SMB2_close calls), and when I test with backports o=
n a 6.1
> >> >>>   kernel, appears to cause a deadlock between kill_sb and some cif=
s
> >> >>>   reconnection code calling iterate_supers_type.  (Pretty sure the=
 deadlock
> >> >>>   was addressed by changes to fs/super.c, so not really an SMB pro=
blem, but
> >> >>>   just an indication that flush_waitqueue isn't the right solution=
).
> >> >>>3. Should cached_dir_lease_break() drop the dentry before queueing =
work
> >> >>>   (and if so, is it OK to do this under the spinlock, or should th=
e spinlock
> >> >>>   be dropped first)?
> >> >>>4. Related to #3 -- shouldn't close_all_cached_dirs() be holding th=
e spinlock
> >> >>>   while looping?
> >> >>>
> >> >>>
> >> >>>Lastly, patches 2, 3, and 5 (in its final form) are beneficial goin=
g back to
> >> >>>v6.1 for stable, but it's not a clean backport because some other i=
mportant
> >> >>>fixes (commit 5c86919455c1 ("smb: client: fix use-after-free in
> >> >>>smb2_query_info_compound()") weren't picked up.
> >> >>>
> >> >>>Paul Aurich (5):
> >> >>>  smb: cached directories can be more than root file handle
> >> >>>  smb: Don't leak cfid when reconnect races with open_cached_dir
> >> >>>  smb: prevent use-after-free due to open_cached_dir error paths
> >> >>>  smb: No need to wait for work when cleaning up cached directories
> >> >>>  smb: During umount, flush any pending lease breaks for cached dir=
s
> >> >>>
> >> >>> fs/smb/client/cached_dir.c | 106 ++++++++++++++++-----------------=
----
> >> >>> 1 file changed, 47 insertions(+), 59 deletions(-)
> >> >>>
> >> >>>--
> >> >>>2.45.2
> >> >>>
> >> >>>
> >> >>
> >> >>
> >> >>--
> >> >>Thanks,
> >> >>
> >> >>Steve
> >> >
> >> >
> >
> >
> >
> >--
> >Thanks,
> >
> >Steve
> >
>


--
Thanks,

Steve
