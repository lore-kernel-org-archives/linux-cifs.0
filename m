Return-Path: <SRS0=ZOHs=XF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29992C49ED7
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 21:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBEAB21019
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 21:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KvafdDmL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfIJVKX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Sep 2019 17:10:23 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:34792 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfIJVKX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Sep 2019 17:10:23 -0400
Received: by mail-io1-f49.google.com with SMTP id k13so25713578ioj.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Sep 2019 14:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j2zPZFhNYbAD1Tlai8SFJO986X1MFMWF8C3VnOdZigM=;
        b=KvafdDmLoTtPFauo0Xy5YI+yGBUE1xeGtfCrnA5gQp6Jtz2JtAFAF6gdU8EjtPairX
         xybq44ovyzalTlD1ZDCxZ2YiwJSPCj2je0G2zUYVlgGUaMI/k0YYYkygcrM2zGnnPCrZ
         SzOFqqF5QFwKpUgNE7U3dM+WWlHMcNwDfk1C1x9CIhf4nfX4Iv4L3Ce1W5NxqwU+ebf/
         AFM/4JJHHHfPahwV/7T5K4hmN/O13QYlHAsxVelnZoBRBhSmKFfPY/J9jgHV+j/BLxA/
         gqK2fQfZXVBdsOTu7eAPGDFNTOD+ZlLiygdyK83E/uNqriQprfPwXEkn3MBNVPKIjsMU
         thlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j2zPZFhNYbAD1Tlai8SFJO986X1MFMWF8C3VnOdZigM=;
        b=F4q/2vUhp7k8wpyA6/eetQ4RZA945WgOuH6+mysivQUGY6/XFxowbYj9AWFiV7w4YJ
         alESJ5UqjUJ/ul69CcQV0DXu1LbMq+roUzVmaXFfnggZItfnBAOgqn6T2RUSvBsp46Xy
         Za9BO6TmBRaNogWjU1pM30PUuDDmosFbR/dqcU15u4lRHeAFwUclw30gboByiFTDWIqE
         SIODYda4g0iiMKlTq4nLUUhQC08bMsFq4moc/AYh8PgxvS6j6hF3rXvnGycBbJM4UjJ7
         s+sQooH6PScYDhF+187J4v8MBigSyHm6W8b0ALYQ/PthsaCI87ipHDIV3HG5tyMU7gUF
         Px/w==
X-Gm-Message-State: APjAAAV2M8LHJ97sCybjczwLOc7HiWcl4EYbymJVlYjQuoxPD/BSz3Yk
        MQQf4/iDm+WBopIJmVelpoQX5nhDnd9UGByddWI=
X-Google-Smtp-Source: APXvYqy5cPWt33ZnfZOapHDfbUcvY84scHIbBMyww9l+ejFzftuQMyxEF33xwcq5g2ixyAsYTet1Zbq+1QRRH+/NUJ4=
X-Received: by 2002:a02:8563:: with SMTP id g90mr13457999jai.63.1568149822179;
 Tue, 10 Sep 2019 14:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msbRyGMY2XQifbxB0iU3a3EPp8UcemO8QE5bhq9HPMqBQ@mail.gmail.com>
 <CAH2r5mv=6dR+5nxJbw19C0QZf3wJQOc5j4CTGTZ=OABqMdQDpw@mail.gmail.com> <CAN05THQxtGKMfO6aRELK5fsc-x1m+u0fCCsNmRYaoFQHa_v86A@mail.gmail.com>
In-Reply-To: <CAN05THQxtGKMfO6aRELK5fsc-x1m+u0fCCsNmRYaoFQHa_v86A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 10 Sep 2019 16:10:11 -0500
Message-ID: <CAH2r5mtwUoTptviSnXBdzBCEhjerWncQqePs+DdxKMj1vKb+nQ@mail.gmail.com>
Subject: Re: [SMB3][PATCHes] parallelizing decryption of large read responses
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

By the way ... my thoughts on "esize" (as an example) is that for a
release or two encryption offload is disabled (but mount option is
mentioned) and then when we are very comfortable with its stability
(and the heuristic we use to turn it on - currently "at least one
other SMB3 requests in flight to the same server" ... we are
comfortable with).   So we have some other mount options like this
that should be used rarely now, and can be noted as such.

On Tue, Sep 10, 2019 at 4:19 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
>
> We have now a decently large number of new mount options so we need a
> patch to the manpage.
> That said, we should also make sure that we try to set reasonable
> values by default,
> or even longer term, remove the options with heuristics.
>
> (Very very few people read the manpage or ever use any of these mount options
> so our default should be "as close to optimal as possible" and using a
> mount option
> should be the rare exception where our heuristics just went wrong.)
>
> On Tue, Sep 10, 2019 at 12:21 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Had a minor typo in patch 2 - fixed in attached
> >
> > On Sun, Sep 8, 2019 at 11:31 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > I am seeing very good performance benefit from offload of decryption
> > > of encrypted SMB3 read responses to a pool of worker threads
> > > (optionally).  See attached patches.
> > >
> > > I plan to add another patch to only offload when number of requests in
> > > flight is > 1 (since there is no point offloading and doing a thread
> > > switch if no other responses would overlap in the cifsd thread reading
> > > from the socket).
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



-- 
Thanks,

Steve
