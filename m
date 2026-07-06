Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62043D3D01;
	Mon,  6 Jul 2026 18:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363738; cv=none; b=MYH/zjEdwuF0a6n56brUU1Zpe0bKZae1ZohhAs9wo6OCDdvdYprZ54ocrSk7NcHwC3/2qmn69vvmrMBn5aiQQMyntXGmVxfavCh8bJxWkN4MY14SU7n2FMtW9Ao72ghkg4sg9HX10GLItP/qHp1pBOyqRlE+XzHG4xNTogRZO+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363738; c=relaxed/simple;
	bh=D8WpqHRxxiV7OTrV7/dV3wADdXy95HkBUJDrldNtfrA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AUVN2MV7ARSHaplvlPWeCyFVHvmvqOuwU05cK/4QLu/u9btnvdUZxv7sbsc/0esqFLxYkvUIQxnOEh7bziBXqDQ5hJf0k1aNGfhK0ddvJdni4cxsoGvkLV/brFpnU6XgVgnEKvBSZU55q1xNJY+SA3YEq0sHsbXgSbcKIzzD11w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7F/doin; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7F/doin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4491F00ADB;
	Mon,  6 Jul 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363719;
	bh=qPXP98Q76Ws0kZmMs094sKpxd/ePbp6bzS3TlRqGYDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7F/doinTCZJH0ixr+zpKs5y5mJn4obIEnpb1aKaSqhulWUPSm0DnGp1IaX7hi3in
	 eoUzvh77v6gnkzVFanA+1v+/NpnR7C/YZqvW53amjQrlQzGLc8+jeaCDZ0sOLa/kH1
	 IVBtoeDaHJlVC8AQt9cdd/4Y8keOm5GJWqaA/2qs+qfwPRhXppxDWbnYpclBFZTXmS
	 btCBmx/eEaG8yZ8ZhebUdmobPB85GpF5UVm3lqYGgfu/df4NbPSurRpV1T3uBQUJOq
	 qo478Xzb2wOf8Sp78nhHr/2FxH0cUx3XQ72jwGbRNMnouv+T6RsBIQ5R8NEyp6Lmt1
	 rY2whlO0bXUIA==
Received: by pali.im (Postfix)
	id 7E55210C4; Mon,  6 Jul 2026 20:48:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 09/11] cifs: Create native Window socket file compatible also with WSL subsystem
Date: Mon,  6 Jul 2026 20:48:17 +0200
Message-Id: <20260706184819.22124-10-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260706184819.22124-1-pali@kernel.org>
References: <20260706184819.22124-1-pali@kernel.org>
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
index e2ea59a17c9c..50eeea127a42 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -384,7 +384,7 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 
 static int create_native_socket(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
-				const char *full_path)
+				const char *full_path, umode_t mode)
 {
 	struct reparse_data_buffer buf = {
 		.ReparseTag = cpu_to_le32(IO_REPARSE_TAG_AF_UNIX),
@@ -398,6 +398,10 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
 		.iov_base = &buf,
 		.iov_len = sizeof(buf),
 	};
+#ifdef CONFIG_CIFS_XATTR
+	const __le64 xattr_mode_val = cpu_to_le64(mode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+#endif
 	struct inode *new;
 	int rc = 0;
 
@@ -408,6 +412,28 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
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
@@ -717,7 +743,7 @@ int mknod_reparse(unsigned int xid, struct inode *inode,
 	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
 
 	if (S_ISSOCK(mode) && !ctx->nonativesocket && ctx->reparse_type != CIFS_REPARSE_TYPE_NONE)
-		return create_native_socket(xid, inode, dentry, tcon, full_path);
+		return create_native_socket(xid, inode, dentry, tcon, full_path, mode);
 
 	switch (ctx->reparse_type) {
 	case CIFS_REPARSE_TYPE_NFS:
-- 
2.20.1

