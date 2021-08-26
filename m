Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A6BC432BE
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 12:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0D3961058
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 12:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242411AbhHZMGf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Aug 2021 08:06:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242147AbhHZMGe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 26 Aug 2021 08:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629979547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/jigHHW05ieDhY0e2I59F7jbh7VMF4pAdJShtAr0frI=;
        b=JbKmPCWTorkkPhvGEyKks4sidr21H3emuJSCi+N4gmdaXW5ngU8qqJdPJlu9BUvU+7Jg9f
        8XoLjAAxO/f5jtul1mgp2GYsUeEapMbBucKFvB2tQ0nVPjGqGlbTJPKsW6t8DztYYFzQ08
        gt7RfYUKi1rfcDsPwX9WDsc22I9AWRM=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-b7pLO_XUMT-Wtbvp70qSpA-1; Thu, 26 Aug 2021 08:05:45 -0400
X-MC-Unique: b7pLO_XUMT-Wtbvp70qSpA-1
Received: by mail-oo1-f72.google.com with SMTP id z15-20020a4a870f000000b0028c0cd3ec6cso1233586ooh.16
        for <linux-cifs@vger.kernel.org>; Thu, 26 Aug 2021 05:05:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=/jigHHW05ieDhY0e2I59F7jbh7VMF4pAdJShtAr0frI=;
        b=QYIHVJDEDHNr7WatASBO2TOs/GCkFMm20Ov5hmdsEpPxDYCNZISZASaxo24BxCxsdB
         BOSzXFxRgK0+4yn4UzLJJFjW+w1SJhE8FsjsvZDTi5D5I04Jp9Ool+HHRAVGIn/7Xp9I
         N80cFsqFxAKIVKdzdOcB8GcXHBMOcdO9VRASUbgx8LHVzwBWo/fn91whp0HzDjCoZj48
         fotDgYCP697zBaGdmegnOKNaPKQkLNQT8kdCkbOWki/7cQW+q8wgTWGG0uSl3/FxzcOj
         1gy/IrSSoBTjVVnhWgCFltUuQ+d5bKBuVO/JmOyOL62z5xIwEQnf8tD4S2XaZt7j4dh9
         oPjA==
X-Gm-Message-State: AOAM530aELn1BD7SKDlxX3HS72bG1P0s4nKgsxL8L/9oslT37uE0t18k
        PFSvwU8RUAbEZCHsHwQUp0uWlVJ/+UZ9j0NY6GEbzon1ighNfJpI+IJxwHSSCVekmLgu10nfAUF
        WaM+8jvA8wP5jJn99IDjqfSgatHhKoxbONfQgrg==
X-Received: by 2002:a05:6808:d51:: with SMTP id w17mr10587853oik.179.1629979543425;
        Thu, 26 Aug 2021 05:05:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJI1Qf3zkD2tqDQGFeLiUkcc0QBDHjMNCcIOT7h310CI8ALz9/8vse8Pw2MY+n7JDkRrw5wMeuu+wxhzJNi+4=
X-Received: by 2002:a05:6808:d51:: with SMTP id w17mr10587835oik.179.1629979543073;
 Thu, 26 Aug 2021 05:05:43 -0700 (PDT)
MIME-Version: 1.0
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Thu, 26 Aug 2021 14:05:32 +0200
Message-ID: <CA+QYu4rS+UkLUS-BDwNAOaMW2nQ4JY3V0OqdnLe3=zNoTrDDYQ@mail.gmail.com>
Subject: possible circular locking dependency detected: compound_send_recv+0x189/0x910
 [cifs] vm_mmap_pgoff+0x85/0x160
To:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     CKI Project <cki-project@redhat.com>, Xiong Zhou <xzhou@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

While running xfstests for cifs [1] we hit the issue below, the
problem though doesn't seem easily reproducible (we've only hit it 3
times since the beginning of July). More logs can be found on [2].


[13104.739969] run fstests generic/095 at 2021-08-24 18:14:01
[13106.003373] CIFS: Attempting to mount \\127.0.0.1\scratch
[13106.079456] CIFS: Attempting to mount \\127.0.0.1\scratch

[13107.832907] ======================================================
[13107.839805] WARNING: possible circular locking dependency detected
[13107.846702] 5.14.0-rc7 #1 Not tainted
[13107.850789] ------------------------------------------------------
[13107.857686] fio/1323391 is trying to acquire lock:
[13107.863025] ffff9cdf0cae72e0 (&tcp_ses->srv_mutex){+.+.}-{3:3}, at:
compound_send_recv+0x189/0x910 [cifs]
[13107.873786]
               but task is already holding lock:
[13107.880295] ffff9cdf07f9c8a8 (&mm->mmap_lock#2){++++}-{3:3}, at:
vm_mmap_pgoff+0x85/0x160
[13107.889425]
               which lock already depends on the new lock.

[13107.898559]
               the existing dependency chain (in reverse order) is:
[13107.906910]
               -> #3 (&mm->mmap_lock#2){++++}-{3:3}:
[13107.913815]        down_write+0x3d/0x70
[13107.918105]        mpol_rebind_mm+0x27/0xe0
[13107.922784]        cpuset_attach+0x226/0x3e0
[13107.927566]        cgroup_migrate_execute+0x414/0x520
[13107.933206]        cgroup_update_dfl_csses+0x212/0x240
[13107.938943]        cgroup_subtree_control_write+0x352/0x430
[13107.945163]        kernfs_fop_write_iter+0x134/0x1d0
[13107.950710]        new_sync_write+0x10b/0x180
[13107.955575]        vfs_write+0x26a/0x380
[13107.959953]        ksys_write+0x58/0xd0
[13107.964226]        do_syscall_64+0x5c/0x80
[13107.968804]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[13107.975030]
               -> #2 (&cpuset_rwsem){++++}-{0:0}:
[13107.981642]        cpuset_read_lock+0x3e/0xb0
[13107.986507]        __sched_setscheduler+0x420/0xa00
[13107.991956]        sched_setscheduler_nocheck+0x68/0x70
[13107.997788]        __kthread_create_on_node+0x12f/0x1a0
[13108.003627]        kthread_create_on_node+0x39/0x40
[13108.009072]        cryptomgr_notify+0x379/0x4d0
[13108.014127]        blocking_notifier_call_chain+0x63/0x90
[13108.020172]        crypto_probing_notify+0x20/0x50
[13108.025522]        crypto_wait_for_test+0x1a/0x70
[13108.030771]        crypto_register_alg+0x56/0x70
[13108.035921]        do_one_initcall+0x5b/0x2d0
[13108.040777]        kernel_init_freeable+0x284/0x2d0
[13108.046215]        kernel_init+0x16/0x120
[13108.050681]        ret_from_fork+0x22/0x30
[13108.055250]
               -> #1 ((crypto_chain).rwsem){++++}-{3:3}:
[13108.062538]        down_read+0x40/0x50
[13108.066720]        blocking_notifier_call_chain+0x2c/0x90
[13108.072745]        crypto_alg_mod_lookup+0x10b/0x220
[13108.078287]        crypto_alloc_tfm_node+0x4c/0xd0
[13108.083635]        cifs_alloc_hash+0x30/0xe0 [cifs]
[13108.089156]        smb311_crypto_shash_allocate+0x65/0xc0 [cifs]
[13108.095929]        smb311_update_preauth_hash+0x78/0x1c0 [cifs]
[13108.102584]        compound_send_recv+0x56f/0x910 [cifs]
[13108.108555]        cifs_send_recv+0x1f/0x30 [cifs]
[13108.113958]        SMB2_negotiate+0x3a8/0x1230 [cifs]
[13108.119660]        smb2_negotiate+0x4f/0x70 [cifs]
[13108.125052]        cifs_negotiate_protocol+0x6b/0xd0 [cifs]
[13108.131309]        cifs_get_smb_ses+0x2f6/0x1110 [cifs]
[13108.137177]        mount_get_conns+0x98/0x400 [cifs]
[13108.142755]        cifs_mount+0x89/0x780 [cifs]
[13108.147850]        cifs_smb3_do_mount+0x15d/0x6a0 [cifs]
[13108.153813]        smb3_get_tree+0xeb/0x1e0 [cifs]
[13108.159207]        vfs_get_tree+0x28/0xc0
[13108.163680]        path_mount+0x42f/0xb60
[13108.168154]        __x64_sys_mount+0xe3/0x120
[13108.173014]        do_syscall_64+0x5c/0x80
[13108.177586]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[13108.183806]
               -> #0 (&tcp_ses->srv_mutex){+.+.}-{3:3}:
[13108.190993]        __lock_acquire+0x1158/0x1de0
[13108.196050]        lock_acquire+0xb5/0x2b0
[13108.200618]        __mutex_lock+0x8a/0x760
[13108.205187]        compound_send_recv+0x189/0x910 [cifs]
[13108.211158]        cifs_send_recv+0x1f/0x30 [cifs]
[13108.216547]        SMB2_write+0x192/0x4b0 [cifs]
[13108.221746]        cifs_write+0x181/0x600 [cifs]
[13108.226939]        cifs_writepage_locked+0x34c/0x670 [cifs]
[13108.233247]        cifs_launder_page+0xcf/0xe0 [cifs]
[13108.238925]        invalidate_inode_pages2_range+0x3c6/0x4d0
[13108.245264]        cifs_invalidate_mapping+0x35/0x60 [cifs]
[13108.251523]        cifs_revalidate_mapping+0x9c/0xb0 [cifs]
[13108.257787]        cifs_file_mmap+0x4b/0x3c0 [cifs]
[13108.263318]        mmap_region+0x415/0x690
[13108.267896]        do_mmap+0x362/0x560
[13108.272082]        vm_mmap_pgoff+0xb8/0x160
[13108.276758]        ksys_mmap_pgoff+0x1a1/0x200
[13108.281724]        do_syscall_64+0x5c/0x80
[13108.286302]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[13108.292525]
               other info that might help us debug this:

[13108.301457] Chain exists of:
                 &tcp_ses->srv_mutex --> &cpuset_rwsem --> &mm->mmap_lock#2

[13108.313788]  Possible unsafe locking scenario:

[13108.320395]        CPU0                    CPU1
[13108.325450]        ----                    ----
[13108.330503]   lock(&mm->mmap_lock#2);
[13108.334590]                                lock(&cpuset_rwsem);
[13108.341196]                                lock(&mm->mmap_lock#2);
[13108.348099]   lock(&tcp_ses->srv_mutex);
[13108.352478]
                *** DEADLOCK ***

[13108.359085] 1 lock held by fio/1323391:
[13108.363374]  #0: ffff9cdf07f9c8a8 (&mm->mmap_lock#2){++++}-{3:3},
at: vm_mmap_pgoff+0x85/0x160
[13108.372998]
               stack backtrace:
[13108.377861] CPU: 19 PID: 1323391 Comm: fio Not tainted 5.14.0-rc7 #1
[13108.384959] Hardware name: Dell Inc. PowerEdge R720/0X3D66, BIOS
2.1.3 11/20/2013
[13108.393314] Call Trace:
[13108.396047]  dump_stack_lvl+0x57/0x72
[13108.400147]  check_noncircular+0xde/0x100
[13108.404623]  ? rcu_read_lock_sched_held+0x3f/0x80
[13108.409881]  ? lock_acquire+0x15b/0x2b0
[13108.414165]  ? rcu_read_lock_sched_held+0x3f/0x80
[13108.419420]  __lock_acquire+0x1158/0x1de0
[13108.423899]  ? __kernel_text_address+0xe/0x30
[13108.428765]  ? unwind_get_return_address+0x1b/0x30
[13108.434114]  lock_acquire+0xb5/0x2b0
[13108.438108]  ? compound_send_recv+0x189/0x910 [cifs]
[13108.443723]  ? lock_is_held_type+0xa5/0x120
[13108.448395]  __mutex_lock+0x8a/0x760
[13108.452385]  ? compound_send_recv+0x189/0x910 [cifs]
[13108.457988]  ? wait_for_free_credits+0x712/0x9e0 [cifs]
[13108.463891]  ? compound_send_recv+0x189/0x910 [cifs]
[13108.469505]  ? compound_send_recv+0x10b/0x910 [cifs]
[13108.475116]  ? lock_release+0xba/0x290
[13108.479304]  ? compound_send_recv+0x189/0x910 [cifs]
[13108.484917]  compound_send_recv+0x189/0x910 [cifs]
[13108.490340]  ? __smb2_plain_req_init+0xe0/0x210 [cifs]
[13108.496161]  ? lock_release+0xba/0x290
[13108.500350]  cifs_send_recv+0x1f/0x30 [cifs]
[13108.505191]  SMB2_write+0x192/0x4b0 [cifs]
[13108.509843]  ? _get_xid+0x60/0xa0 [cifs]
[13108.514290]  ? lock_release+0xba/0x290
[13108.518480]  cifs_write+0x181/0x600 [cifs]
[13108.523118]  ? find_held_lock+0x2b/0x80
[13108.527408]  cifs_writepage_locked+0x34c/0x670 [cifs]
[13108.533118]  cifs_launder_page+0xcf/0xe0 [cifs]
[13108.538248]  invalidate_inode_pages2_range+0x3c6/0x4d0
[13108.543991]  ? __lock_acquire+0x3a8/0x1de0
[13108.548574]  cifs_invalidate_mapping+0x35/0x60 [cifs]
[13108.554280]  cifs_revalidate_mapping+0x9c/0xb0 [cifs]
[13108.559987]  cifs_file_mmap+0x4b/0x3c0 [cifs]
[13108.564918]  mmap_region+0x415/0x690
[13108.568914]  do_mmap+0x362/0x560
[13108.572521]  vm_mmap_pgoff+0xb8/0x160
[13108.576613]  ksys_mmap_pgoff+0x1a1/0x200
[13108.580995]  ? lockdep_hardirqs_on_prepare+0xff/0x180
[13108.586636]  ? syscall_enter_from_user_mode+0x21/0x70
[13108.592278]  do_syscall_64+0x5c/0x80
[13108.596271]  ? rcu_read_lock_sched_held+0x3f/0x80
[13108.601513]  ? lockdep_hardirqs_on_prepare+0xff/0x180
[13108.607155]  ? do_syscall_64+0x69/0x80
[13108.611342]  ? do_user_addr_fault+0x208/0x6b0
[13108.616211]  ? rcu_read_lock_sched_held+0x3f/0x80
[13108.621464]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[13108.627106] RIP: 0033:0x7fe6858b7ff6
[13108.631102] Code: 01 00 66 90 f3 0f 1e fa 41 f7 c1 ff 0f 00 00 75
2b 55 48 89 fd 53 89 cb 48 85 ff 74 37 41 89 da 48 89 ef b8 09 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 62 5b 5d c3 0f 1f 80 00 00 00 00 48 8b
05 f9
[13108.652063] RSP: 002b:00007ffc85a182b8 EFLAGS: 00000246 ORIG_RAX:
0000000000000009
[13108.660517] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe6858b7ff6
[13108.668485] RDX: 0000000000000002 RSI: 0000000000080000 RDI: 0000000000000000
[13108.676451] RBP: 0000000000000000 R08: 0000000000000007 R09: 0000000000000000
[13108.684407] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000080000
[13108.692374] R13: 00005615efc5c020 R14: 00007fe6847c7610 R15: 00005615efc5b440

[1] https://gitlab.com/cki-project/kernel-tests/-/tree/main/filesystems/xfs/xfstests
[2] https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/08/24/358739877/build_x86_64_redhat%3A1530602378/tests/xfstests_cifsv3_11/

Thank you,
Bruno Goncalves

