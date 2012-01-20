From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 25/50] CIFS: Add SMB2 support for cifs_iovec_read
Date: Fri, 20 Jan 2012 12:34:46 +0400
Message-ID: <1327048511-2342-25-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +
 fs/cifs/cifsproto.h |    4 ++
 fs/cifs/file.c      |   76 ++++++++++++++++++++++++-------------
 fs/cifs/smb2file.c  |   43 ++++++++++++++++++++-
 fs/cifs/smb2glob.h  |    6 +++
 fs/cifs/smb2misc.c  |    4 ++
 fs/cifs/smb2pdu.c   |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   28 +++++++++++++
 fs/cifs/smb2proto.h |    7 +++
 9 files changed, 248 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e2eee60..dedeb0f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -607,6 +607,9 @@ typedef int (iwrite_callback_t)(int, struct cifsFileInfo *,
 				struct cifs_io_parms *, unsigned int *,
 				struct kvec *, unsigned long, unsigned int,
 				int);
+typedef int (iread_callback_t)(int, struct cifsFileInfo *,
+			       struct cifs_io_parms *, unsigned int *, char **,
+			       char **, int *);
 
 /*
  * Take a reference on the file private data. Must be called with
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1c7bedb..76b65dd 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -193,6 +193,10 @@ extern ssize_t cifs_iovec_write_generic(struct file *file,
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
index ac1ec04..b90417e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2361,9 +2361,28 @@ ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
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
@@ -2372,11 +2391,11 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
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
 
@@ -2394,7 +2413,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	rsize = min_t(unsigned int, cifs_sb->rsize, CIFSMaxBufSize);
 
 	open_file = file->private_data;
-	pTcon = tlink_tcon(open_file->tlink);
+	tcon = tlink_tcon(open_file->tlink);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
@@ -2416,27 +2435,24 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
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
@@ -2447,7 +2463,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 				return rc;
 			}
 		} else {
-			cifs_stats_bytes_read(pTcon, bytes_read);
+			cifs_stats_bytes_read(tcon, bytes_read);
 			*poffset += bytes_read;
 		}
 	}
@@ -2456,8 +2472,16 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
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
index a00a453..9829ed7 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -76,7 +76,7 @@ const struct file_operations smb2_file_direct_ops = {
 	/* BB reevaluate whether they can be done with directio, no cache */
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = cifs_user_readv,
+	.aio_read = smb2_user_readv,
 	.aio_write = smb2_user_writev,
 	.open = smb2_open,
 	.release = cifs_close,
@@ -132,7 +132,7 @@ const struct file_operations smb2_file_direct_nobrl_ops = {
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
+	struct smb2_read_rsp *pSMB2r;
+	int rc;
+
+	parms->persist_fid = cfile->persist_fid;
+	parms->volatile_fid = cfile->volatile_fid;
+	rc = SMB2_read(xid, parms, bytes_read, all_data, resp_buf_type, 0);
+	if (!(*all_data))
+		return rc;
+
+	pSMB2r = (struct smb2_read_rsp *)(*all_data);
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
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 1db1196..bde9f99 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -40,4 +40,10 @@
 #define SMB2_OP_RENAME 6
 #define SMB2_OP_DELETE 7
 
+/* Used when constructing chained read requests. */
+#define CHAINED_REQUEST 1
+#define START_OF_CHAIN 2
+#define END_OF_CHAIN 4
+#define RELATED_REQUEST 8
+
 #endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index ad84694..d63987c 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -245,6 +245,10 @@ char *smb2_get_data_area_len(int *poff, int *plen, struct smb2_hdr *pSMB2)
 		    ((struct smb2_query_info_rsp *)pSMB2)->OutputBufferLength);
 		break;
 	case SMB2_READ:
+		*poff = ((struct smb2_read_rsp *)pSMB2)->DataOffset;
+		*plen = le32_to_cpu(
+				((struct smb2_read_rsp *)pSMB2)->DataLength);
+		break;
 	case SMB2_QUERY_DIRECTORY:
 	case SMB2_IOCTL:
 	case SMB2_CHANGE_NOTIFY:
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 457718a..c4d4928 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -41,6 +41,7 @@
 #include "cifs_debug.h"
 #include "ntlmssp.h"
 #include "smb2status.h"
+#include "smb2glob.h"
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -1127,6 +1128,110 @@ qinf_exit:
 }
 
 /*
+ * To form a chain of read requests, any read requests after the
+ * first should have the end_of_chain boolean set to true.
+ */
+int smb2_new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
+		      unsigned int remaining_bytes, int request_type)
+{
+	int rc = -EACCES;
+	struct smb2_read_req *pSMB2 = NULL;
+
+	rc = small_smb2_init(SMB2_READ, io_parms->tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+	if (io_parms->tcon->ses->server == NULL)
+		return -ECONNABORTED;
+
+	pSMB2->hdr.ProcessId = cpu_to_le32(io_parms->pid);
+
+	pSMB2->PersistentFileId = io_parms->persist_fid;
+	pSMB2->VolatileFileId = io_parms->volatile_fid;
+	pSMB2->ReadChannelInfoOffset = 0; /* reserved */
+	pSMB2->ReadChannelInfoLength = 0; /* reserved */
+	pSMB2->Channel = 0; /* reserved */
+	pSMB2->MinimumCount = 0;
+	pSMB2->Length = cpu_to_le32(io_parms->length);
+	pSMB2->Offset = cpu_to_le64(io_parms->offset);
+
+	if (request_type & CHAINED_REQUEST) {
+		if (!(request_type & END_OF_CHAIN)) {
+			pSMB2->hdr.NextCommand = cpu_to_le32(
+				be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4);
+		} else /* END_OF_CHAIN */
+			pSMB2->hdr.NextCommand = 0;
+		if (request_type & RELATED_REQUEST) {
+			pSMB2->hdr.Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
+			/*
+			 * related requests use info from previous
+			 * read request in chain.
+			 */
+			pSMB2->hdr.SessionId = 0xFFFFFFFF;
+			pSMB2->hdr.TreeId = 0xFFFFFFFF;
+			pSMB2->PersistentFileId = 0xFFFFFFFF;
+			pSMB2->VolatileFileId = 0xFFFFFFFF;
+		}
+	}
+	if (remaining_bytes > io_parms->length)
+		pSMB2->RemainingBytes = cpu_to_le32(remaining_bytes);
+	else
+		pSMB2->RemainingBytes = 0;
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4;
+	return rc;
+}
+
+int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
+	      unsigned int *nbytes, char **buf, int *pbuf_type,
+	      unsigned int remaining_bytes)
+{
+	int status, resp_buftype, rc = -EACCES;
+	struct smb2_read_rsp *pSMB2r = NULL;
+	struct kvec iov[1];
+
+	*nbytes = 0;
+	rc = smb2_new_read_req(iov, io_parms, remaining_bytes, 0);
+	if (rc)
+		return rc;
+
+	rc = smb2_sendrcv2(xid, io_parms->tcon->ses, iov, 1,
+			   &resp_buftype, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	if (status == STATUS_END_OF_FILE) {
+		free_rsp_buf(resp_buftype, iov[0].iov_base);
+		return 0;
+	}
+
+	cFYI(1, "read returned buftype %d with rc %d status 0x%x",
+		 resp_buftype, rc, status);
+
+	pSMB2r = (struct smb2_read_rsp *)iov[0].iov_base;
+
+	if (rc) {
+		cifs_stats_fail_inc(io_parms->tcon, SMB2READ);
+		cERROR(1, "Send error in read = %d", rc);
+	} else {
+		*nbytes = le32_to_cpu(pSMB2r->DataLength);
+		if ((*nbytes > CIFS_MAX_MSGSIZE) ||
+		    (*nbytes > io_parms->length)) {
+			cFYI(1, "bad length %d for count %d", *nbytes,
+			     io_parms->length);
+			rc = -EIO;
+			*nbytes = 0;
+		}
+	}
+	if (resp_buftype != CIFS_NO_BUFFER) {
+		*buf = iov[0].iov_base;
+		if (resp_buftype == CIFS_SMALL_BUFFER)
+			*pbuf_type = CIFS_SMALL_BUFFER;
+		else if (resp_buftype == CIFS_LARGE_BUFFER)
+			*pbuf_type = CIFS_LARGE_BUFFER;
+	}
+	return rc;
+}
+
+/*
  * SMB2_write function gets iov pointer to kvec array with n_vec as a length.
  * The length field from io_parms must be at least 1 and indicates a number of
  * elements with data to write that begins with position 1 in iov array. All
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index a66bf18..92d0982 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -441,6 +441,34 @@ struct smb2_close_rsp {
 	__le32 Attributes;
 } __packed;
 
+struct smb2_read_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 49 */
+	__u8   Padding; /* offset from start of SMB2 header to place read */
+	__u8   Reserved;
+	__le32 Length;
+	__le64 Offset;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__le32 MinimumCount;
+	__le32 Channel; /* Reserved MBZ */
+	__le32 RemainingBytes;
+	__le16 ReadChannelInfoOffset; /* Reserved MBZ */
+	__le16 ReadChannelInfoLength; /* Reserved MBZ */
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_read_rsp {
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
 /* For write request Flags field below the following flag is defined: */
 #define SMB2_WRITEFLAG_WRITE_THROUGH 0x00000001
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 56fa08c..b477b90 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -82,6 +82,8 @@ extern int smb2_reopen_file_cb(struct cifsFileInfo *cifs_file, int xid,
 			       __u32 *oplock);
 extern ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
+extern ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
+			       unsigned long nr_segs, loff_t pos);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
@@ -107,5 +109,10 @@ extern int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
 extern int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
 		      unsigned int *nbytes, struct kvec *iov, int n_vec,
 		      const unsigned int remaining_bytes, int wtimeout);
+extern int smb2_new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
+			     unsigned int remaining_bytes, int request_type);
+extern int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
+		     unsigned int *nbytes, char **buf, int *pbuf_type,
+		     unsigned int remaining_bytes);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
