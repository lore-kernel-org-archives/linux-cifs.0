Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FA9C46467
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Jan 2023 06:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjADGPb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Jan 2023 01:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjADGPb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Jan 2023 01:15:31 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3F418396
        for <linux-cifs@vger.kernel.org>; Tue,  3 Jan 2023 22:15:30 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id b3so49050484lfv.2
        for <linux-cifs@vger.kernel.org>; Tue, 03 Jan 2023 22:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sgl/oOe4VD1EChA+YvcudtbjJZdtAJLSWSlADdKlRmE=;
        b=QqsjyTbHW0EKWCPDA6pRfyvEIJHmvhvTAoNd84f0sBPt24j6vCLUg1iA91gpDKvQUc
         iQEYnqKMqtBrfbGzOXCDOednbao5aKTncjTSy/E4/BDKIlYc7O1ldCG+ucQC6j/s/Q7K
         MXv0YTFuYztxDkBx9XTUKHw2lU1HyaDMYQz8HqaBYMNifo5SdwWq1ZFprEWXJnXKLCrr
         RzzTjZ28iioWZe5/tEFwt/gplV+NhLcVCFQNppkwzogmkyjljhMHxD1U9MWBCBNLjw12
         fL8h0UreZr9bgFK7a1w1DDUdZc+SaAb3OZTB8AbOxeStw3CJBQbsgr8r+2kVJo3ioJDo
         kvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sgl/oOe4VD1EChA+YvcudtbjJZdtAJLSWSlADdKlRmE=;
        b=frb7NehY95U9a9LP7uWm17aLB+IR7EfFJt7DS20Ejgip3HL8bOos1S6racRa35k+cv
         mPJsl5plM+oRlLJ8AnfkoNSVIRLK63A+xUmwnxDFyKb2CDcs/OCbKkiQxvU0oUMBZMQy
         GIKlwsuF606HM8Bctp9GFNlcc74TP+/We042uQLEbQ0e552A/iIhmJSfi8PPMyItokZf
         jHyrJ8l/+q9dDDNf28eNB6HoDSTUaIkQXa8xl6wbWhMemN2l/weT+RL3v8///AcVBXdb
         v2v9nxUaa3mQ/DXzDdAGPIzUTKGFYjPYv9zDab0qbLqwQQCq1E8kErFwusFjo0ECI59O
         SuBg==
X-Gm-Message-State: AFqh2kq0+IsxkQbDDzYSUp/VqH6zBEVLGjdA8E+26ooxThXaEk79kJM/
        txxpPifJsrOQw7NNk62GbkOp6nx0oWRQO+TVv3DgnY3jHik=
X-Google-Smtp-Source: AMrXdXv+V0U2J5rIvdnSSj2wX5KldR4EygWgCuWYA45o9rnr6CSzHnhN98WUv1m3WiHa6nL/rLi6yKNplWpxGBdkgPM=
X-Received: by 2002:a05:6512:533:b0:4b5:9125:1432 with SMTP id
 o19-20020a056512053300b004b591251432mr2479172lfc.204.1672812928348; Tue, 03
 Jan 2023 22:15:28 -0800 (PST)
MIME-Version: 1.0
References: <20221229214346.9979-1-pc@cjr.nz>
In-Reply-To: <20221229214346.9979-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Jan 2023 00:15:17 -0600
Message-ID: <CAH2r5msGWjwQH7MpLzhhPmiB8Oq-rKxWXWRG6wEbJaVhvO5=uQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: protect access of TCP_Server_Info::{dstaddr,hostname}
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending testing

On Thu, Dec 29, 2022 at 3:43 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Use the appropriate locks to protect access of hostname and dstaddr
> fields in cifs_tree_connect() as they might get changed by other
> tasks.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/dfs.c  | 22 +++++++++++-----------
>  fs/cifs/misc.c |  2 ++
>  2 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
> index 30086f2060a1..b64d20374b9c 100644
> --- a/fs/cifs/dfs.c
> +++ b/fs/cifs/dfs.c
> @@ -327,8 +327,8 @@ static int update_server_fullpath(struct TCP_Server_Info *server, struct cifs_sb
>         return rc;
>  }
>
> -static int target_share_matches_server(struct TCP_Server_Info *server, const char *tcp_host,
> -                                      size_t tcp_host_len, char *share, bool *target_match)
> +static int target_share_matches_server(struct TCP_Server_Info *server, char *share,
> +                                      bool *target_match)
>  {
>         int rc = 0;
>         const char *dfs_host;
> @@ -338,13 +338,16 @@ static int target_share_matches_server(struct TCP_Server_Info *server, const cha
>         extract_unc_hostname(share, &dfs_host, &dfs_host_len);
>
>         /* Check if hostnames or addresses match */
> -       if (dfs_host_len != tcp_host_len || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
> -               cifs_dbg(FYI, "%s: %.*s doesn't match %.*s\n", __func__, (int)dfs_host_len,
> -                        dfs_host, (int)tcp_host_len, tcp_host);
> +       cifs_server_lock(server);
> +       if (dfs_host_len != strlen(server->hostname) ||
> +           strncasecmp(dfs_host, server->hostname, dfs_host_len)) {
> +               cifs_dbg(FYI, "%s: %.*s doesn't match %s\n", __func__,
> +                        (int)dfs_host_len, dfs_host, server->hostname);
>                 rc = match_target_ip(server, dfs_host, dfs_host_len, target_match);
>                 if (rc)
>                         cifs_dbg(VFS, "%s: failed to match target ip: %d\n", __func__, rc);
>         }
> +       cifs_server_unlock(server);
>         return rc;
>  }
>
> @@ -358,13 +361,9 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
>         struct cifs_ses *root_ses = CIFS_DFS_ROOT_SES(tcon->ses);
>         struct cifs_tcon *ipc = root_ses->tcon_ipc;
>         char *share = NULL, *prefix = NULL;
> -       const char *tcp_host;
> -       size_t tcp_host_len;
>         struct dfs_cache_tgt_iterator *tit;
>         bool target_match;
>
> -       extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
> -
>         tit = dfs_cache_get_tgt_iterator(tl);
>         if (!tit) {
>                 rc = -ENOENT;
> @@ -387,8 +386,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
>                         break;
>                 }
>
> -               rc = target_share_matches_server(server, tcp_host, tcp_host_len, share,
> -                                                &target_match);
> +               rc = target_share_matches_server(server, share, &target_match);
>                 if (rc)
>                         break;
>                 if (!target_match) {
> @@ -497,7 +495,9 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
>         }
>
>         if (tcon->ipc) {
> +               cifs_server_lock(server);
>                 scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
> +               cifs_server_unlock(server);
>                 rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
>                 goto out;
>         }
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 4d3c586785a5..2a19c7987c5b 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -1277,7 +1277,9 @@ int match_target_ip(struct TCP_Server_Info *server,
>         if (rc < 0)
>                 return rc;
>
> +       spin_lock(&server->srv_lock);
>         *result = cifs_match_ipaddr((struct sockaddr *)&server->dstaddr, (struct sockaddr *)&ss);
> +       spin_unlock(&server->srv_lock);
>         cifs_dbg(FYI, "%s: ip addresses match: %u\n", __func__, *result);
>         return 0;
>  }
> --
> 2.39.0
>


-- 
Thanks,

Steve
