From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 14/50] CIFS: Query SMB2 inode info
Date: Fri, 20 Jan 2012 12:34:35 +0400
Message-ID: <1327048511-2342-14-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |   13 +++-
 fs/cifs/dir.c       |    6 +-
 fs/cifs/file.c      |    5 +-
 fs/cifs/inode.c     |   89 +++++++++++++++----------
 fs/cifs/smb2dir.c   |   53 +++++++++++++++
 fs/cifs/smb2glob.h  |   43 ++++++++++++
 fs/cifs/smb2inode.c |  182 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2misc.c  |    7 ++-
 fs/cifs/smb2pdu.c   |  113 +++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |  111 +++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h |    9 +++
 11 files changed, 586 insertions(+), 45 deletions(-)
 create mode 100644 fs/cifs/smb2dir.c
 create mode 100644 fs/cifs/smb2glob.h
 create mode 100644 fs/cifs/smb2inode.c

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 3344a9f..0692428 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -146,14 +146,19 @@ extern struct inode *cifs_iget(struct super_block *sb,
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
index 4dd9283..51dfd74 100644
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
index e851d5b..b086633 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -29,8 +29,12 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
+#include "cifs_unicode.h"
 #include "fscache.h"
-
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2glob.h"
+#include "smb2proto.h"
+#endif
 
 static void cifs_set_ops(struct inode *inode)
 {
@@ -268,7 +272,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
  * junction to the new submount (ie to setup the fake directory
  * which represents a DFS referral).
  */
-static void
+void
 cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -503,7 +507,7 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 }
 
 /* Fill a cifs_fattr struct with info from FILE_ALL_INFO */
-static void
+void
 cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 		       struct cifs_sb_info *cifs_sb, bool adjust_tz)
 {
@@ -595,14 +599,15 @@ cgfi_exit:
 	return rc;
 }
 
-int cifs_get_inode_info(struct inode **pinode,
-	const unsigned char *full_path, FILE_ALL_INFO *pfindData,
-	struct super_block *sb, int xid, const __u16 *pfid)
+static int
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
@@ -610,51 +615,54 @@ int cifs_get_inode_info(struct inode **pinode,
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
-		/* could do find first instead but this returns more info */
-		rc = CIFSSMBQPathInfo(xid, pTcon, full_path, pfindData,
-			      0 /* not legacy */,
-			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
-		/* BB optimize code so we do not make the above call
-		when server claims no NT SMB support and the above call
-		failed at least once - set flag in tcon or mount */
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
 		if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
-			rc = SMBQueryInformation(xid, pTcon, full_path,
-					pfindData, cifs_sb->local_nls,
+			rc = SMBQueryInformation(xid, tcon, full_path,
+					data, cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
-					  CIFS_MOUNT_MAP_SPECIAL_CHR);
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
 			adjustTZ = true;
 		}
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
@@ -678,7 +686,7 @@ int cifs_get_inode_info(struct inode **pinode,
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 			int rc1 = 0;
 
-			rc1 = CIFSGetSrvInodeNumber(xid, pTcon,
+			rc1 = CIFSGetSrvInodeNumber(xid, tcon,
 					full_path, &fattr.cf_uniqueid,
 					cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
@@ -707,11 +715,11 @@ int cifs_get_inode_info(struct inode **pinode,
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
@@ -735,12 +743,25 @@ int cifs_get_inode_info(struct inode **pinode,
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
@@ -1745,8 +1766,8 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
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
index 0000000..7d7387d
--- /dev/null
+++ b/fs/cifs/smb2dir.c
@@ -0,0 +1,53 @@
+/*
+ *   fs/cifs/smb2dir.c
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
+cifs_convert_path_to_utf16(const char *from, struct nls_table *local_nls)
+{
+	int len;
+	const char *start_of_path;
+	__le16 *to;
+
+	/* Windows doesn't allow paths beginning with \ */
+	if (from[0] == '\\')
+		start_of_path = from + 1;
+	else
+		start_of_path = from;
+	to = cifs_strndup_to_utf16(start_of_path, PATH_MAX, &len, local_nls);
+	return to;
+}
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
new file mode 100644
index 0000000..1db1196
--- /dev/null
+++ b/fs/cifs/smb2glob.h
@@ -0,0 +1,43 @@
+/*
+ *   fs/cifs/smb2glob.h
+ *
+ *   Definitions for various global variables and structures
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Jeremy Allison (jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
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
+ */
+#ifndef _SMB2_GLOB_H
+#define _SMB2_GLOB_H
+
+/*
+ *****************************************************************
+ * Constants go here
+ *****************************************************************
+ */
+
+/*
+ * Identifiers for functions that use the open, operation, close pattern
+ * in smb2inode.c:smb2_open_op_close()
+ */
+#define SMB2_OP_SET_DELETE 1
+#define SMB2_OP_SET_INFO 2
+#define SMB2_OP_QUERY_INFO 3
+#define SMB2_OP_QUERY_DIR 4
+#define SMB2_OP_MKDIR 5
+#define SMB2_OP_RENAME 6
+#define SMB2_OP_DELETE 7
+
+#endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
new file mode 100644
index 0000000..858f370
--- /dev/null
+++ b/fs/cifs/smb2inode.c
@@ -0,0 +1,182 @@
+/*
+ *   fs/cifs/smb2inode.c
+ *
+ *   Copyright (C) 2012
+ *   Author(s): Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org),
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
+		   __u32 desired_access, __u32 create_disposition,
+		   __u32 file_attributes, __u32 create_options,
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
+					(struct smb2_file_all_info *)data);
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
+move_smb2_info_to_cifs(FILE_ALL_INFO *dst, struct smb2_file_all_info *src)
+{
+	memcpy(dst, src, (size_t)(&src->CurrentByteOffset) - (size_t)src);
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
+	struct smb2_file_all_info *smb2_data;
+
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+			    GFP_KERNEL);
+	if (smb2_data == NULL)
+		return -ENOMEM;
+
+	smb2_path = cifs_convert_path_to_utf16(full_path, cifs_sb->local_nls);
+	if (smb2_path == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = smb2_open_op_close(xid, tcon, smb2_path, FILE_READ_ATTRIBUTES,
+				FILE_OPEN, 0, 0, smb2_data,
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
+int
+smb2_query_inode_info(struct inode **pinode, const char *full_path,
+		      FILE_ALL_INFO *data, struct super_block *sb, int xid)
+{
+	int rc = 0;
+	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	char *buf = NULL;
+	struct cifs_fattr fattr;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	cFYI(1, "Getting info on %s", full_path);
+
+	if ((data == NULL) && (*pinode != NULL)) {
+		if (CIFS_I(*pinode)->clientCanCacheRead) {
+			cFYI(1, "No need to revalidate cached inode sizes");
+			goto sqii_exit;
+		}
+	}
+
+	/* if file info not passed in then get it from server */
+	if (data == NULL) {
+		buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+		if (buf == NULL) {
+			rc = -ENOMEM;
+			goto sqii_exit;
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
+		goto sqii_exit;
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
+sqii_exit:
+	kfree(buf);
+	cifs_put_tlink(tlink);
+	return rc;
+}
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 16272e5..ad84694 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -238,8 +238,13 @@ char *smb2_get_data_area_len(int *poff, int *plen, struct smb2_hdr *pSMB2)
 		*plen = le32_to_cpu(
 		    ((struct smb2_create_rsp *)pSMB2)->CreateContextsLength);
 		break;
-	case SMB2_READ:
 	case SMB2_QUERY_INFO:
+		*poff = le16_to_cpu(
+		    ((struct smb2_query_info_rsp *)pSMB2)->OutputBufferOffset);
+		*plen = le32_to_cpu(
+		    ((struct smb2_query_info_rsp *)pSMB2)->OutputBufferLength);
+		break;
+	case SMB2_READ:
 	case SMB2_QUERY_DIRECTORY:
 	case SMB2_IOCTL:
 	case SMB2_CHANGE_NOTIFY:
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1e2cd95..e4b3b66 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1014,3 +1014,116 @@ close_exit:
 	free_rsp_buf(resp_buftype, pSMB2r);
 	return rc;
 }
+
+static int
+validate_buf(unsigned int offset, unsigned int buffer_length,
+	     struct smb2_hdr *hdr, unsigned int min_buf_size)
+
+{
+	unsigned int smb_len = be32_to_cpu(hdr->smb2_buf_length);
+	char *end_of_smb = smb_len + 4 /* RFC1001 length field */ + (char *)hdr;
+	char *begin_of_buf = 4 /* RFC1001 len field */ + offset + (char *)hdr;
+	char *end_of_buf = begin_of_buf + buffer_length;
+
+
+	if (buffer_length < min_buf_size) {
+		cERROR(1, "buffer length %d smaller than minimum size %d",
+			   buffer_length, min_buf_size);
+		return -EINVAL;
+	}
+
+	/* check if beyond RFC1001 maximum length */
+	if ((smb_len > 0x7FFFFF) || (buffer_length > 0x7FFFFF)) {
+		cERROR(1, "buffer length %d or smb length %d too large",
+			   buffer_length, smb_len);
+		return -EINVAL;
+	}
+
+	if ((begin_of_buf > end_of_smb) || (end_of_buf > end_of_smb)) {
+		cERROR(1, "illegal server response, bad offset to data");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * If SMB buffer fields valid, copy into temporary buffer to hold result
+ * Caller must free buffer
+ */
+static int
+validate_and_copy_buf(unsigned int offset, unsigned int buffer_length,
+		      struct smb2_hdr *hdr, unsigned int minbufsize,
+		      char *pdata)
+
+{
+	char *begin_of_buf = 4 /* RFC1001 len field */ + offset + (char *)hdr;
+	int rc;
+
+	if (!pdata)
+		return -EINVAL;
+
+	rc = validate_buf(offset, buffer_length, hdr, minbufsize);
+	if (rc)
+		return rc;
+
+	memcpy(pdata, begin_of_buf, buffer_length);
+
+	return 0;
+}
+
+int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
+		    u64 persistent_fid, u64 volatile_fid,
+		    struct smb2_file_all_info *data)
+{
+	struct smb2_query_info_req *pSMB2;
+	struct smb2_query_info_rsp *pSMB2r = NULL;
+	struct kvec iov[2];
+	int rc = 0;
+	int resp_buftype;
+	int status;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+
+	cFYI(1, "Query Info");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	pSMB2->InfoType = SMB2_O_INFO_FILE;
+	pSMB2->FileInfoClass = FILE_ALL_INFORMATION;
+	pSMB2->PersistentFileId = persistent_fid;
+	pSMB2->VolatileFileId = volatile_fid;
+	pSMB2->InputBufferOffset =
+		cpu_to_le16(sizeof(struct smb2_query_info_req) - 1 - 4);
+	pSMB2->OutputBufferLength =
+		cpu_to_le32(sizeof(struct smb2_file_all_info) + MAX_NAME * 2);
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4;
+
+	rc = smb2_sendrcv2(xid, ses, iov, 1, &resp_buftype /* ret */, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	cFYI(1, "qinfo buftype %d rc %d status %d", resp_buftype, rc, status);
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2QUERY_INFO);
+		goto qinf_exit;
+	}
+	pSMB2r = (struct smb2_query_info_rsp *)iov[0].iov_base;
+
+	rc = validate_and_copy_buf(le16_to_cpu(pSMB2r->OutputBufferOffset),
+				   le32_to_cpu(pSMB2r->OutputBufferLength),
+				   &pSMB2r->hdr,
+				   sizeof(struct smb2_file_all_info),
+				   (char *)data);
+
+qinf_exit:
+	free_rsp_buf(resp_buftype, iov[0].iov_base);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index a3a08bb..324b475 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -441,4 +441,115 @@ struct smb2_close_rsp {
 	__le32 Attributes;
 } __packed;
 
+/* Possible InfoType values */
+#define SMB2_O_INFO_FILE	0x01
+#define SMB2_O_INFO_FILESYSTEM	0x02
+#define SMB2_O_INFO_SECURITY	0x03
+#define SMB2_O_INFO_QUOTA	0x04
+
+struct smb2_query_info_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 41 */
+	__u8   InfoType;
+	__u8   FileInfoClass;
+	__le32 OutputBufferLength;
+	__le16 InputBufferOffset;
+	__u16  Reserved;
+	__le32 InputBufferLength;
+	__le32 AdditionalInformation;
+	__le32 Flags;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_query_info_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 9 */
+	__le16 OutputBufferOffset;
+	__le32 OutputBufferLength;
+	__u8   Buffer[1];
+} __packed;
+
+/*
+ *	PDU infolevel structure definitions
+ *	BB consider moving to a different header
+ */
+
+/* partial list of QUERY INFO levels */
+#define FILE_DIRECTORY_INFORMATION	1
+#define FILE_FULL_DIRECTORY_INFORMATION 2
+#define FILE_BOTH_DIRECTORY_INFORMATION 3
+#define FILE_BASIC_INFORMATION		4
+#define FILE_STANDARD_INFORMATION	5
+#define FILE_INTERNAL_INFORMATION	6
+#define FILE_EA_INFORMATION	        7
+#define FILE_ACCESS_INFORMATION		8
+#define FILE_NAME_INFORMATION		9
+#define FILE_RENAME_INFORMATION		10
+#define FILE_LINK_INFORMATION		11
+#define FILE_NAMES_INFORMATION		12
+#define FILE_DISPOSITION_INFORMATION	13
+#define FILE_POSITION_INFORMATION	14
+#define FILE_FULL_EA_INFORMATION	15
+#define FILE_MODE_INFORMATION		16
+#define FILE_ALIGNMENT_INFORMATION	17
+#define FILE_ALL_INFORMATION		18
+#define FILE_ALLOCATION_INFORMATION	19
+#define FILE_END_OF_FILE_INFORMATION	20
+#define FILE_ALTERNATE_NAME_INFORMATION 21
+#define FILE_STREAM_INFORMATION		22
+#define FILE_PIPE_INFORMATION		23
+#define FILE_PIPE_LOCAL_INFORMATION	24
+#define FILE_PIPE_REMOTE_INFORMATION	25
+#define FILE_MAILSLOT_QUERY_INFORMATION 26
+#define FILE_MAILSLOT_SET_INFORMATION	27
+#define FILE_COMPRESSION_INFORMATION	28
+#define FILE_OBJECT_ID_INFORMATION	29
+/* Number 30 not defined in documents */
+#define FILE_MOVE_CLUSTER_INFORMATION	31
+#define FILE_QUOTA_INFORMATION		32
+#define FILE_REPARSE_POINT_INFORMATION	33
+#define FILE_NETWORK_OPEN_INFORMATION	34
+#define FILE_ATTRIBUTE_TAG_INFORMATION	35
+#define FILE_TRACKING_INFORMATION	36
+#define FILEID_BOTH_DIRECTORY_INFORMATION 37
+#define FILEID_FULL_DIRECTORY_INFORMATION 38
+#define FILE_VALID_DATA_LENGTH_INFORMATION 39
+#define FILE_SHORT_NAME_INFORMATION	40
+#define FILE_SFIO_RESERVE_INFORMATION	44
+#define FILE_SFIO_VOLUME_INFORMATION	45
+#define FILE_HARD_LINK_INFORMATION	46
+#define FILE_NORMALIZED_NAME_INFORMATION 48
+#define FILEID_GLOBAL_TX_DIRECTORY_INFORMATION 50
+#define FILE_STANDARD_LINK_INFORMATION	54
+
+/*
+ * This level 18, although with struct with same name is different from cifs
+ * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
+ * CurrentByteOffset.
+ */
+struct smb2_file_all_info { /* data block encoding of response to level 18 */
+	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le32 Attributes;
+	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
+	__le64 AllocationSize;	/* Beginning of FILE_STANDARD_INFO equivalent */
+	__le64 EndOfFile;	/* size ie offset to first free byte in file */
+	__le32 NumberOfLinks;	/* hard links */
+	__u8   DeletePending;
+	__u8   Directory;
+	__u16  Pad2;		/* End of FILE_STANDARD_INFO equivalent */
+	__le64 IndexNumber;
+	__le32 EASize;
+	__le32 AccessFlags;
+	__le64 CurrentByteOffset;
+	__le32 Mode;
+	__le32 AlignmentRequirement;
+	__le32 FileNameLength;
+	char   FileName[1];
+} __packed; /* level 18 Query */
+
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 8393802..f4996e3 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -36,6 +36,8 @@ extern int checkSMB2(struct smb2_hdr *smb, __u64 mid, unsigned int length);
 extern unsigned int smb2_calc_size(struct smb2_hdr *pSMB2h);
 extern char *smb2_get_data_area_len(int *poff, int *plen,
 				     struct smb2_hdr *pSMB2);
+extern __le16 *cifs_convert_path_to_utf16(const char *from,
+					  struct nls_table *local_nls);
 
 extern int smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 			 struct kvec *vec, int nvec, int *ret_buf_type,
@@ -45,6 +47,10 @@ extern int smb2_sendrcv_norsp(const unsigned int xid, struct cifs_ses *ses,
 extern int smb2_setup_session(unsigned int xid, struct cifs_ses *psesinfo,
 			      struct nls_table *nls_info);
 
+extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
+				 FILE_ALL_INFO *data, struct super_block *sb,
+				 int xid);
+
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
  *  are contained within these calls
@@ -63,5 +69,8 @@ extern int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 		      __u32 file_attributes, __u32 create_options);
 extern int SMB2_close(const int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
+extern int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
+			   u64 persistent_file_id, u64 volatile_file_id,
+			   struct smb2_file_all_info *data);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
