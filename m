Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DB3C77B73
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Apr 2023 19:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDPTeS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Apr 2023 15:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjDPTeR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Apr 2023 15:34:17 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1822D60
        for <linux-cifs@vger.kernel.org>; Sun, 16 Apr 2023 12:34:13 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id j11so11952806ljq.10
        for <linux-cifs@vger.kernel.org>; Sun, 16 Apr 2023 12:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681673652; x=1684265652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4QQD8uUnY3wj8hY55u/ichy49HKFLrB2pb0T+hQV9M=;
        b=N9akg0lpsicG5KJ6oDrTyZN0DNaVUsslcoCV9VUdrluHi61waJ8ZPEfczupqAi9SIH
         bCzqTyZg01QEIogEUstJMCCldLUMo1Etj3hlT4YzwuvpD4sxLiNjikyIO7nZpsEOIYL7
         U2PONfy21X9Y+KQzwYBiZltkW3FJqB2lbm708b4kLT+i4nMcioKabqJ14RHoqJlv4kbZ
         62MSN8NyZg+gmtWU9wQB0q4QYS5OHuJaA3BtsTnN2VSPfmvF6kwytaEuXYPgdGuxCkm+
         ZAyPjU7Oh1E0xWIBkPioHSHMSKiZ8COIXkagmdDlSJLXGh8RY76y05RO+Wztm3ruu7X2
         mf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681673652; x=1684265652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4QQD8uUnY3wj8hY55u/ichy49HKFLrB2pb0T+hQV9M=;
        b=biZKXGpqzmw7zBzfPoMfgvgUMkcvMtedjx46S19Ob2SXJO/OV8yx6VIbRWpCj2cpja
         vIqx5VVaiE4kx9IHR8DKKf/4o0yNdhY5VzTv8oyATGCh0q4q2ly8hhYWxnSb5YhXimGa
         rGO+5YobbMD27+h4AwhvsrAWr1CEhG01WVhqp2JGDFWM/lmb6D11gQGBcxIAG4C6ju3H
         fNF/N4Ak4hXwKsus4h+KVIIQUjYjeSOZHq7mtlikscOvT4JW9EnzbT2IBNVWBy4vdQKF
         NmnpD6A73XLN9V9F2LARiyho4Z8gWOtY+hIPTqbg6enTWJx9/1xnhCh/k7uSauxpoy84
         mKAQ==
X-Gm-Message-State: AAQBX9cjMXss9qMG5tvogwYb0zyDEcB+DvOZ4BJNomlz24BmyFYtkPk9
        SSQ/hcwCLi3GE0gi+0uiT5DWbddHb8VlIs35S4nZY7WF
X-Google-Smtp-Source: AKy350a2o5ROlDq3hsH2/IMwnBe4n9kEpGeWH9B/K8PqBV+6NwfczeBD+qPvUMr5hdvmJHoyhsuBXRXRGNnqbrzDJK4=
X-Received: by 2002:a2e:a0d2:0:b0:2a8:bbd9:1a07 with SMTP id
 f18-20020a2ea0d2000000b002a8bbd91a07mr1120278ljm.2.1681673651462; Sun, 16 Apr
 2023 12:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230416183828.18174-1-pc@manguebit.com>
In-Reply-To: <20230416183828.18174-1-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 16 Apr 2023 14:33:59 -0500
Message-ID: <CAH2r5mvyBwNJ-1oeF+hS==-ZFzwu733DAYvSGJcYD4OkQnaeyg@mail.gmail.com>
Subject: Re: [PATCH] cifs: avoid dup prefix path in dfs_get_automount_devname()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending additional
review and testing

On Sun, Apr 16, 2023 at 1:38=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> @server->origin_fullpath already contains the tree name + optional
> prefix, so avoid calling __build_path_from_dentry_optional_prefix() as
> it might end up duplicating prefix path from @cifs_sb->prepath into
> final full path.
>
> Instead, generate DFS full path by simply merging
> @server->origin_fullpath with dentry's path.
>
> This fixes the following case
>
>         mount.cifs //root/dfs/dir /mnt/ -o ...
>         ls /mnt/link
>
> where cifs_dfs_do_automount() will call smb3_parse_devname() with
> @devname set to "//root/dfs/dir/link" instead of
> "//root/dfs/dir/dir/link".
>
> Fixes: 7ad54b98fc1f ("cifs: use origin fullpath for automounts")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
> FYI, updated DFS tests to include the above case and avoid regressions.
>
>  fs/cifs/cifs_dfs_ref.c |  2 --
>  fs/cifs/dfs.h          | 22 ++++++++++++++++++----
>  2 files changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index cb40074feb3e..0329a907bdfe 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -171,8 +171,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct =
path *path)
>                 mnt =3D ERR_CAST(full_path);
>                 goto out;
>         }
> -
> -       convert_delimiter(full_path, '/');
>         cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
>
>         tmp =3D *cur_ctx;
> diff --git a/fs/cifs/dfs.h b/fs/cifs/dfs.h
> index 13f26e01f7b9..0b8cbf721fff 100644
> --- a/fs/cifs/dfs.h
> +++ b/fs/cifs/dfs.h
> @@ -34,19 +34,33 @@ static inline int dfs_get_referral(struct cifs_mount_=
ctx *mnt_ctx, const char *p
>                               cifs_remap(cifs_sb), path, ref, tl);
>  }
>
> +/* Return DFS full path out of a dentry set for automount */
>  static inline char *dfs_get_automount_devname(struct dentry *dentry, voi=
d *page)
>  {
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb);
>         struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
>         struct TCP_Server_Info *server =3D tcon->ses->server;
> +       size_t len;
> +       char *s;
>
>         if (unlikely(!server->origin_fullpath))
>                 return ERR_PTR(-EREMOTE);
>
> -       return __build_path_from_dentry_optional_prefix(dentry, page,
> -                                                       server->origin_fu=
llpath,
> -                                                       strlen(server->or=
igin_fullpath),
> -                                                       true);
> +       s =3D dentry_path_raw(dentry, page, PATH_MAX);
> +       if (IS_ERR(s))
> +               return s;
> +       /* for root, we want "" */
> +       if (!s[1])
> +               s++;
> +
> +       len =3D strlen(server->origin_fullpath);
> +       if (s < (char *)page + len)
> +               return ERR_PTR(-ENAMETOOLONG);
> +
> +       s -=3D len;
> +       memcpy(s, server->origin_fullpath, len);
> +       convert_delimiter(s, '/');
> +       return s;
>  }
>
>  static inline void dfs_put_root_smb_sessions(struct list_head *head)
> --
> 2.40.0
>


--=20
Thanks,

Steve
