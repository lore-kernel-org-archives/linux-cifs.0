From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 1/2] CIFS: Implement follow_link for SMB2
Date: Wed, 14 Aug 2013 19:25:21 +0400
Message-ID: <1376493922-7150-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that allows to access files through symlink created on a server.

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +++
 fs/cifs/inode.c     |    4 ++++
 fs/cifs/link.c      |   24 +++++----------------
 fs/cifs/readdir.c   |    3 +++
 fs/cifs/smb2file.c  |    2 +-
 fs/cifs/smb2inode.c |    9 ++++----
 fs/cifs/smb2misc.c  |    4 ++++
 fs/cifs/smb2ops.c   |   60 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.c   |    6 +++++-
 fs/cifs/smb2pdu.h   |   14 ++++++++++++
 fs/cifs/smb2proto.h |    3 ++-
 11 files changed, 103 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 52ca861..ec6c3fb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -308,6 +308,9 @@ struct smb_version_operations {
 	int (*create_hardlink)(const unsigned int, struct cifs_tcon *,
 			       const char *, const char *,
 			       struct cifs_sb_info *);
+	/* query symlink target */
+	int (*query_symlink)(const unsigned int, struct cifs_tcon *,
+			     const char *, char **, struct cifs_sb_info *);
 	/* open a file for non-posix mounts */
 	int (*open)(const unsigned int, struct cifs_open_parms *,
 		    __u32 *, FILE_ALL_INFO *);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 449b6cf..ec0f342 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -549,6 +549,10 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 		 * when Unix extensions are disabled - fake it.
 		 */
 		fattr->cf_nlink = 2;
+	} else if (fattr->cf_cifsattrs & ATTR_REPARSE) {
+		fattr->cf_mode = S_IFLNK;
+		fattr->cf_dtype = DT_LNK;
+		fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
 	} else {
 		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
 		fattr->cf_dtype = DT_REG;
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 562044f..7e36ceb 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -509,6 +509,7 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 
 	xid = get_xid();
 
@@ -519,25 +520,7 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 		goto out;
 	}
 	tcon = tlink_tcon(tlink);
-
-	/*
-	 * For now, we just handle symlinks with unix extensions enabled.
-	 * Eventually we should handle NTFS reparse points, and MacOS
-	 * symlink support. For instance...
-	 *
-	 * rc = CIFSSMBQueryReparseLinkInfo(...)
-	 *
-	 * For now, just return -EACCES when the server doesn't support posix
-	 * extensions. Note that we still allow querying symlinks when posix
-	 * extensions are manually disabled. We could disable these as well
-	 * but there doesn't seem to be any harm in allowing the client to
-	 * read them.
-	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) &&
-	    !cap_unix(tcon->ses)) {
-		rc = -EACCES;
-		goto out;
-	}
+	server = tcon->ses->server;
 
 	full_path = build_path_from_dentry(direntry);
 	if (!full_path)
@@ -559,6 +542,9 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	if ((rc != 0) && cap_unix(tcon->ses))
 		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
 					     cifs_sb->local_nls);
+	else if (rc != 0 && server->ops->query_symlink)
+		rc = server->ops->query_symlink(xid, tcon, full_path,
+						&target_path, cifs_sb);
 
 	kfree(full_path);
 out:
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 69d2c82..42ef03b 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -172,6 +172,9 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 		if (cifs_dfs_is_possible(cifs_sb) &&
 		    (fattr->cf_cifsattrs & ATTR_REPARSE))
 			fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
+	} else if (fattr->cf_cifsattrs & ATTR_REPARSE) {
+		fattr->cf_mode = S_IFLNK;
+		fattr->cf_dtype = DT_LNK;
 	} else {
 		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
 		fattr->cf_dtype = DT_REG;
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 04a81a4..020245d 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -86,7 +86,7 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	if (oparms->tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
 		memcpy(smb2_oplock + 1, fid->lease_key, SMB2_LEASE_KEY_SIZE);
 
-	rc = SMB2_open(xid, oparms, smb2_path, smb2_oplock, smb2_data);
+	rc = SMB2_open(xid, oparms, smb2_path, smb2_oplock, smb2_data, NULL);
 	if (rc)
 		goto out;
 
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index c6ec163..78ff88c 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -60,7 +60,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL);
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
 	if (rc) {
 		kfree(utf16_path);
 		return rc;
@@ -136,7 +136,8 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	rc = smb2_open_op_close(xid, tcon, cifs_sb, full_path,
-				FILE_READ_ATTRIBUTES, FILE_OPEN, 0, smb2_data,
+				FILE_READ_ATTRIBUTES, FILE_OPEN,
+				OPEN_REPARSE_POINT, smb2_data,
 				SMB2_OP_QUERY_INFO);
 	if (rc)
 		goto out;
@@ -191,8 +192,8 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	    struct cifs_sb_info *cifs_sb)
 {
 	return smb2_open_op_close(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
-				  CREATE_DELETE_ON_CLOSE, NULL,
-				  SMB2_OP_DELETE);
+				  CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
+				  NULL, SMB2_OP_DELETE);
 }
 
 static int
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index b0c4334..6103359 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -171,6 +171,10 @@ smb2_check_message(char *buf, unsigned int length)
 	if (4 + len != clc_len) {
 		cifs_dbg(FYI, "Calculated size %u length %u mismatch mid %llu\n",
 			 clc_len, 4 + len, mid);
+		/* create failed on symlink */
+		if (command == SMB2_CREATE_HE &&
+		    hdr->Status == STATUS_STOPPED_ON_SYMLINK)
+			return 0;
 		/* Windows 7 server returns 24 bytes more */
 		if (clc_len + 20 == len && command == SMB2_OPLOCK_BREAK_HE)
 			return 0;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f259e6c..91b9e54 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -24,6 +24,7 @@
 #include "smb2proto.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
+#include "cifs_unicode.h"
 #include "smb2status.h"
 #include "smb2glob.h"
 
@@ -229,7 +230,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL);
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
 	if (rc) {
 		kfree(utf16_path);
 		return rc;
@@ -463,7 +464,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = fid;
 	oparms.reconnect = false;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL);
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
 	kfree(utf16_path);
 	if (rc) {
 		cifs_dbg(VFS, "open dir failed\n");
@@ -550,7 +551,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL);
+	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL);
 	if (rc)
 		return rc;
 	buf->f_type = SMB2_MAGIC_NUMBER;
@@ -596,6 +597,57 @@ smb2_new_lease_key(struct cifs_fid *fid)
 	get_random_bytes(fid->lease_key, SMB2_LEASE_KEY_SIZE);
 }
 
+static int
+smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
+		   const char *full_path, char **target_path,
+		   struct cifs_sb_info *cifs_sb)
+{
+	int rc;
+	__le16 *utf16_path;
+	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	struct cifs_open_parms oparms;
+	struct cifs_fid fid;
+	struct smb2_err_rsp *err_buf = NULL;
+	struct smb2_symlink_err_rsp *symlink;
+	unsigned int sub_len, sub_offset;
+
+	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
+
+	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
+
+	oparms.tcon = tcon;
+	oparms.desired_access = FILE_READ_ATTRIBUTES;
+	oparms.disposition = FILE_OPEN;
+	oparms.create_options = 0;
+	oparms.fid = &fid;
+	oparms.reconnect = false;
+
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, &err_buf);
+
+	if (!rc || !err_buf) {
+		kfree(utf16_path);
+		return -ENOENT;
+	}
+	/* open must fail on symlink - reset rc */
+	rc = 0;
+	symlink = (struct smb2_symlink_err_rsp *)err_buf->ErrorData;
+	sub_len = le16_to_cpu(symlink->SubstituteNameLength);
+	sub_offset = le16_to_cpu(symlink->SubstituteNameOffset);
+	*target_path = cifs_strndup_from_utf16(
+				(char *)symlink->PathBuffer + sub_offset,
+				sub_len, true, cifs_sb->local_nls);
+	if (!(*target_path)) {
+		kfree(utf16_path);
+		return -ENOMEM;
+	}
+	convert_delimiter(*target_path, '/');
+	cifs_dbg(FYI, "%s: target path: %s\n", __func__, *target_path);
+	kfree(utf16_path);
+	return rc;
+}
+
 struct smb_version_operations smb21_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -638,6 +690,7 @@ struct smb_version_operations smb21_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
+	.query_symlink = smb2_query_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -706,6 +759,7 @@ struct smb_version_operations smb30_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
+	.query_symlink = smb2_query_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index abc9c28..5a49861 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -977,7 +977,8 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
 
 int
 SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
-	  __u8 *oplock, struct smb2_file_all_info *buf)
+	  __u8 *oplock, struct smb2_file_all_info *buf,
+	  struct smb2_err_rsp **err_buf)
 {
 	struct smb2_create_req *req;
 	struct smb2_create_rsp *rsp;
@@ -1082,6 +1083,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	if (rc != 0) {
 		cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
+		if (err_buf)
+			*err_buf = kmemdup(rsp, get_rfc1002_length(rsp) + 4,
+					   GFP_KERNEL);
 		goto creat_exit;
 	}
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 36b0d37..40baeae 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -150,6 +150,20 @@ struct smb2_err_rsp {
 	__u8   ErrorData[1];  /* variable length */
 } __packed;
 
+struct smb2_symlink_err_rsp {
+	__le32 SymLinkLength;
+	__le32 SymLinkErrorTag;
+	__le32 ReparseTag;
+	__le16 ReparseDataLength;
+	__le16 UnparsedPathLength;
+	__le16 SubstituteNameOffset;
+	__le16 SubstituteNameLength;
+	__le16 PrintNameOffset;
+	__le16 PrintNameLength;
+	__le32 Flags;
+	__u8  PathBuffer[0];
+} __packed;
+
 #define SMB2_CLIENT_GUID_SIZE 16
 
 extern __u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 1a5ecbe..1db89fd 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -106,7 +106,8 @@ extern int SMB2_tcon(const unsigned int xid, struct cifs_ses *ses,
 extern int SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon);
 extern int SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms,
 		     __le16 *path, __u8 *oplock,
-		     struct smb2_file_all_info *buf);
+		     struct smb2_file_all_info *buf,
+		     struct smb2_err_rsp **err_buf);
 extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, u32 opcode,
 		     bool is_fsctl, char *in_data, u32 indatalen,
-- 
1.7.10.4
