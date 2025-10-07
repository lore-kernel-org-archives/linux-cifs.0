Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC5E1F0994
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859071; cv=none; b=r0Tj2O9x2rwNE7F/k26Smd3GA51aFRUvEPlvi2jAbSyt8kfycIBtueY+hfxv+nVnuywkX/7EBplLpipj/+O2FiJUzw1qNwZVQsDESWPY1fjyw80x5cZWkCtA8DF9SCAUEYDI7Zpt5UPe4yyNLsKOMODp4/HkIFehH62DkpiCMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859071; c=relaxed/simple;
	bh=gYblIq8xMxFwBY/ZigTBWDz6kXFrYJrkAfUMhHLTrHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bv2jWH+cfe4oS2z/wd66NVCVPXMMOiMJQMULbJVw+Z7SzMJxQ6ZExJBrUcCFsWcn/h2dc2Kd1sdwH8bdl+tBY4mEl6ElIelDBBLfbhbBNA4oj3qre7gwy+wqL1PPR7oIqvr6WzKNKAs0PDEmGgQig4my6sMRvPEaw68CyyZ5qbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LBy2DXZ9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hWFQVpC2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LBy2DXZ9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hWFQVpC2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LBy2DXZ9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hWFQVpC2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LBy2DXZ9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hWFQVpC2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0DF4E20707;
	Tue,  7 Oct 2025 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VD1uiqXimS3sApWfpfSzUiUrCMqM/MvueBE/g8p8N/E=;
	b=LBy2DXZ9wj8M6rWgYQ19gN/HvVcWx7sVM1m00hTyEharl78zgm9qua5sZWt76Z/Qua94h7
	bba1V0orl36BA+nq67NHBi4hPBSYs2btlS5pu4bENiyx6u848lOEEdFif5l3U2hT8vZIzh
	3GCbP83UW4arrTZ4zb/m8L+6nBGX7nM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VD1uiqXimS3sApWfpfSzUiUrCMqM/MvueBE/g8p8N/E=;
	b=hWFQVpC2D4D++P7nGVHaK3c9IE2d+lefQhMAikUvgELsn0BzpL7tlecZKVUSlxv9m5r69w
	JLVkEjTaLxbV3gDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LBy2DXZ9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hWFQVpC2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VD1uiqXimS3sApWfpfSzUiUrCMqM/MvueBE/g8p8N/E=;
	b=LBy2DXZ9wj8M6rWgYQ19gN/HvVcWx7sVM1m00hTyEharl78zgm9qua5sZWt76Z/Qua94h7
	bba1V0orl36BA+nq67NHBi4hPBSYs2btlS5pu4bENiyx6u848lOEEdFif5l3U2hT8vZIzh
	3GCbP83UW4arrTZ4zb/m8L+6nBGX7nM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VD1uiqXimS3sApWfpfSzUiUrCMqM/MvueBE/g8p8N/E=;
	b=hWFQVpC2D4D++P7nGVHaK3c9IE2d+lefQhMAikUvgELsn0BzpL7tlecZKVUSlxv9m5r69w
	JLVkEjTaLxbV3gDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DC8C13693;
	Tue,  7 Oct 2025 17:44:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RL5aFWpR5WgzeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:44:10 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 16/20] smb: client: add is_dir argument to query_path_info
Date: Tue,  7 Oct 2025 14:43:00 -0300
Message-ID: <20251007174304.1755251-17-ematsumiya@suse.de>
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
X-Rspamd-Queue-Id: 0DF4E20707
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01

When we have an inode on upper levels, pass is_dir down to
smb2_query_path_info() so we can lookup for a cached dir there.

Since we now have a possible recursive lookup in open_cached_dir() e.g.:

cifs_readdir
  open_cached_dir
    lookup_noperm_positive_unlocked
    ...
      cifs_d_revalidate
      ...
        smb2_query_path_info
	  find_cached_dir

the cfid must be added to the entries list only after dentry lookup, so
we don't hang on an infinite recursion while waiting for itself to open.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 12 ++++++++----
 fs/smb/client/cifsglob.h   |  2 +-
 fs/smb/client/inode.c      |  6 +++---
 fs/smb/client/smb1ops.c    |  4 ++--
 fs/smb/client/smb2inode.c  | 12 ++++++++----
 fs/smb/client/smb2proto.h  |  2 +-
 6 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 96c7154d8031..d47428736692 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -297,12 +297,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	}
 
 	cfid->cfids = cfids;
-	cfids->num_entries++;
-	list_add(&cfid->entry, &cfids->entries);
+	cfid->tcon = tcon;
 	spin_unlock(&cfids->cfid_list_lock);
 
-	pfid = &cfid->fid;
-
 	/*
 	 * Skip any prefix paths in @path as lookup_noperm_positive_unlocked() ends up
 	 * calling ->lookup() which already adds those through
@@ -330,6 +327,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	cfid->tcon = tcon;
 	dentry = NULL;
 
+	spin_lock(&cfids->cfid_list_lock);
+	cfids->num_entries++;
+	list_add(&cfid->entry, &cfids->entries);
+	spin_unlock(&cfids->cfid_list_lock);
+
+	pfid = &cfid->fid;
+
 	/*
 	 * We do not hold the lock for the open because in case
 	 * SMB2_open needs to reconnect.
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 6d6dca23d83a..207221eae5f6 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -401,7 +401,7 @@ struct smb_version_operations {
 			       struct cifs_tcon *tcon,
 			       struct cifs_sb_info *cifs_sb,
 			       const char *full_path,
-			       struct cifs_open_info_data *data);
+			       struct cifs_open_info_data *data, bool is_dir);
 	/* query file data from the server */
 	int (*query_file_info)(const unsigned int xid, struct cifs_tcon *tcon,
 			       struct cifsFileInfo *cfile, struct cifs_open_info_data *data);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 6b5cc6e49477..4d7e7843e959 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1283,8 +1283,8 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 	 */
 
 	if (!data) {
-		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
-						  full_path, &tmp_data);
+		rc = server->ops->query_path_info(xid, tcon, cifs_sb, full_path, &tmp_data,
+						  (*inode && S_ISDIR((*inode)->i_mode)));
 		data = &tmp_data;
 	}
 
@@ -1470,7 +1470,7 @@ static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 	 */
 	if (!data) {
 		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
-						  full_path, &tmp_data);
+						  full_path, &tmp_data, false);
 		data = &tmp_data;
 	}
 
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index a02d41d1ce4a..d964bc9c2823 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -543,7 +543,7 @@ static int cifs_query_path_info(const unsigned int xid,
 				struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb,
 				const char *full_path,
-				struct cifs_open_info_data *data)
+				struct cifs_open_info_data *data, bool is_dir)
 {
 	int rc = -EOPNOTSUPP;
 	FILE_ALL_INFO fi = {};
@@ -934,7 +934,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	if (!(tcon->ses->capabilities & CAP_NT_SMBS) &&
 	    (!buf->CreationTime || !buf->LastAccessTime ||
 	     !buf->LastWriteTime || !buf->ChangeTime)) {
-		rc = cifs_query_path_info(xid, tcon, cifs_sb, full_path, &query_data);
+		rc = cifs_query_path_info(xid, tcon, cifs_sb, full_path, &query_data, false);
 		if (rc) {
 			if (open_file) {
 				cifsFileInfo_put(open_file);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 97780e660281..df0e1052cb77 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -940,10 +940,9 @@ int smb2_query_path_info(const unsigned int xid,
 			 struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb,
 			 const char *full_path,
-			 struct cifs_open_info_data *data)
+			 struct cifs_open_info_data *data, bool is_dir)
 {
 	struct kvec in_iov[3], out_iov[5] = {};
-	struct cached_fid *cfid = NULL;
 	struct cifs_open_parms oparms;
 	struct cifsFileInfo *cfile;
 	__u32 create_options = 0;
@@ -964,12 +963,17 @@ int smb2_query_path_info(const unsigned int xid,
 	 * is fast enough (always using the compounded version).
 	 */
 	if (!tcon->posix_extensions) {
+		struct cached_fid *cfid = NULL;
+
 		rc = -ENOENT;
 		if (!*full_path)
 			rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
+		else if (is_dir)
+			cfid = find_cached_dir(tcon->cfids, full_path, CFID_LOOKUP_PATH);
+
+		if (cfid) {
+			rc = 0;
 
-		/* If it is a root and its handle is cached then use it */
-		if (!rc) {
 			if (cfid->file_all_info) {
 				memcpy(&data->fi, cfid->file_all_info, sizeof(data->fi));
 			} else {
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index ac6db1f18b5b..3e3faa7cf633 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -72,7 +72,7 @@ int smb2_query_path_info(const unsigned int xid,
 			 struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb,
 			 const char *full_path,
-			 struct cifs_open_info_data *data);
+			 struct cifs_open_info_data *data, bool is_dir);
 extern int smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 			      const char *full_path, __u64 size,
 			      struct cifs_sb_info *cifs_sb, bool set_alloc,
-- 
2.51.0

