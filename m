Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF15EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 16:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjF1QWx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jun 2023 12:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbjF1QWv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Jun 2023 12:22:51 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902002689
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 09:22:49 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4faaaa476a9so6449973e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 09:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687969368; x=1690561368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G7wrX/GUDwKI0Wtbravcy7fF6146MAs6ptc4cS93bQI=;
        b=LC5q7QnYiomE5GrDNwU4Awyev0TpVKV2k8zRHhY2lnXpJ4W1RPSTLLLMhkbcS3FwSa
         vlo2dNLyNLCjS5hrj7f3BUGoTWk1GxZ2b9EMVmhwdLf3p/eAfL7IVxBXrFNtD0QqZ5td
         LeysXksCPJQbKPjbPgYmlzj+tRrvdVzEuEket9OnEH8/Rz/ugJ/7Xm9elwa9S+20Wa//
         No39R2C7xP/XHwktXPBOpLu3rq6h3f/JPk43uj5X9ZtEJQOHqQ2c41QfnVwe/ihivs92
         qEJes/IqEmSEwNCD7EGR5p10iayLs/dfv31q+m41hB3tYMjCanG1JZASe8fkdUpo44KZ
         01VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687969368; x=1690561368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G7wrX/GUDwKI0Wtbravcy7fF6146MAs6ptc4cS93bQI=;
        b=COc6f//jmJh4mG11bxmV/46uiTb9/ddID9I+xUqUZACz8OfpjjyjYrBpaI4Ksik8uA
         2QwJAyUrCtsSmPfY3lmHzz+6+1jy1m2/71E6KtPGJq4GUtCfKJVzFW6XcutBRjYd/Isl
         FGT9XampRpS3EqAFY9S5YHiw+p6ESqD60DIS9H7GiPB7MDCfGLWfrMrovFTdJxHrYWv/
         f2HjoDOW463ZLK6EkG4gA1roXaTdsjCiQfiVujYZZP/75Es0NFTjEh7DnZGtvHthWtVf
         SmfMgCOyT/rJduLPRx+V6MG0Zz02NZJCc9aIjSc8iTIgJka5JXj2ZCYXDHjUlLiEnq6z
         mcRQ==
X-Gm-Message-State: AC+VfDxod6nZl9BghliP3ervu4+x3/QAP5otWY88o3keqyQS/UF5rTnf
        EswLzOtfMZsktt4K0pd9FJu8mk/nY71PgeVhJlWDQ7xe
X-Google-Smtp-Source: ACHHUZ6FT57pXxNlr+L8JTn2zM2DO/SusO9O9+H5CzbtPya9/kiVYRupwqvM936K3WrPfe5bXgik6B1nOikwuQpBrpM=
X-Received: by 2002:a2e:b163:0:b0:2b6:a08d:e142 with SMTP id
 a3-20020a2eb163000000b002b6a08de142mr6559154ljm.7.1687969367305; Wed, 28 Jun
 2023 09:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230628002450.18781-1-pc@manguebit.com>
In-Reply-To: <20230628002450.18781-1-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Jun 2023 11:22:35 -0500
Message-ID: <CAH2r5mu0aWp_jAz=jqQB6Dn3gc_kbE=BVMxMoJFccsyvJ8Qkxw@mail.gmail.com>
Subject: Re: [PATCH 1/4] smb: client: fix parsing of source mount option
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged patches

On Tue, Jun 27, 2023 at 7:25=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Handle trailing and leading separators when parsing UNC and prefix
> paths in smb3_parse_devname().  Then, store the sanitised paths in
> smb3_fs_context::source.
>
> This fixes the following cases
>
> $ mount //srv/share// /mnt/1 -o ...
> $ cat /mnt/1/d0/f0
> cat: /mnt/1/d0/f0: Invalid argument
>
> The -EINVAL was returned because the client sent SMB2_CREATE "\\d0\f0"
> rather than SMB2_CREATE "\d0\f0".
>
> $ mount //srv//share /mnt/1 -o ...
> mount: Invalid argument
>
> The -EINVAL was returned correctly although the client only realised
> it after sending a couple of bad requests rather than bailing out
> earlier when parsing mount options.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/cifs_dfs_ref.c | 28 +++++++++++------
>  fs/smb/client/cifsproto.h    |  2 ++
>  fs/smb/client/dfs.c          | 38 ++---------------------
>  fs/smb/client/fs_context.c   | 59 ++++++++++++++++++++++++++++++------
>  fs/smb/client/misc.c         | 17 +++++++----
>  5 files changed, 84 insertions(+), 60 deletions(-)
>
> diff --git a/fs/smb/client/cifs_dfs_ref.c b/fs/smb/client/cifs_dfs_ref.c
> index 0329a907bdfe..b1c2499b1c3b 100644
> --- a/fs/smb/client/cifs_dfs_ref.c
> +++ b/fs/smb/client/cifs_dfs_ref.c
> @@ -118,12 +118,12 @@ cifs_build_devname(char *nodename, const char *prep=
ath)
>         return dev;
>  }
>
> -static int set_dest_addr(struct smb3_fs_context *ctx, const char *full_p=
ath)
> +static int set_dest_addr(struct smb3_fs_context *ctx)
>  {
>         struct sockaddr *addr =3D (struct sockaddr *)&ctx->dstaddr;
>         int rc;
>
> -       rc =3D dns_resolve_server_name_to_ip(full_path, addr, NULL);
> +       rc =3D dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
>         if (!rc)
>                 cifs_set_port(addr, ctx->port);
>         return rc;
> @@ -171,10 +171,9 @@ static struct vfsmount *cifs_dfs_do_automount(struct=
 path *path)
>                 mnt =3D ERR_CAST(full_path);
>                 goto out;
>         }
> -       cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
>
>         tmp =3D *cur_ctx;
> -       tmp.source =3D full_path;
> +       tmp.source =3D NULL;
>         tmp.leaf_fullpath =3D NULL;
>         tmp.UNC =3D tmp.prepath =3D NULL;
>         tmp.dfs_root_ses =3D NULL;
> @@ -185,13 +184,22 @@ static struct vfsmount *cifs_dfs_do_automount(struc=
t path *path)
>                 goto out;
>         }
>
> -       rc =3D set_dest_addr(ctx, full_path);
> -       if (rc) {
> -               mnt =3D ERR_PTR(rc);
> -               goto out;
> -       }
> -
>         rc =3D smb3_parse_devname(full_path, ctx);
> +       if (rc) {
> +               mnt =3D ERR_PTR(rc);
> +               goto out;
> +       }
> +
> +       ctx->source =3D smb3_fs_context_fullpath(ctx, '/');
> +       if (IS_ERR(ctx->source)) {
> +               mnt =3D ERR_CAST(ctx->source);
> +               ctx->source =3D NULL;
> +               goto out;
> +       }
> +       cifs_dbg(FYI, "%s: ctx: source=3D%s UNC=3D%s prepath=3D%s dstaddr=
=3D%pISpc\n",
> +                __func__, ctx->source, ctx->UNC, ctx->prepath, &ctx->dst=
addr);
> +
> +       rc =3D set_dest_addr(ctx);
>         if (!rc)
>                 mnt =3D fc_mount(fc);
>         else
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index d127aded2f28..293c54867d94 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -85,6 +85,8 @@ extern void release_mid(struct mid_q_entry *mid);
>  extern void cifs_wake_up_task(struct mid_q_entry *mid);
>  extern int cifs_handle_standard(struct TCP_Server_Info *server,
>                                 struct mid_q_entry *mid);
> +extern char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx,
> +                                     char dirsep);
>  extern int smb3_parse_devname(const char *devname, struct smb3_fs_contex=
t *ctx);
>  extern int smb3_parse_opt(const char *options, const char *key, char **v=
al);
>  extern int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rh=
s);
> diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> index 2390b2fedd6a..d741f396c527 100644
> --- a/fs/smb/client/dfs.c
> +++ b/fs/smb/client/dfs.c
> @@ -54,39 +54,6 @@ int dfs_parse_target_referral(const char *full_path, c=
onst struct dfs_info3_para
>         return rc;
>  }
>
> -/*
> - * cifs_build_path_to_root returns full path to root when we do not have=
 an
> - * existing connection (tcon)
> - */
> -static char *build_unc_path_to_root(const struct smb3_fs_context *ctx,
> -                                   const struct cifs_sb_info *cifs_sb, b=
ool useppath)
> -{
> -       char *full_path, *pos;
> -       unsigned int pplen =3D useppath && ctx->prepath ? strlen(ctx->pre=
path) + 1 : 0;
> -       unsigned int unc_len =3D strnlen(ctx->UNC, MAX_TREE_SIZE + 1);
> -
> -       if (unc_len > MAX_TREE_SIZE)
> -               return ERR_PTR(-EINVAL);
> -
> -       full_path =3D kmalloc(unc_len + pplen + 1, GFP_KERNEL);
> -       if (full_path =3D=3D NULL)
> -               return ERR_PTR(-ENOMEM);
> -
> -       memcpy(full_path, ctx->UNC, unc_len);
> -       pos =3D full_path + unc_len;
> -
> -       if (pplen) {
> -               *pos =3D CIFS_DIR_SEP(cifs_sb);
> -               memcpy(pos + 1, ctx->prepath, pplen);
> -               pos +=3D pplen;
> -       }
> -
> -       *pos =3D '\0'; /* add trailing null */
> -       convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
> -       cifs_dbg(FYI, "%s: full_path=3D%s\n", __func__, full_path);
> -       return full_path;
> -}
> -
>  static int get_session(struct cifs_mount_ctx *mnt_ctx, const char *full_=
path)
>  {
>         struct smb3_fs_context *ctx =3D mnt_ctx->fs_ctx;
> @@ -179,6 +146,7 @@ static int __dfs_mount_share(struct cifs_mount_ctx *m=
nt_ctx)
>         struct TCP_Server_Info *server;
>         struct cifs_tcon *tcon;
>         char *origin_fullpath =3D NULL;
> +       char sep =3D CIFS_DIR_SEP(cifs_sb);
>         int num_links =3D 0;
>         int rc;
>
> @@ -186,7 +154,7 @@ static int __dfs_mount_share(struct cifs_mount_ctx *m=
nt_ctx)
>         if (IS_ERR(ref_path))
>                 return PTR_ERR(ref_path);
>
> -       full_path =3D build_unc_path_to_root(ctx, cifs_sb, true);
> +       full_path =3D smb3_fs_context_fullpath(ctx, sep);
>         if (IS_ERR(full_path)) {
>                 rc =3D PTR_ERR(full_path);
>                 full_path =3D NULL;
> @@ -228,7 +196,7 @@ static int __dfs_mount_share(struct cifs_mount_ctx *m=
nt_ctx)
>                                 kfree(full_path);
>                                 ref_path =3D full_path =3D NULL;
>
> -                               full_path =3D build_unc_path_to_root(ctx,=
 cifs_sb, true);
> +                               full_path =3D smb3_fs_context_fullpath(ct=
x, sep);
>                                 if (IS_ERR(full_path)) {
>                                         rc =3D PTR_ERR(full_path);
>                                         full_path =3D NULL;
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 226d71e12db0..a4b80babd03e 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -442,14 +442,17 @@ int smb3_parse_opt(const char *options, const char =
*key, char **val)
>   * but there are some bugs that prevent rename from working if there are
>   * multiple delimiters.
>   *
> - * Returns a sanitized duplicate of @path. @gfp indicates the GFP_* flag=
s
> - * for kstrdup.
> + * Return a sanitized duplicate of @path or NULL for empty prefix paths.
> + * Otherwise, return ERR_PTR.
> + *
> + * @gfp indicates the GFP_* flags for kstrdup.
>   * The caller is responsible for freeing the original.
>   */
>  #define IS_DELIM(c) ((c) =3D=3D '/' || (c) =3D=3D '\\')
>  char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
>  {
>         char *cursor1 =3D prepath, *cursor2 =3D prepath;
> +       char *s;
>
>         /* skip all prepended delimiters */
>         while (IS_DELIM(*cursor1))
> @@ -470,8 +473,39 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp=
)
>         if (IS_DELIM(*(cursor2 - 1)))
>                 cursor2--;
>
> -       *(cursor2) =3D '\0';
> -       return kstrdup(prepath, gfp);
> +       *cursor2 =3D '\0';
> +       if (!*prepath)
> +               return NULL;
> +       s =3D kstrdup(prepath, gfp);
> +       if (!s)
> +               return ERR_PTR(-ENOMEM);
> +       return s;
> +}
> +
> +/*
> + * Return full path based on the values of @ctx->{UNC,prepath}.
> + *
> + * It is assumed that both values were already parsed by smb3_parse_devn=
ame().
> + */
> +char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx, char d=
irsep)
> +{
> +       size_t ulen, plen;
> +       char *s;
> +
> +       ulen =3D strlen(ctx->UNC);
> +       plen =3D ctx->prepath ? strlen(ctx->prepath) + 1 : 0;
> +
> +       s =3D kmalloc(ulen + plen + 1, GFP_KERNEL);
> +       if (!s)
> +               return ERR_PTR(-ENOMEM);
> +       memcpy(s, ctx->UNC, ulen);
> +       if (plen) {
> +               s[ulen] =3D dirsep;
> +               memcpy(s + ulen + 1, ctx->prepath, plen);
> +       }
> +       s[ulen + plen] =3D '\0';
> +       convert_delimiter(s, dirsep);
> +       return s;
>  }
>
>  /*
> @@ -485,6 +519,7 @@ smb3_parse_devname(const char *devname, struct smb3_f=
s_context *ctx)
>         char *pos;
>         const char *delims =3D "/\\";
>         size_t len;
> +       int rc;
>
>         if (unlikely(!devname || !*devname)) {
>                 cifs_dbg(VFS, "Device name not specified\n");
> @@ -512,6 +547,8 @@ smb3_parse_devname(const char *devname, struct smb3_f=
s_context *ctx)
>
>         /* now go until next delimiter or end of string */
>         len =3D strcspn(pos, delims);
> +       if (!len)
> +               return -EINVAL;
>
>         /* move "pos" up to delimiter or NULL */
>         pos +=3D len;
> @@ -534,8 +571,11 @@ smb3_parse_devname(const char *devname, struct smb3_=
fs_context *ctx)
>                 return 0;
>
>         ctx->prepath =3D cifs_sanitize_prepath(pos, GFP_KERNEL);
> -       if (!ctx->prepath)
> -               return -ENOMEM;
> +       if (IS_ERR(ctx->prepath)) {
> +               rc =3D PTR_ERR(ctx->prepath);
> +               ctx->prepath =3D NULL;
> +               return rc;
> +       }
>
>         return 0;
>  }
> @@ -1150,12 +1190,13 @@ static int smb3_fs_context_parse_param(struct fs_=
context *fc,
>                         cifs_errorf(fc, "Unknown error parsing devname\n"=
);
>                         goto cifs_parse_mount_err;
>                 }
> -               ctx->source =3D kstrdup(param->string, GFP_KERNEL);
> -               if (ctx->source =3D=3D NULL) {
> +               ctx->source =3D smb3_fs_context_fullpath(ctx, '/');
> +               if (IS_ERR(ctx->source)) {
> +                       ctx->source =3D NULL;
>                         cifs_errorf(fc, "OOM when copying UNC string\n");
>                         goto cifs_parse_mount_err;
>                 }
> -               fc->source =3D kstrdup(param->string, GFP_KERNEL);
> +               fc->source =3D kstrdup(ctx->source, GFP_KERNEL);
>                 if (fc->source =3D=3D NULL) {
>                         cifs_errorf(fc, "OOM when copying UNC string\n");
>                         goto cifs_parse_mount_err;
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index cd914be905b2..609d0c0d9eca 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -1198,16 +1198,21 @@ int match_target_ip(struct TCP_Server_Info *serve=
r,
>
>  int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix=
)
>  {
> +       int rc;
> +
>         kfree(cifs_sb->prepath);
> +       cifs_sb->prepath =3D NULL;
>
>         if (prefix && *prefix) {
>                 cifs_sb->prepath =3D cifs_sanitize_prepath(prefix, GFP_AT=
OMIC);
> -               if (!cifs_sb->prepath)
> -                       return -ENOMEM;
> -
> -               convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb)=
);
> -       } else
> -               cifs_sb->prepath =3D NULL;
> +               if (IS_ERR(cifs_sb->prepath)) {
> +                       rc =3D PTR_ERR(cifs_sb->prepath);
> +                       cifs_sb->prepath =3D NULL;
> +                       return rc;
> +               }
> +               if (cifs_sb->prepath)
> +                       convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(=
cifs_sb));
> +       }
>
>         cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_USE_PREFIX_PATH;
>         return 0;
> --
> 2.41.0
>


--=20
Thanks,

Steve
