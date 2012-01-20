From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 37/50] CIFS: Add SMB2 support for rename operation
Date: Fri, 20 Jan 2012 12:34:58 +0400
Message-ID: <1327048511-2342-37-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2inode.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.c   |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   28 +++++++++++++++++++
 fs/cifs/smb2proto.h |    5 +++
 4 files changed, 176 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index b533844..6bebed1 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -45,7 +45,7 @@ const struct inode_operations smb2_dir_inode_ops = {
 	.link = cifs_hardlink,
 	.mkdir = smb2_mkdir,
 	.rmdir = smb2_rmdir,
-	.rename = cifs_rename,
+	.rename = smb2_rename,
 	.permission = cifs_permission,
 /*	revalidate:cifs_revalidate,   */
 	.setattr = cifs_setattr,
@@ -63,7 +63,7 @@ const struct inode_operations smb2_file_inode_ops = {
 /*	revalidate:cifs_revalidate, */
 	.setattr = cifs_setattr,
 	.getattr = cifs_getattr, /* do we need this anymore? */
-	.rename = cifs_rename,
+	.rename = smb2_rename,
 	.permission = cifs_permission,
 #ifdef CONFIG_CIFS_XATTR
 	.setxattr = cifs_setxattr,
@@ -167,6 +167,10 @@ smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *srch_path,
 		/* Directories are created through parameters in the
 		 * SMB2_open() call. */
 		break;
+	case SMB2_OP_RENAME:
+		tmprc = SMB2_rename(xid, tcon, persist_fid, volatile_fid,
+				    (__le16 *)data);
+		break;
 	default:
 		cERROR(1, "Invalid command");
 		break;
@@ -729,3 +733,67 @@ smb2_create_out:
 	FreeXid(xid);
 	return rc;
 }
+
+static int
+smb2_do_rename(struct dentry *from_dentry, __le16 *from_path,
+	       struct dentry *to_dentry, __le16 *to_path)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(from_dentry->d_sb);
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	int rc, xid;
+
+	xid = GetXid();
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	rc = smb2_open_op_close(xid, tcon, from_path, DELETE,
+				FILE_OPEN, 0, 0, to_path, SMB2_OP_RENAME);
+
+	cifs_put_tlink(tlink);
+	FreeXid(xid);
+	return rc;
+}
+
+int smb2_rename(struct inode *source_dir, struct dentry *source_dentry,
+		struct inode *target_dir, struct dentry *target_dentry)
+{
+	__le16 *from_name = NULL;
+	__le16 *to_name = NULL;
+	int rc, tmprc;
+
+	/*
+	 * we already have the rename sem so we do not need to
+	 * grab it again here to protect the path integrity
+	 */
+	from_name = cifs_build_utf16path_from_dentry(source_dentry);
+	if (from_name == NULL) {
+		rc = -ENOMEM;
+		goto smb2_rename_exit;
+	}
+
+	to_name = cifs_build_utf16path_from_dentry(target_dentry);
+	if (to_name == NULL) {
+		rc = -ENOMEM;
+		goto smb2_rename_exit;
+	}
+
+	rc = smb2_do_rename(source_dentry, from_name, target_dentry, to_name);
+
+	/* Try unlinking the target dentry if it's not negative */
+	if (target_dentry->d_inode && (rc == -EACCES || rc == -EEXIST)) {
+		tmprc = smb2_unlink(target_dir, target_dentry);
+		if (tmprc)
+			goto smb2_rename_exit;
+
+		rc = smb2_do_rename(source_dentry, from_name, target_dentry,
+				    to_name);
+	}
+
+smb2_rename_exit:
+	kfree(from_name);
+	kfree(to_name);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bfc1498..e3168ba 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1695,3 +1695,76 @@ qdir_exit:
 	free_rsp_buf(resp_buftype, pSMB2r);
 	return rc;
 }
+
+int SMB2_rename(const int xid, struct cifs_tcon *tcon,
+		u64 persistent_fid, u64 volatile_fid, __le16 *target_file)
+{
+	struct smb2_set_info_req *pSMB2;
+	struct smb2_set_info_rsp *pSMB2r = NULL;
+	struct kvec iov[2];
+	int rc = 0;
+	int resp_buftype;
+	int status;
+	int uni_path_len;
+	struct TCP_Server_Info *server;
+	struct FileRenameInformation *pfli;
+	struct cifs_ses *ses = tcon->ses;
+
+	cFYI(1, "rename");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_SET_INFO, tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	pSMB2->InfoType = SMB2_O_INFO_FILE;
+	pSMB2->FileInfoClass = FILE_RENAME_INFORMATION;
+	pSMB2->PersistentFileId = persistent_fid;
+	pSMB2->VolatileFileId = volatile_fid;
+	pSMB2->BufferOffset = cpu_to_le16(sizeof(struct smb2_set_info_req)
+			- 1 /* pad */ - 4 /* do not count rfc1001 len field */);
+
+	uni_path_len = (2 * UniStrnlen((wchar_t *)target_file, PATH_MAX)) + 2;
+	pSMB2->BufferOffset = cpu_to_le16(sizeof(struct smb2_set_info_req) - 1
+		/* pad */ - 4 /* do not count rfc1001 len field */);
+	pSMB2->BufferLength = cpu_to_le32(sizeof(struct FileRenameInformation) +
+					uni_path_len);
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4 - 1;
+	iov[0].iov_len += sizeof(struct FileRenameInformation);
+	iov[1].iov_base = target_file;
+	iov[1].iov_len = uni_path_len; /* This is two bytes more - includes
+					  null - is it better to send without */
+
+	pfli = (struct FileRenameInformation *)pSMB2->Buffer;
+	pfli->ReplaceIfExists = 0; /* 1 = replace existing link with new */
+			      /* 0 = fail if link already exists */
+	pfli->RootDirectory = 0;  /* MBZ for network ops (why does spec say?) */
+	pfli->FileNameLength = cpu_to_le32(uni_path_len - 2);
+	pSMB2->hdr.smb2_buf_length =
+		cpu_to_be32(be32_to_cpu(pSMB2->hdr.smb2_buf_length) - 1 +
+			sizeof(struct FileRenameInformation) + uni_path_len);
+
+	rc = smb2_sendrcv2(xid, ses, iov, 2, &resp_buftype /* ret */, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	pSMB2r = (struct smb2_set_info_rsp *)iov[0].iov_base;
+
+	if (rc != 0) {
+		cifs_stats_fail_inc(tcon, SMB2SET_INFO);
+		goto rename_exit;
+	}
+
+	if (pSMB2r == NULL) {
+		rc = -EIO;
+		goto rename_exit;
+	}
+
+rename_exit:
+	free_rsp_buf(resp_buftype, pSMB2r);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 9c8b59d..1f795ca 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -569,6 +569,25 @@ struct smb2_query_info_rsp {
 	__u8   Buffer[1];
 } __packed;
 
+struct smb2_set_info_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 33 */
+	__u8   InfoType;
+	__u8   FileInfoClass;
+	__le32 BufferLength;
+	__le16 BufferOffset;
+	__u16  Reserved;
+	__le32 AdditionalInformation;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_set_info_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 2 */
+} __packed;
+
 /*
  *	PDU infolevel structure definitions
  *	BB consider moving to a different header
@@ -639,6 +658,15 @@ struct smb2_file_full_directory_info {
 	char   filename[0];
 } __packed;
 
+struct FileRenameInformation { /* encoding of request for level 10 */
+	__u8   ReplaceIfExists; /* 1 = replace existing file with new */
+				/* 0 = fail if target file already exists */
+	__u8   Reserved[7];
+	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
+	__le32 FileNameLength;
+	char   FileName[0];     /* New name to be assigned */
+} __packed; /* level 10 set */
+
 /*
  * This level 18, although with struct with same name is different from cifs
  * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 468f184..5317221 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -86,6 +86,8 @@ extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
 extern int smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 		       struct nameidata *nd);
 extern int smb2_readdir(struct file *file, void *direntry, filldir_t filldir);
+extern int smb2_rename(struct inode *source_dir, struct dentry *source_dentry,
+		       struct inode *target_dir, struct dentry *target_dentry);
 
 extern struct cifsFileInfo *smb2_new_fileinfo(__u64 persist_fid,
 					      __u64 volatile_fid,
@@ -148,5 +150,8 @@ extern int SMB2_echo(struct TCP_Server_Info *server);
 extern int SMB2_query_directory(const int xid, struct cifs_tcon *tcon,
 				u64 persistent_fid, u64 volatile_fid, int index,
 				struct cifs_search_info *);
+extern int SMB2_rename(const int xid, struct cifs_tcon *tcon,
+		       u64 persistent_fid, u64 volatile_fid,
+		       __le16 *target_file);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
