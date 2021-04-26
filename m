Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7321AC433B4
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 22:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7F961152
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 22:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhDZWgv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Apr 2021 18:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbhDZWgv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Apr 2021 18:36:51 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6C0C061574
        for <linux-cifs@vger.kernel.org>; Mon, 26 Apr 2021 15:36:07 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id b38so24844776ljf.5
        for <linux-cifs@vger.kernel.org>; Mon, 26 Apr 2021 15:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1yUvMExcek1MS07amupI3aOWo8sC/lDQux+5J3T4y7A=;
        b=m1q/Zt3x7WKQVHV8kN/qTO1GpETAY29DhhjwtYVd2PDIthqnXG8fxdzFJqxcVcTHkU
         oIMgyedlvy1XEVn3F0aSYFkY9VcIcFWUU9PflY5lrvzAjdGcskAPJHa82Tz8+h7kMd1H
         w3yixCGPp+x29GaqVrhKiRcmigkl9l/OqsB3fQ95s0+FfHLXRA6LGCWVcvRgN8EyfXop
         2Kt+SwQGIVkduo58hjqHPyobISCPGCCYnYqMkuxmIXY+OWxa4NQ0a/tsYzu+NrD2pwtl
         iOQ38FnYS0KNHAtndppIbDKaptBulYvXSt6uGBiPTtIsrydBlZUyz0K6PNHpg6bY2wLX
         oGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1yUvMExcek1MS07amupI3aOWo8sC/lDQux+5J3T4y7A=;
        b=n4p24zC+W4qgu+fGJfuTStPQPC8B6QYJX7OZ0ClGB2RN8TnT85hBqn9FRQeSb7Ebm9
         4JxQOP/Vxvc8naXUiScXZsj5xhPmewIF+pGAZrDlvazTLJgNRgjLD1QUy8nTlxbgegbv
         HuqYhg66JK0j1ajm0yCk0hRfjZk3iGl3MoxM3VH72E6RNsto1r0FQQpBCE/2wdu4TkzW
         yVmbgqEAisOxh6licf6ZyTO9/Ug4WjPWtFjkE2nF5vjYX1yQMUZZF1NNtMF/bZYXzNAp
         KXPjszi2SrPxBVt0JdyWzPaI2+lB3zVLlOp0RZMyH1Yt0Cnvral5toJWwaHM/9HXKFLP
         GvNw==
X-Gm-Message-State: AOAM5301OO+6QgQqEin/EvnuXp20BHOI2WIi0aanA5mTKqt9YFyl8yrH
        fDramXwC/QBXlyI/5NpAl6Dtao30KxD/GEsRP0mKN6Z/LNA=
X-Google-Smtp-Source: ABdhPJxklH2vc9iFgF9Aq/Gr+IIAjdnWb9ajnEJ+JoCtpQXwmg1VupRqU32suas+CtIebErptiRg5mA+iHt0FG3NewY=
X-Received: by 2002:a2e:2e19:: with SMTP id u25mr14908641lju.487.1619476565432;
 Mon, 26 Apr 2021 15:36:05 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Apr 2021 17:35:54 -0500
Message-ID: <CAH2r5mtfw9siVqpj4Zu3ayvo-4s+ka90y3fn5EFYLnBK6psReA@mail.gmail.com>
Subject: oops running test 130
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was running various xfstests against Windows server target and saw
these messages in dmesg (presumably triggered by the unmount at the
end of the test, xfstest generic/130).  Ideas?

[ 1967.512898] ------------[ cut here ]------------
[ 1967.512902] refcount_t: addition on 0; use-after-free.
[ 1967.512937] WARNING: CPU: 4 PID: 8914 at lib/refcount.c:25
refcount_warn_saturate+0xcf/0xf0
[ 1967.512944] Modules linked in: md4 cmac nls_utf8 cifs libarc4
libdes rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace
fscache nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ebtable_nat ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat iptable_mangle iptable_raw
iptable_security nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set
nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter sunrpc crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel virtio_balloon ip_tables xfs qxl drm_ttm_helper
ttm drm_kms_helper cec drm virtio_net crc32c_intel virtio_blk
net_failover virtio_console failover floppy qemu_fw_cfg
[ 1967.512989] CPU: 4 PID: 8914 Comm: 130 Not tainted 5.12.0 #1
[ 1967.512992] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 1967.512993] RIP: 0010:refcount_warn_saturate+0xcf/0xf0
[ 1967.512996] Code: 01 01 e8 c4 4f ac ff 0f 0b c3 80 3d 1c 8f 2e 01
00 0f 85 6b ff ff ff 48 c7 c7 80 2c 39 bc c6 05 08 8f 2e 01 01 e8 a1
4f ac ff <0f> 0b c3 48 c7 c7 58 2c 39 bc c6 05 f3 8e 2e 01 01 e8 8b 4f
ac ff
[ 1967.512998] RSP: 0018:ffffab3880e33c48 EFLAGS: 00010292
[ 1967.513000] RAX: 000000000000002a RBX: ffff90730a81d800 RCX: 0000000000000027
[ 1967.513002] RDX: 0000000000000000 RSI: ffff90772bd185c0 RDI: ffff90772bd185c8
[ 1967.513003] RBP: ffff90730a81def8 R08: 0000000000000000 R09: 0000000000000001
[ 1967.513005] R10: 0000000000000002 R11: ffffab3880e33a58 R12: ffff907301e730c0
[ 1967.513006] R13: ffffab3880e33c78 R14: ffffab3880e33ef4 R15: ffff90730b7b1c00
[ 1967.513011] FS:  00007fbbd10df740(0000) GS:ffff90772bd00000(0000)
knlGS:0000000000000000
[ 1967.513013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1967.513014] CR2: 000055d19e5a448c CR3: 000000010ad60003 CR4: 00000000003706e0
[ 1967.513029] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1967.513030] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1967.513032] Call Trace:
[ 1967.513069]  open_cached_dir_by_dentry+0xc2/0xe0 [cifs]
[ 1967.513142]  cifs_dentry_needs_reval+0x6e/0x160 [cifs]
[ 1967.513173]  cifs_revalidate_dentry_attr+0x30/0x340 [cifs]
[ 1967.513201]  cifs_revalidate_dentry+0xf/0x20 [cifs]
[ 1967.513376]  cifs_d_revalidate+0x50/0x130 [cifs]
[ 1967.513408]  path_openat+0x794/0xff0
[ 1967.513412]  ? __bitmap_andnot+0x26/0x70
[ 1967.513415]  do_filp_open+0xa2/0x100
[ 1967.513419]  ? __check_heap_object+0x5c/0x140
[ 1967.513421]  ? __check_object_size+0xd4/0x1a0
[ 1967.513425]  ? alloc_fd+0xba/0x180
[ 1967.513429]  ? do_sys_openat2+0x248/0x310
[ 1967.513432]  do_sys_openat2+0x248/0x310
[ 1967.513435]  do_sys_open+0x47/0x60
[ 1967.513438]  do_syscall_64+0x33/0x40
[ 1967.513443]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1967.513446] RIP: 0033:0x7fbbd11cfb82
[ 1967.513449] Code: 25 00 00 41 00 3d 00 00 41 00 74 4c 48 8d 05 a5
7b 0d 00 8b 00 85 c0 75 6d 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff
ff 0f 05 <48> 3d 00 f0 ff ff 0f 87 a2 00 00 00 48 8b 4c 24 28 64 48 33
0c 25
[ 1967.513451] RSP: 002b:00007ffc5a4f5b10 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ 1967.513453] RAX: ffffffffffffffda RBX: 000055d19e5b81f0 RCX: 00007fbbd11cfb82
[ 1967.513455] RDX: 0000000000000241 RSI: 000055d19e7de710 RDI: 00000000ffffff9c
[ 1967.513456] RBP: 00007ffc5a4f5c10 R08: 0000000000000020 R09: 0000000000000006
[ 1967.513458] R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000000
[ 1967.513459] R13: 0000000000000003 R14: 0000000000000001 R15: 000055d19e7de710
[ 1967.513462] ---[ end trace b96ccc5cc434f1d0 ]---
[ 1967.513464] ------------[ cut here ]------------
[ 1967.513465] refcount_t: underflow; use-after-free.
[ 1967.513495] WARNING: CPU: 4 PID: 8914 at lib/refcount.c:28
refcount_warn_saturate+0x8d/0xf0
[ 1967.513500] Modules linked in: md4 cmac nls_utf8 cifs libarc4
libdes rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace
fscache nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ebtable_nat ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat iptable_mangle iptable_raw
iptable_security nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set
nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter sunrpc crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel virtio_balloon ip_tables xfs qxl drm_ttm_helper
ttm drm_kms_helper cec drm virtio_net crc32c_intel virtio_blk
net_failover virtio_console failover floppy qemu_fw_cfg
[ 1967.513557] CPU: 4 PID: 8914 Comm: 130 Tainted: G        W         5.12.0 #1
[ 1967.513559] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 1967.513560] RIP: 0010:refcount_warn_saturate+0x8d/0xf0
[ 1967.513562] Code: 05 66 8f 2e 01 01 e8 02 50 ac ff 0f 0b c3 80 3d
59 8f 2e 01 00 75 ad 48 c7 c7 b0 2c 39 bc c6 05 49 8f 2e 01 01 e8 e3
4f ac ff <0f> 0b c3 80 3d 3d 8f 2e 01 00 75 8e 48 c7 c7 58 2c 39 bc c6
05 2d
[ 1967.513565] RSP: 0018:ffffab3880e33c58 EFLAGS: 00010296
[ 1967.513566] RAX: 0000000000000026 RBX: ffff90730a81ded8 RCX: 0000000000000027
[ 1967.513568] RDX: 0000000000000000 RSI: ffff90772bd185c0 RDI: ffff90772bd185c8
[ 1967.513569] RBP: ffff90730a81def8 R08: 0000000000000000 R09: 0000000000000001
[ 1967.513570] R10: 0000000000000002 R11: ffffab3880e33a68 R12: ffff907301eb9300
[ 1967.513572] R13: 0000000000000000 R14: ffffab3880e33ef4 R15: ffff90730b7b1c00
[ 1967.513576] FS:  00007fbbd10df740(0000) GS:ffff90772bd00000(0000)
knlGS:0000000000000000
[ 1967.513578] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1967.513579] CR2: 000055d19e5a448c CR3: 000000010ad60003 CR4: 00000000003706e0
[ 1967.513590] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1967.513592] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1967.513593] Call Trace:
[ 1967.513597]  close_cached_dir+0x50/0x60 [cifs]
[ 1967.513637]  cifs_dentry_needs_reval+0x151/0x160 [cifs]
[ 1967.513669]  cifs_revalidate_dentry_attr+0x30/0x340 [cifs]
[ 1967.513699]  cifs_revalidate_dentry+0xf/0x20 [cifs]
[ 1967.513727]  cifs_d_revalidate+0x50/0x130 [cifs]
[ 1967.513784]  path_openat+0x794/0xff0
[ 1967.513787]  ? __bitmap_andnot+0x26/0x70
[ 1967.513790]  do_filp_open+0xa2/0x100
[ 1967.513793]  ? __check_heap_object+0x5c/0x140
[ 1967.513795]  ? __check_object_size+0xd4/0x1a0
[ 1967.513798]  ? alloc_fd+0xba/0x180
[ 1967.513801]  ? do_sys_openat2+0x248/0x310
[ 1967.513804]  do_sys_openat2+0x248/0x310
[ 1967.513807]  do_sys_open+0x47/0x60
[ 1967.513810]  do_syscall_64+0x33/0x40
[ 1967.513813]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1967.513816] RIP: 0033:0x7fbbd11cfb82
[ 1967.513818] Code: 25 00 00 41 00 3d 00 00 41 00 74 4c 48 8d 05 a5
7b 0d 00 8b 00 85 c0 75 6d 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff
ff 0f 05 <48> 3d 00 f0 ff ff 0f 87 a2 00 00 00 48 8b 4c 24 28 64 48 33
0c 25
[ 1967.513820] RSP: 002b:00007ffc5a4f5b10 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ 1967.513822] RAX: ffffffffffffffda RBX: 000055d19e5b81f0 RCX: 00007fbbd11cfb82
[ 1967.513823] RDX: 0000000000000241 RSI: 000055d19e7de710 RDI: 00000000ffffff9c
[ 1967.513825] RBP: 00007ffc5a4f5c10 R08: 0000000000000020 R09: 0000000000000006
[ 1967.513826] R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000000
[ 1967.513828] R13: 0000000000000003 R14: 0000000000000001 R15: 000055d19e7de710
[ 1967.513830] ---[ end trace b96ccc5cc434f1d1 ]---
[ 1967.668927] ------------[ cut here ]------------
[ 1967.668931] refcount_t: saturated; leaking memory.
[ 1967.668968] WARNING: CPU: 5 PID: 9248 at lib/refcount.c:22
refcount_warn_saturate+0xe5/0xf0
[ 1967.668974] Modules linked in: md4 cmac nls_utf8 cifs libarc4
libdes rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace
fscache nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ebtable_nat ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat iptable_mangle iptable_raw
iptable_security nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set
nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter sunrpc crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel virtio_balloon ip_tables xfs qxl drm_ttm_helper
ttm drm_kms_helper cec drm virtio_net crc32c_intel virtio_blk
net_failover virtio_console failover floppy qemu_fw_cfg
[ 1967.669020] CPU: 5 PID: 9248 Comm: xfs_io Tainted: G        W
  5.12.0 #1
[ 1967.669022] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 1967.669024] RIP: 0010:refcount_warn_saturate+0xe5/0xf0
[ 1967.669027] Code: ff 48 c7 c7 80 2c 39 bc c6 05 08 8f 2e 01 01 e8
a1 4f ac ff 0f 0b c3 48 c7 c7 58 2c 39 bc c6 05 f3 8e 2e 01 01 e8 8b
4f ac ff <0f> 0b c3 0f 1f 84 00 00 00 00 00 8b 07 3d 00 00 00 c0 74 12
83 f8
[ 1967.669029] RSP: 0018:ffffab388004fd70 EFLAGS: 00010286
[ 1967.669031] RAX: 0000000000000026 RBX: ffff90730a81d800 RCX: 0000000000000027
[ 1967.669032] RDX: 0000000000000000 RSI: ffff90772bd585c0 RDI: ffff90772bd585c8
[ 1967.669034] RBP: ffff90730a81def8 R08: 0000000000000000 R09: 0000000000000001
[ 1967.669035] R10: ffffab388004fe60 R11: ffffab388004fb80 R12: ffff907301e730c0
[ 1967.669037] R13: ffffab388004fda0 R14: ffff907301e730c0 R15: 0000000000000000
[ 1967.669042] FS:  00007f9079db5880(0000) GS:ffff90772bd40000(0000)
knlGS:0000000000000000
[ 1967.669044] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1967.669045] CR2: 00007ffc9dfd1e38 CR3: 000000010c212005 CR4: 00000000003706e0
[ 1967.669058] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1967.669060] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1967.669061] Call Trace:
[ 1967.669069]  open_cached_dir_by_dentry+0xb6/0xe0 [cifs]
[ 1967.669128]  cifs_dentry_needs_reval+0x6e/0x160 [cifs]
[ 1967.669161]  cifs_revalidate_dentry_attr+0x30/0x340 [cifs]
[ 1967.669191]  cifs_getattr+0x84/0x240 [cifs]
[ 1967.669317]  vfs_statx+0x79/0xf0
[ 1967.669323]  __do_sys_newlstat+0x26/0x40
[ 1967.669327]  do_syscall_64+0x33/0x40
[ 1967.669332]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1967.669335] RIP: 0033:0x7f907a2d0509
[ 1967.669337] Code: 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 0f 1f 40
00 f3 0f 1e fa 48 89 f0 83 ff 01 77 34 48 89 c7 48 89 d6 b8 06 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 07 c3 66 0f 1f 44 00 00 48 8b 15 49 29
0d 00
[ 1967.669340] RSP: 002b:00007ffc9dfd3e48 EFLAGS: 00000246 ORIG_RAX:
0000000000000006
[ 1967.669342] RAX: ffffffffffffffda RBX: 00007ffc9dfd6f80 RCX: 00007f907a2d0509
[ 1967.669344] RDX: 00007ffc9dfd3e90 RSI: 00007ffc9dfd3e90 RDI: 00007ffc9dfd5f80
[ 1967.669345] RBP: 00007ffc9dfd3f60 R08: 00007ffc9dfd34b1 R09: 0000000000000000
[ 1967.669346] R10: 000055ebaa91b98d R11: 0000000000000246 R12: 00007ffc9dfd5f80
[ 1967.669348] R13: 000055ebaa91b994 R14: 000055ebaa91b993 R15: 00007ffc9dfd5f8c
[ 1967.669351] ---[ end trace b96ccc5cc434f1d2 ]---
[ 2063.230364] BUG: Dentry 000000001fab4fcb{i=6000000019c6c,n=/}
still in use (2) [unmount of cifs cifs]
[ 2063.230396] ------------[ cut here ]------------
[ 2063.230397] WARNING: CPU: 4 PID: 9269 at fs/dcache.c:1649
umount_check+0x59/0x70
[ 2063.230403] Modules linked in: md4 cmac nls_utf8 cifs libarc4
libdes rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace
fscache nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_conntrack ebtable_nat ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat iptable_mangle iptable_raw
iptable_security nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set
nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter sunrpc crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel virtio_balloon ip_tables xfs qxl drm_ttm_helper
ttm drm_kms_helper cec drm virtio_net crc32c_intel virtio_blk
net_failover virtio_console failover floppy qemu_fw_cfg
[ 2063.230448] CPU: 4 PID: 9269 Comm: umount Tainted: G        W
  5.12.0 #1
[ 2063.230450] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 2063.230451] RIP: 0010:umount_check+0x59/0x70
[ 2063.230454] Code: 8d 88 c8 03 00 00 48 8b 40 28 4c 8b 08 48 8b 46
30 48 85 c0 74 19 48 8b 50 40 51 48 c7 c7 c8 5f 35 bc 48 89 f1 e8 dd
ea 72 00 <0f> 0b 58 eb ba 31 d2 eb e7 0f 1f 40 00 66 2e 0f 1f 84 00 00
00 00
[ 2063.230456] RSP: 0018:ffffab3880d37dd0 EFLAGS: 00010286
[ 2063.230458] RAX: 000000000000005a RBX: 0000000000001c60 RCX: 0000000000000000
[ 2063.230459] RDX: 0000000000000001 RSI: ffff90772bd185c0 RDI: ffff90772bd185c0
[ 2063.230461] RBP: ffffffffc0a23bc0 R08: 0000000000000000 R09: 0000000000000001
[ 2063.230462] R10: 0000000000000000 R11: ffffab3880d37bf0 R12: ffff90730a819000
[ 2063.230464] R13: ffff90730a81def8 R14: ffffffffbd06e2d0 R15: 0000000000000000
[ 2063.230469] FS:  00007f1ea4fa5080(0000) GS:ffff90772bd00000(0000)
knlGS:0000000000000000
[ 2063.230471] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2063.230472] CR2: 00007f1ea52e64e0 CR3: 000000010ad60001 CR4: 00000000003706e0
[ 2063.230485] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2063.230487] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2063.230488] Call Trace:
[ 2063.230494]  d_walk+0x70/0x280
[ 2063.230497]  ? select_collect+0x80/0x80
[ 2063.230500]  do_one_tree+0x20/0x40
[ 2063.230503]  shrink_dcache_for_umount+0x28/0x80
[ 2063.230505]  generic_shutdown_super+0x1a/0x120
[ 2063.230508]  kill_anon_super+0xe/0x30
[ 2063.230511]  cifs_kill_sb+0x7c/0x90 [cifs]
[ 2063.230555]  deactivate_locked_super+0x3f/0x70
[ 2063.230558]  cleanup_mnt+0xb8/0x150
[ 2063.230561]  task_work_run+0x73/0xb0
[ 2063.230564]  exit_to_user_mode_prepare+0x1b2/0x1c0
[ 2063.230568]  syscall_exit_to_user_mode+0x18/0x40
[ 2063.230574]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 2063.230577] RIP: 0033:0x7f1ea515154b
[ 2063.230580] Code: 29 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 90 f3
0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 29 0c 00 f7 d8 64 89
01 48
[ 2063.230582] RSP: 002b:00007ffd3de1ee78 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[ 2063.230584] RAX: 0000000000000000 RBX: 000055d139120970 RCX: 00007f1ea515154b
[ 2063.230586] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055d139128780
[ 2063.230587] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000002
[ 2063.230588] R10: 000055d139120010 R11: 0000000000000246 R12: 000055d139128780
[ 2063.230589] R13: 00007f1ea53081a4 R14: 000055d139120b50 R15: 00007ffd3de1f0e8
[ 2063.230591] ---[ end trace b96ccc5cc434f1d3 ]---
[ 2063.230915] VFS: Busy inodes after unmount of cifs. Self-destruct
in 5 seconds.  Have a nice day...


-- 
Thanks,

Steve
