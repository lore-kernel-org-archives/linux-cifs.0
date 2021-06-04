Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036E4C4743C
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFEEE613AD
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhFDW1s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 18:27:48 -0400
Received: from mx.cjr.nz ([51.158.111.142]:9476 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231534AbhFDW1s (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 4 Jun 2021 18:27:48 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 21B1380BAC;
        Fri,  4 Jun 2021 22:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1622845560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OUT8gneovZKcRnd7yKP9j2OI1g8s8dcLKyaXI1BILug=;
        b=QpwuzEAv+xMtWctTFt5738pAvdzgLYKUccw2nzmjgRNxsrQkuG9Ns1qNojfFXYky8Swas2
        Shlt1kxdx55bOwAAEz+Og9oh4zArgbpSrnghL9qdvLB5sIebSW9ilBiWeHy6gYJ6488fOk
        yJ+glR72rwKP2E+4aavlRwHOpE31MFwGAfkkH+7tdvC0GAIsNAXR+X8UvHSqZLuU09v9H4
        CAjSo8qoQggNX8ogXtpnlXssdEz7+XzXHX3RQlAK3mawb9USmzi/uMbMkLPhh+eFE3TtFF
        pq2c8QOtpUvMorZlxa9omQv7NV2s39DKug1SKfgrRTRf1WOhJKMs0ON5mMuu/w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 3/7] cifs: keep referral server sessions alive
Date:   Fri,  4 Jun 2021 19:25:29 -0300
Message-Id: <20210604222533.4760-4-pc@cjr.nz>
In-Reply-To: <20210604222533.4760-1-pc@cjr.nz>
References: <20210604222533.4760-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

At every mount, keep all sessions alive that were used for chasing the
DFS referrals as long as the dfs mounts are active.

Use those sessions in DFS cache to refresh all active tcons as well as
cached entries.  They will be managed by a list of mount_group
structures that will be indexed by a randomly generated uuid at mount
time, so we can put all the sessions related to specific dfs mounts
and avoid leaking them.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifs_fs_sb.h |   2 +
 fs/cifs/connect.c    |  54 ++--
 fs/cifs/dfs_cache.c  | 697 ++++++++++++++++---------------------------
 fs/cifs/dfs_cache.h  |   8 +-
 4 files changed, 285 insertions(+), 476 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 9c45b3a82ad9..2dfd10c34ace 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -77,6 +77,8 @@ struct cifs_sb_info {
 	 * failover properly.
 	 */
 	char *origin_fullpath; /* \\HOST\SHARE\[OPTIONAL PATH] */
+	/* randomly generated 128-bit number for indexing dfs mount groups in referral cache */
+	uuid_t dfs_mount_id;
 	/*
 	 * Indicate whether serverino option was turned off later
 	 * (cifs_autodisable_serverino) in order to match new mounts.
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5ac1bd17463d..4997ded82e93 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -368,13 +368,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 			cifs_server_dbg(VFS, "%s: failed to update DFS target hint: rc = %d\n",
 				 __func__, rc);
 		}
-		rc = dfs_cache_update_vol(cifs_sb->origin_fullpath, server);
-		if (rc) {
-			cifs_server_dbg(VFS, "%s: failed to update vol info in DFS cache: rc = %d\n",
-				 __func__, rc);
-		}
 		dfs_cache_free_tgts(&tgt_list);
-
 	}
 
 	cifs_put_tcp_super(sb);
@@ -1595,7 +1589,6 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 {
 	unsigned int rc, xid;
 	struct TCP_Server_Info *server = ses->server;
-
 	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
 
 	spin_lock(&cifs_tcp_ses_lock);
@@ -1603,6 +1596,10 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	}
+
+	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
+	cifs_dbg(FYI, "%s: ses ipc: %s\n", __func__, ses->tcon_ipc ? ses->tcon_ipc->treeName : "NONE");
+
 	if (--ses->ses_count > 0) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
@@ -3278,25 +3275,23 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
-static void set_root_ses(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
+static void set_root_ses(struct cifs_sb_info *cifs_sb, const uuid_t *mount_id, struct cifs_ses *ses,
 			 struct cifs_ses **root_ses)
 {
 	if (ses) {
 		spin_lock(&cifs_tcp_ses_lock);
 		ses->ses_count++;
-		if (ses->tcon_ipc)
+		cifs_dbg(FYI, "%s: new ses_count=%d\n", __func__, ses->ses_count);
+		if (ses->tcon_ipc) {
+			cifs_dbg(FYI, "%s: ipc tcon: %s\n", __func__, ses->tcon_ipc->treeName);
 			ses->tcon_ipc->remap = cifs_remap(cifs_sb);
+		}
 		spin_unlock(&cifs_tcp_ses_lock);
+		dfs_cache_add_refsrv_session(mount_id, ses);
 	}
 	*root_ses = ses;
 }
 
-static void put_root_ses(struct cifs_ses *ses)
-{
-	if (ses)
-		cifs_put_smb_ses(ses);
-}
-
 /* Set up next dfs prefix path in @dfs_path */
 static int next_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
 			    const unsigned int xid, struct TCP_Server_Info *server,
@@ -3376,6 +3371,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	struct cifs_ses *ses = NULL, *root_ses = NULL;
 	struct cifs_tcon *tcon = NULL;
 	int count = 0;
+	uuid_t mount_id = {0};
 	char *ref_path = NULL, *full_path = NULL;
 	char *oldmnt = NULL;
 	char *mntdata = NULL;
@@ -3401,12 +3397,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 		if (rc != -EREMOTE)
 			goto error;
 	}
-	/* Save mount options */
-	mntdata = kstrdup(cifs_sb->ctx->mount_options, GFP_KERNEL);
-	if (!mntdata) {
-		rc = -ENOMEM;
-		goto error;
-	}
+
 	/* Get path of DFS root */
 	ref_path = build_unc_path_to_root(ctx, cifs_sb, false);
 	if (IS_ERR(ref_path)) {
@@ -3415,7 +3406,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 		goto error;
 	}
 
-	set_root_ses(cifs_sb, ses, &root_ses);
+	uuid_gen(&mount_id);
+	set_root_ses(cifs_sb, &mount_id, ses, &root_ses);
 	do {
 		/* Save full path of last DFS path we used to resolve final target server */
 		kfree(full_path);
@@ -3449,10 +3441,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 		rc = is_referral_server(ref_path + 1, tcon, &ref_server);
 		if (rc)
 			break;
-		if (ref_server) {
-			put_root_ses(root_ses);
-			set_root_ses(cifs_sb, ses, &root_ses);
-		}
+		if (ref_server)
+			set_root_ses(cifs_sb, &mount_id, ses, &root_ses);
 
 		/* Get next dfs path and then continue chasing them if -EREMOTE */
 		rc = next_dfs_prepath(cifs_sb, ctx, xid, server, tcon, &ref_path);
@@ -3463,8 +3453,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 
 	if (rc)
 		goto error;
-	put_root_ses(root_ses);
-	root_ses = NULL;
+
 	kfree(ref_path);
 	ref_path = NULL;
 	/*
@@ -3486,10 +3475,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	tcon->remap = cifs_remap(cifs_sb);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	/* Add original context for DFS cache to be used when refreshing referrals */
-	rc = dfs_cache_add_vol(mntdata, ctx, cifs_sb->origin_fullpath);
-	if (rc)
-		goto error;
 	/*
 	 * After reconnecting to a different server, unique ids won't
 	 * match anymore, so we disable serverino. This prevents
@@ -3504,6 +3489,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	kfree(cifs_sb->prepath);
 	cifs_sb->prepath = ctx->prepath;
 	ctx->prepath = NULL;
+	uuid_copy(&cifs_sb->dfs_mount_id, &mount_id);
 
 out:
 	free_xid(xid);
@@ -3515,7 +3501,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	kfree(full_path);
 	kfree(mntdata);
 	kfree(cifs_sb->origin_fullpath);
-	put_root_ses(root_ses);
+	dfs_cache_put_refsrv_sessions(&mount_id);
 	mount_put_conns(cifs_sb, xid, server, ses, tcon);
 	return rc;
 }
@@ -3745,7 +3731,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 
 	kfree(cifs_sb->prepath);
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	dfs_cache_del_vol(cifs_sb->origin_fullpath);
+	dfs_cache_put_refsrv_sessions(&cifs_sb->dfs_mount_id);
 	kfree(cifs_sb->origin_fullpath);
 #endif
 	call_rcu(&cifs_sb->rcu, delayed_free);
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index e5ea87869f36..cecb83b831d9 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -11,6 +11,7 @@
 #include <linux/proc_fs.h>
 #include <linux/nls.h>
 #include <linux/workqueue.h>
+#include <linux/uuid.h>
 #include "cifsglob.h"
 #include "smb2pdu.h"
 #include "smb2proto.h"
@@ -18,7 +19,6 @@
 #include "cifs_debug.h"
 #include "cifs_unicode.h"
 #include "smb2glob.h"
-#include "fs_context.h"
 
 #include "dfs_cache.h"
 
@@ -48,14 +48,15 @@ struct cache_entry {
 	struct cache_dfs_tgt *tgthint;
 };
 
-struct vol_info {
-	char *fullpath;
-	spinlock_t ctx_lock;
-	struct smb3_fs_context ctx;
-	char *mntdata;
+/* List of referral server sessions per dfs mount */
+struct mount_group {
 	struct list_head list;
-	struct list_head rlist;
-	struct kref refcnt;
+	uuid_t id;
+	struct cifs_ses *sessions[CACHE_MAX_ENTRIES];
+	int num_sessions;
+	spinlock_t lock;
+	struct list_head refresh_list;
+	struct kref refcount;
 };
 
 static struct kmem_cache *cache_slab __read_mostly;
@@ -74,13 +75,106 @@ static atomic_t cache_count;
 static struct hlist_head cache_htable[CACHE_HTABLE_SIZE];
 static DECLARE_RWSEM(htable_rw_lock);
 
-static LIST_HEAD(vol_list);
-static DEFINE_SPINLOCK(vol_list_lock);
+static LIST_HEAD(mount_group_list);
+static DEFINE_MUTEX(mount_group_list_lock);
 
 static void refresh_cache_worker(struct work_struct *work);
 
 static DECLARE_DELAYED_WORK(refresh_task, refresh_cache_worker);
 
+static void get_ipc_unc(const char *ref_path, char *ipc, size_t ipclen)
+{
+	const char *host;
+	size_t len;
+
+	extract_unc_hostname(ref_path, &host, &len);
+	scnprintf(ipc, ipclen, "\\\\%.*s\\IPC$", (int)len, host);
+}
+
+static struct cifs_ses *find_ipc_from_server_path(struct cifs_ses **ses, const char *path)
+{
+	char unc[SERVER_NAME_LENGTH + sizeof("//x/IPC$")] = {0};
+
+	get_ipc_unc(path, unc, sizeof(unc));
+	for (; *ses; ses++) {
+		if (!strcasecmp(unc, (*ses)->tcon_ipc->treeName))
+			return *ses;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
+static void __mount_group_release(struct mount_group *mg)
+{
+	int i;
+
+	for (i = 0; i < mg->num_sessions; i++)
+		cifs_put_smb_ses(mg->sessions[i]);
+	kfree(mg);
+}
+
+static void mount_group_release(struct kref *kref)
+{
+	struct mount_group *mg = container_of(kref, struct mount_group, refcount);
+
+	mutex_lock(&mount_group_list_lock);
+	list_del(&mg->list);
+	mutex_unlock(&mount_group_list_lock);
+	__mount_group_release(mg);
+}
+
+static struct mount_group *find_mount_group_locked(const uuid_t *id)
+{
+	struct mount_group *mg;
+
+	list_for_each_entry(mg, &mount_group_list, list) {
+		if (uuid_equal(&mg->id, id))
+			return mg;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
+static struct mount_group *__get_mount_group_locked(const uuid_t *id)
+{
+	struct mount_group *mg;
+
+	mg = find_mount_group_locked(id);
+	if (!IS_ERR(mg))
+		return mg;
+
+	mg = kmalloc(sizeof(*mg), GFP_KERNEL);
+	if (!mg)
+		return ERR_PTR(-ENOMEM);
+	kref_init(&mg->refcount);
+	uuid_copy(&mg->id, id);
+	mg->num_sessions = 0;
+	spin_lock_init(&mg->lock);
+	list_add(&mg->list, &mount_group_list);
+	return mg;
+}
+
+static struct mount_group *get_mount_group(const uuid_t *id)
+{
+	struct mount_group *mg;
+
+	mutex_lock(&mount_group_list_lock);
+	mg = __get_mount_group_locked(id);
+	if (!IS_ERR(mg))
+		kref_get(&mg->refcount);
+	mutex_unlock(&mount_group_list_lock);
+
+	return mg;
+}
+
+static void free_mount_group_list(void)
+{
+	struct mount_group *mg, *tmp_mg;
+
+	list_for_each_entry_safe(mg, tmp_mg, &mount_group_list, list) {
+		list_del_init(&mg->list);
+		__mount_group_release(mg);
+	}
+}
+
 static int get_normalized_path(const char *path, const char **npath)
 {
 	if (!path || strlen(path) < 3 || (*path != '\\' && *path != '/'))
@@ -284,8 +378,7 @@ int dfs_cache_init(void)
 	int rc;
 	int i;
 
-	dfscache_wq = alloc_workqueue("cifs-dfscache",
-				      WQ_FREEZABLE | WQ_MEM_RECLAIM, 1);
+	dfscache_wq = alloc_workqueue("cifs-dfscache", WQ_FREEZABLE | WQ_UNBOUND, 1);
 	if (!dfscache_wq)
 		return -ENOMEM;
 
@@ -437,8 +530,7 @@ static struct cache_entry *alloc_cache_entry(const char *path,
 	return ce;
 }
 
-/* Must be called with htable_rw_lock held */
-static void remove_oldest_entry(void)
+static void remove_oldest_entry_locked(void)
 {
 	int i;
 	struct cache_entry *ce;
@@ -467,8 +559,8 @@ static void remove_oldest_entry(void)
 }
 
 /* Add a new DFS cache entry */
-static int add_cache_entry(const char *path, unsigned int hash,
-			   struct dfs_info3_param *refs, int numrefs)
+static int add_cache_entry_locked(const char *path, unsigned int hash,
+				  struct dfs_info3_param *refs, int numrefs)
 {
 	struct cache_entry *ce;
 
@@ -486,10 +578,8 @@ static int add_cache_entry(const char *path, unsigned int hash,
 	}
 	spin_unlock(&cache_ttl_lock);
 
-	down_write(&htable_rw_lock);
 	hlist_add_head(&ce->hlist, &cache_htable[hash]);
 	dump_ce(ce);
-	up_write(&htable_rw_lock);
 
 	return 0;
 }
@@ -584,34 +674,6 @@ static struct cache_entry *lookup_cache_entry(const char *path, unsigned int *ha
 	return ce;
 }
 
-static void __vol_release(struct vol_info *vi)
-{
-	kfree(vi->fullpath);
-	kfree(vi->mntdata);
-	smb3_cleanup_fs_context_contents(&vi->ctx);
-	kfree(vi);
-}
-
-static void vol_release(struct kref *kref)
-{
-	struct vol_info *vi = container_of(kref, struct vol_info, refcnt);
-
-	spin_lock(&vol_list_lock);
-	list_del(&vi->list);
-	spin_unlock(&vol_list_lock);
-	__vol_release(vi);
-}
-
-static inline void free_vol_list(void)
-{
-	struct vol_info *vi, *nvi;
-
-	list_for_each_entry_safe(vi, nvi, &vol_list, list) {
-		list_del_init(&vi->list);
-		__vol_release(vi);
-	}
-}
-
 /**
  * dfs_cache_destroy - destroy DFS referral cache
  */
@@ -619,7 +681,7 @@ void dfs_cache_destroy(void)
 {
 	cancel_delayed_work_sync(&refresh_task);
 	unload_nls(cache_nlsc);
-	free_vol_list();
+	free_mount_group_list();
 	flush_cache_ents();
 	kmem_cache_destroy(cache_slab);
 	destroy_workqueue(dfscache_wq);
@@ -627,10 +689,9 @@ void dfs_cache_destroy(void)
 	cifs_dbg(FYI, "%s: destroyed DFS referral cache\n", __func__);
 }
 
-/* Must be called with htable_rw_lock held */
-static int __update_cache_entry(const char *path,
-				const struct dfs_info3_param *refs,
-				int numrefs)
+/* Update a cache entry with the new referral in @refs */
+static int update_cache_entry_locked(const char *path, const struct dfs_info3_param *refs,
+				     int numrefs)
 {
 	int rc;
 	struct cache_entry *ce;
@@ -676,32 +737,17 @@ static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 					       nls_codepage, remap);
 }
 
-/* Update an expired cache entry by getting a new DFS referral from server */
-static int update_cache_entry(const char *path,
-			      const struct dfs_info3_param *refs,
-			      int numrefs)
-{
-
-	int rc;
-
-	down_write(&htable_rw_lock);
-	rc = __update_cache_entry(path, refs, numrefs);
-	up_write(&htable_rw_lock);
-
-	return rc;
-}
-
 /*
  * Find, create or update a DFS cache entry.
  *
  * If the entry wasn't found, it will create a new one. Or if it was found but
  * expired, then it will update the entry accordingly.
  *
- * For interlinks, __cifs_dfs_mount() and expand_dfs_referral() are supposed to
+ * For interlinks, cifs_mount() and expand_dfs_referral() are supposed to
  * handle them properly.
  */
-static int __dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
-			    const struct nls_table *nls_codepage, int remap, const char *path)
+static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses,
+			      const struct nls_table *nls_codepage, int remap, const char *path)
 {
 	int rc;
 	unsigned int hash;
@@ -712,52 +758,46 @@ static int __dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
 
 	cifs_dbg(FYI, "%s: search path: %s\n", __func__, path);
 
-	down_read(&htable_rw_lock);
+	down_write(&htable_rw_lock);
 
 	ce = lookup_cache_entry(path, &hash);
 	if (!IS_ERR(ce)) {
 		if (!cache_entry_expired(ce)) {
 			dump_ce(ce);
-			up_read(&htable_rw_lock);
+			up_write(&htable_rw_lock);
 			return 0;
 		}
 	} else {
 		newent = true;
 	}
 
-	up_read(&htable_rw_lock);
-
 	/*
-	 * No entry was found.
-	 *
-	 * Request a new DFS referral in order to create a new cache entry, or
-	 * updating an existing one.
+	 * Either the entry was not found, or it is expired.
+	 * Request a new DFS referral in order to create or update a cache entry.
 	 */
 	rc = get_dfs_referral(xid, ses, nls_codepage, remap, path,
 			      &refs, &numrefs);
 	if (rc)
-		return rc;
+		goto out_unlock;
 
 	dump_refs(refs, numrefs);
 
 	if (!newent) {
-		rc = update_cache_entry(path, refs, numrefs);
-		goto out_free_refs;
+		rc = update_cache_entry_locked(path, refs, numrefs);
+		goto out_unlock;
 	}
 
 	if (atomic_read(&cache_count) >= CACHE_MAX_ENTRIES) {
-		cifs_dbg(FYI, "%s: reached max cache size (%d)\n",
-			 __func__, CACHE_MAX_ENTRIES);
-		down_write(&htable_rw_lock);
-		remove_oldest_entry();
-		up_write(&htable_rw_lock);
+		cifs_dbg(FYI, "%s: reached max cache size (%d)\n", __func__, CACHE_MAX_ENTRIES);
+		remove_oldest_entry_locked();
 	}
 
-	rc = add_cache_entry(path, hash, refs, numrefs);
+	rc = add_cache_entry_locked(path, hash, refs, numrefs);
 	if (!rc)
 		atomic_inc(&cache_count);
 
-out_free_refs:
+out_unlock:
+	up_write(&htable_rw_lock);
 	free_dfs_info_array(refs, numrefs);
 	return rc;
 }
@@ -879,7 +919,7 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
 	if (rc)
 		return rc;
 
-	rc = __dfs_cache_find(xid, ses, nls_codepage, remap, npath);
+	rc = cache_refresh_path(xid, ses, nls_codepage, remap, npath);
 	if (rc)
 		goto out_free_path;
 
@@ -991,7 +1031,7 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 
 	cifs_dbg(FYI, "%s: update target hint - path: %s\n", __func__, npath);
 
-	rc = __dfs_cache_find(xid, ses, nls_codepage, remap, npath);
+	rc = cache_refresh_path(xid, ses, nls_codepage, remap, npath);
 	if (rc)
 		goto out_free_path;
 
@@ -1133,126 +1173,51 @@ int dfs_cache_get_tgt_referral(const char *path,
 }
 
 /**
- * dfs_cache_add_vol - add a cifs context during mount() that will be handled by
- * DFS cache refresh worker.
+ * dfs_cache_add_refsrv_session - add SMB session of referral server
  *
- * @mntdata: mount data.
- * @ctx: cifs context.
- * @fullpath: origin full path.
- *
- * Return zero if context was set up correctly, otherwise non-zero.
+ * @mount_id: mount group uuid to lookup.
+ * @ses: reference counted SMB session of referral server.
  */
-int dfs_cache_add_vol(char *mntdata, struct smb3_fs_context *ctx, const char *fullpath)
+void dfs_cache_add_refsrv_session(const uuid_t *mount_id, struct cifs_ses *ses)
 {
-	int rc;
-	struct vol_info *vi;
-
-	if (!ctx || !fullpath || !mntdata)
-		return -EINVAL;
-
-	cifs_dbg(FYI, "%s: fullpath: %s\n", __func__, fullpath);
-
-	vi = kzalloc(sizeof(*vi), GFP_KERNEL);
-	if (!vi)
-		return -ENOMEM;
-
-	vi->fullpath = kstrdup(fullpath, GFP_KERNEL);
-	if (!vi->fullpath) {
-		rc = -ENOMEM;
-		goto err_free_vi;
-	}
-
-	rc = smb3_fs_context_dup(&vi->ctx, ctx);
-	if (rc)
-		goto err_free_fullpath;
-
-	vi->mntdata = mntdata;
-	spin_lock_init(&vi->ctx_lock);
-	kref_init(&vi->refcnt);
+	struct mount_group *mg;
 
-	spin_lock(&vol_list_lock);
-	list_add_tail(&vi->list, &vol_list);
-	spin_unlock(&vol_list_lock);
-
-	return 0;
-
-err_free_fullpath:
-	kfree(vi->fullpath);
-err_free_vi:
-	kfree(vi);
-	return rc;
-}
+	if (WARN_ON_ONCE(!mount_id || uuid_is_null(mount_id) || !ses))
+		return;
 
-/* Must be called with vol_list_lock held */
-static struct vol_info *find_vol(const char *fullpath)
-{
-	struct vol_info *vi;
+	mg = get_mount_group(mount_id);
+	if (WARN_ON_ONCE(IS_ERR(mg)))
+		return;
 
-	list_for_each_entry(vi, &vol_list, list) {
-		cifs_dbg(FYI, "%s: vi->fullpath: %s\n", __func__, vi->fullpath);
-		if (!strcasecmp(vi->fullpath, fullpath))
-			return vi;
-	}
-	return ERR_PTR(-ENOENT);
+	spin_lock(&mg->lock);
+	if (mg->num_sessions < ARRAY_SIZE(mg->sessions))
+		mg->sessions[mg->num_sessions++] = ses;
+	spin_unlock(&mg->lock);
+	kref_put(&mg->refcount, mount_group_release);
 }
 
 /**
- * dfs_cache_update_vol - update vol info in DFS cache after failover
- *
- * @fullpath: fullpath to look up in volume list.
- * @server: TCP ses pointer.
+ * dfs_cache_put_refsrv_sessions - put all referral server sessions
  *
- * Return zero if volume was updated, otherwise non-zero.
- */
-int dfs_cache_update_vol(const char *fullpath, struct TCP_Server_Info *server)
-{
-	struct vol_info *vi;
-
-	if (!fullpath || !server)
-		return -EINVAL;
-
-	cifs_dbg(FYI, "%s: fullpath: %s\n", __func__, fullpath);
-
-	spin_lock(&vol_list_lock);
-	vi = find_vol(fullpath);
-	if (IS_ERR(vi)) {
-		spin_unlock(&vol_list_lock);
-		return PTR_ERR(vi);
-	}
-	kref_get(&vi->refcnt);
-	spin_unlock(&vol_list_lock);
-
-	cifs_dbg(FYI, "%s: updating volume info\n", __func__);
-	spin_lock(&vi->ctx_lock);
-	memcpy(&vi->ctx.dstaddr, &server->dstaddr,
-	       sizeof(vi->ctx.dstaddr));
-	spin_unlock(&vi->ctx_lock);
-
-	kref_put(&vi->refcnt, vol_release);
-
-	return 0;
-}
-
-/**
- * dfs_cache_del_vol - remove volume info in DFS cache during umount()
+ * Put all SMB sessions from the given mount group id.
  *
- * @fullpath: fullpath to look up in volume list.
+ * @mount_id: mount group uuid to lookup.
  */
-void dfs_cache_del_vol(const char *fullpath)
+void dfs_cache_put_refsrv_sessions(const uuid_t *mount_id)
 {
-	struct vol_info *vi;
+	struct mount_group *mg;
 
-	if (!fullpath || !*fullpath)
+	if (!mount_id || uuid_is_null(mount_id))
 		return;
 
-	cifs_dbg(FYI, "%s: fullpath: %s\n", __func__, fullpath);
-
-	spin_lock(&vol_list_lock);
-	vi = find_vol(fullpath);
-	spin_unlock(&vol_list_lock);
-
-	if (!IS_ERR(vi))
-		kref_put(&vi->refcnt, vol_release);
+	mutex_lock(&mount_group_list_lock);
+	mg = find_mount_group_locked(mount_id);
+	if (IS_ERR(mg)) {
+		mutex_unlock(&mount_group_list_lock);
+		return;
+	}
+	mutex_unlock(&mount_group_list_lock);
+	kref_put(&mg->refcount, mount_group_release);
 }
 
 /**
@@ -1321,278 +1286,136 @@ int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
 	return 0;
 }
 
-/* Get all tcons that are within a DFS namespace and can be refreshed */
-static void get_tcons(struct TCP_Server_Info *server, struct list_head *head)
+/*
+ * Refresh all active dfs mounts regardless of whether they are in cache or not.
+ * (cache can be cleared)
+ */
+static void refresh_mounts(struct cifs_ses **sessions)
 {
+	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
-	struct cifs_tcon *tcon;
+	struct cifs_tcon *tcon, *ntcon;
+	struct list_head tcons;
+	unsigned int xid;
 
-	INIT_LIST_HEAD(head);
+	INIT_LIST_HEAD(&tcons);
 
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
-			if (!tcon->need_reconnect && !tcon->need_reopen_files &&
-			    tcon->dfs_path) {
-				tcon->tc_count++;
-				list_add_tail(&tcon->ulist, head);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+				if (tcon->dfs_path) {
+					tcon->tc_count++;
+					list_add_tail(&tcon->ulist, &tcons);
+				}
 			}
 		}
-		if (ses->tcon_ipc && !ses->tcon_ipc->need_reconnect &&
-		    ses->tcon_ipc->dfs_path) {
-			list_add_tail(&ses->tcon_ipc->ulist, head);
-		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-}
 
-static bool is_dfs_link(const char *path)
-{
-	char *s;
-
-	s = strchr(path + 1, '\\');
-	if (!s)
-		return false;
-	return !!strchr(s + 1, '\\');
-}
-
-static char *get_dfs_root(const char *path)
-{
-	char *s, *npath;
-
-	s = strchr(path + 1, '\\');
-	if (!s)
-		return ERR_PTR(-EINVAL);
-
-	s = strchr(s + 1, '\\');
-	if (!s)
-		return ERR_PTR(-EINVAL);
-
-	npath = kstrndup(path, s - path, GFP_KERNEL);
-	if (!npath)
-		return ERR_PTR(-ENOMEM);
-
-	return npath;
-}
-
-static inline void put_tcp_server(struct TCP_Server_Info *server)
-{
-	cifs_put_tcp_session(server, 0);
-}
-
-static struct TCP_Server_Info *get_tcp_server(struct smb3_fs_context *ctx)
-{
-	struct TCP_Server_Info *server;
-
-	server = cifs_find_tcp_session(ctx);
-	if (IS_ERR_OR_NULL(server))
-		return NULL;
-
-	spin_lock(&GlobalMid_Lock);
-	if (server->tcpStatus != CifsGood) {
-		spin_unlock(&GlobalMid_Lock);
-		put_tcp_server(server);
-		return NULL;
+	list_for_each_entry_safe(tcon, ntcon, &tcons, ulist) {
+		const char *path = tcon->dfs_path + 1;
+		int rc = 0;
+
+		list_del_init(&tcon->ulist);
+		ses = find_ipc_from_server_path(sessions, path);
+		if (!IS_ERR(ses)) {
+			xid = get_xid();
+			cache_refresh_path(xid, ses, cache_nlsc, tcon->remap, path);
+			free_xid(xid);
+		}
+		cifs_put_tcon(tcon);
 	}
-	spin_unlock(&GlobalMid_Lock);
-
-	return server;
 }
 
-/* Find root SMB session out of a DFS link path */
-static struct cifs_ses *find_root_ses(struct vol_info *vi,
-				      struct cifs_tcon *tcon,
-				      const char *path)
+static void refresh_cache(struct cifs_ses **sessions)
 {
-	char *rpath;
-	int rc;
-	struct cache_entry *ce;
-	struct dfs_info3_param ref = {0};
-	char *mdata = NULL, *devname = NULL;
-	struct TCP_Server_Info *server;
+	int i;
 	struct cifs_ses *ses;
-	struct smb3_fs_context ctx = {NULL};
-
-	rpath = get_dfs_root(path);
-	if (IS_ERR(rpath))
-		return ERR_CAST(rpath);
-
-	down_read(&htable_rw_lock);
-
-	ce = lookup_cache_entry(rpath, NULL);
-	if (IS_ERR(ce)) {
-		up_read(&htable_rw_lock);
-		ses = ERR_CAST(ce);
-		goto out;
-	}
-
-	rc = setup_referral(path, ce, &ref, get_tgt_name(ce));
-	if (rc) {
-		up_read(&htable_rw_lock);
-		ses = ERR_PTR(rc);
-		goto out;
-	}
-
-	up_read(&htable_rw_lock);
-
-	mdata = cifs_compose_mount_options(vi->mntdata, rpath, &ref,
-					   &devname);
-	free_dfs_info_param(&ref);
-
-	if (IS_ERR(mdata)) {
-		ses = ERR_CAST(mdata);
-		mdata = NULL;
-		goto out;
-	}
-
-	rc = cifs_setup_volume_info(&ctx, NULL, devname);
-
-	if (rc) {
-		ses = ERR_PTR(rc);
-		goto out;
-	}
-
-	server = get_tcp_server(&ctx);
-	if (!server) {
-		ses = ERR_PTR(-EHOSTDOWN);
-		goto out;
-	}
-
-	ses = cifs_get_smb_ses(server, &ctx);
-
-out:
-	smb3_cleanup_fs_context_contents(&ctx);
-	kfree(mdata);
-	kfree(rpath);
-	kfree(devname);
-
-	return ses;
-}
-
-/* Refresh DFS cache entry from a given tcon */
-static int refresh_tcon(struct vol_info *vi, struct cifs_tcon *tcon)
-{
-	int rc = 0;
 	unsigned int xid;
-	const char *path, *npath;
-	struct cache_entry *ce;
-	struct cifs_ses *root_ses = NULL, *ses;
-	struct dfs_info3_param *refs = NULL;
-	int numrefs = 0;
-
-	xid = get_xid();
-
-	path = tcon->dfs_path + 1;
-
-	rc = get_normalized_path(path, &npath);
-	if (rc)
-		goto out_free_xid;
-
-	down_read(&htable_rw_lock);
-
-	ce = lookup_cache_entry(npath, NULL);
-	if (IS_ERR(ce)) {
-		rc = PTR_ERR(ce);
-		up_read(&htable_rw_lock);
-		goto out_free_path;
-	}
-
-	if (!cache_entry_expired(ce)) {
-		up_read(&htable_rw_lock);
-		goto out_free_path;
-	}
-
-	up_read(&htable_rw_lock);
-
-	/* If it's a DFS Link, then use root SMB session for refreshing it */
-	if (is_dfs_link(npath)) {
-		ses = root_ses = find_root_ses(vi, tcon, npath);
-		if (IS_ERR(ses)) {
-			rc = PTR_ERR(ses);
-			root_ses = NULL;
-			goto out_free_path;
+	int rc;
+
+	/*
+	 * Refresh all cached entries.
+	 * The cache entries may cover more paths than the active mounts
+	 * (e.g. domain-based DFS referrals or multi tier DFS setups).
+	 */
+	down_write(&htable_rw_lock);
+	for (i = 0; i < CACHE_HTABLE_SIZE; i++) {
+		struct cache_entry *ce;
+		struct hlist_head *l = &cache_htable[i];
+
+		hlist_for_each_entry(ce, l, hlist) {
+			struct dfs_info3_param *refs = NULL;
+			int numrefs = 0;
+
+			if (hlist_unhashed(&ce->hlist) || !cache_entry_expired(ce))
+				continue;
+
+			ses = find_ipc_from_server_path(sessions, ce->path);
+			if (IS_ERR(ses))
+				continue;
+
+			xid = get_xid();
+			rc = get_dfs_referral(xid, ses, cache_nlsc, NO_MAP_UNI_RSVD, ce->path,
+					      &refs, &numrefs);
+			free_xid(xid);
+
+			if (!rc)
+				update_cache_entry_locked(ce->path, refs, numrefs);
+
+			free_dfs_info_array(refs, numrefs);
 		}
-	} else {
-		ses = tcon->ses;
 	}
-
-	rc = get_dfs_referral(xid, ses, cache_nlsc, tcon->remap, npath, &refs,
-			      &numrefs);
-	if (!rc) {
-		dump_refs(refs, numrefs);
-		rc = update_cache_entry(npath, refs, numrefs);
-		free_dfs_info_array(refs, numrefs);
-	}
-
-	if (root_ses)
-		cifs_put_smb_ses(root_ses);
-
-out_free_path:
-	free_normalized_path(path, npath);
-
-out_free_xid:
-	free_xid(xid);
-	return rc;
+	up_write(&htable_rw_lock);
 }
 
 /*
- * Worker that will refresh DFS cache based on lowest TTL value from a DFS
+ * Worker that will refresh DFS cache and active mounts based on lowest TTL value from a DFS
  * referral.
  */
 static void refresh_cache_worker(struct work_struct *work)
 {
-	struct vol_info *vi, *nvi;
-	struct TCP_Server_Info *server;
-	LIST_HEAD(vols);
-	LIST_HEAD(tcons);
-	struct cifs_tcon *tcon, *ntcon;
-	int rc;
-
-	/*
-	 * Find SMB volumes that are eligible (server->tcpStatus == CifsGood)
-	 * for refreshing.
-	 */
-	spin_lock(&vol_list_lock);
-	list_for_each_entry(vi, &vol_list, list) {
-		server = get_tcp_server(&vi->ctx);
-		if (!server)
-			continue;
-
-		kref_get(&vi->refcnt);
-		list_add_tail(&vi->rlist, &vols);
-		put_tcp_server(server);
+	struct list_head mglist;
+	struct mount_group *mg, *tmp_mg;
+	struct cifs_ses *sessions[CACHE_MAX_ENTRIES + 1] = {NULL};
+	int max_sessions = ARRAY_SIZE(sessions) - 1;
+	int i = 0, count;
+
+	INIT_LIST_HEAD(&mglist);
+
+	/* Get refereces of mount groups */
+	mutex_lock(&mount_group_list_lock);
+	list_for_each_entry(mg, &mount_group_list, list) {
+		kref_get(&mg->refcount);
+		list_add(&mg->refresh_list, &mglist);
+	}
+	mutex_unlock(&mount_group_list_lock);
+
+	/* Fill in local array with an NULL-terminated list of all referral server sessions */
+	list_for_each_entry(mg, &mglist, refresh_list) {
+		if (i >= max_sessions)
+			break;
+
+		spin_lock(&mg->lock);
+		if (i + mg->num_sessions > max_sessions)
+			count = max_sessions - i;
+		else
+			count = mg->num_sessions;
+		memcpy(&sessions[i], mg->sessions, count * sizeof(mg->sessions[0]));
+		spin_unlock(&mg->lock);
+		i += count;
 	}
-	spin_unlock(&vol_list_lock);
-
-	/* Walk through all TCONs and refresh any expired cache entry */
-	list_for_each_entry_safe(vi, nvi, &vols, rlist) {
-		spin_lock(&vi->ctx_lock);
-		server = get_tcp_server(&vi->ctx);
-		spin_unlock(&vi->ctx_lock);
-
-		if (!server)
-			goto next_vol;
-
-		get_tcons(server, &tcons);
-		rc = 0;
-
-		list_for_each_entry_safe(tcon, ntcon, &tcons, ulist) {
-			/*
-			 * Skip tcp server if any of its tcons failed to refresh
-			 * (possibily due to reconnects).
-			 */
-			if (!rc)
-				rc = refresh_tcon(vi, tcon);
-
-			list_del_init(&tcon->ulist);
-			cifs_put_tcon(tcon);
-		}
 
-		put_tcp_server(server);
+	if (sessions[0]) {
+		/* Refresh all active mounts and cached entries */
+		refresh_mounts(sessions);
+		refresh_cache(sessions);
+	}
 
-next_vol:
-		list_del_init(&vi->rlist);
-		kref_put(&vi->refcnt, vol_release);
+	list_for_each_entry_safe(mg, tmp_mg, &mglist, refresh_list) {
+		list_del_init(&mg->refresh_list);
+		kref_put(&mg->refcount, mount_group_release);
 	}
 
 	spin_lock(&cache_ttl_lock);
diff --git a/fs/cifs/dfs_cache.h b/fs/cifs/dfs_cache.h
index 1afc4f590c47..c23b08530a7f 100644
--- a/fs/cifs/dfs_cache.h
+++ b/fs/cifs/dfs_cache.h
@@ -10,6 +10,7 @@
 
 #include <linux/nls.h>
 #include <linux/list.h>
+#include <linux/uuid.h>
 #include "cifsglob.h"
 
 struct dfs_cache_tgt_list {
@@ -44,13 +45,10 @@ dfs_cache_noreq_update_tgthint(const char *path,
 extern int dfs_cache_get_tgt_referral(const char *path,
 				      const struct dfs_cache_tgt_iterator *it,
 				      struct dfs_info3_param *ref);
-extern int dfs_cache_add_vol(char *mntdata, struct smb3_fs_context *ctx,
-			const char *fullpath);
-extern int dfs_cache_update_vol(const char *fullpath,
-				struct TCP_Server_Info *server);
-extern void dfs_cache_del_vol(const char *fullpath);
 extern int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
 				   char **share, char **prefix);
+void dfs_cache_put_refsrv_sessions(const uuid_t *mount_id);
+void dfs_cache_add_refsrv_session(const uuid_t *mount_id, struct cifs_ses *ses);
 
 static inline struct dfs_cache_tgt_iterator *
 dfs_cache_get_next_tgt(struct dfs_cache_tgt_list *tl,
-- 
2.31.1

