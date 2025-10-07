Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191AC2E8DEA
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859022; cv=none; b=D3diJ6dFALLRQyVGc1pxYBXI37xfmnfXxHm9yonXuLkEqXDflVZltM/uDkHUzktnXg7cEjP16SiTVC9L1FR04eiCbrt8LWvdsEaQEik50RElxwneIKOvlNBuWa/O6lJKA3wfDZY8PrD7VJasGcqwnYtMYpWaBcn2m35lpc+3Xmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859022; c=relaxed/simple;
	bh=i+hDFWbjiWuTmoKghFlj7mVF9kOpxGBUdkJ8EIAnWEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9+qc5Xw/fJAB681/vHATM8tdGlyUsgJPZ8KYfDkHd3a9MGG0tB4r/D4wlhNoT9K4Yey+EVu49prSW0SWKM8hApyS6P+uTTc37KbWY7rljJ87+I2wyqrkDi+vkIrwmM1rgI/ANLGzKjToui89+1s78oxqXYNof8amhCRuOiJhZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MZwcrqLn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=h2pV6WzN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MZwcrqLn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=h2pV6WzN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MZwcrqLn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="h2pV6WzN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MZwcrqLn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="h2pV6WzN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 940EA34214;
	Tue,  7 Oct 2025 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvOoeg3vsxSRVlaUbkmOcNZLhXhilETWv/vFdV8QkLs=;
	b=MZwcrqLn9UqczKx2HGzzAfVKVGhq4WeqvkWxzchNvoY4nKFwoj4lIQr69QoVD0j3qa2pCe
	vKiQri1rZBy0CSOnVTs0qTrtTN/NkalMQXWV0gqomBkkLq75GDpMNS/ASdAIn9xdbqtI0N
	NGOG7G1awuduVpTHnIuJ8JkoSUAOtR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859012;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvOoeg3vsxSRVlaUbkmOcNZLhXhilETWv/vFdV8QkLs=;
	b=h2pV6WzNIhXm6WgskecV981AMAzJZMAmhDYZBLLsBCGS5qkaJ7vPgSI0hrF+OFc4O/EJRT
	LapYf6dtggfit3BQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvOoeg3vsxSRVlaUbkmOcNZLhXhilETWv/vFdV8QkLs=;
	b=MZwcrqLn9UqczKx2HGzzAfVKVGhq4WeqvkWxzchNvoY4nKFwoj4lIQr69QoVD0j3qa2pCe
	vKiQri1rZBy0CSOnVTs0qTrtTN/NkalMQXWV0gqomBkkLq75GDpMNS/ASdAIn9xdbqtI0N
	NGOG7G1awuduVpTHnIuJ8JkoSUAOtR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859012;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvOoeg3vsxSRVlaUbkmOcNZLhXhilETWv/vFdV8QkLs=;
	b=h2pV6WzNIhXm6WgskecV981AMAzJZMAmhDYZBLLsBCGS5qkaJ7vPgSI0hrF+OFc4O/EJRT
	LapYf6dtggfit3BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E4D013693;
	Tue,  7 Oct 2025 17:43:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UoaLNUNR5Wj0dwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:31 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 05/20] smb: client: remove cached_fid->on_list
Date: Tue,  7 Oct 2025 14:42:49 -0300
Message-ID: <20251007174304.1755251-6-ematsumiya@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

That field is currently used to indicate when a cfid should be removed
from the entries list.

Since we now keep cfids on the list until they're going down, we can
remove the field and use the other existing fields for the same effect.

Other changes:
- cfids->num_entries follows semantics of list_*() ops
- add cfid_expired() helper
- check is_valid_cached_dir() even on success when leaving
  open_cached_dir()

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 77 ++++++++++++++------------------------
 fs/smb/client/cached_dir.h | 15 +++++---
 fs/smb/client/dir.c        | 17 ++++-----
 3 files changed, 46 insertions(+), 63 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index a8e467d38200..f72890786423 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -15,7 +15,6 @@
 static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
-static void cfids_laundromat_worker(struct work_struct *work);
 
 struct cached_dir_dentry {
 	struct list_head entry;
@@ -27,11 +26,10 @@ static inline void invalidate_cfid(struct cached_fid *cfid)
 	/* callers must hold the list lock and do any list operations (del/move) themselves */
 	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
 
-	if (cfid->on_list)
+	if (is_valid_cached_dir(cfid))
 		cfid->cfids->num_entries--;
 
 	/* do not change other fields here! */
-	cfid->on_list = false;
 	cfid->time = 0;
 	cfid->last_access_time = 1;
 }
@@ -76,6 +74,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 			 */
 			if (!is_valid_cached_dir(cfid))
 				return NULL;
+
 			kref_get(&cfid->refcount);
 			return cfid;
 		}
@@ -93,7 +92,6 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	cfid->cfids = cfids;
 	cfids->num_entries++;
 	list_add(&cfid->entry, &cfids->entries);
-	cfid->on_list = true;
 	kref_get(&cfid->refcount);
 	/*
 	 * Set @cfid->has_lease to true during construction so that the lease
@@ -260,6 +258,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	} else {
 		dentry = path_to_dentry(cifs_sb, npath);
 		if (IS_ERR(dentry)) {
+			dentry = NULL;
 			rc = -ENOENT;
 			goto out;
 		}
@@ -269,14 +268,14 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			spin_lock(&cfids->cfid_list_lock);
 			list_for_each_entry(parent_cfid, &cfids->entries, entry) {
 				if (parent_cfid->dentry == dentry->d_parent) {
+					if (!is_valid_cached_dir(parent_cfid))
+						break;
+
 					cifs_dbg(FYI, "found a parent cached file handle\n");
-					if (is_valid_cached_dir(parent_cfid)) {
-						lease_flags
-							|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
-						memcpy(pfid->parent_lease_key,
-						       parent_cfid->fid.lease_key,
-						       SMB2_LEASE_KEY_SIZE);
-					}
+
+					lease_flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
+					memcpy(pfid->parent_lease_key, parent_cfid->fid.lease_key,
+					       SMB2_LEASE_KEY_SIZE);
 					break;
 				}
 			}
@@ -285,6 +284,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	}
 	cfid->dentry = dentry;
 	cfid->tcon = tcon;
+	dentry = NULL;
 
 	/*
 	 * We do not hold the lock for the open because in case
@@ -412,24 +412,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 out:
-	if (rc) {
-		spin_lock(&cfids->cfid_list_lock);
-		if (cfid->on_list) {
-			list_del(&cfid->entry);
-			cfid->on_list = false;
-			cfids->num_entries--;
-		}
-		if (cfid->has_lease) {
-			/*
-			 * We are guaranteed to have two references at this
-			 * point. One for the caller and one for a potential
-			 * lease. Release one here, and the second below.
-			 */
-			cfid->has_lease = false;
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
-		}
-		spin_unlock(&cfids->cfid_list_lock);
+	/* cfid invalidated in the mean time, drop it below */
+	if (!rc && !is_valid_cached_dir(cfid))
+		rc = -ENOENT;
 
+	if (rc) {
+		drop_cfid(cfid);
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	} else {
 		*ret_cfid = cfid;
@@ -459,9 +447,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
-		if (cfid->dentry == dentry) {
-			if (!is_valid_cached_dir(cfid))
-				break;
+		if (is_valid_cached_dir(cfid) && cfid->dentry == dentry) {
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
@@ -480,23 +466,20 @@ smb2_close_cached_fid(struct kref *ref)
 	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
 
 	/*
-	 * There's no way a cfid can reach here with ->on_list == true.
+	 * There's no way a valid cfid can reach here.
 	 *
-	 * This is because we hould our own ref, and whenever we put it, we invalidate the cfid
-	 * (which sets ->on_list to false).
+	 * This is because we hould our own ref, and whenever we put it, we invalidate the cfid.
 	 *
-	 * So even if an external caller puts the last ref, ->on_list will already have been set to
-	 * false by then by one of the invalidations that can happen concurrently, e.g. lease break,
+	 * So even if an external caller puts the last ref, cfid will already have been invalidated
+	 * by then by one of the invalidations that can happen concurrently, e.g. lease break,
 	 * invalidate_all_cached_dirs().
 	 *
-	 * So this check is mostly for precaution, but since we can still take the correct actions
-	 * if it's the case, do so.
+	 * So this check is mostly for precaution, but since we can still take the correct action
+	 * (just list_del()) if it's the case, do so.
 	 */
-	if (WARN_ON(cfid->on_list)) {
+	if (WARN_ON(is_valid_cached_dir(cfid)))
+		/* remaining invalidation done by drop_cfid() below */
 		list_del(&cfid->entry);
-		cfid->on_list = false;
-		cfid->cfids->num_entries--;
-	}
 
 	drop_cfid(cfid);
 	free_cached_dir(cfid);
@@ -593,14 +576,14 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 {
 	struct cached_fids *cfids = tcon->cfids;
-	struct cached_fid *cfid, *q;
+	struct cached_fid *cfid;
 
 	if (!cfids)
 		return;
 
 	/* mark all the cfids as closed and invalidate them for laundromat cleanup */
 	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+	list_for_each_entry(cfid, &cfids->entries, entry) {
 		invalidate_cfid(cfid);
 		cfid->is_open = false;
 	}
@@ -709,8 +692,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-		if (cfid->last_access_time &&
-		    time_after(jiffies, cfid->last_access_time + HZ * dir_cache_timeout)) {
+		if (cfid_expired(cfid)) {
 			invalidate_cfid(cfid);
 			list_move(&cfid->entry, &entry);
 		}
@@ -728,8 +710,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		 * concurrent ref-holders, they'll drop it later (cfid is already invalid at this
 		 * point, so can't be found anymore).
 		 *
-		 * No risk for a double list_del() here because cfid->on_list is always false at
-		 * this point.
+		 * No risk for a double list_del() here because cfid is only on this list now.
 		 */
 		drop_cfid(cfid);
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 7614af617243..f9cb94c7f8d2 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -38,7 +38,6 @@ struct cached_fid {
 	const char *path;
 	bool has_lease:1;
 	bool is_open:1;
-	bool on_list:1;
 	bool file_all_info_is_valid:1;
 	unsigned long time; /* jiffies of when lease was taken */
 	unsigned long last_access_time; /* jiffies of when last accessed */
@@ -65,15 +64,19 @@ struct cached_fids {
 	atomic64_t total_dirents_bytes;
 };
 
-/* Module-wide directory cache accounting (defined in cifsfs.c) */
-extern atomic64_t cifs_dircache_bytes_used; /* bytes across all mounts */
+static inline bool cfid_expired(const struct cached_fid *cfid)
+{
+	return (cfid->last_access_time &&
+		time_is_before_jiffies(cfid->last_access_time + HZ * dir_cache_timeout));
+}
 
-static inline bool
-is_valid_cached_dir(struct cached_fid *cfid)
+static inline bool is_valid_cached_dir(struct cached_fid *cfid)
 {
-	return cfid->time && cfid->has_lease;
+	return (cfid->time && cfid->has_lease && !cfid_expired(cfid));
 }
 
+/* Module-wide directory cache accounting (defined in cifsfs.c) */
+extern atomic64_t cifs_dircache_bytes_used; /* bytes across all mounts */
 extern struct cached_fids *init_cached_dirs(void);
 extern void free_cached_dirs(struct cached_fids *cfids);
 extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index fc67a6441c96..31a0926774a8 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -321,16 +321,15 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		spin_lock(&tcon->cfids->cfid_list_lock);
 		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
 			if (parent_cfid->dentry == direntry->d_parent) {
+				if (!is_valid_cached_dir(parent_cfid))
+					break;
+
 				cifs_dbg(FYI, "found a parent cached file handle\n");
-				if (is_valid_cached_dir(parent_cfid)) {
-					lease_flags
-						|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
-					memcpy(fid->parent_lease_key,
-					       parent_cfid->fid.lease_key,
-					       SMB2_LEASE_KEY_SIZE);
-					parent_cfid->dirents.is_valid = false;
-					parent_cfid->dirents.is_failed = true;
-				}
+
+				lease_flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
+				memcpy(fid->parent_lease_key, parent_cfid->fid.lease_key,
+				       SMB2_LEASE_KEY_SIZE);
+				parent_cfid->dirents.is_valid = false;
 				break;
 			}
 		}
-- 
2.51.0

