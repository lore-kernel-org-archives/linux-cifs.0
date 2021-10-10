Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A7BC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Oct 2021 20:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C065960F3A
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Oct 2021 20:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhJJU0T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 10 Oct 2021 16:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbhJJU0T (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 10 Oct 2021 16:26:19 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494E3C061570
        for <linux-cifs@vger.kernel.org>; Sun, 10 Oct 2021 13:24:20 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id j5so64527420lfg.8
        for <linux-cifs@vger.kernel.org>; Sun, 10 Oct 2021 13:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=eBEI6KRtWo5TcosPPcZS7ZzlxPIvo+/igyQjvgfiJl4=;
        b=i1mKL/RTBjw9HOgV9A801d/cw5I6D++N85JlWVr/To0eXYlnVY6zGV15qKaHfXmHcz
         EpoWPk472Xvq0lumhy3YFvFUcsS4mhBEEpykl4u5uucm4VkK1gUa4+4i5ErhyI0FOg9w
         vbU/XpQQZGgrxX3LKF9surroeQjtjdXWWrpnR/LA8kpH/kt47oZiqIcVrdAw3P4mrQD5
         RrVCsyoUKHHl5jr7eNcfN8KyNhzk54vhICfE08oYb/kWmXuSZx8hr/C0wFWhh35pBYP0
         81lALp8m1Z7Iy1HwQKrKDhpCrASGNcG53jrOlSbfMUIGTTmypywpKKJjMzQhIAvueixv
         7FRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eBEI6KRtWo5TcosPPcZS7ZzlxPIvo+/igyQjvgfiJl4=;
        b=1goyAnGRsij83h+oqMZl6U1cqP7BjsPTOW4FfQm0FLPxBpV6unzPJ6hLPzXcRtSbpu
         JZM9ntTIgynKcrgbuy5Mfnd2NaWlF3CrkYJEIg2VNPx343SFkAFidi4GkJq4vJOf4Waf
         VP9BRHdH7OA2FPrD3HaqEKhlYy4YP5Hk6hy/D2kxAP3iWxBLoZapAJyB53/ELRa5W2IY
         7kch0KobMfJcJaLbofSxU255wtE6dykJNJe/fksXQ/g8vqTpHzmzh5swnvQMzablbZCA
         vSeDKsyfor7h0KYkf8oPRqw7hOC9LiRqYIuZRP60oggLqx1y+mq4bPerQssItD+BSWpp
         +G1A==
X-Gm-Message-State: AOAM531rQOkGztlZ5Bo2c935gG9QtMTLWXaXoi38sWhckEfiAEkcOGQ+
        UIjej5aEgrTllYBwrwYeGjRiSSmDJUk0LQQHcunL1V1R3ZU=
X-Google-Smtp-Source: ABdhPJxEY12WC0LLx8tmoKRc9hMW4f2xOZAYTmpKoyJmzgVNUOEr5o92GXS8BGi92nBzcijyjtZMJt9nkyJ/E9Us0eg=
X-Received: by 2002:ac2:5fee:: with SMTP id s14mr22833946lfg.537.1633897458163;
 Sun, 10 Oct 2021 13:24:18 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 10 Oct 2021 15:24:07 -0500
Message-ID: <CAH2r5mujd3miqnAO5NJLC3DfX7GJZr7LCREf8O4ABh3u1Z=GqA@mail.gmail.com>
Subject: xfstest generic/048 failure
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Have any of you seen this error logged running xfstest generic/048 to Windows?

  284.849920] run fstests generic/048 at 2021-10-10 15:15:07
[  285.217555] CIFS: Attempting to mount \\win16.vm.test\Scratch
[  285.279366] CIFS: Attempting to mount \\win16.vm.test\Scratch
[  285.319583] CIFS: VFS: shut down requested (1)
[  285.501234] CIFS: Attempting to mount \\win16.vm.test\Scratch
[  285.575932] CIFS: Attempting to mount \\win16.vm.test\Scratch
[  317.377618] CIFS: VFS: \\win16.vm.test No task to wake, unknown
frame received! NumMids 3
[  317.377640] 00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
[  317.377642] 00000010: 00000001 00000000 ffffffff ffffffff  ................
[  317.377643] 00000020: 00000000 00000000 00000000 00000000  ................
[  317.377645] 00000030: 00000000 00000000 00000000 00000000  ................
[  317.377658] CIFS: VFS: \\win16.vm.test Cmd: 18 Err: 0x0 Flags: 0x1
Mid: 18446744073709551615 Pid: 0
[  317.377672] CIFS: VFS: \\win16.vm.test smb buf 00000000ff2b3095 len 108
[  317.377686] CIFS: VFS: Dump pending requests:
[  317.377698] CIFS: VFS: State: 2 Cmd: 6 Pid: 110 Cbdata:
0000000056fc0dab Mid 3458
[  317.377699] CIFS: VFS: IsLarge: 0 buf: 0000000000000000 time rcv: 0
now: 4294984240
[  317.377701] CIFS: VFS: IsMult: 0 IsEnd: 0

-- 
Thanks,

Steve
