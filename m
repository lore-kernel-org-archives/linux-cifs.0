From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 19/50] CIFS: Add SMB2 support for mkdir operation
Date: Fri, 20 Jan 2012 12:34:40 +0400
Message-ID: <1327048511-2342-19-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    3 ++
 fs/cifs/smb2inode.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2proto.h |    1 +
 3 files changed, 103 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4869540..5881760 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -49,6 +49,9 @@
 #include "cifs_spnego.h"
 #include "fscache.h"
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 int cifsFYI = 0;
 int cifsERROR = 1;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index c7462ac..9c634f0 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -41,7 +41,7 @@ const struct inode_operations smb2_dir_inode_ops = {
 	.getattr = cifs_getattr,
 	.unlink = cifs_unlink,
 	.link = cifs_hardlink,
-	.mkdir = cifs_mkdir,
+	.mkdir = smb2_mkdir,
 	.rmdir = cifs_rmdir,
 	.rename = cifs_rename,
 	.permission = cifs_permission,
@@ -283,3 +283,101 @@ sqii_exit:
 	cifs_put_tlink(tlink);
 	return rc;
 }
+
+int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode)
+{
+	int rc = 0, tmprc;
+	int xid;
+	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct inode *newinode = NULL;
+	__le16 *utf16_path = NULL;
+	char *full_path = NULL;
+
+	cFYI(1, "%s: mode = 0x%x inode = 0x%p", __func__, mode, inode);
+
+	cifs_sb = CIFS_SB(inode->i_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	xid = GetXid();
+
+	full_path = build_path_from_dentry(direntry);
+	if (full_path == NULL) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb->local_nls);
+	if (utf16_path == NULL) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	rc = smb2_open_op_close(xid, tcon, utf16_path, FILE_WRITE_ATTRIBUTES,
+				FILE_CREATE, 0, CREATE_NOT_FILE, NULL,
+				SMB2_OP_MKDIR);
+	if (rc)
+		goto err_out;
+
+	inc_nlink(inode);
+
+	rc = cifs_get_inode_info(&newinode, full_path, NULL, inode->i_sb, xid,
+				 NULL);
+
+	d_instantiate(direntry, newinode);
+	 /*
+	  * setting nlink not necessary except in cases where we
+	  * failed to get it from the server or was set bogus
+	  */
+	if ((direntry->d_inode) && (direntry->d_inode->i_nlink < 2))
+		set_nlink(inode, 2);
+
+	mode &= ~current_umask();
+	/* must turn on setgid bit if parent dir has it */
+	if (inode->i_mode & S_ISGID)
+		mode |= S_ISGID;
+
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
+	    (mode & S_IWUGO) == 0) {
+		FILE_BASIC_INFO data;
+		struct cifsInodeInfo *cifs_i;
+		u32 dosattrs;
+		memset(&data, 0, sizeof(data));
+		cifs_i = CIFS_I(newinode);
+		dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
+		data.Attributes = cpu_to_le32(dosattrs);
+		tmprc = smb2_open_op_close(xid, tcon, utf16_path,
+					   FILE_WRITE_ATTRIBUTES,
+					   FILE_CREATE, 0,
+					   CREATE_NOT_FILE, &data,
+					   SMB2_OP_SET_INFO);
+		if (tmprc == 0)
+			cifs_i->cifsAttrs = dosattrs;
+	}
+
+	if (direntry->d_inode) {
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+			direntry->d_inode->i_mode = (mode | S_IFDIR);
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+			direntry->d_inode->i_uid = current_fsuid();
+			if (inode->i_mode & S_ISGID)
+				direntry->d_inode->i_gid = inode->i_gid;
+			else
+				direntry->d_inode->i_gid = current_fsgid();
+		}
+	}
+
+out:
+	kfree(utf16_path);
+	FreeXid(xid);
+	cifs_put_tlink(tlink);
+	return rc;
+err_out:
+	cFYI(1, "%s returned 0x%x", __func__, rc);
+	d_drop(direntry);
+	goto out;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 8e98cf6..52eea64 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -57,6 +57,7 @@ extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
 				 FILE_ALL_INFO *data, struct super_block *sb,
 				 int xid);
 extern void smb2_set_ops(struct inode *inode);
+extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
-- 
1.7.1
