From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/2] CIFS: Use pid saved in cifsFileInfo in writepages and set_file_size
Date: Wed,  4 May 2011 13:44:30 +0400
Message-ID: <1304502271-11557-1-git-send-email-piastry@etersoft.ru>
References: <linux-cifs@vger.kernel.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We need it to make them work with mandatory locking style because
we can fail in a situation like when kernel need to flush dirty pages
and there is a lock held by process who opened file.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    8 ++++++++
 fs/cifs/cifsproto.h |   13 +++++--------
 fs/cifs/cifssmb.c   |   30 +++++++++++++++++++++++-------
 fs/cifs/dir.c       |   18 ++++++++++--------
 fs/cifs/file.c      |   44 ++++++++++++++++++++++++++++++--------------
 fs/cifs/inode.c     |   24 ++++++++++++++++++------
 fs/cifs/link.c      |   12 ++++++++----
 7 files changed, 102 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 76b4517..c7e38cf 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -455,6 +455,14 @@ struct cifsFileInfo {
 	struct work_struct oplock_break; /* work for oplock breaks */
 };
 
+struct cifs_io_parms {
+	__u16 netfid;
+	__u32 pid;
+	__u64 offset;
+	unsigned int length;
+	struct cifsTconInfo *tcon;
+};
+
 /*
  * Take a reference on the file private data. Must be called with
  * cifs_file_list_lock held.
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7c1ed01..90d33c3 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -341,15 +341,12 @@ extern int CIFSSMBRead(const int xid, struct cifsTconInfo *tcon,
 			const int netfid, unsigned int count,
 			const __u64 lseek, unsigned int *nbytes, char **buf,
 			int *return_buf_type);
-extern int CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
-			const int netfid, const unsigned int count,
-			const __u64 lseek, unsigned int *nbytes,
-			const char *buf, const char __user *ubuf,
+extern int CIFSSMBWrite(const int xid, struct cifs_io_parms *io_parms,
+			unsigned int *nbytes, const char *buf,
+			const char __user *ubuf, const int long_op);
+extern int CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
+			unsigned int *nbytes, struct kvec *iov, const int nvec,
 			const int long_op);
-extern int CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
-			const int netfid, const unsigned int count,
-			const __u64 offset, unsigned int *nbytes,
-			struct kvec *iov, const int nvec, const int long_op);
 extern int CIFSGetSrvInodeNumber(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName, __u64 *inode_number,
 			const struct nls_table *nls_codepage,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8800409..a0f7fc4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1484,9 +1484,8 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
 
 
 int
-CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
-	     const int netfid, const unsigned int count,
-	     const __u64 offset, unsigned int *nbytes, const char *buf,
+CIFSSMBWrite(const int xid, struct cifs_io_parms *io_parms,
+	     unsigned int *nbytes, const char *buf,
 	     const char __user *ubuf, const int long_op)
 {
 	int rc = -EACCES;
@@ -1495,6 +1494,11 @@ CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
 	int bytes_returned, wct;
 	__u32 bytes_sent;
 	__u16 byte_count;
+	__u32 pid = io_parms->pid;
+	__u16 netfid = io_parms->netfid;
+	__u64 offset = io_parms->offset;
+	struct cifsTconInfo *tcon = io_parms->tcon;
+	unsigned int count = io_parms->length;
 
 	*nbytes = 0;
 
@@ -1516,6 +1520,10 @@ CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
 		      (void **) &pSMBr);
 	if (rc)
 		return rc;
+
+	pSMB->hdr.Pid = cpu_to_le16((__u16)pid);
+	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
+
 	/* tcon and ses pointer are checked in smb_init */
 	if (tcon->ses->server == NULL)
 		return -ECONNABORTED;
@@ -1603,16 +1611,20 @@ CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
 }
 
 int
-CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
-	     const int netfid, const unsigned int count,
-	     const __u64 offset, unsigned int *nbytes, struct kvec *iov,
-	     int n_vec, const int long_op)
+CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
+	      unsigned int *nbytes, struct kvec *iov, int n_vec,
+	      const int long_op)
 {
 	int rc = -EACCES;
 	WRITE_REQ *pSMB = NULL;
 	int wct;
 	int smb_hdr_len;
 	int resp_buf_type = 0;
+	__u32 pid = io_parms->pid;
+	__u16 netfid = io_parms->netfid;
+	__u64 offset = io_parms->offset;
+	struct cifsTconInfo *tcon = io_parms->tcon;
+	unsigned int count = io_parms->length;
 
 	*nbytes = 0;
 
@@ -1630,6 +1642,10 @@ CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
 	rc = small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (void **) &pSMB);
 	if (rc)
 		return rc;
+
+	pSMB->hdr.Pid = cpu_to_le16((__u16)pid);
+	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
+
 	/* tcon and ses pointer are checked in smb_init */
 	if (tcon->ses->server == NULL)
 		return -ECONNABORTED;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 9ea65cf..0521492 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -357,6 +357,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
+	struct cifs_io_parms io_parms;
 	char *full_path = NULL;
 	struct inode *newinode = NULL;
 	int oplock = 0;
@@ -439,16 +440,19 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 	 * timestamps in, but we can reuse it safely */
 
 	pdev = (struct win_dev *)buf;
+	io_parms.netfid = fileHandle;
+	io_parms.pid = current->tgid;
+	io_parms.tcon = pTcon;
+	io_parms.offset = 0;
+	io_parms.length = sizeof(struct win_dev);
 	if (S_ISCHR(mode)) {
 		memcpy(pdev->type, "IntxCHR", 8);
 		pdev->major =
 		      cpu_to_le64(MAJOR(device_number));
 		pdev->minor =
 		      cpu_to_le64(MINOR(device_number));
-		rc = CIFSSMBWrite(xid, pTcon,
-			fileHandle,
-			sizeof(struct win_dev),
-			0, &bytes_written, (char *)pdev,
+		rc = CIFSSMBWrite(xid, &io_parms,
+			&bytes_written, (char *)pdev,
 			NULL, 0);
 	} else if (S_ISBLK(mode)) {
 		memcpy(pdev->type, "IntxBLK", 8);
@@ -456,10 +460,8 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 		      cpu_to_le64(MAJOR(device_number));
 		pdev->minor =
 		      cpu_to_le64(MINOR(device_number));
-		rc = CIFSSMBWrite(xid, pTcon,
-			fileHandle,
-			sizeof(struct win_dev),
-			0, &bytes_written, (char *)pdev,
+		rc = CIFSSMBWrite(xid, &io_parms,
+			&bytes_written, (char *)pdev,
 			NULL, 0);
 	} /* else if (S_ISFIFO) */
 	CIFSSMBClose(xid, pTcon, fileHandle);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c672afe..d2b86c4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -857,7 +857,7 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 		cifsi->server_eof = end_of_write;
 }
 
-static ssize_t cifs_write(struct cifsFileInfo *open_file,
+static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
 			  const char *write_data, size_t write_size,
 			  loff_t *poffset)
 {
@@ -869,6 +869,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 	int xid;
 	struct dentry *dentry = open_file->dentry;
 	struct cifsInodeInfo *cifsi = CIFS_I(dentry->d_inode);
+	struct cifs_io_parms io_parms;
 
 	cifs_sb = CIFS_SB(dentry->d_sb);
 
@@ -901,8 +902,13 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 			/* iov[0] is reserved for smb header */
 			iov[1].iov_base = (char *)write_data + total_written;
 			iov[1].iov_len = len;
-			rc = CIFSSMBWrite2(xid, pTcon, open_file->netfid, len,
-					   *poffset, &bytes_written, iov, 1, 0);
+			io_parms.netfid = open_file->netfid;
+			io_parms.pid = pid;
+			io_parms.tcon = pTcon;
+			io_parms.offset = *poffset;
+			io_parms.length = len;
+			rc = CIFSSMBWrite2(xid, &io_parms, &bytes_written, iov,
+					   1, 0);
 		}
 		if (rc || (bytes_written == 0)) {
 			if (total_written)
@@ -1071,8 +1077,8 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 
 	open_file = find_writable_file(CIFS_I(mapping->host), false);
 	if (open_file) {
-		bytes_written = cifs_write(open_file, write_data,
-					   to - from, &offset);
+		bytes_written = cifs_write(open_file, open_file->pid,
+					   write_data, to - from, &offset);
 		cifsFileInfo_put(open_file);
 		/* Does mm or vfs already set times? */
 		inode->i_atime = inode->i_mtime = current_fs_time(inode->i_sb);
@@ -1108,6 +1114,7 @@ static int cifs_writepages(struct address_space *mapping,
 	struct cifsFileInfo *open_file;
 	struct cifsTconInfo *tcon;
 	struct cifsInodeInfo *cifsi = CIFS_I(mapping->host);
+	struct cifs_io_parms io_parms;
 	struct page *page;
 	struct pagevec pvec;
 	int rc = 0;
@@ -1251,10 +1258,14 @@ retry_write:
 				cERROR(1, "No writable handles for inode");
 				rc = -EBADF;
 			} else {
-				rc = CIFSSMBWrite2(xid, tcon, open_file->netfid,
-						   bytes_to_write, offset,
-						   &bytes_written, iov, n_iov,
-						   0);
+				io_parms.netfid = open_file->netfid;
+				io_parms.pid = open_file->pid;
+				io_parms.tcon = tcon;
+				io_parms.offset = offset;
+				io_parms.length = bytes_to_write;
+				rc = CIFSSMBWrite2(xid, &io_parms,
+						   &bytes_written,
+						   iov, n_iov, 0);
 				cifsFileInfo_put(open_file);
 			}
 
@@ -1406,8 +1417,8 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 		/* BB check if anything else missing out of ppw
 		   such as updating last write time */
 		page_data = kmap(page);
-		rc = cifs_write(file->private_data, page_data + offset,
-				copied, &pos);
+		rc = cifs_write(file->private_data, current->tgid,
+				page_data + offset, copied, &pos);
 		/* if (rc < 0) should we set writebehind rc? */
 		kunmap(page);
 
@@ -1558,6 +1569,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	struct cifsFileInfo *open_file;
 	struct cifsTconInfo *pTcon;
 	struct cifs_sb_info *cifs_sb;
+	struct cifs_io_parms io_parms;
 	int xid, rc;
 
 	len = iov_length(iov, nr_segs);
@@ -1616,9 +1628,13 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 				if (rc != 0)
 					break;
 			}
-			rc = CIFSSMBWrite2(xid, pTcon, open_file->netfid,
-					   cur_len, *poffset, &written,
-					   to_send, npages, 0);
+			io_parms.netfid = open_file->netfid;
+			io_parms.pid = current->tgid;
+			io_parms.tcon = pTcon;
+			io_parms.offset = *poffset;
+			io_parms.length = cur_len;
+			rc = CIFSSMBWrite2(xid, &io_parms, &written, to_send,
+					   npages, 0);
 		} while (rc == -EAGAIN);
 
 		for (i = 0; i < npages; i++)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0cc7edd..875232f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1871,6 +1871,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink = NULL;
 	struct cifsTconInfo *pTcon = NULL;
+	struct cifs_io_parms io_parms;
 
 	/*
 	 * To avoid spurious oplock breaks from server, in the case of
@@ -1892,8 +1893,14 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		cFYI(1, "SetFSize for attrs rc = %d", rc);
 		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			unsigned int bytes_written;
-			rc = CIFSSMBWrite(xid, pTcon, nfid, 0, attrs->ia_size,
-					  &bytes_written, NULL, NULL, 1);
+
+			io_parms.netfid = nfid;
+			io_parms.pid = npid;
+			io_parms.tcon = pTcon;
+			io_parms.offset = 0;
+			io_parms.length = attrs->ia_size;
+			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written,
+					  NULL, NULL, 1);
 			cFYI(1, "Wrt seteof rc %d", rc);
 		}
 	} else
@@ -1928,10 +1935,15 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 			if (rc == 0) {
 				unsigned int bytes_written;
-				rc = CIFSSMBWrite(xid, pTcon, netfid, 0,
-						  attrs->ia_size,
-						  &bytes_written, NULL,
-						  NULL, 1);
+
+				io_parms.netfid = netfid;
+				io_parms.pid = current->tgid;
+				io_parms.tcon = pTcon;
+				io_parms.offset = 0;
+				io_parms.length = attrs->ia_size;
+				rc = CIFSSMBWrite(xid, &io_parms,
+						  &bytes_written,
+						  NULL, NULL,  1);
 				cFYI(1, "wrt seteof rc %d", rc);
 				CIFSSMBClose(xid, pTcon, netfid);
 			}
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index ce417a9..1a6a388 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -184,6 +184,7 @@ CIFSCreateMFSymLink(const int xid, struct cifsTconInfo *tcon,
 	__u16 netfid = 0;
 	u8 *buf;
 	unsigned int bytes_written = 0;
+	struct cifs_io_parms io_parms;
 
 	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
 	if (!buf)
@@ -203,10 +204,13 @@ CIFSCreateMFSymLink(const int xid, struct cifsTconInfo *tcon,
 		return rc;
 	}
 
-	rc = CIFSSMBWrite(xid, tcon, netfid,
-			  CIFS_MF_SYMLINK_FILE_SIZE /* length */,
-			  0 /* offset */,
-			  &bytes_written, buf, NULL, 0);
+	io_parms.netfid = netfid;
+	io_parms.pid = current->tgid;
+	io_parms.tcon = tcon;
+	io_parms.offset = 0;
+	io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
+
+	rc = CIFSSMBWrite(xid, &io_parms, &bytes_written, buf, NULL, 0);
 	CIFSSMBClose(xid, tcon, netfid);
 	kfree(buf);
 	if (rc != 0)
-- 
1.7.1
