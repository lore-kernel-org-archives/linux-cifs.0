Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92801C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Nov 2021 04:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61AFD61AA2
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Nov 2021 04:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242226AbhKREcT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Nov 2021 23:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbhKREcS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Nov 2021 23:32:18 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D9FC061570
        for <linux-cifs@vger.kernel.org>; Wed, 17 Nov 2021 20:29:19 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id n26so4694193pff.3
        for <linux-cifs@vger.kernel.org>; Wed, 17 Nov 2021 20:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=XOi3fTduY7SJv5kilOAOHhj/j2Aa3eHSOwfNBkvJmA0=;
        b=Te1xrdWqYqosXs0ir29nhBTZp9vH+M4znLwgJ/3+RfK8HroNz+gvaX9Ad3gVJud908
         eVFb/OhKmauyJFvqJzHwrgZXsQyxrigZED48UDk3JP/ScnAfsjkHk1oZItBYMMwyOEaH
         hncUvy9WtpqfolzSBJ5OV33NOrgGUXJYbyjPkYheVOu5KD0k7fZUZuQh7keMTTX9OlWd
         FKnzCTnmKt367UVXUEkfo0kc2NthvfyEOrzfNN/ZO/YzPq/rnQ/kR0UnCHYgqb+va8y8
         WzAEZCp57L7Mwdg/DQCPtEYT2zN63waTq+W56owI+sEDuWrQuSYff7758eeyTzHMGTYF
         JEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=XOi3fTduY7SJv5kilOAOHhj/j2Aa3eHSOwfNBkvJmA0=;
        b=GzeBnjcfVtreimkzKfj62xh5/eVwZWsAqnoCx67L33RBEeQqHQhSPbfn+dVMahAcej
         goq/gU+gvuW/tUeE1yObUqeXW2nsi7EdP+iwibgCldkIMQpLvRX1p/NQc7mTnw8wR0cp
         bj+R7c09lpsqsiPElwI/V3mqVbweiZkILQgaYOsuc0orf1XUmGuusupP/zOOkyHmJGms
         zqSh6yJG05X6OjpCWhFqpRKsuvVDlCR7/XGok4mo2Qq77Ykj+oKhe1AlXWiAP1Shkbew
         f7YSgeKExDimZ8n/97O0asyqCHG03ndzKjwqPERO0UZt/P8rc7ml2R/I9aOsRi2b4C11
         6e+g==
X-Gm-Message-State: AOAM5308gcgv8pGKylh4mE0bx83gnOJDGFcLGXISGtfDexoL1g2H8ZWi
        wbiEHIKWnlB54vaChNJoSXeBV61j/eQ=
X-Google-Smtp-Source: ABdhPJwMXQoY2HcHRyqdwKo+xyh80/DSz0Ciog8R37GeRr13jCwZoADiE4IuCYcbdAlhnvKn7XqXFg==
X-Received: by 2002:aa7:9404:0:b0:494:6e78:67cd with SMTP id x4-20020aa79404000000b004946e7867cdmr52971041pfo.84.1637209758739;
        Wed, 17 Nov 2021 20:29:18 -0800 (PST)
Received: from xzhoux.usersys.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t13sm1235206pfl.98.2021.11.17.20.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 20:29:18 -0800 (PST)
Date:   Thu, 18 Nov 2021 12:29:14 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, linux-cifs@vger.kernel.org
Subject: [regression] mm, cifs panic
Message-ID: <20211118042914.wnffm3ytzmxjdubn@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Matthew,

Since this commit
	[988c69f1bc23fe632ea5e6eb3c26a9e103c3ed41] mm: optimise put_pages_list()

Always, xfstests[1] sub-testcase generic/340 on CIFS v3.11 can trigger
kernel panic like this:

[ 2001.250571] run fstests generic/340 at 2021-11-14 20:23:26 
[ 2001.392289] cifs_smb3_do_mount: 12 callbacks suppressed 
[ 2001.392295] CIFS: Attempting to mount \\dell-per730-01.dell2.lab.eng.bos.redhat.com\SCRATCH_dev 
[ 2001.420684] CIFS: Attempting to mount \\dell-per730-01.dell2.lab.eng.bos.redhat.com\SCRATCH_dev 
[ 2001.438960] Attempt to set a LOCK_MAND lock via flock(2). This support has been removed and the request ignored. 
[ 2001.451621] ------------[ cut here ]------------ 
[ 2001.456796] kernel BUG at mm/readahead.c:151! 
[ 2001.461664] invalid opcode: 0000 [#1] PREEMPT SMP PTI 
[ 2001.467301] CPU: 6 PID: 531974 Comm: holetest Kdump: loaded Not tainted 5.16.0-rc1 #1 
[ 2001.476038] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 2.11.0 11/02/2019 
[ 2001.484483] RIP: 0010:read_pages+0x228/0x240 
[ 2001.489250] Code: eb 87 48 8b 07 48 c1 e8 33 83 e0 07 83 f8 04 75 e4 48 8b 47 08 8b 40 68 83 e8 01 83 f8 01 77 d5 e8 1d 19 00 00 e9 5f ff ff ff <0f> 0b 0f 0b e8 2f 42 81 00 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 
[ 2001.510203] RSP: 0000:ffffb79227757bd8 EFLAGS: 00010293 
[ 2001.516033] RAX: ffffea3310273dc8 RBX: ffffb79227757cc0 RCX: ffffb79227757bf0 
[ 2001.523993] RDX: ffffb79227757c70 RSI: 0000000000000000 RDI: ffffb79227757bd8 
[ 2001.531953] RBP: ffffb79227757c70 R08: ffffea330d3a0888 R09: ffffea330d3a0888 
[ 2001.539913] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000 
[ 2001.547873] R13: ffffffffc0ca3560 R14: ffffea3310273dc0 R15: ffffea3310273dc8 
[ 2001.555834] FS:  00007f2e20c13640(0000) GS:ffff8d7567cc0000(0000) knlGS:0000000000000000 
[ 2001.564862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 2001.571272] CR2: 00007f2e20c14c00 CR3: 000000037a0fa006 CR4: 00000000001706e0 
[ 2001.579233] Call Trace: 
[ 2001.581959]  <TASK> 
[ 2001.584298]  page_cache_ra_unbounded+0x1d9/0x260 
[ 2001.589450]  do_sync_mmap_readahead+0x115/0x1a0 
[ 2001.594506]  filemap_fault+0x416/0x7b0 
[ 2001.598688]  __do_fault+0x36/0x110 
[ 2001.602483]  do_fault+0x130/0x2b0 
[ 2001.606178]  __handle_mm_fault+0x396/0x6f0 
[ 2001.610747]  handle_mm_fault+0xc5/0x290 
[ 2001.615025]  do_user_addr_fault+0x1c3/0x680 
[ 2001.619694]  exc_page_fault+0x62/0x140 
[ 2001.623867]  ? asm_exc_page_fault+0x8/0x30 
[ 2001.628437]  asm_exc_page_fault+0x1e/0x30 
[ 2001.632908] RIP: 0033:0x40192f 
[ 2001.636311] Code: ff 48 89 c3 48 8b 05 50 28 00 00 48 85 ed 7e 23 31 d2 4b 8d 0c 2f eb 0a 0f 1f 00 48 8b 05 39 28 00 00 48 0f af c2 48 83 c2 01 <48> 89 1c 01 48 39 d5 7f e8 8b 0d f2 27 00 00 31 c0 85 c9 74 0e 8b 
[ 2001.657265] RSP: 002b:00007f2e20c12e10 EFLAGS: 00010202 
[ 2001.663093] RAX: 0000000000000000 RBX: 00007f2e20c13640 RCX: 00007f2e20c14c00 
[ 2001.671053] RDX: 0000000000000001 RSI: 00007f2e20c13f30 RDI: 00007ffea1e626f0 
[ 2001.679014] RBP: 0000000000000100 R08: 0000000000000000 R09: 00007ffea1e6256f 
[ 2001.686975] R10: 0000000000000008 R11: 0000000000000246 R12: 00007ffea1e626f0 
[ 2001.694935] R13: 0000000000000c00 R14: 00007f2e20dae860 R15: 00007f2e20c14000 
[ 2001.702898]  </TASK> 


It's a mmap writing race testcase.

Bisect log is attached. Reverting this commit makes the panic go away.


Thanks,
Murphy

[1] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
[2] git bisect log
git bisect start
# good: [a602285ac11b019e9ce7c3907328e9f95f4967f0] Merge branch 'per_signal_struct_coredumps-for-v5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
git bisect good a602285ac11b019e9ce7c3907328e9f95f4967f0
# bad: [00f178e15095fbcf04db00486378a6fa416a125e] Merge tag 'xtensa-20211105' of git://github.com/jcmvbkbc/linux-xtensa
git bisect bad 00f178e15095fbcf04db00486378a6fa416a125e
# good: [5cd4dc44b8a0f656100e3b6916cf73b1623299eb] Merge tag 'staging-5.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect good 5cd4dc44b8a0f656100e3b6916cf73b1623299eb
# good: [5a1bcbd965341537c354e3682f939a7274ac3f5d] Merge tag 'pinctrl-v5.16-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect good 5a1bcbd965341537c354e3682f939a7274ac3f5d
# good: [fe91c4725aeed35023ba4f7a1e1adfebb6878c23] Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect good fe91c4725aeed35023ba4f7a1e1adfebb6878c23
# bad: [a460a36034bad4403c2c62e04a521bc6987ae5db] mm/damon: remove unnecessary variable initialization
git bisect bad a460a36034bad4403c2c62e04a521bc6987ae5db
# bad: [9871e2ded6c1ff61a59988d7a0e975f012105d52] mm/cma: add cma_pages_valid to determine if pages are in CMA
git bisect bad 9871e2ded6c1ff61a59988d7a0e975f012105d52
# bad: [642688681133a501d149349ba1a824204f3540e1] mm: memcontrol: remove kmemcg_id reparenting
git bisect bad 642688681133a501d149349ba1a824204f3540e1
# good: [d73dad4eb5ad8c31ac9cf358eb5a55825bafe706] kasan: test: bypass __alloc_size checks
git bisect good d73dad4eb5ad8c31ac9cf358eb5a55825bafe706
# good: [efee17134ca464639a2f5b4d036ce40caf1b247a] mm: simplify bdi refcounting
git bisect good efee17134ca464639a2f5b4d036ce40caf1b247a
# bad: [48384b0b76f3662dfa6153c1072c2b936fc14627] mm/memcg: drop swp_entry_t* in mc_handle_file_pte()
git bisect bad 48384b0b76f3662dfa6153c1072c2b936fc14627
# good: [20b7fee738d65e50ca00e325ae27ee3efaa819f6] mm/gup: further simplify __gup_device_huge()
git bisect good 20b7fee738d65e50ca00e325ae27ee3efaa819f6
# good: [642929a2ded029aac13b8cb91bc9b7c088ddb57f] mm/swapfile: fix an integer overflow in swap_show()
git bisect good 642929a2ded029aac13b8cb91bc9b7c088ddb57f
# bad: [988c69f1bc23fe632ea5e6eb3c26a9e103c3ed41] mm: optimise put_pages_list()
git bisect bad 988c69f1bc23fe632ea5e6eb3c26a9e103c3ed41
# first bad commit: [988c69f1bc23fe632ea5e6eb3c26a9e103c3ed41] mm: optimise put_pages_list()
