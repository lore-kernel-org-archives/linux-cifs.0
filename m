Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15039C00A5A
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 22:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjAQWXw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Jan 2023 17:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjAQWVL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Jan 2023 17:21:11 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9962261882
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 14:00:56 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 2D3B080CF7;
        Tue, 17 Jan 2023 22:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673992855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bM1gJFc+tNJJwlTFw9QEOZDd0XBC1HlF9j/fpfhnEYw=;
        b=mLkutIPY6KBdEis5b58fcvQ89y9e/cB/YhO6iFaj+Se1z+JiyGXm5/lxWgdueeGkkv6Usz
        iWTK41AVEEIhyEe0F7t8zI29Unp40FAvjcJqLB5YuzZ5scc5b1fu2QgQXGWqEbPcc9x4Mq
        lm16D/pdif0ZafJbM1fYWXnNXvPPNFECvKBS1bBGsn7bIG19LAWprpGw4xR7yb92j0S7bj
        I+vRqDcou0hrakSjo2mxTvW6ZHwE96QAPzTgSpcIZqHga+ruDkDXfaFUAU3ZI8T34qSquQ
        p55qmoJ9l4swIHPimPvBNN+WowGdDBYGgSgONNPRyClhiLg+toANOIaNGS2r7A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, aurelien.aptel@gmail.com,
        Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH v2 2/5] cifs: avoid re-lookups in dfs_cache_find()
Date:   Tue, 17 Jan 2023 19:00:38 -0300
Message-Id: <20230117220041.15905-3-pc@cjr.nz>
In-Reply-To: <20230117220041.15905-1-pc@cjr.nz>
References: <20230117000952.9965-1-pc@cjr.nz>
 <20230117220041.15905-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Simply downgrade the write lock on cache updates from
cache_refresh_path() and avoid unnecessary re-lookup in
dfs_cache_find().

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 58 ++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index a6d7ae5f49a4..755a00c4cba1 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -558,7 +558,8 @@ static void remove_oldest_entry_locked(void)
 }
 
 /* Add a new DFS cache entry */
-static int add_cache_entry_locked(struct dfs_info3_param *refs, int numrefs)
+static struct cache_entry *add_cache_entry_locked(struct dfs_info3_param *refs,
+						  int numrefs)
 {
 	int rc;
 	struct cache_entry *ce;
@@ -573,11 +574,11 @@ static int add_cache_entry_locked(struct dfs_info3_param *refs, int numrefs)
 
 	rc = cache_entry_hash(refs[0].path_name, strlen(refs[0].path_name), &hash);
 	if (rc)
-		return rc;
+		return ERR_PTR(rc);
 
 	ce = alloc_cache_entry(refs, numrefs);
 	if (IS_ERR(ce))
-		return PTR_ERR(ce);
+		return ce;
 
 	spin_lock(&cache_ttl_lock);
 	if (!cache_ttl) {
@@ -594,7 +595,7 @@ static int add_cache_entry_locked(struct dfs_info3_param *refs, int numrefs)
 
 	atomic_inc(&cache_count);
 
-	return 0;
+	return ce;
 }
 
 /* Check if two DFS paths are equal.  @s1 and @s2 are expected to be in @cache_cp's charset */
@@ -767,8 +768,12 @@ static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses, const
  *
  * For interlinks, cifs_mount() and expand_dfs_referral() are supposed to
  * handle them properly.
+ *
+ * On success, return entry with acquired lock for reading, otherwise error ptr.
  */
-static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, const char *path)
+static struct cache_entry *cache_refresh_path(const unsigned int xid,
+					      struct cifs_ses *ses,
+					      const char *path)
 {
 	struct dfs_info3_param *refs = NULL;
 	struct cache_entry *ce;
@@ -780,10 +785,9 @@ static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, cons
 	down_read(&htable_rw_lock);
 
 	ce = lookup_cache_entry(path);
-	if (!IS_ERR(ce) && !cache_entry_expired(ce)) {
-		up_read(&htable_rw_lock);
-		return 0;
-	}
+	if (!IS_ERR(ce) && !cache_entry_expired(ce))
+		return ce;
+
 	/*
 	 * Unlock shared access as we don't want to hold any locks while getting
 	 * a new referral.  The @ses used for performing the I/O could be
@@ -797,8 +801,10 @@ static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, cons
 	 * Request a new DFS referral in order to create or update a cache entry.
 	 */
 	rc = get_dfs_referral(xid, ses, path, &refs, &numrefs);
-	if (rc)
+	if (rc) {
+		ce = ERR_PTR(rc);
 		goto out;
+	}
 
 	dump_refs(refs, numrefs);
 
@@ -806,16 +812,24 @@ static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, cons
 	/* Re-check as another task might have it added or refreshed already */
 	ce = lookup_cache_entry(path);
 	if (!IS_ERR(ce)) {
-		if (cache_entry_expired(ce))
+		if (cache_entry_expired(ce)) {
 			rc = update_cache_entry_locked(ce, refs, numrefs);
+			if (rc)
+				ce = ERR_PTR(rc);
+		}
 	} else {
-		rc = add_cache_entry_locked(refs, numrefs);
+		ce = add_cache_entry_locked(refs, numrefs);
 	}
 
-	up_write(&htable_rw_lock);
+	if (IS_ERR(ce)) {
+		up_write(&htable_rw_lock);
+		goto out;
+	}
+
+	downgrade_write(&htable_rw_lock);
 out:
 	free_dfs_info_array(refs, numrefs);
-	return rc;
+	return ce;
 }
 
 /*
@@ -935,15 +949,8 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses, const struct nl
 	if (IS_ERR(npath))
 		return PTR_ERR(npath);
 
-	rc = cache_refresh_path(xid, ses, npath);
-	if (rc)
-		goto out_free_path;
-
-	down_read(&htable_rw_lock);
-
-	ce = lookup_cache_entry(npath);
+	ce = cache_refresh_path(xid, ses, npath);
 	if (IS_ERR(ce)) {
-		up_read(&htable_rw_lock);
 		rc = PTR_ERR(ce);
 		goto out_free_path;
 	}
@@ -1039,10 +1046,13 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 
 	cifs_dbg(FYI, "%s: update target hint - path: %s\n", __func__, npath);
 
-	rc = cache_refresh_path(xid, ses, npath);
-	if (rc)
+	ce = cache_refresh_path(xid, ses, npath);
+	if (IS_ERR(ce)) {
+		rc = PTR_ERR(ce);
 		goto out_free_path;
+	}
 
+	up_read(&htable_rw_lock);
 	down_write(&htable_rw_lock);
 
 	ce = lookup_cache_entry(npath);
-- 
2.39.0

