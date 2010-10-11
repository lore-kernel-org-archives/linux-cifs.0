From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/16] cifs: move close processing from cifs_close to cifsFileInfo_put
Date: Mon, 11 Oct 2010 15:07:30 -0400
Message-ID: <1286824053-12084-14-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that it's feasible for a cifsFileInfo to outlive the filp under
which it was created, move the close processing into cifsFileInfo_put.

This means that the last user of the filehandle always does the actual
on the wire close call. This also allows us to get rid of the closePend
flag from cifsFileInfo. If we have an active reference to the file
then it's never going to have a close pending.

cifs_close is converted to simply put the filehandle.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsglob.h |    1 -
 fs/cifs/file.c     |  187 +++++++++++++++++-----------------------------------
 fs/cifs/misc.c     |   10 ---
 3 files changed, 60 insertions(+), 138 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 01e2f56..c928e39 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -391,7 +391,6 @@ struct cifsFileInfo {
 	struct tcon_link *tlink;
 	struct mutex lock_mutex;
 	struct list_head llist; /* list of byte range locks we have. */
-	bool closePend:1;	/* file is marked to close */
 	bool invalidHandle:1;	/* file closed via session abend */
 	bool oplock_break_cancelled:1;
 	atomic_t count;		/* reference count */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 558cdbd..cca560c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -238,7 +238,6 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	pCifsFile->dentry = dget(dentry);
 	pCifsFile->f_flags = file->f_flags;
 	pCifsFile->invalidHandle = false;
-	pCifsFile->closePend = false;
 	pCifsFile->tlink = cifs_get_tlink(tlink);
 	mutex_init(&pCifsFile->fh_mutex);
 	mutex_init(&pCifsFile->lock_mutex);
@@ -262,14 +261,55 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	return pCifsFile;
 }
 
-/* Release a reference on the file private data */
+/*
+ * Release a reference on the file private data. This may involve closing
+ * the filehandle out on the server.
+ */
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 {
-	if (atomic_dec_and_test(&cifs_file->count)) {
-		cifs_put_tlink(cifs_file->tlink);
-		dput(cifs_file->dentry);
-		kfree(cifs_file);
+	struct cifsTconInfo *tcon = tlink_tcon(cifs_file->tlink);
+	struct cifsInodeInfo *cifsi = CIFS_I(cifs_file->dentry->d_inode);
+	struct cifsLockInfo *li, *tmp;
+
+	spin_lock(&cifs_file_list_lock);
+	if (!atomic_dec_and_test(&cifs_file->count)) {
+		spin_unlock(&cifs_file_list_lock);
+		return;
+	}
+
+	/* remove it from the lists */
+	list_del(&cifs_file->flist);
+	list_del(&cifs_file->tlist);
+
+	if (list_empty(&cifsi->openFileList)) {
+		cFYI(1, "closing last open instance for inode %p",
+			cifs_file->dentry->d_inode);
+		cifsi->clientCanCacheRead = false;
+		cifsi->clientCanCacheAll  = false;
+	}
+	spin_unlock(&cifs_file_list_lock);
+
+	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
+		int xid, rc;
+
+		xid = GetXid();
+		rc = CIFSSMBClose(xid, tcon, cifs_file->netfid);
+		FreeXid(xid);
+	}
+
+	/* Delete any outstanding lock records. We'll lose them when the file
+	 * is closed anyway.
+	 */
+	mutex_lock(&cifs_file->lock_mutex);
+	list_for_each_entry_safe(li, tmp, &cifs_file->llist, llist) {
+		list_del(&li->llist);
+		kfree(li);
 	}
+	mutex_unlock(&cifs_file->lock_mutex);
+
+	cifs_put_tlink(cifs_file->tlink);
+	dput(cifs_file->dentry);
+	kfree(cifs_file);
 }
 
 int cifs_open(struct inode *inode, struct file *file)
@@ -601,79 +641,11 @@ reopen_error_exit:
 
 int cifs_close(struct inode *inode, struct file *file)
 {
-	int rc = 0;
-	int xid, timeout;
-	struct cifs_sb_info *cifs_sb;
-	struct cifsTconInfo *pTcon;
-	struct cifsFileInfo *pSMBFile = file->private_data;
-
-	xid = GetXid();
-
-	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = tlink_tcon(pSMBFile->tlink);
-	if (pSMBFile) {
-		struct cifsLockInfo *li, *tmp;
-		spin_lock(&cifs_file_list_lock);
-		pSMBFile->closePend = true;
-		if (pTcon) {
-			/* no sense reconnecting to close a file that is
-			   already closed */
-			if (!pTcon->need_reconnect) {
-				spin_unlock(&cifs_file_list_lock);
-				timeout = 2;
-				while ((atomic_read(&pSMBFile->count) != 1)
-					&& (timeout <= 2048)) {
-					/* Give write a better chance to get to
-					server ahead of the close.  We do not
-					want to add a wait_q here as it would
-					increase the memory utilization as
-					the struct would be in each open file,
-					but this should give enough time to
-					clear the socket */
-					cFYI(DBG2, "close delay, write pending");
-					msleep(timeout);
-					timeout *= 4;
-				}
-				if (!pTcon->need_reconnect &&
-				    !pSMBFile->invalidHandle)
-					rc = CIFSSMBClose(xid, pTcon,
-						  pSMBFile->netfid);
-			} else
-				spin_unlock(&cifs_file_list_lock);
-		} else
-			spin_unlock(&cifs_file_list_lock);
-
-		/* Delete any outstanding lock records.
-		   We'll lose them when the file is closed anyway. */
-		mutex_lock(&pSMBFile->lock_mutex);
-		list_for_each_entry_safe(li, tmp, &pSMBFile->llist, llist) {
-			list_del(&li->llist);
-			kfree(li);
-		}
-		mutex_unlock(&pSMBFile->lock_mutex);
+	cifsFileInfo_put(file->private_data);
+	file->private_data = NULL;
 
-		spin_lock(&cifs_file_list_lock);
-		list_del(&pSMBFile->flist);
-		list_del(&pSMBFile->tlist);
-		spin_unlock(&cifs_file_list_lock);
-		cifsFileInfo_put(file->private_data);
-		file->private_data = NULL;
-	} else
-		rc = -EBADF;
-
-	spin_lock(&cifs_file_list_lock);
-	if (list_empty(&(CIFS_I(inode)->openFileList))) {
-		cFYI(1, "closing last open instance for inode %p", inode);
-		/* if the file is not open we do not know if we can cache info
-		   on this inode, much less write behind and read ahead */
-		CIFS_I(inode)->clientCanCacheRead = false;
-		CIFS_I(inode)->clientCanCacheAll  = false;
-	}
-	spin_unlock(&cifs_file_list_lock);
-	if ((rc == 0) && CIFS_I(inode)->write_behind_rc)
-		rc = CIFS_I(inode)->write_behind_rc;
-	FreeXid(xid);
-	return rc;
+	/* return code from the ->release op is always ignored */
+	return 0;
 }
 
 int cifs_closedir(struct inode *inode, struct file *file)
@@ -1020,13 +992,6 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 			   we blocked so return what we managed to write */
 				return total_written;
 			}
-			if (open_file->closePend) {
-				FreeXid(xid);
-				if (total_written)
-					return total_written;
-				else
-					return -EBADF;
-			}
 			if (open_file->invalidHandle) {
 				/* we could deadlock if we called
 				   filemap_fdatawait from here so tell
@@ -1107,13 +1072,6 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 	     total_written += bytes_written) {
 		rc = -EAGAIN;
 		while (rc == -EAGAIN) {
-			if (open_file->closePend) {
-				FreeXid(xid);
-				if (total_written)
-					return total_written;
-				else
-					return -EBADF;
-			}
 			if (open_file->invalidHandle) {
 				/* we could deadlock if we called
 				   filemap_fdatawait from here so tell
@@ -1193,8 +1151,6 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 	   are always at the end of the list but since the first entry might
 	   have a close pending, we go through the whole list */
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
-		if (open_file->closePend)
-			continue;
 		if (fsuid_only && open_file->uid != current_fsuid())
 			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_READ) {
@@ -1239,8 +1195,6 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 	spin_lock(&cifs_file_list_lock);
 refind_writable:
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
-		if (open_file->closePend)
-			continue;
 		if (!any_available && open_file->pid != current->tgid)
 			continue;
 		if (fsuid_only && open_file->uid != current_fsuid())
@@ -1255,34 +1209,18 @@ refind_writable:
 			}
 
 			spin_unlock(&cifs_file_list_lock);
+
 			/* Had to unlock since following call can block */
 			rc = cifs_reopen_file(open_file, false);
-			if (!rc) {
-				if (!open_file->closePend)
-					return open_file;
-				else { /* start over in case this was deleted */
-				       /* since the list could be modified */
-					spin_lock(&cifs_file_list_lock);
-					cifsFileInfo_put(open_file);
-					goto refind_writable;
-				}
-			}
+			if (!rc)
+				return open_file;
 
-			/* if it fails, try another handle if possible -
-			(we can not do this if closePending since
-			loop could be modified - in which case we
-			have to start at the beginning of the list
-			again. Note that it would be bad
-			to hold up writepages here (rather than
-			in caller) with continuous retries */
+			/* if it fails, try another handle if possible */
 			cFYI(1, "wp failed on reopen file");
-			spin_lock(&cifs_file_list_lock);
-			/* can not use this handle, no write
-			   pending on this one after all */
 			cifsFileInfo_put(open_file);
 
-			if (open_file->closePend) /* list could have changed */
-				goto refind_writable;
+			spin_lock(&cifs_file_list_lock);
+
 			/* else we simply continue to the next entry. Thus
 			   we do not loop on reopen errors.  If we
 			   can not reopen the file, for example if we
@@ -1803,8 +1741,7 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 		smb_read_data = NULL;
 		while (rc == -EAGAIN) {
 			int buf_type = CIFS_NO_BUFFER;
-			if ((open_file->invalidHandle) &&
-			    (!open_file->closePend)) {
+			if (open_file->invalidHandle) {
 				rc = cifs_reopen_file(open_file, true);
 				if (rc != 0)
 					break;
@@ -1889,8 +1826,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 		}
 		rc = -EAGAIN;
 		while (rc == -EAGAIN) {
-			if ((open_file->invalidHandle) &&
-			    (!open_file->closePend)) {
+			if (open_file->invalidHandle) {
 				rc = cifs_reopen_file(open_file, true);
 				if (rc != 0)
 					break;
@@ -2054,8 +1990,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 				read_size, contig_pages);
 		rc = -EAGAIN;
 		while (rc == -EAGAIN) {
-			if ((open_file->invalidHandle) &&
-			    (!open_file->closePend)) {
+			if (open_file->invalidHandle) {
 				rc = cifs_reopen_file(open_file, true);
 				if (rc != 0)
 					break;
@@ -2207,8 +2142,6 @@ static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
 
 	spin_lock(&cifs_file_list_lock);
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
-		if (open_file->closePend)
-			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			spin_unlock(&cifs_file_list_lock);
 			return 1;
@@ -2367,7 +2300,7 @@ void cifs_oplock_break(struct work_struct *work)
 	 * not bother sending an oplock release if session to server still is
 	 * disconnected since oplock already released by the server
 	 */
-	if (!cfile->closePend && !cfile->oplock_break_cancelled) {
+	if (!cfile->oplock_break_cancelled) {
 		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->netfid, 0,
 				 0, 0, 0, LOCKING_ANDX_OPLOCK_RELEASE, false);
 		cFYI(1, "Oplock release rc = %d", rc);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index de6073c..b86b423 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -567,16 +567,6 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				if (pSMB->Fid != netfile->netfid)
 					continue;
 
-				/*
-				 * don't do anything if file is about to be
-				 * closed anyway.
-				 */
-				if (netfile->closePend) {
-					spin_unlock(&cifs_file_list_lock);
-					read_unlock(&cifs_tcp_ses_lock);
-					return true;
-				}
-
 				cFYI(1, "file id match, oplock break");
 				pCifsInode = CIFS_I(netfile->dentry->d_inode);
 				pCifsInode->clientCanCacheAll = false;
-- 
1.7.2.3
