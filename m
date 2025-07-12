Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D46289816;
	Sat, 12 Jul 2025 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752336628; cv=none; b=YsG9pxEiboTqAHTpG0iUKytv1s+qQFanRXaca4hXqZJ/n98ID5BiFnWxnUVfjCbFQs43IbFUy4RfnLnFxTozQuN+KLIbqagyXboLFtODOU5z1b9IZh1xMGnQTKR2a+7WGETfLud+rVAvG2JSyvFp1iF5sOTbUzgYvgLdQ/p/OVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752336628; c=relaxed/simple;
	bh=Cm985pc/kNayqXbA3m4Ka9MuMJHgAUD3wAX10g8lc8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uglV9PehdLnWHJuHc9aE/47OTjaMha/6RxTlBvjqeviXVuLSB6teZF1eQwoksDDGsnmBlcx0cJ4TYE0E5La2DItlBKn+1uQ324mB/EKuA9VB1mP9HVSmeWXEDzA9eTTsdzygXn2Aqjs+LU4sOeXAsfvsTnc6EqmwHYV6uaUArzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJjI/83p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJjI/83p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E778EC4CEEF;
	Sat, 12 Jul 2025 16:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752336628;
	bh=Cm985pc/kNayqXbA3m4Ka9MuMJHgAUD3wAX10g8lc8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJjI/83psrj81lL0Ukr7LPKsn9x8Vrdmi8CoXOS5vDlUmJIbNsVPQoLpJ3CKDD3hl
	 05TM9KhluXPkOlwZeNpvEdNWJLZ8MZSvosrwy5nI7W4UupKwYkj0O6OjSNql248HPg
	 cL051dlzJ3J0ONP8a8ylp3X+Qe9ZgMHCo5yh/cA7kEUX/sHzbkFR9cMCdSE8eGJImH
	 SC8yyTpm9XzvHJBladjYlOIfwvLDb71DvKVwrrTZACPrRxLft2k7IRN2kdttHmcxWp
	 qknfxgcmrm0z2xr9JRllP7+USekYcZAFBr24myNNMcNlL/8Nig8F/PYwyQOmjukoXU
	 RN+9Ft5HUqaQA==
Received: by pali.im (Postfix)
	id E08E0CA1; Sat, 12 Jul 2025 18:10:21 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cifs: Create native Window socket file compatible also with WSL subsystem
Date: Sat, 12 Jul 2025 18:10:12 +0200
Message-Id: <20250712161012.17622-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250712161012.17622-1-pali@kernel.org>
References: <20250712161012.17622-1-pali@kernel.org>
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
 fs/smb/client/reparse.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index ee4af153e7af..74a36957e8cb 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -381,7 +381,7 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 
 static int create_native_socket(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
-				const char *full_path)
+				const char *full_path, umode_t mode)
 {
 	struct reparse_data_buffer buf = {
 		.ReparseTag = cpu_to_le32(IO_REPARSE_TAG_AF_UNIX),
@@ -395,6 +395,8 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
 		.iov_base = &buf,
 		.iov_len = sizeof(buf),
 	};
+	const __le64 xattr_mode_val = cpu_to_le64(mode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct inode *new;
 	int rc = 0;
 
@@ -405,6 +407,28 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
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
@@ -714,7 +738,7 @@ int mknod_reparse(unsigned int xid, struct inode *inode,
 	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
 
 	if (S_ISSOCK(mode) && !ctx->nonativesocket && ctx->reparse_type != CIFS_REPARSE_TYPE_NONE)
-		return create_native_socket(xid, inode, dentry, tcon, full_path);
+		return create_native_socket(xid, inode, dentry, tcon, full_path, mode);
 
 	switch (ctx->reparse_type) {
 	case CIFS_REPARSE_TYPE_NFS:
-- 
2.20.1

