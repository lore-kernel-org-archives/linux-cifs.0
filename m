Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D4513790B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246050; cv=none; b=f56cB/fmD/9kt7TDoiAwi4VVdsl9/BOqEsOcF6zQvKRP3ul3gtHcy4e98ixJTjOpyJc3zSfvoDlRIjUwPeA3w7IAkYg3RvcEVJLzvL9+8ng3nMbL/zor2YmkwqB9OhXQr8QJSsJ/tI6o4DrHYWne2a01E3AEVdDnlYyPAvZPRvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246050; c=relaxed/simple;
	bh=I9d0IxFJGXavrALwA4wZrYwPT10LOPRaCZukrZn3W7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukweYpYRXZy+Vx1SIjQ9wl0NAVAATewdqlYEaCY9g6YOjy7/aYfvqXD1CgDxhzioT1i9CzhUyIGWpxrvm+iYXmZgcEBKGWllQK6H4mDrkT9fctRuMLJDWAq8DLj3S51ewV8npkdCA/rhykAdzhwkTT3+rVEwQbHohh4xwhHhuiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ak85c2gg; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ak85c2gg"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-69d8f70cb0cso237004eaf.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246048; x=1782850848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vs3Qxl4TNnCkh8hIFDotPmZcJOIn2jIfmJAStkFxw8E=;
        b=ak85c2ggNzSTIdQy+Kznl8NhqIB0SK7KixA5vDWzuuvba1ZHYhKte5BTBb4CAoHlxd
         QRMONY6iqaJhD/lkAddQldFEHm1SN3l3SENBjsH+OZ74hzftJkzX919yytK9lpziqt/N
         AvnVPZAf51wo3ruCT3YMXMKohYGsAoDTHn+FtRkdmFuKRqwILJTBSw/5F66en1ZQmW4t
         xB9cPQBCQiE2OhEg7MoTqfXhmhxsdz9N8Rdd2dmch/QqGKMnXZFG4VvHi1m4kuiTfUaF
         xOse5AdzDEHne+wBtANN0PXHVZfNrKQZHDNNYdLJ9B3iksx42cSCnhKEpIAxuTjFIiu7
         Z9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246048; x=1782850848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vs3Qxl4TNnCkh8hIFDotPmZcJOIn2jIfmJAStkFxw8E=;
        b=q75UNHCUniihgRupBwcS6vFU9lIa5MEkayEZDWvxNFZPJAVyXLy9fkeuyvNOZUJbI7
         GlfqEa5fCsgQnu1mKfY3GhMhk4KUrk1QdA4HuyDPSBXHFOxIB+ToPndwojGL8hmtQ4XR
         U2MLr+GQVb+Du6XocXRoomjxCLQlozAvMUWxtVYwStbvOVNhPpMdueRvPn8gJtlr0JFv
         8DhC053M/xY4jDqcllYVv+AvL7etFhHVuqD8aDRZ68/aC2NPInuowffO0wad/HJEQmfd
         GQ5FnIRRPaxNeP7MS7d6MiREyLlQ9fu26sOwvB8RhDuTJRk5TAVKd/ARI+afMghhnXcz
         gCoA==
X-Gm-Message-State: AOJu0YwN6FGqZYD/Kwu9cwZIXQp2q0Jxu9oAozeDlislrWI+oVyW1cLL
	hD7yAlGTqBGsEUDA+7o2lZXl7DuEyU+1CDR76EMXbNHN2vaAdhclMwIWtRjcryZN
X-Gm-Gg: AfdE7clZZe/ZzfKsK/i1tbO8MITP+wS1ZPNn7dY9rF4ouHJGkAWClWQt8NjQ0B4aky7
	ukv/DEkvyrF8Vv0ZrYTvZ5r4s9Rn2+J+1cfEVPUmVV8tk0TiFe3cZZFlIbCd6/yUMvt/y4yGa00
	mL0rtE0JE1VGbTys1Jzau2piTB82bP51eOn+AevbPVaWKTCNKwEU3RaHmvaQo8uuw6loETyRq40
	uFsDQi7Axu3OVs2W73Jq1XypQ9xSF01TB4cK4pmrqhlaAZ6UlYjISJJETXFYGYxkmeHOJ1EH3qA
	0nPmO5XOaK+VoWtp4YFrgsHRJi+oA2wPR3+rgPC0WWrCPZc5ypxpcM6akz7iUHhc6WYvGy17Hx8
	kVGg4EogonAeJB0PKP1W5Pqu1JVz3ttdLic2hRPUwZ7Qhk2TN+te85O9BGceJ0qxEVWS6PehWNe
	7dkIVn0GRVGEe69kGHbd3GR0KfOlwdZndW2vdl1+D18OPgiAK3RqkeZeQwOMQJI/gCkIH0mIuJt
	IIzq/63ZdTGrPZA6D0GZiMz1BG5LPqVXPnzBkZ8fGcbIMgvENje5yPbfg9jnDrPMeKKeuPL2J8u
	/hVGT7v22DHrvDAjAeEZAV0nlWE=
X-Received: by 2002:a05:6820:1612:b0:6a1:123e:3711 with SMTP id 006d021491bc7-6a122fc619fmr212110eaf.39.1782246047989;
        Tue, 23 Jun 2026 13:20:47 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:47 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 15/16] cifs: keep cfids in rbtree for efficient lookups
Date: Tue, 23 Jun 2026 15:13:42 -0500
Message-ID: <20260623201344.2043841-15-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623201344.2043841-1-stfrench@microsoft.com>
References: <20260623201344.2043841-1-stfrench@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today tcon->cfids are maintained as a linked list. When we do
not limit the number of cfids (limited by system memory), this
can be a problem if the mount has a large number of active dir
accesses. We soon start hitting perf bottlenecks.

This change stores cfids in a rbtree instead of a linked list.
The nodes of this tree are keyed based on the path inside the tcon.

Additionally, for faster lookups by dentry, introducing a hashtable
to allow lookups of cfids by dentry faster. This is important
since open_cached_dir_by_dentry is called quite frequently.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 227 ++++++++++++++++++++++++++-----------
 fs/smb/client/cached_dir.h |   8 +-
 fs/smb/client/cifs_debug.c |   4 +-
 3 files changed, 172 insertions(+), 67 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 389695b20324..3cf4cfa23c37 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -22,6 +22,7 @@ static void smb2_close_cached_fid(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
 
 #define CACHED_DIRENT_HASH_BITS	7
+#define CACHED_DIR_DENTRY_HT_BITS	8
 
 struct cached_dir_dentry {
 	struct list_head entry;
@@ -1239,6 +1240,57 @@ int cifs_wait_for_pending_dcache(struct cached_fid *cfid,
 	return ret;
 }
 
+static struct cached_fid *cfid_rb_find(struct rb_root *root, const char *path)
+{
+	struct rb_node *node = root->rb_node;
+
+	while (node) {
+		struct cached_fid *cfid = rb_entry(node, struct cached_fid, node);
+		int cmp = strcmp(path, cfid->path);
+
+		if (cmp < 0)
+			node = node->rb_left;
+		else if (cmp > 0)
+			node = node->rb_right;
+		else
+			return cfid;
+	}
+	return NULL;
+}
+
+static struct cached_fid *cfid_dentry_ht_find(struct cached_fids *cfids,
+					      struct dentry *dentry)
+{
+	struct cached_fid *cfid;
+
+	hlist_for_each_entry(cfid,
+			     &cfids->dentry_ht[hash_ptr(dentry, CACHED_DIR_DENTRY_HT_BITS)],
+			     dentry_node) {
+		if (cfid->dentry == dentry)
+			return cfid;
+	}
+	return NULL;
+}
+
+static void cfid_rb_insert(struct rb_root *root, struct cached_fid *new)
+{
+	struct rb_node **link = &root->rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*link) {
+		struct cached_fid *cfid = rb_entry(*link, struct cached_fid, node);
+		int cmp = strcmp(new->path, cfid->path);
+
+		parent = *link;
+		if (cmp < 0)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+	rb_link_node(&new->node, parent, link);
+	rb_insert_color(&new->node, root);
+}
+
 static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 						    const char *path,
 						    bool lookup_only,
@@ -1246,22 +1298,21 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 {
 	struct cached_fid *cfid;
 
-	list_for_each_entry(cfid, &cfids->entries, entry) {
-		if (!strcmp(cfid->path, path)) {
-			/*
-			 * If it doesn't have a lease it is either not yet
-			 * fully cached or it may be in the process of
-			 * being deleted due to a lease break.
-			 */
-			spin_lock(&cfid->cfid_lock);
-			if (!is_valid_cached_dir(cfid)) {
-				spin_unlock(&cfid->cfid_lock);
-				return NULL;
-			}
-			kref_get(&cfid->refcount);
+	cfid = cfid_rb_find(&cfids->entries, path);
+	if (cfid) {
+		/*
+		 * If it doesn't have a lease it is either not yet
+		 * fully cached or it may be in the process of
+		 * being deleted due to a lease break.
+		 */
+		spin_lock(&cfid->cfid_lock);
+		if (!is_valid_cached_dir(cfid)) {
 			spin_unlock(&cfid->cfid_lock);
-			return cfid;
+			return NULL;
 		}
+		kref_get(&cfid->refcount);
+		spin_unlock(&cfid->cfid_lock);
+		return cfid;
 	}
 	if (lookup_only) {
 		return NULL;
@@ -1276,7 +1327,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	}
 	cfid->cfids = cfids;
 	cfids->num_entries++;
-	list_add(&cfid->entry, &cfids->entries);
+	cfid_rb_insert(&cfids->entries, cfid);
 	cfid->on_list = true;
 	kref_get(&cfid->refcount);
 	/*
@@ -1458,26 +1509,30 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			struct cached_fid *parent_cfid;
 
 			spin_lock(&cfids->cfid_list_lock);
-			list_for_each_entry(parent_cfid, &cfids->entries, entry) {
+			hlist_for_each_entry(parent_cfid,
+					     &cfids->dentry_ht[hash_ptr(dentry->d_parent,
+								CACHED_DIR_DENTRY_HT_BITS)],
+					     dentry_node) {
+				if (parent_cfid->dentry != dentry->d_parent)
+					continue;
 				spin_lock(&parent_cfid->cfid_lock);
-				if (parent_cfid->dentry == dentry->d_parent) {
-					cifs_dbg(FYI, "found a parent cached file handle\n");
-					if (is_valid_cached_dir(parent_cfid)) {
-						lease_flags
-							|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
-						memcpy(pfid->parent_lease_key,
-						       parent_cfid->fid.lease_key,
-						       SMB2_LEASE_KEY_SIZE);
-					}
-					spin_unlock(&parent_cfid->cfid_lock);
-					break;
+				cifs_dbg(FYI, "found a parent cached file handle\n");
+				if (is_valid_cached_dir(parent_cfid)) {
+					lease_flags
+						|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
+					memcpy(pfid->parent_lease_key,
+					       parent_cfid->fid.lease_key,
+					       SMB2_LEASE_KEY_SIZE);
 				}
 				spin_unlock(&parent_cfid->cfid_lock);
+				break;
 			}
 			spin_unlock(&cfids->cfid_list_lock);
 		}
 	}
 	cfid->dentry = dentry;
+	hlist_add_head(&cfid->dentry_node,
+		       &cfids->dentry_ht[hash_ptr(dentry, CACHED_DIR_DENTRY_HT_BITS)]);
 	cfid->tcon = tcon;
 
 	/*
@@ -1630,7 +1685,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 		spin_lock(&cfids->cfid_list_lock);
 		if (cfid->on_list) {
-			list_del(&cfid->entry);
+			if (cfid->dentry)
+				hlist_del_init(&cfid->dentry_node);
+			rb_erase(&cfid->node, &cfids->entries);
 			cfid->on_list = false;
 			cfids->num_entries--;
 		}
@@ -1674,26 +1731,28 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 		return -ENOENT;
 
 	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry(cfid, &cfids->entries, entry) {
-		if (cfid->dentry == dentry) {
-			spin_lock(&cfid->cfid_lock);
-			if (!is_valid_cached_dir(cfid)) {
-				spin_unlock(&cfid->cfid_lock);
-				rc = -ENOENT;
-				break;
-			}
-			cifs_dbg(FYI, "found a cached file handle by dentry\n");
-			kref_get(&cfid->refcount);
-			*ret_cfid = cfid;
-			cfid->last_access_time = jiffies;
-			rc = 0;
-			trace_cfid = cfid;
+	cfid = cfid_dentry_ht_find(cfids, dentry);
+	if (cfid) {
+		spin_lock(&cfid->cfid_lock);
+		if (!is_valid_cached_dir(cfid)) {
 			spin_unlock(&cfid->cfid_lock);
 			spin_unlock(&cfids->cfid_list_lock);
-			trace_smb3_open_cached_dir_by_dentry(cfid, dentry->d_name.name,
-							 dentry->d_name.len, 0);
+			trace_smb3_open_cached_dir_by_dentry(cfid,
+					   dentry->d_name.name,
+					   dentry->d_name.len, rc);
 			return rc;
 		}
+		cifs_dbg(FYI, "found a cached file handle by dentry\n");
+		kref_get(&cfid->refcount);
+		*ret_cfid = cfid;
+		cfid->last_access_time = jiffies;
+		rc = 0;
+		spin_unlock(&cfid->cfid_lock);
+		spin_unlock(&cfids->cfid_list_lock);
+		trace_smb3_open_cached_dir_by_dentry(cfid,
+				   dentry->d_name.name,
+				   dentry->d_name.len, rc);
+		return rc;
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	trace_smb3_open_cached_dir_by_dentry(NULL, dentry->d_name.name,
@@ -1715,7 +1774,9 @@ __releases(&cfid->cfids->cfid_list_lock)
 	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
 
 	if (cfid->on_list) {
-		list_del(&cfid->entry);
+		if (cfid->dentry)
+			hlist_del_init(&cfid->dentry_node);
+		rb_erase(&cfid->node, &cfid->cfids->entries);
 		cfid->on_list = false;
 		cfid->cfids->num_entries--;
 	}
@@ -1790,6 +1851,7 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 {
 	struct rb_root *root = &cifs_sb->tlink_tree;
 	struct rb_node *node;
+	struct rb_node *cfid_node;
 	struct cached_fid *cfid;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
@@ -1807,7 +1869,9 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 		if (cfids == NULL)
 			continue;
 		spin_lock(&cfids->cfid_list_lock);
-		list_for_each_entry(cfid, &cfids->entries, entry) {
+		for (cfid_node = rb_first(&cfids->entries);
+		     cfid_node; cfid_node = rb_next(cfid_node)) {
+			cfid = rb_entry(cfid_node, struct cached_fid, node);
 			tmp_list = kmalloc_obj(*tmp_list, GFP_ATOMIC);
 			if (tmp_list == NULL) {
 				/*
@@ -1823,6 +1887,7 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 
 			spin_lock(&cfid->cfid_lock);
 			tmp_list->dentry = cfid->dentry;
+			hlist_del_init(&cfid->dentry_node);
 			cfid->dentry = NULL;
 			spin_unlock(&cfid->cfid_lock);
 
@@ -1850,7 +1915,8 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
 {
 	struct cached_fids *cfids = tcon->cfids;
-	struct cached_fid *cfid, *q;
+	struct cached_fid *cfid;
+	struct rb_node *rb_node = NULL, *next_node = NULL;
 
 	if (cfids == NULL)
 		return;
@@ -1861,8 +1927,14 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
 	 * during this process.
 	 */
 	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-		list_move(&cfid->entry, &cfids->dying);
+	for (rb_node = rb_first(&cfids->entries);
+	     rb_node; rb_node = next_node) {
+		next_node = rb_next(rb_node);
+		cfid = rb_entry(rb_node, struct cached_fid, node);
+		if (cfid->dentry)
+			hlist_del_init(&cfid->dentry_node);
+		rb_erase(rb_node, &cfids->entries);
+		list_add(&cfid->dying_entry, &cfids->dying);
 		cfids->num_entries--;
 		spin_lock(&cfid->cfid_lock);
 		cfid->is_open = false;
@@ -1926,7 +1998,9 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 		return false;
 
 	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry(cfid, &cfids->entries, entry) {
+	for (struct rb_node *rb_node = rb_first(&cfids->entries);
+	     rb_node; rb_node = rb_next(rb_node)) {
+		cfid = rb_entry(rb_node, struct cached_fid, node);
 		spin_lock(&cfid->cfid_lock);
 		if (cfid->has_lease &&
 		    !memcmp(lease_key,
@@ -1939,7 +2013,9 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			 * We found a lease remove it from the list
 			 * so no threads can access it.
 			 */
-			list_del(&cfid->entry);
+			if (cfid->dentry)
+				hlist_del_init(&cfid->dentry_node);
+			rb_erase(rb_node, &cfids->entries);
 			cfid->on_list = false;
 			cfids->num_entries--;
 
@@ -1971,7 +2047,9 @@ static struct cached_fid *init_cached_dir(const char *path)
 
 	INIT_WORK(&cfid->close_work, cached_dir_offload_close);
 	INIT_WORK(&cfid->put_work, cached_dir_put_work);
-	INIT_LIST_HEAD(&cfid->entry);
+	RB_CLEAR_NODE(&cfid->node);
+	INIT_HLIST_NODE(&cfid->dentry_node);
+	INIT_LIST_HEAD(&cfid->dying_entry);
 	INIT_LIST_HEAD(&cfid->dirents.entry_list);
 	mutex_init(&cfid->dirents.de_mutex);
 	mutex_init(&cfid->cfid_open_mutex);
@@ -2026,14 +2104,20 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
 	spin_lock(&cfids->cfid_list_lock);
 	/* move cfids->dying to the local list */
-	list_cut_before(&entry, &cfids->dying, &cfids->dying);
+	list_splice_init(&cfids->dying, &entry);
 
-	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+	for (struct rb_node *rb_node = rb_first(&cfids->entries), *next_node;
+	     rb_node; rb_node = next_node) {
+		next_node = rb_next(rb_node);
+		cfid = rb_entry(rb_node, struct cached_fid, node);
 		spin_lock(&cfid->cfid_lock);
 		if (dir_cache_timeout && cfid->last_access_time &&
 		    time_after(jiffies, cfid->last_access_time + HZ * dir_cache_timeout)) {
 			cfid->on_list = false;
-			list_move(&cfid->entry, &entry);
+			if (cfid->dentry)
+				hlist_del_init(&cfid->dentry_node);
+			rb_erase(rb_node, &cfids->entries);
+			list_add(&cfid->dying_entry, &entry);
 			cfids->num_entries--;
 			if (cfid->has_lease) {
 				/*
@@ -2052,8 +2136,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
-	list_for_each_entry_safe(cfid, q, &entry, entry) {
-		list_del(&cfid->entry);
+	list_for_each_entry_safe(cfid, q, &entry, dying_entry) {
+		list_del(&cfid->dying_entry);
 
 		dput(cfid->dentry);
 		cfid->dentry = NULL;
@@ -2085,7 +2169,13 @@ struct cached_fids *init_cached_dirs(void)
 	if (!cfids)
 		return NULL;
 	spin_lock_init(&cfids->cfid_list_lock);
-	INIT_LIST_HEAD(&cfids->entries);
+	cfids->entries = RB_ROOT;
+	cfids->dentry_ht = kcalloc(1 << CACHED_DIR_DENTRY_HT_BITS,
+				   sizeof(*cfids->dentry_ht), GFP_KERNEL);
+	if (!cfids->dentry_ht) {
+		kfree(cfids);
+		return NULL;
+	}
 	INIT_LIST_HEAD(&cfids->dying);
 
 	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
@@ -2113,25 +2203,34 @@ void free_cached_dirs(struct cached_fids *cfids)
 
 	cancel_delayed_work_sync(&cfids->laundromat_work);
 
+	kfree(cfids->dentry_ht);
+	cfids->dentry_ht = NULL;
+
 	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+	for (struct rb_node *rb_node = rb_first(&cfids->entries), *next_node;
+	     rb_node; rb_node = next_node) {
+		next_node = rb_next(rb_node);
+		cfid = rb_entry(rb_node, struct cached_fid, node);
 		cfid->on_list = false;
+		if (cfid->dentry)
+			hlist_del_init(&cfid->dentry_node);
 		spin_lock(&cfid->cfid_lock);
 		cfid->is_open = false;
 		spin_unlock(&cfid->cfid_lock);
-		list_move(&cfid->entry, &entry);
+		rb_erase(rb_node, &cfids->entries);
+		list_add(&cfid->dying_entry, &entry);
 	}
-	list_for_each_entry_safe(cfid, q, &cfids->dying, entry) {
+	list_for_each_entry_safe(cfid, q, &cfids->dying, dying_entry) {
 		cfid->on_list = false;
 		spin_lock(&cfid->cfid_lock);
 		cfid->is_open = false;
 		spin_unlock(&cfid->cfid_lock);
-		list_move(&cfid->entry, &entry);
+		list_move(&cfid->dying_entry, &entry);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
-	list_for_each_entry_safe(cfid, q, &entry, entry) {
-		list_del(&cfid->entry);
+	list_for_each_entry_safe(cfid, q, &entry, dying_entry) {
+		list_del(&cfid->dying_entry);
 		free_cached_dir(cfid);
 	}
 
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 922646300049..4091fa786761 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -11,6 +11,7 @@
 #include <linux/completion.h>
 #include <linux/build_bug.h>
 #include <linux/list.h>
+#include <linux/rbtree.h>
 #include <linux/netfs.h>
 
 struct cifs_search_info;
@@ -139,7 +140,9 @@ struct cached_dirents {
 };
 
 struct cached_fid {
-	struct list_head entry;
+	struct rb_node node;
+	struct hlist_node dentry_node;
+	struct list_head dying_entry;
 	struct cached_fids *cfids;
 	const char *path;
 	bool has_lease;
@@ -182,7 +185,8 @@ struct cached_fids {
 	 */
 	spinlock_t cfid_list_lock;
 	int num_entries;
-	struct list_head entries;
+	struct rb_root entries;
+	struct hlist_head *dentry_ht;
 	struct list_head dying;
 	struct delayed_work laundromat_work;
 	/* aggregate accounting for all cached dirents under this tcon */
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 131af7333fc5..9240ee6391dd 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -328,7 +328,9 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 						cfids->num_entries,
 						(unsigned long)atomic_long_read(&cfids->total_dirents_entries),
 						(unsigned long long)atomic64_read(&cfids->total_dirents_bytes));
-				list_for_each_entry(cfid, &cfids->entries, entry) {
+				for (struct rb_node *rb_node = rb_first(&cfids->entries);
+				     rb_node; rb_node = rb_next(rb_node)) {
+					cfid = rb_entry(rb_node, struct cached_fid, node);
 					spin_lock(&cfid->cfid_lock);
 					seq_printf(m, "0x%x 0x%llx 0x%llx ",
 						tcon->tid,
-- 
2.53.0

