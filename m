Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB75155389
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859042; cv=none; b=Nv9YJ1PJMyXGhz2uim9fpISsximBp52XryyTyUhBF0vSbl5lXFW7nifs4YXxXI280kSnEeMSDYdXE8qeGjLR/cpV71FrFGEoUZMqvwVfmCHmptP4gFUjxX6/3SJ0BYeonYWxK2UyCaKMwS+WYP1OZuWA4s98LkqYXX1YFxX6qgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859042; c=relaxed/simple;
	bh=Bj6xYUMt+kelHEjpRPfJBF2/jRYWvI9hUOLvU3/Fk7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VddfDD2gvYHocX1iUv1cYRdrrUbOIRBT+jkN3/bh3wnKnpsGnRS9LATgQq/pRZOWqhv6HUiPEdc0wTLZCyt8T0KIKVGg4Rn01SWvxZWVdXUtOnNCICX5re2AqTgZCwRj/kYdsQeep0YaJQ2hXRRA90zL5ldnKtCvBbkcehfD1VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iu5mjj7i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Hb46zpe+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iu5mjj7i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Hb46zpe+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iu5mjj7i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Hb46zpe+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iu5mjj7i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Hb46zpe+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE98A34215;
	Tue,  7 Oct 2025 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cgvpb1lbwtUzB2KO/xSgBo8iGiwN53L9NyRTfFf6LYM=;
	b=iu5mjj7i4Y3aPWivMXX542CrkKF6Wn0Cl0m0jWlN/c/ztpczUBZrip+4ZoR7fVMu6ONKl6
	1l4sjGT2pJ6D6X9r4Nhe97DtfakSaOjeTURIoJHPmQ/xgY3/KiAL3EOEMFYempjyQZ0+hv
	ximbMFAW4UqiMpVyFwJ4H89cKjqtsPI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cgvpb1lbwtUzB2KO/xSgBo8iGiwN53L9NyRTfFf6LYM=;
	b=Hb46zpe+SV2UqvIu+nxD1zukPjFtzC7ROy3T0OxFcpgz4hjjmCh2lYY/Y3YolkIh8QtqPG
	tGLGx9X5/c3CX8CA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cgvpb1lbwtUzB2KO/xSgBo8iGiwN53L9NyRTfFf6LYM=;
	b=iu5mjj7i4Y3aPWivMXX542CrkKF6Wn0Cl0m0jWlN/c/ztpczUBZrip+4ZoR7fVMu6ONKl6
	1l4sjGT2pJ6D6X9r4Nhe97DtfakSaOjeTURIoJHPmQ/xgY3/KiAL3EOEMFYempjyQZ0+hv
	ximbMFAW4UqiMpVyFwJ4H89cKjqtsPI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cgvpb1lbwtUzB2KO/xSgBo8iGiwN53L9NyRTfFf6LYM=;
	b=Hb46zpe+SV2UqvIu+nxD1zukPjFtzC7ROy3T0OxFcpgz4hjjmCh2lYY/Y3YolkIh8QtqPG
	tGLGx9X5/c3CX8CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B44013693;
	Tue,  7 Oct 2025 17:43:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jc/uDE1R5WgKeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:41 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 08/20] smb: client: split find_or_create_cached_dir()
Date: Tue,  7 Oct 2025 14:42:52 -0300
Message-ID: <20251007174304.1755251-9-ematsumiya@suse.de>
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
index 155013602dbb..067dfa7de4fc 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -52,10 +52,7 @@ static inline void drop_cfid(struct cached_fid *cfid)
 	}
 }
 
-static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
-						    const char *path,
-						    bool lookup_only,
-						    __u32 max_cached_dirs)
+static struct cached_fid *find_cached_dir(struct cached_fids *cfids, const char *path)
 {
 	struct cached_fid *cfid;
 
@@ -69,35 +66,13 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 			if (!is_valid_cached_dir(cfid))
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
@@ -195,9 +170,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	ses = tcon->ses;
 	cfids = tcon->cfids;
 
-	if (cfids == NULL)
+	if (!cfids)
 		return -EOPNOTSUPP;
-
 replay_again:
 	/* reinitialize for possible replay */
 	flags = 0;
@@ -212,24 +186,31 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
-	if (is_valid_cached_dir(cfid)) {
-		cfid->last_access_time = jiffies;
-		spin_unlock(&cfids->cfid_list_lock);
+
+	/* find_cached_dir() already checks if cfid is valid, so no need to check here */
+	cfid = find_cached_dir(cfids, path);
+	if (cfid || lookup_only) {
 		*ret_cfid = cfid;
+		spin_unlock(&cfids->cfid_list_lock);
 		kfree(utf16_path);
-		return 0;
+		return cfid ? 0 : -ENOENT;
 	}
+
+	cfid = init_cached_dir(path);
+	if (!cfid) {
+		spin_unlock(&cfids->cfid_list_lock);
+		kfree(utf16_path);
+		return -ENOMEM;
+	}
+
+	cfid->cfids = cfids;
+	cfids->num_entries++;
+	list_add(&cfid->entry, &cfids->entries);
 	spin_unlock(&cfids->cfid_list_lock);
 
 	pfid = &cfid->fid;
@@ -490,19 +471,22 @@ smb2_close_cached_fid(struct kref *ref)
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
 
@@ -612,6 +596,7 @@ static struct cached_fid *init_cached_dir(const char *path)
 	cfid = kzalloc(sizeof(*cfid), GFP_ATOMIC);
 	if (!cfid)
 		return NULL;
+
 	cfid->path = kstrdup(path, GFP_ATOMIC);
 	if (!cfid->path) {
 		kfree(cfid);
@@ -621,7 +606,23 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
+
+	/* this is our ref */
 	kref_init(&cfid->refcount);
+
+	/* this is caller ref */
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
index be115116c33c..8018f7a947b5 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -86,10 +86,7 @@ extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
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
index 8bb544be401e..c99829f9ec06 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2629,7 +2629,7 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 			 * ->i_nlink and then mark it as delete pending.
 			 */
 			if (S_ISDIR(inode->i_mode)) {
-				drop_cached_dir_by_name(xid, tcon, to_name, cifs_sb);
+				drop_cached_dir_by_name(tcon->cfids, to_name);
 				spin_lock(&inode->i_lock);
 				i_size_write(inode, 0);
 				clear_nlink(inode);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 0985db9f86e5..e69e9a3b5511 100644
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
@@ -1317,7 +1317,7 @@ int smb2_rename_path(const unsigned int xid,
 	struct cifsFileInfo *cfile;
 	__u32 co = file_create_options(source_dentry);
 
-	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
+	drop_cached_dir_by_name(tcon->cfids, from_name);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
 	int rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
@@ -1599,7 +1599,7 @@ int smb2_rename_pending_delete(const char *full_path,
 		goto out;
 	}
 
-	drop_cached_dir_by_name(xid, tcon, full_path, cifs_sb);
+	drop_cached_dir_by_name(tcon->cfids, full_path);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     DELETE | FILE_WRITE_ATTRIBUTES,
 			     FILE_OPEN, co, ACL_NO_MODE);
-- 
2.51.0

