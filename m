Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCC3C10F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 21:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC2120652
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 21:45:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmVYAwsf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfDRVp4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 17:45:56 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38288 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfDRVp4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Apr 2019 17:45:56 -0400
Received: by mail-lf1-f68.google.com with SMTP id v1so2697373lfg.5;
        Thu, 18 Apr 2019 14:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BQ9AnoXdYH58OHa/qFpsfABxBnr63StgEbAqCA9tfak=;
        b=jmVYAwsf2odYiQDCd9AG7JrEW9AwoHSMuBf3ni0TcPXUGIy7r1iaKjBcWdpRexp4q6
         GV5xZBAB0VxL3ZKsudUHDTJAl/e4qFyJe3BT9tNNiIOxISRCULq5VRPDo6DqOYtCs7ny
         sgDdd9sWu9Mve/lKfQIj1fcAG5a1LluCuc/b50lQ9ZQwJ2EVIq2p24+lBMMCKaT2t/dP
         soMR2+Zfrs4H2W9SuI43bTc1lir2hRgmly3kcyEhL8SbY2tVPtiUn0zIlV0zrI0wBsK1
         6OGEesXiKUCgalgwxF+wTlFXnMT4MRg1HEECXoyZCZGXkJGCKbdIQ0Y8gCpd8BIHnnya
         mmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BQ9AnoXdYH58OHa/qFpsfABxBnr63StgEbAqCA9tfak=;
        b=pxPF3r54k0qxBMzJqivQOCkXrEI3kNDEKMKpjGVQ2DfmFMzTWOI5IovyxLi4xPvxZp
         BP6Ze7czRmH4dk4BvrW3MFDYDiutuoTMsTFJUdR9sTI0IEySyeYxBfipnpTgTxW9UF4x
         c21PZMqKoEz4+ULFVdnmj/GhCyPBZdp9xMZfR7OXqH5Bcwd0CtfIypTiknp0j9Plyqdk
         T1Q48oIWcEFgeT37EWwBMTLNAQQkVw2yTm+ZpbBf33TEQu3XOIgsjh5vKt+qrOf8Tr1g
         GV7Dkelxxa9SiHsGvP18pcVKwbhbgzBpYRVUfw7sP0bhdFpAzifzTjyUEpBNjhLgkfOe
         K6qA==
X-Gm-Message-State: APjAAAWckthxVO3jvjpXuLXYp9S2eJ0tmun241GZhBl2XWq3dzfMyb/6
        5yn6jm/4mKzd4Mqjj/4ObvZHnueWl48tfdnAMA==
X-Google-Smtp-Source: APXvYqwLgqFAa4o4W4SQuXUvr9OlRhZefzVDydhThHor2DykH61LQgoJuaYcTJtqes9jf30qDSf2AkTmXvlhdKmiVGc=
X-Received: by 2002:a19:c113:: with SMTP id r19mr227636lff.64.1555623953323;
 Thu, 18 Apr 2019 14:45:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190410193747.25302-1-jglisse@redhat.com> <CAH2r5ms-Y3FWhrabPEFt7T8MvC8Pwi1jjPFS7viWWRzx5rbVDw@mail.gmail.com>
 <20190418211226.GO3288@redhat.com>
In-Reply-To: <20190418211226.GO3288@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 18 Apr 2019 14:45:42 -0700
Message-ID: <CAKywueS_A9zSnDtEJ-m8yV_AWzpAF_s-gp_HMDhFhM2J1QkiTw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix page reference leak with readv/writev
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 18 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 14:12, Jerome Glis=
se <jglisse@redhat.com>:
>
> On Wed, Apr 10, 2019 at 09:47:01PM -0500, Steve French wrote:
> > How was this discovered? Does it address a reported user problem?
>
> I have spotted it while tracking down how page reference are taken
> for bio and how they are release. In the current code, once the page
> are GUPed they are never release if there is any failure, on failure
> cifs_aio_ctx_release() will be call but it will just free the bio_vec
> not release the page reference.
>
> Page reference are only drop if everything is successful.
>
> So this patch move the page reference droping to cifs_aio_ctx_release()
> which is call from all code path including failure AFAICT and thus page
> reference will be drop if failure does happen.
>
> Cheers,
> J=C3=A9r=C3=B4me
>
> >
> > On Wed, Apr 10, 2019 at 2:38 PM <jglisse@redhat.com> wrote:
> > >
> > > From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > >
> > > CIFS can leak pages reference gotten through GUP (get_user_pages*()
> > > through iov_iter_get_pages()). This happen if cifs_send_async_read()
> > > or cifs_write_from_iter() calls fail from within __cifs_readv() and
> > > __cifs_writev() respectively. This patch move page unreference to
> > > cifs_aio_ctx_release() which will happens on all code paths this is
> > > all simpler to follow for correctness.
> > >
> > > Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > Cc: Steve French <sfrench@samba.org>
> > > Cc: linux-cifs@vger.kernel.org
> > > Cc: samba-technical@lists.samba.org
> > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > Cc: linux-fsdevel@vger.kernel.org
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: Stable <stable@vger.kernel.org>
> > > ---
> > >  fs/cifs/file.c | 15 +--------------
> > >  fs/cifs/misc.c | 23 ++++++++++++++++++++++-
> > >  2 files changed, 23 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > index 89006e044973..a756a4d3f70f 100644
> > > --- a/fs/cifs/file.c
> > > +++ b/fs/cifs/file.c
> > > @@ -2858,7 +2858,6 @@ static void collect_uncached_write_data(struct =
cifs_aio_ctx *ctx)
> > >         struct cifs_tcon *tcon;
> > >         struct cifs_sb_info *cifs_sb;
> > >         struct dentry *dentry =3D ctx->cfile->dentry;
> > > -       unsigned int i;
> > >         int rc;
> > >
> > >         tcon =3D tlink_tcon(ctx->cfile->tlink);
> > > @@ -2922,10 +2921,6 @@ static void collect_uncached_write_data(struct=
 cifs_aio_ctx *ctx)
> > >                 kref_put(&wdata->refcount, cifs_uncached_writedata_re=
lease);
> > >         }
> > >
> > > -       if (!ctx->direct_io)
> > > -               for (i =3D 0; i < ctx->npages; i++)
> > > -                       put_page(ctx->bv[i].bv_page);
> > > -
> > >         cifs_stats_bytes_written(tcon, ctx->total_len);
> > >         set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(dentry->d_inode)->f=
lags);
> > >
> > > @@ -3563,7 +3558,6 @@ collect_uncached_read_data(struct cifs_aio_ctx =
*ctx)
> > >         struct iov_iter *to =3D &ctx->iter;
> > >         struct cifs_sb_info *cifs_sb;
> > >         struct cifs_tcon *tcon;
> > > -       unsigned int i;
> > >         int rc;
> > >
> > >         tcon =3D tlink_tcon(ctx->cfile->tlink);
> > > @@ -3647,15 +3641,8 @@ collect_uncached_read_data(struct cifs_aio_ctx=
 *ctx)
> > >                 kref_put(&rdata->refcount, cifs_uncached_readdata_rel=
ease);
> > >         }
> > >
> > > -       if (!ctx->direct_io) {
> > > -               for (i =3D 0; i < ctx->npages; i++) {
> > > -                       if (ctx->should_dirty)
> > > -                               set_page_dirty(ctx->bv[i].bv_page);
> > > -                       put_page(ctx->bv[i].bv_page);
> > > -               }
> > > -
> > > +       if (!ctx->direct_io)
> > >                 ctx->total_len =3D ctx->len - iov_iter_count(to);
> > > -       }
> > >
> > >         /* mask nodata case */
> > >         if (rc =3D=3D -ENODATA)
> > > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > > index bee203055b30..9bc0d17a9d77 100644
> > > --- a/fs/cifs/misc.c
> > > +++ b/fs/cifs/misc.c
> > > @@ -768,6 +768,11 @@ cifs_aio_ctx_alloc(void)
> > >  {
> > >         struct cifs_aio_ctx *ctx;
> > >
> > > +       /*
> > > +        * Must use kzalloc to initialize ctx->bv to NULL and ctx->di=
rect_io
> > > +        * to false so that we know when we have to unreference pages=
 within
> > > +        * cifs_aio_ctx_release()
> > > +        */
> > >         ctx =3D kzalloc(sizeof(struct cifs_aio_ctx), GFP_KERNEL);
> > >         if (!ctx)
> > >                 return NULL;
> > > @@ -786,7 +791,23 @@ cifs_aio_ctx_release(struct kref *refcount)
> > >                                         struct cifs_aio_ctx, refcount=
);
> > >
> > >         cifsFileInfo_put(ctx->cfile);
> > > -       kvfree(ctx->bv);
> > > +
> > > +       /*
> > > +        * ctx->bv is only set if setup_aio_ctx_iter() was call succe=
ssfuly
> > > +        * which means that iov_iter_get_pages() was a success and th=
us that
> > > +        * we have taken reference on pages.
> > > +        */
> > > +       if (ctx->bv) {
> > > +               unsigned i;
> > > +
> > > +               for (i =3D 0; i < ctx->npages; i++) {
> > > +                       if (ctx->should_dirty)
> > > +                               set_page_dirty(ctx->bv[i].bv_page);
> > > +                       put_page(ctx->bv[i].bv_page);
> > > +               }
> > > +               kvfree(ctx->bv);
> > > +       }
> > > +
> > >         kfree(ctx);
> > >  }
> > >
> > > --
> > > 2.20.1
> > >

Good catch, thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
