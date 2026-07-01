Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2E540B373
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 10:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902018; cv=none; b=QhwOhPxiENWe9OGJPicYFpbmECfcGFQhOQfH5qW5QPhclmSW/V3bW1jEIxPPydCRUtMjOaG+2tYiQYpHk8ticB3YjiaMwgKBJAaVg7RqTND+/g7J9dtIz1r+/vgrv6QG8jHjHu+3Ot5QdpSa6Qz0FOsu+eGLWF8svNwg0oogny4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902018; c=relaxed/simple;
	bh=iKzJAer5CgE0BbyTUDhUfkJFRXK/sidSku+cM1xJJnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZuxdhouxoBAzKBh1SSFp6bZbl+MOr5cEOYTbw7heVb7SVQUZnJPHQaziAd13ITxB9daAX61aQUHkPzy4ma/60S/0yE/uqmAQfAw2lQ0l4BiUtcKhDlK2aX3P5LLyxw5TSk9JGLCpJNvj4NDasw4HvL5bHZM/z25JNR1TKSVGEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hr9xhfdo; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hr9xhfdo"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-139aff562e1so605119c88.1
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 03:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782902015; x=1783506815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RplZ3XBgc2KZyF9HvmZwmtPHQfqJtW2MOg4oHaIZgSI=;
        b=Hr9xhfdofo9W0WphK8pJeRxWlw80mEjtnYWA7TR8wz8KhVd0BFlmszv/Qc6WtXIKg+
         5T5ZW6W4qgw6/4gGgCEl6HS5qUpe4YlzEABd5WGjZWHVblX+7/E1iwd3gcEQBCPO1197
         bUHr0Pcu39dZ9almGCprD7eShkoJfJ5A1aLn6QUdg2QAwyppaCeV8ve8TOostlIIeMes
         sbzu64flfzOnYNsHVNw7ak/14WvKinfWyK0Wxro/SW3FFLZfJvDur7cxBmpf1JJIyqPc
         5hvtoZ/VthtLj/9DDtyMCEOfc6/eaFcOwMcUTzKv1lpJXzUZ2g1nCwkIjr+pa8GGZHna
         afCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782902015; x=1783506815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RplZ3XBgc2KZyF9HvmZwmtPHQfqJtW2MOg4oHaIZgSI=;
        b=qdJyyM1Ryuq/JtctkBlUas1uquK5hR1YqtaEp+yfSgsSKcnwOrxfODJ0Arsc5WuJdV
         pLi9eTwk7Aqr+7NwwXGcfaXsMHKmt96/Uh4hCZsQJH7lw4opSlcDeeAXIiRmJ82eEqYv
         QT98EQLsJ8mIU8YZF4qXxXPXFSM+f6Bt8V0UVDkQ+0lPX+hGdlaMQzv1Bsz2ofJkgIz2
         e0rVB5m+uhMisfc/9NG5QHOUv2KmYyHxm0AvkQPYtzRz9ms3w58xq5SKpDJYF64Omzku
         r0+Ah8bP+tFB88LwDzR1qF+MKRALOlHhdGwuzmnsr+EVqEl3myMzmVNzQXQo9ky2LrCA
         0TJw==
X-Gm-Message-State: AOJu0Yxj2FBjHU82nu35tNHvk4Y/pWzFvmwh2B2QqNNboxXxJxtBet9Y
	/QIUAx95DaMMAkBusDZ+/fAgZbORx2GQlt6TcNGjzV6LglksItkUlhEQfApPCg==
X-Gm-Gg: AfdE7clQaBU5y1/LtJjhS0IIveZO7h+wVT4xzaO1ysAaE1hjpMchq0pRdxDHZ/5U7qe
	tLu21XT+Z8tsRMyZ/VAfPhgq5/qvzKrFwcPDa224C3UCE6kZbg1yOXjBhYSofizIFnZHVeSruYF
	BryzEALkczFaLbikGQqwUDRITnlSx5MzC5r56/PIlj4SnygS5xXNxEWj7Nn8ZC4CcEkCzoS/qOf
	U1j7r7Uxk0QiM0JVaq1NEHJljOnBdvvpa92T0rw7N5EJOV3J0iPyVeFkbXcxx20+ps6gblSfEMZ
	6r1BsQXu5WF/lv6Jz/R2BPxhQhKNPwF85LjWyZoPd61PPb0KLJzB6WmEOH4JI/nDFGJwbaefwcn
	kNnIBz0Co43Y+pZj/19nPzLJzo4e2FEEuGx7PwGvaT8crQ+iiBD2QW6Cp2MqWSVUXYH1ZV1PJYO
	qihAi9JbkIOy9XO2XNbUbZG0CdpnMxdb9aD96yKo/mcJazTxXamvrQjmCUfxsnRY3b1eZO9T8cz
	usb/QpCI2ah
X-Received: by 2002:a05:7022:7a0:b0:139:9ba1:dc06 with SMTP id a92af1059eb24-13b36e03348mr1081597c88.38.1782902014593;
        Wed, 01 Jul 2026 03:33:34 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b2abcd5edsm25135838c88.15.2026.07.01.03.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 03:33:33 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 2/2] smb: client: review fixes for nolease remount (patch 7)
Date: Wed,  1 Jul 2026 10:33:13 +0000
Message-ID: <20260701103313.3499731-2-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260701103313.3499731-1-rajasimandalos@gmail.com>
References: <20260701103313.3499731-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Fold the review feedback for the nolease reconfigure patch into one
change.  Each fix, in two lines:

- nolease transition: track the lease -> nolease transition
  (became_nolease) and only run the expensive cache eviction when nolease
  is actually switched on, not on every bare remount.
- nolease locking: set tcon->no_lease under tc_lock to pair with
  match_tcon(), which reads tcon->no_lease with tc_lock held.
- cached dir leak: add a close_handles arg to invalidate_all_cached_dirs()
  so a live remount keeps is_open and lets the laundromat send SMB2_close
  instead of leaking the server handle/lease.
- callers: cifs_debug.c, file.c and smb2pdu.c pass close_handles=false to
  preserve their existing teardown behaviour.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cached_dir.c | 32 ++++++++++++++++++++++----------
 fs/smb/client/cached_dir.h |  3 ++-
 fs/smb/client/cifs_debug.c |  2 +-
 fs/smb/client/file.c       |  2 +-
 fs/smb/client/fs_context.c | 20 +++++++++++++++++---
 fs/smb/client/smb2pdu.c    |  2 +-
 6 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 58d68a8f4d41..420a598f5963 100644
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
@@ -640,10 +648,14 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
 /*
  * Invalidate cached directory entries across all tcons under a
  * superblock.  Collect references on each tcon under tlink_tree_lock,
- * then call invalidate_all_cached_dirs() outside the spinlock since it
- * can sleep.  Holding a tc_count reference prevents the tcon from being
+ * then close their cached dirs outside the spinlock since that can
+ * sleep.  Holding a tc_count reference prevents the tcon from being
  * freed by tlink_expire_delayed() between dropping the spinlock and
  * the call.
+ *
+ * Called on remount while the connection is live (e.g. switching to
+ * nolease), so pass close_handles=true to actually release the
+ * server-side directory handles and their leases.
  */
 void invalidate_all_cached_dirs_sb(struct cifs_sb_info *cifs_sb)
 {
@@ -674,7 +686,7 @@ void invalidate_all_cached_dirs_sb(struct cifs_sb_info *cifs_sb)
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
 	list_for_each_entry_safe(tmp_list, q, &tcon_head, entry) {
-		invalidate_all_cached_dirs(tmp_list->tcon, true);
+		invalidate_all_cached_dirs(tmp_list->tcon, true, true);
 		list_del(&tmp_list->entry);
 		cifs_put_tcon(tmp_list->tcon, netfs_trace_tcon_ref_put_cached_inval_sb);
 		kfree(tmp_list);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 606ba2a0b64f..3b86339ca884 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -91,7 +91,8 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 			     const char *name, struct cifs_sb_info *cifs_sb);
 void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
 void invalidate_all_cached_dirs_sb(struct cifs_sb_info *cifs_sb);
-void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync);
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
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 58430ba51b10..c06117b1975e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -393,7 +393,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	invalidate_all_cached_dirs(tcon, true);
+	invalidate_all_cached_dirs(tcon, true, false);
 	spin_lock(&tcon->tc_lock);
 	if (tcon->status == TID_IN_FILES_INVALIDATE)
 		tcon->status = TID_NEED_TCON;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 89bf6f4604b3..70fa869b9b6d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1333,6 +1333,7 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 	struct rb_node *node;
+	bool became_nolease = false;
 
 	spin_lock(&cifs_sb->tlink_tree_lock);
 	for (node = rb_first(&cifs_sb->tlink_tree); node; node = rb_next(node)) {
@@ -1340,16 +1341,29 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 		tcon = tlink_tcon(tlink);
 		if (IS_ERR(tcon))
 			continue;
+		/*
+		 * Update under tc_lock to pair with match_tcon(), which reads
+		 * tcon->no_lease with tc_lock held.  Track whether this is the
+		 * lease -> nolease transition so the expensive cleanup below
+		 * only runs when nolease is actually being switched on.
+		 */
+		spin_lock(&tcon->tc_lock);
+		if (ctx->no_lease && !tcon->no_lease)
+			became_nolease = true;
 		tcon->no_lease = ctx->no_lease;
+		spin_unlock(&tcon->tc_lock);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
 	/*
-	 * Both _sb() helpers iterate all tcons internally and handle
-	 * their own locking.  They can sleep, so they must be called
+	 * Only when switching to nolease must we evict lease-bearing cached
+	 * state (deferred handles and cached dir fids).  Skipping this when
+	 * nolease was already set avoids dropping caches on every bare
+	 * remount.  Both _sb() helpers iterate all tcons internally and
+	 * handle their own locking; they can sleep, so they must be called
 	 * outside tlink_tree_lock.
 	 */
-	if (ctx->no_lease) {
+	if (became_nolease) {
 		cifs_close_all_deferred_files_sb(cifs_sb);
 		invalidate_all_cached_dirs_sb(cifs_sb);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 958ca0753774..e68f96df8ee3 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2278,7 +2278,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	}
 	spin_unlock(&ses->chan_lock);
 
-	invalidate_all_cached_dirs(tcon, true);
+	invalidate_all_cached_dirs(tcon, true, false);
 
 	rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, server,
 				 (void **) &req,
-- 
2.43.0

