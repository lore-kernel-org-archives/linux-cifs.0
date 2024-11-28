Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E3017BD5
	for <linux-cifs@vger.kernel.org>; Thu, 28 Nov 2024 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732803398; cv=none; b=d69JH+aphLejrEHeIjZWHkvUor8Ni3fjUgSOZzMyMQAkOqyjEsRVm28/xAnYSBfpQHFbz0yeqbwTgPvzUvCPE4M85XbfXvmMKBzG5bsJi74qQczlhANoIMnoUZnIKuZq9z67p3EtDU2Y6/0VyFrc2ekge9ALqEQGfDmlbfZ1PXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732803398; c=relaxed/simple;
	bh=5s9rrQ0ApaZ/NEXlnZXF36Fc2XFpySpBDNF0VtEefCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=hDTssTLcd8yMF412RHSdMvtOAPRI6mYxMCgPWRSsow/L/SlVkxCfCCMXooCY8H8VxOjZacqvyHFWX0M6251tkQol+wU8iA/N+SFelEANl5I4dl8sBPozv8ZkXdgjc7pC/HXS9mDZQgx97iSVN5oBuZXNkDIQeiQgCNLkFB8lDcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQ0klwQv; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQ0klwQv"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53de92be287so1306652e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 28 Nov 2024 06:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732803393; x=1733408193; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXVVt88v/zdvh9vuVnwHk9NS+stn8bXVKStYQfe6uIw=;
        b=PQ0klwQvJ+m6mYlWSKQUuv4+I844tKXw70PfZNULDqOvSOBywFo4yN1noi8wdvBSeE
         FceQl/f07HdKYSfipUkvJmbGpCdK38b7BkbPk8JUdRc9+fiHKUD1VuV3537+jf2RO9QS
         uG5JAiY1uqKorFlZ0S37hxS/sjce3xRb0z8I06RDNcq38Y4dNe7h4IUl1gCHSnhobHXN
         +Q1ItSVdRMP66msQFvbRuCcsghCJOCrQxhsGnkiZV0dtxkt4MbYFHY0zXsezbPNUgyMh
         STLK3jARG6Ce+pjye1UxPS9/IrHgFxViEWhAROL0abd3Ii21vq7nkdDyw84mIdNA8jd6
         qMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732803393; x=1733408193;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EXVVt88v/zdvh9vuVnwHk9NS+stn8bXVKStYQfe6uIw=;
        b=tzTdI6vGn5NGU94a6hg32AQJoPTNVaTYgoJ0iHfYfEKXNrgNnjPRLfsahKLp83FvP+
         Jtv6RxIY1+kjZWU3GSE5LMY2ub11/0WXGkZNs/gQy197s0mTrzCR/9JyA7UbSZ8AUy/h
         TqsiiMKUyyfnpCRRLgAXzhy2RH/NxvjWWQCvizfnYNVOeXg83brVh6zISHoDCrgj6wdP
         OEQgDdAZR0ykkSOVgfVFTlROmIqc8g9oPxmP1pKqRBQOgu8pL+yoSNyG9tty34ClI3pw
         KSwriBFRZ4qiPkVG5ttM2fcngptrBIvVHwrX7J6eiozcsPPpgzwe6pVRhtKRNBrNl7m5
         Qlvg==
X-Forwarded-Encrypted: i=1; AJvYcCWdQNWKdSaMlBVaHiit0222eRZkDcs2EjX5I+L+QMzm/jlosH1a2f8tKCx3j7jBy1DNBVZHoMis8t0U@vger.kernel.org
X-Gm-Message-State: AOJu0YyWVUpwNW9hXeeGb25S3Mvuf73tXpjbEkpetDvNOlCZsTyF5LSl
	jFhyCZmJQFRhrg/0T8noO1hcvTzqpxwdQRnZyqYHXd1oZ5Ka9vEU+5eIyFvz7SBFiIc2DTU9jLb
	cxtqmMbu4cYurIUg4+j6nc4N++FI=
X-Gm-Gg: ASbGncty37JBX+hs+1FixX4/vsg5hN6fitCHXNWIe4ZIw96A13m3v8jaKn/ob46135y
	zan3E9hFb2lcgtzg/yqSTnJRocBCZs3kOw7O/UtGlRnUFTsHOjewctE0IlmwQ0/x2
X-Google-Smtp-Source: AGHT+IG3Iccj16Rx8PBd1RhHfAeLfwNidUCfN7UteCwexsvQn7oc7lRBIW2xtafc6i+Y4LR3ijyo9r3wJgaPTR6bRpY=
X-Received: by 2002:a05:6512:2820:b0:539:8f3c:4586 with SMTP id
 2adb3069b0e04-53df01171camr6446224e87.55.1732803392596; Thu, 28 Nov 2024
 06:16:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118215028.1066662-1-paul@darkrain42.org> <20241118215028.1066662-5-paul@darkrain42.org>
 <2a818d91e9f3c392b2739a4c2a018085@manguebit.com> <Z0FL4kIUiCMFDVfe@vaarsuvius.home.arpa>
 <Z0Y_o2nH16BynCO5@haley.home.arpa> <CAH2r5ms8TmNZ+7DCY8RzUoL+v4Yhnu7BVh--H+PoYrdFDji5+g@mail.gmail.com>
 <CAH2r5mstxfPJE+KSRkjmCvQ_YvMdfNHHafkzbxrxan49WHPamA@mail.gmail.com> <CAH2r5mt8CRRc0nJ_t+wxSaC860cPwEufgfp2Qa1j233Dj=CHkQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt8CRRc0nJ_t+wxSaC860cPwEufgfp2Qa1j233Dj=CHkQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 28 Nov 2024 08:16:22 -0600
Message-ID: <CAH2r5msXKWK7_Q1Jizb_XTe4GLOU=_yv_rjLVVzLBWHbauQTsg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] smb: During unmount, ensure all cached dir
 instances drop their dentry
To: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The unmount crash also happens with mainline so not related to patches
in for-next

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/6/=
builds/128/steps/94/logs/stdio

On Wed, Nov 27, 2024 at 11:00=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> And also see it without patch "smb: During unmount, ensure all cached
> dir instances drop their dentry"
>
> On Wed, Nov 27, 2024 at 7:10=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > I see this error at the end of generic/241 (in dmesg) even without the
> > more recent dir lease patch:
> >
> > "smb: Initialize cfid->tcon before performing network ops"
> >
> > so it is likely unrelated (earlier bug)
> >
> >
> >
> > Nov 27 18:07:46 fedora29 kernel: Call Trace:
> > Nov 27 18:07:46 fedora29 kernel: <TASK>
> > Nov 27 18:07:46 fedora29 kernel: ? __warn+0xa9/0x220
> > Nov 27 18:07:46 fedora29 kernel: ? umount_check+0xc3/0xf0
> > Nov 27 18:07:46 fedora29 kernel: ? report_bug+0x1d4/0x1e0
> > Nov 27 18:07:46 fedora29 kernel: ? handle_bug+0x5b/0xa0
> > Nov 27 18:07:46 fedora29 kernel: ? exc_invalid_op+0x18/0x50
> > Nov 27 18:07:46 fedora29 kernel: ? asm_exc_invalid_op+0x1a/0x20
> > Nov 27 18:07:46 fedora29 kernel: ? irq_work_claim+0x1e/0x40
> > Nov 27 18:07:46 fedora29 kernel: ? umount_check+0xc3/0xf0
> > Nov 27 18:07:46 fedora29 kernel: ? __pfx_umount_check+0x10/0x10
> > Nov 27 18:07:46 fedora29 kernel: d_walk+0xf3/0x4e0
> > Nov 27 18:07:46 fedora29 kernel: ? d_walk+0x4b/0x4e0
> > Nov 27 18:07:46 fedora29 kernel: shrink_dcache_for_umount+0x6d/0x220
> > Nov 27 18:07:46 fedora29 kernel: generic_shutdown_super+0x4a/0x1c0
> > Nov 27 18:07:46 fedora29 kernel: kill_anon_super+0x22/0x40
> > Nov 27 18:07:46 fedora29 kernel: cifs_kill_sb+0x78/0x90 [cifs]
> >
> > On Wed, Nov 27, 2024 at 10:38=E2=80=AFAM Steve French <smfrench@gmail.c=
om> wrote:
> > >
> > > I did see the generic/241 failure again with current for-next
> > > (unrelated to this patch though).  Will try to repro it again - but
> > > any ideas how to narrow it down or fix it would be helpful.
> > >
> > > SECTION -- smb3
> > > FSTYP -- cifs
> > > PLATFORM -- Linux/x86_64 fedora29 6.12.0 #1 SMP PREEMPT_DYNAMIC Wed
> > > Nov 27 01:02:07 UTC 2024
> > > MKFS_OPTIONS -- //win16.vm.test/Scratch
> > > generic/241 73s
> > > Ran: generic/241
> > > Passed all 1 tests
> > > SECTION -- smb3
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > > Ran: generic/241
> > > Passed all 1 tests
> > > Number of reconnects: 0
> > > Test completed smb3 generic/241 at Wed Nov 27 06:38:47 AM UTC 2024
> > > dmesg output during the test:
> > > [Wed Nov 27 00:37:32 2024] CIFS: Attempting to mount //win16.vm.test/=
Share
> > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: generate_smb3signingkey: dumpin=
g
> > > generated AES session keys
> > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: Session Id 45 00 00 08 00 c8 00=
 00
> > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: Cipher type 2
> > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: Session Key 00 bf ed c7 f1 95 0=
e
> > > 29 06 e8 82 87 b5 c8 72 06
> > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: Signing Key a4 0f 15 64 d2 69 0=
2
> > > 2f 4e 78 60 7a fe 3e 31 4e
> > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: ServerIn Key a6 fd 04 f6 04 ea
> > > 0e 6e 60 c0 1b b1 ee 63 38 e9
> > > [Wed Nov 27 00:37:32 2024] CIFS: VFS: ServerOut Key a6 e3 e3 22 8c c2
> > > b0 6e b1 9d 40 ea d0 89 6d d8
> > > [Wed Nov 27 00:37:32 2024] CIFS: Attempting to mount //win16.vm.test/=
Scratch
> > > [Wed Nov 27 00:37:32 2024] CIFS: Attempting to mount //win16.vm.test/=
Scratch
> > > [Wed Nov 27 00:37:32 2024] run fstests generic/241 at 2024-11-27 00:3=
7:33
> > > [Wed Nov 27 00:38:46 2024] ------------[ cut here ]------------
> > > [Wed Nov 27 00:38:46 2024] BUG: Dentry
> > > 00000000318d67d4{i=3D11000000033f68,n=3D~dmtmp} still in use (1) [unm=
ount
> > > of cifs cifs]
> > > [Wed Nov 27 00:38:46 2024] WARNING: CPU: 2 PID: 316177 at
> > > fs/dcache.c:1546 umount_check+0xc3/0xf0
> > > [Wed Nov 27 00:38:46 2024] Modules linked in: cifs ccm cmac nls_utf8
> > > cifs_arc4 nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4
> > > dns_resolver nfs lockd grace netfs nf_conntrack_netbios_ns
> > > nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
> > > nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> > > nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat
> > > ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
> > > nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw
> > > iptable_security ip_set ebtable_filter ebtables ip6table_filter
> > > ip6_tables iptable_filter ip_tables sunrpc kvm_intel kvm virtio_net
> > > net_failover failover virtio_balloon loop fuse dm_multipath nfnetlink
> > > zram xfs bochs drm_client_lib drm_shmem_helper drm_kms_helper
> > > crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel drm
> > > sha512_ssse3 sha256_ssse3 sha1_ssse3 floppy virtio_blk qemu_fw_cfg
> > > virtio_console [last unloaded: cifs]
> > > [Wed Nov 27 00:38:46 2024] CPU: 2 UID: 0 PID: 316177 Comm: umount Not
> > > tainted 6.12.0 #1
> > > [Wed Nov 27 00:38:46 2024] Hardware name: Red Hat KVM, BIOS
> > > 1.16.3-2.el9 04/01/2014
> > > [Wed Nov 27 00:38:46 2024] RIP: 0010:umount_check+0xc3/0xf0
> > > [Wed Nov 27 00:38:46 2024] Code: db 74 0d 48 8d 7b 40 e8 db df f5 ff
> > > 48 8b 53 40 41 55 4d 89 f1 45 89 e0 48 89 e9 48 89 ee 48 c7 c7 80 99
> > > ba ad e8 2d 27 a2 ff <0f> 0b 58 31 c0 5b 5d 41 5c 41 5d 41 5e c3 cc c=
c
> > > cc cc 41 83 fc 01
> > > [Wed Nov 27 00:38:46 2024] RSP: 0018:ff1100012197fd20 EFLAGS: 0001028=
2
> > > [Wed Nov 27 00:38:46 2024] RAX: dffffc0000000000 RBX: ff1100010c574ce=
0
> > > RCX: 0000000000000027
> > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000027 RSI: 000000000000000=
4
> > > RDI: ff110004cb131a48
> > > [Wed Nov 27 00:38:46 2024] RBP: ff1100012c76bd60 R08: ffffffffac3fd2f=
e
> > > R09: ffe21c0099626349
> > > [Wed Nov 27 00:38:46 2024] R10: ff110004cb131a4b R11: 000000000000000=
1
> > > R12: 0000000000000001
> > > [Wed Nov 27 00:38:46 2024] R13: ff110001238b6668 R14: ffffffffc1d6e6c=
0
> > > R15: ff1100012c76be18
> > > [Wed Nov 27 00:38:46 2024] FS: 00007fddc1dcc800(0000)
> > > GS:ff110004cb100000(0000) knlGS:0000000000000000
> > > [Wed Nov 27 00:38:46 2024] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080=
050033
> > > [Wed Nov 27 00:38:46 2024] CR2: 00007fc6440095d0 CR3: 000000014214600=
5
> > > CR4: 0000000000373ef0
> > > [Wed Nov 27 00:38:46 2024] DR0: 0000000000000000 DR1: 000000000000000=
0
> > > DR2: 0000000000000000
> > > [Wed Nov 27 00:38:46 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff=
0
> > > DR7: 0000000000000400
> > > [Wed Nov 27 00:38:46 2024] Call Trace:
> > > [Wed Nov 27 00:38:46 2024] <TASK>
> > > [Wed Nov 27 00:38:46 2024] ? __warn+0xa9/0x220
> > > [Wed Nov 27 00:38:46 2024] ? umount_check+0xc3/0xf0
> > > [Wed Nov 27 00:38:46 2024] ? report_bug+0x1d4/0x1e0
> > > [Wed Nov 27 00:38:46 2024] ? handle_bug+0x5b/0xa0
> > > [Wed Nov 27 00:38:46 2024] ? exc_invalid_op+0x18/0x50
> > > [Wed Nov 27 00:38:46 2024] ? asm_exc_invalid_op+0x1a/0x20
> > > [Wed Nov 27 00:38:46 2024] ? irq_work_claim+0x1e/0x40
> > > [Wed Nov 27 00:38:46 2024] ? umount_check+0xc3/0xf0
> > > [Wed Nov 27 00:38:46 2024] ? __pfx_umount_check+0x10/0x10
> > > [Wed Nov 27 00:38:46 2024] d_walk+0xf3/0x4e0
> > > [Wed Nov 27 00:38:46 2024] ? d_walk+0x4b/0x4e0
> > > [Wed Nov 27 00:38:46 2024] shrink_dcache_for_umount+0x6d/0x220
> > > [Wed Nov 27 00:38:46 2024] generic_shutdown_super+0x4a/0x1c0
> > > [Wed Nov 27 00:38:46 2024] kill_anon_super+0x22/0x40
> > > [Wed Nov 27 00:38:46 2024] cifs_kill_sb+0x78/0x90 [cifs]
> > > [Wed Nov 27 00:38:46 2024] deactivate_locked_super+0x69/0xf0
> > > [Wed Nov 27 00:38:46 2024] cleanup_mnt+0x195/0x200
> > > [Wed Nov 27 00:38:46 2024] task_work_run+0xec/0x150
> > > [Wed Nov 27 00:38:46 2024] ? __pfx_task_work_run+0x10/0x10
> > > [Wed Nov 27 00:38:46 2024] ? mark_held_locks+0x24/0x90
> > > [Wed Nov 27 00:38:46 2024] syscall_exit_to_user_mode+0x269/0x2a0
> > > [Wed Nov 27 00:38:46 2024] do_syscall_64+0x81/0x180
> > > [Wed Nov 27 00:38:46 2024] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > [Wed Nov 27 00:38:46 2024] RIP: 0033:0x7fddc1ff43eb
> > > [Wed Nov 27 00:38:46 2024] Code: c3 66 2e 0f 1f 84 00 00 00 00 00 0f
> > > 1f 40 00 f3 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa
> > > b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 1=
5
> > > f9 a9 0c 00 f7 d8
> > > [Wed Nov 27 00:38:46 2024] RSP: 002b:00007ffe64be88d8 EFLAGS: 0000024=
6
> > > ORIG_RAX: 00000000000000a6
> > > [Wed Nov 27 00:38:46 2024] RAX: 0000000000000000 RBX: 00005632106d4c2=
0
> > > RCX: 00007fddc1ff43eb
> > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000000 RSI: 000000000000000=
0
> > > RDI: 00005632106d9410
> > > [Wed Nov 27 00:38:46 2024] RBP: 00007ffe64be89b0 R08: 00005632106d401=
0
> > > R09: 0000000000000007
> > > [Wed Nov 27 00:38:46 2024] R10: 0000000000000000 R11: 000000000000024=
6
> > > R12: 00005632106d4d28
> > > [Wed Nov 27 00:38:46 2024] R13: 0000000000000000 R14: 00005632106d941=
0
> > > R15: 00005632106d5030
> > > [Wed Nov 27 00:38:46 2024] </TASK>
> > > [Wed Nov 27 00:38:46 2024] irq event stamp: 8317
> > > [Wed Nov 27 00:38:46 2024] hardirqs last enabled at (8323):
> > > [<ffffffffac230dce>] __up_console_sem+0x5e/0x70
> > > [Wed Nov 27 00:38:46 2024] hardirqs last disabled at (8328):
> > > [<ffffffffac230db3>] __up_console_sem+0x43/0x70
> > > [Wed Nov 27 00:38:46 2024] softirqs last enabled at (6628):
> > > [<ffffffffac135745>] __irq_exit_rcu+0x135/0x160
> > > [Wed Nov 27 00:38:46 2024] softirqs last disabled at (6539):
> > > [<ffffffffac135745>] __irq_exit_rcu+0x135/0x160
> > > [Wed Nov 27 00:38:46 2024] ---[ end trace 0000000000000000 ]---
> > > [Wed Nov 27 00:38:46 2024] VFS: Busy inodes after unmount of cifs (ci=
fs)
> > > [Wed Nov 27 00:38:46 2024] ------------[ cut here ]------------
> > > [Wed Nov 27 00:38:46 2024] kernel BUG at fs/super.c:650!
> > > [Wed Nov 27 00:38:46 2024] Oops: invalid opcode: 0000 [#1] PREEMPT SM=
P
> > > KASAN NOPTI
> > > [Wed Nov 27 00:38:46 2024] CPU: 2 UID: 0 PID: 316177 Comm: umount
> > > Tainted: G W 6.12.0 #1
> > > [Wed Nov 27 00:38:46 2024] Tainted: [W]=3DWARN
> > > [Wed Nov 27 00:38:46 2024] Hardware name: Red Hat KVM, BIOS
> > > 1.16.3-2.el9 04/01/2014
> > > [Wed Nov 27 00:38:46 2024] RIP: 0010:generic_shutdown_super+0x1b7/0x1=
c0
> > > [Wed Nov 27 00:38:46 2024] Code: 7b 28 e8 5c ca f8 ff 48 8b 6b 28 48
> > > 89 ef e8 50 ca f8 ff 48 8b 55 00 48 8d b3 68 06 00 00 48 c7 c7 e0 38
> > > ba ad e8 d9 c1 b5 ff <0f> 0b 0f 1f 80 00 00 00 00 90 90 90 90 90 90 9=
0
> > > 90 90 90 90 90 90
> > > [Wed Nov 27 00:38:46 2024] RSP: 0018:ff1100012197fdf0 EFLAGS: 0001028=
2
> > > [Wed Nov 27 00:38:46 2024] RAX: 000000000000002d RBX: ff110001238b600=
0
> > > RCX: 0000000000000027
> > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000027 RSI: 000000000000000=
4
> > > RDI: ff110004cb131a48
> > > [Wed Nov 27 00:38:46 2024] RBP: ffffffffc1c6ac00 R08: ffffffffac3fd2f=
e
> > > R09: ffe21c0099626349
> > > [Wed Nov 27 00:38:46 2024] R10: ff110004cb131a4b R11: 000000000000000=
1
> > > R12: ff110001238b69c0
> > > [Wed Nov 27 00:38:46 2024] R13: ff110001238b6780 R14: 1fe220002432ffd=
4
> > > R15: 0000000000000000
> > > [Wed Nov 27 00:38:46 2024] FS: 00007fddc1dcc800(0000)
> > > GS:ff110004cb100000(0000) knlGS:0000000000000000
> > > [Wed Nov 27 00:38:46 2024] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080=
050033
> > > [Wed Nov 27 00:38:46 2024] CR2: 00007fc6440095d0 CR3: 000000014214600=
5
> > > CR4: 0000000000373ef0
> > > [Wed Nov 27 00:38:46 2024] DR0: 0000000000000000 DR1: 000000000000000=
0
> > > DR2: 0000000000000000
> > > [Wed Nov 27 00:38:46 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff=
0
> > > DR7: 0000000000000400
> > > [Wed Nov 27 00:38:46 2024] Call Trace:
> > > [Wed Nov 27 00:38:46 2024] <TASK>
> > > [Wed Nov 27 00:38:46 2024] ? die+0x37/0x90
> > > [Wed Nov 27 00:38:46 2024] ? do_trap+0x133/0x230
> > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > [Wed Nov 27 00:38:46 2024] ? do_error_trap+0x94/0x130
> > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > [Wed Nov 27 00:38:46 2024] ? handle_invalid_op+0x2c/0x40
> > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > [Wed Nov 27 00:38:46 2024] ? exc_invalid_op+0x2f/0x50
> > > [Wed Nov 27 00:38:46 2024] ? asm_exc_invalid_op+0x1a/0x20
> > > [Wed Nov 27 00:38:46 2024] ? irq_work_claim+0x1e/0x40
> > > [Wed Nov 27 00:38:46 2024] ? generic_shutdown_super+0x1b7/0x1c0
> > > [Wed Nov 27 00:38:46 2024] kill_anon_super+0x22/0x40
> > > [Wed Nov 27 00:38:46 2024] cifs_kill_sb+0x78/0x90 [cifs]
> > > [Wed Nov 27 00:38:46 2024] deactivate_locked_super+0x69/0xf0
> > > [Wed Nov 27 00:38:46 2024] cleanup_mnt+0x195/0x200
> > > [Wed Nov 27 00:38:46 2024] task_work_run+0xec/0x150
> > > [Wed Nov 27 00:38:46 2024] ? __pfx_task_work_run+0x10/0x10
> > > [Wed Nov 27 00:38:46 2024] ? mark_held_locks+0x24/0x90
> > > [Wed Nov 27 00:38:46 2024] syscall_exit_to_user_mode+0x269/0x2a0
> > > [Wed Nov 27 00:38:46 2024] do_syscall_64+0x81/0x180
> > > [Wed Nov 27 00:38:46 2024] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > [Wed Nov 27 00:38:46 2024] RIP: 0033:0x7fddc1ff43eb
> > > [Wed Nov 27 00:38:46 2024] Code: c3 66 2e 0f 1f 84 00 00 00 00 00 0f
> > > 1f 40 00 f3 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa
> > > b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 1=
5
> > > f9 a9 0c 00 f7 d8
> > > [Wed Nov 27 00:38:46 2024] RSP: 002b:00007ffe64be88d8 EFLAGS: 0000024=
6
> > > ORIG_RAX: 00000000000000a6
> > > [Wed Nov 27 00:38:46 2024] RAX: 0000000000000000 RBX: 00005632106d4c2=
0
> > > RCX: 00007fddc1ff43eb
> > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000000 RSI: 000000000000000=
0
> > > RDI: 00005632106d9410
> > > [Wed Nov 27 00:38:46 2024] RBP: 00007ffe64be89b0 R08: 00005632106d401=
0
> > > R09: 0000000000000007
> > > [Wed Nov 27 00:38:46 2024] R10: 0000000000000000 R11: 000000000000024=
6
> > > R12: 00005632106d4d28
> > > [Wed Nov 27 00:38:46 2024] R13: 0000000000000000 R14: 00005632106d941=
0
> > > R15: 00005632106d5030
> > > [Wed Nov 27 00:38:46 2024] </TASK>
> > > [Wed Nov 27 00:38:46 2024] Modules linked in: cifs ccm cmac nls_utf8
> > > cifs_arc4 nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4
> > > dns_resolver nfs lockd grace netfs nf_conntrack_netbios_ns
> > > nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
> > > nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> > > nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat
> > > ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
> > > nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw
> > > iptable_security ip_set ebtable_filter ebtables ip6table_filter
> > > ip6_tables iptable_filter ip_tables sunrpc kvm_intel kvm virtio_net
> > > net_failover failover virtio_balloon loop fuse dm_multipath nfnetlink
> > > zram xfs bochs drm_client_lib drm_shmem_helper drm_kms_helper
> > > crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel drm
> > > sha512_ssse3 sha256_ssse3 sha1_ssse3 floppy virtio_blk qemu_fw_cfg
> > > virtio_console [last unloaded: cifs]
> > > [Wed Nov 27 00:38:46 2024] ---[ end trace 0000000000000000 ]---
> > > [Wed Nov 27 00:38:46 2024] RIP: 0010:generic_shutdown_super+0x1b7/0x1=
c0
> > > [Wed Nov 27 00:38:46 2024] Code: 7b 28 e8 5c ca f8 ff 48 8b 6b 28 48
> > > 89 ef e8 50 ca f8 ff 48 8b 55 00 48 8d b3 68 06 00 00 48 c7 c7 e0 38
> > > ba ad e8 d9 c1 b5 ff <0f> 0b 0f 1f 80 00 00 00 00 90 90 90 90 90 90 9=
0
> > > 90 90 90 90 90 90
> > > [Wed Nov 27 00:38:46 2024] RSP: 0018:ff1100012197fdf0 EFLAGS: 0001028=
2
> > > [Wed Nov 27 00:38:46 2024] RAX: 000000000000002d RBX: ff110001238b600=
0
> > > RCX: 0000000000000027
> > > [Wed Nov 27 00:38:46 2024] RDX: 0000000000000027 RSI: 000000000000000=
4
> > > RDI: ff110004cb131a48
> > > [Wed Nov 27 00:38:46 2024] RBP: ffffffffc1c6ac00 R08: ffffffffac3fd2f=
e
> > > R09: ffe21c0099626349
> > > [Wed Nov 27 00:38:46 2024] R10: ff110004cb131a4b R11: 000000000000000=
1
> > > R12: ff110001238b69c0
> > > [Wed Nov 27 00:38:46 2024] R13: ff110001238b6780 R14: 1fe220002432ffd=
4
> > > R15: 0000000000000000
> > > [Wed Nov 27 00:38:46 2024] FS: 00007fddc1dcc800(0000)
> > > GS:ff110004cb100000(0000) knlGS:0000000000000000
> > > [Wed Nov 27 00:38:46 2024] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080=
050033
> > > [Wed Nov 27 00:38:46 2024] CR2: 00007fc6440095d0 CR3: 000000014214600=
5
> > > CR4: 0000000000373ef0
> > > [Wed Nov 27 00:38:46 2024] DR0: 0000000000000000 DR1: 000000000000000=
0
> > > DR2: 0000000000000000
> > > [Wed Nov 27 00:38:46 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff=
0
> > > DR7: 0000000000000400
> > >
> > > On Tue, Nov 26, 2024 at 3:50=E2=80=AFPM Paul Aurich <paul@darkrain42.=
org> wrote:
> > > >
> > > > On 2024-11-22 19:28:34 -0800, Paul Aurich wrote:
> > > > >On 2024-11-21 23:05:51 -0300, Paulo Alcantara wrote:
> > > > >>Hi Paul,
> > > > >>
> > > > >>Thanks for looking into this!  Really appreciate it.
> > > > >>
> > > > >>Paul Aurich <paul@darkrain42.org> writes:
> > > > >>
> > > > >>>The unmount process (cifs_kill_sb() calling close_all_cached_dir=
s()) can
> > > > >>>race with various cached directory operations, which ultimately =
results
> > > > >>>in dentries not being dropped and these kernel BUGs:
> > > > >>>
> > > > >>>BUG: Dentry ffff88814f37e358{i=3D1000000000080,n=3D/}  still in =
use (2) [unmount of cifs cifs]
> > > > >>>VFS: Busy inodes after unmount of cifs (cifs)
> > > > >>>------------[ cut here ]------------
> > > > >>>kernel BUG at fs/super.c:661!
> > > > >>>
> > > > >>>This happens when a cfid is in the process of being cleaned up w=
hen, and
> > > > >>>has been removed from the cfids->entries list, including:
> > > > >>>
> > > > >>>- Receiving a lease break from the server
> > > > >>>- Server reconnection triggers invalidate_all_cached_dirs(), whi=
ch
> > > > >>>  removes all the cfids from the list
> > > > >>>- The laundromat thread decides to expire an old cfid.
> > > > >>>
> > > > >>>To solve these problems, dropping the dentry is done in queued w=
ork done
> > > > >>>in a newly-added cfid_put_wq workqueue, and close_all_cached_dir=
s()
> > > > >>>flushes that workqueue after it drops all the dentries of which =
it's
> > > > >>>aware. This is a global workqueue (rather than scoped to a mount=
), but
> > > > >>>the queued work is minimal.
> > > > >>
> > > > >>Why does it need to be a global workqueue?  Can't you make it per=
 tcon?
> > > > >
> > > > >The problem with a per-tcon workqueue is I didn't see clean way to
> > > > >deal with multiuser mounts and flushing the workqueue in
> > > > >close_all_cached_dirs() -- when dealing with each individual tcon,
> > > > >we're still holding tlink_tree_lock, so an arbitrary sleep seems
> > > > >problematic.
> > > > >
> > > > >There could be a per-sb workqueue (stored in cifs_sb or the master
> > > > >tcon) but is there a way to get back to the superblock / master tc=
on
> > > > >with just a tcon (e.g. cached_dir_lease_break, when processing a l=
ease
> > > > >break)?
> > > > >
> > > > >>>The final cleanup work for cleaning up a cfid is performed via w=
ork
> > > > >>>queued in the serverclose_wq workqueue; this is done separate fr=
om
> > > > >>>dropping the dentries so that close_all_cached_dirs() doesn't bl=
ock on
> > > > >>>any server operations.
> > > > >>>
> > > > >>>Both of these queued works expect to invoked with a cfid referen=
ce and
> > > > >>>a tcon reference to avoid those objects from being freed while t=
he work
> > > > >>>is ongoing.
> > > > >>
> > > > >>Why do you need to take a tcon reference?
> > > > >
> > > > >In the existing code (and my patch, without the refs), I was seein=
g an
> > > > >intermittent use-after-free of the tcon or cached_fids struct by
> > > > >queued work processing a lease break -- the cfid isn't linked from
> > > > >cached_fids, but smb2_close_cached_fid invoking SMB2_close can rac=
e
> > > > >with the unmount and cifs_put_tcon
> > > > >
> > > > >Something like:
> > > > >
> > > > >    t1                              t2
> > > > >cached_dir_lease_break
> > > > >smb2_cached_lease_break
> > > > >smb2_close_cached_fid
> > > > >SMB2_close starts
> > > > >                                    cifs_kill_sb
> > > > >                                    cifs_umount
> > > > >                                    cifs_put_link
> > > > >                                    cifs_put_tcon
> > > > >SMB2_close continues
> > > > >
> > > > >I had a version of the patch that kept the 'in flight lease breaks=
' on
> > > > >a second list in cached_fids so that they could be cancelled
> > > > >synchronously from free_cached_fids(), but I struggled with it (I
> > > > >can't remember exactly, but I think I was struggling to get the li=
nked
> > > > >list membership / removal handling and num_entries handling
> > > > >consistent).
> > > > >
> > > > >>Can't you drop the dentries
> > > > >>when tearing down tcon in cifs_put_tcon()?  No concurrent mounts =
would
> > > > >>be able to access or free it.
> > > > >
> > > > >The dentries being dropped must occur before kill_anon_super(), as
> > > > >that's where the 'Dentry still in use' check is. All the tcons are=
 put
> > > > >in cifs_umount(), which occurs after:
> > > > >
> > > > >    kill_anon_super(sb);
> > > > >    cifs_umount(cifs_sb);
> > > > >
> > > > >The other thing is that cifs_umount_begin() has this comment, whic=
h
> > > > >made me think a tcon can actually be tied to two distinct mount
> > > > >points:
> > > > >
> > > > >        if ((tcon->tc_count > 1) || (tcon->status =3D=3D TID_EXITI=
NG)) {
> > > > >                /* we have other mounts to same share or we have
> > > > >                   already tried to umount this and woken up
> > > > >                   all waiting network requests, nothing to do */
> > > > >
> > > > >Although, as I'm thinking about it again, I think I've misundersto=
od
> > > > >(and that comment is wrong?).
> > > > >
> > > > >It did cross my mind to pull some of the work out of cifs_umount i=
nto
> > > > >cifs_kill_sb (specifically, I wanted to cancel prune_tlinks earlie=
r)
> > > > >-- no prune_tlinks would make it more feasible to drop tlink_tree_=
lock
> > > > >in close_all_cached_dirs(), at which point a per-tcon workqueue is
> > > > >more practical.
> > > > >
> > > > >>After running xfstests I've seen a leaked tcon in
> > > > >>/proc/fs/cifs/DebugData with no CIFS superblocks, which might be =
related
> > > > >>to this.
> > > > >>
> > > > >>Could you please check if there is any leaked connection in
> > > > >>/proc/fs/cifs/DebugData after running your tests?
> > > > >
> > > > >After I finish with my tests (I'm not using xfstests, although per=
haps
> > > > >I should be) and unmount the share, DebugData doesn't show any
> > > > >connections for me.
> > > >
> > > > I was able to reproduce this leak.  I believe the attached patch ad=
dresses it.
> > > >
> > > > I'm able to intermittently see a 'Dentry still in use' bug with xfs=
tests
> > > > generic/241 (what Steve saw) (the attached patch doesn't help with =
that). I'm
> > > > still unsure what's going on there.
> > > >
> > > > >~Paul
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
