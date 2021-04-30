Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37AEC433B4
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 12:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3B4261449
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 12:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhD3Myb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Apr 2021 08:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhD3Mya (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 30 Apr 2021 08:54:30 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B29C06174A
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 05:53:42 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id b131so7453387ybg.5
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 05:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+vbY2jhIUWbSpc79MaVcO8bYp8Le1FinWmV2pBUzBAs=;
        b=YdxV0EqQwD/gVvdxjGXNJ7FN3/yA0kVbPYvIDawaJetPV37UBAh06uZsg2KEE87Qmw
         N/syJ0H3/+awZbFaXyjRKlEGoIqhZE0izexQduIjZvvOyubTrbvHNd4pDYFwO54a0p9L
         Mg4wUON66Gm5iDS9ioaLk6fg8UN6CV/+Vvpc+D/n0/EZU0hIxZf4BODKQuz2SVYsUwb1
         EDxdJ18l0zXuKJjIC/nWHmMwlMloYfaZB8Nh/Nf7fCHD8Agrntw0k6dQz9G5mjHo7Z6D
         f++O/xeRXKZrWa6PCnmuoSzYklJf3Dnmp2YTlo5hG8UeBac/IKw6DGWC7wXRZBebsX4O
         j+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+vbY2jhIUWbSpc79MaVcO8bYp8Le1FinWmV2pBUzBAs=;
        b=uEDwYI8Gnj+Cvd4fEu6siAql6IIKKK+FEPBUctxzpzZYFneLPNZYM5xxA2mSxY8NJS
         XXYpsKCCAtA9CSQ7BiLv09+MoXOq8szdTd1aNL4spGDkuFZg/e2TUO5e3G7kUCvKpCDB
         uv8txeWyBEVL5vWJJ56pYidsOK4OR9Ne2UMCAromEuvNXaYpH1isWz0kaLWVyi/0EtWF
         Jxt0B/0uBOJUNy0E0IFVDBjFfZcIEY7fjLbT2Wcamn1OyiULo4kyST7wf0bbmEwpZ4GU
         UVuVF2qj39FB8Vdhf7kHUikAaZtO6WrDHgMzDnWqpPNTBWXDScSXRDJuLpykt+Jnb6J2
         fjYw==
X-Gm-Message-State: AOAM533q+gG0w+bd2cC3/nruFuz2yeP41JLFHFPHRiMgooEHXyIpz6x6
        Lh3A39fTxNBB1tZY/+XnU5EAq0aPtx1R6VKcr6E=
X-Google-Smtp-Source: ABdhPJwifZPIOrgVob0jxCzL4vq7a2exUMLXXPqPYUxQl5qSTZDVT+b9KlBcUuMM4iPCYNkztcaMsqBSGLI2eHQeIQI=
X-Received: by 2002:a05:6902:526:: with SMTP id y6mr6627291ybs.331.1619787221470;
 Fri, 30 Apr 2021 05:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org> <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
 <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com>
 <20210426115457.GJ235567@casper.infradead.org> <CANT5p=rHgmLdHJm_y3CCpb=KoEbnJApce2wx4hORY2CwHP2NbQ@mail.gmail.com>
 <20210430115948.GL1847222@casper.infradead.org>
In-Reply-To: <20210430115948.GL1847222@casper.infradead.org>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 30 Apr 2021 18:23:30 +0530
Message-ID: <CANT5p=rGKoXpsEfoNoFmp0LmRJx_2h27_u2EgjybEnAKWOu2Yw@mail.gmail.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I feel this is not just a problem with cifs. Any filesystem
(particularly network filesystems involving higher latency I/O to
fetch data from the server) will have issues coping up with a large
number of small random reads.
My point here is that if all reads to the server were of a minimum
"chunk" size (a contiguous range of pages), page cache could be
populated in chunks. Any future read to other pages in the chunk could
be satisfied from the page cache, thereby improving the overall
performance for similar workloads.

Regards,
Shyam

On Fri, Apr 30, 2021 at 5:30 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Apr 30, 2021 at 04:19:27PM +0530, Shyam Prasad N wrote:
> > Although ideally, I feel that we (cifs.ko) should be able to read in
> > larger granular "chunks" even for small reads, in expectation that
> > surrounding offsets will be read soon.
>
> Why?  How is CIFS special and different from every other filesystem that
> means you know what the access pattern of userspace is going to be better
> than the generic VFS?
>
> There are definitely shortcomings in the readahead code that should
> be addressed, but in almost no circumstances is "read bigger chunks"
> the right answer.



-- 
Regards,
Shyam
