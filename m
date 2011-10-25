From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 23/53] CIFS: Add SMB2 support for reopen file operation
Date: Tue, 25 Oct 2011 10:11:56 +0400
Message-ID: <1319523146-2859-24-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/cifsglob.h  |    4 ++
 fs/cifs/file.c      |  146 +++++++++++++++++++++++++++++++-------------------
 fs/cifs/smb2file.c  |   54 +++++++++++++++++++
 fs/cifs/smb2proto.h |    4 +-
 4 files changed, 151 insertions(+), 57 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e6ea8de..82e40b2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -596,6 +596,10 @@ struct cifsFileInfo {
 	struct work_struct oplock_break; /* work for oplock breaks */
 };
 
+typedef int (reopen_callback_t)(struct cifsFileInfo *cifs_file, int xid,
+				 struct cifs_tcon *tcon, const char *full_path,
+				 __u32 *oplock);
+
 struct cifs_io_parms {
 	__u16 netfid;
 	__u32 pid;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 37c8445..508ec3a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -484,53 +484,26 @@ static int cifs_relock_file(struct cifsFileInfo *cifsFile)
 	return rc;
 }
 
-static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
+static int
+cifs_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
+		    struct cifs_tcon *tcon, const char *full_path,
+		    __u32 *oplock)
 {
 	int rc = -EACCES;
-	int xid;
-	__u32 oplock;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
-	struct cifsInodeInfo *pCifsInode;
 	struct inode *inode;
-	char *full_path = NULL;
-	int desiredAccess;
+	int desired_access;
 	int disposition = FILE_OPEN;
 	int create_options = CREATE_NOT_DIR;
 	__u16 netfid;
 
-	xid = GetXid();
-	mutex_lock(&pCifsFile->fh_mutex);
-	if (!pCifsFile->invalidHandle) {
-		mutex_unlock(&pCifsFile->fh_mutex);
-		rc = 0;
-		FreeXid(xid);
-		return rc;
-	}
-
-	inode = pCifsFile->dentry->d_inode;
+	inode = cifs_file->dentry->d_inode;
 	cifs_sb = CIFS_SB(inode->i_sb);
-	tcon = tlink_tcon(pCifsFile->tlink);
-
-/* can not grab rename sem here because various ops, including
-   those that already have the rename sem can end up causing writepage
-   to get called and if the server was down that means we end up here,
-   and we can never tell if the caller already has the rename_sem */
-	full_path = build_path_from_dentry(pCifsFile->dentry);
-	if (full_path == NULL) {
-		rc = -ENOMEM;
-		mutex_unlock(&pCifsFile->fh_mutex);
-		FreeXid(xid);
-		return rc;
-	}
-
-	cFYI(1, "inode = 0x%p file flags 0x%x for %s",
-		 inode, pCifsFile->f_flags, full_path);
 
 	if (enable_oplocks)
-		oplock = REQ_OPLOCK;
+		*oplock = REQ_OPLOCK;
 	else
-		oplock = 0;
+		*oplock = 0;
 
 	if (tcon->unix_ext && (tcon->ses->capabilities & CAP_UNIX) &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
@@ -540,21 +513,23 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 		 * O_CREAT, O_EXCL and O_TRUNC already had their effect on the
 		 * original open. Must mask them off for a reopen.
 		 */
-		unsigned int oflags = pCifsFile->f_flags &
-						~(O_CREAT | O_EXCL | O_TRUNC);
+		unsigned int oflags = cifs_file->f_flags &
+				      ~(O_CREAT | O_EXCL | O_TRUNC);
 
 		rc = cifs_posix_open(full_path, NULL, inode->i_sb,
-				cifs_sb->mnt_file_mode /* ignored */,
-				oflags, &oplock, &netfid, xid);
+				     cifs_sb->mnt_file_mode /* ignored */,
+				     oflags, oplock, &netfid, xid);
 		if (rc == 0) {
 			cFYI(1, "posix reopen succeeded");
 			goto reopen_success;
 		}
-		/* fallthrough to retry open the old way on errors, especially
-		   in the reconnect path it is important to retry hard */
+		/*
+		 * fallthrough to retry open the old way on errors, especially
+		 * in the reconnect path it is important to retry hard.
+		 */
 	}
 
-	desiredAccess = cifs_convert_flags(pCifsFile->f_flags);
+	desired_access = cifs_convert_flags(cifs_file->f_flags);
 
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
@@ -565,30 +540,78 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 	   and server version of file size can be stale. If we knew for sure
 	   that inode was not dirty locally we could do this */
 
-	rc = CIFSSMBOpen(xid, tcon, full_path, disposition, desiredAccess,
-			 create_options, &netfid, &oplock, NULL,
+	rc = CIFSSMBOpen(xid, tcon, full_path, disposition, desired_access,
+			 create_options, &netfid, oplock, NULL,
 			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
-		mutex_unlock(&pCifsFile->fh_mutex);
 		cFYI(1, "cifs_open returned 0x%x", rc);
-		cFYI(1, "oplock: %d", oplock);
+		cFYI(1, "oplock: %d", *oplock);
 		goto reopen_error_exit;
 	}
 
 reopen_success:
-	pCifsFile->netfid = netfid;
-	pCifsFile->invalidHandle = false;
-	mutex_unlock(&pCifsFile->fh_mutex);
-	pCifsInode = CIFS_I(inode);
+	cifs_file->netfid = netfid;
+reopen_error_exit:
+	return rc;
+}
+
+static int
+cifs_reopen_file_generic(struct cifsFileInfo *cifs_file, bool can_flush,
+			 reopen_callback_t *reopen_cb)
+{
+	int rc = -EACCES;
+	int xid;
+	__u32 oplock;
+	struct cifs_sb_info *cifs_sb;
+	struct cifs_tcon *tcon;
+	struct inode *inode;
+	struct cifsInodeInfo *cifs_inode;
+	char *full_path = NULL;
+
+	xid = GetXid();
+	mutex_lock(&cifs_file->fh_mutex);
+	if (!cifs_file->invalidHandle) {
+		mutex_unlock(&cifs_file->fh_mutex);
+		rc = 0;
+		FreeXid(xid);
+		return rc;
+	}
+
+	inode = cifs_file->dentry->d_inode;
+	cifs_sb = CIFS_SB(inode->i_sb);
+	tcon = tlink_tcon(cifs_file->tlink);
+
+	/*
+	 * Can not grab rename sem here because various ops, including
+	 * those that already have the rename sem can end up causing writepage
+	 * to get called and if the server was down that means we end up here,
+	 * and we can never tell if the caller already has the rename_sem.
+	 */
+	full_path = build_path_from_dentry(cifs_file->dentry);
+	if (full_path == NULL) {
+		rc = -ENOMEM;
+		mutex_unlock(&cifs_file->fh_mutex);
+		FreeXid(xid);
+		return rc;
+	}
+
+	cFYI(1, "inode = 0x%p file flags 0x%x for %s", inode,
+	     cifs_file->f_flags, full_path);
+
+	rc = reopen_cb(cifs_file, xid, tcon, full_path, &oplock);
+	mutex_unlock(&cifs_file->fh_mutex);
+	if (rc)
+		goto out;
+	cifs_inode = CIFS_I(inode);
 
 	if (can_flush) {
 		rc = filemap_write_and_wait(inode->i_mapping);
 		mapping_set_error(inode->i_mapping, rc);
 
 		if (tcon->unix_ext)
-			rc = cifs_get_inode_info_unix(&inode,
-				full_path, inode->i_sb, xid);
+			rc = cifs_get_inode_info_unix(&inode, full_path,
+						      inode->i_sb, xid);
 		else
 			rc = cifs_get_inode_info(&inode, full_path, NULL,
 						 inode->i_sb, xid, NULL);
@@ -599,16 +622,27 @@ reopen_success:
 	     we can not go to the server to get the new inod
 	     info */
 
-	cifs_set_oplock_level(pCifsInode, oplock);
+	cifs_set_oplock_level(cifs_inode, oplock);
+	cifs_relock_file(cifs_file);
+	cifs_file->invalidHandle = false;
 
-	cifs_relock_file(pCifsFile);
-
-reopen_error_exit:
+out:
 	kfree(full_path);
 	FreeXid(xid);
 	return rc;
 }
 
+static int cifs_reopen_file(struct cifsFileInfo *cifs_file, bool can_flush)
+{
+#ifdef CONFIG_CIFS_SMB2
+	if (tlink_tcon(cifs_file->tlink)->ses->server->is_smb2)
+		return cifs_reopen_file_generic(cifs_file, can_flush,
+						smb2_reopen_file_cb);
+#endif
+	return cifs_reopen_file_generic(cifs_file, can_flush,
+					cifs_reopen_file_cb);
+}
+
 int cifs_close(struct inode *inode, struct file *file)
 {
 	if (file->private_data != NULL) {
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 8cb6fd9..eb25167 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -272,3 +272,57 @@ out:
 	cifs_put_tlink(tlink);
 	return rc;
 }
+
+int
+smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
+		    struct cifs_tcon *tcon, const char *full_path,
+		    __u32 *oplock)
+{
+	int rc = -EACCES;
+	struct cifs_sb_info *cifs_sb;
+	struct inode *inode;
+	__le32 desired_access;
+	__le32 create_disposition = FILE_OPEN_LE;
+	__le16 *smb2_path = NULL;
+	__u64 persist_fid, volatile_fid;
+
+	inode = cifs_file->dentry->d_inode;
+	cifs_sb = CIFS_SB(inode->i_sb);
+
+	if (oplockEnabled)
+		*oplock = REQ_OPLOCK;
+	else
+		*oplock = 0;
+
+	desired_access = cpu_to_le32(cifs_convert_flags(cifs_file->f_flags));
+
+	/*
+	 * Can not refresh inode by passing in file_info buf to be returned
+	 * by SMB2_open and then calling get_inode_info with returned buf
+	 * since file might have write behind data that needs to be flushed
+	 * and server version of file size can be stale. If we knew for sure
+	 * that inode was not dirty locally we could do this.
+	 */
+
+	smb2_path = cifs_convert_path_to_ucs(full_path, cifs_sb->local_nls);
+	if (smb2_path == NULL) {
+		rc = -ENOMEM;
+		goto reopen_error_exit;
+	}
+
+	rc = SMB2_open(xid, tcon, smb2_path, &persist_fid, &volatile_fid,
+		       desired_access, create_disposition, 0, 0);
+	if (rc) {
+		mutex_unlock(&cifs_file->fh_mutex);
+		cFYI(1, "cifs_open returned 0x%x", rc);
+		cFYI(1, "oplock: %d", *oplock);
+		goto reopen_error_exit;
+	}
+
+	cifs_file->persist_fid = persist_fid;
+	cifs_file->volatile_fid = volatile_fid;
+	*oplock = 0;
+reopen_error_exit:
+	kfree(smb2_path);
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 5a10108..6dbc432 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -113,9 +113,11 @@ extern struct cifsFileInfo *smb2_new_fileinfo(__u64 persist_fid,
 					      struct file *file,
 					      struct tcon_link *tlink,
 					      __u32 oplock);
+extern int smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
+			       struct cifs_tcon *tcon, const char *full_path,
+			       __u32 *oplock);
 
 extern int smb2_open(struct inode *inode, struct file *file);
-
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
 extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
-- 
1.7.1
