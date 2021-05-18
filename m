Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A67AC433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 18 May 2021 22:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2518760C40
	for <linux-cifs@archiver.kernel.org>; Tue, 18 May 2021 22:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhERWoC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 May 2021 18:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbhERWoB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 May 2021 18:44:01 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD22C061573
        for <linux-cifs@vger.kernel.org>; Tue, 18 May 2021 15:42:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b17so13111280ede.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 May 2021 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=E0bZORG1AUQFGD2ooBan6LVumDGJSh1TfPotAWn9I0E=;
        b=b95FTLN2ms78K9gVUtVNyJt9EQlYu+XFFYpX4/3YbNOluGMReVgLBsBn59NpoNbYRP
         v4Q1Vb+gDGJR+dFR1jdx1hg6xFf1ofb0hc2SX7w3pp1OPcOf4D+3DMkp+SV+L6DWQmX3
         maMDbWiGXvhS4rjxg0ruxfOw1j4qMReFQPI33BkBHRNEAk1y/yX+1pJ4guId3uD0nvpI
         GVSyNUXooQndN18zciujp2jLsN50s0HhYzdRknSNa/iy1nXtLEbuGM2U4a64tbijBv8c
         pc4cafcQgwxH3qCY1zhLDpTWFaNhYefaLBnQ3ipiVkfA4PdNLrKO1Tfh+wPuF9TCuIyc
         KKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=E0bZORG1AUQFGD2ooBan6LVumDGJSh1TfPotAWn9I0E=;
        b=t6IbMdGGBR3kHxbOWqtVC16ozfTquC56Rb6xzedikzsrCgi14HKLGTp/DkeSgl5tgU
         mXyz7rd200bmgQTTavew0nsb/XKZtw9gBdEYY6ZYKlACoGuNfV0sgbCC/6GXWgkYMn7K
         +t3v8sej3WjCPglmMN/SsJVAAqzxejeX2Ng0w8oMwdPgW43CNh7q+vA/fizzPV6UIYEl
         vBZW059KXlg8YGIGNPNWuyhOqW8EDl3TIztsRqIat4Q6Cg7q3BAqPrgplL1Al461kZiY
         kXKeVMIvKpPlATyNLf2kVCK9dcy74PvNSQmCG6XzOaTg8oyH1nr1tHkC3u5wfoRRrP6s
         563Q==
X-Gm-Message-State: AOAM532f64Ez6vVQW/5hgVrAPvLL5toZapkJEQIx7TnU9MEv02YDVNXD
        I4qQ2TY0h1Z8rxfEjqkkWnvz83rplTVM86uzr7E1F8A2wxSuaQ==
X-Google-Smtp-Source: ABdhPJyWn/1CPNtaD5dDwmMxMNmfySf+rNwD4X8LP9L+Tom619TVHZ5POioCOR4er0xwP7L2XWVwszKMdnizChA5QRc=
X-Received: by 2002:a05:6402:1295:: with SMTP id w21mr9366575edv.60.1621377760795;
 Tue, 18 May 2021 15:42:40 -0700 (PDT)
MIME-Version: 1.0
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 19 May 2021 08:42:29 +1000
Message-ID: <CAN05THS7_pmJkzoOvRsDbjQhUUn7h5M2GEG4obt4KizHs3OwRQ@mail.gmail.com>
Subject: KASAN use after free in deferred close
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Cc:     Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

List, Rorith,
I got a hit in KASAN for a use after free that looks like it is
related to the recent deferred close patches. Can you please have a
look?

[  473.779989] run fstests generic/013 at 2021-05-19 08:27:00
[  612.157429] ==================================================================
[  612.158275] BUG: KASAN: use-after-free in process_one_work+0x90/0x9b0
[  612.158801] Read of size 8 at addr ffff88810a31ca60 by task kworker/2:9/2382

[  612.159611] CPU: 2 PID: 2382 Comm: kworker/2:9 Tainted: G
OE     5.13.0-rc2+ #98
[  612.159623] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.14.0-1.fc33 04/01/2014
[  612.159640] Workqueue:  0x0 (deferredclose)
[  612.159669] Call Trace:
[  612.159685]  dump_stack+0xbb/0x107
[  612.159711]  print_address_description.constprop.0+0x18/0x140
[  612.159733]  ? process_one_work+0x90/0x9b0
[  612.159743]  ? process_one_work+0x90/0x9b0
[  612.159754]  kasan_report.cold+0x7c/0xd8
[  612.159778]  ? lock_is_held_type+0x80/0x130
[  612.159789]  ? process_one_work+0x90/0x9b0
[  612.159812]  kasan_check_range+0x145/0x1a0
[  612.159834]  process_one_work+0x90/0x9b0
[  612.159877]  ? pwq_dec_nr_in_flight+0x110/0x110
[  612.159914]  ? spin_bug+0x90/0x90
[  612.159967]  worker_thread+0x3b6/0x6c0
[  612.160023]  ? process_one_work+0x9b0/0x9b0
[  612.160038]  kthread+0x1dc/0x200
[  612.160051]  ? kthread_create_worker_on_cpu+0xd0/0xd0
[  612.160092]  ret_from_fork+0x1f/0x30

[  612.160399] Allocated by task 2358:
[  612.160757]  kasan_save_stack+0x1b/0x40
[  612.160768]  __kasan_kmalloc+0x9b/0xd0
[  612.160778]  cifs_new_fileinfo+0xb0/0x960 [cifs]
[  612.161170]  cifs_open+0xadf/0xf20 [cifs]
[  612.161421]  do_dentry_open+0x2aa/0x6b0
[  612.161432]  path_openat+0xbd9/0xfa0
[  612.161441]  do_filp_open+0x11d/0x230
[  612.161450]  do_sys_openat2+0x115/0x240
[  612.161460]  __x64_sys_openat+0xce/0x140
[  612.161470]  do_syscall_64+0x3a/0x70
[  612.161486]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[  612.161721] Freed by task 2382:
[  612.162241]  kasan_save_stack+0x1b/0x40
[  612.162253]  kasan_set_track+0x1c/0x30
[  612.162263]  kasan_set_free_info+0x20/0x30
[  612.162272]  __kasan_slab_free+0x108/0x150
[  612.162282]  slab_free_freelist_hook+0xf9/0x2c0
[  612.162294]  kfree+0xce/0x350
[  612.162302]  _cifsFileInfo_put+0x42d/0x6a0 [cifs]
[  612.162612]  process_one_work+0x4f2/0x9b0
[  612.162622]  worker_thread+0x2d3/0x6c0
[  612.162631]  kthread+0x1dc/0x200
[  612.162639]  ret_from_fork+0x1f/0x30

[  612.162989] Last potentially related work creation:
[  612.163583]  kasan_save_stack+0x1b/0x40
[  612.163594]  kasan_record_aux_stack+0xc1/0xd0
[  612.163605]  insert_work+0x32/0x160
[  612.163614]  __queue_work+0x35e/0x7e0
[  612.163625]  mod_delayed_work_on+0x98/0x110
[  612.163635]  cifs_close_all_deferred_files+0x8a/0xb0 [cifs]
[  612.163888]  cifs_unlink+0x20c/0x780 [cifs]
[  612.164149]  vfs_unlink+0x194/0x2e0
[  612.164162]  do_unlinkat+0x28b/0x400
[  612.164172]  do_syscall_64+0x3a/0x70
[  612.164183]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[  612.164557] Second to last potentially related work creation:
[  612.165183]  kasan_save_stack+0x1b/0x40
[  612.165195]  kasan_record_aux_stack+0xc1/0xd0
[  612.165205]  insert_work+0x32/0x160
[  612.165215]  __queue_work+0x35e/0x7e0
[  612.165225]  queue_delayed_work_on+0xa6/0xc0
[  612.165235]  cifs_close+0x18d/0x270 [cifs]
[  612.165486]  __fput+0x115/0x3d0
[  612.165498]  task_work_run+0x85/0xc0
[  612.165510]  exit_to_user_mode_prepare+0x1fd/0x200
[  612.165520]  syscall_exit_to_user_mode+0x27/0x70
[  612.165531]  do_syscall_64+0x47/0x70
[  612.165542]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[  612.165921] The buggy address belongs to the object at ffff88810a31c800
                which belongs to the cache kmalloc-1k of size 1024
[  612.167111] The buggy address is located 608 bytes inside of
                1024-byte region [ffff88810a31c800, ffff88810a31cc00)
[  612.168215] The buggy address belongs to the page:
[  612.168794] page:00000000d0b7a3cf refcount:1 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x10a318
[  612.168807] head:00000000d0b7a3cf order:3 compound_mapcount:0
compound_pincount:0
[  612.168815] memcg:ffff88810d800901
[  612.168822] flags:
0x17ffe000010200(slab|head|node=0|zone=2|lastcpupid=0x3fff)
[  612.168835] raw: 0017ffe000010200 dead000000000100 dead000000000122
ffff888100042dc0
[  612.168845] raw: 0000000000000000 0000000080100010 00000001ffffffff
ffff88810d800901
[  612.168852] page dumped because: kasan: bad access detected

[  612.169163] Memory state around the buggy address:
[  612.169605]  ffff88810a31c900: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  612.170243]  ffff88810a31c980: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  612.170930] >ffff88810a31ca00: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  612.171545]                                                        ^
[  612.172068]  ffff88810a31ca80: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  612.172832]  ffff88810a31cb00: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  612.173683] ==================================================================
[  612.174498] Disabling lock debugging due to kernel taint


regards
ronnie sahlberg
