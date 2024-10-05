Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F7015AF6;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728137029; cv=none; b=EjRfbCWeloR9oQVz2AEXo4CWRN/rYAOsXDPy027mY31t9KyWNjjarLunNm1fkH3fGwUEcaR2nPzuRGYdBT6f+Kg7SAYT/VZSt2yFjMl42sPAvd3oQx1YhRx01w/jCJAlD1ChrhghKnXCmPIjHBPwYzguRnPkUN2TnThs0obE+0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728137029; c=relaxed/simple;
	bh=WT1S5UxYOI1A0Z9HVnVrjqZnEWhBI0mrjPysOzPZpUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JY5EbnqLUQcnGAFOV0o2q01E4bZ7S28nOJGqitlvqQaS9/ZYR7GezkYDLzphlNvcB0DpR5pn0kEH2ao+PN+U7pThNwMQ1oXBmRkSVkFwF0uuDS2jXOVpvAm4vRZVZ3o2hDcYyC4vb+V3Swz3Woub+MTjBPBRd17IdzXu0YUcKuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m2b4wmNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m2b4wmNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C43C4CEC7;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728137029;
	bh=WT1S5UxYOI1A0Z9HVnVrjqZnEWhBI0mrjPysOzPZpUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2b4wmNNc+olbJZnHbnqcIuHg1vb75U8kEdRbQ3Gd1dhY3CfmrU6fDQAQ9Hh7S4xu
	 3QCGJqMdkrVmNLU/mdSJ/x6IRwaXJ7seHEZ7qYFes9yH8TTV4qvDpG+lfZMG5vUi20
	 zltgLhOF+Tsc/G4OQntth2ANoYlKcdwirXA/Xj6Btvee/Q0ahF1FbHLqyyaZYwTgyB
	 Zj3fCyXXipYF5q7KaOfVoiZKLdUUgIyI+MQ4AJpDFg8gXb1xUJH1HAFaiILwc7jxeY
	 iDCPDmiBU70AmtIU1wo0Mhr4sZMFkyUgrKLLBR4iUEQ7dEZ4wu8b/g+39C0J08bpns
	 d38PMtVT2VIfw==
Received: by pali.im (Postfix)
	id 9E89B9DA; Sat,  5 Oct 2024 16:03:42 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] cifs: Improve creating native symlinks pointing to directory
Date: Sat,  5 Oct 2024 16:02:55 +0200
Message-Id: <20241005140300.19416-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241005140300.19416-1-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
 <20241005140300.19416-1-pali@kernel.org>
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
ends with slash, or last path component is dot or dot-dot, and check if the
target location on SMB share exists and is a directory. If at least one
condition is truth then create a new SMB symlink of directory type.
Otherwise create it as file type symlink.

This change improves interoperability with Windows systems. Windows systems
would be able to resolve more SMB symlinks created by Linux SMB client
which points to existing directory.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c   | 164 +++++++++++++++++++++++++++++++++++++-
 fs/smb/client/smb2inode.c |   3 +-
 fs/smb/client/smb2proto.h |   1 +
 3 files changed, 164 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 35e8f2e18530..8403e1b94059 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -14,6 +14,12 @@
 #include "fs_context.h"
 #include "reparse.h"
 
+static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
+					   const unsigned int xid,
+					   const char *full_path,
+					   const char *symname,
+					   bool *directory);
+
 int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
 				const char *full_path, const char *symname)
@@ -24,6 +30,7 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 	struct inode *new;
 	struct kvec iov;
 	__le16 *path;
+	bool directory;
 	char *sym, sep = CIFS_DIR_SEP(cifs_sb);
 	u16 len, plen;
 	int rc = 0;
@@ -45,6 +52,18 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 		goto out;
 	}
 
+	/*
+	 * SMB distinguish between symlink to directory and symlink to file.
+	 * They cannot be exchanged (symlink of file type which points to
+	 * directory cannot be resolved and vice-versa). Try to detect if
+	 * the symlink target could be a directory or not. When detection
+	 * fails then treat symlink as a file (non-directory) symlink.
+	 */
+	directory = false;
+	rc = detect_directory_symlink_target(cifs_sb, xid, full_path, symname, &directory);
+	if (rc < 0)
+		goto out;
+
 	plen = 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
 	len = sizeof(*buf) + plen * 2;
 	buf = kzalloc(len, GFP_KERNEL);
@@ -69,7 +88,8 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 	iov.iov_base = buf;
 	iov.iov_len = len;
 	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
-				     tcon, full_path, &iov, NULL);
+				     tcon, full_path, directory,
+				     &iov, NULL);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
 	else
@@ -81,6 +101,144 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 	return rc;
 }
 
+static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
+					   const unsigned int xid,
+					   const char *full_path,
+					   const char *symname,
+					   bool *directory)
+{
+	char sep = CIFS_DIR_SEP(cifs_sb);
+	struct cifs_open_parms oparms;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	const char *basename;
+	struct cifs_fid fid;
+	char *resolved_path;
+	int full_path_len;
+	int basename_len;
+	int symname_len;
+	char *path_sep;
+	__u32 oplock;
+	int open_rc;
+
+	/*
+	 * First do some simple check. If the original Linux symlink target ends
+	 * with slash, or last path component is dot or dot-dot then it is for
+	 * sure symlink to the directory.
+	 */
+	basename = kbasename(symname);
+	basename_len = strlen(basename);
+	if (basename_len == 0 || /* symname ends with slash */
+	    (basename_len == 1 && basename[0] == '.') || /* last component is "." */
+	    (basename_len == 2 && basename[0] == '.' && basename[1] == '.')) { /* or ".." */
+		*directory = true;
+		return 0;
+	}
+
+	/*
+	 * For absolute symlinks it is not possible to determinate
+	 * if it should point to directory or file.
+	 */
+	if (symname[0] == '/') {
+		cifs_dbg(FYI,
+			 "%s: cannot determinate if the symlink target path '%s' "
+			 "is directory or not, creating '%s' as file symlink\n",
+			 __func__, symname, full_path);
+		return 0;
+	}
+
+	/*
+	 * If it was not detected as directory yet and the symlink is relative
+	 * then try to resolve the path on the SMB server, check if the path
+	 * exists and determinate if it is a directory or not.
+	 */
+
+	full_path_len = strlen(full_path);
+	symname_len = strlen(symname);
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+
+	resolved_path = kzalloc(full_path_len + symname_len + 1, GFP_KERNEL);
+	if (!resolved_path) {
+		cifs_put_tlink(tlink);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Compose the resolved SMB symlink path from the SMB full path
+	 * and Linux target symlink path.
+	 */
+	memcpy(resolved_path, full_path, full_path_len+1);
+	path_sep = strrchr(resolved_path, sep);
+	if (path_sep)
+		path_sep++;
+	else
+		path_sep = resolved_path;
+	memcpy(path_sep, symname, symname_len+1);
+	if (sep == '\\')
+		convert_delimiter(path_sep, sep);
+
+	tcon = tlink_tcon(tlink);
+	oparms = CIFS_OPARMS(cifs_sb, tcon, resolved_path,
+			     FILE_READ_ATTRIBUTES, FILE_OPEN, 0, ACL_NO_MODE);
+	oparms.fid = &fid;
+
+	/* Try to open as a directory (NOT_FILE) */
+	oplock = 0;
+	oparms.create_options = cifs_create_options(cifs_sb,
+						    CREATE_NOT_FILE | OPEN_REPARSE_POINT);
+	open_rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
+	if (open_rc == 0) {
+		/* Successful open means that the target path is definitely a directory. */
+		*directory = true;
+		tcon->ses->server->ops->close(xid, tcon, &fid);
+	} else if (open_rc == -ENOTDIR) {
+		/* -ENOTDIR means that the target path is definitely a file. */
+		*directory = false;
+	} else if (open_rc == -ENOENT) {
+		/* -ENOENT means that the target path does not exist. */
+		cifs_dbg(FYI,
+			 "%s: symlink target path '%s' does not exist, "
+			 "creating '%s' as file symlink\n",
+			 __func__, symname, full_path);
+	} else {
+		/* Try to open as a file (NOT_DIR) */
+		oplock = 0;
+		oparms.create_options = cifs_create_options(cifs_sb,
+							    CREATE_NOT_DIR | OPEN_REPARSE_POINT);
+		open_rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
+		if (open_rc == 0) {
+			/* Successful open means that the target path is definitely a file. */
+			*directory = false;
+			tcon->ses->server->ops->close(xid, tcon, &fid);
+		} else if (open_rc == -EISDIR) {
+			/* -EISDIR means that the target path is definitely a directory. */
+			*directory = true;
+		} else {
+			/*
+			 * This code branch is called when we do not have a permission to
+			 * open the resolved_path or some other client/process denied
+			 * opening the resolved_path.
+			 *
+			 * TODO: Try to use ops->query_dir_first on the parent directory
+			 * of resolved_path, search for basename of resolved_path and
+			 * check if the ATTR_DIRECTORY is set in fi.Attributes. In some
+			 * case this could work also when opening of the path is denied.
+			 */
+			cifs_dbg(FYI,
+				 "%s: cannot determinate if the symlink target path '%s' "
+				 "is directory or not, creating '%s' as file symlink\n",
+				 __func__, symname, full_path);
+		}
+	}
+
+	kfree(resolved_path);
+	cifs_put_tlink(tlink);
+	return 0;
+}
+
 static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 			       mode_t mode, dev_t dev,
 			       struct kvec *iov)
@@ -137,7 +295,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 	};
 
 	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
-				     tcon, full_path, &iov, NULL);
+				     tcon, full_path, false, &iov, NULL);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
 	else
@@ -283,7 +441,7 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	data.wsl.eas_len = len;
 
 	new = smb2_get_reparse_inode(&data, inode->i_sb,
-				     xid, tcon, full_path,
+				     xid, tcon, full_path, false,
 				     &reparse_iov, &xattr_iov);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index a6dab60e2c01..cdb0e028e73c 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1198,6 +1198,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 				     const unsigned int xid,
 				     struct cifs_tcon *tcon,
 				     const char *full_path,
+				     bool directory,
 				     struct kvec *reparse_iov,
 				     struct kvec *xattr_iov)
 {
@@ -1217,7 +1218,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 			     FILE_READ_ATTRIBUTES |
 			     FILE_WRITE_ATTRIBUTES,
 			     FILE_CREATE,
-			     CREATE_NOT_DIR | OPEN_REPARSE_POINT,
+			     (directory ? CREATE_NOT_FILE : CREATE_NOT_DIR) | OPEN_REPARSE_POINT,
 			     ACL_NO_MODE);
 	if (xattr_iov)
 		oparms.ea_cctx = xattr_iov;
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index b208232b12a2..5e0855fefcfe 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -61,6 +61,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 				     const unsigned int xid,
 				     struct cifs_tcon *tcon,
 				     const char *full_path,
+				     bool directory,
 				     struct kvec *reparse_iov,
 				     struct kvec *xattr_iov);
 int smb2_query_reparse_point(const unsigned int xid,
-- 
2.20.1

