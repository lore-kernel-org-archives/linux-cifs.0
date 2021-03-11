Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C161C433E6
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 13:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D87B564FA0
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 13:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhCKNb3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhCKNbS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Mar 2021 08:31:18 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0386BC061574
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 05:31:18 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id x19so21752236ybe.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 05:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/kSM5xQTY6L/CGOlUMvBbmG0sEZGRfbdG8W2y2Q3VTE=;
        b=XjTFHkE9QpHddasjTZ7kmYq9fDSVVakWzlzsctAqAhhFs29k7PrEweu+Hs3tN+ooVL
         o+nqr+2Vlac/U9HaPMAhCFq8n61/PhSWJ/y67PTecZKE90jnAQ8dMotELYFX68ZBYmj6
         JR6Rc0sPiZBOfaft7qtWT2LIiXDJS19t5D592Ki7X3LsdB+FhQDsvS8warkhLYoxQIov
         kGmfpj1R8/9Y4JP/Ip+5xR812v80bKiFe02bDyALrUh1MBhJMaOGaZ2DYi6+VvfbupJn
         JDKZfvDsWIwQHCES3vOgl4E4bjl8V4mhieHeHe1G9h7vSlleVQpoHAg/UcV1T9+bacoT
         g61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/kSM5xQTY6L/CGOlUMvBbmG0sEZGRfbdG8W2y2Q3VTE=;
        b=Cl8i/rKi8Fepyshb5gNzReRH4WQwyV6bDqvtga9gt/wtLgXuvBVxrF7ybZrkdaH4po
         UiXSgSXxmYx9ynHYcJLlxzz3NphrFTgEWUzDdQ8dSvIRJOhSY2pTqcmI+z+6pB2e+DfY
         ZX1UpQrZRYQ6jTMgqW0MJm4/wO7pbnV3uU2cYJdySvk1Z4JCQakf48Y0Y+an0AXY5ZSs
         MaqBSryXV/dg+dIHS+LrSopM/oriRR7d81JxIRoOuM6JMEizgG1oSCfhpVz5jyX8Ar8U
         wGKDNGU/l+OXCHm/EqWIyfHgk21c/AHJ6TzuznUp1H2AapGp+fkOMM35N668KlPhAMqE
         ttnQ==
X-Gm-Message-State: AOAM532BpGaVt3dZL+VCjJczjhyQUWK1vJI/OxHv/BxxaSO2gTeKv8NP
        +bj1exh7b3S20lMOtDoSNc41fWuUFlc0R1syq3I=
X-Google-Smtp-Source: ABdhPJwFK4TerJIwN9ABjhP0UA15QScWzQXLbEIKFxGs8KHLuiCj/SwVbMRyavDy82TL7ogxsuxiE6zGs/qgF8m32Sw=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr11096979yba.3.1615469477212;
 Thu, 11 Mar 2021 05:31:17 -0800 (PST)
MIME-Version: 1.0
References: <20210305142407.23652-1-aaptel@suse.com> <CAH2r5mufnuA4cavG8JYq2q+-9kY3oHeoQrLyzeXgN2xFQ8P6_w@mail.gmail.com>
 <CANT5p=pzh7a9v1q15m056i=cN-MC4W2W2Lx3P68itHzd5EQnnQ@mail.gmail.com>
 <874khlx3pv.fsf@suse.com> <CANT5p=r_3=YAj0v-q=R85FLH2S2EjMMinbezMvROqdyB+=X7OA@mail.gmail.com>
In-Reply-To: <CANT5p=r_3=YAj0v-q=R85FLH2S2EjMMinbezMvROqdyB+=X7OA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 11 Mar 2021 19:01:06 +0530
Message-ID: <CANT5p=qiDfYVy8gfbA=AitndK4bb88ju19bc4t1wt8D2vGWy8w@mail.gmail.com>
Subject: Re: [PATCH] cifs: try to pick channel with a minimum of credits
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Discussed this with Aurelien.

> I'm only saying that on getting a EDEADLK error from
> compound_send_recv(), try another channel instead of returning that to
> userspace.
We both agreed that this will be a cleaner way to deal with the issue.
However, he pointed to me that the code changes will be more than what
I initially thought.
That needs more investigation.

The most likely case to hit the problem of EDEADLK is when the first
request on the channel is bigger than what we need.
The proposed fix should avoid that for basic requests by switching
channels (pending testing).
However, a large read/write could still result in EDEADLK error being retur=
ned.

Regards,
Shyam

On Thu, Mar 11, 2021 at 4:19 PM Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
>
> > Some code relies on server->* values so if you swap the server pointer
> > it at the last moment I'm not sure those values will match the new
> > server ptr.
>
> I'm not sure that I understand this. I'm not suggesting that we swap.
> I'm only saying that on getting a EDEADLK error from
> compound_send_recv(), try another channel instead of returning that to
> userspace.
> Please let me know if I'm missing something here.
>
> Regards,
> Shyam
>
> On Mon, Mar 8, 2021 at 5:22 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
> >
> > Hi Shyam,
> >
> > Thanks for the review. I also realized we cannot make this failproof so
> > I went in with the idea to just avoid picking easy, non-confusing cases
> > of unusable channels. If that's not good we can drop the patch all
> > together.
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > Spent some time in this code path. Seems like this is more complicate=
d
> > > than I initially thought.
> > > @Aur=C3=A9lien Aptel A few things to consider:
> > > 1. What if the credits that will be needed by the request is more tha=
n
> > > 3 (or any constant). We may still end up returning -EDEADLK to the
> > > user when we don't find enough credits, and there are not enough
> > > in_flight to satisfy the request. Ideally, we should still try other
> > > channels.
> >
> > Yes you're right, it won't prevent failing if more credits are
> > needed. The patch wasn't meant to be failproof, just to avoid most
> > occurences of the problem. It's a simple sanity check with some
> > false-positives and false-negatives.
> >
> > > 2. Echo and oplock use 1 reserved credit each, which the regular
> > > operations can steal, in case of shortage.
> >
> > There's a dedicated server->echo_credit I think.
> >
> > > 3. Reading server->credits without a lock can result in wildly
> > > different values, since some CPU architectures may not update it
> > > atomically. At worse, we may select a channel which may not have
> > > enough credits when we get to it
> >
> > If we are just doing a read on an aligned int, at least on x86 you will
> > get either a stale value or the new value, you cannot get a garbage mix
> > of both. Which CPU architecture doesn't provide cache coherency at that
> > level? This is a complex question I couldn't find an easy answer to.
> >
> > In any case cifs.ko is already assuming it's valid in various places. W=
e
> > are doing it for some usage of the server->tcpStatus, ses->status,
> > tcon->tidStatus at least.
> >
> > The problems of atomic read in pick_channel() aside, the credits might
> > change from another process between the moment the channel is picked an=
d
> > the moment the credits needed are spent (server->credit -=3D XYZ). In
> > which case it will also EDEADLK later on.
> >
> > > What if we do this...
> > > wait_for_compound_request() can return -EDEADLK when it doesn't get
> > > enough credits, and there are no requests in_flight.
> > > In compound_send_recv(), after we call wait_for_compound_request(), w=
e
> > > can check it's return value. If it's -EDEADLK, we keep calling
> > > cifs_pick_another_channel(ses, bitmask) (bitmask has bits set for
> > > channels already selected and rejected) and
> > > wait_for_compound_request() in a loop till we find a channel which ha=
s
> > > enough credits, or we run out of channels; in which case we can retur=
n
> > > -EDEADLK.
> > > Makes sense? Do you see a problem with that approach?
> >
> > Some code relies on server->* values so if you swap the server pointer
> > it at the last moment I'm not sure those values will match the new
> > server ptr.
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
>
>
> --
> Regards,
> Shyam



--=20
Regards,
Shyam
