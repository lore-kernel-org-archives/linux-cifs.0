From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] Rename clone_range to copychunk_range
Date: Fri, 10 Feb 2017 16:03:50 +0530
Message-ID: <20170210103351.10163-2-sprabhu@redhat.com>
References: <20170210103351.10163-1-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210103351.10163-1-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Renaming calls to reflect the underlying smb2 ioctl called. This is
similar to the name duplicate_extents used for a similar ioctl which is
also used to duplicate files by reusing fs blocks. The name change is to
avoid confusion.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |  3 ++-
 fs/cifs/ioctl.c    | 16 ++++++++--------
 fs/cifs/smb2ops.c  | 12 ++++++------
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7ea8a33..f9376db 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -405,7 +405,8 @@ struct smb_version_operations {
 	char * (*create_lease_buf)(u8 *, u8);
 	/* parse lease context buffer and return oplock/epoch info */
 	__u8 (*parse_lease_buf)(void *, unsigned int *);
-	int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
+	int (*copychunk_range)(const unsigned int,
+			struct cifsFileInfo *src_file,
 			struct cifsFileInfo *target_file, u64 src_off, u64 len,
 			u64 dest_off);
 	int (*duplicate_extents)(const unsigned int, struct cifsFileInfo *src,
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 0015287..9bf0f94 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -34,7 +34,7 @@
 #include "cifs_ioctl.h"
 #include <linux/btrfs.h>
 
-static int cifs_file_clone_range(unsigned int xid, struct file *src_file,
+static int cifs_file_copychunk_range(unsigned int xid, struct file *src_file,
 			  struct file *dst_file)
 {
 	struct inode *src_inode = file_inode(src_file);
@@ -45,7 +45,7 @@ static int cifs_file_clone_range(unsigned int xid, struct file *src_file,
 	struct cifs_tcon *target_tcon;
 	int rc;
 
-	cifs_dbg(FYI, "ioctl clone range\n");
+	cifs_dbg(FYI, "ioctl copychunk range\n");
 
 	if (!src_file->private_data || !dst_file->private_data) {
 		rc = -EBADF;
@@ -75,8 +75,8 @@ static int cifs_file_clone_range(unsigned int xid, struct file *src_file,
 	/* should we flush first and last page first */
 	truncate_inode_pages(&target_inode->i_data, 0);
 
-	if (target_tcon->ses->server->ops->clone_range)
-		rc = target_tcon->ses->server->ops->clone_range(xid,
+	if (target_tcon->ses->server->ops->copychunk_range)
+		rc = target_tcon->ses->server->ops->copychunk_range(xid,
 			smb_file_src, smb_file_target, 0, src_inode->i_size, 0);
 	else
 		rc = -EOPNOTSUPP;
@@ -91,14 +91,14 @@ static int cifs_file_clone_range(unsigned int xid, struct file *src_file,
 	return rc;
 }
 
-static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
+static long cifs_ioctl_copychunk(unsigned int xid, struct file *dst_file,
 			unsigned long srcfd)
 {
 	int rc;
 	struct fd src_file;
 	struct inode *src_inode;
 
-	cifs_dbg(FYI, "ioctl clone range\n");
+	cifs_dbg(FYI, "ioctl copychunk range\n");
 	/* the destination must be opened for writing */
 	if (!(dst_file->f_mode & FMODE_WRITE)) {
 		cifs_dbg(FYI, "file target not open for write\n");
@@ -129,7 +129,7 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
 	if (S_ISDIR(src_inode->i_mode))
 		goto out_fput;
 
-	rc = cifs_file_clone_range(xid, src_file.file, dst_file);
+	rc = cifs_file_copychunk_range(xid, src_file.file, dst_file);
 
 out_fput:
 	fdput(src_file);
@@ -251,7 +251,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			}
 			break;
 		case CIFS_IOC_COPYCHUNK_FILE:
-			rc = cifs_ioctl_clone(xid, filep, arg);
+			rc = cifs_ioctl_copychunk(xid, filep, arg);
 			break;
 		case CIFS_IOC_SET_INTEGRITY:
 			if (pSMBFile == NULL)
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5d456eb..3dfd925 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -587,7 +587,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 static int
-smb2_clone_range(const unsigned int xid,
+smb2_copychunk_range(const unsigned int xid,
 			struct cifsFileInfo *srcfile,
 			struct cifsFileInfo *trgtfile, u64 src_off,
 			u64 len, u64 dest_off)
@@ -605,7 +605,7 @@ smb2_clone_range(const unsigned int xid,
 	if (pcchunk == NULL)
 		return -ENOMEM;
 
-	cifs_dbg(FYI, "in smb2_clone_range - about to call request res key\n");
+	cifs_dbg(FYI, "in smb2_copychunk_range - about to call request res key\n");
 	/* Request a key from the server to identify the source of the copy */
 	rc = SMB2_request_res_key(xid, tlink_tcon(srcfile->tlink),
 				srcfile->fid.persistent_fid,
@@ -1620,7 +1620,7 @@ struct smb_version_operations smb20_operations = {
 	.set_oplock_level = smb2_set_oplock_level,
 	.create_lease_buf = smb2_create_lease_buf,
 	.parse_lease_buf = smb2_parse_lease_buf,
-	.clone_range = smb2_clone_range,
+	.copychunk_range = smb2_copychunk_range,
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
 };
@@ -1700,7 +1700,7 @@ struct smb_version_operations smb21_operations = {
 	.set_oplock_level = smb21_set_oplock_level,
 	.create_lease_buf = smb2_create_lease_buf,
 	.parse_lease_buf = smb2_parse_lease_buf,
-	.clone_range = smb2_clone_range,
+	.copychunk_range = smb2_copychunk_range,
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
 	.enum_snapshots = smb3_enum_snapshots,
@@ -1784,7 +1784,7 @@ struct smb_version_operations smb30_operations = {
 	.set_oplock_level = smb3_set_oplock_level,
 	.create_lease_buf = smb3_create_lease_buf,
 	.parse_lease_buf = smb3_parse_lease_buf,
-	.clone_range = smb2_clone_range,
+	.copychunk_range = smb2_copychunk_range,
 	.duplicate_extents = smb2_duplicate_extents,
 	.validate_negotiate = smb3_validate_negotiate,
 	.wp_retry_size = smb2_wp_retry_size,
@@ -1872,7 +1872,7 @@ struct smb_version_operations smb311_operations = {
 	.set_oplock_level = smb3_set_oplock_level,
 	.create_lease_buf = smb3_create_lease_buf,
 	.parse_lease_buf = smb3_parse_lease_buf,
-	.clone_range = smb2_clone_range,
+	.copychunk_range = smb2_copychunk_range,
 	.duplicate_extents = smb2_duplicate_extents,
 /*	.validate_negotiate = smb3_validate_negotiate, */ /* not used in 3.11 */
 	.wp_retry_size = smb2_wp_retry_size,
-- 
2.9.3
