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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498FAC4708F
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 07:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A05E61278
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 07:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhEaHud (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 31 May 2021 03:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhEaHuc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 31 May 2021 03:50:32 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97C5C061760;
        Mon, 31 May 2021 00:48:51 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id x22so5593435vsn.2;
        Mon, 31 May 2021 00:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WQerxY7xWQJU0sQJYd3W0J67IMvkIibV5Sb4RiTPWfI=;
        b=FZR3K2LyfCzZl6djCqOXma8hHlVAJamJbRH19HLhiBkewMDnSrWsRJXnALVAjccmJt
         aq5yeQT2qOgUzzHUQKkxMmDBrf3xvVPU9KdcPyM486dAh5hPVq2xnP9PjR3r1Lsd5sw4
         61t3nbOK7fLs5eCl6X8v7AFr6AJnVFK8CcHh57pLyzOy29vdzIs1qci/js3GKUeiZczG
         02GK+nbswEngFGhQD4pGxAKOphw6wJhgt+EkVRnU/gGAD7UBXMTXHY6CQWJNk2sdYht5
         58gAh4BGBeraVBE1alwmGvgn75+MYGazNmtg1xztKs+Bfpr9F2zwmdzXWu8nLE9/Wvml
         2VYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WQerxY7xWQJU0sQJYd3W0J67IMvkIibV5Sb4RiTPWfI=;
        b=JqpRfndnpRlh9mOptnESJgEIpthE31ZqdxTUs8LFSQLezXArMTyfHv9KgaBOalbkVP
         5ONw0gRqqBFyDnz6j2leSBro9Ddwd9zSGu+PLt9NLQDIsBCzFWTryfSBtPpCu+Ni1ljs
         ZYivldtQrdNwJnAuZLOgl6JGnVqtAzMYYugNXCOJp/ej2hPu89qTVRcDdRjgyXxwgTDJ
         /ir0JOq9Oqc2vsCdIQctZjRq1DhJxfwfpH+KUqeS8NgTbur0/51JVIw+ejTra1CeFBJU
         5zuooK7ZGb5IvKG41D7b2yWKMqB1CrYdqhl7qOLQerdZhMH/eb3LVmTEwdrZcBN2YiXG
         x4tg==
X-Gm-Message-State: AOAM532UeSik+i9ZIaxfUaId7CRCt2IcwjCDSC/FmmE4WSFgkTMphSFY
        X9QqJjQb7WBET0ZRY15ZfwTpLKruF22+0k0RddU=
X-Google-Smtp-Source: ABdhPJx4JM83e3BeoZX3si9ZmCeRAnVTq79/RfBj9Dd0Gq32VWx5feCij5NRRaO0qG9Oe/ifh6ymXNnQVCKyH2rpiJc=
X-Received: by 2002:a05:6102:3225:: with SMTP id x5mr1994208vsf.18.1622447330957;
 Mon, 31 May 2021 00:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210531062350.1910823-1-yangyingliang@huawei.com>
In-Reply-To: <20210531062350.1910823-1-yangyingliang@huawei.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 31 May 2021 16:48:39 +0900
Message-ID: <CANFS6bam+RdmkWMJ1X5ECt6sF-_7mTi0OG8xpzHZYkveu2P9dQ@mail.gmail.com>
Subject: Re: [PATCH -next v3] cifsd: check return value of ksmbd_vfs_getcasexattr()
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

This looks good to me.

2021=EB=85=84 5=EC=9B=94 31=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 3:19, Y=
ang Yingliang <yangyingliang@huawei.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
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
> v3:
>   Handle the 0 return value in ksmbd_vfs_getcasexattr().
>
> v2:
>   Handle the case ksmbd_vfs_getcasexattr() returns 0.
> ---
>  fs/cifsd/vfs.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifsd/vfs.c b/fs/cifsd/vfs.c
> index 97d5584ec870..a56ec1f7f941 100644
> --- a/fs/cifsd/vfs.c
> +++ b/fs/cifsd/vfs.c
> @@ -266,7 +266,7 @@ static ssize_t ksmbd_vfs_getcasexattr(struct dentry *=
dentry, char *attr_name,
>
>  out:
>         kvfree(xattr_list);
> -       return value_len;
> +       return value_len =3D=3D 0 ? -ENOENT : value_len;
>  }
>
>  static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_=
t *pos,
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
> +       if ((int)v_len < 0) {
>                 ksmbd_err("not found stream in xattr : %zd\n", v_len);
> -               err =3D -ENOENT;
> -               return err;
> +               return (int)v_len;
>         }
>
>         memcpy(buf, &stream_buf[*pos], count);
> @@ -415,9 +413,9 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *=
fp, char *buf, loff_t *pos,
>                                        fp->stream.name,
>                                        fp->stream.size,
>                                        &stream_buf);
> -       if (v_len =3D=3D -ENOENT) {
> +       if ((int)v_len < 0) {
>                 ksmbd_err("not found stream in xattr : %zd\n", v_len);
> -               err =3D -ENOENT;
> +               err =3D (int)v_len;
>                 goto out;
>         }
>
> --
> 2.25.1
>


--=20

Thanks,
Hyunchul
