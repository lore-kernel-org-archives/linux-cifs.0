Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68560C3065E
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352419AbjHQPfl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353239AbjHQPf3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:29 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFEC2D6D
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:27 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5sDc5pFn6z1YkHDjOq7mz8EOz9Xku5PjOJn7NmkFYSQ=;
        b=LMW2rQHWZOmyBnN4q6+p6W0ROjYEX2UA5OXI57Rfyd0xbo0sgZmUcScGLPTFdZd4g+CWE9
        N9ex/nWpeEQG11q+z95IdgKamsYelPWxxM1m+EtJ+dpzJdYKYGdDMn6Pw7yD/j03jpa0oY
        viC/hQsmFLHoqYTsmljx62mkq5IpkBwDAFN6kNJSQ56f/pIvkLPiqEJEfjRK8Qjvp/pTuM
        h3g+IBydGUhw/JVbUpAOZ7izAbtfY8Mt1ve3AhA5Efk0r71wHX4TfBtE8/l14IAUxHtHDS
        6nednPAFIJPNJL97YuZt/VNvWKcktHbEaHjM9svwbAvLqAtcv3fKG5yzrs4TCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5sDc5pFn6z1YkHDjOq7mz8EOz9Xku5PjOJn7NmkFYSQ=;
        b=aJp1yAXZPVZzCFzn4U98S646kj6B9j6qDy82a9vphZC4UwFEfMIWuW6Qp/sl0INahpfVgq
        4lMmlbKfpTeTdlQ3lI6x5wYmp6tS9iEZm1ZdoLEANL+X0JzrYWzpa4sZV7RkS5q3EfWfFx
        Fg95bsMlpyywCsoFr3lpA936Qe6D5RuMnEfYOin2LEzR3ti6keIAnJ5zHqOPan9+GlgOuF
        ngIWA8iNw1pVmlgxEoZH82qkJng7jGHHLIbOP8B4auYR0vWjiX/1Kcer3gwrd0Lud7kndU
        WmKsdKqKEtSXtjMdtL8/Ew9w9+sGm0imyaacNg4au+SPw9qeGPSmhR6Qp/H8Jg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286526; a=rsa-sha256;
        cv=none;
        b=E3+qD72Oirao4AgeQEs7lHTuVs/hTbmTV8GIsgChHgbrw3Q1FVxMBcDkpg8F753W3q9Vad
        BRmgh4JrkGQDoP0YgF3SOpz4DP/0E7/vzHb9AcFaNpmS1uiEpyfqHndLGimmR0JzhOoX9R
        4tqWT2Z/hnx3oOk8fREyDTCFiYp++RzsFiVJDVKWrNmnvV9lWXqZBRkYjA+JSBk466CcQ1
        CX+zm8TgJMy8PUM1kEsNMyHMbSSTWvyGW7Tzj+eRSvhPP2upyiSOg2PfBBmy0rEedtKOp/
        FqalRqTTJYQ/pf3Z61GQhYc2O228yhtuIbcpFyhh1rAdicBdy6p/uBT77Tb/BQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 01/17] smb: client: introduce DFS_CACHE_TGT_LIST()
Date:   Thu, 17 Aug 2023 12:33:59 -0300
Message-ID: <20230817153416.28083-2-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add new helper which declares and initialises target list of a DFS
referral rather having to do both separately.

No functional changes.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/connect.c   | 4 ++--
 fs/smb/client/dfs.c       | 6 +++---
 fs/smb/client/dfs_cache.c | 4 ++--
 fs/smb/client/dfs_cache.h | 6 +++++-
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 238538dde4e3..b3461d5d0f7d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -453,10 +453,10 @@ static int reconnect_target_unlocked(struct TCP_Server_Info *server, struct dfs_
 
 static int reconnect_dfs_server(struct TCP_Server_Info *server)
 {
-	int rc = 0;
-	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
 	struct dfs_cache_tgt_iterator *target_hint = NULL;
+	DFS_CACHE_TGT_LIST(tl);
 	int num_targets = 0;
+	int rc = 0;
 
 	/*
 	 * Determine the number of dfs targets the referral path in @cifs_sb resolves to.
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index ee772c3d9f00..c837800c49d4 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -174,7 +174,7 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	}
 
 	do {
-		struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
+		DFS_CACHE_TGT_LIST(tl);
 
 		rc = dfs_get_referral(mnt_ctx, ref_path + 1, NULL, &tl);
 		if (rc) {
@@ -426,7 +426,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 	/* Try to tree connect to all dfs targets */
 	for (; tit; tit = dfs_cache_get_next_tgt(tl, tit)) {
 		const char *target = dfs_cache_get_tgt_name(tit);
-		struct dfs_cache_tgt_list ntl = DFS_CACHE_TGT_LIST_INIT(ntl);
+		DFS_CACHE_TGT_LIST(ntl);
 
 		kfree(share);
 		kfree(prefix);
@@ -520,7 +520,7 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	int rc;
 	struct TCP_Server_Info *server = tcon->ses->server;
 	const struct smb_version_operations *ops = server->ops;
-	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
+	DFS_CACHE_TGT_LIST(tl);
 	struct cifs_sb_info *cifs_sb = NULL;
 	struct super_block *sb = NULL;
 	struct dfs_info3_param ref = {0};
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 33adf43a01f1..89b8af831a43 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1177,9 +1177,9 @@ static bool is_ses_good(struct cifs_ses *ses)
 /* Refresh dfs referral of tcon and mark it for reconnect if needed */
 static int __refresh_tcon(const char *path, struct cifs_ses *ses, bool force_refresh)
 {
-	struct dfs_cache_tgt_list old_tl = DFS_CACHE_TGT_LIST_INIT(old_tl);
-	struct dfs_cache_tgt_list new_tl = DFS_CACHE_TGT_LIST_INIT(new_tl);
 	struct TCP_Server_Info *server = ses->server;
+	DFS_CACHE_TGT_LIST(old_tl);
+	DFS_CACHE_TGT_LIST(new_tl);
 	bool needs_refresh = false;
 	struct cache_entry *ce;
 	unsigned int xid;
diff --git a/fs/smb/client/dfs_cache.h b/fs/smb/client/dfs_cache.h
index c6d89cd6d4fd..c6abc524855f 100644
--- a/fs/smb/client/dfs_cache.h
+++ b/fs/smb/client/dfs_cache.h
@@ -16,7 +16,11 @@
 extern struct workqueue_struct *dfscache_wq;
 extern atomic_t dfs_cache_ttl;
 
-#define DFS_CACHE_TGT_LIST_INIT(var) { .tl_numtgts = 0, .tl_list = LIST_HEAD_INIT((var).tl_list), }
+#define DFS_CACHE_TGT_LIST_INIT(var) \
+	{ .tl_numtgts = 0, .tl_list = LIST_HEAD_INIT((var).tl_list), }
+
+#define DFS_CACHE_TGT_LIST(var) \
+	struct dfs_cache_tgt_list var = DFS_CACHE_TGT_LIST_INIT(var)
 
 struct dfs_cache_tgt_list {
 	int tl_numtgts;
-- 
2.41.0

