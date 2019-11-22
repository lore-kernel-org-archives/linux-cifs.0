Return-Path: <SRS0=i0zP=ZO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE69C432C0
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 777952071F
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="GLLBm9ul"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKVPbu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Nov 2019 10:31:50 -0500
Received: from mx.cjr.nz ([51.158.111.142]:28452 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfKVPbu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Nov 2019 10:31:50 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 04CA280A50;
        Fri, 22 Nov 2019 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574436701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GrsNZCOIdIM4aLq4mkH5RmVwyGKa3eQlayoEVqZib2k=;
        b=GLLBm9ulK4e6vfGg6aylNscbFB6qlhdAP1ztG+uwqZ4FUCAQTQmWZV1jybBiNogRAF8cYX
        ypUJ4EipLDbW17s5ZLfvlsznMNeg8WnAVFqOPwgN9FRfwNMhOP22mCrPj1kAUXkD+zfR8v
        wXenVQbnhUE1Zsx5C5lbw9ux74Ymvoms8nz9/llntmsLYgtidAngFrro2G0+tBqyjDmSXa
        wkBVwZQNgChQB6UNEx0eEMv8QamXfdK94Vrp1iPPQClfAxbJkNxpD9ksDIMZ5+85VDq8gA
        zCZ8RVDghoGWhTFWgBT5Zd8FNBA1YScKalo6mrGSQO8ZF8s10jCbwUKYxIwrhA==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH 4/7] cifs: Clean up DFS referral cache
Date:   Fri, 22 Nov 2019 12:30:54 -0300
Message-Id: <20191122153057.6608-5-pc@cjr.nz>
In-Reply-To: <20191122153057.6608-1-pc@cjr.nz>
References: <20191122153057.6608-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch does a couple of things:

  - Do some renaming in static code (cosmetic)
  - Use rwlock for cache list
  - Use spinlock for volume list
  - Avoid lock contention in some places

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 989 ++++++++++++++++++++++----------------------
 1 file changed, 497 insertions(+), 492 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 2faa05860a48..b082603c793a 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -5,8 +5,6 @@
  * Copyright (c) 2018-2019 Paulo Alcantara <palcantara@suse.de>
  */
 
-#include <linux/rcupdate.h>
-#include <linux/rculist.h>
 #include <linux/jhash.h>
 #include <linux/ktime.h>
 #include <linux/slab.h>
@@ -22,8 +20,8 @@
 
 #include "dfs_cache.h"
 
-#define DFS_CACHE_HTABLE_SIZE 32
-#define DFS_CACHE_MAX_ENTRIES 64
+#define CACHE_HTABLE_SIZE 32
+#define CACHE_MAX_ENTRIES 64
 
 #define IS_INTERLINK_SET(v) ((v) & (DFSREF_REFERRAL_SERVER | \
 				    DFSREF_STORAGE_SERVER))
@@ -33,55 +31,48 @@ struct dfs_cache_tgt {
 	struct list_head t_list;
 };
 
-struct dfs_cache_entry {
-	struct hlist_node ce_hlist;
-	const char *ce_path;
-	int ce_ttl;
-	int ce_srvtype;
-	int ce_flags;
-	struct timespec64 ce_etime;
-	int ce_path_consumed;
-	int ce_numtgts;
-	struct list_head ce_tlist;
-	struct dfs_cache_tgt *ce_tgthint;
-	struct rcu_head ce_rcu;
+struct cache_entry {
+	struct hlist_node hlist;
+	const char *path;
+	int ttl;
+	int srvtype;
+	int flags;
+	struct timespec64 etime;
+	int path_consumed;
+	int numtgts;
+	struct list_head tlist;
+	struct dfs_cache_tgt *tgthint;
 };
 
-static struct kmem_cache *dfs_cache_slab __read_mostly;
-
-struct dfs_cache_vol_info {
-	char *vi_fullpath;
-	struct smb_vol vi_vol;
-	char *vi_mntdata;
-	struct list_head vi_list;
+struct vol_info {
+	char *fullpath;
+	struct smb_vol smb_vol;
+	char *mntdata;
+	struct list_head list;
 };
 
-struct dfs_cache {
-	struct mutex dc_lock;
-	struct nls_table *dc_nlsc;
-	struct list_head dc_vol_list;
-	int dc_ttl;
-	struct delayed_work dc_refresh;
-};
+static struct kmem_cache *cache_slab __read_mostly;
+static struct workqueue_struct *dfscache_wq __read_mostly;
 
-static struct dfs_cache dfs_cache;
+static atomic_t cache_ttl;
+static struct nls_table *cache_nlsc;
 
 /*
  * Number of entries in the cache
  */
-static size_t dfs_cache_count;
+static atomic_t cache_count;
 
-static DEFINE_MUTEX(dfs_cache_list_lock);
-static struct hlist_head dfs_cache_htable[DFS_CACHE_HTABLE_SIZE];
+static struct hlist_head cache_htable[CACHE_HTABLE_SIZE];
+static DECLARE_RWSEM(list_sem);
+
+static LIST_HEAD(vol_list);
+static DEFINE_SPINLOCK(vol_lock);
 
 static void refresh_cache_worker(struct work_struct *work);
 
-static inline bool is_path_valid(const char *path)
-{
-	return path && (strchr(path + 1, '\\') || strchr(path + 1, '/'));
-}
+static DECLARE_DELAYED_WORK(refresh_task, refresh_cache_worker);
 
-static inline int get_normalized_path(const char *path, char **npath)
+static int get_normalized_path(const char *path, char **npath)
 {
 	if (*path == '\\') {
 		*npath = (char *)path;
@@ -100,57 +91,48 @@ static inline void free_normalized_path(const char *path, char *npath)
 		kfree(npath);
 }
 
-static inline bool cache_entry_expired(const struct dfs_cache_entry *ce)
+static inline bool cache_entry_expired(const struct cache_entry *ce)
 {
 	struct timespec64 ts;
 
 	ktime_get_coarse_real_ts64(&ts);
-	return timespec64_compare(&ts, &ce->ce_etime) >= 0;
+	return timespec64_compare(&ts, &ce->etime) >= 0;
 }
 
-static inline void free_tgts(struct dfs_cache_entry *ce)
+static inline void free_tgts(struct cache_entry *ce)
 {
 	struct dfs_cache_tgt *t, *n;
 
-	list_for_each_entry_safe(t, n, &ce->ce_tlist, t_list) {
+	list_for_each_entry_safe(t, n, &ce->tlist, t_list) {
 		list_del(&t->t_list);
 		kfree(t->t_name);
 		kfree(t);
 	}
 }
 
-static void free_cache_entry(struct rcu_head *rcu)
+static inline void flush_cache_ent(struct cache_entry *ce)
 {
-	struct dfs_cache_entry *ce = container_of(rcu, struct dfs_cache_entry,
-						  ce_rcu);
-	kmem_cache_free(dfs_cache_slab, ce);
-}
-
-static inline void flush_cache_ent(struct dfs_cache_entry *ce)
-{
-	if (hlist_unhashed(&ce->ce_hlist))
-		return;
-
-	hlist_del_init_rcu(&ce->ce_hlist);
-	kfree_const(ce->ce_path);
+	hlist_del_init(&ce->hlist);
+	kfree(ce->path);
 	free_tgts(ce);
-	dfs_cache_count--;
-	call_rcu(&ce->ce_rcu, free_cache_entry);
+	atomic_dec(&cache_count);
+	kmem_cache_free(cache_slab, ce);
 }
 
 static void flush_cache_ents(void)
 {
 	int i;
 
-	rcu_read_lock();
-	for (i = 0; i < DFS_CACHE_HTABLE_SIZE; i++) {
-		struct hlist_head *l = &dfs_cache_htable[i];
-		struct dfs_cache_entry *ce;
+	for (i = 0; i < CACHE_HTABLE_SIZE; i++) {
+		struct hlist_head *l = &cache_htable[i];
+		struct hlist_node *n;
+		struct cache_entry *ce;
 
-		hlist_for_each_entry_rcu(ce, l, ce_hlist)
-			flush_cache_ent(ce);
+		hlist_for_each_entry_safe(ce, n, l, hlist) {
+			if (!hlist_unhashed(&ce->hlist))
+				flush_cache_ent(ce);
+		}
 	}
-	rcu_read_unlock();
 }
 
 /*
@@ -158,36 +140,39 @@ static void flush_cache_ents(void)
  */
 static int dfscache_proc_show(struct seq_file *m, void *v)
 {
-	int bucket;
-	struct dfs_cache_entry *ce;
+	int i;
+	struct cache_entry *ce;
 	struct dfs_cache_tgt *t;
 
 	seq_puts(m, "DFS cache\n---------\n");
 
-	mutex_lock(&dfs_cache_list_lock);
-
-	rcu_read_lock();
-	hash_for_each_rcu(dfs_cache_htable, bucket, ce, ce_hlist) {
-		seq_printf(m,
-			   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,"
-			   "interlink=%s,path_consumed=%d,expired=%s\n",
-			   ce->ce_path,
-			   ce->ce_srvtype == DFS_TYPE_ROOT ? "root" : "link",
-			   ce->ce_ttl, ce->ce_etime.tv_nsec,
-			   IS_INTERLINK_SET(ce->ce_flags) ? "yes" : "no",
-			   ce->ce_path_consumed,
-			   cache_entry_expired(ce) ? "yes" : "no");
-
-		list_for_each_entry(t, &ce->ce_tlist, t_list) {
-			seq_printf(m, "  %s%s\n",
-				   t->t_name,
-				   ce->ce_tgthint == t ? " (target hint)" : "");
+	down_read(&list_sem);
+	for (i = 0; i < CACHE_HTABLE_SIZE; i++) {
+		struct hlist_head *l = &cache_htable[i];
+
+		hlist_for_each_entry(ce, l, hlist) {
+			if (hlist_unhashed(&ce->hlist))
+				continue;
+
+			seq_printf(m,
+				   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,"
+				   "interlink=%s,path_consumed=%d,expired=%s\n",
+				   ce->path,
+				   ce->srvtype == DFS_TYPE_ROOT ? "root" : "link",
+				   ce->ttl, ce->etime.tv_nsec,
+				   IS_INTERLINK_SET(ce->flags) ? "yes" : "no",
+				   ce->path_consumed,
+				   cache_entry_expired(ce) ? "yes" : "no");
+
+			list_for_each_entry(t, &ce->tlist, t_list) {
+				seq_printf(m, "  %s%s\n",
+					   t->t_name,
+					   ce->tgthint == t ? " (target hint)" : "");
+			}
 		}
-
 	}
-	rcu_read_unlock();
+	up_read(&list_sem);
 
-	mutex_unlock(&dfs_cache_list_lock);
 	return 0;
 }
 
@@ -205,9 +190,10 @@ static ssize_t dfscache_proc_write(struct file *file, const char __user *buffer,
 		return -EINVAL;
 
 	cifs_dbg(FYI, "clearing dfs cache");
-	mutex_lock(&dfs_cache_list_lock);
+
+	down_write(&list_sem);
 	flush_cache_ents();
-	mutex_unlock(&dfs_cache_list_lock);
+	up_write(&list_sem);
 
 	return count;
 }
@@ -226,25 +212,25 @@ const struct file_operations dfscache_proc_fops = {
 };
 
 #ifdef CONFIG_CIFS_DEBUG2
-static inline void dump_tgts(const struct dfs_cache_entry *ce)
+static inline void dump_tgts(const struct cache_entry *ce)
 {
 	struct dfs_cache_tgt *t;
 
 	cifs_dbg(FYI, "target list:\n");
-	list_for_each_entry(t, &ce->ce_tlist, t_list) {
+	list_for_each_entry(t, &ce->tlist, t_list) {
 		cifs_dbg(FYI, "  %s%s\n", t->t_name,
-			 ce->ce_tgthint == t ? " (target hint)" : "");
+			 ce->tgthint == t ? " (target hint)" : "");
 	}
 }
 
-static inline void dump_ce(const struct dfs_cache_entry *ce)
+static inline void dump_ce(const struct cache_entry *ce)
 {
 	cifs_dbg(FYI, "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,"
-		 "interlink=%s,path_consumed=%d,expired=%s\n", ce->ce_path,
-		 ce->ce_srvtype == DFS_TYPE_ROOT ? "root" : "link", ce->ce_ttl,
-		 ce->ce_etime.tv_nsec,
-		 IS_INTERLINK_SET(ce->ce_flags) ? "yes" : "no",
-		 ce->ce_path_consumed,
+		 "interlink=%s,path_consumed=%d,expired=%s\n", ce->path,
+		 ce->srvtype == DFS_TYPE_ROOT ? "root" : "link", ce->ttl,
+		 ce->etime.tv_nsec,
+		 IS_INTERLINK_SET(ce->flags) ? "yes" : "no",
+		 ce->path_consumed,
 		 cache_entry_expired(ce) ? "yes" : "no");
 	dump_tgts(ce);
 }
@@ -285,24 +271,34 @@ static inline void dump_refs(const struct dfs_info3_param *refs, int numrefs)
 int dfs_cache_init(void)
 {
 	int i;
+	int rc;
 
-	dfs_cache_slab = kmem_cache_create("cifs_dfs_cache",
-					   sizeof(struct dfs_cache_entry), 0,
-					   SLAB_HWCACHE_ALIGN, NULL);
-	if (!dfs_cache_slab)
+	dfscache_wq = alloc_workqueue("cifs-dfscache",
+				      WQ_FREEZABLE | WQ_MEM_RECLAIM, 1);
+	if (!dfscache_wq)
 		return -ENOMEM;
 
-	for (i = 0; i < DFS_CACHE_HTABLE_SIZE; i++)
-		INIT_HLIST_HEAD(&dfs_cache_htable[i]);
+	cache_slab = kmem_cache_create("cifs_dfs_cache",
+				       sizeof(struct cache_entry), 0,
+				       SLAB_HWCACHE_ALIGN, NULL);
+	if (!cache_slab) {
+		rc = -ENOMEM;
+		goto out_destroy_wq;
+	}
+
+	for (i = 0; i < CACHE_HTABLE_SIZE; i++)
+		INIT_HLIST_HEAD(&cache_htable[i]);
 
-	INIT_LIST_HEAD(&dfs_cache.dc_vol_list);
-	mutex_init(&dfs_cache.dc_lock);
-	INIT_DELAYED_WORK(&dfs_cache.dc_refresh, refresh_cache_worker);
-	dfs_cache.dc_ttl = -1;
-	dfs_cache.dc_nlsc = load_nls_default();
+	atomic_set(&cache_ttl, -1);
+	atomic_set(&cache_count, 0);
+	cache_nlsc = load_nls_default();
 
 	cifs_dbg(FYI, "%s: initialized DFS referral cache\n", __func__);
 	return 0;
+
+out_destroy_wq:
+	destroy_workqueue(dfscache_wq);
+	return rc;
 }
 
 static inline unsigned int cache_entry_hash(const void *data, int size)
@@ -310,7 +306,7 @@ static inline unsigned int cache_entry_hash(const void *data, int size)
 	unsigned int h;
 
 	h = jhash(data, size, 0);
-	return h & (DFS_CACHE_HTABLE_SIZE - 1);
+	return h & (CACHE_HTABLE_SIZE - 1);
 }
 
 /* Check whether second path component of @path is SYSVOL or NETLOGON */
@@ -325,9 +321,9 @@ static inline bool is_sysvol_or_netlogon(const char *path)
 }
 
 /* Return target hint of a DFS cache entry */
-static inline char *get_tgt_name(const struct dfs_cache_entry *ce)
+static inline char *get_tgt_name(const struct cache_entry *ce)
 {
-	struct dfs_cache_tgt *t = ce->ce_tgthint;
+	struct dfs_cache_tgt *t = ce->tgthint;
 
 	return t ? t->t_name : ERR_PTR(-ENOENT);
 }
@@ -346,14 +342,14 @@ static inline struct timespec64 get_expire_time(int ttl)
 }
 
 /* Allocate a new DFS target */
-static inline struct dfs_cache_tgt *alloc_tgt(const char *name)
+static inline struct dfs_cache_tgt *alloc_target(const char *name)
 {
 	struct dfs_cache_tgt *t;
 
-	t = kmalloc(sizeof(*t), GFP_KERNEL);
+	t = kmalloc(sizeof(*t), GFP_ATOMIC);
 	if (!t)
 		return ERR_PTR(-ENOMEM);
-	t->t_name = kstrndup(name, strlen(name), GFP_KERNEL);
+	t->t_name = kstrndup(name, strlen(name), GFP_ATOMIC);
 	if (!t->t_name) {
 		kfree(t);
 		return ERR_PTR(-ENOMEM);
@@ -367,144 +363,126 @@ static inline struct dfs_cache_tgt *alloc_tgt(const char *name)
  * target hint.
  */
 static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
-			 struct dfs_cache_entry *ce, const char *tgthint)
+			 struct cache_entry *ce, const char *tgthint)
 {
 	int i;
 
-	ce->ce_ttl = refs[0].ttl;
-	ce->ce_etime = get_expire_time(ce->ce_ttl);
-	ce->ce_srvtype = refs[0].server_type;
-	ce->ce_flags = refs[0].ref_flag;
-	ce->ce_path_consumed = refs[0].path_consumed;
+	ce->ttl = refs[0].ttl;
+	ce->etime = get_expire_time(ce->ttl);
+	ce->srvtype = refs[0].server_type;
+	ce->flags = refs[0].ref_flag;
+	ce->path_consumed = refs[0].path_consumed;
 
 	for (i = 0; i < numrefs; i++) {
 		struct dfs_cache_tgt *t;
 
-		t = alloc_tgt(refs[i].node_name);
+		t = alloc_target(refs[i].node_name);
 		if (IS_ERR(t)) {
 			free_tgts(ce);
 			return PTR_ERR(t);
 		}
 		if (tgthint && !strcasecmp(t->t_name, tgthint)) {
-			list_add(&t->t_list, &ce->ce_tlist);
+			list_add(&t->t_list, &ce->tlist);
 			tgthint = NULL;
 		} else {
-			list_add_tail(&t->t_list, &ce->ce_tlist);
+			list_add_tail(&t->t_list, &ce->tlist);
 		}
-		ce->ce_numtgts++;
+		ce->numtgts++;
 	}
 
-	ce->ce_tgthint = list_first_entry_or_null(&ce->ce_tlist,
-						  struct dfs_cache_tgt, t_list);
+	ce->tgthint = list_first_entry_or_null(&ce->tlist,
+					       struct dfs_cache_tgt, t_list);
 
 	return 0;
 }
 
 /* Allocate a new cache entry */
-static struct dfs_cache_entry *
-alloc_cache_entry(const char *path, const struct dfs_info3_param *refs,
-		  int numrefs)
+static struct cache_entry *alloc_cache_entry(const char *path,
+					     struct dfs_info3_param *refs,
+					     int numrefs)
 {
-	struct dfs_cache_entry *ce;
+	struct cache_entry *ce;
 	int rc;
 
-	ce = kmem_cache_zalloc(dfs_cache_slab, GFP_KERNEL);
+	ce = kmem_cache_zalloc(cache_slab, GFP_KERNEL);
 	if (!ce)
 		return ERR_PTR(-ENOMEM);
 
-	ce->ce_path = kstrdup_const(path, GFP_KERNEL);
-	if (!ce->ce_path) {
-		kmem_cache_free(dfs_cache_slab, ce);
+	ce->path = kstrndup(path, strlen(path), GFP_KERNEL);
+	if (!ce->path) {
+		kmem_cache_free(cache_slab, ce);
 		return ERR_PTR(-ENOMEM);
 	}
-	INIT_HLIST_NODE(&ce->ce_hlist);
-	INIT_LIST_HEAD(&ce->ce_tlist);
+
+	INIT_HLIST_NODE(&ce->hlist);
+	INIT_LIST_HEAD(&ce->tlist);
 
 	rc = copy_ref_data(refs, numrefs, ce, NULL);
 	if (rc) {
-		kfree_const(ce->ce_path);
-		kmem_cache_free(dfs_cache_slab, ce);
+		kfree(ce->path);
+		kmem_cache_free(cache_slab, ce);
 		ce = ERR_PTR(rc);
 	}
+
 	return ce;
 }
 
 static void remove_oldest_entry(void)
 {
-	int bucket;
-	struct dfs_cache_entry *ce;
-	struct dfs_cache_entry *to_del = NULL;
-
-	rcu_read_lock();
-	hash_for_each_rcu(dfs_cache_htable, bucket, ce, ce_hlist) {
-		if (!to_del || timespec64_compare(&ce->ce_etime,
-						  &to_del->ce_etime) < 0)
-			to_del = ce;
+	int i;
+	struct cache_entry *ce;
+	struct cache_entry *to_del = NULL;
+
+	for (i = 0; i < CACHE_HTABLE_SIZE; i++) {
+		struct hlist_head *l = &cache_htable[i];
+
+		hlist_for_each_entry(ce, l, hlist) {
+			if (hlist_unhashed(&ce->hlist))
+				continue;
+			if (!to_del || timespec64_compare(&ce->etime,
+							  &to_del->etime) < 0)
+				to_del = ce;
+		}
 	}
+
 	if (!to_del) {
 		cifs_dbg(FYI, "%s: no entry to remove", __func__);
-		goto out;
+		return;
 	}
+
 	cifs_dbg(FYI, "%s: removing entry", __func__);
 	dump_ce(to_del);
 	flush_cache_ent(to_del);
-out:
-	rcu_read_unlock();
 }
 
 /* Add a new DFS cache entry */
-static inline struct dfs_cache_entry *
-add_cache_entry(unsigned int hash, const char *path,
-		const struct dfs_info3_param *refs, int numrefs)
+static int add_cache_entry(const char *path, unsigned int hash,
+			   struct dfs_info3_param *refs, int numrefs)
 {
-	struct dfs_cache_entry *ce;
+	struct cache_entry *ce;
+	int ttl;
 
 	ce = alloc_cache_entry(path, refs, numrefs);
 	if (IS_ERR(ce))
-		return ce;
+		return PTR_ERR(ce);
 
-	hlist_add_head_rcu(&ce->ce_hlist, &dfs_cache_htable[hash]);
-
-	mutex_lock(&dfs_cache.dc_lock);
-	if (dfs_cache.dc_ttl < 0) {
-		dfs_cache.dc_ttl = ce->ce_ttl;
-		queue_delayed_work(cifsiod_wq, &dfs_cache.dc_refresh,
-				   dfs_cache.dc_ttl * HZ);
+	ttl = atomic_read(&cache_ttl);
+	if (ttl < 0) {
+		ttl = ce->ttl;
+		queue_delayed_work(dfscache_wq, &refresh_task, ttl * HZ);
 	} else {
-		dfs_cache.dc_ttl = min_t(int, dfs_cache.dc_ttl, ce->ce_ttl);
-		mod_delayed_work(cifsiod_wq, &dfs_cache.dc_refresh,
-				 dfs_cache.dc_ttl * HZ);
+		ttl = min_t(int, ttl, ce->ttl);
+		mod_delayed_work(dfscache_wq, &refresh_task, ttl * HZ);
 	}
-	mutex_unlock(&dfs_cache.dc_lock);
 
-	return ce;
-}
+	atomic_set(&cache_ttl, ttl);
 
-static struct dfs_cache_entry *__find_cache_entry(unsigned int hash,
-						  const char *path)
-{
-	struct dfs_cache_entry *ce;
-	bool found = false;
-
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(ce, &dfs_cache_htable[hash], ce_hlist) {
-		if (!strcasecmp(path, ce->ce_path)) {
-#ifdef CONFIG_CIFS_DEBUG2
-			char *name = get_tgt_name(ce);
+	down_write(&list_sem);
+	hlist_add_head(&ce->hlist, &cache_htable[hash]);
+	dump_ce(ce);
+	up_write(&list_sem);
 
-			if (IS_ERR(name)) {
-				rcu_read_unlock();
-				return ERR_CAST(name);
-			}
-			cifs_dbg(FYI, "%s: cache hit\n", __func__);
-			cifs_dbg(FYI, "%s: target hint: %s\n", __func__, name);
-#endif
-			found = true;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	return found ? ce : ERR_PTR(-ENOENT);
+	return 0;
 }
 
 /*
@@ -513,33 +491,45 @@ static struct dfs_cache_entry *__find_cache_entry(unsigned int hash,
  * Use whole path components in the match.
  * Return ERR_PTR(-ENOENT) if the entry is not found.
  */
-static inline struct dfs_cache_entry *find_cache_entry(const char *path,
-						       unsigned int *hash)
+static struct cache_entry *lookup_cache_entry(const char *path,
+					      unsigned int *hash)
 {
-	*hash = cache_entry_hash(path, strlen(path));
-	return __find_cache_entry(*hash, path);
-}
+	struct cache_entry *ce;
+	unsigned int h;
+	bool found = false;
 
-static inline void destroy_slab_cache(void)
-{
-	rcu_barrier();
-	kmem_cache_destroy(dfs_cache_slab);
+	h = cache_entry_hash(path, strlen(path));
+
+	hlist_for_each_entry(ce, &cache_htable[h], hlist) {
+		if (!strcasecmp(path, ce->path)) {
+			found = true;
+			dump_ce(ce);
+			break;
+		}
+	}
+
+	if (!found)
+		ce = ERR_PTR(-ENOENT);
+	if (hash)
+		*hash = h;
+
+	return ce;
 }
 
-static inline void free_vol(struct dfs_cache_vol_info *vi)
+static inline void free_vol(struct vol_info *vi)
 {
-	list_del(&vi->vi_list);
-	kfree(vi->vi_fullpath);
-	kfree(vi->vi_mntdata);
-	cifs_cleanup_volume_info_contents(&vi->vi_vol);
+	list_del(&vi->list);
+	kfree(vi->fullpath);
+	kfree(vi->mntdata);
+	cifs_cleanup_volume_info_contents(&vi->smb_vol);
 	kfree(vi);
 }
 
 static inline void free_vol_list(void)
 {
-	struct dfs_cache_vol_info *vi, *nvi;
+	struct vol_info *vi, *nvi;
 
-	list_for_each_entry_safe(vi, nvi, &dfs_cache.dc_vol_list, vi_list)
+	list_for_each_entry_safe(vi, nvi, &vol_list, list)
 		free_vol(vi);
 }
 
@@ -548,83 +538,76 @@ static inline void free_vol_list(void)
  */
 void dfs_cache_destroy(void)
 {
-	cancel_delayed_work_sync(&dfs_cache.dc_refresh);
-	unload_nls(dfs_cache.dc_nlsc);
+	cancel_delayed_work_sync(&refresh_task);
+	unload_nls(cache_nlsc);
 	free_vol_list();
-	mutex_destroy(&dfs_cache.dc_lock);
-
 	flush_cache_ents();
-	destroy_slab_cache();
-	mutex_destroy(&dfs_cache_list_lock);
+	kmem_cache_destroy(cache_slab);
+	destroy_workqueue(dfscache_wq);
 
 	cifs_dbg(FYI, "%s: destroyed DFS referral cache\n", __func__);
 }
 
-static inline struct dfs_cache_entry *
-__update_cache_entry(const char *path, const struct dfs_info3_param *refs,
-		     int numrefs)
+static int __update_cache_entry(const char *path, struct dfs_info3_param *refs,
+				int numrefs)
 {
 	int rc;
-	unsigned int h;
-	struct dfs_cache_entry *ce;
+	struct cache_entry *ce;
 	char *s, *th = NULL;
 
-	ce = find_cache_entry(path, &h);
+	ce = lookup_cache_entry(path, NULL);
 	if (IS_ERR(ce))
-		return ce;
+		return PTR_ERR(ce);
 
-	if (ce->ce_tgthint) {
-		s = ce->ce_tgthint->t_name;
-		th = kstrndup(s, strlen(s), GFP_KERNEL);
+	if (ce->tgthint) {
+		s = ce->tgthint->t_name;
+		th = kstrndup(s, strlen(s), GFP_ATOMIC);
 		if (!th)
-			return ERR_PTR(-ENOMEM);
+			return -ENOMEM;
 	}
 
 	free_tgts(ce);
-	ce->ce_numtgts = 0;
+	ce->numtgts = 0;
 
 	rc = copy_ref_data(refs, numrefs, ce, th);
-	kfree(th);
 
-	if (rc)
-		ce = ERR_PTR(rc);
+	kfree(th);
 
-	return ce;
+	return 0;
 }
 
-/* Update an expired cache entry by getting a new DFS referral from server */
-static struct dfs_cache_entry *
-update_cache_entry(const unsigned int xid, struct cifs_ses *ses,
-		   const struct nls_table *nls_codepage, int remap,
-		   const char *path, struct dfs_cache_entry *ce)
+static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
+			    const struct nls_table *nls_codepage, int remap,
+			    const char *path,  struct dfs_info3_param **refs,
+			    int *numrefs)
 {
-	int rc;
-	struct dfs_info3_param *refs = NULL;
-	int numrefs = 0;
+	cifs_dbg(FYI, "%s: get an DFS referral for %s\n", __func__, path);
 
-	cifs_dbg(FYI, "%s: update expired cache entry\n", __func__);
-	/*
-	 * Check if caller provided enough parameters to update an expired
-	 * entry.
-	 */
 	if (!ses || !ses->server || !ses->server->ops->get_dfs_refer)
-		return ERR_PTR(-ETIME);
+		return -EOPNOTSUPP;
 	if (unlikely(!nls_codepage))
-		return ERR_PTR(-ETIME);
+		return -EINVAL;
 
-	cifs_dbg(FYI, "%s: DFS referral request for %s\n", __func__, path);
+	*refs = NULL;
+	*numrefs = 0;
 
-	rc = ses->server->ops->get_dfs_refer(xid, ses, path, &refs, &numrefs,
-					     nls_codepage, remap);
-	if (rc)
-		ce = ERR_PTR(rc);
-	else
-		ce = __update_cache_entry(path, refs, numrefs);
+	return ses->server->ops->get_dfs_refer(xid, ses, path, refs, numrefs,
+					       nls_codepage, remap);
+}
 
-	dump_refs(refs, numrefs);
-	free_dfs_info_array(refs, numrefs);
+/* Update an expired cache entry by getting a new DFS referral from server */
+static inline int update_cache_entry(const char *path,
+				     struct dfs_info3_param *refs,
+				     int numrefs)
+{
 
-	return ce;
+	int rc;
+
+	down_write(&list_sem);
+	rc = __update_cache_entry(path, refs, numrefs);
+	up_write(&list_sem);
+
+	return rc;
 }
 
 /*
@@ -636,95 +619,72 @@ update_cache_entry(const unsigned int xid, struct cifs_ses *ses,
  * For interlinks, __cifs_dfs_mount() and expand_dfs_referral() are supposed to
  * handle them properly.
  */
-static struct dfs_cache_entry *
-do_dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
-		  const struct nls_table *nls_codepage, int remap,
-		  const char *path, bool noreq)
+static int __dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
+			    const struct nls_table *nls_codepage, int remap,
+			    const char *path, bool noreq)
 {
 	int rc;
-	unsigned int h;
-	struct dfs_cache_entry *ce;
-	struct dfs_info3_param *nrefs;
-	int numnrefs;
+	unsigned int hash;
+	struct cache_entry *ce;
+	struct dfs_info3_param *refs = NULL;
+	int numrefs = 0;
+	bool newent = false;
 
 	cifs_dbg(FYI, "%s: search path: %s\n", __func__, path);
 
-	ce = find_cache_entry(path, &h);
-	if (IS_ERR(ce)) {
-		cifs_dbg(FYI, "%s: cache miss\n", __func__);
-		/*
-		 * If @noreq is set, no requests will be sent to the server for
-		 * either updating or getting a new DFS referral.
-		 */
-		if (noreq)
-			return ce;
-		/*
-		 * No cache entry was found, so check for valid parameters that
-		 * will be required to get a new DFS referral and then create a
-		 * new cache entry.
-		 */
-		if (!ses || !ses->server || !ses->server->ops->get_dfs_refer) {
-			ce = ERR_PTR(-EOPNOTSUPP);
-			return ce;
-		}
-		if (unlikely(!nls_codepage)) {
-			ce = ERR_PTR(-EINVAL);
-			return ce;
-		}
+	down_read(&list_sem);
 
-		nrefs = NULL;
-		numnrefs = 0;
+	ce = lookup_cache_entry(path, &hash);
 
-		cifs_dbg(FYI, "%s: DFS referral request for %s\n", __func__,
-			 path);
+	if (noreq) {
+		up_read(&list_sem);
+		return IS_ERR(ce) ? PTR_ERR(ce) : 0;
+	}
 
-		rc = ses->server->ops->get_dfs_refer(xid, ses, path, &nrefs,
-						     &numnrefs, nls_codepage,
-						     remap);
-		if (rc) {
-			ce = ERR_PTR(rc);
-			return ce;
+	if (!IS_ERR(ce)) {
+		if (!cache_entry_expired(ce)) {
+			dump_ce(ce);
+			up_read(&list_sem);
+			return 0;
 		}
+	} else {
+		newent = true;
+	}
 
-		dump_refs(nrefs, numnrefs);
+	up_read(&list_sem);
 
-		cifs_dbg(FYI, "%s: new cache entry\n", __func__);
+	rc = get_dfs_referral(xid, ses, nls_codepage, remap, path,
+			      &refs, &numrefs);
+	if (rc)
+		return rc;
 
-		if (dfs_cache_count >= DFS_CACHE_MAX_ENTRIES) {
-			cifs_dbg(FYI, "%s: reached max cache size (%d)",
-				 __func__, DFS_CACHE_MAX_ENTRIES);
-			remove_oldest_entry();
-		}
-		ce = add_cache_entry(h, path, nrefs, numnrefs);
-		free_dfs_info_array(nrefs, numnrefs);
+	dump_refs(refs, numrefs);
 
-		if (IS_ERR(ce))
-			return ce;
+	if (!newent) {
+		rc = update_cache_entry(path, refs, numrefs);
+		goto out_free_refs;
+	}
 
-		dfs_cache_count++;
+	if (atomic_read(&cache_count) >= CACHE_MAX_ENTRIES) {
+		cifs_dbg(FYI, "%s: reached max cache size (%d)", __func__,
+			 CACHE_MAX_ENTRIES);
+		down_write(&list_sem);
+		remove_oldest_entry();
+		up_write(&list_sem);
 	}
 
-	dump_ce(ce);
+	rc = add_cache_entry(path, hash, refs, numrefs);
+	if (!rc)
+		atomic_inc(&cache_count);
 
-	/* Just return the found cache entry in case @noreq is set */
-	if (noreq)
-		return ce;
-
-	if (cache_entry_expired(ce)) {
-		cifs_dbg(FYI, "%s: expired cache entry\n", __func__);
-		ce = update_cache_entry(xid, ses, nls_codepage, remap, path,
-					ce);
-		if (IS_ERR(ce)) {
-			cifs_dbg(FYI, "%s: failed to update expired entry\n",
-				 __func__);
-		}
-	}
-	return ce;
+out_free_refs:
+	free_dfs_info_array(refs, numrefs);
+	return rc;
 }
 
-/* Set up a new DFS referral from a given cache entry */
-static int setup_ref(const char *path, const struct dfs_cache_entry *ce,
-		     struct dfs_info3_param *ref, const char *tgt)
+/* Set up a DFS referral from a given cache entry */
+static int setup_referral(const char *path, struct cache_entry *ce,
+			  struct dfs_info3_param *ref, const char *target)
 {
 	int rc;
 
@@ -732,21 +692,20 @@ static int setup_ref(const char *path, const struct dfs_cache_entry *ce,
 
 	memset(ref, 0, sizeof(*ref));
 
-	ref->path_name = kstrndup(path, strlen(path), GFP_KERNEL);
+	ref->path_name = kstrndup(path, strlen(path), GFP_ATOMIC);
 	if (!ref->path_name)
 		return -ENOMEM;
 
-	ref->path_consumed = ce->ce_path_consumed;
-
-	ref->node_name = kstrndup(tgt, strlen(tgt), GFP_KERNEL);
+	ref->node_name = kstrndup(target, strlen(target), GFP_ATOMIC);
 	if (!ref->node_name) {
 		rc = -ENOMEM;
 		goto err_free_path;
 	}
 
-	ref->ttl = ce->ce_ttl;
-	ref->server_type = ce->ce_srvtype;
-	ref->ref_flag = ce->ce_flags;
+	ref->path_consumed = ce->path_consumed;
+	ref->ttl = ce->ttl;
+	ref->server_type = ce->srvtype;
+	ref->ref_flag = ce->flags;
 
 	return 0;
 
@@ -757,8 +716,7 @@ static int setup_ref(const char *path, const struct dfs_cache_entry *ce,
 }
 
 /* Return target list of a DFS cache entry */
-static int get_tgt_list(const struct dfs_cache_entry *ce,
-			struct dfs_cache_tgt_list *tl)
+static int get_targets(struct cache_entry *ce, struct dfs_cache_tgt_list *tl)
 {
 	int rc;
 	struct list_head *head = &tl->tl_list;
@@ -768,27 +726,28 @@ static int get_tgt_list(const struct dfs_cache_entry *ce,
 	memset(tl, 0, sizeof(*tl));
 	INIT_LIST_HEAD(head);
 
-	list_for_each_entry(t, &ce->ce_tlist, t_list) {
-		it = kzalloc(sizeof(*it), GFP_KERNEL);
+	list_for_each_entry(t, &ce->tlist, t_list) {
+		it = kzalloc(sizeof(*it), GFP_ATOMIC);
 		if (!it) {
 			rc = -ENOMEM;
 			goto err_free_it;
 		}
 
 		it->it_name = kstrndup(t->t_name, strlen(t->t_name),
-				       GFP_KERNEL);
+				       GFP_ATOMIC);
 		if (!it->it_name) {
 			kfree(it);
 			rc = -ENOMEM;
 			goto err_free_it;
 		}
 
-		if (ce->ce_tgthint == t)
+		if (ce->tgthint == t)
 			list_add(&it->it_list, head);
 		else
 			list_add_tail(&it->it_list, head);
 	}
-	tl->tl_numtgts = ce->ce_numtgts;
+
+	tl->tl_numtgts = ce->numtgts;
 
 	return 0;
 
@@ -829,28 +788,35 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
 {
 	int rc;
 	char *npath;
-	struct dfs_cache_entry *ce;
-
-	if (unlikely(!is_path_valid(path)))
-		return -EINVAL;
+	struct cache_entry *ce;
 
 	rc = get_normalized_path(path, &npath);
 	if (rc)
 		return rc;
 
-	mutex_lock(&dfs_cache_list_lock);
-	ce = do_dfs_cache_find(xid, ses, nls_codepage, remap, npath, false);
-	if (!IS_ERR(ce)) {
-		if (ref)
-			rc = setup_ref(path, ce, ref, get_tgt_name(ce));
-		else
-			rc = 0;
-		if (!rc && tgt_list)
-			rc = get_tgt_list(ce, tgt_list);
-	} else {
+	rc = __dfs_cache_find(xid, ses, nls_codepage, remap, npath, false);
+	if (rc)
+		goto out_free_path;
+
+	down_read(&list_sem);
+
+	ce = lookup_cache_entry(npath, NULL);
+	if (IS_ERR(ce)) {
+		up_read(&list_sem);
 		rc = PTR_ERR(ce);
+		goto out_free_path;
 	}
-	mutex_unlock(&dfs_cache_list_lock);
+
+	if (ref)
+		rc = setup_referral(path, ce, ref, get_tgt_name(ce));
+	else
+		rc = 0;
+	if (!rc && tgt_list)
+		rc = get_targets(ce, tgt_list);
+
+	up_read(&list_sem);
+
+out_free_path:
 	free_normalized_path(path, npath);
 	return rc;
 }
@@ -876,31 +842,33 @@ int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
 {
 	int rc;
 	char *npath;
-	struct dfs_cache_entry *ce;
-
-	if (unlikely(!is_path_valid(path)))
-		return -EINVAL;
+	struct cache_entry *ce;
 
 	rc = get_normalized_path(path, &npath);
 	if (rc)
 		return rc;
 
-	mutex_lock(&dfs_cache_list_lock);
-	ce = do_dfs_cache_find(0, NULL, NULL, 0, npath, true);
+	cifs_dbg(FYI, "%s: path: %s\n", __func__, npath);
+
+	down_read(&list_sem);
+
+	ce = lookup_cache_entry(npath, NULL);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
-		goto out;
+		goto out_unlock;
 	}
 
 	if (ref)
-		rc = setup_ref(path, ce, ref, get_tgt_name(ce));
+		rc = setup_referral(path, ce, ref, get_tgt_name(ce));
 	else
 		rc = 0;
 	if (!rc && tgt_list)
-		rc = get_tgt_list(ce, tgt_list);
-out:
-	mutex_unlock(&dfs_cache_list_lock);
+		rc = get_targets(ce, tgt_list);
+
+out_unlock:
+	up_read(&list_sem);
 	free_normalized_path(path, npath);
+
 	return rc;
 }
 
@@ -929,44 +897,46 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 {
 	int rc;
 	char *npath;
-	struct dfs_cache_entry *ce;
+	struct cache_entry *ce;
 	struct dfs_cache_tgt *t;
 
-	if (unlikely(!is_path_valid(path)))
-		return -EINVAL;
-
 	rc = get_normalized_path(path, &npath);
 	if (rc)
 		return rc;
 
-	cifs_dbg(FYI, "%s: path: %s\n", __func__, npath);
+	cifs_dbg(FYI, "%s: update target hint - path: %s\n", __func__, npath);
 
-	mutex_lock(&dfs_cache_list_lock);
-	ce = do_dfs_cache_find(xid, ses, nls_codepage, remap, npath, false);
+	rc = __dfs_cache_find(xid, ses, nls_codepage, remap, npath, false);
+	if (rc)
+		goto out_free_path;
+
+	down_write(&list_sem);
+
+	ce = lookup_cache_entry(npath, NULL);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
-		goto out;
+		goto out_unlock;
 	}
 
-	rc = 0;
-
-	t = ce->ce_tgthint;
+	t = ce->tgthint;
 
 	if (likely(!strcasecmp(it->it_name, t->t_name)))
-		goto out;
+		goto out_unlock;
 
-	list_for_each_entry(t, &ce->ce_tlist, t_list) {
+	list_for_each_entry(t, &ce->tlist, t_list) {
 		if (!strcasecmp(t->t_name, it->it_name)) {
-			ce->ce_tgthint = t;
+			ce->tgthint = t;
 			cifs_dbg(FYI, "%s: new target hint: %s\n", __func__,
 				 it->it_name);
 			break;
 		}
 	}
 
-out:
-	mutex_unlock(&dfs_cache_list_lock);
+out_unlock:
+	up_write(&list_sem);
+out_free_path:
 	free_normalized_path(path, npath);
+
 	return rc;
 }
 
@@ -989,10 +959,10 @@ int dfs_cache_noreq_update_tgthint(const char *path,
 {
 	int rc;
 	char *npath;
-	struct dfs_cache_entry *ce;
+	struct cache_entry *ce;
 	struct dfs_cache_tgt *t;
 
-	if (unlikely(!is_path_valid(path)) || !it)
+	if (!it)
 		return -EINVAL;
 
 	rc = get_normalized_path(path, &npath);
@@ -1001,33 +971,33 @@ int dfs_cache_noreq_update_tgthint(const char *path,
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, npath);
 
-	mutex_lock(&dfs_cache_list_lock);
+	down_write(&list_sem);
 
-	ce = do_dfs_cache_find(0, NULL, NULL, 0, npath, true);
+	ce = lookup_cache_entry(npath, NULL);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
-		goto out;
+		goto out_unlock;
 	}
 
 	rc = 0;
-
-	t = ce->ce_tgthint;
+	t = ce->tgthint;
 
 	if (unlikely(!strcasecmp(it->it_name, t->t_name)))
-		goto out;
+		goto out_unlock;
 
-	list_for_each_entry(t, &ce->ce_tlist, t_list) {
+	list_for_each_entry(t, &ce->tlist, t_list) {
 		if (!strcasecmp(t->t_name, it->it_name)) {
-			ce->ce_tgthint = t;
+			ce->tgthint = t;
 			cifs_dbg(FYI, "%s: new target hint: %s\n", __func__,
 				 it->it_name);
 			break;
 		}
 	}
 
-out:
-	mutex_unlock(&dfs_cache_list_lock);
+out_unlock:
+	up_write(&list_sem);
 	free_normalized_path(path, npath);
+
 	return rc;
 }
 
@@ -1047,13 +1017,10 @@ int dfs_cache_get_tgt_referral(const char *path,
 {
 	int rc;
 	char *npath;
-	struct dfs_cache_entry *ce;
-	unsigned int h;
+	struct cache_entry *ce;
 
 	if (!it || !ref)
 		return -EINVAL;
-	if (unlikely(!is_path_valid(path)))
-		return -EINVAL;
 
 	rc = get_normalized_path(path, &npath);
 	if (rc)
@@ -1061,21 +1028,22 @@ int dfs_cache_get_tgt_referral(const char *path,
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, npath);
 
-	mutex_lock(&dfs_cache_list_lock);
+	down_read(&list_sem);
 
-	ce = find_cache_entry(npath, &h);
+	ce = lookup_cache_entry(npath, NULL);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
-		goto out;
+		goto out_unlock;
 	}
 
 	cifs_dbg(FYI, "%s: target name: %s\n", __func__, it->it_name);
 
-	rc = setup_ref(path, ce, ref, it->it_name);
+	rc = setup_referral(path, ce, ref, it->it_name);
 
-out:
-	mutex_unlock(&dfs_cache_list_lock);
+out_unlock:
+	up_read(&list_sem);
 	free_normalized_path(path, npath);
+
 	return rc;
 }
 
@@ -1085,7 +1053,7 @@ static int dup_vol(struct smb_vol *vol, struct smb_vol *new)
 
 	if (vol->username) {
 		new->username = kstrndup(vol->username, strlen(vol->username),
-					GFP_KERNEL);
+					 GFP_KERNEL);
 		if (!new->username)
 			return -ENOMEM;
 	}
@@ -1103,7 +1071,7 @@ static int dup_vol(struct smb_vol *vol, struct smb_vol *new)
 	}
 	if (vol->domainname) {
 		new->domainname = kstrndup(vol->domainname,
-					  strlen(vol->domainname), GFP_KERNEL);
+					   strlen(vol->domainname), GFP_KERNEL);
 		if (!new->domainname)
 			goto err_free_unc;
 	}
@@ -1150,7 +1118,7 @@ static int dup_vol(struct smb_vol *vol, struct smb_vol *new)
 int dfs_cache_add_vol(char *mntdata, struct smb_vol *vol, const char *fullpath)
 {
 	int rc;
-	struct dfs_cache_vol_info *vi;
+	struct vol_info *vi;
 
 	if (!vol || !fullpath || !mntdata)
 		return -EINVAL;
@@ -1161,38 +1129,38 @@ int dfs_cache_add_vol(char *mntdata, struct smb_vol *vol, const char *fullpath)
 	if (!vi)
 		return -ENOMEM;
 
-	vi->vi_fullpath = kstrndup(fullpath, strlen(fullpath), GFP_KERNEL);
-	if (!vi->vi_fullpath) {
+	vi->fullpath = kstrndup(fullpath, strlen(fullpath), GFP_KERNEL);
+	if (!vi->fullpath) {
 		rc = -ENOMEM;
 		goto err_free_vi;
 	}
 
-	rc = dup_vol(vol, &vi->vi_vol);
+	rc = dup_vol(vol, &vi->smb_vol);
 	if (rc)
 		goto err_free_fullpath;
 
-	vi->vi_mntdata = mntdata;
+	vi->mntdata = mntdata;
+
+	spin_lock(&vol_lock);
+	list_add_tail(&vi->list, &vol_list);
+	spin_unlock(&vol_lock);
 
-	mutex_lock(&dfs_cache.dc_lock);
-	list_add_tail(&vi->vi_list, &dfs_cache.dc_vol_list);
-	mutex_unlock(&dfs_cache.dc_lock);
 	return 0;
 
 err_free_fullpath:
-	kfree(vi->vi_fullpath);
+	kfree(vi->fullpath);
 err_free_vi:
 	kfree(vi);
 	return rc;
 }
 
-static inline struct dfs_cache_vol_info *find_vol(const char *fullpath)
+static inline struct vol_info *find_vol(const char *fullpath)
 {
-	struct dfs_cache_vol_info *vi;
+	struct vol_info *vi;
 
-	list_for_each_entry(vi, &dfs_cache.dc_vol_list, vi_list) {
-		cifs_dbg(FYI, "%s: vi->vi_fullpath: %s\n", __func__,
-			 vi->vi_fullpath);
-		if (!strcasecmp(vi->vi_fullpath, fullpath))
+	list_for_each_entry(vi, &vol_list, list) {
+		cifs_dbg(FYI, "%s: vi->fullpath: %s\n", __func__, vi->fullpath);
+		if (!strcasecmp(vi->fullpath, fullpath))
 			return vi;
 	}
 	return ERR_PTR(-ENOENT);
@@ -1209,28 +1177,30 @@ static inline struct dfs_cache_vol_info *find_vol(const char *fullpath)
 int dfs_cache_update_vol(const char *fullpath, struct TCP_Server_Info *server)
 {
 	int rc;
-	struct dfs_cache_vol_info *vi;
+	struct vol_info *vi;
 
 	if (!fullpath || !server)
 		return -EINVAL;
 
 	cifs_dbg(FYI, "%s: fullpath: %s\n", __func__, fullpath);
 
-	mutex_lock(&dfs_cache.dc_lock);
+	spin_lock(&vol_lock);
 
 	vi = find_vol(fullpath);
 	if (IS_ERR(vi)) {
 		rc = PTR_ERR(vi);
-		goto out;
+		goto out_unlock;
 	}
 
 	cifs_dbg(FYI, "%s: updating volume info\n", __func__);
-	memcpy(&vi->vi_vol.dstaddr, &server->dstaddr,
-	       sizeof(vi->vi_vol.dstaddr));
+	memcpy(&vi->smb_vol.dstaddr, &server->dstaddr,
+	       sizeof(vi->smb_vol.dstaddr));
+
 	rc = 0;
 
-out:
-	mutex_unlock(&dfs_cache.dc_lock);
+out_unlock:
+	spin_unlock(&vol_lock);
+	cifs_dbg(FYI, "%s: successfully updated vol\n", __func__);
 	return rc;
 }
 
@@ -1241,18 +1211,20 @@ int dfs_cache_update_vol(const char *fullpath, struct TCP_Server_Info *server)
  */
 void dfs_cache_del_vol(const char *fullpath)
 {
-	struct dfs_cache_vol_info *vi;
+	struct vol_info *vi;
 
 	if (!fullpath || !*fullpath)
 		return;
 
 	cifs_dbg(FYI, "%s: fullpath: %s\n", __func__, fullpath);
 
-	mutex_lock(&dfs_cache.dc_lock);
+	spin_lock(&vol_lock);
+
 	vi = find_vol(fullpath);
 	if (!IS_ERR(vi))
 		free_vol(vi);
-	mutex_unlock(&dfs_cache.dc_lock);
+
+	spin_unlock(&vol_lock);
 }
 
 /* Get all tcons that are within a DFS namespace and can be refreshed */
@@ -1290,7 +1262,7 @@ static inline bool is_dfs_link(const char *path)
 	return !!strchr(s + 1, '\\');
 }
 
-static inline char *get_dfs_root(const char *path)
+static char *get_dfs_root(const char *path)
 {
 	char *s, *npath;
 
@@ -1309,12 +1281,37 @@ static inline char *get_dfs_root(const char *path)
 	return npath;
 }
 
+static inline void put_tcp_server(struct TCP_Server_Info *server)
+{
+	cifs_put_tcp_session(server, 0);
+}
+
+static struct TCP_Server_Info *get_tcp_server(struct smb_vol *vol)
+{
+	struct TCP_Server_Info *server;
+
+	server = cifs_find_tcp_session(vol);
+	if (IS_ERR_OR_NULL(server))
+		return NULL;
+
+	spin_lock(&GlobalMid_Lock);
+	if (server->tcpStatus != CifsGood) {
+		spin_unlock(&GlobalMid_Lock);
+		put_tcp_server(server);
+		return NULL;
+	}
+	spin_unlock(&GlobalMid_Lock);
+
+	return server;
+}
+
 /* Find root SMB session out of a DFS link path */
-static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
+static struct cifs_ses *find_root_ses(struct vol_info *vi,
 				      struct cifs_tcon *tcon, const char *path)
 {
 	char *rpath;
 	int rc;
+	struct cache_entry *ce;
 	struct dfs_info3_param ref = {0};
 	char *mdata = NULL, *devname = NULL;
 	struct TCP_Server_Info *server;
@@ -1325,15 +1322,25 @@ static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
 	if (IS_ERR(rpath))
 		return ERR_CAST(rpath);
 
-	memset(&vol, 0, sizeof(vol));
+	down_read(&list_sem);
 
-	rc = dfs_cache_noreq_find(rpath, &ref, NULL);
+	ce = lookup_cache_entry(rpath, NULL);
+	if (IS_ERR(ce)) {
+		up_read(&list_sem);
+		ses = ERR_CAST(ce);
+		goto out;
+	}
+
+	rc = setup_referral(path, ce, &ref, get_tgt_name(ce));
 	if (rc) {
+		up_read(&list_sem);
 		ses = ERR_PTR(rc);
 		goto out;
 	}
 
-	mdata = cifs_compose_mount_options(vi->vi_mntdata, rpath, &ref,
+	up_read(&list_sem);
+
+	mdata = cifs_compose_mount_options(vi->mntdata, rpath, &ref,
 					   &devname);
 	free_dfs_info_param(&ref);
 
@@ -1351,13 +1358,8 @@ static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
 		goto out;
 	}
 
-	server = cifs_find_tcp_session(&vol);
-	if (IS_ERR_OR_NULL(server)) {
-		ses = ERR_PTR(-EHOSTDOWN);
-		goto out;
-	}
-	if (server->tcpStatus != CifsGood) {
-		cifs_put_tcp_session(server, 0);
+	server = get_tcp_server(&vol);
+	if (!server) {
 		ses = ERR_PTR(-EHOSTDOWN);
 		goto out;
 	}
@@ -1373,17 +1375,15 @@ static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
 }
 
 /* Refresh DFS cache entry from a given tcon */
-static void do_refresh_tcon(struct dfs_cache *dc, struct dfs_cache_vol_info *vi,
-			    struct cifs_tcon *tcon)
+static int refresh_tcon(struct vol_info *vi, struct cifs_tcon *tcon)
 {
 	int rc = 0;
 	unsigned int xid;
 	char *path, *npath;
-	unsigned int h;
-	struct dfs_cache_entry *ce;
+	struct cache_entry *ce;
+	struct cifs_ses *root_ses = NULL, *ses;
 	struct dfs_info3_param *refs = NULL;
 	int numrefs = 0;
-	struct cifs_ses *root_ses = NULL, *ses;
 
 	xid = get_xid();
 
@@ -1391,19 +1391,23 @@ static void do_refresh_tcon(struct dfs_cache *dc, struct dfs_cache_vol_info *vi,
 
 	rc = get_normalized_path(path, &npath);
 	if (rc)
-		goto out;
+		goto out_free_xid;
 
-	mutex_lock(&dfs_cache_list_lock);
-	ce = find_cache_entry(npath, &h);
-	mutex_unlock(&dfs_cache_list_lock);
+	down_read(&list_sem);
 
+	ce = lookup_cache_entry(npath, NULL);
 	if (IS_ERR(ce)) {
 		rc = PTR_ERR(ce);
-		goto out;
+		up_read(&list_sem);
+		goto out_free_path;
 	}
 
-	if (!cache_entry_expired(ce))
-		goto out;
+	if (!cache_entry_expired(ce)) {
+		up_read(&list_sem);
+		goto out_free_path;
+	}
+
+	up_read(&list_sem);
 
 	/* If it's a DFS Link, then use root SMB session for refreshing it */
 	if (is_dfs_link(npath)) {
@@ -1411,35 +1415,29 @@ static void do_refresh_tcon(struct dfs_cache *dc, struct dfs_cache_vol_info *vi,
 		if (IS_ERR(ses)) {
 			rc = PTR_ERR(ses);
 			root_ses = NULL;
-			goto out;
+			goto out_free_path;
 		}
 	} else {
 		ses = tcon->ses;
 	}
 
-	if (unlikely(!ses->server->ops->get_dfs_refer)) {
-		rc = -EOPNOTSUPP;
-	} else {
-		rc = ses->server->ops->get_dfs_refer(xid, ses, path, &refs,
-						     &numrefs, dc->dc_nlsc,
-						     tcon->remap);
-		if (!rc) {
-			mutex_lock(&dfs_cache_list_lock);
-			ce = __update_cache_entry(npath, refs, numrefs);
-			mutex_unlock(&dfs_cache_list_lock);
-			dump_refs(refs, numrefs);
-			free_dfs_info_array(refs, numrefs);
-			if (IS_ERR(ce))
-				rc = PTR_ERR(ce);
-		}
+	rc = get_dfs_referral(xid, ses, cache_nlsc, tcon->remap, npath, &refs,
+			      &numrefs);
+	if (!rc) {
+		dump_refs(refs, numrefs);
+		rc = update_cache_entry(npath, refs, numrefs);
+		free_dfs_info_array(refs, numrefs);
 	}
 
-out:
 	if (root_ses)
 		cifs_put_smb_ses(root_ses);
 
-	free_xid(xid);
+out_free_path:
 	free_normalized_path(path, npath);
+
+out_free_xid:
+	free_xid(xid);
+	return rc;
 }
 
 /*
@@ -1448,30 +1446,37 @@ static void do_refresh_tcon(struct dfs_cache *dc, struct dfs_cache_vol_info *vi,
  */
 static void refresh_cache_worker(struct work_struct *work)
 {
-	struct dfs_cache *dc = container_of(work, struct dfs_cache,
-					    dc_refresh.work);
-	struct dfs_cache_vol_info *vi;
+	struct vol_info *vi;
 	struct TCP_Server_Info *server;
-	LIST_HEAD(list);
+	LIST_HEAD(tcons);
 	struct cifs_tcon *tcon, *ntcon;
+	int rc;
 
-	mutex_lock(&dc->dc_lock);
-
-	list_for_each_entry(vi, &dc->dc_vol_list, vi_list) {
-		server = cifs_find_tcp_session(&vi->vi_vol);
-		if (IS_ERR_OR_NULL(server))
+	spin_lock(&vol_lock);
+	list_for_each_entry(vi, &vol_list, list) {
+		server = get_tcp_server(&vi->smb_vol);
+		if (!server)
 			continue;
-		if (server->tcpStatus != CifsGood)
-			goto next;
-		get_tcons(server, &list);
-		list_for_each_entry_safe(tcon, ntcon, &list, ulist) {
-			do_refresh_tcon(dc, vi, tcon);
+
+		get_tcons(server, &tcons);
+		rc = 0;
+
+		list_for_each_entry_safe(tcon, ntcon, &tcons, ulist) {
+			/*
+			 * Skip tcp server if any of its tcons failed to refresh
+			 * (possibily due to reconnects).
+			 */
+			if (!rc)
+				rc = refresh_tcon(vi, tcon);
+
 			list_del_init(&tcon->ulist);
 			cifs_put_tcon(tcon);
 		}
-next:
-		cifs_put_tcp_session(server, 0);
+
+		put_tcp_server(server);
 	}
-	queue_delayed_work(cifsiod_wq, &dc->dc_refresh, dc->dc_ttl * HZ);
-	mutex_unlock(&dc->dc_lock);
+	spin_unlock(&vol_lock);
+
+	queue_delayed_work(dfscache_wq, &refresh_task,
+			   atomic_read(&cache_ttl) * HZ);
 }
-- 
2.24.0

