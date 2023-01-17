Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAD9C46467
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 00:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjAQALI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Jan 2023 19:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbjAQALF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Jan 2023 19:11:05 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3201A1E5D2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Jan 2023 16:11:01 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9439D80267;
        Tue, 17 Jan 2023 00:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673914260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PeKtnOZDO63lfFPPXqoP7AsH6XTXkD47QyC1poGYkdI=;
        b=lDa72YlpFdr2rUc849ChHkSBVcUOTCP3+qV+kgkzLND1aGFZ0W/VqM0u7jNPHgVI2MLayS
        w8ucUvP+sRmd4tPdX/MLy77HPxc0HZUi25pd1Mo6GuJNa7DJZ51cwtqm5+Qo4O5n6hc+qv
        Uiuxr7X4jeykzZvC3T+3wtumwp3upKAouqbjFIqVJl/KFB2F/QvW0W8YmlDuGffuyRc2rW
        gNDVNeMhWsaJ6d4YMhebj18clu+Lg+sCEp2HxD1s455tPYBFiPhQRF6UYAAhd4RiFmy1Sy
        65VhERKAH5iLZlHiMbUwOjpP6c3NnmSnEIJSa61X9cYkb/uz/hlGhuLUe33K7w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 3/5] cifs: don't take exclusive lock for updating target hints
Date:   Mon, 16 Jan 2023 21:09:50 -0300
Message-Id: <20230117000952.9965-4-pc@cjr.nz>
In-Reply-To: <20230117000952.9965-1-pc@cjr.nz>
References: <20230117000952.9965-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Avoid contention while updating dfs target hints.  This should be
perfectly fine to update them under shared locks.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 47 +++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index c82721b3277c..49d1f390a6b8 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -269,7 +269,7 @@ static int dfscache_proc_show(struct seq_file *m, void *v)
 			list_for_each_entry(t, &ce->tlist, list) {
 				seq_printf(m, "  %s%s\n",
 					   t->name,
-					   ce->tgthint == t ? " (target hint)" : "");
+					   READ_ONCE(ce->tgthint) == t ? " (target hint)" : "");
 			}
 		}
 	}
@@ -321,7 +321,7 @@ static inline void dump_tgts(const struct cache_entry *ce)
 	cifs_dbg(FYI, "target list:\n");
 	list_for_each_entry(t, &ce->tlist, list) {
 		cifs_dbg(FYI, "  %s%s\n", t->name,
-			 ce->tgthint == t ? " (target hint)" : "");
+			 READ_ONCE(ce->tgthint) == t ? " (target hint)" : "");
 	}
 }
 
@@ -427,7 +427,7 @@ static int cache_entry_hash(const void *data, int size, unsigned int *hash)
 /* Return target hint of a DFS cache entry */
 static inline char *get_tgt_name(const struct cache_entry *ce)
 {
-	struct cache_dfs_tgt *t = ce->tgthint;
+	struct cache_dfs_tgt *t = READ_ONCE(ce->tgthint);
 
 	return t ? t->name : ERR_PTR(-ENOENT);
 }
@@ -470,6 +470,7 @@ static struct cache_dfs_tgt *alloc_target(const char *name, int path_consumed)
 static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
 			 struct cache_entry *ce, const char *tgthint)
 {
+	struct cache_dfs_tgt *target;
 	int i;
 
 	ce->ttl = max_t(int, refs[0].ttl, CACHE_MIN_TTL);
@@ -496,8 +497,9 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
 		ce->numtgts++;
 	}
 
-	ce->tgthint = list_first_entry_or_null(&ce->tlist,
-					       struct cache_dfs_tgt, list);
+	target = list_first_entry_or_null(&ce->tlist, struct cache_dfs_tgt,
+					  list);
+	WRITE_ONCE(ce->tgthint, target);
 
 	return 0;
 }
@@ -712,14 +714,15 @@ void dfs_cache_destroy(void)
 static int update_cache_entry_locked(struct cache_entry *ce, const struct dfs_info3_param *refs,
 				     int numrefs)
 {
+	struct cache_dfs_tgt *target;
+	char *th = NULL;
 	int rc;
-	char *s, *th = NULL;
 
 	WARN_ON(!rwsem_is_locked(&htable_rw_lock));
 
-	if (ce->tgthint) {
-		s = ce->tgthint->name;
-		th = kstrdup(s, GFP_ATOMIC);
+	target = READ_ONCE(ce->tgthint);
+	if (target) {
+		th = kstrdup(target->name, GFP_ATOMIC);
 		if (!th)
 			return -ENOMEM;
 	}
@@ -890,7 +893,7 @@ static int get_targets(struct cache_entry *ce, struct dfs_cache_tgt_list *tl)
 		}
 		it->it_path_consumed = t->path_consumed;
 
-		if (ce->tgthint == t)
+		if (READ_ONCE(ce->tgthint) == t)
 			list_add(&it->it_list, head);
 		else
 			list_add_tail(&it->it_list, head);
@@ -1046,23 +1049,14 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 		goto out_free_path;
 	}
 
-	up_read(&htable_rw_lock);
-	down_write(&htable_rw_lock);
-
-	ce = lookup_cache_entry(npath);
-	if (IS_ERR(ce)) {
-		rc = PTR_ERR(ce);
-		goto out_unlock;
-	}
-
-	t = ce->tgthint;
+	t = READ_ONCE(ce->tgthint);
 
 	if (likely(!strcasecmp(it->it_name, t->name)))
 		goto out_unlock;
 
 	list_for_each_entry(t, &ce->tlist, list) {
 		if (!strcasecmp(t->name, it->it_name)) {
-			ce->tgthint = t;
+			WRITE_ONCE(ce->tgthint, t);
 			cifs_dbg(FYI, "%s: new target hint: %s\n", __func__,
 				 it->it_name);
 			break;
@@ -1070,7 +1064,7 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 out_unlock:
-	up_write(&htable_rw_lock);
+	up_read(&htable_rw_lock);
 out_free_path:
 	kfree(npath);
 	return rc;
@@ -1100,21 +1094,20 @@ void dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, path);
 
-	if (!down_write_trylock(&htable_rw_lock))
-		return;
+	down_read(&htable_rw_lock);
 
 	ce = lookup_cache_entry(path);
 	if (IS_ERR(ce))
 		goto out_unlock;
 
-	t = ce->tgthint;
+	t = READ_ONCE(ce->tgthint);
 
 	if (unlikely(!strcasecmp(it->it_name, t->name)))
 		goto out_unlock;
 
 	list_for_each_entry(t, &ce->tlist, list) {
 		if (!strcasecmp(t->name, it->it_name)) {
-			ce->tgthint = t;
+			WRITE_ONCE(ce->tgthint, t);
 			cifs_dbg(FYI, "%s: new target hint: %s\n", __func__,
 				 it->it_name);
 			break;
@@ -1122,7 +1115,7 @@ void dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt
 	}
 
 out_unlock:
-	up_write(&htable_rw_lock);
+	up_read(&htable_rw_lock);
 }
 
 /**
-- 
2.39.0

