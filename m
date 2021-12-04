Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EC7C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Dec 2021 00:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354625AbhLDBCh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 20:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354600AbhLDBCg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 20:02:36 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10A9C061751
        for <linux-cifs@vger.kernel.org>; Fri,  3 Dec 2021 16:59:11 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id r15so8712676uao.3
        for <linux-cifs@vger.kernel.org>; Fri, 03 Dec 2021 16:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G1W6iqHkZBflNIsKZCUFWf5aZOWe1GO9txX3Nyh63Ow=;
        b=ln21d2vskYcDpHYxtPMXVu4vk54/WiuHJ0QxkP3WWHO55yjj4zjjHpg3h1ba87kegI
         DPnR9F1fZc3Z1SNgxTpvEbV4Le1Q/jcSKiOz3tXq2XppPSw/aN2ZR/GgvBYTayDYntju
         HYsQO9VvuZVBCyZGE0nK16L96J3dApMvj4AhfCT8fCaZmQFFXCDVYrXALVCPGhezInzx
         ice2fT95YEG2P34m96vNuq8ti7an73d3MxP8Mvl32S15KcLkvJyHKURzFYDCza1x1Kba
         SowurvAaiFmSLTk5NPllek0oJuGDnFseQEgXlQiFeoqmBiX5EZTWOUqODvI8Axv3zYH2
         wKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G1W6iqHkZBflNIsKZCUFWf5aZOWe1GO9txX3Nyh63Ow=;
        b=qFTziQ3fTyBhYsNFGYs4Irfs6wvX3W3TCiwiyWvKHilrbMYpELdnJAeOAx+gnAwQdL
         VX+H1vbt4xrO3pSjJiBvLPHBypXJkSWYwfQz5Gnu186B4+h0OP1UdDtjWp9HduJ/FA7Y
         Q+tnw/eCU0I6cQ7q5xCRUOR229GJtkKLer+La95Sgn2ywqaifL1f+z+FjU8MlA3gZFiC
         vHhGhNLHPN9tufb7Ct3qWZD+By78wV+S27WEJsoo7Ej0pl/4FtaqXieBKbNoW0MENjlV
         jb+K89ZE5Shqyc04/SriX10fR4GRtaiRNizuGPdHoaaeVkjL8XxQyMKgHABCErix7IC5
         IfQA==
X-Gm-Message-State: AOAM532vU1bNRIGKnAjWQr8Tetyl3f64wjhfNVe/VLIMv/ezfQYVr66a
        HDgxjf9XR/mZtURZEYOBo3xzaUl7ONGZ+eJKgdmh/EXOBC8=
X-Google-Smtp-Source: ABdhPJyb77UO2E9w0oelhE8MXxCvieU0v0kfZPiLoCeepnxDNhruhHpFZXNRI/U78EpkLCr3a6r8OmWcOLWdLFMQVXk=
X-Received: by 2002:a05:6102:2c6:: with SMTP id h6mr25933092vsh.13.1638579550839;
 Fri, 03 Dec 2021 16:59:10 -0800 (PST)
MIME-Version: 1.0
References: <20211201204118.3617544-1-mmakassikis@freebox.fr>
In-Reply-To: <20211201204118.3617544-1-mmakassikis@freebox.fr>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 4 Dec 2021 09:58:59 +0900
Message-ID: <CANFS6bZbiK3NZU+-FxccQwvroZTGgV0Gc8h=r0v=-EsC7PK-oA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Remove unused parameter from smb2_get_name()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 12=EC=9B=94 4=EC=9D=BC (=ED=86=A0) =EC=98=A4=EC=A0=84 1:21, M=
arios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> The 'share' parameter is no longer used by smb2_get_name() since
> commit 265fd1991c1d ("ksmbd: use LOOKUP_BENEATH to prevent the out of
> share access").
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/ksmbd/smb2pdu.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 125590d5e940..1edb536fbf75 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -610,7 +610,6 @@ static void destroy_previous_session(struct ksmbd_use=
r *user, u64 id)
>
>  /**
>   * smb2_get_name() - get filename string from on the wire smb format
> - * @share:     ksmbd_share_config pointer
>   * @src:       source buffer
>   * @maxlen:    maxlen of source string
>   * @nls_table: nls_table pointer
> @@ -618,8 +617,7 @@ static void destroy_previous_session(struct ksmbd_use=
r *user, u64 id)
>   * Return:      matching converted filename on success, otherwise error =
ptr
>   */
>  static char *
> -smb2_get_name(struct ksmbd_share_config *share, const char *src,
> -             const int maxlen, struct nls_table *local_nls)
> +smb2_get_name(const char *src, const int maxlen, struct nls_table *local=
_nls)
>  {
>         char *name;
>
> @@ -2513,8 +2511,7 @@ int smb2_open(struct ksmbd_work *work)
>                         goto err_out1;
>                 }
>
> -               name =3D smb2_get_name(share,
> -                                    req->Buffer,
> +               name =3D smb2_get_name(req->Buffer,
>                                      le16_to_cpu(req->NameLength),
>                                      work->conn->local_nls);
>                 if (IS_ERR(name)) {
> @@ -5381,8 +5378,7 @@ static int smb2_rename(struct ksmbd_work *work,
>                 goto out;
>         }
>
> -       new_name =3D smb2_get_name(share,
> -                                file_info->FileName,
> +       new_name =3D smb2_get_name(file_info->FileName,
>                                  le32_to_cpu(file_info->FileNameLength),
>                                  local_nls);
>         if (IS_ERR(new_name)) {
> @@ -5493,8 +5489,7 @@ static int smb2_create_link(struct ksmbd_work *work=
,
>         if (!pathname)
>                 return -ENOMEM;
>
> -       link_name =3D smb2_get_name(share,
> -                                 file_info->FileName,
> +       link_name =3D smb2_get_name(file_info->FileName,
>                                   le32_to_cpu(file_info->FileNameLength),
>                                   local_nls);
>         if (IS_ERR(link_name) || S_ISDIR(file_inode(filp)->i_mode)) {
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
