From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 24/53] CIFS: Add SMB2 support for cifs_iovec_write
Date: Fri, 28 Oct 2011 23:54:35 +0400
Message-ID: <1319831704-3572-25-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    7 +++++++
 fs/cifs/cifsproto.h |    4 ++++
 fs/cifs/file.c      |   41 +++++++++++++++++++++++++++++++----------
 fs/cifs/smb2file.c  |   50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/smb2pdu.c   |   38 +++++++++++++++++++-------------------
 fs/cifs/smb2proto.h |   11 ++++++-----
 6 files changed, 115 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 82e40b2..852c8d2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -602,12 +602,19 @@ typedef int (reopen_callback_t)(struct cifsFileInfo *cifs_file, int xid,
 
 struct cifs_io_parms {
 	__u16 netfid;
+	__u64 persist_fid;
+	__u64 volatile_fid;
 	__u32 pid;
 	__u64 offset;
 	unsigned int length;
 	struct cifs_tcon *tcon;
 };
 
+typedef int (iwrite_callback_t)(int, struct cifsFileInfo *,
+				struct cifs_io_parms *, unsigned int *,
+				struct kvec *, unsigned long, unsigned int,
+				int);
+
 /*
  * Take a reference on the file private data. Must be called with
  * cifs_file_list_lock held.
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 142660f..596a9ab 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -184,6 +184,10 @@ extern struct smb_vol *cifs_get_volume_info(char *mount_data,
 extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
 extern void cifs_umount(struct cifs_sb_info *);
 extern void cifs_dfs_release_automount_timer(void);
+extern ssize_t cifs_iovec_write_generic(struct file *file,
+					const struct iovec *iov,
+					unsigned long nr_segs, loff_t *poffset,
+					iwrite_callback_t *write_cb);
 extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 508ec3a..2063394 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2114,6 +2114,19 @@ error:
 	return rc;
 }
 
+static int
+cifs_iwrite_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
+	       unsigned int *written, struct kvec *iov, unsigned long nr_segs,
+	       unsigned int remaining_bytes, int timeout)
+{
+	int rc;
+
+	parms->netfid = cfile->netfid;
+	rc = CIFSSMBWrite2(xid, parms, written, iov, nr_segs, timeout);
+
+	return rc;
+}
+
 static inline
 size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
 {
@@ -2131,9 +2144,10 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
 	return num_pages;
 }
 
-static ssize_t
-cifs_iovec_write(struct file *file, const struct iovec *iov,
-		 unsigned long nr_segs, loff_t *poffset)
+ssize_t
+cifs_iovec_write_generic(struct file *file, const struct iovec *iov,
+			 unsigned long nr_segs, loff_t *poffset,
+			 iwrite_callback_t *write_cb)
 {
 	unsigned int written;
 	unsigned long num_pages, npages, i;
@@ -2144,7 +2158,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	struct iov_iter it;
 	struct inode *inode;
 	struct cifsFileInfo *open_file;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_io_parms io_parms;
 	int xid, rc;
@@ -2186,7 +2200,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	else
 		pid = current->tgid;
 
-	pTcon = tlink_tcon(open_file->tlink);
+	tcon = tlink_tcon(open_file->tlink);
 	inode = file->f_path.dentry->d_inode;
 
 	iov_iter_init(&it, iov, nr_segs, len, 0);
@@ -2212,13 +2226,12 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 				if (rc != 0)
 					break;
 			}
-			io_parms.netfid = open_file->netfid;
 			io_parms.pid = pid;
-			io_parms.tcon = pTcon;
+			io_parms.tcon = tcon;
 			io_parms.offset = *poffset;
 			io_parms.length = cur_len;
-			rc = CIFSSMBWrite2(xid, &io_parms, &written, to_send,
-					   npages, 0);
+			rc = write_cb(xid, open_file, &io_parms, &written,
+				      to_send, npages, len - total_written, 0);
 		} while (rc == -EAGAIN);
 
 		for (i = 0; i < npages; i++)
@@ -2246,7 +2259,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		spin_unlock(&inode->i_lock);
 	}
 
-	cifs_stats_bytes_written(pTcon, total_written);
+	cifs_stats_bytes_written(tcon, total_written);
 	mark_inode_dirty_sync(inode);
 
 	for (i = 0; i < num_pages; i++)
@@ -2257,6 +2270,14 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	return total_written;
 }
 
+static ssize_t
+cifs_iovec_write(struct file *file, const struct iovec *iov,
+		 unsigned long nr_segs, loff_t *poffset)
+{
+	return cifs_iovec_write_generic(file, iov, nr_segs, poffset,
+					cifs_iwrite_cb);
+}
+
 ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos)
 {
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 7284d40..3a2b3e1 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -78,7 +78,7 @@ const struct file_operations smb2_file_direct_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
 	.aio_read = cifs_user_readv,
-	.aio_write = cifs_user_writev,
+	.aio_write = smb2_user_writev,
 	.open = smb2_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
@@ -134,7 +134,7 @@ const struct file_operations smb2_file_direct_nobrl_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
 	.aio_read = cifs_user_readv,
-	.aio_write = cifs_user_writev,
+	.aio_write = smb2_user_writev,
 	.open = smb2_open,
 	.release = cifs_close,
 	.fsync = cifs_fsync,
@@ -321,3 +321,49 @@ reopen_error_exit:
 	kfree(smb2_path);
 	return rc;
 }
+
+static int
+smb2_iwrite_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
+	       unsigned int *written, struct kvec *iov, unsigned long nr_segs,
+	       unsigned int remaining_bytes, int timeout)
+{
+	int rc;
+
+	parms->persist_fid = cfile->persist_fid;
+	parms->volatile_fid = cfile->volatile_fid;
+	rc = SMB2_write(xid, parms, written, iov, nr_segs, remaining_bytes,
+			timeout);
+
+	return rc;
+}
+
+static ssize_t
+smb2_iovec_write(struct file *file, const struct iovec *iov,
+		 unsigned long nr_segs, loff_t *poffset)
+{
+	return cifs_iovec_write_generic(file, iov, nr_segs, poffset,
+					smb2_iwrite_cb);
+}
+
+ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
+			 unsigned long nr_segs, loff_t pos)
+{
+	ssize_t written;
+	struct inode *inode;
+
+	inode = iocb->ki_filp->f_path.dentry->d_inode;
+
+	/*
+	 * BB - optimize the way when signing is disabled. We can drop this
+	 * extra memory-to-memory copying and use iovec buffers for constructing
+	 * write request.
+	 */
+
+	written = smb2_iovec_write(iocb->ki_filp, iov, nr_segs, &pos);
+	if (written > 0) {
+		CIFS_I(inode)->invalid_mapping = true;
+		iocb->ki_pos = pos;
+	}
+
+	return written;
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6bc3476..f77b861 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2364,15 +2364,13 @@ int SMB2_read(const int xid, struct cifs_tcon *tcon,
 
 /*
  * SMB2_write function gets iov pointer to kvec array with n_vec as a length.
- * The length must be at least 2 because the first element of the array is
- * SMB2 header. Other elements contain a data to write, its length is specified
- * by count.
+ * The length field from io_parms must be at least 1 and indicates a number of
+ * elements with data to write that begins with position 1 in iov array. All
+ * data length is specified by count.
  */
-int SMB2_write(const int xid, struct cifs_tcon *tcon,
-	const u64 persistent_fid, const u64 volatile_fid,
-	const unsigned int count, const __u64 lseek,
-	unsigned int *nbytes, struct kvec *iov, int n_vec,
-	const unsigned int remaining_bytes, int wtimeout)
+int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
+	       unsigned int *nbytes, struct kvec *iov, int n_vec,
+	       const unsigned int remaining_bytes, int wtimeout)
 {
 	int rc = 0;
 	struct write_req *pSMB2 = NULL;
@@ -2380,23 +2378,25 @@ int SMB2_write(const int xid, struct cifs_tcon *tcon,
 	int status, resp_buftype;
 	*nbytes = 0;
 
-	if (n_vec < 2)
+	if (n_vec < 1)
 		return rc;
 
-	rc = small_smb2_init(SMB2_WRITE, tcon, (void **) &pSMB2);
+	rc = small_smb2_init(SMB2_WRITE, io_parms->tcon, (void **) &pSMB2);
 	if (rc)
 		return rc;
 
-	if (tcon->ses->server == NULL)
+	if (io_parms->tcon->ses->server == NULL)
 		return -ECONNABORTED;
 
-	pSMB2->PersistentFileId = persistent_fid;
-	pSMB2->VolatileFileId = volatile_fid;
+	pSMB2->hdr.ProcessId = cpu_to_le32(io_parms->pid);
+
+	pSMB2->PersistentFileId = io_parms->persist_fid;
+	pSMB2->VolatileFileId = io_parms->volatile_fid;
 	pSMB2->WriteChannelInfoOffset = 0;
 	pSMB2->WriteChannelInfoLength = 0;
 	pSMB2->Channel = 0;
-	pSMB2->Length = cpu_to_le32(count);
-	pSMB2->Offset = cpu_to_le64(lseek);
+	pSMB2->Length = cpu_to_le32(io_parms->length);
+	pSMB2->Offset = cpu_to_le64(io_parms->offset);
 	pSMB2->DataOffset = cpu_to_le16(offsetof(struct write_req, Buffer) - 4);
 	pSMB2->RemainingBytes = 0;
 
@@ -2406,16 +2406,16 @@ int SMB2_write(const int xid, struct cifs_tcon *tcon,
 	/* length of entire message including data to be written */
 	pSMB2->hdr.smb2_buf_length =
 		cpu_to_be32(be32_to_cpu(pSMB2->hdr.smb2_buf_length)
-			    - 1 /* pad */ + count);
+			    - 1 /* pad */ + io_parms->length);
 
-	rc = smb2_sendrcv2(xid, tcon->ses, iov, n_vec, &resp_buftype, &status,
-			wtimeout | CIFS_LOG_ERROR);
+	rc = smb2_sendrcv2(xid, io_parms->tcon->ses, iov, n_vec + 1,
+			   &resp_buftype, &status, wtimeout | CIFS_LOG_ERROR);
 
 	cFYI(1, "write returned buftype %d with rc %d status 0x%x",
 		 resp_buftype, rc, status);
 
 	if (rc) {
-		cifs_stats_fail_inc(tcon, SMB2WRITE);
+		cifs_stats_fail_inc(io_parms->tcon, SMB2WRITE);
 		cERROR(1, "Send error in write = %d", rc);
 	} else {
 		pSMB2r = (struct write_rsp *)iov[0].iov_base;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 40d0cae..ede6ee9 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -118,6 +118,9 @@ extern int smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 			       __u32 *oplock);
 
 extern int smb2_open(struct inode *inode, struct file *file);
+extern ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
+				unsigned long nr_segs, loff_t pos);
+
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
 extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
@@ -183,11 +186,9 @@ extern int SMB2_read(const int xid, struct cifs_tcon *tcon,
 		const unsigned int count, const __u64 lseek,
 		unsigned int *nbytes, char **buf, int *pbuf_type,
 		unsigned int remaining_bytes);
-extern int SMB2_write(const int xid, struct cifs_tcon *tcon,
-	const u64 persistent_fid, const u64 volatile_fid,
-	const unsigned int count, const __u64 lseek,
-	unsigned int *nbytes, struct kvec *iov, int n_vec,
-	const unsigned int remaining_bytes, int wtimeout);
+extern int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
+		      unsigned int *nbytes, struct kvec *iov, int n_vec,
+		      const unsigned int remaining_bytes, int wtimeout);
 extern int SMB2_write_complex(const int xid, struct cifs_tcon *tcon,
 	const u64 persistent_fid, const u64 volatile_fid,
 	const unsigned int count, const __u64 lseek,
-- 
1.7.1
