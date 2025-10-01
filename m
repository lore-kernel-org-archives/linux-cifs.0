Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC25419E81F
	for <linux-cifs@vger.kernel.org>; Wed,  1 Oct 2025 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759342970; cv=none; b=sXt2wy11TNqJuI/DIcECvTjEoaw5dtKeKKg0UeuzysCyrXe0OD76jgIHppuMTv1eH8zESGJwHGLv4JpiUJHgOlLvTvMZTeTI0O4LSbYPiPIMcNOSKo3GZxz5BbxBcoWMRxL3M+PszLNmW8Y5yqyXtRvm5hcEIWiZlP/TXU0mcGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759342970; c=relaxed/simple;
	bh=1HG+xuO1AFvt3swxiHOpgpcIiW08Wojer/sXgIXfsTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OAsE8pibgcc7/X6Y4JgVd1KOc47Z4+fBRGdMAHk3beMwMxDYss0whhvOGkllL7HhxQdaqt/eMKHV69zumlUInURAqLog2V57L90HuAATmSj1VnKGnif4jQnpwBL7ehNdJy5XiU3DienIsSbxjVYByYrLnaaEG0Agp7irvdWUNyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ljJG3BfZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KzilTdK9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XPwhXAo3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xZqmfPMX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ljJG3BfZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KzilTdK9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XPwhXAo3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xZqmfPMX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E732233718;
	Wed,  1 Oct 2025 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759342966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wDGAg4Ixy5gQMv6arT5teKUq7X669aSOFZzxFqt58Xc=;
	b=ljJG3BfZgXYKtRTu3yfGYkj6+OlKfhCAuWbjd3pUD1PbJ9/F60HimFOrYMiFlAOOo2kmF8
	ryUz1xlWsSg8IDJ19ZFYnct2QCOmGc8dc4TZSW+B8vj6XAWIjbrKhRrtnAqBD2flqZqCn0
	TvXFv5klDN02n7CI4ZpQbBsTjvhzYeQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759342966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wDGAg4Ixy5gQMv6arT5teKUq7X669aSOFZzxFqt58Xc=;
	b=KzilTdK9PkLjLkk/rJ37zuA1MZU2NbeegFnqTnIOsxwU3+i81ziZfukQD92XWUwSotRAcJ
	UGypPyVtqouKYxDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759342965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wDGAg4Ixy5gQMv6arT5teKUq7X669aSOFZzxFqt58Xc=;
	b=XPwhXAo3IbTIs52/dNyhhCvKJvzjV4RuwLLk9JGvbAtrkDZK5A7CU9GF3ArYJYDMStDoMB
	NBBcGUxzB3zM2yIUx7YrE7X6ZpPuIR2rD/yZ/bPGHXTKlZGzkJCIu6ZG8eCdokENOHmap1
	TBX5sO9JPdQZEdblW3vqeLtoozw+ogc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759342965;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wDGAg4Ixy5gQMv6arT5teKUq7X669aSOFZzxFqt58Xc=;
	b=xZqmfPMX9oBUH3LrFxk3fUWh6Uj0++D1WYENgcFaYLnQuEFuiSGiaNVpyZ27AiFiM1FPPr
	PWhQ3XApbs52tCAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71AAB13A42;
	Wed,  1 Oct 2025 18:22:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oyZCDnVx3WhqbAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 01 Oct 2025 18:22:45 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 12/20] smb: client: prevent lease breaks of cached parents when opening children
Date: Wed,  1 Oct 2025 15:21:11 -0300
Message-ID: <20251001182111.731114-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.49.0
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

In SMB2_open_init() lookup for a cached parent of target path and set
ParentLeaseKey in lease context if found.

Introduce invalidate_cached_dirents() to allow revalidation of cached
dirents but still keep the cached directory.

Testing with e.g. xfstests generic/637 (small simple test) shows a
performance gain of ~17% less create/open ops, and ~83% less lease
breaks:

Before patch
Create/open:
  # tshark -Y 'smb2.create.disposition == 1' -r unpatched.pcap
  169

Lease breaks:
  # tshark -Y 'smb2.cmd == 18' -r unpatched.pcap
  12
-----------------
After patch:
Create/open:
  # tshark -Y 'smb2.create.disposition == 1' -r patched.pcap
  144

Lease breaks:
  # tshark -Y 'smb2.cmd == 18' -r patched.pcap
  2

Other:
- set oparms->cifs_sb in open_cached_dir() as we need it in
  check_cached_parent(); use CIFS_OPARMS() too
- introduce CFID_LOOKUP_PARENT lookup mode (for string paths only)
- add cached_fids->dirsep to save dir separator, used by parent lookups

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2:
- added invalidate_cached_dirents()
- fixed conditions to add ParentLeaseKey
- fixed wrong function name in commit message
- added performance comparison without and with patch to commit message


 fs/smb/client/cached_dir.c | 106 ++++++++++++++++++++++++-------------
 fs/smb/client/cached_dir.h |   5 ++
 fs/smb/client/dir.c        |  23 +-------
 fs/smb/client/smb2inode.c  |  10 +++-
 fs/smb/client/smb2pdu.c    |  63 +++++++++++++++++-----
 5 files changed, 133 insertions(+), 74 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index ff71f2c06b72..b48c36500e77 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -71,11 +71,29 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
 				    bool wait_open)
 {
 	struct cached_fid *cfid, *found;
+	const char *parent_path = NULL;
 	bool match;
 
 	if (!cfids || !key)
 		return NULL;
 
+	if (mode == CFID_LOOKUP_PARENT) {
+		const char *path = key;
+
+		if (!*path)
+			return NULL;
+
+		parent_path = strrchr(path, cfids->dirsep);
+		if (!parent_path)
+			return NULL;
+
+		parent_path = kstrndup(path, parent_path - path, GFP_KERNEL);
+		if (WARN_ON_ONCE(!parent_path))
+			return NULL;
+
+		key = parent_path;
+		mode = CFID_LOOKUP_PATH;
+	}
 retry_find:
 	found = NULL;
 
@@ -114,6 +132,8 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
 		kref_get(&found->refcount);
 	}
 
+	kfree(parent_path);
+
 	return found;
 }
 
@@ -226,7 +246,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	struct cached_fids *cfids;
 	const char *npath;
 	int retries = 0, cur_sleep = 1;
-	__le32 lease_flags = 0;
 
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
@@ -236,9 +255,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 
 	ses = tcon->ses;
 	cfids = tcon->cfids;
-
 	if (!cfids)
 		return -EOPNOTSUPP;
+
+	if (!cfids->dirsep)
+		cfids->dirsep = CIFS_DIR_SEP(cifs_sb);
 replay_again:
 	/* reinitialize for possible replay */
 	flags = 0;
@@ -306,24 +327,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 			rc = -ENOENT;
 			goto out;
 		}
-		if (dentry->d_parent && server->dialect >= SMB30_PROT_ID) {
-			struct cached_fid *parent_cfid;
-
-			spin_lock(&cfids->cfid_list_lock);
-			list_for_each_entry(parent_cfid, &cfids->entries, entry) {
-				if (parent_cfid->dentry == dentry->d_parent) {
-					if (!cfid_is_valid(parent_cfid))
-						break;
-
-					cifs_dbg(FYI, "found a parent cached file handle\n");
-					lease_flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
-					memcpy(pfid->parent_lease_key, parent_cfid->fid.lease_key,
-					       SMB2_LEASE_KEY_SIZE);
-					break;
-				}
-			}
-			spin_unlock(&cfids->cfid_list_lock);
-		}
 	}
 	cfid->dentry = dentry;
 	cfid->tcon = tcon;
@@ -350,20 +353,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	oparms = (struct cifs_open_parms) {
-		.tcon = tcon,
-		.path = path,
-		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
-		.desired_access =  FILE_READ_DATA | FILE_READ_ATTRIBUTES |
-				   FILE_READ_EA,
-		.disposition = FILE_OPEN,
-		.fid = pfid,
-		.lease_flags = lease_flags,
-		.replay = !!(retries),
-	};
-
-	rc = SMB2_open_init(tcon, server,
-			    &rqst[0], &oplock, &oparms, utf16_path);
+	oparms = CIFS_OPARMS(cifs_sb, tcon, path,
+			     FILE_READ_DATA | FILE_READ_ATTRIBUTES | FILE_READ_EA, FILE_OPEN,
+			     cifs_create_options(cifs_sb, CREATE_NOT_FILE), 0);
+	oparms.fid = pfid;
+	oparms.replay = !!retries;
+
+	rc = SMB2_open_init(tcon, server, &rqst[0], &oplock, &oparms, utf16_path);
 	if (rc)
 		goto oshr_free;
 	smb2_set_next_command(tcon, &rqst[0]);
@@ -478,20 +474,34 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	return rc;
 }
 
-static void smb2_close_cached_fid(struct kref *ref)
+static void __invalidate_cached_dirents(struct cached_fid *cfid)
 {
-	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
 	struct cached_dirent *de, *q;
 
-	drop_cfid(cfid);
+	if (!cfid)
+		return;
 
-	/* Delete all cached dirent names */
+	mutex_lock(&cfid->dirents.de_mutex);
 	list_for_each_entry_safe(de, q, &cfid->dirents.entries, entry) {
 		list_del(&de->entry);
 		kfree(de->name);
 		kfree(de);
 	}
 
+	cfid->dirents.is_valid = false;
+	cfid->dirents.is_failed = false;
+	cfid->dirents.file = NULL;
+	cfid->dirents.pos = 0;
+	mutex_unlock(&cfid->dirents.de_mutex);
+}
+
+static void smb2_close_cached_fid(struct kref *ref)
+{
+	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
+
+	__invalidate_cached_dirents(cfid);
+	drop_cfid(cfid);
+
 	kfree(cfid->file_all_info);
 	cfid->file_all_info = NULL;
 	kfree(cfid->path);
@@ -531,6 +541,26 @@ bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode)
 	return true;
 }
 
+/*
+ * Invalidate cached dirents from @key's parent, regardless if @key itself is a cached dir.
+ *
+ * Lease breaks don't necessarily require this, and would require finding the child to begin with,
+ * so skip such cases.
+ */
+void invalidate_cached_dirents(struct cached_fids *cfids, const void *key, int mode)
+{
+	struct cached_fid *cfid = NULL;
+
+	if (mode == CFID_LOOKUP_LEASEKEY)
+		return;
+
+	cfid = find_cfid(cfids, key, mode, false);
+	if (cfid) {
+		__invalidate_cached_dirents(cfid);
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
+	}
+}
+
 void close_cached_dir(struct cached_fid *cfid)
 {
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index c45151446049..343963a589e6 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -54,11 +54,15 @@ struct cached_fids {
 	int num_entries;
 	struct list_head entries;
 	struct delayed_work laundromat_work;
+
+	/* convenience for parent lookups */
+	int dirsep;
 };
 
 /* Lookup modes for find_cached_dir() */
 enum {
 	CFID_LOOKUP_PATH,
+	CFID_LOOKUP_PARENT,
 	CFID_LOOKUP_DENTRY,
 	CFID_LOOKUP_LEASEKEY,
 };
@@ -79,6 +83,7 @@ extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char
 			   struct cifs_sb_info *cifs_sb, struct cached_fid **cfid);
 extern void close_cached_dir(struct cached_fid *cfid);
 extern bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode);
+extern void invalidate_cached_dirents(struct cached_fids *cfids, const void *key, int mode);
 extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
 extern void invalidate_all_cached_dirs(struct cached_fids *cfids);
 #endif			/* _CACHED_DIR_H */
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index e5372c2c799d..03aa54edba3e 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -190,9 +190,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	int disposition;
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
-	struct cached_fid *parent_cfid = NULL;
 	int rdwr_for_fscache = 0;
-	__le32 lease_flags = 0;
 
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
@@ -314,26 +312,8 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
 		create_options |= CREATE_OPTION_READONLY;
 
-
 retry_open:
-	if (tcon->cfids && direntry->d_parent && server->dialect >= SMB30_PROT_ID) {
-		parent_cfid = NULL;
-		spin_lock(&tcon->cfids->cfid_list_lock);
-		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
-			if (parent_cfid->dentry == direntry->d_parent) {
-				if (!cfid_is_valid(parent_cfid))
-					break;
-
-				cifs_dbg(FYI, "found a parent cached file handle\n");
-				lease_flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
-				memcpy(fid->parent_lease_key, parent_cfid->fid.lease_key,
-				       SMB2_LEASE_KEY_SIZE);
-				parent_cfid->dirents.is_valid = false;
-				break;
-			}
-		}
-		spin_unlock(&tcon->cfids->cfid_list_lock);
-	}
+	invalidate_cached_dirents(tcon->cfids, direntry->d_parent, CFID_LOOKUP_DENTRY);
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -343,7 +323,6 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		.disposition = disposition,
 		.path = full_path,
 		.fid = fid,
-		.lease_flags = lease_flags,
 		.mode = mode,
 	};
 	rc = server->ops->open(xid, &oparms, oplock, buf);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 8ccdd1a3ba2c..53bc1250391f 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1120,6 +1120,8 @@ smb2_mkdir(const unsigned int xid, struct inode *parent_inode, umode_t mode,
 {
 	struct cifs_open_parms oparms;
 
+	invalidate_cached_dirents(tcon->cfids, name, CFID_LOOKUP_PARENT);
+
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES,
 			     FILE_CREATE, CREATE_NOT_FILE, mode);
 	return smb2_compound_op(xid, tcon, cifs_sb,
@@ -1141,6 +1143,8 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 	u32 dosattrs;
 	int tmprc;
 
+	invalidate_cached_dirents(tcon->cfids, name, CFID_LOOKUP_PARENT);
+
 	in_iov.iov_base = &data;
 	in_iov.iov_len = sizeof(data);
 	cifs_i = CIFS_I(inode);
@@ -1180,8 +1184,12 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	struct inode *inode = NULL;
 	int rc;
 
-	if (dentry)
+	if (dentry) {
 		inode = d_inode(dentry);
+		invalidate_cached_dirents(tcon->cfids, dentry->d_parent, CFID_LOOKUP_DENTRY);
+	} else {
+		invalidate_cached_dirents(tcon->cfids, name, CFID_LOOKUP_PARENT);
+	}
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, DELETE,
 			     FILE_OPEN, OPEN_REPARSE_POINT, ACL_NO_MODE);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 07ba61583114..f85a2e2555a2 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2419,7 +2419,8 @@ add_lease_context(struct TCP_Server_Info *server,
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = server->vals->create_lease_size;
-	req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
+	/* keep the requested oplock level in case of just setting ParentLeaseKey */
+	req->RequestedOplockLevel = *oplock;
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -3001,6 +3002,34 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	return rc;
 }
 
+/*
+ * When opening a path, set ParentLeaseKey in @oparms if its parent is cached.
+ * We only have RH caching for dirs, so skip this on mkdir, unlink, rmdir.
+ *
+ * Ref: MS-SMB2 3.3.5.9 and MS-FSA 2.1.5.1
+ *
+ * Return: 0 if ParentLeaseKey was set in @oparms, -errno otherwise.
+ */
+static int check_cached_parent(struct cached_fids *cfids, struct cifs_open_parms *oparms)
+{
+	struct cached_fid *cfid;
+
+	if (!cfids || !oparms || !oparms->cifs_sb || !*oparms->path)
+		return -EINVAL;
+
+	cfid = find_cached_dir(cfids, oparms->path, CFID_LOOKUP_PARENT);
+	if (!cfid)
+		return -ENOENT;
+
+	cifs_dbg(FYI, "%s: found cached parent for path: %s\n", __func__, oparms->path);
+
+	memcpy(oparms->fid->parent_lease_key, cfid->fid.lease_key, SMB2_LEASE_KEY_SIZE);
+	oparms->lease_flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
+	close_cached_dir(cfid);
+
+	return 0;
+}
+
 int
 SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	       struct smb_rqst *rqst, __u8 *oplock,
@@ -3077,20 +3106,28 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	iov[1].iov_len = uni_path_len;
 	iov[1].iov_base = path;
 
-	if ((!server->oplocks) || (tcon->no_lease))
+	if (!server->oplocks || tcon->no_lease)
 		*oplock = SMB2_OPLOCK_LEVEL_NONE;
 
-	if (!(server->capabilities & SMB2_GLOBAL_CAP_LEASING) ||
-	    *oplock == SMB2_OPLOCK_LEVEL_NONE)
-		req->RequestedOplockLevel = *oplock;
-	else if (!(server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING) &&
-		  (oparms->create_options & CREATE_NOT_FILE))
-		req->RequestedOplockLevel = *oplock; /* no srv lease support */
-	else {
-		rc = add_lease_context(server, req, iov, &n_iov,
-				       oparms->fid->lease_key, oplock,
-				       oparms->fid->parent_lease_key,
-				       oparms->lease_flags);
+	req->RequestedOplockLevel = *oplock;
+
+	/*
+	 * MS-SMB2 "Product Behavior" says Windows only checks/sets ParentLeaseKey when a lease is
+	 * requested for the child/target.
+	 * Practically speaking, adding the lease context with ParentLeaseKey set, even with oplock
+	 * none, works fine.
+	 * As a precaution, however, only set it for oplocks != none.
+	 */
+	if ((server->capabilities & SMB2_GLOBAL_CAP_LEASING) &&
+	    *oplock != SMB2_OPLOCK_LEVEL_NONE) {
+		rc = -EOPNOTSUPP;
+		if (server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING)
+			rc = check_cached_parent(tcon->cfids, oparms);
+
+		if (!rc || *oplock != SMB2_OPLOCK_LEVEL_NONE)
+			rc = add_lease_context(server, req, iov, &n_iov, oparms->fid->lease_key,
+					       oplock, oparms->fid->parent_lease_key,
+					       oparms->lease_flags);
 		if (rc)
 			return rc;
 	}
-- 
2.49.0

