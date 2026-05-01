Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB75F3AB26C
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634443; cv=none; b=uII0JCo/KLn8RIQ8/PXjE/KsDFhZg4/WtKLiacnziZflEXCJ+7imfQnASLlpuV5hjPwj+pD+V8FpC+9ETw9DbCusSHXzYsBzKN0fH1dtmy5xn1t2pD2BwKMeTebaC4lpyKFaOLt8XAX1i9PZ8ewnFx6VFprrJlyX5Ll4wBjyKdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634443; c=relaxed/simple;
	bh=8sxUOa4GOq0ES6V2+B00JkoL9Pv89jv4RGkW+5b08nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKZTR3kuftA357/uebS6TGR2GvI39A5msQgvcu4Xfd1he3zKh2zaX9WP9tWnHfItVcmlZbyDdR4GTn40tU1Zuqk0+9ZXhNiXU+zFHVBORf9a4uZpJUEZh11/SKlVx+zqWz6eaKrCDuU/LH3vroNto/LG6R3gJqqaPwhv5hMkggw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTyDkWmJ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTyDkWmJ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82f68b3aaf7so825718b3a.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634440; x=1778239240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DEpNZWYhAGnzhrFxPDmeqdZuHK3C9i+Vxou+CJqZF6E=;
        b=dTyDkWmJUpZPL15bDl1eJBBRRH4oNAXgC+YfBUsYGJYV9QpqOP6ORQw61k/mEjmBey
         g519dEzgF8ieGeiJBzfyOh+k+/Yee+I6xFefxbFndrHpBQzwqqHC0KZHWiGcOAreFw9s
         QnG3/N/5+ODe4WMmBo8DXXbvGtolODDA8fKiVRloCaHupa5Ss3Y9+rKnlYdzizDUDD/B
         NUxZE+TWJa/oU9Vk1gmqGtmFyA/0Xh+NXW2Zu7RYBtMny8eJoZ4muQdTORObVX4yDLCe
         Jg/663Wodbo4V9jryhhQBGZ49BMzcd8r5Nm9Am5QMrTivLOFr7UIyzDiEVGiU2SlLHRf
         MILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634440; x=1778239240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DEpNZWYhAGnzhrFxPDmeqdZuHK3C9i+Vxou+CJqZF6E=;
        b=MeVNTe4wyTatWNNFGG0oIo+khKygsEz2zT3kwcytGIR9Nqznbc4bHBINCKOvPhjozZ
         WMQkv3amie+etjknrcHmXfao3P15JVykLX6C69JRdQM6ogxkglPdshF7so0mnbRfnEOc
         QJ8I0mnd0P+N6+Rewkc06NhBjRdzzp/tnL7BCUO9Vu5A7axzhBG7wgY7aeADzKE0x8va
         XnZiNYB/RKnQ2crJwcHaZRQXzxGwPfMVvgBLSpuJal/x+5epYJSvFuvMYuRZ6zpqL+el
         Kvj0rmVL8o7SqSuxTtyYdZ9aN73sL85fAQBfpDcB5/MPvOA+9GKDiPFfwJKeFCtomQSn
         2hRg==
X-Gm-Message-State: AOJu0YxQFnKlQ8jMCU7qLx3Rsizn60YRfysp5bBdpyRVaNOWUyXVyL9B
	F0dhueOcGE31Tz10b4vbK6pGigL+qrPWbiSWK3jtwJrgd4ZCTOrDLW1+G2PhCTJNbHg=
X-Gm-Gg: AeBDietwHuMLF+lnI501KZoHIIz94rStjaBHHBrRLHHeS5kfh8YOKxmipiNP96gK34t
	xNXRT5EWSHEO+hKfAccSrIGV6dyRy/r6ShsFOFwYeD3SW1L7hM6RUG1kIpguvtA6r+NYUlr1uUh
	CiJv+uri9A1fJqwaara9aKS8FgamHT6HIF4tmOpxXyke30ZYZ3cUweGQavaerw8MPg6nRQg0Yi+
	zkd7PB0/YF++vwBFRZI18Y9FSkiPqk95VnGDngLuWhUK3m7s+o14hPb6MZ5Rqmp0UExEWAry14x
	2DlEC0utRXj9uYkOfi7T0fw8KrEruZPSwS/y6MFBQc62Cl+dlSHwns9IdnMO2cylv1NPTodC06V
	BOMCB0jTTQ+6xZlc03Bwi0p7lERlOVkPage+6xiRJ3eC6/aWrmw5Qa9hCmUKyrZ7x/x1SIKd4Bb
	EvhSvm/P5tCIrqh9vuY7dwk18oyu6jmO90vSo4b3CQrq6d5sL/ANsoQUYri7QBDg2R
X-Received: by 2002:a05:6a00:a90d:b0:82f:a085:c46b with SMTP id d2e1a72fcca58-834fdc96843mr8252612b3a.47.1777634440438;
        Fri, 01 May 2026 04:20:40 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:39 -0700 (PDT)
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
Subject: [PATCH v4 09/19] cifs: query dir should reuse cfid even if not fully cached
Date: Fri,  1 May 2026 16:50:12 +0530
Message-ID: <20260501112023.338005-9-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
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

