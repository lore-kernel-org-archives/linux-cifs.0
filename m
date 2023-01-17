Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A756EC67871
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 00:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjAQALM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Jan 2023 19:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbjAQALF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Jan 2023 19:11:05 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC8022DF8
        for <linux-cifs@vger.kernel.org>; Mon, 16 Jan 2023 16:11:03 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4E54180268;
        Tue, 17 Jan 2023 00:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673914262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+MCZ1OFwQjYrlJIvd01NqujMzwPZLGT/B1OJUKq+5Y4=;
        b=BReTzWrkVHofDuFxlLGxRcNHU+nFw7nwHLvFH0HRhv2w8yDwDfOWqZk1NFfDicV8jglYSd
        8xOvPqSQvxxcs1vSO9zWNrmUt9WqFslYw3qEAvaRRnXXxHiQJ5DKe35Qy9W5bbMnwz4Kz/
        ZUy0rixjzBgjyt/PEft4T/WA7/0Tt3bwAzK/TJWgGZcrWP4GaB4cZp2wanEQmOJiaBEVtr
        /3OHgBPHOc8gmuO/vLvu4fGQ1Z+T5zWouGCtdqRcZyQBvA6wJ+BMCH1VurNMet70KGj4gM
        0oncF2ZlbKGIze8CGzEjq43UiXnBZ2NXRkI8WhT7AML6KATrOk/4g3NyDJZRvw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 4/5] cifs: remove duplicate code in __refresh_tcon()
Date:   Mon, 16 Jan 2023 21:09:51 -0300
Message-Id: <20230117000952.9965-5-pc@cjr.nz>
In-Reply-To: <20230117000952.9965-1-pc@cjr.nz>
References: <20230117000952.9965-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The logic for creating or updating a cache entry in __refresh_tcon()
could be simply done with cache_refresh_path(), so use it instead.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 69 +++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 49d1f390a6b8..67890960c763 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -776,7 +776,8 @@ static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses, const
  */
 static struct cache_entry *cache_refresh_path(const unsigned int xid,
 					      struct cifs_ses *ses,
-					      const char *path)
+					      const char *path,
+					      bool force_refresh)
 {
 	struct dfs_info3_param *refs = NULL;
 	struct cache_entry *ce;
@@ -788,13 +789,14 @@ static struct cache_entry *cache_refresh_path(const unsigned int xid,
 	down_read(&htable_rw_lock);
 
 	ce = lookup_cache_entry(path);
-	if (!IS_ERR(ce) && !cache_entry_expired(ce))
+	if (!IS_ERR(ce) && !force_refresh && !cache_entry_expired(ce))
 		return ce;
 
 	up_read(&htable_rw_lock);
 
 	/*
-	 * Either the entry was not found, or it is expired.
+	 * Either the entry was not found, or it is expired, or it is a forced
+	 * refresh.
 	 * Request a new DFS referral in order to create or update a cache entry.
 	 */
 	rc = get_dfs_referral(xid, ses, path, &refs, &numrefs);
@@ -809,7 +811,7 @@ static struct cache_entry *cache_refresh_path(const unsigned int xid,
 	/* Re-check as another task might have it added or refreshed already */
 	ce = lookup_cache_entry(path);
 	if (!IS_ERR(ce)) {
-		if (cache_entry_expired(ce)) {
+		if (force_refresh || cache_entry_expired(ce)) {
 			rc = update_cache_entry_locked(ce, refs, numrefs);
 			if (rc)
 				ce = ERR_PTR(rc);
@@ -946,7 +948,7 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses, const struct nl
 	if (IS_ERR(npath))
 		return PTR_ERR(npath);
 
-	ce = cache_refresh_path(xid, ses, npath);
+	ce = cache_refresh_path(xid, ses, npath, false);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
 		goto out_free_path;
@@ -1043,7 +1045,7 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 
 	cifs_dbg(FYI, "%s: update target hint - path: %s\n", __func__, npath);
 
-	ce = cache_refresh_path(xid, ses, npath);
+	ce = cache_refresh_path(xid, ses, npath, false);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
 		goto out_free_path;
@@ -1321,35 +1323,37 @@ static bool target_share_equal(struct TCP_Server_Info *server, const char *s1, c
  * Mark dfs tcon for reconnecting when the currently connected tcon does not match any of the new
  * target shares in @refs.
  */
-static void mark_for_reconnect_if_needed(struct cifs_tcon *tcon, struct dfs_cache_tgt_list *tl,
-					 const struct dfs_info3_param *refs, int numrefs)
+static void mark_for_reconnect_if_needed(struct TCP_Server_Info *server,
+					 struct dfs_cache_tgt_list *old_tl,
+					 struct dfs_cache_tgt_list *new_tl)
 {
-	struct dfs_cache_tgt_iterator *it;
-	int i;
+	struct dfs_cache_tgt_iterator *oit, *nit;
 
-	for (it = dfs_cache_get_tgt_iterator(tl); it; it = dfs_cache_get_next_tgt(tl, it)) {
-		for (i = 0; i < numrefs; i++) {
-			if (target_share_equal(tcon->ses->server, dfs_cache_get_tgt_name(it),
-					       refs[i].node_name))
+	for (oit = dfs_cache_get_tgt_iterator(old_tl); oit;
+	     oit = dfs_cache_get_next_tgt(old_tl, oit)) {
+		for (nit = dfs_cache_get_tgt_iterator(new_tl); nit;
+		     nit = dfs_cache_get_next_tgt(new_tl, nit)) {
+			if (target_share_equal(server,
+					       dfs_cache_get_tgt_name(oit),
+					       dfs_cache_get_tgt_name(nit)))
 				return;
 		}
 	}
 
 	cifs_dbg(FYI, "%s: no cached or matched targets. mark dfs share for reconnect.\n", __func__);
-	cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
+	cifs_signal_cifsd_for_reconnect(server, true);
 }
 
 /* Refresh dfs referral of tcon and mark it for reconnect if needed */
 static int __refresh_tcon(const char *path, struct cifs_tcon *tcon, bool force_refresh)
 {
-	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
+	struct dfs_cache_tgt_list old_tl = DFS_CACHE_TGT_LIST_INIT(old_tl);
+	struct dfs_cache_tgt_list new_tl = DFS_CACHE_TGT_LIST_INIT(new_tl);
 	struct cifs_ses *ses = CIFS_DFS_ROOT_SES(tcon->ses);
 	struct cifs_tcon *ipc = ses->tcon_ipc;
-	struct dfs_info3_param *refs = NULL;
 	bool needs_refresh = false;
 	struct cache_entry *ce;
 	unsigned int xid;
-	int numrefs = 0;
 	int rc = 0;
 
 	xid = get_xid();
@@ -1358,9 +1362,8 @@ static int __refresh_tcon(const char *path, struct cifs_tcon *tcon, bool force_r
 	ce = lookup_cache_entry(path);
 	needs_refresh = force_refresh || IS_ERR(ce) || cache_entry_expired(ce);
 	if (!IS_ERR(ce)) {
-		rc = get_targets(ce, &tl);
-		if (rc)
-			cifs_dbg(FYI, "%s: could not get dfs targets: %d\n", __func__, rc);
+		rc = get_targets(ce, &old_tl);
+		cifs_dbg(FYI, "%s: get_targets: %d\n", __func__, rc);
 	}
 	up_read(&htable_rw_lock);
 
@@ -1377,26 +1380,18 @@ static int __refresh_tcon(const char *path, struct cifs_tcon *tcon, bool force_r
 	}
 	spin_unlock(&ipc->tc_lock);
 
-	rc = get_dfs_referral(xid, ses, path, &refs, &numrefs);
-	if (!rc) {
-		/* Create or update a cache entry with the new referral */
-		dump_refs(refs, numrefs);
-
-		down_write(&htable_rw_lock);
-		ce = lookup_cache_entry(path);
-		if (IS_ERR(ce))
-			add_cache_entry_locked(refs, numrefs);
-		else if (force_refresh || cache_entry_expired(ce))
-			update_cache_entry_locked(ce, refs, numrefs);
-		up_write(&htable_rw_lock);
-
-		mark_for_reconnect_if_needed(tcon, &tl, refs, numrefs);
+	ce = cache_refresh_path(xid, ses, path, true);
+	if (!IS_ERR(ce)) {
+		rc = get_targets(ce, &new_tl);
+		up_read(&htable_rw_lock);
+		cifs_dbg(FYI, "%s: get_targets: %d\n", __func__, rc);
+		mark_for_reconnect_if_needed(tcon->ses->server, &old_tl, &new_tl);
 	}
 
 out:
 	free_xid(xid);
-	dfs_cache_free_tgts(&tl);
-	free_dfs_info_array(refs, numrefs);
+	dfs_cache_free_tgts(&old_tl);
+	dfs_cache_free_tgts(&new_tl);
 	return rc;
 }
 
-- 
2.39.0

