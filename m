Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757B32E0B64
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859049; cv=none; b=FCoVN1XwcXU99PIcjYMUcvy9JszL6QkvPc+GLviMt2R60R35Njhd7NvJT+bGLR+NkOeq/D/B/oIl4KuRD5LKQ+h+v+fJsdN3nP6ts2gyJMhy49wZ3rHR2zvfU6rgOXLZ7Ycu1Bh7yIxg6n5Yq5RgiypDMKAJjuy7DWhJNRUehyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859049; c=relaxed/simple;
	bh=LZdePpZftaXs9IOz33KdnB1rm2FSnGCRa/mQWJOsg0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7WRi4SdNKPrick54s13wn9bdV6c8xV8zWNMgr0hMo7DsVwpOmMoiidFRcJHksmKmVIPjrpmct+MsNeZ1oSicO2FhR4H3H/di4CTOaMvC3Kyupbp8f7vTNTqj+m1d45pYliMZShyp00SbQI7Um5wZS04ZFMhgDHoJeJUfIJSGOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=On17kzT/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YNEBuNsf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=On17kzT/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YNEBuNsf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="On17kzT/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YNEBuNsf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="On17kzT/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YNEBuNsf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 13F4D34214;
	Tue,  7 Oct 2025 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=44vRzUTbIjM2Ow8AWZ750yGa2pc4I3QkqrZztYQ7xSU=;
	b=On17kzT/rX3883S2wHcEUtlUAEJQPcvOjnELZADI3mk5J1CfoScUCToRWKWLvYMElS0b3z
	aisWR2T/49B2+qJXcymtGNXJUAZOv8FmmqreTmtuusfvpLZo9G+IsgoXSWtemW8uS0gUgA
	Q8mZUnNO8iVG9Ci+IUuOVtNTI4EvYn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859025;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=44vRzUTbIjM2Ow8AWZ750yGa2pc4I3QkqrZztYQ7xSU=;
	b=YNEBuNsfzgT2tjz6ybeJg5RHNTom/Mrk2GhqXTbOZAXjd/zGpWJ2K1oI6mTNKKDsURfUUY
	ENuAk20f7F9e9+Ag==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="On17kzT/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YNEBuNsf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=44vRzUTbIjM2Ow8AWZ750yGa2pc4I3QkqrZztYQ7xSU=;
	b=On17kzT/rX3883S2wHcEUtlUAEJQPcvOjnELZADI3mk5J1CfoScUCToRWKWLvYMElS0b3z
	aisWR2T/49B2+qJXcymtGNXJUAZOv8FmmqreTmtuusfvpLZo9G+IsgoXSWtemW8uS0gUgA
	Q8mZUnNO8iVG9Ci+IUuOVtNTI4EvYn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859025;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=44vRzUTbIjM2Ow8AWZ750yGa2pc4I3QkqrZztYQ7xSU=;
	b=YNEBuNsfzgT2tjz6ybeJg5RHNTom/Mrk2GhqXTbOZAXjd/zGpWJ2K1oI6mTNKKDsURfUUY
	ENuAk20f7F9e9+Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 948F813693;
	Tue,  7 Oct 2025 17:43:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sU/fFlBR5WgOeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:44 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 09/20] smb: client: enhance cached dir lookups
Date: Tue,  7 Oct 2025 14:42:53 -0300
Message-ID: <20251007174304.1755251-10-ematsumiya@suse.de>
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 13F4D34214
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

Enable cfid lookups to be matched with the 3 modes (path, dentry,
and lease key) currently used in a single function.

Caller exposed function (find_cached_dir()) checks if cfid is
mid-creation in open_cached_dir() and retries the lookup, avoiding
opening the same path again.

Changes:
- expose find_cached_dir()
- add CFID_LOOKUP_* modes
- remove @lookup_only arg from open_cached_dir(), replace, in calllers,
  with find_cached_dir() where it was true
- remove open_cached_dir_by_dentry(), replace with find_cached_dir()
- use find_cached_dir() in cached_dir_lease_break()

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 201 +++++++++++++++++++++----------------
 fs/smb/client/cached_dir.h |  17 ++--
 fs/smb/client/dir.c        |  39 ++++---
 fs/smb/client/inode.c      |  13 +--
 fs/smb/client/readdir.c    |   4 +-
 fs/smb/client/smb2inode.c  |  10 +-
 fs/smb/client/smb2ops.c    |  10 +-
 7 files changed, 168 insertions(+), 126 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 067dfa7de4fc..100d608828f2 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -52,27 +52,63 @@ static inline void drop_cfid(struct cached_fid *cfid)
 	}
 }
 
-static struct cached_fid *find_cached_dir(struct cached_fids *cfids, const char *path)
+/*
+ * Find a cached dir based on @key and @mode (raw lookup).
+ * The only validation done here is if cfid is not going down (last_access_time != 1).
+ *
+ * If @wait_open is true, keep retrying until cfid transitions from 'opening' to valid/invalid.
+ *
+ * Callers must handle any other validation as needed.
+ * Returned cfid, if found, has a ref taken, regardless of state.
+ */
+static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key, int mode,
+				    bool wait_open)
 {
-	struct cached_fid *cfid;
+	struct cached_fid *cfid, *found;
+	bool match;
+
+	if (!cfids || !key)
+		return NULL;
+
+retry_find:
+	found = NULL;
 
+	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
-		if (!strcmp(cfid->path, path)) {
-			/*
-			 * If it doesn't have a lease it is either not yet
-			 * fully cached or it may be in the process of
-			 * being deleted due to a lease break.
-			 */
-			if (!is_valid_cached_dir(cfid))
-				return NULL;
+		/* don't even bother checking if it's going away */
+		if (cfid->last_access_time == 1)
+			continue;
 
-			cfid->last_access_time = jiffies;
+		if (mode == CFID_LOOKUP_PATH)
+			match = !strcmp(cfid->path, (char *)key);
+
+		if (mode == CFID_LOOKUP_DENTRY)
+			match = (cfid->dentry == key);
+
+		if (mode == CFID_LOOKUP_LEASEKEY)
+			match = !memcmp(cfid->fid.lease_key, (u8 *)key, SMB2_LEASE_KEY_SIZE);
+
+		if (!match)
+			continue;
+
+		/* only get a ref here if not waiting for open */
+		if (!wait_open)
 			kref_get(&cfid->refcount);
-			return cfid;
-		}
+		found = cfid;
+		break;
 	}
+	spin_unlock(&cfids->cfid_list_lock);
 
-	return NULL;
+	if (wait_open && found) {
+		/* cfid is being opened in open_cached_dir(), retry lookup */
+		if (found->has_lease && !found->time && !found->last_access_time)
+			goto retry_find;
+
+		/* we didn't get a ref above, so get one now */
+		kref_get(&found->refcount);
+	}
+
+	return found;
 }
 
 static struct dentry *
@@ -131,14 +167,38 @@ static const char *path_no_prefix(struct cifs_sb_info *cifs_sb,
 	return path + len;
 }
 
+/*
+ * Find a cached dir based on @key and @mode (caller exposed).
+ * This function will retry lookup if cfid found is in opening state.
+ *
+ * Returns valid cfid (with updated last_access_time) or NULL.
+ */
+struct cached_fid *find_cached_dir(struct cached_fids *cfids, const void *key, int mode)
+{
+	struct cached_fid *cfid;
+
+	if (!cfids || !key)
+		return NULL;
+
+	cfid = find_cfid(cfids, key, mode, true);
+	if (cfid) {
+		if (is_valid_cached_dir(cfid)) {
+			cfid->last_access_time = jiffies;
+		} else {
+			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			cfid = NULL;
+		}
+	}
+
+	return cfid;
+}
+
 /*
  * Open the and cache a directory handle.
  * If error then *cfid is not initialized.
  */
-int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
-		    const char *path,
-		    struct cifs_sb_info *cifs_sb,
-		    bool lookup_only, struct cached_fid **ret_cfid)
+int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
+		    struct cifs_sb_info *cifs_sb, struct cached_fid **ret_cfid)
 {
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
@@ -154,7 +214,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	__le16 *utf16_path = NULL;
 	u8 oplock = SMB2_OPLOCK_LEVEL_II;
 	struct cifs_fid *pfid;
-	struct dentry *dentry = NULL;
+	struct dentry *dentry;
 	struct cached_fid *cfid;
 	struct cached_fids *cfids;
 	const char *npath;
@@ -176,6 +236,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	/* reinitialize for possible replay */
 	flags = 0;
 	oplock = SMB2_OPLOCK_LEVEL_II;
+	dentry = NULL;
+	cfid = NULL;
+	*ret_cfid = NULL;
 	server = cifs_pick_channel(ses);
 
 	if (!server->ops->new_lease_key)
@@ -185,27 +248,25 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
-	spin_lock(&cfids->cfid_list_lock);
-	if (cfids->num_entries >= tcon->max_cached_dirs) {
-		spin_unlock(&cfids->cfid_list_lock);
-		kfree(utf16_path);
-		return -ENOENT;
+	/* find_cached_dir() already checks if cfid is valid, so no need to check here */
+	cfid = find_cached_dir(cfids, path, CFID_LOOKUP_PATH);
+	if (cfid) {
+		rc = 0;
+		goto out;
 	}
 
-	/* find_cached_dir() already checks if cfid is valid, so no need to check here */
-	cfid = find_cached_dir(cfids, path);
-	if (cfid || lookup_only) {
-		*ret_cfid = cfid;
+	spin_lock(&cfids->cfid_list_lock);
+	if (cfids->num_entries >= tcon->max_cached_dirs) {
 		spin_unlock(&cfids->cfid_list_lock);
-		kfree(utf16_path);
-		return cfid ? 0 : -ENOENT;
+		rc = -ENOENT;
+		goto out;
 	}
 
 	cfid = init_cached_dir(path);
 	if (!cfid) {
 		spin_unlock(&cfids->cfid_list_lock);
-		kfree(utf16_path);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
 
 	cfid->cfids = cfids;
@@ -392,8 +453,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		rc = -ENOENT;
 
 	if (rc) {
-		drop_cfid(cfid);
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		if (cfid) {
+			drop_cfid(cfid);
+			kref_put(&cfid->refcount, smb2_close_cached_fid);
+		}
 	} else {
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
@@ -407,34 +470,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
-			      struct dentry *dentry,
-			      struct cached_fid **ret_cfid)
-{
-	struct cached_fid *cfid;
-	struct cached_fids *cfids = tcon->cfids;
-
-	if (cfids == NULL)
-		return -EOPNOTSUPP;
-
-	if (!dentry)
-		return -ENOENT;
-
-	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry(cfid, &cfids->entries, entry) {
-		if (is_valid_cached_dir(cfid) && cfid->dentry == dentry) {
-			cifs_dbg(FYI, "found a cached file handle by dentry\n");
-			kref_get(&cfid->refcount);
-			*ret_cfid = cfid;
-			cfid->last_access_time = jiffies;
-			spin_unlock(&cfids->cfid_list_lock);
-			return 0;
-		}
-	}
-	spin_unlock(&cfids->cfid_list_lock);
-	return -ENOENT;
-}
-
 static void
 smb2_close_cached_fid(struct kref *ref)
 {
@@ -478,7 +513,7 @@ void drop_cached_dir_by_name(struct cached_fids *cfids, const char *name)
 	if (!cfids)
 		return;
 
-	cfid = find_cached_dir(cfids, name);
+	cfid = find_cached_dir(cfids, name, CFID_LOOKUP_PATH);
 	if (!cfid) {
 		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
 		return;
@@ -558,35 +593,31 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 {
 	struct cached_fids *cfids = tcon->cfids;
 	struct cached_fid *cfid;
-	bool found = false;
 
 	if (cfids == NULL)
 		return false;
 
-	spin_lock(&cfids->cfid_list_lock);
-	list_for_each_entry(cfid, &cfids->entries, entry) {
-		if (cfid->has_lease &&
-		    !memcmp(lease_key,
-			    cfid->fid.lease_key,
-			    SMB2_LEASE_KEY_SIZE)) {
-			/*
-			 * We found a lease, invalidate cfid and schedule immediate cleanup on
-			 * laundromat.
-			 * No need to take a ref here, as we still hold our initial one.
-			 */
-			invalidate_cfid(cfid);
-			cfid->has_lease = false;
-			found = true;
-			break;
-		}
-	}
-	spin_unlock(&cfids->cfid_list_lock);
+	/*
+	 * Raw lookup here as we _must_ find our lease, no matter cfid state.
+	 * Also, this lease break might be coming from the SMB2 open in open_cached_dir(), so no
+	 * need to wait for it to finish.
+	 */
+	cfid = find_cfid(cfids, lease_key, CFID_LOOKUP_LEASEKEY, false);
+	if (cfid) {
+		/* found a lease, invalidate cfid and schedule immediate cleanup on laundromat */
+		spin_lock(&cfids->cfid_list_lock);
+		invalidate_cfid(cfid);
+		cfid->has_lease = false;
+		spin_unlock(&cfids->cfid_list_lock);
 
-	/* avoid unnecessary scheduling */
-	if (found)
+		/* put lookup ref */
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
 		mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
 
-	return found;
+		return true;
+	}
+
+	return false;
 }
 
 static struct cached_fid *init_cached_dir(const char *path)
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 8018f7a947b5..8d9733b8fbb6 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -64,6 +64,13 @@ struct cached_fids {
 	atomic64_t total_dirents_bytes;
 };
 
+/* Lookup modes for find_cached_dir() */
+enum {
+	CFID_LOOKUP_PATH,
+	CFID_LOOKUP_DENTRY,
+	CFID_LOOKUP_LEASEKEY,
+};
+
 static inline bool cfid_expired(const struct cached_fid *cfid)
 {
 	return (cfid->last_access_time &&
@@ -78,13 +85,9 @@ static inline bool is_valid_cached_dir(struct cached_fid *cfid)
 /* Module-wide directory cache accounting (defined in cifsfs.c) */
 extern atomic64_t cifs_dircache_bytes_used; /* bytes across all mounts */
 extern struct cached_fids *init_cached_dirs(void);
-extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
-			   const char *path,
-			   struct cifs_sb_info *cifs_sb,
-			   bool lookup_only, struct cached_fid **cfid);
-extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
-				     struct dentry *dentry,
-				     struct cached_fid **cfid);
+extern struct cached_fid *find_cached_dir(struct cached_fids *cfids, const void *key, int mode);
+extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
+			   struct cifs_sb_info *cifs_sb, struct cached_fid **cfid);
 extern void close_cached_dir(struct cached_fid *cfid);
 extern void drop_cached_dir_by_name(struct cached_fids *cfids, const char *name);
 extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 31a0926774a8..5466f4968a84 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -677,7 +677,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	const char *full_path;
 	void *page;
 	int retry_count = 0;
-	struct cached_fid *cfid = NULL;
 
 	xid = get_xid();
 
@@ -728,16 +727,24 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		 * correct action even if case insensitive is not forced on
 		 * mount.
 		 */
-		if (pTcon->nocase && !open_cached_dir_by_dentry(pTcon, direntry->d_parent, &cfid)) {
+		if (pTcon->nocase) {
+			struct cached_fid *cfid = find_cached_dir(pTcon->cfids, direntry->d_parent,
+								  CFID_LOOKUP_DENTRY);
+
 			/*
-			 * dentry is negative and parent is fully cached:
-			 * we can assume file does not exist
+			 * dentry is negative and parent is fully cached, we can assume file does
+			 * not exist
+			 *
+			 * reuse rc here
 			 */
-			if (cfid->dirents.is_valid) {
+			rc = 0;
+			if (cfid) {
+				rc = cfid->dirents.is_valid;
 				close_cached_dir(cfid);
-				goto out;
 			}
-			close_cached_dir(cfid);
+
+			if (rc)
+				goto out;
 		}
 	}
 	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
@@ -785,7 +792,6 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 		  struct dentry *direntry, unsigned int flags)
 {
 	struct inode *inode = NULL;
-	struct cached_fid *cfid;
 	int rc;
 
 	if (flags & LOOKUP_RCU)
@@ -835,17 +841,20 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 	} else {
 		struct cifs_sb_info *cifs_sb = CIFS_SB(dir->i_sb);
 		struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+		struct cached_fid *cfid = find_cached_dir(tcon->cfids, direntry->d_parent,
+							  CFID_LOOKUP_DENTRY);
 
-		if (!open_cached_dir_by_dentry(tcon, direntry->d_parent, &cfid)) {
+		if (cfid) {
 			/*
-			 * dentry is negative and parent is fully cached:
-			 * we can assume file does not exist
+			 * dentry is negative and parent is fully cached, we can assume file does
+			 * not exist
+			 *
+			 * reuse rc here
 			 */
-			if (cfid->dirents.is_valid) {
-				close_cached_dir(cfid);
-				return 1;
-			}
+			rc = cfid->dirents.is_valid;
 			close_cached_dir(cfid);
+			if (rc)
+				return 1;
 		}
 	}
 
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index c99829f9ec06..34a31617c298 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2690,7 +2690,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-	struct cached_fid *cfid = NULL;
+	struct cached_fid *cfid;
 
 	if (test_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags))
 		return false;
@@ -2703,13 +2703,14 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	if (!lookupCacheEnabled)
 		return true;
 
-	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
-		if (cifs_i->time > cfid->time) {
-			close_cached_dir(cfid);
-			return false;
-		}
+	cfid = find_cached_dir(tcon->cfids, dentry->d_parent, CFID_LOOKUP_DENTRY);
+	if (cfid) {
+		bool valid = time_after(cifs_i->time, cfid->time);
+
 		close_cached_dir(cfid);
+		return !valid;
 	}
+
 	/*
 	 * depending on inode type, check if attribute caching disabled for
 	 * files or directories
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index f0ce26622a14..c9c32e4868eb 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -1079,7 +1079,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		tcon = tlink_tcon(cifsFile->tlink);
 	}
 
-	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, false, &cfid);
+	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
 	cifs_put_tlink(tlink);
 	if (rc)
 		goto cache_not_found;
@@ -1150,7 +1150,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	tcon = tlink_tcon(cifsFile->tlink);
 	rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
 			     &current_entry, &num_to_fill);
-	open_cached_dir(xid, tcon, full_path, cifs_sb, false, &cfid);
+	open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
 	if (rc) {
 		cifs_dbg(FYI, "fce error %d\n", rc);
 		goto rddir2_exit;
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index e69e9a3b5511..33962c72e2fc 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -964,12 +964,10 @@ int smb2_query_path_info(const unsigned int xid,
 	 * is fast enough (always using the compounded version).
 	 */
 	if (!tcon->posix_extensions) {
-		if (*full_path) {
-			rc = -ENOENT;
-		} else {
-			rc = open_cached_dir(xid, tcon, full_path,
-					     cifs_sb, false, &cfid);
-		}
+		rc = -ENOENT;
+		if (!*full_path)
+			rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
+
 		/* If it is a root and its handle is cached then use it */
 		if (!rc) {
 			if (cfid->file_all_info_is_valid) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 058050f744c0..26eba23c113d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -882,7 +882,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 		.fid = &fid,
 	};
 
-	rc = open_cached_dir(xid, tcon, "", cifs_sb, false, &cfid);
+	rc = open_cached_dir(xid, tcon, "", cifs_sb, &cfid);
 	if (rc == 0)
 		memcpy(&fid, &cfid->fid, sizeof(struct cifs_fid));
 	else
@@ -952,8 +952,8 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	bool islink;
 	int rc, rc2;
 
-	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
-	if (!rc) {
+	cfid = find_cached_dir(tcon->cfids, full_path, CFID_LOOKUP_PATH);
+	if (cfid) {
 		close_cached_dir(cfid);
 		return 0;
 	}
@@ -2744,8 +2744,8 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	 * We can only call this for things we know are directories.
 	 */
 	if (!strcmp(path, ""))
-		open_cached_dir(xid, tcon, path, cifs_sb, false,
-				&cfid); /* cfid null if open dir failed */
+		/* cfid null if open dir failed */
+		open_cached_dir(xid, tcon, path, cifs_sb, &cfid);
 
 	rqst[0].rq_iov = vars->open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
-- 
2.51.0

