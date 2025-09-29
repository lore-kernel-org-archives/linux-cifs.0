Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D185821B918
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152532; cv=none; b=km+gFaMGd8GXDmt+GBicI9mTakDRxuAkRcRtfFCHE9AaNSWWXpqxsBjml7QSAxCHWzle0524RGhU473/awllZiugnehdWp5ky5jvjT8+IXCYow2rOkhO0sqPeFI3FE+FJ8343sACgHqMGwlVi3Iqv0sLH2DFuEmvL8ductKGuJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152532; c=relaxed/simple;
	bh=hhCRXXWm9/UtPTcCZFYGqbMIvRq4XvWlNqDRUUtRtkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EruuLRoWwIhr5xEnRvNhgxYa3nroeDmo6LDxACJBlBg5tGPLIcDPdG8zGRtiyy+U4YfB3ElWEwI5V6iXIKZB6s4n16LfUPhRBV3YByW8Q2QCs2ZV63aG0/JDzXFDetz8E+/7OQaHlkJwwY0VVxE97Ozu7ujRJ+A1xtSOTrfkaBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Jfz43xCP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bi4W/SeY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Jfz43xCP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bi4W/SeY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Jfz43xCP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bi4W/SeY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Jfz43xCP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bi4W/SeY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 08F9835649;
	Mon, 29 Sep 2025 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqg6scb6frUAFC81srYWvby4yplXIwVbqDuW7dpGhD0=;
	b=Jfz43xCPT0YrQ+7kvIosXNpVYM+sHJYaFimeKa4fGb5iABh2WxJMYsmt/vU3b3UMn/7g0X
	iYoy1yEu8tQl5cwEYYIbiFO0gy6utz7kJ7qaUpHZYdn4jsNTukehc3gxBYzuGPvVGRseN2
	VQgAQPP/Wvn/ZMlT5RfG05QZYBlhnS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqg6scb6frUAFC81srYWvby4yplXIwVbqDuW7dpGhD0=;
	b=bi4W/SeYxfOHN2oLQSZ2QhyzRdym1weO/n29k5aJVboQZyFB1QzsMtWPY6BG0XY1E177IO
	sfdCkTa3pH+nZyDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqg6scb6frUAFC81srYWvby4yplXIwVbqDuW7dpGhD0=;
	b=Jfz43xCPT0YrQ+7kvIosXNpVYM+sHJYaFimeKa4fGb5iABh2WxJMYsmt/vU3b3UMn/7g0X
	iYoy1yEu8tQl5cwEYYIbiFO0gy6utz7kJ7qaUpHZYdn4jsNTukehc3gxBYzuGPvVGRseN2
	VQgAQPP/Wvn/ZMlT5RfG05QZYBlhnS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqg6scb6frUAFC81srYWvby4yplXIwVbqDuW7dpGhD0=;
	b=bi4W/SeYxfOHN2oLQSZ2QhyzRdym1weO/n29k5aJVboQZyFB1QzsMtWPY6BG0XY1E177IO
	sfdCkTa3pH+nZyDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8992013782;
	Mon, 29 Sep 2025 13:28:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pntoFJCJ2mjBGwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:28:48 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 04/20] smb: client: remove cached_fids->dying list
Date: Mon, 29 Sep 2025 10:27:49 -0300
Message-ID: <20250929132805.220558-5-ematsumiya@suse.de>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,laundromat_work.work:url];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Since any cleanup is now done on the local list in laundromat, the
dying list can be removed.

- entries stays on the main list until they're scheduled for cleanup
  (->last_access_time == 1)
- cached_fids->num_entries is decremented only when cfid transitions
  from on_list true -> false

cached_fid lifecycle on the list becomes:

- list_add() on find_or_create_cached_dir()
- list_move() to local list on laundromat
- list_del() on release callback, if on_list == true (unlikely, see
  comment in the function)

Other changes:
- add invalidate_cfid() helper

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 104 +++++++++++++++++--------------------
 fs/smb/client/cached_dir.h |   3 +-
 2 files changed, 48 insertions(+), 59 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index ab37a025ea1c..2fea7f6c5678 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -22,16 +22,26 @@ struct cached_dir_dentry {
 	struct dentry *dentry;
 };
 
+static inline void invalidate_cfid(struct cached_fid *cfid)
+{
+	/* callers must hold the list lock and do any list operations (del/move) themselves */
+	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
+
+	if (cfid->on_list)
+		cfid->cfids->num_entries--;
+
+	/* do not change other fields here! */
+	cfid->on_list = false;
+	cfid->time = 0;
+	cfid->last_access_time = 1;
+}
+
 static inline void drop_cfid(struct cached_fid *cfid)
 {
 	struct dentry *dentry = NULL;
 
 	spin_lock(&cfid->cfids->cfid_list_lock);
-	if (cfid->on_list) {
-		list_del(&cfid->entry);
-		cfid->on_list = false;
-		cfid->cfids->num_entries--;
-	}
+	invalidate_cfid(cfid);
 
 	spin_lock(&cfid->fid_lock);
 	swap(cfid->dentry, dentry);
@@ -466,6 +476,25 @@ smb2_close_cached_fid(struct kref *ref)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
 
+	/*
+	 * There's no way a cfid can reach here with ->on_list == true.
+	 *
+	 * This is because we hould our own ref, and whenever we put it, we invalidate the cfid
+	 * (which sets ->on_list to false).
+	 *
+	 * So even if an external caller puts the last ref, ->on_list will already have been set to
+	 * false by then by one of the invalidations that can happen concurrently, e.g. lease break,
+	 * invalidate_all_cached_dirs().
+	 *
+	 * So this check is mostly for precaution, but since we can still take the correct actions
+	 * if it's the case, do so.
+	 */
+	if (WARN_ON(cfid->on_list)) {
+		list_del(&cfid->entry);
+		cfid->on_list = false;
+		cfid->cfids->num_entries--;
+	}
+
 	drop_cfid(cfid);
 	free_cached_dir(cfid);
 }
@@ -481,15 +510,10 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
 		return;
 	}
-	spin_lock(&cfid->cfids->cfid_list_lock);
-	if (cfid->has_lease) {
-		cfid->has_lease = false;
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
-	}
-	spin_unlock(&cfid->cfids->cfid_list_lock);
-	close_cached_dir(cfid);
-}
 
+	drop_cfid(cfid);
+	kref_put(&cfid->refcount, smb2_close_cached_fid);
+}
 
 void close_cached_dir(struct cached_fid *cfid)
 {
@@ -521,6 +545,8 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 			continue;
 		spin_lock(&cfids->cfid_list_lock);
 		list_for_each_entry(cfid, &cfids->entries, entry) {
+			invalidate_cfid(cfid);
+
 			tmp_list = kmalloc(sizeof(*tmp_list), GFP_ATOMIC);
 			if (tmp_list == NULL) {
 				/*
@@ -570,25 +596,11 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 	if (!cfids)
 		return;
 
-	/*
-	 * Mark all the cfids as closed, and move them to the cfids->dying list.
-	 * They'll be cleaned up by laundromat.  Take a reference to each cfid
-	 * during this process.
-	 */
+	/* mark all the cfids as closed and invalidate them for laundromat cleanup */
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-		list_move(&cfid->entry, &cfids->dying);
-		cfids->num_entries--;
+		invalidate_cfid(cfid);
 		cfid->is_open = false;
-		cfid->on_list = false;
-		if (cfid->has_lease) {
-			/*
-			 * The lease was never cancelled from the server,
-			 * so steal that reference.
-			 */
-			cfid->has_lease = false;
-		} else
-			kref_get(&cfid->refcount);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
@@ -612,17 +624,13 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
 			    SMB2_LEASE_KEY_SIZE)) {
-			cfid->has_lease = false;
-			cfid->time = 0;
-
 			/*
-			 * We found a lease, move it to the dying list and schedule immediate
-			 * cleanup on laundromat.
+			 * We found a lease, invalidate cfid and schedule immediate cleanup on
+			 * laundromat.
 			 * No need to take a ref here, as we still hold our initial one.
 			 */
-			list_move(&cfid->entry, &cfids->dying);
-			cfids->num_entries--;
-			cfid->on_list = false;
+			invalidate_cfid(cfid);
+			cfid->has_lease = false;
 			found = true;
 			break;
 		}
@@ -684,23 +692,11 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
 
 	spin_lock(&cfids->cfid_list_lock);
-	/* move cfids->dying to the local list */
-	list_cut_before(&entry, &cfids->dying, &cfids->dying);
-
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		if (cfid->last_access_time &&
 		    time_after(jiffies, cfid->last_access_time + HZ * dir_cache_timeout)) {
-			cfid->on_list = false;
+			invalidate_cfid(cfid);
 			list_move(&cfid->entry, &entry);
-			cfids->num_entries--;
-			if (cfid->has_lease) {
-				/*
-				 * Our lease has not yet been cancelled from the
-				 * server. Steal that reference.
-				 */
-				cfid->has_lease = false;
-			} else
-				kref_get(&cfid->refcount);
 		}
 	}
 	spin_unlock(&cfids->cfid_list_lock);
@@ -735,7 +731,6 @@ struct cached_fids *init_cached_dirs(void)
 		return NULL;
 	spin_lock_init(&cfids->cfid_list_lock);
 	INIT_LIST_HEAD(&cfids->entries);
-	INIT_LIST_HEAD(&cfids->dying);
 
 	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
@@ -760,12 +755,7 @@ void free_cached_dirs(struct cached_fids *cfids)
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-		cfid->on_list = false;
-		cfid->is_open = false;
-		list_move(&cfid->entry, &entry);
-	}
-	list_for_each_entry_safe(cfid, q, &cfids->dying, entry) {
-		cfid->on_list = false;
+		invalidate_cfid(cfid);
 		cfid->is_open = false;
 		list_move(&cfid->entry, &entry);
 	}
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 5e892d53a67a..e549f019b923 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -52,12 +52,11 @@ struct cached_fid {
 struct cached_fids {
 	/* Must be held when:
 	 * - accessing the cfids->entries list
-	 * - accessing the cfids->dying list
+	 * - accessing cfids->num_entries
 	 */
 	spinlock_t cfid_list_lock;
 	int num_entries;
 	struct list_head entries;
-	struct list_head dying;
 	struct delayed_work laundromat_work;
 };
 
-- 
2.49.0

