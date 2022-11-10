Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C64C4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Nov 2022 21:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiKJV2V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKJV2V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Nov 2022 16:28:21 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407B8123
        for <linux-cifs@vger.kernel.org>; Thu, 10 Nov 2022 13:28:20 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 888E27FC02;
        Thu, 10 Nov 2022 21:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1668115698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pd8sKabKJUuaaCEH3B8xVK3m0JphfkFr0uTODUnJjok=;
        b=iYaY7a7J2AOHWflM05mv7PKXXeHnZ5T+e07mLFLvBaJWjhupt7RUgJCisHgM30VxXVhG4R
        0IScPuuwoycoPBPUh2fUgwk1q+tIsUq6fEQ91Z5S0hXcU0zDMfsanKxw9CyBVZRwDE5bcY
        QDBkCJd5raD8acC+vZ8x7HwlF8xRSIAdbmur1Rmk5dwzGtYKWIVy9sZKmtzjvS8ip16IVE
        wTJhE35b8N9UoJplsSycGm9naqW0aCUd4nPqtJ+JU3UZnXwlnycAAMxHFgcLwLIbKigkx6
        T/QW29ecgDjDrdwV5MkPLPxDrTrpFliK0drjVcKNCALOFfcSdvZZikaW+vMxjg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        zhangxiaoxu5@huawei.com, sfrench@samba.org, smfrench@gmail.com,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com
Subject: Re: [PATCH] cifs: Fix connections leak when tlink setup failed
In-Reply-To: <20221110030009.2207092-1-zhangxiaoxu5@huawei.com>
References: <20221110030009.2207092-1-zhangxiaoxu5@huawei.com>
Date:   Thu, 10 Nov 2022 18:29:33 -0300
Message-ID: <87eduawlaa.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:

> If the tlink setup failed, lost to put the connections, then
> the module refcnt leak since the cifsd kthread not exit.
>
> Also leak the fscache info, and for next mount with fsc,it will
> print the follow errors:
>   CIFS: Cache volume key already in use (cifs,127.0.0.1:445,TEST)
>
> Let's check the result of tlink setup, and put the connection when
> error happened.
>
> Fixes: 56c762eb9bee ("cifs: Refactor out cifs_mount()")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/connect.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 1cc47dd3b4d6..e699e45e70c4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3855,14 +3855,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>  	uuid_copy(&cifs_sb->dfs_mount_id, &mnt_ctx.mount_id);
>  
>  out:
> -	free_xid(mnt_ctx.xid);
>  	cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
> -	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> +	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> +	if (rc)
> +		goto put_conns;

Good catch.  However, this would partially fix the leaked connections as
you must still call dfs_cache_put_refsrv_sessions() to put all other
connections that were used for chasing DFS referrals.  For non-DFS
mounts, it wouldn't be a problem, though.

What about something like below

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1cc47dd3b4d6..083ba70f3c1a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3855,9 +3855,13 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	uuid_copy(&cifs_sb->dfs_mount_id, &mnt_ctx.mount_id);
 
 out:
-	free_xid(mnt_ctx.xid);
 	cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
-	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	rc =  mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	if (rc)
+		goto error;
+
+	free_xid(mnt_ctx.xid);
+	return rc;
 
 error:
 	dfs_cache_put_refsrv_sessions(&mnt_ctx.mount_id);
