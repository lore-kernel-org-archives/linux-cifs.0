From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/7] CIFS: Implement cifs_strict_read
Date: Mon, 13 Dec 2010 18:00:53 +0300
Message-ID: <1292252455-4025-5-git-send-email-piastryyy@gmail.com>
References: <1292252455-4025-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292252455-4025-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Read from the cache if we have at least Level II oplock - otherwise
read from the server.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/cifsproto.h |    2 ++
 fs/cifs/file.c      |    4 ++--
 3 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a0e35d3..e3f0024 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -575,8 +575,54 @@ cifs_do_mount(struct file_system_type *fs_type,
 static ssize_t cifs_strict_read(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos)
 {
-	ssize_t read = 0;
-	/* BB */
+	struct inode *inode;
+	struct cifs_sb_info *cifs_sb;
+	ssize_t read;
+	unsigned long i, len = 0;
+	char *buf, *offset;
+
+	inode = iocb->ki_filp->f_path.dentry->d_inode;
+	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
+
+	if (CIFS_I(inode)->clientCanCacheRead)
+		return generic_file_aio_read(iocb, iov, nr_segs, pos);
+
+	/*
+	 * In strict cache mode we need to read from the server all the time
+	 * if we don't have level II oplock because the server can delay mtime
+	 * change - so we can't make a decision about inode invalidating.
+	 * And we can also fail with pagereading if there are mandatory locks
+	 * on pages affected by this read but not on the region from pos to
+	 * pos+len-1.
+	 */
+
+	for (i = 0; i < nr_segs; i++)
+		len += iov[i].iov_len;
+
+	buf = kmalloc(len, GFP_KERNEL);
+
+	read = cifs_read(iocb->ki_filp, buf, len, &pos);
+	if (read < 0) {
+		kfree(buf);
+		return read;
+	}
+
+	for (i = 0, offset = buf, len = read; i < nr_segs && len; i++) {
+		unsigned long cur_len = min_t(unsigned long, len,
+					      iov[i].iov_len);
+
+		if (copy_to_user(iov[i].iov_base, offset, cur_len)) {
+			kfree(buf);
+			return -EFAULT;
+		}
+
+		len -= cur_len;
+		offset += cur_len;
+	}
+
+	iocb->ki_pos = pos;
+
+	kfree(buf);
 	return read;
 }
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e6d1481..05f6446 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -79,6 +79,8 @@ extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
 extern bool is_valid_oplock_break(struct smb_hdr *smb,
 				  struct TCP_Server_Info *);
 extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
+extern ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
+			 loff_t *poffset);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern unsigned int smbCalcSize(struct smb_hdr *ptr);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index dd1e59a..1f96326 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1758,8 +1758,8 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 }
 
 
-static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
-	loff_t *poffset)
+ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
+		  loff_t *poffset)
 {
 	int rc = -EACCES;
 	unsigned int bytes_read = 0;
-- 
1.7.3.2
