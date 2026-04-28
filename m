Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C14844CAD7
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392511; cv=none; b=gGiepxKK5oJSRdqCDGHA1DYSz3qXWK/u58tHxYZ3Wdeye8xc86Lqn10m5dYmwbL5klO3UMyXcTvyieok0OWrbHT5YXVw7f5EG9J1J1YxpGXJBwmylvQqB0ufvDvpS2KBqECQXsI8ANMjF8pQZVDm3HFxj9D5nXuqN8rGf4T+VeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392511; c=relaxed/simple;
	bh=8sxUOa4GOq0ES6V2+B00JkoL9Pv89jv4RGkW+5b08nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuYMv+p5tqhv86YJrwPmYfIGL/GE1LD6+jxcEqTQ6/TC+vH7BNrrBMBSQVE7NT1K0mZxTODt8Q7x6H+yuARIlqABvOR1olnyxiXOFm1VVqQYbXXYYjIOWs5QHApdV8tcp5FCFQwPwrI+pUK7jXRzEMWlRC17nOYM/jpW6yyjeK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d2SohE/y; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2SohE/y"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35d94f4ee36so7041184a91.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392508; x=1777997308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DEpNZWYhAGnzhrFxPDmeqdZuHK3C9i+Vxou+CJqZF6E=;
        b=d2SohE/y3JiFblb30qqJhYW/axruYuQRoOuyJS8TA5jFm8qbuzXhrG+OU6+W+erXoj
         DxvCwXgxZrpflMA6K7YUPMiuH4pLXv1lRrsCpbuyTmR1IgmhCoWiHQc+z2pPQ3bkL2lj
         +a4u+H85I7n5DOzgrKdfFHvoJcHjPQhDywhCRL8Umj3OfvosQkCK5OXnQJ90ByvYf3O4
         a4d+INbnwxuqdiUZH9J3pLeYYsOPLs7yRG1UjyMsZz41m0wvNMmJtzZ0Cz5oI16lT75U
         vz02/bb68CpPkQqGXQCydpdx5Qn7UoZ9JMKbuEsJZ+Vg4AgTbnhYjHwmGZSaH4k6nRAz
         8qoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392508; x=1777997308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DEpNZWYhAGnzhrFxPDmeqdZuHK3C9i+Vxou+CJqZF6E=;
        b=VpPX1KA6J0mgEwNczdNB1f0U6iTLL0/EeYjAv8b5ztHGZ7hVBq/zkOTud3EzJxF1oE
         xS7ZY64HvX4jwxzlVWCqSVjmnLobv9jlTEyEDfQARjlMsbh+LhQwryP9VRwgbH4Hr0Wo
         F2hFO8DmtolkdtitE5RdFY6x3W9QqIY/FUe+qhehEF4wzPsokSLGroeBHBeJYD6VSpZS
         nx1qU7QvCC0xxe/0Lz1tpUWP/qWJDIh94DX401i4l3GOKMLCAXLN5dSAp1eRLefzGgrT
         DUnoPlaXclsTkxH4THzp70fhZHcRnR2Nn+lcgqJiN1lcuzs9REDaRfR5O246pQuFdAlM
         c/+A==
X-Gm-Message-State: AOJu0YxccggZzdw2hRZcbonYb5LT0b8uwxQyIo+DPQwclNHtOwJSBZlT
	vERAflK9HT+28tmt1Wn8cio2LVMh+c6YxYMxJ3F0InyGyrnFqTYVJjxvvliy03wA/8Q=
X-Gm-Gg: AeBDiesZOtO8PGGs7gw8Tg+/xoZvl5VSGeAnRXXBTXFH1hdRDR7u90ZJEf/lhcgQ8GF
	N1A55Ep9B+Khm4FbEAU8kOxtiImEmLutARLyNC7kQDD/N7o0eD5dO6nm9s29i1iZ8HtAnqxJLgr
	J9RMJqeVQC7Ibi/THQdgVgVIoBJLFfmDoQ0zvR1RjrKwYXOYv47qnCac5RsRWo74ZL5JOPmk7gp
	3RAjhELK+v2B8W2g3FYLQA6kJNojZt2tnhmF7V0yE+RScLu56xxNuwxicQ2N6InB2YdsVfJ81AY
	xLKERiyVaU2JQiqxJVXwL9Ktbeetir/7lIkZ15A7Rj8TDGP/yXmFfmiBjWJ1abt75Sgu3C5dMlr
	YWPpPWi+GQ9L687l8XBYGFpZSshkCUK6s1Le6bzq2SeDcIVNeT+Rta4YZq476jiTn/yXSUOhztm
	P9dzbhH2hC60n6fGk2U8EaYZflV0gckVqBrmkcXLjMEX8Ri6mkAcbSqyJmVgFKyAtV
X-Received: by 2002:a17:903:2ed0:b0:2ae:cb0e:fd59 with SMTP id d9443c01a7336-2b97c4120bdmr38474795ad.8.1777392507459;
        Tue, 28 Apr 2026 09:08:27 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:27 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v3 09/19] cifs: query dir should reuse cfid even if not fully cached
Date: Tue, 28 Apr 2026 21:37:54 +0530
Message-ID: <20260428160804.281745-9-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428160804.281745-1-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When a cached_dirents population is underway but not yet fully populated,
cifs_readdir does not rely on the local cache, but makes a parallel
stream of QueryDir calls to the server. However, these calls are made
without lease key and that ends up breaking our dir lease.

This change will reuse the existing lease key for this scenario for the
parallel QueryDir calls that are made.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 38 ++++++++++++++++++++++++++++++++++++
 fs/smb/client/cached_dir.h |  6 ++++++
 fs/smb/client/cifsglob.h   |  2 ++
 fs/smb/client/file.c       |  1 +
 fs/smb/client/readdir.c    | 40 ++++++++++++++++++++++++++------------
 fs/smb/client/smb2ops.c    | 19 ++++++++++++++++++
 6 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index ad2439856a1fe..614a241393b59 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -22,6 +22,20 @@ struct cached_dir_dentry {
 	struct dentry *dentry;
 };
 
+bool cached_dir_is_valid(struct cached_fid *cfid)
+{
+	bool valid;
+
+	if (!cfid)
+		return false;
+
+	spin_lock(&cfid->cfid_lock);
+	valid = is_valid_cached_dir(cfid);
+	spin_unlock(&cfid->cfid_lock);
+
+	return valid;
+}
+
 bool cached_dir_copy_lease_key(struct cached_fid *cfid,
 			      __u8 lease_key[SMB2_LEASE_KEY_SIZE])
 {
@@ -1132,3 +1146,27 @@ void free_cached_dirs(struct cached_fids *cfids)
 
 	kfree(cfids);
 }
+
+void cifs_set_srch_inf_cfid(struct cifs_search_info *srch_inf,
+			   struct cached_fid *cfid)
+{
+	if (srch_inf->cfid == cfid)
+		return;
+
+	if (cfid)
+		kref_get(&cfid->refcount);
+
+	if (srch_inf->cfid)
+		close_cached_dir(srch_inf->cfid);
+
+	srch_inf->cfid = cfid;
+}
+
+void cifs_put_srch_inf_cfid(struct cifs_search_info *srch_inf)
+{
+	if (!srch_inf->cfid)
+		return;
+
+	close_cached_dir(srch_inf->cfid);
+	srch_inf->cfid = NULL;
+}
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index f82db6a7ca5b0..0767350b40fba 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -8,6 +8,8 @@
 #ifndef _CACHED_DIR_H
 #define _CACHED_DIR_H
 
+struct cifs_search_info;
+
 struct cached_dirent {
 	struct list_head entry;
 	char *name;
@@ -84,6 +86,7 @@ is_valid_cached_dir(struct cached_fid *cfid)
 	return cfid->time && cfid->has_lease;
 }
 
+bool cached_dir_is_valid(struct cached_fid *cfid);
 bool cached_dir_copy_lease_key(struct cached_fid *cfid,
 			      __u8 lease_key[SMB2_LEASE_KEY_SIZE]);
 
@@ -95,6 +98,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 int open_cached_dir_by_dentry(struct cifs_tcon *tcon, struct dentry *dentry,
 			      struct cached_fid **ret_cfid);
 void close_cached_dir(struct cached_fid *cfid);
+void cifs_set_srch_inf_cfid(struct cifs_search_info *srch_inf,
+			   struct cached_fid *cfid);
+void cifs_put_srch_inf_cfid(struct cifs_search_info *srch_inf);
 bool emit_cached_dir_if_valid(struct cached_fid *cfid,
 			      struct file *file,
 			      struct dir_context *ctx);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a15971ffeee58..2a3fad071564a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -309,6 +309,7 @@ struct cifs_search_info;
 struct cifsInodeInfo;
 struct cifs_open_parms;
 struct cifs_credits;
+struct cached_fid;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct cifs_ses *ses, struct TCP_Server_Info *server,
@@ -1395,6 +1396,7 @@ struct cifs_search_info {
 	bool unicode:1;
 	bool smallBuf:1; /* so we know which buf_release function to call */
 	bool is_dynamic_buf:1; /* dynamically allocated buffer - can be variable size */
+	struct cached_fid *cfid; /* Reference to cached file id for directory enumeration */
 };
 
 /* Structure for QueryDirectory with multi-credit support */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 6a1419d59ed5a..9e3c07006f4f2 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1552,6 +1552,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 			cifs_buf_release(buf);
 	}
 
+	cifs_put_srch_inf_cfid(&cfile->srch_inf);
 	cifs_put_tlink(cfile->tlink);
 	kfree(file->private_data);
 	file->private_data = NULL;
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 907e235ad1b8f..ef81fdb503c0a 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -344,7 +344,7 @@ cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
 
 static int
 _initiate_cifs_search(const unsigned int xid, struct file *file,
-		     const char *full_path)
+		     const char *full_path, struct cached_fid *cfid)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
 	struct tcon_link *tlink = NULL;
@@ -368,9 +368,11 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 		spin_lock_init(&cifsFile->file_info_lock);
 		file->private_data = cifsFile;
 		cifsFile->tlink = cifs_get_tlink(tlink);
+		cifs_set_srch_inf_cfid(&cifsFile->srch_inf, cfid);
 		tcon = tlink_tcon(tlink);
 	} else {
 		cifsFile = file->private_data;
+		cifs_set_srch_inf_cfid(&cifsFile->srch_inf, cfid);
 		tcon = tlink_tcon(cifsFile->tlink);
 	}
 
@@ -425,12 +427,12 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 
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
@@ -742,7 +744,11 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 			cfile->srch_inf.srch_entries_start = NULL;
 			cfile->srch_inf.last_entry = NULL;
 		}
-		rc = initiate_cifs_search(xid, file, full_path);
+		/* Pass cfid only if still valid; srch_inf owns the reference. */
+		struct cached_fid *rewind_cfid =
+			cached_dir_is_valid(cfile->srch_inf.cfid) ?
+			cfile->srch_inf.cfid : NULL;
+		rc = initiate_cifs_search(xid, file, full_path, rewind_cfid);
 		if (rc) {
 			cifs_dbg(FYI, "error %d reinitiating a search on rewind\n",
 				 rc);
@@ -968,20 +974,31 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	if (emit_cached_dir_if_valid(cfid, file, ctx))
 		goto rddir2_exit;
 
-	/* Drop the cache while calling initiate_cifs_search and
-	 * find_cifs_entry in case there will be reconnects during
-	 * query_directory.
+	/*
+	 * If cfid is valid but cache is invalid and not failed,
+	 * keep cfid and pass it to initiate_cifs_search to populate.
+	 * Otherwise (no cfid or cache is failed), close cfid and
+	 * proceed without cache for this session.
 	 */
-	close_cached_dir(cfid);
-	cfid = NULL;
+	if (cfid) {
+		bool cache_pending;
+
+		mutex_lock(&cfid->dirents.de_mutex);
+		cache_pending = !cfid->dirents.is_valid && !cfid->dirents.is_failed;
+		mutex_unlock(&cfid->dirents.de_mutex);
+		if (!cache_pending) {
+			close_cached_dir(cfid);
+			cfid = NULL;
+		}
+	}
 
- cache_not_found:
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
@@ -1009,7 +1026,6 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	tcon = tlink_tcon(cifsFile->tlink);
 	rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
 			     &current_entry, &num_to_fill);
-	open_cached_dir(xid, tcon, full_path, cifs_sb, false, &cfid);
 	if (rc) {
 		cifs_dbg(FYI, "fce error %d\n", rc);
 		goto rddir2_exit;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 2df4d080e95f0..05b636fbb20a6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2463,12 +2463,16 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_query_directory_rsp *qd2_rsp = NULL;
 	struct smb2_create_rsp *op_rsp = NULL;
 	struct TCP_Server_Info *server;
+	struct cached_fid *cfid = srch_inf ? srch_inf->cfid : NULL;
 	int retries = 0, cur_sleep = 0;
 	unsigned int compound_resp_bufsize;
+	bool use_cfid_lease = false;
+	bool cfid_open_locked = false;
 
 replay_again:
 	/* reinitialize for possible replay */
 	flags = 0;
+	use_cfid_lease = false;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(tcon->ses);
 
@@ -2476,6 +2480,15 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
+	if (cfid) {
+		mutex_lock(&cfid->cfid_open_mutex);
+		cfid_open_locked = true;
+		use_cfid_lease = cached_dir_copy_lease_key(cfid,
+						      fid->lease_key);
+		oplock = use_cfid_lease ?
+			SMB2_OPLOCK_LEVEL_II : SMB2_OPLOCK_LEVEL_NONE;
+	}
+
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
@@ -2556,6 +2569,10 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = compound_send_recv(xid, tcon->ses, server,
 				flags, 3, rqst,
 				resp_buftype, rsp_iov);
+	if (cfid_open_locked) {
+		mutex_unlock(&cfid->cfid_open_mutex);
+		cfid_open_locked = false;
+	}
 
 	/* If the open failed there is nothing to do */
 	op_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
@@ -2696,6 +2713,8 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 			tcon->ses->Suid, 0, srch_inf->entries_in_buffer);
 
  qdf_free:
+	if (cfid_open_locked)
+		mutex_unlock(&cfid->cfid_open_mutex);
 	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_directory_free(&rqst[1]);
-- 
2.43.0

