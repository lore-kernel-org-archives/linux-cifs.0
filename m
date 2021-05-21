Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B77BC4707A
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 18:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA6F61164
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 18:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhEUSjY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 14:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235978AbhEUSjX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 May 2021 14:39:23 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE94C0613CE
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 11:37:59 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id m11so31113695lfg.3
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 11:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xsIXA6Yzsc/YeQVrzrR4WflBVC26j4yYZqbb7LZoam4=;
        b=YDWtU4llf4pDDq0Zg8/H7NYgw0GMjYfipUaa2GQowN9wLkHuE3DuYdHO1vY11gpAJJ
         YsOOOAgRNacUsihZxuVu6FenHQv+CIGZPYnQP0vyBmuOSX4kmCzGQ98SJ7SOY8QgSuPK
         RJ7Jxx3TtX3AXerPq1N5FrV1sT+IlnhCq5kwUbR+Us+euPd+qGt2YuRqGfC/F3mzpCfV
         ytCtq1n2FgqD7/ZQxdbQuJlNDvqzMQRpQ0YJNM8cASihrrt+LvgJGUgDzn4pXLJjfOjC
         L/ehkFItgLNu6+XX0uJHVuqm9T1+uIRJZUZ5IYW5FjVITvdVjydfT0Jrs/bQ8I0tJqLG
         QJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xsIXA6Yzsc/YeQVrzrR4WflBVC26j4yYZqbb7LZoam4=;
        b=HQD4/dv0fZl3F8oAP8/bstuv/0Wyr4+6GpB7+WBulLSl+FB/H7E0tGoV66KegLFyU+
         wAxPg118x5q+PsqBlx/CNmN061+Y3CX4zFAdFwGgVYUGLedvIaJP4yTIBrV3oW+/HETZ
         wD6eNg7ycaWMH72iQ7F5HyIulANCDSTpC0UmWUZHM4Eto4ZpY+nqbKQ3zeAWq12vjjvO
         pRE4imhNrLvCSsuE+ph3ttHAGoJotrikukcv7l5Jq/vL7fKzrvVyE1PtV1+ammficmvy
         mum3+o/Rt4T9QXTTowdRQO/RFkCK0t8NsvrtdlJsmwe+z+JGjrn3VRA/mwu1d75Gd41F
         0aTg==
X-Gm-Message-State: AOAM533vF9aiHnL0iFIcdePHKULo5Wk2yNxII8IvBI86FuxVnmBMLxhS
        kf84h6fZ77dt62wcBFNJhDgFM6iulzv6Paur404=
X-Google-Smtp-Source: ABdhPJwqtCgValArzDD2GeefWBOAU2Q0YcvVj8kRCDgLXfPT8mysTw6Y0XM/fjO4va7qmYFpiyfuC1v+d4zmjlcOTuI=
X-Received: by 2002:a05:6512:b17:: with SMTP id w23mr2991127lfu.133.1621622278178;
 Fri, 21 May 2021 11:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mubFZ5BA=MqiL7wQW=adU1Ek4J5YvLDQEu_SiYhRV-yHg@mail.gmail.com>
 <CANT5p=qtC9YXOSQimeU2DcjpR=ES0x_pp6Eb2CUm7y87CH0u3w@mail.gmail.com>
In-Reply-To: <CANT5p=qtC9YXOSQimeU2DcjpR=ES0x_pp6Eb2CUm7y87CH0u3w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 May 2021 13:37:47 -0500
Message-ID: <CAH2r5mvDjfzsXyXH5Lj5qwZBW=AGgTVOfehn_vGXiF-hO8dX_A@mail.gmail.com>
Subject: Re: bug in dumping server name in tracepoints
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, May 21, 2021 at 2:52 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Can you please verify with this patch?
>
> We missed using the variable length string macros in several
> tracepoints. Fixed them in this change.
>
> There's probably more useful macros that we can use to print
> others like flags etc. But I'll submit seperate patches for
> those at a future date.
>
> https://github.com/sprasad-microsoft/smb-kernel-client/commit/ce6399dd4f13cacc4ffdc41e07cde5cc88175f71.patch
> https://github.com/sprasad-microsoft/smb-kernel-client/pull/2
>
> Regards,
> Shyam

Yes - it works now

# trace-cmd show
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
           cifsd-226090  [000] .... 386914.150292: smb3_reconnect:
conn_id=0x1 server=localhost current_mid=26


> On Thu, May 20, 2021 at 11:41 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Looks like we have a bug in how we dump server name in some
> > tracepoints e.g. see below:
> >
> > smfrench@smfrench-ThinkPad-P52:~/cifs-2.6$ sudo trace-cmd show
> > # tracer: nop
> > #
> > # entries-in-buffer/entries-written: 1/1   #P:12
> > #
> > #                                _-----=> irqs-off
> > #                               / _----=> need-resched
> > #                              | / _---=> hardirq/softirq
> > #                              || / _--=> preempt-depth
> > #                              ||| /     delay
> > #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
> > #              | |         |   ||||      |         |
> >            cifsd-82671   [006] .... 298870.051187: smb3_reconnect:
> > conn_id=0x2 server=(0xffff950d5f6f6c00:localhost)[UNSAFE-MEMORY]
> > current_mid=3105
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
