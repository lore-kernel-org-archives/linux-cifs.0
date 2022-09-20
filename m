Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE836ECAAD8
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 04:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiITEKY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 00:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiITEKX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 00:10:23 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE4B4DF12
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:10:21 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id 129so1738971vsi.10
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ozT2DMNXAedpEYueVBkWfzPNmnFLt/Vq8k7OpaUx9j4=;
        b=IEbn3IXV2JeEqGLzr6n16Eg30jnWUImwX5KFtKQJuOb00V0RjDZHNqXJvbdaFqLTss
         6UxRqX8e7PmT4FCVzfjujMlm219wvTJmVQgcjizenzbWiA6t9IneeNH/r20plZNwbTmH
         0HWwKwZfZFYtP+wIfgfd/Rq/IF9Uaf7VIcgLcmZo7y7RZ5xUPp9RhUTws0tElWisf077
         t6QYbQR2tywSZVKFUNSdRYfacLNJDoJfOpNFN5XDulKsm/rhIL9kEk6DHdFw9qwv1gJ9
         X0qh0s16VGHxQL4OGfeLClcay19eb+5QyZxicyIfjmzEWSdtEwamsXPkehEJ8oOafDMN
         T8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ozT2DMNXAedpEYueVBkWfzPNmnFLt/Vq8k7OpaUx9j4=;
        b=ASo1I9Yl5jiFfa4HwAcWqRu+zS6EnR3z9w7TbkXPWpdviikVCQ3gKh78MWWAi3EZEQ
         dM6nLxMdG7ZGEMdvopM92D3QTWboIGqGzinKQrlv/jxafmjD1I7/lruPfi+I/VJyrGXn
         156cXXxodDn/oXTI+nhmkWX3WrcjH0pFj/tp5EVgc0XRrMR5uWwC5j92LGzx0qT5bgj0
         ziNvThPxQfVIUH2UtGxJf89t2+wsq69n8MYp7r91Pyj6vd0jS8CgMrb4PSomfiOdFOk2
         tNR+sL4L+WpeJuCtbbWIcwgSFpFZwLUhiV+aH3eZk73iKUW/OEW5ZvLpFleUnpNIYX9t
         QTfQ==
X-Gm-Message-State: ACrzQf3iQ4NOoGJrR3i/UqXqlm9WnjRAxK5+JJkEZ/GAmeYbkF4td1vg
        7T3OwKjx8NzpBS18xma68xKO9V5FyvqVLUfnkHvXOW2V
X-Google-Smtp-Source: AMsMyM7x+posz19x+kWX0Vl7ZC0GwhvfsubafsmJDisyazac4Ggp+NgB0U23xof9n9tE7bbl+PJeCKCxYk/FcHJLtkg=
X-Received: by 2002:a67:ad15:0:b0:398:6aef:316b with SMTP id
 t21-20020a67ad15000000b003986aef316bmr8126368vsl.17.1663647020446; Mon, 19
 Sep 2022 21:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220919213759.487123-1-lsahlber@redhat.com> <20220919213759.487123-2-lsahlber@redhat.com>
 <5e836422-b132-b28b-af31-4cf7d02cc365@talpey.com> <CAGvGhF5+2PJbV4c5Aia8=jV5o-JNtEGmsvfYbHEo1+qOdMW1vg@mail.gmail.com>
In-Reply-To: <CAGvGhF5+2PJbV4c5Aia8=jV5o-JNtEGmsvfYbHEo1+qOdMW1vg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Sep 2022 23:10:09 -0500
Message-ID: <CAH2r5mvW6Fw1PRJX8z_eo0GtZO5cELrBiF626TTx3HUWU6=J4g@mail.gmail.com>
Subject: Re: [PATCH] cifs: destage dirty pages before re-reading them for cache=none
To:     Leif Sahlberg <lsahlber@redhat.com>
Cc:     Tom Talpey <tom@talpey.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

could you resend - also add cc:stable if you think appropriate.

On Mon, Sep 19, 2022 at 11:08 PM Leif Sahlberg <lsahlber@redhat.com> wrote:
>
> On Tue, Sep 20, 2022 at 11:43 AM Tom Talpey <tom@talpey.com> wrote:
> >
> > On 9/19/2022 5:37 PM, Ronnie Sahlberg wrote:
> > > This is the opposite case of kernel bugzilla 216301.
> > > If we mmap a file using cache=none and then proceed to update the mmapped
> > > area these updates are not reflected in a later pread() of that part of the
> > > file.
> > > To fix this we must first destage any dirty pages in the range before
> > > we allow the pread() to proceed.
> > >
> > > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > > Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >   fs/cifs/file.c | 9 +++++++++
> > >   1 file changed, 9 insertions(+)
> > >
> > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > index 6f38b134a346..1f3eb97ef4ab 100644
> > > --- a/fs/cifs/file.c
> > > +++ b/fs/cifs/file.c
> > > @@ -4271,6 +4271,15 @@ static ssize_t __cifs_readv(
> > >               len = ctx->len;
> > >       }
> > >
> > > +     if (direct) {
> > > +             rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
> > > +                                               offset, offset + len - 1);
> > > +             if (rc) {
> > > +                     kref_put(&ctx->refcount, cifs_aio_ctx_release);
> > > +                     return rc;
> >
> > Are the possible return values from filemap_write_and_wait_range() also
> > valid for returning from __cifs_readv()? It seems a bit odd to return
> > write errors here.
> >
> > If not, then perhaps a more generic failure rc would be safer/more POSIX
> > compliant?
>
> Good point. Since an error here means we have dirty pages and
> destaging them failed I guess -EAGAIN
> would be the best to return. We want/need userspace to retry this,
> possibly forever, in that scenario.
>
> Steve, can you change the patch to -EAGAIN or do you want me to re-send it?
>
> regards
> ronnie s
>
>
> >
> > Tom.
> >
> > > +             }
> > > +     }
> > > +
> > >       /* grab a lock here due to read response handlers can access ctx */
> > >       mutex_lock(&ctx->aio_mutex);
> > >
> >
>


-- 
Thanks,

Steve
