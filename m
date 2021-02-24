Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02911C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C420E64F0F
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhBYAAr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 19:00:47 -0500
Received: from mx.cjr.nz ([51.158.111.142]:15446 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234266AbhBYAAq (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Feb 2021 19:00:46 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 3F11F7FF6A;
        Thu, 25 Feb 2021 00:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1614211203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lbdi9TuKQIsn1toCiLXfI23dKV9w1p0lGiFiBxRyb7c=;
        b=Qlf08YqqPYcbWnsHS7h+7qVP36se3LrmuwyN2Fhj5c1/PStS1fIX6VnRZUIHfHAOlrFWWp
        hZI40cPMuZ4lImusQu8AyttebTVT4W3BeOXXPRdUoHOGgQKpylpNT7e36GBS5//jBvINve
        c0hJoOPktUctoKukcSSLBQivKtVid/wMV/EO7UChRmI4NBh8r7NlmFPPdSwh5paVVdaVpq
        PWC5PaS1ybfVFhS1duyKz16ssyCgo1FJ2fTBbltnI977oXNq/MiMxQzzyzXlKLVob8N+HS
        dNIXRbYXk9N7p9LmLx9RFwRe7YWGQsWIsSiz68wWBd5Rnfz1tpq37fxwqYQUow==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/4] cifs: fix DFS failover
Date:   Wed, 24 Feb 2021 20:59:21 -0300
Message-Id: <20210224235924.29931-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In do_dfs_failover(), the mount_get_conns() function requires the full
fs context in order to get new connection to server, so clone the
original context and change it accordingly when retrying the DFS
targets in the referral.

If failover was successful, then update original context with the new
UNC, prefix path and ip address.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 123 ++++++++++++++++++++++------------------------
 1 file changed, 59 insertions(+), 64 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cd6dbeaf2166..a800e055c614 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3045,96 +3045,91 @@ static int update_vol_info(const struct dfs_cache_tgt_iterator *tgt_it,
 	return 0;
 }
 
-static int setup_dfs_tgt_conn(const char *path, const char *full_path,
-			      const struct dfs_cache_tgt_iterator *tgt_it,
-			      struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
-			      unsigned int *xid, struct TCP_Server_Info **server,
-			      struct cifs_ses **ses, struct cifs_tcon **tcon)
-{
-	int rc;
-	struct dfs_info3_param ref = {0};
-	char *mdata = NULL;
-	struct smb3_fs_context fake_ctx = {NULL};
-	char *fake_devname = NULL;
-
-	cifs_dbg(FYI, "%s: dfs path: %s\n", __func__, path);
-
-	rc = dfs_cache_get_tgt_referral(path, tgt_it, &ref);
-	if (rc)
-		return rc;
-
-	mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
-					   full_path + 1, &ref,
-					   &fake_devname);
-	free_dfs_info_param(&ref);
-
-	if (IS_ERR(mdata)) {
-		rc = PTR_ERR(mdata);
-		mdata = NULL;
-	} else
-		rc = cifs_setup_volume_info(&fake_ctx, mdata, fake_devname);
-
-	kfree(mdata);
-	kfree(fake_devname);
-
-	if (!rc) {
-		/*
-		 * We use a 'fake_ctx' here because we need pass it down to the
-		 * mount_{get,put} functions to test connection against new DFS
-		 * targets.
-		 */
-		mount_put_conns(cifs_sb, *xid, *server, *ses, *tcon);
-		rc = mount_get_conns(&fake_ctx, cifs_sb, xid, server, ses,
-				     tcon);
-		if (!rc || (*server && *ses)) {
-			/*
-			 * We were able to connect to new target server.
-			 * Update current context with new target server.
-			 */
-			rc = update_vol_info(tgt_it, &fake_ctx, ctx);
-		}
-	}
-	smb3_cleanup_fs_context_contents(&fake_ctx);
-	return rc;
-}
-
 static int do_dfs_failover(const char *path, const char *full_path, struct cifs_sb_info *cifs_sb,
 			   struct smb3_fs_context *ctx, struct cifs_ses *root_ses,
 			   unsigned int *xid, struct TCP_Server_Info **server,
 			   struct cifs_ses **ses, struct cifs_tcon **tcon)
 {
 	int rc;
-	struct dfs_cache_tgt_list tgt_list;
+	struct dfs_cache_tgt_list tgt_list = {0};
 	struct dfs_cache_tgt_iterator *tgt_it = NULL;
+	struct smb3_fs_context tmp_ctx = {NULL};
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
 		return -EOPNOTSUPP;
 
+	cifs_dbg(FYI, "%s: path=%s full_path=%s\n", __func__, path, full_path);
+
 	rc = dfs_cache_noreq_find(path, NULL, &tgt_list);
 	if (rc)
 		return rc;
+	/*
+	 * We use a 'tmp_ctx' here because we need pass it down to the mount_{get,put} functions to
+	 * test connection against new DFS targets.
+	 */
+	rc = smb3_fs_context_dup(&tmp_ctx, ctx);
+	if (rc)
+		goto out;
 
 	for (;;) {
+		struct dfs_info3_param ref = {0};
+		char *fake_devname = NULL, *mdata = NULL;
+
 		/* Get next DFS target server - if any */
 		rc = get_next_dfs_tgt(path, &tgt_list, &tgt_it);
 		if (rc)
 			break;
-		/* Connect to next DFS target */
-		rc = setup_dfs_tgt_conn(path, full_path, tgt_it, cifs_sb, ctx, xid, server, ses,
-					tcon);
-		if (!rc || (*server && *ses))
+
+		rc = dfs_cache_get_tgt_referral(path, tgt_it, &ref);
+		if (rc)
 			break;
+
+		cifs_dbg(FYI, "%s: old ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
+			 tmp_ctx.prepath);
+
+		mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options, full_path + 1, &ref,
+						   &fake_devname);
+		free_dfs_info_param(&ref);
+
+		if (IS_ERR(mdata)) {
+			rc = PTR_ERR(mdata);
+			mdata = NULL;
+		} else
+			rc = cifs_setup_volume_info(&tmp_ctx, mdata, fake_devname);
+
+		kfree(mdata);
+		kfree(fake_devname);
+
+		if (rc)
+			break;
+
+		cifs_dbg(FYI, "%s: new ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
+			 tmp_ctx.prepath);
+
+		mount_put_conns(cifs_sb, *xid, *server, *ses, *tcon);
+		rc = mount_get_conns(&tmp_ctx, cifs_sb, xid, server, ses, tcon);
+		if (!rc || (*server && *ses)) {
+			/*
+			 * We were able to connect to new target server. Update current context with
+			 * new target server.
+			 */
+			rc = update_vol_info(tgt_it, &tmp_ctx, ctx);
+			break;
+		}
 	}
 	if (!rc) {
+		cifs_dbg(FYI, "%s: final ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
+			 tmp_ctx.prepath);
 		/*
-		 * Update DFS target hint in DFS referral cache with the target
-		 * server we successfully reconnected to.
+		 * Update DFS target hint in DFS referral cache with the target server we
+		 * successfully reconnected to.
 		 */
-		rc = dfs_cache_update_tgthint(*xid, root_ses ? root_ses : *ses,
-					      cifs_sb->local_nls,
-					      cifs_remap(cifs_sb), path,
-					      tgt_it);
+		rc = dfs_cache_update_tgthint(*xid, root_ses ? root_ses : *ses, cifs_sb->local_nls,
+					      cifs_remap(cifs_sb), path, tgt_it);
 	}
+
+out:
+	smb3_cleanup_fs_context_contents(&tmp_ctx);
 	dfs_cache_free_tgts(&tgt_list);
 	return rc;
 }
-- 
2.30.1

