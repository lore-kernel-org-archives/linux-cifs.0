Return-Path: <SRS0=suyG=SL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06026C10F0E
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 22:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3F8620820
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 22:06:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HcNfistb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbfDIWG6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Apr 2019 18:06:58 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34454 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfDIWG6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Apr 2019 18:06:58 -0400
Received: by mail-lj1-f194.google.com with SMTP id j89so215695ljb.1;
        Tue, 09 Apr 2019 15:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3hkkLQawD7Q+Pi2//1qIMQpr5r5mGZHWPalFx05A7i8=;
        b=HcNfistb3+OerOknF3ipzZXSOpJ1e1XtaAbSZtzcGuA7gsEW+o+H4Dn6k7xArnGQjh
         5naWrVINowWsaABKm77o21vTBv6P00Aul8YrT//jew21y6pcnDbbnNv+JtuaqX4C9GUt
         9Y1UWzZPm0sDHWv3VG8p8kgi+Ae/HqwezNRUwDFA2boTOvsjhWdLQGdugdIB5Sida0CG
         I/1pHsKflfHXGu/ROJvg9TgTsbkngMUqPNCBVbS3Q5zkFnQesNRZbcJE0kjYzxs/WFRm
         0Tc/4MmtkC9e8HBO/g371VVpAIE9W9vE80+XOsOmwWMaUm2Cvqq7tNhqX4FEAI5u53HT
         0iLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3hkkLQawD7Q+Pi2//1qIMQpr5r5mGZHWPalFx05A7i8=;
        b=LvpMnhSJRZo4Te9rKBsqC1fkFFIkBE4z41tpiZem6GUw/JCZ8I6YtvcyBhynHEx6AE
         FvxvFQdo1av3lCUnJjQR2QUrxsTwb4a/HWD145DM+v93v4WpVJjk3BgMUSrJ7fmnmoK0
         hn3K97KhJdM0rWrK3gSBrqnPLVL+RQbVdVmc7W6QH/7dNV2UnEghcky0zGJyTaU8lxaz
         SK8HSNjOd6DHHcWN7X62K/htW2Yj+V5XMrZ1+tmIiwm5tMMp89S4wNOwIJgKYmif2V3Q
         GFCX6VqJD3MGHs6QGXJbRJ4UAuLhlZoekAgLIeRw9a3C+5bwYQPhx0IOJaCMSw0Eya9W
         4xrg==
X-Gm-Message-State: APjAAAUulGF7fbd0ABhMp7B/0QWud6wQSVO00t0GL1lyTH4j5DLXRf4m
        yxzM7Qzmwui2cysGEQuPujL7ParlzWdIUNwqHQ==
X-Google-Smtp-Source: APXvYqzDJVI95DIDDlkcRsNU5fer3RB9XOJMlycwRJyW/oVVhsi7+NvEuHjd2XPEL4llm0cO2eUSONB9SEDdx7K3EwM=
X-Received: by 2002:a2e:9703:: with SMTP id r3mr12022906lji.88.1554847616091;
 Tue, 09 Apr 2019 15:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190409214722.27472-1-lsahlber@redhat.com>
In-Reply-To: <20190409214722.27472-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 9 Apr 2019 15:06:44 -0700
Message-ID: <CAKywueTL_oih27aKw=wQzDieCbhf9YA5_JsWS=QApdf82v6UGw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix handle leak in smb2_query_symlink()
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 9 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 14:47, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> If we enter smb2_query_symlink() for something that is not a symlink
> and where the SMB2_open() would succeed we would never end up
> closing this handle and would thus leak a handle on the server.
>
> Fix this by immediately calling SMB2_close() on successfull open.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> CC: Stable <stable@vger.kernel.org>
> ---
>  fs/cifs/smb2ops.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 83a100dd2497..ab4737e3c31f 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2397,6 +2397,8 @@ smb2_query_symlink(const unsigned int xid, struct c=
ifs_tcon *tcon,
>
>         rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, &err_io=
v,
>                        &resp_buftype);
> +       if (!rc)
> +               SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fi=
d);
>         if (!rc || !err_iov.iov_base) {
>                 rc =3D -ENOENT;
>                 goto free_path;
> --
> 2.13.6
>

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
