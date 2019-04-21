Return-Path: <SRS0=uVY/=SX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F096C282E3
	for <linux-cifs@archiver.kernel.org>; Sun, 21 Apr 2019 03:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF4022087B
	for <linux-cifs@archiver.kernel.org>; Sun, 21 Apr 2019 03:48:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I410LrDU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfDUDsm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 Apr 2019 23:48:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35199 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfDUDsm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 20 Apr 2019 23:48:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id g8so4348954pgf.2;
        Sat, 20 Apr 2019 20:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Pt1xXI/Z46Xkaq0ePTfP7hl0Wl15voMnKfOEn1h6XqM=;
        b=I410LrDUJeMAOGJrllvnX/SYrcEwtXY4lQVKcPTf3WricaVO1ov4kwXVvEo9vw3VuE
         ANjjdXk6wAFCK9Eap+5Ye3E6vE9S4ayqMZdxzjkVrZxcCFnV3XgW+hwqbcREljPR5KXL
         fvOZ5bldntvMdCPJqdn+ojJhXHgQR/2haIPoF9D2uTq8lABCN7fCwI0yl9zAe9UBTWQT
         ean1YpL7H4a+cRlY7PGP8U6CZiwuEOh5BADD/61NNmawGszexlEnzKue26TytRpuNcDz
         RfmEc/5lhkezp3PiUNSZWhrg06i5a2JI2l7aHZlXJ1kPQufl9Fw8F1Ez33fZwWOEpbaF
         /uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Pt1xXI/Z46Xkaq0ePTfP7hl0Wl15voMnKfOEn1h6XqM=;
        b=RC0gG6nY+6kJ9mJeG9d45HUZWHXEUR07m9vjxJntNnYoJmm9TcIqaRGVcsGIgs+p4A
         Zzh4QITuulWxprbB3JiQ6jqEUCMX6mVCeTOwCsTUghKoGNq0ANXtCHTOafyLE9k+9FrI
         SijRJ4gFLLIj8o+TjaZb/mMLjQL5w9aS0NR+AnORtEr8gCK1sJJ58XLhtD1LpG9vPAks
         it/uaTjGK594mhmHk4CH9HoXXWvAxiYJ5TfRX7j/O3pD4c5qCmYWY5iBR5fprb5pMmoQ
         SkqgOp+46UiJlHz+RNgpDStfL9TI4+scUXsKGYBPLKq5wIiIAruIxbZ664sWajjcET6w
         gyhQ==
X-Gm-Message-State: APjAAAVzlO6jhnZ8OmtreP8xmndxmyllEDdTrT2j6+KtX3sXd7ZiN57w
        caTDbykElEa36HSuo+3QYAWA6CbRankHVgZARZ0=
X-Google-Smtp-Source: APXvYqwoFV7u+ksJgyXV7ZEsvcCx8zPWors/bHxPhJJ22iKdpom8yXzLVDeFEMLsprS5Dg/6ML2A+PKxzake6IkRrcc=
X-Received: by 2002:a63:f843:: with SMTP id v3mr8292261pgj.69.1555818520930;
 Sat, 20 Apr 2019 20:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190410193747.25302-1-jglisse@redhat.com> <CAH2r5ms-Y3FWhrabPEFt7T8MvC8Pwi1jjPFS7viWWRzx5rbVDw@mail.gmail.com>
 <20190418211226.GO3288@redhat.com> <CAKywueS_A9zSnDtEJ-m8yV_AWzpAF_s-gp_HMDhFhM2J1QkiTw@mail.gmail.com>
In-Reply-To: <CAKywueS_A9zSnDtEJ-m8yV_AWzpAF_s-gp_HMDhFhM2J1QkiTw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 20 Apr 2019 22:48:29 -0500
Message-ID: <CAH2r5msNLx_6jQ_TgFAx4DY5TNd=SMTNuNYHGmgoFFreqUKF8Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix page reference leak with readv/writev
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Jerome Glisse <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated patch in cifs-2.6.git for-next

On Thu, Apr 18, 2019 at 4:45 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=87=D1=82, 18 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 14:12, Jerome Gl=
isse <jglisse@redhat.com>:
> >
> > On Wed, Apr 10, 2019 at 09:47:01PM -0500, Steve French wrote:
> > > How was this discovered? Does it address a reported user problem?
> >
> > I have spotted it while tracking down how page reference are taken
> > for bio and how they are release. In the current code, once the page
> > are GUPed they are never release if there is any failure, on failure
> > cifs_aio_ctx_release() will be call but it will just free the bio_vec
> > not release the page reference.
> >
> > Page reference are only drop if everything is successful.
> >
> > So this patch move the page reference droping to cifs_aio_ctx_release()
> > which is call from all code path including failure AFAICT and thus page
> > reference will be drop if failure does happen.
> >
> > Cheers,
> > J=C3=A9r=C3=B4me
> >
> > >
> > > On Wed, Apr 10, 2019 at 2:38 PM <jglisse@redhat.com> wrote:
> > > >
> > > > From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > >
> > > > CIFS can leak pages reference gotten through GUP (get_user_pages*()
> > > > through iov_iter_get_pages()). This happen if cifs_send_async_read(=
)
> > > > or cifs_write_from_iter() calls fail from within __cifs_readv() and
> > > > __cifs_writev() respectively. This patch move page unreference to
> > > > cifs_aio_ctx_release() which will happens on all code paths this is
> > > > all simpler to follow for correctness.
> > > >
> > > > Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > > Cc: Steve French <sfrench@samba.org>
> > > > Cc: linux-cifs@vger.kernel.org
> > > > Cc: samba-technical@lists.samba.org
> > > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > > Cc: linux-fsdevel@vger.kernel.org
> > > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Cc: Stable <stable@vger.kernel.org>
> > > > ---
> > > >  fs/cifs/file.c | 15 +--------------
> > > >  fs/cifs/misc.c | 23 ++++++++++++++++++++++-
> > > >  2 files changed, 23 insertions(+), 15 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > > index 89006e044973..a756a4d3f70f 100644
> > > > --- a/fs/cifs/file.c
> > > > +++ b/fs/cifs/file.c
> > > > @@ -2858,7 +2858,6 @@ static void collect_uncached_write_data(struc=
t cifs_aio_ctx *ctx)
> > > >         struct cifs_tcon *tcon;
> > > >         struct cifs_sb_info *cifs_sb;
> > > >         struct dentry *dentry =3D ctx->cfile->dentry;
> > > > -       unsigned int i;
> > > >         int rc;
> > > >
> > > >         tcon =3D tlink_tcon(ctx->cfile->tlink);
> > > > @@ -2922,10 +2921,6 @@ static void collect_uncached_write_data(stru=
ct cifs_aio_ctx *ctx)
> > > >                 kref_put(&wdata->refcount, cifs_uncached_writedata_=
release);
> > > >         }
> > > >
> > > > -       if (!ctx->direct_io)
> > > > -               for (i =3D 0; i < ctx->npages; i++)
> > > > -                       put_page(ctx->bv[i].bv_page);
> > > > -
> > > >         cifs_stats_bytes_written(tcon, ctx->total_len);
> > > >         set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(dentry->d_inode)-=
>flags);
> > > >
> > > > @@ -3563,7 +3558,6 @@ collect_uncached_read_data(struct cifs_aio_ct=
x *ctx)
> > > >         struct iov_iter *to =3D &ctx->iter;
> > > >         struct cifs_sb_info *cifs_sb;
> > > >         struct cifs_tcon *tcon;
> > > > -       unsigned int i;
> > > >         int rc;
> > > >
> > > >         tcon =3D tlink_tcon(ctx->cfile->tlink);
> > > > @@ -3647,15 +3641,8 @@ collect_uncached_read_data(struct cifs_aio_c=
tx *ctx)
> > > >                 kref_put(&rdata->refcount, cifs_uncached_readdata_r=
elease);
> > > >         }
> > > >
> > > > -       if (!ctx->direct_io) {
> > > > -               for (i =3D 0; i < ctx->npages; i++) {
> > > > -                       if (ctx->should_dirty)
> > > > -                               set_page_dirty(ctx->bv[i].bv_page);
> > > > -                       put_page(ctx->bv[i].bv_page);
> > > > -               }
> > > > -
> > > > +       if (!ctx->direct_io)
> > > >                 ctx->total_len =3D ctx->len - iov_iter_count(to);
> > > > -       }
> > > >
> > > >         /* mask nodata case */
> > > >         if (rc =3D=3D -ENODATA)
> > > > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > > > index bee203055b30..9bc0d17a9d77 100644
> > > > --- a/fs/cifs/misc.c
> > > > +++ b/fs/cifs/misc.c
> > > > @@ -768,6 +768,11 @@ cifs_aio_ctx_alloc(void)
> > > >  {
> > > >         struct cifs_aio_ctx *ctx;
> > > >
> > > > +       /*
> > > > +        * Must use kzalloc to initialize ctx->bv to NULL and ctx->=
direct_io
> > > > +        * to false so that we know when we have to unreference pag=
es within
> > > > +        * cifs_aio_ctx_release()
> > > > +        */
> > > >         ctx =3D kzalloc(sizeof(struct cifs_aio_ctx), GFP_KERNEL);
> > > >         if (!ctx)
> > > >                 return NULL;
> > > > @@ -786,7 +791,23 @@ cifs_aio_ctx_release(struct kref *refcount)
> > > >                                         struct cifs_aio_ctx, refcou=
nt);
> > > >
> > > >         cifsFileInfo_put(ctx->cfile);
> > > > -       kvfree(ctx->bv);
> > > > +
> > > > +       /*
> > > > +        * ctx->bv is only set if setup_aio_ctx_iter() was call suc=
cessfuly
> > > > +        * which means that iov_iter_get_pages() was a success and =
thus that
> > > > +        * we have taken reference on pages.
> > > > +        */
> > > > +       if (ctx->bv) {
> > > > +               unsigned i;
> > > > +
> > > > +               for (i =3D 0; i < ctx->npages; i++) {
> > > > +                       if (ctx->should_dirty)
> > > > +                               set_page_dirty(ctx->bv[i].bv_page);
> > > > +                       put_page(ctx->bv[i].bv_page);
> > > > +               }
> > > > +               kvfree(ctx->bv);
> > > > +       }
> > > > +
> > > >         kfree(ctx);
> > > >  }
> > > >
> > > > --
> > > > 2.20.1
> > > >
>
> Good catch, thanks!
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve
