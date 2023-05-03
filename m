Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70A5C77B75
	for <linux-cifs@archiver.kernel.org>; Wed,  3 May 2023 22:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjECWVy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 May 2023 18:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjECWVx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 May 2023 18:21:53 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F38483F5
        for <linux-cifs@vger.kernel.org>; Wed,  3 May 2023 15:21:51 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Vd/hSgy1EF/FYLB8WYUS62wsU2EuSqXp/511/3d0Zw=;
        b=fTUXJcRoBw8i5+i9XKarp7rQHf0nQLOLMZH3OGFBThi9YegOpej2WdkQ9L09VmFLJfvmHb
        6w0n86l0Wv00jd2aPMAvjTTAsbW0SIIONzU1GyplqeMtL7lIAQZNLUAm0HAwfp1Nu83Ypt
        zrp3xp0tAF2BEadeLGKoWB18pOsGBOKC4EjFupkntZDj83DxnSRu6vlvGljg2VbnQ0Lscs
        mqS1BQ0xP4/yFFBih8jlc9qh0SEXa6YCfygd54jvbZSA6rMDLmQ0VXFtwOx2DIceE8dEyQ
        WMwk+lCrYHs3/n208Q3Ez5O3M4v15VHDIOzYlt+rBTtlxlwcIP930/TAmmPcHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Vd/hSgy1EF/FYLB8WYUS62wsU2EuSqXp/511/3d0Zw=;
        b=aXyOUfP6PQY0fTuByZC8ZaB8n4wab6+OSmfEvI7mqtDEUGel6fucuPmrqpeqvqyNv04mk6
        jddsLOCsF8i1fwsBrRhaefmcnwwdhheqHCY4oy6dPv7qfLuDQTwMgHFvVJpH1HuTMcme/f
        A8cuZVvZDWrE2ffDEefcinkSDWdGHGnt7IydsMyuQyBabJ5vwe50Rm+YWrOc5k112RveY9
        chOtOaOCLxS+vvY3LYZV6mFUdAYlHGSObwF7yli4Eo2+XkQJVULVOwIfpgktoXBL+d+58O
        +cC5Xrx7aEcK5wZqQxkqUPldHaWFLLXk+nCo1VBwEEe05TWMMbySxy5mybfbIw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1683152509; a=rsa-sha256;
        cv=none;
        b=lkeJPKHHUj77c5PQxZhd1Oqn3A1P9B6dvwq2z+KmHxXcN0Oum5Z59QE1F0dWpYw2mUaBCq
        Ur4acAMqbUaJMzz26k1sU2gZDko2rCQyWrcM7G0uhpA7GY5RTSEV/JO4ITm3RGu9ILwpgR
        vNLslmwC+Lyl8cnBdySLT+DoglryadU5AzhHHQmvtnbh9mKhGOsWTtuKWeXeknw533/tta
        q5/vus+HtO8Jv2suGpGwGaO7sErjvcESnvUj//12J4Vj58gF22yLHCBMdZ0r9f1pJIciJN
        GOhcSHtEuHiaef3HqFNbxXTRRLJsKW1uyAzQ4eJPOojJRegNHTMK53X8jyZrhQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/7] cifs: protect access of TCP_Server_Info::{origin,leaf}_fullpath
Date:   Wed,  3 May 2023 19:21:14 -0300
Message-Id: <20230503222117.7609-5-pc@manguebit.com>
In-Reply-To: <20230503222117.7609-1-pc@manguebit.com>
References: <20230503222117.7609-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Protect access of TCP_Server_Info::{origin,leaf}_fullpath when
matching DFS connections, and get rid of
TCP_Server_Info::current_fullpath while we're at it.

Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifsglob.h  | 20 +++++++++++++-------
 fs/cifs/connect.c   | 10 ++++++----
 fs/cifs/dfs.c       | 14 ++++++++------
 fs/cifs/dfs.h       | 13 +++++++++++--
 fs/cifs/dfs_cache.c |  6 +++++-
 5 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 08a73dcb7786..a62447404851 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -736,17 +736,23 @@ struct TCP_Server_Info {
 #endif
 	struct mutex refpath_lock; /* protects leaf_fullpath */
 	/*
-	 * Canonical DFS full paths that were used to chase referrals in mount and reconnect.
+	 * origin_fullpath: Canonical copy of smb3_fs_context::source.
+	 *                  It is used for matching existing DFS tcons.
 	 *
-	 * origin_fullpath: first or original referral path
-	 * leaf_fullpath: last referral path (might be changed due to nested links in reconnect)
+	 * leaf_fullpath: Canonical DFS referral path related to this
+	 *                connection.
+	 *                It is used in DFS cache refresher, reconnect and may
+	 *                change due to nested DFS links.
 	 *
-	 * current_fullpath: pointer to either origin_fullpath or leaf_fullpath
-	 * NOTE: cannot be accessed outside cifs_reconnect() and smb2_reconnect()
+	 * Both protected by @refpath_lock and @srv_lock.  The @refpath_lock is
+	 * mosly used for not requiring a copy of @leaf_fullpath when getting
+	 * cached or new DFS referrals (which might also sleep during I/O).
+	 * While @srv_lock is held for making string and NULL comparions against
+	 * both fields as in mount(2) and cache refresh.
 	 *
-	 * format: \\HOST\SHARE\[OPTIONAL PATH]
+	 * format: \\HOST\SHARE[\OPTIONAL PATH]
 	 */
-	char *origin_fullpath, *leaf_fullpath, *current_fullpath;
+	char *origin_fullpath, *leaf_fullpath;
 };
 
 static inline bool is_smb1(struct TCP_Server_Info *server)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index eee8b31c1eaf..340bd7cf64f3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -454,7 +454,6 @@ static int reconnect_target_unlocked(struct TCP_Server_Info *server, struct dfs_
 static int reconnect_dfs_server(struct TCP_Server_Info *server)
 {
 	int rc = 0;
-	const char *refpath = server->current_fullpath + 1;
 	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
 	struct dfs_cache_tgt_iterator *target_hint = NULL;
 	int num_targets = 0;
@@ -467,8 +466,10 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 	 * through /proc/fs/cifs/dfscache or the target list is empty due to server settings after
 	 * refreshing the referral, so, in this case, default it to 1.
 	 */
-	if (!dfs_cache_noreq_find(refpath, NULL, &tl))
+	mutex_lock(&server->refpath_lock);
+	if (!dfs_cache_noreq_find(server->leaf_fullpath + 1, NULL, &tl))
 		num_targets = dfs_cache_get_nr_tgts(&tl);
+	mutex_unlock(&server->refpath_lock);
 	if (!num_targets)
 		num_targets = 1;
 
@@ -512,7 +513,9 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 	} while (server->tcpStatus == CifsNeedReconnect);
 
-	dfs_cache_noreq_update_tgthint(refpath, target_hint);
+	mutex_lock(&server->refpath_lock);
+	dfs_cache_noreq_update_tgthint(server->leaf_fullpath + 1, target_hint);
+	mutex_unlock(&server->refpath_lock);
 	dfs_cache_free_tgts(&tl);
 
 	/* Need to set up echo worker again once connection has been established */
@@ -1582,7 +1585,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 			rc = -ENOMEM;
 			goto out_err;
 		}
-		tcp_ses->current_fullpath = tcp_ses->leaf_fullpath;
 	}
 
 	if (ctx->nosharesock)
diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index 37f7da4f5c8b..c4ec5c67087b 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -248,11 +248,12 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 		tcon = mnt_ctx->tcon;
 
 		mutex_lock(&server->refpath_lock);
+		spin_lock(&server->srv_lock);
 		if (!server->origin_fullpath) {
 			server->origin_fullpath = origin_fullpath;
-			server->current_fullpath = server->leaf_fullpath;
 			origin_fullpath = NULL;
 		}
+		spin_unlock(&server->srv_lock);
 		mutex_unlock(&server->refpath_lock);
 
 		if (list_empty(&tcon->dfs_ses_list)) {
@@ -342,10 +343,11 @@ static int update_server_fullpath(struct TCP_Server_Info *server, struct cifs_sb
 		rc = PTR_ERR(npath);
 	} else {
 		mutex_lock(&server->refpath_lock);
+		spin_lock(&server->srv_lock);
 		kfree(server->leaf_fullpath);
 		server->leaf_fullpath = npath;
+		spin_unlock(&server->srv_lock);
 		mutex_unlock(&server->refpath_lock);
-		server->current_fullpath = server->leaf_fullpath;
 	}
 	return rc;
 }
@@ -450,7 +452,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 		share = prefix = NULL;
 
 		/* Check if share matches with tcp ses */
-		rc = dfs_cache_get_tgt_share(server->current_fullpath + 1, tit, &share, &prefix);
+		rc = dfs_cache_get_tgt_share(server->leaf_fullpath + 1, tit, &share, &prefix);
 		if (rc) {
 			cifs_dbg(VFS, "%s: failed to parse target share: %d\n", __func__, rc);
 			break;
@@ -464,7 +466,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 			continue;
 		}
 
-		dfs_cache_noreq_update_tgthint(server->current_fullpath + 1, tit);
+		dfs_cache_noreq_update_tgthint(server->leaf_fullpath + 1, tit);
 		tree_connect_ipc(xid, tree, cifs_sb, tcon);
 
 		scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
@@ -582,8 +584,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	cifs_sb = CIFS_SB(sb);
 
 	/* If it is not dfs or there was no cached dfs referral, then reconnect to same share */
-	if (!server->current_fullpath ||
-	    dfs_cache_noreq_find(server->current_fullpath + 1, &ref, &tl)) {
+	if (!server->leaf_fullpath ||
+	    dfs_cache_noreq_find(server->leaf_fullpath + 1, &ref, &tl)) {
 		rc = ops->tree_connect(xid, tcon->ses, tcon->tree_name, tcon, cifs_sb->local_nls);
 		goto out;
 	}
diff --git a/fs/cifs/dfs.h b/fs/cifs/dfs.h
index 0b8cbf721fff..1c90df5ecfbd 100644
--- a/fs/cifs/dfs.h
+++ b/fs/cifs/dfs.h
@@ -43,8 +43,12 @@ static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
 	size_t len;
 	char *s;
 
-	if (unlikely(!server->origin_fullpath))
+	spin_lock(&server->srv_lock);
+	if (unlikely(!server->origin_fullpath)) {
+		spin_unlock(&server->srv_lock);
 		return ERR_PTR(-EREMOTE);
+	}
+	spin_unlock(&server->srv_lock);
 
 	s = dentry_path_raw(dentry, page, PATH_MAX);
 	if (IS_ERR(s))
@@ -53,13 +57,18 @@ static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
 	if (!s[1])
 		s++;
 
+	spin_lock(&server->srv_lock);
 	len = strlen(server->origin_fullpath);
-	if (s < (char *)page + len)
+	if (s < (char *)page + len) {
+		spin_unlock(&server->srv_lock);
 		return ERR_PTR(-ENAMETOOLONG);
+	}
 
 	s -= len;
 	memcpy(s, server->origin_fullpath, len);
+	spin_unlock(&server->srv_lock);
 	convert_delimiter(s, '/');
+
 	return s;
 }
 
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 30cbdf8514a5..6557d7b2798a 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1278,8 +1278,12 @@ static void refresh_cache_worker(struct work_struct *work)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		if (!server->leaf_fullpath)
+		spin_lock(&server->srv_lock);
+		if (!server->leaf_fullpath) {
+			spin_unlock(&server->srv_lock);
 			continue;
+		}
+		spin_unlock(&server->srv_lock);
 
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			if (ses->tcon_ipc) {
-- 
2.40.1

