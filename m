Return-Path: <SRS0=PPE7=UJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3599FC43218
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 18:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DFEF20820
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 18:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EFEXdP50"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbfFJSls (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jun 2019 14:41:48 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33986 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbfFJSls (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jun 2019 14:41:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id p17so1691972ljg.1
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2019 11:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0e/wXB6iKEf9NA7GLfSgaL66CAw0BN8n2LgazPFsgqE=;
        b=EFEXdP50YvGjiQ+cTlf007oFpVQD5AxybRKQ+qHhK8Pq4Ok0YqK+pIOeYQV1hUpm2x
         2eHol7S5pxsmeVCWUjDKaEYaR8TwMWrdWooXFskXSSgzojS+LqJJEbMm+Oui9Zj/6NzM
         bQm+lv5miKkyvqtwYJ5kpRa/7e+4+l4h7sMiX3WXYmdAQzMw4A9fvQWlLPYu6qXeL01q
         JycPNYaa+XYJGKhTrtPatzKG1AJ7a1FrYwAgA8nUzhmrw8ToabNlHfvfo7eh3ojTMlGh
         PYdUVj7xc2t6WqdG2tDj0EJZK0PkNW2hyqkteUsAjNv2QCCRG6XC9FvUJgfO2DasKyfO
         6IjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0e/wXB6iKEf9NA7GLfSgaL66CAw0BN8n2LgazPFsgqE=;
        b=RjtwwK9w/lZPjpykJed9OGr0JJ0nnX1TM7M2a0JChaOMeyrsFRFIpQZ7vuSi0CKDQS
         eByCrXUPYtR8ZakbzMhEMe5vbjeFELZtcTbCfwkDH72wv1cv2/c1g4RAS9fsDdTEBI6S
         YWn1/yQS2DWLfhwn9SlzSBS+XLiXI0zmG+HBHiGBzE1OVfB1ko2Uoq/q8RAA6t82BDMz
         DBEkMATkPTPJh98guvtRiFocYgymMMG5HBhpiE9Csb3oAntQfLPk56/wp2vkj8VKP9ND
         IRegRIcRIYI1NmGMjVspi1wad+M9qOxLfYzfgSCRHkIEJrCZPn5gxd4DLW02In23eeY3
         sMxg==
X-Gm-Message-State: APjAAAV+ib6XQBt/ZogBMCb5rlBUsJvBcvemH9TjmmXYM4ZPQesagfyE
        LvFk4s6pvQsdPITj9E7In6Rfpf7yIp70c0Mc4dKUtvk=
X-Google-Smtp-Source: APXvYqyNepGwHstN79Fag6D/tkNZK7ffXvlhsB8OugtaMjG8ZSBrc5z8sRyJ5wgcJmlVJCXcBgLjtsRSzklnz5/dHF4=
X-Received: by 2002:a2e:9e8e:: with SMTP id f14mr13105957ljk.120.1560192106798;
 Mon, 10 Jun 2019 11:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvRQj1hyDbBY8DTMtDShr2uxmJqYWWJg+H=iO3RUDc3oQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvRQj1hyDbBY8DTMtDShr2uxmJqYWWJg+H=iO3RUDc3oQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 10 Jun 2019 11:41:35 -0700
Message-ID: <CAKywueRHrFjuJOxPv=L1H2Ju4_A7SPUQ15VzH8DKn9sh3LeCzw@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Fix match_server check to allow for multidialect negotiate
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D0=B1, 8 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 02:06, Steve French=
 <smfrench@gmail.com>:
>
> When using multidialect negotiate (default or allowing any smb3
> dialect via vers=3D3)
> allow matching on existing server session.  Before this fix if you mount
> a second time to a different share on the same server, we will only reuse
> the existing smb session if a single dialect is requested (e.g. specifyin=
g
> vers=3D2.1 or vers=3D3.0 or vers=3D3.1.1 on the mount command). If a defa=
ult mount
> (e.g. not specifying vers=3D) is done then we will create a new socket
> connection and SMB3 (or SMB3.1.1) session each time we connect to a
> different share
> on the same server rather than reusing the existing one.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/connect.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8c4121da624e..6200207565db 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2542,8 +2542,25 @@ static int match_server(struct TCP_Server_Info
> *server, struct smb_vol *vol)
>      if (vol->nosharesock)
>          return 0;
>
> -    /* BB update this for smb3any and default case */
> -    if ((server->vals !=3D vol->vals) || (server->ops !=3D vol->ops))
> +    /* If multidialect negotiation see if existing sessions match one */
> +    if (strcmp(vol->vals->version_string, SMB3ANY_VERSION_STRING) =3D=3D=
 0) {
> +        if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> +            return 0;
> +        else if (server->vals->protocol_id =3D=3D SMB21_PROT_ID)
> +            return 0;
> +        else if (strcmp(server->vals->version_string,
> +             SMB1_VERSION_STRING) =3D=3D 0)
> +            return 0;
> +        /* else SMB3 or later, which is fine */

May be better to check

if (server->vals->protocol_id < SMB30_PROT_ID)
    return 0;

? SMB1 case should work too because protocol_id is 0.


> +    } else if (strcmp(vol->vals->version_string,
> +           SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> +        if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> +            return 0;
> +        else if (strcmp(server->vals->version_string,
> +             SMB1_VERSION_STRING) =3D=3D 0)
> +            return 0;

and here the same way:

if (server->vals->protocol_id < SMB21_PROT_ID)
    return 0;

> +        /* else SMB2.1 or later, which is fine */
> +    } else if ((server->vals !=3D vol->vals) || (server->ops !=3D vol->o=
ps))
>          return 0;
>
>      if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
> --
> 2.20.1

In this case we can avoid nested IFs - should be cleaner I guess.


--
Best regards,
Pavel Shilovsky
