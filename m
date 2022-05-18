Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17743C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 16:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbiERQU2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 12:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240030AbiERQU1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 12:20:27 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C091F0DDA
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 09:20:15 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 12C277FD1E;
        Wed, 18 May 2022 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1652890814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5xW7UZ2OLkdm+Uo273I+bdrASLeqeSWxxyONDmuOirI=;
        b=hrHGR/yFSdNb/+oVf6EPoijCEWUGWgPSZEeShqAi8tPyuWTj7KQBKfSWUUJfK7LgzLfODB
        7PgB0A8xOpZjWUYnWuVcoomA2AbHI1aiqbAXUcMq/sIquFQtXD+KQ9FD23xSIVNZhXHewr
        qDydwZXYmiGxhFD3bRjqgjKPweX40yA/jp8MkwFHnXbkGZcn890vhIloTng4WQ2sobvzCq
        56kAj+IWRR0ZtDPe7Cctgu9xY3q9cgveVDRMtfzOkucgrnnZmyggz3teFe1ZCuOCXuHd+4
        FV09QL7ppQbFglQCWj8CdFLrD3j2PWWEHeo+Unb+e4O7jvfJP9ONX7FPFfj7GQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: Re: [PATCH] cifs: don't call cifs_dfs_query_info_nonascii_quirk()
 if nodfs was set
In-Reply-To: <20220518144105.21913-1-ematsumiya@suse.de>
References: <20220518144105.21913-1-ematsumiya@suse.de>
Date:   Wed, 18 May 2022 13:20:07 -0300
Message-ID: <87ee0q3j9k.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> Also return EOPNOTSUPP if path is remote but nodfs was set.
>
> Fixes: a2809d0e1696 ("cifs: quirk for STATUS_OBJECT_NAME_INVALID returned for non-ASCII dfs refs")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/connect.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 42e14f408856..1ef3d16a8bda 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3432,6 +3432,7 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
>  	struct cifs_tcon *tcon = mnt_ctx->tcon;
>  	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
>  	char *full_path;
> +	bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
>  
>  	if (!server->ops->is_path_accessible)
>  		return -EOPNOTSUPP;
> @@ -3449,14 +3450,20 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
>  	rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
>  					     full_path);
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> -	if (rc == -ENOENT && is_tcon_dfs(tcon))
> +	if (nodfs) {
> +		if (rc == -EREMOTE)
> +			rc = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	/* path *might* exist with non-ASCII characters in DFS root
> +	 * try again with full path (only if nodfs is not set) */
> +	if (rc == -ENOENT && is_tcon_dfs(tcon) && !nodfs)

You can get rid of !nodfs check since it is useless.  The comment might
be kept, though.

Other than that,

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>

Steve, please mark it for stable.
