Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FE5C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 06:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiCQG3G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 02:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiCQG2w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 02:28:52 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA213D9D
        for <linux-cifs@vger.kernel.org>; Wed, 16 Mar 2022 23:23:33 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 17so5978955lji.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Mar 2022 23:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nng/zDsEW1zxLvgraPUJ14awvFjvU3vTEAT8kxteU/4=;
        b=IGB1pj8a+6UDQEgtsJmqGr44ypR8z12C1JqBgNy0gqeWy9HeZwGbQoiDtb7kd8HOb7
         u1nIlRLgXTcqoM7uAG/NhjLm1+bCOV5lQweR3FrvExSvWrfo8Et+JOCxEkOvu3Zwb2Ae
         2SyR+m0ZO4Hpy0tNmDhg9HwnIK0m8Hsp2wydQXwrT6qfUzglJG2o9dtGFwi+tzK7aKLD
         ZleFn25trQdmMnRXfZQsE09mdTgY1ZA6Cy42U6okTZEJlA5XDszzN4bm6jUsOFjKyBoF
         lL+MI+l6AeZv5VXlGXnqHvmfvYzhohKSPP33YKvL/+5hwU3P9nw/jwt7MjgqlRqCfLdD
         iJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nng/zDsEW1zxLvgraPUJ14awvFjvU3vTEAT8kxteU/4=;
        b=MuopCVusHEHvvAUKqhfZV9V9PKiTAEIaGTeZj/GsZpeeojqSJ3XVdDVPwKC5EoxgJI
         NCP6IDh5yOLL001UOYwbpiCnzjFb87OSdz6vwgknNFlh5q7Gd6uaICdv7NYUAE46kjc6
         b96lajK81vN2KcyxFX8JBCrl0CwAHzpURmxlZMao61IrTbeKBkrCpgU+ThjoLVsrRyf+
         lEzFgMlIe2lbZlvtejvzHNSq0pQHgEeinGxCseylZ+DwqzbVCN0SEVq5N9XU8aYWvYtw
         0PUzTpg0Q4zFLrmyVAXXEycETY2IhIDc8L2ALjs7eXHZt2ViFiCcQ29nEJtKW+vZ87nP
         C8QA==
X-Gm-Message-State: AOAM531RXBWGIFkd25hOmAY56Ct5tHyaUtLhsQpLAjFJHhZ1AYGCvlL/
        satZWzy6UUYXjG9lLgNF43//3+AluOqSigg0u8F0vYRYuqcVHA==
X-Google-Smtp-Source: ABdhPJz/G/c6CNEWrz+to6r6yvh6bdsohOsXi4IULhQKkuvOfiYU5z3UCJuBI6PqxtxXL5K25VKK1M8+9eyaPuJBfls=
X-Received: by 2002:a2e:2e02:0:b0:247:ef72:9e97 with SMTP id
 u2-20020a2e2e02000000b00247ef729e97mr1983016lju.497.1647498211481; Wed, 16
 Mar 2022 23:23:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvrgzqncUVhDC1bwn8fkrJt7RFs+gTvgByGsDpwfr9eOg@mail.gmail.com>
In-Reply-To: <CAH2r5mvrgzqncUVhDC1bwn8fkrJt7RFs+gTvgByGsDpwfr9eOg@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Thu, 17 Mar 2022 02:23:19 -0400
Message-ID: <CAFrh3J_jDg=2-6j6hpfae_i9f57YVE99tHNK7nE0sxfiHXO+JQ@mail.gmail.com>
Subject: Re: multiuser mount option regression
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I am testing Ronnie's patch from earlier today now, and will see if
the mount has broken later this morning, as I'm putting the machine to
sleep now.

I tried just reverting 73f9bfbe3d818bb52266d5c9f3ba57d97842ffe7 in
5.17-rc8, but it broke cifs mounting entirely with the error I
mentioned earlier today:

[  242.560881] INFO: task mount.smb3:3219 blocked for more than 120 seconds.
[  242.560901]       Tainted: P           OE
5.17.0-051700rc8-generic #202203132130
[  242.560904] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.560907] task:mount.smb3      state:D stack:    0 pid: 3219
ppid:     1 flags:0x00004006
[  242.560914] Call Trace:
[  242.560918]  <TASK>
[  242.560927]  __schedule+0x240/0x5a0
[  242.560939]  schedule+0x55/0xd0
[  242.560941]  schedule_preempt_disabled+0x15/0x20
[  242.560944]  __mutex_lock.constprop.0+0x2e0/0x4b0
[  242.560949]  __mutex_lock_slowpath+0x13/0x20
[  242.560953]  mutex_lock+0x34/0x40
[  242.560958]  cifs_get_smb_ses+0x367/0xab0 [cifs]
[  242.561108]  ? __queue_delayed_work+0x5c/0x90
[  242.561120]  mount_get_conns+0x63/0x430 [cifs]
[  242.561182]  cifs_mount+0x86/0x420 [cifs]
[  242.561222]  cifs_smb3_do_mount+0x10d/0x320 [cifs]
[  242.561252]  ? cifs_smb3_do_mount+0x10d/0x320 [cifs]
[  242.561283]  ? vfs_parse_fs_string+0x7f/0xb0
[  242.561290]  smb3_get_tree+0x3e/0x70 [cifs]
[  242.561337]  vfs_get_tree+0x27/0xc0
[  242.561343]  do_new_mount+0x14b/0x1a0
[  242.561348]  path_mount+0x1d4/0x530
[  242.561350]  ? putname+0x55/0x60
[  242.561357]  __x64_sys_mount+0x108/0x140
[  242.561360]  do_syscall_64+0x59/0xc0
[  242.561368]  ? do_syscall_64+0x69/0xc0
[  242.561372]  ? handle_mm_fault+0xba/0x290
[  242.561376]  ? do_user_addr_fault+0x1dd/0x670
[  242.561382]  ? syscall_exit_to_user_mode+0x27/0x50
[  242.561385]  ? exit_to_user_mode_prepare+0x37/0xb0
[  242.561392]  ? irqentry_exit_to_user_mode+0x9/0x20
[  242.561394]  ? irqentry_exit+0x33/0x40
[  242.561397]  ? exc_page_fault+0x89/0x180
[  242.561399]  ? asm_exc_page_fault+0x8/0x30
[  242.561405]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  242.561409] RIP: 0033:0x7f42af11ceae
[  242.561414] RSP: 002b:00007fff6af66c48 EFLAGS: 00000206 ORIG_RAX:
00000000000000a5
[  242.561418] RAX: ffffffffffffffda RBX: 000055dcbe40beb0 RCX: 00007f42af11ceae
[  242.561420] RDX: 000055dcbe1a447e RSI: 000055dcbe1a44da RDI: 00007fff6af67ea6
[  242.561421] RBP: 0000000000000000 R08: 000055dcbe40beb0 R09: 000055dcbe40cf40
[  242.561423] R10: 0000000000000000 R11: 0000000000000206 R12: 00007fff6af67e9b
[  242.561424] R13: 00007f42af237000 R14: 00007f42af23990f R15: 000055dcbe40cf40
[  242.561427]  </TASK>





On Thu, Mar 17, 2022 at 2:03 AM Steve French <smfrench@gmail.com> wrote:
>
> I narrowed the regression for multiuser mounts down (which Ronnie had
> mentioned) to this patch (one of the first applied to 5.17 merge
> window for cifs.ko).   I am curious whether this is also related to
> the hard to reproduce reconnect issue that the regression tracker was
> monitoring
>
> commit 73f9bfbe3d818bb52266d5c9f3ba57d97842ffe7 (HEAD -> tmp)
> Author: Shyam Prasad N <sprasad@microsoft.com>
> Date:   Mon Jul 19 17:37:52 2021 +0000
>
>     cifs: maintain a state machine for tcp/smb/tcon sessions
>
>     If functions like cifs_negotiate_protocol, cifs_setup_session,
>     cifs_tree_connect are called in parallel on different channels,
>     each of these will be execute the requests. This maybe unnecessary
>     in some cases, and only the first caller may need to do the work.
>
>     This is achieved by having more states for the tcp/smb/tcon session
>     status fields. And tracking the state of reconnection based on the
>     state machine.
>
>     For example:
>     for tcp connections:
>     CifsNew/CifsNeedReconnect ->
>       CifsNeedNegotiate ->
>         CifsInNegotiate ->
>           CifsNeedSessSetup ->
>             CifsInSessSetup ->
>               CifsGood
>
>     for smb sessions:
>     CifsNew/CifsNeedReconnect ->
>       CifsGood
>
>      CifsNew/CifsNeedReconnect ->
>       CifsInFilesInvalidate ->
>         CifsNeedTcon ->
>           CifsInTcon ->
>             CifsGood
>
>     If any channel reconnect sees that it's in the middle of
>     transition to CifsGood, then they can skip the function.
>
>
>
> --
> Thanks,
>
> Steve
