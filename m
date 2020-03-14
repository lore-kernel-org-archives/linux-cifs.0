Return-Path: <SRS0=CwqD=5A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84448C0044D
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 01:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5371620637
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 01:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ivlwx8X7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgCOB3T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 14 Mar 2020 21:29:19 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37813 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgCOB3S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 14 Mar 2020 21:29:18 -0400
Received: by mail-ed1-f65.google.com with SMTP id b23so17306049edx.4
        for <linux-cifs@vger.kernel.org>; Sat, 14 Mar 2020 18:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Yg4BFvTg/G9D/BgjHmGWU0qTMOu+JNOa+39l1roZnzQ=;
        b=ivlwx8X7WYImRTQLwnLFgDs+uwXs4ljzqIUpTFuywlN2bmxKTqpy3/BN0tlVwVtYxE
         f34fm4l08MbpjClvnwTJAEmsAAzY+o0AWW8iEhRDAavo2tZOm3Zi685zZmTuT9GdMqHc
         J7pU2V8LUaZyiXEpyCsSAyzhLUC0ql7FPijucB4H7imXwOgvDjiXPEpPtGtnnZzCUlmo
         FIOOeqzxHhBa5FnS8TLPWxMbw1ZBwyQeBnXwYkupC1B+4lnAOUCzni+HgJJMDV7FrDJ1
         1MnzLw6JWkpb+rucYWwifEFaD/nyjiElCApSfu5iVO23czj1k81nxpfOoop5EywQ66ZS
         Lhlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yg4BFvTg/G9D/BgjHmGWU0qTMOu+JNOa+39l1roZnzQ=;
        b=pUwgAoXhEVr3fv9l/IVG3WBy6UKmUu10Ohj/nuQzmqcKxrS7ouBT0mxtRZV7vWNwo1
         CAhr/Aq3DOptJVlmKQ52DvlSoU2cLoJyGIPiLYH8ugkZcA40FLKPd6bEAWy6E6/RzjbE
         hdBIc4JQUOMF1nS2bOcAQGjn+mmekt1eX5mEbebDcl7ArtiyFXm+yK3F6o9DN7HH/pwn
         ikXPUXzjZlxJTEPVqz2N6O5ebfKBExeEQia/ux3teraBbXk5xwLwoTLXGYQTcpoloxWm
         Fp0DD2r3t7v2PeXSIp+JntBYfWs7Du5e9hrkVfNqAt7nb1GKaJ1csrevcDeIZywDonv/
         O+4g==
X-Gm-Message-State: ANhLgQ1Ko0OEf6rUqDeB/YirErYLDlPQJhpqOVpey23A8ZEd37ibXuFl
        h8YzWW7o5SecTqBnP3HDLFE9wDdZOmaDy2hCuAdI
X-Google-Smtp-Source: ADFU+vvoXgGxNCya2wEk2FfqdqLAoMHpLHXtVICm/9z2Bvnplz+Qo5lEbOI0iowOnBfWJEZ5s6yK07Xl/SUMpgZk6tU=
X-Received: by 2002:a2e:8802:: with SMTP id x2mr11651410ljh.291.1584203190455;
 Sat, 14 Mar 2020 09:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200314033831.wm7uwy33j3brdgjp@xzhoux.usersys.redhat.com>
In-Reply-To: <20200314033831.wm7uwy33j3brdgjp@xzhoux.usersys.redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Sat, 14 Mar 2020 09:26:18 -0700
Message-ID: <CAKywueQpONLLM2Z15HNDFTLm9feTpRo+i3E93MPkAPEDog4yTw@mail.gmail.com>
Subject: Re: [PATCH] CIFS: fiemap: do not return EINVAL if get nothing
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 13 =D0=BC=D0=B0=D1=80. 2020 =D0=B3. =D0=B2 20:40, Murphy Zhou=
 <jencce.kernel@gmail.com>:
>
> If we call fiemap on a truncated file with none blocks allocated,
> it makes sense we get nothing from this call. No output means
> no blocks have been counted, but the call succeeded. It's a valid
> response.
>
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c31e84ee3c39..32b7f9795d4a 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3417,7 +3417,7 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
>         if (rc)
>                 goto out;
>
> -       if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
> +       if (out_data_len && out_data_len < sizeof(struct file_allocated_r=
ange_buffer)) {
>                 rc =3D -EINVAL;
>                 goto out;
>         }
> --
> 2.20.1
