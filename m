Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25241C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 23:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbiCAXNw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 18:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiCAXNv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 18:13:51 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F101EAD8
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 15:13:10 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id w4so23675vsq.1
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 15:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ot3OhLc5LYjXpl58JVe7+HqyHnA8h8OzVtI1dB6gIWQ=;
        b=Po2dwvM2jOfhFgrnRNGRttmN6pnU1RHz8iTKpIMF3OdU3+BbKU6F+aDRKx1X10V5TP
         fro7/nXpY3ErikXf7pysAbgA6VeDoYojhaaOhZJZB9ydx7h+sj3cJ97fz0vbDwfB2AA1
         wiL5UiYSOJpFS6yWrzKFj4VdjjVg1bz04EOrfZsDR/kEqsW4xCdydP9DHpC0Wbw4Lq/c
         YlOvbapWUgN1rb01RGIm+pK0+93KzOAry9lbB9AbUZTI+FC1s+LI8JeyKpnFYD4J9aFb
         P4NEWfhsGEY9WGJM6UDij4anAnV7WQsehwn5/TEF3Zq/x3NoRpxTdw9ppJHfltyKr1Yp
         EOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ot3OhLc5LYjXpl58JVe7+HqyHnA8h8OzVtI1dB6gIWQ=;
        b=Fx/FciEQVPXEkSjKY4bIadS39tknkBgGgAikCvfawjRLDjXDhkEA4rrqIiw48Z8gah
         wvIoQN4k2wgEdyAF7Qnp4+LyapjDE/nKYJTI2QkZ9zCnDPN8uXFE5mAxlb+a3Ly8tWyf
         VhvVjnKqdjrsEYRmuigDZfhCARxFqE2YAp5O9xoTcjDuExLLH1Xaj7ZY49mVNQhdoPAp
         YdxdciBVef6TeafBnwsTLuiBnUUFoLLSBk4AyGnYwLI8QyTgr5nbWaDmkoXgWWMycn8L
         lHXhMqNAUtTIYsNxadjl7J94oLrBcEHtH5i8RvOp86wNLKJSAb3rDRy+jFDdocuO1F1A
         2JfA==
X-Gm-Message-State: AOAM530rOliq45TspkgZIWbqn7p0cGygsjHcJmPGN/9uvXg8tcHN2P+G
        TVnXm4XuUhSiHihabXyp2fjPy/bFop3qnZviXLQ=
X-Google-Smtp-Source: ABdhPJzgMd5p+ipue0rkbSTHAprH64Gv8dB5o5paQYT2vXH3n9IyxIkCZaY61T/57PJsXiFvqb6bMIOhnblHiwXEyAs=
X-Received: by 2002:a05:6102:e46:b0:31d:7efb:eb91 with SMTP id
 p6-20020a0561020e4600b0031d7efbeb91mr12400490vst.80.1646176389322; Tue, 01
 Mar 2022 15:13:09 -0800 (PST)
MIME-Version: 1.0
References: <20220301110006.4033351-1-mmakassikis@freebox.fr> <20220301110006.4033351-4-mmakassikis@freebox.fr>
In-Reply-To: <20220301110006.4033351-4-mmakassikis@freebox.fr>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 2 Mar 2022 08:12:58 +0900
Message-ID: <CANFS6bYbKX4KQB+A_NFeBZjgpbuKBnR2yM7ozxwkJVmk23g7cg@mail.gmail.com>
Subject: Re: [PATCH 4/4] ksmbd-tools: Fix potential out-of-bounds write in ndr_write_*
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

2022=EB=85=84 3=EC=9B=94 1=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 11:55, M=
arios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> align_offset() may advance the offset at which the data will be written,
> so it should be called before verifying that there is enough room in the
> output buffer.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  mountd/rpc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mountd/rpc.c b/mountd/rpc.c
> index 9d6402ba5281..20a445dea347 100644
> --- a/mountd/rpc.c
> +++ b/mountd/rpc.c
> @@ -294,9 +294,9 @@ static __u8 noop_int8(__u8 v)
>  #define NDR_WRITE_INT(name, type, be, le)                              \
>  int ndr_write_##name(struct ksmbd_dcerpc *dce, type value)             \
>  {                                                                      \
> +       align_offset(dce, sizeof(type));                                \
>         if (try_realloc_payload(dce, sizeof(value)))                    \
>                 return -ENOMEM;                                         \
> -       align_offset(dce, sizeof(type));                                \
>         if (dce->flags & KSMBD_DCERPC_LITTLE_ENDIAN)                    \
>                 *(type *)PAYLOAD_HEAD(dce) =3D le(value);                =
 \
>         else                                                            \
> @@ -377,10 +377,10 @@ NDR_READ_UNION(int32, __u32);
>
>  int ndr_write_bytes(struct ksmbd_dcerpc *dce, void *value, size_t sz)
>  {
> +       align_offset(dce, 2);
>         if (try_realloc_payload(dce, sizeof(short)))
>                 return -ENOMEM;
>
> -       align_offset(dce, 2);
>         memcpy(PAYLOAD_HEAD(dce), value, sz);
>         dce->offset +=3D sz;
>         return 0;
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
