From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] CIFS: Implement cifs_file_strict_mmap
Date: Tue, 14 Dec 2010 14:10:57 +0300
Message-ID: <1292325060-8828-3-git-send-email-piastryyy@gmail.com>
References: <1292325060-8828-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292325060-8828-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Invalidate inode mapping if we don't have at least Level II oplock.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |    4 ++--
 fs/cifs/cifsfs.h |    1 +
 fs/cifs/file.c   |   17 +++++++++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 7660133..a218afe 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -720,7 +720,7 @@ const struct file_operations cifs_file_strict_ops = {
 	.lock = cifs_lock,
 	.fsync = cifs_strict_fsync,
 	.flush = cifs_flush,
-	.mmap = cifs_file_mmap,
+	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
@@ -775,7 +775,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 	.release = cifs_close,
 	.fsync = cifs_strict_fsync,
 	.flush = cifs_flush,
-	.mmap = cifs_file_mmap,
+	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 8584829..657738f 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -89,6 +89,7 @@ extern int cifs_fsync(struct file *, int);
 extern int cifs_strict_fsync(struct file *, int);
 extern int cifs_flush(struct file *, fl_owner_t id);
 extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
+extern int cifs_file_strict_mmap(struct file * , struct vm_area_struct *);
 extern const struct file_operations cifs_dir_ops;
 extern int cifs_dir_open(struct inode *inode, struct file *file);
 extern int cifs_readdir(struct file *file, void *direntry, filldir_t filldir);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4e37cb8..dd1e59a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1827,17 +1827,34 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	return total_read;
 }
 
+int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int rc, xid;
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	xid = GetXid();
+
+	if (!CIFS_I(inode)->clientCanCacheRead)
+		cifs_invalidate_mapping(inode);
+
+	rc = generic_file_mmap(file, vma);
+	FreeXid(xid);
+	return rc;
+}
+
 int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int rc, xid;
 
 	xid = GetXid();
+
 	rc = cifs_revalidate_file(file);
 	if (rc) {
 		cFYI(1, "Validation prior to mmap failed, error=%d", rc);
 		FreeXid(xid);
 		return rc;
 	}
+
 	rc = generic_file_mmap(file, vma);
 	FreeXid(xid);
 	return rc;
-- 
1.7.3.2
