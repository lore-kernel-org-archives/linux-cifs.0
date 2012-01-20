From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 41/50] CIFS: Process oplocks for SMB2
Date: Fri, 20 Jan 2012 12:35:02 +0400
Message-ID: <1327048511-2342-41-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/cifsproto.h   |    2 +-
 fs/cifs/connect.c     |   19 ++++++++++++++++++-
 fs/cifs/file.c        |   14 ++++++--------
 fs/cifs/nterr.h       |    1 +
 fs/cifs/smb2file.c    |   35 ++++++++++++++++++++++++++++-------
 fs/cifs/smb2inode.c   |   12 +++++++-----
 fs/cifs/smb2pdu.c     |    9 +++++----
 fs/cifs/smb2proto.h   |    5 +++--
 fs/cifs/smb2readdir.c |    4 +++-
 9 files changed, 72 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1a32f98..dae5043 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -137,7 +137,7 @@ extern struct cifsFileInfo *cifs_new_fileinfo(__u16 netfid, struct file *file,
 					      __u32 oplock);
 extern void cifs_new_fileinfo_generic(struct file *file,
 				      struct cifsFileInfo *cfile,
-				      struct tcon_link *tlink, __u32 oplock);
+				      struct tcon_link *tlink);
 extern int cifs_posix_open(const char *full_path, struct inode **pinode,
 			   struct super_block *sb, int mode,
 			   unsigned int f_flags, __u32 *poplock, __u16 *pnetfid,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 86f13a3..d544676 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -850,6 +850,21 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
+#ifdef CONFIG_CIFS_SMB2
+	/*
+	* If we negotiate SMB2 protocol and get STATUS_PENDING - update
+	* the number of credits and skip it.
+	*/
+	if (server->is_smb2 &&
+			le32_to_cpu(smb2_buffer->Status) == STATUS_PENDING) {
+		if (!length)
+			atomic_add(le16_to_cpu(smb2_buffer->CreditRequest),
+				   &server->credits);
+		cFYI(1, "STATUS_PENDING received");
+		return -1;
+	}
+#endif
+
 	if (mid)
 		handle_mid(mid, server, buf, length);
 
@@ -3188,9 +3203,11 @@ is_path_accessible(int xid, struct cifs_tcon *tcon,
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
index c2e108b..3937d51 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -249,18 +249,21 @@ cifs_new_fileinfo(__u16 netfid, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
 {
 	struct cifsFileInfo *cfile;
+	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
 
 	cfile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
 	if (cfile == NULL)
 		return cfile;
 	cfile->netfid = netfid;
-	cifs_new_fileinfo_generic(file, cfile, tlink, oplock);
+	cifs_new_fileinfo_generic(file, cfile, tlink);
+	cifs_set_oplock_level(cinode, oplock);
+	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
 	return cfile;
 }
 
 void
 cifs_new_fileinfo_generic(struct file *file, struct cifsFileInfo *cfile,
-			  struct tcon_link *tlink, __u32 oplock)
+			  struct tcon_link *tlink)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
@@ -285,9 +288,6 @@ cifs_new_fileinfo_generic(struct file *file, struct cifsFileInfo *cfile,
 		list_add_tail(&cfile->flist, &cinode->openFileList);
 	spin_unlock(&cifs_file_list_lock);
 
-	cifs_set_oplock_level(cinode, oplock);
-	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
-
 	file->private_data = cfile;
 }
 
@@ -547,6 +547,7 @@ cifs_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 
 reopen_success:
 	cifs_file->netfid = netfid;
+	cifs_set_oplock_level(CIFS_I(inode), *oplock);
 reopen_error_exit:
 	return rc;
 }
@@ -561,7 +562,6 @@ cifs_reopen_file_generic(struct cifsFileInfo *cifs_file, bool can_flush,
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
 	struct inode *inode;
-	struct cifsInodeInfo *cifs_inode;
 	char *full_path = NULL;
 
 	xid = GetXid();
@@ -598,7 +598,6 @@ cifs_reopen_file_generic(struct cifsFileInfo *cifs_file, bool can_flush,
 	mutex_unlock(&cifs_file->fh_mutex);
 	if (rc)
 		goto out;
-	cifs_inode = CIFS_I(inode);
 
 	if (can_flush) {
 		rc = filemap_write_and_wait(inode->i_mapping);
@@ -617,7 +616,6 @@ cifs_reopen_file_generic(struct cifsFileInfo *cifs_file, bool can_flush,
 	     we can not go to the server to get the new inod
 	     info */
 
-	cifs_set_oplock_level(cifs_inode, oplock);
 	cifs_relock_file(cifs_file);
 	cifs_file->invalidHandle = false;
 
diff --git a/fs/cifs/nterr.h b/fs/cifs/nterr.h
index 2572673..942b75c 100644
--- a/fs/cifs/nterr.h
+++ b/fs/cifs/nterr.h
@@ -40,6 +40,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define ERROR_INSUFFICIENT_BUFFER	  0x007a
 #define STATUS_1804	                  0x070c
 #define STATUS_NOTIFY_ENUM_DIR            0x010c
+#define STATUS_PENDING			  0x0103
 
 /* Win32 Error codes extracted using a loop in smbclient then printing a
    netmon sniff to a file. */
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 2d5e2db..5b2c6c0 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -177,9 +177,28 @@ const struct address_space_operations smb2_addr_ops_smallbuf = {
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
 	struct cifsFileInfo *cfile;
 
@@ -188,7 +207,8 @@ smb2_new_fileinfo(__u64 persist_fid, __u64 volatile_fid, struct file *file,
 		return cfile;
 	cfile->persist_fid = persist_fid;
 	cfile->volatile_fid = volatile_fid;
-	cifs_new_fileinfo_generic(file, cfile, tlink, oplock);
+	cifs_new_fileinfo_generic(file, cfile, tlink);
+	smb2_set_oplock_level(CIFS_I(file->f_path.dentry->d_inode), oplock);
 	return cfile;
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
@@ -335,8 +354,10 @@ smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 		goto reopen_error_exit;
 	}
 
+	*oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
 	rc = SMB2_open(xid, tcon, smb2_path, &persist_fid, &volatile_fid,
-		       desired_access, create_disposition, 0, 0);
+		       desired_access, create_disposition, 0, 0,
+		       (__u8 *)oplock);
 	if (rc) {
 		mutex_unlock(&cifs_file->fh_mutex);
 		cFYI(1, "cifs_open returned 0x%x", rc);
@@ -346,7 +367,7 @@ smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 
 	cifs_file->persist_fid = persist_fid;
 	cifs_file->volatile_fid = volatile_fid;
-	*oplock = 0;
+	smb2_set_oplock_level(CIFS_I(inode), *oplock);
 reopen_error_exit:
 	kfree(smb2_path);
 	return rc;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 31285b5..b3de208 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -148,10 +148,11 @@ smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *srch_path,
 {
 	int rc, tmprc = 0;
 	u64 persist_fid, volatile_fid;
+	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 
 	rc = SMB2_open(xid, tcon, srch_path, &persist_fid, &volatile_fid,
 		       desired_access, create_disposition, file_attributes,
-		       create_options);
+		       create_options, &oplock);
 	if (rc)
 		return rc;
 
@@ -561,7 +562,7 @@ unlink_out:
 
 static int
 smb2_create_helper(struct inode *dir, struct dentry *direntry, int mode,
-		   struct nameidata *nd, __u32 *oplock, __u64 *persist_fid,
+		   struct nameidata *nd, __u8 *oplock, __u64 *persist_fid,
 		   __u64 *volatile_fid, int xid, struct cifs_tcon *tcon,
 		   const char *full_path, void *data)
 {
@@ -609,8 +610,10 @@ smb2_create_helper(struct inode *dir, struct dentry *direntry, int mode,
 		goto out;
 	}
 
+	*oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
 	rc = SMB2_open(xid, tcon, smb2_path, persist_fid, volatile_fid,
-		       desired_access, create_disposition, 0, create_options);
+		       desired_access, create_disposition, 0, create_options,
+		       oplock);
 	if (rc)
 		goto out;
 
@@ -631,7 +634,6 @@ smb2_create_helper(struct inode *dir, struct dentry *direntry, int mode,
 	move_smb2_info_to_cifs(data, smb2_data);
 
 out:
-	*oplock = 0;
 	kfree(smb2_data);
 	kfree(smb2_path);
 	return rc;
@@ -643,7 +645,7 @@ smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 {
 	int rc = -ENOENT;
 	int xid;
-	__u32 oplock = 0;
+	__u8 oplock = 0;
 	/*
 	 * BB below access is probably too much for mknod to request
 	 *    but we have to do query and setpathinfo so requesting
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 31e735f..30dc552 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -881,7 +881,7 @@ int SMB2_tdis(const int xid, struct cifs_tcon *tcon)
 int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	      u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
 	      __u32 create_disposition, __u32 file_attributes,
-	      __u32 create_options)
+	      __u32 create_options, __u8 *oplock)
 {
 	struct smb2_create_req *pSMB2;
 	struct smb2_create_rsp *pSMB2r;
@@ -905,9 +905,9 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
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
 	pSMB2->DesiredAccess = cpu_to_le32(desired_access);
@@ -958,6 +958,7 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	}
 	*persistent_fid = pSMB2r->PersistentFileId;
 	*volatile_fid = pSMB2r->VolatileFileId;
+	*oplock = pSMB2r->OplockLevel;
 creat_exit:
 	free_rsp_buf(resp_buftype, pSMB2r);
 	return rc;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index baf46d3..df44cf2 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -99,7 +99,7 @@ extern struct cifsFileInfo *smb2_new_fileinfo(__u64 persist_fid,
 					      __u64 volatile_fid,
 					      struct file *file,
 					      struct tcon_link *tlink,
-					      __u32 oplock);
+					      __u8 oplock);
 extern int smb2_open(struct inode *inode, struct file *file);
 extern int smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 			       struct cifs_tcon *tcon, const char *full_path,
@@ -140,7 +140,8 @@ extern int SMB2_tdis(const int xid, struct cifs_tcon *tcon);
 extern int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 		      u64 *persistent_fid, u64 *volatile_fid,
 		      __u32 desired_access, __u32 create_disposition,
-		      __u32 file_attributes, __u32 create_options);
+		      __u32 file_attributes, __u32 create_options,
+		      __u8 *oplock);
 extern int SMB2_close(const int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
 extern int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
diff --git a/fs/cifs/smb2readdir.c b/fs/cifs/smb2readdir.c
index a9b489f..ce4b5cd 100644
--- a/fs/cifs/smb2readdir.c
+++ b/fs/cifs/smb2readdir.c
@@ -87,6 +87,7 @@ static int smb2_initiate_search(const int xid, struct file *file)
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
 	u64 persistent_fid, volatile_fid;
+	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 
 	smb2_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	tlink = cifs_sb_tlink(smb2_sb);
@@ -101,7 +102,8 @@ static int smb2_initiate_search(const int xid, struct file *file)
 		return -ENOMEM;
 
 	rc = SMB2_open(xid, tcon, full_path, &persistent_fid, &volatile_fid,
-		       FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0);
+		       FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0,
+		       &oplock);
 	if (rc) {
 		cERROR(1, "open of dir failed before readdir with rc = %d", rc);
 		goto initiate_search_exit;
-- 
1.7.1
