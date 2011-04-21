From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/2] CIFS: Forward pid of process who opened file to writepages
Date: Thu, 21 Apr 2011 17:26:34 +0400
Message-ID: <1303392395-9217-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We need it to make write work with mandatory locking style because
we can fail when kernel need to flush dirty pages and there is a lock
held by process who opened file.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |    7 ++++---
 fs/cifs/cifssmb.c   |   12 ++++++++----
 fs/cifs/file.c      |   20 +++++++++++---------
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 76c4dc7..a2eb860 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -344,9 +344,10 @@ extern int CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
 			const char *buf, const char __user *ubuf,
 			const int long_op);
 extern int CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
-			const int netfid, const unsigned int count,
-			const __u64 offset, unsigned int *nbytes,
-			struct kvec *iov, const int nvec, const int long_op);
+			const int netfid, const __u32 netpid,
+			const unsigned int count, const __u64 offset,
+			unsigned int *nbytes, struct kvec *iov, const int nvec,
+			const int long_op);
 extern int CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon *tcon,
 			const unsigned char *searchName, __u64 *inode_number,
 			const struct nls_table *nls_codepage,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 3291770..17d1cbf 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1603,10 +1603,10 @@ CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
 }
 
 int
-CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
-	     const int netfid, const unsigned int count,
-	     const __u64 offset, unsigned int *nbytes, struct kvec *iov,
-	     int n_vec, const int long_op)
+CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon, const int netfid,
+	      const __u32 netpid, const unsigned int count, const __u64 offset,
+	      unsigned int *nbytes, struct kvec *iov, int n_vec,
+	      const int long_op)
 {
 	int rc = -EACCES;
 	WRITE_REQ *pSMB = NULL;
@@ -1630,6 +1630,10 @@ CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
 	rc = small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (void **) &pSMB);
 	if (rc)
 		return rc;
+
+	pSMB->hdr.Pid = cpu_to_le16((__u16)netpid);
+	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(netpid >> 16));
+
 	/* tcon and ses pointer are checked in smb_init */
 	if (tcon->ses->server == NULL)
 		return -ECONNABORTED;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9c7f83f..838f06c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -857,7 +857,7 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 		cifsi->server_eof = end_of_write;
 }
 
-static ssize_t cifs_write(struct cifsFileInfo *open_file,
+static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 netpid,
 			  const char *write_data, size_t write_size,
 			  loff_t *poffset)
 {
@@ -901,8 +901,9 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 			/* iov[0] is reserved for smb header */
 			iov[1].iov_base = (char *)write_data + total_written;
 			iov[1].iov_len = len;
-			rc = CIFSSMBWrite2(xid, pTcon, open_file->netfid, len,
-					*poffset, &bytes_written, iov, 1, 0);
+			rc = CIFSSMBWrite2(xid, pTcon, open_file->netfid,
+					   netpid, len, *poffset,
+					   &bytes_written, iov, 1, 0);
 		}
 		if (rc || (bytes_written == 0)) {
 			if (total_written)
@@ -1071,8 +1072,8 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 
 	open_file = find_writable_file(CIFS_I(mapping->host), false);
 	if (open_file) {
-		bytes_written = cifs_write(open_file, write_data,
-					   to - from, &offset);
+		bytes_written = cifs_write(open_file, open_file->pid,
+					   write_data, to - from, &offset);
 		cifsFileInfo_put(open_file);
 		/* Does mm or vfs already set times? */
 		inode->i_atime = inode->i_mtime = current_fs_time(inode->i_sb);
@@ -1252,6 +1253,7 @@ retry_write:
 				rc = -EBADF;
 			} else {
 				rc = CIFSSMBWrite2(xid, tcon, open_file->netfid,
+						   open_file->pid,
 						   bytes_to_write, offset,
 						   &bytes_written, iov, n_iov,
 						   0);
@@ -1391,8 +1393,8 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 		/* BB check if anything else missing out of ppw
 		   such as updating last write time */
 		page_data = kmap(page);
-		rc = cifs_write(file->private_data, page_data + offset,
-				copied, &pos);
+		rc = cifs_write(file->private_data, current->tgid,
+				page_data + offset, copied, &pos);
 		/* if (rc < 0) should we set writebehind rc? */
 		kunmap(page);
 
@@ -1625,8 +1627,8 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 					break;
 			}
 			rc = CIFSSMBWrite2(xid, pTcon, open_file->netfid,
-					   cur_len, *poffset, &written,
-					   to_send, npages, 0);
+					   current->tgid, cur_len, *poffset,
+					   &written, to_send, npages, 0);
 		} while (rc == -EAGAIN);
 
 		for (i = 0; i < npages; i++)
-- 
1.7.1
