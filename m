Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C98DDC43334
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jul 2022 22:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiGEW0m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiGEW0i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jul 2022 18:26:38 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C766414020
        for <linux-cifs@vger.kernel.org>; Tue,  5 Jul 2022 15:26:37 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id q8so3832771ljj.10
        for <linux-cifs@vger.kernel.org>; Tue, 05 Jul 2022 15:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nvhA6QGuH/9Ca5AWv+XJgENCzjeCQ64n1KPkndplBJA=;
        b=L9Hphgy7gVDb2KjbUuCgFOD4VGDwWg7YBcu5nd0yaAQ2k+SqIq/Bxln1lRIma3P+E5
         OUykZvrb95BfrXerieapbjOZwmjCjXDJ9op7XayaotV+nnV7mk1v5qCmI97IUbnpEBYY
         SKz4wBxwknZTdqXXRzGIb1KCYjn3M6iDEEfW0YXJbHre3x8/GCfTvKUb3dkByns6rmE4
         4LSatTH3JL957YwRo2yUZyaGpAKk6D+wp22HOsFA3M9wEyPv4efgXV1oHur7x7QgA7g0
         pN42vQclsBtMiKpOr3B28c+84Q8c9nTlHpCvcwJbtNPhlOQWWSjKWl3PlB/Mxr70bwpr
         vn5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nvhA6QGuH/9Ca5AWv+XJgENCzjeCQ64n1KPkndplBJA=;
        b=15MQdmUzbvbfOthE/b+iyuJabZUfqlUmDU2ytYhrR/pxZH4qW2HAFm7mzcKeX1cUm6
         dzQ17xC9IFvXee3PhK+XUQM0jt/RoaEQxu8g42bS46J9a2fTjq/pxVIlFa82zZaRD4/I
         uSRkfr8P/sjBTOfBzkaWKgSUdw/9xE0M2zb1LMNjK8lpmYdWBgxHmZdx7yGZ9mj4S7ND
         9HCYNHgiPkPW34Lo1XN1J8L6uh6KILyigASkL6RwRChCn26UctTmQuqh/jA140WExO3o
         VqIWvTrCXh2kMLfHjCWcVwIPqPNe/voK1Uhm3G6f/aLKmquEaJG1a5cEh4j+fP/JSdJU
         OIzw==
X-Gm-Message-State: AJIora9jAB/HN/wwtRqj5ZS4m5wJdZb0nrjvTI1IMOVdCMjsqE8auzF0
        njFg9Y2to3dUDSM7Kn/xz86SxKsE2nAx4RkYnhI=
X-Google-Smtp-Source: AGRyM1vwQOOUdkXsnOuZHqXvL3pQW1N14XhtHPIrmqQ6yRqIVXNa/HCzs1sZUcS4Z+rwL0LZemvk9myUbwV6SUMG/fA=
X-Received: by 2002:a2e:8ec1:0:b0:25a:94fb:f9e6 with SMTP id
 e1-20020a2e8ec1000000b0025a94fbf9e6mr20825328ljl.401.1657059995995; Tue, 05
 Jul 2022 15:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
 <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com> <CANT5p=rhUvsrveJDA+AsJ6=j=sWC97LiTH+HcTFxbqRtFKqkAw@mail.gmail.com>
 <CAN05THSaD5JbdkjfEzQDtNOL-M+ZQhm-yrz6n1ystJKXOsJArw@mail.gmail.com>
 <CANT5p=pXXfou2H0pTX+yorFTkJ-AryhhDeaAuVzxoDb4-=U69Q@mail.gmail.com>
 <CAN05THTyNW6mw=arsDd5PCNvX_PwV2xijghe_MDFvbz_hMC-Nw@mail.gmail.com>
 <35b03fb9-1500-865f-f67a-c24817531ca1@talpey.com> <CANT5p=qetdByFLOV0=1VXXa0xMukAggaDtjaQ=K0KH4upVRa1A@mail.gmail.com>
In-Reply-To: <CANT5p=qetdByFLOV0=1VXXa0xMukAggaDtjaQ=K0KH4upVRa1A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 6 Jul 2022 08:26:23 +1000
Message-ID: <CAN05THSW5Yb0bRkEnU1iYVu=nbHriUm=PW2oHcx1WP1m2Z61bA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add mount parameter to control deferred close timeout
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 4 Jul 2022 at 23:52, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Fri, Jul 1, 2022 at 9:00 PM Tom Talpey <tom@talpey.com> wrote:
> >
> > On 7/1/2022 7:00 AM, ronnie sahlberg wrote:
> > > On Fri, 1 Jul 2022 at 18:44, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >>
> > >> On Fri, Jul 1, 2022 at 12:07 PM ronnie sahlberg
> > >> <ronniesahlberg@gmail.com> wrote:
> > >>>
> > >>> On Fri, 1 Jul 2022 at 16:03, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >>>>
> > >>>> On Fri, Jul 1, 2022 at 3:23 AM Tom Talpey <tom@talpey.com> wrote:
> > >>>>>
> > >>>>> Is there a justification for why this is necessary?
> > >>>>>
> > >>>>> When and how are admins expected to use it, and with what values?
> > >>>>>
> > >>>>
> > >>>> Hi Tom,
> > >>>>
> > >>>> This came up specifically when a customer reported an issue with lease break.
> > >>>> We wanted to rule out (or confirm) if deferred close is playing any
> > >>>> part in this by disabling it.
> > >>>> However, to disable it today, we will need to set acregmax to 0, which
> > >>>> will also disable attribute caching.
> > >>>>
> > >>>> So Bharath now submitted a patch for this to be able to tune this
> > >>>> parameter separately.
> > >>>
> > >>> Ok,  will the option be removed later once the investigation is done?
> > >>> We shouldn't add options that are difficult/impossible to use
> > >>> correctly by normal users.
> > >> We didn't intend to. We thought that this could be a useful tunable
> > >> parameter that the basic users need not even worry about, but advanced
> > >> users / developers could suggest changing it to tune / troubleshoot
> > >> specific scenarios.
> > >
> > > If it is just for developers needing it to debug specific issues  it
> > > should absolutely not be a mount option in upstream.
> > > Maybe have it as a /proc/fs/cifs/Debug thing or just provide custom
> > > builds for the customer when debugging specific issues.
> >
> > Absolutely agree. Upstream isn't a developer sandbox.
> >
> > I'll point out that this patch:
> > 1) Doesn't change any behavior as-is
> > 2) Doesn't give any guidance on values
> > 3) Doesn't update the userspace mount command
> > 4) Doesn't ever go away because it changes the ABI
> > 5) Increases the total number of cifs.ko mount options to 102.
> >
> > I'm not sure about that last one. It might be 103.
> >
> I understand that the concern is mainly around this being a mount option.
> So let's discuss what's the correct place for tuning such configurations?
> It could be a module parameter. It would make it global. But I guess
> that's okay.
> Thoughts?

I think /proc/fs/cifs/Debug would be an appropriate place since it
would make it obvious that it
is just a debugging option and not something normal users should use.
Perhaps something like making it writeable by root and be able to do :
echo "dclosetomeo:55" >> /proc/fs/cifs/Debug


>
> > > Once they become mount options they need to be documented, what they
> > > do and why you would use them and exactly how to determine what to set
> > > them to.
> > >
> > >
> > >
> > >>>
> > >>>
> > >>>>
> > >>>>> On 6/29/2022 4:26 AM, Bharath SM wrote:
> > >>>>>> Adding a new mount parameter to specifically control timeout for deferred close.
> > >>>>
> > >>>>
> > >>>>
> > >>>> --
> > >>>> Regards,
> > >>>> Shyam
> > >>
> > >>
> > >>
> > >> --
> > >> Regards,
> > >> Shyam
> > >
>
>
>
> --
> Regards,
> Shyam
