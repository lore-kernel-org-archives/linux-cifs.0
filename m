Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3A61F95C
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152564; cv=none; b=tWwvtsSAVkM+468juI7T5Uxk/T3Bnrc2+3Np9Bt42+Q7aD0lGtXsr9geLZHR7NIlHE0Xw0KcmDANV7rbY2ljF7C+tVjtrXBkleivIkUvfuOwjfGy9LMd5OETp8uGJfapJ3Ia4dC9kTULbAefPXn08wmpo1goa0TkYGUSh7u6/Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152564; c=relaxed/simple;
	bh=HzAo3by3wxh5SNICTZcZGm8qUv1h3momvxKOAYQLaRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVNfSslTVqRw+Zf37IV1U7yVGr6jC74upZIJPwUEkIekyVe/pYHtPn/qHT0EOTET7yHLtn7IAHJJSs1A9X5WSDqO6tyoh7JxynLYmqW73kr2TG+uhCM3ulwzR1FHpcxa4icX4pC3kNbL5l5CLIbhfGKYPRjt6RtYPyPsIo3ObsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x9SDRBXT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ERdtibHu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x9SDRBXT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ERdtibHu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x9SDRBXT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ERdtibHu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x9SDRBXT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ERdtibHu"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E2A32C552;
	Mon, 29 Sep 2025 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PkcQgOEuoQ6zJiuy6gGaCyw626k7CAtFHzmS1xEmlLs=;
	b=x9SDRBXTfymm/Sn3L4oKjyxkoTXz+4LjJO39/y1qzqurcWe4ZiRyoTKikWLN2jzrJQZri0
	yizg3a0Wz/olQMcge+5sSz9kZNB/yEIG/LUJVO8wkN+hka+KrYP7ZzByUb/ooRdfw/caK/
	tEvoPL9PPB25Z4BlXmCrcFrXwDfC+tY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PkcQgOEuoQ6zJiuy6gGaCyw626k7CAtFHzmS1xEmlLs=;
	b=ERdtibHujLLUyKURK44px7z5Q2AVkz+A+q8qF5Z00/0GXl3amXgteXmcT2ZgAhWqEulJaj
	Rk92dqus0bBgeeCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PkcQgOEuoQ6zJiuy6gGaCyw626k7CAtFHzmS1xEmlLs=;
	b=x9SDRBXTfymm/Sn3L4oKjyxkoTXz+4LjJO39/y1qzqurcWe4ZiRyoTKikWLN2jzrJQZri0
	yizg3a0Wz/olQMcge+5sSz9kZNB/yEIG/LUJVO8wkN+hka+KrYP7ZzByUb/ooRdfw/caK/
	tEvoPL9PPB25Z4BlXmCrcFrXwDfC+tY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PkcQgOEuoQ6zJiuy6gGaCyw626k7CAtFHzmS1xEmlLs=;
	b=ERdtibHujLLUyKURK44px7z5Q2AVkz+A+q8qF5Z00/0GXl3amXgteXmcT2ZgAhWqEulJaj
	Rk92dqus0bBgeeCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFF1013782;
	Mon, 29 Sep 2025 13:29:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KwOzHbCJ2mj4GwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:29:20 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 13/20] smb: client: actually use cached dirs on readdir
Date: Mon, 29 Sep 2025 10:27:58 -0300
Message-ID: <20250929132805.220558-14-ematsumiya@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
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
 fs/smb/client/readdir.c   | 71 +++++++++++++++++++++++----------------
 fs/smb/client/smb2ops.c   |  2 +-
 fs/smb/client/smb2pdu.c   | 11 +++---
 fs/smb/client/smb2proto.h |  2 +-
 5 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0fae95cf81c4..9a86efddc3c4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1434,6 +1434,7 @@ struct cifs_search_info {
 	bool emptyDir:1;
 	bool unicode:1;
 	bool smallBuf:1; /* so we know which buf_release function to call */
+	bool restart_scan;
 };
 
 #define ACL_NO_MODE	((umode_t)(-1))
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index cc6762d950d2..0b2efd680fe6 100644
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
@@ -1028,7 +1038,6 @@ static int cifs_filldir(char *find_entry, struct file *file,
 			      &fattr, cfid, file);
 }
 
-
 int cifs_readdir(struct file *file, struct dir_context *ctx)
 {
 	int rc = 0;
@@ -1036,7 +1045,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	int i;
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon;
-	struct cifsFileInfo *cifsFile;
+	struct cifsFileInfo *cifsFile = NULL;
 	char *current_entry;
 	int num_to_fill = 0;
 	char *tmp_buf = NULL;
@@ -1095,23 +1104,22 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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
+		if (tcon->status != TID_GOOD || (cfid && !cfid_is_valid(cfid))) {
+			rc = -ENOENT;
+			goto rddir2_exit;
+		}
 	}
 
 	if (!dir_emit_dots(file, ctx))
@@ -1128,15 +1136,17 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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
+	if (tcon->status != TID_GOOD || (cfid && !cfid_is_valid(cfid))) {
+		rc = -ENOENT;
+		goto rddir2_exit;
+	}
+
 	if (rc) {
 		cifs_dbg(FYI, "fce error %d\n", rc);
 		goto rddir2_exit;
@@ -1204,8 +1214,11 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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
index 39e6dc13d2da..8842315d2526 100644
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
index 2474ac18b85e..cc7251f4e3a6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5418,7 +5418,7 @@ int SMB2_query_directory_init(const unsigned int xid,
 			      struct TCP_Server_Info *server,
 			      struct smb_rqst *rqst,
 			      u64 persistent_fid, u64 volatile_fid,
-			      int index, int info_level)
+			      int index, struct cifs_search_info *search)
 {
 	struct smb2_query_directory_req *req;
 	unsigned char *bufptr;
@@ -5435,7 +5435,7 @@ int SMB2_query_directory_init(const unsigned int xid,
 	if (rc)
 		return rc;
 
-	switch (info_level) {
+	switch (search->info_level) {
 	case SMB_FIND_FILE_DIRECTORY_INFO:
 		req->FileInformationClass = FILE_DIRECTORY_INFORMATION;
 		break;
@@ -5449,14 +5449,15 @@ int SMB2_query_directory_init(const unsigned int xid,
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
@@ -5603,7 +5604,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
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
2.49.0

