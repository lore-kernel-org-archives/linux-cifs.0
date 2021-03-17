Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28199C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 02:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1BE664F96
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 02:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCQCfm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Mar 2021 22:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhCQCfi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Mar 2021 22:35:38 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC08C06174A
        for <linux-cifs@vger.kernel.org>; Tue, 16 Mar 2021 19:35:37 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u4so701286lfs.0
        for <linux-cifs@vger.kernel.org>; Tue, 16 Mar 2021 19:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GvkSjbOflTYrrhQW/IujV+Vj77yNYWLHdlNlegrHH4E=;
        b=ASGp57d2AB3YJwzE0HztUK7znMoqHLdCpnr808cyahGXOlRg55T2zYUWxFwELsX85a
         rS35PH4RkUyQRe4gbJq52No3U0lb3SmDBGMBrHHk9qd67i95PxSvEvT+Mngdku3IDOLo
         nnwpKbepa9C5Dlkm18/FC8Ew/qk9tKjgUsJpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GvkSjbOflTYrrhQW/IujV+Vj77yNYWLHdlNlegrHH4E=;
        b=s4jKpmmxRt+IGO3O/GvuQCd4RbEs+aG+Wtg9Ir3JzkrmbUyoL/pe2b8hHoTOrPmsdY
         GYXwJxVKMHFmxADrRfcorvkdPFwPkq8wHblwyjIcyBHckd2VPLxfG+oK+IbDaxH5ylCc
         OiMKabXsGJNXeKDwOxCMP3096LCBDCmMMvqoLVS5+7SoKzr6XhRymUBKx8JrJ9EpUl+6
         N5FD3NhmI0U+p+7PQWH0u1jR5EEVXmQ49Nx7DfW3X33ZJ5aFfGX2sHb0z07d46fw1zZe
         c/8/nwFNbr8zOHl1QDJeV6JGydl71ww0MW2qqqdXk1jq998dkfnsquBDCiPrZ2FRbpu5
         PY6g==
X-Gm-Message-State: AOAM530xGEQGie6EnfgUUJXezmhzbBoEz0x6Q9TFb5173s67nRjBI6j4
        RlpId9l7gJg0GToH8KoGtZyd5vOQGO6C/A==
X-Google-Smtp-Source: ABdhPJzBLKAYWfa6zeUSNfQCsTCCdTZxuMu3yKY8WMSJ8+37czJJ9TQkvMiEUa3g1DbMBspAc4HuJg==
X-Received: by 2002:ac2:5509:: with SMTP id j9mr982385lfk.302.1615948535583;
        Tue, 16 Mar 2021 19:35:35 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id q3sm3017786ljp.98.2021.03.16.19.35.33
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 19:35:34 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id e7so688512lft.2
        for <linux-cifs@vger.kernel.org>; Tue, 16 Mar 2021 19:35:33 -0700 (PDT)
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr922688lfu.41.1615948533286;
 Tue, 16 Mar 2021 19:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <161539526152.286939.8589700175877370401.stgit@warthog.procyon.org.uk>
 <161539528910.286939.1252328699383291173.stgit@warthog.procyon.org.uk>
 <20210316190707.GD3420@casper.infradead.org> <CAHk-=wjSGsRj7xwhSMQ6dAQiz53xA39pOG+XA_WeTgwBBu4uqg@mail.gmail.com>
 <887b9eb7-2764-3659-d0bf-6a034a031618@toxicpanda.com>
In-Reply-To: <887b9eb7-2764-3659-d0bf-6a034a031618@toxicpanda.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 16 Mar 2021 19:35:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=whWoJhGeMn85LOh9FX-5d2-Upzmv1m2ZmYxvD31TKpUTA@mail.gmail.com>
Message-ID: <CAHk-=whWoJhGeMn85LOh9FX-5d2-Upzmv1m2ZmYxvD31TKpUTA@mail.gmail.com>
Subject: Re: [PATCH v4 02/28] mm: Add an unlock function for PG_private_2/PG_fscache
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linux-MM <linux-mm@kvack.org>, linux-cachefs@redhat.com,
        linux-afs@lists.infradead.org,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 16, 2021 at 7:12 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
>
> Yeah it's just a flag, we use it to tell that the page is part of a range that
> has been allocated for IO.  The lifetime of the page is independent of the page,
> but is generally either dirty or under writeback, so either it goes through
> truncate and we clear PagePrivate2 there, or it actually goes through IO and is
> cleared before we drop the page in our endio.

Ok, that's what it looked like from my very limited "looking at a
couple of grep cases", but I didn't go any further than that.

> We _always_ have PG_private set on the page as long as we own it, and
> PG_private_2 is only set in this IO related context, so we're safe
> there because of the rules around PG_dirty/PG_writeback. We don't need
> it to have an extra ref for it being set.

Perfect. That means that at least as far as btrfs is concerned, we
could trivially remove PG_private_2 from that page_has_private() math
- you'd always see the same result anyway, exactly because you have
PG_private set.

And as far as I can tell, fscache doesn't want that PG_private_2 bit
to interact with the random VM lifetime or migration rules either, and
should rely entirely on the page count. David?

There's actually a fair number of page_has_private() users, so we'd
better make sure that's the case. But it's simplified by this but
really only being used by btrfs (which doesn't care) and fscache, so
this cleanup would basically be entirely up to the whole fscache
series.

Hmm? Objections?

            Linus
