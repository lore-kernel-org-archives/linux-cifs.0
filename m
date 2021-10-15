Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62CEC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 23:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B249461151
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 23:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhJOXmG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Oct 2021 19:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhJOXmG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Oct 2021 19:42:06 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223C2C061570
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 16:39:59 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id q13so171274uaq.2
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 16:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WCWcHmyoV0mNBSjA7z1S3JESFHLdEQjdD8qFN+JC728=;
        b=gpnkVq47ctTn/ys327W47t5EEEYr5l2KgNhpnDiX1hRgR+LN9A7iQvYHqnrhcnKoXn
         Ve8vZINsCTd3x6Z3GntwC5x5x//i+AcKwqKpsex67B9e7J2lv0xRKglYzE7MzBVUNifd
         z3OJU0ykwuJukoT3bI3CfHQJV4yilbz1AInTyQqfhg3hiRcqyOlCg8tdPD4BjER8LH1k
         OD1+0Oc7WaC5LWa19DJ1+lv+li9TzSHMIf9qM8B4DZJlNQjDOpYFBt+TU97KhKG0v0VW
         R5TB035p4oyh2/+qXl3vZdW63n5UJVegjAqQ9ILuTA16XFycq5HLkl57trnV4/J/9XDd
         neVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WCWcHmyoV0mNBSjA7z1S3JESFHLdEQjdD8qFN+JC728=;
        b=F7wOE50t4dlTQ2aetD3p3a9nkwZK4VVrWdNHgDUTCgzSTNURNGS9Nu7PHVU8lvahAS
         FXZpLrYffTcUTKBSPIdT3Wjp1alhZUlKrN0EwcYnuoYOykQ7rC/5/9LDX4lmF+TYI8VD
         mzq8yIRUANZsqOGRvxBuoWAlGF0eZrNsxkJDzyHlpFPvQKth8w+s3CPoVq3ndaQgXJPm
         3cVVZwJlpWghjoiBtclT0xu1zzTU18PEq/dMgLQVIhfULzEkYowVgvuq7iHP2tlSfXFG
         tw7hcSh9bClEECHjH5Z65MwyWvPn4MqWMUJO/iiTL0jNBYw2sa0km3x8H/al92xpmxhu
         RTPg==
X-Gm-Message-State: AOAM5314JZ6PWDMg0vyAkIXhYBu7xYiomYFMFZoLXGURUaiMVDP4265f
        /kG5yeorPnfmHdPaffdLiaZfYkmXzMhPAuwu7ns=
X-Google-Smtp-Source: ABdhPJxkKdOMUdZw7jvFIqeNQ+ev9Cs5tEsuYEE98474+DhJB90jOFs1DXFlXHNDTWsm2vwOIzdcn3obwcTev8XzEJE=
X-Received: by 2002:a67:e998:: with SMTP id b24mr17624995vso.58.1634341198227;
 Fri, 15 Oct 2021 16:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211015044553.70582-1-linkinjeon@kernel.org>
In-Reply-To: <20211015044553.70582-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 16 Oct 2021 08:39:47 +0900
Message-ID: <CANFS6bYKR=a8O6jCfKqejo9kpEmU-HXLWeRgr2N4iTyuSvf5og@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: validate credit charge after validating SMB2
 PDU body size
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Ralph Boehme <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 10=EC=9B=94 15=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 5:19, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> From: Ralph Boehme <slow@samba.org>
>
> smb2_validate_credit_charge() accesses fields in the SMB2 PDU body,
> but until smb2_calc_size() is called the PDU has not yet been verified
> to be large enough to access the PDU dynamic part length field.
>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Ralph Boehme <slow@samba.org>
> ---
>  v2:
>   - add goto statement not to skip to validate credit charge.
>   - fix conflict with credit management patch.
>
>  fs/ksmbd/smb2misc.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index e7e441c8f050..030ca57c3784 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -400,26 +400,20 @@ int ksmbd_smb2_check_message(struct ksmbd_work *wor=
k)
>                 }
>         }
>
> -       if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) =
&&
> -           smb2_validate_credit_charge(work->conn, hdr)) {
> -               work->conn->ops->set_rsp_status(work, STATUS_INVALID_PARA=
METER);
> -               return 1;
> -       }
> -
>         if (smb2_calc_size(hdr, &clc_len))
>                 return 1;
>
>         if (len !=3D clc_len) {
>                 /* client can return one byte more due to implied bcc[0] =
*/
>                 if (clc_len =3D=3D len + 1)
> -                       return 0;
> +                       goto validate_credit;
>
>                 /*
>                  * Some windows servers (win2016) will pad also the final
>                  * PDU in a compound to 8 bytes.
>                  */
>                 if (ALIGN(clc_len, 8) =3D=3D len)
> -                       return 0;
> +                       goto validate_credit;
>
>                 /*
>                  * windows client also pad up to 8 bytes when compounding=
.
> @@ -432,7 +426,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
>                                     "cli req padded more than expected. L=
ength %d not %d for cmd:%d mid:%llu\n",
>                                     len, clc_len, command,
>                                     le64_to_cpu(hdr->MessageId));
> -                       return 0;
> +                       goto validate_credit;
>                 }
>
>                 ksmbd_debug(SMB,
> @@ -443,6 +437,13 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work=
)
>                 return 1;
>         }
>
> +validate_credit:
> +       if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) =
&&
> +           smb2_validate_credit_charge(work->conn, hdr)) {
> +               work->conn->ops->set_rsp_status(work, STATUS_INVALID_PARA=
METER);
> +               return 1;
> +       }
> +
>         return 0;
>  }
>
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
