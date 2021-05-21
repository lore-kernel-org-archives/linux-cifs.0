Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5B5C433B4
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 07:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38BEE600CC
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 07:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbhEUHxg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 03:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhEUHxg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 May 2021 03:53:36 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D2BC061574
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 00:52:12 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id r7so4224240ybs.10
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 00:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4mj6zBlF4FsSpkZctQsS25TqIruTSy2VFnzMviXhgAY=;
        b=rCbBNqs8uia4BmoX74hipn5TTt6iN71kw/vt7axOL0qafmtjvgjUbsJ9y/H4UCd3+W
         XHx/GrrXF1H5US8sQIvQSXsIyPKVaekvB1dxDXUdMsXNevA232cnZ2htri5ENs0HkdEl
         lxyCMOTlgxClUDrnppNYcN5rjo6vbyk3NDhBlx+8+7oLdX44Zwc07/0NsS/fZXR4oEAh
         rst8557p1qOaMscmmeY4gIa+V2DQj4SrSj3QikaZL8PS4XiRt+p3MjoGORQQC1Om+LwY
         jA39h5DCCNWzK2cJJgXn6yFAItOdDygb4In7s3vBxutaC1kBthpfGBpixYLEDMFxe1KS
         OyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4mj6zBlF4FsSpkZctQsS25TqIruTSy2VFnzMviXhgAY=;
        b=fJwUMS9cu7DZ7qWaaG6c82W+m0FWie3ZaD94DJUTrqVFW3mVfmgW9qm4sWskpfeT/T
         tGzjKnqv4sYp6UUILrYkNg/epRsqcKc2XhbdtGeCGYXketIDoj8OnTdOSXYft4OqmMCB
         KBoBLkLxfWIOH5GTSm7DOJrleeQmtP8r+P/l73Il9zCn3jAZGSuSpygzO2L2Lj++3yKU
         Xcf/mOSTtdr4KevzO2hjglKdn2hEQJYie2qwoZ8l1NrYCjqzUHj57G8ZneBqoHei/HvT
         aI2Xdch3DATBomtBptXexqyy4U761s4+UeKHkOS7aAmMm98Iiq5h/+wlmKCSA1bcv/CD
         iogQ==
X-Gm-Message-State: AOAM530UiSt10/twolCuusIEjesDmd3hzC9/G0cdlX+GHpgc3ltZjOMO
        qubY6zatXzVcgDhSFEGFFJGvYRUnu/JhIny+eQI=
X-Google-Smtp-Source: ABdhPJyLABeKqmK5OHi2lZFvNCaWqJeTvz6zMiSK1m2ljEpacCOKWtzQgjATik8ZoJXvCX6xu+q7BUz1uou4Ab8ES1U=
X-Received: by 2002:a25:af04:: with SMTP id a4mr13178511ybh.131.1621583531917;
 Fri, 21 May 2021 00:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mubFZ5BA=MqiL7wQW=adU1Ek4J5YvLDQEu_SiYhRV-yHg@mail.gmail.com>
In-Reply-To: <CAH2r5mubFZ5BA=MqiL7wQW=adU1Ek4J5YvLDQEu_SiYhRV-yHg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 21 May 2021 13:22:01 +0530
Message-ID: <CANT5p=qtC9YXOSQimeU2DcjpR=ES0x_pp6Eb2CUm7y87CH0u3w@mail.gmail.com>
Subject: Re: bug in dumping server name in tracepoints
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Can you please verify with this patch?

We missed using the variable length string macros in several
tracepoints. Fixed them in this change.

There's probably more useful macros that we can use to print
others like flags etc. But I'll submit seperate patches for
those at a future date.

https://github.com/sprasad-microsoft/smb-kernel-client/commit/ce6399dd4f13cacc4ffdc41e07cde5cc88175f71.patch
https://github.com/sprasad-microsoft/smb-kernel-client/pull/2

Regards,
Shyam

On Thu, May 20, 2021 at 11:41 PM Steve French <smfrench@gmail.com> wrote:
>
> Looks like we have a bug in how we dump server name in some
> tracepoints e.g. see below:
>
> smfrench@smfrench-ThinkPad-P52:~/cifs-2.6$ sudo trace-cmd show
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 1/1   #P:12
> #
> #                                _-----=> irqs-off
> #                               / _----=> need-resched
> #                              | / _---=> hardirq/softirq
> #                              || / _--=> preempt-depth
> #                              ||| /     delay
> #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
> #              | |         |   ||||      |         |
>            cifsd-82671   [006] .... 298870.051187: smb3_reconnect:
> conn_id=0x2 server=(0xffff950d5f6f6c00:localhost)[UNSAFE-MEMORY]
> current_mid=3105
>
>
> --
> Thanks,
>
> Steve



-- 
Regards,
Shyam
