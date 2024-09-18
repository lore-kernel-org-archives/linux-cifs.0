Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68B9132464
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 05:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636571; cv=pass; b=bOVJ3/VLKrsuKwowBoXi8qyaVeecD8ZkDP1aGX6oQiO4MjgW8m7+dzLoRyKHrlKbrN0RYPcPWnMyqnjAP4jNkJ5P9BiqPGqqfoOtK60nLrW6gFKyAfl688M8dGeUcwjEXb3PHO9+Vq6vMR82VS9nJGxNhHDIUI1hE3ECabivEdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636571; c=relaxed/simple;
	bh=cOeY6x7J7dJJaNT12nfmfhVGI5V78VQLAf046Bf9o6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CS97WYa2JpSwIax/ke/ei/fuarPE3oaUgJyqWYMNNhkMxoqYX45s48oU/DvhHD3LXTtYN05Hf+ZU43/DdPlFohvVv0Gw/WNou12oSDANIUbCUzdGHIhpbpyuUxQ9HLLJYAziOHYsppzkEqSN3eJI7N5zgMbgAIrhSPkZHRVZgts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=ObQp3rrg; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ObQp3rrg"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IBUyE1jiCDLMMLV+y0cUTmRChmJY1isG8qoIPxrO2+Y=;
	b=ObQp3rrgkcwSBlKQVUAdUWis/jQwpVXW5vTIeNdLG/0LWLHEMIbvwxY8H0RCso54Qao/rQ
	cSuOizqHvQti9r//PeSnP9hV8mvbxrELD2vLyH7xwd+RQ3t/KnEYpMh8OcvPjou/XGQx9w
	VIbg85lbYMIa+rlcVT7MMhO0ZaGYesSq2gPePrdJtM2ZaMSH49z6K5ayBKlMGAFxxL8OVZ
	CK9xtcRR2GEBvd/V1MNu9hgtmRTR27cjMk0Tnk4uLB7UyuJNXyfIVjKHsPHQn+WqZB27st
	PoRZo7ero7ORIv8DLqMwnrHU/8hETY41jHZYaiQRZ5CaEmHCsWhfVPpzywT7Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636567; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=IBUyE1jiCDLMMLV+y0cUTmRChmJY1isG8qoIPxrO2+Y=;
	b=EyzHZZHToK7igWS684bAkLO2+nqp50iV1ACSfhcTMcY/NCdGQKawfwOw4njxtrKnAMwWAf
	afdZ7ZGcFCQ3elmUS+4xhltAb0NyrTMrM0WfxO7gVfvlrhMWKIhBz4ujiDzu42jK7LkDz0
	7v8tQQ1ZuR8ami3+HptC1oRW0DVtOLGb4p4kvR0L8lZQ+LSkMrlTLO0uQ0uT5ew78FzBnw
	rqAFoQeXDzZl+qoqM3lwhESS1tAa5PU0AssAtW+np5eiE+8aKDTgQO8Md3dgH5SgvEGoVu
	NjMn0c8v4q7EDuAL9XhLgRIx0peDPYz0cYUicWYWDLFYS1CKmrgHRA5YQvmKUA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726636567; a=rsa-sha256;
	cv=none;
	b=O5FuCRYrntD/Jnd5sDQMqPpwVgEhDb6wwAISoOIqNEOXogRFjmo6+wI/MgQpG3KD8zy9Gu
	VBq2zEe1Ao6QJooOk2w+biZL9G2G12mC3klZztsVArq7F1nHqFfuPleQ6MMYapPi087uX/
	09Ge7OUa/3kD7rjb8+qM5gdS4bGm6Wsow+VAthsXPkm4DMebOfCaPkBI0k/mSf6ItA2hpo
	UY9g/5mrDxVMorlZ6pPi68mqk+aZF5zqbnkjkXrIU3emGaAsJemlcaP8Y6WNQjrjyb3ZqP
	3kiWBlvBD4aq9kh1ZxxafNhn1NNqsTB+lGKbNU07FdbRqrOz37epAb3sYEvtpA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/9] smb: client: avoid unnecessary reconnects when refreshing referrals
Date: Wed, 18 Sep 2024 02:15:34 -0300
Message-ID: <20240918051542.64349-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not mark tcons for reconnect when current connection matches any of
the targets returned by new referral even when there is no cached
entry.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/dfs_cache.c | 191 ++++++++++++++++++++++++--------------
 1 file changed, 119 insertions(+), 72 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 11c8efecf7aa..3cf7c88489be 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1095,16 +1095,18 @@ int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
 	return 0;
 }
 
-static bool target_share_equal(struct TCP_Server_Info *server, const char *s1, const char *s2)
+static bool target_share_equal(struct cifs_tcon *tcon, const char *s1)
 {
-	char unc[sizeof("\\\\") + SERVER_NAME_LENGTH] = {0};
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct sockaddr_storage ss;
 	const char *host;
+	const char *s2 = &tcon->tree_name[1];
 	size_t hostlen;
-	struct sockaddr_storage ss;
+	char unc[sizeof("\\\\") + SERVER_NAME_LENGTH] = {0};
 	bool match;
 	int rc;
 
-	if (strcasecmp(s1, s2))
+	if (strcasecmp(s2, s1))
 		return false;
 
 	/*
@@ -1128,34 +1130,6 @@ static bool target_share_equal(struct TCP_Server_Info *server, const char *s1, c
 	return match;
 }
 
-/*
- * Mark dfs tcon for reconnecting when the currently connected tcon does not match any of the new
- * target shares in @refs.
- */
-static void mark_for_reconnect_if_needed(struct TCP_Server_Info *server,
-					 const char *path,
-					 struct dfs_cache_tgt_list *old_tl,
-					 struct dfs_cache_tgt_list *new_tl)
-{
-	struct dfs_cache_tgt_iterator *oit, *nit;
-
-	for (oit = dfs_cache_get_tgt_iterator(old_tl); oit;
-	     oit = dfs_cache_get_next_tgt(old_tl, oit)) {
-		for (nit = dfs_cache_get_tgt_iterator(new_tl); nit;
-		     nit = dfs_cache_get_next_tgt(new_tl, nit)) {
-			if (target_share_equal(server,
-					       dfs_cache_get_tgt_name(oit),
-					       dfs_cache_get_tgt_name(nit))) {
-				dfs_cache_noreq_update_tgthint(path, nit);
-				return;
-			}
-		}
-	}
-
-	cifs_dbg(FYI, "%s: no cached or matched targets. mark dfs share for reconnect.\n", __func__);
-	cifs_signal_cifsd_for_reconnect(server, true);
-}
-
 static bool is_ses_good(struct cifs_ses *ses)
 {
 	struct TCP_Server_Info *server = ses->server;
@@ -1172,43 +1146,127 @@ static bool is_ses_good(struct cifs_ses *ses)
 	return ret;
 }
 
-/* Refresh dfs referral of @ses and mark it for reconnect if needed */
-static void __refresh_ses_referral(struct cifs_ses *ses, bool force_refresh)
+static char *get_ses_refpath(struct cifs_ses *ses)
 {
 	struct TCP_Server_Info *server = ses->server;
-	DFS_CACHE_TGT_LIST(old_tl);
-	DFS_CACHE_TGT_LIST(new_tl);
-	bool needs_refresh = false;
-	struct cache_entry *ce;
-	unsigned int xid;
-	char *path = NULL;
-	int rc = 0;
-
-	xid = get_xid();
+	char *path = ERR_PTR(-ENOENT);
 
 	mutex_lock(&server->refpath_lock);
 	if (server->leaf_fullpath) {
 		path = kstrdup(server->leaf_fullpath + 1, GFP_ATOMIC);
 		if (!path)
-			rc = -ENOMEM;
+			path = ERR_PTR(-ENOMEM);
 	}
 	mutex_unlock(&server->refpath_lock);
-	if (!path)
+	return path;
+}
+
+/* Refresh dfs referral of @ses */
+static void refresh_ses_referral(struct cifs_ses *ses)
+{
+	struct cache_entry *ce;
+	unsigned int xid;
+	char *path;
+	int rc = 0;
+
+	xid = get_xid();
+
+	path = get_ses_refpath(ses);
+	if (IS_ERR(path)) {
+		rc = PTR_ERR(path);
+		path = NULL;
 		goto out;
+	}
+
+	ses = CIFS_DFS_ROOT_SES(ses);
+	if (!is_ses_good(ses)) {
+		cifs_dbg(FYI, "%s: skip cache refresh due to disconnected ipc\n",
+			 __func__);
+		goto out;
+	}
+
+	ce = cache_refresh_path(xid, ses, path, false);
+	if (!IS_ERR(ce))
+		up_read(&htable_rw_lock);
+	else
+		rc = PTR_ERR(ce);
+
+out:
+	free_xid(xid);
+	kfree(path);
+}
+
+static int __refresh_tcon_referral(struct cifs_tcon *tcon,
+				   const char *path,
+				   struct dfs_info3_param *refs,
+				   int numrefs, bool force_refresh)
+{
+	struct cache_entry *ce;
+	bool reconnect = force_refresh;
+	int rc = 0;
+	int i;
+
+	if (unlikely(!numrefs))
+		return 0;
+
+	if (force_refresh) {
+		for (i = 0; i < numrefs; i++) {
+			/* TODO: include prefix paths in the matching */
+			if (target_share_equal(tcon, refs[i].node_name)) {
+				reconnect = false;
+				break;
+			}
+		}
+	}
+
+	down_write(&htable_rw_lock);
+	ce = lookup_cache_entry(path);
+	if (!IS_ERR(ce)) {
+		if (force_refresh || cache_entry_expired(ce))
+			rc = update_cache_entry_locked(ce, refs, numrefs);
+	} else if (PTR_ERR(ce) == -ENOENT) {
+		ce = add_cache_entry_locked(refs, numrefs);
+	}
+	up_write(&htable_rw_lock);
+
+	if (IS_ERR(ce))
+		rc = PTR_ERR(ce);
+	if (reconnect) {
+		cifs_tcon_dbg(FYI, "%s: mark for reconnect\n", __func__);
+		cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
+	}
+	return rc;
+}
+
+static void refresh_tcon_referral(struct cifs_tcon *tcon, bool force_refresh)
+{
+	struct dfs_info3_param *refs = NULL;
+	struct cache_entry *ce;
+	struct cifs_ses *ses;
+	unsigned int xid;
+	bool needs_refresh;
+	char *path;
+	int numrefs = 0;
+	int rc = 0;
+
+	xid = get_xid();
+	ses = tcon->ses;
+
+	path = get_ses_refpath(ses);
+	if (IS_ERR(path)) {
+		rc = PTR_ERR(path);
+		path = NULL;
+		goto out;
+	}
 
 	down_read(&htable_rw_lock);
 	ce = lookup_cache_entry(path);
 	needs_refresh = force_refresh || IS_ERR(ce) || cache_entry_expired(ce);
-	if (!IS_ERR(ce)) {
-		rc = get_targets(ce, &old_tl);
-		cifs_dbg(FYI, "%s: get_targets: %d\n", __func__, rc);
-	}
-	up_read(&htable_rw_lock);
-
 	if (!needs_refresh) {
-		rc = 0;
+		up_read(&htable_rw_lock);
 		goto out;
 	}
+	up_read(&htable_rw_lock);
 
 	ses = CIFS_DFS_ROOT_SES(ses);
 	if (!is_ses_good(ses)) {
@@ -1217,29 +1275,16 @@ static void __refresh_ses_referral(struct cifs_ses *ses, bool force_refresh)
 		goto out;
 	}
 
-	ce = cache_refresh_path(xid, ses, path, true);
-	if (!IS_ERR(ce)) {
-		rc = get_targets(ce, &new_tl);
-		up_read(&htable_rw_lock);
-		cifs_dbg(FYI, "%s: get_targets: %d\n", __func__, rc);
-		mark_for_reconnect_if_needed(server, path, &old_tl, &new_tl);
+	rc = get_dfs_referral(xid, ses, path, &refs, &numrefs);
+	if (!rc) {
+		rc = __refresh_tcon_referral(tcon, path, refs,
+					     numrefs, force_refresh);
 	}
 
 out:
 	free_xid(xid);
-	dfs_cache_free_tgts(&old_tl);
-	dfs_cache_free_tgts(&new_tl);
 	kfree(path);
-}
-
-static inline void refresh_ses_referral(struct cifs_ses *ses)
-{
-	__refresh_ses_referral(ses, false);
-}
-
-static inline void force_refresh_ses_referral(struct cifs_ses *ses)
-{
-	__refresh_ses_referral(ses, true);
+	free_dfs_info_array(refs, numrefs);
 }
 
 /**
@@ -1280,7 +1325,7 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	 */
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 
-	force_refresh_ses_referral(tcon->ses);
+	refresh_tcon_referral(tcon, true);
 	return 0;
 }
 
@@ -1291,9 +1336,11 @@ void dfs_cache_refresh(struct work_struct *work)
 	struct cifs_ses *ses;
 
 	tcon = container_of(work, struct cifs_tcon, dfs_cache_work.work);
+	ses = tcon->ses->dfs_root_ses;
 
-	for (ses = tcon->ses; ses; ses = ses->dfs_root_ses)
+	for (; ses; ses = ses->dfs_root_ses)
 		refresh_ses_referral(ses);
+	refresh_tcon_referral(tcon, false);
 
 	queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
 			   atomic_read(&dfs_cache_ttl) * HZ);
-- 
2.46.0

