Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A34B172BDE;
	Sun,  6 Oct 2024 10:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728208870; cv=none; b=gMxVYfDVAeXf5i2jnpHvDSZxTAUBMpd0DN2dSo7OnYeIA5z2pVMqtt5YZZHcWgXpu56ZGsAYO1jePup0IUz0fHPKU7ThOjR+UIKTEN3Ba39ABlU2dETNcefEoTUh9XEPWU/sc/tAk8UVOjWU4hihKwG/5rBKI+Kdjiou/7jLTRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728208870; c=relaxed/simple;
	bh=1HEPHV7KcUkKxaUZCYCFRY2RNfcJW+87yTdK2jAscHM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f7jbdRKe16s1JpaSNKi7POOD+n9Ib4XV8ypPnbcxFK8EF9F2NGlIXE5bG5u860yl+qCf8FaPKtJXXgZkOjHLf3fZXXdfYPbaiCX6b8Bql9dUNUInVwDyAVwUtdTIH8wdJAT5hpm/pVf16T1ce6SlB2PmjSc8Orxbm62uWRwba6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7Ltkw6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7Ltkw6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D941C4CECF;
	Sun,  6 Oct 2024 10:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728208870;
	bh=1HEPHV7KcUkKxaUZCYCFRY2RNfcJW+87yTdK2jAscHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7Ltkw6NAfIP4tBmPRbL2iZ/OkcS+MF50wgcwpNjre7zVdy0yg0fdZPOiSJku2vYa
	 Pjcn/gRq8XxSwD5rCxL2MzEXUC43t7SwC/YiTkL1nd6QC4iZ5iKncuMR75EuYJ7B82
	 hYixh8zSuq1Xnn69lfEFAJ4fApgmAs/IGrOgkRsz/FvyZK89fOvdx7SbzUBeN4S9G/
	 Mj3Jtc7PMXeEPLemy/NDU9ZrveVUG/JLar565uavtJKseaqvxAVNmJmdlB3zTyo9ww
	 DU2LH/7GGY33qiVJXQZxgCDPVnMCqRw1DUDnZQuVTYBRf6mfBAnMvKVKQCl2ZVvrcJ
	 ov28n6L1CyIHQ==
Received: by pali.im (Postfix)
	id 9B4CBC2E; Sun,  6 Oct 2024 12:01:02 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] cifs: Add support for creating native Windows sockets
Date: Sun,  6 Oct 2024 12:00:42 +0200
Message-Id: <20241006100046.30772-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241006100046.30772-1-pali@kernel.org>
References: <20241006100046.30772-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Native Windows sockets created by WinSock on Windows 10 April 2018 Update
(version 1803) or Windows Server 2019 (version 1809) or later versions is
reparse point with IO_REPARSE_TAG_AF_UNIX tag, with empty reparse point
data buffer and without any EAs.

Create AF_UNIX sockets in this native format when -o reparse=native or
-o reparse=native+<something> mount option is used.

This change makes AF_UNIX sockets created by Linux CIFS client compatible
with AF_UNIX sockets created by Windows applications on NTFS volumes.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h |  6 +++---
 fs/smb/client/reparse.c  | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7632d2ba5390..570b22d02f7e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -155,9 +155,9 @@ enum securityEnum {
 
 enum cifs_reparse_type {
 	CIFS_REPARSE_TYPE_NONE, /* disable creating new reparse points */
-	CIFS_REPARSE_TYPE_NATIVE, /* native symlinks only */
-	CIFS_REPARSE_TYPE_NATIVE_NFS, /* native for symlinks, nfs for others */
-	CIFS_REPARSE_TYPE_NATIVE_WSL, /* native for symlinks, wsl for others */
+	CIFS_REPARSE_TYPE_NATIVE, /* native symlinks and sockets only, no support for others */
+	CIFS_REPARSE_TYPE_NATIVE_NFS, /* native for symlinks/sockets, nfs for fifos/block/char */
+	CIFS_REPARSE_TYPE_NATIVE_WSL, /* native for symlinks/sockets, wsl for fifos/block/char */
 	CIFS_REPARSE_TYPE_NFS, /* nfs for everything */
 	CIFS_REPARSE_TYPE_WSL, /* wsl for everything */
 	CIFS_REPARSE_TYPE_DEFAULT = CIFS_REPARSE_TYPE_NATIVE_NFS,
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 38fe0a710c65..f1488f870320 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -379,6 +379,35 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 	return 0;
 }
 
+static int create_native_socket(const unsigned int xid, struct inode *inode,
+				struct dentry *dentry, struct cifs_tcon *tcon,
+				const char *full_path)
+{
+	struct cifs_open_info_data data = {
+		.reparse_point = true,
+		.reparse = { .tag = IO_REPARSE_TAG_AF_UNIX, },
+	};
+	struct reparse_data_buffer buf = {
+		.ReparseTag = cpu_to_le32(IO_REPARSE_TAG_AF_UNIX),
+		.ReparseDataLength = 0,
+	};
+	struct kvec iov = {
+		.iov_base = &buf,
+		.iov_len = sizeof(buf),
+	};
+	struct inode *new;
+	int rc;
+
+	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+				     tcon, full_path, false, &iov, NULL);
+	if (!IS_ERR(new))
+		d_instantiate(dentry, new);
+	else
+		rc = PTR_ERR(new);
+	cifs_free_open_info(&data);
+	return rc;
+}
+
 static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 			       mode_t mode, dev_t dev,
 			       struct kvec *iov)
@@ -602,6 +631,13 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
 {
 	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
 
+	if (S_ISSOCK(mode) && (
+	     ctx->reparse_type == CIFS_REPARSE_TYPE_NATIVE ||
+	     ctx->reparse_type == CIFS_REPARSE_TYPE_NATIVE_NFS ||
+	     ctx->reparse_type == CIFS_REPARSE_TYPE_NATIVE_WSL)) {
+		return create_native_socket(xid, inode, dentry, tcon, full_path);
+	}
+
 	switch (ctx->reparse_type) {
 	case CIFS_REPARSE_TYPE_NATIVE_NFS:
 	case CIFS_REPARSE_TYPE_NFS:
-- 
2.20.1

