Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7162E8E12
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859007; cv=none; b=slwPIgSNjVivg2rbfuPaxlfjrq+j+aouVxg6yzhVSoceD6BMdawOVpUA36pQ/Cnm9mIERqub4RLB419oDoUOY7YX1UpEMGEYjUfsPjtMqSpOz63u8qvtu7rOLl9LrJf+hgPgo0pF0bDKsEItPBonVNmOKJ1Av0XCOa7hC1wRynU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859007; c=relaxed/simple;
	bh=8V+3/dEVf1LEMADVCo6HCEf/TQAEkX4O+gqK1OKM0us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4HM06cT0c+v3r2PboZEfl8jDmnNbb+W2j0DktK8zaaWNTcSkAiWPXvWZx22s8gL2W9lhkrDr6AJa8McYO2XfOwIJOcH89AsiCP8IDR9+VQwAGl85vJAOxedIqYinhQvTlef9kBR447vlxxzDPa274RclxbnJr+CylLNfC/ODp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XP4XTclw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vf4igW2y; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XP4XTclw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vf4igW2y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XP4XTclw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vf4igW2y";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XP4XTclw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vf4igW2y"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3945234213;
	Tue,  7 Oct 2025 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkDMh25M/2sZRZhHORaUOZo4fE82iSs40Qn3uvmvs88=;
	b=XP4XTclwJnp+N0evir9lxd4xq8d5QHeKi7xTDFvMPK6WCTjQC7afYnld2ymLesl9PesaeG
	76DS+vc+pc8OJmwgeTg/dXwk4cAcHrPV/NagPVbGWs2Q7JBfmtTASvd4cM81QIM/sKYkRH
	JoeOFwoXZMf6DCbefXI8DYqSGPCND2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkDMh25M/2sZRZhHORaUOZo4fE82iSs40Qn3uvmvs88=;
	b=Vf4igW2yT9YnNaOPnd/k/CUlPQ15mZHoMp8HBHkuAgpM/m5/cxSK1YzuK/IpzUe0K33CTx
	jhgst9MLHD9xP5Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkDMh25M/2sZRZhHORaUOZo4fE82iSs40Qn3uvmvs88=;
	b=XP4XTclwJnp+N0evir9lxd4xq8d5QHeKi7xTDFvMPK6WCTjQC7afYnld2ymLesl9PesaeG
	76DS+vc+pc8OJmwgeTg/dXwk4cAcHrPV/NagPVbGWs2Q7JBfmtTASvd4cM81QIM/sKYkRH
	JoeOFwoXZMf6DCbefXI8DYqSGPCND2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkDMh25M/2sZRZhHORaUOZo4fE82iSs40Qn3uvmvs88=;
	b=Vf4igW2yT9YnNaOPnd/k/CUlPQ15mZHoMp8HBHkuAgpM/m5/cxSK1YzuK/IpzUe0K33CTx
	jhgst9MLHD9xP5Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA15B13693;
	Tue,  7 Oct 2025 17:43:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rygsIDpR5WjndwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:22 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 02/20] smb: client: remove cached_dir_offload_close/close_work
Date: Tue,  7 Oct 2025 14:42:46 -0300
Message-ID: <20251007174304.1755251-3-ematsumiya@suse.de>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

Make put_work an 'async dput' and then move cfid to dying list so
laundromat can cleanup the rest.

Other changes:
- add drop_cfid() helper to drop entries counter, dput and close
  synchronously, when possible

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 136 +++++++++++++++++--------------------
 fs/smb/client/cached_dir.h |   1 -
 2 files changed, 64 insertions(+), 73 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index f6d192129a36..8ea0ab033c51 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -22,6 +22,34 @@ struct cached_dir_dentry {
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
+	swap(cfid->dentry, dentry);
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
@@ -439,28 +467,9 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
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
 
@@ -534,6 +543,9 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 			list_add_tail(&tmp_list->entry, &entry);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
+
+		/* run laundromat now as it might not have been queued */
+		mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
@@ -587,34 +599,28 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
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
+
 	dput(cfid->dentry);
 	cfid->dentry = NULL;
 
-	queue_work(serverclose_wq, &cfid->close_work);
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
@@ -633,13 +639,6 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
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
@@ -666,7 +665,6 @@ static struct cached_fid *init_cached_dir(const char *path)
 		return NULL;
 	}
 
-	INIT_WORK(&cfid->close_work, cached_dir_offload_close);
 	INIT_WORK(&cfid->put_work, cached_dir_put_work);
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
@@ -679,12 +677,8 @@ static void free_cached_dir(struct cached_fid *cfid)
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
@@ -747,25 +741,22 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 
-		dput(cfid->dentry);
-		cfid->dentry = NULL;
-
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
@@ -818,6 +809,7 @@ void free_cached_dirs(struct cached_fids *cfids)
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
+		drop_cfid(cfid);
 		free_cached_dir(cfid);
 	}
 
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 1e383db7c337..03f356088144 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -47,7 +47,6 @@ struct cached_fid {
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
 	struct work_struct put_work;
-	struct work_struct close_work;
 	struct smb2_file_all_info file_all_info;
 	struct cached_dirents dirents;
 };
-- 
2.51.0

