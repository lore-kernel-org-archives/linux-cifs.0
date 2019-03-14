Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58417C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 16:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F6A5217F5
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 16:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FAuUOYZ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfCNQMU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 12:12:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35222 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfCNQMU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 12:12:20 -0400
Received: by mail-qt1-f195.google.com with SMTP id h39so6710312qte.2
        for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2019 09:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WwF274cl90pvuQcgReptTUCw7nbE+9UtxQC+KMlILc0=;
        b=FAuUOYZ6LfaVb2gFB1cV6AxRDGgTPWGwobcTw0yiQ6ptKfIxBM4lFbHPaGuyo7PrCK
         +4bUNd3y/opqbh5ve1xRpNxyX4gmb3wFOyfFJHLD4yp4VNuj3SduAGqmYhWxHxB8AqA1
         JyfKdtARqGJJnEQU7wAbKAAsE1IfiKRzs+I+Qi7ufJlGWCTW2L5UdjHVRNq1Rc2t0NYY
         a2J2vWgwZupMzn1ux5L9X/61+V12/b2giCv2gvOUxSPXbLI8x1SkRA2es/T4Is4pzW/Q
         HG/e6gvIv2jMw+LjaS9QQjAPisZYdlTHL6PntFGJow8qOWmzK2uZxItWrX6pRnCz/KKE
         Txfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WwF274cl90pvuQcgReptTUCw7nbE+9UtxQC+KMlILc0=;
        b=CjEic20tw5ONqEYrrlwSxKnJWtPkxlT7QSu39UuBjjGCkZoC9qlSAINg1d/eGS8qAS
         bmYbdvMGRbVjWtFXlyMsZF6zTmmtCzmLkRsIpy5Nj5lYwaBytQpmLurDJifrK/SWOW9w
         Oh1r53awfJHS/FX+xrh+ZqbLt8MJaFQCXJwSTDoOBKRYa9nhtz16ybua/9MdHVj/QrR5
         qunPzgufTN0UO1exvAYS8FoBB0dmqO78PWmKMK/fNMdomybpsQvYw92jmZJgTpDvL++i
         1F+BpPZRRGuZ2LFRYJj8I6GtLcMb0T9yaKZhF/RiAjfDwdFyILpbNvvXsrhpUjmPMeoH
         Npog==
X-Gm-Message-State: APjAAAXFcszvFSSncJ125ysOem0LbsIq1f7mjWmkW6JF41Ng3b6AGdar
        u2ORuDYW/g3SW1/4/9ap9/UoXhfoEWRyNMqZ/Gc=
X-Google-Smtp-Source: APXvYqxuD3L3czzIHUNV/Qi0Sgh8pPr1Qv+uczooeiRSWOoHJ+Iap3ubp9fvjolKz9oIengp2x1buAhEk+WkbKqEFls=
X-Received: by 2002:ac8:25d9:: with SMTP id f25mr40284810qtf.156.1552579938962;
 Thu, 14 Mar 2019 09:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190314142503.GA21260@sh-el5.eng.rdu2.redhat.com>
In-Reply-To: <20190314142503.GA21260@sh-el5.eng.rdu2.redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 15 Mar 2019 02:12:07 +1000
Message-ID: <CAN05THTmpk5qs1eM-SK3kF0Ofn8Q=aJen9t6Cww72Y9fvsfgog@mail.gmail.com>
Subject: Re: [5.0+ CIFS regression] fsstress hang on CIFS
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Mar 15, 2019 at 12:25 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Hi,
>
> xfstests generic/013 on CIFS hangs on Linus tree now.
>
> Bisect points to
>
> commit 7091bcaba9f34c83e1e6f418b6de5c6d987571da (HEAD, refs/bisect/bad)
> Author: Pavel Shilovsky <pshilov@microsoft.com>
> Date:   Wed Jan 30 16:58:09 2019 -0800
>
>     CIFS: Try to acquire credits at once for compound requests
>
> as the first bad commit.
>
> It should be easy to reproduce.

I built a kernel at 7091bcaba9f34c83e1e6
and it passes generic/013 against a windows2016 server for me.

It could be a configuration difference.  What are the mount options
you use and what server do you use?

The code in the commit you find has been majorly re-worked in the
for-next branch: https://github.com/smfrench/smb3-kernel
Can you try cherry-picking these patches and see if the problem remains ?

https://github.com/smfrench/smb3-kernel/commit/4b62ba8c7e9380f7274e3b4c90d41ab5e329ba08
https://github.com/smfrench/smb3-kernel/commit/e2d79dccc7929257f7a2c824b397092de596b5c1
https://github.com/smfrench/smb3-kernel/commit/15736c7f36cd55ef8c4e5df65c1a97ecd4b6e44f
https://github.com/smfrench/smb3-kernel/commit/1bb731eaf331cec630a0371db2d0b79d5344d1e3
https://github.com/smfrench/smb3-kernel/commit/a32fd3e57c3b15b456bbf39235d6555a88e20600
https://github.com/smfrench/smb3-kernel/commit/9ed2d4dce312973e2f998d520f8c976c899e0dd9



regards
ronnie sahlberg



>
> Thanks,
> M
>
> dmesg:
> run fstests generic/013 at 2019-03-14 09:51:56
> INFO: task kworker/3:1:104 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/3:1     D    0   104      2 0x80000000
> Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
> INFO: task kworker/5:1:106 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/5:1     D    0   106      2 0x80000000
> Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  ? ttwu_do_wakeup+0x19/0x140
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
> INFO: task kworker/7:1:108 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/7:1     D    0   108      2 0x80000000
> Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  ? ttwu_do_wakeup+0x19/0x140
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
> INFO: task kworker/7:3:391 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/7:3     D    0   391      2 0x80000000
> Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  ? ttwu_do_wakeup+0x19/0x140
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
> INFO: task kworker/1:3:807 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/1:3     D    0   807      2 0x80000000
> Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
> INFO: task kworker/13:2:1077 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/13:2    D    0  1077      2 0x80000080
> Workqueue: cifsiod cifs_uncached_readv_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  ? __switch_to_asm+0x40/0x70
>  cifs_uncached_readv_complete+0x78/0x4d0 [cifs]
>  ? __switch_to_asm+0x34/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
> INFO: task kworker/3:0:1910 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/3:0     D    0  1910      2 0x80000080
> Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
> INFO: task kworker/5:5:3930 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/5:5     D    0  3930      2 0x80000080
> Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
> INFO: task kworker/1:2:3932 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/1:2     D    0  3932      2 0x80000080
> Workqueue: cifsiod cifs_uncached_readv_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  ? __switch_to_asm+0x40/0x70
>  cifs_uncached_readv_complete+0x78/0x4d0 [cifs]
>  ? __switch_to_asm+0x34/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
> INFO: task kworker/1:5:3934 blocked for more than 120 seconds.
>       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/1:5     D    0  3934      2 0x80000080
> Workqueue: cifsiod cifs_uncached_readv_complete [cifs]
> Call Trace:
>  ? __schedule+0x24e/0x860
>  schedule+0x28/0x70
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.8+0x2d0/0x4b0
>  ? __switch_to_asm+0x40/0x70
>  cifs_uncached_readv_complete+0x78/0x4d0 [cifs]
>  ? __switch_to_asm+0x34/0x70
>  process_one_work+0x1a1/0x3a0
>  worker_thread+0x30/0x380
>  ? mod_delayed_work_on+0x90/0x90
>  kthread+0x112/0x130
>  ? __kthread_parkme+0x70/0x70
>  ret_from_fork+0x35/0x40
