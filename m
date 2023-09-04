Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD1AC71153
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Sep 2023 03:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbjIDDpA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Sep 2023 23:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbjIDDo7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Sep 2023 23:44:59 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A08C5
        for <linux-cifs@vger.kernel.org>; Sun,  3 Sep 2023 20:44:56 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9936b3d0286so151887366b.0
        for <linux-cifs@vger.kernel.org>; Sun, 03 Sep 2023 20:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693799095; x=1694403895; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYYLuQTLzqjp9LGduO+rYd8endTdBP7gsdqEAxFVCmw=;
        b=PaPyuzACZHyoyjE1z5LiJIASLHvA+XUbaASvPCC20lgvugTSUGrVTGSM/NjflorGhx
         qzB8T3oE0zrK3AcAWmOIvGAgJClOO8Oiq103TA0WDycj5UfdQ2XetNRqP5VHnomFOgM5
         Qsheqc8QKFhFFKFiwQynQnTlPqxdqVMy1jnKGZTUZhxepcT/X+SAJingKQapNe79qXyh
         7U3tOOsqESKF/lyyw9kEPQb6TVQR3dUbZgrfu34+QYs+767fYE0IDQBae8pABM46GIfD
         5HhFYhmoSraF1prpdgSX57Hlrvy4Wm65vCJRg/m8sHTWablVkkFoI57fPfFCmehAtoFd
         ZsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693799095; x=1694403895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYYLuQTLzqjp9LGduO+rYd8endTdBP7gsdqEAxFVCmw=;
        b=M0lYuTh9xfB7TIVYaX3LVSvPG5suAcHwfNAeFoT2OKEhLkn9tK7gty03pfGwsAOPw3
         wF3qUlG2sg/s8XTul9MB4WZE0p4fdKy5V3zgPPQgknyhvEGff12o+OaL8L049YQTgm4r
         KgHbmPFXnM/D9kukrGZCQA5IZlHhFd1RElM9nBryw3Of8v9eYZQvw9+LKOpVVWL/fEeJ
         b1j2wC03QZAbpjCdzbHG3ywS5/3tp54CLeHNps5571nurys96zdTyrSwhSd01RCTiXfo
         UXVj5JKX2+DDd/up6bwXeCr096kIFM0UbeXAi/NKHA3e/pZBQhu7lnNbRJATYFNg1ykT
         frAg==
X-Gm-Message-State: AOJu0YypGyd3rqZI/X0JHaT/bnMCUp5NuOGh8rIVOK0VG+RXVryr2KzJ
        yMlxAJnjw3WjOBOAXgh7KikT2tp4COuB/D3WZi/HGyvEftk=
X-Google-Smtp-Source: AGHT+IGC2WvVD/VIHMxur3RUr0tfRH9MV6fb7zl/m+DokmXlnjvaFsDYWo9ZpLafU5qj2JaFu1nASzOaPwjCJnGuEW8=
X-Received: by 2002:a17:906:30d4:b0:9a5:d972:af43 with SMTP id
 b20-20020a17090630d400b009a5d972af43mr6611715ejb.65.1693799094581; Sun, 03
 Sep 2023 20:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
 <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>
 <7ed6285e-8278-9b20-2512-6bcac4a21af9@samba.org> <CAH2r5msreVdsetQ1DQYY0orfh=N+zkxLnsWvuecYJWzN3Xev+A@mail.gmail.com>
 <CAN05THR=bR7Wr5qP_evmBEWuxFVtX-z2+o_KavZ5r_zbTD3W8g@mail.gmail.com>
 <CAH2r5mvf+kqp_YdZear29kpEhbzHNa7z5nnXCTmn74ShMVTZYg@mail.gmail.com> <CAH2r5muNavsN6ELUFMUWCXV_8N=FuNQ9Efyp3Uwy9msQMGs_LQ@mail.gmail.com>
In-Reply-To: <CAH2r5muNavsN6ELUFMUWCXV_8N=FuNQ9Efyp3Uwy9msQMGs_LQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 4 Sep 2023 13:44:43 +1000
Message-ID: <CAN05THS7pQj2eb0uPurKH9WiFuGL9h6ucemUf8QF+co09WCOoA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow controlling length of time directory entries
 are cached with dir leases
To:     Steve French <smfrench@gmail.com>
Cc:     Ralph Boehme <slow@samba.org>, CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, 2 Sept 2023 at 08:47, Steve French <smfrench@gmail.com> wrote:
>
> I also noticed that Windows apparently lets you control the size of
> the directory entry cache (the file info cached for directories). See
> below:
>
> DirectoryCacheEntrySizeMax
> HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\Direc=
toryCacheEntrySizeMax
> The default is 64 KB. This is the maximum size of directory cache entries=
.
>
> Should we add a tuneable similar to this (per mount? per system?)

Probably not because most of the time these settings do not really
work, and often, when you increase them you make things worse.

I think you want to implement something like when a cached directory
is re-opened then the timeout is reset so that
hot directories will remain in the cache longer. Which is what you
want. You want hot data in the case.

On the other hand, you want cold data to expire as quickly as
possible, because cache that is held up by cold data can not
be used to store hot data until the cold data has expired from the
cache. So you want this timer as short as possible.
The shortest possible timeout without it also expiring out hot data.

Shorter timeouts and quicker expunge oc cache =3D=3D better performance.
It might not sound intuitively but I can show with a simple example.

Assume your cache has 10 slots to store a directory.
Assume you have 1000 cold directories that are accessed relatively infreque=
ntly.
Assume you have 1 directory that is hot and is accessed 10 times more
frequently than a cold directory.

We now changed the timeout to 60 seconds. This means any cold
directory that enters the cache will sit in the cache and block that
entry for 60 seconds
until it is cleared and something else can use that cache slot.
This is akin a model where every 60 seconds you have a lottery where
10 directories will win entry to the cache.
What is the probability that a hot directory wins the lottery and
becomes cached?
In this example it is 1%  because the access to the hot directory is
only 1% of all access.
All the cold directories have just a 0.1% chance of becomming cached
but since there are so  many of them they will still dominate.
(The problem we have to solve now is to get the hot directory into the
cache as fast as possible and to get it to remain in cache for as long
as possible.)

On average thus we will have to wait 50 iterations until the hot
directory will even enter the cache for the first time,  or it will on
average take 50 minutes
before the hot directory is even cached.
If we had left the original 30 second timeout it would "only" have
taken 25 minutes on average to get this directory into the cache.
This kind of suggests that even 30 seconds would be way to big for
this example and maybe we should use 10 seconds, or less.

You want hot directories in the cache for as long as possible. A good
way to do this is to make them sticky, so that if they are frequently
accessed while
cached, make them sticky so they do not expire as easily from the cache.
On the other hand, any cold directory you want to expire from the
cache as fast as possible since every time you hold a cold directory
in cache, that part of the cache becomes
useless and wasted.  You do this by, for example, setting this timeout
as low as possible. So they are kicked out as soon as possible.







>
> On Fri, Sep 1, 2023 at 5:20=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
> >
> > On Fri, Sep 1, 2023 at 11:31=E2=80=AFAM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > Maybe just re-set the timestamp every time the cached directory is re=
opened,
> > > that way a hot directory will remain in cache indefinitely but one
> > > that is cold will
> > > quickly time out and make space for something else to be chaced.
> >
> >
> > Makes sense
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
> Thanks,
>
> Steve
