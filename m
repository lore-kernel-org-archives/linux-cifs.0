Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC05DC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Oct 2021 12:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B80A461038
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Oct 2021 12:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhJKMVp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Oct 2021 08:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbhJKMVo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Oct 2021 08:21:44 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38D2C061570;
        Mon, 11 Oct 2021 05:19:44 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id h4so12406032uaw.1;
        Mon, 11 Oct 2021 05:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GmDig8uR6zWhf7zrT1U+cYAgHxtWyD/idN3V+pqxfVE=;
        b=UKRDw1MY9529cio6+Ud/0HXNC1CG9Em4E9iVWUVEuHPLRmniv6VpVhtIcYk2eDo8W5
         sZ2p3tVf/pDmEpWzKV6OLBGzUHTBvQUwtGbwCAkzCcyc4ix2t+du4cQXDgJN4oi827E5
         WftwthEpoSIoQXwxWcrVD/2YsVm1RYrsqkiHtBrVO4dSEcm15wPuHNG8C80u2u7SYtK9
         jJcaCa3dU1gZ8bzgC1jHRpff/2bvLp2eNqqqd1oCW0OSdWSrvJJd5gOMUbM8VD+LYDiI
         MzHOJzA/MfP5v7YKH0545v39rjyueOvV0Ben1oBh6HtQtxoQ4Lp6VUsivr661bgnKrKY
         o8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GmDig8uR6zWhf7zrT1U+cYAgHxtWyD/idN3V+pqxfVE=;
        b=4Yc+BYFTK9q65nSHIovogE30CAZKAN/QuWQnvon5VfThY4Njc04KcraMueNNEK2rjI
         wBfu9jdb7obf9rdVPPymnFRSzJABoHGssah8RhFfsnxWJrBXKnjS88mE/MJuwB03Jz6E
         5UHaVtCAW4yGAd9IBlMJy1bGPYJosYahW80X/pSnrvx1UMVlEO7pApwymbK7CBhuWTPC
         4SMiU/+sgmcOseOu9k3dvyCF3IlGjWTNe09Vp4N8ik1RqBiht1G84grIVC9FVpGuFGqJ
         8FNl98crEMLjpu9P9aVzWAOj2sWAzp3U0D/5q9zolGAA9nd9p26oUYwk71N6wtz1pj1J
         vSZw==
X-Gm-Message-State: AOAM5319rZN3gXSGNp43qySWLw8xfX+C5YNDm9RkMWV9NqBFh8cCDfpz
        ITFjhKFbYHHhfn/+wivl1FAcRGnmV94A7xgPIjY=
X-Google-Smtp-Source: ABdhPJwuowsev0gau00Zx+r18LA5VdDlSrEUHqHB+mlJ6Cd4KwPc0ry6MBaEzvgjd0rJoW3AGvWjSAwRulhgnPYFBEk=
X-Received: by 2002:a67:ca96:: with SMTP id a22mr9059095vsl.44.1633954783838;
 Mon, 11 Oct 2021 05:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <bf5648ef0933536661e42cc73aa06722522d5862.1633872027.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <bf5648ef0933536661e42cc73aa06722522d5862.1633872027.git.christophe.jaillet@wanadoo.fr>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 11 Oct 2021 21:19:32 +0900
Message-ID: <CANFS6bY-BOKVzDSPSnKOJRxn8dkW+V+xKy0JR_WtfHoiJV4CxA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Remove redundant 'flush_workqueue()' calls
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 10=EC=9B=94 10=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 10:29,=
 Christophe JAILLET
<christophe.jaillet@wanadoo.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
>
> Remove the redundant 'flush_workqueue()' calls.
>
> This was generated with coccinelle:
>
> @@
> expression E;
> @@
> -       flush_workqueue(E);
>         destroy_workqueue(E);
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  fs/ksmbd/ksmbd_work.c     | 1 -
>  fs/ksmbd/transport_rdma.c | 1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/fs/ksmbd/ksmbd_work.c b/fs/ksmbd/ksmbd_work.c
> index fd58eb4809f6..14b9caebf7a4 100644
> --- a/fs/ksmbd/ksmbd_work.c
> +++ b/fs/ksmbd/ksmbd_work.c
> @@ -69,7 +69,6 @@ int ksmbd_workqueue_init(void)
>
>  void ksmbd_workqueue_destroy(void)
>  {
> -       flush_workqueue(ksmbd_wq);
>         destroy_workqueue(ksmbd_wq);
>         ksmbd_wq =3D NULL;
>  }
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 3a7fa23ba850..0fa7b9c17af3 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -2026,7 +2026,6 @@ int ksmbd_rdma_destroy(void)
>         smb_direct_listener.cm_id =3D NULL;
>
>         if (smb_direct_wq) {
> -               flush_workqueue(smb_direct_wq);
>                 destroy_workqueue(smb_direct_wq);
>                 smb_direct_wq =3D NULL;
>         }
> --
> 2.30.2
>


--=20
Thanks,
Hyunchul
