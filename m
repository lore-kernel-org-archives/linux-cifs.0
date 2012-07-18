From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 23/45] CIFS: Add SMB2 support for cifs_iovec_read
Date: Wed, 18 Jul 2012 19:48:39 +0400
Message-ID: <1342626541-29872-24-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   25 +++++++++
 fs/cifs/cifsproto.h |   20 +-------
 fs/cifs/cifssmb.c   |    2 +-
 fs/cifs/smb2glob.h  |    6 ++
 fs/cifs/smb2misc.c  |    3 +
 fs/cifs/smb2ops.c   |   19 +++++++
 fs/cifs/smb2pdu.c   |  136 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   28 +++++++++++
 fs/cifs/smb2proto.h |    1 +
 9 files changed, 220 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e71ab49..9ce1353 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -857,12 +857,37 @@ struct cifsFileInfo {
 
 struct cifs_io_parms {
 	__u16 netfid;
+#ifdef CONFIG_CIFS_SMB2
+	__u64 persistent_fid;	/* persist file id for smb2 */
+	__u64 volatile_fid;	/* volatile file id for smb2 */
+#endif
 	__u32 pid;
 	__u64 offset;
 	unsigned int length;
 	struct cifs_tcon *tcon;
 };
 
+struct cifs_readdata;
+
+/* asynchronous read support */
+struct cifs_readdata {
+	struct kref			refcount;
+	struct list_head		list;
+	struct completion		done;
+	struct cifsFileInfo		*cfile;
+	struct address_space		*mapping;
+	__u64				offset;
+	unsigned int			bytes;
+	pid_t				pid;
+	int				result;
+	struct list_head		pages;
+	struct work_struct		work;
+	int (*marshal_iov) (struct cifs_readdata *rdata,
+			    unsigned int remaining);
+	unsigned int			nr_iov;
+	struct kvec			iov[1];
+};
+
 /*
  * Take a reference on the file private data. Must be called with
  * cifs_file_list_lock held.
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c811f66..949be72 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -463,27 +463,9 @@ extern int E_md4hash(const unsigned char *passwd, unsigned char *p16,
 extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 			unsigned char *p24);
 
-/* asynchronous read support */
-struct cifs_readdata {
-	struct kref			refcount;
-	struct list_head		list;
-	struct completion		done;
-	struct cifsFileInfo		*cfile;
-	struct address_space		*mapping;
-	__u64				offset;
-	unsigned int			bytes;
-	pid_t				pid;
-	int				result;
-	struct list_head		pages;
-	struct work_struct		work;
-	int (*marshal_iov) (struct cifs_readdata *rdata,
-			    unsigned int remaining);
-	unsigned int			nr_iov;
-	struct kvec			iov[1];
-};
-
 void cifs_readdata_release(struct kref *refcount);
 int cifs_async_readv(struct cifs_readdata *rdata);
+int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid);
 
 /* asynchronous write support */
 struct cifs_writedata {
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 2936875..e37801c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1440,7 +1440,7 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
-static int
+int
 cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length, len;
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 33c1d89..11505d7 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -41,4 +41,10 @@
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
index a4ff5d5..cbb69e2 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -242,6 +242,9 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 		    ((struct smb2_query_info_rsp *)hdr)->OutputBufferLength);
 		break;
 	case SMB2_READ:
+		*off = ((struct smb2_read_rsp *)hdr)->DataOffset;
+		*len = le32_to_cpu(((struct smb2_read_rsp *)hdr)->DataLength);
+		break;
 	case SMB2_QUERY_DIRECTORY:
 	case SMB2_IOCTL:
 	case SMB2_CHANGE_NOTIFY:
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c0997ad..ba4adf2 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -370,6 +370,20 @@ smb2_flush_file(const unsigned int xid, struct cifs_tcon *tcon,
 	return SMB2_flush(xid, tcon, fid->persistent_fid, fid->volatile_fid);
 }
 
+static unsigned int
+smb2_read_data_offset(char *buf)
+{
+	struct smb2_read_rsp *rsp = (struct smb2_read_rsp *)buf;
+	return rsp->DataOffset;
+}
+
+static unsigned int
+smb2_read_data_length(char *buf)
+{
+	struct smb2_read_rsp *rsp = (struct smb2_read_rsp *)buf;
+	return le32_to_cpu(rsp->DataLength);
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -379,6 +393,9 @@ struct smb_version_operations smb21_operations = {
 	.get_credits_field = smb2_get_credits_field,
 	.get_credits = smb2_get_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.read_data_offset = smb2_read_data_offset,
+	.read_data_length = smb2_read_data_length,
+	.map_error = map_smb2_to_linux_error,
 	.find_mid = smb2_find_mid,
 	.check_message = smb2_check_message,
 	.dump_detail = smb2_dump_detail,
@@ -407,12 +424,14 @@ struct smb_version_operations smb21_operations = {
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
 	.flush = smb2_flush_file,
+	.async_readv = smb2_async_readv,
 };
 
 struct smb_version_values smb21_values = {
 	.version_string = SMB21_VERSION_STRING,
 	.header_size = sizeof(struct smb2_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
+	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
 	.lock_cmd = SMB2_LOCK,
 	.cap_unix = 0,
 	.cap_nt_find = SMB2_NT_FIND,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ff37406..69646ac 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -31,6 +31,7 @@
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/vfs.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/uaccess.h>
 #include <linux/xattr.h>
 #include "smb2pdu.h"
@@ -42,6 +43,7 @@
 #include "cifs_debug.h"
 #include "ntlmssp.h"
 #include "smb2status.h"
+#include "smb2glob.h"
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -1190,3 +1192,137 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	free_rsp_buf(resp_buftype, iov[0].iov_base);
 	return rc;
 }
+
+/*
+ * To form a chain of read requests, any read requests after the first should
+ * have the end_of_chain boolean set to true.
+ */
+static int
+smb2_new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
+		  unsigned int remaining_bytes, int request_type)
+{
+	int rc = -EACCES;
+	struct smb2_read_req *req = NULL;
+
+	rc = small_smb2_init(SMB2_READ, io_parms->tcon, (void **) &req);
+	if (rc)
+		return rc;
+	if (io_parms->tcon->ses->server == NULL)
+		return -ECONNABORTED;
+
+	req->hdr.ProcessId = cpu_to_le32(io_parms->pid);
+
+	req->PersistentFileId = io_parms->persistent_fid;
+	req->VolatileFileId = io_parms->volatile_fid;
+	req->ReadChannelInfoOffset = 0; /* reserved */
+	req->ReadChannelInfoLength = 0; /* reserved */
+	req->Channel = 0; /* reserved */
+	req->MinimumCount = 0;
+	req->Length = cpu_to_le32(io_parms->length);
+	req->Offset = cpu_to_le64(io_parms->offset);
+
+	if (request_type & CHAINED_REQUEST) {
+		if (!(request_type & END_OF_CHAIN)) {
+			/* 4 for rfc1002 length field */
+			req->hdr.NextCommand =
+				cpu_to_le32(get_rfc1002_length(req) + 4);
+		} else /* END_OF_CHAIN */
+			req->hdr.NextCommand = 0;
+		if (request_type & RELATED_REQUEST) {
+			req->hdr.Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
+			/*
+			 * Related requests use info from previous read request
+			 * in chain.
+			 */
+			req->hdr.SessionId = 0xFFFFFFFF;
+			req->hdr.TreeId = 0xFFFFFFFF;
+			req->PersistentFileId = 0xFFFFFFFF;
+			req->VolatileFileId = 0xFFFFFFFF;
+		}
+	}
+	if (remaining_bytes > io_parms->length)
+		req->RemainingBytes = cpu_to_le32(remaining_bytes);
+	else
+		req->RemainingBytes = 0;
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for rfc1002 length field */
+	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	return rc;
+}
+
+static void
+smb2_readv_callback(struct mid_q_entry *mid)
+{
+	struct cifs_readdata *rdata = mid->callback_data;
+	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct smb2_hdr *buf = (struct smb2_hdr *)rdata->iov[0].iov_base;
+	unsigned int credits_received = 1;
+
+	cFYI(1, "%s: mid=%llu state=%d result=%d bytes=%u", __func__,
+		mid->mid, mid->mid_state, rdata->result, rdata->bytes);
+
+	switch (mid->mid_state) {
+	case MID_RESPONSE_RECEIVED:
+		credits_received = le16_to_cpu(buf->CreditRequest);
+		/* result already set, check signature */
+		/* if (server->sec_mode &
+		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+			if (smb2_verify_signature(mid->resp_buf, server))
+				cERROR(1, "Unexpected SMB signature"); */
+		/* FIXME: should this be counted toward the initiating task? */
+		task_io_account_read(rdata->bytes);
+		cifs_stats_bytes_read(tcon, rdata->bytes);
+		break;
+	case MID_REQUEST_SUBMITTED:
+	case MID_RETRY_NEEDED:
+		rdata->result = -EAGAIN;
+		break;
+	default:
+		rdata->result = -EIO;
+	}
+
+	if (rdata->result)
+		cifs_stats_fail_inc(tcon, SMB2_READ_HE);
+
+	queue_work(cifsiod_wq, &rdata->work);
+	DeleteMidQEntry(mid);
+	add_credits(server, credits_received, 0);
+}
+
+/* smb2_async_readv - send an async write, and set up mid to handle result */
+int
+smb2_async_readv(struct cifs_readdata *rdata)
+{
+	int rc;
+	struct smb2_hdr *buf;
+	struct cifs_io_parms io_parms;
+
+	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
+		rdata->offset, rdata->bytes);
+
+	io_parms.tcon = tlink_tcon(rdata->cfile->tlink);
+	io_parms.offset = rdata->offset;
+	io_parms.length = rdata->bytes;
+	io_parms.persistent_fid = rdata->cfile->fid.persistent_fid;
+	io_parms.volatile_fid = rdata->cfile->fid.volatile_fid;
+	io_parms.pid = rdata->pid;
+	rc = smb2_new_read_req(&rdata->iov[0], &io_parms, 0, 0);
+	if (rc)
+		return rc;
+
+	buf = (struct smb2_hdr *)rdata->iov[0].iov_base;
+	/* 4 for rfc1002 length field */
+	rdata->iov[0].iov_len = get_rfc1002_length(rdata->iov[0].iov_base) + 4;
+
+	kref_get(&rdata->refcount);
+	rc = cifs_call_async(io_parms.tcon->ses->server, rdata->iov, 1,
+			     cifs_readv_receive, smb2_readv_callback,
+			     rdata, 0);
+	if (rc)
+		kref_put(&rdata->refcount, cifs_readdata_release);
+
+	cifs_small_buf_release(buf);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index af2c996..d73367c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -466,6 +466,34 @@ struct smb2_flush_rsp {
 	__le16 Reserved;
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
 struct smb2_echo_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 51e6cd1..f442e46 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -97,6 +97,7 @@ extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
 			    u64 persistent_fid, u64 volatile_fid,
 			    __le64 *uniqueid);
+extern int smb2_async_readv(struct cifs_readdata *rdata);
 extern int SMB2_echo(struct TCP_Server_Info *server);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
