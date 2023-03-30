Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D61C6FD1D
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 22:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjC3W7T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 18:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjC3W7S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 18:59:18 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D979AD33C
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 15:59:16 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id q16so26576145lfe.10
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 15:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680217155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfjM+XODcj+oHwq+6wJrP+uX94ecxMxBEx84nk6VEVs=;
        b=hitfvgiAu2L6q1XAaZAHr1dhr8M1g1/PLMVopYzG64bScwgerljsgWF2IFIcUwdtfu
         pD2OJLOZIr74ke8zsND6+ZJ4g5vzpNVZq9JCUfCBJnPUI8n8H65kvGycHZ2cjeMNsxqC
         h9HvN1RvHKhYXW6xugApXNYn5js50kP4m8fafbXnvF6WJmh15nZ3uDYE319uZN/YfQNH
         OjhsDSY12LlQJuTclrw+QH1WNX8fcDyC+o9l+huVEes2Rcl/ArTQyxfM5yjJZjbX2NXU
         +b3tJgc4TTOpW9mE/4dJxuQHzpegK/EcQORLRdiqBiQCM/U9nU1HBmuXP9gv+9VmQ2Ss
         mg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680217155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sfjM+XODcj+oHwq+6wJrP+uX94ecxMxBEx84nk6VEVs=;
        b=LGihkspT1Rqu7+uZ/35lf05vYuWNkt4kUUUTR124FZ1oIpbgViUbC91zc+p+7vdJYN
         7Ng5ChHd009/jIt610II4P7ZI5/SKlM0riu4/RWXppwMBFC1PuwQHNvxt6wK4POFpWrj
         sSK2r10SUaOF1q070q5YS8FcMwZUQ4HycpoLuoxfIoVn+Uoy9li5uvG4v5ppF7i4ckBn
         FMKqrXkb2jepb450sG4ZfzSyJeGCCh9GhoxY+rrLrwnDDSweIMFDqiXp0Rs3401KmDuy
         xItkXU72vICuEX2eycF2a7xs8vtm8nYngeuCSFnF02nFmStKLdkpUfZRxqYfuVI19PFX
         VP+g==
X-Gm-Message-State: AAQBX9evW5gTBuDagK/9rA/eVhgeL2eWofh0sBvM80Sb+yP4r1pe1rWj
        eg/7FoVkGVt9tBIfd7SrkA1yoOy8519iQyObt5iOpnAE
X-Google-Smtp-Source: AKy350YyTErfArCo2Fbu1yFThHM63mwQpG9rk7RFkLR2dTzfY4k7Wpkhau3tov9i1fvGzwYCnzj6v4a/U8pQaRpBwX4=
X-Received: by 2002:ac2:5ed9:0:b0:4e9:a3b7:2369 with SMTP id
 d25-20020ac25ed9000000b004e9a3b72369mr7536352lfq.7.1680217154923; Thu, 30 Mar
 2023 15:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230329201423.32134-1-pc@manguebit.com> <20230329201423.32134-3-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-3-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 30 Mar 2023 17:59:03 -0500
Message-ID: <CAH2r5msbAB0L9=S0Bwy6txLesKp2E7Ab2wAX5SLmXaPcB-tf0Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] cifs: avoid races in parallel reconnects in smb1
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added ronnie's RB and merged into cifs-2.6.git for-next (I will hold
off on patches 1 and 2 since they are cleanup until 6.4-rc)

On Wed, Mar 29, 2023 at 3:14=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Prevent multiple threads of doing negotiate, session setup and tree
> connect by holding @ses->session_mutex in cifs_reconnect_tcon() while
> reconnecting session and tcon.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/cifs/cifssmb.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 38a697eca305..c9d57ba84be4 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -71,7 +71,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_com=
mand)
>         int rc;
>         struct cifs_ses *ses;
>         struct TCP_Server_Info *server;
> -       struct nls_table *nls_codepage;
> +       struct nls_table *nls_codepage =3D NULL;
>
>         /*
>          * SMBs NegProt, SessSetup, uLogoff do not have tcon yet so check=
 for
> @@ -99,6 +99,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_com=
mand)
>         }
>         spin_unlock(&tcon->tc_lock);
>
> +again:
>         rc =3D cifs_wait_for_server_reconnect(server, tcon->retry);
>         if (rc)
>                 return rc;
> @@ -110,8 +111,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_c=
ommand)
>         }
>         spin_unlock(&ses->chan_lock);
>
> -       nls_codepage =3D load_nls_default();
> -
> +       mutex_lock(&ses->session_mutex);
>         /*
>          * Recheck after acquire mutex. If another thread is negotiating
>          * and the server never sends an answer the socket will be closed
> @@ -120,29 +120,38 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb=
_command)
>         spin_lock(&server->srv_lock);
>         if (server->tcpStatus =3D=3D CifsNeedReconnect) {
>                 spin_unlock(&server->srv_lock);
> +               mutex_lock(&ses->session_mutex);
> +
> +               if (tcon->retry)
> +                       goto again;
>                 rc =3D -EHOSTDOWN;
>                 goto out;
>         }
>         spin_unlock(&server->srv_lock);
>
> +       nls_codepage =3D load_nls_default();
> +
>         /*
>          * need to prevent multiple threads trying to simultaneously
>          * reconnect the same SMB session
>          */
> +       spin_lock(&ses->ses_lock);
>         spin_lock(&ses->chan_lock);
> -       if (!cifs_chan_needs_reconnect(ses, server)) {
> +       if (!cifs_chan_needs_reconnect(ses, server) &&
> +           ses->ses_status =3D=3D SES_GOOD) {
>                 spin_unlock(&ses->chan_lock);
> +               spin_unlock(&ses->ses_lock);
>
>                 /* this means that we only need to tree connect */
>                 if (tcon->need_reconnect)
>                         goto skip_sess_setup;
>
> -               rc =3D -EHOSTDOWN;
> +               mutex_unlock(&ses->session_mutex);
>                 goto out;
>         }
>         spin_unlock(&ses->chan_lock);
> +       spin_unlock(&ses->ses_lock);
>
> -       mutex_lock(&ses->session_mutex);
>         rc =3D cifs_negotiate_protocol(0, ses, server);
>         if (!rc)
>                 rc =3D cifs_setup_session(0, ses, server, nls_codepage);
> --
> 2.40.0
>


--=20
Thanks,

Steve
