Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB1EC7EE29
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Jun 2023 19:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjFJTpq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 10 Jun 2023 15:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjFJTpq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 10 Jun 2023 15:45:46 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1122D5F
        for <linux-cifs@vger.kernel.org>; Sat, 10 Jun 2023 12:45:44 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b1a4250b07so33038051fa.3
        for <linux-cifs@vger.kernel.org>; Sat, 10 Jun 2023 12:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686426342; x=1689018342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/hxlwrjczMNQQihwKUFPYs4MHmUJg367619b/acktd4=;
        b=JQbnSemfUxB9fjuSawLG9rGcFSr7bxsH3fu5Xfw+35Rrs8S8GaHoOaZ2LB6UIde4xd
         xsIruudJmACuN7pRVx4E+oaZ1IMmYKCU0Tg0nS1dHMmponckhYL3PYsRplEqbS4sd70m
         UWMAUIxjy7zKJW/7v3oosMhgK8KiivkbKrI8WaAEqRva5dizZuS1nG+Ju0iBOkxrwVDj
         rm+jWqe3Cc8kfBSfQ/hI0ak0yzmDV6g1tJFXokf//xkn5NyvaY/UcQTN8qlMB5x6VyP7
         TPT4h/fxvt6jH7ScsP/15+jdmq9mwVhWm5GPzfpA4c1FD0sFe5RITEoq4Avxs/U7z2ic
         V26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686426342; x=1689018342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/hxlwrjczMNQQihwKUFPYs4MHmUJg367619b/acktd4=;
        b=TGVD0Sab3FkVoNZyIZcXKhEAfTbTcv+soF1HzcR+a5CPFmbUyqMpfVPMwvlcLM78pW
         mpFBiDi6PunYGtFrSnr+HcnlD6CLSJ5w+pdhuyqE2CJGXrpAXlWB8AtZZQ9H6zLuZNAF
         2Yiow75/UI1dw+6BNo72JL3jlzmCSQ1oZuqsPSQEX+9Nhdsc4HmHE9Z4iHPhfKL3rGDj
         Xa/3l9Rjc2sS3MsSwGPk8mrSzolQgcTq4aKLlOnWX0MJwElOQfT+iHpcDdZdrhn4RLY+
         /6KOKeoOyFxw4t+x0XGdjbMl4XKV8jyG0nMyoaC4VRB+o3LGlVCrHUThDja4pfqviNDI
         BVqA==
X-Gm-Message-State: AC+VfDwWXo+MJaI0BJf8ZsRsirmqRaNDiwEi0X1ZYdstcuTX/B5O1ZRA
        f/2Ip/WH+iAh+cL+5bXlOX8nfRlk1k2BSHrQlXzmipM+h64=
X-Google-Smtp-Source: ACHHUZ5ih/bAR0dmfadih5BMp6krsHO75f6I2z4ww4W701CsMHVQc4qsNl4OCO/a/AKvU8Ib01NDUyLzAzBdsIslhCg=
X-Received: by 2002:a2e:a0d3:0:b0:2b1:d4fc:75f2 with SMTP id
 f19-20020a2ea0d3000000b002b1d4fc75f2mr836659ljm.7.1686426342216; Sat, 10 Jun
 2023 12:45:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com>
In-Reply-To: <20230609174659.60327-1-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 10 Jun 2023 14:45:31 -0500
Message-ID: <CAH2r5ms-4CiFHS3nftNqkTLopF+AoJPYr-Yz5wpvfCV3Xe+9Mg@mail.gmail.com>
Subject: Re: [PATCH 1/6] cifs: fix status checks in cifs_tree_connect
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, bharathsm.hsk@gmail.com,
        tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next

On Fri, Jun 9, 2023 at 12:47=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> The ordering of status checks at the beginning of
> cifs_tree_connect is wrong. As a result, a tcon
> which is good may stay marked as needing reconnect
> infinitely.
>
> Fixes: 2f0e4f034220 ("cifs: check only tcon status on tcon related functi=
ons")
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/connect.c | 9 +++++----
>  fs/smb/client/dfs.c     | 9 +++++----
>  2 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 8e9a672320ab..1250d156619b 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4086,16 +4086,17 @@ int cifs_tree_connect(const unsigned int xid, str=
uct cifs_tcon *tcon, const stru
>
>         /* only send once per connect */
>         spin_lock(&tcon->tc_lock);
> +       if (tcon->status =3D=3D TID_GOOD) {
> +               spin_unlock(&tcon->tc_lock);
> +               return 0;
> +       }
> +
>         if (tcon->status !=3D TID_NEW &&
>             tcon->status !=3D TID_NEED_TCON) {
>                 spin_unlock(&tcon->tc_lock);
>                 return -EHOSTDOWN;
>         }
>
> -       if (tcon->status =3D=3D TID_GOOD) {
> -               spin_unlock(&tcon->tc_lock);
> -               return 0;
> -       }
>         tcon->status =3D TID_IN_TCON;
>         spin_unlock(&tcon->tc_lock);
>
> diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> index 2f93bf8c3325..2390b2fedd6a 100644
> --- a/fs/smb/client/dfs.c
> +++ b/fs/smb/client/dfs.c
> @@ -575,16 +575,17 @@ int cifs_tree_connect(const unsigned int xid, struc=
t cifs_tcon *tcon, const stru
>
>         /* only send once per connect */
>         spin_lock(&tcon->tc_lock);
> +       if (tcon->status =3D=3D TID_GOOD) {
> +               spin_unlock(&tcon->tc_lock);
> +               return 0;
> +       }
> +
>         if (tcon->status !=3D TID_NEW &&
>             tcon->status !=3D TID_NEED_TCON) {
>                 spin_unlock(&tcon->tc_lock);
>                 return -EHOSTDOWN;
>         }
>
> -       if (tcon->status =3D=3D TID_GOOD) {
> -               spin_unlock(&tcon->tc_lock);
> -               return 0;
> -       }
>         tcon->status =3D TID_IN_TCON;
>         spin_unlock(&tcon->tc_lock);
>
> --
> 2.34.1
>


--=20
Thanks,

Steve
