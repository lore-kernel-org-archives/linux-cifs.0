From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 42/53] CIFS: Process oplocks for SMB2
Date: Tue, 25 Oct 2011 10:12:15 +0400
Message-ID: <1319523146-2859-43-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/cifsproto.h   |    3 +--
 fs/cifs/connect.c     |    4 +++-
 fs/cifs/file.c        |   15 ++++++---------
 fs/cifs/smb2file.c    |   39 +++++++++++++++++++++++++++------------
 fs/cifs/smb2inode.c   |   15 +++++++--------
 fs/cifs/smb2pdu.c     |    9 +++++----
 fs/cifs/smb2proto.h   |    9 +++++----
 fs/cifs/smb2readdir.c |    4 +++-
 8 files changed, 57 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e99db0a..2df7074 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -131,8 +131,7 @@ extern struct cifsFileInfo *cifs_new_fileinfo(__u16 netfid, struct file *file,
 					      struct tcon_link *tlink,
 					      __u32 oplock);
 extern struct cifsFileInfo *cifs_new_fileinfo_generic(struct file *file,
-						      struct tcon_link *tlink,
-						      __u32 oplock);
+						      struct tcon_link *tlink);
 extern int cifs_posix_open(const char *full_path, struct inode **pinode,
 			   struct super_block *sb, int mode,
 			   unsigned int f_flags, __u32 *poplock, __u16 *pnetfid,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b3f2e13..f8d5023 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3176,9 +3176,11 @@ is_path_accessible(int xid, struct cifs_tcon *tcon,
 #ifdef CONFIG_CIFS_SMB2
 	if (tcon->ses->server->is_smb2) {
 		__u64 persistent_fid, volatile_fid;
+		__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+
 		rc = SMB2_open(xid, tcon, (__le16 *)full_path, &persistent_fid,
 			       &volatile_fid, FILE_READ_ATTRIBUTES, FILE_OPEN,
-			       0, 0);
+			       0, 0, &oplock);
 		if (rc)
 			return rc;
 		/* rc = SMB2_query_info() */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 2c9471c..09655f7 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -249,17 +249,19 @@ cifs_new_fileinfo(__u16 netfid, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
 {
 	struct cifsFileInfo *cifs_file;
+	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
 
-	cifs_file = cifs_new_fileinfo_generic(file, tlink, oplock);
+	cifs_file = cifs_new_fileinfo_generic(file, tlink);
 	if (cifs_file == NULL)
 		return NULL;
 	cifs_file->netfid = netfid;
+	cifs_set_oplock_level(cinode, oplock);
+	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
 	return cifs_file;
 }
 
 struct cifsFileInfo *
-cifs_new_fileinfo_generic(struct file *file, struct tcon_link *tlink,
-			  __u32 oplock)
+cifs_new_fileinfo_generic(struct file *file, struct tcon_link *tlink)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
@@ -289,9 +291,6 @@ cifs_new_fileinfo_generic(struct file *file, struct tcon_link *tlink,
 		list_add_tail(&pCifsFile->flist, &pCifsInode->openFileList);
 	spin_unlock(&cifs_file_list_lock);
 
-	cifs_set_oplock_level(pCifsInode, oplock);
-	pCifsInode->can_cache_brlcks = pCifsInode->clientCanCacheAll;
-
 	file->private_data = pCifsFile;
 	return pCifsFile;
 }
@@ -552,6 +551,7 @@ cifs_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 
 reopen_success:
 	cifs_file->netfid = netfid;
+	cifs_set_oplock_level(CIFS_I(inode), *oplock);
 reopen_error_exit:
 	return rc;
 }
@@ -566,7 +566,6 @@ cifs_reopen_file_generic(struct cifsFileInfo *cifs_file, bool can_flush,
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
 	struct inode *inode;
-	struct cifsInodeInfo *cifs_inode;
 	char *full_path = NULL;
 
 	xid = GetXid();
@@ -603,7 +602,6 @@ cifs_reopen_file_generic(struct cifsFileInfo *cifs_file, bool can_flush,
 	mutex_unlock(&cifs_file->fh_mutex);
 	if (rc)
 		goto out;
-	cifs_inode = CIFS_I(inode);
 
 	if (can_flush) {
 		rc = filemap_write_and_wait(inode->i_mapping);
@@ -622,7 +620,6 @@ cifs_reopen_file_generic(struct cifsFileInfo *cifs_file, bool can_flush,
 	     we can not go to the server to get the new inod
 	     info */
 
-	cifs_set_oplock_level(cifs_inode, oplock);
 	cifs_relock_file(cifs_file);
 	cifs_file->invalidHandle = false;
 
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 318e4b9..5454137 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -178,17 +178,37 @@ const struct address_space_operations smb2_addr_ops_smallbuf = {
 	.launder_page = cifs_launder_page,
 };
 
+static void
+smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u8 oplock)
+{
+	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
+		cinode->clientCanCacheAll = true;
+		cinode->clientCanCacheRead = true;
+		cFYI(1, "Exclusive Oplock granted on inode %p",
+		     &cinode->vfs_inode);
+	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
+		cinode->clientCanCacheAll = false;
+		cinode->clientCanCacheRead = true;
+		cFYI(1, "Level II Oplock granted on inode %p",
+		    &cinode->vfs_inode);
+	} else {
+		cinode->clientCanCacheAll = false;
+		cinode->clientCanCacheRead = false;
+	}
+}
+
 struct cifsFileInfo *
 smb2_new_fileinfo(__u64 persist_fid, __u64 volatile_fid, struct file *file,
-		  struct tcon_link *tlink, __u32 oplock)
+		  struct tcon_link *tlink, __u8 oplock)
 {
 	struct cifsFileInfo *cifs_file;
 
-	cifs_file = cifs_new_fileinfo_generic(file, tlink, oplock);
+	cifs_file = cifs_new_fileinfo_generic(file, tlink);
 	if (cifs_file == NULL)
 		return NULL;
 	cifs_file->persist_fid = persist_fid;
 	cifs_file->volatile_fid = volatile_fid;
+	smb2_set_oplock_level(CIFS_I(file->f_path.dentry->d_inode), oplock);
 	return cifs_file;
 }
 
@@ -220,9 +240,9 @@ smb2_open_helper(struct file *file, struct inode *inode, const char *full_path,
 		goto out;
 	}
 
+	*oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
 	rc = SMB2_open(xid, tcon, smb2_path, persist_fid, volatile_fid,
-		       desired_access, create_disposition, 0, 0);
-
+		       desired_access, create_disposition, 0, 0, oplock);
 	if (rc)
 		goto out;
 
@@ -234,7 +254,6 @@ smb2_open_helper(struct file *file, struct inode *inode, const char *full_path,
 
 	move_smb2_info_to_cifs(data, smb2_data);
 out:
-	*oplock = 0;
 	kfree(smb2_data);
 	kfree(smb2_path);
 	return rc;
@@ -319,11 +338,6 @@ smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 	inode = cifs_file->dentry->d_inode;
 	cifs_sb = CIFS_SB(inode->i_sb);
 
-	if (oplockEnabled)
-		*oplock = REQ_OPLOCK;
-	else
-		*oplock = 0;
-
 	desired_access = cpu_to_le32(cifs_convert_flags(cifs_file->f_flags));
 
 	/*
@@ -340,8 +354,9 @@ smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 		goto reopen_error_exit;
 	}
 
+	*oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
 	rc = SMB2_open(xid, tcon, smb2_path, &persist_fid, &volatile_fid,
-		       desired_access, create_disposition, 0, 0);
+		       desired_access, create_disposition, 0, 0, (u8 *)oplock);
 	if (rc) {
 		mutex_unlock(&cifs_file->fh_mutex);
 		cFYI(1, "cifs_open returned 0x%x", rc);
@@ -351,7 +366,7 @@ smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 
 	cifs_file->persist_fid = persist_fid;
 	cifs_file->volatile_fid = volatile_fid;
-	*oplock = 0;
+	smb2_set_oplock_level(CIFS_I(inode), *oplock);
 reopen_error_exit:
 	kfree(smb2_path);
 	return rc;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index a5948b9..650a530 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -148,10 +148,11 @@ smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
 {
 	int rc, tmprc = 0;
 	u64 persist_fid, volatile_fid;
+	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 
 	rc = SMB2_open(xid, tcon, path, &persist_fid, &volatile_fid,
 		       desired_access, create_disposition, file_attributes,
-		       create_options);
+		       create_options, &oplock);
 	if (rc)
 		return rc;
 
@@ -582,7 +583,7 @@ unlink_out:
 
 static int
 smb2_create_helper(struct inode *dir, struct dentry *direntry, int mode,
-		   struct nameidata *nd, __u32 *oplock, __u64 *persist_fid,
+		   struct nameidata *nd, __u8 *oplock, __u64 *persist_fid,
 		   __u64 *volatile_fid, int xid, struct cifs_tcon *tcon,
 		   const char *full_path, void *data)
 {
@@ -628,8 +629,10 @@ smb2_create_helper(struct inode *dir, struct dentry *direntry, int mode,
 		goto out;
 	}
 
+	*oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
 	rc = SMB2_open(xid, tcon, smb2_path, persist_fid, volatile_fid,
-		       desired_access, create_disposition, 0, create_options);
+		       desired_access, create_disposition, 0, create_options,
+		       oplock);
 	if (rc)
 		goto out;
 
@@ -650,7 +653,6 @@ smb2_create_helper(struct inode *dir, struct dentry *direntry, int mode,
 	move_smb2_info_to_cifs(data, smb2_data);
 
 out:
-	*oplock = 0;
 	kfree(smb2_data);
 	kfree(smb2_path);
 	return rc;
@@ -662,7 +664,7 @@ smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 {
 	int rc = -ENOENT;
 	int xid;
-	__u32 oplock = 0;
+	__u8 oplock = 0;
 	/*
 	 * BB below access is probably too much for mknod to request
 	 *    but we have to do query and setpathinfo so requesting
@@ -688,9 +690,6 @@ smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 	}
 	tcon = tlink_tcon(tlink);
 
-	if (oplockEnabled)
-		oplock = REQ_OPLOCK;
-
 	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 353bd30..e2dccb8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1047,7 +1047,7 @@ int SMB2_tdis(const int xid, struct cifs_tcon *tcon)
 int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	      u64 *persistent_fid, u64 *volatile_fid, __le32 desired_access,
 	      __le32 create_disposition, __le32 file_attributes,
-	      __le32 create_options)
+	      __le32 create_options, u8 *oplock)
 {
 	struct create_req *pSMB2;
 	struct create_rsp *pSMB2r;
@@ -1071,9 +1071,9 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	if (rc)
 		return rc;
 
-	/* if (enable_oplocks)
-		pSMB2->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_BATCH;
-	else */
+	if (enable_oplocks)
+		pSMB2->RequestedOplockLevel = *oplock;
+	else
 		pSMB2->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
 	pSMB2->ImpersonationLevel = IL_IMPERSONATION;
 	pSMB2->DesiredAccess = desired_access;
@@ -1123,6 +1123,7 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	}
 	*persistent_fid = pSMB2r->PersistentFileId;
 	*volatile_fid = pSMB2r->VolatileFileId;
+	*oplock = pSMB2r->OplockLevel;
 creat_exit:
 	free_rsp_buf(resp_buftype, pSMB2r);
 	return rc;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 73aab65..1f8dc9a 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -128,7 +128,7 @@ extern struct cifsFileInfo *smb2_new_fileinfo(__u64 persist_fid,
 					      __u64 volatile_fid,
 					      struct file *file,
 					      struct tcon_link *tlink,
-					      __u32 oplock);
+					      __u8 oplock);
 extern int smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 			       struct cifs_tcon *tcon, const char *full_path,
 			       __u32 *oplock);
@@ -217,9 +217,10 @@ extern int SMB2_set_hardlink(const int xid, struct cifs_tcon *tcon,
 extern int SMB2_rename(const int xid, struct cifs_tcon *tcon,
 		    u64 persistent_fid, u64 volatile_fid, __le16 *target_file);
 extern int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
-	      u64 *persistent_fid, u64 *volatile_fid, __le32 desired_access,
-	      __le32 create_disposition, __le32 file_attributes,
-	      __le32 create_options);
+		      u64 *persistent_fid, u64 *volatile_fid,
+		      __le32 desired_access, __le32 create_disposition,
+		      __le32 file_attributes, __le32 create_options,
+		      u8 *oplock);
 extern int SMB2_symlink_ioctl(const int, struct cifs_tcon *, u32, u64, u64,
 				const char *);
 extern int SMB2_close(const int xid, struct cifs_tcon *tcon,
diff --git a/fs/cifs/smb2readdir.c b/fs/cifs/smb2readdir.c
index 02be0f9..7d80e8b 100644
--- a/fs/cifs/smb2readdir.c
+++ b/fs/cifs/smb2readdir.c
@@ -398,6 +398,7 @@ static int initiate_smb2_search(const int xid, struct file *file)
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
 	u64 persistent_fid, volatile_fid;
+	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 
 	smb2_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	tlink = cifs_sb_tlink(smb2_sb);
@@ -413,7 +414,8 @@ static int initiate_smb2_search(const int xid, struct file *file)
 
 	cifs_dump_mem("about to search on name: ", full_path, 4);
 	rc = SMB2_open(xid, tcon, full_path, &persistent_fid, &volatile_fid,
-			FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0);
+			FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0,
+			&oplock);
 	if (rc) {
 		cERROR(1, "open of dir failed before readdir with rc = %d", rc);
 		goto initiate_search_exit;
-- 
1.7.1
