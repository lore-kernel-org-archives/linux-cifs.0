Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1865C83F2C
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Sep 2023 03:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbjIDD5Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Sep 2023 23:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbjIDD5Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Sep 2023 23:57:25 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E43FB
        for <linux-cifs@vger.kernel.org>; Sun,  3 Sep 2023 20:57:20 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-52c9be5e6f0so1146462a12.1
        for <linux-cifs@vger.kernel.org>; Sun, 03 Sep 2023 20:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693799839; x=1694404639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEFDRXUXma0/8zRFC/pvF67e0iQ+6NFBUWdQ4oiLvjA=;
        b=mJWrh0Hsm+Pd1YAMJYPqH6UPxsc+raKVtPgvzaQrH949TS2/NuPD8s7Y19jVlEknwk
         D1aNtFtIhib9bux5TTOBKibg9F+mANCkXldUp6gU1ZrJcUGdSwNpZFvvhQYB7K6XG2dq
         mTtjvyPm36K8GCZwD+177Bwdl/7v8D5ds822tnEWZ2hY+qcRyasuNTK/FViN5Lb92nUk
         46FDvzLhtLtpSy38NxQcyOpBZ7G2b+14W9vyGFLtrhIDfpSowdSJWZRO1dh+AdHqVYQ6
         gIHBJbNSnMnSflfWF3I433UhO3wS8GmqEzDX+/NpIoVVy1cVo/Alt7XW16nUD2qR1v6z
         HPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693799839; x=1694404639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oEFDRXUXma0/8zRFC/pvF67e0iQ+6NFBUWdQ4oiLvjA=;
        b=RIk82fpe5AoT1oG6SxbctgJ07MSddFVosdNHTsU4DDhUU6mflZClskDPK2ooY3wU/s
         d/9+hDzxFhaqVSHWVSp9eLp25MOV2kALPD+n6gXvCgbg7xO62uWp5Yv3ql9q5HDaRV0r
         BpD6z+DtsIEJPfIFhawjkrMZ/kqyJRGJ9GW2ZTWdp5Ew4akjbVgyYP1vPZVDZHqEG6np
         4FXNLgzJEd1CWwsOXSvuVQlVyrASHjIGX4ZjgmPbQJ+6dtSGW06NvWuCzInlsHF8eIpJ
         Ldmwp7arE2PbrWwbZ9umzHC2u1Nv1IfEUf4QiQkMVFgnLPGt21G9uG+XmidNY5vwamBQ
         8XAA==
X-Gm-Message-State: AOJu0Yzltz/WhDp40aGDncRBHjUOsTFW+KCM62D6igqdbY0vYQRmzlHK
        fVV0NhNlyLoe3bsRfb2ahf0ARR36uEoENo2Rheg=
X-Google-Smtp-Source: AGHT+IHtxpQ1X5UM9Xxh8xFMQyTSXn2M7w+IxEVvVkqowek51o++pVVSm+gzD/A4vj/LWpeSDVqgCjLk8v5EJ51xJXs=
X-Received: by 2002:a17:907:75d9:b0:9a1:c221:4661 with SMTP id
 jl25-20020a17090775d900b009a1c2214661mr5930275ejc.0.1693799838613; Sun, 03
 Sep 2023 20:57:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
 <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>
 <7ed6285e-8278-9b20-2512-6bcac4a21af9@samba.org> <CAH2r5msreVdsetQ1DQYY0orfh=N+zkxLnsWvuecYJWzN3Xev+A@mail.gmail.com>
 <CAN05THR=bR7Wr5qP_evmBEWuxFVtX-z2+o_KavZ5r_zbTD3W8g@mail.gmail.com>
 <CAH2r5mvf+kqp_YdZear29kpEhbzHNa7z5nnXCTmn74ShMVTZYg@mail.gmail.com>
 <CAH2r5muNavsN6ELUFMUWCXV_8N=FuNQ9Efyp3Uwy9msQMGs_LQ@mail.gmail.com> <CAN05THS7pQj2eb0uPurKH9WiFuGL9h6ucemUf8QF+co09WCOoA@mail.gmail.com>
In-Reply-To: <CAN05THS7pQj2eb0uPurKH9WiFuGL9h6ucemUf8QF+co09WCOoA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 4 Sep 2023 13:57:07 +1000
Message-ID: <CAN05THTyfxMOcndbFJvJbcXPdsoc2W5ZytfX_JBAE+gPgONKMA@mail.gmail.com>
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

On Mon, 4 Sept 2023 at 13:44, ronnie sahlberg <ronniesahlberg@gmail.com> wr=
ote:
>
> On Sat, 2 Sept 2023 at 08:47, Steve French <smfrench@gmail.com> wrote:
> >
> > I also noticed that Windows apparently lets you control the size of
> > the directory entry cache (the file info cached for directories). See
> > below:
> >
> > DirectoryCacheEntrySizeMax
> > HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\Dir=
ectoryCacheEntrySizeMax
> > The default is 64 KB. This is the maximum size of directory cache entri=
es.
> >
> > Should we add a tuneable similar to this (per mount? per system?)
>
> Probably not because most of the time these settings do not really
> work, and often, when you increase them you make things worse.
>
> I think you want to implement something like when a cached directory
> is re-opened then the timeout is reset so that
> hot directories will remain in the cache longer. Which is what you
> want. You want hot data in the case.
>
> On the other hand, you want cold data to expire as quickly as
> possible, because cache that is held up by cold data can not
> be used to store hot data until the cold data has expired from the
> cache. So you want this timer as short as possible.
> The shortest possible timeout without it also expiring out hot data.
>
> Shorter timeouts and quicker expunge oc cache =3D=3D better performance.
> It might not sound intuitively but I can show with a simple example.
>
> Assume your cache has 10 slots to store a directory.
> Assume you have 1000 cold directories that are accessed relatively infreq=
uently.
> Assume you have 1 directory that is hot and is accessed 10 times more
> frequently than a cold directory.
>
> We now changed the timeout to 60 seconds. This means any cold
> directory that enters the cache will sit in the cache and block that
> entry for 60 seconds
> until it is cleared and something else can use that cache slot.
> This is akin a model where every 60 seconds you have a lottery where
> 10 directories will win entry to the cache.
> What is the probability that a hot directory wins the lottery and
> becomes cached?
> In this example it is 1%  because the access to the hot directory is
> only 1% of all access.
> All the cold directories have just a 0.1% chance of becomming cached
> but since there are so  many of them they will still dominate.
> (The problem we have to solve now is to get the hot directory into the
> cache as fast as possible and to get it to remain in cache for as long
> as possible.)
>
> On average thus we will have to wait 50 iterations until the hot
> directory will even enter the cache for the first time,  or it will on
> average take 50 minutes
> before the hot directory is even cached.
> If we had left the original 30 second timeout it would "only" have
> taken 25 minutes on average to get this directory into the cache.
> This kind of suggests that even 30 seconds would be way to big for
> this example and maybe we should use 10 seconds, or less.
>
> You want hot directories in the cache for as long as possible. A good
> way to do this is to make them sticky, so that if they are frequently
> accessed while
> cached, make them sticky so they do not expire as easily from the cache.
> On the other hand, any cold directory you want to expire from the
> cache as fast as possible since every time you hold a cold directory
> in cache, that part of the cache becomes
> useless and wasted.  You do this by, for example, setting this timeout
> as low as possible. So they are kicked out as soon as possible.
>
>


A slightly more complex implementation might be that
when you add a directory to the cache you set an initial, relatively
short timeout,
maybe 3 seconds, before it expires.
Then every time a directory is accessed while in the cache, you reset
the timeout
to double the expiry time up to a maximum of 30 seconds/60 seconds/...

That way a hot directory will relatively quickly become sticky while a
cold directory is kicked out
after just 3 seconds or so or whatever the initial short timeout is set to.


Probably would need a good set of data and real tests to tweak these
values and understand what
good defaults would be.
Probably would be a good idea with a bunch of dbench scripts to create
and perform some I/O resembling
common application workloads on sets of a few tens of thousands of
directories and measure cache-hit rate
as well as wall-clock time to run each test. Maybe also compare with
test runs agains a target with very roundtrip
versus very high roundtrips. And some mixture between the ratio of hot
vs cold directories.

To be realistic I think the total set of directories in the test would
need to be orders of magnitude
larger than the number of directories that can fit in the cache.

>
>
>
>
>
> >
> > On Fri, Sep 1, 2023 at 5:20=E2=80=AFPM Steve French <smfrench@gmail.com=
> wrote:
> > >
> > > On Fri, Sep 1, 2023 at 11:31=E2=80=AFAM ronnie sahlberg
> > > <ronniesahlberg@gmail.com> wrote:
> > > >
> > > > Maybe just re-set the timestamp every time the cached directory is =
reopened,
> > > > that way a hot directory will remain in cache indefinitely but one
> > > > that is cold will
> > > > quickly time out and make space for something else to be chaced.
> > >
> > >
> > > Makes sense
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
> > Thanks,
> >
> > Steve
