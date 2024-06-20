Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67F619AD5C;
	Thu, 20 Jun 2024 08:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.245.218.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718873467; cv=none; b=hLqCvUSi+7DGho5jzDlDfe6QMrhNLwxI7EOxiZM77bVKe/h1MxGsHZrEQrA6mZy5RsKDqw3sftGos3u83hfSnVzd5tTKOzzlW+I/AJsMO5a0Qfuj1VO71BfY/occH88CJZ4urnt16llFFUvHQtjomBrQ3GlX9g/nssQ87xHo4H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718873467; c=relaxed/simple;
	bh=sUvQHFWXwTVizgjSFLoS2IxCi10pqoHZtHkb+mRkI6s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IoAX06BYzRW7mtaNJK9RLMzGiAiZnqpibXJwU5G5GxadO0Xr9j3QBnw8Q5eaS0hiG3bZXAMoQRCVAKgy0JO7YCLqcesrZFY1lZHBtBrfX4pB3shVZaIlKuL4A+4Cxy2wKYPaVIa9LplLt4UnHVHtStqVw7tUjte+EyqTz22HYR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=13.245.218.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-mid: bizesmtpsz12t1718872779tqad9p
X-QQ-Originating-IP: Yx/PM8hjdE0hSifBpo19wymsZe1VP0BiCo+IMSzIhnU=
Received: from localhost.localdomain ( [110.191.179.216])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 20 Jun 2024 16:39:17 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16193038021665393026
From: wangrong <wangrong@uniontech.com>
To: sfrench@samba.org
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	wangrong <wangrong@uniontech.com>
Subject: [PATCH] smb: client: use actual path when queryfs
Date: Thu, 20 Jun 2024 16:37:29 +0800
Message-Id: <20240620083729.28623-1-wangrong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5a-0

Due to server permission control, the client does not have access to
the shared root directory, but can access subdirectories normally, so
users usually mount the shared subdirectories directly. In this case,
queryfs should use the actual path instead of the root directory to
avoid the call returning an error (EACCES).

Signed-off-by: wangrong <wangrong@uniontech.com>
---
 fs/smb/client/cifsfs.c   | 13 ++++++++++++-
 fs/smb/client/cifsglob.h |  2 +-
 fs/smb/client/smb1ops.c  |  2 +-
 fs/smb/client/smb2ops.c  | 19 ++++++++++++-------
 4 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index bb86fc064..a4d59f0f5 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -313,8 +313,17 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int xid;
 	int rc = 0;
+	const char *full_path;
+	void *page;
 
 	xid = get_xid();
+	page = alloc_dentry_path();
+
+	full_path = build_path_from_dentry(dentry, page);
+	if (IS_ERR(full_path)) {
+		rc = PTR_ERR(full_path);
+		goto statfs_out;
+	}
 
 	if (le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength) > 0)
 		buf->f_namelen =
@@ -330,8 +339,10 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_ffree = 0;	/* unlimited */
 
 	if (server->ops->queryfs)
-		rc = server->ops->queryfs(xid, tcon, cifs_sb, buf);
+		rc = server->ops->queryfs(xid, tcon, full_path, cifs_sb, buf);
 
+statfs_out:
+	free_dentry_path(page);
 	free_xid(xid);
 	return rc;
 }
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 73482734a..d3118d748 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -483,7 +483,7 @@ struct smb_version_operations {
 			__u16 net_fid, struct cifsInodeInfo *cifs_inode);
 	/* query remote filesystem */
 	int (*queryfs)(const unsigned int, struct cifs_tcon *,
-		       struct cifs_sb_info *, struct kstatfs *);
+		       const char *, struct cifs_sb_info *, struct kstatfs *);
 	/* send mandatory brlock to the server */
 	int (*mand_lock)(const unsigned int, struct cifsFileInfo *, __u64,
 			 __u64, __u32, int, int, bool);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 212ec6f66..e3a195824 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -909,7 +909,7 @@ cifs_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
 
 static int
 cifs_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
-	     struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
+	     const char *path, struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
 {
 	int rc = -EOPNOTSUPP;
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c8e536540..bb7194386 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2784,7 +2784,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int
 smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
-	     struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
+	     const char *path, struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
 {
 	struct smb2_query_info_rsp *rsp;
 	struct smb2_fs_full_size_info *info = NULL;
@@ -2793,7 +2793,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 
 
-	rc = smb2_query_info_compound(xid, tcon, "",
+	rc = smb2_query_info_compound(xid, tcon, path,
 				      FILE_READ_ATTRIBUTES,
 				      FS_FULL_SIZE_INFORMATION,
 				      SMB2_O_INFO_FILESYSTEM,
@@ -2821,28 +2821,33 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int
 smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
-	       struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
+	       const char *path, struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
 {
 	int rc;
-	__le16 srch_path = 0; /* Null - open root of share */
+	__le16 *utf16_path = NULL;
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 
 	if (!tcon->posix_extensions)
-		return smb2_queryfs(xid, tcon, cifs_sb, buf);
+		return smb2_queryfs(xid, tcon, path, cifs_sb, buf);
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
-		.path = "",
+		.path = path,
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
 		.fid = &fid,
 	};
 
-	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (utf16_path == NULL)
+		return -ENOMEM;
+
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
+	kfree(utf16_path);
 	if (rc)
 		return rc;
 
-- 
2.20.1

