Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920A434404F
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782131; cv=none; b=LiUipFJ5zWRMFzIF2brxrrSi/jP41qleawuKL6AgdsbZAA3vwIYPROBVZrwfC+VIYE88FSfzWYS8qKGnZFFVcf5h37VYO4Ya9epcSUevynTTz1BJUa51gXbb/D8QVgbneCf9qyVriwcFQ/tScGgVJkqzefdXdASi3HBLBjhwXcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782131; c=relaxed/simple;
	bh=QC5s5BDJvB1yz7b92besAYxxi9YZGscztqCPMp8QwPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgkCj4Axxpw4YbkPP8RetV3pVo3h3uXZqcyVaxJ5FA3Jvu4cHdNinqEQDzeMKSSgsrvPZ9D8JmPFPCPY5zUjusaQJMHhCIUULtSIqbaTy8471gllyq89SMZXh8kDAvYTRik6KoQZm6RodpqmuWWyTL8Kd9TizBrEQEzqThGqSRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WNF9JDDR; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WNF9JDDR"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c828daf83e2so2562139a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782130; x=1779386930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0BvF/qC5gYDe1QmCAmWrTDNE8Ed+ZSfcscT2BbVWo4=;
        b=WNF9JDDR10/EiCG99d9vhdDaTLGEy8JFE/MHyGnBdNsWVwTLA+MKUVV83CE4r/eMdS
         D4OXCaTemrMcrMANz4HpWXLVzn1vQ2DXWrKu2wmnKKbN42hrp6VLCKrMCWML0OKM01j5
         419tbDohNA8sHICWgc/K7nTyhcLiWelxbXB+ZBe7MnutVfKtim95ow/5q4vE/XHi2EcW
         kD8PuLhCKIAQtsB7wXrdiKcbcPpGF/Kueoojtxo0DXE3abD16LBeeOYG8VVgdOCFgvxS
         vz4DvEe+Rv8BcNf5EV3OKRiEUkKnBHSQCWh4VRPN6xjSVmLkLHircesecYYAbEb8dNvy
         BjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782130; x=1779386930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f0BvF/qC5gYDe1QmCAmWrTDNE8Ed+ZSfcscT2BbVWo4=;
        b=U4WQkYlf8AWhxQETwLKzkKKMyRGVBuY/4c599/c/RI8oQ5watpe0SpKZSCoGUEg6UT
         bR6OXrYtKGNb2/h1YRbpuAAZLP6wIWXW5T1pMxexbHld+3v1y6DB+9cmQhN6ffvKMMoV
         3AToQPxPACxVzhFEJ3A6Ghvr4sTRTjYPlI8s7F0vVdGAlPjm4+OWfa2f9VdEAq2kD1SR
         xbgAnju4AKpvQiViJZpfuIqNWGuWF8+Hh98MgXlrjVPVRE12MGhVqqMdvhmG/zywnwZ9
         tKUP1QXe4q2lnpAXAFiQ6zo2C6ss+6B2xnKTwZrb5XIyVfwJE1afcYPGG/vlac1UxcXz
         EPpA==
X-Gm-Message-State: AOJu0YxphzcGgWOubl8+KNHbFmmyDrK3f25yT0F2GJQS8NiG8ZwHWsfX
	bLifM7SywJXwVlzJxqF9m9W3Ka7v8xaQW/Rs5ljSv14s5/98XYy8B0X9cntwfYTBSIo=
X-Gm-Gg: Acq92OGu2X16sILjztIM822aViYDBY8KeD629n91QbIepE5s6cv/G2smHnqwF05Sf0h
	p032qB9VSLPzU2CkfJj1woJfKZDpy2MKl8L/eCEekckr/kkdr4Lfou0JRvxdkMmSeO6Utmyd5//
	ehhWOCbWTyYa0XeOIrWkt2IRnWs/25gDDuLw6me48kCnLROMDWJsYW3yAY+G/R90ZknJfpTpOqZ
	KZRKLHFzBrE5KaOJE//Mcu82iz17ESy2LiwzQ/CsXGDnm9vdaNwUeIkoaIwwPd01LNUxJJPkzT2
	jHqkaT2iklRgu0ciNudlQ6N9Ab5J6SDr1EFh8JmM3OFSalI3mIJHD9BGkDJ/W1yEamMQh/5/BkI
	KC3j5jDAzQp9hliXssRURBrGfTF930T7joeq/u4mpU2kBd0qEFd+Xx1R1LMYMjfl8lS90dFjJOY
	cwWiAZBWd897bbZ8n0KV/KEWJrimV9FlnG98OACT79GA0zsfRFc4FrtQ==
X-Received: by 2002:a05:6a20:3d26:b0:3a1:5cce:caa8 with SMTP id adf61e73a8af0-3b22ec587d0mr327030637.41.1778782129712;
        Thu, 14 May 2026 11:08:49 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:49 -0700 (PDT)
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
Subject: [PATCH v5 17/17] cifs: invalidate cached_dirents if population aborted
Date: Thu, 14 May 2026 23:38:23 +0530
Message-ID: <20260514180823.497293-17-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514180823.497293-1-sprasad@microsoft.com>
References: <20260514180823.497293-1-sprasad@microsoft.com>
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

