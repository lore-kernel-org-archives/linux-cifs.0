Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D66CC6FD18
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjC2UZT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjC2UZS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:25:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1880F46B0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:25:14 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id cn12so68239342edb.4
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680121512;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DWjVI/cyPicHkcA47j//YCHWMvlzteacsHyL9QASJZg=;
        b=k5KfpgOrRUWWdDO2yD955REup+rFfBZHL5vZyt7lZWu02bNg0EdmI0dsOZdPE1yjhA
         Ele+oEL9WCW+DEhHhT5OpawcmYQFdZ7WXgNgxYKZfjmhYat/9oxtw+CH+70a1S3bZ67b
         s4ZNebYAJiOZVfNH/8dpZSMuIyuYiM87jTud14692MChEx9wlkqHEvRB1AilDrQz2iLG
         2kc19ogxEm0qoFtdytRS/bVhkFgGcnRNgh2/gg3hZgEGxTrM6pOA1yrnqQsBQ3v1toer
         J5f4kUj7zoCH5AbXqEAW6G+YRU3BQaEje3kBNimT2wSnBgfJDquHV6BcmYpsfiV0qrM/
         hqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680121512;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DWjVI/cyPicHkcA47j//YCHWMvlzteacsHyL9QASJZg=;
        b=HpruVkZH94a6IdttWyn9VU4cewIW7XeqxQLaj544nU/atN38BtCN8FfIaonhia31Jn
         1waMj/+gLt0p+GAYhe4rhfLZAoumaQomeXq8Jtqhv0+0fXkvqkEpoMb9lFIHl5biPWpW
         6HJSZORC/uf45L0n9o8/Sgqw6YkB5zANFA7AOPTVwo0ktSDKBUaG8BZqX5jMp7WDWkYs
         44J467X5eb9ijuHNKbUkk0uyAoZZArT2HdGqrg64yYshaHb3r+GqdRsoUkyfC1OztfdL
         69KJpZNsTsK78lVzh6XVHnQBrCoY8PUqq3wqrWBXAXLmMlyJSW5mbuDMHfG6XR4E/XSs
         znhw==
X-Gm-Message-State: AAQBX9eTc/yLj3ONfveUSBIMlQ3ojTpQxacGXBtSTUvGieRVXwHYuo81
        6A0IqrC4bMsBkojHMNTvtspbweVSaz+mqtSExWw=
X-Google-Smtp-Source: AKy350YZBtz7W80fTGYAyrqdSKT2x0eV0mn54tPqGLS1UF+/aj03YIeOhFSCMsZDHt7XeZi5b5ATXE3ZSIdFQQI7nps=
X-Received: by 2002:a17:907:a0cd:b0:947:4b15:51e5 with SMTP id
 hw13-20020a170907a0cd00b009474b1551e5mr53101ejc.2.1680121512417; Wed, 29 Mar
 2023 13:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230329201423.32134-1-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-1-pc@manguebit.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 30 Mar 2023 06:24:59 +1000
Message-ID: <CAN05THRzKyB0bgMRi4pqA2GecAMapbMzaCdcvS0igh0r_629WA@mail.gmail.com>
Subject: Re: [PATCH 1/5] cifs: get rid of cifs_mount_ctx::{origin,leaf}_fullpath
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by me

On Thu, 30 Mar 2023 at 06:20, Paulo Alcantara <pc@manguebit.com> wrote:
>
> leaf_fullpath is now part of smb3_fs_context structure, while
> origin_fullpath is just a variable in __dfs_mount_share() that is used
> when final tcon is available.
>
> Get rid of those fields in cifs_mount_ctx structure and no-op
> kfree()'s.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/cifs/cifsglob.h | 1 -
>  fs/cifs/connect.c  | 2 --
>  2 files changed, 3 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 08a73dcb7786..c5e3a0fc7983 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1750,7 +1750,6 @@ struct cifs_mount_ctx {
>         struct TCP_Server_Info *server;
>         struct cifs_ses *ses;
>         struct cifs_tcon *tcon;
> -       char *origin_fullpath, *leaf_fullpath;
>         struct list_head dfs_ses_list;
>  };
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 1cbb90587995..ef50f603e640 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3454,8 +3454,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>
>  error:
>         dfs_put_root_smb_sessions(&mnt_ctx.dfs_ses_list);
> -       kfree(mnt_ctx.origin_fullpath);
> -       kfree(mnt_ctx.leaf_fullpath);
>         cifs_mount_put_conns(&mnt_ctx);
>         return rc;
>  }
> --
> 2.40.0
>
