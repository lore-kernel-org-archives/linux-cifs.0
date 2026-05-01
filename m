Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C26C39FCB4
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634454; cv=none; b=LOTmxb+AH7z3SbhdFlopVCEg5pRjybKu29hwP1tyLZpDny93e8TQ4JoSdtvjqdzQBXK89mrZiugprKjgACkOR0VA1muBclBYPviT4XHn2BNQ8jBlhk+uQM7tFvPdHSu/tdI3VlEpq1+36Mw4JDT9s0Yopi1aovYJYMBI1k946N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634454; c=relaxed/simple;
	bh=o0N32qWfdGxLwXjkbDqAtu2/BBJadb3qdMdCxb+FO28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQh+v0XsW5fImpGBedOsiTAUN0X+TvbnChWrJo/8nk92Ie2yOzpZur9Rmmbq50oNcRayiVUoBIOaLhQeboNr69vxFBcQ85br2WY2teW/+BVuVFy6Lg3n+Q8kdUb6tuO0vBjH1Dhf8Vwh6rk/X+KGh3i8sDdahobt1WKRhpWzFPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YpBsV6lK; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YpBsV6lK"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82fbf5d4dc2so1339977b3a.1
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634452; x=1778239252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGsmBdudK7tseR2Ysem6WDL8rrBZQlqIDRvGpYGz1FQ=;
        b=YpBsV6lKNo7VgV4PUp9lknUvPCR9ZH/3aaTTHDENJzlNO+SV/9S+jerOKvyGI2ovCn
         0qiuqOQfg38B0pdcL0zSzMtBaqbXKahdkyeJgAxqANt9gUsqwfAnj0lu8RLXriuIxmOm
         q0O8SssdI4VuTtezaUclmD3z7QvqADg9EdBLeOl805uWB0kCvV6t3n0uNSL/AZqPQxRk
         zXQ71zvULFF2YBKHLIv2UZxGXjKC92N7kuB0FQI2pJC3lga5oZB67TKlJsR1LBGJXLCU
         Gy12e5C76Fc8b27AFXA17QSsiCCPfrDmG300tbZ8RRfRDkqgxL6UV81dg100eSZ7duBq
         JZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634452; x=1778239252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pGsmBdudK7tseR2Ysem6WDL8rrBZQlqIDRvGpYGz1FQ=;
        b=D8Ua3fyuYuTBiJTiChD9S2JBR6vpihNhZHCKwNK+SmVC73ine+hvyQgQ+V8z883TmG
         8CkzUFQDM0OWT75LjeaJmb6lcqBeXO7hQRbphkPKBXCty3bRQj0YChGwLe2y04AkjkXu
         0gOUxqhVI1w0gX57OK/w6lubM/uAaUfXm5RhS5kRjfWsKtm1AK8hPSByCh0/pDt0kbad
         QoqAGPNy19qz4kZVhFm0TQykw1lxyJ5eHaN3vIas6/WA8ujPjkpAo/7rcukTMhWdW1Nt
         B82GLqli/MXOXt54sOxqlzNjHwYWx0PFcDFxN9EOqjhRrvhjeNauAzp4sFnKzR5xPoJ1
         wt0Q==
X-Gm-Message-State: AOJu0YzdAFQeQV5IW0YoEjzZytrT95Qc+0e8NhNQ0YETKda6ElOA+i7j
	ApTM37YcCJSPHkMwDS4lvZu8t+v4xdehX64v+9UQc3c6sfmSqtbxWwInRYV24aJVgHo=
X-Gm-Gg: AeBDieujQ3wzDcpJUXEeDDyvhT9Vw0M7k/AoayF0/8i9VAWN5xKrP7ma8T+5mNAV413
	vDc9xpmWaVHje0glc39358Jcp9WTwbyT45hySZ5AMdB6MEMpiB2UZR/AZz+LKpSk4ggIpoNw3jZ
	6v8iU84vRvlbr7TYDWGUPqtYEms8AxgvfoP10kgLQcqPoisvWN7G1YdzRj2+W+boCGRJi2gvQgS
	byzE13AtbPCHQ30umamlxncOxSGDkunl3L/X+pWwig1kBwLajmlaMR7wts1JrbHlDxppN4p0DDc
	9/iSCMvUjMKqC1YT/BvvTbgHJiiRFF/rSVxWKH+m8NRNfJucHNeH++doa5CcdMcOr8bmVUdp+tt
	+7J/dAU9CBymxMH1yMzvl5/bYnvXlfNwcJXznXCBARnLkT2qi9L6khA5ZfHcz5rP33ZyUXTLIic
	HsLcoa+eimf3t+Vu76rO7spf9C/Mt3ihcLNAWIwtgsWj2p8anouUoc6DSPt+2OuVWD
X-Received: by 2002:a05:6a00:2d1a:b0:82f:5571:1a92 with SMTP id d2e1a72fcca58-834fdb0e9b3mr7812151b3a.7.1777634452224;
        Fri, 01 May 2026 04:20:52 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:51 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v4 18/19] cifs: keep cfids in rbtree for efficient lookups
Date: Fri,  1 May 2026 16:50:21 +0530
Message-ID: <20260501112023.338005-18-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
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
index 6fb88c4c97dc1..14c87ac1a4ad4 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -22,6 +22,7 @@ static void smb2_close_cached_fid(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
 
 #define CACHED_DIRENT_HASH_BITS	7
+#define CACHED_DIR_DENTRY_HT_BITS	8
 
 struct cached_dir_dentry {
 	struct list_head entry;
@@ -1240,6 +1241,57 @@ int cifs_wait_for_pending_dcache(struct cached_fid *cfid,
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
@@ -1247,22 +1299,21 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
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
 void invalidate_all_cached_dirs_nowait(struct cifs_tcon *tcon)
 {
 	struct cached_fids *cfids = tcon->cfids;
-	struct cached_fid *cfid, *q;
+	struct cached_fid *cfid;
+	struct rb_node *rb_node = NULL, *next_node = NULL;
 
 	if (cfids == NULL)
 		return;
@@ -1861,8 +1927,14 @@ void invalidate_all_cached_dirs_nowait(struct cifs_tcon *tcon)
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
@@ -1939,7 +2011,9 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 		return false;
 
 	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry(cfid, &cfids->entries, entry) {
+	for (struct rb_node *rb_node = rb_first(&cfids->entries);
+	     rb_node; rb_node = rb_next(rb_node)) {
+		cfid = rb_entry(rb_node, struct cached_fid, node);
 		spin_lock(&cfid->cfid_lock);
 		if (cfid->has_lease &&
 		    !memcmp(lease_key,
@@ -1952,7 +2026,9 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			 * We found a lease remove it from the list
 			 * so no threads can access it.
 			 */
-			list_del(&cfid->entry);
+			if (cfid->dentry)
+				hlist_del_init(&cfid->dentry_node);
+			rb_erase(rb_node, &cfids->entries);
 			cfid->on_list = false;
 			cfids->num_entries--;
 
@@ -1984,7 +2060,9 @@ static struct cached_fid *init_cached_dir(const char *path)
 
 	INIT_WORK(&cfid->close_work, cached_dir_offload_close);
 	INIT_WORK(&cfid->put_work, cached_dir_put_work);
-	INIT_LIST_HEAD(&cfid->entry);
+	RB_CLEAR_NODE(&cfid->node);
+	INIT_HLIST_NODE(&cfid->dentry_node);
+	INIT_LIST_HEAD(&cfid->dying_entry);
 	INIT_LIST_HEAD(&cfid->dirents.entry_list);
 	mutex_init(&cfid->dirents.de_mutex);
 	mutex_init(&cfid->cfid_open_mutex);
@@ -2039,14 +2117,20 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
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
@@ -2065,8 +2149,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
-	list_for_each_entry_safe(cfid, q, &entry, entry) {
-		list_del(&cfid->entry);
+	list_for_each_entry_safe(cfid, q, &entry, dying_entry) {
+		list_del(&cfid->dying_entry);
 
 		dput(cfid->dentry);
 		cfid->dentry = NULL;
@@ -2098,7 +2182,13 @@ struct cached_fids *init_cached_dirs(void)
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
@@ -2126,25 +2216,34 @@ void free_cached_dirs(struct cached_fids *cfids)
 
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
index 0726f25b9144a..58dde9452ec9b 100644
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
@@ -181,7 +184,8 @@ struct cached_fids {
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
index cc7d26a3917c5..81908679a11e3 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -326,7 +326,9 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
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
2.43.0

