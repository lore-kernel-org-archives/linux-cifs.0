Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF9A2101B1;
	Wed,  4 Dec 2024 23:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733355303; cv=none; b=n6dt4EVyA3Z15R5o+61Musd5L6rmkVw0SoSRTIVrzYHeyuHC8AEM/ewnGGDAUdVR4YZ7dVKNCzKqMuM5qewyA16X61B+5jXizwPyGjLYW5H7Rrc0JZSlXrdLlKfM/zGVJCFz45TBObItUPqXY9u0gPXk1bCDKaWPV6ltmh+mmNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733355303; c=relaxed/simple;
	bh=adTCL/do/oOSbOd7oGH5zx91NR4XDjRHqW8saseRH/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChLAM6zI8E1ZCAokvHxwRFWhN0ynN+azSCnHaMZyyXwEMM+T2+EhxlHQ/wgFpzQU+CXkHLKKkrYRygmXj62h0RaDh2dyAyhWafr+oFaLBnbd5Ryyo6Fseufof8t8pXiYjqwLpUnMqkVR/Cn4KyhNN7a+3AQ8Agz4IF95Ed5lOqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2z2cPRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2z2cPRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33E9C4CECD;
	Wed,  4 Dec 2024 23:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733355302;
	bh=adTCL/do/oOSbOd7oGH5zx91NR4XDjRHqW8saseRH/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2z2cPRwuD2DBBfWoSPyp5jZ1YmKAva3Kfaw6Mw62riJ4LChmFiwWLUGe0ThKskiD
	 lsYdaeeBFMYVt/7NAbTUiItxVLhCSnhIyHYHm5/by0WNgL1jQmPfMdNvMhyN79gWdA
	 J/AFU6yrZZNQnDIGWMPM9EH1lHo13dZTP2B/xC+nfBmYbbGOtQ+EQbnG7SN6OTVWzJ
	 E4bjHu96PMRRrNrZh+e1nM3IIN/SJ3A12l57tCAqZtwDdJ9rHONLjSeXIwLiA6RIOZ
	 cyuU1tub4YsnvVwPf26Cn6wjia9mYcAisLn7aN8ApfUPNzNycM7HG7GV0ovO+0neUp
	 ooJxZRi8SUxPA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 6/8] smb: client: don't try following DFS links in cifs_tree_connect()
Date: Wed,  4 Dec 2024 17:23:22 -0500
Message-ID: <20241204222334.2249307-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204222334.2249307-1-sashal@kernel.org>
References: <20241204222334.2249307-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.1
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 36008fe6e3dc588e5e9ceae6e82c7f69399eb5d8 ]

We can't properly support chasing DFS links in cifs_tree_connect()
because

  (1) We don't support creating new sessions while we're reconnecting,
      which would be required for DFS interlinks.

  (2) ->is_path_accessible() can't be called from cifs_tree_connect()
     as it would deadlock with smb2_reconnect().  This is required for
     checking if new DFS target is a nested DFS link.

By unconditionally trying to get an DFS referral from new DFS target
isn't correct because if the new DFS target (interlink) is an DFS
standalone namespace, then we would end up getting -ELOOP and then
potentially leaving tcon disconnected.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/dfs.c | 188 ++++----------------------------------------
 1 file changed, 17 insertions(+), 171 deletions(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 3f6077c68d68a..c35953843373e 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -321,49 +321,6 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	return rc;
 }
 
-/* Update dfs referral path of superblock */
-static int update_server_fullpath(struct TCP_Server_Info *server, struct cifs_sb_info *cifs_sb,
-				  const char *target)
-{
-	int rc = 0;
-	size_t len = strlen(target);
-	char *refpath, *npath;
-
-	if (unlikely(len < 2 || *target != '\\'))
-		return -EINVAL;
-
-	if (target[1] == '\\') {
-		len += 1;
-		refpath = kmalloc(len, GFP_KERNEL);
-		if (!refpath)
-			return -ENOMEM;
-
-		scnprintf(refpath, len, "%s", target);
-	} else {
-		len += sizeof("\\");
-		refpath = kmalloc(len, GFP_KERNEL);
-		if (!refpath)
-			return -ENOMEM;
-
-		scnprintf(refpath, len, "\\%s", target);
-	}
-
-	npath = dfs_cache_canonical_path(refpath, cifs_sb->local_nls, cifs_remap(cifs_sb));
-	kfree(refpath);
-
-	if (IS_ERR(npath)) {
-		rc = PTR_ERR(npath);
-	} else {
-		mutex_lock(&server->refpath_lock);
-		spin_lock(&server->srv_lock);
-		kfree(server->leaf_fullpath);
-		server->leaf_fullpath = npath;
-		spin_unlock(&server->srv_lock);
-		mutex_unlock(&server->refpath_lock);
-	}
-	return rc;
-}
-
 static int target_share_matches_server(struct TCP_Server_Info *server, char *share,
 				       bool *target_match)
 {
@@ -388,77 +345,22 @@ static int target_share_matches_server(struct TCP_Server_Info *server, char *sha
 	return rc;
 }
 
-static void __tree_connect_ipc(const unsigned int xid, char *tree,
-			       struct cifs_sb_info *cifs_sb,
-			       struct cifs_ses *ses)
-{
-	struct TCP_Server_Info *server = ses->server;
-	struct cifs_tcon *tcon = ses->tcon_ipc;
-	int rc;
-
-	spin_lock(&ses->ses_lock);
-	spin_lock(&ses->chan_lock);
-	if (cifs_chan_needs_reconnect(ses, server) ||
-	    ses->ses_status != SES_GOOD) {
-		spin_unlock(&ses->chan_lock);
-		spin_unlock(&ses->ses_lock);
-		cifs_server_dbg(FYI, "%s: skipping ipc reconnect due to disconnected ses\n",
-				__func__);
-		return;
-	}
-	spin_unlock(&ses->chan_lock);
-	spin_unlock(&ses->ses_lock);
-
-	cifs_server_lock(server);
-	scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
-	cifs_server_unlock(server);
-
-	rc = server->ops->tree_connect(xid, ses, tree, tcon,
-				       cifs_sb->local_nls);
-	cifs_server_dbg(FYI, "%s: tree_reconnect %s: %d\n", __func__, tree, rc);
-	spin_lock(&tcon->tc_lock);
-	if (rc) {
-		tcon->status = TID_NEED_TCON;
-	} else {
-		tcon->status = TID_GOOD;
-		tcon->need_reconnect = false;
-	}
-	spin_unlock(&tcon->tc_lock);
-}
-
-static void tree_connect_ipc(const unsigned int xid, char *tree,
-			     struct cifs_sb_info *cifs_sb,
-			     struct cifs_tcon *tcon)
-{
-	struct cifs_ses *ses = tcon->ses;
-
-	__tree_connect_ipc(xid, tree, cifs_sb, ses);
-	__tree_connect_ipc(xid, tree, cifs_sb, CIFS_DFS_ROOT_SES(ses));
-}
-
-static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tcon,
-				     struct cifs_sb_info *cifs_sb, char *tree, bool islink,
-				     struct dfs_cache_tgt_list *tl)
+static int tree_connect_dfs_target(const unsigned int xid,
+				   struct cifs_tcon *tcon,
+				   struct cifs_sb_info *cifs_sb,
+				   char *tree, bool islink,
+				   struct dfs_cache_tgt_list *tl)
 {
-	int rc;
+	const struct smb_version_operations *ops = tcon->ses->server->ops;
 	struct TCP_Server_Info *server = tcon->ses->server;
-	const struct smb_version_operations *ops = server->ops;
-	struct cifs_ses *root_ses = CIFS_DFS_ROOT_SES(tcon->ses);
-	char *share = NULL, *prefix = NULL;
 	struct dfs_cache_tgt_iterator *tit;
+	char *share = NULL, *prefix = NULL;
 	bool target_match;
-
-	tit = dfs_cache_get_tgt_iterator(tl);
-	if (!tit) {
-		rc = -ENOENT;
-		goto out;
-	}
+	int rc = -ENOENT;
 
 	/* Try to tree connect to all dfs targets */
-	for (; tit; tit = dfs_cache_get_next_tgt(tl, tit)) {
-		const char *target = dfs_cache_get_tgt_name(tit);
-		DFS_CACHE_TGT_LIST(ntl);
-
+	for (tit = dfs_cache_get_tgt_iterator(tl);
+	     tit; tit = dfs_cache_get_next_tgt(tl, tit)) {
 		kfree(share);
 		kfree(prefix);
 		share = prefix = NULL;
@@ -479,69 +381,16 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 		}
 
 		dfs_cache_noreq_update_tgthint(server->leaf_fullpath + 1, tit);
-		tree_connect_ipc(xid, tree, cifs_sb, tcon);
-
 		scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
-		if (!islink) {
-			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, cifs_sb->local_nls);
-			break;
-		}
-
-		/*
-		 * If no dfs referrals were returned from link target, then just do a TREE_CONNECT
-		 * to it.  Otherwise, cache the dfs referral and then mark current tcp ses for
-		 * reconnect so either the demultiplex thread or the echo worker will reconnect to
-		 * newly resolved target.
-		 */
-		if (dfs_cache_find(xid, root_ses, cifs_sb->local_nls, cifs_remap(cifs_sb), target,
-				   NULL, &ntl)) {
-			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, cifs_sb->local_nls);
-			if (rc)
-				continue;
-
+		rc = ops->tree_connect(xid, tcon->ses, tree,
+				       tcon, tcon->ses->local_nls);
+		if (islink && !rc && cifs_sb)
 			rc = cifs_update_super_prepath(cifs_sb, prefix);
-		} else {
-			/* Target is another dfs share */
-			rc = update_server_fullpath(server, cifs_sb, target);
-			dfs_cache_free_tgts(tl);
-
-			if (!rc) {
-				rc = -EREMOTE;
-				list_replace_init(&ntl.tl_list, &tl->tl_list);
-			} else
-				dfs_cache_free_tgts(&ntl);
-		}
 		break;
 	}
 
-out:
 	kfree(share);
 	kfree(prefix);
-
-	return rc;
-}
-
-static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tcon,
-				   struct cifs_sb_info *cifs_sb, char *tree, bool islink,
-				   struct dfs_cache_tgt_list *tl)
-{
-	int rc;
-	int num_links = 0;
-	struct TCP_Server_Info *server = tcon->ses->server;
-	char *old_fullpath = server->leaf_fullpath;
-
-	do {
-		rc = __tree_connect_dfs_target(xid, tcon, cifs_sb, tree, islink, tl);
-		if (!rc || rc != -EREMOTE)
-			break;
-	} while (rc = -ELOOP, ++num_links < MAX_NESTED_LINKS);
-	/*
-	 * If we couldn't tree connect to any targets from last referral path, then
-	 * retry it from newly resolved dfs referral.
-	 */
-	if (rc && server->leaf_fullpath != old_fullpath)
-		cifs_signal_cifsd_for_reconnect(server, true);
-
 	dfs_cache_free_tgts(tl);
 	return rc;
 }
@@ -596,14 +445,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	if (!IS_ERR(sb))
 		cifs_sb = CIFS_SB(sb);
 
-	/*
-	 * Tree connect to last share in @tcon->tree_name whether dfs super or
-	 * cached dfs referral was not found.
-	 */
-	if (!cifs_sb || !server->leaf_fullpath ||
+	/* Tree connect to last share in @tcon->tree_name if no DFS referral */
+	if (!server->leaf_fullpath ||
 	    dfs_cache_noreq_find(server->leaf_fullpath + 1, &ref, &tl)) {
-		rc = ops->tree_connect(xid, tcon->ses, tcon->tree_name, tcon,
-				       cifs_sb ? cifs_sb->local_nls : nlsc);
+		rc = ops->tree_connect(xid, tcon->ses, tcon->tree_name,
+				       tcon, tcon->ses->local_nls);
 		goto out;
 	}
 
-- 
2.43.0

