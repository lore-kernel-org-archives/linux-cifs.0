Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B30C433B4
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Apr 2021 02:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16F1461245
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Apr 2021 02:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhDYChu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 24 Apr 2021 22:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhDYCht (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 24 Apr 2021 22:37:49 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983BEC061574
        for <linux-cifs@vger.kernel.org>; Sat, 24 Apr 2021 19:37:10 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b23so542879lfv.8
        for <linux-cifs@vger.kernel.org>; Sat, 24 Apr 2021 19:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ApMca1Eyr5GUSdGvas8Fas+otOhefecXCgTN5Q8YgXI=;
        b=YLOGxvAEFQErgZFXnZI6jqkb7mfqVD5pT34dHeuRz+9DBAvgQixKJRjpIQJjltBd1h
         p3FqktfkfUjSg9N3WV8kT07+5JvU9N+xny29aDkwGgO6yLRkboQq+QOIpCDigMCj5f6V
         aVnEhJfX3nDUyfizUhpzLEqGo5zTr+J20gJWTVOfhSGnwJXf34jvLqicAseiPFSCbJZB
         PV9Sa4XdqbMvKGCzfrQn7NUjmlHluuquxdjLHjIJTs5Dvg6w0J3n9ZcogALk+wAUGKPe
         WX3jc/cFR8ZMnYSa6tIdjfN0kQwtnzXYFPc97W6ZmbTcljZLJ/8ckc49/YPMc2pU+sht
         y2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ApMca1Eyr5GUSdGvas8Fas+otOhefecXCgTN5Q8YgXI=;
        b=KdB9aCjXmigxn7YeHQZUMRmoPyDUKim6QqmcjKRV5Z24R8orW4Z3YNNCAmfGTT8VJq
         biCTfgcZl4TGLM03yO2kEGAAXOBF/BvfgqYTGLsATy0NgjCvxMhAGwxz+7n+tCRNXkZX
         Zcx9J07vmee0z1a4/s4TXHBzRz7mwnAs/Bimr/VxADqwWdOPZyFC4CHU+6O2YVnIxyXY
         /PgJDxnFlGwSTliHXVXOVGcuGhq/RZ5tZOKHfPexZ3NAP3HOeop2ZANjd1PvFQwcQhtU
         QLftBkUl6+UKpMqAX1NS6MwkkUzVxPjgxeFfsyhN62bzUMXx7gNB9udWWI0/LglV+0QA
         ne0w==
X-Gm-Message-State: AOAM531XYm8zdI0WTQENbYDcTxHLgvzbiFiTUmiBbp9sVsu6U2mLOdws
        9Kn8ja9m/1oEjmGWLpzfEAT+qTsJM79/Ztd+t/8FCacP
X-Google-Smtp-Source: ABdhPJxgaeXVrlJiYWKfN7hRlo4O2mEV+lE7HwqfGyNiXJtMDGfRI4Dpwn6VE0TVA31J00kkDnRpqyqYL3c/mBLyWrA=
X-Received: by 2002:ac2:5cab:: with SMTP id e11mr7929511lfq.175.1619318222512;
 Sat, 24 Apr 2021 19:37:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org>
In-Reply-To: <20210425020946.GG235567@casper.infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 24 Apr 2021 21:36:51 -0500
Message-ID: <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yep - good catch.  It is missing part of my patch :(

Ugh

Will need to rerun and get real numbers

On Sat, Apr 24, 2021 at 9:10 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Apr 24, 2021 at 02:27:11PM -0500, Steve French wrote:
> > Using the buildbot test systems, this resulted in an average improvement
> > of 14% to the Windows server test target for the first 12 tests I
> > tried (no multichannel)
> > changing to 12MB rasize (read ahead size).   Similarly increasing the
> > rasize to 12MB to Azure (this time with multichannel, 4 channels)
> > improved performance 37%
> >
> > Note that Ceph had already introduced a mount parameter "rasize" to
> > allow controlling this.  Add mount parameter "rasize" to cifs.ko to
> > allow control of read ahead (rasize defaults to 4MB which is typically
> > what it used to default to to the many servers whose rsize was that).
>
> I think something was missing from this patch -- I see you parse it and
> set it in the mount context, but I don't see where it then gets used to
> actually affect readahead.



-- 
Thanks,

Steve
