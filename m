Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF12C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jan 2022 19:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbiAQTda (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jan 2022 14:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242966AbiAQTd3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jan 2022 14:33:29 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58744C061574
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 11:33:29 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id bu18so38542300lfb.5
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 11:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yHZHRTxA/LLB6QB1fzSFOMlJCL7LPa3ipOCqlPuRaJk=;
        b=gU371rg3Oij7Dzt/wJuYeb0bW645cr6a8wVx3yHE+QBESGRQgktUfZz4aLRMIGMZ60
         dwSfjIrjL+vRy2qbWwzU6o2VKjXDZCAxNWBFHv9DGDVrQ7p4V+/ekZPP5ILmGPPks07S
         MGoNNPyiGnlnsRQ3FT/jSmqvkbAxlRlMDsDc9sXY6ffXzma/gxQ0J1i1bAu+VeAtxT09
         3f7+nuDrwj+Z87qES/tQYZ3hR1PjgE0CA73dI+nvGsQG0xwkBxGyKTGFESCVAHvNnORk
         zXFP4jNql+4hstNuwvt2p7pObNzV3vIo/gX8AMn4P9ZWbZhquD5lBKBxSGQbQ9yyzfxx
         uQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yHZHRTxA/LLB6QB1fzSFOMlJCL7LPa3ipOCqlPuRaJk=;
        b=3PbOmK+YH0mGadjZOqDNGgk2FwDqBmANTj/owAxTmfF0Hh1AiatcQfkwtwRZVXr7cI
         UCPqaCnpszELdo6rhUiUMKXAwa8QPL9eoAkQQjbdZZA/bD2904iQ3cIOCzTAzwH68bNG
         JgdJlJAeiagsZJq/8o7IEkCOdrZzDPr5TuHu7/V3UNppplmm/qGUv1meJFgHXvxiPwcY
         4p6xDNaDVNatNroWp5F5lbnmkMWSV/x44PW1etM0/rprp65tk7v0Nyz9re37uiwDIwJi
         I/Ul+VfMiLe0lFC6oQ9fHnT/mXq/YLPzmRh474yh3sh8M1yN7Z61Phn3s88u8vwqmrhR
         Pwhg==
X-Gm-Message-State: AOAM532t9ga9Se1M1sThWVwVqFyWbBvQFepmByrqyOvdUoQ0J3ViVZmN
        H/lpXIC+Sjlv4kIFLI9pkSOHzw8vLlM3h6ZGrGA=
X-Google-Smtp-Source: ABdhPJzTq6esnYjS2mUgvViDzc2yiKUJ2QqFHZr5UP8ORQ+T6cjuMyFrLyqb7oDL2GI77WLKwXlb8CPeab2PslyH6dM=
X-Received: by 2002:a05:651c:150b:: with SMTP id e11mr1826401ljf.398.1642448007512;
 Mon, 17 Jan 2022 11:33:27 -0800 (PST)
MIME-Version: 1.0
References: <YeHUxJ9zTVNrKveF@himera.home>
In-Reply-To: <YeHUxJ9zTVNrKveF@himera.home>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Jan 2022 13:33:15 -0600
Message-ID: <CAH2r5mt75RnL7zhE8zaySj0Wp1ic5WFd+YOA3jtJv64EoV6vuw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] cifs: quirk for STATUS_OBJECT_NAME_INVALID
 returned for non-ASCII dfs refs
To:     Eugene Korenevsky <ekorenevsky@astralinux.ru>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Fri, Jan 14, 2022 at 5:04 PM Eugene Korenevsky
<ekorenevsky@astralinux.ru> wrote:
>
> Windows SMB server responds with STATUS_OBJECT_NAME_INVALID code to
> SMB2 QUERY_INFO request for "\<server>\<dfsname>\<linkpath>" DFS reference,
> where <dfsname> contains non-ASCII unicode symbols.
>
> Check such DFS reference and emulate -EREMOTE if it is actual.
>
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215440
> Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
> ---
> v2: No changes, this is a new patch in the patchset for #215440 fix
>
>  fs/cifs/cifsproto.h |  5 +++++
>  fs/cifs/connect.c   |  5 +++++
>  fs/cifs/inode.c     |  6 ++++++
>  fs/cifs/misc.c      | 49 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 65 insertions(+)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 4f5a3e857df4..b3a9cc0def2c 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -626,6 +626,11 @@ static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
>  int match_target_ip(struct TCP_Server_Info *server,
>                     const char *share, size_t share_len,
>                     bool *result);
> +
> +int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
> +                                      struct cifs_tcon *tcon,
> +                                      struct cifs_sb_info *cifs_sb,
> +                                      const char *dfs_link_path);
>  #endif
>
>  static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 1060164b984a..db0f8a1c8fb5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3322,6 +3322,11 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
>
>         rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
>                                              full_path);
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +       if (rc == -ENOENT && is_tcon_dfs(tcon))
> +               rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon, cifs_sb,
> +                                                       full_path);
> +#endif
>         if (rc != 0 && rc != -EREMOTE) {
>                 kfree(full_path);
>                 return rc;
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 279622e4eb1c..baa197edd8c5 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -952,6 +952,12 @@ cifs_get_inode_info(struct inode **inode,
>                 rc = server->ops->query_path_info(xid, tcon, cifs_sb,
>                                                  full_path, tmp_data,
>                                                  &adjust_tz, &is_reparse_point);
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +               if (rc == -ENOENT && is_tcon_dfs(tcon))
> +                       rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon,
> +                                                               cifs_sb,
> +                                                               full_path);
> +#endif
>                 data = tmp_data;
>         }
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 5148d48d6a35..56598f7dbe00 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -1302,4 +1302,53 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
>         cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
>         return 0;
>  }
> +
> +/** cifs_dfs_query_info_nonascii_quirk
> + * Handle weird Windows SMB server behaviour. It responds with
> + * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
> + * for "\<server>\<dfsname>\<linkpath>" DFS reference,
> + * where <dfsname> contains non-ASCII unicode symbols.
> + *
> + * Check such DFS reference and emulate -ENOENT if it is actual.
> + */
> +int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
> +                                      struct cifs_tcon *tcon,
> +                                      struct cifs_sb_info *cifs_sb,
> +                                      const char *linkpath)
> +{
> +       char *treename, *dfspath, sep;
> +       int treenamelen, linkpathlen, rc;
> +
> +       treename = tcon->treeName;
> +       /* MS-DFSC: All paths in REQ_GET_DFS_REFERRAL and RESP_GET_DFS_REFERRAL
> +        * messages MUST be encoded with exactly one leading backslash, not two
> +        * leading backslashes.
> +        */
> +       sep = CIFS_DIR_SEP(cifs_sb);
> +       if (treename[0] == sep && treename[1] == sep)
> +               treename++;
> +       linkpathlen = strlen(linkpath);
> +       treenamelen = strnlen(treename, MAX_TREE_SIZE + 1);
> +       dfspath = kzalloc(treenamelen + linkpathlen + 1, GFP_KERNEL);
> +       if (!dfspath)
> +               return -ENOMEM;
> +       if (treenamelen)
> +               memcpy(dfspath, treename, treenamelen);
> +       memcpy(dfspath + treenamelen, linkpath, linkpathlen);
> +       rc = dfs_cache_find(xid, tcon->ses, cifs_sb->local_nls,
> +                           cifs_remap(cifs_sb), dfspath, NULL, NULL);
> +       if (rc == 0) {
> +               cifs_dbg(FYI, "DFS ref '%s' is found, emulate -EREMOTE\n",
> +                        dfspath);
> +               rc = -EREMOTE;
> +       } else if (rc == -EEXIST) {
> +               cifs_dbg(FYI, "DFS ref '%s' is not found, emulate -ENOENT\n",
> +                        dfspath);
> +               rc = -ENOENT;
> +       } else {
> +               cifs_dbg(FYI, "%s: dfs_cache_find returned %d\n", __func__, rc);
> +       }
> +       kfree(dfspath);
> +       return rc;
> +}
>  #endif
> --
> 2.30.2
>


-- 
Thanks,

Steve
