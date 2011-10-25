From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 35/53] CIFS: Add SMB2 support for create operation
Date: Tue, 25 Oct 2011 10:12:08 +0400
Message-ID: <1319523146-2859-36-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/smb2inode.c |  184 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2proto.h |    2 +
 2 files changed, 185 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index e023fb0..a47544e 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -23,6 +23,8 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/namei.h>
+#include <linux/file.h>
 #include <asm/div64.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
@@ -36,7 +38,7 @@
 #include "smb2proto.h"
 
 const struct inode_operations smb2_dir_inode_ops = {
-	.create = cifs_create,
+	.create = smb2_create,
 	.lookup = cifs_lookup,
 	.getattr = cifs_getattr,
 	.unlink = smb2_unlink,
@@ -569,3 +571,183 @@ unlink_out:
 	cifs_put_tlink(tlink);
 	return rc;
 }
+
+static int
+smb2_create_helper(struct inode *dir, struct dentry *direntry, int mode,
+		   struct nameidata *nd, __u32 *oplock, __u64 *persist_fid,
+		   __u64 *volatile_fid, int xid, struct cifs_tcon *tcon,
+		   const char *full_path, void *data)
+{
+	int rc;
+	__le32 desired_access;
+	__le32 create_disposition;
+	__le32 create_options = cpu_to_le32(CREATE_NOT_DIR);
+	__le32 oflags;
+	__le16 *smb2_path;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dir->i_sb);
+	FILE_ALL_INFO_SMB2 *smb2_data;
+
+	if (nd) {
+		/* if the file is going to stay open, then we
+		   need to set the desired access properly */
+		oflags = nd->intent.open.file->f_flags;
+
+		/* read attributes access to get attributes of inode */
+		desired_access = FILE_READ_ATTRIBUTES_LE;
+		if (OPEN_FMODE(oflags) & FMODE_READ)
+			/* is this too little?*/
+			desired_access |= cpu_to_le32(GENERIC_READ);
+		if (OPEN_FMODE(oflags) & FMODE_WRITE)
+			desired_access |= cpu_to_le32(GENERIC_WRITE);
+
+		if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+			create_disposition = FILE_CREATE_LE;
+		else if ((oflags & (O_CREAT | O_TRUNC)) == (O_CREAT | O_TRUNC))
+			create_disposition = FILE_OVERWRITE_IF_LE;
+		else if ((oflags & O_CREAT) == O_CREAT)
+			create_disposition = FILE_OPEN_IF_LE;
+		else
+			cFYI(1, "Create flag not set in create function");
+	} else {
+		desired_access = cpu_to_le32(GENERIC_READ | GENERIC_WRITE);
+		create_disposition = FILE_OVERWRITE_IF_LE;
+	}
+	/* BB pass O_SYNC flag through on file attributes .. BB */
+
+	smb2_path = cifs_convert_path_to_ucs(full_path, cifs_sb->local_nls);
+	if (smb2_path == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = SMB2_open(xid, tcon, smb2_path, persist_fid, volatile_fid,
+		       desired_access, create_disposition, 0, create_options);
+	if (rc)
+		goto out;
+
+	smb2_data = kzalloc(sizeof(FILE_ALL_INFO_SMB2) + MAX_NAME*2,
+			    GFP_KERNEL);
+	if (smb2_data == NULL) {
+		rc = -ENOMEM;
+		SMB2_close(xid, tcon, *persist_fid, *volatile_fid);
+		goto out;
+	}
+
+	rc = SMB2_query_info(xid, tcon, *persist_fid, *volatile_fid, smb2_data);
+	if (rc) {
+		SMB2_close(xid, tcon, *persist_fid, *volatile_fid);
+		goto out;
+	}
+
+	move_smb2_info_to_cifs(data, smb2_data);
+
+out:
+	*oplock = 0;
+	kfree(smb2_data);
+	kfree(smb2_path);
+	return rc;
+}
+
+int
+smb2_create(struct inode *dir, struct dentry *direntry, int mode,
+	    struct nameidata *nd)
+{
+	int rc = -ENOENT;
+	int xid;
+	__u32 oplock = 0;
+	/*
+	 * BB below access is probably too much for mknod to request
+	 *    but we have to do query and setpathinfo so requesting
+	 *    less could fail (unless we want to request getatr and setatr
+	 *    permissions (only).  At least for POSIX we do not have to
+	 *    request so much.
+	 */
+	__u64 persist_fid, volatile_fid;
+	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct inode *newinode = NULL;
+	FILE_ALL_INFO *buf;
+	char *full_path;
+
+	xid = GetXid();
+
+	cifs_sb = CIFS_SB(dir->i_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		FreeXid(xid);
+		return PTR_ERR(tlink);
+	}
+	tcon = tlink_tcon(tlink);
+
+	if (oplockEnabled)
+		oplock = REQ_OPLOCK;
+
+	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	full_path = build_path_from_dentry(direntry);
+	if (full_path == NULL) {
+		rc = -ENOMEM;
+		goto smb2_create_out;
+	}
+
+	rc = smb2_create_helper(dir, direntry, mode, nd, &oplock, &persist_fid,
+				&volatile_fid, xid, tcon, full_path, buf);
+	if (rc) {
+		cFYI(1, "smb2_create returned 0x%x", rc);
+		goto smb2_create_out;
+	}
+
+	rc = smb2_query_inode_info(&newinode, full_path, buf, dir->i_sb, xid);
+	if (rc) {
+		cFYI(1, "Create worked, get_inode_info failed rc = %d", rc);
+		SMB2_close(xid, tcon, persist_fid, volatile_fid);
+		goto smb2_create_out;
+	}
+
+	if (newinode) {
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+			newinode->i_mode = mode;
+		if ((oplock & CIFS_CREATE_ACTION) &&
+		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)) {
+			newinode->i_uid = current_fsuid();
+			if (dir->i_mode & S_ISGID)
+				newinode->i_gid = dir->i_gid;
+			else
+				newinode->i_gid = current_fsgid();
+		}
+	}
+
+	d_instantiate(direntry, newinode);
+
+	if (newinode && nd) {
+		struct cifsFileInfo *file_info;
+		struct file *filp;
+
+		filp = lookup_instantiate_filp(nd, direntry, generic_file_open);
+		if (IS_ERR(filp)) {
+			rc = PTR_ERR(filp);
+			SMB2_close(xid, tcon, persist_fid, volatile_fid);
+			goto smb2_create_out;
+		}
+
+		file_info = smb2_new_fileinfo(persist_fid, volatile_fid,
+					      filp, tlink, oplock);
+		if (file_info == NULL) {
+			fput(filp);
+			SMB2_close(xid, tcon, persist_fid, volatile_fid);
+			rc = -ENOMEM;
+		}
+	} else {
+		SMB2_close(xid, tcon, persist_fid, volatile_fid);
+	}
+
+smb2_create_out:
+	kfree(buf);
+	kfree(full_path);
+	cifs_put_tlink(tlink);
+	FreeXid(xid);
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index c3c8b57..d846117 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -149,6 +149,8 @@ extern int smb2_writepages(struct address_space *mapping,
 extern int smb2_readpages(struct file *file, struct address_space *mapping,
 			  struct list_head *page_list, unsigned num_pages);
 
+extern int smb2_create(struct inode *dir, struct dentry *direntry, int mode,
+		       struct nameidata *nd);
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
 extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
-- 
1.7.1
