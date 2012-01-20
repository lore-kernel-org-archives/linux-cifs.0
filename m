From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 24/50] CIFS: Add SMB2 support for cifs_iovec_write
Date: Fri, 20 Jan 2012 12:34:45 +0400
Message-ID: <1327048511-2342-24-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    7 +++++
 fs/cifs/cifsproto.h |    4 +++
 fs/cifs/file.c      |   41 ++++++++++++++++++++++++--------
 fs/cifs/smb2file.c  |   50 ++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.c   |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   30 ++++++++++++++++++++++++
 fs/cifs/smb2proto.h |    5 ++++
 7 files changed, 189 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 99baed0..e2eee60 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -595,12 +595,19 @@ typedef int (reopen_callback_t)(struct cifsFileInfo *cifs_file, int xid,
 
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
index 9f5c2e3..1c7bedb 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -189,6 +189,10 @@ extern struct smb_vol *cifs_get_volume_info(char *mount_data,
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
index 2e5bda1..ac1ec04 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2135,6 +2135,19 @@ error:
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
@@ -2152,9 +2165,10 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
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
@@ -2165,7 +2179,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	struct iov_iter it;
 	struct inode *inode;
 	struct cifsFileInfo *open_file;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_io_parms io_parms;
 	int xid, rc;
@@ -2207,7 +2221,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	else
 		pid = current->tgid;
 
-	pTcon = tlink_tcon(open_file->tlink);
+	tcon = tlink_tcon(open_file->tlink);
 	inode = file->f_path.dentry->d_inode;
 
 	iov_iter_init(&it, iov, nr_segs, len, 0);
@@ -2233,13 +2247,12 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
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
@@ -2267,7 +2280,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		spin_unlock(&inode->i_lock);
 	}
 
-	cifs_stats_bytes_written(pTcon, total_written);
+	cifs_stats_bytes_written(tcon, total_written);
 	mark_inode_dirty_sync(inode);
 
 	for (i = 0; i < num_pages; i++)
@@ -2278,6 +2291,14 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
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
index 1166118..a00a453 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -77,7 +77,7 @@ const struct file_operations smb2_file_direct_ops = {
 	.read = do_sync_read,
 	.write = do_sync_write,
 	.aio_read = cifs_user_readv,
-	.aio_write = cifs_user_writev,
+	.aio_write = smb2_user_writev,
 	.open = smb2_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
@@ -133,7 +133,7 @@ const struct file_operations smb2_file_direct_nobrl_ops = {
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
index f2b2511..457718a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1125,3 +1125,67 @@ qinf_exit:
 	free_rsp_buf(resp_buftype, iov[0].iov_base);
 	return rc;
 }
+
+/*
+ * SMB2_write function gets iov pointer to kvec array with n_vec as a length.
+ * The length field from io_parms must be at least 1 and indicates a number of
+ * elements with data to write that begins with position 1 in iov array. All
+ * data length is specified by count.
+ */
+int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
+	       unsigned int *nbytes, struct kvec *iov, int n_vec,
+	       const unsigned int remaining_bytes, int wtimeout)
+{
+	int rc = 0;
+	struct smb2_write_req *pSMB2 = NULL;
+	struct smb2_write_rsp *pSMB2r = NULL;
+	int status, resp_buftype;
+	*nbytes = 0;
+
+	if (n_vec < 1)
+		return rc;
+
+	rc = small_smb2_init(SMB2_WRITE, io_parms->tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	if (io_parms->tcon->ses->server == NULL)
+		return -ECONNABORTED;
+
+	pSMB2->hdr.ProcessId = cpu_to_le32(io_parms->pid);
+
+	pSMB2->PersistentFileId = io_parms->persist_fid;
+	pSMB2->VolatileFileId = io_parms->volatile_fid;
+	pSMB2->WriteChannelInfoOffset = 0;
+	pSMB2->WriteChannelInfoLength = 0;
+	pSMB2->Channel = 0;
+	pSMB2->Length = cpu_to_le32(io_parms->length);
+	pSMB2->Offset = cpu_to_le64(io_parms->offset);
+	pSMB2->DataOffset = cpu_to_le16(
+				offsetof(struct smb2_write_req, Buffer) - 4);
+	pSMB2->RemainingBytes = 0;
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4 - 1;
+
+	/* length of entire message including data to be written */
+	pSMB2->hdr.smb2_buf_length =
+		cpu_to_be32(be32_to_cpu(pSMB2->hdr.smb2_buf_length)
+			    - 1 /* pad */ + io_parms->length);
+
+	rc = smb2_sendrcv2(xid, io_parms->tcon->ses, iov, n_vec + 1,
+			   &resp_buftype, &status, wtimeout | CIFS_LOG_ERROR);
+
+	cFYI(1, "write returned buftype %d with rc %d status 0x%x",
+		 resp_buftype, rc, status);
+
+	if (rc) {
+		cifs_stats_fail_inc(io_parms->tcon, SMB2WRITE);
+		cERROR(1, "Send error in write = %d", rc);
+	} else {
+		pSMB2r = (struct smb2_write_rsp *)iov[0].iov_base;
+		*nbytes = le32_to_cpu(pSMB2r->DataLength);
+		free_rsp_buf(resp_buftype, pSMB2r);
+	}
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 324b475..a66bf18 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -441,6 +441,36 @@ struct smb2_close_rsp {
 	__le32 Attributes;
 } __packed;
 
+/* For write request Flags field below the following flag is defined: */
+#define SMB2_WRITEFLAG_WRITE_THROUGH 0x00000001
+
+struct smb2_write_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 49 */
+	__le16 DataOffset; /* offset from start of SMB2 header to write data */
+	__le32 Length;
+	__le64 Offset;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__le32 Channel; /* Reserved MBZ */
+	__le32 RemainingBytes;
+	__le16 WriteChannelInfoOffset; /* Reserved MBZ */
+	__le16 WriteChannelInfoLength; /* Reserved MBZ */
+	__le32 Flags;
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_write_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 17 */
+	__u8   DataOffset;
+	__u8   Reserved;
+	__le32 DataLength;
+	__le32 DataRemaining;
+	__u32  Reserved2;
+	__u8   Buffer[1];
+} __packed;
+
 /* Possible InfoType values */
 #define SMB2_O_INFO_FILE	0x01
 #define SMB2_O_INFO_FILESYSTEM	0x02
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index cf3331e..56fa08c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -80,6 +80,8 @@ extern int smb2_open(struct inode *inode, struct file *file);
 extern int smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 			       struct cifs_tcon *tcon, const char *full_path,
 			       __u32 *oplock);
+extern ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
+				unsigned long nr_segs, loff_t pos);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
@@ -102,5 +104,8 @@ extern int SMB2_close(const int xid, struct cifs_tcon *tcon,
 extern int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   struct smb2_file_all_info *data);
+extern int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
+		      unsigned int *nbytes, struct kvec *iov, int n_vec,
+		      const unsigned int remaining_bytes, int wtimeout);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
