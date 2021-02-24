Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378C7C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E888B6146B
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhBYAAw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 19:00:52 -0500
Received: from mx.cjr.nz ([51.158.111.142]:15550 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234584AbhBYAAv (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Feb 2021 19:00:51 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id DB2D280342;
        Thu, 25 Feb 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1614211210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L1aydCfOll087ZBxr1GqQrjLtH+4Gt2SkOruDFMvtRg=;
        b=Be5n8OIF5cenp2b1C1OIHZ00doSWaxK7qsrQvi9+LTy5ixXuHY9YQcces4O6o3z40WZjBk
        UX4S4MHpQ+w1FDwWhrJuUZee67NsbLsJB/MA9Xx3LnDnqD32BJskkf8a7UwtMwEbfjX9Mv
        CCVLk1GJJHpqDjg42NkrMJvgra6v67dD/EKkB3ozgDO4MElYrso/Z2gdupYk6J3ISpBS2K
        Fq34VGdBZ+tNPCu70nBsRyHbS95p8hiToqBMKJb0xXcxayMr8QjtdYM/ANLDZEYw7NeTJI
        niYwSNlnrMLWb3IgUDDKssRXR5PMbnIbOP3BaotWJduVTTg46bFSpevE2Y5lXw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 4/4] cifs: fix nodfs mount option
Date:   Wed, 24 Feb 2021 20:59:24 -0300
Message-Id: <20210224235924.29931-4-pc@cjr.nz>
In-Reply-To: <20210224235924.29931-1-pc@cjr.nz>
References: <20210224235924.29931-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Skip DFS resolving when mounting with 'nodfs' even if
CONFIG_CIFS_DFS_UPCALL is enabled.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 37452b2e24b8..6ab5f96fe1b4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3373,15 +3373,15 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 
 	rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
 	/*
-	 * Unconditionally try to get an DFS referral (even cached) to determine whether it is an
-	 * DFS mount.
+	 * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwise unconditionally
+	 * try to get an DFS referral (even cached) to determine whether it is an DFS mount.
 	 *
 	 * Skip prefix path to provide support for DFS referrals from w2k8 servers which don't seem
 	 * to respond with PATH_NOT_COVERED to requests that include the prefix.
 	 */
-	if (dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
+	    dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
 			   NULL)) {
-		/* No DFS referral was returned.  Looks like a regular share. */
 		if (rc)
 			goto error;
 		/* Check if it is fully accessible and then mount it */
-- 
2.30.1

