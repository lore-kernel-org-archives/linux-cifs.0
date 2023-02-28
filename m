Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D0DC64EC4
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Feb 2023 22:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjB1WVL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Feb 2023 17:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjB1WVK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Feb 2023 17:21:10 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2C7360A6
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 14:21:07 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id o12so46245136edb.9
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 14:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xZox4znT/ZjybEB0Iq7gk7BevBsLKHTFmTKOQ1IAnLU=;
        b=Tux+FEF35896lM/c+LRtm+F1t24dQOewfsS1LnMIDY2F7CdKsMBx24sbBFBNQbfIgr
         xQdGKWKMFVJon5gRzxByvSWZdXlHoV7zKlqI3FI1OheIG6W6xUM+bFidp1MJrQIPxLAl
         hFLFkSPi6lkaFdVlo4PqqtBTlBbeawx85SwMrtT4ApeBStoMXmalpJ43qIMT1YRIN+a2
         COQNbWGcwxfy9fsJESskyRGM31qFWl3tBGofAv43N8YAzwrm0BLSAwVFBRbXNux9BqqZ
         u17w6jVXpRWTpEV1BzXRjxMrinJie4qs1BbBbsujkY/mmciJiGKPg/ZUoV0BC94lLe/k
         SYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZox4znT/ZjybEB0Iq7gk7BevBsLKHTFmTKOQ1IAnLU=;
        b=cIkhDEr3mTVXR1kdRekSryd34kNC1vKWR/phFP2G+gluFjpWu4SX1+SyiKFMAEK+j+
         AELcE6OxAg94gpVEdGXCuQAwlPay/kojMGs9WfUGH2lKnZvldVVNI73fyV8CWav6YxN8
         fI+cDdx/46uj54f21wUgiIdzFE21c8BAjhNUGK6PqK5Bd3q3ovuFgHij6aXhVpWl+LnC
         I7Cz4e8+0+xxCMXF89mgi1sYJ1BGKUfJVFP77YH1kKInsuPX1f8sXcXQiLdtMUmnZtkc
         v0ZOFnZgaPRvObfdvJJVlAr9OUOsXHETBSLg0zrcfCCMGgm3C2sAdGJDnftS2EsfUg+0
         fINA==
X-Gm-Message-State: AO0yUKUNBuS+CbV8TaTNoiY79u6buCge+HAePDO7ya9HWuOGl2kLVhlA
        MrUeLFmXqKSvZBjtAmfGkUJ2gPgwyg3UU5ZOej4=
X-Google-Smtp-Source: AK7set+o7Fo+log3ffiS/qZB3UrhCo+Camh8dGu6jamyD6pF3G9wHBAR/nj/AqyNxRGOvloa+M2hz4yGxTNWEfxe5sA=
X-Received: by 2002:a17:906:817:b0:8e6:266c:c75e with SMTP id
 e23-20020a170906081700b008e6266cc75emr2095740ejd.14.1677622865528; Tue, 28
 Feb 2023 14:21:05 -0800 (PST)
MIME-Version: 1.0
References: <20230227135323.26712-1-pc@manguebit.com> <20230228220155.23394-1-pc@manguebit.com>
In-Reply-To: <20230228220155.23394-1-pc@manguebit.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 1 Mar 2023 08:20:51 +1000
Message-ID: <CAN05THSaVcbsqaR=euCr2Me88HkgMO7fHhX7nc21=cRLKdPwyw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] cifs: improve checking of DFS links over STATUS_OBJECT_NAME_INVALID
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Wed, 1 Mar 2023 at 08:15, Paulo Alcantara <pc@manguebit.com> wrote:
>
> Do not map STATUS_OBJECT_NAME_INVALID to -EREMOTE under non-DFS
> shares, or 'nodfs' mounts or CONFIG_CIFS_DFS_UPCALL=n builds.
> Otherwise, in the slow path, get a referral to figure out whether it
> is an actual DFS link.
>
> This could be simply reproduced under a non-DFS share by running the
> following
>
>   $ mount.cifs //srv/share /mnt -o ...
>   $ cat /mnt/$(printf '\U110000')
>   cat: '/mnt/'$'\364\220\200\200': Object is remote
>
> Fixes: c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
> v1 -> v2: fixed mem leak on PTR_ERR(ref_path) != -EINVAL
>
>  fs/cifs/cifsproto.h | 20 ++++++++++----
>  fs/cifs/misc.c      | 67 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2inode.c | 21 +++++++-------
>  fs/cifs/smb2ops.c   | 23 +++++++++-------
>  4 files changed, 106 insertions(+), 25 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index b7a36ebd0f2f..20a2f0f3f682 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -667,11 +667,21 @@ static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
>  int match_target_ip(struct TCP_Server_Info *server,
>                     const char *share, size_t share_len,
>                     bool *result);
> -
> -int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
> -                                      struct cifs_tcon *tcon,
> -                                      struct cifs_sb_info *cifs_sb,
> -                                      const char *dfs_link_path);
> +int cifs_inval_name_dfs_link_error(const unsigned int xid,
> +                                  struct cifs_tcon *tcon,
> +                                  struct cifs_sb_info *cifs_sb,
> +                                  const char *full_path,
> +                                  bool *islink);
> +#else
> +static inline int cifs_inval_name_dfs_link_error(const unsigned int xid,
> +                                  struct cifs_tcon *tcon,
> +                                  struct cifs_sb_info *cifs_sb,
> +                                  const char *full_path,
> +                                  bool *islink)
> +{
> +       *islink = false;
> +       return 0;
> +}
>  #endif
>
>  static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 2905734eb289..0c6c1fc8dae9 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -21,6 +21,7 @@
>  #include "cifsfs.h"
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  #include "dns_resolve.h"
> +#include "dfs_cache.h"
>  #endif
>  #include "fs_context.h"
>  #include "cached_dir.h"
> @@ -1198,4 +1199,70 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
>         cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
>         return 0;
>  }
> +
> +/*
> + * Handle weird Windows SMB server behaviour. It responds with
> + * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request for
> + * "\<server>\<dfsname>\<linkpath>" DFS reference, where <dfsname> contains
> + * non-ASCII unicode symbols.
> + */
> +int cifs_inval_name_dfs_link_error(const unsigned int xid,
> +                                  struct cifs_tcon *tcon,
> +                                  struct cifs_sb_info *cifs_sb,
> +                                  const char *full_path,
> +                                  bool *islink)
> +{
> +       struct cifs_ses *ses = tcon->ses;
> +       size_t len;
> +       char *path;
> +       char *ref_path;
> +
> +       *islink = false;
> +
> +       /*
> +        * Fast path - skip check when @full_path doesn't have a prefix path to
> +        * look up or tcon is not DFS.
> +        */
> +       if (strlen(full_path) < 2 || !cifs_sb ||
> +           (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
> +           !is_tcon_dfs(tcon) || !ses->server->origin_fullpath)
> +               return 0;
> +
> +       /*
> +        * Slow path - tcon is DFS and @full_path has prefix path, so attempt
> +        * to get a referral to figure out whether it is an DFS link.
> +        */
> +       len = strnlen(tcon->tree_name, MAX_TREE_SIZE + 1) + strlen(full_path) + 1;
> +       path = kmalloc(len, GFP_KERNEL);
> +       if (!path)
> +               return -ENOMEM;
> +
> +       scnprintf(path, len, "%s%s", tcon->tree_name, full_path);
> +       ref_path = dfs_cache_canonical_path(path + 1, cifs_sb->local_nls,
> +                                           cifs_remap(cifs_sb));
> +       kfree(path);
> +
> +       if (IS_ERR(ref_path)) {
> +               if (PTR_ERR(ref_path) != -EINVAL)
> +                       return PTR_ERR(ref_path);
> +       } else {
> +               struct dfs_info3_param *refs = NULL;
> +               int num_refs = 0;
> +
> +               /*
> +                * XXX: we are not using dfs_cache_find() here because we might
> +                * end filling all the DFS cache and thus potentially
> +                * removing cached DFS targets that the client would eventually
> +                * need during failover.
> +                */
> +               if (ses->server->ops->get_dfs_refer &&
> +                   !ses->server->ops->get_dfs_refer(xid, ses, ref_path, &refs,
> +                                                    &num_refs, cifs_sb->local_nls,
> +                                                    cifs_remap(cifs_sb)))
> +                       *islink = refs[0].server_type == DFS_TYPE_LINK;
> +               free_dfs_info_array(refs, num_refs);
> +               kfree(ref_path);
> +       }
> +       return 0;
> +}
>  #endif
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 37b4cd59245d..9b956294e864 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -527,12 +527,13 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                          struct cifs_sb_info *cifs_sb, const char *full_path,
>                          struct cifs_open_info_data *data, bool *adjust_tz, bool *reparse)
>  {
> -       int rc;
>         __u32 create_options = 0;
>         struct cifsFileInfo *cfile;
>         struct cached_fid *cfid = NULL;
>         struct kvec err_iov[3] = {};
>         int err_buftype[3] = {};
> +       bool islink;
> +       int rc, rc2;
>
>         *adjust_tz = false;
>         *reparse = false;
> @@ -580,15 +581,15 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                                               SMB2_OP_QUERY_INFO, cfile, NULL, NULL,
>                                               NULL, NULL);
>                         goto out;
> -               } else if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
> -                          hdr->Status == STATUS_OBJECT_NAME_INVALID) {
> -                       /*
> -                        * Handle weird Windows SMB server behaviour. It responds with
> -                        * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
> -                        * for "\<server>\<dfsname>\<linkpath>" DFS reference,
> -                        * where <dfsname> contains non-ASCII unicode symbols.
> -                        */
> -                       rc = -EREMOTE;
> +               } else if (rc != -EREMOTE && hdr->Status == STATUS_OBJECT_NAME_INVALID) {
> +                       rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
> +                                                            full_path, &islink);
> +                       if (rc2) {
> +                               rc = rc2;
> +                               goto out;
> +                       }
> +                       if (islink)
> +                               rc = -EREMOTE;
>                 }
>                 if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
>                     (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index f79b075f2992..6dfb865ee9d7 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -796,7 +796,6 @@ static int
>  smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>                         struct cifs_sb_info *cifs_sb, const char *full_path)
>  {
> -       int rc;
>         __le16 *utf16_path;
>         __u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
>         int err_buftype = CIFS_NO_BUFFER;
> @@ -804,6 +803,8 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>         struct kvec err_iov = {};
>         struct cifs_fid fid;
>         struct cached_fid *cfid;
> +       bool islink;
> +       int rc, rc2;
>
>         rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
>         if (!rc) {
> @@ -833,15 +834,17 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>
>                 if (unlikely(!hdr || err_buftype == CIFS_NO_BUFFER))
>                         goto out;
> -               /*
> -                * Handle weird Windows SMB server behaviour. It responds with
> -                * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
> -                * for "\<server>\<dfsname>\<linkpath>" DFS reference,
> -                * where <dfsname> contains non-ASCII unicode symbols.
> -                */
> -               if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
> -                   hdr->Status == STATUS_OBJECT_NAME_INVALID)
> -                       rc = -EREMOTE;
> +
> +               if (rc != -EREMOTE && hdr->Status == STATUS_OBJECT_NAME_INVALID) {
> +                       rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
> +                                                            full_path, &islink);
> +                       if (rc2) {
> +                               rc = rc2;
> +                               goto out;
> +                       }
> +                       if (islink)
> +                               rc = -EREMOTE;
> +               }
>                 if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
>                     (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
>                         rc = -EOPNOTSUPP;
> --
> 2.39.2
>
