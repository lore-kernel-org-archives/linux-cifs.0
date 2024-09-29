Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEFE364BA;
	Sun, 29 Sep 2024 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727635864; cv=none; b=Bm5Kw7ASViOLiaOxYyB5YtsGXEjCpip0KEnRLcG6xkc0D/P918Ih2+L5H0vgerv9mxKcssQ7/pQzXzP/CknSfvZktdA6oUWcfK0xdyHHXjQ5ZJ8pZToeSxlWPq/0Kq+a/qvODusvPN1T4n+IQld/KjSBZzm81/Ag8InP12i8/kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727635864; c=relaxed/simple;
	bh=g6/gu9aNBfiUbdKhwIecVwFtjJMBa44gGtl/X23FNYw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E56fCYsSbFxLjYKLHo2M+pNpNfaXvvQ6BvcuGtySAiDFNcEKRxncNkF9GU3RGb4Ccg9OOM8SWvb1d1XHhkgSs4P+WK4gbJYd92TMSlcPSVgbcquOejzhyBtb5Vv5uRS0uMTpmOVp7d0sZo66wd/RmZ7qsjh70uEBFgzSVpO/WNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKC19SMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKC19SMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94434C4CEC5;
	Sun, 29 Sep 2024 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727635863;
	bh=g6/gu9aNBfiUbdKhwIecVwFtjJMBa44gGtl/X23FNYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKC19SMGxhC6HuauqpY6zqT8M92H9K5qIhi7hMFS0FEVJXxu31M4yoRlTRYbYulbR
	 JApQPL+g1os18ps8C1JOOkhKMlmaBTuFpPr++Tglz224FlfH9lgYm4nObkIPal+Pwe
	 bF7m4bCO0WO8HFzgFiaGm4rojXWctKc2CSDd8SrPh5wXQaah2yPtTIbPHPFiSJjCeU
	 hs6pv0gdDqcDuVqfd8eB/L61fj98/RFjvBQJp/L2JQkNymu72AA/dnG60LZuU5iwa+
	 m7zgyw5bfA2B/7xoFmrI9czbGNFV1PgmBN/nnRrGQ2/rmcvTRnyUbnUmqjVhCQeZiy
	 JA1DP+lG3jyQQ==
Received: by pali.im (Postfix)
	id 2BD2EB64; Sun, 29 Sep 2024 20:50:57 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] cifs: Improve creating native symlinks pointing to directory
Date: Sun, 29 Sep 2024 20:50:48 +0200
Message-Id: <20240929185053.10554-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240929185053.10554-1-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SMB protocol for native symlinks distinguish between symlink to directory
and symlink to file. These two symlink types cannot be exchanged, which
means that symlink of file type pointing to directory cannot be resolved at
all (and vice-versa).

Windows follows this rule for local filesystems (NTFS) and also for SMB.

Linux SMB client currenly creates all native symlinks of file type. Which
means that Windows (and some other SMB clients) cannot resolve symlinks
pointing to directory created by Linux SMB client.

As Linux system does not distinguish between directory and file symlinks,
its API does not provide enough information for Linux SMB client during
creating of native symlinks.

Add some heuristic into the Linux SMB client for choosing the correct
symlink type during symlink creation. Check if the symlink target location
ends with slash, or last path component is dot or dot dot, and check if the
target location on SMB share exists and is a directory. If at least one
condition is truth then create a new SMB symlink of directory type.
Otherwise create it as file type symlink.

This change improves interoperability with Windows systems. Windows systems
would be able to resolve more SMB symlinks created by Linux SMB client
which points to existing directory.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c   | 131 ++++++++++++++++++++++++++++++++++++--
 fs/smb/client/smb2inode.c |   3 +-
 fs/smb/client/smb2proto.h |   1 +
 3 files changed, 130 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 507e17244ed3..9390ab801696 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -24,13 +24,16 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 	struct inode *new;
 	struct kvec iov;
 	__le16 *path;
+	bool directory = false;
 	char *sym, sep = CIFS_DIR_SEP(cifs_sb);
 	u16 len, plen;
 	int rc = 0;
 
-	sym = kstrdup(symname, GFP_KERNEL);
+	len = strlen(symname)+1;
+	sym = kzalloc(len+1, GFP_KERNEL); /* +1 for possible directory slash */
 	if (!sym)
 		return -ENOMEM;
+	memcpy(sym, symname, len);
 
 	data = (struct cifs_open_info_data) {
 		.reparse_point = true,
@@ -45,6 +48,125 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 		goto out;
 	}
 
+	/*
+	 * SMB distinguish between symlink to directory and symlink to file.
+	 * They cannot be exchanged (symlink of file type which points to
+	 * directory cannot be resolved and vice-versa). First do some simple
+	 * check, if the original Linux symlink target ends with slash, or
+	 * last path component is dot or dot dot then it is for sure symlink
+	 * to the directory.
+	 */
+	if (!directory) {
+		const char *basename = kbasename(symname);
+		int basename_len = strlen(basename);
+		if (basename_len == 0 || /* symname ends with slash */
+		    (basename_len == 1 && basename[0] == '.') || /* last component is "." */
+		    (basename_len == 2 && basename[0] == '.' && basename[1] == '.')) /* last component is ".." */
+			directory = true;
+	}
+
+	/*
+	 * If it was not detected as directory yet and the symlink is relative
+	 * then try to resolve the path on the SMB server, check if the path
+	 * exists and determinate if it is a directory or not.
+	 */
+	if (!directory && symname[0] != '/') {
+		__u32 oplock;
+		struct tcon_link *tlink;
+		struct cifs_tcon *tcon;
+		struct cifs_fid fid;
+		struct cifs_open_parms oparms;
+		char *resolved_path;
+		char *path_sep;
+		int open_rc;
+		int full_path_len = strlen(full_path);
+		int symname_len = strlen(symname);
+
+		tlink = cifs_sb_tlink(cifs_sb);
+		if (IS_ERR(tlink)) {
+			rc = PTR_ERR(tlink);
+			goto out;
+		}
+
+		resolved_path = kzalloc(full_path_len + symname_len + 1, GFP_KERNEL);
+		if (!resolved_path) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		/*
+		 * Compose the resolved SMB symlink path from the SMB full path
+		 * and Linux target symlink path.
+		 */
+		memcpy(resolved_path, full_path, full_path_len+1);
+		path_sep = strrchr(resolved_path, sep);
+		if (path_sep)
+			path_sep++;
+		else
+			path_sep = resolved_path;
+		memcpy(path_sep, symname, symname_len+1);
+		if (sep == '\\')
+			convert_delimiter(path_sep, sep);
+
+		tcon = tlink_tcon(tlink);
+
+		oparms = (struct cifs_open_parms) {
+			.tcon = tcon,
+			.cifs_sb = cifs_sb,
+			.desired_access = FILE_READ_ATTRIBUTES,
+			.disposition = FILE_OPEN,
+			.path = resolved_path,
+			.fid = &fid,
+		};
+
+		/* Try to open as NOT_FILE */
+		oplock = 0;
+		oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
+		open_rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
+		if (open_rc == 0) {
+			/* Successful open means that the target path is definitely a directory. */
+			directory = true;
+			tcon->ses->server->ops->close(xid, tcon, &fid);
+		} else if (open_rc != -ENOTDIR) {
+			/* Try to open as NOT_DIR */
+			oplock = 0;
+			oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
+			open_rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
+			if (open_rc == 0) {
+				tcon->ses->server->ops->close(xid, tcon, &fid);
+			} else if (open_rc == -EISDIR) {
+				/* -EISDIR means that the target path is definitely a directory. */
+				directory = true;
+			} else {
+				cifs_dbg(FYI,
+					 "%s: cannot determinate if the symlink target path '%s' "
+					 "is directory or not, creating '%s' as file symlink\n",
+					 __func__, symname, full_path);
+			}
+		}
+
+		kfree(resolved_path);
+		cifs_put_tlink(tlink);
+	}
+
+	/*
+	 * For absolute symlinks it is not possible to determinate
+	 * if it should point to directory or file.
+	 */
+	if (!directory && symname[0] == '/')
+		cifs_dbg(FYI,
+			 "%s: cannot determinate if the symlink target path '%s' "
+			 "is directory or not, creating '%s' as file symlink\n",
+			 __func__, symname, full_path);
+
+	/* Ensure that directory symlink target in inode would have trailing slash */
+	len = strlen(data.symlink_target);
+	if (directory && data.symlink_target[len-1] != '/') {
+		/* symlink_target has already preallocated one byte more */
+		data.symlink_target[len] = '/';
+		data.symlink_target[len+1] = '\0';
+	}
+
 	plen = 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
 	len = sizeof(*buf) + plen * 2;
 	buf = kzalloc(len, GFP_KERNEL);
@@ -69,7 +191,8 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 	iov.iov_base = buf;
 	iov.iov_len = len;
 	new = smb2_create_reparse_inode(&data, inode->i_sb, xid,
-				     tcon, full_path, &iov, NULL);
+					tcon, full_path, directory,
+					&iov, NULL);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
 	else
@@ -137,7 +260,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 	};
 
 	new = smb2_create_reparse_inode(&data, inode->i_sb, xid,
-				     tcon, full_path, &iov, NULL);
+					tcon, full_path, false, &iov, NULL);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
 	else
@@ -283,7 +406,7 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	data.wsl.eas_len = len;
 
 	new = smb2_create_reparse_inode(&data, inode->i_sb,
-				     xid, tcon, full_path,
+					xid, tcon, full_path, false,
 				     &reparse_iov, &xattr_iov);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 0fc73035d6dc..fffb9df4faeb 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1198,6 +1198,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 				     const unsigned int xid,
 				     struct cifs_tcon *tcon,
 				     const char *full_path,
+				     bool directory,
 				     struct kvec *reparse_iov,
 				     struct kvec *xattr_iov)
 {
@@ -1217,7 +1218,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 			     FILE_READ_ATTRIBUTES |
 			     FILE_WRITE_ATTRIBUTES,
 			     FILE_CREATE,
-			     CREATE_NOT_DIR | OPEN_REPARSE_POINT,
+			     (directory ? CREATE_NOT_FILE : CREATE_NOT_DIR) | OPEN_REPARSE_POINT,
 			     ACL_NO_MODE);
 	if (xattr_iov)
 		oparms.ea_cctx = xattr_iov;
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 4ac30d29d5a1..fd092f2bb8c5 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -61,6 +61,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 				     const unsigned int xid,
 				     struct cifs_tcon *tcon,
 				     const char *full_path,
+				     bool directory,
 				     struct kvec *reparse_iov,
 				     struct kvec *xattr_iov);
 int smb2_query_reparse_point(const unsigned int xid,
-- 
2.20.1

