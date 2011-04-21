From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Add rwpidforward mount option
Date: Thu, 21 Apr 2011 17:26:35 +0400
Message-ID: <1303392395-9217-2-git-send-email-piastry@etersoft.ru>
References: <1303392395-9217-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303392395-9217-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add rwpidforward mount option that switches on a mode when we forward
pid of a process who opened a file to any read and write operation.

This can prevent applications like WINE from failing on read or write
operation on a previously locked file region from the same netfd from
another process if we use mandatory brlock style.
It is actual for WINE because during a run of WINE program two processes
work on the same netfd - share the same file struct between several VFS
fds:
1) WINE-server does open and lock;
2) WINE-application does read and write.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/README       |    3 +++
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsfs.c     |    8 ++++++++
 fs/cifs/cifsproto.h  |   16 ++++++++--------
 fs/cifs/cifssmb.c    |   19 +++++++++++++------
 fs/cifs/connect.c    |    5 +++++
 fs/cifs/dir.c        |    4 ++--
 fs/cifs/file.c       |   48 ++++++++++++++++++++++++++++++++++++------------
 fs/cifs/inode.c      |   10 ++++++----
 fs/cifs/link.c       |    6 +++---
 10 files changed, 85 insertions(+), 35 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index 4a3ca0e..c5c2c5e 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -457,6 +457,9 @@ A partial list of the supported mount options follows:
 		otherwise - read from the server. All written data are stored
 		in the cache, but if the client doesn't have Exclusive Oplock,
 		it writes the data to the server.
+  rwpidforward  Forward pid of a process who opened a file to any read or write
+		operation on that file. This prevent applications like WINE
+		from failing on read and write if we use mandatory brlock style.
   acl   	Allow setfacl and getfacl to manage posix ACLs if server
 		supports them.  (default)
   noacl 	Do not allow setfacl and getfacl calls on this mount
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 1ef54ab..867ae15 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -43,6 +43,7 @@
 #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
 #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
 #define CIFS_MOUNT_STRICT_IO	0x40000 /* strict cache mode */
+#define CIFS_MOUNT_RWPIDFORWARD	0x80000 /* use pid forwarding for rw */
 
 struct cifs_sb_info {
 	struct rb_root tlink_tree;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fb6a2ad..9d07558 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -460,6 +460,10 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 		seq_printf(s, ",nocase");
 	if (tcon->retry)
 		seq_printf(s, ",hard");
+	if (tcon->unix_ext)
+		seq_printf(s, ",unix");
+	else
+		seq_printf(s, ",nounix");
 	if (cifs_sb->prepath)
 		seq_printf(s, ",prepath=%s", cifs_sb->prepath);
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
@@ -468,6 +472,10 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 		seq_printf(s, ",setuids");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
 		seq_printf(s, ",serverino");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		seq_printf(s, ",rwpidforward");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
+		seq_printf(s, ",forcemand");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
 		seq_printf(s, ",directio");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index a2eb860..4f68d97 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -334,15 +334,15 @@ extern int CIFSSMBClose(const int xid, struct cifs_tcon *tcon,
 extern int CIFSSMBFlush(const int xid, struct cifs_tcon *tcon,
 			const int smb_file_id);
 
-extern int CIFSSMBRead(const int xid, struct cifs_tcon *tcon,
-			const int netfid, unsigned int count,
-			const __u64 lseek, unsigned int *nbytes, char **buf,
-			int *return_buf_type);
+extern int CIFSSMBRead(const int xid, struct cifs_tcon *tcon, const int netfid,
+		       const __u32 netpid, const unsigned int count,
+		       const __u64 lseek, unsigned int *nbytes, char **buf,
+		       int *return_buf_type);
 extern int CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
-			const int netfid, const unsigned int count,
-			const __u64 lseek, unsigned int *nbytes,
-			const char *buf, const char __user *ubuf,
-			const int long_op);
+			const int netfid, const __u32 netpid,
+			const unsigned int count, const __u64 lseek,
+			unsigned int *nbytes, const char *buf,
+			const char __user *ubuf, const int long_op);
 extern int CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
 			const int netfid, const __u32 netpid,
 			const unsigned int count, const __u64 offset,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 17d1cbf..890897c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1380,8 +1380,8 @@ openRetry:
 
 int
 CIFSSMBRead(const int xid, struct cifs_tcon *tcon, const int netfid,
-	    const unsigned int count, const __u64 lseek, unsigned int *nbytes,
-	    char **buf, int *pbuf_type)
+	    const __u32 netpid, const unsigned int count, const __u64 lseek,
+	    unsigned int *nbytes, char **buf, int *pbuf_type)
 {
 	int rc = -EACCES;
 	READ_REQ *pSMB = NULL;
@@ -1407,6 +1407,9 @@ CIFSSMBRead(const int xid, struct cifs_tcon *tcon, const int netfid,
 	if (rc)
 		return rc;
 
+	pSMB->hdr.Pid = cpu_to_le16((__u16)netpid);
+	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(netpid >> 16));
+
 	/* tcon and ses pointer are checked in smb_init */
 	if (tcon->ses->server == NULL)
 		return -ECONNABORTED;
@@ -1484,10 +1487,10 @@ CIFSSMBRead(const int xid, struct cifs_tcon *tcon, const int netfid,
 
 
 int
-CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
-	     const int netfid, const unsigned int count,
-	     const __u64 offset, unsigned int *nbytes, const char *buf,
-	     const char __user *ubuf, const int long_op)
+CIFSSMBWrite(const int xid, struct cifs_tcon *tcon, const int netfid,
+	     const __u32 netpid, const unsigned int count, const __u64 offset,
+	     unsigned int *nbytes, const char *buf, const char __user *ubuf,
+	     const int long_op)
 {
 	int rc = -EACCES;
 	WRITE_REQ *pSMB = NULL;
@@ -1516,6 +1519,10 @@ CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
 		      (void **) &pSMBr);
 	if (rc)
 		return rc;
+
+	pSMB->hdr.Pid = cpu_to_le16((__u16)netpid);
+	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(netpid >> 16));
+
 	/* tcon and ses pointer are checked in smb_init */
 	if (tcon->ses->server == NULL)
 		return -ECONNABORTED;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 94e60c5..7eab9b2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -103,6 +103,7 @@ struct smb_vol {
 	bool noautotune:1;
 	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
 	bool fsc:1;	/* enable fscache */
+	bool rwpidforward:1; /* pid forward for rw */
 	bool mfsymlinks:1; /* use Minshall+French Symlinks */
 	bool multiuser:1;
 	bool use_smb2:1; /* force smb2 use on mount instead of cifs */
@@ -1362,6 +1363,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 			vol->server_ino = 1;
 		} else if (strnicmp(data, "noserverino", 9) == 0) {
 			vol->server_ino = 0;
+		} else if (strnicmp(data, "rwpidforward", 4) == 0) {
+			vol->rwpidforward = 1;
 		} else if (strnicmp(data, "cifsacl", 7) == 0) {
 			vol->cifs_acl = 1;
 		} else if (strnicmp(data, "nocifsacl", 9) == 0) {
@@ -2643,6 +2646,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOSSYNC;
 	if (pvolume_info->mand_lock)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOPOSIXBRL;
+	if (pvolume_info->rwpidforward)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
 	if (pvolume_info->cifs_acl)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
 	if (pvolume_info->override_uid)
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index ab74179..6cdac98 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -446,7 +446,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 		pdev->minor =
 		      cpu_to_le64(MINOR(device_number));
 		rc = CIFSSMBWrite(xid, pTcon,
-			fileHandle,
+			fileHandle, current->tgid,
 			sizeof(struct win_dev),
 			0, &bytes_written, (char *)pdev,
 			NULL, 0);
@@ -457,7 +457,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 		pdev->minor =
 		      cpu_to_le64(MINOR(device_number));
 		rc = CIFSSMBWrite(xid, pTcon,
-			fileHandle,
+			fileHandle, current->tgid,
 			sizeof(struct win_dev),
 			0, &bytes_written, (char *)pdev,
 			NULL, 0);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 838f06c..b2bd01a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -725,8 +725,8 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 			else
 				posix_lock_type = CIFS_WRLCK;
 			rc = CIFSSMBPosixLock(xid, tcon, netfid, 1 /* get */,
-					length,	pfLock,
-					posix_lock_type, wait_flag);
+					length, pfLock, posix_lock_type,
+					wait_flag);
 			FreeXid(xid);
 			return rc;
 		}
@@ -797,8 +797,8 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 			posix_lock_type = CIFS_UNLCK;
 
 		rc = CIFSSMBPosixLock(xid, tcon, netfid, 0 /* set */,
-				      length, pfLock,
-				      posix_lock_type, wait_flag);
+				      length, pfLock, posix_lock_type,
+				      wait_flag);
 	} else {
 		struct cifsFileInfo *fid = file->private_data;
 
@@ -1569,6 +1569,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	struct cifs_tcon *pTcon;
 	struct cifs_sb_info *cifs_sb;
 	int xid, rc;
+	__u32 netpid;
 
 	len = iov_length(iov, nr_segs);
 	if (!len)
@@ -1600,6 +1601,12 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 
 	xid = GetXid();
 	open_file = file->private_data;
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		netpid = open_file->pid;
+	else
+		netpid = current->tgid;
+
 	pTcon = tlink_tcon(open_file->tlink);
 	inode = file->f_path.dentry->d_inode;
 
@@ -1627,8 +1634,8 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 					break;
 			}
 			rc = CIFSSMBWrite2(xid, pTcon, open_file->netfid,
-					   current->tgid, cur_len, *poffset,
-					   &written, to_send, npages, 0);
+					   netpid, cur_len, *poffset, &written,
+					   to_send, npages, 0);
 		} while (rc == -EAGAIN);
 
 		for (i = 0; i < npages; i++)
@@ -1725,6 +1732,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	struct cifsFileInfo *open_file;
 	struct smb_com_read_rsp *pSMBr;
 	char *read_data;
+	__u32 netpid;
 
 	if (!nr_segs)
 		return 0;
@@ -1739,6 +1747,11 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	open_file = file->private_data;
 	pTcon = tlink_tcon(open_file->tlink);
 
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		netpid = open_file->pid;
+	else
+		netpid = current->tgid;
+
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
 
@@ -1755,7 +1768,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 					break;
 			}
 			rc = CIFSSMBRead(xid, pTcon, open_file->netfid,
-					 cur_len, *poffset, &bytes_read,
+					 netpid, cur_len, *poffset, &bytes_read,
 					 &read_data, &buf_type);
 			pSMBr = (struct smb_com_read_rsp *)read_data;
 			if (read_data) {
@@ -1837,6 +1850,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	char *current_offset;
 	struct cifsFileInfo *open_file;
 	int buf_type = CIFS_NO_BUFFER;
+	__u32 netpid;
 
 	xid = GetXid();
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
@@ -1849,6 +1863,11 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	open_file = file->private_data;
 	pTcon = tlink_tcon(open_file->tlink);
 
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		netpid = open_file->pid;
+	else
+		netpid = current->tgid;
+
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
 
@@ -1872,7 +1891,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 					break;
 			}
 			rc = CIFSSMBRead(xid, pTcon,
-					 open_file->netfid,
+					 open_file->netfid, netpid,
 					 current_read_size, *poffset,
 					 &bytes_read, &current_offset,
 					 &buf_type);
@@ -2010,6 +2029,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	struct smb_com_read_rsp *pSMBr;
 	struct cifsFileInfo *open_file;
 	int buf_type = CIFS_NO_BUFFER;
+	__u32 netpid;
 
 	xid = GetXid();
 	if (file->private_data == NULL) {
@@ -2031,6 +2051,11 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		goto read_complete;
 
 	cFYI(DBG2, "rpages: num pages %d", num_pages);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		netpid = open_file->pid;
+	else
+		netpid = current->tgid;
+
 	for (i = 0; i < num_pages; ) {
 		unsigned contig_pages;
 		struct page *tmp_page;
@@ -2074,10 +2099,9 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 			}
 
 			rc = CIFSSMBRead(xid, pTcon,
-					 open_file->netfid,
-					 read_size, offset,
-					 &bytes_read, &smb_read_data,
-					 &buf_type);
+					 open_file->netfid, netpid,
+					 read_size, offset, &bytes_read,
+					 &smb_read_data, &buf_type);
 			/* BB more RC checks ? */
 			if (rc == -EAGAIN) {
 				if (smb_read_data) {
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index adb6324..bafeae6 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -405,7 +405,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 	if (rc == 0) {
 		int buf_type = CIFS_NO_BUFFER;
 			/* Read header */
-		rc = CIFSSMBRead(xid, tcon, netfid,
+		rc = CIFSSMBRead(xid, tcon, netfid, current->tgid,
 				 24 /* length */, 0 /* offset */,
 				 &bytes_read, &pbuf, &buf_type);
 		if ((rc == 0) && (bytes_read >= 8)) {
@@ -1859,8 +1859,9 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		cFYI(1, "SetFSize for attrs rc = %d", rc);
 		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			unsigned int bytes_written;
-			rc = CIFSSMBWrite(xid, pTcon, nfid, 0, attrs->ia_size,
-					  &bytes_written, NULL, NULL, 1);
+			rc = CIFSSMBWrite(xid, pTcon, nfid, npid,
+					  0, attrs->ia_size, &bytes_written,
+					  NULL, NULL, 1);
 			cFYI(1, "Wrt seteof rc %d", rc);
 		}
 	} else
@@ -1895,7 +1896,8 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 			if (rc == 0) {
 				unsigned int bytes_written;
-				rc = CIFSSMBWrite(xid, pTcon, netfid, 0,
+				rc = CIFSSMBWrite(xid, pTcon, netfid,
+						  current->tgid, 0,
 						  attrs->ia_size,
 						  &bytes_written, NULL,
 						  NULL, 1);
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 3a097b6..7536104 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -203,7 +203,7 @@ CIFSCreateMFSymLink(const int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	rc = CIFSSMBWrite(xid, tcon, netfid,
+	rc = CIFSSMBWrite(xid, tcon, netfid, current->tgid,
 			  CIFS_MF_SYMLINK_FILE_SIZE /* length */,
 			  0 /* offset */,
 			  &bytes_written, buf, NULL, 0);
@@ -250,7 +250,7 @@ CIFSQueryMFSymLink(const int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 	pbuf = buf;
 
-	rc = CIFSSMBRead(xid, tcon, netfid,
+	rc = CIFSSMBRead(xid, tcon, netfid, current->tgid,
 			 CIFS_MF_SYMLINK_FILE_SIZE /* length */,
 			 0 /* offset */,
 			 &bytes_read, &pbuf, &buf_type);
@@ -329,7 +329,7 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 	}
 	pbuf = buf;
 
-	rc = CIFSSMBRead(xid, pTcon, netfid,
+	rc = CIFSSMBRead(xid, pTcon, netfid, current->tgid,
 			 CIFS_MF_SYMLINK_FILE_SIZE /* length */,
 			 0 /* offset */,
 			 &bytes_read, &pbuf, &buf_type);
-- 
1.7.1
