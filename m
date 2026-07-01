Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E343C25A2C6
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894348; cv=none; b=U35nV9zMpcDDH1HiKPDIv6cCW8gJgEdfsZ1u4JEojL+ztHnb1lAzeF6KuYOKDNVRCIodK601etWzcVjXBKnI2KR+fs6WMBEtexok2SV6mHZKS/xA5lSiz9hN8ZCbLLBbATt6aJgbIZ7VHcV2qPh9UbR5+R/1JTB2LUHf58JjotM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894348; c=relaxed/simple;
	bh=dXfQHc66WUUZIif0YqT1RSOuLvi8mgTS74s3eUebqCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ9YLuTeiEZ45yIQEX2u9LhOH0InpIFLfflUJyfcxSX9z3/QfFPmXfBV0QbvI95Pz1Gv5/YTTtk9v1ayZIUNUXBtDDrQEdNIBSWTR1UEzB8m2SbY5IFbsSJpyVxaKppKR/QxpZVIsBZLbGjJvKx0TtPC7Lmm1MiMVXsZEWwwG/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=hVUdwh1q; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="hVUdwh1q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LbJT21G1NVbQbIT8V91xWEHmmXgpuCgBPQdWxpuqzMA=;
	b=hVUdwh1qWEsoOK7qqTWD5xqLCSztPyXnaEZ8rMax71/bjbZWofDQSpgE3tcbYM8Kljaqup
	zOmA8mcvxCcUKq5pBOVB/EYUN7x9VmjnGrKdWO9OKL+Q118+cwvPzA/FCKmpcc6eMGnqbi
	7wHS3k3cC5rgUjt9yuSGrf8o+UWaQuSd7g8UMH3n2KRtPd/Bc5iiHc8V0PHUzgbCzlcFtF
	uM3cM0XP85WWS+HRoqs0muCzwuuVT3oUBgrqE/EkE79VHpvUs09FiitESt/3i61dKq+s9/
	GXXxBYToG9CU37VkTXJ3hpfc3JdiaKsPfzvDhzjdEVMnFTPFQzjH4bsMrPQO4g==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/9] smb/client: factor out cifs_new_dir_fileinfo()
Date: Wed,  1 Jul 2026 08:24:59 +0000
Message-ID: <20260701082507.786487-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
References: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

This patch was split out to make it easier to review.

Both readdir and notify can need directory private data before a
search handle exists. Move the common cifsFileInfo allocation and
initialization into a helper so those paths share the same setup.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsproto.h |  2 ++
 fs/smb/client/file.c      | 24 ++++++++++++++++++++++++
 fs/smb/client/readdir.c   | 14 ++++++--------
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c4ababcb51a3..dfbad6bc0a9b 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -267,6 +267,8 @@ void cifs_close_all_deferred_files(struct cifs_tcon *tcon);
 void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_sb);
 void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 					   struct dentry *dentry);
+struct cifsFileInfo *cifs_new_dir_fileinfo(struct file *file,
+					   struct tcon_link *tlink);
 
 void cifs_mark_open_handles_for_deleted_file(struct inode *inode,
 					     const char *path);
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 8b25d6c9ec5e..f1e854f381d9 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -660,6 +660,30 @@ cifs_down_write(struct rw_semaphore *sem)
 static void cifsFileInfo_put_work(struct work_struct *work);
 void serverclose_work(struct work_struct *work);
 
+struct cifsFileInfo *cifs_new_dir_fileinfo(struct file *file,
+					   struct tcon_link *tlink)
+{
+	struct cifsFileInfo *cfile, *old;
+
+	cfile = kzalloc_obj(struct cifsFileInfo);
+	if (!cfile)
+		return NULL;
+
+	spin_lock_init(&cfile->file_info_lock);
+	mutex_init(&cfile->fh_mutex);
+	cfile->invalidHandle = true;
+	cfile->tlink = cifs_get_tlink(tlink);
+
+	old = cmpxchg(&file->private_data, NULL, cfile);
+	if (old) {
+		cifs_put_tlink(cfile->tlink);
+		kfree(cfile);
+		return old;
+	}
+
+	return cfile;
+}
+
 struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 				       struct tcon_link *tlink, __u32 oplock,
 				       const char *symlink_target)
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index a50c86bbe60f..f108e719e683 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -355,20 +355,17 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	__u16 search_flags;
 	int rc = 0;
 
-	if (file->private_data == NULL) {
+	if (!file->private_data) {
 		tlink = cifs_sb_tlink(cifs_sb);
 		if (IS_ERR(tlink))
 			return PTR_ERR(tlink);
 
-		cifsFile = kzalloc_obj(struct cifsFileInfo);
-		if (cifsFile == NULL) {
+		cifsFile = cifs_new_dir_fileinfo(file, tlink);
+		if (!cifsFile) {
 			rc = -ENOMEM;
 			goto error_exit;
 		}
-		spin_lock_init(&cifsFile->file_info_lock);
-		file->private_data = cifsFile;
-		cifsFile->tlink = cifs_get_tlink(tlink);
-		tcon = tlink_tcon(tlink);
+		tcon = tlink_tcon(cifsFile->tlink);
 	} else {
 		cifsFile = file->private_data;
 		tcon = tlink_tcon(cifsFile->tlink);
@@ -1125,7 +1122,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
 	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
 	 */
-	if (file->private_data == NULL) {
+	cifsFile = file->private_data;
+	if (!cifsFile || cifsFile->invalidHandle) {
 		rc = initiate_cifs_search(xid, file, full_path);
 		cifs_dbg(FYI, "initiate cifs search rc %d\n", rc);
 		if (rc)
-- 
2.54.0

