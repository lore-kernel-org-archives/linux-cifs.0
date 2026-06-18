Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E1C30567C
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802194; cv=none; b=on5ZBBS4NVGRIakWEAPtLjAO/hiSgZ8t2K60/u4ojRSG81BJRhwe7N4Zgh1WRab5xh3B610pzmdnY1LGvJQQr+47kNBnjkGoAnzptOqgLMYRZcrRzccUUfic7fMdvzkiqdAhiAqy2PoNgT4bClIhwU2LuHpRjPMbJjlclqJlaWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802194; c=relaxed/simple;
	bh=66kFmF/vUxhf7RrsSEtVI8VyZpZ1KASYiEfz7IhTrNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqWjVkIPRN84moLVYX4SnjYdI69U9DY1Bu9742Tbmhrc2bgkipnMTYf88Cce87BkN7XIKaW5Ap0VprBTyN1MkA0sREvCeH0iUj0VBDUeW0SLzitsjZbhQ34Xa3UF8gUZSyBwMnzLusaOBaAwu565F1OWFn+z1ujWcwtcds6JTrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=tLfdUK2h; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="tLfdUK2h"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781802186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=57ag4wVwJV/t4Q8uQj8gvEX2e1OFyqIQvZbzGMtYAi8=;
	b=tLfdUK2hV5nv+jKSbOnQedZWiC5gPYqBtT3xFq1cQPXGasQ72GmGQZFt9UUHzc4O98Yt8Q
	0gjyi1lxzELcrVQTfOreHIxBqq0vdkbaWDbYVCypgdSAhsxNTNrojCSYeOgOdSAG1Dpl55
	VGp+9yi//y/OKcvv7nUXL5s69s4Clht49RM2QiJe3Nbr4GLzCYCT5Yg0dfxypvpJDDVWow
	5/gB3Kg0acjOiDpEGJv2VzqfFa/Cnr07KYnf/ChYPeZPO62eggDEZY+yXpSyrbWjxYkdPY
	jKaHlpqOhKjFosGFuhegVPZixvdFEOepUS1/35OylCwVXcW4Cm85lp0pmSaTqQ==
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
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH 2/2] smb/client: do not call SMB2_close() in smb3_notify()
Date: Thu, 18 Jun 2026 17:02:02 +0000
Message-ID: <20260618170202.244402-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260618170202.244402-1-chenxiaosong@chenxiaosong.com>
References: <20260618170202.244402-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Before this patch, when an operation on the server triggered multiple
actions, the client received only one action notification.

After this patch, the client can receive all action notifications.
After `open(directory)`, only the first `ioctl(CIFS_IOC_NOTIFY_INFO)`
triggers `SMB2_open()`, `cifsFileInfo` is stored in `file->private_data`,
`close(directory)` will trigger `SMB2_close()`.

Example:

  smbinfo notify /mnt

  # server: touch /export/file1
  Notifications received, returned data_len is 24
  Action: 0x00000001, FileName: file1
  Notifications received, returned data_len is 24
  Action: 0x00000003, FileName: file1

  # server: mv /export/file1 /export/file2
  Notifications received, returned data_len is 48
  Action: 0x00000004, FileName: file1
  Action: 0x00000005, FileName: file2
  Notifications received, returned data_len is 24
  Action: 0x00000003, FileName: file2
  Notifications received, returned data_len is 24
  Action: 0x00000002, FileName: file1

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 83 ++++++++++++++++++++++++++++-------------
 1 file changed, 58 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b50d3b8a9252..7b156bc806fe 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2365,47 +2365,84 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 static int
-smb3_notify_open(const unsigned int xid, struct dentry *dentry,
-		 struct cifs_sb_info *cifs_sb, void *page,
-		 struct cifs_fid *fid, const unsigned char **pathp,
-		 __le16 **utf16_pathp, struct cifs_tcon **tconp)
+smb3_notify_open(const unsigned int xid, struct file *pfile)
 {
+	struct inode *inode = file_inode(pfile);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsFileInfo *cfile, *existing_cfile;
 	struct cifs_tcon *tcon;
 	const unsigned char *path;
 	__le16 *utf16_path = NULL;
+	struct tcon_link *tlink = NULL;
 	struct cifs_open_parms oparms;
+	struct cifs_fid fid = {};
+	void *page = NULL;
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	int rc;
 
-	path = build_path_from_dentry(dentry, page);
+	existing_cfile = pfile->private_data;
+	if (existing_cfile && !existing_cfile->invalidHandle) {
+		rc = 0;
+		goto out;
+	}
+	if (existing_cfile && existing_cfile->invalidHandle) {
+		rc = -EBADF;
+		goto out;
+	}
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		goto out;
+	}
+	tcon = tlink_tcon(tlink);
+
+	page = alloc_dentry_path();
+	path = build_path_from_dentry(pfile->f_path.dentry, page);
 	if (IS_ERR(path)) {
 		rc = PTR_ERR(path);
 		goto out;
 	}
-	*pathp = path;
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (utf16_path == NULL) {
 		rc = -ENOMEM;
 		goto out;
 	}
-	*utf16_pathp = utf16_path;
 
-	tcon = cifs_sb_master_tcon(cifs_sb);
-	*tconp = tcon;
+	cfile = kzalloc_obj(struct cifsFileInfo);
+	if (!cfile) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	spin_lock_init(&cfile->file_info_lock);
+	cfile->tlink = cifs_get_tlink(tlink);
+
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.path = path,
 		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
-		.fid = fid,
+		.fid = &fid,
 	};
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
 		       NULL);
+	if (rc) {
+		cifs_put_tlink(cfile->tlink);
+		kfree(cfile);
+		goto out;
+	}
+
+	cfile->fid = fid;
+	cfile->invalidHandle = false;
+	pfile->private_data = cfile;
 
 out:
+	kfree(utf16_path);
+	free_dentry_path(page);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
@@ -2415,17 +2452,12 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 {
 	struct smb3_notify_info notify;
 	struct smb3_notify_info __user *pnotify_buf;
-	struct dentry *dentry = pfile->f_path.dentry;
-	struct inode *inode = file_inode(pfile);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_fid fid;
 	struct cifs_tcon *tcon;
-	const unsigned char *path;
 	char *returned_ioctl_info = NULL;
-	void *page = alloc_dentry_path();
-	__le16 *utf16_path = NULL;
 	int rc = 0;
 	__u32 ret_len = 0;
+	struct cifsFileInfo *cfile = pfile->private_data;
 
 	if (return_changes) {
 		if (copy_from_user(&notify, ioc_buf, sizeof(struct smb3_notify_info))) {
@@ -2440,18 +2472,21 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 		notify.data_len = 0;
 	}
 
-	rc = smb3_notify_open(xid, dentry, cifs_sb, page, &fid,
-			      &path, &utf16_path, &tcon);
-	if (rc)
-		goto notify_exit;
+	if (!cfile || cfile->invalidHandle) {
+		rc = smb3_notify_open(xid, pfile);
+		if (rc)
+			goto notify_exit;
+		cfile = pfile->private_data;
+	}
+
+	tcon = tlink_tcon(cfile->tlink);
+	fid = cfile->fid;
 
 	rc = SMB2_change_notify(xid, tcon, fid.persistent_fid, fid.volatile_fid,
 				notify.watch_tree, notify.completion_filter,
 				notify.data_len, &returned_ioctl_info, &ret_len);
 
-	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
-
-	cifs_dbg(FYI, "change notify for path %s rc %d\n", path, rc);
+	cifs_dbg(FYI, "change notify rc %d\n", rc);
 	if (return_changes && (ret_len > 0) && (notify.data_len > 0)) {
 		if (ret_len > notify.data_len)
 			ret_len = notify.data_len;
@@ -2463,8 +2498,6 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 	}
 	kfree(returned_ioctl_info);
 notify_exit:
-	free_dentry_path(page);
-	kfree(utf16_path);
 	return rc;
 }
 
-- 
2.54.0

