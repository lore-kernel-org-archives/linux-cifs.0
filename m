Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEF1C433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Oct 2022 20:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJBUWU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 16:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJBUWT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 16:22:19 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1612E3A14D
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 13:22:18 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id 63so9588022vse.2
        for <linux-cifs@vger.kernel.org>; Sun, 02 Oct 2022 13:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=NnCQcYydupQyMbregF3nXizQzPehjpZkZWmZFq0hrIY=;
        b=lSoC3srB4Q4ruN4AzFHcv9Vkvu6OJqB7WZ78pfsNe/wnOCDZLZ0iTEB7egUsSYd3Ag
         ZmcWEf9Hama01DNwgvNYibCqVL2PqQnPw+5G4w8L1miFm39jwdseR8B/AQsZGBw8blOb
         Cj95SV4+t9UL1OyKhbWDQw8/w5u4VsITdpRvOOafTX4arodXHYfo02bRyPUaYcOLKQ/h
         tiB+PJ6OclEjwbHYadqG4b66mBe5EIIbBT8MgmQQOdABCi0ZtNQGNl2VqTRwh4lh2pLT
         nEN7qbD+5DF1ByCbZd9TFnYTEt6Amn8vgfu1qgLqKcdQiNbzoHZGdj+aTYBrwnQKeGWJ
         9w6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=NnCQcYydupQyMbregF3nXizQzPehjpZkZWmZFq0hrIY=;
        b=mclJpu3XqTaZQeFpoqYyuuJTSlhpahasQ1expxfUjLheqeAIcQ8LIydzs4J/61WSZK
         FgIG3H3GtFAX0ieB2PjJnhMCxzfvBzpQV+/oh1r9dT01AIiCTcf9AE9EpOKpRB4/2e/N
         aojttYOqiB8zn75bVnuJQxQoRs2pgZ6/DBtUDR8uzrQmUw6Mk+Xb/4GVxs0DAiPCbw7n
         RbdWAw5rVxDDB7MmmgJNuqA1MD29v3a5WCSERi5ZURFKgAdDjjZ2QyYUnTDUabmeIdmC
         BTxPzVsYbeD28VsMO+h31foaU8AEUgRZYfI+hjkncjqwLxbKhGzhBoPOft20ZMDnMtEj
         8Tbg==
X-Gm-Message-State: ACrzQf2W99rG+IfAZUJMA6PqyFkmegjCPqlcrlAp3coHAvdcCz0sT6te
        +lMLXh1I2ZLFpPaJXho8cIpyksXXi+xSk/lWZBXY0V5J4Oc=
X-Google-Smtp-Source: AMsMyM4VpunFFdbnPlI1Fw732VHZe1dp9XGIGLp483XgTYD/1394Scvq9ruRnhhi2cHJiw0/GLanBtX4mIHSBxmdicw=
X-Received: by 2002:a05:6102:3118:b0:3a6:5332:25c0 with SMTP id
 e24-20020a056102311800b003a6533225c0mr1752668vsh.60.1664742136880; Sun, 02
 Oct 2022 13:22:16 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 2 Oct 2022 15:22:05 -0500
Message-ID: <CAH2r5muqfcAOWrbnbjuW=UBerszYxAzP1fAoFj_+eyp7uqG7jQ@mail.gmail.com>
Subject: cifs/102 test warning
To:     CIFS <linux-cifs@vger.kernel.org>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Noticed this in the logs for cifs/102 with current for-next.   Ideas?


2014.571858] run fstests cifs/102 at 2022-10-02 15:12:19

[ 2015.934812] ======================================================
[ 2015.935001] WARNING: possible circular locking dependency detected
[ 2015.935225] 6.0.0-rc7 #1 Not tainted
[ 2015.935307] ------------------------------------------------------
[ 2015.935307] cifsd/12418 is trying to acquire lock:
[ 2015.935307] ffffffffc0babaf8 (&cifs_tcp_ses_lock){+.+.}-{2:2}, at:
smb2_find_smb_tcon+0x24/0xd0 [cifs]
[ 2015.936656]
               but task is already holding lock:
[ 2015.936771] ffff91f54fd02268 (&tcp_ses->mid_lock){+.+.}-{2:2}, at:
release_mid+0x29/0x3b0 [cifs]
[ 2015.936771]
               which lock already depends on the new lock.

[ 2015.937709]
               the existing dependency chain (in reverse order) is:
[ 2015.938412]
               -> #1 (&tcp_ses->mid_lock){+.+.}-{2:2}:
[ 2015.938675]        _raw_spin_lock+0x2f/0x40
[ 2015.938939]        cifs_debug_data_proc_show+0x60d/0x980 [cifs]
[ 2015.938939]        seq_read_iter+0xdf/0x470
[ 2015.939367]        proc_reg_read_iter+0x46/0x70
[ 2015.939632]        vfs_read+0x230/0x2d0
[ 2015.939806]        ksys_read+0x88/0xc0
[ 2015.939806]        do_syscall_64+0x3a/0x90
[ 2015.939806]        entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 2015.939806]
               -> #0 (&cifs_tcp_ses_lock){+.+.}-{2:2}:
[ 2015.939806]        __lock_acquire+0x11d9/0x1690
[ 2015.939806]        lock_acquire+0x254/0x300
[ 2015.939806]        _raw_spin_lock+0x2f/0x40
[ 2015.941189]        smb2_find_smb_tcon+0x24/0xd0 [cifs]
[ 2015.941189]        smb2_handle_cancelled_mid+0x42/0x90 [cifs]
[ 2015.941633]        release_mid+0x1f7/0x3b0 [cifs]
[ 2015.942363]        cifs_demultiplex_thread+0x830/0xd40 [cifs]
[ 2015.942892]        kthread+0xe8/0x110
[ 2015.943423]        ret_from_fork+0x22/0x30
[ 2015.943423]
               other info that might help us debug this:

[ 2015.943423]  Possible unsafe locking scenario:

[ 2015.943423]        CPU0                    CPU1
[ 2015.945327] CIFS: VFS: \\win16.vm.test\Share Close unmatched open for MID:211
[ 2015.945142]        ----                    ----
[ 2015.945142]   lock(&tcp_ses->mid_lock);
[ 2015.945142]                                lock(&cifs_tcp_ses_lock);
[ 2015.945142]                                lock(&tcp_ses->mid_lock);
[ 2015.945142]   lock(&cifs_tcp_ses_lock);
[ 2015.945142]
                *** DEADLOCK ***

[ 2015.945142] 1 lock held by cifsd/12418:
[ 2015.945142]  #0: ffff91f54fd02268 (&tcp_ses->mid_lock){+.+.}-{2:2},
at: release_mid+0x29/0x3b0 [cifs]
[ 2015.949720]
               stack backtrace:
[ 2015.950654] CPU: 6 PID: 12418 Comm: cifsd Not tainted 6.0.0-rc7 #1
[ 2015.951605] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 2015.951774] Call Trace:
[ 2015.951774]  <TASK>
[ 2015.952771]  dump_stack_lvl+0x55/0x71
[ 2015.952771]  check_noncircular+0xeb/0x100
[ 2015.953646]  ? __lock_acquire+0x490/0x1690
[ 2015.954175]  ? cpu_attach_domain+0x2e7/0x9d0
[ 2015.954651]  ? __lock_acquire+0x11d9/0x1690
[ 2015.955159]  __lock_acquire+0x11d9/0x1690
[ 2015.955159]  lock_acquire+0x254/0x300
[ 2015.955688]  ? smb2_find_smb_tcon+0x24/0xd0 [cifs]
[ 2015.956203] CIFS: VFS: \\win16.vm.test\Share Close unmatched open for MID:212
[ 2015.955688]  _raw_spin_lock+0x2f/0x40
[ 2015.957008]  ? smb2_find_smb_tcon+0x24/0xd0 [cifs]
[ 2015.957008]  smb2_find_smb_tcon+0x24/0xd0 [cifs]
[ 2015.957008]  smb2_handle_cancelled_mid+0x42/0x90 [cifs]
[ 2015.957008]  ? _raw_spin_lock+0x2f/0x40
[ 2015.959650]  release_mid+0x1f7/0x3b0 [cifs]
[ 2015.959650]  cifs_demultiplex_thread+0x830/0xd40 [cifs]
[ 2015.959650]  ? cifs_handle_standard+0x1b0/0x1b0 [cifs]
[ 2015.960655]  kthread+0xe8/0x110
[ 2015.960655]  ? kthread_complete_and_exit+0x20/0x20
[ 2015.960655]  ret_from_fork+0x22/0x30
[ 2015.960655]  </TASK>
[ 2015.976931] CIFS: VFS: \\win16.vm.test\Share Close unmatched open for MID:213


-- 
Thanks,

Steve
