Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9348C10F11
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6834B206DF
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbuGdjgI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfDKCrO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 22:47:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33549 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfDKCrO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Apr 2019 22:47:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id k19so2736115pgh.0;
        Wed, 10 Apr 2019 19:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WPkfQuLclK667SiAGvmJhQ63UQ9GZ00hj/awcwsw5dA=;
        b=bbuGdjgIxOfTR4MdjXCaLJ0L7kKpDEyIgwD4MzlqLKcqYnMJ/urPhALzznXb/jHoFU
         0aXS5HR194d9z0fCwHmdvVWADWmjbmcIWDQaTPU6+roEZl8sOzjpr9es1ZFIqTpQJ9XZ
         us9MgA3LR+pWO4bejnQF02Yja/inAsdPaQ+o7Tgzs5O9hI8W/YLhqXQk11/fpb5D4Tcq
         Vu9T4N+tWrGeLTj7w1NFAM9ZrRsM6YlRbVpzfBdqQszxuY9tt+1Py27vc/th4trneSK6
         rsZdlmwFa+9xuFkGsPaxaBOtr/beXKlt+w5RMmAQxVCuaW63oE28jMQfKWAw6Id7GKXe
         V3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WPkfQuLclK667SiAGvmJhQ63UQ9GZ00hj/awcwsw5dA=;
        b=aAr3MfSfMUNnT7JQ3V9UsqV1RbquZ3jOKINevXOHzqaWQ2ITJYYKV+3yzUNhFP4T/f
         UTbW7CBw1dXwvvJOQqp/BVjJpw1+O6x0FtDi1Owam+N0w/zmNQWkmyfnpiG5UpYCaV5v
         kNPL6WBgggQacsy1tlhuzUmqhKNDFdWozJdy6rvVZL7X3fUFsy7qoyjMJrDADDyxq9h+
         JOPC2knn2hU62c8WUqOCQMoueExMpsx84uOpalg19VJbG6EsbHOHQBwxnxgCNxUl1SrA
         Hy/6Q2Gbw2YJ/A54PcPFPAhVD3hmzyFSUU50SHVPQ4e61BbjZ+mvlNsBBiqGDixOc63I
         jQHw==
X-Gm-Message-State: APjAAAWRB3oL4z8MpmZiFn1qSrNzYaDuzdZRHnOQ3AfTUREKMrQhVpnL
        mrkwruxcYycIPSOjKB8dL8Xik6IhEMKQXEAS/1I=
X-Google-Smtp-Source: APXvYqz3vRf/nS4aP18oHtyJeLtlxQuWE/cWpaQymroj3f03ZeRiGlhWHXCcnrWp9VnTjVkK90nxxxpVMlWs79DexvQ=
X-Received: by 2002:aa7:8c13:: with SMTP id c19mr46739064pfd.225.1554950832979;
 Wed, 10 Apr 2019 19:47:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190410193747.25302-1-jglisse@redhat.com>
In-Reply-To: <20190410193747.25302-1-jglisse@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Apr 2019 21:47:01 -0500
Message-ID: <CAH2r5ms-Y3FWhrabPEFt7T8MvC8Pwi1jjPFS7viWWRzx5rbVDw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix page reference leak with readv/writev
To:     jglisse@redhat.com
Cc:     LKML <linux-kernel@vger.kernel.org>,
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

How was this discovered? Does it address a reported user problem?

On Wed, Apr 10, 2019 at 2:38 PM <jglisse@redhat.com> wrote:
>
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>
> CIFS can leak pages reference gotten through GUP (get_user_pages*()
> through iov_iter_get_pages()). This happen if cifs_send_async_read()
> or cifs_write_from_iter() calls fail from within __cifs_readv() and
> __cifs_writev() respectively. This patch move page unreference to
> cifs_aio_ctx_release() which will happens on all code paths this is
> all simpler to follow for correctness.
>
> Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Steve French <sfrench@samba.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Stable <stable@vger.kernel.org>
> ---
>  fs/cifs/file.c | 15 +--------------
>  fs/cifs/misc.c | 23 ++++++++++++++++++++++-
>  2 files changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 89006e044973..a756a4d3f70f 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2858,7 +2858,6 @@ static void collect_uncached_write_data(struct cifs=
_aio_ctx *ctx)
>         struct cifs_tcon *tcon;
>         struct cifs_sb_info *cifs_sb;
>         struct dentry *dentry =3D ctx->cfile->dentry;
> -       unsigned int i;
>         int rc;
>
>         tcon =3D tlink_tcon(ctx->cfile->tlink);
> @@ -2922,10 +2921,6 @@ static void collect_uncached_write_data(struct cif=
s_aio_ctx *ctx)
>                 kref_put(&wdata->refcount, cifs_uncached_writedata_releas=
e);
>         }
>
> -       if (!ctx->direct_io)
> -               for (i =3D 0; i < ctx->npages; i++)
> -                       put_page(ctx->bv[i].bv_page);
> -
>         cifs_stats_bytes_written(tcon, ctx->total_len);
>         set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(dentry->d_inode)->flags=
);
>
> @@ -3563,7 +3558,6 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx=
)
>         struct iov_iter *to =3D &ctx->iter;
>         struct cifs_sb_info *cifs_sb;
>         struct cifs_tcon *tcon;
> -       unsigned int i;
>         int rc;
>
>         tcon =3D tlink_tcon(ctx->cfile->tlink);
> @@ -3647,15 +3641,8 @@ collect_uncached_read_data(struct cifs_aio_ctx *ct=
x)
>                 kref_put(&rdata->refcount, cifs_uncached_readdata_release=
);
>         }
>
> -       if (!ctx->direct_io) {
> -               for (i =3D 0; i < ctx->npages; i++) {
> -                       if (ctx->should_dirty)
> -                               set_page_dirty(ctx->bv[i].bv_page);
> -                       put_page(ctx->bv[i].bv_page);
> -               }
> -
> +       if (!ctx->direct_io)
>                 ctx->total_len =3D ctx->len - iov_iter_count(to);
> -       }
>
>         /* mask nodata case */
>         if (rc =3D=3D -ENODATA)
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index bee203055b30..9bc0d17a9d77 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -768,6 +768,11 @@ cifs_aio_ctx_alloc(void)
>  {
>         struct cifs_aio_ctx *ctx;
>
> +       /*
> +        * Must use kzalloc to initialize ctx->bv to NULL and ctx->direct=
_io
> +        * to false so that we know when we have to unreference pages wit=
hin
> +        * cifs_aio_ctx_release()
> +        */
>         ctx =3D kzalloc(sizeof(struct cifs_aio_ctx), GFP_KERNEL);
>         if (!ctx)
>                 return NULL;
> @@ -786,7 +791,23 @@ cifs_aio_ctx_release(struct kref *refcount)
>                                         struct cifs_aio_ctx, refcount);
>
>         cifsFileInfo_put(ctx->cfile);
> -       kvfree(ctx->bv);
> +
> +       /*
> +        * ctx->bv is only set if setup_aio_ctx_iter() was call successfu=
ly
> +        * which means that iov_iter_get_pages() was a success and thus t=
hat
> +        * we have taken reference on pages.
> +        */
> +       if (ctx->bv) {
> +               unsigned i;
> +
> +               for (i =3D 0; i < ctx->npages; i++) {
> +                       if (ctx->should_dirty)
> +                               set_page_dirty(ctx->bv[i].bv_page);
> +                       put_page(ctx->bv[i].bv_page);
> +               }
> +               kvfree(ctx->bv);
> +       }
> +
>         kfree(ctx);
>  }
>
> --
> 2.20.1
>


--=20
Thanks,

Steve
