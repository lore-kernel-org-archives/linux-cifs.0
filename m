Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E39BBC7EE29
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Jun 2023 19:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjFJTtg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 10 Jun 2023 15:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjFJTtf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 10 Jun 2023 15:49:35 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D6530ED
        for <linux-cifs@vger.kernel.org>; Sat, 10 Jun 2023 12:49:33 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f624daccd1so3391232e87.0
        for <linux-cifs@vger.kernel.org>; Sat, 10 Jun 2023 12:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686426572; x=1689018572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dhjem3loLcN8pTSS0k+ToFrbb8uUCXqf+dt4x9dBS5o=;
        b=RYPcxciKZeE/4OzrV7ZlN/ULsNZRtvxlF0Cp3ihQKxaYrGSzHy8JnyOSjxxLDLe2jc
         QqQcjB4duEp9W/JLsq6VY/fgjeKJBgzLrRSHvuO9I9M+nQ7fYoVDD/mUbNMwztYy5uZ2
         GZFcU+pDKyeSt5PgA3iE7A/hbNiO6X71Elo1En3c9iBIDy8C6yEsygGhhA/qy24KWe7S
         X5PQxot4P+UCWsfuP6pc3pFzUiqk5OAZAJ3Rc/gJf6pcHv+2y+XtnZQjE/6ckdQAI4eB
         lB+3JwJ2g4nSArvp+XAuhpia23WeLwGEvVD+LL28MWU0txAHXAYJj/6g/n4H+iWjQ7nh
         0MYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686426572; x=1689018572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dhjem3loLcN8pTSS0k+ToFrbb8uUCXqf+dt4x9dBS5o=;
        b=if+Yo6+oCP14+FD1JIpwtSvZV1/TDjWrSQ6b2FtTqNniG2QyVlAHkjYn+SIfazt0it
         zNNW0G5jtCFRTlK4RNWe29E0142vhLWZw2mlzushmIp2u9AvuIWIwD3/OBN2IKn6xX4g
         UnTQ04+ZNOHTBfnD09PaIrkkuT+NAT4x/2kqORHkBuyoM1nu8+eQSmog3GTtGUGGM1TV
         3gs+kmzZ8nKXsokGD/I1fqDuYpSmsvBp+y+g+mBy4CgSBDf/ZsfQp9ByYt6yrsNN4bAr
         eYTekVJTVQx71vPpg4EN0ZIGg/S+rgWnTVcNicCPpeVdnj6QIJ0/2+cPXG9I84zWzYbZ
         NM9g==
X-Gm-Message-State: AC+VfDxuo0tOBLXU1vQABdBWUEGbBBPE2AMru10ENtNBhOjtmof+8Ow1
        dOrmKDLcJznMwmT9plz805YcEt5tQhg/xYGDLH8=
X-Google-Smtp-Source: ACHHUZ6SUQpOmuNucicAzjs6+jN4nR21DMFJ1PE+vF8KVpv3QYMO677pDT3rIT5izmezJJPaJ6jx8IrRG0SDZzeN5LI=
X-Received: by 2002:a19:770b:0:b0:4ec:a18e:f989 with SMTP id
 s11-20020a19770b000000b004eca18ef989mr1863074lfc.17.1686426571697; Sat, 10
 Jun 2023 12:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-3-sprasad@microsoft.com>
In-Reply-To: <20230609174659.60327-3-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 10 Jun 2023 14:49:20 -0500
Message-ID: <CAH2r5mtKozDLH+y-6ASL1mb_v5g9=TxjekRGO=L_AxJjfhrKnQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] cifs: add a warning when the in-flight count goes negative
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, bharathsm.hsk@gmail.com,
        tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

should this be a warn once? Could it get very noisy?

On Fri, Jun 9, 2023 at 12:47=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> We've seen the in-flight count go into negative with some
> internal stress testing in Microsoft.
>
> Adding a WARN when this happens, in hope of understanding
> why this happens when it happens.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/smb2ops.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 6e3be58cfe49..43162915e03c 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -91,6 +91,7 @@ smb2_add_credits(struct TCP_Server_Info *server,
>                                             server->conn_id, server->host=
name, *val,
>                                             add, server->in_flight);
>         }
> +       WARN_ON(server->in_flight =3D=3D 0);
>         server->in_flight--;
>         if (server->in_flight =3D=3D 0 &&
>            ((optype & CIFS_OP_MASK) !=3D CIFS_NEG_OP) &&
> --
> 2.34.1
>


--=20
Thanks,

Steve
