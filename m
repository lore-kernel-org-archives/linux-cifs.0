Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB08C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Feb 2022 08:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiBLIc2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Feb 2022 03:32:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiBLIc1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Feb 2022 03:32:27 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CA4212
        for <linux-cifs@vger.kernel.org>; Sat, 12 Feb 2022 00:32:23 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id z19so20737603lfq.13
        for <linux-cifs@vger.kernel.org>; Sat, 12 Feb 2022 00:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=48v+XTGT2FfeXa8+Sk7GWknsakTPEn/vW6Ysl4S1Rgw=;
        b=AtCeWFAJ9tgChXiHQiwFRLSjlhGxfcIIsLLl+sPOLiUVPzSn2dqSPbgsahqgCLemze
         E3/jVJmGdK6dtDVv2LZADx13eCFQZjJCcGIEn48uRnn/painqL0d0AnJJIcAJSMUA6pb
         HwOPZ7bi8GXXJR+c45ru4vKh6Y8X7nna6pg4d5APuVM8ne7RYjPMsGG81H9QlXoWMCJw
         60OsW7o9eJC1c6Xg4M33yYdnRKmm/hR/AFGdi6EghK6nkWXytGs9rs+wm0DOTHUSKAux
         pYxAX1NwT81CLzRt4/WWu5jxu3Dxt2PIYRKVdZyPpzBpgreklXjIjZUXBqLDpD3z9djE
         ensA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=48v+XTGT2FfeXa8+Sk7GWknsakTPEn/vW6Ysl4S1Rgw=;
        b=tUn4r+6ENQetBS72HPMeIMllWl4L1aUvKv1t2bQN8CDHFSgZ/gWGc7dy+i4utwzhCy
         pMHjITSrA6en8VdJHBBm7VsumpxlMg3D2FrXQnNPHNq6KIyPgNQkyMZ9/5iAqit1etIP
         Ck0X7pxOYmzqrcQ5lSI5M4BvX9kZpmAPi8nFcZhfNutAYhox65ZW6OpWVgjpHZYlxtub
         eWZDmz163SjONcnpuP5RvHD6g1eyNi3LIHCTGa/N7OgiAoCdSv528QHl56H1379DeHQs
         3wxj2LE6gP4vEmMrM537IvkkGgqmeJbR2TNYL8+Ql4H4SO76y/33w0uf0nxynKqLNnlu
         jquw==
X-Gm-Message-State: AOAM532iR8Rsx1SOSbYSLfTsV+OKjv28STHj0KUrVEuqj8100ceZdIp1
        eUs90K5qMGax8XtLoZOwR58oknZXWB154KU4E6ZcaHbn76A=
X-Google-Smtp-Source: ABdhPJyLXAH1Z1bGCIWE4cK0YFBvctgrwVlIdeyF/grR3M1uAU/rs8ufScXg3ZkExhU8p6haMRbbQZT09ODGKMLnNVk=
X-Received: by 2002:a05:6512:3e14:: with SMTP id i20mr3910568lfv.601.1644654741866;
 Sat, 12 Feb 2022 00:32:21 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Feb 2022 02:32:10 -0600
Message-ID: <CAH2r5msEy7+TP010eqH19SU1NonXGAPnM2J7bjGSrXb=wQGCpg@mail.gmail.com>
Subject: possible circular lock dependency
To:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Saw possible lock dependency problem (once) running cifs/102 test -
ran multiple times but only saw once.  It may be fixed by later
patches from Shyam, but I was doing some tests with only his first
two.

This is on on 5.17-rc3 + the 3 patches below.
52492ff5c583 cifs: call helper functions for marking channels for reconnect
a81da65fbae6 cifs: call cifs_reconnect when a connection is marked
d0cbe56a7d5a [smb3] improve error message when mount options conflict with posix
dfd42facf1e4 (tag: v5.17-rc3, origin/master, origin/HEAD,
linus/master, master) Linux 5.17-rc3

[ 6566.222316] run fstests cifs/102 at 2022-02-12 02:27:53

[ 6567.213971] ======================================================
[ 6567.214280] WARNING: possible circular locking dependency detected
[ 6567.214496] 5.17.0-rc3 #1 Not tainted
[ 6567.214851] ------------------------------------------------------
[ 6567.214851] cifsd/5791 is trying to acquire lock:
[ 6567.214851] ffffffffc0b296f8 (&cifs_tcp_ses_lock){+.+.}-{2:2}, at:
smb2_find_smb_tcon+0x24/0xc0 [cifs]
[ 6567.215501]
               but task is already holding lock:
[ 6567.215501] ffffffffc0b29698 (&GlobalMid_Lock){+.+.}-{2:2}, at:
cifs_mid_q_entry_release+0x22/0x610 [cifs]
[ 6567.216247]
               which lock already depends on the new lock.

[ 6567.216661]
               the existing dependency chain (in reverse order) is:
[ 6567.217496]
               -> #1 (&GlobalMid_Lock){+.+.}-{2:2}:
[ 6567.217991]        _raw_spin_lock+0x2f/0x40
[ 6567.217991]        cifs_debug_data_proc_show+0x50c/0x9b0 [cifs]
[ 6567.217991]        seq_read_iter+0xd3/0x440
[ 6567.217991]        proc_reg_read_iter+0x46/0x60
[ 6567.219094]        new_sync_read+0x10e/0x180
[ 6567.219094]        vfs_read+0x171/0x1a0
[ 6567.219560]        ksys_read+0x87/0xc0
[ 6567.219585]        do_syscall_64+0x3a/0x80
[ 6567.219585]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 6567.219585]
               -> #0 (&cifs_tcp_ses_lock){+.+.}-{2:2}:
[ 6567.220786]        __lock_acquire+0x1302/0x18d0
[ 6567.220786]        lock_acquire+0x267/0x330
[ 6567.221479]        _raw_spin_lock+0x2f/0x40
[ 6567.221479]        smb2_find_smb_tcon+0x24/0xc0 [cifs]
[ 6567.221479]        smb2_handle_cancelled_mid+0x3e/0x90 [cifs]
[ 6567.221479]        cifs_mid_q_entry_release+0x28a/0x610 [cifs]
[ 6567.223102]        cifs_demultiplex_thread+0x848/0xf70 [cifs]
[ 6567.223102]        kthread+0xe8/0x110
[ 6567.223642]        ret_from_fork+0x22/0x30
[ 6567.223642]
               other info that might help us debug this:

[ 6567.223642]  Possible unsafe locking scenario:

[ 6567.225550]        CPU0                    CPU1
[ 6567.225550]        ----                    ----
[ 6567.225550]   lock(&GlobalMid_Lock);
[ 6567.225550]                                lock(&cifs_tcp_ses_lock);
[ 6567.228648]                                lock(&GlobalMid_Lock);
[ 6567.228648]   lock(&cifs_tcp_ses_lock);
[ 6567.229647]
                *** DEADLOCK ***

[ 6567.230447] 1 lock held by cifsd/5791:
[ 6567.231573]  #0: ffffffffc0b29698 (&GlobalMid_Lock){+.+.}-{2:2},
at: cifs_mid_q_entry_release+0x22/0x610 [cifs]
[ 6567.232498]
               stack backtrace:
[ 6567.232630] CPU: 3 PID: 5791 Comm: cifsd Not tainted 5.17.0-rc3 #1
[ 6567.232630] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 6567.234451] Call Trace:
[ 6567.234451]  <TASK>
[ 6567.234451]  dump_stack_lvl+0x58/0x71
[ 6567.234451]  check_noncircular+0xe7/0x100
[ 6567.234451]  ? __lock_acquire+0xb7e/0x18d0
[ 6567.234451]  ? __lock_acquire+0x1302/0x18d0
[ 6567.234451]  __lock_acquire+0x1302/0x18d0
[ 6567.234451]  lock_acquire+0x267/0x330
[ 6567.234451]  ? smb2_find_smb_tcon+0x24/0xc0 [cifs]
[ 6567.234451]  _raw_spin_lock+0x2f/0x40
[ 6567.234451]  ? smb2_find_smb_tcon+0x24/0xc0 [cifs]
[ 6567.234451]  smb2_find_smb_tcon+0x24/0xc0 [cifs]
[ 6567.240749]  smb2_handle_cancelled_mid+0x3e/0x90 [cifs]
[ 6567.240749]  ? _raw_spin_lock+0x2f/0x40
[ 6567.240749]  cifs_mid_q_entry_release+0x28a/0x610 [cifs]
[ 6567.240749]  ? lock_release+0x1db/0x2b0
[ 6567.240749]  cifs_demultiplex_thread+0x848/0xf70 [cifs]
[ 6567.240749]  ? cifs_handle_standard+0x210/0x210 [cifs]
[ 6567.240749]  kthread+0xe8/0x110
[ 6567.240749]  ? kthread_complete_and_exit+0x20/0x20
[ 6567.240749]  ret_from_fork+0x22/0x30
[ 6567.240749]  </TASK>
[ 6567.252563] CIFS: VFS: \\win16.vm.test\Share Close unmatched open for MID:404
[ 6567.256753] CIFS: VFS: \\win16.vm.test\Share Close unmatched open for MID:405
[ 6567.269283] CIFS: VFS: \\win16.vm.test\Share Close unmatched open for MID:407
[ 6567.271962] CIFS: VFS: \\win16.vm.test\Share Close unmatched open for MID:408


-- 
Thanks,

Steve
