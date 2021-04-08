Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474D3C433B4
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 23:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17C9761151
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 23:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhDHX5l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 19:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDHX5k (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 19:57:40 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184ABC061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 16:57:28 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l4so5798883ejc.10
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 16:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XLF2Hy47tG/NhXLeWFJjwjLlXpGjFs6Bt2Vh546exGI=;
        b=U1nu8PCKZ2rC+hNkH/1FtHr0pHi1eBFqU8nKatafLTnVUf8YWjf3+Y9lxaTCmPnC6N
         1maOTah5U5Ugwluf4SbyJDC0T/VIm4gmhPdxCSV5suWLxAoQA6cU1UWIC534ya5fYLAp
         8IzK2dToo8y36YbKoGVCbAg0EPiSom+ZJL01Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XLF2Hy47tG/NhXLeWFJjwjLlXpGjFs6Bt2Vh546exGI=;
        b=m1HA7zzZOrL1tFbgMp+5xa9U6kX201HqSx5INoS7QaWRQDQkajjvdvDRsCHmgs62cH
         ukaxRdt/GBuxJ8r3eL0+xqKcPQ1U4Cd0ROtnE3gJlGkNTnwTnDETYTY1opCXKRor8k9n
         Jj0zWP6umT1j8PlnKxcNwI+Cc31OAsBbud/NsiXGkW2uBgKc9jKYW8aiUHfA9zJ7hajW
         Oo+Pdyhu5ZxMY2qfRt3s7bA9pyES11TqXhI8+WbTzneRO8igZQuNCbJxJRwL/I7x3jiP
         WGWO6t/7fCwQoencxnEAlKndIVbVRKKiJ280vojptPyybRc11/NBAmb3FsUJHNV4HCw1
         Qu2A==
X-Gm-Message-State: AOAM533NvIjEGGjqlhfZQZCKSoKNBKe2fjqqwnznDzbvKLeQh9YveovP
        awrIQ79sZj3fb4DdCgeNJwpeCXJl54ZwH+5a
X-Google-Smtp-Source: ABdhPJxNMRful4ecMXzbS6DFy7itRAUvnPEXp4vxQtX4e4r8H6s/2LxMFSV6NkGewD72AdGcyi8TkQ==
X-Received: by 2002:a17:906:a0c2:: with SMTP id bh2mr13183038ejb.394.1617926246684;
        Thu, 08 Apr 2021 16:57:26 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id ju23sm408608ejc.17.2021.04.08.16.57.26
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 16:57:26 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id z1so4427211edb.8
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 16:57:26 -0700 (PDT)
X-Received: by 2002:ac2:5974:: with SMTP id h20mr5012619lfp.40.1617925853980;
 Thu, 08 Apr 2021 16:50:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210408145057.GN2531743@casper.infradead.org>
 <161789062190.6155.12711584466338493050.stgit@warthog.procyon.org.uk>
 <161789066013.6155.9816857201817288382.stgit@warthog.procyon.org.uk>
 <46017.1617897451@warthog.procyon.org.uk> <136646.1617916529@warthog.procyon.org.uk>
In-Reply-To: <136646.1617916529@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 8 Apr 2021 16:50:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi_XrtTanTwoKs0jwnjhSvwpMYVDJ477VtjvvTXRjm5wQ@mail.gmail.com>
Message-ID: <CAHk-=wi_XrtTanTwoKs0jwnjhSvwpMYVDJ477VtjvvTXRjm5wQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: Split page_has_private() in two to better handle PG_private_2
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Apr 8, 2021 at 2:15 PM David Howells <dhowells@redhat.com> wrote:
>
> mm: Split page_has_private() in two to better handle PG_private_2

From a look through the patch and some (limited) thinking about it, I
like the patch. I think it clarifies the two very different cases, and
makes it clear that one is about that page cleanup, and the other is
about the magical reference counting. The two are separate issues,
even if for PG_private both happen to be true.

So this seems sane to me.

That said, I had a couple of reactions:

> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 04a34c08e0a6..04cb440ce06e 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -832,14 +832,27 @@ static inline void ClearPageSlabPfmemalloc(struct page *page)
>
>  #define PAGE_FLAGS_PRIVATE                             \
>         (1UL << PG_private | 1UL << PG_private_2)

I think this should be re-named to be PAGE_FLAGS_CLEANUP, because I
don't think it makes any other sense to "combine" the two PG_private*
bits any more. No?

> +static inline int page_private_count(struct page *page)
> +{
> +       return test_bit(PG_private, &page->flags) ? 1 : 0;
> +}

Why is this open-coding the bit test, rather than just doing

        return PagePrivate(page) ? 1 : 0;

instead? In fact, since test_bit() _should_ return a 'bool', I think even just

        return PagePrivate(page);

should work and give the same result, but I could imagine that some
architecture version of "test_bit()" might return some other non-zero
value (although honestly, I think that should be fixed if so).

                Linus
