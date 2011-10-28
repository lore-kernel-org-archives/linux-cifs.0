From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH v2 25/53] CIFS: Add SMB2 support for cifs_iovec_read
Date: Fri, 28 Oct 2011 23:54:36 +0400
Message-ID: <1319831704-3572-26-git-send-email-piastry@etersoft.ru>
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
 fs/cifs/cifsglob.h  |    3 ++
 fs/cifs/cifsproto.h |    4 +++
 fs/cifs/file.c      |   76 +++++++++++++++++++++++++++++++++-----------------
 fs/cifs/smb2file.c  |   43 +++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.c   |   47 +++++++++++++++-----------------
 fs/cifs/smb2proto.h |   17 +++++-------
 6 files changed, 127 insertions(+), 63 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 852c8d2..1ab2767 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -614,6 +614,9 @@ typedef int (iwrite_callback_t)(int, struct cifsFileInfo *,
 				struct cifs_io_parms *, unsigned int *,
 				struct kvec *, unsigned long, unsigned int,
 				int);
+typedef int (iread_callback_t)(int, struct cifsFileInfo *,
+			       struct cifs_io_parms *, unsigned int *, char **,
+			       char **, int *);
 
 /*
  * Take a reference on the file private data. Must be called with
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 596a9ab..1129f16 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -188,6 +188,10 @@ extern ssize_t cifs_iovec_write_generic(struct file *file,
 					const struct iovec *iov,
 					unsigned long nr_segs, loff_t *poffset,
 					iwrite_callback_t *write_cb);
+extern ssize_t cifs_iovec_read_generic(struct file *file,
+				       const struct iovec *iov,
+				       unsigned long nr_segs, loff_t *poffset,
+				       iread_callback_t *read_cb);
 extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 2063394..44f678a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2340,9 +2340,28 @@ ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	return written;
 }
 
-static ssize_t
-cifs_iovec_read(struct file *file, const struct iovec *iov,
-		 unsigned long nr_segs, loff_t *poffset)
+static int
+cifs_iread_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
+	      unsigned int *bytes_read, char **all_data, char **data_offset,
+	      int *resp_buf_type)
+{
+	struct smb_com_read_rsp *pSMBr;
+	int rc;
+
+	parms->netfid = cfile->netfid;
+	rc = CIFSSMBRead(xid, parms, bytes_read, all_data, resp_buf_type);
+	if (!(*all_data))
+		return rc;
+
+	pSMBr = (struct smb_com_read_rsp *)(*all_data);
+	*data_offset = *all_data + 4 + le16_to_cpu(pSMBr->DataOffset);
+	return rc;
+}
+
+ssize_t
+cifs_iovec_read_generic(struct file *file, const struct iovec *iov,
+			unsigned long nr_segs, loff_t *poffset,
+			iread_callback_t *read_cb)
 {
 	int rc;
 	int xid;
@@ -2351,11 +2370,11 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	size_t len, cur_len;
 	int iov_offset = 0;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 	struct cifsFileInfo *open_file;
-	struct smb_com_read_rsp *pSMBr;
 	struct cifs_io_parms io_parms;
 	char *read_data;
+	char *data_offset = NULL;
 	unsigned int rsize;
 	__u32 pid;
 
@@ -2373,7 +2392,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	rsize = min_t(unsigned int, cifs_sb->rsize, CIFSMaxBufSize);
 
 	open_file = file->private_data;
-	pTcon = tlink_tcon(open_file->tlink);
+	tcon = tlink_tcon(open_file->tlink);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
@@ -2395,27 +2414,24 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 				if (rc != 0)
 					break;
 			}
-			io_parms.netfid = open_file->netfid;
 			io_parms.pid = pid;
-			io_parms.tcon = pTcon;
+			io_parms.tcon = tcon;
 			io_parms.offset = *poffset;
 			io_parms.length = cur_len;
-			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
-					 &read_data, &buf_type);
-			pSMBr = (struct smb_com_read_rsp *)read_data;
-			if (read_data) {
-				char *data_offset = read_data + 4 +
-						le16_to_cpu(pSMBr->DataOffset);
-				if (memcpy_toiovecend(iov, data_offset,
-						      iov_offset, bytes_read))
-					rc = -EFAULT;
-				if (buf_type == CIFS_SMALL_BUFFER)
-					cifs_small_buf_release(read_data);
-				else if (buf_type == CIFS_LARGE_BUFFER)
-					cifs_buf_release(read_data);
-				read_data = NULL;
-				iov_offset += bytes_read;
-			}
+			rc = read_cb(xid, open_file, &io_parms, &bytes_read,
+				     &read_data, &data_offset, &buf_type);
+			if (rc)
+				continue;
+
+			if (memcpy_toiovecend(iov, data_offset,
+					      iov_offset, bytes_read))
+				rc = -EFAULT;
+			if (buf_type == CIFS_SMALL_BUFFER)
+				cifs_small_buf_release(read_data);
+			else if (buf_type == CIFS_LARGE_BUFFER)
+				cifs_buf_release(read_data);
+			read_data = NULL;
+			iov_offset += bytes_read;
 		}
 
 		if (rc || (bytes_read == 0)) {
@@ -2426,7 +2442,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 				return rc;
 			}
 		} else {
-			cifs_stats_bytes_read(pTcon, bytes_read);
+			cifs_stats_bytes_read(tcon, bytes_read);
 			*poffset += bytes_read;
 		}
 	}
@@ -2435,8 +2451,16 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	return total_read;
 }
 
+static ssize_t
+cifs_iovec_read(struct file *file, const struct iovec *iov,
+		unsigned long nr_segs, loff_t *poffset)
+{
+	return cifs_iovec_read_generic(file, iov, nr_segs, poffset,
+				       cifs_iread_cb);
+}
+
 ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
-			       unsigned long nr_segs, loff_t pos)
+			unsigned long nr_segs, loff_t pos)
 {
 	ssize_t read;
 
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 3a2b3e1..3404d8a 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -77,7 +77,7 @@ const struct file_operations smb2_file_direct_ops = {
 	/* BB reevaluate whether they can be done with directio, no cache */
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = cifs_user_readv,
+	.aio_read = smb2_user_readv,
 	.aio_write = smb2_user_writev,
 	.open = smb2_open,
 	.release = cifs_close,
@@ -133,7 +133,7 @@ const struct file_operations smb2_file_direct_nobrl_ops = {
 	/* BB reevaluate whether they can be done with directio, no cache */
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = cifs_user_readv,
+	.aio_read = smb2_user_readv,
 	.aio_write = smb2_user_writev,
 	.open = smb2_open,
 	.release = cifs_close,
@@ -367,3 +367,42 @@ ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
 
 	return written;
 }
+
+static int
+smb2_iread_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
+	      unsigned int *bytes_read, char **all_data, char **data_offset,
+	      int *resp_buf_type)
+{
+	struct read_rsp *pSMB2r;
+	int rc;
+
+	parms->persist_fid = cfile->persist_fid;
+	parms->volatile_fid = cfile->volatile_fid;
+	rc = SMB2_read(xid, parms, bytes_read, all_data, resp_buf_type, 0);
+	if (!(*all_data))
+		return rc;
+
+	pSMB2r = (struct read_rsp *)(*all_data);
+	*data_offset = (char *)pSMB2r->hdr.ProtocolId + pSMB2r->DataOffset;
+	return rc;
+}
+
+static ssize_t
+smb2_iovec_read(struct file *file, const struct iovec *iov,
+		unsigned long nr_segs, loff_t *poffset)
+{
+	return cifs_iovec_read_generic(file, iov, nr_segs, poffset,
+				       smb2_iread_cb);
+}
+
+ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
+			unsigned long nr_segs, loff_t pos)
+{
+	ssize_t read;
+
+	read = smb2_iovec_read(iocb->ki_filp, iov, nr_segs, &pos);
+	if (read > 0)
+		iocb->ki_pos = pos;
+
+	return read;
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f77b861..2ff0acf 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2259,29 +2259,28 @@ rename_exit:
  * To form a chain of read requests, any read requests after the
  * first should have the end_of_chain boolean set to true.
  */
-int new_read_req(struct kvec *iov, struct cifs_tcon *tcon,
-		u64 persistent_fid, u64 volatile_fid,
-		const unsigned int count, const __u64 lseek,
-		unsigned int remaining_bytes,
-		int request_type)
+int new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
+		 unsigned int remaining_bytes, int request_type)
 {
 	int rc = -EACCES;
 	struct read_req *pSMB2 = NULL;
 
-	rc = small_smb2_init(SMB2_READ, tcon, (void **) &pSMB2);
+	rc = small_smb2_init(SMB2_READ, io_parms->tcon, (void **) &pSMB2);
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
 	pSMB2->ReadChannelInfoOffset = 0; /* reserved */
 	pSMB2->ReadChannelInfoLength = 0; /* reserved */
 	pSMB2->Channel = 0; /* reserved */
 	pSMB2->MinimumCount = 0;
-	pSMB2->Length = cpu_to_le32(count);
-	pSMB2->Offset = cpu_to_le64(lseek);
+	pSMB2->Length = cpu_to_le32(io_parms->length);
+	pSMB2->Offset = cpu_to_le64(io_parms->offset);
 
 	if (request_type & CHAINED_REQUEST) {
 		if (!(request_type & END_OF_CHAIN)) {
@@ -2301,7 +2300,7 @@ int new_read_req(struct kvec *iov, struct cifs_tcon *tcon,
 			pSMB2->VolatileFileId = 0xFFFFFFFF;
 		}
 	}
-	if (remaining_bytes > count)
+	if (remaining_bytes > io_parms->length)
 		pSMB2->RemainingBytes = cpu_to_le32(remaining_bytes);
 	else
 		pSMB2->RemainingBytes = 0;
@@ -2311,22 +2310,20 @@ int new_read_req(struct kvec *iov, struct cifs_tcon *tcon,
 	return rc;
 }
 
-int SMB2_read(const int xid, struct cifs_tcon *tcon,
-	u64 persistent_fid, u64 volatile_fid,
-	const unsigned int count, const __u64 lseek,
-	unsigned int *nbytes, char **buf, int *pbuf_type,
-	unsigned int remaining_bytes)
+int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
+	      unsigned int *nbytes, char **buf, int *pbuf_type,
+	      unsigned int remaining_bytes)
 {
 	int status, resp_buftype, rc = -EACCES;
 	struct read_rsp *pSMB2r = NULL;
 	struct kvec iov[1];
 
 	*nbytes = 0;
-	rc = new_read_req(iov, tcon, persistent_fid, volatile_fid,
-			count, lseek, remaining_bytes, 0);
+	rc = new_read_req(iov, io_parms, remaining_bytes, 0);
 	if (rc)
 		return rc;
-	rc = smb2_sendrcv2(xid, tcon->ses, iov, 1,
+
+	rc = smb2_sendrcv2(xid, io_parms->tcon->ses, iov, 1,
 			   &resp_buftype, &status,
 			   CIFS_STD_OP | CIFS_LOG_ERROR);
 	if (status == STATUS_END_OF_FILE) {
@@ -2340,14 +2337,14 @@ int SMB2_read(const int xid, struct cifs_tcon *tcon,
 	pSMB2r = (struct read_rsp *)iov[0].iov_base;
 
 	if (rc) {
-		cifs_stats_fail_inc(tcon, SMB2READ);
+		cifs_stats_fail_inc(io_parms->tcon, SMB2READ);
 		cERROR(1, "Send error in read = %d", rc);
 	} else {
 		*nbytes = le32_to_cpu(pSMB2r->DataLength);
-		if ((*nbytes > SMB2_MAX_MSGSIZE)
-			|| (*nbytes > count)) {
-			cFYI(1, "bad length %d for count %d",
-					*nbytes, count);
+		if ((*nbytes > SMB2_MAX_MSGSIZE) ||
+		    (*nbytes > io_parms->length)) {
+			cFYI(1, "bad length %d for count %d", *nbytes,
+			     io_parms->length);
 			rc = -EIO;
 			*nbytes = 0;
 		}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index ede6ee9..30ab741 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -118,6 +118,8 @@ extern int smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 			       __u32 *oplock);
 
 extern int smb2_open(struct inode *inode, struct file *file);
+extern ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
+			       unsigned long nr_segs, loff_t pos);
 extern ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 
@@ -181,11 +183,9 @@ extern int SMB2_symlink_ioctl(const int, struct cifs_tcon *, u32, u64, u64,
 				const char *);
 extern int SMB2_close(const int xid, struct cifs_tcon *tcon,
 			u64 persistent_file_id, u64 volatile_file_id);
-extern int SMB2_read(const int xid, struct cifs_tcon *tcon,
-		u64 persistent_fid, u64 volatile_fid,
-		const unsigned int count, const __u64 lseek,
-		unsigned int *nbytes, char **buf, int *pbuf_type,
-		unsigned int remaining_bytes);
+extern int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
+		     unsigned int *nbytes, char **buf, int *pbuf_type,
+		     unsigned int remaining_bytes);
 extern int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
 		      unsigned int *nbytes, struct kvec *iov, int n_vec,
 		      const unsigned int remaining_bytes, int wtimeout);
@@ -209,11 +209,8 @@ extern int SMB2_lock(const int xid, struct cifs_tcon *tcon,
 		     const u64 persistent_fid, const u64 volatile_fid,
 		     u64 length, u64 offset, u32 lockFlags, int wait);
 extern void DeleteMidQEntryComplex(struct mid_q_entry *midEntry);
-extern int new_read_req(struct kvec *iov, struct cifs_tcon *tcon,
-			u64 persistent_fid, u64 volatile_fid,
-			const unsigned int count, const __u64 lseek,
-			unsigned int remaining_bytes,
-			int request_type);
+extern int new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
+			unsigned int remaining_bytes, int request_type);
 extern int smb2_sendv(struct TCP_Server_Info *server, struct kvec *iov,
 		      int n_vec);
 extern int smb2_wait_on_complex_mid(struct cifs_ses *ses,
-- 
1.7.1

