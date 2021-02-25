Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A5CC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 01:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5C764EF1
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 01:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhBYBSI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 20:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhBYBSH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Feb 2021 20:18:07 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345D4C061786
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 17:17:27 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id r23so4656739ljh.1
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 17:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cwlmOHKKS9LuFAclvGPRVtkxjByXlwpebNB0ztpqHzo=;
        b=STwWiIaMxr64rTtx93uRoVLvmSK64GlZOEryQq6hWCglhOHC9G8/OYrXsjUQXslYGa
         PgKSCt2wrPah2LZGz+3nyJtSU8H7+dwScmOi6d9y0uyl+ZA+PUFf+jNIhVKwkBkXZ12F
         1iYZ5x3ADtt6if/hlyy6rnFAqjqIMr8iCoNP0fqdmsPIln7QtAFQnYFP085Fo67G6wJq
         NsK3NQyy4Ka9cf1lcNMFP8v2KNee4YWLFHlmPzJaF2oIY9duMmuud8WycohqC3lXs2TS
         qLpTQlK/TgZ+JOYDrKnVQWMVDjxWfZSyakn1L1OY1erPgpoA/IepLLCoUs1VIA2BMDDW
         Urrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cwlmOHKKS9LuFAclvGPRVtkxjByXlwpebNB0ztpqHzo=;
        b=M+WMo+3Kg9UdY5+2Bpqww/1vaTLeK7OS1vkqytx0oXa1FQELDNHrLo2CgfccUKvj9Q
         hjKLCcw/wDHHAxRdt/2pYwMtTrg5WNIeD7Uow+hwBJe2x93Zw0wE7O5vkykM3m+GqP+w
         gRBcQxrfZ+TlEtigYz0ZfztOFih6z6+rsV0C5EzjRkoRcYxi1vX5uIqjzR5S1KMPC+Jo
         2ZQJozL29md9gL1ksA8Wl/QkApA4obhvflgB3s2liX2d5BRV4o0Lcd/ZlocCESPqBQz+
         NPo53dgKjLepLza/0gdrsr1TV6rh/7bETAknoDCcZLWLPH/EZBFzXvFBbpwvLcaq3D3G
         4C7Q==
X-Gm-Message-State: AOAM531/wG0wKHK1+NvAaZF+zrypJdeTzp7Eo62VHe6mU7nUeTdPN6dN
        2jZ7Eo84VBl7FWFPwTtgHC8vsRB4wBSJBA35UMWc7WK5jv9cng==
X-Google-Smtp-Source: ABdhPJzikfNxs47IKzlIAV8CcGF5rUCMFB4AEYjMfnr+tSJ/7AXWqNr8P6Bl+okM0X9C1EES6WKMf4yS+kOdzxNLm5c=
X-Received: by 2002:a2e:9e48:: with SMTP id g8mr264385ljk.477.1614215845652;
 Wed, 24 Feb 2021 17:17:25 -0800 (PST)
MIME-Version: 1.0
References: <20210224235924.29931-1-pc@cjr.nz>
In-Reply-To: <20210224235924.29931-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Feb 2021 19:17:14 -0600
Message-ID: <CAH2r5muMt3gmmtLOBxaOqqh-KfccSDDuta6ob218_w9WQZdmbA@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: fix DFS failover
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

is this series of 4 identical with
   https://git.cjr.nz/linux.git/commit/?h=dfs-fixes-v2

On Wed, Feb 24, 2021 at 6:00 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> In do_dfs_failover(), the mount_get_conns() function requires the full
> fs context in order to get new connection to server, so clone the
> original context and change it accordingly when retrying the DFS
> targets in the referral.
>
> If failover was successful, then update original context with the new
> UNC, prefix path and ip address.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/connect.c | 123 ++++++++++++++++++++++------------------------
>  1 file changed, 59 insertions(+), 64 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index cd6dbeaf2166..a800e055c614 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3045,96 +3045,91 @@ static int update_vol_info(const struct dfs_cache_tgt_iterator *tgt_it,
>         return 0;
>  }
>
> -static int setup_dfs_tgt_conn(const char *path, const char *full_path,
> -                             const struct dfs_cache_tgt_iterator *tgt_it,
> -                             struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
> -                             unsigned int *xid, struct TCP_Server_Info **server,
> -                             struct cifs_ses **ses, struct cifs_tcon **tcon)
> -{
> -       int rc;
> -       struct dfs_info3_param ref = {0};
> -       char *mdata = NULL;
> -       struct smb3_fs_context fake_ctx = {NULL};
> -       char *fake_devname = NULL;
> -
> -       cifs_dbg(FYI, "%s: dfs path: %s\n", __func__, path);
> -
> -       rc = dfs_cache_get_tgt_referral(path, tgt_it, &ref);
> -       if (rc)
> -               return rc;
> -
> -       mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
> -                                          full_path + 1, &ref,
> -                                          &fake_devname);
> -       free_dfs_info_param(&ref);
> -
> -       if (IS_ERR(mdata)) {
> -               rc = PTR_ERR(mdata);
> -               mdata = NULL;
> -       } else
> -               rc = cifs_setup_volume_info(&fake_ctx, mdata, fake_devname);
> -
> -       kfree(mdata);
> -       kfree(fake_devname);
> -
> -       if (!rc) {
> -               /*
> -                * We use a 'fake_ctx' here because we need pass it down to the
> -                * mount_{get,put} functions to test connection against new DFS
> -                * targets.
> -                */
> -               mount_put_conns(cifs_sb, *xid, *server, *ses, *tcon);
> -               rc = mount_get_conns(&fake_ctx, cifs_sb, xid, server, ses,
> -                                    tcon);
> -               if (!rc || (*server && *ses)) {
> -                       /*
> -                        * We were able to connect to new target server.
> -                        * Update current context with new target server.
> -                        */
> -                       rc = update_vol_info(tgt_it, &fake_ctx, ctx);
> -               }
> -       }
> -       smb3_cleanup_fs_context_contents(&fake_ctx);
> -       return rc;
> -}
> -
>  static int do_dfs_failover(const char *path, const char *full_path, struct cifs_sb_info *cifs_sb,
>                            struct smb3_fs_context *ctx, struct cifs_ses *root_ses,
>                            unsigned int *xid, struct TCP_Server_Info **server,
>                            struct cifs_ses **ses, struct cifs_tcon **tcon)
>  {
>         int rc;
> -       struct dfs_cache_tgt_list tgt_list;
> +       struct dfs_cache_tgt_list tgt_list = {0};
>         struct dfs_cache_tgt_iterator *tgt_it = NULL;
> +       struct smb3_fs_context tmp_ctx = {NULL};
>
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
>                 return -EOPNOTSUPP;
>
> +       cifs_dbg(FYI, "%s: path=%s full_path=%s\n", __func__, path, full_path);
> +
>         rc = dfs_cache_noreq_find(path, NULL, &tgt_list);
>         if (rc)
>                 return rc;
> +       /*
> +        * We use a 'tmp_ctx' here because we need pass it down to the mount_{get,put} functions to
> +        * test connection against new DFS targets.
> +        */
> +       rc = smb3_fs_context_dup(&tmp_ctx, ctx);
> +       if (rc)
> +               goto out;
>
>         for (;;) {
> +               struct dfs_info3_param ref = {0};
> +               char *fake_devname = NULL, *mdata = NULL;
> +
>                 /* Get next DFS target server - if any */
>                 rc = get_next_dfs_tgt(path, &tgt_list, &tgt_it);
>                 if (rc)
>                         break;
> -               /* Connect to next DFS target */
> -               rc = setup_dfs_tgt_conn(path, full_path, tgt_it, cifs_sb, ctx, xid, server, ses,
> -                                       tcon);
> -               if (!rc || (*server && *ses))
> +
> +               rc = dfs_cache_get_tgt_referral(path, tgt_it, &ref);
> +               if (rc)
>                         break;
> +
> +               cifs_dbg(FYI, "%s: old ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
> +                        tmp_ctx.prepath);
> +
> +               mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options, full_path + 1, &ref,
> +                                                  &fake_devname);
> +               free_dfs_info_param(&ref);
> +
> +               if (IS_ERR(mdata)) {
> +                       rc = PTR_ERR(mdata);
> +                       mdata = NULL;
> +               } else
> +                       rc = cifs_setup_volume_info(&tmp_ctx, mdata, fake_devname);
> +
> +               kfree(mdata);
> +               kfree(fake_devname);
> +
> +               if (rc)
> +                       break;
> +
> +               cifs_dbg(FYI, "%s: new ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
> +                        tmp_ctx.prepath);
> +
> +               mount_put_conns(cifs_sb, *xid, *server, *ses, *tcon);
> +               rc = mount_get_conns(&tmp_ctx, cifs_sb, xid, server, ses, tcon);
> +               if (!rc || (*server && *ses)) {
> +                       /*
> +                        * We were able to connect to new target server. Update current context with
> +                        * new target server.
> +                        */
> +                       rc = update_vol_info(tgt_it, &tmp_ctx, ctx);
> +                       break;
> +               }
>         }
>         if (!rc) {
> +               cifs_dbg(FYI, "%s: final ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
> +                        tmp_ctx.prepath);
>                 /*
> -                * Update DFS target hint in DFS referral cache with the target
> -                * server we successfully reconnected to.
> +                * Update DFS target hint in DFS referral cache with the target server we
> +                * successfully reconnected to.
>                  */
> -               rc = dfs_cache_update_tgthint(*xid, root_ses ? root_ses : *ses,
> -                                             cifs_sb->local_nls,
> -                                             cifs_remap(cifs_sb), path,
> -                                             tgt_it);
> +               rc = dfs_cache_update_tgthint(*xid, root_ses ? root_ses : *ses, cifs_sb->local_nls,
> +                                             cifs_remap(cifs_sb), path, tgt_it);
>         }
> +
> +out:
> +       smb3_cleanup_fs_context_contents(&tmp_ctx);
>         dfs_cache_free_tgts(&tgt_list);
>         return rc;
>  }
> --
> 2.30.1
>


-- 
Thanks,

Steve
