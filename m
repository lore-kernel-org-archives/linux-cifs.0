Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6703436405A
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 07:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607143; cv=none; b=Fukbyu0l9uLUk6afW3YYe9PFvNwqwLyDdTA5xX8buhQEWLrcXoV4epf7+ZQPDf2sZncz7ziI+hVYr5S1DsJRrC7xndqobmlNoF5LlrVsEGGtouOmiBcDIpjull6ikB8otC+6JiTqYCEGWgK46tV4cCXYjRSffURodVjDjGyqxs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607143; c=relaxed/simple;
	bh=QFlXdWE2HiSletRwOxEfg2RVbKkmwnYSs04xKaKXE6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+DjADCpJTQTUYMs0UKu24YGiaw8v8QHeBMdpkVVji8UlV+qshQz5j5Exgs2x4v8T1TUfJcNIqHl7w1YfP3jmfzHepG4HSWnboNiE+wu62+X0/f3JISJom4qeT8zgTxjHNQ9voDBYxbY3kN/KBYX/C63m/hWBB82fROY0UgZzn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQxb1zOK; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQxb1zOK"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cbee846deecso1696303a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 00:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607141; x=1787211941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jRyBp4azLRYDtuZXmLZjg7k4fYuxAWuRZTjPkBtnP4E=;
        b=PQxb1zOKrZWTShhLVbK8SRxGsg0aaNnfMgh7Vw1rvW7XMuw1YXky0AF5WOYi/SiL2P
         tT+/8G8GYC/mgYqvKYrJ5rgzsIGl8fcgX/RP6GjPxxZ4LTHmtBXf74x2ITbRRdtXZyC9
         uApKW9rzTiWXKHLTTdfFBcpYe4kiRd5Fd2KhfxXrTGT2Z1QCQ0BNDaW8ACaqx0suHZAB
         0FLYeJowbQYiM7izVN2xZWqEdeRVyFMlb4x4Ex3jan5CrAYicVzpkoHxyngg7AOEy1R2
         fKd4vKmcUoURfjObLBTE9Te8rBgcEQ/n9KPyLYZrVAi5Tm8qWKaGwVtMktwd4Td30zTO
         FQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607141; x=1787211941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jRyBp4azLRYDtuZXmLZjg7k4fYuxAWuRZTjPkBtnP4E=;
        b=Y3NNPWugU2CGqDchQqVtWzmca9iO07OUrUBvVipBI//FVvaMOYdU0O1eBhkOK+Xl7O
         RdtCTZ7naItDRnSksDZM0iomb1JPHB9ywTO6yxIbWTHISSJqe+VFFmBH/5FWcWdZdzHv
         ypEU3DtSPkDUIwLrUkAkSZvXId5/czDFj8daWnszhhNkBnGwjAawE+oL/3O2Hu/KnAvh
         Bn0rX95XUsBqIkxDIWhH0UGri6UMQPKqkMh7lOzOSbybpw3ewExb/vJvuLJ0mmV6ZmOJ
         RdTdZzlz3XnZ61Hd8v2DsRRJ7Lg/VyRnANlCwiED+2fQOvcJoJC4R0q4z8bAtklCfqyc
         F4Lg==
X-Forwarded-Encrypted: i=1; AHgh+RorklpygKwpa3Byl3J1dgFJZ4FpynD1HgNh1cdPG4bf7pvkC2zewtpLQboKpPNHRqJh+lIHfqL7QpJi@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgv+J3Qc1H/bOSvSVoFFt1mL4C44Zu0RLb2QmHvjdrUp2StB3Y
	GJ1mRydyewr/OCTVpXtxlsVMLXnWsXgyFFxTxoBMHnXRLIDvBQAw9wZ6
X-Gm-Gg: AR+sD10srmhqZ0lDaOTGLibsYsrRyDVvvH08l0qq5dZ9F729kr3SNayHFRMLhcmSvgK
	ZYm55vfDIBUcJaL/O0AJBDEYo9MT+Mh6Tst6cIfsot4jKiihtdHwobou3b9aEPLnlZ/tYc88sak
	hGrDIfYuYxQS7qXjOY2zr6wUNQcsfh3D7/2YDWMkhWKxXhKY8fPIRff5/+IZCESO2D2qi7EEczW
	tRpqm+7SARCJi9USxEykxT/6tiSvLAltILyvOUe32EAF7pUyoqWZ4JjgYdClwBsSTN2m+OwE6Vj
	2k7cM9AhLhJK9kAFDzJ+laqsOtRl3YKn2zELMk6v720GxkqT1EALM4QPMZyaSCGzLFzEhbo3kzQ
	zF0Rmt+CDH8nwDmKU+y1uKygh1LCNGdwMabqbFF3xC1bL7oOWBCx3Mft+ZsemiKcFr4Ja7TyTxV
	DLcdYGdoF8bvTV4FbPN2cIqseOujcwDBMJnU4p68XCO9PJgM4zLe88JgisxUMSUN6GXisFP41R4
	X1IsPSgp6PGQIO8LFdHzQ7Ww55FKZ6U8D0QhjoW/kNRQXt6sFZS/hP+2gvxS8ZixSRdRj05dAgO
	2MqwNG+lzuH4AnQ+
X-Received: by 2002:a05:6a21:389:b0:3c3:935a:af2c with SMTP id adf61e73a8af0-3cc54f4a0f8mr5641057637.3.1786607140572;
        Thu, 13 Aug 2026 00:45:40 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ec022acabsm4587594eec.27.2026.08.13.00.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:45:40 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 7/7] smb: client: allow nolease option to be reconfigured on remount
Date: Thu, 13 Aug 2026 07:45:17 +0000
Message-ID: <20260813074517.607275-8-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813074517.607275-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Changing nolease via remount is silently accepted but has no effect:
the value is never propagated to the live tcons, and state from before
the switch keeps using the old behavior.

Make nolease take effect on remount:

 - Add smb3_sync_tcon_opts(), called from smb3_reconfigure() after the
   context is updated, to propagate ctx->no_lease to every tcon under
   the superblock (walking tlink_tree under tlink_tree_lock) so future
   opens honor the new setting.

 - On switch to nolease, drop deferred file handles via
   cifs_close_all_deferred_files_sb() and evict cached directory fids
   via the new invalidate_all_cached_dirs_sb(), since each holds a
   lease.

invalidate_all_cached_dirs() gains a close_handles argument: the live
remount passes true so smb2_close_cached_fid() actually sends
SMB2_close to release the server-side directory handle and lease; the
session-loss/teardown callers pass false, keeping their old behavior.
invalidate_all_cached_dirs_sb() counts the tcons under the lock,
allocates the pointer array with GFP_KERNEL outside it, then re-takes
the lock to collect a reference on each tcon and invalidates outside
the lock (it can sleep).

Move tcon->no_lease out of the bitfield into a plain bool: as a
runtime writer it would otherwise share a word with need_reconnect/
need_reopen_files, and a bitfield read-modify-write could clobber a
concurrent lockless update of those.

Existing open handles keep their leases until the server breaks them or
userspace closes the file -- nolease only governs new opens.

Not addressed here (pre-existing, unrelated to nolease):
cached_dir_lease_break() updates tcon->tc_count without tc_lock;
cfids_laundromat_worker() can resurrect a tcon from tc_count 0 without
a TID_EXITING check, racing cifs_put_tcon(); and the cifs_debug dirs
knob still invalidates with close_handles=false.  These are left for
separate changes.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cached_dir.c | 83 ++++++++++++++++++++++++++++++++++----
 fs/smb/client/cached_dir.h |  4 +-
 fs/smb/client/cifs_debug.c |  2 +-
 fs/smb/client/cifsglob.h   |  2 +-
 fs/smb/client/file.c       |  2 +-
 fs/smb/client/fs_context.c | 54 +++++++++++++++++++++++++
 fs/smb/client/smb2pdu.c    |  2 +-
 fs/smb/client/trace.h      |  2 +
 8 files changed, 139 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 88d5e9a32f28..3968e4f074a8 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -598,10 +598,17 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 }
 
 /*
- * Invalidate all cached dirs when a TCON has been reset
- * due to a session loss.
+ * Invalidate all cached dirs on a TCON, moving them to the dying list
+ * for the laundromat to clean up.
+ *
+ * @close_handles: if true, the connection is still live (e.g. remount),
+ * so leave cfid->is_open set and let smb2_close_cached_fid() send
+ * SMB2_close to release the server-side directory handle and lease.  If
+ * false (the session-loss teardown case), mark the cfids closed so the
+ * doomed SMB2_close is skipped -- the server has already dropped them.
  */
-void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
+void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync,
+				bool close_handles)
 {
 	struct cached_fids *cfids = tcon->cfids;
 	struct cached_fid *cfid, *q;
@@ -610,15 +617,16 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
 		return;
 
 	/*
-	 * Mark all the cfids as closed, and move them to the cfids->dying list.
-	 * They'll be cleaned up by laundromat.  Take a reference to each cfid
-	 * during this process.
+	 * Move all the cfids to the cfids->dying list.  They'll be cleaned
+	 * up by laundromat.  Take a reference to each cfid during this
+	 * process.
 	 */
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		list_move(&cfid->entry, &cfids->dying);
 		cfids->num_entries--;
-		cfid->is_open = false;
+		if (!close_handles)
+			cfid->is_open = false;
 		cfid->on_list = false;
 		if (cfid->has_lease) {
 			/*
@@ -637,6 +645,67 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
 		flush_delayed_work(&cfids->laundromat_work);
 }
 
+/*
+ * Invalidate cached directory entries across all tcons under a
+ * superblock.  Count the tcons first so the pointer array can be
+ * allocated with GFP_KERNEL outside tlink_tree_lock: allocating
+ * per-tcon under the spinlock would force GFP_ATOMIC and, on failure,
+ * silently leave some tcons with stale leases after a nolease remount.
+ * References are then taken under tlink_tree_lock and the cached dirs
+ * closed outside the spinlock since that can sleep.  Holding a tc_count
+ * reference prevents the tcon from being freed by tlink_expire_delayed()
+ * between dropping the spinlock and the call.
+ *
+ * Called on remount while the connection is live (e.g. switching to
+ * nolease), so pass close_handles=true to actually release the
+ * server-side directory handles and their leases.
+ */
+void invalidate_all_cached_dirs_sb(struct cifs_sb_info *cifs_sb)
+{
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct rb_node *node;
+	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
+	struct cifs_tcon **tcons;
+	unsigned int i, n = 0, count = 0;
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		if (!IS_ERR(tlink_tcon(tlink)))
+			count++;
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	if (!count)
+		return;
+
+	tcons = kcalloc(count, sizeof(*tcons), GFP_KERNEL);
+	if (!tcons)
+		return;
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(root); node && n < count; node = rb_next(node)) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
+		if (IS_ERR(tcon))
+			continue;
+		spin_lock(&tcon->tc_lock);
+		++tcon->tc_count;
+		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+				    netfs_trace_tcon_ref_get_cached_inval_sb);
+		spin_unlock(&tcon->tc_lock);
+		tcons[n++] = tcon;
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	for (i = 0; i < n; i++) {
+		invalidate_all_cached_dirs(tcons[i], true, true);
+		cifs_put_tcon(tcons[i], netfs_trace_tcon_ref_put_cached_inval_sb);
+	}
+	kfree(tcons);
+}
+
 static void
 cached_dir_offload_close(struct work_struct *work)
 {
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index fc756836da95..3b86339ca884 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -90,7 +90,9 @@ void close_cached_dir(struct cached_fid *cfid);
 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 			     const char *name, struct cifs_sb_info *cifs_sb);
 void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
-void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync);
+void invalidate_all_cached_dirs_sb(struct cifs_sb_info *cifs_sb);
+void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync,
+				bool close_handles);
 bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
 
 #endif			/* _CACHED_DIR_H */
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 4ed4f55a0bb7..28b0d433810f 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -383,7 +383,7 @@ static ssize_t cifs_debug_dirs_proc_write(struct file *file, const char __user *
 				if (cifs_ses_exiting(ses))
 					continue;
 				list_for_each_entry(tcon, &ses->tcon_list, tcon_list)
-					invalidate_all_cached_dirs(tcon, false);
+					invalidate_all_cached_dirs(tcon, false, false);
 			}
 		}
 		spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3bd2a588e7c4..2c5bc4dee5b2 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1265,9 +1265,9 @@ struct cifs_tcon {
 	bool need_reopen_files:1; /* need to reopen tcon file handles */
 	bool use_resilient:1; /* use resilient instead of durable handles */
 	bool use_persistent:1; /* use persistent instead of durable handles */
-	bool no_lease:1;    /* Do not request leases on files or directories */
 	bool use_witness:1; /* use witness protocol */
 	bool dummy:1; /* dummy tcon used for reconnecting channels */
+	bool no_lease;    /* Do not request leases on files or directories */
 	__le32 capabilities;
 	__u32 share_flags;
 	__u32 maximal_access;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index ac89c1ba56b1..852687916c4f 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -399,7 +399,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	invalidate_all_cached_dirs(tcon, true);
+	invalidate_all_cached_dirs(tcon, true, false);
 	spin_lock(&tcon->tc_lock);
 	if (tcon->status == TID_IN_FILES_INVALIDATE)
 		tcon->status = TID_NEED_TCON;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index ee8e38c3b7f4..35a1910ef6e3 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -35,6 +35,7 @@
 #include "nterr.h"
 #include "rfc1002pdu.h"
 #include "fs_context.h"
+#include "cached_dir.h"
 
 DEFINE_MUTEX(cifs_mount_mutex);
 
@@ -1341,6 +1342,57 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 	spin_unlock(&ses->chan_lock);
 }
 
+/*
+ * Propagate ctx->no_lease to every tcon under this superblock so future
+ * opens honor the new setting after a remount.  When switching to nolease,
+ * also drop deferred file handles and invalidate cached directory fids,
+ * since each holds an active lease from before the switch.
+ *
+ * Existing open handles keep their leases until the server breaks them
+ * or userspace closes the file -- nolease only governs new opens.
+ */
+static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
+				struct smb3_fs_context *ctx)
+{
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct rb_node *node;
+	bool became_nolease = false;
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(&cifs_sb->tlink_tree); node; node = rb_next(node)) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
+		if (IS_ERR(tcon))
+			continue;
+		/*
+		 * Update under tc_lock to pair with match_tcon(), which reads
+		 * tcon->no_lease with tc_lock held.  Track whether this is the
+		 * lease -> nolease transition so the expensive cleanup below
+		 * only runs when nolease is actually being switched on.
+		 */
+		spin_lock(&tcon->tc_lock);
+		if (ctx->no_lease && !tcon->no_lease)
+			became_nolease = true;
+		tcon->no_lease = ctx->no_lease;
+		spin_unlock(&tcon->tc_lock);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	/*
+	 * Only when switching to nolease must we evict lease-bearing cached
+	 * state (deferred handles and cached dir fids).  Skipping this when
+	 * nolease was already set avoids dropping caches on every bare
+	 * remount.  Both _sb() helpers iterate all tcons internally and
+	 * handle their own locking; they can sleep, so they must be called
+	 * outside tlink_tree_lock.
+	 */
+	if (became_nolease) {
+		cifs_close_all_deferred_files_sb(cifs_sb);
+		invalidate_all_cached_dirs_sb(cifs_sb);
+	}
+}
+
 /*
  * Synchronize server-level options that are stored on TCP_Server_Info
  * at mount time.  These fields are consulted at runtime (retry logic)
@@ -1566,6 +1618,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 #endif
 	if (!rc)
 		smb3_sync_server_opts(cifs_sb);
+	if (!rc)
+		smb3_sync_tcon_opts(cifs_sb, cifs_sb->ctx);
 
 	return rc;
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ee63b8547728..baef7efd78c7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2304,7 +2304,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	}
 	spin_unlock(&ses->chan_lock);
 
-	invalidate_all_cached_dirs(tcon, true);
+	invalidate_all_cached_dirs(tcon, true, false);
 
 	rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, server,
 				 (void **) &req,
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 5b21ad3c15fb..1e61a36759ed 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -173,6 +173,7 @@
 	EM(netfs_trace_tcon_ref_free_ipc,		"FRE Ipc   ") \
 	EM(netfs_trace_tcon_ref_free_ipc_fail,		"FRE Ipc-F ") \
 	EM(netfs_trace_tcon_ref_free_reconnect_server,	"FRE Reconn") \
+	EM(netfs_trace_tcon_ref_get_cached_inval_sb,	"GET Ch-IvS") \
 	EM(netfs_trace_tcon_ref_get_cached_laundromat,	"GET Ch-Lau") \
 	EM(netfs_trace_tcon_ref_get_cached_lease_break,	"GET Ch-Lea") \
 	EM(netfs_trace_tcon_ref_get_cancelled_close,	"GET Cn-Cls") \
@@ -186,6 +187,7 @@
 	EM(netfs_trace_tcon_ref_new_ipc,		"NEW Ipc   ") \
 	EM(netfs_trace_tcon_ref_new_reconnect_server,	"NEW Reconn") \
 	EM(netfs_trace_tcon_ref_put_cached_close,	"PUT Ch-Cls") \
+	EM(netfs_trace_tcon_ref_put_cached_inval_sb,	"PUT Ch-IvS") \
 	EM(netfs_trace_tcon_ref_put_cancelled_close,	"PUT Cn-Cls") \
 	EM(netfs_trace_tcon_ref_put_cancelled_close_fid, "PUT Cn-Fid") \
 	EM(netfs_trace_tcon_ref_put_cancelled_mid,	"PUT Cn-Mid") \
-- 
2.43.0

