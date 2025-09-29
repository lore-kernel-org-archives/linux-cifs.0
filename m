Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E412FBDFE
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152518; cv=none; b=uKI6TSThw6fqM42AUEnTi8m5qrQMxjTb37n5z6OJFOr8iJKKxJZcSYfpj/Tymu8zS1Xn3tOgXKomZCPZfrMuxgTvy5jZTrhpUmx5DnRkvSXxUJN3fNkK4W11CSHFkwpxaUyoSmzw26Jbm1gUAOr/N+ETIsIH0KJmoQzdp3pso8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152518; c=relaxed/simple;
	bh=gmiVIWL2eY3vekgmkwACVpGf5Lr/AhN5n89O7fBc9sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI+erhCsqi4oF2nvJxPo9tom+Fga5yMhqLWn75GtETc0EbvLGHnoYi3we+/hbnxeZw+aE6uM+A5g/Kr97Tj9ByBeQw6Y7//QW6r7ZWhxRaGpcznzrBpJ4k8FSxEGy0v/e4xnjfsniiiZjl+FUNCvbvI0Ch4u+h0SScvCGETJa+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Hgr0LGlb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WsmXU/6l; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Hgr0LGlb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WsmXU/6l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Hgr0LGlb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WsmXU/6l";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Hgr0LGlb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WsmXU/6l"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B43EB35626;
	Mon, 29 Sep 2025 13:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nzE1yAi8FmJtvcMsHhBZ3hnjlbW2sCs5Gs063BQuCK4=;
	b=Hgr0LGlbXX6XIc6vfEU0L+p/lA2CA20WmBcfg4QvR3ATkUNnq5iMad3NxbDXJPAyDo+WCs
	AtIaV0ZT0HcWsEOF2r9jaO++4F7RCpDzQ1LXt8WBp+QU94h1FT3whom95xD+unsGeg09Jb
	SFT0yGEUvQKyW6Iqi8FTmhsSRRdEzvM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152514;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nzE1yAi8FmJtvcMsHhBZ3hnjlbW2sCs5Gs063BQuCK4=;
	b=WsmXU/6l2TIpSYCvHRXBrhcQCBmXltEt2gPxjhppFnoMiG6FTL9HsCXaRQkbxOmZ3tlMU9
	KhULsj9B0k7qHGCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Hgr0LGlb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="WsmXU/6l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nzE1yAi8FmJtvcMsHhBZ3hnjlbW2sCs5Gs063BQuCK4=;
	b=Hgr0LGlbXX6XIc6vfEU0L+p/lA2CA20WmBcfg4QvR3ATkUNnq5iMad3NxbDXJPAyDo+WCs
	AtIaV0ZT0HcWsEOF2r9jaO++4F7RCpDzQ1LXt8WBp+QU94h1FT3whom95xD+unsGeg09Jb
	SFT0yGEUvQKyW6Iqi8FTmhsSRRdEzvM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152514;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nzE1yAi8FmJtvcMsHhBZ3hnjlbW2sCs5Gs063BQuCK4=;
	b=WsmXU/6l2TIpSYCvHRXBrhcQCBmXltEt2gPxjhppFnoMiG6FTL9HsCXaRQkbxOmZ3tlMU9
	KhULsj9B0k7qHGCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 421E313782;
	Mon, 29 Sep 2025 13:28:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /BHrAoKJ2miaGwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:28:34 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 02/20] smb: client: remove cached_dir_offload_close/close_work
Date: Mon, 29 Sep 2025 10:27:47 -0300
Message-ID: <20250929132805.220558-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250929132805.220558-1-ematsumiya@suse.de>
References: <20250929132805.220558-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: B43EB35626
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[laundromat_work.work:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01

Make put_work an 'async dput' and then move cfid to dying list so
laundromat can cleanup the rest.

Other changes:
- add drop_cfid() helper to drop entries counter, dput and close
  synchronously, when possible

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 142 +++++++++++++++++--------------------
 fs/smb/client/cached_dir.h |   1 -
 2 files changed, 66 insertions(+), 77 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index f61fef810a23..8689ee4a883d 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -22,6 +22,36 @@ struct cached_dir_dentry {
 	struct dentry *dentry;
 };
 
+static inline void drop_cfid(struct cached_fid *cfid)
+{
+	struct dentry *dentry = NULL;
+
+	spin_lock(&cfid->cfids->cfid_list_lock);
+	if (cfid->on_list) {
+		list_del(&cfid->entry);
+		cfid->on_list = false;
+		cfid->cfids->num_entries--;
+	}
+
+	spin_lock(&cfid->fid_lock);
+	swap(cfid->dentry, dentry);
+	spin_unlock(&cfid->fid_lock);
+	spin_unlock(&cfid->cfids->cfid_list_lock);
+
+	dput(dentry);
+
+	if (cfid->is_open) {
+		int rc;
+
+		cfid->is_open = false;
+		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid, cfid->fid.volatile_fid);
+
+		/* SMB2_close should handle -EBUSY or -EAGAIN */
+		if (rc)
+			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
+	}
+}
+
 static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 						    const char *path,
 						    bool lookup_only,
@@ -434,28 +464,9 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 static void
 smb2_close_cached_fid(struct kref *ref)
 {
-	struct cached_fid *cfid = container_of(ref, struct cached_fid,
-					       refcount);
-	int rc;
-
-	spin_lock(&cfid->cfids->cfid_list_lock);
-	if (cfid->on_list) {
-		list_del(&cfid->entry);
-		cfid->on_list = false;
-		cfid->cfids->num_entries--;
-	}
-	spin_unlock(&cfid->cfids->cfid_list_lock);
-
-	dput(cfid->dentry);
-	cfid->dentry = NULL;
-
-	if (cfid->is_open) {
-		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
-			   cfid->fid.volatile_fid);
-		if (rc) /* should we retry on -EBUSY or -EAGAIN? */
-			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
-	}
+	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
 
+	drop_cfid(cfid);
 	free_cached_dir(cfid);
 }
 
@@ -530,6 +541,9 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 			list_add_tail(&tmp_list->entry, &entry);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
+
+		/* run laundromat now as it might not have been queued */
+		mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
@@ -583,30 +597,15 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 	flush_delayed_work(&cfids->laundromat_work);
 }
 
-static void
-cached_dir_offload_close(struct work_struct *work)
-{
-	struct cached_fid *cfid = container_of(work,
-				struct cached_fid, close_work);
-	struct cifs_tcon *tcon = cfid->tcon;
-
-	WARN_ON(cfid->on_list);
-
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
-	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
-}
-
 /*
- * Release the cached directory's dentry, and then queue work to drop cached
- * directory itself (closing on server if needed).
- *
- * Must be called with a reference to the cached_fid and a reference to the
- * tcon.
+ * Release the cached directory's dentry and schedule immediate cleanup on laundromat.
+ * Must be called with a reference to the cached_fid and a reference to the tcon.
  */
 static void cached_dir_put_work(struct work_struct *work)
 {
-	struct cached_fid *cfid = container_of(work, struct cached_fid,
-					       put_work);
+	struct cached_fid *cfid = container_of(work, struct cached_fid, put_work);
+	struct cached_fids *cfids = cfid->cfids;
+	struct cifs_tcon *tcon = cfid->tcon;
 	struct dentry *dentry;
 
 	spin_lock(&cfid->fid_lock);
@@ -615,7 +614,16 @@ static void cached_dir_put_work(struct work_struct *work)
 	spin_unlock(&cfid->fid_lock);
 
 	dput(dentry);
-	queue_work(serverclose_wq, &cfid->close_work);
+
+	/* move to dying list so laundromat can clean it up */
+	spin_lock(&cfids->cfid_list_lock);
+	list_move(&cfid->entry, &cfids->dying);
+	cfid->on_list = false;
+	cfids->num_entries--;
+	spin_unlock(&cfids->cfid_list_lock);
+
+	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
+	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
 }
 
 bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
@@ -634,13 +642,6 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			    SMB2_LEASE_KEY_SIZE)) {
 			cfid->has_lease = false;
 			cfid->time = 0;
-			/*
-			 * We found a lease remove it from the list
-			 * so no threads can access it.
-			 */
-			list_del(&cfid->entry);
-			cfid->on_list = false;
-			cfids->num_entries--;
 
 			++tcon->tc_count;
 			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
@@ -667,7 +668,6 @@ static struct cached_fid *init_cached_dir(const char *path)
 		return NULL;
 	}
 
-	INIT_WORK(&cfid->close_work, cached_dir_offload_close);
 	INIT_WORK(&cfid->put_work, cached_dir_put_work);
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
@@ -681,12 +681,8 @@ static void free_cached_dir(struct cached_fid *cfid)
 {
 	struct cached_dirent *dirent, *q;
 
-	WARN_ON(work_pending(&cfid->close_work));
 	WARN_ON(work_pending(&cfid->put_work));
 
-	dput(cfid->dentry);
-	cfid->dentry = NULL;
-
 	/*
 	 * Delete all cached dirent names
 	 */
@@ -705,7 +701,6 @@ static void cfids_laundromat_worker(struct work_struct *work)
 {
 	struct cached_fids *cfids;
 	struct cached_fid *cfid, *q;
-	struct dentry *dentry;
 	LIST_HEAD(entry);
 
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
@@ -735,28 +730,22 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 
-		spin_lock(&cfid->fid_lock);
-		dentry = cfid->dentry;
-		cfid->dentry = NULL;
-		spin_unlock(&cfid->fid_lock);
-
-		dput(dentry);
-		if (cfid->is_open) {
-			spin_lock(&cifs_tcp_ses_lock);
-			++cfid->tcon->tc_count;
-			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
-					    netfs_trace_tcon_ref_get_cached_laundromat);
-			spin_unlock(&cifs_tcp_ses_lock);
-			queue_work(serverclose_wq, &cfid->close_work);
-		} else
-			/*
-			 * Drop the ref-count from above, either the lease-ref (if there
-			 * was one) or the extra one acquired.
-			 */
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+		/*
+		 * If a cfid reached here, we must cleanup anything unrelated to it, i.e. dentry and
+		 * remote fid.
+		 *
+		 * For the cfid itself, we only drop our own ref (kref_init).  If there are still
+		 * concurrent ref-holders, they'll drop it later (cfid is already invalid at this
+		 * point, so can't be found anymore).
+		 *
+		 * No risk for a double list_del() here because cfid->on_list is always false at
+		 * this point.
+		 */
+		drop_cfid(cfid);
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
-	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
-			   dir_cache_timeout * HZ);
+
+	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work, dir_cache_timeout * HZ);
 }
 
 struct cached_fids *init_cached_dirs(void)
@@ -806,6 +795,7 @@ void free_cached_dirs(struct cached_fids *cfids)
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
+		drop_cfid(cfid);
 		free_cached_dir(cfid);
 	}
 
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index a3757a736d3e..e5445e3a7bd3 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -45,7 +45,6 @@ struct cached_fid {
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
 	struct work_struct put_work;
-	struct work_struct close_work;
 	struct smb2_file_all_info file_all_info;
 	struct cached_dirents dirents;
 };
-- 
2.49.0

