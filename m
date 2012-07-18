From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 17/45] CIFS: Move reopen code to ops struct
Date: Wed, 18 Jul 2012 19:48:33 +0400
Message-ID: <1342626541-29872-18-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c |  123 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 65 insertions(+), 58 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e11a58a..e8cca00 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -450,59 +450,66 @@ out:
 	return rc;
 }
 
-/* Try to reacquire byte range locks that were released when session */
-/* to server was lost */
+/*
+ * Try to reacquire byte range locks that were released when session
+ * to server was lost
+ */
 static int cifs_relock_file(struct cifsFileInfo *cifsFile)
 {
 	int rc = 0;
 
-/* BB list all locks open on this file and relock */
+	/* BB list all locks open on this file and relock */
 
 	return rc;
 }
 
-static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
+static int
+cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 {
 	int rc = -EACCES;
 	unsigned int xid;
 	__u32 oplock;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
-	struct cifsInodeInfo *pCifsInode;
+	struct TCP_Server_Info *server;
+	struct cifsInodeInfo *cinode;
 	struct inode *inode;
 	char *full_path = NULL;
-	int desiredAccess;
+	int desired_access;
 	int disposition = FILE_OPEN;
 	int create_options = CREATE_NOT_DIR;
-	__u16 netfid;
+	struct cifs_fid fid;
 
 	xid = get_xid();
-	mutex_lock(&pCifsFile->fh_mutex);
-	if (!pCifsFile->invalidHandle) {
-		mutex_unlock(&pCifsFile->fh_mutex);
+	mutex_lock(&cfile->fh_mutex);
+	if (!cfile->invalidHandle) {
+		mutex_unlock(&cfile->fh_mutex);
 		rc = 0;
 		free_xid(xid);
 		return rc;
 	}
 
-	inode = pCifsFile->dentry->d_inode;
+	inode = cfile->dentry->d_inode;
 	cifs_sb = CIFS_SB(inode->i_sb);
-	tcon = tlink_tcon(pCifsFile->tlink);
+	tcon = tlink_tcon(cfile->tlink);
+	server = tcon->ses->server;
 
-/* can not grab rename sem here because various ops, including
-   those that already have the rename sem can end up causing writepage
-   to get called and if the server was down that means we end up here,
-   and we can never tell if the caller already has the rename_sem */
-	full_path = build_path_from_dentry(pCifsFile->dentry);
+	/*
+	 * Can not grab rename sem here because various ops, including those
+	 * that already have the rename sem can end up causing writepage to get
+	 * called and if the server was down that means we end up here, and we
+	 * can never tell if the caller already has the rename_sem.
+	 */
+	full_path = build_path_from_dentry(cfile->dentry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		mutex_unlock(&pCifsFile->fh_mutex);
+		mutex_unlock(&cfile->fh_mutex);
 		free_xid(xid);
 		return rc;
 	}
 
-	cFYI(1, "inode = 0x%p file flags 0x%x for %s",
-		 inode, pCifsFile->f_flags, full_path);
+	cFYI(1, "inode = 0x%p file flags 0x%x for %s", inode, cfile->f_flags,
+	     full_path);
 
 	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;
@@ -516,69 +523,69 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 		 * O_CREAT, O_EXCL and O_TRUNC already had their effect on the
 		 * original open. Must mask them off for a reopen.
 		 */
-		unsigned int oflags = pCifsFile->f_flags &
+		unsigned int oflags = cfile->f_flags &
 						~(O_CREAT | O_EXCL | O_TRUNC);
 
 		rc = cifs_posix_open(full_path, NULL, inode->i_sb,
-				cifs_sb->mnt_file_mode /* ignored */,
-				oflags, &oplock, &netfid, xid);
+				     cifs_sb->mnt_file_mode /* ignored */,
+				     oflags, &oplock, &fid.netfid, xid);
 		if (rc == 0) {
 			cFYI(1, "posix reopen succeeded");
 			goto reopen_success;
 		}
-		/* fallthrough to retry open the old way on errors, especially
-		   in the reconnect path it is important to retry hard */
+		/*
+		 * fallthrough to retry open the old way on errors, especially
+		 * in the reconnect path it is important to retry hard
+		 */
 	}
 
-	desiredAccess = cifs_convert_flags(pCifsFile->f_flags);
+	desired_access = cifs_convert_flags(cfile->f_flags);
 
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
-	/* Can not refresh inode by passing in file_info buf to be returned
-	   by SMBOpen and then calling get_inode_info with returned buf
-	   since file might have write behind data that needs to be flushed
-	   and server version of file size can be stale. If we knew for sure
-	   that inode was not dirty locally we could do this */
-
-	rc = CIFSSMBOpen(xid, tcon, full_path, disposition, desiredAccess,
-			 create_options, &netfid, &oplock, NULL,
-			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+	/*
+	 * Can not refresh inode by passing in file_info buf to be returned by
+	 * CIFSSMBOpen and then calling get_inode_info with returned buf since
+	 * file might have write behind data that needs to be flushed and server
+	 * version of file size can be stale. If we knew for sure that inode was
+	 * not dirty locally we could do this.
+	 */
+	rc = server->ops->open(xid, tcon, full_path, disposition,
+			       desired_access, create_options, &fid, &oplock,
+			       NULL, cifs_sb);
 	if (rc) {
-		mutex_unlock(&pCifsFile->fh_mutex);
-		cFYI(1, "cifs_open returned 0x%x", rc);
+		mutex_unlock(&cfile->fh_mutex);
+		cFYI(1, "cifs_reopen returned 0x%x", rc);
 		cFYI(1, "oplock: %d", oplock);
 		goto reopen_error_exit;
 	}
 
 reopen_success:
-	pCifsFile->fid.netfid = netfid;
-	pCifsFile->invalidHandle = false;
-	mutex_unlock(&pCifsFile->fh_mutex);
-	pCifsInode = CIFS_I(inode);
+	cfile->invalidHandle = false;
+	mutex_unlock(&cfile->fh_mutex);
+	cinode = CIFS_I(inode);
 
 	if (can_flush) {
 		rc = filemap_write_and_wait(inode->i_mapping);
 		mapping_set_error(inode->i_mapping, rc);
 
 		if (tcon->unix_ext)
-			rc = cifs_get_inode_info_unix(&inode,
-				full_path, inode->i_sb, xid);
+			rc = cifs_get_inode_info_unix(&inode, full_path,
+						      inode->i_sb, xid);
 		else
-			rc = cifs_get_inode_info(&inode,
-				full_path, NULL, inode->i_sb,
-				xid, NULL);
-	} /* else we are writing out data to server already
-	     and could deadlock if we tried to flush data, and
-	     since we do not know if we have data that would
-	     invalidate the current end of file on the server
-	     we can not go to the server to get the new inod
-	     info */
-
-	cifs_set_oplock_level(pCifsInode, oplock);
-
-	cifs_relock_file(pCifsFile);
+			rc = cifs_get_inode_info(&inode, full_path, NULL,
+						 inode->i_sb, xid, NULL);
+	}
+	/*
+	 * Else we are writing out data to server already and could deadlock if
+	 * we tried to flush data, and since we do not know if we have data that
+	 * would invalidate the current end of file on the server we can not go
+	 * to the server to get the new inode info.
+	 */
+
+	server->ops->set_fid(cfile, &fid, oplock);
+	cifs_relock_file(cfile);
 
 reopen_error_exit:
 	kfree(full_path);
-- 
1.7.1
