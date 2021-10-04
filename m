Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79092C433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 08:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574EE6115C
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 08:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhJDIkn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Oct 2021 04:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhJDIkm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Oct 2021 04:40:42 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88E1C061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 01:38:53 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id v4so3933199vsg.12
        for <linux-cifs@vger.kernel.org>; Mon, 04 Oct 2021 01:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+afMhA92jcLI2Hhmvq3Z8wJT7Ot3vgKtbaH/Pjm8AYA=;
        b=JxF/ZXT9/4BNbMkwCO0j9Qmjse2aK6+xFG2N7z3i9mAAP5H/bkGO34tDFqX1FPgioC
         l1MZyY50yxm6rojM/2CwTJVRod9wpRlHNCvYKX6Cr7yFodogQd0ew4Lkbyr1jZTifK0c
         8KDy8si0TNMa31WaPQvW1HgLpYN7rP819IdO4k/+xrcIuiBdITAKZq6WRnYGgNSQ9CVH
         culaGy8pHz2ZVtiYgwBxH+XE3aisxbOVJZ18EiCJTpm4dscGk0jx6mOJJgC+wVg9cz9N
         SOZNKhB83Sa+NVk4WAG3DZjER+y4LFGqQpJ54D1qcgGH0ncPbqDQSehoL+aqcBNVHRJl
         SkZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+afMhA92jcLI2Hhmvq3Z8wJT7Ot3vgKtbaH/Pjm8AYA=;
        b=dMJme5V4TJ+eoorggW/OLhwFjjZW4NwspcLOzFcowSbhuixQD/EM2YRf5uLUJ9iJ6A
         dPnfq9lT/LLUYpqwCXD+kQprYxrMnKZVD3iggJtX+0As464tU4zrz8CUvMVL9KWVoSpa
         8Xbk1vNjCZEcBYqcOTF2ObVRaLrZbq2SAstD8+cQXkO26zfD/fciiOJ1orQkObyE9z7p
         UEGQGq8J/ofUvqsugdJXVQpNxbRbWpO2gMsSIj3Qi8DLEuv3E90tWxR6/Wb0d/oez7e0
         tA6ef3b/BK60oyK3t3H02QQECFbR/lsoFjqaYJeuAFucjrkohFbBMqRKpkysa1aG9kYF
         oUWg==
X-Gm-Message-State: AOAM530jTvUM9xxdkboQqQKA0kYYhnqfZ+rcl3JMydsQH1h9ig1cqDdP
        nr7/tLrStqp6qNoZ1CU029EjKsxFq1vA4InlU3Y=
X-Google-Smtp-Source: ABdhPJwVOpzAMhjuVTk8mC68HbdSn/ey7EY8r2GEv1sc8uhahcmQWXpZ5tKTOUOTc+4BGsTjPpY7UxUfchROdQN0FPI=
X-Received: by 2002:a67:c81a:: with SMTP id u26mr747325vsk.27.1633336733083;
 Mon, 04 Oct 2021 01:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211003043105.10453-1-linkinjeon@kernel.org>
In-Reply-To: <20211003043105.10453-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 4 Oct 2021 17:38:42 +0900
Message-ID: <CANFS6bb+hqid_YvkkSnMajwsQeOF_6NFke5ffuRVnPVoiHdKug@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: use buf_data_size instead of recalculation in smb3_decrypt_req()
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 10=EC=9B=94 3=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 1:31, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Tom suggested to use buf_data_size that is already calculated, to verify
> these offsets.
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Suggested-by: Tom Talpey <tom@talpey.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index b06361313889..4d1be224dd8e 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -8457,15 +8457,13 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>         struct smb2_transform_hdr *tr_hdr =3D (struct smb2_transform_hdr =
*)buf;
>         int rc =3D 0;
>
> -       if (pdu_length + 4 <
> -           sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr)) =
{
> +       if (buf_data_size < sizeof(struct smb2_hdr)) {

Could integer overflow occur when buf_data_size is initialized?
buf_data_size is initialized with "pdu_length + 4 -
sizeof(struct smb2_transform_hdr)".

There was the check that the pdu size is greater than at least
__SMB2_HEADER_STRUCTURE_SIZE at ksmbd_conn_handler_loop(),
But I can't find this check in the latest patch set.


>                 pr_err("Transform message is too small (%u)\n",
>                        pdu_length);
>                 return -ECONNABORTED;
>         }
>
> -       if (pdu_length + 4 <
> -           le32_to_cpu(tr_hdr->OriginalMessageSize) + sizeof(struct smb2=
_transform_hdr)) {
> +       if (buf_data_size < le32_to_cpu(tr_hdr->OriginalMessageSize)) {
>                 pr_err("Transform message is broken\n");
>                 return -ECONNABORTED;
>         }
> --
> 2.25.1
>


--
Thanks,
Hyunchul
