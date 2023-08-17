Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B45C27C7A
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 09:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjHQJnE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 05:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbjHQJmc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 05:42:32 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7012D66
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 02:42:30 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4ff93a7f230so863617e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 02:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692265349; x=1692870149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHHlS+pk0mCHCjGphBweWiOV3/q0xsOg3g0ajcesSsw=;
        b=b/J5njzUe4w69aFGtNoNOeA4gZpv+pax86mck9Z/TiQHoaCYKF8n7KpMMUhQ/Y9Ft1
         B+/ixLXcPQsrNmhx/UwaGyxvPJuHAsk4H98SdrxBS7/snSK0C0BY9lzUSq49q+16Sb5b
         ltwq/X/PnwhFdy8XQVJxaM8kfNf19aS1CxDGwUJ4xhAZnWq6wAd0VK52+GieH5pzCWmq
         5PeczNcrnEYUn0fCZmWtkpUpBhKVDovkmgzFltFmfpK8yZN0OZTqBkkdwkp4rzSqdOpj
         gnb7E5KLaHnsw2mF+ZpfF5Ry6JjdWjClgSxl1WRAMvorZdJJXF0RXqp7Du3y/JOCCFtr
         onKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692265349; x=1692870149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YHHlS+pk0mCHCjGphBweWiOV3/q0xsOg3g0ajcesSsw=;
        b=iFpCWy0m0qTbm9NMpHM+1kafjpggbk50hZcqqbl8PS5NToHfiupWOmPkIIu2JBNZIf
         EATUdZl0yGyRbvBk+z9hYoEt7ZrkMEcjnqXqvFxP+H8OgM7Ih/KNjtZQTcT5BoUy9OTg
         vpXTBJ+gmFyaldRYLGvQ3m8JYNEljEDz/l156ve0VGiyywVQihlMXJUsQmJh9ghjb7E5
         iHcpYv49JfDxBaWUr0np3J1rGq/LwMa0UGuWIQNG6tycB6jmXUzjCUFpRJr/GEooa/NZ
         /mxoYnDck5QgQ2ZoUkxawb/ATiDuoOQTCKSE3/3sHVLqYELwaEQRgkM7kntmtES8lujo
         Wm5w==
X-Gm-Message-State: AOJu0YxJavWfFGykq74+1YMGWBQeMqgiY8u+U+zcbmRMWw3mCvNMC3U8
        39Cp95Ht7gpII7qCh/MblnVOzw3ZCyeYfwZW9Nk=
X-Google-Smtp-Source: AGHT+IEhXGrf5vYlEQ/t+epEaWWnZscVL2FrQho8rsa6Xc1Qhp3nKhxTW5AtEa1J47aNrWh43+M+ylrloYO384kyFcc=
X-Received: by 2002:a05:6512:3d01:b0:4fe:d15:e1d2 with SMTP id
 d1-20020a0565123d0100b004fe0d15e1d2mr755393lfv.12.1692265348698; Thu, 17 Aug
 2023 02:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230816202638.17616-1-bharathsm@microsoft.com>
In-Reply-To: <20230816202638.17616-1-bharathsm@microsoft.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 17 Aug 2023 15:12:17 +0530
Message-ID: <CANT5p=ocZ1V-0buA7i8fJXYCMdWi5MZjQbvRJugmKMp+SHBpRQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: update desired access while requesting for
 directory lease
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     pc@manguebit.com, sfrench@samba.org, sprasad@microsoft.com,
        tom@talpey.com, linux-cifs@vger.kernel.org, bharathsm@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Aug 17, 2023 at 1:58=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> We read and cache directory contents when we get directory
> lease, so we should ask for read permission to read contents
> of directory.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index fe483f163dbc..2d5e9a9d5b8b 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -218,7 +218,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon,
>                 .tcon =3D tcon,
>                 .path =3D path,
>                 .create_options =3D cifs_create_options(cifs_sb, CREATE_N=
OT_FILE),
> -               .desired_access =3D FILE_READ_ATTRIBUTES,
> +               .desired_access =3D  FILE_READ_DATA | FILE_READ_ATTRIBUTE=
S,
>                 .disposition =3D FILE_OPEN,
>                 .fid =3D pfid,
>         };
> --
> 2.39.2
>

Looks good to me.
Should also CC stable.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

--=20
Regards,
Shyam
