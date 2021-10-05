Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FBFC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 10:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F9B16121F
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 10:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhJEKE2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbhJEKE1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 06:04:27 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE48C061749
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 03:02:37 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id f2so22088137vsj.4
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 03:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wKynMVZdgsjn5u7/o6nlzEnvOfoEw4n9ts+6d2y44d4=;
        b=D0No+GQQEYltUTR8VyzQtBybytsQ4vLDpdxObNxTKOcy7kz54zC6UyN7juTvAZKvm8
         lGPkEI2dxYJlhVJSUUL+/D96OQw8M096JV/nQbfPNrf3Z0cuNqKQUJCHLM+lCKNk+VI/
         FeH4Gl54WBt/ftD9+kjfVA8KK9nNK1PIGZuRCN+FaE/ZGJcT2tv65P1ImIzEKgM1BCrJ
         Wp7j4oZBN54ODxBryOWORk+bv8EL/oaHAMTXhf4fTPiyb99AHVBX1bUTjICHdcK/R/IX
         MbGqQZOz0tnUXnzSUVgkYWxCf2dlBZrhhx44PG1akb3HqZmUPXOevPlcBc36OqJ+Uoj9
         286w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wKynMVZdgsjn5u7/o6nlzEnvOfoEw4n9ts+6d2y44d4=;
        b=pPjw9qnNXiQIHvn2l/Ed3i5TYtrmkzz/J78MtbuzfXbxg2AWzNQ1ktoI/+6t6XkN7C
         25aP0DzZftIIahjD2LE2QXyBVGlatNuvUjdbcuH/xMGs2k2BqfKh5+2PBjlCP5ocksDI
         MSnjxI8Kh+DwSb0R6/3wEpI4PLdA5frQi28w2mTVk8gu0J9RhSunV9vngLV+vAcvA0zE
         1ykqOJ333+JvrFbZU7DiDJ168Xsex7wgI4M2Ba/9LnwuDv2ScdJd/n/J5M9pdSVwJvUp
         PEKtEuwrVW4MDkpi/wH1Ox+zMI7pk+DH7ddU6sArweyHDU3ePv+sa9H/Iko9Z2ZdxL3u
         ieSg==
X-Gm-Message-State: AOAM530FyQagSahBS/f0ovP7ZpPa9PkFQXth/ySvz7+9A1mfdyUOE0NR
        2pwgA6+2Oxlik7YCwF9I/nuN4Mg+PSoFan5WcqI=
X-Google-Smtp-Source: ABdhPJwgn8tmoKmclj3JehzM22MM5qfYu+8FVeXUSbwRT2vPo7GpGA/n3vqgwkGNkrIbmx7L9C6Ue0Qhhze5BVvQgdA=
X-Received: by 2002:a67:c088:: with SMTP id x8mr17117596vsi.45.1633428156676;
 Tue, 05 Oct 2021 03:02:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211005012042.4263-1-linkinjeon@kernel.org>
In-Reply-To: <20211005012042.4263-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 5 Oct 2021 19:02:25 +0900
Message-ID: <CANFS6ba5AoY-CGX1iEP-EzOmzqYhtjMJi8rr2Cc_rhD8fZHjOQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: use buf_data_size instead of recalculation in smb3_decrypt_req()
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

Looks good to me.
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 10=EC=9B=94 5=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 10:20, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:

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
>  v2:
>    - change data type of buf_data_size to signed to validate
>      smb2_transfrom_hdr size.
>  fs/ksmbd/smb2pdu.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index b06361313889..bb030e4366ad 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -8452,20 +8452,18 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>         struct smb2_hdr *hdr;
>         unsigned int pdu_length =3D get_rfc1002_len(buf);
>         struct kvec iov[2];
> -       unsigned int buf_data_size =3D pdu_length + 4 -
> +       int buf_data_size =3D pdu_length + 4 -
>                 sizeof(struct smb2_transform_hdr);
>         struct smb2_transform_hdr *tr_hdr =3D (struct smb2_transform_hdr =
*)buf;
>         int rc =3D 0;
>
> -       if (pdu_length + 4 <
> -           sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr)) =
{
> +       if (buf_data_size < sizeof(struct smb2_hdr)) {
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
