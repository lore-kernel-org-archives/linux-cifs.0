From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Add support for flock over a cifs mount.
Date: Mon, 07 Nov 2011 20:05:40 +0000
Message-ID: <1320696342.1690.19.camel@sprabhu.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Allow flock over a cifs mount.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8f1fe32..56d3b36 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -830,6 +830,7 @@ const struct file_operations cifs_file_ops = {
 	.open = cifs_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
+	.flock = cifs_flock,
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
@@ -849,6 +850,7 @@ const struct file_operations cifs_file_strict_ops = {
 	.open = cifs_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
+	.flock = cifs_flock,
 	.fsync = cifs_strict_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
@@ -869,6 +871,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.open = cifs_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
+	.flock = cifs_flock,
 	.fsync = cifs_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 30ff560..e119e9d 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -87,6 +87,7 @@ extern ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
 extern ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 				  unsigned long nr_segs, loff_t pos);
 extern int cifs_lock(struct file *, int, struct file_lock *);
+extern int cifs_flock(struct file *, int, struct file_lock *);
 extern int cifs_fsync(struct file *, loff_t, loff_t, int);
 extern int cifs_strict_fsync(struct file *, loff_t, loff_t, int);
 extern int cifs_flush(struct file *, fl_owner_t id);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c1f063c..dd34f0b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -43,6 +43,23 @@
 #include "cifs_fs_sb.h"
 #include "fscache.h"
 
+static int do_vfs_lock(struct file *file, struct file_lock *fl)
+{
+	int res = 0;
+
+	switch (fl->fl_flags & (FL_POSIX|FL_FLOCK)) {
+	case FL_POSIX:
+		res = posix_lock_file_wait(file, fl);
+		break;
+	case FL_FLOCK:
+		res = flock_lock_file_wait(file, fl);
+		break;
+	default:
+		BUG();
+	}
+	return res;
+}
+
 static inline int cifs_convert_flags(unsigned int flags)
 {
 	if ((flags & O_ACCMODE) == O_RDONLY)
@@ -814,7 +831,7 @@ cifs_posix_lock_set(struct file *file, struct file_lock *flock)
 	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
 	int rc = 1;
 
-	if ((flock->fl_flags & FL_POSIX) == 0)
+	if ((flock->fl_flags & (FL_POSIX | FL_FLOCK)) == 0)
 		return rc;
 
 	mutex_lock(&cinode->lock_mutex);
@@ -822,7 +839,7 @@ cifs_posix_lock_set(struct file *file, struct file_lock *flock)
 		mutex_unlock(&cinode->lock_mutex);
 		return rc;
 	}
-	rc = posix_lock_file_wait(file, flock);
+	rc = do_vfs_lock(file, flock);
 	mutex_unlock(&cinode->lock_mutex);
 	return rc;
 }
@@ -1231,12 +1248,27 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
 	__u16 netfid = cfile->netfid;
+	unsigned char fl_flags = flock->fl_flags;
+
+	if (unlock) {
+		/*Check for existance of lock*/
+		flock->fl_flags |= FL_EXISTS;
+		if (do_vfs_lock(flock->fl_file, flock) == -ENOENT)
+			goto out;
+	} else {
+		/*Check if we can obtain lock*/
+		flock->fl_flags |= FL_ACCESS;
+		rc = do_vfs_lock(flock->fl_file, flock);
+		if (rc < 0)
+			goto out;
+	}
+	flock->fl_flags = fl_flags;
 
 	if (posix_lck) {
 		int posix_lock_type;
 
 		rc = cifs_posix_lock_set(file, flock);
-		if (!rc || rc < 0)
+		if (rc <= 0)
 			return rc;
 
 		if (type & LOCKING_ANDX_SHARED_LOCK)
@@ -1250,7 +1282,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 		rc = CIFSSMBPosixLock(xid, tcon, netfid, current->tgid,
 				      0 /* set */, length, flock,
 				      posix_lock_type, wait_flag);
-		goto out;
+		goto out_lock;
 	}
 
 	if (lock) {
@@ -1259,7 +1291,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 		if (rc < 0)
 			return rc;
 		else if (!rc)
-			goto out;
+			goto out_lock;
 
 		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
 				 flock->fl_start, 0, 1, type, wait_flag, 0);
@@ -1271,9 +1303,14 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	} else if (unlock)
 		rc = cifs_unlock_range(cfile, flock, xid);
 
+out_lock:
+	if (rc == 0 && lock) {
+		/*We have to sleep here*/
+		flock->fl_flags |= FL_SLEEP;
+		do_vfs_lock(file, flock);
+	}
 out:
-	if (flock->fl_flags & FL_POSIX)
-		posix_lock_file_wait(file, flock);
+	flock->fl_flags = fl_flags;
 	return rc;
 }
 
@@ -1334,6 +1371,22 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	return rc;
 }
 
+int cifs_flock(struct file *file, int cmd, struct file_lock *flock)
+{
+	int rc;
+
+	rc = cifs_lock(file, cmd, flock);
+
+	/*
+	 * flock requires -EWOULDBLOCK in case of conflicting locks
+	 * and LOCK_NB is used
+	 */
+	if ((rc == -EACCES) && !(flock->fl_flags & FL_SLEEP))
+		rc = -EWOULDBLOCK;
+
+	return rc;
+}
+
 /* update the file size (if needed) after a write */
 void
 cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
