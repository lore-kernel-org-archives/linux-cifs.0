Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C95BC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 18:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A6012077B
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 18:40:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bLvhAeuT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfCNSkU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 14:40:20 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43728 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfCNSkU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 14:40:20 -0400
Received: by mail-lf1-f66.google.com with SMTP id g7so5006557lfh.10
        for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2019 11:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lT9eWGwXWzTzuD6aw7b9KrpWZTYdsAqfCNuWnWeNWos=;
        b=bLvhAeuTkBnLm5koV4BMaTP2GfjCPUDsku6sS4D+uYyT3XxpMT3kZMuZ83kN6VKth+
         YqsVyfRTWZnoSnaJLZC6FMknwJ2deLj5rAmcyDmj7NvbizEZe/I8e9kjJhdyj/d0n0Ll
         RruCUGvrMEqkr4aOnlt1Dk1enz7feeiotFeTp+QQFXjU9PBmaM6pFyxTmp4CnJZHQcgw
         1j/9K6y0msoFxqh/Lh36fh3zMD3mxw2I0rrB2qRk8A8f79WSVZgrWmjnlYSPLmWTHTkY
         9WwY0kEu7LP73WzAO3wMv6ladew7TQv0+1j0sDQeEVndy+sPZW/hvVp7IyQQ0YHYjNWF
         0g4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lT9eWGwXWzTzuD6aw7b9KrpWZTYdsAqfCNuWnWeNWos=;
        b=FmSJqtldaMlCucB2MEVZcmM5/RxZBHXluw1PuPmDvxHq5x4YyOxGluOqZIrlGfpuBh
         9IAdKxZFtadvI+oXsAc7fAZOP+QjH6SmF3OqeM4uCvyieHAawVU+lQIZVSIipnZ+JYBy
         0NK9uMEzdKdiS+kdusEyMfqKWRhKqjiQ3gw1qIPefryHuk3sI9dvUWm78g1zSbVb7hVt
         knJUuVCn+ZEnu0HeA1SmRmVY88W4Z3CdGTEhYsCqtlI0Ya64VAf/dauI7kx1JSJKeM7w
         GXU3zJeML5eNrhgxp7dsD+uLAeU9KL5wlD09+81WcZwD/FUJaWJDlSUE3upZsUxtN8Na
         ZvJg==
X-Gm-Message-State: APjAAAXu7Ewh4UQ3PPaql87JMlkwzcGDe1bEH/vWwnCLKwZNcj6w00nV
        EDIuG3i5q4AmoJ6pbq9dxv8tNhD3UdqD3XiWJ38iY9E=
X-Google-Smtp-Source: APXvYqyps/qjb4yb07IGv3htNYLyN7jUGHnDQnE8nquAoWgMfd9HvceneK3uwg58B8C5LRGm54iiJ8bUFMvWUl1ULgA=
X-Received: by 2002:a19:2d44:: with SMTP id t4mr27383430lft.90.1552588817127;
 Thu, 14 Mar 2019 11:40:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190314142503.GA21260@sh-el5.eng.rdu2.redhat.com> <CAN05THTmpk5qs1eM-SK3kF0Ofn8Q=aJen9t6Cww72Y9fvsfgog@mail.gmail.com>
In-Reply-To: <CAN05THTmpk5qs1eM-SK3kF0Ofn8Q=aJen9t6Cww72Y9fvsfgog@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 14 Mar 2019 11:40:06 -0700
Message-ID: <CAKywueTkWiEuux17PM5f7=myRiDUoqZJNkrUGw-ZvscXnPu=dw@mail.gmail.com>
Subject: Re: [5.0+ CIFS regression] fsstress hang on CIFS
To:     Murphy Zhou <jencce.kernel@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 14 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 09:14, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
> On Fri, Mar 15, 2019 at 12:25 AM Murphy Zhou <jencce.kernel@gmail.com> wr=
ote:
> >
> > Hi,
> >
> > xfstests generic/013 on CIFS hangs on Linus tree now.
> >
> > Bisect points to
> >
> > commit 7091bcaba9f34c83e1e6f418b6de5c6d987571da (HEAD, refs/bisect/bad)
> > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > Date:   Wed Jan 30 16:58:09 2019 -0800
> >
> >     CIFS: Try to acquire credits at once for compound requests
> >
> > as the first bad commit.
> >
> > It should be easy to reproduce.
>
> I built a kernel at 7091bcaba9f34c83e1e6
> and it passes generic/013 against a windows2016 server for me.
>
> It could be a configuration difference.  What are the mount options
> you use and what server do you use?
>
> The code in the commit you find has been majorly re-worked in the
> for-next branch: https://github.com/smfrench/smb3-kernel
> Can you try cherry-picking these patches and see if the problem remains ?
>
> https://github.com/smfrench/smb3-kernel/commit/4b62ba8c7e9380f7274e3b4c90=
d41ab5e329ba08
> https://github.com/smfrench/smb3-kernel/commit/e2d79dccc7929257f7a2c824b3=
97092de596b5c1
> https://github.com/smfrench/smb3-kernel/commit/15736c7f36cd55ef8c4e5df65c=
1a97ecd4b6e44f
> https://github.com/smfrench/smb3-kernel/commit/1bb731eaf331cec630a0371db2=
d0b79d5344d1e3
> https://github.com/smfrench/smb3-kernel/commit/a32fd3e57c3b15b456bbf39235=
d6555a88e20600
> https://github.com/smfrench/smb3-kernel/commit/9ed2d4dce312973e2f998d520f=
8c976c899e0dd9
>
>
>
> regards
> ronnie sahlberg
>
>
>
> >
> > Thanks,
> > M
> >
> > dmesg:
> > run fstests generic/013 at 2019-03-14 09:51:56
> > INFO: task kworker/3:1:104 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/3:1     D    0   104      2 0x80000000
> > Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x34/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40
> > INFO: task kworker/5:1:106 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/5:1     D    0   106      2 0x80000000
> > Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  ? ttwu_do_wakeup+0x19/0x140
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x34/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40
> > INFO: task kworker/7:1:108 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/7:1     D    0   108      2 0x80000000
> > Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  ? ttwu_do_wakeup+0x19/0x140
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x34/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40
> > INFO: task kworker/7:3:391 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/7:3     D    0   391      2 0x80000000
> > Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  ? ttwu_do_wakeup+0x19/0x140
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x34/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40
> > INFO: task kworker/1:3:807 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/1:3     D    0   807      2 0x80000000
> > Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x34/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40
> > INFO: task kworker/13:2:1077 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/13:2    D    0  1077      2 0x80000080
> > Workqueue: cifsiod cifs_uncached_readv_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  ? __switch_to_asm+0x40/0x70
> >  cifs_uncached_readv_complete+0x78/0x4d0 [cifs]
> >  ? __switch_to_asm+0x34/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40
> > INFO: task kworker/3:0:1910 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/3:0     D    0  1910      2 0x80000080
> > Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x34/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40
> > INFO: task kworker/5:5:3930 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/5:5     D    0  3930      2 0x80000080
> > Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  cifs_uncached_writev_complete+0xcd/0x570 [cifs]
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  ? __switch_to_asm+0x34/0x70
> >  ? __switch_to_asm+0x40/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40
> > INFO: task kworker/1:2:3932 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/1:2     D    0  3932      2 0x80000080
> > Workqueue: cifsiod cifs_uncached_readv_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  ? __switch_to_asm+0x40/0x70
> >  cifs_uncached_readv_complete+0x78/0x4d0 [cifs]
> >  ? __switch_to_asm+0x34/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40
> > INFO: task kworker/1:5:3934 blocked for more than 120 seconds.
> >       Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > kworker/1:5     D    0  3934      2 0x80000080
> > Workqueue: cifsiod cifs_uncached_readv_complete [cifs]
> > Call Trace:
> >  ? __schedule+0x24e/0x860
> >  schedule+0x28/0x70
> >  schedule_preempt_disabled+0xa/0x10
> >  __mutex_lock.isra.8+0x2d0/0x4b0
> >  ? __switch_to_asm+0x40/0x70
> >  cifs_uncached_readv_complete+0x78/0x4d0 [cifs]
> >  ? __switch_to_asm+0x34/0x70
> >  process_one_work+0x1a1/0x3a0
> >  worker_thread+0x30/0x380
> >  ? mod_delayed_work_on+0x90/0x90
> >  kthread+0x112/0x130
> >  ? __kthread_parkme+0x70/0x70
> >  ret_from_fork+0x35/0x40

(cc'ing Long)

I think this is one more occurrence of the known bug in the direct IO
resend code path: the process is most likely stuck in
cifs_resend_wdata thus not allowing other process to acquire the
mutex. We had two patches fixing it that is currently being re-worked:

https://patchwork.kernel.org/patch/10836349/
https://patchwork.kernel.org/patch/10836355/

But you can try them out to see if they fix your issue.

--
Best regards,
Pavel Shilovsky
