Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D002F9C2D
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152593; cv=none; b=EdZqPzK8/M9Xs3B/CEu0Au1YJhk9Chm0VJi3Ciq1uFvugHFhlzMlYWPVqd2huRho68bNsf5buqcgECRNbIOZusMDWFhxPkAOn0qVM/8bZcHTl22lRv7+OZfvcChc+DycGIct4g3RdP1hYTmDWnN472fpLRJuA5JeYgZCV5VBb/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152593; c=relaxed/simple;
	bh=qJhYFvXM9Cf1sy4FRZdudGi8Vh3xgDVxthr49bfG6oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDSNsl8nuqh4Ye3ncJvpYXw2laiucr0QEWSADOLx1th+fWK16UnPZDneROQzmoZb1048Q/GJXrTi+x7dp47ekrNDX5O/ADVNPXIvyUUT+POyIX34lPYbA9NSOtO9O0ZgQozPhc9v1D/JgT01DmvqUzYR79OJTbz25rk+2IGjiS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VntpbHMf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kO4bgSIs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VntpbHMf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kO4bgSIs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VntpbHMf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kO4bgSIs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VntpbHMf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kO4bgSIs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C760C2C443;
	Mon, 29 Sep 2025 13:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jwGO+k/WRyg5+7qpt8cxzFfo+L/RAg0z93bw3FDbWE=;
	b=VntpbHMfs2C9If3gNXYahCQKbE7J4FAILb4tscATzL2dUnJAjPnvGlRJcyl5EsjfvHW3mA
	YCZSnFL9sNTeLaFpHBFw9jh/C+trXfI0/txMOOGY9Wn7RXYHhbi4pwMsgOp7qNNxo/weWk
	igRi3HVdOXzqZ/Q0a4Kh8Mfd53be7AQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152587;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jwGO+k/WRyg5+7qpt8cxzFfo+L/RAg0z93bw3FDbWE=;
	b=kO4bgSIsBxC8mp8qOfPgkdJFgCiSF8nB+NliQ2loygNSiPE3NZugAKwKe5za8yUE7MJuIq
	Th08iS3GeiVsM8AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jwGO+k/WRyg5+7qpt8cxzFfo+L/RAg0z93bw3FDbWE=;
	b=VntpbHMfs2C9If3gNXYahCQKbE7J4FAILb4tscATzL2dUnJAjPnvGlRJcyl5EsjfvHW3mA
	YCZSnFL9sNTeLaFpHBFw9jh/C+trXfI0/txMOOGY9Wn7RXYHhbi4pwMsgOp7qNNxo/weWk
	igRi3HVdOXzqZ/Q0a4Kh8Mfd53be7AQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152587;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jwGO+k/WRyg5+7qpt8cxzFfo+L/RAg0z93bw3FDbWE=;
	b=kO4bgSIsBxC8mp8qOfPgkdJFgCiSF8nB+NliQ2loygNSiPE3NZugAKwKe5za8yUE7MJuIq
	Th08iS3GeiVsM8AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53C3413782;
	Mon, 29 Sep 2025 13:29:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ykc2B8uJ2mgsHAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:29:47 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 19/20] smb: client: rework cached dirs synchronization
Date: Mon, 29 Sep 2025 10:28:04 -0300
Message-ID: <20250929132805.220558-20-ematsumiya@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,laundromat_work.work:url];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80

This patch adds usage of RCU and seqlocks for cached dir (list and
entries).

Traversing the list under RCU allows faster lookups (no locks) and also
guarantees that entries being read are not gone (i.e. prevents UAF).

seqlocks provides atomicity/consistency when reading entries, allowing
callers to re-check cfid in case of write-side invalidation.

Combined with refcounting, this new approach provides safety for
callers and flexibility for future enhancements.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 269 ++++++++++++++++++++++++-------------
 fs/smb/client/cached_dir.h |  19 ++-
 fs/smb/client/cifs_debug.c |   5 +-
 3 files changed, 193 insertions(+), 100 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index c9e3e71e3f1f..6d9a06ede476 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -16,12 +16,12 @@
 #define CFID_INVALID_TIME 1
 
 static struct cached_fid *init_cached_dir(const char *path);
-static void smb2_close_cached_fid(struct kref *ref);
+static void cfid_release_ref(struct kref *ref);
 
 static inline void invalidate_cfid(struct cached_fid *cfid)
 {
 	/* callers must hold the list lock and do any list operations (del/move) themselves */
-	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
+	lockdep_assert_held(&cfid->cfids->entries_seqlock.lock);
 
 	if (cfid_is_valid(cfid))
 		cfid->cfids->num_entries--;
@@ -31,20 +31,19 @@ static inline void invalidate_cfid(struct cached_fid *cfid)
 	cfid->atime = CFID_INVALID_TIME;
 }
 
-static inline void drop_cfid(struct cached_fid *cfid)
+static inline void __drop_cfid(struct cached_fid *cfid)
 {
 	struct dentry *dentry = NULL;
 	u64 pfid = 0, vfid = 0;
 
-	spin_lock(&cfid->cfids->cfid_list_lock);
+	write_seqlock(&cfid->cfids->entries_seqlock);
+	write_seqlock(&cfid->seqlock);
 	invalidate_cfid(cfid);
-
-	spin_lock(&cfid->fid_lock);
 	swap(cfid->dentry, dentry);
 	swap(cfid->fid.persistent_fid, pfid);
 	swap(cfid->fid.volatile_fid, vfid);
-	spin_unlock(&cfid->fid_lock);
-	spin_unlock(&cfid->cfids->cfid_list_lock);
+	write_sequnlock(&cfid->seqlock);
+	write_sequnlock(&cfid->cfids->entries_seqlock);
 
 	dput(dentry);
 
@@ -58,11 +57,18 @@ static inline void drop_cfid(struct cached_fid *cfid)
 	}
 }
 
+static inline void drop_cfid(struct cached_fid *cfid)
+{
+	__drop_cfid(cfid);
+	kref_put(&cfid->refcount, cfid_release_ref);
+}
+
 /*
  * Find a cached dir based on @key and @mode (raw lookup).
  * The only validation done here is if cfid is going down (->ctime == CFID_INVALID_TIME).
  *
  * If @wait_open is true, keep retrying until cfid transitions from 'opening' to valid/invalid.
+ * Will also keep retrying on list seqcount invalidations.
  *
  * Callers must handle any other validation as needed.
  * Returned cfid, if found, has a ref taken, regardless of state.
@@ -70,51 +76,94 @@ static inline void drop_cfid(struct cached_fid *cfid)
 static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key, int mode,
 				    bool wait_open)
 {
-	struct cached_fid *cfid, *found;
-	bool match;
+	struct cached_fid *cfid;
+	unsigned int lseq = 0;
+	int ret;
 
 	if (!cfids || !key)
 		return NULL;
 
 retry_find:
-	found = NULL;
+	ret = -ENOENT;
 
-	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry(cfid, &cfids->entries, entry) {
+	rcu_read_lock();
+	lseq = read_seqbegin(&cfids->entries_seqlock);
+	list_for_each_entry_rcu(cfid, &cfids->entries, entry) {
+		if (need_seqretry(&cfids->entries_seqlock, lseq)) {
+			ret = -ECHILD;
+			break;
+		}
+
+		ret = -ENOENT;
 		/* don't even bother checking if it's going away */
 		if (cfid->ctime == CFID_INVALID_TIME)
 			continue;
 
 		if (mode == CFID_LOOKUP_PATH)
-			match = !strcmp(cfid->path, (char *)key);
+			ret = strcmp(cfid->path, (char *)key);
 
 		if (mode == CFID_LOOKUP_DENTRY)
-			match = (cfid->dentry == key);
+			ret = (cfid->dentry != key);
 
 		if (mode == CFID_LOOKUP_LEASEKEY)
-			match = !memcmp(cfid->fid.lease_key, (u8 *)key, SMB2_LEASE_KEY_SIZE);
+			ret = memcmp(cfid->fid.lease_key, (u8 *)key, SMB2_LEASE_KEY_SIZE);
 
-		if (!match)
+		if (ret) {
+			ret = -ENOENT;
 			continue;
+		}
+
+		if (wait_open && !cfid->ctime) {
+			unsigned int cseq = read_seqbegin(&cfid->seqlock);
+
+			if (!cfid->ctime)
+				ret = -ECHILD;
+			else if (!cfid_is_valid(cfid))
+				ret = -EINVAL;
+
+			if (read_seqretry(&cfid->seqlock, cseq) && !ret)
+				ret = -ECHILD;
 
-		/* only get a ref here if not waiting for open */
-		if (!wait_open)
-			kref_get(&cfid->refcount);
-		found = cfid;
+			if (ret)
+				break;
+		}
+
+		kref_get(&cfid->refcount);
 		break;
 	}
-	spin_unlock(&cfids->cfid_list_lock);
 
-	if (wait_open && found) {
-		/* cfid is being opened in open_cached_dir(), retry lookup */
-		if (!found->ctime)
-			goto retry_find;
+	if (read_seqretry(&cfids->entries_seqlock, lseq)) {
+		if (wait_open) {
+			if (ret == -ENOENT) {
+				ret = -ECHILD;
+
+				/*
+				 * Not found but caller requested wait for open.
+				 * The list seqcount invalidation might have been our open, retry
+				 * only once more (in case it wasn't).
+				 */
+				wait_open = false;
+			}
+		}
 
-		/* we didn't get a ref above, so get one now */
-		kref_get(&found->refcount);
+		if (!ret)
+			ret = -EUCLEAN;
 	}
+	rcu_read_unlock();
 
-	return found;
+	if (!ret)
+		return cfid;
+
+	if (ret == -EUCLEAN) {
+		kref_put(&cfid->refcount, cfid_release_ref);
+		ret = -ECHILD;
+	}
+
+	if (ret == -ECHILD)
+		goto retry_find;
+
+	/* -EINVAL or -ENOENT */
+	return NULL;
 }
 
 static struct dentry *
@@ -191,7 +240,7 @@ struct cached_fid *find_cached_dir(struct cached_fids *cfids, const void *key, i
 		if (cfid_is_valid(cfid)) {
 			cfid->atime = jiffies;
 		} else {
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			kref_put(&cfid->refcount, cfid_release_ref);
 			cfid = NULL;
 		}
 	}
@@ -222,7 +271,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	u8 oplock = SMB2_OPLOCK_LEVEL_II;
 	struct cifs_fid *pfid;
 	struct dentry *dentry;
-	struct cached_fid *cfid;
+	struct cached_fid __rcu *cfid;
 	struct cached_fids *cfids;
 	const char *npath;
 	int retries = 0, cur_sleep = 1;
@@ -251,34 +300,35 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	if (!server->ops->new_lease_key)
 		return -EIO;
 
-	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
-	if (!utf16_path)
-		return -ENOMEM;
-
 	/* find_cached_dir() already validates cfid if found, so no need to check here again */
 	cfid = find_cached_dir(cfids, path, CFID_LOOKUP_PATH);
 	if (cfid) {
-		rc = 0;
-		goto out;
+		*ret_cfid = cfid;
+		return 0;
 	}
 
-	spin_lock(&cfids->cfid_list_lock);
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
+
+	read_seqlock_excl(&cfids->entries_seqlock);
 	if (cfids->num_entries >= tcon->max_cached_dirs) {
-		spin_unlock(&cfids->cfid_list_lock);
+		read_sequnlock_excl(&cfids->entries_seqlock);
 		rc = -ENOENT;
 		goto out;
 	}
+	read_sequnlock_excl(&cfids->entries_seqlock);
 
+	/* no ned to lock cfid or entries yet */
 	cfid = init_cached_dir(path);
 	if (!cfid) {
-		spin_unlock(&cfids->cfid_list_lock);
 		rc = -ENOMEM;
 		goto out;
 	}
 
 	cfid->cfids = cfids;
 	cfid->tcon = tcon;
-	spin_unlock(&cfids->cfid_list_lock);
+	pfid = &cfid->fid;
 
 	/*
 	 * Skip any prefix paths in @path as lookup_noperm_positive_unlocked() ends up
@@ -303,16 +353,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 			goto out;
 		}
 	}
-	cfid->dentry = dentry;
-	cfid->tcon = tcon;
-	dentry = NULL;
 
-	spin_lock(&cfids->cfid_list_lock);
+	write_seqlock(&cfids->entries_seqlock);
 	cfids->num_entries++;
-	list_add(&cfid->entry, &cfids->entries);
-	spin_unlock(&cfids->cfid_list_lock);
-
-	pfid = &cfid->fid;
+	list_add_rcu(&cfid->entry, &cfids->entries);
+	write_sequnlock(&cfids->entries_seqlock);
 
 	/*
 	 * We do not hold the lock for the open because in case
@@ -378,8 +423,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		goto oshr_free;
 	}
 
-	spin_lock(&cfids->cfid_list_lock);
-
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
@@ -389,30 +432,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 
 
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
-		spin_unlock(&cfids->cfid_list_lock);
 		rc = -EINVAL;
 		goto oshr_free;
 	}
 
-	rc = smb2_parse_contexts(server, rsp_iov,
-				 &oparms.fid->epoch,
-				 oparms.fid->lease_key,
+	rc = smb2_parse_contexts(server, rsp_iov, &oparms.fid->epoch, oparms.fid->lease_key,
 				 &oplock, NULL, NULL);
-	if (rc) {
-		spin_unlock(&cfids->cfid_list_lock);
+	if (rc)
 		goto oshr_free;
-	}
 
 	rc = -EINVAL;
-	if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
-		spin_unlock(&cfids->cfid_list_lock);
+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
 		goto oshr_free;
-	}
+
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
-	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info)) {
-		spin_unlock(&cfids->cfid_list_lock);
+	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
 		goto oshr_free;
-	}
+
 	if (!smb2_validate_and_copy_iov(le16_to_cpu(qi_rsp->OutputBufferOffset),
 					sizeof(struct smb2_file_all_info), &rsp_iov[1],
 					sizeof(struct smb2_file_all_info), (char *)&info)) {
@@ -423,10 +459,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		}
 	}
 
-	cfid->ctime = jiffies;
-	cfid->atime = jiffies;
-	spin_unlock(&cfids->cfid_list_lock);
-	/* At this point the directory handle is fully cached */
 	rc = 0;
 oshr_free:
 	SMB2_open_free(&rqst[0]);
@@ -434,16 +466,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 out:
-	/* cfid invalidated in the mean time, drop it below */
-	if (!rc && !cfid_is_valid(cfid))
+	/* cfid only becomes fully valid below, so can't use cfid_is_valid() here */
+	if (!rc && cfid->ctime == CFID_INVALID_TIME)
 		rc = -ENOENT;
 
 	if (rc) {
-		if (cfid) {
+		dput(dentry);
+
+		if (cfid)
 			drop_cfid(cfid);
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
-		}
 	} else {
+		/* seqlocked-write will inform concurrent lookups of opening -> open transition */
+		write_seqlock(&cfid->seqlock);
+		cfid->dentry = dentry;
+		cfid->ctime = jiffies;
+		cfid->atime = jiffies;
+		write_sequnlock(&cfid->seqlock);
+
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
@@ -456,13 +495,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	return rc;
 }
 
-static void smb2_close_cached_fid(struct kref *ref)
+static void cfid_rcu_free(struct rcu_head *rcu)
 {
-	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
+	struct cached_fid *cfid = container_of(rcu, struct cached_fid, rcu);
 	struct cached_dirent *de, *q;
 
-	drop_cfid(cfid);
-
 	/* Delete all cached dirent names */
 	list_for_each_entry_safe(de, q, &cfid->dirents.entries, entry) {
 		list_del(&de->entry);
@@ -477,6 +514,14 @@ static void smb2_close_cached_fid(struct kref *ref)
 	kfree(cfid);
 }
 
+static void cfid_release_ref(struct kref *ref)
+{
+	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
+
+	__drop_cfid(cfid);
+	call_rcu_hurry(&cfid->rcu, cfid_rcu_free);
+}
+
 bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode)
 {
 	struct cached_fid *cfid;
@@ -497,13 +542,16 @@ bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode)
 		drop_cfid(cfid);
 	} else {
 		/* we're locked in smb2_is_valid_lease_break(), so can't dput/close here */
-		spin_lock(&cfids->cfid_list_lock);
+		write_seqlock(&cfids->entries_seqlock);
+		write_seqlock(&cfid->seqlock);
 		invalidate_cfid(cfid);
-		spin_unlock(&cfids->cfid_list_lock);
+		write_sequnlock(&cfid->seqlock);
+		write_sequnlock(&cfids->entries_seqlock);
+
+		/* put lookup ref */
+		kref_put(&cfid->refcount, cfid_release_ref);
 	}
 
-	/* put lookup ref */
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
 	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
 
 	return true;
@@ -511,26 +559,28 @@ bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode)
 
 void close_cached_dir(struct cached_fid *cfid)
 {
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	kref_put(&cfid->refcount, cfid_release_ref);
 }
 
 static void invalidate_all_cfids(struct cached_fids *cfids, bool closed)
 {
-	struct cached_fid *cfid, *q;
+	struct cached_fid *cfid;
 
 	if (!cfids)
 		return;
 
 	/* mark all the cfids as closed and invalidate them for laundromat cleanup */
-	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+	write_seqlock(&cfids->entries_seqlock);
+	list_for_each_entry(cfid, &cfids->entries, entry) {
+		write_seqlock(&cfid->seqlock);
 		invalidate_cfid(cfid);
 		if (closed) {
 			cfid->fid.persistent_fid = 0;
 			cfid->fid.volatile_fid = 0;
 		}
+		write_sequnlock(&cfid->seqlock);
 	}
-	spin_unlock(&cfids->cfid_list_lock);
+	write_sequnlock(&cfids->entries_seqlock);
 
 	/* run laundromat unconditionally now as there might have been previously queued work */
 	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
@@ -570,6 +620,8 @@ void invalidate_all_cached_dirs(struct cached_fids *cfids)
 	if (!cfids)
 		return;
 
+	synchronize_rcu();
+
 	invalidate_all_cfids(cfids, true);
 	flush_delayed_work(&cfids->laundromat_work);
 }
@@ -591,7 +643,7 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
-	spin_lock_init(&cfid->fid_lock);
+	seqlock_init(&cfid->seqlock);
 
 	/* this is our ref */
 	kref_init(&cfid->refcount);
@@ -607,20 +659,51 @@ static struct cached_fid *init_cached_dir(const char *path)
 
 static void cfids_laundromat_worker(struct work_struct *work)
 {
-	struct cached_fids *cfids;
+	unsigned int lseq, cseq, done = 1;
 	struct cached_fid *cfid, *q;
+	struct cached_fids *cfids;
 	LIST_HEAD(entry);
 
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
 
-	spin_lock(&cfids->cfid_list_lock);
+	rcu_read_lock();
+	/* RCU-seqcounted read first so we avoid unnecessary seqcount invalidations */
+	lseq = read_seqbegin(&cfids->entries_seqlock);
+	list_for_each_entry_rcu(cfid, &cfids->entries, entry) {
+		if (read_seqretry(&cfids->entries_seqlock, lseq)) {
+			done = 0;
+			break;
+		}
+
+		cseq = read_seqbegin(&cfid->seqlock);
+		if (cfid_expired(cfid))
+			done = 0;
+
+		if (read_seqretry(&cfid->seqlock, cseq) || !done) {
+			done = 0;
+			break;
+		}
+	}
+
+	/* no list invalidations and no invalidated/expired entries, requeue */
+	if (!read_seqretry(&cfids->entries_seqlock, lseq) && done) {
+		rcu_read_unlock();
+		goto requeue;
+	}
+	rcu_read_unlock();
+
+	/* now we know something was invalidated in the above read, do a write-locked run */
+	write_seqlock(&cfids->entries_seqlock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		write_seqlock(&cfid->seqlock);
 		if (cfid_expired(cfid)) {
+			//raw_write_seqcount_barrier(&cfids->entries_seqlock.seqcount);
 			invalidate_cfid(cfid);
 			list_move(&cfid->entry, &entry);
 		}
+		write_sequnlock(&cfid->seqlock);
 	}
-	spin_unlock(&cfids->cfid_list_lock);
+	write_sequnlock(&cfids->entries_seqlock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
@@ -636,9 +719,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		 * No risk for a double list_del() here because cfid is only on this list now.
 		 */
 		drop_cfid(cfid);
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
-
+requeue:
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work, dir_cache_timeout * HZ);
 }
 
@@ -649,7 +731,8 @@ struct cached_fids *init_cached_dirs(void)
 	cfids = kzalloc(sizeof(*cfids), GFP_KERNEL);
 	if (!cfids)
 		return NULL;
-	spin_lock_init(&cfids->cfid_list_lock);
+
+	seqlock_init(&cfids->entries_seqlock);
 	INIT_LIST_HEAD(&cfids->entries);
 
 	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index d5ad10a35ed7..77c292399978 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -8,6 +8,8 @@
 #ifndef _CACHED_DIR_H
 #define _CACHED_DIR_H
 
+#include <linux/seqlock.h>
+
 struct cached_dirent {
 	struct list_head entry;
 	char *name;
@@ -33,13 +35,19 @@ struct cached_dirents {
 
 struct cached_fid {
 	struct list_head entry;
+	struct rcu_head rcu;
+	/*
+	 * ->seqlock must be used:
+	 * - write-locked when updating
+	 * - rcu_read_lock() + seqcounted on reads
+	 */
+	seqlock_t seqlock;
 	struct cached_fids *cfids;
 	const char *path;
 	unsigned long ctime; /* (jiffies) creation time, when cfid was created (cached) */
 	unsigned long atime; /* (jiffies) access time, when it was last used */
 	struct kref refcount;
 	struct cifs_fid fid;
-	spinlock_t fid_lock;
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
 	struct smb2_file_all_info *file_all_info;
@@ -48,11 +56,12 @@ struct cached_fid {
 
 /* default MAX_CACHED_FIDS is 16 */
 struct cached_fids {
-	/* Must be held when:
-	 * - accessing the cfids->entries list
-	 * - accessing cfids->num_entries
+	/*
+	 * ->entries_seqlock must be used when accessing ->entries or ->num_entries:
+	 * - write-locked when updating
+	 * - rcu_read_lock() + seqcounted on reads
 	 */
-	spinlock_t cfid_list_lock;
+	seqlock_t entries_seqlock;
 	int num_entries;
 	struct list_head entries;
 	struct delayed_work laundromat_work;
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index bb27b9c97724..72e63db75403 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -306,7 +306,8 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 				cfids = tcon->cfids;
 				if (!cfids)
 					continue;
-				spin_lock(&cfids->cfid_list_lock); /* check lock ordering */
+
+				read_seqlock_excl(&cfids->entries_seqlock);
 				seq_printf(m, "Num entries: %d\n", cfids->num_entries);
 				list_for_each_entry(cfid, &cfids->entries, entry) {
 					seq_printf(m, "0x%x 0x%llx 0x%llx     %s",
@@ -320,7 +321,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 						seq_printf(m, ", valid dirents");
 					seq_printf(m, "\n");
 				}
-				spin_unlock(&cfids->cfid_list_lock);
+				read_sequnlock_excl(&cfids->entries_seqlock);
 			}
 		}
 	}
-- 
2.49.0

