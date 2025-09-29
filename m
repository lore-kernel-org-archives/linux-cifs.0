Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2F81F95C
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152549; cv=none; b=cDAVhiBFd+kJ/yghRf4VHBSZOiBzXMiPxkFuAp/qB8H3MY1NMGd+0LTFz/1dMNjw9FfZSW7dNuMxWul/R5M1c70l9gLYoDBFPKK+omyGDpC+5nsCUduD5x6QuS64Yy0K+ll3AvL23BTNbZXhY1f21TP8nRdUanRZkVBRsVFOwCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152549; c=relaxed/simple;
	bh=rMV5DWZ+B6ROmLdOnYQUX82ViqNV8VNbWmIumWyhEIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzNdihBPkHcoBSlNBAwPByreY9WILCCuJJOD0Bh6X3CcqXwPMpzdi9ghtyj5awX0VmdiQT47ARF1oHNx1uF400O3ZINVSOZlMjD3zso4kp0EJDJKAPTgUxSlrqWeMok7d5igcEpNNM/JTo1jznkvfJpXtUT1FSBIXrFyRoXRF0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oeVR3wDl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z/+uQYDG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oeVR3wDl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z/+uQYDG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oeVR3wDl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z/+uQYDG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oeVR3wDl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z/+uQYDG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8BCCA33725;
	Mon, 29 Sep 2025 13:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGJnhy36D8p2vsWnpyPCWEeovHXA2SNa6qQVXbPTwuc=;
	b=oeVR3wDlrp6YBg84KpHuCwHZDBapjzdMmiCmk8MXNcPwEd0fh1pbGTITSBSEdYWXl9k41/
	l/Ttkk2vx1HtnAyjJim5VIJnmsej76sGLvYsq9DrrHsIZ5RmAy4NAUzl3TZoedcGassL+p
	8rRKRV1zv5+7mXwUSzXfe3vnF7Wg2G8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152545;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGJnhy36D8p2vsWnpyPCWEeovHXA2SNa6qQVXbPTwuc=;
	b=z/+uQYDGjPgEb5Z4+rMl2u2yUe1wzmIfmllyx1BGoiDJLlWo5wWHCQBYIFMZ2eCO1lJHqm
	pCsJeOlczoIdIhAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGJnhy36D8p2vsWnpyPCWEeovHXA2SNa6qQVXbPTwuc=;
	b=oeVR3wDlrp6YBg84KpHuCwHZDBapjzdMmiCmk8MXNcPwEd0fh1pbGTITSBSEdYWXl9k41/
	l/Ttkk2vx1HtnAyjJim5VIJnmsej76sGLvYsq9DrrHsIZ5RmAy4NAUzl3TZoedcGassL+p
	8rRKRV1zv5+7mXwUSzXfe3vnF7Wg2G8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152545;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGJnhy36D8p2vsWnpyPCWEeovHXA2SNa6qQVXbPTwuc=;
	b=z/+uQYDGjPgEb5Z4+rMl2u2yUe1wzmIfmllyx1BGoiDJLlWo5wWHCQBYIFMZ2eCO1lJHqm
	pCsJeOlczoIdIhAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A74513782;
	Mon, 29 Sep 2025 13:29:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cdbcNKCJ2mjiGwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:29:04 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 08/20] smb: client: split find_or_create_cached_dir()
Date: Mon, 29 Sep 2025 10:27:53 -0300
Message-ID: <20250929132805.220558-9-ematsumiya@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

This patch splits the function into 2 separate ones; it not only makes
the code clearer, but also allows further and easier enhancements to
both.

So move the initialization part into init_cached_dir() and add
find_cached_dir() for lookups.

Other:
- drop_cached_dir_by_name():
  * use find_cached_dir()
  * remove no longer used args

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 95 +++++++++++++++++++-------------------
 fs/smb/client/cached_dir.h |  5 +-
 fs/smb/client/inode.c      |  2 +-
 fs/smb/client/smb2inode.c  |  6 +--
 4 files changed, 53 insertions(+), 55 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 8c8ead6e96bd..92898880d20f 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -54,10 +54,7 @@ static inline void drop_cfid(struct cached_fid *cfid)
 	}
 }
 
-static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
-						    const char *path,
-						    bool lookup_only,
-						    __u32 max_cached_dirs)
+static struct cached_fid *find_cached_dir(struct cached_fids *cfids, const char *path)
 {
 	struct cached_fid *cfid;
 
@@ -71,35 +68,13 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 			if (!cfid_is_valid(cfid))
 				return NULL;
 
+			cfid->last_access_time = jiffies;
 			kref_get(&cfid->refcount);
 			return cfid;
 		}
 	}
-	if (lookup_only) {
-		return NULL;
-	}
-	if (cfids->num_entries >= max_cached_dirs) {
-		return NULL;
-	}
-	cfid = init_cached_dir(path);
-	if (cfid == NULL) {
-		return NULL;
-	}
-	cfid->cfids = cfids;
-	cfids->num_entries++;
-	list_add(&cfid->entry, &cfids->entries);
-	kref_get(&cfid->refcount);
-	/*
-	 * Set @cfid->has_lease to true during construction so that the lease
-	 * reference can be put in cached_dir_lease_break() due to a potential
-	 * lease break right after the request is sent or while @cfid is still
-	 * being cached, or if a reconnection is triggered during construction.
-	 * Concurrent processes won't be to use it yet due to @cfid->time being
-	 * zero.
-	 */
-	cfid->has_lease = true;
 
-	return cfid;
+	return NULL;
 }
 
 static struct dentry *
@@ -197,9 +172,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	ses = tcon->ses;
 	cfids = tcon->cfids;
 
-	if (cfids == NULL)
+	if (!cfids)
 		return -EOPNOTSUPP;
-
 replay_again:
 	/* reinitialize for possible replay */
 	flags = 0;
@@ -214,24 +188,31 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	spin_lock(&cfids->cfid_list_lock);
-	cfid = find_or_create_cached_dir(cfids, path, lookup_only, tcon->max_cached_dirs);
-	if (cfid == NULL) {
+	if (cfids->num_entries >= tcon->max_cached_dirs) {
 		spin_unlock(&cfids->cfid_list_lock);
 		kfree(utf16_path);
 		return -ENOENT;
 	}
-	/*
-	 * Return cached fid if it is valid (has a lease and has a time).
-	 * Otherwise, it is either a new entry or laundromat worker removed it
-	 * from @cfids->entries.  Caller will put last reference if the latter.
-	 */
-	if (cfid->has_lease && cfid->time) {
-		cfid->last_access_time = jiffies;
-		spin_unlock(&cfids->cfid_list_lock);
+
+	/* find_cached_dir() already checks if has_lease and time, so no need to check here */
+	cfid = find_cached_dir(cfids, path);
+	if (cfid || lookup_only) {
 		*ret_cfid = cfid;
+		spin_unlock(&cfids->cfid_list_lock);
+		kfree(utf16_path);
+		return cfid ? 0 : -ENOENT;
+	}
+
+	cfid = init_cached_dir(path);
+	if (!cfid) {
+		spin_unlock(&cfids->cfid_list_lock);
 		kfree(utf16_path);
-		return 0;
+		return -ENOMEM;
 	}
+
+	cfid->cfids = cfids;
+	cfids->num_entries++;
+	list_add(&cfid->entry, &cfids->entries);
 	spin_unlock(&cfids->cfid_list_lock);
 
 	pfid = &cfid->fid;
@@ -487,19 +468,22 @@ smb2_close_cached_fid(struct kref *ref)
 	kfree(cfid);
 }
 
-void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
-			     const char *name, struct cifs_sb_info *cifs_sb)
+void drop_cached_dir_by_name(struct cached_fids *cfids, const char *name)
 {
-	struct cached_fid *cfid = NULL;
-	int rc;
+	struct cached_fid *cfid;
 
-	rc = open_cached_dir(xid, tcon, name, cifs_sb, true, &cfid);
-	if (rc) {
+	if (!cfids)
+		return;
+
+	cfid = find_cached_dir(cfids, name);
+	if (!cfid) {
 		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
 		return;
 	}
 
 	drop_cfid(cfid);
+
+	/* put lookup ref */
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
 }
 
@@ -609,6 +593,7 @@ static struct cached_fid *init_cached_dir(const char *path)
 	cfid = kzalloc(sizeof(*cfid), GFP_ATOMIC);
 	if (!cfid)
 		return NULL;
+
 	cfid->path = kstrdup(path, GFP_ATOMIC);
 	if (!cfid->path) {
 		kfree(cfid);
@@ -619,7 +604,23 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
 	spin_lock_init(&cfid->fid_lock);
+
+	/* this is our ref */
 	kref_init(&cfid->refcount);
+
+	/* this is caller/lease ref */
+	kref_get(&cfid->refcount);
+
+	/*
+	 * Set @cfid->has_lease to true during construction so that the lease
+	 * reference can be put in cached_dir_lease_break() due to a potential
+	 * lease break right after the request is sent or while @cfid is still
+	 * being cached, or if a reconnection is triggered during construction.
+	 * Concurrent processes won't be to use it yet due to @cfid->time being
+	 * zero.
+	 */
+	cfid->has_lease = true;
+
 	return cfid;
 }
 
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 47c0404ba84a..4bc93131275e 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -79,10 +79,7 @@ extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 				     struct dentry *dentry,
 				     struct cached_fid **cfid);
 extern void close_cached_dir(struct cached_fid *cfid);
-extern void drop_cached_dir_by_name(const unsigned int xid,
-				    struct cifs_tcon *tcon,
-				    const char *name,
-				    struct cifs_sb_info *cifs_sb);
+extern void drop_cached_dir_by_name(struct cached_fids *cfids, const char *name);
 extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
 extern void invalidate_all_cached_dirs(struct cached_fids *cfids);
 extern bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index e80bf55765b6..9344a86f6d46 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2615,7 +2615,7 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 			 * ->i_nlink and then mark it as delete pending.
 			 */
 			if (S_ISDIR(inode->i_mode)) {
-				drop_cached_dir_by_name(xid, tcon, to_name, cifs_sb);
+				drop_cached_dir_by_name(tcon->cfids, to_name);
 				spin_lock(&inode->i_lock);
 				i_size_write(inode, 0);
 				clear_nlink(inode);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 7cadc8ca4f55..f462845dd167 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1162,7 +1162,7 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 {
 	struct cifs_open_parms oparms;
 
-	drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
+	drop_cached_dir_by_name(tcon->cfids, name);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, DELETE,
 			     FILE_OPEN, CREATE_NOT_FILE, ACL_NO_MODE);
 	return smb2_compound_op(xid, tcon, cifs_sb,
@@ -1240,7 +1240,7 @@ int smb2_rename_path(const unsigned int xid,
 	struct cifsFileInfo *cfile;
 	__u32 co = file_create_options(source_dentry);
 
-	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
+	drop_cached_dir_by_name(tcon->cfids, from_name);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
 	int rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
@@ -1522,7 +1522,7 @@ int smb2_rename_pending_delete(const char *full_path,
 		goto out;
 	}
 
-	drop_cached_dir_by_name(xid, tcon, full_path, cifs_sb);
+	drop_cached_dir_by_name(tcon->cfids, full_path);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     DELETE | FILE_WRITE_ATTRIBUTES,
 			     FILE_OPEN, co, ACL_NO_MODE);
-- 
2.49.0

