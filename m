From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH v2 22/53] CIFS: Add SMB2 support for open/close file operations
Date: Fri, 28 Oct 2011 23:54:33 +0400
Message-ID: <1319831704-3572-23-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel@vger.kernel.org,
	Pavel Shilovsky <piastryyy@gmail.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Pavel Shilovsky <piastryyy@gmail.com>

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
---
 fs/cifs/cifsfs.c    |   85 ----------------
 fs/cifs/cifsfs.h    |    4 +
 fs/cifs/cifsglob.h  |    4 +
 fs/cifs/cifsproto.h |   19 +++--
 fs/cifs/file.c      |  141 +++++++++++++++++++++++---
 fs/cifs/smb2file.c  |  274 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2inode.c |   14 ++--
 fs/cifs/smb2pdu.c   |    4 +-
 fs/cifs/smb2proto.h |   15 +++
 9 files changed, 442 insertions(+), 118 deletions(-)
 create mode 100644 fs/cifs/smb2file.c

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c7b316e..7991a53 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -686,91 +686,6 @@ out_nls:
 	goto out;
 }
 
-static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-				   unsigned long nr_segs, loff_t pos)
-{
-	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
-	ssize_t written;
-	int rc;
-
-	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
-
-	if (CIFS_I(inode)->clientCanCacheAll)
-		return written;
-
-	rc = filemap_fdatawrite(inode->i_mapping);
-	if (rc)
-		cFYI(1, "cifs_file_aio_write: %d rc on %p inode", rc, inode);
-
-	return written;
-}
-
-static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
-{
-	/*
-	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
-	 * the cached file length
-	 */
-	if (origin != SEEK_SET || origin != SEEK_CUR) {
-		int rc;
-		struct inode *inode = file->f_path.dentry->d_inode;
-
-		/*
-		 * We need to be sure that all dirty pages are written and the
-		 * server has the newest file length.
-		 */
-		if (!CIFS_I(inode)->clientCanCacheRead && inode->i_mapping &&
-		    inode->i_mapping->nrpages != 0) {
-			rc = filemap_fdatawait(inode->i_mapping);
-			if (rc) {
-				mapping_set_error(inode->i_mapping, rc);
-				return rc;
-			}
-		}
-		/*
-		 * Some applications poll for the file length in this strange
-		 * way so we must seek to end on non-oplocked files by
-		 * setting the revalidate time to zero.
-		 */
-		CIFS_I(inode)->time = 0;
-
-		rc = cifs_revalidate_file_attr(file);
-		if (rc < 0)
-			return (loff_t)rc;
-	}
-	return generic_file_llseek_unlocked(file, offset, origin);
-}
-
-static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
-{
-	/* note that this is called by vfs setlease with lock_flocks held
-	   to protect *lease from going away */
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct cifsFileInfo *cfile = file->private_data;
-
-	if (!(S_ISREG(inode->i_mode)))
-		return -EINVAL;
-
-	/* check if file is oplocked */
-	if (((arg == F_RDLCK) &&
-		(CIFS_I(inode)->clientCanCacheRead)) ||
-	    ((arg == F_WRLCK) &&
-		(CIFS_I(inode)->clientCanCacheAll)))
-		return generic_setlease(file, arg, lease);
-	else if (tlink_tcon(cfile->tlink)->local_lease &&
-		 !CIFS_I(inode)->clientCanCacheRead)
-		/* If the server claims to support oplock on this
-		   file, then we still need to check oplock even
-		   if the local_lease mount option is set, but there
-		   are servers which do not support oplock for which
-		   this mount option may be useful if the user
-		   knows that the file won't be changed on the server
-		   by anyone else */
-		return generic_setlease(file, arg, lease);
-	else
-		return -EAGAIN;
-}
-
 struct file_system_type cifs_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "cifs",
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 2009adc..198a141 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -82,6 +82,8 @@ extern ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
 			       unsigned long nr_segs, loff_t pos);
 extern ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
 				 unsigned long nr_segs, loff_t pos);
+extern ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
+				   unsigned long nr_segs, loff_t pos);
 extern ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 extern ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
@@ -92,6 +94,8 @@ extern int cifs_strict_fsync(struct file *, loff_t, loff_t, int);
 extern int cifs_flush(struct file *, fl_owner_t id);
 extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
 extern int cifs_file_strict_mmap(struct file * , struct vm_area_struct *);
+extern int cifs_setlease(struct file *file, long arg, struct file_lock **lease);
+extern loff_t cifs_llseek(struct file *file, loff_t offset, int origin);
 extern const struct file_operations cifs_dir_ops;
 extern int cifs_dir_open(struct inode *inode, struct file *file);
 extern int cifs_readdir(struct file *file, void *direntry, filldir_t filldir);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a2b14d8..e6ea8de 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -579,6 +579,10 @@ struct cifsFileInfo {
 	unsigned int uid;	/* allows finding which FileInfo structure */
 	__u32 pid;		/* process id who opened file */
 	__u16 netfid;		/* file id from remote */
+#ifdef CONFIG_CIFS_SMB2
+	__u64 volatile_fid;	/* volatile file id for smb2 */
+	__u64 persist_fid;	/* persist file id for smb2 */
+#endif
 	/* BB add lock scope info here if needed */ ;
 	/* lock scope id (0 if none) */
 	struct dentry *dentry;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 607d3e4..142660f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -125,13 +125,18 @@ extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 				      int offset);
 extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
 
-extern struct cifsFileInfo *cifs_new_fileinfo(__u16 fileHandle,
-				struct file *file, struct tcon_link *tlink,
-				__u32 oplock);
-extern int cifs_posix_open(char *full_path, struct inode **pinode,
-				struct super_block *sb,
-				int mode, unsigned int f_flags,
-				__u32 *poplock, __u16 *pnetfid, int xid);
+extern int cifs_convert_flags(unsigned int flags);
+extern int cifs_get_disposition(unsigned int flags);
+extern struct cifsFileInfo *cifs_new_fileinfo(__u16 netfid, struct file *file,
+					      struct tcon_link *tlink,
+					      __u32 oplock);
+extern struct cifsFileInfo *cifs_new_fileinfo_generic(struct file *file,
+						      struct tcon_link *tlink,
+						      __u32 oplock);
+extern int cifs_posix_open(const char *full_path, struct inode **pinode,
+			   struct super_block *sb, int mode,
+			   unsigned int f_flags, __u32 *poplock, __u16 *pnetfid,
+			   int xid);
 void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
 extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
 				     FILE_UNIX_BASIC_INFO *info,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1b9bae6..37c8445 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -42,8 +42,11 @@
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
 #include "fscache.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
-static inline int cifs_convert_flags(unsigned int flags)
+inline int cifs_convert_flags(unsigned int flags)
 {
 	if ((flags & O_ACCMODE) == O_RDONLY)
 		return GENERIC_READ;
@@ -91,7 +94,7 @@ static u32 cifs_posix_convert_flags(unsigned int flags)
 	return posix_flags;
 }
 
-static inline int cifs_get_disposition(unsigned int flags)
+inline int cifs_get_disposition(unsigned int flags)
 {
 	if ((flags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
 		return FILE_CREATE;
@@ -105,9 +108,9 @@ static inline int cifs_get_disposition(unsigned int flags)
 		return FILE_OPEN;
 }
 
-int cifs_posix_open(char *full_path, struct inode **pinode,
-			struct super_block *sb, int mode, unsigned int f_flags,
-			__u32 *poplock, __u16 *pnetfid, int xid)
+int cifs_posix_open(const char *full_path, struct inode **pinode,
+		    struct super_block *sb, int mode, unsigned int f_flags,
+		    __u32 *poplock, __u16 *pnetfid, int xid)
 {
 	int rc;
 	FILE_UNIX_BASIC_INFO *presp_data;
@@ -168,9 +171,9 @@ posix_open_ret:
 }
 
 static int
-cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
-	     struct cifs_tcon *tcon, unsigned int f_flags, __u32 *poplock,
-	     __u16 *pnetfid, int xid)
+cifs_nt_open(const char *full_path, struct inode *inode,
+	     struct cifs_sb_info *cifs_sb, struct cifs_tcon *tcon,
+	     unsigned int f_flags, __u32 *poplock, __u16 *pnetfid, int xid)
 {
 	int rc;
 	int desiredAccess;
@@ -242,9 +245,22 @@ out:
 }
 
 struct cifsFileInfo *
-cifs_new_fileinfo(__u16 fileHandle, struct file *file,
+cifs_new_fileinfo(__u16 netfid, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
 {
+	struct cifsFileInfo *cifs_file;
+
+	cifs_file = cifs_new_fileinfo_generic(file, tlink, oplock);
+	if (cifs_file == NULL)
+		return NULL;
+	cifs_file->netfid = netfid;
+	return cifs_file;
+}
+
+struct cifsFileInfo *
+cifs_new_fileinfo_generic(struct file *file, struct tcon_link *tlink,
+			  __u32 oplock)
+{
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct cifsInodeInfo *pCifsInode = CIFS_I(inode);
@@ -255,7 +271,6 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 		return pCifsFile;
 
 	pCifsFile->count = 1;
-	pCifsFile->netfid = fileHandle;
 	pCifsFile->pid = current->tgid;
 	pCifsFile->uid = current_fsuid();
 	pCifsFile->dentry = dget(dentry);
@@ -323,10 +338,16 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	cancel_work_sync(&cifs_file->oplock_break);
 
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
-		int xid, rc;
+		int xid, rc = 0;
 
 		xid = GetXid();
-		rc = CIFSSMBClose(xid, tcon, cifs_file->netfid);
+#ifdef CONFIG_CIFS_SMB2
+		if (tcon->ses->server->is_smb2)
+			rc = SMB2_close(xid, tcon, cifs_file->persist_fid,
+					cifs_file->volatile_fid);
+		else
+#endif
+			rc = CIFSSMBClose(xid, tcon, cifs_file->netfid);
 		FreeXid(xid);
 	}
 
@@ -348,7 +369,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	kfree(cifs_file);
 }
 
-int cifs_open(struct inode *inode, struct file *file)
+int
+cifs_open(struct inode *inode, struct file *file)
 {
 	int rc = -EACCES;
 	int xid;
@@ -356,7 +378,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
-	struct cifsFileInfo *pCifsFile = NULL;
+	struct cifsFileInfo *cifs_file = NULL;
 	char *full_path = NULL;
 	bool posix_open_ok = false;
 	__u16 netfid;
@@ -419,8 +441,8 @@ int cifs_open(struct inode *inode, struct file *file)
 			goto out;
 	}
 
-	pCifsFile = cifs_new_fileinfo(netfid, file, tlink, oplock);
-	if (pCifsFile == NULL) {
+	cifs_file = cifs_new_fileinfo(netfid, file, tlink, oplock);
+	if (cifs_file == NULL) {
 		CIFSSMBClose(xid, tcon, netfid);
 		rc = -ENOMEM;
 		goto out;
@@ -441,7 +463,7 @@ int cifs_open(struct inode *inode, struct file *file)
 			.device	= 0,
 		};
 		CIFSSMBUnixSetFileInfo(xid, tcon, &args, netfid,
-					pCifsFile->pid);
+					cifs_file->pid);
 	}
 
 out:
@@ -643,6 +665,72 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	return rc;
 }
 
+loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
+{
+	/*
+	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
+	 * the cached file length
+	 */
+	if (origin != SEEK_SET || origin != SEEK_CUR) {
+		int rc;
+		struct inode *inode = file->f_path.dentry->d_inode;
+
+		/*
+		 * We need to be sure that all dirty pages are written and the
+		 * server has the newest file length.
+		 */
+		if (!CIFS_I(inode)->clientCanCacheRead && inode->i_mapping &&
+		    inode->i_mapping->nrpages != 0) {
+			rc = filemap_fdatawait(inode->i_mapping);
+			if (rc) {
+				mapping_set_error(inode->i_mapping, rc);
+				return rc;
+			}
+		}
+		/*
+		 * Some applications poll for the file length in this strange
+		 * way so we must seek to end on non-oplocked files by
+		 * setting the revalidate time to zero.
+		 */
+		CIFS_I(inode)->time = 0;
+
+		rc = cifs_revalidate_file_attr(file);
+		if (rc < 0)
+			return (loff_t)rc;
+	}
+	return generic_file_llseek_unlocked(file, offset, origin);
+}
+
+int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
+{
+	/* note that this is called by vfs setlease with lock_flocks held
+	   to protect *lease from going away */
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct cifsFileInfo *cfile = file->private_data;
+
+	if (!(S_ISREG(inode->i_mode)))
+		return -EINVAL;
+
+	/* check if file is oplocked */
+	if (((arg == F_RDLCK) &&
+		(CIFS_I(inode)->clientCanCacheRead)) ||
+	    ((arg == F_WRLCK) &&
+		(CIFS_I(inode)->clientCanCacheAll)))
+		return generic_setlease(file, arg, lease);
+	else if (tlink_tcon(cfile->tlink)->local_lease &&
+		 !CIFS_I(inode)->clientCanCacheRead)
+		/* If the server claims to support oplock on this
+		   file, then we still need to check oplock even
+		   if the local_lease mount option is set, but there
+		   are servers which do not support oplock for which
+		   this mount option may be useful if the user
+		   knows that the file won't be changed on the server
+		   by anyone else */
+		return generic_setlease(file, arg, lease);
+	else
+		return -EAGAIN;
+}
+
 static struct cifsLockInfo *
 cifs_lock_init(__u64 len, __u64 offset, __u8 type, __u16 netfid)
 {
@@ -2178,6 +2266,25 @@ ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 	return cifs_user_writev(iocb, iov, nr_segs, pos);
 }
 
+ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
+			    unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	ssize_t written;
+	int rc;
+
+	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	if (CIFS_I(inode)->clientCanCacheAll)
+		return written;
+
+	rc = filemap_fdatawrite(inode->i_mapping);
+	if (rc)
+		cFYI(1, "cifs_file_aio_write: %d rc on %p inode", rc, inode);
+
+	return written;
+}
+
 static ssize_t
 cifs_iovec_read(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
new file mode 100644
index 0000000..8b4d802
--- /dev/null
+++ b/fs/cifs/smb2file.c
@@ -0,0 +1,274 @@
+/*
+ *   fs/cifs/smb2file.c
+ *
+ *   Copyright (C) 2011
+ *   Author(s): Pavel Shilovsky (piastryyy@gmail.com),
+ *              Steve French (sfrench@us.ibm.com)
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include <linux/fs.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <asm/div64.h>
+#include "cifsfs.h"
+#include "cifspdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+#include "cifs_fs_sb.h"
+#include "cifs_unicode.h"
+#include "fscache.h"
+#include "smb2glob.h"
+#include "smb2proto.h"
+
+const struct file_operations smb2_file_ops = {
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = generic_file_aio_read,
+	.aio_write = cifs_file_aio_write,
+	.open = smb2_open,
+	.release = cifs_close,
+	.lock = cifs_lock,
+	.fsync = cifs_fsync,
+	.flush = cifs_flush,
+	.mmap  = cifs_file_mmap,
+	.splice_read = generic_file_splice_read,
+	.llseek = cifs_llseek,
+#ifdef CONFIG_CIFS_POSIX
+	.unlocked_ioctl	= cifs_ioctl,
+#endif /* CONFIG_CIFS_POSIX */
+	.setlease = cifs_setlease,
+};
+
+const struct file_operations smb2_file_strict_ops = {
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = cifs_strict_readv,
+	.aio_write = cifs_strict_writev,
+	.open = smb2_open,
+	.release = cifs_close,
+	.lock = cifs_lock,
+	.fsync = cifs_strict_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_strict_mmap,
+	.splice_read = generic_file_splice_read,
+	.llseek = cifs_llseek,
+#ifdef CONFIG_CIFS_POSIX
+	.unlocked_ioctl	= cifs_ioctl,
+#endif /* CONFIG_CIFS_POSIX */
+	.setlease = cifs_setlease,
+};
+
+const struct file_operations smb2_file_direct_ops = {
+	/* BB reevaluate whether they can be done with directio, no cache */
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = cifs_user_readv,
+	.aio_write = cifs_user_writev,
+	.open = smb2_open,
+	.release = cifs_close,
+	.lock = cifs_lock,
+	.fsync = cifs_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_mmap,
+	.splice_read = generic_file_splice_read,
+#ifdef CONFIG_CIFS_POSIX
+	.unlocked_ioctl  = cifs_ioctl,
+#endif /* CONFIG_CIFS_POSIX */
+	.llseek = cifs_llseek,
+	.setlease = cifs_setlease,
+};
+
+const struct file_operations smb2_file_nobrl_ops = {
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = generic_file_aio_read,
+	.aio_write = cifs_file_aio_write,
+	.open = smb2_open,
+	.release = cifs_close,
+	.fsync = cifs_fsync,
+	.flush = cifs_flush,
+	.mmap  = cifs_file_mmap,
+	.splice_read = generic_file_splice_read,
+	.llseek = cifs_llseek,
+#ifdef CONFIG_CIFS_POSIX
+	.unlocked_ioctl	= cifs_ioctl,
+#endif /* CONFIG_CIFS_POSIX */
+	.setlease = cifs_setlease,
+};
+
+const struct file_operations smb2_file_strict_nobrl_ops = {
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = cifs_strict_readv,
+	.aio_write = cifs_strict_writev,
+	.open = smb2_open,
+	.release = cifs_close,
+	.fsync = cifs_strict_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_strict_mmap,
+	.splice_read = generic_file_splice_read,
+	.llseek = cifs_llseek,
+#ifdef CONFIG_CIFS_POSIX
+	.unlocked_ioctl	= cifs_ioctl,
+#endif /* CONFIG_CIFS_POSIX */
+	.setlease = cifs_setlease,
+};
+
+const struct file_operations smb2_file_direct_nobrl_ops = {
+	/* BB reevaluate whether they can be done with directio, no cache */
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = cifs_user_readv,
+	.aio_write = cifs_user_writev,
+	.open = smb2_open,
+	.release = cifs_close,
+	.fsync = cifs_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_mmap,
+	.splice_read = generic_file_splice_read,
+#ifdef CONFIG_CIFS_POSIX
+	.unlocked_ioctl  = cifs_ioctl,
+#endif /* CONFIG_CIFS_POSIX */
+	.llseek = cifs_llseek,
+	.setlease = cifs_setlease,
+};
+
+struct cifsFileInfo *
+smb2_new_fileinfo(__u64 persist_fid, __u64 volatile_fid, struct file *file,
+		  struct tcon_link *tlink, __u32 oplock)
+{
+	struct cifsFileInfo *cifs_file;
+
+	cifs_file = cifs_new_fileinfo_generic(file, tlink, oplock);
+	if (cifs_file == NULL)
+		return NULL;
+	cifs_file->persist_fid = persist_fid;
+	cifs_file->volatile_fid = volatile_fid;
+	return cifs_file;
+}
+
+static int
+smb2_open_helper(struct file *file, struct inode *inode, const char *full_path,
+		 __u8 *oplock, __u64 *persist_fid, __u64 *volatile_fid,
+		 FILE_ALL_INFO *data, struct cifs_tcon *tcon, int xid)
+{
+	int rc;
+	__u32 desired_access = FILE_READ_ATTRIBUTES;
+	__u32 create_disposition;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	__le16 *smb2_path;
+	FILE_ALL_INFO_SMB2 *smb2_data = NULL;
+
+	desired_access = cifs_convert_flags(file->f_flags);
+	create_disposition = cifs_get_disposition(file->f_flags);
+
+	smb2_path = cifs_convert_path_to_ucs(full_path, cifs_sb->local_nls);
+	if (smb2_path == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	smb2_data = kzalloc(sizeof(FILE_ALL_INFO_SMB2) + MAX_NAME*2,
+			    GFP_KERNEL);
+	if (smb2_data == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = SMB2_open(xid, tcon, smb2_path, persist_fid, volatile_fid,
+		       desired_access, create_disposition, 0, 0);
+
+	if (rc)
+		goto out;
+
+	rc = SMB2_query_info(xid, tcon, *persist_fid, *volatile_fid, smb2_data);
+	if (rc) {
+		SMB2_close(xid, tcon, *persist_fid, *volatile_fid);
+		goto out;
+	}
+
+	move_smb2_info_to_cifs(data, smb2_data);
+out:
+	*oplock = 0;
+	kfree(smb2_data);
+	kfree(smb2_path);
+	return rc;
+}
+
+int smb2_open(struct inode *inode, struct file *file)
+{
+	int rc = -EACCES;
+	int xid;
+	__u8 oplock;
+	struct cifs_sb_info *cifs_sb;
+	struct cifsFileInfo *cifs_file;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	__u64 persist_fid, volatile_fid;
+	char *full_path;
+	FILE_ALL_INFO *data = NULL;
+
+	xid = GetXid();
+
+	cifs_sb = CIFS_SB(inode->i_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		FreeXid(xid);
+		return PTR_ERR(tlink);
+	}
+	tcon = tlink_tcon(tlink);
+
+	full_path = build_path_from_dentry(file->f_path.dentry);
+	if (full_path == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	data = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	if (data == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = smb2_open_helper(file, inode, full_path, &oplock, &persist_fid,
+			      &volatile_fid, data, tcon, xid);
+	if (rc)
+		goto out;
+
+	rc = smb2_query_inode_info(&inode, full_path, data, inode->i_sb, xid);
+	if (rc) {
+		SMB2_close(xid, tcon, persist_fid, volatile_fid);
+		goto out;
+	}
+
+	cifs_file = smb2_new_fileinfo(persist_fid, volatile_fid, file, tlink,
+				      oplock);
+	if (cifs_file == NULL) {
+		SMB2_close(xid, tcon, persist_fid, volatile_fid);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	cifs_fscache_set_inode_cookie(inode, file);
+out:
+	kfree(full_path);
+	kfree(data);
+	FreeXid(xid);
+	cifs_put_tlink(tlink);
+	return rc;
+}
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 9111153..4b33f16 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -96,18 +96,18 @@ void smb2_set_ops(struct inode *inode)
 		inode->i_op = &smb2_file_inode_ops;
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
-				inode->i_fop = &cifs_file_direct_nobrl_ops;
+				inode->i_fop = &smb2_file_direct_nobrl_ops;
 			else
-				inode->i_fop = &cifs_file_direct_ops;
+				inode->i_fop = &smb2_file_direct_ops;
 		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
-				inode->i_fop = &cifs_file_strict_nobrl_ops;
+				inode->i_fop = &smb2_file_strict_nobrl_ops;
 			else
-				inode->i_fop = &cifs_file_strict_ops;
+				inode->i_fop = &smb2_file_strict_ops;
 		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
-			inode->i_fop = &cifs_file_nobrl_ops;
+			inode->i_fop = &smb2_file_nobrl_ops;
 		else { /* not direct, send byte range locks */
-			inode->i_fop = &cifs_file_ops;
+			inode->i_fop = &smb2_file_ops;
 		}
 
 		/* check if server can support readpages */
@@ -177,7 +177,7 @@ smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
 	return rc;
 }
 
-static void
+void
 move_smb2_info_to_cifs(FILE_ALL_INFO *dst, FILE_ALL_INFO_SMB2 *src)
 {
 	memcpy(dst, src, (size_t)(&src->CurrentByteOffset) - (size_t)src);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 891a51f..6bc3476 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1069,9 +1069,9 @@ int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
 	if (rc)
 		return rc;
 
-	if (oplockEnabled)
+	/* if (enable_oplocks)
 		pSMB2->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_BATCH;
-	else
+	else */
 		pSMB2->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
 	pSMB2->ImpersonationLevel = IL_IMPERSONATION;
 	pSMB2->DesiredAccess = cpu_to_le32(desired_access);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 2c5cf2c..b7d1f46 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -37,6 +37,13 @@ extern const struct inode_operations smb2_symlink_inode_ops;
 
 extern const struct file_operations smb2_dir_ops;
 
+extern const struct file_operations smb2_file_ops;
+extern const struct file_operations smb2_file_direct_ops; /* if directio mnt */
+extern const struct file_operations smb2_file_strict_ops; /* if strictio mnt */
+extern const struct file_operations smb2_file_nobrl_ops; /* no brlocks */
+extern const struct file_operations smb2_file_direct_nobrl_ops;
+extern const struct file_operations smb2_file_strict_nobrl_ops;
+
 /* extern char *build_smb2path_from_dentry(struct dentry *);*/
 extern __le16 *build_ucspath_from_dentry(struct dentry *);
 /*extern __le16 *smb2_build_path_to_root(struct cifs_sb_info *smb2_sb);
@@ -84,6 +91,7 @@ extern int smb2_setup_session(unsigned int xid, struct cifs_ses *pses_info,
 			      struct nls_table *nls_info);
 extern int smb2_umount(struct super_block *, struct cifs_sb_info *);
 
+extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst, FILE_ALL_INFO_SMB2 *src);
 extern int smb2_query_inode_info(struct inode **pinode, const char *full_path,
 				 FILE_ALL_INFO *data, struct super_block *sb,
 				 int xid);
@@ -100,6 +108,13 @@ extern void smb2_create_dfs_attr(struct cifs_fattr *fattr,
 extern void cifs_fattr_to_inode(struct inode *pinode, struct cifs_fattr *attr);
 extern int smb2_fsync(struct file *file, int datasync);
 extern int smb2_flush(struct file *file, fl_owner_t id);
+extern struct cifsFileInfo *smb2_new_fileinfo(__u64 persist_fid,
+					      __u64 volatile_fid,
+					      struct file *file,
+					      struct tcon_link *tlink,
+					      __u32 oplock);
+
+extern int smb2_open(struct inode *inode, struct file *file);
 
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
-- 
1.7.1

