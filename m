Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2DFC04FF3
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 23:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 865B561176
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 23:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhEUXqI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 19:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhEUXqI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 May 2021 19:46:08 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC14CC061574
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 16:44:44 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m11so32080638lfg.3
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 16:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XGaEgsRRmzdAKxaHpdSZf9bVDp3cSo+sjHa/Jv+Jzko=;
        b=gCpXF+f2MrjdVQoAU6VVWtmg4052OadTf8a/ZAk0EuPX0sJcaay+gH1KDH0P0BKVu+
         LWdTmULvkPkNHjXVOaJZ2KaMuv1eeuaaLlnzQVDP45tg7TnsfDXmRB8fhsXq6ylDsGsc
         9t9HIOEPUSIUc9btqTbOuBggxREMvaY9lkFTgWzK4zLgtWuJ05YFhZVeOE/0y8id5xnz
         TODIN8JflNxRKu4KM2HGDVXN+jF/P1sXFV3/xrLrglHzqW7QA5JmHwaVSQMImFLxhWdy
         v4OwwDZ78rY29OSbgHEGms4BXb3SJPJgx1R3guO4ArDuhIYoPKA++pev3kRGZEpcMygF
         gojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XGaEgsRRmzdAKxaHpdSZf9bVDp3cSo+sjHa/Jv+Jzko=;
        b=GeNyMOZpQwvOFgHsbbzwZVMlYx/ugm7xzOjFtrYW866yTM1Q38xmqT6ZwVzu5zOxJh
         celjAKSb0VVVpgub0C6O8r9p5RiWU/9kOPZBeeilcIMgYU8/OD2bK2J3/f4eptE035KY
         188PesvRd+8HTMboAHZDqY2oe9joJbUGFwSpLeknH+pcqnbO5pQaogjevoIa7kYNQHic
         lJOkBBUK1szeGwVJFzvPi7fRwMKv/SCfdH3qxge6Fy93ZG6qwdn2I+MwAjyp/hhpfS/O
         +2INozWsBRcHtihz3x6t1L0IBt+McoOxdIUfklYsiaEisF3RQY+OSzh+5Y0QaL1DEiX3
         syGg==
X-Gm-Message-State: AOAM530VcYk5RMiQYWK37V4Bovd2wuedx3bye0Zy21OeJVGP65TfYYHz
        loZPeGnG8EpqxM+eztwCaubB+bratSrHY9aLjyg=
X-Google-Smtp-Source: ABdhPJz9scMOWRjlgCrLBnkae2IRXANhhNH5ttoRShE09q9hrdbnvUvtdGlv0hPMoj9MAdQ+s/KSun7mB0fTXo+fTVs=
X-Received: by 2002:a05:6512:33d0:: with SMTP id d16mr3808373lfg.184.1621640682308;
 Fri, 21 May 2021 16:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mubFZ5BA=MqiL7wQW=adU1Ek4J5YvLDQEu_SiYhRV-yHg@mail.gmail.com>
 <CANT5p=qtC9YXOSQimeU2DcjpR=ES0x_pp6Eb2CUm7y87CH0u3w@mail.gmail.com> <CAH2r5mvDjfzsXyXH5Lj5qwZBW=AGgTVOfehn_vGXiF-hO8dX_A@mail.gmail.com>
In-Reply-To: <CAH2r5mvDjfzsXyXH5Lj5qwZBW=AGgTVOfehn_vGXiF-hO8dX_A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 May 2021 18:44:31 -0500
Message-ID: <CAH2r5mtJg7e41GjLCWfDMZc_Tje6LX3Qdx4wkyQSEwp3eSHzGQ@mail.gmail.com>
Subject: Re: bug in dumping server name in tracepoints
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next and cc:stable v5.12

On Fri, May 21, 2021 at 1:37 PM Steve French <smfrench@gmail.com> wrote:
>
> On Fri, May 21, 2021 at 2:52 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Can you please verify with this patch?
> >
> > We missed using the variable length string macros in several
> > tracepoints. Fixed them in this change.
> >
> > There's probably more useful macros that we can use to print
> > others like flags etc. But I'll submit seperate patches for
> > those at a future date.
> >
> > https://github.com/sprasad-microsoft/smb-kernel-client/commit/ce6399dd4f13cacc4ffdc41e07cde5cc88175f71.patch
> > https://github.com/sprasad-microsoft/smb-kernel-client/pull/2
> >
> > Regards,
> > Shyam
>
> Yes - it works now
>
> # trace-cmd show
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
>            cifsd-226090  [000] .... 386914.150292: smb3_reconnect:
> conn_id=0x1 server=localhost current_mid=26
>
>
> > On Thu, May 20, 2021 at 11:41 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Looks like we have a bug in how we dump server name in some
> > > tracepoints e.g. see below:
> > >
> > > smfrench@smfrench-ThinkPad-P52:~/cifs-2.6$ sudo trace-cmd show
> > > # tracer: nop
> > > #
> > > # entries-in-buffer/entries-written: 1/1   #P:12
> > > #
> > > #                                _-----=> irqs-off
> > > #                               / _----=> need-resched
> > > #                              | / _---=> hardirq/softirq
> > > #                              || / _--=> preempt-depth
> > > #                              ||| /     delay
> > > #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
> > > #              | |         |   ||||      |         |
> > >            cifsd-82671   [006] .... 298870.051187: smb3_reconnect:
> > > conn_id=0x2 server=(0xffff950d5f6f6c00:localhost)[UNSAFE-MEMORY]
> > > current_mid=3105
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
