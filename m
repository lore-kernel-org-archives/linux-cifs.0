From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/16] cifs: convert GlobalSMBSeslock from a rwlock to regular spinlock
Date: Mon, 11 Oct 2010 15:07:28 -0400
Message-ID: <1286824053-12084-12-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Convert this lock to a regular spinlock

A rwlock_t offers little value here. It's more expensive than a regular
spinlock unless you have a fairly large section of code that runs under
the read lock and can benefit from the concurrency.

Additionally, we need to ensure that the refcounting for files isn't
racy and to do that we need to lock areas that can increment it for
write. That means that the areas that can actually use a read_lock are
very few and relatively infrequently used.

While we're at it, change the name to something easier to type, and fix
a bug in find_writable_file. cifsFileInfo_put can sleep and shouldn't be
called while holding the lock.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    2 +-
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/cifssmb.c  |    4 +-
 fs/cifs/file.c     |   54 ++++++++++++++++++++++++++--------------------------
 fs/cifs/misc.c     |    8 +++---
 fs/cifs/readdir.c  |    6 ++--
 6 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3facf25..c25e928 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -942,8 +942,8 @@ init_cifs(void)
 	GlobalTotalActiveXid = 0;
 	GlobalMaxActiveXid = 0;
 	memset(Local_System_Name, 0, 15);
-	rwlock_init(&GlobalSMBSeslock);
 	rwlock_init(&cifs_tcp_ses_lock);
+	spin_lock_init(&cifs_file_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
 	if (cifs_max_pending < 2) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6dcd911..c29ef5f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -720,7 +720,7 @@ GLOBAL_EXTERN rwlock_t		cifs_tcp_ses_lock;
  * If cifs_tcp_ses_lock and the lock below are both needed to be held, then
  * the cifs_tcp_ses_lock must be grabbed first and released last.
  */
-GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;
+GLOBAL_EXTERN spinlock_t	cifs_file_list_lock;
 
 /* Outstanding dir notify requests */
 GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 54bd83a..d0aed27 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -91,13 +91,13 @@ static void mark_open_files_invalid(struct cifsTconInfo *pTcon)
 	struct list_head *tmp1;
 
 /* list all files open on tree connection and mark them invalid */
-	write_lock(&GlobalSMBSeslock);
+	spin_lock(&cifs_file_list_lock);
 	list_for_each_safe(tmp, tmp1, &pTcon->openFileList) {
 		open_file = list_entry(tmp, struct cifsFileInfo, tlist);
 		open_file->invalidHandle = true;
 		open_file->oplock_break_cancelled = true;
 	}
-	write_unlock(&GlobalSMBSeslock);
+	spin_unlock(&cifs_file_list_lock);
 	/* BB Add call to invalidate_inodes(sb) for all superblocks mounted
 	   to this tcon */
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 422bb18..cae80da 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -246,10 +246,10 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	atomic_set(&pCifsFile->count, 1);
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
-	write_lock(&GlobalSMBSeslock);
+	spin_lock(&cifs_file_list_lock);
 	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
 	list_add(&pCifsFile->flist, &pCifsInode->openFileList);
-	write_unlock(&GlobalSMBSeslock);
+	spin_unlock(&cifs_file_list_lock);
 
 	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
 		pCifsInode->clientCanCacheAll = true;
@@ -603,13 +603,13 @@ int cifs_close(struct inode *inode, struct file *file)
 	pTcon = tlink_tcon(pSMBFile->tlink);
 	if (pSMBFile) {
 		struct cifsLockInfo *li, *tmp;
-		write_lock(&GlobalSMBSeslock);
+		spin_lock(&cifs_file_list_lock);
 		pSMBFile->closePend = true;
 		if (pTcon) {
 			/* no sense reconnecting to close a file that is
 			   already closed */
 			if (!pTcon->need_reconnect) {
-				write_unlock(&GlobalSMBSeslock);
+				spin_unlock(&cifs_file_list_lock);
 				timeout = 2;
 				while ((atomic_read(&pSMBFile->count) != 1)
 					&& (timeout <= 2048)) {
@@ -629,9 +629,9 @@ int cifs_close(struct inode *inode, struct file *file)
 					rc = CIFSSMBClose(xid, pTcon,
 						  pSMBFile->netfid);
 			} else
-				write_unlock(&GlobalSMBSeslock);
+				spin_unlock(&cifs_file_list_lock);
 		} else
-			write_unlock(&GlobalSMBSeslock);
+			spin_unlock(&cifs_file_list_lock);
 
 		/* Delete any outstanding lock records.
 		   We'll lose them when the file is closed anyway. */
@@ -642,16 +642,16 @@ int cifs_close(struct inode *inode, struct file *file)
 		}
 		mutex_unlock(&pSMBFile->lock_mutex);
 
-		write_lock(&GlobalSMBSeslock);
+		spin_lock(&cifs_file_list_lock);
 		list_del(&pSMBFile->flist);
 		list_del(&pSMBFile->tlist);
-		write_unlock(&GlobalSMBSeslock);
+		spin_unlock(&cifs_file_list_lock);
 		cifsFileInfo_put(file->private_data);
 		file->private_data = NULL;
 	} else
 		rc = -EBADF;
 
-	read_lock(&GlobalSMBSeslock);
+	spin_lock(&cifs_file_list_lock);
 	if (list_empty(&(CIFS_I(inode)->openFileList))) {
 		cFYI(1, "closing last open instance for inode %p", inode);
 		/* if the file is not open we do not know if we can cache info
@@ -659,7 +659,7 @@ int cifs_close(struct inode *inode, struct file *file)
 		CIFS_I(inode)->clientCanCacheRead = false;
 		CIFS_I(inode)->clientCanCacheAll  = false;
 	}
-	read_unlock(&GlobalSMBSeslock);
+	spin_unlock(&cifs_file_list_lock);
 	if ((rc == 0) && CIFS_I(inode)->write_behind_rc)
 		rc = CIFS_I(inode)->write_behind_rc;
 	FreeXid(xid);
@@ -681,18 +681,18 @@ int cifs_closedir(struct inode *inode, struct file *file)
 		struct cifsTconInfo *pTcon = tlink_tcon(pCFileStruct->tlink);
 
 		cFYI(1, "Freeing private data in close dir");
-		write_lock(&GlobalSMBSeslock);
+		spin_lock(&cifs_file_list_lock);
 		if (!pCFileStruct->srch_inf.endOfSearch &&
 		    !pCFileStruct->invalidHandle) {
 			pCFileStruct->invalidHandle = true;
-			write_unlock(&GlobalSMBSeslock);
+			spin_unlock(&cifs_file_list_lock);
 			rc = CIFSFindClose(xid, pTcon, pCFileStruct->netfid);
 			cFYI(1, "Closing uncompleted readdir with rc %d",
 				 rc);
 			/* not much we can do if it fails anyway, ignore rc */
 			rc = 0;
 		} else
-			write_unlock(&GlobalSMBSeslock);
+			spin_unlock(&cifs_file_list_lock);
 		ptmp = pCFileStruct->srch_inf.ntwrk_buf_start;
 		if (ptmp) {
 			cFYI(1, "closedir free smb buf in srch struct");
@@ -1178,7 +1178,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
-	read_lock(&GlobalSMBSeslock);
+	spin_lock(&cifs_file_list_lock);
 	/* we could simply get the first_list_entry since write-only entries
 	   are always at the end of the list but since the first entry might
 	   have a close pending, we go through the whole list */
@@ -1192,14 +1192,14 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 				/* found a good file */
 				/* lock it so it will not be closed on us */
 				cifsFileInfo_get(open_file);
-				read_unlock(&GlobalSMBSeslock);
+				spin_unlock(&cifs_file_list_lock);
 				return open_file;
 			} /* else might as well continue, and look for
 			     another, or simply have the caller reopen it
 			     again rather than trying to fix this handle */
 		}
 	}
-	read_unlock(&GlobalSMBSeslock);
+	spin_unlock(&cifs_file_list_lock);
 	return NULL;
 }
 #endif
@@ -1226,7 +1226,7 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
-	read_lock(&GlobalSMBSeslock);
+	spin_lock(&cifs_file_list_lock);
 refind_writable:
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (open_file->closePend)
@@ -1240,11 +1240,11 @@ refind_writable:
 
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
-				read_unlock(&GlobalSMBSeslock);
+				spin_unlock(&cifs_file_list_lock);
 				return open_file;
 			}
 
-			read_unlock(&GlobalSMBSeslock);
+			spin_unlock(&cifs_file_list_lock);
 			/* Had to unlock since following call can block */
 			rc = cifs_reopen_file(open_file, false);
 			if (!rc) {
@@ -1252,7 +1252,7 @@ refind_writable:
 					return open_file;
 				else { /* start over in case this was deleted */
 				       /* since the list could be modified */
-					read_lock(&GlobalSMBSeslock);
+					spin_lock(&cifs_file_list_lock);
 					cifsFileInfo_put(open_file);
 					goto refind_writable;
 				}
@@ -1266,7 +1266,7 @@ refind_writable:
 			to hold up writepages here (rather than
 			in caller) with continuous retries */
 			cFYI(1, "wp failed on reopen file");
-			read_lock(&GlobalSMBSeslock);
+			spin_lock(&cifs_file_list_lock);
 			/* can not use this handle, no write
 			   pending on this one after all */
 			cifsFileInfo_put(open_file);
@@ -1287,7 +1287,7 @@ refind_writable:
 		any_available = true;
 		goto refind_writable;
 	}
-	read_unlock(&GlobalSMBSeslock);
+	spin_unlock(&cifs_file_list_lock);
 	return NULL;
 }
 
@@ -2195,16 +2195,16 @@ static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
 {
 	struct cifsFileInfo *open_file;
 
-	read_lock(&GlobalSMBSeslock);
+	spin_lock(&cifs_file_list_lock);
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (open_file->closePend)
 			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
-			read_unlock(&GlobalSMBSeslock);
+			spin_unlock(&cifs_file_list_lock);
 			return 1;
 		}
 	}
-	read_unlock(&GlobalSMBSeslock);
+	spin_unlock(&cifs_file_list_lock);
 	return 0;
 }
 
@@ -2368,8 +2368,8 @@ void cifs_oplock_break(struct work_struct *work)
 	 * finished grabbing reference for us.  Make sure it's done by
 	 * waiting for GlobalSMSSeslock.
 	 */
-	write_lock(&GlobalSMBSeslock);
-	write_unlock(&GlobalSMBSeslock);
+	spin_lock(&cifs_file_list_lock);
+	spin_unlock(&cifs_file_list_lock);
 
 	cifs_oplock_break_put(cfile);
 }
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 9bac3e7..de6073c 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -560,7 +560,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				continue;
 
 			cifs_stats_inc(&tcon->num_oplock_brks);
-			read_lock(&GlobalSMBSeslock);
+			spin_lock(&cifs_file_list_lock);
 			list_for_each(tmp2, &tcon->openFileList) {
 				netfile = list_entry(tmp2, struct cifsFileInfo,
 						     tlist);
@@ -572,7 +572,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				 * closed anyway.
 				 */
 				if (netfile->closePend) {
-					read_unlock(&GlobalSMBSeslock);
+					spin_unlock(&cifs_file_list_lock);
 					read_unlock(&cifs_tcp_ses_lock);
 					return true;
 				}
@@ -594,11 +594,11 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 					cifs_oplock_break_get(netfile);
 				netfile->oplock_break_cancelled = false;
 
-				read_unlock(&GlobalSMBSeslock);
+				spin_unlock(&cifs_file_list_lock);
 				read_unlock(&cifs_tcp_ses_lock);
 				return true;
 			}
-			read_unlock(&GlobalSMBSeslock);
+			spin_unlock(&cifs_file_list_lock);
 			read_unlock(&cifs_tcp_ses_lock);
 			cFYI(1, "No matching file for oplock break");
 			return true;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 078c625..dbc1c64 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -529,14 +529,14 @@ static int find_cifs_entry(const int xid, struct cifsTconInfo *pTcon,
 	   (index_to_find < first_entry_in_buffer)) {
 		/* close and restart search */
 		cFYI(1, "search backing up - close and restart search");
-		write_lock(&GlobalSMBSeslock);
+		spin_lock(&cifs_file_list_lock);
 		if (!cifsFile->srch_inf.endOfSearch &&
 		    !cifsFile->invalidHandle) {
 			cifsFile->invalidHandle = true;
-			write_unlock(&GlobalSMBSeslock);
+			spin_unlock(&cifs_file_list_lock);
 			CIFSFindClose(xid, pTcon, cifsFile->netfid);
 		} else
-			write_unlock(&GlobalSMBSeslock);
+			spin_unlock(&cifs_file_list_lock);
 		if (cifsFile->srch_inf.ntwrk_buf_start) {
 			cFYI(1, "freeing SMB ff cache buf on search rewind");
 			if (cifsFile->srch_inf.smallBuf)
-- 
1.7.2.3
