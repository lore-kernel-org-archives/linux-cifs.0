Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF8EC4708F
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 05:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D69E61248
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 05:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhEaFkj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 31 May 2021 01:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhEaFkf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 31 May 2021 01:40:35 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8BAC061574;
        Sun, 30 May 2021 22:38:55 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id n61so5989702uan.2;
        Sun, 30 May 2021 22:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HnNmmcpEGANCywXAOHjjcUJ4MN6oF/accismZD3OTBY=;
        b=sDg+mggvypKBneaa3Jrh6Gwlmjq7O+/sgTx9+ShU59xkd38JFVUcZUHTK7IdznJa/O
         T4wttBebcWUfBojLxSjIwj0o/xqvFZIApQZAIl0km6c8zpD1GXXbMNpmdOFYGDru2n0k
         d4F4SfkrQjZlJB+VoldJNtCi03dzZRr5YsWcvcFV6mak3lXgOnlIQnsTGcW+0PRiJQNw
         y5O0EaafidOdazuwmmhkblHGAQlKb1xYifEfQ8eH8Iv31D9YLqTB4Hb7Q9cKifR1Jvr7
         J/9oi/Fnp2451KV631ZW3GZ7w98hE8V7KhPc8fN4ubxm5lYa6KyjM+WdsSSqrW7JbVdg
         2kMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HnNmmcpEGANCywXAOHjjcUJ4MN6oF/accismZD3OTBY=;
        b=aKLnQUzgE3nMp2Sfb9zdgj7Fum5omwo8GBF7pMnfdC+mZ0tHkM+C8XMZ3Es4CiM7vc
         KLdscn12HyBTTFOimtvchjrVHvS5W1+PgK6VCaEUf9B+/aE4FrcB0Y1483FKnlgwBwpt
         hUp/ke827YMPdZrKLweUogoVHl1w2jbhtqdy7heC8e48D4+asD8r9mBGBAyTE7UVrVW9
         6pMmfU/ds96SaD531rjlNpBFauzJkHwdzEBkN/C2fDDd5Q1RInXnpwo4FBkmB30Z/4Lm
         GPVNn3hV/GBGuidBgn/KrNrge/8ivnxrTR617sZtLHBZdQgkkURHBz9i8AHlJ4M9IzZ1
         VTBQ==
X-Gm-Message-State: AOAM533rlw9fE0+SIKh1hnz5xWE80DQ27VMyEygvb04KoN34Aplyp77W
        qhdtFywxisWHuudMvDhWxJP7bf1i+XZblm7YMfM=
X-Google-Smtp-Source: ABdhPJxVnhl7BbzXoHUxBwYsSTgkaTs5EoHCr/SSq7+a3HYzww0NBP4xIl/errV4WHy7xBi0YnvOFYPm/59cNixeAeg=
X-Received: by 2002:a1f:b488:: with SMTP id d130mr11690045vkf.17.1622439533937;
 Sun, 30 May 2021 22:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210531030550.1708816-1-yangyingliang@huawei.com>
In-Reply-To: <20210531030550.1708816-1-yangyingliang@huawei.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 31 May 2021 14:38:42 +0900
Message-ID: <CANFS6bbZysgZ2Wv7_FqmeBC0e34h5uiBLFdeiDvOxHFd2XGTSg@mail.gmail.com>
Subject: Re: [PATCH -next v2] cifsd: check return value of ksmbd_vfs_getcasexattr()
 correctly
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        linux-cifsd-devel <linux-cifsd-devel@lists.sourceforge.net>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 5=EC=9B=94 31=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 12:01, =
Yang Yingliang <yangyingliang@huawei.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> If ksmbd_vfs_getcasexattr() returns -ENOMEM, stream_buf is NULL,
> it will cause null-ptr-deref when using it to copy memory. So we
> need check the return value of ksmbd_vfs_getcasexattr() by comparing
> with 0.
>
> Fixes: f44158485826 ("cifsd: add file operations")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2:
>   Handle the case ksmbd_vfs_getcasexattr() returns 0.
> ---
>  fs/cifsd/vfs.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifsd/vfs.c b/fs/cifsd/vfs.c
> index 97d5584ec870..2a9cc0bc7726 100644
> --- a/fs/cifsd/vfs.c
> +++ b/fs/cifsd/vfs.c
> @@ -274,7 +274,6 @@ static int ksmbd_vfs_stream_read(struct ksmbd_file *f=
p, char *buf, loff_t *pos,
>  {
>         ssize_t v_len;
>         char *stream_buf =3D NULL;
> -       int err;
>
>         ksmbd_debug(VFS, "read stream data pos : %llu, count : %zd\n",
>                     *pos, count);
> @@ -283,10 +282,9 @@ static int ksmbd_vfs_stream_read(struct ksmbd_file *=
fp, char *buf, loff_t *pos,
>                                        fp->stream.name,
>                                        fp->stream.size,
>                                        &stream_buf);
> -       if (v_len =3D=3D -ENOENT) {
> +       if ((int)v_len <=3D 0) {
>                 ksmbd_err("not found stream in xattr : %zd\n", v_len);
> -               err =3D -ENOENT;
> -               return err;
> +               return v_len =3D=3D 0 ? -ENOENT : (int)v_len;

How about making ksmbd_vfs_getcasexattr return -ENONENT instead of
returning 0 to
remove duplicate error handling code?

Thanks,
Hyunchul

>         }
>
>         memcpy(buf, &stream_buf[*pos], count);
> @@ -415,9 +413,9 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *=
fp, char *buf, loff_t *pos,
>                                        fp->stream.name,
>                                        fp->stream.size,
>                                        &stream_buf);
> -       if (v_len =3D=3D -ENOENT) {
> +       if ((int)v_len <=3D 0) {
>                 ksmbd_err("not found stream in xattr : %zd\n", v_len);
> -               err =3D -ENOENT;
> +               err =3D v_len =3D=3D 0 ? -ENOENT : (int)v_len;
>                 goto out;
>         }
>
> --
> 2.25.1
>
