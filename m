Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BA01F0994
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859044; cv=none; b=Ql32UT7pgKp3h2iGhRYpBTYdZyNakWgRd7HJhX5SGCxJLAa+yW/Z3OevCKJ6PPNuixzcNwncSfjRBBjh2XGZp29hT+SsuzNDXnsxA88aX2WaXLuNJFFoUHyFge4dxZ9rmIKryX5fV8CqW7hnJ6Uh3DyTyGifbrfiUOyqdslOL5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859044; c=relaxed/simple;
	bh=m8l7VTgKJPAwoIGrxfkcSiYGb83e/9r9nc75j8IxVw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvOBG0pmrGT9kN1iSqCT3uS0rLCGX99aucOG6m7+JpLLkeIJgVOmPytlDMibV0KXl/CJ4uTMqOOElXN5/RL5DcK+lsbY3wJOuRBJsZ95hHVKHDNxoeK2Vv1/0t1FdCUT5H0ccIXNvaM3BexU3sS07QotZnTUqOB8NXkNGmv9Zjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fhisLGcQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Wzyujc8q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fhisLGcQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Wzyujc8q; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fhisLGcQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Wzyujc8q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fhisLGcQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Wzyujc8q"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A5EE20AB2;
	Tue,  7 Oct 2025 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iw1FKTnLcRUUcUCOhwUHNscxKhfd797ofP3odbEJo/Q=;
	b=fhisLGcQGbQxaupLGYYDpPF+pczMJmX9edZfe3cFwI6zyOojPVXR9wSDXANkQQTRq4ecgh
	GhxcFl7MhW87oiUkNOeZeKo6KARms8o4cwvk3PVURDD4pXcnC9CwqTgiCc9syfa6QmYNNM
	XFBdurmkYLgRDcKHkf8QHZox8PZdbkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iw1FKTnLcRUUcUCOhwUHNscxKhfd797ofP3odbEJo/Q=;
	b=Wzyujc8qRctPm5YJk5EPbHl+DtGm5mTvhJJGVUgLw+u/HX6lMADtXCWduah0rPoWm74dxB
	v2WPufMA+cHqrVDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fhisLGcQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wzyujc8q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iw1FKTnLcRUUcUCOhwUHNscxKhfd797ofP3odbEJo/Q=;
	b=fhisLGcQGbQxaupLGYYDpPF+pczMJmX9edZfe3cFwI6zyOojPVXR9wSDXANkQQTRq4ecgh
	GhxcFl7MhW87oiUkNOeZeKo6KARms8o4cwvk3PVURDD4pXcnC9CwqTgiCc9syfa6QmYNNM
	XFBdurmkYLgRDcKHkf8QHZox8PZdbkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iw1FKTnLcRUUcUCOhwUHNscxKhfd797ofP3odbEJo/Q=;
	b=Wzyujc8qRctPm5YJk5EPbHl+DtGm5mTvhJJGVUgLw+u/HX6lMADtXCWduah0rPoWm74dxB
	v2WPufMA+cHqrVDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA39213693;
	Tue,  7 Oct 2025 17:43:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lgXWK1lR5WgceAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:53 +0000
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
Date: Tue,  7 Oct 2025 14:42:56 -0300
Message-ID: <20251007174304.1755251-13-ematsumiya@suse.de>
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
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 6A5EE20AB2
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RL73jpmmudngk8cygugnauyh74)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01

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
 fs/smb/client/cached_dir.c | 109 +++++++++++++++++++++++--------------
 fs/smb/client/cached_dir.h |   5 ++
 fs/smb/client/dir.c        |  24 +-------
 fs/smb/client/smb2inode.c  |  11 ++++
 fs/smb/client/smb2pdu.c    |  63 ++++++++++++++++-----
 5 files changed, 136 insertions(+), 76 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index d04dc65fb8a6..22709b0bfb3d 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -69,11 +69,29 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
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
 
@@ -112,6 +130,8 @@ static struct cached_fid *find_cfid(struct cached_fids *cfids, const void *key,
 		kref_get(&found->refcount);
 	}
 
+	kfree(parent_path);
+
 	return found;
 }
 
@@ -224,7 +244,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	struct cached_fids *cfids;
 	const char *npath;
 	int retries = 0, cur_sleep = 1;
-	__le32 lease_flags = 0;
 
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
@@ -234,9 +253,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 
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
@@ -304,25 +325,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 			rc = -ENOENT;
 			goto out;
 		}
-		if (dentry->d_parent && server->dialect >= SMB30_PROT_ID) {
-			struct cached_fid *parent_cfid;
-
-			spin_lock(&cfids->cfid_list_lock);
-			list_for_each_entry(parent_cfid, &cfids->entries, entry) {
-				if (parent_cfid->dentry == dentry->d_parent) {
-					if (!is_valid_cached_dir(parent_cfid))
-						break;
-
-					cifs_dbg(FYI, "found a parent cached file handle\n");
-
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
@@ -349,20 +351,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
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
@@ -477,21 +472,35 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	return rc;
 }
 
-static void
-smb2_close_cached_fid(struct kref *ref)
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
+static void
+smb2_close_cached_fid(struct kref *ref)
+{
+	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
+
+	__invalidate_cached_dirents(cfid);
+	drop_cfid(cfid);
+
 	kfree(cfid->file_all_info);
 	cfid->file_all_info = NULL;
 	kfree(cfid->path);
@@ -531,6 +540,26 @@ bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode)
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
index 81969921ff88..de1231bdb0d9 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -59,11 +59,15 @@ struct cached_fids {
 	/* aggregate accounting for all cached dirents under this tcon */
 	atomic_long_t total_dirents_entries;
 	atomic64_t total_dirents_bytes;
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
@@ -86,6 +90,7 @@ extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char
 			   struct cifs_sb_info *cifs_sb, struct cached_fid **cfid);
 extern void close_cached_dir(struct cached_fid *cfid);
 extern bool drop_cached_dir(struct cached_fids *cfids, const void *key, int mode);
+extern void invalidate_cached_dirents(struct cached_fids *cfids, const void *key, int mode);
 extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
 extern void invalidate_all_cached_dirs(struct cached_fids *cfids);
 #endif			/* _CACHED_DIR_H */
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 5466f4968a84..5903c1fc96d4 100644
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
@@ -314,27 +312,8 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
 		create_options |= CREATE_OPTION_READONLY;
 
-
 retry_open:
-	if (tcon->cfids && direntry->d_parent && server->dialect >= SMB30_PROT_ID) {
-		parent_cfid = NULL;
-		spin_lock(&tcon->cfids->cfid_list_lock);
-		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
-			if (parent_cfid->dentry == direntry->d_parent) {
-				if (!is_valid_cached_dir(parent_cfid))
-					break;
-
-				cifs_dbg(FYI, "found a parent cached file handle\n");
-
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
@@ -344,7 +323,6 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		.disposition = disposition,
 		.path = full_path,
 		.fid = fid,
-		.lease_flags = lease_flags,
 		.mode = mode,
 	};
 	rc = server->ops->open(xid, &oparms, oplock, buf);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c3c77fc0c11d..97780e660281 100644
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
@@ -1196,6 +1200,13 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	if (!utf16_path)
 		return -ENOMEM;
 
+	if (dentry) {
+		inode = d_inode(dentry);
+		invalidate_cached_dirents(tcon->cfids, dentry->d_parent, CFID_LOOKUP_DENTRY);
+	} else {
+		invalidate_cached_dirents(tcon->cfids, name, CFID_LOOKUP_PARENT);
+	}
+
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 again:
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index acbfbb40932a..366dcb996f59 100644
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
2.51.0

