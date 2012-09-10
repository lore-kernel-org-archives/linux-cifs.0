From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Check for mandatory brlocks on read/write
Date: Mon, 10 Sep 2012 15:56:57 +0400
Message-ID: <1347278217-4586-1-git-send-email-pshilovsky@etersoft.ru>
References: <1346406088-4537-8-git-send-email-pshilovsky@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346406088-4537-8-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently CIFS code accept read/write ops on mandatory locked area
when two processes use the same file descriptor - it's wrong.
Fix this by serializing io and brlock operations on the inode.

Signed-off-by: Pavel Shilovsky <pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 ++
 fs/cifs/file.c      |  123 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 103 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 15e38dc..c758ee7 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -180,6 +180,10 @@ extern struct smb_vol *cifs_get_volume_info(char *mount_data,
 extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
 extern void cifs_umount(struct cifs_sb_info *);
 extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
+extern bool cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
+				    __u64 length, __u8 type,
+				    struct cifsLockInfo **conf_lock,
+				    bool rw_check);
 
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index daeb817..ecc0d5d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -704,10 +704,10 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
 	}
 }
 
-static bool
+extern bool
 cifs_find_fid_lock_conflict(struct cifs_fid_locks *fdlocks, __u64 offset,
 			    __u64 length, __u8 type, struct cifsFileInfo *cfile,
-			    struct cifsLockInfo **conf_lock)
+			    struct cifsLockInfo **conf_lock, bool rw_check)
 {
 	struct cifsLockInfo *li;
 	struct cifsFileInfo *cur_cfile = fdlocks->cfile;
@@ -717,19 +717,24 @@ cifs_find_fid_lock_conflict(struct cifs_fid_locks *fdlocks, __u64 offset,
 		if (offset + length <= li->offset ||
 		    offset >= li->offset + li->length)
 			continue;
+		if (rw_check && server->ops->compare_fids(cfile, cur_cfile) &&
+		    current->tgid == li->pid)
+			continue;
 		if ((type & server->vals->shared_lock_type) &&
 		    ((server->ops->compare_fids(cfile, cur_cfile) &&
 		     current->tgid == li->pid) || type == li->type))
 			continue;
-		*conf_lock = li;
+		if (conf_lock)
+			*conf_lock = li;
 		return true;
 	}
 	return false;
 }
 
-static bool
+bool
 cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
-			__u8 type, struct cifsLockInfo **conf_lock)
+			__u8 type, struct cifsLockInfo **conf_lock,
+			bool rw_check)
 {
 	bool rc = false;
 	struct cifs_fid_locks *cur;
@@ -737,7 +742,7 @@ cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 
 	list_for_each_entry(cur, &cinode->llist, llist) {
 		rc = cifs_find_fid_lock_conflict(cur, offset, length, type,
-						 cfile, conf_lock);
+						 cfile, conf_lock, rw_check);
 		if (rc)
 			break;
 	}
@@ -765,7 +770,7 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 	down_read(&cinode->lock_sem);
 
 	exist = cifs_find_lock_conflict(cfile, offset, length, type,
-					&conf_lock);
+					&conf_lock, false);
 	if (exist) {
 		flock->fl_start = conf_lock->offset;
 		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
@@ -812,7 +817,7 @@ try_again:
 	down_write(&cinode->lock_sem);
 
 	exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
-					lock->type, &conf_lock);
+					lock->type, &conf_lock, false);
 	if (!exist && cinode->can_cache_brlcks) {
 		list_add_tail(&lock->llist, &cfile->llist->locks);
 		up_write(&cinode->lock_sem);
@@ -2394,15 +2399,58 @@ ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
 	return written;
 }
 
-ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
-			   unsigned long nr_segs, loff_t pos)
+static ssize_t
+cifs_writev(struct kiocb *iocb, const struct iovec *iov,
+	    unsigned long nr_segs, loff_t pos)
 {
-	struct inode *inode;
+	struct file *file = iocb->ki_filp;
+	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
+	struct inode *inode = file->f_mapping->host;
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
+	ssize_t rc = -EACCES;
 
-	inode = iocb->ki_filp->f_path.dentry->d_inode;
+	BUG_ON(iocb->ki_pos != pos);
 
-	if (CIFS_I(inode)->clientCanCacheAll)
-		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	sb_start_write(inode->i_sb);
+
+	/*
+	 * We need to hold the sem to be sure nobody modifies lock list
+	 * with a brlock that prevents writing.
+	 */
+	down_read(&cinode->lock_sem);
+	if (!cifs_find_lock_conflict(cfile, pos, iov_length(iov, nr_segs),
+				     server->vals->exclusive_lock_type, NULL,
+				     true)) {
+		mutex_lock(&inode->i_mutex);
+		rc = __generic_file_aio_write(iocb, iov, nr_segs,
+					       &iocb->ki_pos);
+		mutex_unlock(&inode->i_mutex);
+	}
+
+	if (rc > 0 || rc == -EIOCBQUEUED) {
+		ssize_t err;
+
+		err = generic_write_sync(file, pos, rc);
+		if (err < 0 && rc > 0)
+			rc = err;
+	}
+
+	up_read(&cinode->lock_sem);
+	sb_end_write(inode->i_sb);
+	return rc;
+}
+
+ssize_t
+cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
+		   unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsFileInfo *cfile = (struct cifsFileInfo *)
+						iocb->ki_filp->private_data;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
 	/*
 	 * In strict cache mode we need to write the data to the server exactly
@@ -2411,7 +2459,15 @@ ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 	 * not on the region from pos to ppos+len-1.
 	 */
 
-	return cifs_user_writev(iocb, iov, nr_segs, pos);
+	if (!cinode->clientCanCacheAll)
+		return cifs_user_writev(iocb, iov, nr_segs, pos);
+
+	if (cap_unix(tcon->ses) &&
+	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
+	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	return cifs_writev(iocb, iov, nr_segs, pos);
 }
 
 static struct cifs_readdata *
@@ -2746,15 +2802,17 @@ ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
 	return read;
 }
 
-ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
-			  unsigned long nr_segs, loff_t pos)
+ssize_t
+cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
+		  unsigned long nr_segs, loff_t pos)
 {
-	struct inode *inode;
-
-	inode = iocb->ki_filp->f_path.dentry->d_inode;
-
-	if (CIFS_I(inode)->clientCanCacheRead)
-		return generic_file_aio_read(iocb, iov, nr_segs, pos);
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsFileInfo *cfile = (struct cifsFileInfo *)
+						iocb->ki_filp->private_data;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	int rc = -EACCES;
 
 	/*
 	 * In strict cache mode we need to read from the server all the time
@@ -2764,8 +2822,25 @@ ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
 	 * on pages affected by this read but not on the region from pos to
 	 * pos+len-1.
 	 */
+	if (!cinode->clientCanCacheRead)
+		return cifs_user_readv(iocb, iov, nr_segs, pos);
+
+	if (cap_unix(tcon->ses) &&
+	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
+	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+		return generic_file_aio_read(iocb, iov, nr_segs, pos);
 
-	return cifs_user_readv(iocb, iov, nr_segs, pos);
+	/*
+	 * We need to hold the sem to be sure nobody modifies lock list
+	 * with a brlock that prevents reading.
+	 */
+	down_read(&cinode->lock_sem);
+	if (!cifs_find_lock_conflict(cfile, pos, iov_length(iov, nr_segs),
+				     tcon->ses->server->vals->shared_lock_type,
+				     NULL, true))
+		rc = generic_file_aio_read(iocb, iov, nr_segs, pos);
+	up_read(&cinode->lock_sem);
+	return rc;
 }
 
 static ssize_t
-- 
1.7.1
