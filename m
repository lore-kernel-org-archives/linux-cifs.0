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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D36BC4708E
	for <linux-cifs@archiver.kernel.org>; Sat, 29 May 2021 14:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD0F61157
	for <linux-cifs@archiver.kernel.org>; Sat, 29 May 2021 14:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhE2OOv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 May 2021 10:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhE2OOu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 May 2021 10:14:50 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D10FC061574;
        Sat, 29 May 2021 07:13:13 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id f11so3702285vst.0;
        Sat, 29 May 2021 07:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L2BlukILXONRQJcclTGh7GA2Qfr+L6d986kgRYUf/Ws=;
        b=lbrqNq0uEAew5n0pLs6zfKEUdjlz+WISW0Ok7SWpREczZQzFfAhbmhny6bTB9zwAR9
         fiSbdsKRRPQ36nnRT2YDNiEmqVKU8H3/FTRSoLh1ALQSWYlgCgF+68e++RWnRnf6PNW3
         39KuASfdF7zkxDJNi4xRvukcCrwStY3ywYwpQy1JORYO3flk+RiU/lr8jEL+wL7pez0K
         8DuaekToFufi+g3pv+kWkfYBK1+hMgChZjsHv83z7PU+nsFijLZA71RN7Y5PjPFR8VEH
         m2Ajsw8T6rN+lESstwrTwxlUgjRwEhbIScO+d8JEzzruhK20IcYcf/6ANdD5WITI76Bp
         UDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L2BlukILXONRQJcclTGh7GA2Qfr+L6d986kgRYUf/Ws=;
        b=uXo3JEMXSRi8zuKkph9U/zi5R1S51tZUohswF2iprU0TMcghH2BfOIZOTlekqR3vlc
         3Mk26MxFWEwoFahw6oIApgXRyzBBsJITwNDveslsPtHoZ2i7ch+E9e3eJaVQ9R4jOyYm
         FpYzvQGUuDyveVFZptb/b24cZYtrzMXD/bUB/+vWFwsvCy7NwH/tnZksXzGL1Ih1vSun
         0Ki33jGPfWh98dz1v5R8s3d2UVNCTAZpmry4Qie1ES1ZrreO8PM+s7bb2Y6vuKdn0G26
         Dy1R8pp1yPDXdMn+wjQgW+wAaL+wrVnvTL7NfqcpCSMtV+MchKfog5QrNwn613jOcThg
         3gmA==
X-Gm-Message-State: AOAM532T3wn0gKVfH33+NRMjq4ntSZQPSo9NU6GiA+pFGPmgI74omR39
        9scjqGCgBnLO7OgtirpZnppu8p0doZ2XI8JFg7I=
X-Google-Smtp-Source: ABdhPJxDAViTVR8Z4Bq2yEXQKABk64nreqW75JIfEKNXn7UHMF8Ml1UzCfBPNAnEbTbvJ3u7GQBZnBmC8nA1Hnr1tb0=
X-Received: by 2002:a67:d017:: with SMTP id r23mr10749055vsi.12.1622297592646;
 Sat, 29 May 2021 07:13:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210529082058.3012233-1-yangyingliang@huawei.com> <20210529082058.3012233-3-yangyingliang@huawei.com>
In-Reply-To: <20210529082058.3012233-3-yangyingliang@huawei.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 29 May 2021 23:13:01 +0900
Message-ID: <CANFS6bYGp0CsdjovHxpaxbYVq72U3EY8C-oSphHDUSrwLmxCOA@mail.gmail.com>
Subject: Re: [PATCH -next 3/3] cifsd: check return value of
 ksmbd_vfs_getcasexattr() correctly
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

Hi Yang,

2021=EB=85=84 5=EC=9B=94 29=EC=9D=BC (=ED=86=A0) =EC=98=A4=ED=9B=84 5:16, Y=
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
>  fs/cifsd/vfs.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifsd/vfs.c b/fs/cifsd/vfs.c
> index 97d5584ec870..45ba30f1f2d2 100644
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
> +       if ((int)v_len < 0) {

because ksmbd_vfs_getcasexattr can return 0, 0 has to be handled.

Thanks,
Hyunchul

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
