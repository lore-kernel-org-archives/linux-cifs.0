Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF29C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71CE76124B
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244055AbhIYK3S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 06:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbhIYK3R (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 06:29:17 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6EFC061570
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 03:27:43 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id k32so398226uae.2
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 03:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U5KLg838PJLp1Aix5uyTkTRaGGQikAIn6R5nP0nI570=;
        b=XesiVA+J+EmM7oPvJhzbA1QkISA58tGlhTHRYvX9zXWiJk6K88xn4UoROCnPE2NmLK
         GtlsQxV1AWnUsSIpZCM9+kFyD8tZK3amV7QytNiF8GKEhxaANhxsM0db3yjNfINAXXGn
         HzUUEmUMztU2+f8S/fq31C5NsSFmYw8IcUqs8eASo/ohpty6DV0ii2NP6WWJgY/yrkiZ
         NLySP6mtjDCbZtPPItUkstmSpDXreK4UcRy+f/3DD4Ep2VDq2/j9oXw+pHaNAnZZFgjC
         1zYPu1xvdhKxS0+PFd6eLfw44uuQ/RYKftwDAdJsIdfzVrTdusii3j8z7vV85N15Nlfw
         dB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U5KLg838PJLp1Aix5uyTkTRaGGQikAIn6R5nP0nI570=;
        b=LePNAo0+NsicqZf4VUWgtX5HSyieJ4i8zprFgM/sUC+47uUUgaGXtW/zAWSiGQHKeB
         vRQmlu7vm80xnooXCTtvBIqpy5p8OGB7qaVX241FFkxdtaXnhFu3VZbe8yRMNeH4eA1K
         NB9bV31VEF1Cs4fFHQ6iO/ghaVOl2mcGveqVc1oRcjI5HsOl43k6Z9PMl5VvSK75crF4
         AT2Rll1a1SML9rxgfJFWnGpXDlwcFCPO8CLyKoRFMksX5hhZGFMHkixmv9YxzreJaQB3
         jcV4sClqGnPCySDSwovNB3PYUIPu3baX/Dkq4GghniyCoJ9SCKKcy9LbcOeyTo+Ab4lo
         J5OQ==
X-Gm-Message-State: AOAM533/V6uMJDO/Lfoamp7ybhTRmBGLbFhN7y+NJCrR0jHIiCYqbFiv
        YWoUZwwkGo3iPchfZUgbsAhkYo51xKC9AQQfJUo=
X-Google-Smtp-Source: ABdhPJyY+JVYq7q8RD7jjLeiko/e6yqCUu60px+/hPL+c4PyABM7SyvDhsmvzdb4/hmK+sdnEm0OPL8Hf+7Z/x9tu8w=
X-Received: by 2002:ab0:5b03:: with SMTP id u3mr13037776uae.41.1632565662076;
 Sat, 25 Sep 2021 03:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210924021254.27096-1-linkinjeon@kernel.org> <20210924021254.27096-5-linkinjeon@kernel.org>
In-Reply-To: <20210924021254.27096-5-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 25 Sep 2021 19:27:30 +0900
Message-ID: <CANFS6bYOJE12aA+UZpr6ajeu555a23N7F3OS1mgVZKX48AtwFg@mail.gmail.com>
Subject: Re: [PATCH 4/7] ksmbd: check strictly data area in ksmbd_smb2_check_message()
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

2021=EB=85=84 9=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:13, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> When invalid data offset and data length in request,
> ksmbd_smb2_check_message check strictly and doesn't allow to process such
> requests.
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2misc.c | 83 ++++++++++++++++++++-------------------------
>  1 file changed, 37 insertions(+), 46 deletions(-)
>
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index 9aa46bb3e10d..697285e47522 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -83,15 +83,18 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_C=
OMMANDS] =3D {
>   * Returns the pointer to the beginning of the data area. Length of the =
data

Do we need to change this comment about the return value?
Looks good to me except this.
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>


>   * area and the offset to it (from the beginning of the smb are also ret=
urned.
>   */
> -static char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr =
*hdr)
> +static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
> +                                 struct smb2_hdr *hdr)
>  {
> +       int ret =3D 0;
> +
>         *off =3D 0;
>         *len =3D 0;
>
>         /* error reqeusts do not have data area */
>         if (hdr->Status && hdr->Status !=3D STATUS_MORE_PROCESSING_REQUIR=
ED &&
>             (((struct smb2_err_rsp *)hdr)->StructureSize) =3D=3D SMB2_ERR=
OR_STRUCTURE_SIZE2_LE)
> -               return NULL;
> +               return ret;
>
>         /*
>          * Following commands have data areas so we have to get the locat=
ion
> @@ -165,69 +168,52 @@ static char *smb2_get_data_area_len(int *off, int *=
len, struct smb2_hdr *hdr)
>         case SMB2_IOCTL:
>                 *off =3D le32_to_cpu(((struct smb2_ioctl_req *)hdr)->Inpu=
tOffset);
>                 *len =3D le32_to_cpu(((struct smb2_ioctl_req *)hdr)->Inpu=
tCount);
> -
>                 break;
>         default:
>                 ksmbd_debug(SMB, "no length check for command\n");
>                 break;
>         }
>
> -       /*
> -        * Invalid length or offset probably means data area is invalid, =
but
> -        * we have little choice but to ignore the data area in this case=
.
> -        */
>         if (*off > 4096) {
> -               ksmbd_debug(SMB, "offset %d too large, data area ignored\=
n",
> -                           *off);
> -               *len =3D 0;
> -               *off =3D 0;
> -       } else if (*off < 0) {
> -               ksmbd_debug(SMB,
> -                           "negative offset %d to data invalid ignore da=
ta area\n",
> -                           *off);
> -               *off =3D 0;
> -               *len =3D 0;
> -       } else if (*len < 0) {
> -               ksmbd_debug(SMB,
> -                           "negative data length %d invalid, data area i=
gnored\n",
> -                           *len);
> -               *len =3D 0;
> -       } else if (*len > 128 * 1024) {
> -               ksmbd_debug(SMB, "data area larger than 128K: %d\n", *len=
);
> -               *len =3D 0;
> +               ksmbd_debug(SMB, "offset %d too large\n", *off);
> +               ret =3D -EINVAL;
> +       } else if ((u64)*off + *len > MAX_STREAM_PROT_LEN) {
> +               ksmbd_debug(SMB, "Request is larger than maximum stream p=
rotocol length(%u): %llu\n",
> +                           MAX_STREAM_PROT_LEN, (u64)*off + *len);
> +               ret =3D -EINVAL;
>         }
>
> -       /* return pointer to beginning of data area, ie offset from SMB s=
tart */
> -       if ((*off !=3D 0) && (*len !=3D 0))
> -               return (char *)hdr + *off;
> -       else
> -               return NULL;
> +       return ret;
>  }
>
>  /*
>   * Calculate the size of the SMB message based on the fixed header
>   * portion, the number of word parameters and the data portion of the me=
ssage.
>   */
> -static unsigned int smb2_calc_size(void *buf)
> +static int smb2_calc_size(void *buf, unsigned int *len)
>  {
>         struct smb2_pdu *pdu =3D (struct smb2_pdu *)buf;
>         struct smb2_hdr *hdr =3D &pdu->hdr;
> -       int offset; /* the offset from the beginning of SMB to data area =
*/
> -       int data_length; /* the length of the variable length data area *=
/
> +       unsigned int offset; /* the offset from the beginning of SMB to d=
ata area */
> +       unsigned int data_length; /* the length of the variable length da=
ta area */
> +       int ret;
> +
>         /* Structure Size has already been checked to make sure it is 64 =
*/
> -       int len =3D le16_to_cpu(hdr->StructureSize);
> +       *len =3D le16_to_cpu(hdr->StructureSize);
>
>         /*
>          * StructureSize2, ie length of fixed parameter area has already
>          * been checked to make sure it is the correct length.
>          */
> -       len +=3D le16_to_cpu(pdu->StructureSize2);
> +       *len +=3D le16_to_cpu(pdu->StructureSize2);
>
>         if (has_smb2_data_area[le16_to_cpu(hdr->Command)] =3D=3D false)
>                 goto calc_size_exit;
>
> -       smb2_get_data_area_len(&offset, &data_length, hdr);
> -       ksmbd_debug(SMB, "SMB2 data length %d offset %d\n", data_length,
> +       ret =3D smb2_get_data_area_len(&offset, &data_length, hdr);
> +       if (ret)
> +               return ret;
> +       ksmbd_debug(SMB, "SMB2 data length %u offset %u\n", data_length,
>                     offset);
>
>         if (data_length > 0) {
> @@ -237,16 +223,19 @@ static unsigned int smb2_calc_size(void *buf)
>                  * for some commands, typically those with odd StructureS=
ize,
>                  * so we must add one to the calculation.
>                  */
> -               if (offset + 1 < len)
> +               if (offset + 1 < *len) {
>                         ksmbd_debug(SMB,
> -                                   "data area offset %d overlaps SMB2 he=
ader %d\n",
> -                                   offset + 1, len);
> -               else
> -                       len =3D offset + data_length;
> +                                   "data area offset %d overlaps SMB2 he=
ader %u\n",
> +                                   offset + 1, *len);
> +                       return -EINVAL;
> +               }
> +
> +               *len =3D offset + data_length;
>         }
> +
>  calc_size_exit:
> -       ksmbd_debug(SMB, "SMB2 len %d\n", len);
> -       return len;
> +       ksmbd_debug(SMB, "SMB2 len %u\n", *len);
> +       return 0;
>  }
>
>  static inline int smb2_query_info_req_len(struct smb2_query_info_req *h)
> @@ -391,9 +380,11 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work=
)
>                 return 1;
>         }
>
> -       clc_len =3D smb2_calc_size(hdr);
> +       if (smb2_calc_size(hdr, &clc_len))
> +               return 1;
> +
>         if (len !=3D clc_len) {
> -               /* server can return one byte more due to implied bcc[0] =
*/
> +               /* client can return one byte more due to implied bcc[0] =
*/
>                 if (clc_len =3D=3D len + 1)
>                         return 0;
>
> --
> 2.25.1
>


--
Thanks,
Hyunchul
