Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB02C74A5B
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjC2U1S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjC2U1R (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:27:17 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D12D46B0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:27:16 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b20so68270340edd.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680121635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CaJjW0T0yOh7quW34QNSDX0BSEWP/cp4GqawI4Q6J+4=;
        b=BQP3abXhmZQwo0qgmq7MqmhCnVMDFGk9vwTA5m6YenXBSvNNck0bO/YyRq/ycbBB9M
         iRacZ800jszgyz6IOB6QMZr19xCKWwGRNGY221ySVjrJPNDSxaMjHw8lLjzYGo7s9E3l
         fLvfyIcCfxDzsY3rcf7thwud5Bzt3ogsHR14bPsSVdMWLaf6FlRhXYXOt/tHTacMoj/D
         EvNhn6hhMF8Vcx1XF3CwG1iCMjnmvIvNJLv76Ee8kPObthsfyRiZJwUAZKwhB8KFDX1Z
         mdJBG46DflU1QzYLjxMqspGuimxvXzh7BJw8bZJCFkeuJD71WTLwgpGlWVkJMALIuoV/
         n7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680121635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CaJjW0T0yOh7quW34QNSDX0BSEWP/cp4GqawI4Q6J+4=;
        b=ctK9gJFavMW7BhiwucHMKBEaKVGZjXaf+1HklQYNGVfUCeFVoGXsB2exswzhwXIedY
         OXcyE6uptB98rjT6SbAqVs4et6I1WItqDqXD0kx82nEYwQgIa5ITY2gPSwDjXSrn3LTq
         CDu126W6ZiFimXOvTHCjBp81hjKvfMNnSjOw0OOxmdZneBRfCm2Kig/LTqrXrokHpeYM
         1W7Kpbv0Mhf2ZSPSalBRVgV6bqbAyn1Npf2o6tSwQzvkG5Fz5WdRXI1FdTOLOXXtAU9P
         MbYpHDqoColhY7jPIHwsVbn2DQrPKc11zxRchPp0D4fPwMlF4piPI2d3jcMvGdowQfGk
         x7Yg==
X-Gm-Message-State: AAQBX9fjigpwuGK0QnB66vfwTnZJCQ3lnVhoai1F/7UiRIk89iQFGaGv
        Hz7UeO5NDbKR+Szxvga/SWX38SEtPD7tqHGmaTI=
X-Google-Smtp-Source: AKy350aJbhUkEE04chpeqOTjZcoprVs54Lmx6M3UMVJ1YLpdkhswoyC1mpqjRg6iYVzJFfk5l7lw+xS/+q8PY/oW4js=
X-Received: by 2002:a17:906:5584:b0:93a:6e4d:e772 with SMTP id
 y4-20020a170906558400b0093a6e4de772mr2281496ejp.7.1680121634824; Wed, 29 Mar
 2023 13:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230329201423.32134-1-pc@manguebit.com> <20230329201423.32134-3-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-3-pc@manguebit.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 30 Mar 2023 06:27:02 +1000
Message-ID: <CAN05THSrxuq3kcMuKhvbM9vfq9T2icSG-zwUSsQ-BNeweBtCLQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] cifs: avoid races in parallel reconnects in smb1
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed-by me

On Thu, 30 Mar 2023 at 06:20, Paulo Alcantara <pc@manguebit.com> wrote:
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
> @@ -71,7 +71,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
>         int rc;
>         struct cifs_ses *ses;
>         struct TCP_Server_Info *server;
> -       struct nls_table *nls_codepage;
> +       struct nls_table *nls_codepage = NULL;
>
>         /*
>          * SMBs NegProt, SessSetup, uLogoff do not have tcon yet so check for
> @@ -99,6 +99,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
>         }
>         spin_unlock(&tcon->tc_lock);
>
> +again:
>         rc = cifs_wait_for_server_reconnect(server, tcon->retry);
>         if (rc)
>                 return rc;
> @@ -110,8 +111,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
>         }
>         spin_unlock(&ses->chan_lock);
>
> -       nls_codepage = load_nls_default();
> -
> +       mutex_lock(&ses->session_mutex);
>         /*
>          * Recheck after acquire mutex. If another thread is negotiating
>          * and the server never sends an answer the socket will be closed
> @@ -120,29 +120,38 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
>         spin_lock(&server->srv_lock);
>         if (server->tcpStatus == CifsNeedReconnect) {
>                 spin_unlock(&server->srv_lock);
> +               mutex_lock(&ses->session_mutex);
> +
> +               if (tcon->retry)
> +                       goto again;
>                 rc = -EHOSTDOWN;
>                 goto out;
>         }
>         spin_unlock(&server->srv_lock);
>
> +       nls_codepage = load_nls_default();
> +
>         /*
>          * need to prevent multiple threads trying to simultaneously
>          * reconnect the same SMB session
>          */
> +       spin_lock(&ses->ses_lock);
>         spin_lock(&ses->chan_lock);
> -       if (!cifs_chan_needs_reconnect(ses, server)) {
> +       if (!cifs_chan_needs_reconnect(ses, server) &&
> +           ses->ses_status == SES_GOOD) {
>                 spin_unlock(&ses->chan_lock);
> +               spin_unlock(&ses->ses_lock);
>
>                 /* this means that we only need to tree connect */
>                 if (tcon->need_reconnect)
>                         goto skip_sess_setup;
>
> -               rc = -EHOSTDOWN;
> +               mutex_unlock(&ses->session_mutex);
>                 goto out;
>         }
>         spin_unlock(&ses->chan_lock);
> +       spin_unlock(&ses->ses_lock);
>
> -       mutex_lock(&ses->session_mutex);
>         rc = cifs_negotiate_protocol(0, ses, server);
>         if (!rc)
>                 rc = cifs_setup_session(0, ses, server, nls_codepage);
> --
> 2.40.0
>
