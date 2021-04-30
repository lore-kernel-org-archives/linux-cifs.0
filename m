Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E07AC433B4
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 19:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00A216146D
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 19:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhD3TXX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Apr 2021 15:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhD3TXW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 30 Apr 2021 15:23:22 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D28AC06174A
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 12:22:33 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id v6so5342445ljj.5
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 12:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JI0mPIQY4SQQXCeRpiiDgKdyW+NtwT6tlay69HeL4tY=;
        b=q5K+I0onBtzEfRgxEyea0On6OIUncr24GuB9VUpoAxKg1J1z/fTXoNCCUqg/bI0QZz
         AtYEAqkRrxczNGvwwEr4f9iQE+iSp0/wkggzVqxHiMEo5BkmwiiX1VqTLluTot6OlHEn
         1esqGoEmQ0zc2DL6DRvXxEOC4Ef+0Ujhzn7/H61yOFCXI29r2AQBJulC0hjqtZ7NiuRJ
         XKkuVjGMHBrGfzTsZm3kBuNrDsXKQdORglcmvUi2SpEHy83wa0ZJRw6Ai0H64AELaqHB
         STAjbcSJgSBXyEjpksv1BKcnxbPVYXLf3zDb70vJdXqWNIueFyIVi7klmBR802ByCjVH
         QGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JI0mPIQY4SQQXCeRpiiDgKdyW+NtwT6tlay69HeL4tY=;
        b=k3eK2g53E59DghehlVd1bUz7gL55xpNL6iiQiWJUmpbynQp8r3sr/1We5T6qmCAipF
         pHe5HdmKP/7qPyBpFTJcoTkF6jRd8jUPLvzGwXPxX/NIX61SfLOB8QZIpYXICNVpz/AA
         NxttfSM+FXAGPkrI1bWFMz1gZm4TjHJ4K/wHcRw5LDAEZ+xiM9+OfLXgGMIDXTkaO9dC
         ez9RAAx3lZvop18GCMdygxOuTfwowjuMwPsAhOfOzjVlEdZH9kOgldUOzwQ5UZOA85Ek
         kQ5uBezVkmVqkFJhMB9pPSIOXZ7j7t2gJuk+snrXt+Cig1izMDL8Ube3mjJRqzSKF3l8
         Du2g==
X-Gm-Message-State: AOAM532u34lT2ic4ABwm0PU3IUGYPon6Zx70ygqh7o3SjD3JQI4eayrH
        8pPORN/i8abcwge7FCj4Gp1fshsF1IXkOytfcNf1kqkZ
X-Google-Smtp-Source: ABdhPJyecTMJVayUB61GFRkhPnXccJCGuBMDe4YamEhZZuB/vElX//ORscx6dOdq9G0VKu2sfSjs6tq1WLlyvc2g1PI=
X-Received: by 2002:a2e:6e03:: with SMTP id j3mr4772807ljc.218.1619810551795;
 Fri, 30 Apr 2021 12:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org> <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
 <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com>
 <20210426115457.GJ235567@casper.infradead.org> <CANT5p=rHgmLdHJm_y3CCpb=KoEbnJApce2wx4hORY2CwHP2NbQ@mail.gmail.com>
 <20210430115948.GL1847222@casper.infradead.org>
In-Reply-To: <20210430115948.GL1847222@casper.infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 30 Apr 2021 14:22:20 -0500
Message-ID: <CAH2r5mtE2g=p_rKThrDR_4N6=zqaBiz_KpK+bPpw5Q+qeFuTjQ@mail.gmail.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 30, 2021 at 7:00 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Apr 30, 2021 at 04:19:27PM +0530, Shyam Prasad N wrote:
> > Although ideally, I feel that we (cifs.ko) should be able to read in
> > larger granular "chunks" even for small reads, in expectation that
> > surrounding offsets will be read soon.
>
> Why?  How is CIFS special and different from every other filesystem that
> means you know what the access pattern of userspace is going to be better
> than the generic VFS?

In general small chunks are bad for network file systems since the 'cost' of
sending a large read or write on the network (and in the call stack on
the client
and server, with various task switches etc) is not much more than a small one.
This can be different on a local file system with less latency between request
and response and fewer task switches involved on client and server.


There are tradeoffs between - having multiple small chunks in flight
vs. fewer large chunks in flight - but a general idea is that if possible it can
be much faster to keep some requests in flight and keep some activity:
- on the network
- on the server side
- on the client side

to avoid "dead time" where nothing is happening on the network due to latency
decrypting on the client or server etc.  For this reason it makes sense that
having multiple 4 1MB reads in flight (e.g. copying a file with new "rasize"
mount parm set to (e.g.) 4MB for cifs.ko) can be much faster than only
having 1 1MB
read in flight at one time, and much, much faster than using direct
i/o where some
tools like "rsync" use quite small i/o sizes (cp uses 1MB i/o if
uncached i/o for
case where mounted to cifs and nfs but rsync uses a small size which hurts
uncached performance greatly)
uses much smaller)


-- 
Thanks,

Steve
