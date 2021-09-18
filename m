Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B26C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 15:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0500161268
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 15:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbhIRP5U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 11:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237245AbhIRP5U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 11:57:20 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52729C061574
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 08:55:56 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m3so44059303lfu.2
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 08:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eDMHBmaWjaHCIU6sQEEJo6LJuwPDvoeJD8kWUeS2lDA=;
        b=afqhdyjaVKrqe20kYPaKpI33dwH+lZCj4abEXRWs5plGIlOzLgfrvE/8cyKo4CbIN9
         k0V1eqQeAqzuR3zQ2Hfeji7Nv2+CcmL9OHWS2Z7PzEE/nuihyrXEI8Aw/MlLe6czrIo+
         tHAYFlrsMe+o+L9R9csf4728mzJJO9pMp0zaJDoo93nt9ZnI2ZwRRBcmDWeQxNWOHfhd
         vG7C7xutkvFv5cl7CBi9nLjUHFSWUNjXGmZsXqw2M8ld/qeOvuatG5NT49uxJ9RtEfGh
         N1ha0wlu8I7eg1JnnzBoVi5JGHIreaFLKwpZ50tO70DJYe4WYENtjRfBChthFEMm9TYT
         leGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eDMHBmaWjaHCIU6sQEEJo6LJuwPDvoeJD8kWUeS2lDA=;
        b=0iUATE3GWmacTEvjqkWqqmB7w1j+ezdoWaECIpWW5uIBTOzJcyMPnmibgdfCxlEO/R
         dv0lKSEvJftIvaMGuDJGaIEltY7yqweTnt7O0gw4sFSxx4tqXCjir2h8+EFFxm6SKfKq
         LcJQnET4woZ3LVIYf5IhOBUFxgXitVRK5t1yASW79xma6x08aDSGFfW2D/wlMmR9rqwW
         2+shp/lHd9XsOiF3az4IdC/24hMhr2bbmgqmNq139OK5e4fcbA5wsiLipTzmXGJ+BlIF
         ywhCKM0jiFV3kIpgp3jbshUrcdxjBU7E8xj/FLrhQNAHe8vHpeIcHXSy7SMvv3tdSKyn
         2euQ==
X-Gm-Message-State: AOAM5323PgIXfeyP4+Pe8WQW4i8Hw4vZ5v1trp0v+yZjKRJmCtvY4lOK
        uD8wOr8GK9il0nPl2dqpIQz6B4rAmVPyN2oOIt4=
X-Google-Smtp-Source: ABdhPJxGRKLlrfYiZDDWrc+vkwSUIfmoEBAN5AFZxPs78dvhgqfkTmpkVYnZk1tombDHZ3eQWwu2O8dSvDZCepCq6do=
X-Received: by 2002:a2e:4e01:: with SMTP id c1mr14061040ljb.460.1631980554590;
 Sat, 18 Sep 2021 08:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210918094513.89480-1-linkinjeon@kernel.org> <20210918094513.89480-3-linkinjeon@kernel.org>
In-Reply-To: <20210918094513.89480-3-linkinjeon@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 18 Sep 2021 10:55:43 -0500
Message-ID: <CAH2r5mumOAqEgkitSK4yrxithPUUF1d9GihTLQAOdrX8-kK2Eg@mail.gmail.com>
Subject: Re: [PATCH 3/4] ksmbd: add validatioin for FILE_FULL_EA_INFORMATION
 of smb2_get_info
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifsd-for-next (smbd-for-next) after fixing typo in title.
The other three look promising but want to look in more detail at
those unless others have review feedback on those - those patches
include some potentially very important checks.

On Sat, Sep 18, 2021 at 4:45 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> Add validation to check whether req->InputBufferLength is smaller than
> smb2_ea_info_req structure size.
>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index e589e8cc389f..e92af212583e 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -4059,6 +4059,10 @@ static int smb2_get_ea(struct ksmbd_work *work, st=
ruct ksmbd_file *fp,
>         path =3D &fp->filp->f_path;
>         /* single EA entry is requested with given user.* name */
>         if (req->InputBufferLength) {
> +               if (le32_to_cpu(req->InputBufferLength) <
> +                   sizeof(struct smb2_ea_info_req))
> +                       return -EINVAL;
> +
>                 ea_req =3D (struct smb2_ea_info_req *)req->Buffer;
>         } else {
>                 /* need to send all EAs, if no specific EA is requested*/
> --
> 2.25.1
>


--=20
Thanks,

Steve
