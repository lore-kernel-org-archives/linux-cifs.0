From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 02/15] CIFS: Make SendReceive2() takes resp iov
Date: Mon, 30 Jan 2017 13:39:31 -0800
Message-ID: <1485812384-28870-3-git-send-email-pshilov@microsoft.com>
References: <1485812384-28870-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485812384-28870-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now SendReceive2 frees the first iov and returns a response buffer
in it that increases a code complexity. Simplify this by making
a caller responsible for freeing request buffer itself and returning
a response buffer in a separate iov.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsproto.h |   3 +-
 fs/cifs/cifssmb.c   |  70 ++++++++++++++++------------
 fs/cifs/sess.c      |   5 +-
 fs/cifs/smb2pdu.c   | 128 +++++++++++++++++++++++++++++++++-------------------
 fs/cifs/transport.c |  30 ++++--------
 5 files changed, 136 insertions(+), 100 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index cd8025a..8610f25 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -95,7 +95,8 @@ extern int cifs_wait_mtu_credits(struct TCP_Server_Info *server,
 				 unsigned int *credits);
 extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
 			struct kvec *, int /* nvec to send */,
-			int * /* type of buf returned */ , const int flags);
+			int * /* type of buf returned */, const int flags,
+			struct kvec * /* resp vec */);
 extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct cifs_tcon *ptcon,
 			struct smb_hdr *in_buf ,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e3fed92..e2a790a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -673,6 +673,7 @@ CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
 		return rc;
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *)smb_buffer, 0);
+	cifs_small_buf_release(smb_buffer);
 	if (rc)
 		cifs_dbg(FYI, "Tree disconnect failed %d\n", rc);
 
@@ -772,6 +773,7 @@ CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses)
 
 	pSMB->AndXCommand = 0xFF;
 	rc = SendReceiveNoRsp(xid, ses, (char *) pSMB, 0);
+	cifs_small_buf_release(pSMB);
 session_already_dead:
 	mutex_unlock(&ses->session_mutex);
 
@@ -1667,6 +1669,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	int wct;
 	int resp_buf_type = 0;
 	struct kvec iov[1];
+	struct kvec rsp_iov;
 	__u32 pid = io_parms->pid;
 	__u16 netfid = io_parms->netfid;
 	__u64 offset = io_parms->offset;
@@ -1716,10 +1719,11 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	iov[0].iov_base = (char *)pSMB;
 	iov[0].iov_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4;
-	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs */,
-			 &resp_buf_type, CIFS_LOG_ERROR);
+	rc = SendReceive2(xid, tcon->ses, iov, 1, &resp_buf_type,
+			  CIFS_LOG_ERROR, &rsp_iov);
+	cifs_small_buf_release(pSMB);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
-	pSMBr = (READ_RSP *)iov[0].iov_base;
+	pSMBr = (READ_RSP *)rsp_iov.iov_base;
 	if (rc) {
 		cifs_dbg(VFS, "Send error in read = %d\n", rc);
 	} else {
@@ -1747,12 +1751,11 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 		}
 	}
 
-/*	cifs_small_buf_release(pSMB); */ /* Freed earlier now in SendReceive2 */
 	if (*buf) {
-		free_rsp_buf(resp_buf_type, iov[0].iov_base);
+		free_rsp_buf(resp_buf_type, rsp_iov.iov_base);
 	} else if (resp_buf_type != CIFS_NO_BUFFER) {
 		/* return buffer to caller to free */
-		*buf = iov[0].iov_base;
+		*buf = rsp_iov.iov_base;
 		if (resp_buf_type == CIFS_SMALL_BUFFER)
 			*pbuf_type = CIFS_SMALL_BUFFER;
 		else if (resp_buf_type == CIFS_LARGE_BUFFER)
@@ -2182,6 +2185,7 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 	__u64 offset = io_parms->offset;
 	struct cifs_tcon *tcon = io_parms->tcon;
 	unsigned int count = io_parms->length;
+	struct kvec rsp_iov;
 
 	*nbytes = 0;
 
@@ -2240,8 +2244,9 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 	else /* wct == 12 pad bigger by four bytes */
 		iov[0].iov_len = smb_hdr_len + 8;
 
-
-	rc = SendReceive2(xid, tcon->ses, iov, n_vec + 1, &resp_buf_type, 0);
+	rc = SendReceive2(xid, tcon->ses, iov, n_vec + 1, &resp_buf_type, 0,
+			  &rsp_iov);
+	cifs_small_buf_release(pSMB);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	if (rc) {
 		cifs_dbg(FYI, "Send error Write2 = %d\n", rc);
@@ -2249,7 +2254,7 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 		/* presumably this can not happen, but best to be safe */
 		rc = -EIO;
 	} else {
-		WRITE_RSP *pSMBr = (WRITE_RSP *)iov[0].iov_base;
+		WRITE_RSP *pSMBr = (WRITE_RSP *)rsp_iov.iov_base;
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
 		*nbytes = (*nbytes) << 16;
 		*nbytes += le16_to_cpu(pSMBr->Count);
@@ -2263,8 +2268,7 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 			*nbytes &= 0xFFFF;
 	}
 
-/*	cifs_small_buf_release(pSMB); */ /* Freed earlier now in SendReceive2 */
-	free_rsp_buf(resp_buf_type, iov[0].iov_base);
+	free_rsp_buf(resp_buf_type, rsp_iov.iov_base);
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
 		since file handle passed in no longer valid */
@@ -2279,6 +2283,7 @@ int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	LOCK_REQ *pSMB = NULL;
 	struct kvec iov[2];
+	struct kvec rsp_iov;
 	int resp_buf_type;
 	__u16 count;
 
@@ -2307,7 +2312,9 @@ int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[1].iov_len = (num_unlock + num_lock) * sizeof(LOCKING_ANDX_RANGE);
 
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
-	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP);
+	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP,
+			  &rsp_iov);
+	cifs_small_buf_release(pSMB);
 	if (rc)
 		cifs_dbg(FYI, "Send error in cifs_lockv = %d\n", rc);
 
@@ -2368,14 +2375,12 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
 	inc_rfc1001_len(pSMB, count);
 	pSMB->ByteCount = cpu_to_le16(count);
 
-	if (waitFlag) {
+	if (waitFlag)
 		rc = SendReceiveBlockingLock(xid, tcon, (struct smb_hdr *) pSMB,
 			(struct smb_hdr *) pSMB, &bytes_returned);
-		cifs_small_buf_release(pSMB);
-	} else {
+	else
 		rc = SendReceiveNoRsp(xid, tcon->ses, (char *)pSMB, flags);
-		/* SMB buffer freed by function above */
-	}
+	cifs_small_buf_release(pSMB);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
 	if (rc)
 		cifs_dbg(FYI, "Send error in Lock = %d\n", rc);
@@ -2401,6 +2406,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buf_type = 0;
 	__u16 params, param_offset, offset, byte_count, count;
 	struct kvec iov[1];
+	struct kvec rsp_iov;
 
 	cifs_dbg(FYI, "Posix Lock\n");
 
@@ -2462,11 +2468,10 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		iov[0].iov_base = (char *)pSMB;
 		iov[0].iov_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4;
 		rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs */,
-				&resp_buf_type, timeout);
-		pSMB = NULL; /* request buf already freed by SendReceive2. Do
-				not try to free it twice below on exit */
-		pSMBr = (struct smb_com_transaction2_sfi_rsp *)iov[0].iov_base;
+				&resp_buf_type, timeout, &rsp_iov);
+		pSMBr = (struct smb_com_transaction2_sfi_rsp *)rsp_iov.iov_base;
 	}
+	cifs_small_buf_release(pSMB);
 
 	if (rc) {
 		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
@@ -2506,10 +2511,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 plk_err_exit:
-	if (pSMB)
-		cifs_small_buf_release(pSMB);
-
-	free_rsp_buf(resp_buf_type, iov[0].iov_base);
+	free_rsp_buf(resp_buf_type, rsp_iov.iov_base);
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
 	   since file handle passed in no longer valid */
@@ -2536,6 +2538,7 @@ CIFSSMBClose(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 	pSMB->LastWriteTime = 0xFFFFFFFF;
 	pSMB->ByteCount = 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
+	cifs_small_buf_release(pSMB);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_closes);
 	if (rc) {
 		if (rc != -EINTR) {
@@ -2565,6 +2568,7 @@ CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 	pSMB->FileID = (__u16) smb_file_id;
 	pSMB->ByteCount = 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
+	cifs_small_buf_release(pSMB);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_flushes);
 	if (rc)
 		cifs_dbg(VFS, "Send error in Flush = %d\n", rc);
@@ -3820,6 +3824,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 	int buf_type = 0;
 	QUERY_SEC_DESC_REQ *pSMB;
 	struct kvec iov[1];
+	struct kvec rsp_iov;
 
 	cifs_dbg(FYI, "GetCifsACL\n");
 
@@ -3843,7 +3848,8 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 	iov[0].iov_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4;
 
 	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovec */, &buf_type,
-			 0);
+			  0, &rsp_iov);
+	cifs_small_buf_release(pSMB);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_acl_get);
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QuerySecDesc = %d\n", rc);
@@ -3855,11 +3861,11 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 		char *pdata;
 
 /* validate_nttransact */
-		rc = validate_ntransact(iov[0].iov_base, (char **)&parm,
+		rc = validate_ntransact(rsp_iov.iov_base, (char **)&parm,
 					&pdata, &parm_len, pbuflen);
 		if (rc)
 			goto qsec_out;
-		pSMBr = (struct smb_com_ntransact_rsp *)iov[0].iov_base;
+		pSMBr = (struct smb_com_ntransact_rsp *)rsp_iov.iov_base;
 
 		cifs_dbg(FYI, "smb %p parm %p data %p\n",
 			 pSMBr, parm, *acl_inf);
@@ -3896,8 +3902,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 		}
 	}
 qsec_out:
-	free_rsp_buf(buf_type, iov[0].iov_base);
-/*	cifs_small_buf_release(pSMB); */ /* Freed earlier now in SendReceive2 */
+	free_rsp_buf(buf_type, rsp_iov.iov_base);
 	return rc;
 }
 
@@ -4666,6 +4671,7 @@ CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->FileID = searchHandle;
 	pSMB->ByteCount = 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
+	cifs_small_buf_release(pSMB);
 	if (rc)
 		cifs_dbg(VFS, "Send error in FindClose = %d\n", rc);
 
@@ -5687,6 +5693,7 @@ CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
+	cifs_small_buf_release(pSMB);
 	if (rc) {
 		cifs_dbg(FYI, "Send error in SetFileInfo (SetFileSize) = %d\n",
 			 rc);
@@ -5758,6 +5765,7 @@ CIFSSMBSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
+	cifs_small_buf_release(pSMB);
 	if (rc)
 		cifs_dbg(FYI, "Send error in Set Time (SetFileInfo) = %d\n",
 			 rc);
@@ -5818,6 +5826,7 @@ CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	*data_offset = delete_file ? 1 : 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
+	cifs_small_buf_release(pSMB);
 	if (rc)
 		cifs_dbg(FYI, "Send error in SetFileDisposition = %d\n", rc);
 
@@ -6057,6 +6066,7 @@ CIFSSMBUnixSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	cifs_fill_unix_set_info((FILE_UNIX_BASIC_INFO *)data_offset, args);
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
+	cifs_small_buf_release(pSMB);
 	if (rc)
 		cifs_dbg(FYI, "Send error in Set Time (SetFileInfo) = %d\n",
 			 rc);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 538d9b5..a1118e3 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -652,6 +652,7 @@ sess_sendreceive(struct sess_data *sess_data)
 	int rc;
 	struct smb_hdr *smb_buf = (struct smb_hdr *) sess_data->iov[0].iov_base;
 	__u16 count;
+	struct kvec rsp_iov = { NULL, 0 };
 
 	count = sess_data->iov[1].iov_len + sess_data->iov[2].iov_len;
 	smb_buf->smb_buf_length =
@@ -661,7 +662,9 @@ sess_sendreceive(struct sess_data *sess_data)
 	rc = SendReceive2(sess_data->xid, sess_data->ses,
 			  sess_data->iov, 3 /* num_iovecs */,
 			  &sess_data->buf0_type,
-			  CIFS_LOG_ERROR);
+			  CIFS_LOG_ERROR, &rsp_iov);
+	cifs_small_buf_release(sess_data->iov[0].iov_base);
+	memcpy(&sess_data->iov[0], &rsp_iov, sizeof(struct kvec));
 
 	return rc;
 }
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0a668c7..fb6cf1b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -399,6 +399,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	struct smb2_negotiate_req *req;
 	struct smb2_negotiate_rsp *rsp;
 	struct kvec iov[1];
+	struct kvec rsp_iov;
 	int rc = 0;
 	int resp_buftype;
 	struct TCP_Server_Info *server = ses->server;
@@ -447,9 +448,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	/* 4 for rfc1002 length field */
 	iov[0].iov_len = get_rfc1002_length(req) + 4;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags);
-
-	rsp = (struct smb2_negotiate_rsp *)iov[0].iov_base;
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	cifs_small_buf_release(req);
+	rsp = (struct smb2_negotiate_rsp *)rsp_iov.iov_base;
 	/*
 	 * No tcon so can't do
 	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
@@ -673,6 +674,7 @@ SMB2_sess_sendreceive(struct SMB2_sess_data *sess_data)
 {
 	int rc;
 	struct smb2_sess_setup_req *req = sess_data->iov[0].iov_base;
+	struct kvec rsp_iov = { NULL, 0 };
 
 	/* Testing shows that buffer offset must be at location of Buffer[0] */
 	req->SecurityBufferOffset =
@@ -687,7 +689,9 @@ SMB2_sess_sendreceive(struct SMB2_sess_data *sess_data)
 	rc = SendReceive2(sess_data->xid, sess_data->ses,
 				sess_data->iov, 2,
 				&sess_data->buf0_type,
-				CIFS_LOG_ERROR | CIFS_NEG_OP);
+				CIFS_LOG_ERROR | CIFS_NEG_OP, &rsp_iov);
+	cifs_small_buf_release(sess_data->iov[0].iov_base);
+	memcpy(&sess_data->iov[0], &rsp_iov, sizeof(struct kvec));
 
 	return rc;
 }
@@ -1041,7 +1045,8 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	if (server->sign)
 		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 
-	rc = SendReceiveNoRsp(xid, ses, (char *) &req->hdr, 0);
+	rc = SendReceiveNoRsp(xid, ses, (char *) req, 0);
+	cifs_small_buf_release(req);
 	/*
 	 * No tcon so can't do
 	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
@@ -1073,6 +1078,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	struct smb2_tree_connect_req *req;
 	struct smb2_tree_connect_rsp *rsp = NULL;
 	struct kvec iov[2];
+	struct kvec rsp_iov;
 	int rc = 0;
 	int resp_buftype;
 	int unc_path_len;
@@ -1132,8 +1138,9 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 	inc_rfc1001_len(req, unc_path_len - 1 /* pad */);
 
-	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, 0);
-	rsp = (struct smb2_tree_connect_rsp *)iov[0].iov_base;
+	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(req);
+	rsp = (struct smb2_tree_connect_rsp *)rsp_iov.iov_base;
 
 	if (rc != 0) {
 		if (tcon) {
@@ -1214,7 +1221,8 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc)
 		return rc;
 
-	rc = SendReceiveNoRsp(xid, ses, (char *)&req->hdr, 0);
+	rc = SendReceiveNoRsp(xid, ses, (char *)req, 0);
+	cifs_small_buf_release(req);
 	if (rc)
 		cifs_stats_fail_inc(tcon, SMB2_TREE_DISCONNECT_HE);
 
@@ -1476,12 +1484,13 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	struct cifs_tcon *tcon = oparms->tcon;
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[4];
+	struct kvec rsp_iov;
 	int resp_buftype;
 	int uni_path_len;
 	__le16 *copy_path = NULL;
 	int copy_size;
 	int rc = 0;
-	unsigned int num_iovecs = 2;
+	unsigned int n_iov = 2;
 	__u32 file_attributes = 0;
 	char *dhc_buf = NULL, *lc_buf = NULL;
 
@@ -1546,25 +1555,25 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	    *oplock == SMB2_OPLOCK_LEVEL_NONE)
 		req->RequestedOplockLevel = *oplock;
 	else {
-		rc = add_lease_context(server, iov, &num_iovecs, oplock);
+		rc = add_lease_context(server, iov, &n_iov, oplock);
 		if (rc) {
 			cifs_small_buf_release(req);
 			kfree(copy_path);
 			return rc;
 		}
-		lc_buf = iov[num_iovecs-1].iov_base;
+		lc_buf = iov[n_iov-1].iov_base;
 	}
 
 	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
 		/* need to set Next field of lease context if we request it */
 		if (server->capabilities & SMB2_GLOBAL_CAP_LEASING) {
 			struct create_context *ccontext =
-			    (struct create_context *)iov[num_iovecs-1].iov_base;
+			    (struct create_context *)iov[n_iov-1].iov_base;
 			ccontext->Next =
 				cpu_to_le32(server->vals->create_lease_size);
 		}
 
-		rc = add_durable_context(iov, &num_iovecs, oparms,
+		rc = add_durable_context(iov, &n_iov, oparms,
 					tcon->use_persistent);
 		if (rc) {
 			cifs_small_buf_release(req);
@@ -1572,11 +1581,12 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			kfree(lc_buf);
 			return rc;
 		}
-		dhc_buf = iov[num_iovecs-1].iov_base;
+		dhc_buf = iov[n_iov-1].iov_base;
 	}
 
-	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
-	rsp = (struct smb2_create_rsp *)iov[0].iov_base;
+	rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(req);
+	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
 
 	if (rc != 0) {
 		cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
@@ -1624,8 +1634,9 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct kvec iov[2];
+	struct kvec rsp_iov;
 	int resp_buftype;
-	int num_iovecs;
+	int n_iov;
 	int rc = 0;
 
 	cifs_dbg(FYI, "SMB2 IOCTL\n");
@@ -1662,9 +1673,9 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer) - 4);
 		iov[1].iov_base = in_data;
 		iov[1].iov_len = indatalen;
-		num_iovecs = 2;
+		n_iov = 2;
 	} else
-		num_iovecs = 1;
+		n_iov = 1;
 
 	req->OutputOffset = 0;
 	req->OutputCount = 0; /* MBZ */
@@ -1701,8 +1712,9 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		iov[0].iov_len = get_rfc1002_length(req) + 4;
 
 
-	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
-	rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
+	rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(req);
+	rsp = (struct smb2_ioctl_rsp *)rsp_iov.iov_base;
 
 	if ((rc != 0) && (rc != -EINVAL)) {
 		cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
@@ -1786,6 +1798,7 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[1];
+	struct kvec rsp_iov;
 	int resp_buftype;
 	int rc = 0;
 
@@ -1807,8 +1820,9 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	/* 4 for rfc1002 length field */
 	iov[0].iov_len = get_rfc1002_length(req) + 4;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0);
-	rsp = (struct smb2_close_rsp *)iov[0].iov_base;
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(req);
+	rsp = (struct smb2_close_rsp *)rsp_iov.iov_base;
 
 	if (rc != 0) {
 		cifs_stats_fail_inc(tcon, SMB2_CLOSE_HE);
@@ -1887,6 +1901,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_query_info_req *req;
 	struct smb2_query_info_rsp *rsp = NULL;
 	struct kvec iov[2];
+	struct kvec rsp_iov;
 	int rc = 0;
 	int resp_buftype;
 	struct TCP_Server_Info *server;
@@ -1916,8 +1931,9 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	/* 4 for rfc1002 length field */
 	iov[0].iov_len = get_rfc1002_length(req) + 4;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0);
-	rsp = (struct smb2_query_info_rsp *)iov[0].iov_base;
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(req);
+	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
 
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
@@ -2070,6 +2086,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[1];
+	struct kvec rsp_iov;
 	int resp_buftype;
 	int rc = 0;
 
@@ -2091,12 +2108,13 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	/* 4 for rfc1002 length field */
 	iov[0].iov_len = get_rfc1002_length(req) + 4;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0);
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(req);
 
 	if (rc != 0)
 		cifs_stats_fail_inc(tcon, SMB2_FLUSH_HE);
 
-	free_rsp_buf(resp_buftype, iov[0].iov_base);
+	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	return rc;
 }
 
@@ -2295,6 +2313,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	struct smb2_read_rsp *rsp = NULL;
 	struct smb2_sync_hdr *shdr;
 	struct kvec iov[1];
+	struct kvec rsp_iov;
 
 	*nbytes = 0;
 	rc = smb2_new_read_req(iov, io_parms, 0, 0);
@@ -2302,13 +2321,14 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 		return rc;
 
 	rc = SendReceive2(xid, io_parms->tcon->ses, iov, 1,
-			  &resp_buftype, CIFS_LOG_ERROR);
+			  &resp_buftype, CIFS_LOG_ERROR, &rsp_iov);
+	cifs_small_buf_release(iov[0].iov_base);
 
-	rsp = (struct smb2_read_rsp *)iov[0].iov_base;
+	rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
 	shdr = get_sync_hdr(rsp);
 
 	if (shdr->Status == STATUS_END_OF_FILE) {
-		free_rsp_buf(resp_buftype, iov[0].iov_base);
+		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 		return 0;
 	}
 
@@ -2328,9 +2348,9 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	if (*buf) {
 		memcpy(*buf, (char *)shdr + rsp->DataOffset, *nbytes);
-		free_rsp_buf(resp_buftype, iov[0].iov_base);
+		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	} else if (resp_buftype != CIFS_NO_BUFFER) {
-		*buf = iov[0].iov_base;
+		*buf = rsp_iov.iov_base;
 		if (resp_buftype == CIFS_SMALL_BUFFER)
 			*buf_type = CIFS_SMALL_BUFFER;
 		else if (resp_buftype == CIFS_LARGE_BUFFER)
@@ -2492,6 +2512,8 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	struct smb2_write_req *req = NULL;
 	struct smb2_write_rsp *rsp = NULL;
 	int resp_buftype;
+	struct kvec rsp_iov;
+
 	*nbytes = 0;
 
 	if (n_vec < 1)
@@ -2526,8 +2548,9 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	inc_rfc1001_len(req, io_parms->length - 1 /* Buffer */);
 
 	rc = SendReceive2(xid, io_parms->tcon->ses, iov, n_vec + 1,
-			  &resp_buftype, 0);
-	rsp = (struct smb2_write_rsp *)iov[0].iov_base;
+			  &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(req);
+	rsp = (struct smb2_write_rsp *)rsp_iov.iov_base;
 
 	if (rc) {
 		cifs_stats_fail_inc(io_parms->tcon, SMB2_WRITE_HE);
@@ -2590,6 +2613,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_query_directory_req *req;
 	struct smb2_query_directory_rsp *rsp = NULL;
 	struct kvec iov[2];
+	struct kvec rsp_iov;
 	int rc = 0;
 	int len;
 	int resp_buftype = CIFS_NO_BUFFER;
@@ -2654,8 +2678,9 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 
 	inc_rfc1001_len(req, len - 1 /* Buffer */);
 
-	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, 0);
-	rsp = (struct smb2_query_directory_rsp *)iov[0].iov_base;
+	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(req);
+	rsp = (struct smb2_query_directory_rsp *)rsp_iov.iov_base;
 
 	if (rc) {
 		if (rc == -ENODATA &&
@@ -2715,6 +2740,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_set_info_req *req;
 	struct smb2_set_info_rsp *rsp = NULL;
 	struct kvec *iov;
+	struct kvec rsp_iov;
 	int rc = 0;
 	int resp_buftype;
 	unsigned int i;
@@ -2766,8 +2792,9 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 		iov[i].iov_len = size[i];
 	}
 
-	rc = SendReceive2(xid, ses, iov, num, &resp_buftype, 0);
-	rsp = (struct smb2_set_info_rsp *)iov[0].iov_base;
+	rc = SendReceive2(xid, ses, iov, num, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(req);
+	rsp = (struct smb2_set_info_rsp *)rsp_iov.iov_base;
 
 	if (rc != 0)
 		cifs_stats_fail_inc(tcon, SMB2_SET_INFO_HE);
@@ -2908,7 +2935,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, CIFS_OBREAK_OP);
-	/* SMB2 buffer freed by function above */
+	cifs_small_buf_release(req);
 
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_OPLOCK_BREAK_HE);
@@ -2968,6 +2995,7 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct smb2_query_info_rsp *rsp = NULL;
 	struct kvec iov;
+	struct kvec rsp_iov;
 	int rc = 0;
 	int resp_buftype;
 	struct cifs_ses *ses = tcon->ses;
@@ -2979,12 +3007,13 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, 0);
+	rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(iov.iov_base);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
 		goto qfsinf_exit;
 	}
-	rsp = (struct smb2_query_info_rsp *)iov.iov_base;
+	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
 
 	info = (struct smb2_fs_full_size_info *)(4 /* RFC1001 len */ +
 		le16_to_cpu(rsp->OutputBufferOffset) + (char *)&rsp->hdr);
@@ -2995,7 +3024,7 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 		copy_fs_info_to_kstatfs(info, fsdata);
 
 qfsinf_exit:
-	free_rsp_buf(resp_buftype, iov.iov_base);
+	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	return rc;
 }
 
@@ -3005,6 +3034,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct smb2_query_info_rsp *rsp = NULL;
 	struct kvec iov;
+	struct kvec rsp_iov;
 	int rc = 0;
 	int resp_buftype, max_len, min_len;
 	struct cifs_ses *ses = tcon->ses;
@@ -3029,12 +3059,13 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, 0);
+	rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, 0, &rsp_iov);
+	cifs_small_buf_release(iov.iov_base);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
 		goto qfsattr_exit;
 	}
-	rsp = (struct smb2_query_info_rsp *)iov.iov_base;
+	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
 
 	rsp_len = le32_to_cpu(rsp->OutputBufferLength);
 	offset = le16_to_cpu(rsp->OutputBufferOffset);
@@ -3058,7 +3089,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 qfsattr_exit:
-	free_rsp_buf(resp_buftype, iov.iov_base);
+	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	return rc;
 }
 
@@ -3070,6 +3101,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	struct smb2_lock_req *req = NULL;
 	struct kvec iov[2];
+	struct kvec rsp_iov;
 	int resp_buf_type;
 	unsigned int count;
 
@@ -3095,7 +3127,9 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[1].iov_len = count;
 
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
-	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP);
+	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP,
+			  &rsp_iov);
+	cifs_small_buf_release(req);
 	if (rc) {
 		cifs_dbg(FYI, "Send error in smb2_lockv = %d\n", rc);
 		cifs_stats_fail_inc(tcon, SMB2_LOCK_HE);
@@ -3142,7 +3176,7 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->LeaseState = lease_state;
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, CIFS_OBREAK_OP);
-	/* SMB2 buffer freed by function above */
+	cifs_small_buf_release(req);
 
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_OPLOCK_BREAK_HE);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 206a597..b9fad50 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -546,12 +546,13 @@ SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 {
 	int rc;
 	struct kvec iov[1];
+	struct kvec rsp_iov;
 	int resp_buf_type;
 
 	iov[0].iov_base = in_buf;
 	iov[0].iov_len = get_rfc1002_length(in_buf) + 4;
 	flags |= CIFS_NO_RESP;
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags);
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_dbg(NOISY, "SendRcvNoRsp flags %d rc %d\n", flags, rc);
 
 	return rc;
@@ -650,7 +651,7 @@ cifs_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
 int
 SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	     struct kvec *iov, int n_vec, int *resp_buf_type /* ret */,
-	     const int flags)
+	     const int flags, struct kvec *resp_iov)
 {
 	int rc = 0;
 	int timeout, optype;
@@ -666,15 +667,12 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	*resp_buf_type = CIFS_NO_BUFFER;  /* no response buf yet */
 
 	if ((ses == NULL) || (ses->server == NULL)) {
-		cifs_small_buf_release(buf);
 		cifs_dbg(VFS, "Null session\n");
 		return -EIO;
 	}
 
-	if (ses->server->tcpStatus == CifsExiting) {
-		cifs_small_buf_release(buf);
+	if (ses->server->tcpStatus == CifsExiting)
 		return -ENOENT;
-	}
 
 	/*
 	 * Ensure that we do not send more than 50 overlapping requests
@@ -683,10 +681,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	 */
 
 	rc = wait_for_free_request(ses->server, timeout, optype);
-	if (rc) {
-		cifs_small_buf_release(buf);
+	if (rc)
 		return rc;
-	}
 
 	/*
 	 * Make sure that we sign in the same order that we send on this socket
@@ -699,7 +695,6 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	midQ = ses->server->ops->setup_request(ses, &rqst);
 	if (IS_ERR(midQ)) {
 		mutex_unlock(&ses->server->srv_mutex);
-		cifs_small_buf_release(buf);
 		/* Update # of requests on wire to server */
 		add_credits(ses->server, 1, optype);
 		return PTR_ERR(midQ);
@@ -715,15 +710,11 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		ses->server->sequence_number -= 2;
 	mutex_unlock(&ses->server->srv_mutex);
 
-	if (rc < 0) {
-		cifs_small_buf_release(buf);
+	if (rc < 0)
 		goto out;
-	}
 
-	if (timeout == CIFS_ASYNC_OP) {
-		cifs_small_buf_release(buf);
+	if (timeout == CIFS_ASYNC_OP)
 		goto out;
-	}
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
@@ -732,15 +723,12 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			cifs_small_buf_release(buf);
 			add_credits(ses->server, 1, optype);
 			return rc;
 		}
 		spin_unlock(&GlobalMid_Lock);
 	}
 
-	cifs_small_buf_release(buf);
-
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
 		add_credits(ses->server, 1, optype);
@@ -754,8 +742,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	buf = (char *)midQ->resp_buf;
-	iov[0].iov_base = buf;
-	iov[0].iov_len = get_rfc1002_length(buf) + 4;
+	resp_iov->iov_base = buf;
+	resp_iov->iov_len = get_rfc1002_length(buf) + 4;
 	if (midQ->large_buf)
 		*resp_buf_type = CIFS_LARGE_BUFFER;
 	else
-- 
2.7.4
