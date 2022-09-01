Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AD4ECAAD2
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 06:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiIAGIp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 02:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbiIAGIl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 02:08:41 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5124114C61
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 23:08:40 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so728875wmk.3
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 23:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=Xt7+U8XSH06YbMQlKMCUWLT/lAtd088oSyM1uET5dfc=;
        b=EkVPlwaDoG4VulZFCN/jmByRqFCpJd4QqM2w4oTGpFRSDVBQNSTKUIKEOcMkEFY6ke
         LVi79NqG21TTv2ByM5PshIqezq/sjKSQHkDrIkolNM3ynO7ftF7Pt/6nmiw/i0a/yQyc
         J+x67z8rqjjw/56kgToRmorIs9LdEbDVK/pyV8mUouqJVRcFfVIA+p+O8jYlfPhV7dOc
         ZTzdTNSA3FNwGpqj2XKPcd/GVaR4n9RujCdM+8GJRtNQLnHFessOgWH3kmSL7Kv5tnpd
         YwNSTIAfZMRISs7UPbciwtHNQoc5qaO2E0FnPsWSGpsMxIrazHj6Xcwxsw6PX6gzJ2Vi
         BLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=Xt7+U8XSH06YbMQlKMCUWLT/lAtd088oSyM1uET5dfc=;
        b=SI1tY2wHfzTKOv9F2uWCIAlVZUJiZJjzAPIkHHGkbfZwY+7u9vvd8EDq9OZOh3URjv
         J92NuuZXYZL3wlLzr0Owszp5rCZB9hCgViJ68komOMX3PvRhhXc9lBZcSNtiy1OU01W/
         3VGB5jBsmVM9AcWxx0zmU9HQ1xT6gRk80Ng0RvLwOSRG85kWv2sd38u1wvyMvTMh4PE+
         qQudwB52NcTD0iKBIR32diLKK+TBlDzNgG6IYamwcrT1MeVHZj6GCFEFWbKmG2jMgcKk
         R9F7b5Q9teOAVl4sjSPxZP43oiZQ5W5vpHk31qFSAPJlFMy07FpZlL6eEqgmUQDHbaDP
         UZLQ==
X-Gm-Message-State: ACgBeo15oK5Pw3R8gDLLkOiVFnodPzpnbLZ/M27qVR9ubeoqlCuPRpm7
        GN1j93EdEGb1aNWbY24bnzqilca/FyOSGjTT66g=
X-Google-Smtp-Source: AA6agR6U6BBgPlojax9DGqXRmt4QNaFZHDcJxSwKQUdRvtVkHpM9U/BqagkxBR0y4td1zit0MVZm6uera846fBNrO10=
X-Received: by 2002:a05:600c:15c5:b0:3a5:b800:3c53 with SMTP id
 v5-20020a05600c15c500b003a5b8003c53mr3945553wmf.176.1662012519279; Wed, 31
 Aug 2022 23:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220830141732.9982-1-linkinjeon@kernel.org> <20220830141732.9982-2-linkinjeon@kernel.org>
In-Reply-To: <20220830141732.9982-2-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 1 Sep 2022 15:08:28 +0900
Message-ID: <CANFS6bZ6gKyfkPrFLaifu7nhOGkKJBgqpNNZ+gB5w9O5tCZRPw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: remove generic_fillattr use in smb2_open()
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 8=EC=9B=94 30=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 11:17, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Removed the use of unneeded generic_fillattr() in smb2_open().
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ksmbd/smb2pdu.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index c49f65146ab3..ad6410874b95 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2761,7 +2761,6 @@ int smb2_open(struct ksmbd_work *work)
>         } else {
>                 file_present =3D true;
>                 user_ns =3D mnt_user_ns(path.mnt);
> -               generic_fillattr(user_ns, d_inode(path.dentry), &stat);
>         }
>         if (stream_name) {
>                 if (req->CreateOptions & FILE_DIRECTORY_FILE_LE) {
> @@ -2770,7 +2769,8 @@ int smb2_open(struct ksmbd_work *work)
>                                 rsp->hdr.Status =3D STATUS_NOT_A_DIRECTOR=
Y;
>                         }
>                 } else {
> -                       if (S_ISDIR(stat.mode) && s_type =3D=3D DATA_STRE=
AM) {
> +                       if (file_present && S_ISDIR(d_inode(path.dentry)-=
>i_mode) &&
> +                           s_type =3D=3D DATA_STREAM) {
>                                 rc =3D -EIO;
>                                 rsp->hdr.Status =3D STATUS_FILE_IS_A_DIRE=
CTORY;
>                         }
> @@ -2787,7 +2787,8 @@ int smb2_open(struct ksmbd_work *work)
>         }
>
>         if (file_present && req->CreateOptions & FILE_NON_DIRECTORY_FILE_=
LE &&
> -           S_ISDIR(stat.mode) && !(req->CreateOptions & FILE_DELETE_ON_C=
LOSE_LE)) {
> +           S_ISDIR(d_inode(path.dentry)->i_mode) &&
> +           !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
>                 ksmbd_debug(SMB, "open() argument is a directory: %s, %x\=
n",
>                             name, req->CreateOptions);
>                 rsp->hdr.Status =3D STATUS_FILE_IS_A_DIRECTORY;
> @@ -2797,7 +2798,7 @@ int smb2_open(struct ksmbd_work *work)
>
>         if (file_present && (req->CreateOptions & FILE_DIRECTORY_FILE_LE)=
 &&
>             !(req->CreateDisposition =3D=3D FILE_CREATE_LE) &&
> -           !S_ISDIR(stat.mode)) {
> +           !S_ISDIR(d_inode(path.dentry)->i_mode)) {
>                 rsp->hdr.Status =3D STATUS_NOT_A_DIRECTORY;
>                 rc =3D -EIO;
>                 goto err_out;
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
