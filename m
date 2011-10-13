From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: patch to build current cifs on "2.6.40"
Date: Thu, 13 Oct 2011 18:21:34 -0500
Message-ID: <CAH2r5mtS1jbSoyvppoEP49nELRZYrLH7WurqrafqKQz5CsPf_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I wanted to test cifs on a "2.6.40" (Fedora) system and due to video
driver issues couldn't use current mainline so ... here is a patch to
build current cifs on older (2.6.40 or 3.0) kernels.

diff -u /home/stevef/kernel-cifs.git/fs/cifs/cifsfs.c ./cifsfs.c
--- /home/stevef/kernel-cifs.git/fs/cifs/cifsfs.c	2011-10-12
23:42:05.196815382 -0500
+++ ./cifsfs.c	2011-10-13 17:52:30.744806928 -0500
@@ -210,7 +210,7 @@
 	return 0;
 }

-static int cifs_permission(struct inode *inode, int mask)
+static int cifs_permission(struct inode *inode, int mask, unsigned int flags)
 {
 	struct cifs_sb_info *cifs_sb;

@@ -225,7 +225,7 @@
 		on the client (above and beyond ACL on servers) for
 		servers which do not support setting and viewing mode bits,
 		so allowing client to check permissions is useful */
-		return generic_permission(inode, mask);
+		return generic_permission(inode, mask, flags, NULL);
 }

 static struct kmem_cache *cifs_inode_cachep;
diff -u /home/stevef/kernel-cifs.git/fs/cifs/cifsfs.h ./cifsfs.h
--- /home/stevef/kernel-cifs.git/fs/cifs/cifsfs.h	2011-10-12
23:41:27.634817012 -0500
+++ ./cifsfs.h	2011-10-13 17:44:45.784798721 -0500
@@ -87,8 +87,8 @@
 extern ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 				  unsigned long nr_segs, loff_t pos);
 extern int cifs_lock(struct file *, int, struct file_lock *);
-extern int cifs_fsync(struct file *, loff_t, loff_t, int);
-extern int cifs_strict_fsync(struct file *, loff_t, loff_t, int);
+extern int cifs_fsync(struct file *, int);
+extern int cifs_strict_fsync(struct file *, int);
 extern int cifs_flush(struct file *, fl_owner_t id);
 extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
 extern int cifs_file_strict_mmap(struct file * , struct vm_area_struct *);
diff -u /home/stevef/kernel-cifs.git/fs/cifs/file.c ./file.c
--- /home/stevef/kernel-cifs.git/fs/cifs/file.c	2011-10-13
17:16:08.726768410 -0500
+++ ./file.c	2011-10-13 17:54:56.180809494 -0500
@@ -1442,7 +1411,7 @@
 	return rc;
 }

-int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
+int cifs_strict_fsync(struct file *file,
 		      int datasync)
 {
 	int xid;
@@ -1452,7 +1421,7 @@
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);

-	rc = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	rc = filemap_write_and_wait(inode->i_mapping);
 	if (rc)
 		return rc;
 	mutex_lock(&inode->i_mutex);
@@ -1479,7 +1448,7 @@
 	return rc;
 }

-int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+int cifs_fsync(struct file *file, int datasync)
 {
 	int xid;
 	int rc = 0;
@@ -1488,7 +1457,7 @@
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	struct inode *inode = file->f_mapping->host;

-	rc = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	rc = filemap_write_and_wait(inode->i_mapping);
 	if (rc)
 		return rc;
 	mutex_lock(&inode->i_mutex);

-- 
Thanks,

Steve
