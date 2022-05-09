Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720F1C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  9 May 2022 23:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiEIXjQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 May 2022 19:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbiEIXhx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 May 2022 19:37:53 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFD422B3BD
        for <linux-cifs@vger.kernel.org>; Mon,  9 May 2022 16:33:24 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i11so5732358ybq.9
        for <linux-cifs@vger.kernel.org>; Mon, 09 May 2022 16:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nJ705cFGeJ3ke+5mkUPrPEewNX7yrE75qmvJ2KVZf0s=;
        b=Id8h4Jfxx0Tato37+T4c7FtNNZZsIGQix+P7tghZfeFEHS0wq3U2saCP062iKezOQ7
         u0rU2pF5eBaMpyMu/cDssJ8mnBmYCWlKS6x2WZPuE+6PInlY5x0dh7xm0snWUn2h1oEb
         +0Q7pOpBmaBSseT1iiGdAQxG3rzLX6Yv9WGScr49O7sFREK1aPSMJTruGw8Xx1PUbCPj
         v9meUF82HjiUrL39SKas/T03J5BlEDKk2UTy+chZCyFz9i+0or0tytACDCHWfIv/zdMm
         Gr7B4wGje2R3hUWch1r/WUWpXX3oQL6s2xAro61cCVgJOf9xA3mEWjmQHWL8uu1yYplk
         h3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nJ705cFGeJ3ke+5mkUPrPEewNX7yrE75qmvJ2KVZf0s=;
        b=7yIUZ12D17k3grJptnWMqGtlL2RRQsUnVlSpuOZUB///otDazeiAiaaeqUT5diDkpd
         XFHjSisEuaVqAwmbvXV2SgUzVps+p0RtwlqnQlukKiTpmdH+JTN1amI/tHBMvmPFIcLQ
         n9BDdk1A9xtjG+AeFwhEfPy6RwciCz1X+3290pGWmY6eqpCW1IB7U+d+ZsoWTP3d8omP
         +8hmMn10980/brxCgrkUe3z3LnspLfRyXb3VDsTNxCdsqDt2PxgvXRS493qpNxvytOXC
         TCdOX0pddYkHXqkhp9KJFQJ7c9D47lkjuvx/xpGRu6gIDvduBm+VgWjCwN4JWuQNgeYg
         869A==
X-Gm-Message-State: AOAM531Lg73TC9Ph4u/MlZCc/+JekfwN5Fh8yikwujoqBX0v6YkVMrYj
        KoFUK3JHsO4yk7ZsG2keKsWY8zEjJd2NYlVo9aQ=
X-Google-Smtp-Source: ABdhPJz/e3egqCbCacf/2s7SXDdiT7qVUZzwzLAkBPenhuOf2a2o0iGFrC2ZngESbSJwUQpRGCVjQcayhwtt3N8kIaU=
X-Received: by 2002:a05:6902:709:b0:64a:99b:3594 with SMTP id
 k9-20020a056902070900b0064a099b3594mr16133992ybt.493.1652139204034; Mon, 09
 May 2022 16:33:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220504014407.2301906-1-lsahlber@redhat.com> <20220504014407.2301906-2-lsahlber@redhat.com>
 <20220504165430.xptspu37vmhwwesj@cyberdelia>
In-Reply-To: <20220504165430.xptspu37vmhwwesj@cyberdelia>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 10 May 2022 09:33:12 +1000
Message-ID: <CAN05THTE3ZZzUhL6tqzy_bs0RLLnLxmG9HK8Sx3uQSkg6yTJQA@mail.gmail.com>
Subject: Re: [PATCH] cifs: cache dirent names for cached directories
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 6 May 2022 at 16:21, Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 05/04, Ronnie Sahlberg wrote:
> >+struct cached_dirents {
> >+      bool is_valid:1;
> >+      bool is_failed:1;
>
> Does it make sense to have both? Do you expect a situation where
> is_valid && is_failed happens? From the patch, I don't see such case and
> the code could be adjusted to use !is_valid where appropriate.
> But let me know if I missed something.

The reason to have both is to handle cases where we fail populating
the cache partway through readdir.

The idea is that is_valid is set once we have fully populated the
cache successfully
and is_failed is set on failure during the population of the cache and
once it is set there is no point in even trying to add new entries to
the cache.

>
> This is just a cosmetic nitpick, but other than that,
>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>
>
> Cheers,
>
> Enzo
