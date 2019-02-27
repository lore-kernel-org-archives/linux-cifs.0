Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2749AC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 01:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBCD4218CD
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 01:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ApKnIlb2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfB0BXt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Feb 2019 20:23:49 -0500
Received: from mail-lf1-f51.google.com ([209.85.167.51]:41346 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfB0BXt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Feb 2019 20:23:49 -0500
Received: by mail-lf1-f51.google.com with SMTP id e27so11170552lfj.8
        for <linux-cifs@vger.kernel.org>; Tue, 26 Feb 2019 17:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=26QJq/zFTCfm7ZR8Kz9EaTLWvwac6cQN5hqyJnH5ZFQ=;
        b=ApKnIlb2QEuT/IduDgLdSu4Uwsc6RMZE/EmxxDwgMKp9TQg5ci+Ilywhbvm4SxY0sR
         g4Xs3et5e+tchRoQ14Y7NALc1Gg0hMl0uUliXmIKrs58GhmKFQf9M6U5zKbAk1aAqU0K
         4gzvN4NtYoAcPHARiGmeAxdWXq8pCPtVh4kVLL15JinJKx3KiUi5pKH3fDfNFGKnXlCK
         NmnC9scO/sq2+kGFO8b7CwwLTvBEwh+z48CvV7cxCzojt6DdZETF0EvIA8Hv5ytrj5K/
         UG+7uLNyaj4SjKL38xBPX33bPLMVMoEbITRW1izmD6VlLbENWrbsP3rRoH6R/ahLuGAA
         97lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=26QJq/zFTCfm7ZR8Kz9EaTLWvwac6cQN5hqyJnH5ZFQ=;
        b=sAZeomJDAsE5SYgaxWOzctFSDx0cjimih2g1VbFH6b1rD7R9nYBn5TYwpteMvkwLhj
         qDaX297gmoWvEUh/z5640sflslTRdjUHqDTbIkf4C+jLQ2nc+feznZau+G0PPw+mF8/8
         pEn+hb0wVZTeDzFyOk2pXgA48M4ffcTj/5TMjM01ZotUo9THCBlkaqzhEFLSgCc6rBdw
         hGamOpejj74BxAd+nZ4x0XCdWcY9qQ2TO9fwEpYjAD3CdbZLbO5KckSgYEIg7Wu9wxfg
         o+tP4v44nofXzzN7p7RFBvu9oDUNcJRrmFoZEPyavhHLq1wRh4ZLHQ2jvCTBnY/3myWT
         uNlQ==
X-Gm-Message-State: AHQUAubwmuZFt/nwHRzTrpLou77tpdESCL1WpN+dLoquNhNvM3+1uWx+
        WI27evY7pIFuf7AKrtVzgHQ+RiKKwVfN/IzYWQ==
X-Google-Smtp-Source: AHgI3IZDexi8fSoRvVSqB7/X7LrRNuwNfGZ3ac+G6w2ySFx0zMDq7SMZ/HPo0g+NE3F/z9eAP2YZGBrVzLtnbbJ3MZA=
X-Received: by 2002:ac2:55ad:: with SMTP id y13mr4836739lfg.97.1551230627149;
 Tue, 26 Feb 2019 17:23:47 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msgdyPZE077R5hatgiFamWa_M9fAZ+JbgsAZQxk-ki9kw@mail.gmail.com>
In-Reply-To: <CAH2r5msgdyPZE077R5hatgiFamWa_M9fAZ+JbgsAZQxk-ki9kw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 26 Feb 2019 17:23:35 -0800
Message-ID: <CAKywueQ2B6oXoCYqf3Dd5_miijuzPbi55wZ-B+igYzQc2=wtdw@mail.gmail.com>
Subject: Re: [PATCH] Improve dynamic tracing of open and posix mkdir
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 26 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 17:16, Steve=
 French <smfrench@gmail.com>:
>
> Updated to limit it to open and mkdir (not compounded operations) with
> feedback from Pavel.
>
> Sample output
>
> # trace-cmd show
> # tracer: nop
> #
> #                              _-----=3D> irqs-off
> #                             / _----=3D> need-resched
> #                            | / _---=3D> hardirq/softirq
> #                            || / _--=3D> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>            mkdir-19287 [002] .... 17897.136632:
> smb3_posix_mkdir_enter: xid=3D8 sid=3D0xd29a497f tid=3D0xbc99b185
> cr_opts=3D0x1 des_access=3D0x100
>            mkdir-19287 [002] .... 17897.141109: smb3_posix_mkdir_done:
> xid=3D8 sid=3D0xd29a497f tid=3D0xbc99b185 fid=3D0x3d0ea06a cr_opts=3D0x1
> des_access=3D0x100
>            touch-19289 [002] .... 17910.203266: smb3_open_enter:
> xid=3D12 sid=3D0xd29a497f tid=3D0xbc99b185 cr_opts=3D0x40
> des_access=3D0x40000080
>            touch-19289 [002] .... 17910.214443: smb3_open_done: xid=3D12
> sid=3D0xd29a497f tid=3D0xbc99b185 fid=3D0x74770519 cr_opts=3D0x40
> des_access=3D0x40000080

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
