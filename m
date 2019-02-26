Return-Path: <SRS0=zR3V=RB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2860AC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Feb 2019 02:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAAFA21841
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Feb 2019 02:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ncOemlix"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfBZCZ3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 21:25:29 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]:42753 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfBZCZ3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 21:25:29 -0500
Received: by mail-qt1-f173.google.com with SMTP id u7so3985921qtg.9
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 18:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r2iZAsCl/eFwLm/jNBCkZkKP2zYQwiGuV/TyqRuar+E=;
        b=ncOemlixFUsDpS1swYBxCMdImf2F4ueLXvw2QN2+M6gEYY8L5CObXO0vwVNM1fNdZz
         0XUuYDUvXTpHmBcanBgJDGJQYSsC/iBic16GvTprE0i+h4UqxSubAKEkWvWA56dmtwFq
         B/lU4Bnp7yukRHz7xDglVwWzdcJBKEpMPXoPSgDm5KfKJPkT+i5gbH8vm/rVT6oYIIYO
         FjX26dPfpH3N2/SOw3oqLpFJHoGloAO9t1U7siSKhRZu2IDtdvTPBPYAhbJiI3HeNeiu
         V8s+2YaLRYBgdOL2QI7HyhwdHllhCE2609J5YrGedWA0yiBjQDUyKSY1lEvKy2aukjsu
         11iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r2iZAsCl/eFwLm/jNBCkZkKP2zYQwiGuV/TyqRuar+E=;
        b=mXr78E4b5ZbjL7kqN/rqJFVRHIIZQzkSOyXpS60F99x/ZwlUGuSDLulychUb1e8N6P
         uI6/EBFd6DawIsn+ZOoQDHHvxSTj7ZLZiyXR1Jdqj28DSxDlnSEfafC8KE78k1W4yeMo
         pFrKT8HserpKGqzqXGc166MHzceimqLRSu/uIZ8JIUeJtAXXouxBYBylXBxvQhTEsPQo
         oVkRE06On+PgTzhWv8ipAG5AXeaRyuYHQawVkp4xEHxkIesm2DE7BJLTazQNG/vALs5f
         jdYQObZ4RN7KF1egGsTyFAIvEVJeosB8WnV8MKlwStvp4G9RVe1dFAow5znY9ZfVUxNi
         X78A==
X-Gm-Message-State: AHQUAubHsuEpDYysBGXxHJskFYlR04WXpkyrhdNgir65d1aH5PbQHxWX
        ViCwzRL4xmnB1qE+hsjZN4QrEa81Elva4GAUiAXnZA==
X-Google-Smtp-Source: AHgI3IYATCJnjZu/Yic+yYoH4ig7B5yrYlhJZqLkqExSlYLt+tGoAu9jDcrPz+1xLNKDn7Jv1A+BI5v0GBH+XNStTKM=
X-Received: by 2002:a0c:91a9:: with SMTP id n38mr16077908qvn.171.1551147928170;
 Mon, 25 Feb 2019 18:25:28 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msOkMhOOSK1838dsWfiNm6ZTGMRQ2m3jVK0ReNP63LT5g@mail.gmail.com>
In-Reply-To: <CAH2r5msOkMhOOSK1838dsWfiNm6ZTGMRQ2m3jVK0ReNP63LT5g@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 26 Feb 2019 12:25:17 +1000
Message-ID: <CAN05THQmApOBODVma9_PK0==A9McXcRPWEaneq5uHisijai=1A@mail.gmail.com>
Subject: Re: [PATCH] dynamic tracing open_enter/done
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Tue, Feb 26, 2019 at 8:27 AM Steve French <smfrench@gmail.com> wrote:
>
> Sample output (note that they are mostly compounded so fid is not very
> meaningful - and set to 0)
>
> # trace-cmd show
> # tracer: nop
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>               ls-1008  [001] .... 97979.221345: smb3_open_enter: xid=8
> sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x81
>               ls-1008  [001] .... 97979.222446: smb3_open_done: xid=8
> sid=0xfab79a42 tid=0x4b599fda fid=0xec26ce8a cr_opts=0x0
> des_access=0x81
>               ls-1009  [007] .... 97985.278984: smb3_open_enter:
> xid=11 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
>               ls-1009  [007] .... 97985.280496: smb3_open_done: xid=11
> sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
>               ls-1009  [007] .... 97985.280569: smb3_open_enter:
> xid=12 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x81
>               ls-1009  [003] .... 97985.281311: smb3_open_err: xid=12
> sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x81 rc=-13
>             stat-1013  [005] .... 97993.537550: smb3_open_enter:
> xid=14 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
>             stat-1013  [005] .... 97993.538634: smb3_open_err: xid=14
> sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80 rc=-2
>            mkdir-1015  [006] .... 97997.445397: smb3_open_enter:
> xid=15 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
>            mkdir-1015  [006] .... 97997.446442: smb3_open_err: xid=15
> sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80 rc=-2
>            mkdir-1015  [006] .... 97997.446457: smb3_open_enter:
> xid=16 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x1 des_access=0x100
>            mkdir-1015  [006] .... 97997.447839: smb3_open_done: xid=16
> sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x1 des_access=0x100
>            mkdir-1015  [006] .... 97997.447852: smb3_open_enter:
> xid=16 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
>            mkdir-1015  [006] .... 97997.449092: smb3_open_done: xid=16
> sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
>             stat-1017  [006] .... 98002.176448: smb3_open_enter:
> xid=17 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
>             stat-1017  [006] .... 98002.177836: smb3_open_done: xid=17
> sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
>            touch-1018  [007] .... 98006.350783: smb3_open_enter:
> xid=18 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x40
> des_access=0x40000080
>            touch-1018  [007] .... 98006.351938: smb3_open_done: xid=18
> sid=0xfab79a42 tid=0x4b599fda fid=0x25565488 cr_opts=0x40
> des_access=0x40000080
>            touch-1018  [007] .... 98006.352410: smb3_open_enter:
> xid=19 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x100
>            touch-1018  [007] .... 98006.353429: smb3_open_done: xid=19
> sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x100
>               rm-1022  [006] .... 98011.406241: smb3_open_enter:
> xid=21 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
>               rm-1022  [006] .... 98011.407548: smb3_open_done: xid=21
> sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
>               rm-1022  [006] .... 98011.407596: smb3_open_enter:
> xid=22 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x201000
> des_access=0x10000
>               rm-1022  [006] .... 98011.408723: smb3_open_done: xid=22
> sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x201000
> des_access=0x10000
>            rmdir-1023  [001] .... 98017.810408: smb3_open_enter:
> xid=23 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
>            rmdir-1023  [001] .... 98017.811916: smb3_open_done: xid=23
> sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
>            rmdir-1023  [001] .... 98017.811934: smb3_open_enter:
> xid=24 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x1 des_access=0x10000
>            rmdir-1023  [002] .... 98017.813449: smb3_open_done: xid=24
> sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x1 des_access=0x10000
>
>
>
> --
> Thanks,
>
> Steve
