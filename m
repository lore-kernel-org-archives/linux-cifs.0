Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4489C1E5728
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 21:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731966643; cv=none; b=tTUzfmEv+kWSRkelEX9NRqLglra6MeIkdAWqam+CutBCgyeMt6YbraIuATl+3F2Lwg4rDjDAP5nuQ05f+JT31+4st73aTs7Kd/e/9nWqjbR/xWHBg5num7QsUvbTJpOzbUkrNEYKK3Kjyf9jd1UxIWXOdyJxi22ccKQRX8uLU60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731966643; c=relaxed/simple;
	bh=8yO9Ev99EH50oUlNu3HfOCCCoKvTIkPSOqcuUIsZM4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKxo9ZiAMB/0DoZRwzM1BSEoI/DbI5e0O5SxWvbEiNaJIkSlNzIalrSULz/3A/n4pjYU3Knq78gOEzknl+3W7Wg5Y/W0raPoKpsdF7t/YENl+6FTlSHOZQtbCcm9cmIU2ld7+WfSRaArgXtAbikkDd6htVABEJvbPOr8J6f6Cy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=FLn2825t; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=kafMl57A; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="FLn2825t";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="kafMl57A"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1731966634; h=from : to : cc : subject : date : message-id :
 in-reply-to : references : mime-version : content-transfer-encoding :
 from; bh=NMWm5/p0DfcEsSv9jNuO6Hj3Zh7kCcKqqAkkM9DzaKo=;
 b=FLn2825tq/KCg0QOZTk+p/zpkJXXrX8cNARRvHwfJgVtX8aC2CM0W17oT0Yt/ykWXxOTc
 MVfrmabOx4LqqZrCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1731966634; h=from : to
 : cc : subject : date : message-id : in-reply-to : references :
 mime-version : content-transfer-encoding : from;
 bh=NMWm5/p0DfcEsSv9jNuO6Hj3Zh7kCcKqqAkkM9DzaKo=;
 b=kafMl57A1K0ek3gLhO9y+UKERUNl6aUFLmcytRg+VIJKGtO9QrHkuIPrxWDlzv73+GM1Q
 6UExVHCAGJZ6whvQMXLnsrNZ3d/mbT/oqBBysyfsHn1WzWQrYMAxo6HM1ja2whlk5BxfZfD
 CYXdiJjqaS0O+HViJdqxsn8ZyYPvP2MHgxsyz9HH3kwzXA2J6MOBBtH8qV/qo3JB9rP36Xi
 tR6QNLjIVC19cfWqoR7GNXzOB7f0g4EPzUTRUMAIaTTwJ+WhjIayVBz+KJPhzfaVdF2AvUY
 RoE5hWRJUcDEQt9KsqUvLtj/6BDRiYk9TYAgUEPJilQy0wNbSd7p3ORZIyvA==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by o-chul.darkrain42.org (Postfix) with ESMTPSA id 60BE583E9;
	Mon, 18 Nov 2024 13:50:34 -0800 (PST)
From: Paul Aurich <paul@darkrain42.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: paul@darkrain42.org,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH v2 4/4] smb: During unmount, ensure all cached dir instances drop their dentry
Date: Mon, 18 Nov 2024 13:50:28 -0800
Message-ID: <20241118215028.1066662-5-paul@darkrain42.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241118215028.1066662-1-paul@darkrain42.org>
References: <20241118215028.1066662-1-paul@darkrain42.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The unmount process (cifs_kill_sb() calling close_all_cached_dirs()) can
race with various cached directory operations, which ultimately results
in dentries not being dropped and these kernel BUGs:

BUG: Dentry ffff88814f37e358{i=1000000000080,n=/}  still in use (2) [unmount of cifs cifs]
VFS: Busy inodes after unmount of cifs (cifs)
------------[ cut here ]------------
kernel BUG at fs/super.c:661!

This happens when a cfid is in the process of being cleaned up when, and
has been removed from the cfids->entries list, including:

- Receiving a lease break from the server
- Server reconnection triggers invalidate_all_cached_dirs(), which
  removes all the cfids from the list
- The laundromat thread decides to expire an old cfid.

To solve these problems, dropping the dentry is done in queued work done
in a newly-added cfid_put_wq workqueue, and close_all_cached_dirs()
flushes that workqueue after it drops all the dentries of which it's
aware. This is a global workqueue (rather than scoped to a mount), but
the queued work is minimal.

The final cleanup work for cleaning up a cfid is performed via work
queued in the serverclose_wq workqueue; this is done separate from
dropping the dentries so that close_all_cached_dirs() doesn't block on
any server operations.

Both of these queued works expect to invoked with a cfid reference and
a tcon reference to avoid those objects from being freed while the work
is ongoing.

While we're here, add proper locking to close_all_cached_dirs(), and
locking around the freeing of cfid->dentry.

Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Aurich <paul@darkrain42.org>
---
 fs/smb/client/cached_dir.c | 156 ++++++++++++++++++++++++++++++-------
 fs/smb/client/cached_dir.h |   6 +-
 fs/smb/client/cifsfs.c     |  14 +++-
 fs/smb/client/cifsglob.h   |   3 +-
 fs/smb/client/inode.c      |   3 -
 fs/smb/client/trace.h      |   3 +
 6 files changed, 148 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 64c67cbb2aa5..8fb95f4347df 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -15,10 +15,15 @@
 static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
 
+struct cached_dir_dentry {
+	struct list_head entry;
+	struct dentry *dentry;
+};
+
 static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 						    const char *path,
 						    bool lookup_only,
 						    __u32 max_cached_dirs)
 {
@@ -469,42 +474,68 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 	struct rb_node *node;
 	struct cached_fid *cfid;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
 	struct cached_fids *cfids;
+	struct cached_dir_dentry *tmp_list, *q;
+	LIST_HEAD(entry);
 
+	spin_lock(&cifs_sb->tlink_tree_lock);
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
 		tcon = tlink_tcon(tlink);
 		if (IS_ERR(tcon))
 			continue;
 		cfids = tcon->cfids;
 		if (cfids == NULL)
 			continue;
+		spin_lock(&cfids->cfid_list_lock);
 		list_for_each_entry(cfid, &cfids->entries, entry) {
-			dput(cfid->dentry);
+			tmp_list = kmalloc(sizeof(*tmp_list), GFP_ATOMIC);
+			if (tmp_list == NULL)
+				break;
+			spin_lock(&cfid->fid_lock);
+			tmp_list->dentry = cfid->dentry;
 			cfid->dentry = NULL;
+			spin_unlock(&cfid->fid_lock);
+
+			list_add_tail(&tmp_list->entry, &entry);
 		}
+		spin_unlock(&cfids->cfid_list_lock);
 	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	list_for_each_entry_safe(tmp_list, q, &entry, entry) {
+		list_del(&tmp_list->entry);
+		dput(tmp_list->dentry);
+		kfree(tmp_list);
+	}
+
+	/* Flush any pending work that will drop dentries */
+	flush_workqueue(cfid_put_wq);
 }
 
 /*
  * Invalidate all cached dirs when a TCON has been reset
  * due to a session loss.
  */
 void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 {
 	struct cached_fids *cfids = tcon->cfids;
 	struct cached_fid *cfid, *q;
-	LIST_HEAD(entry);
 
 	if (cfids == NULL)
 		return;
 
+	/*
+	 * Mark all the cfids as closed, and move them to the cfids->dying list.
+	 * They'll be cleaned up later by cfids_invalidation_worker. Take
+	 * a reference to each cfid during this process.
+	 */
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-		list_move(&cfid->entry, &entry);
+		list_move(&cfid->entry, &cfids->dying);
 		cfids->num_entries--;
 		cfid->is_open = false;
 		cfid->on_list = false;
 		if (cfid->has_lease) {
 			/*
@@ -513,30 +544,51 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 			 */
 			cfid->has_lease = false;
 		} else
 			kref_get(&cfid->refcount);
 	}
+	/*
+	 * Queue dropping of the dentries once locks have been dropped
+	 */
+	if (!list_empty(&cfids->dying))
+		queue_work(cfid_put_wq, &cfids->invalidation_work);
 	spin_unlock(&cfids->cfid_list_lock);
-
-	list_for_each_entry_safe(cfid, q, &entry, entry) {
-		list_del(&cfid->entry);
-		cancel_work_sync(&cfid->lease_break);
-		/*
-		 * Drop the ref-count from above, either the lease-ref (if there
-		 * was one) or the extra one acquired.
-		 */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
-	}
 }
 
 static void
-smb2_cached_lease_break(struct work_struct *work)
+cached_dir_offload_close(struct work_struct *work)
 {
 	struct cached_fid *cfid = container_of(work,
-				struct cached_fid, lease_break);
+				struct cached_fid, close_work);
+	struct cifs_tcon *tcon = cfid->tcon;
+
+	WARN_ON(cfid->on_list);
 
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
+}
+
+/*
+ * Release the cached directory's dentry, and then queue work to drop cached
+ * directory itself (closing on server if needed).
+ *
+ * Must be called with a reference to the cached_fid and a reference to the
+ * tcon.
+ */
+static void cached_dir_put_work(struct work_struct *work)
+{
+	struct cached_fid *cfid = container_of(work, struct cached_fid,
+					       put_work);
+	struct dentry *dentry;
+
+	spin_lock(&cfid->fid_lock);
+	dentry = cfid->dentry;
+	cfid->dentry = NULL;
+	spin_unlock(&cfid->fid_lock);
+
+	dput(dentry);
+	queue_work(serverclose_wq, &cfid->close_work);
 }
 
 int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 {
 	struct cached_fids *cfids = tcon->cfids;
@@ -559,12 +611,14 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			 */
 			list_del(&cfid->entry);
 			cfid->on_list = false;
 			cfids->num_entries--;
 
-			queue_work(cifsiod_wq,
-				   &cfid->lease_break);
+			++tcon->tc_count;
+			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+					    netfs_trace_tcon_ref_get_cached_lease_break);
+			queue_work(cfid_put_wq, &cfid->put_work);
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
 		}
 	}
 	spin_unlock(&cfids->cfid_list_lock);
@@ -582,11 +636,12 @@ static struct cached_fid *init_cached_dir(const char *path)
 	if (!cfid->path) {
 		kfree(cfid);
 		return NULL;
 	}
 
-	INIT_WORK(&cfid->lease_break, smb2_cached_lease_break);
+	INIT_WORK(&cfid->close_work, cached_dir_offload_close);
+	INIT_WORK(&cfid->put_work, cached_dir_put_work);
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
 	spin_lock_init(&cfid->fid_lock);
 	kref_init(&cfid->refcount);
@@ -595,10 +650,13 @@ static struct cached_fid *init_cached_dir(const char *path)
 
 static void free_cached_dir(struct cached_fid *cfid)
 {
 	struct cached_dirent *dirent, *q;
 
+	WARN_ON(work_pending(&cfid->close_work));
+	WARN_ON(work_pending(&cfid->put_work));
+
 	dput(cfid->dentry);
 	cfid->dentry = NULL;
 
 	/*
 	 * Delete all cached dirent names
@@ -612,14 +670,34 @@ static void free_cached_dir(struct cached_fid *cfid)
 	kfree(cfid->path);
 	cfid->path = NULL;
 	kfree(cfid);
 }
 
+static void cfids_invalidation_worker(struct work_struct *work)
+{
+	struct cached_fids *cfids = container_of(work, struct cached_fids,
+						 invalidation_work);
+	struct cached_fid *cfid, *q;
+	LIST_HEAD(entry);
+
+	spin_lock(&cfids->cfid_list_lock);
+	/* move cfids->dying to the local list */
+	list_cut_before(&entry, &cfids->dying, &cfids->dying);
+	spin_unlock(&cfids->cfid_list_lock);
+
+	list_for_each_entry_safe(cfid, q, &entry, entry) {
+		list_del(&cfid->entry);
+		/* Drop the ref-count acquired in invalidate_all_cached_dirs */
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
+	}
+}
+
 static void cfids_laundromat_worker(struct work_struct *work)
 {
 	struct cached_fids *cfids;
 	struct cached_fid *cfid, *q;
+	struct dentry *dentry;
 	LIST_HEAD(entry);
 
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
 
 	spin_lock(&cfids->cfid_list_lock);
@@ -641,22 +719,32 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
-		/*
-		 * Cancel and wait for the work to finish in case we are racing
-		 * with it.
-		 */
-		cancel_work_sync(&cfid->lease_break);
-		/*
-		 * Drop the ref-count from above, either the lease-ref (if there
-		 * was one) or the extra one acquired.
-		 */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+
+		spin_lock(&cfid->fid_lock);
+		dentry = cfid->dentry;
+		cfid->dentry = NULL;
+		spin_unlock(&cfid->fid_lock);
+
+		dput(dentry);
+		if (cfid->is_open) {
+			spin_lock(&cifs_tcp_ses_lock);
+			++cfid->tcon->tc_count;
+			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
+					    netfs_trace_tcon_ref_get_cached_laundromat);
+			spin_unlock(&cifs_tcp_ses_lock);
+			queue_work(serverclose_wq, &cfid->close_work);
+		} else
+			/*
+			 * Drop the ref-count from above, either the lease-ref (if there
+			 * was one) or the extra one acquired.
+			 */
+			kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
-	queue_delayed_work(cifsiod_wq, &cfids->laundromat_work,
+	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);
 }
 
 struct cached_fids *init_cached_dirs(void)
 {
@@ -665,13 +753,15 @@ struct cached_fids *init_cached_dirs(void)
 	cfids = kzalloc(sizeof(*cfids), GFP_KERNEL);
 	if (!cfids)
 		return NULL;
 	spin_lock_init(&cfids->cfid_list_lock);
 	INIT_LIST_HEAD(&cfids->entries);
+	INIT_LIST_HEAD(&cfids->dying);
 
+	INIT_WORK(&cfids->invalidation_work, cfids_invalidation_worker);
 	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
-	queue_delayed_work(cifsiod_wq, &cfids->laundromat_work,
+	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);
 
 	return cfids;
 }
 
@@ -686,17 +776,23 @@ void free_cached_dirs(struct cached_fids *cfids)
 
 	if (cfids == NULL)
 		return;
 
 	cancel_delayed_work_sync(&cfids->laundromat_work);
+	cancel_work_sync(&cfids->invalidation_work);
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		cfid->on_list = false;
 		cfid->is_open = false;
 		list_move(&cfid->entry, &entry);
 	}
+	list_for_each_entry_safe(cfid, q, &cfids->dying, entry) {
+		cfid->on_list = false;
+		cfid->is_open = false;
+		list_move(&cfid->entry, &entry);
+	}
 	spin_unlock(&cfids->cfid_list_lock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 		free_cached_dir(cfid);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 81ba0fd5cc16..1dfe79d947a6 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -42,23 +42,27 @@ struct cached_fid {
 	struct kref refcount;
 	struct cifs_fid fid;
 	spinlock_t fid_lock;
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
-	struct work_struct lease_break;
+	struct work_struct put_work;
+	struct work_struct close_work;
 	struct smb2_file_all_info file_all_info;
 	struct cached_dirents dirents;
 };
 
 /* default MAX_CACHED_FIDS is 16 */
 struct cached_fids {
 	/* Must be held when:
 	 * - accessing the cfids->entries list
+	 * - accessing the cfids->dying list
 	 */
 	spinlock_t cfid_list_lock;
 	int num_entries;
 	struct list_head entries;
+	struct list_head dying;
+	struct work_struct invalidation_work;
 	struct delayed_work laundromat_work;
 };
 
 extern struct cached_fids *init_cached_dirs(void);
 extern void free_cached_dirs(struct cached_fids *cfids);
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 20cafdff5081..bf909c2f6b96 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -155,10 +155,11 @@ struct workqueue_struct	*cifsiod_wq;
 struct workqueue_struct	*decrypt_wq;
 struct workqueue_struct	*fileinfo_put_wq;
 struct workqueue_struct	*cifsoplockd_wq;
 struct workqueue_struct	*deferredclose_wq;
 struct workqueue_struct	*serverclose_wq;
+struct workqueue_struct	*cfid_put_wq;
 __u32 cifs_lock_secret;
 
 /*
  * Bumps refcount for cifs super block.
  * Note that it should be only called if a reference to VFS super block is
@@ -1893,13 +1894,20 @@ init_cifs(void)
 	if (!serverclose_wq) {
 		rc = -ENOMEM;
 		goto out_destroy_deferredclose_wq;
 	}
 
-	rc = cifs_init_inodecache();
-	if (rc)
+	cfid_put_wq = alloc_workqueue("cfid_put_wq",
+				      WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
+	if (!cfid_put_wq) {
+		rc = -ENOMEM;
 		goto out_destroy_serverclose_wq;
+	}
+
+	rc = cifs_init_inodecache();
+	if (rc)
+		goto out_destroy_cfid_put_wq;
 
 	rc = cifs_init_netfs();
 	if (rc)
 		goto out_destroy_inodecache;
 
@@ -1963,10 +1971,12 @@ init_cifs(void)
 	destroy_mids();
 out_destroy_netfs:
 	cifs_destroy_netfs();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_cfid_put_wq:
+	destroy_workqueue(cfid_put_wq);
 out_destroy_serverclose_wq:
 	destroy_workqueue(serverclose_wq);
 out_destroy_deferredclose_wq:
 	destroy_workqueue(deferredclose_wq);
 out_destroy_cifsoplockd_wq:
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 5041b1ffc244..31ea19e7b998 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1981,11 +1981,11 @@ require use of the stronger protocol */
  * cifsInodeInfo->open_file_lock	cifsInodeInfo->openFileList	cifs_alloc_inode
  * cifsInodeInfo->writers_lock	cifsInodeInfo->writers		cifsInodeInfo_alloc
  * cifsInodeInfo->lock_sem	cifsInodeInfo->llist		cifs_init_once
  *				->can_cache_brlcks
  * cifsInodeInfo->deferred_lock	cifsInodeInfo->deferred_closes	cifsInodeInfo_alloc
- * cached_fid->fid_mutex		cifs_tcon->crfid		tcon_info_alloc
+ * cached_fids->cfid_list_lock	cifs_tcon->cfids->entries	 init_cached_dirs
  * cifsFileInfo->fh_mutex		cifsFileInfo			cifs_new_fileinfo
  * cifsFileInfo->file_info_lock	cifsFileInfo->count		cifs_new_fileinfo
  *				->invalidHandle			initiate_cifs_search
  *				->oplock_break_cancelled
  ****************************************************************************/
@@ -2069,10 +2069,11 @@ extern struct workqueue_struct *cifsiod_wq;
 extern struct workqueue_struct *decrypt_wq;
 extern struct workqueue_struct *fileinfo_put_wq;
 extern struct workqueue_struct *cifsoplockd_wq;
 extern struct workqueue_struct *deferredclose_wq;
 extern struct workqueue_struct *serverclose_wq;
+extern struct workqueue_struct *cfid_put_wq;
 extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index eff3f57235ee..20484853fb6b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2471,17 +2471,14 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 
 	if (!lookupCacheEnabled)
 		return true;
 
 	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
-		spin_lock(&cfid->fid_lock);
 		if (cfid->time && cifs_i->time > cfid->time) {
-			spin_unlock(&cfid->fid_lock);
 			close_cached_dir(cfid);
 			return false;
 		}
-		spin_unlock(&cfid->fid_lock);
 		close_cached_dir(cfid);
 	}
 	/*
 	 * depending on inode type, check if attribute caching disabled for
 	 * files or directories
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 0b52d22a91a0..12cbd3428a6d 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -42,18 +42,21 @@
 	EM(netfs_trace_tcon_ref_free,			"FRE       ") \
 	EM(netfs_trace_tcon_ref_free_fail,		"FRE Fail  ") \
 	EM(netfs_trace_tcon_ref_free_ipc,		"FRE Ipc   ") \
 	EM(netfs_trace_tcon_ref_free_ipc_fail,		"FRE Ipc-F ") \
 	EM(netfs_trace_tcon_ref_free_reconnect_server,	"FRE Reconn") \
+	EM(netfs_trace_tcon_ref_get_cached_laundromat,	"GET Ch-Lau") \
+	EM(netfs_trace_tcon_ref_get_cached_lease_break,	"GET Ch-Lea") \
 	EM(netfs_trace_tcon_ref_get_cancelled_close,	"GET Cn-Cls") \
 	EM(netfs_trace_tcon_ref_get_dfs_refer,		"GET DfsRef") \
 	EM(netfs_trace_tcon_ref_get_find,		"GET Find  ") \
 	EM(netfs_trace_tcon_ref_get_find_sess_tcon,	"GET FndSes") \
 	EM(netfs_trace_tcon_ref_get_reconnect_server,	"GET Reconn") \
 	EM(netfs_trace_tcon_ref_new,			"NEW       ") \
 	EM(netfs_trace_tcon_ref_new_ipc,		"NEW Ipc   ") \
 	EM(netfs_trace_tcon_ref_new_reconnect_server,	"NEW Reconn") \
+	EM(netfs_trace_tcon_ref_put_cached_close,	"PUT Ch-Cls") \
 	EM(netfs_trace_tcon_ref_put_cancelled_close,	"PUT Cn-Cls") \
 	EM(netfs_trace_tcon_ref_put_cancelled_close_fid, "PUT Cn-Fid") \
 	EM(netfs_trace_tcon_ref_put_cancelled_mid,	"PUT Cn-Mid") \
 	EM(netfs_trace_tcon_ref_put_mnt_ctx,		"PUT MntCtx") \
 	EM(netfs_trace_tcon_ref_put_reconnect_server,	"PUT Reconn") \
-- 
2.45.2

