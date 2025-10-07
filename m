Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DFA1F0994
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859051; cv=none; b=GDTU49Dv4SIyMgSU7TCCzDrHWkzcbtX8DfvqVwLPDWelCphFvgpMDcGe767JRN4TdG3t4LVzYvKjddiwDvT3l0VsGcZCLdloNz0rDZVlsZRnveeFVQrrHmizzWCFHKff7wYkyOkVReEFdR6PfblPYxRBaeJC9qsYiRM4VUzMeCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859051; c=relaxed/simple;
	bh=+c5LzmCGeKT/5JZSul4+qTU24easIuyHbCGcx25bn4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXvCdkThZmDzwSnAevPm1lCfM2jIgb/iVxVNypKUZbCcXrZa0O7D+FCNF7yYWYrf0p/hK0myfkas3g+Ej/6XLJE4NpfB6YRvKlOZu0CfmiM9mmMqai0MeU2CQho+Pd4yd6kkFKbys29+cYutb5i8fb4F7m+sa2tHsRmEJFbcIq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SKqoyLoa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KEgMr6FW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SKqoyLoa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KEgMr6FW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SKqoyLoa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KEgMr6FW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SKqoyLoa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KEgMr6FW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8C39420AAD;
	Tue,  7 Oct 2025 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EfuJM3M2pAWnAWiyeaM3eKtYhLzEXmd6LVOy9am+7TE=;
	b=SKqoyLoaK0D8l9RotrLkuuJwdnU3sU9oenufUzizm7k4pviqvcQ9qHF7kJ8fJRe72RVGaS
	SxPXV+L9tYCjlfXdr21eDLNG8euyUq46P2LS7vBolLSUL2DTpYoYNMedjt3NNNL18RjC2E
	pzHzAoK9d+VeJJrE8sBiaSYf/QUaOTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EfuJM3M2pAWnAWiyeaM3eKtYhLzEXmd6LVOy9am+7TE=;
	b=KEgMr6FWdySSZuiaLIC4t9asXl+qSe6c6JeXmCLVDLHx9I+K9yQy5CTO8dqax+ZRrAKORT
	h4qFtc6gAXEH/ADw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EfuJM3M2pAWnAWiyeaM3eKtYhLzEXmd6LVOy9am+7TE=;
	b=SKqoyLoaK0D8l9RotrLkuuJwdnU3sU9oenufUzizm7k4pviqvcQ9qHF7kJ8fJRe72RVGaS
	SxPXV+L9tYCjlfXdr21eDLNG8euyUq46P2LS7vBolLSUL2DTpYoYNMedjt3NNNL18RjC2E
	pzHzAoK9d+VeJJrE8sBiaSYf/QUaOTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EfuJM3M2pAWnAWiyeaM3eKtYhLzEXmd6LVOy9am+7TE=;
	b=KEgMr6FWdySSZuiaLIC4t9asXl+qSe6c6JeXmCLVDLHx9I+K9yQy5CTO8dqax+ZRrAKORT
	h4qFtc6gAXEH/ADw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19D4313693;
	Tue,  7 Oct 2025 17:43:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6a/TNFxR5WgjeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:56 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 13/20] smb: client: actually use cached dirs on readdir
Date: Tue,  7 Oct 2025 14:42:57 -0300
Message-ID: <20251007174304.1755251-14-ematsumiya@suse.de>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

Currently, even when we have a valid cached dir, cifs_readdir will not
make use of it for the Find request, and will reopen a separate handle
in query_dir_first.

Fix this by setting cifsFile->fid to cfid->fid and resetting search info
parameters.  Also add cifs_search_info->reset_scan to indicate
SMB2_query_directory_init to include the SMB2_RESTART_SCANS flag.

With this, we use query_dir_next directly instead of query_dir_first.

This patch also keeps the cfid reference all through cifs_readdir().
To prevent bogus/invalid usage of it, check if cfid is still valid after
each possible network call (i.e. where possible reconnects may have
happened).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/readdir.c   | 77 +++++++++++++++++++++++----------------
 fs/smb/client/smb2ops.c   |  2 +-
 fs/smb/client/smb2pdu.c   | 11 +++---
 fs/smb/client/smb2proto.h |  2 +-
 5 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3ac254e123dc..6d6dca23d83a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1441,6 +1441,7 @@ struct cifs_search_info {
 	bool emptyDir:1;
 	bool unicode:1;
 	bool smallBuf:1; /* so we know which buf_release function to call */
+	bool restart_scan;
 };
 
 #define ACL_NO_MODE	((umode_t)(-1))
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index c9c32e4868eb..9470723a4579 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -344,7 +344,7 @@ cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
 
 static int
 _initiate_cifs_search(const unsigned int xid, struct file *file,
-		     const char *full_path)
+		     const char *full_path, struct cached_fid *cfid)
 {
 	__u16 search_flags;
 	int rc = 0;
@@ -374,7 +374,6 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	}
 
 	server = tcon->ses->server;
-
 	if (!server->ops->query_dir_first) {
 		rc = -ENOSYS;
 		goto error_exit;
@@ -382,6 +381,13 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 
 	cifsFile->invalidHandle = true;
 	cifsFile->srch_inf.endOfSearch = false;
+	if (cfid) {
+		cifsFile->srch_inf.restart_scan = true;
+		cifsFile->srch_inf.entries_in_buffer = 0;
+		cifsFile->srch_inf.index_of_last_entry = 2;
+		cifsFile->fid.persistent_fid = cfid->fid.persistent_fid;
+		cifsFile->fid.volatile_fid = cfid->fid.volatile_fid;
+	}
 
 	cifs_dbg(FYI, "Full path: %s start at: %lld\n", full_path, file->f_pos);
 
@@ -406,12 +412,16 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	if (backup_cred(cifs_sb))
 		search_flags |= CIFS_SEARCH_BACKUP_SEARCH;
 
-	rc = server->ops->query_dir_first(xid, tcon, full_path, cifs_sb,
-					  &cifsFile->fid, search_flags,
-					  &cifsFile->srch_inf);
-
+	if (cfid)
+		rc = server->ops->query_dir_next(xid, tcon, &cifsFile->fid, 0, &cifsFile->srch_inf);
+	else
+		rc = server->ops->query_dir_first(xid, tcon, full_path, cifs_sb, &cifsFile->fid,
+						  search_flags, &cifsFile->srch_inf);
 	if (rc == 0) {
-		cifsFile->invalidHandle = false;
+		if (cfid)
+			cifsFile->srch_inf.restart_scan = false;
+		else
+			cifsFile->invalidHandle = false;
 	} else if ((rc == -EOPNOTSUPP) &&
 		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
 		cifs_autodisable_serverino(cifs_sb);
@@ -424,12 +434,12 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 
 static int
 initiate_cifs_search(const unsigned int xid, struct file *file,
-		     const char *full_path)
+		     const char *full_path, struct cached_fid *cfid)
 {
 	int rc, retry_count = 0;
 
 	do {
-		rc = _initiate_cifs_search(xid, file, full_path);
+		rc = _initiate_cifs_search(xid, file, full_path, cfid);
 		/*
 		 * If we don't have enough credits to start reading the
 		 * directory just try again after short wait.
@@ -683,7 +693,7 @@ static int cifs_save_resume_key(const char *current_entry,
 static int
 find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 		struct file *file, const char *full_path,
-		char **current_entry, int *num_to_ret)
+		char **current_entry, int *num_to_ret, struct cached_fid *cfid)
 {
 	__u16 search_flags;
 	int rc = 0;
@@ -739,7 +749,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 			cfile->srch_inf.srch_entries_start = NULL;
 			cfile->srch_inf.last_entry = NULL;
 		}
-		rc = initiate_cifs_search(xid, file, full_path);
+		rc = initiate_cifs_search(xid, file, full_path, cfid);
 		if (rc) {
 			cifs_dbg(FYI, "error %d reinitiating a search on rewind\n",
 				 rc);
@@ -1042,7 +1052,6 @@ static int cifs_filldir(char *find_entry, struct file *file,
 			      &fattr, cfid, file);
 }
 
-
 int cifs_readdir(struct file *file, struct dir_context *ctx)
 {
 	int rc = 0;
@@ -1050,7 +1059,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	int i;
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon;
-	struct cifsFileInfo *cifsFile;
+	struct cifsFileInfo *cifsFile = NULL;
 	char *current_entry;
 	int num_to_fill = 0;
 	char *tmp_buf = NULL;
@@ -1071,8 +1080,10 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 
 	if (file->private_data == NULL) {
 		tlink = cifs_sb_tlink(cifs_sb);
-		if (IS_ERR(tlink))
-			goto cache_not_found;
+		if (IS_ERR(tlink)) {
+			rc = PTR_ERR(tlink);
+			goto rddir2_exit;
+		}
 		tcon = tlink_tcon(tlink);
 	} else {
 		cifsFile = file->private_data;
@@ -1109,23 +1120,22 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	}
 	mutex_unlock(&cfid->dirents.de_mutex);
 
-	/* Drop the cache while calling initiate_cifs_search and
-	 * find_cifs_entry in case there will be reconnects during
-	 * query_directory.
-	 */
-	close_cached_dir(cfid);
-	cfid = NULL;
-
- cache_not_found:
+	/* keep our cfid ref, but check if still valid after network calls */
+cache_not_found:
 	/*
 	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
 	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
 	 */
 	if (file->private_data == NULL) {
-		rc = initiate_cifs_search(xid, file, full_path);
+		rc = initiate_cifs_search(xid, file, full_path, cfid);
 		cifs_dbg(FYI, "initiate cifs search rc %d\n", rc);
 		if (rc)
 			goto rddir2_exit;
+
+		if (tcon->status != TID_GOOD || (cfid && !is_valid_cached_dir(cfid))) {
+			rc = -ENOENT;
+			goto rddir2_exit;
+		}
 	}
 
 	if (!dir_emit_dots(file, ctx))
@@ -1142,15 +1152,17 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 			rc = 0;
 			goto rddir2_exit;
 		}
-	} /* else {
-		cifsFile->invalidHandle = true;
-		tcon->ses->server->close(xid, tcon, &cifsFile->fid);
-	} */
+	}
 
 	tcon = tlink_tcon(cifsFile->tlink);
 	rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
-			     &current_entry, &num_to_fill);
-	open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
+			     &current_entry, &num_to_fill, cfid);
+
+	if (tcon->status != TID_GOOD || (cfid && !is_valid_cached_dir(cfid))) {
+		rc = -ENOENT;
+		goto rddir2_exit;
+	}
+
 	if (rc) {
 		cifs_dbg(FYI, "fce error %d\n", rc);
 		goto rddir2_exit;
@@ -1218,8 +1230,11 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	kfree(tmp_buf);
 
 rddir2_exit:
-	if (cfid)
+	if (cfid) {
+		if (cifsFile)
+			cifsFile->invalidHandle = true;
 		close_cached_dir(cfid);
+	}
 	free_dentry_path(page);
 	free_xid(xid);
 	return rc;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 26eba23c113d..cc2c1f9b76f2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2397,7 +2397,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_query_directory_init(xid, tcon, server,
 				       &rqst[1],
 				       COMPOUND_FID, COMPOUND_FID,
-				       0, srch_inf->info_level);
+				       0, srch_inf);
 	if (rc)
 		goto qdf_free;
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 366dcb996f59..1b13333394e2 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5395,7 +5395,7 @@ int SMB2_query_directory_init(const unsigned int xid,
 			      struct TCP_Server_Info *server,
 			      struct smb_rqst *rqst,
 			      u64 persistent_fid, u64 volatile_fid,
-			      int index, int info_level)
+			      int index, struct cifs_search_info *search)
 {
 	struct smb2_query_directory_req *req;
 	unsigned char *bufptr;
@@ -5412,7 +5412,7 @@ int SMB2_query_directory_init(const unsigned int xid,
 	if (rc)
 		return rc;
 
-	switch (info_level) {
+	switch (search->info_level) {
 	case SMB_FIND_FILE_DIRECTORY_INFO:
 		req->FileInformationClass = FILE_DIRECTORY_INFORMATION;
 		break;
@@ -5426,14 +5426,15 @@ int SMB2_query_directory_init(const unsigned int xid,
 		req->FileInformationClass = FILE_FULL_DIRECTORY_INFORMATION;
 		break;
 	default:
-		cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
-			info_level);
+		cifs_tcon_dbg(VFS, "info level %u isn't supported\n", search->info_level);
 		return -EINVAL;
 	}
 
 	req->FileIndex = cpu_to_le32(index);
 	req->PersistentFileId = persistent_fid;
 	req->VolatileFileId = volatile_fid;
+	if (search->restart_scan)
+		req->Flags |= SMB2_RESTART_SCANS;
 
 	len = 0x2;
 	bufptr = req->Buffer;
@@ -5580,7 +5581,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_query_directory_init(xid, tcon, server,
 				       &rqst, persistent_fid,
 				       volatile_fid, index,
-				       srch_inf->info_level);
+				       srch_inf);
 	if (rc)
 		goto qdir_exit;
 
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index b3f1398c9f79..ac6db1f18b5b 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -231,7 +231,7 @@ extern int SMB2_query_directory_init(unsigned int xid, struct cifs_tcon *tcon,
 				     struct TCP_Server_Info *server,
 				     struct smb_rqst *rqst,
 				     u64 persistent_fid, u64 volatile_fid,
-				     int index, int info_level);
+				     int index, struct cifs_search_info *search);
 extern void SMB2_query_directory_free(struct smb_rqst *rqst);
 extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 			u64 persistent_fid, u64 volatile_fid, u32 pid,
-- 
2.51.0

