Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94609C4743C
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D39B61406
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhFDW1x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 18:27:53 -0400
Received: from mx.cjr.nz ([51.158.111.142]:9514 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231657AbhFDW1w (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 4 Jun 2021 18:27:52 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0A8BC80BAD;
        Fri,  4 Jun 2021 22:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1622845564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6RU08FjG81GlWQv2XEJoJ3kMsWWTYjbhlbpeTkscdI=;
        b=aD6diVG7Jt5tbPqar6mi74avmXCgATOl35x45AS/owjui9Fpcz4K8+mgtefSdQfUXrYdM7
        dJabvh068kkTnGhB1zjkFejXeaC9fG4qCdM2Vw+UEFqxbjnMLQQklCJPvwst8PKyj4bI7y
        cmUu3EvDg3TR8SO0GKtLWbK4cOlS+hjIsYZrgxqV/TDiq/xznZupGjcYVKHBQYgD/qgrXO
        Z30N420pCmAZom2x1HKrEJvxvyIbkoyJOdx+QUqw5ZJAvk/7bnvqjjmtqEQQ2YaAYwmvjF
        mkPNSpCA55l+6WsWx3X26bZHhz5IA4VcoImRN3kqjxCaltjIZAUkDAuZL8M64Q==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 5/7] cifs: fix path comparison and hash calc
Date:   Fri,  4 Jun 2021 19:25:31 -0300
Message-Id: <20210604222533.4760-6-pc@cjr.nz>
In-Reply-To: <20210604222533.4760-1-pc@cjr.nz>
References: <20210604222533.4760-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix cache lookup and hash calculations when handling paths with
different cases.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 168 ++++++++++++++++++++++++--------------------
 1 file changed, 93 insertions(+), 75 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index c52fec3c4092..f7c4874ddc17 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -424,12 +424,24 @@ int dfs_cache_init(void)
 	return rc;
 }
 
-static inline unsigned int cache_entry_hash(const void *data, int size)
+static int cache_entry_hash(const void *data, int size, unsigned int *hash)
 {
-	unsigned int h;
+	int i, clen;
+	const unsigned char *s = data;
+	wchar_t c;
+	unsigned int h = 0;
 
-	h = jhash(data, size, 0);
-	return h & (CACHE_HTABLE_SIZE - 1);
+	for (i = 0; i < size; i += clen) {
+		clen = cache_cp->char2uni(&s[i], size - i, &c);
+		if (unlikely(clen < 0)) {
+			cifs_dbg(VFS, "%s: can't convert char\n", __func__);
+			return clen;
+		}
+		c = cifs_toupper(c);
+		h = jhash(&c, sizeof(c), h);
+	}
+	*hash = h % CACHE_HTABLE_SIZE;
+	return 0;
 }
 
 /* Check whether second path component of @path is SYSVOL or NETLOGON */
@@ -522,9 +534,7 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
 }
 
 /* Allocate a new cache entry */
-static struct cache_entry *alloc_cache_entry(const char *path,
-					     const struct dfs_info3_param *refs,
-					     int numrefs)
+static struct cache_entry *alloc_cache_entry(struct dfs_info3_param *refs, int numrefs)
 {
 	struct cache_entry *ce;
 	int rc;
@@ -533,11 +543,9 @@ static struct cache_entry *alloc_cache_entry(const char *path,
 	if (!ce)
 		return ERR_PTR(-ENOMEM);
 
-	ce->path = kstrdup(path, GFP_KERNEL);
-	if (!ce->path) {
-		kmem_cache_free(cache_slab, ce);
-		return ERR_PTR(-ENOMEM);
-	}
+	ce->path = refs[0].path_name;
+	refs[0].path_name = NULL;
+
 	INIT_HLIST_NODE(&ce->hlist);
 	INIT_LIST_HEAD(&ce->tlist);
 
@@ -579,12 +587,18 @@ static void remove_oldest_entry_locked(void)
 }
 
 /* Add a new DFS cache entry */
-static int add_cache_entry_locked(const char *path, unsigned int hash,
-				  struct dfs_info3_param *refs, int numrefs)
+static int add_cache_entry_locked(struct dfs_info3_param *refs, int numrefs)
 {
+	int rc;
 	struct cache_entry *ce;
+	unsigned int hash;
 
-	ce = alloc_cache_entry(path, refs, numrefs);
+	convert_delimiter(refs[0].path_name, '\\');
+	rc = cache_entry_hash(refs[0].path_name, strlen(refs[0].path_name), &hash);
+	if (rc)
+		return rc;
+
+	ce = alloc_cache_entry(refs, numrefs);
 	if (IS_ERR(ce))
 		return PTR_ERR(ce);
 
@@ -604,57 +618,69 @@ static int add_cache_entry_locked(const char *path, unsigned int hash,
 	return 0;
 }
 
-static struct cache_entry *__lookup_cache_entry(const char *path)
+/* Check if two DFS paths are equal.  @s1 and @s2 are expected to be in @cache_cp's charset */
+static bool dfs_path_equal(const char *s1, int len1, const char *s2, int len2)
+{
+	int i, l1, l2;
+	wchar_t c1, c2;
+
+	if (len1 != len2)
+		return false;
+
+	for (i = 0; i < len1; i += l1) {
+		l1 = cache_cp->char2uni(&s1[i], len1 - i, &c1);
+		l2 = cache_cp->char2uni(&s2[i], len2 - i, &c2);
+		if (unlikely(l1 < 0 && l2 < 0)) {
+			if (s1[i] != s2[i])
+				return false;
+			l1 = 1;
+			continue;
+		}
+		if (l1 != l2)
+			return false;
+		if (cifs_toupper(c1) != cifs_toupper(c2))
+			return false;
+	}
+	return true;
+}
+
+static struct cache_entry *__lookup_cache_entry(const char *path, unsigned int hash, int len)
 {
 	struct cache_entry *ce;
-	unsigned int h;
-	bool found = false;
 
-	h = cache_entry_hash(path, strlen(path));
-
-	hlist_for_each_entry(ce, &cache_htable[h], hlist) {
-		if (!strcasecmp(path, ce->path)) {
-			found = true;
+	hlist_for_each_entry(ce, &cache_htable[hash], hlist) {
+		if (dfs_path_equal(ce->path, strlen(ce->path), path, len)) {
 			dump_ce(ce);
-			break;
+			return ce;
 		}
 	}
-
-	if (!found)
-		ce = ERR_PTR(-ENOENT);
-	return ce;
+	return ERR_PTR(-EEXIST);
 }
 
 /*
- * Find a DFS cache entry in hash table and optionally check prefix path against
- * @path.
- * Use whole path components in the match.
- * Must be called with htable_rw_lock held.
+ * Find a DFS cache entry in hash table and optionally check prefix path against normalized @path.
  *
- * Return ERR_PTR(-ENOENT) if the entry is not found.
+ * Use whole path components in the match.  Must be called with htable_rw_lock held.
+ *
+ * Return ERR_PTR(-EEXIST) if the entry is not found.
  */
-static struct cache_entry *lookup_cache_entry(const char *path, unsigned int *hash)
+static struct cache_entry *lookup_cache_entry(const char *path)
 {
-	struct cache_entry *ce = ERR_PTR(-ENOENT);
-	unsigned int h;
+	struct cache_entry *ce;
 	int cnt = 0;
-	char *npath;
-	char *s, *e;
-	char sep;
+	const char *s = path, *e;
+	char sep = *s;
+	unsigned int hash;
+	int rc;
 
-	npath = kstrdup(path, GFP_KERNEL);
-	if (!npath)
-		return ERR_PTR(-ENOMEM);
-
-	s = npath;
-	sep = *npath;
 	while ((s = strchr(s, sep)) && ++cnt < 3)
 		s++;
 
 	if (cnt < 3) {
-		h = cache_entry_hash(path, strlen(path));
-		ce = __lookup_cache_entry(path);
-		goto out;
+		rc = cache_entry_hash(path, strlen(path), &hash);
+		if (rc)
+			return ERR_PTR(rc);
+		return __lookup_cache_entry(path, hash, strlen(path));
 	}
 	/*
 	 * Handle paths that have more than two path components and are a complete prefix of the DFS
@@ -662,36 +688,29 @@ static struct cache_entry *lookup_cache_entry(const char *path, unsigned int *ha
 	 *
 	 * See MS-DFSC 3.2.5.5 "Receiving a Root Referral Request or Link Referral Request".
 	 */
-	h = cache_entry_hash(npath, strlen(npath));
-	e = npath + strlen(npath) - 1;
+	e = path + strlen(path) - 1;
 	while (e > s) {
-		char tmp;
+		int len;
 
 		/* skip separators */
 		while (e > s && *e == sep)
 			e--;
 		if (e == s)
-			goto out;
-
-		tmp = *(e+1);
-		*(e+1) = 0;
-
-		ce = __lookup_cache_entry(npath);
-		if (!IS_ERR(ce)) {
-			h = cache_entry_hash(npath, strlen(npath));
 			break;
-		}
 
-		*(e+1) = tmp;
+		len = e + 1 - path;
+		rc = cache_entry_hash(path, len, &hash);
+		if (rc)
+			return ERR_PTR(rc);
+		ce = __lookup_cache_entry(path, hash, len);
+		if (!IS_ERR(ce))
+			return ce;
+
 		/* backward until separator */
 		while (e > s && *e != sep)
 			e--;
 	}
-out:
-	if (hash)
-		*hash = h;
-	kfree(npath);
-	return ce;
+	return ERR_PTR(-EEXIST);
 }
 
 /**
@@ -717,7 +736,7 @@ static int update_cache_entry_locked(const char *path, const struct dfs_info3_pa
 	struct cache_entry *ce;
 	char *s, *th = NULL;
 
-	ce = lookup_cache_entry(path, NULL);
+	ce = lookup_cache_entry(path);
 	if (IS_ERR(ce))
 		return PTR_ERR(ce);
 
@@ -767,7 +786,6 @@ static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses, const
 static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, const char *path)
 {
 	int rc;
-	unsigned int hash;
 	struct cache_entry *ce;
 	struct dfs_info3_param *refs = NULL;
 	int numrefs = 0;
@@ -777,7 +795,7 @@ static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, cons
 
 	down_write(&htable_rw_lock);
 
-	ce = lookup_cache_entry(path, &hash);
+	ce = lookup_cache_entry(path);
 	if (!IS_ERR(ce)) {
 		if (!cache_entry_expired(ce)) {
 			dump_ce(ce);
@@ -808,7 +826,7 @@ static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, cons
 		remove_oldest_entry_locked();
 	}
 
-	rc = add_cache_entry_locked(path, hash, refs, numrefs);
+	rc = add_cache_entry_locked(refs, numrefs);
 	if (!rc)
 		atomic_inc(&cache_count);
 
@@ -940,7 +958,7 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses, const struct nl
 
 	down_read(&htable_rw_lock);
 
-	ce = lookup_cache_entry(npath, NULL);
+	ce = lookup_cache_entry(npath);
 	if (IS_ERR(ce)) {
 		up_read(&htable_rw_lock);
 		rc = PTR_ERR(ce);
@@ -987,7 +1005,7 @@ int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
 
 	down_read(&htable_rw_lock);
 
-	ce = lookup_cache_entry(path, NULL);
+	ce = lookup_cache_entry(path);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
 		goto out_unlock;
@@ -1044,7 +1062,7 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 
 	down_write(&htable_rw_lock);
 
-	ce = lookup_cache_entry(npath, NULL);
+	ce = lookup_cache_entry(npath);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
 		goto out_unlock;
@@ -1098,7 +1116,7 @@ int dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt_
 
 	down_write(&htable_rw_lock);
 
-	ce = lookup_cache_entry(path, NULL);
+	ce = lookup_cache_entry(path);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
 		goto out_unlock;
@@ -1147,7 +1165,7 @@ int dfs_cache_get_tgt_referral(const char *path, const struct dfs_cache_tgt_iter
 
 	down_read(&htable_rw_lock);
 
-	ce = lookup_cache_entry(path, NULL);
+	ce = lookup_cache_entry(path);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
 		goto out_unlock;
-- 
2.31.1

