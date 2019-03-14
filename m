Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481D8C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 14:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A98021019
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 14:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfCNOZF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:25:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbfCNOZF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Mar 2019 10:25:05 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD2FE30EEF70;
        Thu, 14 Mar 2019 14:25:04 +0000 (UTC)
Received: from sh-el5.eng.rdu2.redhat.com (sh-el5.eng.rdu2.redhat.com [10.10.160.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EF9217D1C;
        Thu, 14 Mar 2019 14:25:04 +0000 (UTC)
Received: from sh-el5.eng.rdu2.redhat.com (localhost.localdomain [127.0.0.1])
        by sh-el5.eng.rdu2.redhat.com (8.13.8/8.13.8) with ESMTP id x2EEP3gl021322;
        Thu, 14 Mar 2019 10:25:03 -0400
Received: (from xzhou@localhost)
        by sh-el5.eng.rdu2.redhat.com (8.13.8/8.13.8/Submit) id x2EEP34D021321;
        Thu, 14 Mar 2019 10:25:03 -0400
Date:   Thu, 14 Mar 2019 10:25:03 -0400
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [5.0+ CIFS regression] fsstress hang on CIFS
Message-ID: <20190314142503.GA21260@sh-el5.eng.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 14 Mar 2019 14:25:04 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

xfstests generic/013 on CIFS hangs on Linus tree now.

Bisect points to

commit 7091bcaba9f34c83e1e6f418b6de5c6d987571da (HEAD, refs/bisect/bad)
Author: Pavel Shilovsky <pshilov@microsoft.com>
Date:   Wed Jan 30 16:58:09 2019 -0800

    CIFS: Try to acquire credits at once for compound requests

as the first bad commit.

It should be easy to reproduce.

Thanks,
M

dmesg:
run fstests generic/013 at 2019-03-14 09:51:56
INFO: task kworker/3:1:104 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/3:1     D    0   104      2 0x80000000
Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 cifs_uncached_writev_complete+0xcd/0x570 [cifs]
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
INFO: task kworker/5:1:106 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/5:1     D    0   106      2 0x80000000
Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 ? ttwu_do_wakeup+0x19/0x140
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 cifs_uncached_writev_complete+0xcd/0x570 [cifs]
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
INFO: task kworker/7:1:108 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/7:1     D    0   108      2 0x80000000
Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 ? ttwu_do_wakeup+0x19/0x140
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 cifs_uncached_writev_complete+0xcd/0x570 [cifs]
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
INFO: task kworker/7:3:391 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/7:3     D    0   391      2 0x80000000
Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 ? ttwu_do_wakeup+0x19/0x140
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 cifs_uncached_writev_complete+0xcd/0x570 [cifs]
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
INFO: task kworker/1:3:807 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:3     D    0   807      2 0x80000000
Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 cifs_uncached_writev_complete+0xcd/0x570 [cifs]
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
INFO: task kworker/13:2:1077 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/13:2    D    0  1077      2 0x80000080
Workqueue: cifsiod cifs_uncached_readv_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 ? __switch_to_asm+0x40/0x70
 cifs_uncached_readv_complete+0x78/0x4d0 [cifs]
 ? __switch_to_asm+0x34/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
INFO: task kworker/3:0:1910 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/3:0     D    0  1910      2 0x80000080
Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 cifs_uncached_writev_complete+0xcd/0x570 [cifs]
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
INFO: task kworker/5:5:3930 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/5:5     D    0  3930      2 0x80000080
Workqueue: cifsiod cifs_uncached_writev_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 cifs_uncached_writev_complete+0xcd/0x570 [cifs]
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
INFO: task kworker/1:2:3932 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:2     D    0  3932      2 0x80000080
Workqueue: cifsiod cifs_uncached_readv_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 ? __switch_to_asm+0x40/0x70
 cifs_uncached_readv_complete+0x78/0x4d0 [cifs]
 ? __switch_to_asm+0x34/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
INFO: task kworker/1:5:3934 blocked for more than 120 seconds.
      Not tainted 5.0.0-bisect-7091bcaba9f3+ #15
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:5     D    0  3934      2 0x80000080
Workqueue: cifsiod cifs_uncached_readv_complete [cifs]
Call Trace:
 ? __schedule+0x24e/0x860
 schedule+0x28/0x70
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.isra.8+0x2d0/0x4b0
 ? __switch_to_asm+0x40/0x70
 cifs_uncached_readv_complete+0x78/0x4d0 [cifs]
 ? __switch_to_asm+0x34/0x70
 process_one_work+0x1a1/0x3a0
 worker_thread+0x30/0x380
 ? mod_delayed_work_on+0x90/0x90
 kthread+0x112/0x130
 ? __kthread_parkme+0x70/0x70
 ret_from_fork+0x35/0x40
