Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053576;
	b=m1Qc4RRULxnWVF47NgWaN1M2ibQUiIXjrXGBfRP0HCrGooKlUYBchD8v7aKAfZSKBCbJ
	 fdVkQvPqhL097GCb6gDiqnV6YyZuyPme8eq0abBBZxhKSTXQq5ofx6LhSh6jABZKafN17
	 pzK8MjvPdjKhPNNLpvI6TswvYagiozvOhQsTk3Ysf0SoOVIkhEsVVd9cu4/4Quxckya0U
	 T0r9mNwbs3v7vkuYJPlQBW1F6lDlul9Jbwu8aALtB93rYTR9laiWzLhMabgVjmq657nGU
	 4yVW373961tlAOXOmGlkwDh8gqfTsimBAH2uCiF59AvQBuiJfQlO29EvU7qDPZZWUoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053576;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=+AHOeQv+GND5Q0M/3XIRcfQVZxyeXsBzdilGn7fzPqE=;
	b=aQvAaKQNbzOylSDVD3xOdcmlW4t5eFnhAuX1mwxuOThv/WYxRiNYyEkcSfIHA6FHXAq5
	 QyvE6u3/p1394kBNU6pwA9udFnRtHaFlp9XXp9swAiU7r3XjBnR6I3nM3pypN4JNOuGGT
	 kBJQmKoQ+bI15QAu3tDlaF2gnEPeMc90n4hN94nsUcpl41QzLsj5KveLwq8qicS6cO0Wk
	 M5Lo0oFrvYJMGeNm0cRttu62NvYPNDk6Pv47SQEeWuqhMF9voRuQlsK4UIMu0PVUc9CCt
	 aUHrkUFPYZ/bx3HgyP0At9hK2LWGvgPdXhd6AumRXw56bmzfpF3XjRdxq4AWWZqGeJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fsqUjz6c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE5F606A329;
	Mon, 26 Oct 2026 22:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fsqUjz6c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6C31F01828;
	Mon, 26 Oct 2026 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053575;
	bh=+AHOeQv+GND5Q0M/3XIRcfQVZxyeXsBzdilGn7fzPqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsqUjz6c1FUL5rCoTT14tRhqUo9UwOIBO+2bolJH2qKA0Xk0QGQwA7m4PY29CG5Nk
	 DJTHVPeXWtM+kof+vLFHDYyv/rATaPuIj1mxIXDNEbZEtNg9TEw7ESEZL4uNsMaTkV
	 4SrXPaLGurR21Lhu7Qa5GOTLA1eD72L/J7AIepOAgZLZLBIbAJgsB8HVIxC4zA1jVb
	 GUwgOdjqS3sK9ZLo4be9W3SS5QMZfIXHuJGrhp1zei03mz/MRVMRw4ynJGn3+l6cAG
	 /Ymgtwd04JKUschWJBS48VpIUU2ULX6p0L7DVUzMmbfvj5G/hnq72cXdtqadHmNl4f
	 mj2zcaA9VuMwQ==
Received: by pali.im (Postfix)
	id C4F05FA6; Mon, 26 Oct 2026 23:26:10 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 7/9] cifs: Create native Window socket file compatible also with WSL subsystem
Date: Mon, 26 Oct 2026 23:25:58 +0100
Message-Id: <20261026222600.17323-8-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261026222600.17323-1-pali@kernel.org>
References: <20261026222600.17323-1-pali@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
index 86eb56dbc81a..6a7e6d9ad375 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -409,7 +409,7 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 
 static int create_native_socket(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
-				const char *full_path)
+				const char *full_path, umode_t mode)
 {
 	struct reparse_data_buffer buf = {
 		.ReparseTag = cpu_to_le32(IO_REPARSE_TAG_AF_UNIX),
@@ -423,6 +423,10 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
 		.iov_base = &buf,
 		.iov_len = sizeof(buf),
 	};
+#ifdef CONFIG_CIFS_XATTR
+	const __le64 xattr_mode_val = cpu_to_le64(mode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+#endif
 	struct inode *new;
 	int rc = 0;
 
@@ -433,6 +437,28 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
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
@@ -742,7 +768,7 @@ int mknod_reparse(unsigned int xid, struct inode *inode,
 	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
 
 	if (S_ISSOCK(mode) && !ctx->nonativesocket && ctx->reparse_type != CIFS_REPARSE_TYPE_NONE)
-		return create_native_socket(xid, inode, dentry, tcon, full_path);
+		return create_native_socket(xid, inode, dentry, tcon, full_path, mode);
 
 	switch (ctx->reparse_type) {
 	case CIFS_REPARSE_TYPE_NFS:
-- 
2.20.1

