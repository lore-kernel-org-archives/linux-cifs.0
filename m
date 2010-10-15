From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/13] cifs: clean up cifs_reopen_file
Date: Fri, 15 Oct 2010 15:33:59 -0400
Message-ID: <1287171248-464-5-git-send-email-jlayton@redhat.com>
References: <1287171248-464-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287171248-464-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add a f_flags field that holds the f_flags field from the filp. We'll
need this info in case the filp ever goes away before the cifsFileInfo
does. Have cifs_reopen_file use that value instead of filp->f_flags
too and have it take a cifsFileInfo arg instead of a filp.

While we're at it, get rid of some bogus cargo-cult NULL pointer
checks in that function and reduce the level of indentation.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Acked-by: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/dir.c      |    1 +
 fs/cifs/file.c     |  129 ++++++++++++++++++++++------------------------------
 3 files changed, 57 insertions(+), 74 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9fc77a4..2eb054b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -390,6 +390,7 @@ struct cifsFileInfo {
 	/* lock scope id (0 if none) */
 	struct file *pfile; /* needed for writepage */
 	struct dentry *dentry;
+	unsigned int f_flags;
 	struct tcon_link *tlink;
 	struct mutex lock_mutex;
 	struct list_head llist; /* list of byte range locks we have. */
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 36cf3e2..3c23d88 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -147,6 +147,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	pCifsFile->pid = current->tgid;
 	pCifsFile->uid = current_fsuid();
 	pCifsFile->dentry = dget(dentry);
+	pCifsFile->f_flags = file->f_flags;
 	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
 	pCifsFile->closePend = false;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 394cf28..dd922a5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -412,14 +412,13 @@ static int cifs_relock_file(struct cifsFileInfo *cifsFile)
 	return rc;
 }
 
-static int cifs_reopen_file(struct file *file, bool can_flush)
+static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 {
 	int rc = -EACCES;
 	int xid;
 	__u32 oplock;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *tcon;
-	struct cifsFileInfo *pCifsFile;
 	struct cifsInodeInfo *pCifsInode;
 	struct inode *inode;
 	char *full_path = NULL;
@@ -427,11 +426,6 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 	int disposition = FILE_OPEN;
 	__u16 netfid;
 
-	if (file->private_data)
-		pCifsFile = file->private_data;
-	else
-		return -EBADF;
-
 	xid = GetXid();
 	mutex_lock(&pCifsFile->fh_mutex);
 	if (!pCifsFile->invalidHandle) {
@@ -441,21 +435,7 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 		return rc;
 	}
 
-	if (file->f_path.dentry == NULL) {
-		cERROR(1, "no valid name if dentry freed");
-		dump_stack();
-		rc = -EBADF;
-		goto reopen_error_exit;
-	}
-
-	inode = file->f_path.dentry->d_inode;
-	if (inode == NULL) {
-		cERROR(1, "inode not valid");
-		dump_stack();
-		rc = -EBADF;
-		goto reopen_error_exit;
-	}
-
+	inode = pCifsFile->dentry->d_inode;
 	cifs_sb = CIFS_SB(inode->i_sb);
 	tcon = tlink_tcon(pCifsFile->tlink);
 
@@ -463,17 +443,16 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
    those that already have the rename sem can end up causing writepage
    to get called and if the server was down that means we end up here,
    and we can never tell if the caller already has the rename_sem */
-	full_path = build_path_from_dentry(file->f_path.dentry);
+	full_path = build_path_from_dentry(pCifsFile->dentry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-reopen_error_exit:
 		mutex_unlock(&pCifsFile->fh_mutex);
 		FreeXid(xid);
 		return rc;
 	}
 
 	cFYI(1, "inode = 0x%p file flags 0x%x for %s",
-		 inode, file->f_flags, full_path);
+		 inode, pCifsFile->f_flags, full_path);
 
 	if (oplockEnabled)
 		oplock = REQ_OPLOCK;
@@ -488,7 +467,8 @@ reopen_error_exit:
 		 * O_CREAT, O_EXCL and O_TRUNC already had their effect on the
 		 * original open. Must mask them off for a reopen.
 		 */
-		unsigned int oflags = file->f_flags & ~(O_CREAT|O_EXCL|O_TRUNC);
+		unsigned int oflags = pCifsFile->f_flags &
+						~(O_CREAT | O_EXCL | O_TRUNC);
 
 		rc = cifs_posix_open(full_path, NULL, inode->i_sb,
 				cifs_sb->mnt_file_mode /* ignored */,
@@ -501,7 +481,7 @@ reopen_error_exit:
 		   in the reconnect path it is important to retry hard */
 	}
 
-	desiredAccess = cifs_convert_flags(file->f_flags);
+	desiredAccess = cifs_convert_flags(pCifsFile->f_flags);
 
 	/* Can not refresh inode by passing in file_info buf to be returned
 	   by SMBOpen and then calling get_inode_info with returned buf
@@ -517,49 +497,50 @@ reopen_error_exit:
 		mutex_unlock(&pCifsFile->fh_mutex);
 		cFYI(1, "cifs_open returned 0x%x", rc);
 		cFYI(1, "oplock: %d", oplock);
-	} else {
+		goto reopen_error_exit;
+	}
+
 reopen_success:
-		pCifsFile->netfid = netfid;
-		pCifsFile->invalidHandle = false;
-		mutex_unlock(&pCifsFile->fh_mutex);
-		pCifsInode = CIFS_I(inode);
-		if (pCifsInode) {
-			if (can_flush) {
-				rc = filemap_write_and_wait(inode->i_mapping);
-				if (rc != 0)
-					CIFS_I(inode)->write_behind_rc = rc;
-			/* temporarily disable caching while we
-			   go to server to get inode info */
-				pCifsInode->clientCanCacheAll = false;
-				pCifsInode->clientCanCacheRead = false;
-				if (tcon->unix_ext)
-					rc = cifs_get_inode_info_unix(&inode,
-						full_path, inode->i_sb, xid);
-				else
-					rc = cifs_get_inode_info(&inode,
-						full_path, NULL, inode->i_sb,
-						xid, NULL);
-			} /* else we are writing out data to server already
-			     and could deadlock if we tried to flush data, and
-			     since we do not know if we have data that would
-			     invalidate the current end of file on the server
-			     we can not go to the server to get the new inod
-			     info */
-			if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
-				pCifsInode->clientCanCacheAll = true;
-				pCifsInode->clientCanCacheRead = true;
-				cFYI(1, "Exclusive Oplock granted on inode %p",
-					 file->f_path.dentry->d_inode);
-			} else if ((oplock & 0xF) == OPLOCK_READ) {
-				pCifsInode->clientCanCacheRead = true;
-				pCifsInode->clientCanCacheAll = false;
-			} else {
-				pCifsInode->clientCanCacheRead = false;
-				pCifsInode->clientCanCacheAll = false;
-			}
-			cifs_relock_file(pCifsFile);
-		}
+	pCifsFile->netfid = netfid;
+	pCifsFile->invalidHandle = false;
+	mutex_unlock(&pCifsFile->fh_mutex);
+	pCifsInode = CIFS_I(inode);
+
+	if (can_flush) {
+		rc = filemap_write_and_wait(inode->i_mapping);
+		if (rc != 0)
+			CIFS_I(inode)->write_behind_rc = rc;
+
+		pCifsInode->clientCanCacheAll = false;
+		pCifsInode->clientCanCacheRead = false;
+		if (tcon->unix_ext)
+			rc = cifs_get_inode_info_unix(&inode,
+				full_path, inode->i_sb, xid);
+		else
+			rc = cifs_get_inode_info(&inode,
+				full_path, NULL, inode->i_sb,
+				xid, NULL);
+	} /* else we are writing out data to server already
+	     and could deadlock if we tried to flush data, and
+	     since we do not know if we have data that would
+	     invalidate the current end of file on the server
+	     we can not go to the server to get the new inod
+	     info */
+	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
+		pCifsInode->clientCanCacheAll = true;
+		pCifsInode->clientCanCacheRead = true;
+		cFYI(1, "Exclusive Oplock granted on inode %p",
+			 pCifsFile->dentry->d_inode);
+	} else if ((oplock & 0xF) == OPLOCK_READ) {
+		pCifsInode->clientCanCacheRead = true;
+		pCifsInode->clientCanCacheAll = false;
+	} else {
+		pCifsInode->clientCanCacheRead = false;
+		pCifsInode->clientCanCacheAll = false;
 	}
+	cifs_relock_file(pCifsFile);
+
+reopen_error_exit:
 	kfree(full_path);
 	FreeXid(xid);
 	return rc;
@@ -998,7 +979,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 				   filemap_fdatawait from here so tell
 				   reopen_file not to flush data to server
 				   now */
-				rc = cifs_reopen_file(file, false);
+				rc = cifs_reopen_file(open_file, false);
 				if (rc != 0)
 					break;
 			}
@@ -1096,7 +1077,7 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 				   filemap_fdatawait from here so tell
 				   reopen_file not to flush data to
 				   server now */
-				rc = cifs_reopen_file(file, false);
+				rc = cifs_reopen_file(open_file, false);
 				if (rc != 0)
 					break;
 			}
@@ -1244,7 +1225,7 @@ refind_writable:
 
 			read_unlock(&GlobalSMBSeslock);
 			/* Had to unlock since following call can block */
-			rc = cifs_reopen_file(open_file->pfile, false);
+			rc = cifs_reopen_file(open_file, false);
 			if (!rc) {
 				if (!open_file->closePend)
 					return open_file;
@@ -1792,7 +1773,7 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 			int buf_type = CIFS_NO_BUFFER;
 			if ((open_file->invalidHandle) &&
 			    (!open_file->closePend)) {
-				rc = cifs_reopen_file(file, true);
+				rc = cifs_reopen_file(open_file, true);
 				if (rc != 0)
 					break;
 			}
@@ -1878,7 +1859,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 		while (rc == -EAGAIN) {
 			if ((open_file->invalidHandle) &&
 			    (!open_file->closePend)) {
-				rc = cifs_reopen_file(file, true);
+				rc = cifs_reopen_file(open_file, true);
 				if (rc != 0)
 					break;
 			}
@@ -2043,7 +2024,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		while (rc == -EAGAIN) {
 			if ((open_file->invalidHandle) &&
 			    (!open_file->closePend)) {
-				rc = cifs_reopen_file(file, true);
+				rc = cifs_reopen_file(open_file, true);
 				if (rc != 0)
 					break;
 			}
-- 
1.7.2.3
