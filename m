Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C9F48F836;
	Tue, 25 Aug 2026 23:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699201; cv=none; b=h/bvbUr6Zrkg/cz0xzwQ9qeLm4Sk0e+I8De6k+QqJm2YX4rJQ1KUJIg6MiN92FYV4SIlAd/YD+lTQYtf7DYlrKTbqOD5d6T2M8MuwLyFi2hHFkNnTOb0ugcwsIhaXXD8JmdT7+GJMk8/4hNGVnLN+4FoZ01yAh/vsQIhIbYWip8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699201; c=relaxed/simple;
	bh=ODZY08rGRpu1bMBIuLXXLpP4TGc/a5RVqujJigqPHCI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NHurZwwtT36Mm20uJFp1V96C7IQ9PNfAESQ5c5vTbuG8Wc7KUtZItSWFHI4LhkhDENKMhvjPDfWpYUXhFb/Y0QwqZ6V/TWp8THRgJ+k6flbpzmf4P8SXHE2if4L8/Cpr3at18I32K98drbr6RlLVxhnA8W+UVUjaOFGqT8FxhyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GCH1XkNd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GCH1XkNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFAB1F00ACF;
	Tue, 25 Aug 2026 23:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787699199;
	bh=quCzjb53wdGaHiRz14QLt+nRl+z3UnuHae+QbIgP0r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCH1XkNdWvm+A4F8R0AErthm1mqFh2hMILNJ8de6WNbEdRa1p5Fp+AYvTRiAEP9B/
	 KSuIO++Nrp2gSiYmkZaqWFsJx7Y2gdSE5TMMzsBvGVcoExprGn+LK7PM5t6gnlX1Q3
	 ec5Y6hraZfdCnDyVh8SytHV+Sv7u6Ohv0RfqORArXs2Sl8M6F+EopAxHUwevM6G6rP
	 rBU34SRap/MJsNyi3UD1RsWIbZMj6uv3FXQm8RnXRzDY7oiQnAwbNJ51yZ6THZmetj
	 +xn5mxAqO9GUcbDi0PxguNoC+IXsYJfeYPFBapr/q/ElyxfGP2DJuPcnW4GkFafpvu
	 DUM28/e+QRR7A==
Received: by pali.im (Postfix)
	id 1C1B11B5C; Wed, 26 Aug 2026 01:06:39 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] cifs: Create native Window socket file compatible also with WSL subsystem
Date: Wed, 26 Aug 2026 01:06:20 +0200
Message-Id: <20260825230622.24617-8-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260825230622.24617-1-pali@kernel.org>
References: <20260821214722.q7rkflclyyugdxll@pali>
 <20260825230622.24617-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

After creating a native socket via the IO_REPARSE_TAG_AF_UNIX reparse
point, try to set also the WSL EA $LXMOD.

This makes the native Win32 / NT socket file recognized also under
WSL subsystem. WSL subsystem uses same reparse point tag but requires also
to be EA $LXMOD set.

Fixes: 45a99d5d1173 ("cifs: Add support for creating native Windows sockets")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 0829f5373a38..4dd81e40e947 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -399,7 +399,7 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 
 static int create_native_socket(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
-				const char *full_path)
+				const char *full_path, umode_t mode)
 {
 	struct reparse_data_buffer buf = {
 		.ReparseTag = cpu_to_le32(IO_REPARSE_TAG_AF_UNIX),
@@ -413,6 +413,10 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
 		.iov_base = &buf,
 		.iov_len = sizeof(buf),
 	};
+#ifdef CONFIG_CIFS_XATTR
+	const __le64 xattr_mode_val = cpu_to_le64(mode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+#endif
 	struct inode *new;
 	int rc = 0;
 
@@ -423,6 +427,28 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
 		d_instantiate(dentry, new);
 	else
 		rc = PTR_ERR(new);
+
+	/*
+	 * Try to set also optional WSL EA $LXMOD but ignore errors.
+	 * WSL socket and native Win32/NT sockets uses same reparse point
+	 * tag IO_REPARSE_TAG_AF_UNIX. WSL subsystem additionally requires
+	 * EA $LXMOD to be set with the S_IFSOCK value. So setting this EA
+	 * allows native socket to be recognized also by WSL subsystem.
+	 * Note that setting of both EAs and reparse points is not supported
+	 * by NTFS filesystem on Windows 8 / Windows Server 2012 and always
+	 * fails. So ignore failures from this set_EA call.
+	 */
+#ifdef CONFIG_CIFS_XATTR
+	if (!rc && tcon->ses->server->ops->set_EA &&
+	    (le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_EXTENDED_ATTRIBUTES))
+		tcon->ses->server->ops->set_EA(xid, tcon, full_path,
+					       true /* open reparse point */,
+					       SMB2_WSL_XATTR_MODE,
+					       &xattr_mode_val,
+					       SMB2_WSL_XATTR_MODE_SIZE,
+					       cifs_sb->local_nls, cifs_sb);
+#endif
+
 	cifs_free_open_info(&data);
 	return rc;
 }
@@ -732,7 +758,7 @@ int mknod_reparse(unsigned int xid, struct inode *inode,
 	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
 
 	if (S_ISSOCK(mode) && !ctx->nonativesocket && ctx->reparse_type != CIFS_REPARSE_TYPE_NONE)
-		return create_native_socket(xid, inode, dentry, tcon, full_path);
+		return create_native_socket(xid, inode, dentry, tcon, full_path, mode);
 
 	switch (ctx->reparse_type) {
 	case CIFS_REPARSE_TYPE_NFS:
-- 
2.20.1

