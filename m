Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98106C43334
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Jul 2022 13:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiGDNw4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiGDNwz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Jul 2022 09:52:55 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6524395A0
        for <linux-cifs@vger.kernel.org>; Mon,  4 Jul 2022 06:52:53 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id q16so9935743qtn.5
        for <linux-cifs@vger.kernel.org>; Mon, 04 Jul 2022 06:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=53iYePWVehtemMqs7wAsWsHrHIx8qw7qJbXzUUs+GRk=;
        b=NKLfZLscdRoDuLRI6RCVWb2f4DI7TvHBBhkCF9z9A+Ev09IZFGQI5v2QbzSwwFjOJY
         Sci3eUmousjm/PBjulW3Xx7Ul66Hoyt9FHRwTA2jKvtStkixSehA1qTis2+jyEXa6bw8
         D1n3UO/pRaEjXiGl4FFVKmpxWChTjAbyWzi3SEzDEcKNFtxcasCkTdQC+zOhjjxEGGrU
         ytqmX1MIwVJ7r0U+Ahp9kaOUAl18KWvN1uyVMAXikkUoA/vN27q97CJ2IFFup36LwhgR
         tmHDLNfXp/bV3wuVvsAPRSjKn9EGMQDkRdMhLEHocJ0EdtE39KDYZR9MvXRwJzw7t8lt
         tiOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=53iYePWVehtemMqs7wAsWsHrHIx8qw7qJbXzUUs+GRk=;
        b=dRN1+wKKrhBOfBze4GEv8dPwtX4n/XMhu2h1+tCo1P6+pljY0s5CRPOAyAnu2sp6n+
         cJ3+bvB+wsbfF2YNPzjtqXm6NF1L9buA9VwUAlA5QOYkgll1ecLNlS2EWspm5IGrT+yt
         1CtSYZOMJ4FYhqQnZhICG/WCx3aVgtUjxBsUesQMsWMeNQ/GTmwsZBsaQlIvTvSV4xB0
         PDOTyXZgPZDrUijm7Z0RkiDqInwKGdgcJyaG5ZBElzfJ+T64rcRGRrKLfaKPYMD8dX+y
         H21AefXUPaCroXv7IFuXte8vE85llkXD/YnV/LTWSYfAn6QvcmRzD203AXS36mHUOIgJ
         cVZA==
X-Gm-Message-State: AJIora/SwhGLmjQ9rvrE59cgu3X/JFKnsr6pk7H23WZMOauDpJ42P0Dm
        WGMpZGjMd1DRhrD7NfPh86n+WC+MmWB1lLpcIgE=
X-Google-Smtp-Source: AGRyM1u8zgOIQ/g4/fKQz1aPIge2RVfQmzDnxvId7VKtTGX2TRhUGV05gnyD00lRR9kAcBWc9JYTVQmumEFa1c/UOao=
X-Received: by 2002:a05:6214:4005:b0:472:be5a:810d with SMTP id
 kd5-20020a056214400500b00472be5a810dmr17007016qvb.36.1656942772862; Mon, 04
 Jul 2022 06:52:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
 <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com> <CANT5p=rhUvsrveJDA+AsJ6=j=sWC97LiTH+HcTFxbqRtFKqkAw@mail.gmail.com>
 <CAN05THSaD5JbdkjfEzQDtNOL-M+ZQhm-yrz6n1ystJKXOsJArw@mail.gmail.com>
 <CANT5p=pXXfou2H0pTX+yorFTkJ-AryhhDeaAuVzxoDb4-=U69Q@mail.gmail.com>
 <CAN05THTyNW6mw=arsDd5PCNvX_PwV2xijghe_MDFvbz_hMC-Nw@mail.gmail.com> <35b03fb9-1500-865f-f67a-c24817531ca1@talpey.com>
In-Reply-To: <35b03fb9-1500-865f-f67a-c24817531ca1@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 4 Jul 2022 19:22:42 +0530
Message-ID: <CANT5p=qetdByFLOV0=1VXXa0xMukAggaDtjaQ=K0KH4upVRa1A@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add mount parameter to control deferred close timeout
To:     Tom Talpey <tom@talpey.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 1, 2022 at 9:00 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 7/1/2022 7:00 AM, ronnie sahlberg wrote:
> > On Fri, 1 Jul 2022 at 18:44, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >>
> >> On Fri, Jul 1, 2022 at 12:07 PM ronnie sahlberg
> >> <ronniesahlberg@gmail.com> wrote:
> >>>
> >>> On Fri, 1 Jul 2022 at 16:03, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >>>>
> >>>> On Fri, Jul 1, 2022 at 3:23 AM Tom Talpey <tom@talpey.com> wrote:
> >>>>>
> >>>>> Is there a justification for why this is necessary?
> >>>>>
> >>>>> When and how are admins expected to use it, and with what values?
> >>>>>
> >>>>
> >>>> Hi Tom,
> >>>>
> >>>> This came up specifically when a customer reported an issue with lease break.
> >>>> We wanted to rule out (or confirm) if deferred close is playing any
> >>>> part in this by disabling it.
> >>>> However, to disable it today, we will need to set acregmax to 0, which
> >>>> will also disable attribute caching.
> >>>>
> >>>> So Bharath now submitted a patch for this to be able to tune this
> >>>> parameter separately.
> >>>
> >>> Ok,  will the option be removed later once the investigation is done?
> >>> We shouldn't add options that are difficult/impossible to use
> >>> correctly by normal users.
> >> We didn't intend to. We thought that this could be a useful tunable
> >> parameter that the basic users need not even worry about, but advanced
> >> users / developers could suggest changing it to tune / troubleshoot
> >> specific scenarios.
> >
> > If it is just for developers needing it to debug specific issues  it
> > should absolutely not be a mount option in upstream.
> > Maybe have it as a /proc/fs/cifs/Debug thing or just provide custom
> > builds for the customer when debugging specific issues.
>
> Absolutely agree. Upstream isn't a developer sandbox.
>
> I'll point out that this patch:
> 1) Doesn't change any behavior as-is
> 2) Doesn't give any guidance on values
> 3) Doesn't update the userspace mount command
> 4) Doesn't ever go away because it changes the ABI
> 5) Increases the total number of cifs.ko mount options to 102.
>
> I'm not sure about that last one. It might be 103.
>
I understand that the concern is mainly around this being a mount option.
So let's discuss what's the correct place for tuning such configurations?
It could be a module parameter. It would make it global. But I guess
that's okay.
Thoughts?

> > Once they become mount options they need to be documented, what they
> > do and why you would use them and exactly how to determine what to set
> > them to.
> >
> >
> >
> >>>
> >>>
> >>>>
> >>>>> On 6/29/2022 4:26 AM, Bharath SM wrote:
> >>>>>> Adding a new mount parameter to specifically control timeout for deferred close.
> >>>>
> >>>>
> >>>>
> >>>> --
> >>>> Regards,
> >>>> Shyam
> >>
> >>
> >>
> >> --
> >> Regards,
> >> Shyam
> >



-- 
Regards,
Shyam
