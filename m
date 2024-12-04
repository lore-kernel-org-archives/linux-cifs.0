Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B564224AEF;
	Wed,  4 Dec 2024 23:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733355350; cv=none; b=mBEebNUlLjl5xg3CV0WxOhu1ENKgj0Dal+4mqzHUZXWUGNPoiIBGiRma7neAFRJgp3H4umcn44EIjMOcuXslYnVFAvHGCWfNaTH6PVOoOVysyANBoaCe5bMjoNsgDXMEU6F7HGT4KOh06B2HYhsQ3xiTYCP7viqGOUzLxWgbCvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733355350; c=relaxed/simple;
	bh=6g/3gOZpjLqFEtM76L2A0xUggHcj0QKf3jkNqW6mKdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saeO9SSFjztvJ0JXIOpQ52YQEbpjAxw8hnkbFdzAFYVmWP4fW+mHBvZTPDgHRpxTNhke4+UnyXUCeNB3cWTBaTMpYPE5DzcdwGrEqafVEog+IoP7uPBUCwnVqp0FmdmoZ6W4u0WezhBV6ddwyzDQG7X3TUHuxkxPVZmKFi0HeH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMGVWdQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMGVWdQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E62C4CECD;
	Wed,  4 Dec 2024 23:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733355350;
	bh=6g/3gOZpjLqFEtM76L2A0xUggHcj0QKf3jkNqW6mKdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMGVWdQs85YIpRgdyuxigDjY6iiOK58kuTi75i5a9fTGJKWmQ60eLdUSQ7lIe2qV+
	 dev6rljXAWK4BbfMjXMtmTvaw+pezHkijyijrI65cbI97z5xtUDZCCy6yapD2ESex7
	 dwpAMpqrqP+4ZonJx1kVsCCIxM5tMrdbPtYsCsjHBScwtxSaVyo7y8uus4DmED7Jdu
	 IaH8WC/0j0GpaNgmHuzSGlBb7ghs9cozEc8LnuFCsK+eEyidlQpmV4vhM3fiajNvxE
	 6QDFhHKGpZBLboT4f5yFE/D1x1i6d2x5FZmEkltKBjYLHefJuWUPZJ/GFS0hrSoHn4
	 YrUgrb0W5NGvQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 4/6] smb: client: don't try following DFS links in cifs_tree_connect()
Date: Wed,  4 Dec 2024 17:24:13 -0500
Message-ID: <20241204222425.2250046-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204222425.2250046-1-sashal@kernel.org>
References: <20241204222425.2250046-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.63
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
index 3ec965547e3d4..bd259b04cdede 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -324,49 +324,6 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
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
@@ -391,77 +348,22 @@ static int target_share_matches_server(struct TCP_Server_Info *server, char *sha
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
@@ -482,69 +384,16 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
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
@@ -599,14 +448,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
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

