Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58ABAC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 20 May 2022 22:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiETWls (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 May 2022 18:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiETWlr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 May 2022 18:41:47 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43616185408
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 15:41:45 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id m6so11126996ljb.2
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 15:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wv6hvAKOX8Xf8nuYgiLntwwQ3ChgOiMglanwT4a8b90=;
        b=ZRT8uGtlt/j/B3P8pqm3mFGl7mxiYz6yqlHJuO0B2l2PQh8Vy5Djm6P9weTruud1p/
         xBAkOMTcV2inFCwsJgXCO2fMU9sIOfxuc6sBTlwG/aRYK44ZT+YrwY6QtZRi1Oy8vvY+
         43F3H7P5EOEjPJVncO189b9t/GhzWSRzXJRG5bTD1P8Aj/JWToANRiYFEl9uOhcF22Ws
         ihS7RdyoHc25eQYCRxNTrisHP7E8Cbrro3jgTYeb/Y20p9+nxhS0jridHOXGLzcgSsq4
         64t5lnTUF/fROv+ORTFErKqxUqygX878sXskRfqVuY3YaFlmXzkPv9ROWxG97p9fgeCL
         jZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wv6hvAKOX8Xf8nuYgiLntwwQ3ChgOiMglanwT4a8b90=;
        b=Q8RDjN56aX5wUKITxug6ZT0iPD2Y3jfjGT8A/q5hV7QSbW3IL9RV3VFAdLzfMrFp6B
         gOiBcl4yS7eXZmPbTdDJIKlI/PDGfjTjSy455i2E0uiPMOFPVK7BlKMv3R2V7bPMkAY2
         PyaGYskEpQTIyygzvg/do/A8wCG+y+vDYQ9yF3rdQfBTnlrRmMTYRFzTDT3g6pIZKExL
         /mXV1Z+gaCIAkzuPe4mhnj7GzKOa0e4+uE2Y9a2PpZrhxKjHGLfvEEUFiXaZkVHajFBa
         yUTzcFH66yrAxJyZtQ0/BNsqDafjWWKPJvqRuwxN21v2Nmtwl+AtpbNt00un5IZlxiQN
         CNVQ==
X-Gm-Message-State: AOAM533PptNlqeDxXESnYdHcuqhhXfkbCMAZjpyLwblx7qgJ5IAtRDbe
        hcgb470m3/JV2xdYPpFD0YqtThZovbVOVj6W/NG/Yxla
X-Google-Smtp-Source: ABdhPJzLv4mhhpYKd1agDYNksCvqXRi3bU6B43ID7IGNZGAgs0iyMJHyk8DpNQ0FMmgC3Ibga9zqU6UH1eyCcO7Ilc4=
X-Received: by 2002:a2e:6a10:0:b0:253:e02a:94c6 with SMTP id
 f16-20020a2e6a10000000b00253e02a94c6mr1742505ljc.460.1653086503239; Fri, 20
 May 2022 15:41:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220518163155.28520-1-ematsumiya@suse.de>
In-Reply-To: <20220518163155.28520-1-ematsumiya@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 20 May 2022 17:41:32 -0500
Message-ID: <CAH2r5muzZ3vGAJE30uUu0X9VkTj8i3EAfRs1KKC=-+4Zex9SuQ@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: don't call cifs_dfs_query_info_nonascii_quirk()
 if nodfs was set
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next and added cc:stable

On Wed, May 18, 2022 at 11:32 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Also return EOPNOTSUPP if path is remote but nodfs was set.
>
> Fixes: a2809d0e1696 ("cifs: quirk for STATUS_OBJECT_NAME_INVALID returned for non-ASCII dfs refs")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
> v2: remove useles !nodfs check before calling
>     cifs_dfs_query_info_nonascii_quirk()
>
>  fs/cifs/connect.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 42e14f408856..0505d7782e42 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3432,6 +3432,7 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
>         struct cifs_tcon *tcon = mnt_ctx->tcon;
>         struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
>         char *full_path;
> +       bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
>
>         if (!server->ops->is_path_accessible)
>                 return -EOPNOTSUPP;
> @@ -3449,14 +3450,20 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
>         rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
>                                              full_path);
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> +       if (nodfs) {
> +               if (rc == -EREMOTE)
> +                       rc = -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       /* path *might* exist with non-ASCII characters in DFS root
> +        * try again with full path (only if nodfs is not set) */
>         if (rc == -ENOENT && is_tcon_dfs(tcon))
>                 rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon, cifs_sb,
>                                                         full_path);
>  #endif
> -       if (rc != 0 && rc != -EREMOTE) {
> -               kfree(full_path);
> -               return rc;
> -       }
> +       if (rc != 0 && rc != -EREMOTE)
> +               goto out;
>
>         if (rc != -EREMOTE) {
>                 rc = cifs_are_all_path_components_accessible(server, xid, tcon,
> @@ -3468,6 +3475,7 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
>                 }
>         }
>
> +out:
>         kfree(full_path);
>         return rc;
>  }
> --
> 2.36.1
>


-- 
Thanks,

Steve
