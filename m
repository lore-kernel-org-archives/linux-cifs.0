Return-Path: <SRS0=ZOHs=XF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B59C3A5A2
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 09:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79A9A20872
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 09:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="utNmMpJ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389294AbfIJJTS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Sep 2019 05:19:18 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:33939 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbfIJJTR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Sep 2019 05:19:17 -0400
Received: by mail-io1-f51.google.com with SMTP id k13so20639832ioj.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Sep 2019 02:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FLSH+s3I1EjuRyWzmaf5krWguVxQOdOr9FFToFUKS0U=;
        b=utNmMpJ4VB7VGYKfV7uyZvjahve502gtTAQ514WsAbhOKf5NjYPC8yTlxwEnLX5mjU
         SEAryeZ1hKG0HYOmv/abGeZrq10blJJQsA1TyJ6BkM8vSkpaHewFfarbpuTXJuS/0Rgk
         YvS7lUFSCXpaKQoQUftjd8brABaHcghfmiBmUxaMEbMBnqggTWlGnqkhk7knlcFwkvy8
         T/zjmnRoLiTcoWAh9Yi81JStyd3RSeOv5UpSyt/uKl+vcd75b14CyHqUIRsN16Nlz7j/
         VCnVahLNnSGQExpGLiR0CbnjpBxmHN1OC/xDce0c+42rHKEts17jLNuDv2P0uncIbUfj
         UuxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FLSH+s3I1EjuRyWzmaf5krWguVxQOdOr9FFToFUKS0U=;
        b=WyFY34JvA/LA2qgWKdhOGXd9oCBa4O/e88kGeMsiuTbllH5SOihEbpzM+DGtA/XaWg
         NHNrAuI+it9PAjTEN+NRY4zo9p61yPxRlCEh69vEd4LMzWp64Y8CtjSqZ31VdA6Y9PdK
         IRd863D0S7fYVx9oXoQ6wjGPi38URzVW6wdM2rwYxTUz+LG731VNvUQkx1CQnJVWBwtf
         mQ8qb3YpzedRTBZaQiO3T6RyGGT9c8+Hhrdtrf++I4d+UIiLd1Y73lBybY5iLAw2N790
         66QvNEdAyREQv+MYijAK34bcbaHDlZbcDT0bE/5M7I72klTMRVc7Q+wx1L9UJpV/72gf
         zIEQ==
X-Gm-Message-State: APjAAAVZBaM7A/40hLey9W4GlYD/i9IYLuk5W0zVi8QXouIDT2IegP25
        95slO27RcEqlx6aPkVFoGuW+YXAEX0DjMB7ZRtg=
X-Google-Smtp-Source: APXvYqz5vq/WSdEy20ox0jWzi5PdZC4USpVsflzfhX7kFAxlii23mTG5DOqYe4BmhWiVT+BIU6K7cqeXPfXlVdlzWZ4=
X-Received: by 2002:a6b:4404:: with SMTP id r4mr22556736ioa.159.1568107156750;
 Tue, 10 Sep 2019 02:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msbRyGMY2XQifbxB0iU3a3EPp8UcemO8QE5bhq9HPMqBQ@mail.gmail.com>
 <CAH2r5mv=6dR+5nxJbw19C0QZf3wJQOc5j4CTGTZ=OABqMdQDpw@mail.gmail.com>
In-Reply-To: <CAH2r5mv=6dR+5nxJbw19C0QZf3wJQOc5j4CTGTZ=OABqMdQDpw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 10 Sep 2019 19:19:05 +1000
Message-ID: <CAN05THQxtGKMfO6aRELK5fsc-x1m+u0fCCsNmRYaoFQHa_v86A@mail.gmail.com>
Subject: Re: [SMB3][PATCHes] parallelizing decryption of large read responses
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>


We have now a decently large number of new mount options so we need a
patch to the manpage.
That said, we should also make sure that we try to set reasonable
values by default,
or even longer term, remove the options with heuristics.

(Very very few people read the manpage or ever use any of these mount options
so our default should be "as close to optimal as possible" and using a
mount option
should be the rare exception where our heuristics just went wrong.)

On Tue, Sep 10, 2019 at 12:21 AM Steve French <smfrench@gmail.com> wrote:
>
> Had a minor typo in patch 2 - fixed in attached
>
> On Sun, Sep 8, 2019 at 11:31 PM Steve French <smfrench@gmail.com> wrote:
> >
> > I am seeing very good performance benefit from offload of decryption
> > of encrypted SMB3 read responses to a pool of worker threads
> > (optionally).  See attached patches.
> >
> > I plan to add another patch to only offload when number of requests in
> > flight is > 1 (since there is no point offloading and doing a thread
> > switch if no other responses would overlap in the cifsd thread reading
> > from the socket).
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
