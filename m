Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA84F42A7AE
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992176; cv=none; b=kBHgPVwnIP9/selEmBH1n1tCclKVxo1kaQHHPS3UbgBDnDbaZMqsmDW9QALgKz19iAhy4sYugKMsnWkMjRBAgqXzFsjK2DCFk55mtPXrhGUewPaYV4usWK/an5NsNqZzCKmd3jScSyzZYa0XZM8Q2PASFAabh8jnMRgHN9ATHxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992176; c=relaxed/simple;
	bh=iKzJAer5CgE0BbyTUDhUfkJFRXK/sidSku+cM1xJJnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUb1f2pkwPag9e1e+ZyuWJGO3Je2GiuHfyr6VI4xiubC5pRocj5bMkqbHxtenkzg5/EurBpirsYVvQXOVX3jwnmefeJRqm1qEz3n/Sdqr62uZmhVfoz3RBBgWkCWoM60XLCY4fDWdTZ+xWlxzbjP2pSyPCaX/V9/4EscVBWGbGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mv4qJ82v; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mv4qJ82v"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-37e1607f7faso1366448a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992169; x=1783596969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RplZ3XBgc2KZyF9HvmZwmtPHQfqJtW2MOg4oHaIZgSI=;
        b=Mv4qJ82vQ1CUa4oMe3xw7dgB7ckIhUHG66aIXQSIAnMpRPXstHLwP9KtJ7e7LaDFqL
         SidkDgaPWSXE4e03ucca5OckgP7IhuU8Y/QchyGPVUQ8Xm7zjpGr6IcLOA6pPqPZB7+I
         lili2yO8SBLum+m6lQsg31QIUCWsqCcxAJyC9fI3mjkmyNWeSSzxrQCLL9W4xkkyFeFL
         L3aLtI47jLIu/1gerWXRAqVemKwpdE9qCAZ0rhEo1Bdkh1GfsYIr8wqgJLugu170FuEn
         d+pZEWffub7GqUDTEZGgk4FclthODHqqDZqyJallGcrUkHfJJiXsXw0jv9DHPwffuw3a
         nxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992169; x=1783596969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RplZ3XBgc2KZyF9HvmZwmtPHQfqJtW2MOg4oHaIZgSI=;
        b=MbmqgeTptpExHMohhvzqxMDLpLG7M5YZCRcNNMIzaqBtG2iqQVrluMMOmK9dLOBMAz
         Vk/EnP1YDODMSsd/bm6KQiTfoVf4BLK68mgTf7n50Xaq9dnsXCDuTphqduQ4NcxQkwdZ
         hG4S31nFsnOS6Y6ZOpzSbjBgAjxgw4AkC6d/kL4Z+Bzuu+Odv90dUdj1k51wUrKSP8Il
         4zrQ199jpI3aSx859RbtCebc6V/x/S8tjem7WN/3IyxhNh1P0QLJu54ZunrpTn499FlL
         o7U0kdyKAMmULDmBDN0r31jfW0RLY+89vdCX7XphIkXGO7Zd+HtKAqI62Pc6Cc16BLdZ
         znnQ==
X-Gm-Message-State: AOJu0YxoyBCN9i9P6ei96vXPODU8WL4jqhql09suu8fPvNuAh/7zKq3n
	QZtQ3bjNvhD+wUR11i/pp8jso1+kJUi96l4HXBsgPCDZj13Yyu66Ai2mzfwBZA==
X-Gm-Gg: AfdE7cmDeS2mnSeYFhkLM3LNh4aVhQBIXUmT4pUdvx1Cee1c/FY20Sp2gkNM03JnnAp
	HGSJR2agSmVuGf4g70CcILWvXum9owDIAnGV4PXCHSfKFY5x4Nxn9kldtdFbhPiczn5EhKCRz+/
	tqYZbOavwA2vOQml72kbII2KkpJ91oMxIH5wamRDS/aKT+vNM9IeNVqrO5BZVlzHEa5dymKIlTN
	6tgL5Lx+bG5mdRGmWexea0qx0Vxe5bEf/XhAy/WGL7OVQd/fEOfrljv0yvGGL+vJkNlG9el0WE6
	U0H6s4UNSVdu5NVe57WaTMR1VfTrCk2vf3dqyW4NSGFVh8yCVRBATwUV4LEOP93iT+9nI+hGHv6
	us+ZsMeRYB0wSIM91WdvdPAOiTXoGuCQa/LsvnPFEyXXvkOp+1dmJReyqOKPC2gaSfzUJIt0NIx
	kHBEfw1mnheBg1Xta22RrCrJ19pgQGpt2wfSQpQze6ABJ6THSq4YUBVCrb7i83WiwH1LZM976vh
	E25IYobn4z0wUADDEqEUyo=
X-Received: by 2002:a17:90b:4fd2:b0:37e:a09:2640 with SMTP id 98e67ed59e1d1-380aa0fd3e9mr6047450a91.7.1782992169188;
        Thu, 02 Jul 2026 04:36:09 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:36:08 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 9/9] smb: client: review fixes for nolease remount (patch 7)
Date: Thu,  2 Jul 2026 11:35:35 +0000
Message-ID: <20260702113535.4044308-10-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702113535.4044308-1-rajasimandalos@gmail.com>
References: <20260702113535.4044308-1-rajasimandalos@gmail.com>
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

