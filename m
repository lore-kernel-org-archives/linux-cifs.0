Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE66EC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Jul 2022 03:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbiGSD4j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Jul 2022 23:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiGSD4j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Jul 2022 23:56:39 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963312AC5D
        for <linux-cifs@vger.kernel.org>; Mon, 18 Jul 2022 20:56:38 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id 94so816081uau.8
        for <linux-cifs@vger.kernel.org>; Mon, 18 Jul 2022 20:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G6vm9VhEQECVzCHJ5bvtM3Etmi/GIEoN7gVN+t1KeLk=;
        b=BJ/lPyKzs65eG17qwdzg3U06qjhoJdgZtAElS6XyAeR97KpMara22C3PmrKLEYVgmw
         2gdPW0yDhlQ/vSmv2hcTliANbZ4kQBs6iwWFOWSUJBUF8WojiMGp/3bdF3Eu+etQrLXv
         f8ohe7SFKlXXeIDZIUy5+R6Ef3+PB9pGD7kLFK0KvIm9TdPEpui2vBFAQfdw0zxjyUNb
         vY1wtdvWXqYxzOqlSKBhrXxdNDx5w6iYuVH4PerDPKkmgCq34nKOydml4/YSkq/I03Tf
         128jMyNqYRJp+C5LcQFA3beaGXw0RIjypl1TPbncjr2D9FS70Bv+WZazXYL/+NrcQPbJ
         /F7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G6vm9VhEQECVzCHJ5bvtM3Etmi/GIEoN7gVN+t1KeLk=;
        b=LW7WyM3y8jYTLLH81OtOMWk6zoxiy3ldC61dMFVUuVyX7a5R3c0x+2T9QkazFkruAh
         xJ55NokpJZcToIPcvL8ya6/MDiDvy3b0B1p/404xlDrHj0+EPmrsBCv1vGRandhYlbFc
         OUvPLVCiv6jXJrP3FTyVDzNNrAAUGmvSqDh0VQZTYxy6XdZ2zl866qFLS7laJPAmKxls
         Wovro5oHCYWT1oJR42a97oCbB6HIGC0U+GJfl5stPzyqxaXZkvvtDq7uD8d2q8i0AwuK
         xLR+8xi45xoy2iU3KsvqxpJU10C+1NQm8lHGj3keeTNP3yKkzbMMOxpCfiubAFLCf/wD
         Y7Sw==
X-Gm-Message-State: AJIora8IkcaeQYDvbami5CRqZjbaPf0xpO5mCwE/clZsowsA0v6eNLya
        aG6yc0iEW0Jtt4kNeAiNHzl8eUR6e4Qn/L7XY6Y=
X-Google-Smtp-Source: AGRyM1sLSORz/v6WRCbeJBp4yV6zuPEdwe1Zp1utkzYchs0BqQN7SfxYMo8IYlhuqydIDJMgIDh6cFO85Sa2jj7Cyvw=
X-Received: by 2002:ab0:3f0c:0:b0:383:f357:9c02 with SMTP id
 bt12-20020ab03f0c000000b00383f3579c02mr3240866uab.19.1658202997491; Mon, 18
 Jul 2022 20:56:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220718190624.3087569-1-willy@infradead.org>
In-Reply-To: <20220718190624.3087569-1-willy@infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 18 Jul 2022 22:56:26 -0500
Message-ID: <CAH2r5mtS8sWvygbYHTrE39rRH1eurqqogBNYefWcbsjOSHDxAQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix memory leak when using fscache
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Mon, Jul 18, 2022 at 2:07 PM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> If we hit the 'index == next_cached' case, we leak a refcount on the
> struct page.  Fix this by using readahead_folio() which takes care of
> the refcount for you.
>
> Fixes: 0174ee9947bd ("cifs: Implement cache I/O by accessing the cache directly")
> Cc: David Howells <dhowells@redhat.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/cifs/file.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index e64cda7a7610..6985710e14c2 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -4459,10 +4459,10 @@ static void cifs_readahead(struct readahead_control *ractl)
>                                  * TODO: Send a whole batch of pages to be read
>                                  * by the cache.
>                                  */
> -                               page = readahead_page(ractl);
> -                               last_batch_size = 1 << thp_order(page);
> +                               struct folio *folio = readahead_folio(ractl);
> +                               last_batch_size = folio_nr_pages(folio);
>                                 if (cifs_readpage_from_fscache(ractl->mapping->host,
> -                                                              page) < 0) {
> +                                                              &folio->page) < 0) {
>                                         /*
>                                          * TODO: Deal with cache read failure
>                                          * here, but for the moment, delegate
> @@ -4470,7 +4470,7 @@ static void cifs_readahead(struct readahead_control *ractl)
>                                          */
>                                         caching = false;
>                                 }
> -                               unlock_page(page);
> +                               folio_unlock(folio);
>                                 next_cached++;
>                                 cache_nr_pages--;
>                                 if (cache_nr_pages == 0)
> --
> 2.35.1
>


-- 
Thanks,

Steve
