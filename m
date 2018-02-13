From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/14] cifs: push rfc1002 generation down the stack
Date: Tue, 13 Feb 2018 15:42:23 +1100
Message-ID: <20180213044234.18364-4-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Move the generation of the 4 byte length field down the stack and
generate it immediately before we start writing the data to the socket.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c   | 10 +++++--
 fs/cifs/smb2ops.c       | 73 ++++++++++++++++++++-----------------------------
 fs/cifs/smb2pdu.c       | 34 +++++++----------------
 fs/cifs/smb2transport.c | 22 +++++++--------
 fs/cifs/transport.c     | 73 ++++++++++++++++++-------------------------------
 5 files changed, 85 insertions(+), 127 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 68abbb0db608..6bc175f44b8d 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -76,8 +76,14 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
 
-	if (n_vec < 2 || iov[0].iov_len != 4)
-		return -EIO;
+	/* iov[0] is actual data and not the rfc1002 length for SMB2+ */
+	if (server->vals->header_preamble_size == 0) {
+		rc = crypto_shash_update(shash,
+					 iov[0].iov_base, iov[0].iov_len);
+	} else {
+		if (n_vec < 2 || iov[0].iov_len != 4)
+			return -EIO;
+	}
 
 	for (i = 1; i < n_vec; i++) {
 		if (iov[i].iov_len == 0)
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 1c60b4e64656..6a2e33fa3b3a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2062,7 +2062,7 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 		   struct smb_rqst *old_rq)
 {
 	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)old_rq->rq_iov[1].iov_base;
+			(struct smb2_sync_hdr *)old_rq->rq_iov[0].iov_base;
 
 	memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
@@ -2073,14 +2073,13 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 }
 
 /* Assumes:
- * rqst->rq_iov[0]  is rfc1002 length
- * rqst->rq_iov[1]  is tranform header
- * rqst->rq_iov[2+] data to be encrypted/decrypted
+ * rqst->rq_iov[0]  is tranform header
+ * rqst->rq_iov[1+] data to be encrypted/decrypted
  */
 static struct scatterlist *
 init_sg(struct smb_rqst *rqst, u8 *sign)
 {
-	unsigned int sg_len = rqst->rq_nvec + rqst->rq_npages;
+	unsigned int sg_len = rqst->rq_nvec + rqst->rq_npages + 1;
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	struct scatterlist *sg;
 	unsigned int i;
@@ -2091,10 +2090,10 @@ init_sg(struct smb_rqst *rqst, u8 *sign)
 		return NULL;
 
 	sg_init_table(sg, sg_len);
-	sg_set_buf(&sg[0], rqst->rq_iov[1].iov_base + 20, assoc_data_len);
-	for (i = 1; i < rqst->rq_nvec - 1; i++)
-		sg_set_buf(&sg[i], rqst->rq_iov[i+1].iov_base,
-						rqst->rq_iov[i+1].iov_len);
+	sg_set_buf(&sg[0], rqst->rq_iov[0].iov_base + 20, assoc_data_len);
+	for (i = 1; i < rqst->rq_nvec; i++)
+		sg_set_buf(&sg[i], rqst->rq_iov[i].iov_base,
+						rqst->rq_iov[i].iov_len);
 	for (j = 0; i < sg_len - 1; i++, j++) {
 		unsigned int len = (j < rqst->rq_npages - 1) ? rqst->rq_pagesz
 							: rqst->rq_tailsz;
@@ -2125,18 +2124,17 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
 	return 1;
 }
 /*
- * Encrypt or decrypt @rqst message. @rqst has the following format:
- * iov[0] - rfc1002 length
- * iov[1] - transform header (associate data),
- * iov[2-N] and pages - data to encrypt.
- * On success return encrypted data in iov[2-N] and pages, leave iov[0-1]
+ * Encrypt or decrypt @rqst message. @rqst[0] has the following format:
+ * iov[0]   - transform header (associate data),
+ * iov[1-N] - SMB2 header and pages - data to encrypt.
+ * On success return encrypted data in iov[1-N] and pages, leave iov[0]
  * untouched.
  */
 static int
 crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 {
 	struct smb2_transform_hdr *tr_hdr =
-			(struct smb2_transform_hdr *)rqst->rq_iov[1].iov_base;
+			(struct smb2_transform_hdr *)rqst->rq_iov[0].iov_base;
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc = 0;
 	struct scatterlist *sg;
@@ -2149,7 +2147,6 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 	struct crypto_aead *tfm;
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 
-	/* Fixme compounding: get rid of iov[0] */
 	rc = smb2_get_enc_key(server, tr_hdr->SessionId, enc, key);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not get %scryption key\n", __func__,
@@ -2225,9 +2222,6 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 	return rc;
 }
 
-/* This is called from smb_send_rqst. At this point we have the rfc1002
- * header as the first element in the vector.
- */
 static int
 smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 		       struct smb_rqst *old_rq)
@@ -2236,7 +2230,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 	struct page **pages;
 	struct smb2_transform_hdr *tr_hdr;
 	unsigned int npages = old_rq->rq_npages;
-	unsigned int orig_len = get_rfc1002_length(old_rq->rq_iov[0].iov_base);
+	unsigned int orig_len = 0;
 	int i;
 	int rc = -ENOMEM;
 
@@ -2249,24 +2243,23 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 	new_rq->rq_pagesz = old_rq->rq_pagesz;
 	new_rq->rq_tailsz = old_rq->rq_tailsz;
 
+	for (i = 0; i < old_rq->rq_nvec; i++)
+		orig_len += old_rq->rq_iov[i].iov_len;
+
 	for (i = 0; i < npages; i++) {
 		pages[i] = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
 		if (!pages[i])
 			goto err_free_pages;
 	}
 
-	/* Make space for one extra iov to hold the transform header */
 	iov = kmalloc_array(old_rq->rq_nvec + 1, sizeof(struct kvec),
 			    GFP_KERNEL);
 	if (!iov)
 		goto err_free_pages;
 
-	/* copy all iovs from the old except the 1st one (rfc1002 length) */
-	memcpy(&iov[2], &old_rq->rq_iov[1],
-				sizeof(struct kvec) * (old_rq->rq_nvec - 1));
-	/* copy the rfc1002 iov */
-	iov[0].iov_base = old_rq->rq_iov[0].iov_base;
-	iov[0].iov_len  = old_rq->rq_iov[0].iov_len;
+	/* copy all iovs from the old */
+	memcpy(&iov[1], &old_rq->rq_iov[0],
+				sizeof(struct kvec) * old_rq->rq_nvec);
 
 	new_rq->rq_iov = iov;
 	new_rq->rq_nvec = old_rq->rq_nvec + 1;
@@ -2277,12 +2270,8 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 
 	/* fill the 2nd iov with a transform header */
 	fill_transform_hdr(tr_hdr, orig_len, old_rq);
-	new_rq->rq_iov[1].iov_base = tr_hdr;
-	new_rq->rq_iov[1].iov_len = sizeof(struct smb2_transform_hdr);
-
-	/* Update rfc1002 header */
-	inc_rfc1001_len(new_rq->rq_iov[0].iov_base,
-			sizeof(struct smb2_transform_hdr));
+	new_rq->rq_iov[0].iov_base = tr_hdr;
+	new_rq->rq_iov[0].iov_len = sizeof(struct smb2_transform_hdr);
 
 	/* copy pages form the old */
 	for (i = 0; i < npages; i++) {
@@ -2322,7 +2311,7 @@ smb3_free_transform_rq(struct smb_rqst *rqst)
 		put_page(rqst->rq_pages[i]);
 	kfree(rqst->rq_pages);
 	/* free transform header */
-	kfree(rqst->rq_iov[1].iov_base);
+	kfree(rqst->rq_iov[0].iov_base);
 	kfree(rqst->rq_iov);
 }
 
@@ -2339,19 +2328,17 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 		 unsigned int buf_data_size, struct page **pages,
 		 unsigned int npages, unsigned int page_data_size)
 {
-	struct kvec iov[3];
+	struct kvec iov[2];
 	struct smb_rqst rqst = {NULL};
 	int rc;
 
-	iov[0].iov_base = NULL;
-	iov[0].iov_len = 0;
-	iov[1].iov_base = buf;
-	iov[1].iov_len = sizeof(struct smb2_transform_hdr);
-	iov[2].iov_base = buf + sizeof(struct smb2_transform_hdr);
-	iov[2].iov_len = buf_data_size;
+	iov[0].iov_base = buf;
+	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
+	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
+	iov[1].iov_len = buf_data_size;
 
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = 3;
+	rqst.rq_nvec = 2;
 	rqst.rq_pages = pages;
 	rqst.rq_npages = npages;
 	rqst.rq_pagesz = PAGE_SIZE;
@@ -2363,7 +2350,7 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 	if (rc)
 		return rc;
 
-	memmove(buf, iov[2].iov_base, buf_data_size);
+	memmove(buf, iov[1].iov_base, buf_data_size);
 
 	server->total_read = buf_data_size + page_data_size;
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ad178150fbf3..a1a25b46cc2e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2344,11 +2344,10 @@ SMB2_echo(struct TCP_Server_Info *server)
 {
 	struct smb2_echo_req *req;
 	int rc = 0;
-	struct kvec iov[2];
+	struct kvec iov[1];
 	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = 2 };
+				 .rq_nvec = 1 };
 	unsigned int total_len;
-	__be32 rfc1002_marker;
 
 	cifs_dbg(FYI, "In echo request\n");
 
@@ -2364,11 +2363,8 @@ SMB2_echo(struct TCP_Server_Info *server)
 
 	req->sync_hdr.CreditRequest = cpu_to_le16(1);
 
-	iov[0].iov_len = 4;
-	rfc1002_marker = cpu_to_be32(total_len);
-	iov[0].iov_base = &rfc1002_marker;
-	iov[1].iov_len = total_len;
-	iov[1].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
+	iov[0].iov_base = (char *)req;
 
 	rc = cifs_call_async(server, &rqst, NULL, smb2_echo_callback, NULL,
 			     server, CIFS_ECHO_OP);
@@ -2551,10 +2547,9 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	struct smb2_sync_hdr *shdr;
 	struct cifs_io_parms io_parms;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = 2 };
+				 .rq_nvec = 1 };
 	struct TCP_Server_Info *server;
 	unsigned int total_len;
-	__be32 req_len;
 
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%u\n",
 		 __func__, rdata->offset, rdata->bytes);
@@ -2585,12 +2580,8 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	if (encryption_required(io_parms.tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req_len = cpu_to_be32(total_len);
-
-	rdata->iov[0].iov_base = &req_len;
-	rdata->iov[0].iov_len = sizeof(__be32);
-	rdata->iov[1].iov_base = buf;
-	rdata->iov[1].iov_len = total_len;
+	rdata->iov[0].iov_base = buf;
+	rdata->iov[0].iov_len = total_len;
 
 	shdr = (struct smb2_sync_hdr *)buf;
 
@@ -2741,10 +2732,9 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	struct smb2_sync_hdr *shdr;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	struct kvec iov[2];
+	struct kvec iov[1];
 	struct smb_rqst rqst = { };
 	unsigned int total_len;
-	__be32 rfc1002_marker;
 
 	rc = smb2_plain_req_init(SMB2_WRITE, tcon, (void **) &req, &total_len);
 	if (rc) {
@@ -2775,12 +2765,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 				offsetof(struct smb2_write_req, Buffer));
 	req->RemainingBytes = 0;
 
-	/* 4 for rfc1002 length field and 1 for Buffer */
-	iov[0].iov_len = 4;
-	rfc1002_marker = cpu_to_be32(total_len - 1 + wdata->bytes);
-	iov[0].iov_base = &rfc1002_marker;
-	iov[1].iov_len = total_len - 1;
-	iov[1].iov_base = (char *)req;
+	iov[0].iov_len = total_len - 1;
+	iov[0].iov_base = (char *)req;
 
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index cf37c6651bf6..dbd257faf01b 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -186,7 +186,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
 	unsigned char *sigptr = smb2_signature;
 	struct kvec *iov = rqst->rq_iov;
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)iov[1].iov_base;
+	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)iov[0].iov_base;
 	struct cifs_ses *ses;
 
 	ses = smb2_find_smb_ses(server, shdr->SessionId);
@@ -427,7 +427,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	unsigned char *sigptr = smb3_signature;
 	struct kvec *iov = rqst->rq_iov;
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)iov[1].iov_base;
+	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)iov[0].iov_base;
 	struct cifs_ses *ses;
 
 	ses = smb2_find_smb_ses(server, shdr->SessionId);
@@ -473,7 +473,7 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	int rc = 0;
 	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)rqst->rq_iov[1].iov_base;
+			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
 
 	if (!(shdr->Flags & SMB2_FLAGS_SIGNED) ||
 	    server->tcpStatus == CifsNeedNegotiate)
@@ -495,7 +495,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	unsigned int rc;
 	char server_response_sig[16];
 	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)rqst->rq_iov[1].iov_base;
+			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
 
 	if ((shdr->Command == SMB2_NEGOTIATE) ||
 	    (shdr->Command == SMB2_SESSION_SETUP) ||
@@ -620,14 +620,12 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
 	unsigned int len = get_rfc1002_length(mid->resp_buf);
-	struct kvec iov[2];
+	struct kvec iov[1];
 	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = 2 };
+				 .rq_nvec = 1 };
 
-	iov[0].iov_base = NULL;
-	iov[0].iov_len = 4;
-	iov[1].iov_base = (char *)mid->resp_buf;
-	iov[1].iov_len = server->total_size;
+	iov[0].iov_base = (char *)mid->resp_buf;
+	iov[0].iov_len = server->total_size;
 
 	dump_smb(mid->resp_buf, min_t(u32, 80, len));
 	/* convert the length into a more usable form */
@@ -648,7 +646,7 @@ smb2_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
 {
 	int rc;
 	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)rqst->rq_iov[1].iov_base;
+			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	smb2_seq_num_into_buf(ses->server, shdr);
@@ -669,7 +667,7 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
 	int rc;
 	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)rqst->rq_iov[1].iov_base;
+			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	smb2_seq_num_into_buf(server, shdr);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5cecf67af8f1..d6f26fc3e6f5 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -225,37 +225,45 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	int rc;
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
-	unsigned int smb_buf_length = get_rfc1002_length(iov[0].iov_base);
-	unsigned long send_length;
+	unsigned int send_length;
 	unsigned int i;
 	size_t total_len = 0, sent, size;
 	struct socket *ssocket = server->ssocket;
 	struct msghdr smb_msg;
 	int val = 1;
+	__be32 rfc1002_marker;
 
 	if (ssocket == NULL)
 		return -ENOTSOCK;
 
-	/* sanity check send length */
 	send_length = rqst_len(rqst);
-	if (send_length != smb_buf_length + 4) {
-		WARN(1, "Send length mismatch(send_length=%lu smb_buf_length=%u)\n",
-			send_length, smb_buf_length);
-		return -EIO;
-	}
-
-	if (n_vec < 2)
-		return -EIO;
-
-	cifs_dbg(FYI, "Sending smb: smb_len=%u\n", smb_buf_length);
-	dump_smb(iov[0].iov_base, iov[0].iov_len);
-	dump_smb(iov[1].iov_base, iov[1].iov_len);
+	rfc1002_marker = cpu_to_be32(send_length);
 
 	/* cork the socket */
 	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
 				(char *)&val, sizeof(val));
 
 	size = 0;
+	/* Generate a rfc1002 marker for SMB2+ */
+	if (server->vals->header_preamble_size == 0) {
+		struct kvec hiov = {
+			.iov_base = &rfc1002_marker,
+			.iov_len  = 4
+		};
+		iov_iter_kvec(&smb_msg.msg_iter, WRITE | ITER_KVEC, &hiov,
+			      1, 4);
+		rc = smb_send_kvec(server, &smb_msg, &sent);
+		if (rc < 0)
+			goto uncork;
+
+		total_len += sent;
+		send_length += 4;
+	}
+
+	cifs_dbg(FYI, "Sending smb: smb_len=%u\n", send_length);
+	dump_smb(iov[0].iov_base, iov[0].iov_len);
+	dump_smb(iov[1].iov_base, iov[1].iov_len);
+
 	for (i = 0; i < n_vec; i++)
 		size += iov[i].iov_len;
 
@@ -291,9 +299,9 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
 				(char *)&val, sizeof(val));
 
-	if ((total_len > 0) && (total_len != smb_buf_length + 4)) {
+	if ((total_len > 0) && (total_len != send_length)) {
 		cifs_dbg(FYI, "partial send (wanted=%u sent=%zu): terminating session\n",
-			 smb_buf_length + 4, total_len);
+			 send_length, total_len);
 		/*
 		 * If we have only sent part of an SMB then the next SMB could
 		 * be taken as the remainder of this one. We need to kill the
@@ -713,7 +721,6 @@ cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * to the same server. We may make this configurable later or
 	 * use ses->maxReq.
 	 */
-
 	rc = wait_for_free_request(ses->server, timeout, optype);
 	if (rc)
 		return rc;
@@ -844,39 +851,13 @@ smb2_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	       const int flags, struct kvec *resp_iov)
 {
 	struct smb_rqst rqst;
-	struct kvec s_iov[CIFS_MAX_IOV_SIZE], *new_iov;
 	int rc;
-	int i;
-	__u32 count;
-	__be32 rfc1002_marker;
-
-	if (n_vec + 1 > CIFS_MAX_IOV_SIZE) {
-		new_iov = kmalloc(sizeof(struct kvec) * (n_vec + 1),
-				  GFP_KERNEL);
-		if (!new_iov)
-			return -ENOMEM;
-	} else
-		new_iov = s_iov;
-
-	/* 1st iov is an RFC1002 Session Message length */
-	memcpy(new_iov + 1, iov, (sizeof(struct kvec) * n_vec));
-
-	count = 0;
-	for (i = 1; i < n_vec + 1; i++)
-		count += new_iov[i].iov_len;
-
-	rfc1002_marker = cpu_to_be32(count);
-
-	new_iov[0].iov_base = &rfc1002_marker;
-	new_iov[0].iov_len = 4;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = new_iov;
-	rqst.rq_nvec = n_vec + 1;
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = n_vec;
 
 	rc = cifs_send_recv(xid, ses, &rqst, resp_buf_type, flags, resp_iov);
-	if (n_vec + 1 > CIFS_MAX_IOV_SIZE)
-		kfree(new_iov);
 	return rc;
 }
 
-- 
2.13.3
