Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC627C7EE22
	for <linux-cifs@archiver.kernel.org>; Wed,  3 May 2023 22:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjECWV6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 May 2023 18:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjECWV6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 May 2023 18:21:58 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2727D8E
        for <linux-cifs@vger.kernel.org>; Wed,  3 May 2023 15:21:56 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cew9aSXO8xlKxZFIdAKFcmnCym/o3WCRV0czPEY5S+0=;
        b=UCPvDgMcZAodZBwz6nqxsO7RLRWaTbsfnYyFjSB4mLY0XQiuMaZ7+qHTAGpjETdydFaK+X
        Nk51Sv5LaufT+uJEG3TrM2dOqoQXFhHoQBoUS094K4YH8rK5pdj1WWUe91DqoAolHZs3zo
        d793E/TumXZxZ9Vm3S7KU698gLryxWtd0e8g1BsElPX3ljmviQNZqOOrwMrDKzpshJ3Rdv
        zsJARY8I55Ufyxx4eaxB7x4AvpbYjkOd5trjx/ODPP188IkIHpu/+KlOYYWIPZ3Jrw8/lJ
        TKwHWKDPaLD47HeeDTn1eFxvgjG/Ugmgk1PIsatMh+91u2YYV2jXaRxMgAnwZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cew9aSXO8xlKxZFIdAKFcmnCym/o3WCRV0czPEY5S+0=;
        b=NMuSQ51CNw9r0tqA3nGC3m7MWYHOOScGg9MFGlFTixkjuv6CkPvXRTOKJRkGtYJtzS1p0G
        r0IVroHMU75Fa0Nlqukfvo18aX/1qeF9Nl6B6DsGM4xo6eO11X0X1bsXD8L9MkFoKt/b/f
        8Nbu98JghdjVG+d6+uziDbNwYt3D9lUQuqZed/RgDHG96LP4uSaOz1r9FJrndByshEHR8U
        HFAAZi6MY7FfRI6ov4IuCVyL62x3BeLlAyB4KLXk+81dKMVm78wHWEDkcT9iLU+vqo53kE
        8GLK0yBo9nyTTx+SyRUaFwirmXTKlgZo+4+o/2k/cZQ6R/U1p0CKL14wXUJ54A==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1683152514; a=rsa-sha256;
        cv=none;
        b=OSb2aDgxOhd1PRR4qPQlxrCfZdMlBNoEQPulrJnUECo0Y3LqMDBXxpoNB/7A0e7aWAny7/
        1iHfP54k4iXjWBNEThawXnioDaA1CyCJ5le1RnWrqyiGl78BwdPRBu3l9Ce7XpOUqbwQ+A
        VwSQ20hBfEbWOoxuz4SAQUq6TBx+e5odE6IOcXaLxjgGvZdM8+7L6Rzb/dU1ZB/QdSzcTn
        BVnoIU2lUbS55+LciZyu5KJPL4MlPmVtuMafSomC1JEx0WzsWbC5Q8+RAi7qCFZafbZ+AU
        MENXwytbd8NcMcvPOuA1PMt6j+2q4Q3qDB5wCL36Br7/Kuhmkyk35YahZTrzcg==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>,
        stable@vger.kernel.org
Subject: [PATCH 6/7] cifs: avoid potential races when handling multiple dfs tcons
Date:   Wed,  3 May 2023 19:21:16 -0300
Message-Id: <20230503222117.7609-7-pc@manguebit.com>
In-Reply-To: <20230503222117.7609-1-pc@manguebit.com>
References: <20230503222117.7609-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Now that a DFS tcon manages its own list of DFS referrals and
sessions, there is no point in having a single worker to refresh
referrals of all DFS tcons.  Make it faster and less prone to race
conditions when having several mounts by queueing a worker per DFS
tcon that will take care of refreshing only the DFS referrals related
to it.

Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifsglob.h  |   2 +-
 fs/cifs/connect.c   |   7 ++-
 fs/cifs/dfs.c       |   4 ++
 fs/cifs/dfs_cache.c | 141 +++++++++++++++++++-------------------------
 fs/cifs/dfs_cache.h |   9 +++
 5 files changed, 82 insertions(+), 81 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a62447404851..9c5cd332ce14 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1238,8 +1238,8 @@ struct cifs_tcon {
 	struct cached_fids *cfids;
 	/* BB add field for back pointer to sb struct(s)? */
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	struct list_head ulist; /* cache update list */
 	struct list_head dfs_ses_list;
+	struct delayed_work dfs_cache_work;
 #endif
 	struct delayed_work	query_interfaces; /* query interfaces workqueue job */
 };
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 340bd7cf64f3..71966db89b6a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2336,6 +2336,9 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 
 	/* cancel polling of interfaces */
 	cancel_delayed_work_sync(&tcon->query_interfaces);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	cancel_delayed_work_sync(&tcon->dfs_cache_work);
+#endif
 
 	if (tcon->use_witness) {
 		int rc;
@@ -2583,7 +2586,9 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
 				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 	}
-
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	INIT_DELAYED_WORK(&tcon->dfs_cache_work, dfs_cache_refresh);
+#endif
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcon->tcon_list, &ses->tcon_list);
 	spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index c4ec5c67087b..da4e083b1ab4 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -157,6 +157,8 @@ static int get_dfs_conn(struct cifs_mount_ctx *mnt_ctx, const char *ref_path, co
 		rc = cifs_is_path_remote(mnt_ctx);
 	}
 
+	dfs_cache_noreq_update_tgthint(ref_path + 1, tit);
+
 	if (rc == -EREMOTE && is_refsrv) {
 		rc2 = get_root_smb_session(mnt_ctx);
 		if (rc2)
@@ -259,6 +261,8 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 		if (list_empty(&tcon->dfs_ses_list)) {
 			list_replace_init(&mnt_ctx->dfs_ses_list,
 					  &tcon->dfs_ses_list);
+			queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
+					   dfs_cache_get_ttl() * HZ);
 		} else {
 			dfs_put_root_smb_sessions(&mnt_ctx->dfs_ses_list);
 		}
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 6557d7b2798a..1513b2709889 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -20,12 +20,14 @@
 #include "cifs_unicode.h"
 #include "smb2glob.h"
 #include "dns_resolve.h"
+#include "dfs.h"
 
 #include "dfs_cache.h"
 
-#define CACHE_HTABLE_SIZE 32
-#define CACHE_MAX_ENTRIES 64
-#define CACHE_MIN_TTL 120 /* 2 minutes */
+#define CACHE_HTABLE_SIZE	32
+#define CACHE_MAX_ENTRIES	64
+#define CACHE_MIN_TTL		120 /* 2 minutes */
+#define CACHE_DEFAULT_TTL	300 /* 5 minutes */
 
 #define IS_DFS_INTERLINK(v) (((v) & DFSREF_REFERRAL_SERVER) && !((v) & DFSREF_STORAGE_SERVER))
 
@@ -50,10 +52,9 @@ struct cache_entry {
 };
 
 static struct kmem_cache *cache_slab __read_mostly;
-static struct workqueue_struct *dfscache_wq __read_mostly;
+struct workqueue_struct *dfscache_wq;
 
-static int cache_ttl;
-static DEFINE_SPINLOCK(cache_ttl_lock);
+atomic_t dfs_cache_ttl;
 
 static struct nls_table *cache_cp;
 
@@ -65,10 +66,6 @@ static atomic_t cache_count;
 static struct hlist_head cache_htable[CACHE_HTABLE_SIZE];
 static DECLARE_RWSEM(htable_rw_lock);
 
-static void refresh_cache_worker(struct work_struct *work);
-
-static DECLARE_DELAYED_WORK(refresh_task, refresh_cache_worker);
-
 /**
  * dfs_cache_canonical_path - get a canonical DFS path
  *
@@ -290,7 +287,9 @@ int dfs_cache_init(void)
 	int rc;
 	int i;
 
-	dfscache_wq = alloc_workqueue("cifs-dfscache", WQ_FREEZABLE | WQ_UNBOUND, 1);
+	dfscache_wq = alloc_workqueue("cifs-dfscache",
+				      WQ_UNBOUND|WQ_FREEZABLE|WQ_MEM_RECLAIM,
+				      0);
 	if (!dfscache_wq)
 		return -ENOMEM;
 
@@ -306,6 +305,7 @@ int dfs_cache_init(void)
 		INIT_HLIST_HEAD(&cache_htable[i]);
 
 	atomic_set(&cache_count, 0);
+	atomic_set(&dfs_cache_ttl, CACHE_DEFAULT_TTL);
 	cache_cp = load_nls("utf8");
 	if (!cache_cp)
 		cache_cp = load_nls_default();
@@ -480,6 +480,7 @@ static struct cache_entry *add_cache_entry_locked(struct dfs_info3_param *refs,
 	int rc;
 	struct cache_entry *ce;
 	unsigned int hash;
+	int ttl;
 
 	WARN_ON(!rwsem_is_locked(&htable_rw_lock));
 
@@ -496,15 +497,8 @@ static struct cache_entry *add_cache_entry_locked(struct dfs_info3_param *refs,
 	if (IS_ERR(ce))
 		return ce;
 
-	spin_lock(&cache_ttl_lock);
-	if (!cache_ttl) {
-		cache_ttl = ce->ttl;
-		queue_delayed_work(dfscache_wq, &refresh_task, cache_ttl * HZ);
-	} else {
-		cache_ttl = min_t(int, cache_ttl, ce->ttl);
-		mod_delayed_work(dfscache_wq, &refresh_task, cache_ttl * HZ);
-	}
-	spin_unlock(&cache_ttl_lock);
+	ttl = min_t(int, atomic_read(&dfs_cache_ttl), ce->ttl);
+	atomic_set(&dfs_cache_ttl, ttl);
 
 	hlist_add_head(&ce->hlist, &cache_htable[hash]);
 	dump_ce(ce);
@@ -616,7 +610,6 @@ static struct cache_entry *lookup_cache_entry(const char *path)
  */
 void dfs_cache_destroy(void)
 {
-	cancel_delayed_work_sync(&refresh_task);
 	unload_nls(cache_cp);
 	flush_cache_ents();
 	kmem_cache_destroy(cache_slab);
@@ -1142,6 +1135,7 @@ static bool target_share_equal(struct TCP_Server_Info *server, const char *s1, c
  * target shares in @refs.
  */
 static void mark_for_reconnect_if_needed(struct TCP_Server_Info *server,
+					 const char *path,
 					 struct dfs_cache_tgt_list *old_tl,
 					 struct dfs_cache_tgt_list *new_tl)
 {
@@ -1153,8 +1147,10 @@ static void mark_for_reconnect_if_needed(struct TCP_Server_Info *server,
 		     nit = dfs_cache_get_next_tgt(new_tl, nit)) {
 			if (target_share_equal(server,
 					       dfs_cache_get_tgt_name(oit),
-					       dfs_cache_get_tgt_name(nit)))
+					       dfs_cache_get_tgt_name(nit))) {
+				dfs_cache_noreq_update_tgthint(path, nit);
 				return;
+			}
 		}
 	}
 
@@ -1162,13 +1158,28 @@ static void mark_for_reconnect_if_needed(struct TCP_Server_Info *server,
 	cifs_signal_cifsd_for_reconnect(server, true);
 }
 
+static bool is_ses_good(struct cifs_ses *ses)
+{
+	struct TCP_Server_Info *server = ses->server;
+	struct cifs_tcon *tcon = ses->tcon_ipc;
+	bool ret;
+
+	spin_lock(&ses->ses_lock);
+	spin_lock(&ses->chan_lock);
+	ret = !cifs_chan_needs_reconnect(ses, server) &&
+		ses->ses_status == SES_GOOD &&
+		!tcon->need_reconnect;
+	spin_unlock(&ses->chan_lock);
+	spin_unlock(&ses->ses_lock);
+	return ret;
+}
+
 /* Refresh dfs referral of tcon and mark it for reconnect if needed */
-static int __refresh_tcon(const char *path, struct cifs_tcon *tcon, bool force_refresh)
+static int __refresh_tcon(const char *path, struct cifs_ses *ses, bool force_refresh)
 {
 	struct dfs_cache_tgt_list old_tl = DFS_CACHE_TGT_LIST_INIT(old_tl);
 	struct dfs_cache_tgt_list new_tl = DFS_CACHE_TGT_LIST_INIT(new_tl);
-	struct cifs_ses *ses = CIFS_DFS_ROOT_SES(tcon->ses);
-	struct cifs_tcon *ipc = ses->tcon_ipc;
+	struct TCP_Server_Info *server = ses->server;
 	bool needs_refresh = false;
 	struct cache_entry *ce;
 	unsigned int xid;
@@ -1190,20 +1201,19 @@ static int __refresh_tcon(const char *path, struct cifs_tcon *tcon, bool force_r
 		goto out;
 	}
 
-	spin_lock(&ipc->tc_lock);
-	if (ipc->status != TID_GOOD) {
-		spin_unlock(&ipc->tc_lock);
-		cifs_dbg(FYI, "%s: skip cache refresh due to disconnected ipc\n", __func__);
+	ses = CIFS_DFS_ROOT_SES(ses);
+	if (!is_ses_good(ses)) {
+		cifs_dbg(FYI, "%s: skip cache refresh due to disconnected ipc\n",
+			 __func__);
 		goto out;
 	}
-	spin_unlock(&ipc->tc_lock);
 
 	ce = cache_refresh_path(xid, ses, path, true);
 	if (!IS_ERR(ce)) {
 		rc = get_targets(ce, &new_tl);
 		up_read(&htable_rw_lock);
 		cifs_dbg(FYI, "%s: get_targets: %d\n", __func__, rc);
-		mark_for_reconnect_if_needed(tcon->ses->server, &old_tl, &new_tl);
+		mark_for_reconnect_if_needed(server, path, &old_tl, &new_tl);
 	}
 
 out:
@@ -1216,10 +1226,11 @@ static int __refresh_tcon(const char *path, struct cifs_tcon *tcon, bool force_r
 static int refresh_tcon(struct cifs_tcon *tcon, bool force_refresh)
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_ses *ses = tcon->ses;
 
 	mutex_lock(&server->refpath_lock);
 	if (server->leaf_fullpath)
-		__refresh_tcon(server->leaf_fullpath + 1, tcon, force_refresh);
+		__refresh_tcon(server->leaf_fullpath + 1, ses, force_refresh);
 	mutex_unlock(&server->refpath_lock);
 	return 0;
 }
@@ -1263,60 +1274,32 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	return refresh_tcon(tcon, true);
 }
 
-/*
- * Worker that will refresh DFS cache from all active mounts based on lowest TTL value
- * from a DFS referral.
- */
-static void refresh_cache_worker(struct work_struct *work)
+/* Refresh all DFS referrals related to DFS tcon */
+void dfs_cache_refresh(struct work_struct *work)
 {
 	struct TCP_Server_Info *server;
-	struct cifs_tcon *tcon, *ntcon;
-	struct list_head tcons;
+	struct dfs_root_ses *rses;
+	struct cifs_tcon *tcon;
 	struct cifs_ses *ses;
 
-	INIT_LIST_HEAD(&tcons);
-
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		spin_lock(&server->srv_lock);
-		if (!server->leaf_fullpath) {
-			spin_unlock(&server->srv_lock);
-			continue;
-		}
-		spin_unlock(&server->srv_lock);
-
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-			if (ses->tcon_ipc) {
-				ses->ses_count++;
-				list_add_tail(&ses->tcon_ipc->ulist, &tcons);
-			}
-			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
-				if (!tcon->ipc) {
-					tcon->tc_count++;
-					list_add_tail(&tcon->ulist, &tcons);
-				}
-			}
-		}
-	}
-	spin_unlock(&cifs_tcp_ses_lock);
-
-	list_for_each_entry_safe(tcon, ntcon, &tcons, ulist) {
-		struct TCP_Server_Info *server = tcon->ses->server;
-
-		list_del_init(&tcon->ulist);
-
+	tcon = container_of(work, struct cifs_tcon, dfs_cache_work.work);
+	ses = tcon->ses;
+	server = ses->server;
+
+	mutex_lock(&server->refpath_lock);
+	if (server->leaf_fullpath)
+		__refresh_tcon(server->leaf_fullpath + 1, ses, false);
+	mutex_unlock(&server->refpath_lock);
+
+	list_for_each_entry(rses, &tcon->dfs_ses_list, list) {
+		ses = rses->ses;
+		server = ses->server;
 		mutex_lock(&server->refpath_lock);
 		if (server->leaf_fullpath)
-			__refresh_tcon(server->leaf_fullpath + 1, tcon, false);
+			__refresh_tcon(server->leaf_fullpath + 1, ses, false);
 		mutex_unlock(&server->refpath_lock);
-
-		if (tcon->ipc)
-			cifs_put_smb_ses(tcon->ses);
-		else
-			cifs_put_tcon(tcon);
 	}
 
-	spin_lock(&cache_ttl_lock);
-	queue_delayed_work(dfscache_wq, &refresh_task, cache_ttl * HZ);
-	spin_unlock(&cache_ttl_lock);
+	queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
+			   atomic_read(&dfs_cache_ttl) * HZ);
 }
diff --git a/fs/cifs/dfs_cache.h b/fs/cifs/dfs_cache.h
index e0d39393035a..c6d89cd6d4fd 100644
--- a/fs/cifs/dfs_cache.h
+++ b/fs/cifs/dfs_cache.h
@@ -13,6 +13,9 @@
 #include <linux/uuid.h>
 #include "cifsglob.h"
 
+extern struct workqueue_struct *dfscache_wq;
+extern atomic_t dfs_cache_ttl;
+
 #define DFS_CACHE_TGT_LIST_INIT(var) { .tl_numtgts = 0, .tl_list = LIST_HEAD_INIT((var).tl_list), }
 
 struct dfs_cache_tgt_list {
@@ -42,6 +45,7 @@ int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
 			    char **prefix);
 char *dfs_cache_canonical_path(const char *path, const struct nls_table *cp, int remap);
 int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb);
+void dfs_cache_refresh(struct work_struct *work);
 
 static inline struct dfs_cache_tgt_iterator *
 dfs_cache_get_next_tgt(struct dfs_cache_tgt_list *tl,
@@ -89,4 +93,9 @@ dfs_cache_get_nr_tgts(const struct dfs_cache_tgt_list *tl)
 	return tl ? tl->tl_numtgts : 0;
 }
 
+static inline int dfs_cache_get_ttl(void)
+{
+	return atomic_read(&dfs_cache_ttl);
+}
+
 #endif /* _CIFS_DFS_CACHE_H */
-- 
2.40.1

