Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF0EC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 21:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ABEC6112D
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 21:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhINVXV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Sep 2021 17:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbhINVXM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Sep 2021 17:23:12 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAACC0613EE;
        Tue, 14 Sep 2021 14:21:49 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x27so1379892lfu.5;
        Tue, 14 Sep 2021 14:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uo/LrTByBuM+thHtzRuHWUtLdiKYW1ebh0CY7Ez0iow=;
        b=jeVUwEqzat+R2k0OIZLYt9s5LaqMT79H+JeUmw5eLwUbTrGEl/9tnHyVgazX2aUqlQ
         tvtDxfMewrdORjzyXhDz+J4m/x7mkS9Uchh3MCCZkCX3XZsTUV/Jeh1O2JUMcroA6Qq3
         hYI8oGd0H0YOFEkrR5W0k0vnl1nkYYxvJZWEzU5zhGSCyNd1iEGhKfU1VZNJvIjYqac4
         SGQIU//roCq1aW4S2t47ula622a0P/WAzUYvoaIsgfsmm90uF5sv/fyy97/agOeLZjk2
         syDqhoKrmrcJWrciBZytf+aEd2wZevBIj4VcDf1JCg4NaV0dAvxEdvjeNPxKyx7nGlqI
         ZmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uo/LrTByBuM+thHtzRuHWUtLdiKYW1ebh0CY7Ez0iow=;
        b=vh3/QcWC5gqNPAiKvLj4i1X2VpNSKFZz+wXpx9PvM09UoYBIrcHN5Vfu1Y3zDMJ2yi
         O3IqUplx1QyfTww8jD3htv5mHaz2g5gIXifyssS/5t65GBKrFq9NH8EQiEJ+ordHObCT
         N5vN5qxndz5D/171NLmfq1ez2iSScpIYSqnowfKHloQT1yX69iCrsLRyMRhPuDWR0vHy
         dAYnLid+GeQW3IjwgGYE77QDBL9b/3WbzZkd7RKrgzZ1WS7nFtgusGYUO6OswUOeDvPU
         wN2FkThIPNKTY8VCsL0QdWMErEPy3rQiFSP6rgJrcXeJlkvnSR3Asg3uqKd06lGuN7aB
         IWHQ==
X-Gm-Message-State: AOAM530v419IK5v/DlpxTj+1QvZwRrJZt4KDUvZlS7qUe65UettKlK4X
        mzQyAZy/SQnO8BgBdI4tvdvOLCT4f2QioUoLWz4=
X-Google-Smtp-Source: ABdhPJxYxUwDbsIFF8eGusAVg9bszlieDML1vS548jRVAiFxa3aPFGAznC8pWnTKFGS4fdIiXsXhatDQ5nFZK372+CY=
X-Received: by 2002:a05:6512:78:: with SMTP id i24mr14419410lfo.595.1631654506946;
 Tue, 14 Sep 2021 14:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvVdBoUW-0BfsxiRAE6X30cqhBtNDvG7pwKdQwsu+wXfg@mail.gmail.com>
 <CAHk-=wiNvB_j3VZYJ1yZqq+9JjgWCO1MUmRsjTKBwQ+x=kB5tg@mail.gmail.com>
 <CAH2r5mtTLUQa2U=MGHOVk_FsPZg6owMsw+RoTudWxGuoQej41g@mail.gmail.com>
 <CAHk-=wjxmDks6CS41PCy_BZG70pjAhcPBV_7ga8kSJySvvDezQ@mail.gmail.com> <CAH2r5mt72NYan9q8MR5H8cNkYzT4jn1ZM1f3jp5V-fDs2cyB-A@mail.gmail.com>
In-Reply-To: <CAH2r5mt72NYan9q8MR5H8cNkYzT4jn1ZM1f3jp5V-fDs2cyB-A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Sep 2021 16:21:36 -0500
Message-ID: <CAH2r5much4q6bETPPCbqmhb+ksrX=5RXu_fcNVNk8dHiqN+g2Q@mail.gmail.com>
Subject: Re: [GIT PULL] cifs/smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 31, 2021 at 1:06 PM Steve French <smfrench@gmail.com> wrote:
> On Tue, Aug 31, 2021 at 12:43 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Tue, Aug 31, 2021 at 10:09 AM Steve French <smfrench@gmail.com> wrote:
<snip>
> > I'm ok with directory renames, git handles it all well enough that the
> > pain should be fairly minimal.
> >
> > I'd ask for that to be done during a fairly calm cycle, though, when
> > there isn't a lot pending, so that any rename conflicts will be
> > minimized.
<snip>
> > > Do you have any objections to me renaming the client's source
> > > directory to "fs/smb3" (or fs/smb) and fs/smb3_common ...?
> >
> > So no objections to the rename per se, but can we please use a more
> > specific name that is *not* tainted by history?
> >
> > I'll throw out two suggestions, but they are just that: (a) "smbfs" or
> > (b) "smb-client".

Due to git history for fs/smbfs directory (from many, many years ago) rename
to "fs/smbfs" could be more confusing. So alternative suggestion which
I implemented
was rename the source directory from fs/cifs to "fs/smbfs_client."  I
will send a P/R
for that since it is fairly quiet right now.  If you would prefer that
we wait for a future
release that is fine too, but seems like low risk now and might reduce
future confusion in
the future (to rename the source directory).
