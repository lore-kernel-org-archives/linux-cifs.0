From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 13/15] CIFS: Decrypt and process small encrypted packets
Date: Mon, 30 Jan 2017 13:39:42 -0800
Message-ID: <1485812384-28870-14-git-send-email-pshilov@microsoft.com>
References: <1485812384-28870-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485812384-28870-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Allow to decrypt transformed packets, find a corresponding mid
and process as usual further.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h      |   1 +
 fs/cifs/cifsproto.h     |   2 +
 fs/cifs/connect.c       |   9 ++
 fs/cifs/smb2ops.c       | 227 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.c       |   4 +-
 fs/cifs/smb2proto.h     |   2 +
 fs/cifs/smb2transport.c |   2 +-
 7 files changed, 243 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index fa56f47..f9a9a12 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1342,6 +1342,7 @@ struct mid_q_entry {
 	bool large_buf:1;	/* if valid response, is pointer to large buf */
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool multiEnd:1;	/* both received */
+	bool decrypted:1;	/* decrypted entry */
 };
 
 /*	Make code in transport.c a little cleaner by moving
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index fe874dc..0eb35d2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -74,6 +74,8 @@ extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern void cifs_delete_mid(struct mid_q_entry *mid);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
+extern int cifs_handle_standard(struct TCP_Server_Info *server,
+				struct mid_q_entry *mid);
 extern int cifs_call_async(struct TCP_Server_Info *server,
 			struct smb_rqst *rqst,
 			mid_receive_t *receive, mid_callback_t *callback,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3a2183a..c41f496 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -784,6 +784,15 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	dump_smb(buf, server->total_read);
 
+	return cifs_handle_standard(server, mid);
+}
+
+int
+cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+{
+	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
+	int length;
+
 	/*
 	 * We know that we received enough to get to the MID as we
 	 * checked the pdu_length earlier. Now check to see
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index eda9d4c..86b8ab2 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1799,6 +1799,228 @@ smb3_free_transform_rq(struct smb_rqst *rqst)
 	kfree(rqst->rq_iov);
 }
 
+static int
+smb3_is_transform_hdr(void *buf)
+{
+	struct smb2_transform_hdr *trhdr = buf;
+
+	return trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM;
+}
+
+static int
+decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
+		 unsigned int buf_data_size, struct page **pages,
+		 unsigned int npages, unsigned int page_data_size)
+{
+	struct kvec iov[2];
+	struct smb_rqst rqst = {0};
+	struct smb2_hdr *hdr;
+	int rc;
+
+	iov[0].iov_base = buf;
+	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
+	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
+	iov[1].iov_len = buf_data_size;
+
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 2;
+	rqst.rq_pages = pages;
+	rqst.rq_npages = npages;
+	rqst.rq_pagesz = PAGE_SIZE;
+	rqst.rq_tailsz = (page_data_size % PAGE_SIZE) ? : PAGE_SIZE;
+
+	rc = crypt_message(server, &rqst, 0);
+	cifs_dbg(FYI, "decrypt message returned %d\n", rc);
+
+	if (rc)
+		return rc;
+
+	memmove(buf + 4, iov[1].iov_base, buf_data_size);
+	hdr = (struct smb2_hdr *)buf;
+	hdr->smb2_buf_length = cpu_to_be32(buf_data_size + page_data_size);
+	server->total_read = buf_data_size + page_data_size + 4;
+
+	return rc;
+}
+
+static int
+handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
+		 char *buf, unsigned int buf_len, struct page **pages,
+		 unsigned int npages, unsigned int page_data_size)
+{
+	unsigned int data_offset;
+	unsigned int data_len;
+	struct cifs_readdata *rdata = mid->callback_data;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
+	struct bio_vec *bvec = NULL;
+	struct iov_iter iter;
+	struct kvec iov;
+	int length;
+
+	if (shdr->Command != SMB2_READ) {
+		cifs_dbg(VFS, "only big read responses are supported\n");
+		return -ENOTSUPP;
+	}
+
+	if (server->ops->is_status_pending &&
+			server->ops->is_status_pending(buf, server, 0))
+		return -1;
+
+	rdata->result = server->ops->map_error(buf, false);
+	if (rdata->result != 0) {
+		cifs_dbg(FYI, "%s: server returned error %d\n",
+			 __func__, rdata->result);
+		dequeue_mid(mid, rdata->result);
+		return 0;
+	}
+
+	data_offset = server->ops->read_data_offset(buf) + 4;
+	data_len = server->ops->read_data_length(buf);
+
+	if (data_offset < server->vals->read_rsp_size) {
+		/*
+		 * win2k8 sometimes sends an offset of 0 when the read
+		 * is beyond the EOF. Treat it as if the data starts just after
+		 * the header.
+		 */
+		cifs_dbg(FYI, "%s: data offset (%u) inside read response header\n",
+			 __func__, data_offset);
+		data_offset = server->vals->read_rsp_size;
+	} else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
+		/* data_offset is beyond the end of smallbuf */
+		cifs_dbg(FYI, "%s: data offset (%u) beyond end of smallbuf\n",
+			 __func__, data_offset);
+		rdata->result = -EIO;
+		dequeue_mid(mid, rdata->result);
+		return 0;
+	}
+
+	if (buf_len <= data_offset) {
+		/* read response payload is in pages */
+		/* BB add code to init iter with pages */
+	} else if (buf_len >= data_offset + data_len) {
+		/* read response payload is in buf */
+		WARN_ONCE(npages > 0, "read data can be either in buf or in pages");
+		iov.iov_base = buf + data_offset;
+		iov.iov_len = data_len;
+		iov_iter_kvec(&iter, WRITE | ITER_KVEC, &iov, 1, data_len);
+	} else {
+		/* read response payload cannot be in both buf and pages */
+		WARN_ONCE(1, "buf can not contain only a part of read data");
+		rdata->result = -EIO;
+		dequeue_mid(mid, rdata->result);
+		return 0;
+	}
+
+	/* set up first iov for signature check */
+	rdata->iov[0].iov_base = buf;
+	rdata->iov[0].iov_len = 4;
+	rdata->iov[1].iov_base = buf + 4;
+	rdata->iov[1].iov_len = server->vals->read_rsp_size - 4;
+	cifs_dbg(FYI, "0: iov_base=%p iov_len=%lu\n",
+		 rdata->iov[0].iov_base, server->vals->read_rsp_size);
+
+	length = rdata->copy_into_pages(server, rdata, &iter);
+
+	kfree(bvec);
+
+	if (length < 0)
+		return length;
+
+	dequeue_mid(mid, false);
+	return length;
+}
+
+static int
+receive_encrypted_standard(struct TCP_Server_Info *server,
+			   struct mid_q_entry **mid)
+{
+	int length;
+	char *buf = server->smallbuf;
+	unsigned int pdu_length = get_rfc1002_length(buf);
+	unsigned int buf_size;
+	struct mid_q_entry *mid_entry;
+
+	/* switch to large buffer if too big for a small one */
+	if (pdu_length + 4 > MAX_CIFS_SMALL_BUFFER_SIZE) {
+		server->large_buf = true;
+		memcpy(server->bigbuf, buf, server->total_read);
+		buf = server->bigbuf;
+	}
+
+	/* now read the rest */
+	length = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1,
+				pdu_length - HEADER_SIZE(server) + 1 + 4);
+	if (length < 0)
+		return length;
+	server->total_read += length;
+
+	buf_size = pdu_length + 4 - sizeof(struct smb2_transform_hdr);
+	length = decrypt_raw_data(server, buf, buf_size, NULL, 0, 0);
+	if (length)
+		return length;
+
+	mid_entry = smb2_find_mid(server, buf);
+	if (mid_entry == NULL)
+		cifs_dbg(FYI, "mid not found\n");
+	else {
+		cifs_dbg(FYI, "mid found\n");
+		mid_entry->decrypted = true;
+	}
+
+	*mid = mid_entry;
+
+	if (mid_entry && mid_entry->handle)
+		return mid_entry->handle(server, mid_entry);
+
+	return cifs_handle_standard(server, mid_entry);
+}
+
+static int
+smb3_receive_transform(struct TCP_Server_Info *server, struct mid_q_entry **mid)
+{
+	char *buf = server->smallbuf;
+	unsigned int pdu_length = get_rfc1002_length(buf);
+	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
+	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
+
+	if (pdu_length + 4 < sizeof(struct smb2_transform_hdr) +
+						sizeof(struct smb2_sync_hdr)) {
+		cifs_dbg(VFS, "Transform message is too small (%u)\n",
+			 pdu_length);
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return -ECONNABORTED;
+	}
+
+	if (pdu_length + 4 < orig_len + sizeof(struct smb2_transform_hdr)) {
+		cifs_dbg(VFS, "Transform message is broken\n");
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return -ECONNABORTED;
+	}
+
+	if (pdu_length + 4 > CIFSMaxBufSize + MAX_HEADER_SIZE(server)) {
+		cifs_dbg(VFS, "Decoding responses of big size (%u) is not supported\n",
+			 pdu_length);
+		/* BB add code to allocate and fill highmem pages here */
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return -ECONNABORTED;
+	}
+
+	return receive_encrypted_standard(server, mid);
+}
+
+int
+smb3_handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+{
+	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
+
+	return handle_read_data(server, mid, buf, get_rfc1002_length(buf) + 4,
+				NULL, 0, 0);
+}
+
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -2047,6 +2269,8 @@ struct smb_version_operations smb30_operations = {
 	.enum_snapshots = smb3_enum_snapshots,
 	.init_transform_rq = smb3_init_transform_rq,
 	.free_transform_rq = smb3_free_transform_rq,
+	.is_transform_hdr = smb3_is_transform_hdr,
+	.receive_transform = smb3_receive_transform,
 };
 
 #ifdef CONFIG_CIFS_SMB311
@@ -2137,7 +2361,8 @@ struct smb_version_operations smb311_operations = {
 	.enum_snapshots = smb3_enum_snapshots,
 	.init_transform_rq = smb3_init_transform_rq,
 	.free_transform_rq = smb3_free_transform_rq,
-};
+	.is_transform_hdr = smb3_is_transform_hdr,
+	.receive_transform = smb3_receive_transform,
 };
 #endif /* CIFS_SMB311 */
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 12dee85..0abeb5f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2281,7 +2281,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	case MID_RESPONSE_RECEIVED:
 		credits_received = le16_to_cpu(shdr->CreditRequest);
 		/* result already set, check signature */
-		if (server->sign) {
+		if (server->sign && !mid->decrypted) {
 			int rc;
 
 			rc = smb2_verify_signature(&rqst, server);
@@ -2384,7 +2384,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(io_parms.tcon->ses->server, &rqst,
 			     cifs_readv_receive, smb2_readv_callback,
-			     NULL, rdata, flags);
+			     smb3_handle_read_data, rdata, flags);
 	if (rc) {
 		kref_put(&rdata->refcount, cifs_readdata_release);
 		cifs_stats_fail_inc(io_parms.tcon, SMB2_READ_HE);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 7d30b75..85fc7a7 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -58,6 +58,8 @@ extern bool smb2_is_valid_oplock_break(char *buffer,
 				       struct TCP_Server_Info *srv);
 extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
 					  __u64 ses_id);
+extern int smb3_handle_read_data(struct TCP_Server_Info *server,
+				 struct mid_q_entry *mid);
 
 extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
 				   struct smb2_file_all_info *src);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 3caa11d..7c3bb1b 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -564,7 +564,7 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 
 	dump_smb(mid->resp_buf, min_t(u32, 80, len));
 	/* convert the length into a more usable form */
-	if (len > 24 && server->sign) {
+	if (len > 24 && server->sign && !mid->decrypted) {
 		int rc;
 
 		rc = smb2_verify_signature(&rqst, server);
-- 
2.7.4
