Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4928DC636CC
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Feb 2023 02:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBHCHc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Feb 2023 21:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjBHCHa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Feb 2023 21:07:30 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E374108E
        for <linux-cifs@vger.kernel.org>; Tue,  7 Feb 2023 18:07:19 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id AC7DD7FEB9;
        Wed,  8 Feb 2023 02:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1675822038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YkXtka0jscHuMG9IQ9qHhuO4v2nVovzMIqRhzwdYgIg=;
        b=SU8ZOMzEPGlUvcsR0Ts3AIuPXXuP2qlu88kNj0B4y4vpsR/AHjtbtAT2E+/QhuaDHjAO8l
        GaPaR0Un30FE+aPPOv6cxkHiBWDErqzBpejOskIMEPIF2X08q7A3mxdlUtdrwzB+moIfRa
        gl5VqhZMcIoAhu2DzBdMuCCv/ut0/zW6mebvSAu9pwjlZtiv3GukhBNEh0ZQ5qrG79wLdM
        dyXnfMhQ6W87grALLaAVYUwUbRYq+u9pRGDW0vGAjrvIcGFDY/x6fvO26jW7hDvaHO/qe0
        WTENFNtoStnZ+Aj58RfnnTpROQzrHcK3+MUE8oIDFuGXxYmoH7v5TzNkjH0qGQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/2] cifs: set DFS root session in cifs_get_smb_ses()
Date:   Tue,  7 Feb 2023 23:06:48 -0300
Message-Id: <20230208020648.30073-2-pc@cjr.nz>
In-Reply-To: <20230208020648.30073-1-pc@cjr.nz>
References: <20230208020648.30073-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set the DFS root session pointer earlier when creating a new SMB
session to prevent racing with smb2_reconnect() and DFS cache
refresher.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifs_dfs_ref.c |  1 +
 fs/cifs/cifsglob.h     |  1 -
 fs/cifs/connect.c      |  6 ++++++
 fs/cifs/dfs.c          | 19 ++++++++-----------
 fs/cifs/dfs.h          |  3 ++-
 fs/cifs/fs_context.h   |  1 +
 6 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 2b1a8d55b4ec..cb40074feb3e 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -179,6 +179,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 	tmp.source = full_path;
 	tmp.leaf_fullpath = NULL;
 	tmp.UNC = tmp.prepath = NULL;
+	tmp.dfs_root_ses = NULL;
 
 	rc = smb3_fs_context_dup(ctx, &tmp);
 	if (rc) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index cfdd5bf701a1..f0a88b0ae31b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1767,7 +1767,6 @@ struct cifs_mount_ctx {
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
-	struct cifs_ses *root_ses;
 	uuid_t mount_id;
 	char *origin_fullpath, *leaf_fullpath;
 };
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b2a04b4e89a5..70e7795a56b1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2278,6 +2278,12 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	 * need to lock before changing something in the session.
 	 */
 	spin_lock(&cifs_tcp_ses_lock);
+	/*
+	 * Set refcounted DFS root session.  Its lifetime is managed by DFS cache.
+	 *
+	 * For more information, see dfs_cache_{add,put}_refsrv_sessions().
+	 */
+	ses->dfs_root_ses = ctx->dfs_root_ses;
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index b64d20374b9c..6505f1b20147 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -95,25 +95,22 @@ static int get_session(struct cifs_mount_ctx *mnt_ctx, const char *full_path)
 	ctx->leaf_fullpath = (char *)full_path;
 	rc = cifs_mount_get_session(mnt_ctx);
 	ctx->leaf_fullpath = NULL;
-	if (!rc) {
-		struct cifs_ses *ses = mnt_ctx->ses;
 
-		mutex_lock(&ses->session_mutex);
-		ses->dfs_root_ses = mnt_ctx->root_ses;
-		mutex_unlock(&ses->session_mutex);
-	}
 	return rc;
 }
 
 static void set_root_ses(struct cifs_mount_ctx *mnt_ctx)
 {
-	if (mnt_ctx->ses) {
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
+	struct cifs_ses *ses = mnt_ctx->ses;
+
+	if (ses) {
 		spin_lock(&cifs_tcp_ses_lock);
-		mnt_ctx->ses->ses_count++;
+		ses->ses_count++;
 		spin_unlock(&cifs_tcp_ses_lock);
-		dfs_cache_add_refsrv_session(&mnt_ctx->mount_id, mnt_ctx->ses);
+		dfs_cache_add_refsrv_session(&mnt_ctx->mount_id, ses);
 	}
-	mnt_ctx->root_ses = mnt_ctx->ses;
+	ctx->dfs_root_ses = mnt_ctx->ses;
 }
 
 static int get_dfs_conn(struct cifs_mount_ctx *mnt_ctx, const char *ref_path, const char *full_path,
@@ -260,7 +257,7 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 	rc = get_session(mnt_ctx, NULL);
 	if (rc)
 		return rc;
-	mnt_ctx->root_ses = mnt_ctx->ses;
+	ctx->dfs_root_ses = mnt_ctx->ses;
 	/*
 	 * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwise unconditionally
 	 * try to get an DFS referral (even cached) to determine whether it is an DFS mount.
diff --git a/fs/cifs/dfs.h b/fs/cifs/dfs.h
index 344bea6d8bab..baf16df55d7e 100644
--- a/fs/cifs/dfs.h
+++ b/fs/cifs/dfs.h
@@ -22,9 +22,10 @@ static inline char *dfs_get_path(struct cifs_sb_info *cifs_sb, const char *path)
 static inline int dfs_get_referral(struct cifs_mount_ctx *mnt_ctx, const char *path,
 				   struct dfs_info3_param *ref, struct dfs_cache_tgt_list *tl)
 {
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
 
-	return dfs_cache_find(mnt_ctx->xid, mnt_ctx->root_ses, cifs_sb->local_nls,
+	return dfs_cache_find(mnt_ctx->xid, ctx->dfs_root_ses, cifs_sb->local_nls,
 			      cifs_remap(cifs_sb), path, ref, tl);
 }
 
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 44cb5639ed3b..1b8d4e27f831 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -265,6 +265,7 @@ struct smb3_fs_context {
 	bool rootfs:1; /* if it's a SMB root file system */
 	bool witness:1; /* use witness protocol */
 	char *leaf_fullpath;
+	struct cifs_ses *dfs_root_ses;
 };
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
-- 
2.39.1

