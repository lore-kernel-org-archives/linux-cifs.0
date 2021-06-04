Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2F1C4743C
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04B5F613AD
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhFDW1v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 18:27:51 -0400
Received: from mx.cjr.nz ([51.158.111.142]:9492 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231534AbhFDW1v (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 4 Jun 2021 18:27:51 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C61987FC02;
        Fri,  4 Jun 2021 22:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1622845562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKesDzXVJ/oHndzNYKWkVdGuiVYg4I6qznWelAcPn/U=;
        b=zaGjo0WBSAvVRkzvBeaTDG4wm9fuE+dYD2nUqMLt+SpfquHrgRVIZ3tV0VGrmcrG8w88AL
        irSHNk3IzFcqlEE6YzsNS/sEWcYy3poTZpqzcj5C8iR99GQ2CYsEYvs7Xfcxf5iVW6KVFy
        SOlvRQYU9Q+FTjemFOHklgIKu3nyJUcgBnNvgaKSc6huby47doVqAvPMCNO4BnmmtTP0R1
        EiDQlKvCiLbPyPOuWKjVDKnmwbs9ZB8BGVOCOlK6BIxUFI/OYFdMn0QItq2SB+fdYzo3ij
        vKmCJtzfzZK6hL6BCHQx3pkJEhycsOWSepI8Kr7JRKUJKirp6ljhaBHaXafYAw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 4/7] cifs: handle different charsets in dfs cache
Date:   Fri,  4 Jun 2021 19:25:30 -0300
Message-Id: <20210604222533.4760-5-pc@cjr.nz>
In-Reply-To: <20210604222533.4760-1-pc@cjr.nz>
References: <20210604222533.4760-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Convert all dfs paths to dfs cache's local codepage (@cache_cp) and
avoid mixing them with different charsets.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifs_fs_sb.h |   5 +-
 fs/cifs/cifsglob.h   |   3 +-
 fs/cifs/connect.c    |  67 +++++++++++-------
 fs/cifs/dfs_cache.c  | 165 ++++++++++++++++++++-----------------------
 fs/cifs/dfs_cache.h  |  37 +++++-----
 5 files changed, 138 insertions(+), 139 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 2dfd10c34ace..64990ccd1b9c 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -72,9 +72,8 @@ struct cifs_sb_info {
 	char *prepath;
 
 	/*
-	 * Path initially provided by the mount call. We might connect
-	 * to something different via DFS but we want to keep it to do
-	 * failover properly.
+	 * Canonical DFS path initially provided by the mount call. We might connect to something
+	 * different via DFS but we want to keep it to do failover properly.
 	 */
 	char *origin_fullpath; /* \\HOST\SHARE\[OPTIONAL PATH] */
 	/* randomly generated 128-bit number for indexing dfs mount groups in referral cache */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8488d7024462..d85ef3b41bd9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1093,8 +1093,7 @@ struct cifs_tcon {
 	struct cached_fid crfid; /* Cached root fid */
 	/* BB add field for back pointer to sb struct(s)? */
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	char *dfs_path;
-	int remap:2;
+	char *dfs_path; /* canonical DFS path */
 	struct list_head ulist; /* cache update list */
 #endif
 };
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4997ded82e93..cece0c2249c3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3004,9 +3004,8 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
-static inline int get_next_dfs_tgt(const char *path,
-				   struct dfs_cache_tgt_list *tgt_list,
-				   struct dfs_cache_tgt_iterator **tgt_it)
+static int get_next_dfs_tgt(struct dfs_cache_tgt_list *tgt_list,
+			    struct dfs_cache_tgt_iterator **tgt_it)
 {
 	if (!*tgt_it)
 		*tgt_it = dfs_cache_get_tgt_iterator(tgt_list);
@@ -3046,6 +3045,7 @@ static int do_dfs_failover(const char *path, const char *full_path, struct cifs_
 			   struct cifs_ses **ses, struct cifs_tcon **tcon)
 {
 	int rc;
+	char *npath = NULL;
 	struct dfs_cache_tgt_list tgt_list = {0};
 	struct dfs_cache_tgt_iterator *tgt_it = NULL;
 	struct smb3_fs_context tmp_ctx = {NULL};
@@ -3053,9 +3053,13 @@ static int do_dfs_failover(const char *path, const char *full_path, struct cifs_
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
 		return -EOPNOTSUPP;
 
-	cifs_dbg(FYI, "%s: path=%s full_path=%s\n", __func__, path, full_path);
+	npath = dfs_cache_canonical_path(path, cifs_sb->local_nls, cifs_remap(cifs_sb));
+	if (IS_ERR(npath))
+		return PTR_ERR(npath);
 
-	rc = dfs_cache_noreq_find(path, NULL, &tgt_list);
+	cifs_dbg(FYI, "%s: path=%s full_path=%s\n", __func__, npath, full_path);
+
+	rc = dfs_cache_noreq_find(npath, NULL, &tgt_list);
 	if (rc)
 		return rc;
 	/*
@@ -3071,11 +3075,11 @@ static int do_dfs_failover(const char *path, const char *full_path, struct cifs_
 		char *fake_devname = NULL, *mdata = NULL;
 
 		/* Get next DFS target server - if any */
-		rc = get_next_dfs_tgt(path, &tgt_list, &tgt_it);
+		rc = get_next_dfs_tgt(&tgt_list, &tgt_it);
 		if (rc)
 			break;
 
-		rc = dfs_cache_get_tgt_referral(path, tgt_it, &ref);
+		rc = dfs_cache_get_tgt_referral(npath, tgt_it, &ref);
 		if (rc)
 			break;
 
@@ -3124,6 +3128,7 @@ static int do_dfs_failover(const char *path, const char *full_path, struct cifs_
 	}
 
 out:
+	kfree(npath);
 	smb3_cleanup_fs_context_contents(&tmp_ctx);
 	dfs_cache_free_tgts(&tgt_list);
 	return rc;
@@ -3281,11 +3286,6 @@ static void set_root_ses(struct cifs_sb_info *cifs_sb, const uuid_t *mount_id, s
 	if (ses) {
 		spin_lock(&cifs_tcp_ses_lock);
 		ses->ses_count++;
-		cifs_dbg(FYI, "%s: new ses_count=%d\n", __func__, ses->ses_count);
-		if (ses->tcon_ipc) {
-			cifs_dbg(FYI, "%s: ipc tcon: %s\n", __func__, ses->tcon_ipc->treeName);
-			ses->tcon_ipc->remap = cifs_remap(cifs_sb);
-		}
 		spin_unlock(&cifs_tcp_ses_lock);
 		dfs_cache_add_refsrv_session(mount_id, ses);
 	}
@@ -3337,17 +3337,25 @@ static int next_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_context
 }
 
 /* Check if resolved targets can handle any DFS referrals */
-static int is_referral_server(const char *ref_path, struct cifs_tcon *tcon, bool *ref_server)
+static int is_referral_server(const char *ref_path, struct cifs_sb_info *cifs_sb,
+			      struct cifs_tcon *tcon, bool *ref_server)
 {
 	int rc;
 	struct dfs_info3_param ref = {0};
 
+	cifs_dbg(FYI, "%s: ref_path=%s\n", __func__, ref_path);
+
 	if (is_tcon_dfs(tcon)) {
 		*ref_server = true;
 	} else {
-		cifs_dbg(FYI, "%s: ref_path=%s\n", __func__, ref_path);
+		char *npath;
 
-		rc = dfs_cache_noreq_find(ref_path, &ref, NULL);
+		npath = dfs_cache_canonical_path(ref_path, cifs_sb->local_nls, cifs_remap(cifs_sb));
+		if (IS_ERR(npath))
+			return PTR_ERR(npath);
+
+		rc = dfs_cache_noreq_find(npath, &ref, NULL);
+		kfree(npath);
 		if (rc) {
 			cifs_dbg(VFS, "%s: dfs_cache_noreq_find: failed (rc=%d)\n", __func__, rc);
 			return rc;
@@ -3438,7 +3446,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			continue;
 
 		/* Make sure that requests go through new root servers */
-		rc = is_referral_server(ref_path + 1, tcon, &ref_server);
+		rc = is_referral_server(ref_path + 1, cifs_sb, tcon, &ref_server);
 		if (rc)
 			break;
 		if (ref_server)
@@ -3455,7 +3463,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 		goto error;
 
 	kfree(ref_path);
-	ref_path = NULL;
 	/*
 	 * Store DFS full path in both superblock and tree connect structures.
 	 *
@@ -3464,15 +3471,25 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	 * links, the prefix path is included in both and may be changed during reconnect.  See
 	 * cifs_tree_connect().
 	 */
-	cifs_sb->origin_fullpath = kstrdup(full_path, GFP_KERNEL);
-	if (!cifs_sb->origin_fullpath) {
-		rc = -ENOMEM;
-		goto error;
-	}
-	spin_lock(&cifs_tcp_ses_lock);
-	tcon->dfs_path = full_path;
+	ref_path = dfs_cache_canonical_path(full_path, cifs_sb->local_nls, cifs_remap(cifs_sb));
+	kfree(full_path);
 	full_path = NULL;
-	tcon->remap = cifs_remap(cifs_sb);
+
+	if (IS_ERR(ref_path)) {
+		rc = PTR_ERR(ref_path);
+		ref_path = NULL;
+		goto error;
+	}
+	cifs_sb->origin_fullpath = ref_path;
+
+	ref_path = kstrdup(cifs_sb->origin_fullpath, GFP_KERNEL);
+	if (!ref_path) {
+		rc = -ENOMEM;
+		goto error;
+	}
+	spin_lock(&cifs_tcp_ses_lock);
+	tcon->dfs_path = ref_path;
+	ref_path = NULL;
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/*
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index cecb83b831d9..c52fec3c4092 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -65,7 +65,7 @@ static struct workqueue_struct *dfscache_wq __read_mostly;
 static int cache_ttl;
 static DEFINE_SPINLOCK(cache_ttl_lock);
 
-static struct nls_table *cache_nlsc;
+static struct nls_table *cache_cp;
 
 /*
  * Number of entries in the cache
@@ -175,27 +175,45 @@ static void free_mount_group_list(void)
 	}
 }
 
-static int get_normalized_path(const char *path, const char **npath)
+/**
+ * dfs_cache_canonical_path - get a canonical DFS path
+ *
+ * @path: DFS path
+ * @cp: codepage
+ * @remap: mapping type
+ *
+ * Return canonical path if success, otherwise error.
+ */
+char *dfs_cache_canonical_path(const char *path, const struct nls_table *cp, int remap)
 {
+	char *tmp;
+	int plen = 0;
+	char *npath;
+
 	if (!path || strlen(path) < 3 || (*path != '\\' && *path != '/'))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
-	if (*path == '\\') {
-		*npath = path;
+	if (unlikely(strcmp(cp->charset, cache_cp->charset))) {
+		tmp = (char *)cifs_strndup_to_utf16(path, strlen(path), &plen, cp, remap);
+		if (!tmp) {
+			cifs_dbg(VFS, "%s: failed to convert path to utf16\n", __func__);
+			return ERR_PTR(-EINVAL);
+		}
+
+		npath = cifs_strndup_from_utf16(tmp, plen, true, cache_cp);
+		kfree(tmp);
+
+		if (!npath) {
+			cifs_dbg(VFS, "%s: failed to convert path from utf16\n", __func__);
+			return ERR_PTR(-EINVAL);
+		}
 	} else {
-		char *s = kstrdup(path, GFP_KERNEL);
-		if (!s)
-			return -ENOMEM;
-		convert_delimiter(s, '\\');
-		*npath = s;
+		npath = kstrdup(path, GFP_KERNEL);
+		if (!npath)
+			return ERR_PTR(-ENOMEM);
 	}
-	return 0;
-}
-
-static inline void free_normalized_path(const char *path, const char *npath)
-{
-	if (path != npath)
-		kfree(npath);
+	convert_delimiter(npath, '\\');
+	return npath;
 }
 
 static inline bool cache_entry_expired(const struct cache_entry *ce)
@@ -394,7 +412,9 @@ int dfs_cache_init(void)
 		INIT_HLIST_HEAD(&cache_htable[i]);
 
 	atomic_set(&cache_count, 0);
-	cache_nlsc = load_nls_default();
+	cache_cp = load_nls("utf8");
+	if (!cache_cp)
+		cache_cp = load_nls_default();
 
 	cifs_dbg(FYI, "%s: initialized DFS referral cache\n", __func__);
 	return 0;
@@ -680,7 +700,7 @@ static struct cache_entry *lookup_cache_entry(const char *path, unsigned int *ha
 void dfs_cache_destroy(void)
 {
 	cancel_delayed_work_sync(&refresh_task);
-	unload_nls(cache_nlsc);
+	unload_nls(cache_cp);
 	free_mount_group_list();
 	flush_cache_ents();
 	kmem_cache_destroy(cache_slab);
@@ -718,23 +738,21 @@ static int update_cache_entry_locked(const char *path, const struct dfs_info3_pa
 	return rc;
 }
 
-static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
-			    const struct nls_table *nls_codepage, int remap,
-			    const char *path,  struct dfs_info3_param **refs,
-			    int *numrefs)
+static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses, const char *path,
+			    struct dfs_info3_param **refs, int *numrefs)
 {
 	cifs_dbg(FYI, "%s: get an DFS referral for %s\n", __func__, path);
 
 	if (!ses || !ses->server || !ses->server->ops->get_dfs_refer)
 		return -EOPNOTSUPP;
-	if (unlikely(!nls_codepage))
+	if (unlikely(!cache_cp))
 		return -EINVAL;
 
 	*refs = NULL;
 	*numrefs = 0;
 
-	return ses->server->ops->get_dfs_refer(xid, ses, path, refs, numrefs,
-					       nls_codepage, remap);
+	return ses->server->ops->get_dfs_refer(xid, ses, path, refs, numrefs, cache_cp,
+					       NO_MAP_UNI_RSVD);
 }
 
 /*
@@ -746,8 +764,7 @@ static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
  * For interlinks, cifs_mount() and expand_dfs_referral() are supposed to
  * handle them properly.
  */
-static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses,
-			      const struct nls_table *nls_codepage, int remap, const char *path)
+static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, const char *path)
 {
 	int rc;
 	unsigned int hash;
@@ -775,8 +792,7 @@ static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses,
 	 * Either the entry was not found, or it is expired.
 	 * Request a new DFS referral in order to create or update a cache entry.
 	 */
-	rc = get_dfs_referral(xid, ses, nls_codepage, remap, path,
-			      &refs, &numrefs);
+	rc = get_dfs_referral(xid, ses, path, &refs, &numrefs);
 	if (rc)
 		goto out_unlock;
 
@@ -897,7 +913,7 @@ static int get_targets(struct cache_entry *ce, struct dfs_cache_tgt_list *tl)
  * needs to be issued:
  * @xid: syscall xid
  * @ses: smb session to issue the request on
- * @nls_codepage: charset conversion
+ * @cp: codepage
  * @remap: path character remapping type
  * @path: path to lookup in DFS referral cache.
  *
@@ -906,20 +922,19 @@ static int get_targets(struct cache_entry *ce, struct dfs_cache_tgt_list *tl)
  *
  * Return zero if the target was found, otherwise non-zero.
  */
-int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
-		   const struct nls_table *nls_codepage, int remap,
-		   const char *path, struct dfs_info3_param *ref,
+int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses, const struct nls_table *cp,
+		   int remap, const char *path, struct dfs_info3_param *ref,
 		   struct dfs_cache_tgt_list *tgt_list)
 {
 	int rc;
 	const char *npath;
 	struct cache_entry *ce;
 
-	rc = get_normalized_path(path, &npath);
-	if (rc)
-		return rc;
+	npath = dfs_cache_canonical_path(path, cp, remap);
+	if (IS_ERR(npath))
+		return PTR_ERR(npath);
 
-	rc = cache_refresh_path(xid, ses, nls_codepage, remap, npath);
+	rc = cache_refresh_path(xid, ses, npath);
 	if (rc)
 		goto out_free_path;
 
@@ -942,7 +957,7 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
 	up_read(&htable_rw_lock);
 
 out_free_path:
-	free_normalized_path(path, npath);
+	kfree(npath);
 	return rc;
 }
 
@@ -954,7 +969,7 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
  * expired, nor create a new cache entry if @path hasn't been found. It heavily
  * relies on an existing cache entry.
  *
- * @path: path to lookup in the DFS referral cache.
+ * @path: canonical DFS path to lookup in the DFS referral cache.
  * @ref: when non-NULL, store single DFS referral result in it.
  * @tgt_list: when non-NULL, store complete DFS target list in it.
  *
@@ -966,18 +981,13 @@ int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
 			 struct dfs_cache_tgt_list *tgt_list)
 {
 	int rc;
-	const char *npath;
 	struct cache_entry *ce;
 
-	rc = get_normalized_path(path, &npath);
-	if (rc)
-		return rc;
-
-	cifs_dbg(FYI, "%s: path: %s\n", __func__, npath);
+	cifs_dbg(FYI, "%s: path: %s\n", __func__, path);
 
 	down_read(&htable_rw_lock);
 
-	ce = lookup_cache_entry(npath, NULL);
+	ce = lookup_cache_entry(path, NULL);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
 		goto out_unlock;
@@ -992,8 +1002,6 @@ int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
 
 out_unlock:
 	up_read(&htable_rw_lock);
-	free_normalized_path(path, npath);
-
 	return rc;
 }
 
@@ -1008,16 +1016,15 @@ int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
  *
  * @xid: syscall id
  * @ses: smb session
- * @nls_codepage: charset conversion
+ * @cp: codepage
  * @remap: type of character remapping for paths
- * @path: path to lookup in DFS referral cache.
+ * @path: path to lookup in DFS referral cache
  * @it: DFS target iterator
  *
  * Return zero if the target hint was updated successfully, otherwise non-zero.
  */
 int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
-			     const struct nls_table *nls_codepage, int remap,
-			     const char *path,
+			     const struct nls_table *cp, int remap, const char *path,
 			     const struct dfs_cache_tgt_iterator *it)
 {
 	int rc;
@@ -1025,13 +1032,13 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 	struct cache_entry *ce;
 	struct cache_dfs_tgt *t;
 
-	rc = get_normalized_path(path, &npath);
-	if (rc)
-		return rc;
+	npath = dfs_cache_canonical_path(path, cp, remap);
+	if (IS_ERR(npath))
+		return PTR_ERR(npath);
 
 	cifs_dbg(FYI, "%s: update target hint - path: %s\n", __func__, npath);
 
-	rc = cache_refresh_path(xid, ses, nls_codepage, remap, npath);
+	rc = cache_refresh_path(xid, ses, npath);
 	if (rc)
 		goto out_free_path;
 
@@ -1060,8 +1067,7 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 out_unlock:
 	up_write(&htable_rw_lock);
 out_free_path:
-	free_normalized_path(path, npath);
-
+	kfree(npath);
 	return rc;
 }
 
@@ -1073,32 +1079,26 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
  * expired, nor create a new cache entry if @path hasn't been found. It heavily
  * relies on an existing cache entry.
  *
- * @path: path to lookup in DFS referral cache.
+ * @path: canonical DFS path to lookup in DFS referral cache.
  * @it: target iterator which contains the target hint to update the cache
  * entry with.
  *
  * Return zero if the target hint was updated successfully, otherwise non-zero.
  */
-int dfs_cache_noreq_update_tgthint(const char *path,
-				   const struct dfs_cache_tgt_iterator *it)
+int dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt_iterator *it)
 {
 	int rc;
-	const char *npath;
 	struct cache_entry *ce;
 	struct cache_dfs_tgt *t;
 
 	if (!it)
 		return -EINVAL;
 
-	rc = get_normalized_path(path, &npath);
-	if (rc)
-		return rc;
-
-	cifs_dbg(FYI, "%s: path: %s\n", __func__, npath);
+	cifs_dbg(FYI, "%s: path: %s\n", __func__, path);
 
 	down_write(&htable_rw_lock);
 
-	ce = lookup_cache_entry(npath, NULL);
+	ce = lookup_cache_entry(path, NULL);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
 		goto out_unlock;
@@ -1121,8 +1121,6 @@ int dfs_cache_noreq_update_tgthint(const char *path,
 
 out_unlock:
 	up_write(&htable_rw_lock);
-	free_normalized_path(path, npath);
-
 	return rc;
 }
 
@@ -1130,32 +1128,26 @@ int dfs_cache_noreq_update_tgthint(const char *path,
  * dfs_cache_get_tgt_referral - returns a DFS referral (@ref) from a given
  * target iterator (@it).
  *
- * @path: path to lookup in DFS referral cache.
+ * @path: canonical DFS path to lookup in DFS referral cache.
  * @it: DFS target iterator.
  * @ref: DFS referral pointer to set up the gathered information.
  *
  * Return zero if the DFS referral was set up correctly, otherwise non-zero.
  */
-int dfs_cache_get_tgt_referral(const char *path,
-			       const struct dfs_cache_tgt_iterator *it,
+int dfs_cache_get_tgt_referral(const char *path, const struct dfs_cache_tgt_iterator *it,
 			       struct dfs_info3_param *ref)
 {
 	int rc;
-	const char *npath;
 	struct cache_entry *ce;
 
 	if (!it || !ref)
 		return -EINVAL;
 
-	rc = get_normalized_path(path, &npath);
-	if (rc)
-		return rc;
-
-	cifs_dbg(FYI, "%s: path: %s\n", __func__, npath);
+	cifs_dbg(FYI, "%s: path: %s\n", __func__, path);
 
 	down_read(&htable_rw_lock);
 
-	ce = lookup_cache_entry(npath, NULL);
+	ce = lookup_cache_entry(path, NULL);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
 		goto out_unlock;
@@ -1167,8 +1159,6 @@ int dfs_cache_get_tgt_referral(const char *path,
 
 out_unlock:
 	up_read(&htable_rw_lock);
-	free_normalized_path(path, npath);
-
 	return rc;
 }
 
@@ -1230,8 +1220,8 @@ void dfs_cache_put_refsrv_sessions(const uuid_t *mount_id)
  *
  * Return zero if target was parsed correctly, otherwise non-zero.
  */
-int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
-			    char **share, char **prefix)
+int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it, char **share,
+			    char **prefix)
 {
 	char *s, sep, *p;
 	size_t len;
@@ -1321,7 +1311,7 @@ static void refresh_mounts(struct cifs_ses **sessions)
 		ses = find_ipc_from_server_path(sessions, path);
 		if (!IS_ERR(ses)) {
 			xid = get_xid();
-			cache_refresh_path(xid, ses, cache_nlsc, tcon->remap, path);
+			cache_refresh_path(xid, ses, path);
 			free_xid(xid);
 		}
 		cifs_put_tcon(tcon);
@@ -1357,8 +1347,7 @@ static void refresh_cache(struct cifs_ses **sessions)
 				continue;
 
 			xid = get_xid();
-			rc = get_dfs_referral(xid, ses, cache_nlsc, NO_MAP_UNI_RSVD, ce->path,
-					      &refs, &numrefs);
+			rc = get_dfs_referral(xid, ses, ce->path, &refs, &numrefs);
 			free_xid(xid);
 
 			if (!rc)
diff --git a/fs/cifs/dfs_cache.h b/fs/cifs/dfs_cache.h
index c23b08530a7f..b29d3ae64829 100644
--- a/fs/cifs/dfs_cache.h
+++ b/fs/cifs/dfs_cache.h
@@ -24,31 +24,26 @@ struct dfs_cache_tgt_iterator {
 	struct list_head it_list;
 };
 
-extern int dfs_cache_init(void);
-extern void dfs_cache_destroy(void);
+int dfs_cache_init(void);
+void dfs_cache_destroy(void);
 extern const struct proc_ops dfscache_proc_ops;
 
-extern int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
-			  const struct nls_table *nls_codepage, int remap,
-			  const char *path, struct dfs_info3_param *ref,
-			  struct dfs_cache_tgt_list *tgt_list);
-extern int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
-				struct dfs_cache_tgt_list *tgt_list);
-extern int dfs_cache_update_tgthint(const unsigned int xid,
-				    struct cifs_ses *ses,
-				    const struct nls_table *nls_codepage,
-				    int remap, const char *path,
-				    const struct dfs_cache_tgt_iterator *it);
-extern int
-dfs_cache_noreq_update_tgthint(const char *path,
-			       const struct dfs_cache_tgt_iterator *it);
-extern int dfs_cache_get_tgt_referral(const char *path,
-				      const struct dfs_cache_tgt_iterator *it,
-				      struct dfs_info3_param *ref);
-extern int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
-				   char **share, char **prefix);
+int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses, const struct nls_table *cp,
+		   int remap, const char *path, struct dfs_info3_param *ref,
+		   struct dfs_cache_tgt_list *tgt_list);
+int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
+			 struct dfs_cache_tgt_list *tgt_list);
+int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
+			     const struct nls_table *cp, int remap, const char *path,
+			     const struct dfs_cache_tgt_iterator *it);
+int dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt_iterator *it);
+int dfs_cache_get_tgt_referral(const char *path, const struct dfs_cache_tgt_iterator *it,
+			       struct dfs_info3_param *ref);
+int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it, char **share,
+			    char **prefix);
 void dfs_cache_put_refsrv_sessions(const uuid_t *mount_id);
 void dfs_cache_add_refsrv_session(const uuid_t *mount_id, struct cifs_ses *ses);
+char *dfs_cache_canonical_path(const char *path, const struct nls_table *cp, int remap);
 
 static inline struct dfs_cache_tgt_iterator *
 dfs_cache_get_next_tgt(struct dfs_cache_tgt_list *tl,
-- 
2.31.1

