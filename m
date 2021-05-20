Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCADC433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 18:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B08FC60FD8
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 18:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhETSMn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 May 2021 14:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhETSMn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 May 2021 14:12:43 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD7CC061574
        for <linux-cifs@vger.kernel.org>; Thu, 20 May 2021 11:11:20 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id e2so14597077ljk.4
        for <linux-cifs@vger.kernel.org>; Thu, 20 May 2021 11:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ACh7sW/5RgWxuA/S402+klqvdShpCnTjrk++GGvn+S8=;
        b=MnkFAeSGCUMaVhxpO4DPoY8jEj8OQNR7dJR5mQgb1SlQKE9OdDtbc8P0Xp8nSF1gKR
         P4fA5XYTYRGS0BgLGHhTWJcVm8Sca2E4Mi2R2lhw7Dk88FT+ha2c6N8gy2WYXY9wuuxP
         JrWzYUREo3USo1lThmJFoi35J9Vw5ME6uhp7JH+/1y0vyLaovTor5v5RvzR0nxV4ECSR
         ujJtlU0XxXIgDzF7glTWBDX7lwbIWx0lvc7SUMS4/EA86oyKaHHJ9xzp9ygX5XacPCGR
         iP0Ow6ZH4vO/hwAI9bzIbE/KgBOYX6aZ4fJhsG16JYU58BpacpElv/009g4kpr8UNgCb
         Yaxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ACh7sW/5RgWxuA/S402+klqvdShpCnTjrk++GGvn+S8=;
        b=JX6aGXSW/kR0uOPFju/nNuPBviLlJKOsT+PoZ9UicWT3ckdiEriCSPu/YIM1VpSGyG
         Qf0BAXRTQjM2pwoBP0zXjJPRhmCQWJkqinFy1TSXO0D37x38KHbfpPoD+bhH+OEyhKHO
         mgbwWovM7vguhepwM9fgGv3nEKgiax41Yi4tPdXt9CvlCukvghTPLchbwFm0rOFe8Mw1
         7FJXsQYsnErRJIx2+LY0C9bfrsy/ucSn1pSuf74Hzu3neosoHnLmNtiea1eEJia/LXOv
         lWNsO2viNT2ZHsYjpeWmmrhTr4qb4Df2J3c7Ig82cgTWiGBdttlrus29Se6ZBg+VnnCV
         zyBQ==
X-Gm-Message-State: AOAM5325Gzpxd6AU6uLKGsaJSgCyppyH3sbPoMkYqB4ab1khLRbc8U3P
        7IcPN54cM22mjgeup3yg7QTGVsz3RN2E/y/w63U=
X-Google-Smtp-Source: ABdhPJy2Im35aT2lmslJ3NcnTY8KQCxYbR6iahefmhEwxqJ4mT2M4OZj13lCICwxQMYgbwr2LjNH8bG/N9plpkjnLys=
X-Received: by 2002:a2e:7819:: with SMTP id t25mr3867264ljc.406.1621534278521;
 Thu, 20 May 2021 11:11:18 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 20 May 2021 13:11:07 -0500
Message-ID: <CAH2r5mubFZ5BA=MqiL7wQW=adU1Ek4J5YvLDQEu_SiYhRV-yHg@mail.gmail.com>
Subject: bug in dumping server name in tracepoints
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like we have a bug in how we dump server name in some
tracepoints e.g. see below:

smfrench@smfrench-ThinkPad-P52:~/cifs-2.6$ sudo trace-cmd show
# tracer: nop
#
# entries-in-buffer/entries-written: 1/1   #P:12
#
#                                _-----=> irqs-off
#                               / _----=> need-resched
#                              | / _---=> hardirq/softirq
#                              || / _--=> preempt-depth
#                              ||| /     delay
#           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
#              | |         |   ||||      |         |
           cifsd-82671   [006] .... 298870.051187: smb3_reconnect:
conn_id=0x2 server=(0xffff950d5f6f6c00:localhost)[UNSAFE-MEMORY]
current_mid=3105


-- 
Thanks,

Steve
