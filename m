From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 07/11] CIFS: Separate protocol-specific code from transport routines
Date: Fri, 16 Mar 2012 18:09:30 +0300
Message-ID: <1331910574-998-8-git-send-email-piastry@etersoft.ru>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331910574-998-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that lets us use this functions for SMB2.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_debug.h |    2 +-
 fs/cifs/cifsglob.h   |    6 ++
 fs/cifs/cifsproto.h  |    2 +-
 fs/cifs/cifssmb.c    |   21 +++---
 fs/cifs/misc.c       |    5 +-
 fs/cifs/transport.c  |  171 +++++++++++++++++++++++++++++---------------------
 6 files changed, 119 insertions(+), 88 deletions(-)

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 8942b28..0a234c1 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -32,7 +32,7 @@ void cifs_dump_mids(struct TCP_Server_Info *);
 #define DBG2 0
 #endif
 extern int traceSMB;		/* flag which enables the function below */
-void dump_smb(struct smb_hdr *, int);
+void dump_smb(void *, int);
 #define CIFS_INFO	0x01
 #define CIFS_RC		0x02
 #define CIFS_TIMER	0x04
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 339ebe3..c3c7d7c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -230,6 +230,12 @@ struct cifs_mnt_data {
 	int flags;
 };
 
+static inline unsigned int
+get_rfc1002_length(void *buf)
+{
+	return be32_to_cpu(*((__be32 *)buf));
+}
+
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 47a769e..2d506e3 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -77,7 +77,7 @@ extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* out */ ,
 			int * /* bytes returned */ , const int long_op);
 extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
-			struct smb_hdr *in_buf, int flags);
+			    char *in_buf, int flags);
 extern int cifs_check_receive(struct mid_q_entry *mid,
 			struct TCP_Server_Info *server, bool log_error);
 extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 08c84a1..d3b8089 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -696,7 +696,7 @@ CIFSSMBTDis(const int xid, struct cifs_tcon *tcon)
 	if (rc)
 		return rc;
 
-	rc = SendReceiveNoRsp(xid, tcon->ses, smb_buffer, 0);
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *)smb_buffer, 0);
 	if (rc)
 		cFYI(1, "Tree disconnect failed %d", rc);
 
@@ -793,7 +793,7 @@ CIFSSMBLogoff(const int xid, struct cifs_ses *ses)
 	pSMB->hdr.Uid = ses->Suid;
 
 	pSMB->AndXCommand = 0xFF;
-	rc = SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pSMB, 0);
+	rc = SendReceiveNoRsp(xid, ses, (char *) pSMB, 0);
 session_already_dead:
 	mutex_unlock(&ses->session_mutex);
 
@@ -2423,8 +2423,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 			(struct smb_hdr *) pSMB, &bytes_returned);
 		cifs_small_buf_release(pSMB);
 	} else {
-		rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *)pSMB,
-				      timeout);
+		rc = SendReceiveNoRsp(xid, tcon->ses, (char *)pSMB, timeout);
 		/* SMB buffer freed by function above */
 	}
 	cifs_stats_inc(&tcon->num_locks);
@@ -2591,7 +2590,7 @@ CIFSSMBClose(const int xid, struct cifs_tcon *tcon, int smb_file_id)
 	pSMB->FileID = (__u16) smb_file_id;
 	pSMB->LastWriteTime = 0xFFFFFFFF;
 	pSMB->ByteCount = 0;
-	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	cifs_stats_inc(&tcon->num_closes);
 	if (rc) {
 		if (rc != -EINTR) {
@@ -2620,7 +2619,7 @@ CIFSSMBFlush(const int xid, struct cifs_tcon *tcon, int smb_file_id)
 
 	pSMB->FileID = (__u16) smb_file_id;
 	pSMB->ByteCount = 0;
-	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	cifs_stats_inc(&tcon->num_flushes);
 	if (rc)
 		cERROR(1, "Send error in Flush = %d", rc);
@@ -4628,7 +4627,7 @@ CIFSFindClose(const int xid, struct cifs_tcon *tcon,
 
 	pSMB->FileID = searchHandle;
 	pSMB->ByteCount = 0;
-	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
 		cERROR(1, "Send error in FindClose = %d", rc);
 
@@ -5649,7 +5648,7 @@ CIFSSMBSetFileSize(const int xid, struct cifs_tcon *tcon, __u64 size,
 	pSMB->Reserved4 = 0;
 	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
-	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc) {
 		cFYI(1, "Send error in SetFileInfo (SetFileSize) = %d", rc);
 	}
@@ -5718,7 +5717,7 @@ CIFSSMBSetFileInfo(const int xid, struct cifs_tcon *tcon,
 	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
-	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
 		cFYI(1, "Send error in Set Time (SetFileInfo) = %d", rc);
 
@@ -5777,7 +5776,7 @@ CIFSSMBSetFileDisposition(const int xid, struct cifs_tcon *tcon,
 	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	*data_offset = delete_file ? 1 : 0;
-	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
 		cFYI(1, "Send error in SetFileDisposition = %d", rc);
 
@@ -6009,7 +6008,7 @@ CIFSSMBUnixSetFileInfo(const int xid, struct cifs_tcon *tcon,
 
 	cifs_fill_unix_set_info(data_offset, args);
 
-	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
 		cFYI(1, "Send error in Set Time (SetFileInfo) = %d", rc);
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 5dc936b..1578617 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -604,16 +604,15 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 }
 
 void
-dump_smb(struct smb_hdr *smb_buf, int smb_buf_length)
+dump_smb(void *buf, int smb_buf_length)
 {
 	int i, j;
 	char debug_line[17];
-	unsigned char *buffer;
+	unsigned char *buffer = buf;
 
 	if (traceSMB == 0)
 		return;
 
-	buffer = (unsigned char *) smb_buf;
 	for (i = 0, j = 0; i < smb_buf_length; i++, j++) {
 		if (i % 8 == 0) {
 			/* have reached the beginning of line */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 20dc7ba..7f63c44 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -126,11 +126,11 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	int rc = 0;
 	int i = 0;
 	struct msghdr smb_msg;
-	struct smb_hdr *smb_buffer = iov[0].iov_base;
+	__be32 *buf_len = (__be32 *)(iov[0].iov_base);
 	unsigned int len = iov[0].iov_len;
 	unsigned int total_len;
 	int first_vec = 0;
-	unsigned int smb_buf_length = be32_to_cpu(smb_buffer->smb_buf_length);
+	unsigned int smb_buf_length = get_rfc1002_length(iov[0].iov_base);
 	struct socket *ssocket = server->ssocket;
 
 	if (ssocket == NULL)
@@ -150,7 +150,7 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 		total_len += iov[i].iov_len;
 
 	cFYI(1, "Sending smb:  total_len %d", total_len);
-	dump_smb(smb_buffer, len);
+	dump_smb(iov[0].iov_base, len);
 
 	i = 0;
 	while (total_len) {
@@ -158,24 +158,24 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 				    n_vec - first_vec, total_len);
 		if ((rc == -ENOSPC) || (rc == -EAGAIN)) {
 			i++;
-			/* if blocking send we try 3 times, since each can block
-			   for 5 seconds. For nonblocking  we have to try more
-			   but wait increasing amounts of time allowing time for
-			   socket to clear.  The overall time we wait in either
-			   case to send on the socket is about 15 seconds.
-			   Similarly we wait for 15 seconds for
-			   a response from the server in SendReceive[2]
-			   for the server to send a response back for
-			   most types of requests (except SMB Write
-			   past end of file which can be slow, and
-			   blocking lock operations). NFS waits slightly longer
-			   than CIFS, but this can make it take longer for
-			   nonresponsive servers to be detected and 15 seconds
-			   is more than enough time for modern networks to
-			   send a packet.  In most cases if we fail to send
-			   after the retries we will kill the socket and
-			   reconnect which may clear the network problem.
-			*/
+			/*
+			 * If blocking send we try 3 times, since each can block
+			 * for 5 seconds. For nonblocking  we have to try more
+			 * but wait increasing amounts of time allowing time for
+			 * socket to clear.  The overall time we wait in either
+			 * case to send on the socket is about 15 seconds.
+			 * Similarly we wait for 15 seconds for a response from
+			 * the server in SendReceive[2] for the server to send
+			 * a response back for most types of requests (except
+			 * SMB Write past end of file which can be slow, and
+			 * blocking lock operations). NFS waits slightly longer
+			 * than CIFS, but this can make it take longer for
+			 * nonresponsive servers to be detected and 15 seconds
+			 * is more than enough time for modern networks to
+			 * send a packet.  In most cases if we fail to send
+			 * after the retries we will kill the socket and
+			 * reconnect which may clear the network problem.
+			 */
 			if ((i >= 14) || (!server->noblocksnd && (i > 2))) {
 				cERROR(1, "sends on sock %p stuck for 15 seconds",
 				    ssocket);
@@ -235,9 +235,8 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	else
 		rc = 0;
 
-	/* Don't want to modify the buffer as a
-	   side effect of this call. */
-	smb_buffer->smb_buf_length = cpu_to_be32(smb_buf_length);
+	/* Don't want to modify the buffer as a side effect of this call. */
+	*buf_len = cpu_to_be32(smb_buf_length);
 
 	return rc;
 }
@@ -349,6 +348,33 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 	return 0;
 }
 
+static int
+cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
+			 unsigned int nvec, struct mid_q_entry **ret_mid)
+{
+	int rc;
+	struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
+	struct mid_q_entry *mid;
+
+	/* enable signing if server requires it */
+	if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+		hdr->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
+
+	mid = AllocMidQEntry(hdr, server);
+	if (mid == NULL)
+		return -ENOMEM;
+
+	/* put it on the pending_mid_q */
+	spin_lock(&GlobalMid_Lock);
+	list_add_tail(&mid->qhead, &server->pending_mid_q);
+	spin_unlock(&GlobalMid_Lock);
+
+	rc = cifs_sign_smb2(iov, nvec, server, &mid->sequence_number);
+	if (rc)
+		delete_mid(mid);
+	*ret_mid = mid;
+	return rc;
+}
 
 /*
  * Send a SMB request and set the callback function in the mid to handle
@@ -361,34 +387,18 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 {
 	int rc;
 	struct mid_q_entry *mid;
-	struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
 
 	rc = wait_for_free_request(server, ignore_pend ? CIFS_ASYNC_OP : 0);
 	if (rc)
 		return rc;
 
-	/* enable signing if server requires it */
-	if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
-		hdr->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
-
 	mutex_lock(&server->srv_mutex);
-	mid = AllocMidQEntry(hdr, server);
-	if (mid == NULL) {
+	rc = cifs_setup_async_request(server, iov, nvec, &mid);
+	if (rc) {
 		mutex_unlock(&server->srv_mutex);
 		cifs_add_credits(server, 1);
 		wake_up(&server->request_q);
-		return -ENOMEM;
-	}
-
-	/* put it on the pending_mid_q */
-	spin_lock(&GlobalMid_Lock);
-	list_add_tail(&mid->qhead, &server->pending_mid_q);
-	spin_unlock(&GlobalMid_Lock);
-
-	rc = cifs_sign_smb2(iov, nvec, server, &mid->sequence_number);
-	if (rc) {
-		mutex_unlock(&server->srv_mutex);
-		goto out_err;
+		return rc;
 	}
 
 	mid->receive = receive;
@@ -424,14 +434,14 @@ out_err:
  */
 int
 SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
-		struct smb_hdr *in_buf, int flags)
+		 char *in_buf, int flags)
 {
 	int rc;
 	struct kvec iov[1];
 	int resp_buf_type;
 
-	iov[0].iov_base = (char *)in_buf;
-	iov[0].iov_len = be32_to_cpu(in_buf->smb_buf_length) + 4;
+	iov[0].iov_base = in_buf;
+	iov[0].iov_len = get_rfc1002_length(in_buf) + 4;
 	flags |= CIFS_NO_RESP;
 	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags);
 	cFYI(DBG2, "SendRcvNoRsp flags %d rc %d", flags, rc);
@@ -514,7 +524,7 @@ int
 cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = be32_to_cpu(mid->resp_buf->smb_buf_length) + 4;
+	unsigned int len = get_rfc1002_length(mid->resp_buf) + 4;
 
 	dump_smb(mid->resp_buf, min_t(u32, 92, len));
 
@@ -534,6 +544,24 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	return map_smb_to_linux_error(mid->resp_buf, log_error);
 }
 
+static int
+cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
+		   unsigned int nvec, struct mid_q_entry **ret_mid)
+{
+	int rc;
+	struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
+	struct mid_q_entry *mid;
+
+	rc = allocate_mid(ses, hdr, &mid);
+	if (rc)
+		return rc;
+	rc = cifs_sign_smb2(iov, nvec, ses->server, &mid->sequence_number);
+	if (rc)
+		delete_mid(mid);
+	*ret_mid = mid;
+	return rc;
+}
+
 int
 SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	     struct kvec *iov, int n_vec, int *pRespBufType /* ret */,
@@ -542,54 +570,52 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	int rc = 0;
 	int long_op;
 	struct mid_q_entry *midQ;
-	struct smb_hdr *in_buf = iov[0].iov_base;
+	char *buf = iov[0].iov_base;
 
 	long_op = flags & CIFS_TIMEOUT_MASK;
 
 	*pRespBufType = CIFS_NO_BUFFER;  /* no response buf yet */
 
 	if ((ses == NULL) || (ses->server == NULL)) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		cERROR(1, "Null session");
 		return -EIO;
 	}
 
 	if (ses->server->tcpStatus == CifsExiting) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		return -ENOENT;
 	}
 
-	/* Ensure that we do not send more than 50 overlapping requests
-	   to the same server. We may make this configurable later or
-	   use ses->maxReq */
+	/*
+	 * Ensure that we do not send more than 50 overlapping requests
+	 * to the same server. We may make this configurable later or
+	 * use ses->maxReq.
+	 */
 
 	rc = wait_for_free_request(ses->server, long_op);
 	if (rc) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		return rc;
 	}
 
-	/* make sure that we sign in the same order that we send on this socket
-	   and avoid races inside tcp sendmsg code that could cause corruption
-	   of smb data */
+	/*
+	 * Make sure that we sign in the same order that we send on this socket
+	 * and avoid races inside tcp sendmsg code that could cause corruption
+	 * of smb data.
+	 */
 
 	mutex_lock(&ses->server->srv_mutex);
 
-	rc = allocate_mid(ses, in_buf, &midQ);
+	rc = cifs_setup_request(ses, iov, n_vec, &midQ);
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		/* Update # of requests on wire to server */
 		cifs_add_credits(ses->server, 1);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
-	rc = cifs_sign_smb2(iov, n_vec, ses->server, &midQ->sequence_number);
-	if (rc) {
-		mutex_unlock(&ses->server->srv_mutex);
-		cifs_small_buf_release(in_buf);
-		goto out;
-	}
 
 	midQ->midState = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
@@ -600,23 +626,23 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	mutex_unlock(&ses->server->srv_mutex);
 
 	if (rc < 0) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		goto out;
 	}
 
 	if (long_op == CIFS_ASYNC_OP) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		goto out;
 	}
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
-		send_nt_cancel(ses->server, in_buf, midQ);
+		send_nt_cancel(ses->server, (struct smb_hdr *)buf, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->midState == MID_REQUEST_SUBMITTED) {
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			cifs_small_buf_release(in_buf);
+			cifs_small_buf_release(buf);
 			cifs_add_credits(ses->server, 1);
 			wake_up(&ses->server->request_q);
 			return rc;
@@ -624,7 +650,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		spin_unlock(&GlobalMid_Lock);
 	}
 
-	cifs_small_buf_release(in_buf);
+	cifs_small_buf_release(buf);
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
@@ -639,8 +665,9 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	iov[0].iov_base = (char *)midQ->resp_buf;
-	iov[0].iov_len = be32_to_cpu(midQ->resp_buf->smb_buf_length) + 4;
+	buf = (char *)midQ->resp_buf;
+	iov[0].iov_base = buf;
+	iov[0].iov_len = get_rfc1002_length(buf) + 4;
 	if (midQ->largeBuf)
 		*pRespBufType = CIFS_LARGE_BUFFER;
 	else
-- 
1.7.1
