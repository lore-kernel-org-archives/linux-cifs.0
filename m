Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2B92E889C
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859029; cv=none; b=qtA7OCas0XA+pDvkys0c8GrWcTkHsozqyrZHhjuojG5vpn1e4idwwBYz35w0zkHWXY1DWPg6JlXdLED6PR2+dM3ZO5UmJcRMsONhmVo8uK6v0ttLClY+VqZuDnxDsTNsI9tOaNErGWw56H4OojseBBWbn6xqpPao7wEO65cgHTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859029; c=relaxed/simple;
	bh=Vbcqtll+ZZrDzgiavGPu/psJNHPqCjVK3A2aFiMST7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4fhLWxxbYlnGFzaJw9mdvLO5puB1i90k6QTkZavcKY0fudPAIsZA0KCk7iK5Ocjf8nb2wylu6CVN/NJ1cIOYN9cN+6rYChgvK7zrwrQz73hPUZLe+F8ZI9djM/70rudfb6Z/977jfix5x0tnr1vaZiufWyNN/n5aF7PqdOl8/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hamOIKry; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zK8nCwms; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hamOIKry; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zK8nCwms; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hamOIKry";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zK8nCwms";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hamOIKry";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zK8nCwms"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C1F2B34213;
	Tue,  7 Oct 2025 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H8XRM7KtFo87tnwUK8TLYPsa5TV5qmurdUb846wid2E=;
	b=hamOIKryDfLMB2YvGJTOqQjDt9oCC8T8fcy+MO98PTZ4LuCl4PICcoDHeoYTCWNgcCsPC0
	yZVFAhFpgv50STuRoAbfRXEYsruy+oafz74oLuPJH9i6L65703UYCjsp/2MbrzVtPyiWwA
	Xg2RqY6ddushv+3VI3ByMbMho5xKuw0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H8XRM7KtFo87tnwUK8TLYPsa5TV5qmurdUb846wid2E=;
	b=zK8nCwmsi6CDi9l+igXT6JPqGXSr56HMeCBbwgt0vix6i6i3WiPik0ua7elDcjKr9jC/5a
	hXJ3nOdrn+bFPODg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H8XRM7KtFo87tnwUK8TLYPsa5TV5qmurdUb846wid2E=;
	b=hamOIKryDfLMB2YvGJTOqQjDt9oCC8T8fcy+MO98PTZ4LuCl4PICcoDHeoYTCWNgcCsPC0
	yZVFAhFpgv50STuRoAbfRXEYsruy+oafz74oLuPJH9i6L65703UYCjsp/2MbrzVtPyiWwA
	Xg2RqY6ddushv+3VI3ByMbMho5xKuw0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H8XRM7KtFo87tnwUK8TLYPsa5TV5qmurdUb846wid2E=;
	b=zK8nCwmsi6CDi9l+igXT6JPqGXSr56HMeCBbwgt0vix6i6i3WiPik0ua7elDcjKr9jC/5a
	hXJ3nOdrn+bFPODg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3EF2913693;
	Tue,  7 Oct 2025 17:43:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YgM/AkdR5Wj3dwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:35 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 06/20] smb: client: merge {close,invalidate}_all_cached_dirs()
Date: Tue,  7 Oct 2025 14:42:50 -0300
Message-ID: <20251007174304.1755251-7-ematsumiya@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251007174304.1755251-1-ematsumiya@suse.de>
References: <20251007174304.1755251-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80

close_all_cached_dirs(), invalidate_all_cached_dirs() and
free_cached_dirs() have become too similar now, merge their
functionality in a single static invalidate_all_cfids() function.

This also allows removing free_cached_dirs() altogether as it only
requires cancelling the work afterwards (done directly in
tconInfoFree()).

Other changes:
- remove struct cached_dir_dentry

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 113 ++++++++-----------------------------
 fs/smb/client/cached_dir.h |   4 +-
 fs/smb/client/cifsfs.c     |   2 +-
 fs/smb/client/file.c       |   2 +-
 fs/smb/client/misc.c       |   9 ++-
 fs/smb/client/smb2pdu.c    |   2 +-
 6 files changed, 36 insertions(+), 96 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index f72890786423..e86c86643379 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -16,11 +16,6 @@ static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
 
-struct cached_dir_dentry {
-	struct list_head entry;
-	struct dentry *dentry;
-};
-
 static inline void invalidate_cfid(struct cached_fid *cfid)
 {
 	/* callers must hold the list lock and do any list operations (del/move) themselves */
@@ -506,6 +501,27 @@ void close_cached_dir(struct cached_fid *cfid)
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
 }
 
+static void invalidate_all_cfids(struct cached_fids *cfids, bool closed)
+{
+	struct cached_fid *cfid, *q;
+
+	if (!cfids)
+		return;
+
+	/* mark all the cfids as closed and invalidate them for laundromat cleanup */
+	spin_lock(&cfids->cfid_list_lock);
+	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		invalidate_cfid(cfid);
+		cfid->has_lease = false;
+		if (closed)
+			cfid->is_open = false;
+	}
+	spin_unlock(&cfids->cfid_list_lock);
+
+	/* run laundromat unconditionally now as there might have been previously queued work */
+	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
+}
+
 /*
  * Called from cifs_kill_sb when we unmount a share
  */
@@ -513,12 +529,8 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 {
 	struct rb_root *root = &cifs_sb->tlink_tree;
 	struct rb_node *node;
-	struct cached_fid *cfid;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
-	struct cached_fids *cfids;
-	struct cached_dir_dentry *tmp_list, *q;
-	LIST_HEAD(entry);
 
 	spin_lock(&cifs_sb->tlink_tree_lock);
 	for (node = rb_first(root); node; node = rb_next(node)) {
@@ -526,45 +538,11 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 		tcon = tlink_tcon(tlink);
 		if (IS_ERR(tcon))
 			continue;
-		cfids = tcon->cfids;
-		if (cfids == NULL)
-			continue;
-		spin_lock(&cfids->cfid_list_lock);
-		list_for_each_entry(cfid, &cfids->entries, entry) {
-			invalidate_cfid(cfid);
-
-			tmp_list = kmalloc(sizeof(*tmp_list), GFP_ATOMIC);
-			if (tmp_list == NULL) {
-				/*
-				 * If the malloc() fails, we won't drop all
-				 * dentries, and unmounting is likely to trigger
-				 * a 'Dentry still in use' error.
-				 */
-				cifs_tcon_dbg(VFS, "Out of memory while dropping dentries\n");
-				spin_unlock(&cfids->cfid_list_lock);
-				spin_unlock(&cifs_sb->tlink_tree_lock);
-				goto done;
-			}
-
-			tmp_list->dentry = cfid->dentry;
-			cfid->dentry = NULL;
 
-			list_add_tail(&tmp_list->entry, &entry);
-		}
-		spin_unlock(&cfids->cfid_list_lock);
-
-		/* run laundromat now as it might not have been queued */
-		mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
+		invalidate_all_cfids(tcon->cfids, false);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
-done:
-	list_for_each_entry_safe(tmp_list, q, &entry, entry) {
-		list_del(&tmp_list->entry);
-		dput(tmp_list->dentry);
-		kfree(tmp_list);
-	}
-
 	/* Flush any pending work that will drop dentries */
 	flush_workqueue(cfid_put_wq);
 }
@@ -573,24 +551,12 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
  * Invalidate all cached dirs when a TCON has been reset
  * due to a session loss.
  */
-void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
+void invalidate_all_cached_dirs(struct cached_fids *cfids)
 {
-	struct cached_fids *cfids = tcon->cfids;
-	struct cached_fid *cfid;
-
 	if (!cfids)
 		return;
 
-	/* mark all the cfids as closed and invalidate them for laundromat cleanup */
-	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry(cfid, &cfids->entries, entry) {
-		invalidate_cfid(cfid);
-		cfid->is_open = false;
-	}
-	spin_unlock(&cfids->cfid_list_lock);
-
-	/* run laundromat unconditionally now as there might have been previously queued work */
-	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
+	invalidate_all_cfids(cfids, true);
 	flush_delayed_work(&cfids->laundromat_work);
 }
 
@@ -738,34 +704,3 @@ struct cached_fids *init_cached_dirs(void)
 
 	return cfids;
 }
-
-/*
- * Called from tconInfoFree when we are tearing down the tcon.
- * There are no active users or open files/directories at this point.
- */
-void free_cached_dirs(struct cached_fids *cfids)
-{
-	struct cached_fid *cfid, *q;
-	LIST_HEAD(entry);
-
-	if (cfids == NULL)
-		return;
-
-	cancel_delayed_work_sync(&cfids->laundromat_work);
-
-	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-		invalidate_cfid(cfid);
-		cfid->is_open = false;
-		list_move(&cfid->entry, &entry);
-	}
-	spin_unlock(&cfids->cfid_list_lock);
-
-	list_for_each_entry_safe(cfid, q, &entry, entry) {
-		list_del(&cfid->entry);
-		drop_cfid(cfid);
-		free_cached_dir(cfid);
-	}
-
-	kfree(cfids);
-}
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index f9cb94c7f8d2..be115116c33c 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -78,7 +78,6 @@ static inline bool is_valid_cached_dir(struct cached_fid *cfid)
 /* Module-wide directory cache accounting (defined in cifsfs.c) */
 extern atomic64_t cifs_dircache_bytes_used; /* bytes across all mounts */
 extern struct cached_fids *init_cached_dirs(void);
-extern void free_cached_dirs(struct cached_fids *cfids);
 extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			   const char *path,
 			   struct cifs_sb_info *cifs_sb,
@@ -92,7 +91,6 @@ extern void drop_cached_dir_by_name(const unsigned int xid,
 				    const char *name,
 				    struct cifs_sb_info *cifs_sb);
 extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
-extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
+extern void invalidate_all_cached_dirs(struct cached_fids *cfids);
 extern bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
-
 #endif			/* _CACHED_DIR_H */
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 1775c2b7528f..54a19bfc6170 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -140,7 +140,7 @@ static void cifs_drop_all_dir_caches(void)
 			if (cifs_ses_exiting(ses))
 				continue;
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list)
-				invalidate_all_cached_dirs(tcon);
+				invalidate_all_cached_dirs(tcon->cfids);
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index a5ed742afa00..0731d2369ab6 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -394,7 +394,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	invalidate_all_cached_dirs(tcon);
+	invalidate_all_cached_dirs(tcon->cfids);
 	spin_lock(&tcon->tc_lock);
 	if (tcon->status == TID_IN_FILES_INVALIDATE)
 		tcon->status = TID_NEED_TCON;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index dda6dece802a..0c6da3d7047f 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -169,7 +169,14 @@ tconInfoFree(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 		return;
 	}
 	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count, trace);
-	free_cached_dirs(tcon->cfids);
+
+	if (tcon->cfids) {
+		invalidate_all_cached_dirs(tcon->cfids);
+		cancel_delayed_work_sync(&tcon->cfids->laundromat_work);
+		kfree(tcon->cfids);
+		tcon->cfids = NULL;
+	}
+
 	atomic_dec(&tconInfoAllocCount);
 	kfree(tcon->nativeFileSystem);
 	kfree_sensitive(tcon->password);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 42e2d4ea344d..acbfbb40932a 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2197,7 +2197,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	}
 	spin_unlock(&ses->chan_lock);
 
-	invalidate_all_cached_dirs(tcon);
+	invalidate_all_cached_dirs(tcon->cfids);
 
 	rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, server,
 				 (void **) &req,
-- 
2.51.0

