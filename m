Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E78317145
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232182; cv=none; b=K+8E+cN2Kh+Q8Efn5RD/pjZ2itPV7lSAp5Pv/w01icZv3bYAwUmHgCokGuxVJ4nqyqubCxZ9R1U4ip/bpFzpVgjN0N/bVRHOmrvUy64SQVStrEwrHL+nSEE0FKGopX2tVhYM84rqLI1qf8ip2AG/Aqcn3kjnf913/RCIcwj/XKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232182; c=relaxed/simple;
	bh=QC5s5BDJvB1yz7b92besAYxxi9YZGscztqCPMp8QwPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNpaowyCQm36cZRU1kd6n/PEwZrdqcVZc1aJUriGhPmURyssmCkKXAfwKCcPMyFBwppfhGuhJ8LMmntZjk01AZKxbYqcDLViYm0jZLnyDOhoDGVBTvUtop/Pi6MgVkGXkwVCtFyTsBGYXGmOwRhYtUVovzYXntdyw+07tB0e6MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RYS+/JTX; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYS+/JTX"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c0aa420401so149505ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782232180; x=1782836980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0BvF/qC5gYDe1QmCAmWrTDNE8Ed+ZSfcscT2BbVWo4=;
        b=RYS+/JTXLffOVgFoIhT8+Un+9eR73AKN1MeSnp+P1SOaUSZFmpi32BpoHxNGPbPPov
         Rp/yEc79D3FEyMOHJnNtsI7dAqDdc0QUCWTwKlsc/p29VE0OjYNg2ZVrxA6JQHfeWW1y
         V4GXJq5aHNkmRlLS/tBgVERecwrR/J0mFjXSGtI65lwqM1eWrhSn+InOCczEU2y00xg7
         Gy5cLrR5QaRBifn1I6oIZWDxy8UgUmxp9UCG8y2Lk3h1Swyrnqj/vvZs9mEHTDQLqXhR
         KVQjX0oju6W7fTkk2qM/tSqoBhUnf9HsV+ymAGlTFThvfnFpZoUds0HVuSPmt0fEfc3B
         8Lww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232180; x=1782836980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f0BvF/qC5gYDe1QmCAmWrTDNE8Ed+ZSfcscT2BbVWo4=;
        b=K8e9N54PtbVQlEKrsKvNPg7u2Qko4MKWws7uR6olR36yWspARWhYj3+IYUy8+JMVjg
         yXlCvS/yujvXA9SxTyyayIemsu7dRCsD/vGsVCEvjV+Exd/Ra3sg9emVCjp3SHkrhdk/
         cerVrpQoANkNIwCE/n9aMfl3espGFQl5wd1RbIZMZU/HGAjUPuN6ZPKywmiPqyN2IQEF
         q0cnqsJmVjp7fFHTOjfHB0ug/Tk2p4XgfJz7ncryDAWkgWylYBzB7aTXBs5IDDjK4PEH
         5dkgM1H9IdL3rctycT4GWEBKT1Ef85PnaqI2yYS6HoGdbAOzj4PNSNzB0OJs4XnIwRv2
         J5TA==
X-Gm-Message-State: AOJu0YyPoDeog6he3oQTcdDtUnFbJg7pxzaqDVd1bHka+6NxyV/yalYu
	aoH6IJfPviXuQ7qRUDjp38QaunTnled3fDTWZcRIBSywk5MyJRoleIznc/0tlRrq0EY=
X-Gm-Gg: AfdE7ckD0m6j56pVXCTYrpiJk19tjsGhmeiX0oXtxbjw+/8UKdJQW2da+eytLr9hYDt
	btOtz4OVx21U2mUIaL2lzD49NLdZ3nsK4suPYK0BP9Qv3HZBBHGYUb38GbuDfOn8wfx+ZC0CTe0
	b+/kTPI9ApbrsK5OfIbopq8a3YG+gEvmsghEm9rPVNjxudsqI0cOji33ViZDFK8aXNBs9hC6QT1
	E+6bOqsRWMFyQypbo/dLFgaliPP2zO5OetwAChKcCbAsmdaNyJuDi+6vAIyAFLpXVb5vrRuKV9f
	TADBoBrE0rh7+5iVgLcL2ygYT3pCWldvjSCZXrUpu9wtUhdF1xsuyu8EMc/0126v88AYUCke8Ju
	LtWgCZBPZo1fU4IzywrEAUzMUMgmVHf+Ac2mCXmnuyidS/xgxHP14vx375iF0gil06CONjpN2fJ
	p90mmm10jY7uUk9UBBfdyRxrBY1Qg9/iPzLbAELNkND8wcSbq3vFH3pA==
X-Received: by 2002:a17:902:ebc3:b0:2bf:dd8b:7cd with SMTP id d9443c01a7336-2c7c75c4046mr41481805ad.10.1782232179991;
        Tue, 23 Jun 2026 09:29:39 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfdc97sm135185485ad.65.2026.06.23.09.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:29:39 -0700 (PDT)
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
Subject: [PATCH v6 17/17] cifs: invalidate cached_dirents if population aborted
Date: Tue, 23 Jun 2026 21:59:10 +0530
Message-ID: <20260623162910.343930-17-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623162910.343930-1-sprasad@microsoft.com>
References: <20260623162910.343930-1-sprasad@microsoft.com>
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
index 3cf4cfa23c377..fa1ebc7132475 100644
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
@@ -2098,7 +2130,9 @@ static void cfids_laundromat_worker(struct work_struct *work)
 {
 	struct cached_fids *cfids;
 	struct cached_fid *cfid, *q;
+	struct cached_dir_invalidate_entry *inv, *inv_q;
 	LIST_HEAD(entry);
+	LIST_HEAD(invalidate_list);
 
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
 
@@ -2108,6 +2142,9 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
 	for (struct rb_node *rb_node = rb_first(&cfids->entries), *next_node;
 	     rb_node; rb_node = next_node) {
+		struct cached_dir_invalidate_entry *inv_ent;
+		unsigned long last_populate_time;
+
 		next_node = rb_next(rb_node);
 		cfid = rb_entry(rb_node, struct cached_fid, node);
 		spin_lock(&cfid->cfid_lock);
@@ -2131,11 +2168,29 @@ static void cfids_laundromat_worker(struct work_struct *work)
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
 
@@ -2156,9 +2211,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
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
@@ -2179,9 +2233,8 @@ struct cached_fids *init_cached_dirs(void)
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
index 4091fa7867618..b41d157ec2f08 100644
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

