Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85E1C6FD1F
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Mar 2023 23:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCNXdJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Mar 2023 19:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCNXdI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Mar 2023 19:33:08 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F4338B44
        for <linux-cifs@vger.kernel.org>; Tue, 14 Mar 2023 16:33:06 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678836784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nT7693H1iSjnvgTh2/cG6Uh6bWg78yeIxGCdd0Qr51c=;
        b=JqXtHF1XdJWXqIutS7BxIlPIdTBC6AGGMN1gRr0+wpgxsCylZ8jjJ+5JmuZj6otGxOx5/r
        5jjswvfHkXBgHOdfaiwclsnw1KpSSosXnWSXBRGzCjJVOeH0ZAnhhRNvEIcQd3uvvPkY7L
        BLluPZlGfh/HX8qNUnqyMsvoWAIiU4GzG/kGhLily059pTJn82lVcD0HqpMkSu+7lsr7Ji
        pnFCUmWeMs+SoPwYsNPAScRWL3peQWhGrFNlYkjZ1094gFzeMZG30KkvXgLX9wc/0612hp
        OcM0QSrxNSWYdVb6O/uvNxm7FiLpVBLkEzrcaAByedtwdABQRplGimRP3IIK5A==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1678836784; a=rsa-sha256;
        cv=none;
        b=EXoJl2JOEUwEgENWGD8Wiybq8w8LaQk/lcllrnkZEGOWsjsuw1R8rNsu2Q4JoJ5ApsnbnA
        M8S6SL+8t3XGiAClZwx5ZhD8WnGGLf/N8BSo3JQqJ3B0zwUIxmVPUKX2K8rpEdC0mMdxUu
        /tNeWalDFm9vppDIapHvj6SQIZHjTDOZsErmpPMWldmKg3i9MwyAFu66eVRIgl36ADAjFz
        qqTHfL+OZCUHn0d5w158woEOyR98YYrg+ZXAQTr8NJjZdI6HyxOm2Zdq1uuvZ/brgfkahd
        EvZ6arN2dRSXHICZj0Oi05McS+GNpTT/7SRr8rOFQy30RoylYMUMGSXdoG6fJA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678836784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nT7693H1iSjnvgTh2/cG6Uh6bWg78yeIxGCdd0Qr51c=;
        b=ZswbB0MbDNiQibe9Vqx9roD++pGzAVPRQlIlB31d/lYhrbIVJJZHKjMtKjHrIE+LU3rtfw
        aeAC35w+A5TpO3Kv9V962cG6y73sKV7LZqUbuNRiIPqYE3vK79A/59lJcX53zPMIeuFDH3
        nmuv6Aj700Lir1/hP4bhEnbks21KXU0zM1B3erAJ3IUueWBLXG0ehIN/5dD+05CBj0P5At
        IfwcP9q7xdUN2q48IORwtoRZUfxmxQ2E+NcGxozdST7anCayFKBAvIWxMBtA8b607Y6DdG
        iokgcIklQfB/gM3AqSeZ+XcSCQ8EjpAouLYPKKXk1pZEn7v4B99m+TOydQAiRw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/4] cifs: set DFS root session in cifs_get_smb_ses()
Date:   Tue, 14 Mar 2023 20:32:53 -0300
Message-Id: <20230314233256.16468-1-pc.crab@mail.manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set the DFS root session pointer earlier when creating a new SMB
session to prevent racing with smb2_reconnect(), cifs_reconnect_tcon()
and DFS cache refresher.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifs_dfs_ref.c |  1 +
 fs/cifs/cifsglob.h     |  1 -
 fs/cifs/connect.c      |  1 +
 fs/cifs/dfs.c          | 19 ++++++++-----------
 fs/cifs/dfs.h          |  3 ++-
 fs/cifs/fs_context.h   |  1 +
 6 files changed, 13 insertions(+), 13 deletions(-)

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
index 8a37b1553dc6..a6f3e03e5790 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1749,7 +1749,6 @@ struct cifs_mount_ctx {
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
-	struct cifs_ses *root_ses;
 	uuid_t mount_id;
 	char *origin_fullpath, *leaf_fullpath;
 };
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3d07729c91a1..5038dcd045b9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2229,6 +2229,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	 * need to lock before changing something in the session.
 	 */
 	spin_lock(&cifs_tcp_ses_lock);
+	ses->dfs_root_ses = ctx->dfs_root_ses;
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index d37af02902c5..eb35259b48fa 100644
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
2.39.2

