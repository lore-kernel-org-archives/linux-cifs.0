From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 06/15] CIFS: Separate RFC1001 length processing for SMB2 read
Date: Tue,  6 Dec 2016 14:02:29 -0800
Message-ID: <1481061758-52020-7-git-send-email-pshilov@microsoft.com>
References: <1481061758-52020-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481061758-52020-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Allocate and initialize SMB2 read request without RFC1001 length
field to directly call cifs_send_recv() rather than SendReceive2()
in a read codepath.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsproto.h |  3 ++
 fs/cifs/smb2pdu.c   | 89 ++++++++++++++++++++++++++++++++++++++++-------------
 fs/cifs/smb2pdu.h   |  5 +--
 fs/cifs/transport.c |  2 +-
 4 files changed, 74 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8610f25..f87d1d6 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -78,6 +78,9 @@ extern int cifs_call_async(struct TCP_Server_Info *server,
 			struct smb_rqst *rqst,
 			mid_receive_t *receive, mid_callback_t *callback,
 			void *cbdata, const int flags);
+extern int cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
+			  struct smb_rqst *rqst, int *resp_buf_type,
+			  const int flags, struct kvec *resp_iov);
 extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f6ba2c0..d1a9037 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -293,10 +293,46 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon, void *buf,
 	*total_len = parmsize + sizeof(struct smb2_sync_hdr);
 }
 
+/* init request without RFC1001 length at the beginning */
+static int
+smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
+		    void **request_buf, unsigned int *total_len)
+{
+	int rc;
+	struct smb2_sync_hdr *shdr;
+
+	rc = smb2_reconnect(smb2_command, tcon);
+	if (rc)
+		return rc;
+
+	/* BB eventually switch this to SMB2 specific small buf size */
+	*request_buf = cifs_small_buf_get();
+	if (*request_buf == NULL) {
+		/* BB should we add a retry in here if not a writepage? */
+		return -ENOMEM;
+	}
+
+	shdr = (struct smb2_sync_hdr *)(*request_buf);
+
+	fill_small_buf(smb2_command, tcon, shdr, total_len);
+
+	if (tcon != NULL) {
+#ifdef CONFIG_CIFS_STATS2
+		uint16_t com_code = le16_to_cpu(smb2_command);
+
+		cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_sent[com_code]);
+#endif
+		cifs_stats_inc(&tcon->num_smbs_sent);
+	}
+
+	return rc;
+}
+
 /*
  * Allocate and return pointer to an SMB request hdr, and set basic
  * SMB information in the SMB header. If the return code is zero, this
- * function must have filled in request_buf pointer.
+ * function must have filled in request_buf pointer. The returned buffer
+ * has RFC1001 length at the beginning.
  */
 static int
 small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
@@ -2140,16 +2176,17 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		  int request_type)
 {
 	int rc = -EACCES;
-	struct smb2_read_req *req = NULL;
+	struct smb2_read_plain_req *req = NULL;
 	struct smb2_sync_hdr *shdr;
 
-	rc = small_smb2_init(SMB2_READ, io_parms->tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, (void **) &req,
+				 total_len);
 	if (rc)
 		return rc;
 	if (io_parms->tcon->ses->server == NULL)
 		return -ECONNABORTED;
 
-	shdr = get_sync_hdr(req);
+	shdr = &req->sync_hdr;
 	shdr->ProcessId = cpu_to_le32(io_parms->pid);
 
 	req->PersistentFileId = io_parms->persistent_fid;
@@ -2163,9 +2200,9 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 
 	if (request_type & CHAINED_REQUEST) {
 		if (!(request_type & END_OF_CHAIN)) {
-			/* 4 for rfc1002 length field */
-			shdr->NextCommand =
-				cpu_to_le32(get_rfc1002_length(req) + 4);
+			/* next 8-byte aligned request */
+			*total_len = DIV_ROUND_UP(*total_len, 8) * 8;
+			shdr->NextCommand = cpu_to_le32(*total_len);
 		} else /* END_OF_CHAIN */
 			shdr->NextCommand = 0;
 		if (request_type & RELATED_REQUEST) {
@@ -2186,8 +2223,6 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		req->RemainingBytes = 0;
 
 	*buf = req;
-	/* 4 for rfc1002 length field */
-	*total_len = get_rfc1002_length(req) + 4;
 	return rc;
 }
 
@@ -2264,6 +2299,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 				 .rq_nvec = 2 };
 	struct TCP_Server_Info *server;
 	unsigned int total_len;
+	__be32 req_len;
 
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%u\n",
 		 __func__, rdata->offset, rdata->bytes);
@@ -2290,12 +2326,14 @@ smb2_async_readv(struct cifs_readdata *rdata)
 		return rc;
 	}
 
-	shdr = get_sync_hdr(buf);
-	/* 4 for rfc1002 length field */
-	rdata->iov[0].iov_len = 4;
-	rdata->iov[0].iov_base = buf;
-	rdata->iov[1].iov_len = total_len - 4;
-	rdata->iov[1].iov_base = buf + 4;
+	req_len = cpu_to_be32(total_len);
+
+	rdata->iov[0].iov_base = &req_len;
+	rdata->iov[0].iov_len = sizeof(__be32);
+	rdata->iov[1].iov_base = buf;
+	rdata->iov[1].iov_len = total_len;
+
+	shdr = (struct smb2_sync_hdr *)buf;
 
 	if (rdata->credits) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
@@ -2327,24 +2365,31 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	  unsigned int *nbytes, char **buf, int *buf_type)
 {
 	int resp_buftype, rc = -EACCES;
+	struct smb2_read_plain_req *req = NULL;
 	struct smb2_read_rsp *rsp = NULL;
 	struct smb2_sync_hdr *shdr;
-	struct kvec iov[1];
+	struct kvec iov[2];
 	struct kvec rsp_iov;
 	unsigned int total_len;
-	char *req;
+	__be32 req_len;
+	struct smb_rqst rqst = { .rq_iov = iov,
+				 .rq_nvec = 2 };
 
 	*nbytes = 0;
 	rc = smb2_new_read_req((void **)&req, &total_len, io_parms, 0, 0);
 	if (rc)
 		return rc;
 
-	iov[0].iov_base = buf;
-	iov[0].iov_len = total_len;
+	req_len = cpu_to_be32(total_len);
 
-	rc = SendReceive2(xid, io_parms->tcon->ses, iov, 1,
-			  &resp_buftype, CIFS_LOG_ERROR, &rsp_iov);
-	cifs_small_buf_release(iov[0].iov_base);
+	iov[0].iov_base = &req_len;
+	iov[0].iov_len = sizeof(__be32);
+	iov[1].iov_base = req;
+	iov[1].iov_len = total_len;
+
+	rc = cifs_send_recv(xid, io_parms->tcon->ses, &rqst, &resp_buftype,
+			    CIFS_LOG_ERROR, &rsp_iov);
+	cifs_small_buf_release(req);
 
 	rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
 	shdr = get_sync_hdr(rsp);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 052342d..35ff9fa 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -823,8 +823,9 @@ struct smb2_flush_rsp {
 #define SMB2_CHANNEL_RDMA_V1		0x00000001 /* SMB3 or later */
 #define SMB2_CHANNEL_RDMA_V1_INVALIDATE 0x00000001 /* SMB3.02 or later */
 
-struct smb2_read_req {
-	struct smb2_hdr hdr;
+/* SMB2 read request without RFC1001 length at the beginning */
+struct smb2_read_plain_req {
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 49 */
 	__u8   Padding; /* offset from start of SMB2 header to place read */
 	__u8   Flags; /* MBZ unless SMB3.02 or later */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 988f124..713981b2 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -665,7 +665,7 @@ cifs_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
 	return mid;
 }
 
-static int
+int
 cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	       struct smb_rqst *rqst, int *resp_buf_type, const int flags,
 	       struct kvec *resp_iov)
-- 
2.7.4
