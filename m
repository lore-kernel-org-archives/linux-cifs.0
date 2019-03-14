Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D965AC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 15:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CDFA217F5
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 15:29:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mqsA1vK+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfCNP3e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:29:34 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43418 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfCNP3d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 11:29:33 -0400
Received: by mail-qk1-f196.google.com with SMTP id s26so3560150qkm.10
        for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2019 08:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nr9TRBQzGnfVNFBkUp9I1JLn8t/WrBTib91hy2sY0X0=;
        b=mqsA1vK+/nRWF6Lp0IFVlgwnxHJdguXfV6C83ckrXAriMbm1P9Y+bcAz4fok3DhxzR
         6GvWnWQB8NRqn61g9v+5WXWms/CTRz2ghHnVi7Y66Dowkc9S6TLmV8hG2mzS5FksLuUs
         vOWlK+h318lc4oz0C9kJao2g26zUlwYEeRobZo7sAQCdIp+gkbanAKiKJHc9NRRm3JRT
         NmUQmS1wVmFJcZ0qBQIpwEaVzy7B90dV5DLWfsmGIOAbOELGwFJMKaqs3LcMxvHV8E4C
         o+jhV+eNkIe+y0EZeWzTWI99PSLdWGq76Za9k3YJVrmTQcoWwVM/KUexkb/qdIIrEKP0
         OaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nr9TRBQzGnfVNFBkUp9I1JLn8t/WrBTib91hy2sY0X0=;
        b=sbipaECYIf3gFklccMaark5R40OcOO0lpBlMmnNK8XBxmhp27lH/M32wLhlzYLShoI
         wLRgwu1RBzcRbxEmXBpklesfFlFSTXEg7Y4z3TZx4S85UqITPIyIWt8ZZLDqNpqhOMDS
         WLdzpjMz75RwEuVSwBmJMJ0yDzXCNW6nle0Mcja2viw4WsuO/7kZCa/FO+PMYJTyfVg8
         67VSHmf3iHUE5AKraWplt3KAPzlPJLLhniFgK3CRKOER6a8iewZvF3dtlIK7CHZ8b791
         fYO/qWYbflQTeKEJxLxFR0TEE4BWXY8S1Rkv1dMt+C9RJ58yV/tYeviYgnG+VW+is2qj
         lbFA==
X-Gm-Message-State: APjAAAUQ+ly9YcbQ49LeyiPDIV/vMiocBAtvo9A+lNFTguHEJ7AJJ/qB
        MicE6Y61SDG8cOnfcoGvBxWijssMlKE8kxnOcvA=
X-Google-Smtp-Source: APXvYqwujyKjK55SdQhx+INOFNgbqo4i5n5kf0HrRyH7Ha3bKNRMSShQoJjb97rr1pbma4JnViBs8Fxb6AuB3SPritw=
X-Received: by 2002:a37:6812:: with SMTP id d18mr19680276qkc.28.1552577372390;
 Thu, 14 Mar 2019 08:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190314142503.GA21260@sh-el5.eng.rdu2.redhat.com>
In-Reply-To: <20190314142503.GA21260@sh-el5.eng.rdu2.redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 15 Mar 2019 01:29:20 +1000
Message-ID: <CAN05THSZcjPRijsWsrk8WLAAcMpZW3QvYuVoDiMgpboiuFSuaQ@mail.gmail.com>
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

generic/013 works on Steves for-next branch, but it contains changes
in this area.
We do have generic/013 in our buildbot so it should have been tested and passed.

Can you describe your configuration? It could be a configuration that
we do not have proper cover for.



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
