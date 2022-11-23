Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7201C4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Nov 2022 20:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239880AbiKWUbT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239804AbiKWUbD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Nov 2022 15:31:03 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0206FB972B
        for <linux-cifs@vger.kernel.org>; Wed, 23 Nov 2022 12:26:16 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id d7so13276062qkk.3
        for <linux-cifs@vger.kernel.org>; Wed, 23 Nov 2022 12:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CqmvkkESPfhDMe/qDmW4BJUOiTicPIv5an9zs8Gyv18=;
        b=H05YjYlWatbzx/wYDWLZlWtlE1KBwjnnlgWrAS57YeODNFQbfnbqnkGjrw+7lnDaor
         oScBBYPzE4yA/do2o0oXxJV/7PAgcLDU8MGXopXi7Hyz2CY8RYXjIOxuZIHXCxSyrV4d
         4jeZ+ngrXKdb0oQJMIfkShcljtHyJ8LXyw7yk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CqmvkkESPfhDMe/qDmW4BJUOiTicPIv5an9zs8Gyv18=;
        b=LU3S1Dt/G+hG+/sMgOKA+E/kki567sE+4MQPifJe+mm/ToJRXJUiS3M70n1Dwt5RI+
         Ta3a5AlL+UE2bLohLu888wSiASKnI72xwz9mBalMNQiNtVX/YVhy9UeuQ7fbcbmIVmyl
         hL7HUrcrjBbax64WvF67XRDl1myQKLRlFM5Q16+FOwpjzRhTTzGjxf3atDSfJRvuV+zT
         947jIzgc2BkfH0zT7dEkwBwU6J6kwCElJlZgy2OPkckX5buNbSdlzNrwvMZdWCngpODd
         zlOaxLrCblopnH2iMBaCECltcz2sV5qJH4gh+d+jHgo4lscMY5bG3EJRuY7PhGq1ioUW
         BQzw==
X-Gm-Message-State: ANoB5pmvwTa2tOtPy9jmb1F+fVsvNxP+kxcvDPiM2jYtQb/wFvRAti64
        gmm6Q7dZwXn5+vONhW0OuCGH0e9yfd081w==
X-Google-Smtp-Source: AA0mqf6fwUpuMEIkpmjiMepuCdCyD7QS3z55XUtOoQvi3cYkjP+0QrKr+IjNMcc7py7hXihLQXO8xQ==
X-Received: by 2002:a37:88c7:0:b0:6ec:537f:3d94 with SMTP id k190-20020a3788c7000000b006ec537f3d94mr9898964qkd.376.1669235174208;
        Wed, 23 Nov 2022 12:26:14 -0800 (PST)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com. [209.85.219.48])
        by smtp.gmail.com with ESMTPSA id bq30-20020a05620a469e00b006ef1a8f1b81sm12843218qkb.5.2022.11.23.12.26.12
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 12:26:13 -0800 (PST)
Received: by mail-qv1-f48.google.com with SMTP id p12so1466510qvu.5
        for <linux-cifs@vger.kernel.org>; Wed, 23 Nov 2022 12:26:12 -0800 (PST)
X-Received: by 2002:ad4:4101:0:b0:4b1:856b:4277 with SMTP id
 i1-20020ad44101000000b004b1856b4277mr10112261qvp.129.1669235172559; Wed, 23
 Nov 2022 12:26:12 -0800 (PST)
MIME-Version: 1.0
References: <1459152.1669208550@warthog.procyon.org.uk> <CAHk-=wghJtq-952e_8jd=vtV68y_HsDJ8=e0=C3-AsU2WL-8YA@mail.gmail.com>
 <1619343.1669233783@warthog.procyon.org.uk>
In-Reply-To: <1619343.1669233783@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Nov 2022 12:25:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=whJBOAOqB8wWxeAtKy3b9r4rn2Y48+zsuDDhKJ3D3D4cw@mail.gmail.com>
Message-ID: <CAHk-=whJBOAOqB8wWxeAtKy3b9r4rn2Y48+zsuDDhKJ3D3D4cw@mail.gmail.com>
Subject: Re: [PATCH v3] mm, netfs, fscache: Stop read optimisation when folio
 removed from pagecache
To:     David Howells <dhowells@redhat.com>
Cc:     willy@infradead.org, dwysocha@redhat.com,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>, linux-cachefs@redhat.com,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 23, 2022 at 12:03 PM David Howells <dhowells@redhat.com> wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> > But I also think it's strange in another way, with that odd placement of
> >
> >         mapping_clear_release_always(inode->i_mapping);
> >
> > at inode eviction time. That just feels very random.
>
> I was under the impression that a warning got splashed if unexpected
> address_space flags were set when ->evict_inode() returned.  I may be thinking
> of page flags.  If it doesn't, fine, this isn't required.

I don't know if the warning happens or not, but the thing I reacted to
was just how *random* this was. There was no logic to it, nor any
explanation.

I *suspect* that if we add this kind of new generic address space
flag, then that flag should just be cleared by generic code when the
address space is released.

But I'm not saying it has to be done that way - I'm just saying that
however it is done, please don't make it this random mess with no
explanation.

The *setting* of the flag was at least fairly obvious. I didn't find
code like this odd:

+       if (v9inode->netfs.cache)
+               mapping_set_release_always(inode->i_mapping);

and it makes all kinds of sense (ie I can read it as a "if I use netfs
caching for this inode, then I want to be informed when a folio is
released from this mapping").

It's just the clearing that looked very random to me.

Maybe just a comment would have helped, but I get the feeling that it
migth as well just be cleared in "clear_inode()" or something like
that.

> > That code makes no sense what-so-ever. Why isn't it using
> > "folio_has_private()"?
>
> It should be, yes.
>
> > Why is this done as an open-coded - and *badly* so - version of
> > !folio_needs_release() that you for some reason made private to mm/vmscan.c?
>
> Yeah, in retrospect, I should have put that in mm/internal.h.

So if folio_needs_release() is in mm/internal.h, and then mm/filemap.c
uses it in filemap_release_folio() instead of the odd open-coding, I
think that would clear up my worries about both mm/filemap.c and
mm/vmscan.c.

                Linus
