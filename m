Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD804E7E65A
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Sep 2023 19:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbjIZTSX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Sep 2023 15:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjIZTSX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Sep 2023 15:18:23 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92A9DE
        for <linux-cifs@vger.kernel.org>; Tue, 26 Sep 2023 12:18:15 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6c4bad60a1aso3949489a34.2
        for <linux-cifs@vger.kernel.org>; Tue, 26 Sep 2023 12:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695755895; x=1696360695; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:content-language:user-agent
         :mime-version:date:message-id:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GqLbi2X2UFgOQuYCx5q3bwt8gMD7866DbojQIUYpl6w=;
        b=UihqLjWq/IJ74CS+4mLC5Mzxo9hwshscxFuwCyStdmdljomnubztbqdUkvSN6zYbHL
         JnmEZuK4Zof+27p9vn+GRyg1wk88TC6++lO26yCCVS8CfUwq1ydC7TnA3cxUMP26yf5m
         zWAegfT/MwVF15IRGhKPE56Gpm7ZsSl1Iq6dZckcDWwAU/rSK0EMwE74joAay6/bKSWw
         CvtdhvYvouK3Xrl2qGznvLH6cpIxPecWoRk7wOn2cuw0GaObM2Os+2Udk6zxgDok8WHK
         ntHNbXnOsOGFVHs+BJBbxCwp5xBDiHcANOlFmXqs4WoPoifxBd4rc6iYHWFjAMjFh14e
         1VsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695755895; x=1696360695;
        h=content-transfer-encoding:to:subject:content-language:user-agent
         :mime-version:date:message-id:from:sender:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GqLbi2X2UFgOQuYCx5q3bwt8gMD7866DbojQIUYpl6w=;
        b=uwJUcZmOegyjmv/o4Z8Aj09BqyNcIbunuIk7hJ3DWqXgg4LGuVmN1MtI0qTF86Tu14
         FeZsbObUcswFWfnMMULDAhm8IGmL5/O0cv6xNjd/4ELY+v2yynMCgVFpg+4ZYVr2RwRL
         hvTbWAilxtMQF74WutfNCFsu73R15uql0mm4tuSyfGpuKL9bzLVnhEdS6z2lsqhgIKYg
         7GJI/q9rJct08mGr2xXzdzECUz4MPnxvzQ4PPaXlzTgzczxDw5bHBE5b7tLnvQthn4vq
         jxf9dcvIWSeyrTXKIZSbRkvUVL9ct2ulLo9O8RouFDJP3n818X5L95cqxZ2E/nOfYX5T
         snuw==
X-Gm-Message-State: AOJu0YyRvdfif6lj9bOCrNuWs1LdZwCNHIRdLFb+BPc8W9/b9ZuYhJ/v
        D2zJMriWSTGoEHjEg8k6RX8twnMUJn8=
X-Google-Smtp-Source: AGHT+IHWMFBUY65brBz1qdVAb2JV/xfch6V7p/ditB4Szu+gJrRCiNU0Fy7ty0++ta6V5V7C656iPg==
X-Received: by 2002:a05:6870:5623:b0:1d5:a377:f360 with SMTP id m35-20020a056870562300b001d5a377f360mr12870049oao.41.1695755894639;
        Tue, 26 Sep 2023 12:18:14 -0700 (PDT)
Received: from [172.16.0.69] (c-67-184-72-25.hsd1.il.comcast.net. [67.184.72.25])
        by smtp.gmail.com with ESMTPSA id t6-20020a0c8d86000000b0065b1bcd0d33sm1466545qvb.93.2023.09.26.12.18.14
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 12:18:14 -0700 (PDT)
Sender: Frank Sorenson <frank.sorenson@gmail.com>
From:   Frank Sorenson <frank@tuxrocks.com>
X-Google-Original-From: Frank Sorenson <sorenson@redhat.com>
Message-ID: <e04c7696-fc8a-b799-13f9-2cc051ba80dd@redhat.com>
Date:   Tue, 26 Sep 2023 14:18:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
Subject: possible circular locking dependency detected warning and deadlock
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I'm getting a 'WARNING: possible circular locking dependency detected' 
followed by a DEADLOCK when I access /proc/fs/cifs/DebugData while doing 
a lot of mounts/unmounts/IO, etc.

The kernel is 6.6.0-rc1+

I have not nailed down a reliable reproducer, however I can hit this 
with some regularity by looping 'cat /proc/fs/cifs/DebugData 
 >/dev/null', mounting and unmounting, and doing some reads/writes.


Sep 23 22:19:54 vm25 kernel: 
======================================================
Sep 23 22:19:54 vm25 kernel: WARNING: possible circular locking 
dependency detected
Sep 23 22:19:54 vm25 kernel: 6.6.0-rc1+ #4 Not tainted
Sep 23 22:19:54 vm25 kernel: 
------------------------------------------------------
Sep 23 22:19:54 vm25 kernel: cat/4414 is trying to acquire lock:
Sep 23 22:19:54 vm25 kernel: ffff8880660a8280 
(&tcp_ses->mid_lock){+.+.}-{2:2}, at: 
cifs_debug_data_proc_show+0x16bf/0x27c0 [cifs]
Sep 23 22:19:54 vm25 kernel: #012but task is already holding lock:
Sep 23 22:19:54 vm25 kernel: ffff888066af3328 
(&ret_buf->chan_lock){+.+.}-{2:2}, at: 
cifs_debug_data_proc_show+0x15cc/0x27c0 [cifs]
Sep 23 22:19:54 vm25 kernel: #012which lock already depends on the new lock.
Sep 23 22:19:54 vm25 kernel: #012the existing dependency chain (in 
reverse order) is:
Sep 23 22:19:54 vm25 kernel: #012-> #2 (&ret_buf->chan_lock){+.+.}-{2:2}:
Sep 23 22:19:54 vm25 kernel:       __lock_acquire+0xbd6/0x1c00
Sep 23 22:19:54 vm25 kernel:       lock_acquire+0x1da/0x5e0
Sep 23 22:19:54 vm25 kernel:       _raw_spin_lock+0x34/0x80
Sep 23 22:19:54 vm25 kernel: cifs_chan_update_iface+0x2d/0xbc0 [cifs]
Sep 23 22:19:54 vm25 kernel: 
cifs_mark_tcp_ses_conns_for_reconnect+0x3f7/0x630 [cifs]
Sep 23 22:19:54 vm25 kernel:       __cifs_reconnect+0x5c/0x710 [cifs]
Sep 23 22:19:54 vm25 kernel: cifs_readv_from_socket+0x5b5/0x810 [cifs]
Sep 23 22:19:54 vm25 kernel: cifs_read_from_socket+0xb1/0xf0 [cifs]
Sep 23 22:19:54 vm25 kernel: cifs_demultiplex_thread+0x28c/0x1840 [cifs]
Sep 23 22:19:54 vm25 kernel:       kthread+0x2f1/0x3d0
Sep 23 22:19:54 vm25 kernel:       ret_from_fork+0x2d/0x70
Sep 23 22:19:54 vm25 kernel:       ret_from_fork_asm+0x1b/0x30
Sep 23 22:19:54 vm25 kernel: #012-> #1 (&cifs_tcp_ses_lock){+.+.}-{2:2}:
Sep 23 22:19:54 vm25 kernel:       __lock_acquire+0xbd6/0x1c00
Sep 23 22:19:54 vm25 kernel:       lock_acquire+0x1da/0x5e0
Sep 23 22:19:54 vm25 kernel:       _raw_spin_lock+0x34/0x80
Sep 23 22:19:54 vm25 kernel:       smb2_find_smb_tcon+0x22/0x1d0 [cifs]
Sep 23 22:19:54 vm25 kernel: smb2_handle_cancelled_mid+0x203/0x470 [cifs]
Sep 23 22:19:54 vm25 kernel:       __release_mid+0x3c5/0xdc0 [cifs]
Sep 23 22:19:54 vm25 kernel:       release_mid+0x72/0xa0 [cifs]
Sep 23 22:19:54 vm25 kernel: cifs_demultiplex_thread+0x898/0x1840 [cifs]
Sep 23 22:19:54 vm25 kernel:       kthread+0x2f1/0x3d0
Sep 23 22:19:54 vm25 kernel:       ret_from_fork+0x2d/0x70
Sep 23 22:19:54 vm25 kernel:       ret_from_fork_asm+0x1b/0x30
Sep 23 22:19:54 vm25 kernel: #012-> #0 (&tcp_ses->mid_lock){+.+.}-{2:2}:
Sep 23 22:19:54 vm25 kernel:       check_prev_add+0x1bd/0x23a0
Sep 23 22:19:54 vm25 kernel:       validate_chain+0xb02/0xf30
Sep 23 22:19:54 vm25 kernel:       __lock_acquire+0xbd6/0x1c00
Sep 23 22:19:54 vm25 kernel:       lock_acquire+0x1da/0x5e0
Sep 23 22:19:54 vm25 kernel:       _raw_spin_lock+0x34/0x80
Sep 23 22:19:54 vm25 kernel: cifs_debug_data_proc_show+0x16bf/0x27c0 [cifs]
Sep 23 22:19:54 vm25 kernel:       seq_read_iter+0x410/0x10a0
Sep 23 22:19:54 vm25 kernel: proc_reg_read_iter+0x1a2/0x270
Sep 23 22:19:54 vm25 kernel:       vfs_read+0x3d9/0x780
Sep 23 22:19:54 vm25 kernel:       ksys_read+0xf1/0x1d0
Sep 23 22:19:54 vm25 kernel:       do_syscall_64+0x59/0x90
Sep 23 22:19:54 vm25 kernel: entry_SYSCALL_64_after_hwframe+0x6e/0xd8
Sep 23 22:19:54 vm25 kernel: #012other info that might help us debug this:
Sep 23 22:19:54 vm25 kernel: Chain exists of:#012 &tcp_ses->mid_lock --> 
&cifs_tcp_ses_lock --> &ret_buf->chan_lock
Sep 23 22:19:54 vm25 kernel: Possible unsafe locking scenario:
Sep 23 22:19:54 vm25 kernel:       CPU0                    CPU1
Sep 23 22:19:54 vm25 kernel:       ----                    ----
Sep 23 22:19:54 vm25 kernel:  lock(&ret_buf->chan_lock);
Sep 23 22:19:54 vm25 kernel: lock(&cifs_tcp_ses_lock);
Sep 23 22:19:54 vm25 kernel: lock(&ret_buf->chan_lock);
Sep 23 22:19:54 vm25 kernel:  lock(&tcp_ses->mid_lock);
Sep 23 22:19:54 vm25 kernel: #012 *** DEADLOCK ***
Sep 23 22:19:54 vm25 kernel: 3 locks held by cat/4414:
Sep 23 22:19:54 vm25 kernel: #0: ffff88804fe4c6c0 
(&p->lock){+.+.}-{3:3}, at: seq_read_iter+0xc7/0x10a0
Sep 23 22:19:54 vm25 kernel: #1: ffffffffc23d8458 
(&cifs_tcp_ses_lock){+.+.}-{2:2}, at: 
cifs_debug_data_proc_show+0x17f/0x27c0 [cifs]
Sep 23 22:19:54 vm25 kernel: #2: ffff888066af3328 
(&ret_buf->chan_lock){+.+.}-{2:2}, at: 
cifs_debug_data_proc_show+0x15cc/0x27c0 [cifs]
Sep 23 22:19:54 vm25 kernel: #012stack backtrace:
Sep 23 22:19:54 vm25 kernel: CPU: 3 PID: 4414 Comm: cat Not tainted 
6.6.0-rc1+ #4
Sep 23 22:19:54 vm25 kernel: Hardware name: QEMU Standard PC (i440FX + 
PIIX, 1996), BIOS edk2-20230524-3.fc37 05/24/2023
Sep 23 22:19:54 vm25 kernel: Call Trace:
Sep 23 22:19:54 vm25 kernel: <TASK>
Sep 23 22:19:54 vm25 kernel: dump_stack_lvl+0x60/0xb0
Sep 23 22:19:54 vm25 kernel: check_noncircular+0x2f9/0x3e0
Sep 23 22:19:54 vm25 kernel: ? __pfx_check_noncircular+0x10/0x10
Sep 23 22:19:54 vm25 kernel: ? save_trace+0x8b/0x3e0
Sep 23 22:19:54 vm25 kernel: ? alloc_chain_hlocks+0x1de/0x520
Sep 23 22:19:54 vm25 kernel: check_prev_add+0x1bd/0x23a0
Sep 23 22:19:54 vm25 kernel: validate_chain+0xb02/0xf30
Sep 23 22:19:54 vm25 kernel: ? __pfx_validate_chain+0x10/0x10
Sep 23 22:19:54 vm25 kernel: ? __pfx_format_decode+0x10/0x10
Sep 23 22:19:54 vm25 kernel: __lock_acquire+0xbd6/0x1c00
Sep 23 22:19:54 vm25 kernel: ? local_clock_noinstr+0x9/0xc0
Sep 23 22:19:54 vm25 kernel: lock_acquire+0x1da/0x5e0
Sep 23 22:19:54 vm25 kernel: ? cifs_debug_data_proc_show+0x16bf/0x27c0 
[cifs]
Sep 23 22:19:54 vm25 kernel: ? seq_printf+0x17c/0x240
Sep 23 22:19:54 vm25 kernel: ? __pfx_lock_acquire+0x10/0x10
Sep 23 22:19:54 vm25 kernel: ? __pfx_seq_printf+0x10/0x10
Sep 23 22:19:54 vm25 kernel: ? __pfx___lock_acquired+0x10/0x10
Sep 23 22:19:54 vm25 kernel: ? do_raw_spin_trylock+0xb5/0x180
Sep 23 22:19:54 vm25 kernel: ? __pfx_do_raw_spin_trylock+0x10/0x10
Sep 23 22:19:54 vm25 kernel: _raw_spin_lock+0x34/0x80
Sep 23 22:19:54 vm25 kernel: ? cifs_debug_data_proc_show+0x16bf/0x27c0 
[cifs]
Sep 23 22:19:54 vm25 kernel: cifs_debug_data_proc_show+0x16bf/0x27c0 [cifs]
Sep 23 22:19:54 vm25 kernel: ? __kmem_cache_alloc_node+0x237/0x380
Sep 23 22:19:54 vm25 kernel: ? seq_read_iter+0x6a5/0x10a0
Sep 23 22:19:54 vm25 kernel: ? rcu_is_watching+0x11/0xb0
Sep 23 22:19:54 vm25 kernel: ? __kmalloc_node+0x101/0x190
Sep 23 22:19:54 vm25 kernel: seq_read_iter+0x410/0x10a0
Sep 23 22:19:54 vm25 kernel: ? selinux_file_permission+0x358/0x440
Sep 23 22:19:54 vm25 kernel: proc_reg_read_iter+0x1a2/0x270
Sep 23 22:19:54 vm25 kernel: vfs_read+0x3d9/0x780
Sep 23 22:19:54 vm25 kernel: ? __pfx_vfs_read+0x10/0x10
Sep 23 22:19:54 vm25 kernel: ? __lock_release+0x48a/0x960
Sep 23 22:19:54 vm25 kernel: ? __fget_light+0x51/0x220
Sep 23 22:19:54 vm25 kernel: ksys_read+0xf1/0x1d0
Sep 23 22:19:54 vm25 kernel: ? __pfx_ksys_read+0x10/0x10
Sep 23 22:19:54 vm25 kernel: ? ktime_get_coarse_real_ts64+0x130/0x170
Sep 23 22:19:54 vm25 kernel: do_syscall_64+0x59/0x90
Sep 23 22:19:54 vm25 kernel: ? exc_page_fault+0xaa/0xe0
Sep 23 22:19:54 vm25 kernel: ? asm_exc_page_fault+0x22/0x30
Sep 23 22:19:54 vm25 kernel: ? lockdep_hardirqs_on+0x79/0x100
Sep 23 22:19:54 vm25 kernel: entry_SYSCALL_64_after_hwframe+0x6e/0xd8
Sep 23 22:19:54 vm25 kernel: RIP: 0033:0x7fcc5a744082
Sep 23 22:19:54 vm25 kernel: Code: c0 e9 b2 fe ff ff 50 48 8d 3d ca 05 
08 00 e8 35 e7 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 
85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 
28 48 89 54 24
Sep 23 22:19:54 vm25 kernel: RSP: 002b:00007ffe9b154468 EFLAGS: 00000246 
ORIG_RAX: 0000000000000000
Sep 23 22:19:54 vm25 kernel: RAX: ffffffffffffffda RBX: 0000000000020000 
RCX: 00007fcc5a744082
Sep 23 22:19:54 vm25 kernel: RDX: 0000000000020000 RSI: 00007fcc5a828000 
RDI: 0000000000000003
Sep 23 22:19:54 vm25 kernel: RBP: 00007fcc5a828000 R08: 00007fcc5a827010 
R09: 0000000000000000
Sep 23 22:19:54 vm25 kernel: R10: 0000000000000022 R11: 0000000000000246 
R12: 0000000000022000
Sep 23 22:19:54 vm25 kernel: R13: 0000000000000003 R14: 0000000000020000 
R15: 0000000000020000
Sep 23 22:19:54 vm25 kernel: </TASK>


Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

