Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCC113790B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246036; cv=none; b=o9l+aF1aditSEkO79R1vuwG0IYwxC2n9wvOfaApM3RKA32SkXcJNyxW5+jjVM1KIxRVYIMNTvgg9BNma2B+Vjbdutx4f6pCWUK55K97XroGPwpHCx4mJBipmmjPHZDk7/zj0TyUFdKPoVnv6FcsQBqHpzJ0a7K3Ww0j6+OidO2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246036; c=relaxed/simple;
	bh=SjcDiPtGvl/K2Oh6cUMCsa0cjzW09YIujEsp8Jv4WMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ud7IqxccGysgiUifP4ZVmBOcpO9ep1Cr0eg+2lisH/iq0zpomDtfq2Py9aQJqtaczDVvpwAMhA3RYdS5bPTesFMCL2sed1zvdXIeqiASm0WPsyyokg7JP8ci8+li8hSdcHTawOCLknUk0DQbR8Lis4V8D+BHjMgRP1Gj1pnhoFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QovFbFWz; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QovFbFWz"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a0edfe29ecso188255eaf.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246034; x=1782850834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qvXFl1v8+oP1DG+Ru/9Dxlv9+AlosIo9zPPycj3ElmU=;
        b=QovFbFWz1cnq8RPv4DirQKOr3Ih9crYijVcZceatS4CRT7M1mrs7CkV+uMcjpyjs2Y
         oKec3VrGiggooUgBNO1Hjb0q1JY7vJ0OY14M6I4u3IxAxE6OQZ9X+z3894ySokyqf2lh
         MMkLbEYOW/t0GXRE93Y57o/3vNbQLsikW+59FZZVlwJ6O/FdoVTlw0kHMqvPIyd7063Q
         NCUZ5ZO16h+ey7kw+ydPD962lk7ularswDq8gF2gTaGzgGpezy2ryIemePAJIfszqVkg
         TxQSZimidtM1BNEzdWjl0bkj1OGB8bqabA5g4yoTJACowPJJTCs9VOfZOkj0mAAIvUXq
         I1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246034; x=1782850834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qvXFl1v8+oP1DG+Ru/9Dxlv9+AlosIo9zPPycj3ElmU=;
        b=SAYIABFjCEMq5JHkTsieshivAWIz4bEWku7lS40sAzRtck9ugIePgLEGoNmhkoU908
         V8XKQ0Jn/VNXpBSHc9/xOvoeZMMiVBCJYWxFtfJhLqUiY7wJQyslzmO5+XRMVgG/SCb5
         gVtrSfxP9PPuvEFL+KpuazbCJ4P+1wKT9/WIWYf9dYalhwz2tp+ZDGmxCLSWgxnGwDa4
         zw021oksa3tUbNRkxzRDWfzfWmto+0ij7vdFukt/n/J/0jOFRAZmdW3j5/OW15cllMSI
         /zacpgpkU+1hhnQcwvVhGcn6xYF45NKNTFjhYY13wQ3ZPlbTDFlxp6BbrPHSNcTZ1wtd
         aRFw==
X-Gm-Message-State: AOJu0Yw4mwmGgFofE9ClBqeWEHZhpsquIjK8LC9yaXaR9rwEVjZkWU78
	cxWEAKdA6LbzGDif633ST2DJ3RiQ/UIOeTejYksfWWqjV2SRmSnER2KsqTxJISCC
X-Gm-Gg: AfdE7cl8LRDDZfRZp5Pt4M55xcaCKcW2yLx/1tu90ltIxsBiCbePcOzSQdEWCPmhYlN
	J7uAeR3UfaAdfQPYYKMesRcZcyGOSe6K7HqLLlpD98tgH3pD6WlAI8/HU0WsX8KlsI+USePb16X
	1pBU9JWfo3G/o+SUO9Yg9axlW06m/sqBYKVeJznYFHYxO7mNbp+tMeyY6N7Nm8Df5B0GBEbeyPF
	/ccJW4yuIqSC8liCAqVmph5zPFjUBJuRP2I3euVNJiGz/VGFOYTWLgTJIKR60Hu/dDoCUOjJF+3
	lW9dxjnmGkjniLmo9La8wxXnd3VJ0GfsVaPGV9dVNS7rc4UO5K0h0WDDtC8Jk6Kwb7F+3VdMdtm
	HflGOG/nX1YImYrIWaRLSDtiE4t083RA5sx3dISMsY/K1inoR89pY2FwzwD5lnnmX3To72qgVBB
	RIM7HaOwyiiE05y34vf4SBXHoQLQSvKTTobI7RHaQqj7cqC1jLLBMngTbxorOsx8tK5hFMMTUMD
	SV0iutZM8t4gOXPgcgM9ejlgaEIKF7mJdMySHsh+Ngrd++JJNzpzCkNomYzEPvx9rzb6E3Lny5T
	jiLQk9Vk9L7u7B925mR3RK9PKNM=
X-Received: by 2002:a05:6820:4dc9:b0:6a1:1357:7e89 with SMTP id 006d021491bc7-6a122e29e1bmr239841eaf.3.1782246034113;
        Tue, 23 Jun 2026 13:20:34 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:33 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 06/16] cifs: query dir should reuse cfid even if not fully cached
Date: Tue, 23 Jun 2026 15:13:33 -0500
Message-ID: <20260623201344.2043841-6-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623201344.2043841-1-stfrench@microsoft.com>
References: <20260623201344.2043841-1-stfrench@microsoft.com>
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
index d8e96d8bbc5e..7aba3d1ae9b3 100644
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
@@ -1133,3 +1147,27 @@ void free_cached_dirs(struct cached_fids *cfids)
 
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
index 323ebe4f5783..990b3cf70a28 100644
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
@@ -85,6 +87,7 @@ is_valid_cached_dir(struct cached_fid *cfid)
 	return cfid->time && cfid->has_lease;
 }
 
+bool cached_dir_is_valid(struct cached_fid *cfid);
 bool cached_dir_copy_lease_key(struct cached_fid *cfid,
 			      __u8 lease_key[SMB2_LEASE_KEY_SIZE]);
 
@@ -96,6 +99,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
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
index b2181cceac3a..aa87421c75c0 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -306,6 +306,7 @@ struct cifs_search_info;
 struct cifsInodeInfo;
 struct cifs_open_parms;
 struct cifs_credits;
+struct cached_fid;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct cifs_ses *ses, struct TCP_Server_Info *server,
@@ -1393,6 +1394,7 @@ struct cifs_search_info {
 	bool unicode:1;
 	bool smallBuf:1; /* so we know which buf_release function to call */
 	bool is_dynamic_buf:1; /* dynamically allocated buffer - can be variable size */
+	struct cached_fid *cfid; /* Reference to cached file id for directory enumeration */
 };
 
 /* Structure for QueryDirectory with multi-credit support */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index fe862bcc99d1..ec993924f26f 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1569,6 +1569,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 			cifs_buf_release(buf);
 	}
 
+	cifs_put_srch_inf_cfid(&cfile->srch_inf);
 	cifs_put_tlink(cfile->tlink);
 	kfree(file->private_data);
 	file->private_data = NULL;
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index d463dc057f80..cbebb6f980e9 100644
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
index fa83fa5ad052..e2663c39d347 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2469,12 +2469,16 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
 
@@ -2482,6 +2486,15 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
 
@@ -2564,6 +2577,10 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = compound_send_recv(xid, tcon->ses, server,
 				flags, 3, rqst,
 				resp_buftype, rsp_iov);
+	if (cfid_open_locked) {
+		mutex_unlock(&cfid->cfid_open_mutex);
+		cfid_open_locked = false;
+	}
 
 	/* If the open failed there is nothing to do */
 	op_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
@@ -2706,6 +2723,8 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 			tcon->ses->Suid, 0, srch_inf->entries_in_buffer);
 
  qdf_free:
+	if (cfid_open_locked)
+		mutex_unlock(&cfid->cfid_open_mutex);
 	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_directory_free(&rqst[1]);
-- 
2.53.0

