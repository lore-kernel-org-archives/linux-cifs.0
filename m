Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093A044D001
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392520; cv=none; b=hKwjzah16jooDvREQtAW25hZUthaqgbdsKdKpwhzB3g1WA3ytiirDZoO8Cn/FGyFNf7eG6ad8QeYWjvPwirEg0Q+PMGV9uS9GRAwxrG3HZ2kHrkEuKjuy1EYiNrhJkkk7OvZv+QETrgXRQUtlWxfoU9/LUDgyk4RQuVcRAtCSvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392520; c=relaxed/simple;
	bh=7A6DXbfDYsk+dYivDPkWaiojfYnlGKNJsQIOvSDlQls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tk0w7WwJaT50ODjt5OJd65Y79OQb4QO773GBVzPCUE/KpTnIc0b4C59RfLII08UaG99tHgOSjkqLtGZt9Rg8u+C5E8DfhVn7GKacPjQyYXttHNDC06c5uCQG99Za6xydYGwjdatHHxvTp8AxPrcmEBwCZ057ji1jLfg+NeUFoBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QbVsCVCs; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbVsCVCs"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b2589c26e3so107632255ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392517; x=1777997317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BY/5y7bF/G0XpGQs/QcZVj1G4/LwsLHtt7BxAwjhkg=;
        b=QbVsCVCsoSMEZx5Pwdom2SqLAaHGD6edX79tJQZkzLXjZKl79PmxvjkssUcDeIkhKl
         zmmMPdXLi/Kp5N6G6dxeortB+xGyoLISykrctkxPstfs8hrpaMtHk6quR6gEusdEoPqH
         P2ViXRIDELubebsjJCfci4aZzoflqt0WOmBRu9pBphHa/am+DWHyIDZblek3iHC9+k0o
         OpSzrLNJM4Y5ZG+vHFYkMrKDmSZFgppClyfw32MVKSAuEwc9/HAe0AXw8+DwUg7xYgPb
         sb7ev5XFSZAv74dnW7ewOpd5AamOuM4dNEaSMUTzygJpWiddr9bYTRwWqAWMW3tJ8SER
         WDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392517; x=1777997317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8BY/5y7bF/G0XpGQs/QcZVj1G4/LwsLHtt7BxAwjhkg=;
        b=KlIftQmqPWYWurU1d+uHeBiZ+dCrpiMPEV5m0+VOTd3cc7Zor0QWmKYUdo9Ke5lXhw
         XR345NG0RxVG72QcZs3vstIpkppGNPTxejQKQd5lvowsQZEHFJyY4aZWWZG8WkZsuaPE
         Uv02BCxIth4bHb2QHebal6sqYylAuRhW21AGKf070infgmo5eUNxCJjm3/63hYBsnrDb
         MIKKbmmqjXT66otV7aPQJIzXHMWkJSfoI3xOgHc6hnl90ERwcJckbU6kNpTf5KpVYnby
         20z1Nso7d6+OhQiErbHm7e6g5EVqhtPas+cI1K9txCz5x/mhmpzqj2DsvoxxqNFvWOLo
         AM4Q==
X-Gm-Message-State: AOJu0YwW6rQZUuYGp/lWoaiBBZh+iBqrggJMBye1VQ0ZMZSbcihhxFod
	IcGJqTKj9JkMu7M8NhKJQxCji2zGFUWDrEcQm1e5ctzhyXnyB7nKCP5y6gTX4IRkDhs=
X-Gm-Gg: AeBDiev0IiVm+iURYZfw0mqY5cK5ToVQ3PZgibREGEiWQv5kqd0iRAN0hmEjFlAFUGG
	LJUWmPfYv2ZyCGesMv3Mb1TWj3X0AZl/HFgTuMplfqvwDifsMTAx2SL9NLj2oFt6i0SFAsvR3SX
	GE5msySUfgYkmIbJxTm0r67h7Eatk2JVirk28BC+jak7BhoK/weCY2wC2XV5xwhixBYIP6Ridap
	tUJTg1wy72G6ADbdOsh5T75ezMPgCMil/t6fDQwHAjfKtIILYMVxgGOQdFV8LXOH8H5KIaMqus5
	6rH4S4234DaCogcM/cXAq/LhciWHzvY/CK/vvOUbTQ3D0pHjP8PqnMW22QsTvwgB5xfsLGHzbIb
	ev/rA3MbVxGSn+jdXjLxuE7/LD6id72PSx1NE1p2y3npU0J0kRkK5x3qpA4Ti63LHV9n1DnYTyd
	rlnIKNQzsQvBEosJyp4+z7CF35ZlXhkZ7vNkN1DHYpEsCWDgSwoDakM/wgeSTUN1+m
X-Received: by 2002:a17:902:f70e:b0:2b0:ac1e:9720 with SMTP id d9443c01a7336-2b98744708fmr423335ad.23.1777392516916;
        Tue, 28 Apr 2026 09:08:36 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:36 -0700 (PDT)
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
Subject: [PATCH v3 19/19] cifs: invalidate cached_dirents if population aborted
Date: Tue, 28 Apr 2026 21:38:04 +0530
Message-ID: <20260428160804.281745-19-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428160804.281745-1-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

In order to make sure that parallel readdirs do not populate
the cfid->cached_dirents, only the first readdir is given
"ownership" of populating cached_dirents. However, if the
next readdir on the same FD never arrives, we will always
miss the dirent cache.

This change introduces a 10-second timeout which will be used
by laundromat thread to check if the cached_dirents can be
invalidated. Ten seconds is a long enough interval between
successive readdir calls.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 65 ++++++++++++++++++++++++++++++++++----
 fs/smb/client/cached_dir.h |  1 +
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 14c87ac1a4ad4..b626045745ca2 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -23,12 +23,18 @@ static void cfids_laundromat_worker(struct work_struct *work);
 
 #define CACHED_DIRENT_HASH_BITS	7
 #define CACHED_DIR_DENTRY_HT_BITS	8
+#define CACHED_DIR_POPULATE_TIMEOUT	10
 
 struct cached_dir_dentry {
 	struct list_head entry;
 	struct dentry *dentry;
 };
 
+struct cached_dir_invalidate_entry {
+	struct list_head entry;
+	struct cached_fid *cfid;
+};
+
 /* Generic helpers */
 bool cached_dir_is_valid(struct cached_fid *cfid)
 {
@@ -496,6 +502,7 @@ static void fail_cached_dir_locked(struct cached_dirents *cde)
 	 * can claim this slot and repopulate the cache.
 	 */
 	cde->file = NULL;
+	cde->last_populate_time = 0;
 }
 
 /* insert cached_dirent into lookup hashtable */
@@ -799,6 +806,7 @@ bool emit_cached_dir_if_valid(struct cached_fid *cfid,
 		cfid->dirents.file = file;
 		cfid->dirents.dir_inode = file_inode(file);
 		cfid->dirents.pos = 2;
+		cfid->dirents.last_populate_time = jiffies;
 		cached_dir_reset_insert_cursor_locked(&cfid->dirents);
 		/*
 		 * A previous population attempt may have failed and left
@@ -851,6 +859,28 @@ static void finished_cached_dirents_count(struct cached_dirents *cde,
 		cached_mapping->folio_is_eof = 1;
 
 	cde->is_valid = 1;
+	cde->last_populate_time = 0;
+}
+
+static void maybe_invalidate_stale_cached_dirents(struct cached_fid *cfid)
+{
+	struct cached_dirents *cde = &cfid->dirents;
+
+	mutex_lock(&cde->de_mutex);
+	if (cde->last_populate_time && !cde->is_valid && !cde->is_failed &&
+	    cde->file &&
+	    time_after(jiffies,
+		       cde->last_populate_time + HZ * CACHED_DIR_POPULATE_TIMEOUT))
+		fail_cached_dir_locked(cde);
+	mutex_unlock(&cde->de_mutex);
+}
+
+static unsigned long cached_dir_laundromat_interval_seconds(void)
+{
+	if (!dir_cache_timeout)
+		return CACHED_DIR_POPULATE_TIMEOUT;
+
+	return min_t(unsigned int, dir_cache_timeout, CACHED_DIR_POPULATE_TIMEOUT);
 }
 
 /* update the cached_dirent for a given name in list */
@@ -992,6 +1022,8 @@ bool add_to_cached_dir(struct cached_fid *cfid,
 	old_bytes = cfid->dirents.bytes_used;
 	added = add_cached_dirent(&cfid->dirents, ctx, name, namelen,
 				  fattr, file);
+	if (added)
+		cfid->dirents.last_populate_time = jiffies;
 	new_entries = cfid->dirents.entries_count;
 	new_bytes = cfid->dirents.bytes_used;
 	mutex_unlock(&cfid->dirents.de_mutex);
@@ -2111,7 +2143,9 @@ static void cfids_laundromat_worker(struct work_struct *work)
 {
 	struct cached_fids *cfids;
 	struct cached_fid *cfid, *q;
+	struct cached_dir_invalidate_entry *inv, *inv_q;
 	LIST_HEAD(entry);
+	LIST_HEAD(invalidate_list);
 
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
 
@@ -2121,6 +2155,9 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
 	for (struct rb_node *rb_node = rb_first(&cfids->entries), *next_node;
 	     rb_node; rb_node = next_node) {
+		struct cached_dir_invalidate_entry *inv_ent;
+		unsigned long last_populate_time;
+
 		next_node = rb_next(rb_node);
 		cfid = rb_entry(rb_node, struct cached_fid, node);
 		spin_lock(&cfid->cfid_lock);
@@ -2144,11 +2181,29 @@ static void cfids_laundromat_worker(struct work_struct *work)
 				kref_get(&cfid->refcount);
 			}
 		} else {
+			last_populate_time = READ_ONCE(cfid->dirents.last_populate_time);
+			if (last_populate_time &&
+			    time_after(jiffies,
+				       last_populate_time + HZ * CACHED_DIR_POPULATE_TIMEOUT)) {
+				inv_ent = kmalloc_obj(*inv_ent, GFP_ATOMIC);
+				if (inv_ent) {
+					kref_get(&cfid->refcount);
+					inv_ent->cfid = cfid;
+					list_add_tail(&inv_ent->entry, &invalidate_list);
+				}
+			}
 			spin_unlock(&cfid->cfid_lock);
 		}
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
+	list_for_each_entry_safe(inv, inv_q, &invalidate_list, entry) {
+		list_del(&inv->entry);
+		maybe_invalidate_stale_cached_dirents(inv->cfid);
+		close_cached_dir(inv->cfid);
+		kfree(inv);
+	}
+
 	list_for_each_entry_safe(cfid, q, &entry, dying_entry) {
 		list_del(&cfid->dying_entry);
 
@@ -2169,9 +2224,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			 */
 			close_cached_dir(cfid);
 	}
-	if (dir_cache_timeout)
-		queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
-				   dir_cache_timeout * HZ);
+	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
+			   cached_dir_laundromat_interval_seconds() * HZ);
 }
 
 struct cached_fids *init_cached_dirs(void)
@@ -2192,9 +2246,8 @@ struct cached_fids *init_cached_dirs(void)
 	INIT_LIST_HEAD(&cfids->dying);
 
 	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
-	if (dir_cache_timeout)
-		queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
-				   dir_cache_timeout * HZ);
+	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
+			   cached_dir_laundromat_interval_seconds() * HZ);
 
 	atomic_long_set(&cfids->total_dirents_entries, 0);
 	atomic64_set(&cfids->total_dirents_bytes, 0);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 58dde9452ec9b..eca0a0ca3674c 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -120,6 +120,7 @@ struct cached_dirents {
 	struct inode *dir_inode;
 	struct mutex de_mutex;
 	loff_t pos;		 /* Expected ctx->pos */
+	unsigned long last_populate_time; /* jiffies of last successful populate progress */
 	struct folio_queue *folioq;
 	struct list_head entry_list;
 	unsigned int entry_list_count;
-- 
2.43.0

