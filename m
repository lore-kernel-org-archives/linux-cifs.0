Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72EC1F19A;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728137030; cv=none; b=Vc4NI4ijJZSS3/6+gDLyNvpM+VtTJ1VU4SQQVXjtV/DKYMoZ06i+ZFqLJ4qu95+imUehWAdADSZIaYk21/mZyaB8pjyTuNcxLmGBoEegbik0Rffutot1H+B2OVqbaI+vttGTuHMn3uj/qh8Nl1R1Xb6PJT9bmxzcDue55DwWLaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728137030; c=relaxed/simple;
	bh=S6HYcLfijvOqTM13PxgG/z9ct4kBTgHVZpvHru4R4Qw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hfCk50k2evVBup0jbI/7EhFtPe/++CnP2geJHXlw1Uuj8mtmVWeW3m2kawKhIq874F66QFemr84DJ+X6GndRG+SxkFuGb6nr46hMzBeY++CTNDTd+E1y4yFoIJNczZLQsMExd5/ejuxnSBj72iyhRE/QWHmtSv5kr9ckOqiH3I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmCz/r+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmCz/r+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFBBC4CED0;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728137029;
	bh=S6HYcLfijvOqTM13PxgG/z9ct4kBTgHVZpvHru4R4Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmCz/r+LHD4DJLkdLAgpI68pRqkxjF6mHXgwsNE8J7WS3dZIYp3Cd8ME/uYsL34bK
	 LThP/hJT9b5v8WVw/7xyo6pVfre9xn0b7002xxvM2pMRLymiXjFKeTUluQL59H1ArE
	 fYv21ZCOeDMTclwE6mP9ADlfeZgQ5s+VcSV3gXhbcawp6ZMW91cY8ZC63C6LDb1cev
	 ytbRXTHG50cnV8UvcOhfYtivcmqGALOW+EyzCQcnNIHVUL9ueS3R4vOrlAKbxfZn7x
	 NPZ8UuuZUIpwvnsbM/O2zIrhbYNXykkVasUYQZ4XWEvKR7fAsU6LgZ2xd8aDrMOreY
	 kDzJBh59VxG0Q==
Received: by pali.im (Postfix)
	id 0AC03A4E; Sat,  5 Oct 2024 16:03:43 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] cifs: Fix parsing native symlinks relative to the export
Date: Sat,  5 Oct 2024 16:02:57 +0200
Message-Id: <20241005140300.19416-4-pali@kernel.org>
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

SMB symlink which has SYMLINK_FLAG_RELATIVE set is relative (as opposite of
the absolute) and it can be relative either to the current directory (where
is the symlink stored) or relative to the top level export path. To what it
is relative depends on the first character of the symlink target path.

If the first character is path separator then symlink is relative to the
export, otherwise to the current directory. Linux (and generally POSIX
systems) supports only symlink paths relative to the current directory
where is symlink stored.

Currently if Linux SMB client reads relative SMB symlink with first
character as path separator (slash), it let as is. Which means that Linux
interpret it as absolute symlink pointing from the root (/). But this
location is different than the top level directory of SMB export (unless
SMB export was mounted to the root) and thefore SMB symlinks relative to
the export are interpreted wrongly by Linux SMB client.

Fix this problem. As Linux does not have equivalent of the path relative to
the top of the mount point, convert such symlink target path relative to
the current directory. Do this by prepending "../" pattern N times before
the SMB target path, where N is the number of path separators found in SMB
symlink path.

So for example, if SMB share is mounted to Linux path /mnt/share/, symlink
is stored in file /mnt/share/test/folder1/symlink (so SMB symlink path is
test\folder1\symlink) and SMB symlink target points to \test\folder2\file,
then convert symlink target path to Linux path ../../test/folder2/file.

Deduplicate code for parsing SMB symlinks in native form from functions
smb2_parse_symlink_response() and parse_reparse_native_symlink() into new
function smb2_parse_native_symlink() and pass into this new function a new
full_path parameter from callers, which specify SMB full path where is
symlink stored.

This change fixes resolving of the native Windows symlinks relative to the
top level directory of the SMB share.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/cifsproto.h |  1 +
 fs/smb/client/inode.c     |  1 +
 fs/smb/client/reparse.c   | 90 +++++++++++++++++++++++++++++++++------
 fs/smb/client/reparse.h   |  4 +-
 fs/smb/client/smb1ops.c   |  3 +-
 fs/smb/client/smb2file.c  | 21 +++++----
 fs/smb/client/smb2inode.c |  6 ++-
 fs/smb/client/smb2proto.h |  9 +++-
 9 files changed, 108 insertions(+), 28 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 9eae8649f90c..260b553283ef 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -589,6 +589,7 @@ struct smb_version_operations {
 	/* Check for STATUS_NETWORK_NAME_DELETED */
 	bool (*is_network_name_deleted)(char *buf, struct TCP_Server_Info *srv);
 	int (*parse_reparse_point)(struct cifs_sb_info *cifs_sb,
+				   const char *full_path,
 				   struct kvec *rsp_iov,
 				   struct cifs_open_info_data *data);
 	int (*create_reparse_symlink)(const unsigned int xid,
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 791bddac0396..44555a0e4df6 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -675,6 +675,7 @@ char *extract_hostname(const char *unc);
 char *extract_sharename(const char *unc);
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
+			const char *full_path,
 			bool unicode, struct cifs_open_info_data *data);
 int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 			 struct dentry *dentry, struct cifs_tcon *tcon,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0c23634438e5..0fe54b2d2561 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1107,6 +1107,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 			rc = 0;
 		} else if (iov && server->ops->parse_reparse_point) {
 			rc = server->ops->parse_reparse_point(cifs_sb,
+							      full_path,
 							      iov, data);
 		}
 		break;
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 8403e1b94059..0d1cea64ab6e 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -532,9 +532,76 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 	return 0;
 }
 
+int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
+			      bool unicode, bool relative,
+			      const char *full_path,
+			      struct cifs_sb_info *cifs_sb)
+{
+	char sep = CIFS_DIR_SEP(cifs_sb);
+	char *linux_target = NULL;
+	char *smb_target = NULL;
+	int levels;
+	int rc;
+	int i;
+
+	smb_target = cifs_strndup_from_utf16(buf, len, unicode, cifs_sb->local_nls);
+	if (!smb_target) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (smb_target[0] == sep && relative) {
+		/*
+		 * This is a relative SMB symlink from the top of the share,
+		 * which is the top level directory of the Linux mount point.
+		 * Linux does not support such relative symlinks, so convert
+		 * it to the relative symlink from the current directory.
+		 * full_path is the SMB path to the symlink (from which is
+		 * extracted current directory) and smb_target is the SMB path
+		 * where symlink points, therefore full_path must always be on
+		 * the SMB share.
+		 */
+		int smb_target_len = strlen(smb_target)+1;
+		levels = 0;
+		for (i = 1; full_path[i]; i++) { /* i=1 to skip leading sep */
+			if (full_path[i] == sep)
+				levels++;
+		}
+		linux_target = kmalloc(levels*3 + smb_target_len, GFP_KERNEL);
+		if (!linux_target) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		for (i = 0; i < levels; i++) {
+			linux_target[i*3 + 0] = '.';
+			linux_target[i*3 + 1] = '.';
+			linux_target[i*3 + 2] = sep;
+		}
+		memcpy(linux_target + levels*3, smb_target+1, smb_target_len); /* +1 to skip leading sep */
+	} else {
+		linux_target = smb_target;
+		smb_target = NULL;
+	}
+
+	if (sep == '\\')
+		convert_delimiter(linux_target, '/');
+
+	rc = 0;
+	*target = linux_target;
+
+	cifs_dbg(FYI, "%s: symlink target: %s\n", __func__, *target);
+
+out:
+	if (rc != 0)
+		kfree(linux_target);
+	kfree(smb_target);
+	return rc;
+}
+
 static int parse_reparse_symlink(struct reparse_symlink_data_buffer *sym,
 				 u32 plen, bool unicode,
 				 struct cifs_sb_info *cifs_sb,
+				 const char *full_path,
 				 struct cifs_open_info_data *data)
 {
 	unsigned int len;
@@ -549,20 +616,18 @@ static int parse_reparse_symlink(struct reparse_symlink_data_buffer *sym,
 		return -EIO;
 	}
 
-	data->symlink_target = cifs_strndup_from_utf16(sym->PathBuffer + offs,
-						       len, unicode,
-						       cifs_sb->local_nls);
-	if (!data->symlink_target)
-		return -ENOMEM;
-
-	convert_delimiter(data->symlink_target, '/');
-	cifs_dbg(FYI, "%s: target path: %s\n", __func__, data->symlink_target);
-
-	return 0;
+	return smb2_parse_native_symlink(&data->symlink_target,
+					 sym->PathBuffer + offs,
+					 len,
+					 unicode,
+					 le32_to_cpu(sym->Flags) & SYMLINK_FLAG_RELATIVE,
+					 full_path,
+					 cifs_sb);
 }
 
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
+			const char *full_path,
 			bool unicode, struct cifs_open_info_data *data)
 {
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
@@ -577,7 +642,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_SYMLINK:
 		return parse_reparse_symlink(
 			(struct reparse_symlink_data_buffer *)buf,
-			plen, unicode, cifs_sb, data);
+			plen, unicode, cifs_sb, full_path, data);
 	case IO_REPARSE_TAG_LX_SYMLINK:
 	case IO_REPARSE_TAG_AF_UNIX:
 	case IO_REPARSE_TAG_LX_FIFO:
@@ -593,6 +658,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 }
 
 int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
+			     const char *full_path,
 			     struct kvec *rsp_iov,
 			     struct cifs_open_info_data *data)
 {
@@ -602,7 +668,7 @@ int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
 
 	buf = (struct reparse_data_buffer *)((u8 *)io +
 					     le32_to_cpu(io->OutputOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, true, data);
+	return parse_reparse_point(buf, plen, cifs_sb, full_path, true, data);
 }
 
 static void wsl_to_fattr(struct cifs_open_info_data *data,
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 5be54878265e..eb6854e65e08 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -128,7 +128,9 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev);
-int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb, struct kvec *rsp_iov,
+int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
+			     const char *full_path,
+			     struct kvec *rsp_iov,
 			     struct cifs_open_info_data *data);
 
 #endif /* _CIFS_REPARSE_H */
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index e03c91a49650..fed32db32a46 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -994,6 +994,7 @@ static int cifs_query_symlink(const unsigned int xid,
 }
 
 static int cifs_parse_reparse_point(struct cifs_sb_info *cifs_sb,
+				    const char *full_path,
 				    struct kvec *rsp_iov,
 				    struct cifs_open_info_data *data)
 {
@@ -1004,7 +1005,7 @@ static int cifs_parse_reparse_point(struct cifs_sb_info *cifs_sb,
 
 	buf = (struct reparse_data_buffer *)((__u8 *)&io->hdr.Protocol +
 					     le32_to_cpu(io->DataOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, unicode, data);
+	return parse_reparse_point(buf, plen, cifs_sb, full_path, unicode, data);
 }
 
 static bool
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index c23478ab1cf8..dc52995f5591 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -63,12 +63,12 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 	return sym;
 }
 
-int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec *iov, char **path)
+int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec *iov,
+				const char *full_path, char **path)
 {
 	struct smb2_symlink_err_rsp *sym;
 	unsigned int sub_offs, sub_len;
 	unsigned int print_offs, print_len;
-	char *s;
 
 	if (!cifs_sb || !iov || !iov->iov_base || !iov->iov_len || !path)
 		return -EINVAL;
@@ -86,15 +86,13 @@ int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec
 	    iov->iov_len < SMB2_SYMLINK_STRUCT_SIZE + print_offs + print_len)
 		return -EINVAL;
 
-	s = cifs_strndup_from_utf16((char *)sym->PathBuffer + sub_offs, sub_len, true,
-				    cifs_sb->local_nls);
-	if (!s)
-		return -ENOMEM;
-	convert_delimiter(s, '/');
-	cifs_dbg(FYI, "%s: symlink target: %s\n", __func__, s);
-
-	*path = s;
-	return 0;
+	return smb2_parse_native_symlink(path,
+					 (char *)sym->PathBuffer + sub_offs,
+					 sub_len,
+					 true,
+					 le32_to_cpu(sym->Flags) & SYMLINK_FLAG_RELATIVE,
+					 full_path,
+					 cifs_sb);
 }
 
 int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32 *oplock, void *buf)
@@ -126,6 +124,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 			goto out;
 		if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
+							 oparms->path,
 							 &data->symlink_target);
 			if (!rc) {
 				memset(smb2_data, 0, sizeof(*smb2_data));
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index cdb0e028e73c..9a28a30ec1a3 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -828,6 +828,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int parse_create_response(struct cifs_open_info_data *data,
 				 struct cifs_sb_info *cifs_sb,
+				 const char *full_path,
 				 const struct kvec *iov)
 {
 	struct smb2_create_rsp *rsp = iov->iov_base;
@@ -841,6 +842,7 @@ static int parse_create_response(struct cifs_open_info_data *data,
 		break;
 	case STATUS_STOPPED_ON_SYMLINK:
 		rc = smb2_parse_symlink_response(cifs_sb, iov,
+						 full_path,
 						 &data->symlink_target);
 		if (rc)
 			return rc;
@@ -930,14 +932,14 @@ int smb2_query_path_info(const unsigned int xid,
 
 	switch (rc) {
 	case 0:
-		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
+		rc = parse_create_response(data, cifs_sb, full_path, &out_iov[0]);
 		break;
 	case -EOPNOTSUPP:
 		/*
 		 * BB TODO: When support for special files added to Samba
 		 * re-verify this path.
 		 */
-		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
+		rc = parse_create_response(data, cifs_sb, full_path, &out_iov[0]);
 		if (rc || !data->reparse_point)
 			goto out;
 
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 5e0855fefcfe..aa01ae234732 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -113,7 +113,14 @@ extern int smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_sb_info *cifs_sb,
 			  const unsigned char *path, char *pbuf,
 			  unsigned int *pbytes_read);
-int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec *iov, char **path);
+int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
+			      bool unicode, bool relative,
+			      const char *full_path,
+			      struct cifs_sb_info *cifs_sb);
+int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb,
+				const struct kvec *iov,
+				const char *full_path,
+				char **path);
 int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32 *oplock,
 		   void *buf);
 extern int smb2_unlock_range(struct cifsFileInfo *cfile,
-- 
2.20.1

