Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4F1F95C
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152570; cv=none; b=iim4qMmRCbHMUz+kBpb7N5FefbIQHF3YZKiAxU2rRj0sSkkHpaLMf+KRedsbq3sJPlO41GuoYn6XNdk7JhO0KPPQ8osERhGFg00b1wBFxhraScif2CkmfRuQcNt5P+gc5rGfvT2q/W2FotIpp5pzlwc+jivuUaW3mbhG6cKpQS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152570; c=relaxed/simple;
	bh=DoUJpcOw8jdAiu8KWPzfguHq+0Z975s4HldYR49j/S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEEIYtTSG3zDb9sBER+skB3k5/N88yxbWM3ZTiNo6Yt3Bs6mVmb0LnwZA8T8X7PwW7Vf768mcZxYsVAbpyNnwcDRodtBReUQf3OBmDtCXYHGJXcJ4fZOnW3f0dpIvoGaXGoOXzLSKRFvhl+eOCecwyzOYJ0aMXqobrZOK13h79I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dgB3Uvz5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LKUq4Ebj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dgB3Uvz5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LKUq4Ebj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dgB3Uvz5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LKUq4Ebj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dgB3Uvz5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LKUq4Ebj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1770A327C2;
	Mon, 29 Sep 2025 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R7JSOdYe/TAA8JOAVRLRknyXp0Jf3c95T7ubrjm5K4Y=;
	b=dgB3Uvz5NSPrQjEUpUhZYPjc1AtbLZQZPaDtB+Z6jgkizIhjShswxxChCEIE/R/EF4tn8q
	lFuYsy+TBJcaDCuqLgkUS787hygShvZlj4XuBQJ5i8IOWPL4Clap7Hk2HQx0wZBedcYv5R
	B/UCBgDl6vBtEY+n952+izR8hmdOj2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R7JSOdYe/TAA8JOAVRLRknyXp0Jf3c95T7ubrjm5K4Y=;
	b=LKUq4EbjkSpIlL2Beage/usJ24FBy+75o8f5WagB18tP+CDYM+9JNgD46o36VIH/Nc10mp
	0tKuC5kIex7gOBAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R7JSOdYe/TAA8JOAVRLRknyXp0Jf3c95T7ubrjm5K4Y=;
	b=dgB3Uvz5NSPrQjEUpUhZYPjc1AtbLZQZPaDtB+Z6jgkizIhjShswxxChCEIE/R/EF4tn8q
	lFuYsy+TBJcaDCuqLgkUS787hygShvZlj4XuBQJ5i8IOWPL4Clap7Hk2HQx0wZBedcYv5R
	B/UCBgDl6vBtEY+n952+izR8hmdOj2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R7JSOdYe/TAA8JOAVRLRknyXp0Jf3c95T7ubrjm5K4Y=;
	b=LKUq4EbjkSpIlL2Beage/usJ24FBy+75o8f5WagB18tP+CDYM+9JNgD46o36VIH/Nc10mp
	0tKuC5kIex7gOBAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97F2013782;
	Mon, 29 Sep 2025 13:29:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V0rhF62J2mj1GwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:29:17 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 12/20] smb: client: prevent lease breaks of cached parents when opening children
Date: Mon, 29 Sep 2025 10:27:57 -0300
Message-ID: <20250929132805.220558-13-ematsumiya@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80

In SMB2_open_init(), when opening (not creating/deleting) a path, lookup
for a cached parent and set ParentLeaseKey in lease context if found.

Other:
- set oparms->cifs_sb in open_cached_dir() as we need it in
  add_parent_lease_key(); use CIFS_OPARMS() too

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 42 ++++---------------
 fs/smb/client/dir.c        | 26 +++---------
 fs/smb/client/smb2inode.c  |  2 +
 fs/smb/client/smb2pdu.c    | 86 ++++++++++++++++++++++++++++++++------
 4 files changed, 88 insertions(+), 68 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index ff71f2c06b72..9dd74268b2d8 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -226,7 +226,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	struct cached_fids *cfids;
 	const char *npath;
 	int retries = 0, cur_sleep = 1;
-	__le32 lease_flags = 0;
 
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
@@ -236,9 +235,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 
 	ses = tcon->ses;
 	cfids = tcon->cfids;
-
 	if (!cfids)
 		return -EOPNOTSUPP;
+
 replay_again:
 	/* reinitialize for possible replay */
 	flags = 0;
@@ -306,24 +305,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
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
@@ -350,20 +331,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
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
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index e5372c2c799d..b60af27668bb 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -189,10 +189,9 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	struct inode *newinode = NULL;
 	int disposition;
 	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cached_fid *parent_cfid;
 	struct cifs_open_parms oparms;
-	struct cached_fid *parent_cfid = NULL;
 	int rdwr_for_fscache = 0;
-	__le32 lease_flags = 0;
 
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
@@ -314,25 +313,11 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
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
+	parent_cfid = find_cached_dir(tcon->cfids, direntry->d_parent, CFID_LOOKUP_DENTRY);
+	if (parent_cfid) {
+		parent_cfid->dirents.is_valid = false;
+		close_cached_dir(parent_cfid);
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -343,7 +328,6 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		.disposition = disposition,
 		.path = full_path,
 		.fid = fid,
-		.lease_flags = lease_flags,
 		.mode = mode,
 	};
 	rc = server->ops->open(xid, &oparms, oplock, buf);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 8ccdd1a3ba2c..6d643b8b9547 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1120,6 +1120,8 @@ smb2_mkdir(const unsigned int xid, struct inode *parent_inode, umode_t mode,
 {
 	struct cifs_open_parms oparms;
 
+	drop_cached_dir(tcon->cfids, name, CFID_LOOKUP_PATH);
+
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES,
 			     FILE_CREATE, CREATE_NOT_FILE, mode);
 	return smb2_compound_op(xid, tcon, cifs_sb,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 07ba61583114..2474ac18b85e 100644
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
@@ -3001,6 +3002,50 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
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
+	const char *parent_path, *path;
+
+	if (!cfids || !oparms || !oparms->cifs_sb || !*oparms->path)
+		return -EINVAL;
+
+	if ((oparms->disposition == FILE_CREATE && oparms->create_options == CREATE_NOT_FILE) ||
+	    oparms->desired_access == DELETE)
+		return -EOPNOTSUPP;
+
+	path = oparms->path;
+	parent_path = strrchr(path, CIFS_DIR_SEP(oparms->cifs_sb));
+	if (!parent_path)
+		return -ENOENT;
+
+	parent_path = kstrndup(path, parent_path - path, GFP_KERNEL);
+	if (!parent_path)
+		return -ENOMEM;
+
+	cfid = find_cached_dir(cfids, parent_path, CFID_LOOKUP_PATH);
+	kfree(parent_path);
+
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
@@ -3077,20 +3122,35 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
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
+		/*
+		 * -ENOENT just means we couldn't find a cached parent, but we do have dir leasing,
+		 * so try requesting a level II oplock for the child path.
+		 */
+		if ((!rc || rc == -ENOENT) && *oplock == SMB2_OPLOCK_LEVEL_NONE)
+			*oplock = SMB2_OPLOCK_LEVEL_II;
+
+		if (*oplock != SMB2_OPLOCK_LEVEL_NONE)
+			rc = add_lease_context(server, req, iov, &n_iov, oparms->fid->lease_key,
+					       oplock, oparms->fid->parent_lease_key,
+					       oparms->lease_flags);
 		if (rc)
 			return rc;
 	}
-- 
2.49.0

