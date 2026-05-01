Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573043A1684
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634455; cv=none; b=PhU/MVviuoLsE7VbmCqVqTOH0wI+wJ65QeWx0bJMNcHRK2zuRZTkwdL4TEH+3od0G0yEnWDpVJR2r3iiy6XeFlJly4DujyXHLnna04i/ydj8NnAlyZJqVCCbxZ940rd0YhpR0wBaPLKg5QRk9GuPVBtOUhqFNYyQvfSE3t775wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634455; c=relaxed/simple;
	bh=7A6DXbfDYsk+dYivDPkWaiojfYnlGKNJsQIOvSDlQls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YevAS6m4RMfHwwlwUc7OFPTVo41h9niAcOM/DWzn5YlsNfb2eIAVD3Bg1F+Nm8NotyAo+1j9J1A6s2jKPqRRJH7Jp0llUpqsOwjx0IREjPssQcwvdql02GOo3bkr6q/JY+oRgjXJISzIuvr0kpo+xWL51mioo8ROD7i4ZF3xV04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l6ZV99db; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6ZV99db"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-835066ef130so898343b3a.1
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634453; x=1778239253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BY/5y7bF/G0XpGQs/QcZVj1G4/LwsLHtt7BxAwjhkg=;
        b=l6ZV99dbCJYUWU5TTHpu1dMixIOdQNdD6WIZWjSipP1KzV6o6dY1OYdnfon2zTeX01
         dX/+3WRH/nP55rLD1iflV/zC+qmBDn60hqNcPjPmvB+pxlZks4f5W9gHGLAHJmLjsfIq
         KFD1EtPAzHWIe0rpTI8jp+PPat56nm74jdLwYNWnN4uj916Qb4K8nUk7lgcVGzQZXZHU
         OhCn8/HDelgKIkYSE6MNr5rwNLt/3jS7us2t3kyMeg7jwSLK384rIJpLiJMTdwCk0w/B
         hpi4YFxTpsh5YsrA6+NK+m+73+EbWdwE7l74dC6CwXqj1ZcNq0Z5SzGwUP/igT/XLLux
         sCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634453; x=1778239253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8BY/5y7bF/G0XpGQs/QcZVj1G4/LwsLHtt7BxAwjhkg=;
        b=L1y+YfToOlcuCoiQkb/t2JHjEx4/6KBDKYhnwbbm8kQQeDUq4/adEQBmVBAHENakcG
         iiXL5his6P1hPSUqH3cTXLn9Prr11dkaZHJG+cBaax6fgKuZpZxW0Q8xhJBBaFLZl6gt
         rQOj2y+/OlVOP0KbRNJ3rIx/MiIUF0frfVAc6faQr7xa1/atHOWPKGeaYpqP1dDrM2Qv
         fEBtXykUWgFjRamebDlCFiywUKrDayE7lAHnmapCxiP+2bCjJoWXxEYzRHGb0YSCkhl3
         ZoxkEay3Z13eYaXUmabhPOYxH2TSe7JaZWSYHRujSFZfjNolBhkCuGnufosmRUHAROQ4
         UHAg==
X-Gm-Message-State: AOJu0YzzoBaHzruoG97h6UTp14J5a7y9naYHkE4HJC90dRK7Iir+mHnl
	G2Sr+LFI7SI9dk7Et8kgT5vNuosR2wxujIZJhCd6nwTcDuC/eA6XSGe/+EMUPscHYFc=
X-Gm-Gg: AeBDiesQgC4UNlK5YZCRrYN5m1jfQQMg4ePFw7ci6WpC8mesqCDOR9Ij0ruYALKw1zt
	USFhGWxFXIctC+QN2QOrFzjtDTr2Kz8Xa1e02nCiDWKwdzeGYiOlJw74/5m7ij8xi9QFalLpi/Y
	61zDSHB3LuRdnNBfz0TrfmfpVC/Tp97r6O4z7HhiLEwqz0zFrOE0aDFfVJQHqS9dRQBwA3QDJBR
	naSMjsc9lf9PjFRl/uhVKkDao0pvr7IEoDxFiL88THjwAfnOlQSi6rWrBrTOuuRwzapTW2cNMZw
	Csuk8jEI1cDV4ie91oAcZZYbC1M7bjge2QiqAgy1mv2Vt93Bs2wknEEsK5D1UNK+rlCALPv9fib
	P2R5gZgPkYK4Dfobi9kGrCyAYsTnw2G3aWJhIJM9YZp1iucsuA6KHgteVgr3aQW3v6i9EJicUE1
	AOr+56ZuMNGrQItn0Po8+YnoanobrnmFurZ3zbWxQnHEGAMWdILvsUvehCbPFo+wVg
X-Received: by 2002:a05:6a00:3d48:b0:829:9a7b:db84 with SMTP id d2e1a72fcca58-8351a610551mr2745278b3a.49.1777634453183;
        Fri, 01 May 2026 04:20:53 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:52 -0700 (PDT)
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
Subject: [PATCH v4 19/19] cifs: invalidate cached_dirents if population aborted
Date: Fri,  1 May 2026 16:50:22 +0530
Message-ID: <20260501112023.338005-19-sprasad@microsoft.com>
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

