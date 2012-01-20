From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 38/50] CIFS: Add SMB2 support for hardlink operation
Date: Fri, 20 Jan 2012 12:34:59 +0400
Message-ID: <1327048511-2342-38-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2glob.h  |    1 +
 fs/cifs/smb2inode.c |    8 +++-
 fs/cifs/smb2link.c  |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   |   74 +++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |    9 ++++
 fs/cifs/smb2proto.h |    9 ++++
 6 files changed, 207 insertions(+), 2 deletions(-)
 create mode 100644 fs/cifs/smb2link.c

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index bde9f99..460d330 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -39,6 +39,7 @@
 #define SMB2_OP_MKDIR 5
 #define SMB2_OP_RENAME 6
 #define SMB2_OP_DELETE 7
+#define SMB2_OP_HARDLINK 8
 
 /* Used when constructing chained read requests. */
 #define CHAINED_REQUEST 1
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 6bebed1..31285b5 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -42,7 +42,7 @@ const struct inode_operations smb2_dir_inode_ops = {
 	.lookup = cifs_lookup,
 	.getattr = cifs_getattr,
 	.unlink = smb2_unlink,
-	.link = cifs_hardlink,
+	.link = smb2_hardlink,
 	.mkdir = smb2_mkdir,
 	.rmdir = smb2_rmdir,
 	.rename = smb2_rename,
@@ -140,7 +140,7 @@ void smb2_set_ops(struct inode *inode)
 	}
 }
 
-static int
+int
 smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *srch_path,
 		   __u32 desired_access, __u32 create_disposition,
 		   __u32 file_attributes, __u32 create_options,
@@ -171,6 +171,10 @@ smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *srch_path,
 		tmprc = SMB2_rename(xid, tcon, persist_fid, volatile_fid,
 				    (__le16 *)data);
 		break;
+	case SMB2_OP_HARDLINK:
+		tmprc = SMB2_set_hardlink(xid, tcon, persist_fid, volatile_fid,
+					  (__le16 *)data);
+		break;
 	default:
 		cERROR(1, "Invalid command");
 		break;
diff --git a/fs/cifs/smb2link.c b/fs/cifs/smb2link.c
new file mode 100644
index 0000000..48f4a56
--- /dev/null
+++ b/fs/cifs/smb2link.c
@@ -0,0 +1,108 @@
+/*
+ *   fs/cifs/smb2link.c
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org),
+ *              Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include <linux/fs.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/namei.h>
+#include "cifsfs.h"
+#include "cifspdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+#include "cifs_fs_sb.h"
+#include "smb2glob.h"
+#include "smb2proto.h"
+
+int
+smb2_hardlink(struct dentry *old_file, struct inode *inode,
+	      struct dentry *direntry)
+{
+	int rc = -EACCES;
+	int xid;
+	__le16 *from_name = NULL;
+	__le16 *to_name = NULL;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct cifsInodeInfo *cinode;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	xid = GetXid();
+
+	from_name = cifs_build_utf16path_from_dentry(old_file);
+	to_name = cifs_build_utf16path_from_dentry(direntry);
+	if ((from_name == NULL) || (to_name == NULL)) {
+		rc = -ENOMEM;
+		goto smb2_hl_exit;
+	}
+
+	rc = smb2_open_op_close(xid, tcon, from_name, FILE_READ_ATTRIBUTES,
+				FILE_OPEN, 0, 0, to_name, SMB2_OP_HARDLINK);
+
+	if ((rc == -EIO) || (rc == -EINVAL))
+		rc = -EOPNOTSUPP;
+
+	d_drop(direntry);	/* force new lookup from server of target */
+
+	/*
+	 * if source file is cached (oplocked) revalidate will not go to server
+	 * until the file is closed or oplock broken so update nlinks locally.
+	 */
+	if (old_file->d_inode) {
+		cinode = CIFS_I(old_file->d_inode);
+		if (rc == 0) {
+			inc_nlink(inode);
+/* BB should we make this contingent on superblock flag NOATIME? */
+/*			old_file->d_inode->i_ctime = CURRENT_TIME;*/
+			/*
+			 * parent dir timestamps will update from srv
+			 * within a second, would it really be worth it
+			 * to set the parent dir cifs inode time to zero
+			 * to force revalidate (faster) for it too?
+			 */
+		}
+		/*
+		 * if not oplocked will force revalidate to get info
+		 * on source file from srv.
+		 */
+		cinode->time = 0;
+
+		/*
+		 * Will update parent dir timestamps from srv within a second.
+		 * Would it really be worth it to set the parent dir (cifs
+		 * inode) time field to zero to force revalidate on parent
+		 * directory faster ie
+			CIFS_I(inode)->time = 0;
+		 */
+	}
+
+smb2_hl_exit:
+	kfree(from_name);
+	kfree(to_name);
+	FreeXid(xid);
+	cifs_put_tlink(tlink);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e3168ba..ae1eb69 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1768,3 +1768,77 @@ rename_exit:
 	free_rsp_buf(resp_buftype, pSMB2r);
 	return rc;
 }
+
+int SMB2_set_hardlink(const int xid, struct cifs_tcon *tcon,
+		      u64 persistent_fid, u64 volatile_fid, __le16 *target_file)
+{
+	struct smb2_set_info_req *pSMB2;
+	struct smb2_set_info_rsp *pSMB2r = NULL;
+	struct kvec iov[2];
+	int rc = 0;
+	int resp_buftype;
+	int status;
+	int uni_path_len;
+	struct TCP_Server_Info *server;
+	struct FileLinkInformation *pfli;
+	struct cifs_ses *ses = tcon->ses;
+
+	cFYI(1, "Create hard link");
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
+	pSMB2->FileInfoClass = FILE_LINK_INFORMATION;
+	pSMB2->PersistentFileId = persistent_fid;
+	pSMB2->VolatileFileId = volatile_fid;
+	pSMB2->BufferOffset = cpu_to_le16(sizeof(struct smb2_set_info_req)
+			- 1 /* pad */ - 4 /* do not count rfc1001 len field */);
+
+	uni_path_len = (2 * UniStrnlen((wchar_t *)target_file, PATH_MAX)) + 2;
+	pSMB2->BufferOffset = cpu_to_le16(sizeof(struct smb2_set_info_req) - 1
+		/* pad */ - 4 /* do not count rfc1001 len field */);
+	pSMB2->BufferLength = cpu_to_le32(sizeof(struct FileLinkInformation) +
+					uni_path_len);
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4 - 1;
+	iov[0].iov_len += sizeof(struct FileLinkInformation);
+	iov[1].iov_base = target_file;
+	iov[1].iov_len = uni_path_len; /* This is two bytes more - includes
+					  null - is it better to send without */
+
+	pfli = (struct FileLinkInformation *)pSMB2->Buffer;
+	pfli->ReplaceIfExists = 0; /* 1 = replace existing link with new */
+			      /* 0 = fail if link already exists */
+	pfli->RootDirectory = 0;  /* MBZ for network ops (why does spec say?) */
+	pfli->FileNameLength = cpu_to_le32(uni_path_len - 2);
+	pSMB2->hdr.smb2_buf_length =
+		cpu_to_be32(be32_to_cpu(pSMB2->hdr.smb2_buf_length) - 1 +
+			sizeof(struct FileLinkInformation) + uni_path_len);
+
+	rc = smb2_sendrcv2(xid, ses, iov, 2, &resp_buftype /* ret */, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	cFYI(1, "sinfo buftype %d rc %d status %d", resp_buftype, rc, status);
+	pSMB2r = (struct smb2_set_info_rsp *)iov[0].iov_base;
+
+	if (rc != 0) {
+		cifs_stats_fail_inc(tcon, SMB2SET_INFO);
+		goto set_link_exit;
+	}
+
+	if (pSMB2r == NULL) {
+		rc = -EIO;
+		goto set_link_exit;
+	}
+
+set_link_exit:
+	free_rsp_buf(resp_buftype, pSMB2r);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 1f795ca..4d0fa6e 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -667,6 +667,15 @@ struct FileRenameInformation { /* encoding of request for level 10 */
 	char   FileName[0];     /* New name to be assigned */
 } __packed; /* level 10 set */
 
+struct FileLinkInformation { /* encoding of request for level 11 */
+	__u8   ReplaceIfExists; /* 1 = replace existing link with new */
+				/* 0 = fail if link already exists */
+	__u8   Reserved[7];
+	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
+	__le32 FileNameLength;
+	char   FileName[0];     /* Name to be assigned to new link */
+} __packed; /* level 11 set */
+
 /*
  * This level 18, although with struct with same name is different from cifs
  * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 5317221..61814bf 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -79,6 +79,10 @@ extern int smb2_query_file_info(struct file *filp);
 extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
 				 FILE_ALL_INFO *data, struct super_block *sb,
 				 int xid);
+extern int smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
+			      __u32 desired_access, __u32 create_disposition,
+			      __u32 file_attributes, __u32 create_options,
+			      void *data, int command);
 extern void smb2_set_ops(struct inode *inode);
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
@@ -88,6 +92,8 @@ extern int smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 extern int smb2_readdir(struct file *file, void *direntry, filldir_t filldir);
 extern int smb2_rename(struct inode *source_dir, struct dentry *source_dentry,
 		       struct inode *target_dir, struct dentry *target_dentry);
+extern int smb2_hardlink(struct dentry *old_file, struct inode *inode,
+			 struct dentry *direntry);
 
 extern struct cifsFileInfo *smb2_new_fileinfo(__u64 persist_fid,
 					      __u64 volatile_fid,
@@ -153,5 +159,8 @@ extern int SMB2_query_directory(const int xid, struct cifs_tcon *tcon,
 extern int SMB2_rename(const int xid, struct cifs_tcon *tcon,
 		       u64 persistent_fid, u64 volatile_fid,
 		       __le16 *target_file);
+extern int SMB2_set_hardlink(const int xid, struct cifs_tcon *tcon,
+			     u64 persistent_fid, u64 volatile_fid,
+			     __le16 *target_file);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
