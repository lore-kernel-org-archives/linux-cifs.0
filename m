Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B0AC43460
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 04:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EE1B61263
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 04:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhDZExW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Apr 2021 00:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDZExV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Apr 2021 00:53:21 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD01C061574
        for <linux-cifs@vger.kernel.org>; Sun, 25 Apr 2021 21:52:39 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id t94so10019762ybi.3
        for <linux-cifs@vger.kernel.org>; Sun, 25 Apr 2021 21:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dF5NkQW2l8YzcJgY6B7g3OvZDjIemy0cgB9Ta5KCd7M=;
        b=s5jERKqVUImiLI1TCVTEg3Vx3LrDDH1eAaxKMzc7651s0iUDZIMFeW0O5DNSbX6tLB
         BwOuvDtXYlqd+alCfaLpFIAABHeLU4YUt1GG58hyeVIDDtx/q3pSZUwU3fFcv6QFevLc
         PfXWqzphcxEcRjd0LKN2BbDMqOJTVx/r0SpEkwcxQFd1VgTQ8zCHOhx2JXj6nJck0FLH
         Aojp0Yb2y3EmNnHPRVzw2e6AsKd6SPJPis1lVop6/sUPeP6a5Mb897KyV3ofTJlBmSQd
         gVMWqgxXbFCktCRSEZzTrPlrTsOlF/jmSy5rEEj06iYZnX26l89bJ94iGmzeFS+Pax+B
         QgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dF5NkQW2l8YzcJgY6B7g3OvZDjIemy0cgB9Ta5KCd7M=;
        b=XGpq5wHVuGNGzYKl3UFG4tR7+lgPheLrLhEqK89G9IwI0j3m4ONSDxGKhfQNvB3vuA
         M01HY6/W2d0pj2sYiEIHcL3RSMWqLmoQQDEi63A1AiDARYMkH6FyP+gEWbUZom4CNuVK
         lIUmNteMfJe2KgxJVxtqK9CQcbm+a4NrUEpjctVmUxrADUNf5xt1U8cV9giKWG+o9IdU
         9pFJ2JkAGTDwkubEfZ8iJV9Uj9BOqKQ+ODKr6ufcM0UGB0zEcKnGjxjttwbUJMAl92eY
         tF6fHZl62qYDHEevpZsoNdHKRokG8jBMhyyuLsQsfXVoLEX8X+7rdxxfYt6VMrO6aHdi
         v9fQ==
X-Gm-Message-State: AOAM530gZR/FpcZvZJMCe6LIt2M0DAk+o/0RrfMH1Yd9Hk9ZrDed/vcl
        tLoYID2OVI5I2dGWn2/YnxwcOHkXw1sKFf9jeXM=
X-Google-Smtp-Source: ABdhPJxmCTO/3mGEXNKhBAtozXB/Vnhx6cuIfTmiMRREL63vdyf321rpe3RocezqYXoJIedR1guFgPJp4s+AGDe1PtA=
X-Received: by 2002:a25:3287:: with SMTP id y129mr6115745yby.97.1619412758608;
 Sun, 25 Apr 2021 21:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org> <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
In-Reply-To: <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 26 Apr 2021 10:22:27 +0530
Message-ID: <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
To:     Steve French <smfrench@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Agree with this. Was experimenting on the similar lines on Friday.
Does show good improvements with sequential workload.
For random read/write workload, the user can use the default value.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

On Sun, Apr 25, 2021 at 10:20 PM Steve French <smfrench@gmail.com> wrote:
>
> Updated patch attached. It does seem to help - just tried an experiment
>
>       dd if=3D/mnt/test/1GBfile of=3D/dev/null bs=3D1M count=3D1024
>
> to the same server, same share and compared mounting with rasize=3D6MB
> vs. default (1MB to Azure)
>
> (rw,relatime,vers=3D3.1.1,cache=3Dstrict,username=3Dlinuxsmb3testsharesmc=
,uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3D20.150.70.104,file_mode=3D077=
7,dir_mode=3D0777,soft,persistenthandles,nounix,serverino,mapposix,mfsymlin=
ks,nostrictsync,rsize=3D1048576,wsize=3D1048576,bsize=3D1048576,echo_interv=
al=3D60,actimeo=3D1,multichannel,max_channels=3D2)
>
> Got 391 MB/s  with rasize=3D6MB, much faster than default (which ends up
> as 1MB with current code) of 163MB/s
>
>
>
>
>
>
> # dd if=3D/mnt/test/394.29520 of=3D/dev/null bs=3D1M count=3D1024 ; dd
> if=3D/mnt/scratch/394.29520 of=3D/mnt/test/junk1 bs=3D1M count=3D1024 ;dd
> if=3D/mnt/test/394.29520 of=3D/dev/null bs=3D1M count=3D1024 ; dd
> if=3D/mnt/scratch/394.29520 of=3D/mnt/test/junk1 bs=3D1M count=3D1024 ;
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.06764 s, 264 MB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB, 1.0 GiB) copied, 12.5912 s, 85.3 MB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB, 1.0 GiB) copied, 3.0573 s, 351 MB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB, 1.0 GiB) copied, 8.58283 s, 125 MB/s
>
> On Sat, Apr 24, 2021 at 9:36 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Yep - good catch.  It is missing part of my patch :(
> >
> > Ugh
> >
> > Will need to rerun and get real numbers
> >
> > On Sat, Apr 24, 2021 at 9:10 PM Matthew Wilcox <willy@infradead.org> wr=
ote:
> > >
> > > On Sat, Apr 24, 2021 at 02:27:11PM -0500, Steve French wrote:
> > > > Using the buildbot test systems, this resulted in an average improv=
ement
> > > > of 14% to the Windows server test target for the first 12 tests I
> > > > tried (no multichannel)
> > > > changing to 12MB rasize (read ahead size).   Similarly increasing t=
he
> > > > rasize to 12MB to Azure (this time with multichannel, 4 channels)
> > > > improved performance 37%
> > > >
> > > > Note that Ceph had already introduced a mount parameter "rasize" to
> > > > allow controlling this.  Add mount parameter "rasize" to cifs.ko to
> > > > allow control of read ahead (rasize defaults to 4MB which is typica=
lly
> > > > what it used to default to to the many servers whose rsize was that=
).
> > >
> > > I think something was missing from this patch -- I see you parse it a=
nd
> > > set it in the mount context, but I don't see where it then gets used =
to
> > > actually affect readahead.
> >
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



--=20
Regards,
Shyam
