Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B422C433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Oct 2021 18:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B2BB60FC1
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Oct 2021 18:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhJ2SUt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Oct 2021 14:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhJ2SUt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Oct 2021 14:20:49 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12602C061766
        for <linux-cifs@vger.kernel.org>; Fri, 29 Oct 2021 11:18:20 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id s19so18143899ljj.11
        for <linux-cifs@vger.kernel.org>; Fri, 29 Oct 2021 11:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YR8MaXQV2dAoTf7veoG8XVBeAhgdgomPxezXzaQONmo=;
        b=HVDkvGeodIU22X5kjbO7ZR0lTCWWwkScN+820L1CO6Jp/wFHT2URTkNHboM7IjptmB
         YVg/RfMSjgzCpZAxQHFmCUZlYnl5lVQQW/xElvUR6baO9Q4c6uG+lfqCGqGH4kKGh1KE
         qArq9uCu2p9WrvPFJV+b6G0oeDLEt/s/4EqMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YR8MaXQV2dAoTf7veoG8XVBeAhgdgomPxezXzaQONmo=;
        b=FoNRiS5e3skkgeslUY4orh9gIhZgLL7oNgzEfKzovw37jnx8Y8EjL70AwzUN+yyp30
         tFddO/JHIbSN0WxoD7VAQz1qpRdZ6/Z/wOkUFMQ/dIViVQkHhPrlsA+GrdcLg53m1Z8G
         /1drEL2rk/X3CpW14wDXrGSithg5F1KQJYdHMK3jFDCm+HHZhB8jurZCC+wwkZ7tE9RI
         hT7ZOc5gxpHBV2m0h/PiuE1xpdz3QNkutu4ewCDxqSlT4UpssM4rmDlHnR6gYYLy61G/
         368x79q6OBP/hsw8hcZv09Cw9WnKX+Ul8H4R+thtdL5pvpBo8MJnuiOHzCXl683DLQil
         Ft+Q==
X-Gm-Message-State: AOAM533w0Sqxrqv/MXh1gv9pFIa2jZUnhXzoEEWsiOvTy2ucw4lYdCT6
        x69qY0rbsoKEfOLlBN3+b5We7UVYwpBQcB1vKVg=
X-Google-Smtp-Source: ABdhPJzSlgcLattJXiymG3AfCX26dV67YLUpkaWc50PGx2NCGJJrwMGyqB+aKnrsxUttwHoH7n7w6A==
X-Received: by 2002:a2e:bf12:: with SMTP id c18mr13838801ljr.462.1635531497016;
        Fri, 29 Oct 2021 11:18:17 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id e12sm680756ljp.30.2021.10.29.11.18.15
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 11:18:16 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id u5so18190361ljo.8
        for <linux-cifs@vger.kernel.org>; Fri, 29 Oct 2021 11:18:15 -0700 (PDT)
X-Received: by 2002:a05:651c:17a6:: with SMTP id bn38mr12949536ljb.56.1635531495482;
 Fri, 29 Oct 2021 11:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <163551653404.1877519.12363794970541005441.stgit@warthog.procyon.org.uk>
 <CAHk-=wiy4KNREEqvd10Ku8VVSY1Lb=fxTA1TzGmqnLaHM3gdTg@mail.gmail.com> <1889041.1635530124@warthog.procyon.org.uk>
In-Reply-To: <1889041.1635530124@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 29 Oct 2021 11:17:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg_C6V_S+Aox5Fn7MuFe13ADiRVnh6UcvY4WX9JjXn3dg@mail.gmail.com>
Message-ID: <CAHk-=wg_C6V_S+Aox5Fn7MuFe13ADiRVnh6UcvY4WX9JjXn3dg@mail.gmail.com>
Subject: Re: [PATCH v4 00/10] fscache: Replace and remove old I/O API
To:     David Howells <dhowells@redhat.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        v9fs-developer@lists.sourceforge.net,
        CIFS <linux-cifs@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        linux-cachefs@redhat.com, Dave Wysochanski <dwysocha@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 29, 2021 at 10:55 AM David Howells <dhowells@redhat.com> wrote:
>
> This means bisection is of limited value and why I'm looking at a 'flag day'.

So I'm kind of resigned to that by now, I just wanted to again clarify
that the rest of my comments are about "if we have to deal with a flag
dat anyway, then make it as simple and straightforward as possible,
rather than adding extra steps that are only noise".

> [ Snip explanation of netfslib ]
> This particular patchset is intended to enable removal of the old I/O routines
> by changing nfs and cifs to use a "fallback" method to use the new kiocb-using
> API and thus allow me to get on with the rest of it.

Ok, at least that explains that part.

But:

> However, if you would rather I just removed all of fscache and (most of[*])
> cachefiles, that I can do.

I assume and think that if you just do that part first, then the
"convert to netfslib" of afs and ceph at that later stage will mean
that the fallback code will never be needed?

So I would much prefer that streamlined model over one that adds that
temporary intermediate stage only for it to be deleted.

             Linus
