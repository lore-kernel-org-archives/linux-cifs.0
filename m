Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B82DEB64DD
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jul 2023 16:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjGLQAS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Jul 2023 12:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjGLQAR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Jul 2023 12:00:17 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74062A2
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jul 2023 09:00:15 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b6ef9ed2fdso118180431fa.2
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jul 2023 09:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689177613; x=1691769613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V+qTuYxr5eSq/kpIXipPVixILLqUBS+G+FHi9eeOvJg=;
        b=ptBUya/knHFIUnTUmcmzOocv6LkUnWFwVpq/jFJLIXzXGAmVKJY9nbO4R5jzzR4C/o
         O0BtpB339/i6iNaQHoMdS4ceuG9KaCSyH3ZYuMxe8OKto0jUiMcZF3ITmZlf6CKN4zRq
         UilgrPWD8fzDyszl72NrWEw9jLDYP8WuBoqKUwtELIGS80640Na1UIR9Iz8viiROTbu3
         KAZsHNQqEYpVv0kOCCwls5dPvXopb/kuDe2DopkJYVmCuIpKx8SveO5xb03wk3eZnvD0
         F45gGX+20BykPX1qr04+APDO78bk3cr9AsjtAV/bPTunVdeImRBXuInxzKMf8Rlk4syr
         Iubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689177613; x=1691769613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V+qTuYxr5eSq/kpIXipPVixILLqUBS+G+FHi9eeOvJg=;
        b=Jl4Us3BZtuPIMXxYs8qEcMuxplxCLq8DnYR6C0yG3aCQJDRaacEtf/UZxOWFRodqDZ
         OjQk31iTMC1bgV5XRiyq05g7+JUTaWZg7zshXSH92mpxaBPBiUcywZx4wD3poMrwW9fx
         c0fNoZY1d8GLjqQQKyXArVX8cwdnDCtB88Yj/v3D/OmPGy7ihxuH2vFy2tDCvzYGuj5F
         Gu8TJUpxQU/bA/BGYhWh4OhMHATtZ1vZ1nqRQ1KCnYlmMUPqZIrqaP0sC8j8Hwrip6+B
         aDpPTT3NH0IMsQp3S6qL92sAGTGJR6jZJlWbxgyJOy/7oYVzsNDh2RWr7TcTTU4W67Wp
         UuQw==
X-Gm-Message-State: ABy/qLbItvgfP7HMXS2wZO/Kh7AsvAiOkvG3GMxY17QWNEcuesbYiiQe
        45fR0FADa1qbAgfnJjDn9dMVgn8sPs8pxcYM30lNAh4G
X-Google-Smtp-Source: APBJJlG4dZS6dQsyXS3YHo1oPxNvUvdvI6Hu9DA+Yu+6GksL1tZVNUYAho+hfsAoHR/4pX0Cej97DRtjlUfJzWJxXxM=
X-Received: by 2002:a2e:9685:0:b0:2b6:e332:1d6b with SMTP id
 q5-20020a2e9685000000b002b6e3321d6bmr15076643lji.52.1689177613320; Wed, 12
 Jul 2023 09:00:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230711171510.5295-1-pc@manguebit.com>
In-Reply-To: <20230711171510.5295-1-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 12 Jul 2023 11:00:02 -0500
Message-ID: <CAH2r5mu5S8ymbrGxFvDhH37wXF3AXG1yuvx+f7rMwU_g5Vi2cA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix missed ses refcounting
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into cifs-2.6.git for-next pending testing

On Tue, Jul 11, 2023 at 12:15=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> Use new cifs_smb_ses_inc_refcount() helper to get an active reference
> of @ses and @ses->dfs_root_ses (if set).  This will prevent
> @ses->dfs_root_ses of being put in the next call to cifs_put_smb_ses()
> and thus potentially causing an use-after-free bug.
>
> Fixes: 8e3554150d6c ("cifs: fix sharing of DFS connections")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/dfs.c           | 26 ++++++++++----------------
>  fs/smb/client/smb2transport.c |  2 +-
>  2 files changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> index 1403a2d1ab17..df3fd3b720da 100644
> --- a/fs/smb/client/dfs.c
> +++ b/fs/smb/client/dfs.c
> @@ -66,6 +66,12 @@ static int get_session(struct cifs_mount_ctx *mnt_ctx,=
 const char *full_path)
>         return rc;
>  }
>
> +/*
> + * Track individual DFS referral servers used by new DFS mount.
> + *
> + * On success, their lifetime will be shared by final tcon (dfs_ses_list=
).
> + * Otherwise, they will be put by dfs_put_root_smb_sessions() in cifs_mo=
unt().
> + */
>  static int add_root_smb_session(struct cifs_mount_ctx *mnt_ctx)
>  {
>         struct smb3_fs_context *ctx =3D mnt_ctx->fs_ctx;
> @@ -80,11 +86,12 @@ static int add_root_smb_session(struct cifs_mount_ctx=
 *mnt_ctx)
>                 INIT_LIST_HEAD(&root_ses->list);
>
>                 spin_lock(&cifs_tcp_ses_lock);
> -               ses->ses_count++;
> +               cifs_smb_ses_inc_refcount(ses);
>                 spin_unlock(&cifs_tcp_ses_lock);
>                 root_ses->ses =3D ses;
>                 list_add_tail(&root_ses->list, &mnt_ctx->dfs_ses_list);
>         }
> +       /* Select new DFS referral server so that new referrals go throug=
h it */
>         ctx->dfs_root_ses =3D ses;
>         return 0;
>  }
> @@ -242,7 +249,6 @@ static int __dfs_mount_share(struct cifs_mount_ctx *m=
nt_ctx)
>  int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
>  {
>         struct smb3_fs_context *ctx =3D mnt_ctx->fs_ctx;
> -       struct cifs_ses *ses;
>         bool nodfs =3D ctx->nodfs;
>         int rc;
>
> @@ -276,20 +282,8 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, =
bool *isdfs)
>         }
>
>         *isdfs =3D true;
> -       /*
> -        * Prevent DFS root session of being put in the first call to
> -        * cifs_mount_put_conns().  If another DFS root server was not fo=
und
> -        * while chasing the referrals (@ctx->dfs_root_ses =3D=3D @ses), =
then we
> -        * can safely put extra refcount of @ses.
> -        */
> -       ses =3D mnt_ctx->ses;
> -       mnt_ctx->ses =3D NULL;
> -       mnt_ctx->server =3D NULL;
> -       rc =3D __dfs_mount_share(mnt_ctx);
> -       if (ses =3D=3D ctx->dfs_root_ses)
> -               cifs_put_smb_ses(ses);
> -
> -       return rc;
> +       add_root_smb_session(mnt_ctx);
> +       return __dfs_mount_share(mnt_ctx);
>  }
>
>  /* Update dfs referral path of superblock */
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index c6db898dab7c..7676091b3e77 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -160,7 +160,7 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info *se=
rver, __u64 ses_id)
>                         spin_unlock(&ses->ses_lock);
>                         continue;
>                 }
> -               ++ses->ses_count;
> +               cifs_smb_ses_inc_refcount(ses);
>                 spin_unlock(&ses->ses_lock);
>                 return ses;
>         }
> --
> 2.41.0
>


--=20
Thanks,

Steve
