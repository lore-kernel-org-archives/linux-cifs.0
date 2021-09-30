Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1858BC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 01:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDE0F617E1
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 01:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347570AbhI3BlR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 21:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhI3BlR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 21:41:17 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5640C06161C
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 18:39:35 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id z62so5373744vsz.9
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 18:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CsSgRijdWJHlCM3E6otnepNY9rY4xvrkiiqN0pUeDwY=;
        b=fDLV1mm67sqFgaCJu1ETcP5utUkP7lAiYAFSUlP5mQvKUMrlgkDGIjPFKHHqEeNPfB
         m0qqNuIpk7ZG3uJ4gwBL63VKlzlui4bHxSYUU+emBrfbOj4xpblnSp1KJ4L5ZXQeh7Gn
         gaPBMldYO+T3q5GdwGVn+uFYowXGCKcH5wIgFmanzieaPxPd8tlrEcimVRtvWe3X48lN
         Tglu8f/S71O90Ix8mZay9OfNj6bDilTBrIGwd4pJ9/BP6XP1Nwv/IAy+sSjqrcuguQff
         +YhIaCxJZTcx4YEwQSLQ647R/ONmsH8TPozfdWx/qqCEKkG8jtzR8F/YSE5/1svsV24P
         7rGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CsSgRijdWJHlCM3E6otnepNY9rY4xvrkiiqN0pUeDwY=;
        b=DBn33DWa/SuftOEy30ljrCsiNLl5S9OKZYGoJzG9XhDUr4qRgXIqAdrqbgklSm86UA
         UET+EanhwJ/d5a19fQRRB6cruhPqZ0Y3VKkVbDxmhtN2OMlMMAR3NOTWOoxG+a/9n9gz
         OgsCyvYPjS2ue3SEkzoTmJx54kO0HclUNE9fLexCUqj3MR3Z/AfX4xRxX/eiLJm9VYop
         ZrNlCwICvV3o6OVwrUQnK56gG6Sn88ZIJ+XBVCA4uCkIyM+HQYcW+VqH4czPeDrHjbHq
         DFWUJODg3Ic3fwOlndsH3T14E+UTvNHdF0HSvvBA748ufDUS53LEznqVqUsOmCaUrW8y
         VvCg==
X-Gm-Message-State: AOAM533JBKDiD4MOoSXk+ytO4WjOR98wbblU/y/lFT79LeZYMzKve1yi
        zoFc+Tu0T77ZUVQJ8HK3IIS39XHzvBMNtquLccg=
X-Google-Smtp-Source: ABdhPJzPBuXoLGK63CER+utpcMm4Ifw/j7VPUcXAgJqEUn7i8R6ZBBbEIKUVHL8mkFsdA3BqGWQqvSyG1ehAzG/ND6M=
X-Received: by 2002:a67:c088:: with SMTP id x8mr1465966vsi.45.1632965974764;
 Wed, 29 Sep 2021 18:39:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210930012108.12396-1-linkinjeon@kernel.org>
In-Reply-To: <20210930012108.12396-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 30 Sep 2021 10:39:23 +0900
Message-ID: <CANFS6bZmGQMhp4G6FGeJ4cAsLV=HmusRMPqXct_6HJ4xpoPYVw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix transform header validation
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 9=EC=9B=94 30=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 10:22, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Validate that the transform and smb request headers are present
> before checking OriginalMessageSize and SessionId fields.
>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Reviewed-By: Tom Talpey <tom@talpey.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  v2:
>    - reword patch description.
>
>  fs/ksmbd/smb2pdu.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index ec05d9dc6436..b06361313889 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -8455,16 +8455,8 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>         unsigned int buf_data_size =3D pdu_length + 4 -
>                 sizeof(struct smb2_transform_hdr);
>         struct smb2_transform_hdr *tr_hdr =3D (struct smb2_transform_hdr =
*)buf;
> -       unsigned int orig_len =3D le32_to_cpu(tr_hdr->OriginalMessageSize=
);
>         int rc =3D 0;
>
> -       sess =3D ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->Sessi=
onId));
> -       if (!sess) {
> -               pr_err("invalid session id(%llx) in transform header\n",
> -                      le64_to_cpu(tr_hdr->SessionId));
> -               return -ECONNABORTED;
> -       }
> -
>         if (pdu_length + 4 <
>             sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr)) =
{
>                 pr_err("Transform message is too small (%u)\n",
> @@ -8472,11 +8464,19 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>                 return -ECONNABORTED;
>         }
>
> -       if (pdu_length + 4 < orig_len + sizeof(struct smb2_transform_hdr)=
) {
> +       if (pdu_length + 4 <
> +           le32_to_cpu(tr_hdr->OriginalMessageSize) + sizeof(struct smb2=
_transform_hdr)) {
>                 pr_err("Transform message is broken\n");
>                 return -ECONNABORTED;
>         }
>
> +       sess =3D ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->Sessi=
onId));
> +       if (!sess) {
> +               pr_err("invalid session id(%llx) in transform header\n",
> +                      le64_to_cpu(tr_hdr->SessionId));
> +               return -ECONNABORTED;
> +       }
> +
>         iov[0].iov_base =3D buf;
>         iov[0].iov_len =3D sizeof(struct smb2_transform_hdr);
>         iov[1].iov_base =3D buf + sizeof(struct smb2_transform_hdr);
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
