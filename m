Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD3DC4320A
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Aug 2021 05:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAE8461042
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Aug 2021 05:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhHTF7l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Aug 2021 01:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbhHTF7k (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Aug 2021 01:59:40 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F795C061575;
        Thu, 19 Aug 2021 22:59:03 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id y6so15474992lje.2;
        Thu, 19 Aug 2021 22:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=48Hb/Qgy2m5wWev5VsfncYKR1cJzadSWEDW/hiW1JKE=;
        b=uU6/WcBRyLDu0UTuJ8Px/JqtCnevMORcSNmDk1Xqt0LVStFW3tSw6p+WwlTt7j48Wk
         hlJ6rviDndHRe9M8CyNHjlCDqvPtc3wsKEaDKi4lcmDG02yRpq6QgDrVo41ApjAYeNuw
         CV5jcXpcEBBy9Zf7ilQd7SqCEHtOjD82AkPGc9fN8EdAnhf3z8rmoxfwo+h6Sf+r26kU
         DUaCMI7TACT7qoWCB3+6xDBE/p3ty5dIkel8Vm+WWENUNrzFlxRGgILdfMx69jYjn3I7
         FvcOmHHMFA6+uHEopjdtF86P0Um69G3GtgJCW9ZTRFwzFEr4Ga0UgwaUZy4TK4GdDi2+
         PtTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=48Hb/Qgy2m5wWev5VsfncYKR1cJzadSWEDW/hiW1JKE=;
        b=bY5inNMA6qG1ml7oE5iN0j7ujiwTop68u35OUVFipGQHPCSYitQ9ovx94kv/Ka3438
         R+45f2bQ3vCqR8p+dkjy5e7db0cKQEnIf/ibUyIkIVjECDCfMFjvCTLxZTJEANsfS7LD
         L/P4sk4nrRlQuLd+NdsqMZrO+SiOjKVhft1Hh66M2y9lN9vsHqvbOi8NmTP3bwph+j9j
         bOUmB+K/j4JvHYEdthwdSkGtMzkukIXkT1KPKqotIqa5O9+HX7l/UVaZZjvUymdKdAO4
         vwKxj99G4ApvpVtAdfZfGeOE+4UdJKb6+k2OhxFpKVmpwbeibrcWB69llEw8vUxchZEL
         WZXg==
X-Gm-Message-State: AOAM531bt1Df84bFif7/1dmHsxAOBe4pXBKxnAApJNNmFGWoFvkNfbTR
        C3w20hLdrahsSUqX1fQdxzvvfFusc5RhApc2O1s=
X-Google-Smtp-Source: ABdhPJxJFkEicXBCXcmKO2Qb4x3gTqTvh9KLsu8FLi/awHbRkJtOze0bMErSZYFBjVjGftgdeiVuv7cPIHgvjUQMktI=
X-Received: by 2002:a2e:2417:: with SMTP id k23mr14866266ljk.256.1629439141581;
 Thu, 19 Aug 2021 22:59:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210817102709.15046-1-len.baker@gmx.com> <2f3a644e279a8a0933343339fa0add8e76276bf8.camel@kernel.org>
In-Reply-To: <2f3a644e279a8a0933343339fa0add8e76276bf8.camel@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 20 Aug 2021 00:58:50 -0500
Message-ID: <CAH2r5msKF-YZsmWEwqZZEn2ibooEOtFm7khvSnhD9uOidNycew@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix a potencially linear read overflow
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>, Steve French <sfrench@samba.org>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added RB and repushed to cifs-2.6.git for-next

On Wed, Aug 18, 2021 at 8:22 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2021-08-17 at 12:27 +0200, Len Baker wrote:
> > strlcpy() reads the entire source buffer first. This read may exceed the
> > destination size limit. This is both inefficient and can lead to linear
> > read overflows if a source string is not NUL-terminated.
> >
> > Also, the strnlen() call does not avoid the read overflow in the strlcpy
> > function when a not NUL-terminated string is passed.
> >
> > So, replace this block by a call to kstrndup() that avoids this type of
> > overflow and does the same.
> >
> > Fixes: 066ce6899484d ("cifs: rename cifs_strlcpy_to_host and make it use new functions")
> > Signed-off-by: Len Baker <len.baker@gmx.com>
> > ---
> >  fs/cifs/cifs_unicode.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> > index 9bd03a231032..171ad8b42107 100644
> > --- a/fs/cifs/cifs_unicode.c
> > +++ b/fs/cifs/cifs_unicode.c
> > @@ -358,14 +358,9 @@ cifs_strndup_from_utf16(const char *src, const int maxlen,
> >               if (!dst)
> >                       return NULL;
> >               cifs_from_utf16(dst, (__le16 *) src, len, maxlen, codepage,
> > -                            NO_MAP_UNI_RSVD);
> > +                             NO_MAP_UNI_RSVD);
> >       } else {
> > -             len = strnlen(src, maxlen);
> > -             len++;
> > -             dst = kmalloc(len, GFP_KERNEL);
> > -             if (!dst)
> > -                     return NULL;
> > -             strlcpy(dst, src, len);
> > +             dst = kstrndup(src, maxlen, GFP_KERNEL);
> >       }
> >
> >       return dst;
> > --
> > 2.25.1
> >
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>


-- 
Thanks,

Steve
