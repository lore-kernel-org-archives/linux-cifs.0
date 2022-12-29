Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF6DC4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 03:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiL2D0R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Dec 2022 22:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiL2D0Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Dec 2022 22:26:16 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448BEFAEA
        for <linux-cifs@vger.kernel.org>; Wed, 28 Dec 2022 19:26:14 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id j17so16456522lfr.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Dec 2022 19:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tvG/Du20VyVVqDR9fWM/fuxG7WUXf9V0dRwSaZuSWrU=;
        b=CuYvyp0BdzxJHnopoo40n91Y0RnqwAjK/yvxNakCurHcYIxMEvMvW3G37R8IwlDDDP
         v/zNn/PHxvwFiZ0OM1s2RBQjQoFCgg/2xRFJb3aX8I0uK8COE9nrIFx+UVJPsEfCwpDt
         xh8AXSTCkIo4rCSohgApQMHDrBlDidLugVkc72VqIFP66dvbJFOXatx7Eq4eK761VB2H
         QhoQkhDf+nBRrMxeEa3kAR8lE22CSQ6O5jt82WuoR3HUOMpHoqmdZ64KOqdC04EnfCQs
         k6MQtZwPCsDLEWnQW1Gen7ffTXelzF/rT0fgVElV7AXYwLSnMFflKoh2QzBMbQkWtCKb
         1RQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tvG/Du20VyVVqDR9fWM/fuxG7WUXf9V0dRwSaZuSWrU=;
        b=2VXzzgP2lWDanP8NMq7iF0pLLG3dVttj59lI2Mvjj/r1YpP+QhBIHaQxn7uJfHOb2r
         5Hq+yg7XrKVHoRUGATcZi2pB2Fh6ooIvGHrT+/U/yd58+WAWsw66ebal6h4AmgQ8/lKy
         lLCOoDYOSPedjJ3nnuLThumkPuOfYvjhYY6nRZU9zNbI/NeTObVV/yg1dZSwdpcTnoom
         wUHb7ktxSGtms8S8skgPwPDFyXjt3pKqYtQr63l6JAIGaj4rKElKSnIQsLW5YSV6DsSF
         IoNK+pHI1VJo4N6EBqSw+bmTfEAZ8U028uPqaN1WTR0D/xsrxgt5DrWBC3CKbXpCRcYv
         KfoQ==
X-Gm-Message-State: AFqh2kqHo/T7OwHXfrzHzyordthzaff2/GRjXB1aF3k9JUSCg541mRgQ
        4yxJbpn+8R2kPR1CMrvhBz6dV0Y9lahZQyghzAA=
X-Google-Smtp-Source: AMrXdXvShqqA5M8QFWetoXjF51ldUZyGYu2HxieJ6QMflc11a786XNksavHDNjJE6YLgkUVrBdhhuFiMekc2mbohH8Y=
X-Received: by 2002:a05:6512:c03:b0:4b5:5ceb:3ca7 with SMTP id
 z3-20020a0565120c0300b004b55ceb3ca7mr1214249lfu.338.1672284372347; Wed, 28
 Dec 2022 19:26:12 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 29 Dec 2022 08:56:00 +0530
Message-ID: <CANT5p=qEwppcgZvbdLaABb6M-pRxyDQ05oHOb523n34tYyDqcw@mail.gmail.com>
Subject: Deadlock in Ubuntu 5.4 kernel
To:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo/Enzo,

A customer reported this deadlock in a Kubernetes setup running on Ubuntu-18.04.
This must be a 5.4 kernel, running this code:
https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-azure/+git/bionic

Based on the stack, it appears to be a hang in DFS reconnect codepath,
trying to access the DFS cache lock in dfs_cache_update_vol.

Can you tell if this is a known issue that has been fixed since?
And if Ubuntu should backport any fix to 5.4?
I could not find the function in the mainline codebase.

dmesg:
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.066765] INFO: task cifsd:981715 blocked for more than 604
seconds.
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.073365]       Not tainted 5.4.0-1091-azure #96~18.04.1-Ubuntu
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.080279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E
node-problem-detector-startup.sh[562959]: I1210 09:07:48.142691
562992 log_monitor.go:160] New status generated:
&{Source:kernel-monitor Events:[{Severity:warn Timestamp:2022-12-10
09:07:47.636272174 +0000 UTC m=+63284.134685121 Reason:TaskHung
Message:INFO: task cifsd:981715 blocked for more than 604 seconds.}]
Conditions:[{Type:KernelDeadlock Status:False Transition:2022-12-09
15:33:03.569676476 +0000 UTC m=+0.068089323 Reason:KernelHasNoDeadlock
Message:kernel has no deadlock} {Type:ReadonlyFilesystem Status:False
Transition:2022-12-09 15:33:03.569676576 +0000 UTC m=+0.068089423
Reason:FilesystemIsNotReadOnly Message:Filesystem is not read-only}]}
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086811] cifsd           D    0 981715      2 0x80004002
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086814] Call Trace:
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086826]  __schedule+0x277/0x710
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086829]  ? __next_timer_interrupt+0xe0/0xe0
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086836]  schedule+0x33/0xa0
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086838]  schedule_preempt_disabled+0xe/0x10
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086840]  __mutex_lock.isra.10+0x24c/0x4a0
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086870]  ? do_dfs_cache_find+0x1be/0xea0 [cifs]
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086873]  __mutex_lock_slowpath+0x13/0x20
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086874]  ? __mutex_lock_slowpath+0x13/0x20
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086875]  mutex_lock+0x2f/0x40
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086891]  dfs_cache_update_vol+0x4a/0x290 [cifs]
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086904]  cifs_reconnect+0x597/0xd50 [cifs]
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086916]  cifs_handle_standard+0x198/0x1c0 [cifs]
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086928]  cifs_demultiplex_thread+0x9ed/0xc70 [cifs]
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086931]  kthread+0x121/0x140
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086942]  ? cifs_handle_standard+0x1c0/0x1c0 [cifs]
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086944]  ? kthread_park+0x90/0x90
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.086946]  ret_from_fork+0x35/0x40
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.087014] INFO: task kworker/0:2:2562230 blocked for more than
604 seconds.
Dec 10 09:07:48 aks-corew26-13626357-vmss00000E kernel:
[5653610.092927]       Not tainted 5.4.0-1091-azure #96~18.04.1-Ubuntu


-- 
Regards,
Shyam
