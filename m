Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA549C432C0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0D2E20665
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="ocfJqy/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfK0Ah1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 19:37:27 -0500
Received: from mx.cjr.nz ([51.158.111.142]:16170 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbfK0Ah1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Nov 2019 19:37:27 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1A6BD80A26;
        Wed, 27 Nov 2019 00:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574815044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpHBhEnUUIoahJEhGFgZPlfRMhNslA67yh56V3D8Qbk=;
        b=ocfJqy/sX8XfyOzmUB50qqgrkl/nG8Dl5PkIK52vPzRsNcGQIhhb42yYcKPbW1n+RtC7x4
        7QZfVL5Ms6YLsu4cGsYS2zZHIo/RCW35MLd6MSl/1o+QW8n5UVs0S5oKzBX7IlEjqTCQWt
        uTiNpY3MlM0uVBqXpbQXLW9HcJaJpJOyauKalXVZi0GQCt/qBwqiMYgwrcvMxcq1Z2+nbq
        KLSkyE2a3OI3z9IQtOlPLTHD8LAzRHxZWVA4jAMqDeV6h6e0oLst/KNdhpiO/ic5gR/4DX
        7MNjowWkNQAi16CBKrrPjcETBNNISpmKWifHsOETF9us6zY8X/cq7EN+Ouut8g==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH v3 08/11] cifs: Fix potential deadlock when updating vol in cifs_reconnect()
Date:   Tue, 26 Nov 2019 21:36:31 -0300
Message-Id: <20191127003634.14072-9-pc@cjr.nz>
In-Reply-To: <20191127003634.14072-1-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can't acquire vol_lock while refreshing the DFS cache because
cifs_reconnect() may call dfs_cache_update_vol() while we are walking
through the volume list.

To prevent that, make vol_info refcounted, create a temp list with all
volumes eligible for refreshing, and then use it without any locks
held.

Also turn vol_lock into a spinlock rather than a mutex.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 104 +++++++++++++++++++++++++++++---------------
 1 file changed, 69 insertions(+), 35 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 1d1f7c03931b..629190926197 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -52,12 +52,14 @@ struct vol_info {
 	struct smb_vol smb_vol;
 	char *mntdata;
 	struct list_head list;
+	struct list_head rlist;
+	int vol_count;
 };
 
 static struct kmem_cache *cache_slab __read_mostly;
 static struct workqueue_struct *dfscache_wq __read_mostly;
 
-static int cache_ttl;
+static atomic_t cache_ttl;
 static struct nls_table *cache_nlsc;
 
 /*
@@ -69,7 +71,7 @@ static struct hlist_head cache_htable[CACHE_HTABLE_SIZE];
 static DEFINE_MUTEX(list_lock);
 
 static LIST_HEAD(vol_list);
-static DEFINE_MUTEX(vol_lock);
+static DEFINE_SPINLOCK(vol_lock);
 
 static void refresh_cache_worker(struct work_struct *work);
 
@@ -300,7 +302,7 @@ int dfs_cache_init(void)
 	for (i = 0; i < CACHE_HTABLE_SIZE; i++)
 		INIT_HLIST_HEAD(&cache_htable[i]);
 
-	cache_ttl = -1;
+	atomic_set(&cache_ttl, -1);
 	cache_nlsc = load_nls_default();
 
 	cifs_dbg(FYI, "%s: initialized DFS referral cache\n", __func__);
@@ -464,6 +466,7 @@ add_cache_entry(unsigned int hash, const char *path,
 		const struct dfs_info3_param *refs, int numrefs)
 {
 	struct cache_entry *ce;
+	int ttl;
 
 	ce = alloc_cache_entry(path, refs, numrefs);
 	if (IS_ERR(ce))
@@ -471,15 +474,16 @@ add_cache_entry(unsigned int hash, const char *path,
 
 	hlist_add_head_rcu(&ce->hlist, &cache_htable[hash]);
 
-	mutex_lock(&vol_lock);
-	if (cache_ttl < 0) {
-		cache_ttl = ce->ttl;
-		queue_delayed_work(dfscache_wq, &refresh_task, cache_ttl * HZ);
+	ttl = atomic_read(&cache_ttl);
+	if (ttl < 0) {
+		ttl = ce->ttl;
+		queue_delayed_work(dfscache_wq, &refresh_task, ttl * HZ);
 	} else {
-		cache_ttl = min_t(int, cache_ttl, ce->ttl);
-		mod_delayed_work(dfscache_wq, &refresh_task, cache_ttl * HZ);
+		ttl = min_t(int, ttl, ce->ttl);
+		mod_delayed_work(dfscache_wq, &refresh_task, ttl * HZ);
 	}
-	mutex_unlock(&vol_lock);
+
+	atomic_set(&cache_ttl, ttl);
 
 	return ce;
 }
@@ -523,13 +527,16 @@ static inline void destroy_slab_cache(void)
 	kmem_cache_destroy(cache_slab);
 }
 
-static inline void free_vol(struct vol_info *vi)
+/* Must be called with vol_lock held */
+static inline void put_vol(struct vol_info *vi)
 {
-	list_del(&vi->list);
-	kfree(vi->fullpath);
-	kfree(vi->mntdata);
-	cifs_cleanup_volume_info_contents(&vi->smb_vol);
-	kfree(vi);
+	if (!--vi->vol_count) {
+		list_del_init(&vi->list);
+		kfree(vi->fullpath);
+		kfree(vi->mntdata);
+		cifs_cleanup_volume_info_contents(&vi->smb_vol);
+		kfree(vi);
+	}
 }
 
 static inline void free_vol_list(void)
@@ -537,7 +544,7 @@ static inline void free_vol_list(void)
 	struct vol_info *vi, *nvi;
 
 	list_for_each_entry_safe(vi, nvi, &vol_list, list)
-		free_vol(vi);
+		put_vol(vi);
 }
 
 /**
@@ -1156,10 +1163,12 @@ int dfs_cache_add_vol(char *mntdata, struct smb_vol *vol, const char *fullpath)
 		goto err_free_fullpath;
 
 	vi->mntdata = mntdata;
+	vi->vol_count++;
 
-	mutex_lock(&vol_lock);
+	spin_lock(&vol_lock);
 	list_add_tail(&vi->list, &vol_list);
-	mutex_unlock(&vol_lock);
+	spin_unlock(&vol_lock);
+
 	return 0;
 
 err_free_fullpath:
@@ -1169,7 +1178,8 @@ int dfs_cache_add_vol(char *mntdata, struct smb_vol *vol, const char *fullpath)
 	return rc;
 }
 
-static inline struct vol_info *find_vol(const char *fullpath)
+/* Must be called with vol_lock held */
+static struct vol_info *find_vol(const char *fullpath)
 {
 	struct vol_info *vi;
 
@@ -1199,21 +1209,22 @@ int dfs_cache_update_vol(const char *fullpath, struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "%s: fullpath: %s\n", __func__, fullpath);
 
-	mutex_lock(&vol_lock);
+	spin_lock(&vol_lock);
 
 	vi = find_vol(fullpath);
 	if (IS_ERR(vi)) {
 		rc = PTR_ERR(vi);
-		goto out;
+		goto out_unlock;
 	}
 
 	cifs_dbg(FYI, "%s: updating volume info\n", __func__);
 	memcpy(&vi->smb_vol.dstaddr, &server->dstaddr,
 	       sizeof(vi->smb_vol.dstaddr));
+
 	rc = 0;
 
-out:
-	mutex_unlock(&vol_lock);
+out_unlock:
+	spin_unlock(&vol_lock);
 	return rc;
 }
 
@@ -1231,11 +1242,11 @@ void dfs_cache_del_vol(const char *fullpath)
 
 	cifs_dbg(FYI, "%s: fullpath: %s\n", __func__, fullpath);
 
-	mutex_lock(&vol_lock);
+	spin_lock(&vol_lock);
 	vi = find_vol(fullpath);
 	if (!IS_ERR(vi))
-		free_vol(vi);
-	mutex_unlock(&vol_lock);
+		put_vol(vi);
+	spin_unlock(&vol_lock);
 }
 
 /* Get all tcons that are within a DFS namespace and can be refreshed */
@@ -1449,27 +1460,50 @@ static void refresh_tcon(struct vol_info *vi, struct cifs_tcon *tcon)
  */
 static void refresh_cache_worker(struct work_struct *work)
 {
-	struct vol_info *vi;
+	struct vol_info *vi, *nvi;
 	struct TCP_Server_Info *server;
-	LIST_HEAD(list);
+	LIST_HEAD(vols);
+	LIST_HEAD(tcons);
 	struct cifs_tcon *tcon, *ntcon;
 
-	mutex_lock(&vol_lock);
-
+	/*
+	 * Find SMB volumes that are eligible (server->tcpStatus == CifsGood)
+	 * for refreshing.
+	 */
+	spin_lock(&vol_lock);
 	list_for_each_entry(vi, &vol_list, list) {
 		server = get_tcp_server(&vi->smb_vol);
 		if (!server)
 			continue;
 
-		get_tcons(server, &list);
-		list_for_each_entry_safe(tcon, ntcon, &list, ulist) {
+		vi->vol_count++;
+		list_add_tail(&vi->rlist, &vols);
+		put_tcp_server(server);
+	}
+	spin_unlock(&vol_lock);
+
+	/* Walk through all TCONs and refresh any expired cache entry */
+	list_for_each_entry_safe(vi, nvi, &vols, rlist) {
+		server = get_tcp_server(&vi->smb_vol);
+		if (!server)
+			goto next_vol;
+
+		get_tcons(server, &tcons);
+		list_for_each_entry_safe(tcon, ntcon, &tcons, ulist) {
 			refresh_tcon(vi, tcon);
 			list_del_init(&tcon->ulist);
 			cifs_put_tcon(tcon);
 		}
 
 		put_tcp_server(server);
+
+next_vol:
+		list_del_init(&vi->rlist);
+		spin_lock(&vol_lock);
+		put_vol(vi);
+		spin_unlock(&vol_lock);
 	}
-	queue_delayed_work(dfscache_wq, &refresh_task, cache_ttl * HZ);
-	mutex_unlock(&vol_lock);
+
+	queue_delayed_work(dfscache_wq, &refresh_task,
+			   atomic_read(&cache_ttl) * HZ);
 }
-- 
2.24.0

