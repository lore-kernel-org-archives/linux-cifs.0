Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435A8C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFFF864F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhBYAAs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 19:00:48 -0500
Received: from mx.cjr.nz ([51.158.111.142]:15470 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234610AbhBYAAs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Feb 2021 19:00:48 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id AA8427FF6B;
        Thu, 25 Feb 2021 00:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1614211206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FleaF1MqsU4SpQwM9MXK+dYb6wT1gkx6vRFOAfGUzFI=;
        b=VTRbahvAXdBatRaBQbWR5txgzJEH3LzsxTL0fuLBF45qg8Syawryhfo7VNxee0A2CRbYai
        lG4X71nmC1n9r5gPwNNxci/L5/FriOg0uQrLFkRyzzoDUtUMBVIZjR2L9ICfvARjR1nDIy
        6nLRNVz2nTQa647Ww4s+QVnCmJ/aZhVDZEFzbatdjwwXO7Hvdtqr16ct1niVH6L5b5OJRX
        Es6wx+/6X3XRzsHFIbkFukzPCdHixGmYA9LW39E//PnoNtx9a8DJp0VD8CpdSEMcch0afO
        nQaZU/f9GemlJIRy5M7fK1KToYlyaTssbQfhE9NpiHhxbJ4YW21e4ZTrzxP5FQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/4] cifs: check all path components in resolved dfs target
Date:   Wed, 24 Feb 2021 20:59:22 -0300
Message-Id: <20210224235924.29931-2-pc@cjr.nz>
In-Reply-To: <20210224235924.29931-1-pc@cjr.nz>
References: <20210224235924.29931-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Handle the case where a resolved target share is like
//server/users/dir, and the user "foo" has no read permission to
access the parent folder "users" but has access to the final path
component "dir".

is_path_remote() already implements that, so call it directly.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 93 +++++++++++++++++------------------------------
 1 file changed, 33 insertions(+), 60 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a800e055c614..f1729890aca5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3287,73 +3287,46 @@ static void put_root_ses(struct cifs_ses *ses)
 		cifs_put_smb_ses(ses);
 }
 
-/* Check if a path component is remote and then update @dfs_path accordingly */
-static int check_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
-			     const unsigned int xid, struct TCP_Server_Info *server,
-			     struct cifs_tcon *tcon, char **dfs_path)
+/* Set up next dfs prefix path in @dfs_path */
+static int next_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
+			    const unsigned int xid, struct TCP_Server_Info *server,
+			    struct cifs_tcon *tcon, char **dfs_path)
 {
-	char *path, *s;
-	char sep = CIFS_DIR_SEP(cifs_sb), tmp;
-	char *npath;
-	int rc = 0;
-	int added_treename = tcon->Flags & SMB_SHARE_IS_IN_DFS;
-	int skip = added_treename;
+	char *path, *npath;
+	int added_treename = is_tcon_dfs(tcon);
+	int rc;
 
 	path = cifs_build_path_to_root(ctx, cifs_sb, tcon, added_treename);
 	if (!path)
 		return -ENOMEM;
 
-	/*
-	 * Walk through the path components in @path and check if they're accessible. In case any of
-	 * the components is -EREMOTE, then update @dfs_path with the next DFS referral request path
-	 * (NOT including the remaining components).
-	 */
-	s = path;
-	do {
-		/* skip separators */
-		while (*s && *s == sep)
-			s++;
-		if (!*s)
-			break;
-		/* next separator */
-		while (*s && *s != sep)
-			s++;
-		/*
-		 * if the treename is added, we then have to skip the first
-		 * part within the separators
-		 */
-		if (skip) {
-			skip = 0;
-			continue;
+	rc = is_path_remote(cifs_sb, ctx, xid, server, tcon);
+	if (rc == -EREMOTE) {
+		struct smb3_fs_context v = {NULL};
+		/* if @path contains a tree name, skip it in the prefix path */
+		if (added_treename) {
+			rc = smb3_parse_devname(path, &v);
+			if (rc)
+				goto out;
+			npath = build_unc_path_to_root(&v, cifs_sb, true);
+			smb3_cleanup_fs_context_contents(&v);
+		} else {
+			v.UNC = ctx->UNC;
+			v.prepath = path + 1;
+			npath = build_unc_path_to_root(&v, cifs_sb, true);
 		}
-		tmp = *s;
-		*s = 0;
-		rc = server->ops->is_path_accessible(xid, tcon, cifs_sb, path);
-		if (rc && rc == -EREMOTE) {
-			struct smb3_fs_context v = {NULL};
-			/* if @path contains a tree name, skip it in the prefix path */
-			if (added_treename) {
-				rc = smb3_parse_devname(path, &v);
-				if (rc)
-					break;
-				rc = -EREMOTE;
-				npath = build_unc_path_to_root(&v, cifs_sb, true);
-				smb3_cleanup_fs_context_contents(&v);
-			} else {
-				v.UNC = ctx->UNC;
-				v.prepath = path + 1;
-				npath = build_unc_path_to_root(&v, cifs_sb, true);
-			}
-			if (IS_ERR(npath)) {
-				rc = PTR_ERR(npath);
-				break;
-			}
-			kfree(*dfs_path);
-			*dfs_path = npath;
+
+		if (IS_ERR(npath)) {
+			rc = PTR_ERR(npath);
+			goto out;
 		}
-		*s = tmp;
-	} while (rc == 0);
 
+		kfree(*dfs_path);
+		*dfs_path = npath;
+		rc = -EREMOTE;
+	}
+
+out:
 	kfree(path);
 	return rc;
 }
@@ -3439,8 +3412,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			put_root_ses(root_ses);
 			set_root_ses(cifs_sb, ses, &root_ses);
 		}
-		/* Check for remaining path components and then continue chasing them (-EREMOTE) */
-		rc = check_dfs_prepath(cifs_sb, ctx, xid, server, tcon, &ref_path);
+		/* Get next dfs path and then continue chasing them if -EREMOTE */
+		rc = next_dfs_prepath(cifs_sb, ctx, xid, server, tcon, &ref_path);
 		/* Prevent recursion on broken link referrals */
 		if (rc == -EREMOTE && ++count > MAX_NESTED_LINKS)
 			rc = -ELOOP;
-- 
2.30.1

