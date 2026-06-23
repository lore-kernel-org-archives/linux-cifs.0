Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F5E35675B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246051; cv=none; b=hAoLTQtyvSF5DKTRVndtueaCbJxH7Mt35RTEdnIhyX9dXXlJOwwHRNMIs6Jt85xnJm3YDs8S1SVCtbzU5q/T+Dy4Qn+/Yl5NJIdgBTd69w+QoV4Zn97Kq4ZqcY/RzUJvgqAaqy1jwkcgBB0dk1SAgAO97wIP974BXniGqz3lPjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246051; c=relaxed/simple;
	bh=Byeoh6CmqwdWBwKJYA8PJbrKwc70qcCicGmtlyRAH+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=at460kG1/7vwwGl0yeoEkQprJILTSXe4+esRd+M13a7HsaYvS10QdcvxXov96TnErhW0AJ8ejgWccJFYoYOb0vtpF4mZtK6nYYR6e7omRXzZNH7xKpkTYmsHdclyie4CfZ+pZ6Bc+s8HVBEFf2iGJEH8aV8wIg/DT2/lbN46FL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lpx595rQ; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lpx595rQ"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-69d862236ddso193936eaf.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246049; x=1782850849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/tW96VqVk7qPuZnPkgv5sqWYvy87zmmEWceC1BmnJHk=;
        b=Lpx595rQhFYq6nBn4sMsEjArtq9waVijPt3aod3dpe36SdbUpStBfMnjxw6G+1feqX
         T/Py9HeJprfh3htBH9tgigEhF3F5/kxRBDrUeCOZ3ctPi6lXOhq1O+BwBJ21HauhQ6gd
         /JrZG7BtduHpp5BQoFq0WY7bRG1nGkRjcQ2tR7KZJ9kaLaT1as9FzASn4UgZbqkMHqDQ
         eqtcC0AZ04PpbrDmW8SM7h2PFUSvk8QLiIgTuJopqi2Aki21cEuOvewjn0rG5z0kDmID
         QB7lTTkeOsoMfhjzkWO04PQyoUGd6n9RUxcxaUn1N8xgG88VNPoUlXXv1MBnBiP/6LB6
         vhOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246049; x=1782850849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/tW96VqVk7qPuZnPkgv5sqWYvy87zmmEWceC1BmnJHk=;
        b=COb0Kp7wDA9IEwaUOZsWiQ1dSnuMLnvMK0a7t6sI8Duw2bAB56BX5SqrxHieJDyMsa
         +npk4K6dtYp31AWclzvzjmMTL7zWVLnZ+ti1FUeyAS0vtAx0myQDEVTQr7OQb2vVc8fy
         BaWb+tgcKHe1e8Z9O+KCj5cOLynYkp6i5ahxiIAfcPvs58Jw3KsGMZ8+iCQbOtH/0PhD
         7L9/1tCf9hfJkxU+mKgDNLkHj6OSRivaxzle8pF1hOmQyzpDityZHngHWiXhS7pk/3t+
         Il3gWdMnk/SvW8O30H2DkDaDsK+qmth4OIgw81sHbYnCKl6HiDUjMBMoJ/dOU0F7GUUH
         lROA==
X-Gm-Message-State: AOJu0Yw+eBmsm5Azx3h73ijOsSwjGEkl2OIwwU4jAtEyUjshGwX3rmVd
	WWDOb97nnLqlpKhYgvw+sAnzr4CmR04cLWlCK9JTWwnhrT29Zl2rcxy9QoZ/wDEn
X-Gm-Gg: AfdE7clQPkD0Y04BS17lA4ez5ZZaBVDfVc621ejhd91SymprW8cQypBZ96L8UNew4Bq
	eYkJBva/8YwEa5SQsu13wfM5QkTT0OE/GMOotumI54ooRCt23XcEeGN8IdeJS3RhLGlut+YRkhz
	3FGVQtoeyzHiTciue+nyOvmADLgFYAPXfxAuDeAQwDc/wzrVmTmlByG8LEhDbsg/hYI0i2tC1vO
	Cvh6t6G5sW9OqDimTOAxecy6jeSK+9i7V+etrU3KnTOkZAvLsTq3VrLo3rb3E+iDqUlghRs/GTm
	JxXEE8tupcU0GZmOa/UV7WIDZ7dmt3fQHzYjsrbnjEQvRducMSzkOZGHonn0LDLhrMYXrX9HvPl
	EOBCFzo3917bOFnz5I1sNSBAvHv9B+vnGFm+flSNFmowL1q4zhX3FeS/Mzp1LqfGtwj0eIpKr4U
	P/9u/ejsBx1yQ0kr4Sv+hffmkgfaOTYqcmTB/iu9duJ5qdH3841oA5R0yEvJsFhVgq4GI3kFzVg
	nj++E3E+f8HOjC/hu0/wPzH46DzAphmTjv+9TShmQ1uiCz+2oCxaFUh/1mVJT0nXCzQPniz8ymV
	2iBaEdZC8e7gqbgYxUH0tImm+a0=
X-Received: by 2002:a05:6820:81c1:b0:6a0:f200:2545 with SMTP id 006d021491bc7-6a12304b156mr189080eaf.46.1782246049383;
        Tue, 23 Jun 2026 13:20:49 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:48 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 16/16] cifs: invalidate cached_dirents if population aborted
Date: Tue, 23 Jun 2026 15:13:43 -0500
Message-ID: <20260623201344.2043841-16-stfrench@microsoft.com>
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
index 3cf4cfa23c37..fa1ebc713247 100644
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
index 4091fa786761..b41d157ec2f0 100644
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
2.53.0

