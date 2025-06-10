Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E89283CBF;
	Tue, 10 Jun 2025 21:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749591271; cv=none; b=j6ayOiPWJ3Ll94pxF/S8BwBPEx4BJYRjgxOk+Q4ErmmxguCmYfMprVm/JKA2giN/ROYzVvpsFH/qc42NRechwWOSLcSBuWIbU5j7Gkn9uB+AvcjsbsB0VrXcF2pLpHNOfeDv+w/gWiZ67HHHDhje5KJiFuSCg3OME+b2STsStBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749591271; c=relaxed/simple;
	bh=HTSey208KOXDuggjShSGss4FhGVxRQP7RpEyEn19KcA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=eJ5NtKjIGIONs2CJYoKMC1rV96W0nh40Mn6MO0wDMSccZFM/6DWQcSkY3LYvWw7ijl58/78nAKHrtAFOU27gK1aevq/m+rZ3Show/meyIGMQRBbkdEjVMW1qeXVRxoSsUs85+Yg2GDVtKcBCG8O+i5niv9Uc7YISyQPNDqxipDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AdE86Xvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AdE86Xvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79977C4CEED;
	Tue, 10 Jun 2025 21:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749591270;
	bh=HTSey208KOXDuggjShSGss4FhGVxRQP7RpEyEn19KcA=;
	h=From:To:Cc:Subject:Date:From;
	b=AdE86XvruZxPOPFqfFy3rXDOK2Pp1F+Utm/4dNgQXR9JS/rRa9HAngJvptNTos4aQ
	 TBlIDw6JTbjyR7cV6lk0ZctwJkBv0ZHn6Q8BrL4oZIe/+2Nxj5e/xZgQJQI24oXnI3
	 GzSQX5JYUBN4DgEbOnx8HFsykFGrBzeJHEQBnyji/u3XzV/KczCHmGfBOuvaeH2gxH
	 TTl0C8U0k5dt3URrQ7I3zgVj6yS7FQgR5zP157nE3Wuk5s5TgYWeSbQaUzXMh+e0yd
	 ay1avWrGhv+lK+zJBv8YDRrlcMIO1vb7Cq9pIbN6mnaIQD8EiFp3sknY52H7UnXJwN
	 eHiens8vjsuUw==
Received: by pali.im (Postfix)
	id 602DC4F1; Tue, 10 Jun 2025 23:34:28 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Remy Monsen <monsen@monsen.cc>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix lstat() and AT_SYMLINK_NOFOLLOW to work on broken symlink nodes
Date: Tue, 10 Jun 2025 23:34:04 +0200
Message-Id: <20250610213404.16288-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently Linux SMB client returns EIO for lstat() and AT_SYMLINK_NOFOLLOW
calls on symlink node when the symlink target location is broken or cannot
be read or parsed.

Fix this problem by relaxing the errors from various locations which parses
information about symlink file node (UNIX SMB1, native SMB2+, NFS-style,
WSL-style) and let readlink() syscall to return EIO when the symlink target
location is not available.

Note that SFU symlinks and MF symlinks are not affected by this issue,
their parser has already relaxed code.

This change fixes the 'ls -l -a' call on directory which has symlink nodes
with broken target locations.

Reported-by: Remy Monsen <monsen@monsen.cc>
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsfs.c   |  3 +-
 fs/smb/client/inode.c    | 24 ++++++++++++++++
 fs/smb/client/reparse.c  | 61 ++++++++++++++++++++++++++++++++--------
 fs/smb/client/smb2file.c | 10 ++++---
 4 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a08c42363ffc..f4b923f73dca 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1180,7 +1180,8 @@ const char *cifs_get_link(struct dentry *dentry, struct inode *inode,
 		strscpy(target_path, CIFS_I(inode)->symlink_target, PATH_MAX);
 	} else {
 		kfree(target_path);
-		target_path = ERR_PTR(-EOPNOTSUPP);
+		/* If symlink_target is not filled for symlink then it is an IO error. */
+		target_path = ERR_PTR(-EIO);
 	}
 	spin_unlock(&inode->i_lock);
 
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b1c6e3986278..762cd194946a 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -480,6 +480,12 @@ static int cifs_get_unix_fattr(const unsigned char *full_path,
 						cifs_sb, full_path,
 						&fattr->cf_symlink_target);
 		cifs_dbg(FYI, "%s: query_symlink: %d\n", __func__, rc);
+		/*
+		 * Convert -EIO to 0. This let lstat() success and
+		 * empty data->cf_symlink_target triggers readlink() to fail with -EIO.
+		 */
+		if (rc == -EIO)
+			rc = 0;
 	}
 	return rc;
 }
@@ -1133,6 +1139,12 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 			rc = server->ops->query_symlink(xid, tcon,
 							cifs_sb, full_path,
 							&data->symlink_target);
+			/*
+			 * Convert -EIO to 0. This let lstat() success and
+			 * empty data->symlink_target triggers readlink() to fail with -EIO.
+			 */
+			if (rc == -EIO)
+				rc = 0;
 		}
 		if (rc == -EOPNOTSUPP)
 			data->reparse.tag = IO_REPARSE_TAG_INTERNAL;
@@ -1182,6 +1194,18 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 			 */
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
+		} else if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK) {
+			/*
+			 * data->reparse.tag can be set to IO_REPARSE_TAG_SYMLINK
+			 * by STATUS_STOPPED_ON_SYMLINK error code. In this case
+			 * we do not have a real reparse point iov buffer so
+			 * data->reparse.buf and data->reparse.io.iov.iov_base
+			 * are not set. And in the case symlink target location
+			 * in the struct smb2_symlink_err_rsp is parsable then we
+			 * even do not have data->symlink_target. So set rc to 0
+			 * which let lstat() success and readlink() to fail.
+			 */
+			rc = 0;
 		}
 
 		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index d1d25f5f72ca..c70affb7b7f7 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -739,7 +739,11 @@ static int parse_reparse_nfs(struct reparse_nfs_data_buffer *buf,
 	case NFS_SPECFILE_LNK:
 		if (len == 0 || (len % 2)) {
 			cifs_dbg(VFS, "srv returned malformed nfs symlink buffer\n");
-			return -EIO;
+			/*
+			 * This is an -EIO error. Convert it to 0. This let lstat() success and
+			 * empty data->symlink_target triggers readlink() to fail with -EIO.
+			 */
+			return 0;
 		}
 		/*
 		 * Check that buffer does not contain UTF-16 null codepoint
@@ -747,7 +751,11 @@ static int parse_reparse_nfs(struct reparse_nfs_data_buffer *buf,
 		 */
 		if (UniStrnlen((wchar_t *)buf->DataBuffer, len/2) != len/2) {
 			cifs_dbg(VFS, "srv returned null byte in nfs symlink target location\n");
-			return -EIO;
+			/*
+			 * This is an -EIO error. Convert it to 0. This let lstat() success and
+			 * empty data->symlink_target triggers readlink() to fail with -EIO.
+			 */
+			return 0;
 		}
 		data->symlink_target = cifs_strndup_from_utf16(buf->DataBuffer,
 							       len, true,
@@ -986,6 +994,14 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 	if (rc != 0)
 		kfree(linux_target);
 	kfree(smb_target);
+
+	/*
+	* Convert -EIO to 0. This let lstat() success and
+	* empty *target triggers readlink() to fail with -EIO.
+	*/
+	if (rc == -EIO)
+		rc = 0;
+
 	return rc;
 }
 
@@ -1004,7 +1020,11 @@ static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
 	len = le16_to_cpu(sym->SubstituteNameLength);
 	if (offs + 20 > plen || offs + len + 20 > plen) {
 		cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
-		return -EIO;
+		/*
+		 * This is an -EIO error. Convert it to 0. This let lstat() success and
+		 * empty data->symlink_target triggers readlink() to fail with -EIO.
+		 */
+		return 0;
 	}
 
 	return smb2_parse_native_symlink(&data->symlink_target,
@@ -1024,16 +1044,19 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 	int symname_utf8_len;
 	__le16 *symname_utf16;
 	int symname_utf16_len;
+	int rc = 0;
 
 	if (len <= data_offset) {
 		cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\n");
-		return -EIO;
+		rc = -EIO;
+		goto out;
 	}
 
 	/* MS-FSCC 2.1.2.7 defines layout of the Target field only for Version 2. */
 	if (le32_to_cpu(buf->Version) != 2) {
 		cifs_dbg(VFS, "srv returned unsupported wsl symlink version %u\n", le32_to_cpu(buf->Version));
-		return -EIO;
+		rc = -EIO;
+		goto out;
 	}
 
 	/* Target for Version 2 is in UTF-8 but without trailing null-term byte */
@@ -1044,17 +1067,21 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 	 */
 	if (strnlen(buf->Target, symname_utf8_len) != symname_utf8_len) {
 		cifs_dbg(VFS, "srv returned null byte in wsl symlink target location\n");
-		return -EIO;
+		rc = -EIO;
+		goto out;
 	}
 	symname_utf16 = kzalloc(symname_utf8_len * 2, GFP_KERNEL);
-	if (!symname_utf16)
-		return -ENOMEM;
+	if (!symname_utf16) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	symname_utf16_len = utf8s_to_utf16s(buf->Target, symname_utf8_len,
 					    UTF16_LITTLE_ENDIAN,
 					    (wchar_t *) symname_utf16, symname_utf8_len * 2);
 	if (symname_utf16_len < 0) {
 		kfree(symname_utf16);
-		return symname_utf16_len;
+		rc = symname_utf16_len;
+		goto out;
 	}
 	symname_utf16_len *= 2; /* utf8s_to_utf16s() returns number of u16 items, not byte length */
 
@@ -1062,10 +1089,20 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 						       symname_utf16_len, true,
 						       cifs_sb->local_nls);
 	kfree(symname_utf16);
-	if (!data->symlink_target)
-		return -ENOMEM;
+	if (!data->symlink_target) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
-	return 0;
+out:
+	/*
+	* Convert -EIO to 0. This let lstat() success and
+	* empty data->symlink_target triggers readlink() to fail with -EIO.
+	*/
+	if (rc == -EIO)
+		rc = 0;
+
+	return rc;
 }
 
 int parse_reparse_point(struct reparse_data_buffer *buf,
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index a7f629238830..9ac359f7be43 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -76,11 +76,11 @@ int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_i
 		return 0;
 
 	if (!*target)
-		return -EIO;
+		return 0;
 
 	len = strlen(*target);
 	if (!len)
-		return -EIO;
+		return 0;
 
 	/*
 	 * If this is directory symlink and it does not have trailing slash then
@@ -103,8 +103,10 @@ int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_i
 	 * cannot contain slash character. File name with slash is invalid on
 	 * both Windows and Linux systems. So return an error for such symlink.
 	 */
-	if (!directory && (*target)[len-1] == '/')
-		return -EIO;
+	if (!directory && (*target)[len-1] == '/') {
+		kfree(*target);
+		*target = NULL;
+	}
 
 	return 0;
 }
-- 
2.20.1

