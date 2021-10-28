Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD12C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 23:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1674F610A4
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 23:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhJ1X7a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Oct 2021 19:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhJ1X73 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Oct 2021 19:59:29 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B83CC061570
        for <linux-cifs@vger.kernel.org>; Thu, 28 Oct 2021 16:57:02 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id z22so12493645uaq.12
        for <linux-cifs@vger.kernel.org>; Thu, 28 Oct 2021 16:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xhNcZSlJDduUlHwB5TzYi6IdunLaUYgdnsb5cn5YG3o=;
        b=Ja9qbAcJUjTiE2wzxERS0JOh8Vpr2bdl3IZiMXPg8YeQGQwzAwE7E/amfMXFT1qyg0
         L5Zbhuy7yEtHGkbt7T4RoiY7djKZdHCx02W6Cj2+e/eIMtaAmEV08ByQiVq6htkoznRj
         uZqDV9Qr9tNCJmnNuzTpYld4RESuh12z/1heet0cqgPIbrL10Fkt4OkvnejDVeLmF6KB
         3Pvw6pencIsIlDgnQR1bGeP9O8h2bP+Ytu9/IdgCtlDOudfZQniyqYCFG3PquW7Vdo1i
         ozDqjbG+CeDhJB7Zg4cosNzibjPR/5KnbZGQPNfYF8Onf/u7lBWKM5HK2JXA7gQ/sZiu
         CT4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xhNcZSlJDduUlHwB5TzYi6IdunLaUYgdnsb5cn5YG3o=;
        b=OGDzKTG6Ya8ZaRV04yTjz8HRuAWoDlGIZDm8v1Hzk+R8bMTpM9QeaBX8NVDRO/QPer
         Sp/CIMnsc/9iRKdWDmx9r4fEBUgZ3JPMPR2Hk4UAVlLOBj7jgH+hR/ONy7K/EWhgQ0VK
         i/nKLsmhis84Wk9w6xhM9m2KKzMLybPGpuAejDwvYEBQQMO2Ga9LPlqYqfq5QuCJDmhx
         ERZgFQkTzibcC+E7Q/D9m/WQcJpUug6Gc3aP4LKcJdIyGQ3WlSGpfecPsEYgY7pEn2U6
         Az06Qdijl7YSZWmz5Ws+Gpamf94fYOBYkirU9FOWxirmv1sWRnFjSwaVihCK+vq1OaPP
         hctA==
X-Gm-Message-State: AOAM532gVLtoOs9GpsxCAwY1VECOkLJpowfldDzDZpc0sc06A5N8h67W
        wm8vOe4W0JUGlm1mni9ETvbibsw7ML5+VnKzpmliyBf/Xek=
X-Google-Smtp-Source: ABdhPJyezO8INqlv19X30ja7xhR5DljuXwABfTNDaGvzAqmg03lGVtVoi1+jbhfco199GntVii/eQ/PrjXTidIk11l4=
X-Received: by 2002:a67:c19d:: with SMTP id h29mr8856595vsj.18.1635465421246;
 Thu, 28 Oct 2021 16:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211028190125.391374-1-mmakassikis@freebox.fr>
In-Reply-To: <20211028190125.391374-1-mmakassikis@freebox.fr>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Fri, 29 Oct 2021 08:56:50 +0900
Message-ID: <CANFS6bYYpxzNjakeQ6GRMwAAd0rzaF2sgcpbZ5Qd3pOVmKpS5w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Fix buffer length check in fsctl_validate_negotiate_info()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 10=EC=9B=94 29=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 4:02, =
Marios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> The validate_negotiate_info_req struct definition includes an extra
> field to access the data coming after the header. This causes the check
> in fsctl_validate_negotiate_info() to count the first element of the
> array twice. This in turn makes some valid requests fail, depending on
> whether they include padding or not.
>
> Fixes: f7db8fd03a4b ("ksmbd: add validation in smb2_ioctl")
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
> This causes mounts to fail on older kernels (v4.19 on debian10) when
> specifying vers=3D3.0.
>
>  fs/ksmbd/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 7e448df3f847..a03b53df3f04 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7312,7 +7312,7 @@ static int fsctl_validate_negotiate_info(struct ksm=
bd_conn *conn,
>         int ret =3D 0;
>         int dialect;
>
> -       if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
> +       if (in_buf_len < offsetof(struct validate_negotiate_info_req, Dia=
lects) +
>                         le16_to_cpu(neg_req->DialectCount) * sizeof(__le1=
6))
>                 return -EINVAL;
>
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
