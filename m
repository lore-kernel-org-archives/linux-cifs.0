Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B22C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Oct 2022 01:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJLBEk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJLBEj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 21:04:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB517474F8
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 18:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665536673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+OgK2qRhEANFOUNbyzcx4BR3WqdB+deDgGjvP0ram54=;
        b=ZXdDDJNL6BDxEw7b0xdtYihG8+qJKcZdZXP6A4N4it4z7rp3nh9C2xkZexerF/SPL/tNvI
        jO1Ptj/FKupIiqTN8YHFCB0MJOCKSEsMGiWIjP4g+HqxrQ8hI2ZKHvU8a0PtbR2kRGs/lj
        Gk2tzVpxl37j9JTYxUGLYeIbRE0jAyw=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-131-W48USeyiPlmoslBxs6rQkw-1; Tue, 11 Oct 2022 21:04:32 -0400
X-MC-Unique: W48USeyiPlmoslBxs6rQkw-1
Received: by mail-oi1-f200.google.com with SMTP id z10-20020a056808028a00b00354b8b0ff15so1824663oic.13
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 18:04:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+OgK2qRhEANFOUNbyzcx4BR3WqdB+deDgGjvP0ram54=;
        b=tRp3qZOCx8JjoG6MkoQ5AloiU14rClkYwLIVO3pVxMGD04wE8FpkEYVm2kqb9zmKCo
         6/uvErK3asSRZTYRnHrWH0zlwQgCyxe3R7uCuEf1XyQHg+81O5/+bq1UPGPBEGIXYpWY
         TdRxheAqYzl7NzqUezkOw8jsUFeXecuD/imyX+leg+cHV7aqziIw4Xw/MmqfOPfQdHnD
         xsTunvxdML7eZIRYmzovP6zSpNWrhJ2GCh4wlDE0/jEczvn27ioshqhcSyFcQch9dRPM
         yMLoxDMM+hwYw64zCqOOfjnV/fvvRBgJ52DrKsbWUEmr8ozL+iZl5qNZypxSvk3vVQ6h
         p2dQ==
X-Gm-Message-State: ACrzQf000Rr0YQalJADOc8Fk8lUOVzZjtWXiIJ/f5NHSZ8Sut8CZUpDH
        fb/LuJQkP2X9IS/Bo9YtbMtEBZ6/y/J1ljLDW8Ub3wybQrZQds6cE0uj4Bjh8X+bphLr5HovY9B
        iDpAAcUqRWRL1SOHw/4boN7wgsTekoBT+aearQA==
X-Received: by 2002:a05:6830:610b:b0:65b:eb36:6336 with SMTP id ca11-20020a056830610b00b0065beb366336mr11667962otb.131.1665536671368;
        Tue, 11 Oct 2022 18:04:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6mtOaf1Zoo5w02y6zP+cqS/zaIwCiMgtLUep4gOGidOhCyw9c5Y8tdur4Fc1QIEmseP9noGcaao7cuTfC66g0=
X-Received: by 2002:a05:6830:610b:b0:65b:eb36:6336 with SMTP id
 ca11-20020a056830610b00b0065beb366336mr11667953otb.131.1665536671129; Tue, 11
 Oct 2022 18:04:31 -0700 (PDT)
MIME-Version: 1.0
References: <20221011220729.1455757-1-lsahlber@redhat.com> <20221011220729.1455757-2-lsahlber@redhat.com>
 <bd9a1a65-8565-e5ca-8d48-f7c3430e6e7c@talpey.com>
In-Reply-To: <bd9a1a65-8565-e5ca-8d48-f7c3430e6e7c@talpey.com>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Wed, 12 Oct 2022 11:04:19 +1000
Message-ID: <CAGvGhF7sSVC=+jzq+LAbVLU0fWyEba=b9x6D-arH2NuXdcWppg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Oct 12, 2022 at 10:49 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/11/2022 6:07 PM, Ronnie Sahlberg wrote:
> > When application has done lseek() to a different offset on a directory fd
> > we skipped one entry too many before we start emitting directory entries
> > from the cache.
> >
> > We need to also make sure that when we are starting to emit directory
> > entries from the cache, the ->pos sequence might have holes and skip
> > some indices.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >   fs/cifs/readdir.c | 29 +++++++++++++++++++++++------
> >   1 file changed, 23 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index 8e060c00c969..1bb4624e768b 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -844,17 +844,34 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
> >                               struct dir_context *ctx)
> >   {
> >       struct cached_dirent *dirent;
> > -     int rc;
> > +     bool rc;
> >
> >       list_for_each_entry(dirent, &cde->entries, entry) {
> > -             if (ctx->pos >= dirent->pos)
> > +             /*
> > +              * Skip all early entries prior to the current lseek()
> > +              * position.
> > +              */
> > +             if (ctx->pos > dirent->pos)
> >                       continue;
> > +             /*
> > +              * We recorded the current ->pos value for the dirent
> > +              * when we stored it in the cache.
> > +              * However, this sequence of ->pos values may have holes
> > +              * in it, for example dot-dirs returned from the server
> > +              * are suppressed.
> > +              * Handle this bu forcing ctx->pos to be the same as the
> > +              * ->pos of the current dirent we emit from the cache.
> > +              * This means that when we emit these entries from the cache
> > +              * we now emit them with the same ->pos value as in the
> > +              * initial scan.
> > +              */
>
> It's a little wordy, but it's better, so ok.
>
> >               ctx->pos = dirent->pos;
> >               rc = dir_emit(ctx, dirent->name, dirent->namelen,
> >                             dirent->fattr.cf_uniqueid,
> >                             dirent->fattr.cf_dtype);
> >               if (!rc)
> >                       return rc;
>
> Well, I still think it would be clearer as "return false". And the
> name "rc" really seems odd now for a bool. But again, ok I guess.
>
> Either way, I learned a thing or two chasing down dir_emit() and the
> overall approach seems good.
>
> > +             ctx->pos++;
> >       }
> >       return true;
> >   }
> > @@ -1202,10 +1219,10 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
> >                                ctx->pos, tmp_buf);
> >                       cifs_save_resume_key(current_entry, cifsFile);
> >                       break;
> > -             } else
> > -                     current_entry =
> > -                             nxt_dir_entry(current_entry, end_of_smb,
> > -                                     cifsFile->srch_inf.info_level);
> > +             }
> > +             current_entry =
> > +                     nxt_dir_entry(current_entry, end_of_smb,
> > +                                   cifsFile->srch_inf.info_level);
>
> This change isn't actually changing anything. Would it be
> better to leave out on principle?

I wanted this change since previously it was a little confusing. A
quick glance might raise questions "why only do this conditionally?"
and then when looking more carefully "oh, we actually do this
unconditionally before every new iteration".

It is as you say a no-op change.
It should arguably be done in a separate patch but it is so small I
just took the lazy path and put it in this patch instead of a separate
patch.

Thanks for the review.
>
>
> >       }
> >       kfree(tmp_buf);
> >
> Overall,
>
> Reviewed-by: Tom Talpey <tom@talpey.com>
>

