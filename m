Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7AA443AB0
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 09:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614196; cv=none; b=u93Yiws5GKgcfX6tDKDahawf2jkzrsb4RqDqskctw49RdJtOoxlpVdzu479uUsMtswqkvaksvBvMsPj98uYlkibRk94nm2zZV+eHEHrikahoT67lfCibPXjzE7QixBvTKAQEyNLlL4MvP6nCKqQ5lVZKpfMQJzx39GV/l2UlH8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614196; c=relaxed/simple;
	bh=Z4i7YGE8yOofPxOpiRU3KUeOMjJFVHx2iK77DxA/E/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIpfzCKnt31COv9wbdCAVZrHB6CGqrsqef4pO00YyjQPVXLv3xf+sfJQvFfaxsDm4xY06AMz4i3WsBuqpMAryiNPRvAapCF4WKTK5Tf+qCjKhe56MtPGEeuCkNTCecDKdZ6eh3yTXpO4Irya9xJ0CJbuaosWCKg6z8CQvZIUzD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nm7MjUbu; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nm7MjUbu"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cbee3777e1cso1295946a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786614194; x=1787218994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ebo0bh894P42W9cDYajqG4XGay01WbUvBd0Zf4dwFfc=;
        b=nm7MjUbuzv1B/cjxfCrRwECpqMA8bwtk69+sTxqh12hRcqYb6Jed1k6MLbyMaE0ZYu
         vFsPs5YDxeNQi3Qwbn032dM+c/jMhShsdm4TNu3mQwKTUEcS36RjjFHiIR3J6Rfnzt7M
         IcuJlUWr3p2oRTKgqOFpn1u5sMzbAkPldZ9IFeCKI8KVTbPhyfyzmV8yfybidr4K1Qtc
         mxjm3MwrT2EDKUQK4/cJLk6TMX54RZ4eYPJyxtg8tCIDb6zCv7lW/UlU2/dmySaCqUWQ
         QolISDXScuDjobsSvLAhXqltT2+2LQivDfyycF0rqdWq6VttkJlVI8YisaRuZ4Ah1tFh
         OlnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786614194; x=1787218994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ebo0bh894P42W9cDYajqG4XGay01WbUvBd0Zf4dwFfc=;
        b=BaD/3vH8tx+nmB8qOa6bl73Gs+DzQhzoTvSNPYdopzHbIy7P3xo4BIllctyUYQz3xK
         3hGMyPTv76Sj6ZBsl6wWb9hEw0Zga8P/qUIMDXUQTlpekQIKBeMjkzFwgLmGhdRKfofb
         cAnavad6+RYXBI8QmcqhL8HTbjc20794zdE/RBTeCYw1wIrqgbUEWieb/7e3kqXnFQG7
         N2JIdW/df+Es3rmp8Sp+eXBEfHBLD7+SrmkQ23K80K6ZO4lJDwfEqmwDsGcW0Mc8geQt
         9QabJd5n1HBxn6gqbuhKAx4Biu5TCeUHNtG7hXUvPBcd9jg3ySZiJVAZl7gEx9+Ans6N
         z+LA==
X-Forwarded-Encrypted: i=1; AHgh+RqGkIdF244IaAmfavo8RfZjxvHBb6bU9d2CxUwXiMDDA4WTMIVoPh9WQCoElN4mLXQtNsbxhSy2J5yE@vger.kernel.org
X-Gm-Message-State: AOJu0YxKUzuGlIKcce6NefaLLnDX/Zjq5PrwjM3+vgnzfiswYd0YaYTy
	H34ZYSm4W8cqhavYZ9mpdq2jJeZFeQEDRNRtPe2ZnprrOFKGGYx6PTc8
X-Gm-Gg: AR+sD11+5LchdlskYlB+vgNrWJRqzdyQf3WNDwuGzHT1bIBkkHV4PkkfkBCEI0r7v8z
	abAjJ88V/suXENsSgVCfh0lMiMublmxNen6Hbud7TJ3tXA2SUikj5rKg6bhWVUxB8lCm3FjYQM4
	Lp4bhHjEBrawdTSaBUAS86baQG5p6ZAGxSR+nFKPll5aZqCsy3fyl9f74A7VDK00iCYYm3QqAZ4
	26SjDjG8DG5tw595mTgOkCn3+KXF0N4tq9AurfJ8IkCdpVTci4yogCSL+Cro0o1xwTXYiYVs8ce
	Em4BIKZNMr3AqtJKS9DQbyIvYuWeICkdCgeBS9ET+RFvBajJtIcK8a0plmjo1BzjdU66mabOGtD
	JT19DVxPftAv4eSbZiRAAiV8SXmR7WmIb6asta0h9r4UeoAxuunxDn9txc3IzyuISFshmaqZJSR
	KC8Oepfgt9z+LfbyG/XuEM65KRk7xKU0hES9R1Fc7XwJ+CqiNer4+0rPF3G7D6z9HQsIh+6dlmL
	FNe7xGLp2QMeMLvNLo7iWpYHRtxDIFdDa5WS7w0ME4Ra31YOOEHe2s57y2YIdAEngbvcrhk5R8M
	/MIrviarQgZK7Nro
X-Received: by 2002:a05:6a21:9a4a:b0:3a2:7ef4:81df with SMTP id adf61e73a8af0-3cc5538f542mr6068349637.26.1786614194254;
        Thu, 13 Aug 2026 02:43:14 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc760524sm6409135eec.1.2026.08.13.02.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 02:43:13 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2 7/8] smb: client: allow nolease option to be reconfigured on remount
Date: Thu, 13 Aug 2026 09:42:50 +0000
Message-ID: <20260813094251.666373-8-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813094251.666373-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com>
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
cfids_laundromat_worker() can resurrect a tcon from tc_count 0 without
a TID_EXITING check, racing cifs_put_tcon(); and the cifs_debug dirs
knob still invalidates with close_handles=false.  These are left for
separate changes.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cached_dir.c | 89 +++++++++++++++++++++++++++++++++++---
 fs/smb/client/cached_dir.h |  4 +-
 fs/smb/client/cifs_debug.c |  2 +-
 fs/smb/client/cifsglob.h   |  2 +-
 fs/smb/client/file.c       |  2 +-
 fs/smb/client/fs_context.c | 54 +++++++++++++++++++++++
 fs/smb/client/smb2pdu.c    |  2 +-
 fs/smb/client/trace.h      |  2 +
 8 files changed, 145 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 88d5e9a32f28..f85d2d1dbbe3 100644
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
@@ -637,6 +645,73 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
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
+	/*
+	 * Best effort: if the snapshot array can't be allocated, skip the
+	 * eviction.  New opens still honor the updated nolease via the
+	 * tcon->no_lease propagation done by the caller.
+	 */
+	tcons = kcalloc(count, sizeof(*tcons), GFP_KERNEL);
+	if (!tcons)
+		return;
+
+	/* n < count bounds the walk to the snapshot size if tcons are added */
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

