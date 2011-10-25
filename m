From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 17/53] CIFS: Simplify SMB2 query info
Date: Tue, 25 Oct 2011 10:11:50 +0400
Message-ID: <1319523146-2859-18-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsproto.h |   13 +++-
 fs/cifs/dir.c       |    6 +-
 fs/cifs/file.c      |    5 +-
 fs/cifs/inode.c     |  165 +++++++++++++++++----------------------------------
 fs/cifs/smb2dir.c   |   71 ++++++++++++++++++++++
 fs/cifs/smb2glob.h  |    1 +
 fs/cifs/smb2inode.c |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h |   13 ++--
 8 files changed, 312 insertions(+), 128 deletions(-)
 create mode 100644 fs/cifs/smb2dir.c
 create mode 100644 fs/cifs/smb2inode.c

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index af55d18..66b1ccb 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -141,14 +141,19 @@ extern struct inode *cifs_iget(struct super_block *sb,
 			       struct cifs_fattr *fattr);
 
 extern int cifs_get_file_info(struct file *filp);
-extern int cifs_get_inode_info(struct inode **pinode,
-			const unsigned char *search_path,
-			FILE_ALL_INFO *pfile_info,
-			struct super_block *sb, int xid, const __u16 *pfid);
+extern int cifs_get_inode_info(struct inode **pinode, const char *full_path,
+			       void *data, struct super_block *sb, int xid,
+			       const __u16 *fid);
 extern int cifs_get_file_info_unix(struct file *filp);
 extern int cifs_get_inode_info_unix(struct inode **pinode,
 			const unsigned char *search_path,
 			struct super_block *sb, int xid);
+extern void cifs_all_info_to_fattr(struct cifs_fattr *fattr,
+				   FILE_ALL_INFO *info,
+				   struct cifs_sb_info *cifs_sb,
+				   bool adjust_tz);
+extern void cifs_create_dfs_fattr(struct cifs_fattr *fattr,
+				  struct super_block *sb);
 extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
 			      struct cifs_fattr *fattr, struct inode *inode,
 			      const char *path, const __u16 *pfid);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index d7eeb9d..3696f5b 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -304,8 +304,8 @@ cifs_create_get_file_info:
 		rc = cifs_get_inode_info_unix(&newinode, full_path,
 					      inode->i_sb, xid);
 	else {
-		rc = cifs_get_inode_info(&newinode, full_path, buf,
-					 inode->i_sb, xid, &fileHandle);
+		rc = cifs_get_inode_info(&newinode, full_path, buf, inode->i_sb,
+					 xid, &fileHandle);
 		if (newinode) {
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
 				newinode->i_mode = mode;
@@ -594,7 +594,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 						parent_dir_inode->i_sb, xid);
 	} else
 		rc = cifs_get_inode_info(&newInode, full_path, NULL,
-				parent_dir_inode->i_sb, xid, NULL);
+					 parent_dir_inode->i_sb, xid, NULL);
 
 	if ((rc == 0) && (newInode != NULL)) {
 		d_add(direntry, newInode);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ea096ce..1b9bae6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -568,9 +568,8 @@ reopen_success:
 			rc = cifs_get_inode_info_unix(&inode,
 				full_path, inode->i_sb, xid);
 		else
-			rc = cifs_get_inode_info(&inode,
-				full_path, NULL, inode->i_sb,
-				xid, NULL);
+			rc = cifs_get_inode_info(&inode, full_path, NULL,
+						 inode->i_sb, xid, NULL);
 	} /* else we are writing out data to server already
 	     and could deadlock if we tried to flush data, and
 	     since we do not know if we have data that would
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 4d03038..cb5da45 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -32,6 +32,7 @@
 #include "cifs_unicode.h"
 #include "fscache.h"
 #ifdef CONFIG_CIFS_SMB2
+#include "smb2glob.h"
 #include "smb2proto.h"
 #endif
 
@@ -271,7 +272,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
  * junction to the new submount (ie to setup the fake directory
  * which represents a DFS referral).
  */
-static void
+void
 cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -506,7 +507,7 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 }
 
 /* Fill a cifs_fattr struct with info from FILE_ALL_INFO */
-static void
+void
 cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 		       struct cifs_sb_info *cifs_sb, bool adjust_tz)
 {
@@ -598,73 +599,15 @@ cgfi_exit:
 	return rc;
 }
 
-#ifdef CONFIG_CIFS_SMB2
-static void
-move_smb2_info_to_cifs(FILE_ALL_INFO *dst, FILE_ALL_INFO_SMB2 *src)
-{
-	memcpy(dst, src,
-	       (unsigned int)(&src->CurrentByteOffset) - (unsigned int)src);
-	dst->CurrentByteOffset = src->CurrentByteOffset;
-	dst->Mode = src->Mode;
-	dst->AlignmentRequirement = src->AlignmentRequirement;
-	dst->IndexNumber1 = 0; /* we don't use it */
-}
-
 static int
-smb2_qinfo_helper(int xid, struct cifs_sb_info *cifs_sb, struct cifs_tcon *tcon,
-		  const unsigned char *full_path, FILE_ALL_INFO *pfindData)
-{
-	const unsigned char *start_full_path = full_path;
-	__u64 persistent_fid, volatile_fid;
-	FILE_ALL_INFO_SMB2 *data = NULL;
-	__le16 *path = NULL;
-	int usc_len, rc;
-
-	data = kzalloc(sizeof(FILE_ALL_INFO_SMB2) + MAX_NAME*2, GFP_KERNEL);
-	if (data == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	if (strlen(full_path) && full_path[0] == '\\')
-		start_full_path += 1;
-
-	path = smb2_strndup_to_ucs(start_full_path,
-				   PATH_MAX, &usc_len,
-				   cifs_sb->local_nls);
-	if (path == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	rc = SMB2_open(xid, tcon, path, &persistent_fid, &volatile_fid,
-		       FILE_READ_ATTRIBUTES_LE, FILE_OPEN_LE, 0, 0);
-	if (!rc) {
-		rc = SMB2_query_info(xid, tcon, persistent_fid,
-				     volatile_fid, data);
-		SMB2_close(xid, tcon, persistent_fid,
-			   volatile_fid);
-	}
-
-	if (rc)
-		goto out;
-
-	move_smb2_info_to_cifs(pfindData, data);
-out:
-	kfree(data);
-	kfree(path);
-	return rc;
-}
-#endif
-
-int cifs_get_inode_info(struct inode **pinode, const unsigned char *full_path,
-			FILE_ALL_INFO *pfindData, struct super_block *sb,
-			int xid, const __u16 *pfid)
+cifs_query_inode_info(struct inode **pinode, const char *full_path,
+			FILE_ALL_INFO *data, struct super_block *sb, int xid,
+			const __u16 *fid)
 {
 	int rc = 0, tmprc;
-	struct cifs_tcon *pTcon;
-	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct tcon_link *tlink;
 	char *buf = NULL;
 	bool adjustTZ = false;
 	struct cifs_fattr fattr;
@@ -672,66 +615,54 @@ int cifs_get_inode_info(struct inode **pinode, const unsigned char *full_path,
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
-	pTcon = tlink_tcon(tlink);
+	tcon = tlink_tcon(tlink);
 
 	cFYI(1, "Getting info on %s", full_path);
 
-	if ((pfindData == NULL) && (*pinode != NULL)) {
+	if ((data == NULL) && (*pinode != NULL)) {
 		if (CIFS_I(*pinode)->clientCanCacheRead) {
 			cFYI(1, "No need to revalidate cached inode sizes");
-			goto cgii_exit;
+			goto cqii_exit;
 		}
 	}
 
 	/* if file info not passed in then get it from server */
-	if (pfindData == NULL) {
+	if (data == NULL) {
 		buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 		if (buf == NULL) {
 			rc = -ENOMEM;
-			goto cgii_exit;
+			goto cqii_exit;
 		}
-		pfindData = (FILE_ALL_INFO *)buf;
-
-		if (pTcon->ses->server->is_smb2 == false) {
-			/*
-			 * Could do find first instead but this returns more
-			 * info.
-			 */
-			rc = CIFSSMBQPathInfo(xid, pTcon, full_path, pfindData,
-					      0 /* not legacy */,
-					      cifs_sb->local_nls,
-					      cifs_sb->mnt_cifs_flags &
-					      CIFS_MOUNT_MAP_SPECIAL_CHR);
-			/*
-			 * BB optimize code so we do not make the above call
-			 * when server claims no NT SMB support and the above
-			 * call failed at least once - set flag in tcon or
-			 * mount.
-			 */
-			if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
-				rc = SMBQueryInformation(xid, pTcon, full_path,
-						pfindData, cifs_sb->local_nls,
-						cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
-				adjustTZ = true;
-			}
-#ifdef CONFIG_CIFS_SMB2
-		} else
-			rc = smb2_qinfo_helper(xid, cifs_sb, pTcon, full_path,
-					       pfindData);
-#else
+		data = (FILE_ALL_INFO *)buf;
+
+		/* Could do find first instead but this returns more info */
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, data,
+				      0 /* not legacy */,
+				      cifs_sb->local_nls,
+				      cifs_sb->mnt_cifs_flags &
+				      CIFS_MOUNT_MAP_SPECIAL_CHR);
+		/*
+		 * BB optimize code so we do not make the above call when server
+		 * claims no NT SMB support and the above call failed at least
+		 * once - set flag in tcon or mount.
+		 */
+		if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
+			rc = SMBQueryInformation(xid, tcon, full_path,
+					data, cifs_sb->local_nls,
+					cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
+			adjustTZ = true;
 		}
-#endif
 	}
 
 	if (!rc) {
-		cifs_all_info_to_fattr(&fattr, (FILE_ALL_INFO *) pfindData,
+		cifs_all_info_to_fattr(&fattr, (FILE_ALL_INFO *) data,
 				       cifs_sb, adjustTZ);
 	} else if (rc == -EREMOTE) {
 		cifs_create_dfs_fattr(&fattr, sb);
 		rc = 0;
 	} else {
-		goto cgii_exit;
+		goto cqii_exit;
 	}
 
 	/*
@@ -752,11 +683,10 @@ int cifs_get_inode_info(struct inode **pinode, const unsigned char *full_path,
 	 * guaranteed unique?
 	 */
 	if (*pinode == NULL) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
-		    pTcon->ses->server->is_smb2 == false) {
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 			int rc1 = 0;
 
-			rc1 = CIFSGetSrvInodeNumber(xid, pTcon,
+			rc1 = CIFSGetSrvInodeNumber(xid, tcon,
 					full_path, &fattr.cf_uniqueid,
 					cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
@@ -785,11 +715,11 @@ int cifs_get_inode_info(struct inode **pinode, const unsigned char *full_path,
 	/* fill in 0777 bits from ACL */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *pinode, full_path,
-						pfid);
+				       fid);
 		if (rc) {
 			cFYI(1, "%s: Getting ACL failed with error: %d",
 				__func__, rc);
-			goto cgii_exit;
+			goto cqii_exit;
 		}
 	}
 #endif /* CONFIG_CIFS_ACL */
@@ -813,12 +743,25 @@ int cifs_get_inode_info(struct inode **pinode, const unsigned char *full_path,
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
-cgii_exit:
+cqii_exit:
 	kfree(buf);
 	cifs_put_tlink(tlink);
 	return rc;
 }
 
+int
+cifs_get_inode_info(struct inode **pinode, const char *full_path, void *data,
+		    struct super_block *sb, int xid, const __u16 *fid)
+{
+#ifdef CONFIG_CIFS_SMB2
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(CIFS_SB(sb));
+
+	if (tcon->ses->server->is_smb2)
+		return smb2_query_inode_info(pinode, full_path, data, sb, xid);
+#endif
+	return cifs_query_inode_info(pinode, full_path, data, sb, xid, fid);
+}
+
 static const struct inode_operations cifs_ipc_inode_ops = {
 	.lookup = cifs_lookup,
 };
@@ -1833,8 +1776,8 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 	if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
 		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
-		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
-					 xid, NULL);
+		rc = cifs_get_inode_info(&inode, full_path, NULL, sb, xid,
+					 NULL);
 
 out:
 	kfree(full_path);
diff --git a/fs/cifs/smb2dir.c b/fs/cifs/smb2dir.c
new file mode 100644
index 0000000..f297e2c
--- /dev/null
+++ b/fs/cifs/smb2dir.c
@@ -0,0 +1,71 @@
+/*
+ *   fs/cifs/smb2dir.c
+ *
+ *   Copyright (C) 2011
+ *   Author(s): Pavel Shilovsky (piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org),
+ *              Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
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
+#include <linux/pagemap.h>
+#include <asm/div64.h>
+#include "cifsfs.h"
+#include "cifspdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+#include "cifs_fs_sb.h"
+#include "cifs_unicode.h"
+#include "fscache.h"
+#include "smb2glob.h"
+#include "smb2proto.h"
+
+/* Note: caller must free return buffer */
+__le16 *
+cifs_convert_path_to_ucs(const char *from, struct nls_table *local_nls)
+{
+	int ucs_len;
+	const char *start_of_path;
+	__le16 *ucs_full_path;
+
+	/* Windows doesn't allow paths beginning with \ */
+	if (from[0] == '\\')
+		start_of_path = from + 1;
+	else
+		start_of_path = from;
+	ucs_full_path = smb2_strndup_to_ucs(start_of_path, PATH_MAX,
+					    &ucs_len, local_nls);
+	return ucs_full_path;
+}
+
+__le16 *
+build_ucspath_from_dentry(struct dentry *direntry)
+{
+	char *full_path;
+	__le16 *ucs_path;
+
+	full_path = build_path_from_dentry(direntry);
+	if (full_path == NULL)
+		return NULL;
+
+	ucs_path = cifs_convert_path_to_ucs(full_path,
+					    CIFS_SB(direntry->d_sb)->local_nls);
+	kfree(full_path);
+	return ucs_path;
+}
+
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 0e9fba7..1fe5813 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -182,6 +182,7 @@ struct page_req {
 #define SMB2_OP_QUERY_DIR 4
 #define SMB2_OP_MKDIR 5
 #define SMB2_OP_RENAME 6
+#define SMB2_OP_DELETE 7
 
 /* Used when constructing chained read requests. */
 #define CHAINED_REQUEST 1
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
new file mode 100644
index 0000000..b6d4dd5
--- /dev/null
+++ b/fs/cifs/smb2inode.c
@@ -0,0 +1,166 @@
+/*
+ *   fs/cifs/smb2inode.c
+ *
+ *   Copyright (C) 2011
+ *   Author(s): Pavel Shilovsky (piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org),
+ *              Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
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
+#include <linux/pagemap.h>
+#include <asm/div64.h>
+#include "cifsfs.h"
+#include "cifspdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+#include "cifs_fs_sb.h"
+#include "cifs_unicode.h"
+#include "fscache.h"
+#include "smb2glob.h"
+#include "smb2proto.h"
+
+static int
+smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *srch_path,
+		   __le32 desired_access, __le32 create_disposition,
+		   __le32 file_attributes, __le32 create_options,
+		   void *data, int command)
+{
+	int rc, tmprc = 0;
+	u64 persist_fid, volatile_fid;
+
+	rc = SMB2_open(xid, tcon, srch_path, &persist_fid, &volatile_fid,
+		       desired_access, create_disposition, file_attributes,
+		       create_options);
+	if (rc)
+		return rc;
+
+	switch (command) {
+	case SMB2_OP_DELETE:
+		break;
+	case SMB2_OP_QUERY_INFO:
+		tmprc = SMB2_query_info(xid, tcon, persist_fid,
+					volatile_fid,
+					(FILE_ALL_INFO_SMB2 *)data);
+		break;
+	case SMB2_OP_MKDIR:
+		/* Directories are created through parameters in the
+		 * SMB2_open() call. */
+		break;
+	default:
+		cERROR(1, "Invalid command");
+		break;
+	}
+
+	rc = SMB2_close(xid, tcon, persist_fid, volatile_fid);
+	if (tmprc)
+		rc = tmprc;
+
+	return rc;
+}
+
+static void
+move_smb2_info_to_cifs(FILE_ALL_INFO *dst, FILE_ALL_INFO_SMB2 *src)
+{
+	memcpy(dst, src,
+	       (unsigned int)(&src->CurrentByteOffset) - (unsigned int)src);
+	dst->CurrentByteOffset = src->CurrentByteOffset;
+	dst->Mode = src->Mode;
+	dst->AlignmentRequirement = src->AlignmentRequirement;
+	dst->IndexNumber1 = 0; /* we don't use it */
+}
+
+static int
+smb2_qinfo_helper(int xid, struct cifs_sb_info *cifs_sb, struct cifs_tcon *tcon,
+		  const char *full_path, FILE_ALL_INFO *data)
+{
+	int rc;
+	__le16 *smb2_path;
+	FILE_ALL_INFO_SMB2 *smb2_data;
+
+	smb2_data = kzalloc(sizeof(FILE_ALL_INFO_SMB2) + MAX_NAME*2,
+			    GFP_KERNEL);
+	if (smb2_data == NULL)
+		return -ENOMEM;
+
+	smb2_path = cifs_convert_path_to_ucs(full_path, cifs_sb->local_nls);
+	if (smb2_path == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = smb2_open_op_close(xid, tcon, smb2_path, FILE_READ_ATTRIBUTES_LE,
+				FILE_OPEN_LE, 0, 0, smb2_data,
+				SMB2_OP_QUERY_INFO);
+	if (rc)
+		goto out;
+
+	move_smb2_info_to_cifs(data, smb2_data);
+out:
+	kfree(smb2_path);
+	kfree(smb2_data);
+	return rc;
+}
+
+int smb2_get_inode_info(struct inode **pinode, const char *full_path,
+			FILE_ALL_INFO *data, struct super_block *sb,
+			int xid, struct cifs_tcon *tcon)
+{
+	int rc = 0;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	char *buf = NULL;
+	struct cifs_fattr fattr;
+
+	/* if file info not passed in then get it from server */
+	if (data == NULL) {
+		buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+		if (buf == NULL) {
+			rc = -ENOMEM;
+			goto sgii_exit;
+		}
+		data = (FILE_ALL_INFO *)buf;
+		rc = smb2_qinfo_helper(xid, cifs_sb, tcon, full_path, data);
+	}
+
+	if (!rc) {
+		cifs_all_info_to_fattr(&fattr, (FILE_ALL_INFO *) data,
+				       cifs_sb, false);
+	} else if (rc == -EREMOTE) {
+		cifs_create_dfs_fattr(&fattr, sb);
+		rc = 0;
+	} else {
+		goto sgii_exit;
+	}
+
+	if (*pinode == NULL)
+		fattr.cf_uniqueid = iunique(sb, ROOT_I);
+	else
+		fattr.cf_uniqueid = CIFS_I(*pinode)->uniqueid;
+
+	if (!*pinode) {
+		*pinode = cifs_iget(sb, &fattr);
+		if (!*pinode)
+			rc = -ENOMEM;
+	} else {
+		cifs_fattr_to_inode(*pinode, &fattr);
+	}
+
+sgii_exit:
+	kfree(buf);
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index e46ed83..33401a9 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -47,6 +47,9 @@ extern int checkSMB2(struct smb2_hdr *smb2, __u64 mid, unsigned int length);
 extern char *smb2_get_data_area_len(int *poff, int *pln, struct smb2_hdr *psmb);
 extern unsigned int smb2_calc_size(struct smb2_hdr *ptr);
 extern int map_smb2_to_linux_error(struct smb2_hdr *smb2, int logErr);
+extern __le16 *cifs_build_ucspath_from_dentry(struct dentry *);
+extern __le16 *cifs_convert_path_to_ucs(const char *from,
+					struct nls_table *local_nls);
 
 extern int smb2_send(struct TCP_Server_Info *, struct smb2_hdr *,
 		     unsigned int /* length */);
@@ -76,13 +79,9 @@ extern int smb2_setup_session(unsigned int xid, struct cifs_ses *pses_info,
 			      struct nls_table *nls_info);
 extern int smb2_umount(struct super_block *, struct cifs_sb_info *);
 
-extern int smb2_get_inode_info(struct inode **pinode, __le16 *search_path,
-			FILE_ALL_INFO *pfile_info, struct super_block *sb,
-			int xid);
-extern struct smb2_file *smb2_new_fileinfo(struct inode *newinode,
-					u64 persistfid, u64 volatile_fid,
-					struct file *file, struct vfsmount *mnt,
-					unsigned int oflags);
+extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
+				 FILE_ALL_INFO *data, struct super_block *sb,
+				 int xid);
 extern bool smb2_is_size_safe_to_change(struct smb2_inode *smb2_ind,
 					__u64 end_of_file);
 extern struct inode *smb2_iget(struct super_block *sb,
-- 
1.7.1
