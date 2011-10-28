From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 13/53] CIFS: Add SMB2 transport routines
Date: Fri, 28 Oct 2011 23:54:24 +0400
Message-ID: <1319831704-3572-14-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

And simplify smb_sendv to make it process SMB2 requests. It let us
send SMB2 negotiate message to the server.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h      |    6 ++
 fs/cifs/cifsproto.h     |    4 +-
 fs/cifs/smb2misc.c      |   11 +--
 fs/cifs/smb2proto.h     |    4 +-
 fs/cifs/smb2transport.c |  209 ++++++++++++++++++++++++++++++++++++++++-------
 fs/cifs/transport.c     |   75 ++++++++++-------
 6 files changed, 240 insertions(+), 69 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2703b7e..4ccd893 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -239,6 +239,12 @@ struct cifs_mnt_data {
 	int flags;
 };
 
+static inline unsigned int
+get_rfc1002_length(void *buf)
+{
+       return be32_to_cpu(*((__be32 *)buf));
+}
+
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2b3fa3b..5109925 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -36,7 +36,9 @@ extern void cifs_buf_release(void *);
 extern struct smb_hdr *cifs_small_buf_get(void);
 extern void cifs_small_buf_release(void *);
 extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
-			unsigned int /* length */);
+		    unsigned int /* length */);
+extern int smb_sendv(struct TCP_Server_Info *server, struct kvec *iov,
+		     int n_vec);
 extern unsigned int _GetXid(void);
 extern void _FreeXid(unsigned int);
 #define GetXid()						\
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 1a600d8..6f7afdc 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -27,19 +27,18 @@
 #include "cifs_unicode.h"
 #include "smb2status.h"
 
-/*
-__u64 get_mid(struct tcp_srv_inf *server)
+__u64 get_mid(struct TCP_Server_Info *server)
 {
 	__u64 mid;
 
 	if (server == NULL)
 		return 0;
 
-	spin_lock(&SMB2_mid_lock);
-	mid = server->current_mid++;
-	spin_unlock(&SMB2_mid_lock);
+	spin_lock(&GlobalMid_Lock);
+	mid = server->current_smb2_mid++;
+	spin_unlock(&GlobalMid_Lock);
 	return mid;
-} */ /* BB do we eventually need an SMB2 version of this routine? BB */
+} /* BB do we eventually need an SMB2 version of this routine? BB */
 
 static int
 check_smb2_hdr(struct smb2_hdr *smb, __u64 mid)
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index c4c40bd..e826279 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -38,8 +38,8 @@ extern void free_rsp_buf(int resp_buftype, void *pSMB2r);
 extern struct smb2_hdr *smb2_buf_get(void);
 extern void smb2_buf_release(void *);
 extern struct smb2_hdr *smb2_small_buf_get(void);
-extern void smb2_small_buf_release(void *);
-extern __u64 get_mid(struct TCP_Server_Info *server);*/
+extern void smb2_small_buf_release(void *);*/
+extern __u64 get_mid(struct TCP_Server_Info *server);
 extern int small_smb2_init_no_tc(__le16 smb2_cmd,
 				struct cifs_ses *ses,
 				void **request_buf);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 2ca9943..adf24c4 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -38,22 +38,15 @@
 extern mempool_t *smb2_mid_poolp;
 
 /*
- *  Send an (optionally, already signed) SMB2 request over a socket.
- *  This socket is already locked (by a mutex) by the caller so we
- *  won't have framing problems or mess up SMB2 signatures.
+ * Set message id for the request. Should be called after wait_for_free_response
+ * and locking srv_mutex. iov array must have at least 1 element.
  */
-
-int smb2_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
+static inline void smb2_seq_num_into_buf(struct TCP_Server_Info *server,
+					 struct kvec *iov)
 {
-	int rc = -EHOSTDOWN;
-
-	cFYI(1, "function not merged yet");  /* BB fixme */
-
-	return rc;
+	((struct smb2_hdr *)iov[0].iov_base)->MessageId = get_mid(server);
 }
 
-
-
 /*
  *
  * Send an SMB Request.  No response info (other than return code)
@@ -108,23 +101,6 @@ smb2_sendrcv_blocking(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-/*
- * sendrcv2 is passed a cifs_ses structure (rather than simply being
- * passed the ses->server->socket), because it needs the creds
- * contained in the cifs_ses struct in order to sign requests.
- */
-int
-smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
-	     struct kvec *iov, int n_vec, int *presp_buftype /* ret */,
-	     int *status /* ret SMB2 network status code */, const int flags)
-{
-	int rc = -EHOSTDOWN;
-
-	cFYI(1, "function not merged yet");  /* BB fixme */
-
-	return rc;
-}
-
 static void
 wake_up_smb2_task(struct smb2_mid_entry *mid)
 {
@@ -251,7 +227,7 @@ wait_for_smb2_response(struct TCP_Server_Info *server,
 {
 	int error;
 
-	error = wait_event_killable(server->response_q,
+	error = wait_event_freezekillable(server->response_q,
 				    midq->mid_state != MID_REQUEST_SUBMITTED);
 	if (error < 0)
 		return -ERESTARTSYS;
@@ -311,4 +287,177 @@ free_smb2_mid(struct smb2_mid_entry *mid)
 
 	smb2_mid_entry_free(mid);
 }
+
+static int
+smb2_check_receive(struct smb2_mid_entry *mid, struct TCP_Server_Info *server,
+		   unsigned int receive_len, bool log_error)
+{
+	unsigned int len = get_rfc1002_length(mid->resp_buf);
+
+	dump_smb2(mid->resp_buf, min_t(u32, 80, len));
+	/* convert the length into a more usable form */
+	if ((receive_len > 24) &&
+	    (server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)) {
+		/* BB fixme */
+		/*rc = smb2_verify_signature(mid->resp_buf,
+					&ses->server->mac_signing_key);
+		if (rc) {
+			cERROR(1, "Unexpected SMB signature");
+		} */
+	}
+
+	return map_smb2_to_linux_error(mid->resp_buf, log_error);
+}
+
+/*
+ * sendrcv2 is passed a cifs_ses structure (rather than simply being
+ * passed the ses->server->socket), because it needs the creds
+ * contained in the cifs_ses struct in order to sign requests
+ */
+int
+smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
+	     struct kvec *iov, int n_vec, int *presp_buftype /* ret */,
+	     int *status /* ret SMB2 network status code */, const int flags)
+{
+	int rc = 0;
+	int long_op;
+	unsigned int receive_len;
+	struct smb2_mid_entry *midQ;
+	struct smb2_hdr *buf = iov[0].iov_base;
+	unsigned int credits = 1;
+
+	if (status)
+		*status = STATUS_SUCCESS;
+	long_op = flags & CIFS_TIMEOUT_MASK;
+
+	*presp_buftype = CIFS_NO_BUFFER;  /* no response buf yet */
+
+	if ((ses == NULL) || (ses->server == NULL)) {
+		cifs_small_buf_release(buf);
+		cERROR(1, "Null session");
+		return -EIO;
+	}
+
+	if (ses->server->tcpStatus == CifsExiting) {
+		cifs_small_buf_release(buf);
+		cFYI(1, "ololo");
+		return -ENOENT;
+	}
+
+	rc = wait_for_free_request(ses->server, long_op);
+	if (rc) {
+		cifs_small_buf_release(buf);
+		return rc;
+	}
+
+	/*
+	 * Make sure that we sign in the same order that we send on this socket
+	 * and avoid races inside tcp sendmsg code that could cause corruption
+	 * of smb data.
+	 */
+
+	mutex_lock(&ses->server->srv_mutex);
+
+	smb2_seq_num_into_buf(ses->server, iov);
+
+	rc = get_smb2_mid(ses, buf, &midQ);
+	if (rc) {
+		mutex_unlock(&ses->server->srv_mutex);
+		cifs_small_buf_release(buf);
+		atomic_inc(&ses->server->credits);
+		wake_up(&ses->server->request_q);
+		return rc;
+	}
+	/* rc = sign_smb2(iov, n_vec, ses->server); BB
+	if (rc) {
+		mutex_unlock(&ses->server->srv_mutex);
+		cifs_small_buf_release(in_buf);
+		goto out;
+	} */
+
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
+	cifs_in_send_inc(ses->server);
+	rc = smb_sendv(ses->server, iov, n_vec);
+	cifs_in_send_dec(ses->server);
+	cifs_save_when_sent(midQ);
+
+	mutex_unlock(&ses->server->srv_mutex);
+
+	if (rc < 0) {
+		cifs_small_buf_release(buf);
+		goto out;
+	}
+
+	if (long_op == CIFS_ASYNC_OP) {
+		cifs_small_buf_release(buf);
+		goto out;
+	}
+
+	rc = wait_for_smb2_response(ses->server, midQ);
+	if (rc != 0) {
+		/* send_nt_cancel(ses->server, in_buf, midQ); BB */
+		spin_lock(&GlobalMid_Lock);
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
+			midQ->callback = free_smb2_mid;
+			spin_unlock(&GlobalMid_Lock);
+			cifs_small_buf_release(buf);
+			atomic_inc(&ses->server->credits);
+			wake_up(&ses->server->request_q);
+			return rc;
+		}
+		spin_unlock(&GlobalMid_Lock);
+	}
+
+	cifs_small_buf_release(buf);
+
+	rc = sync_smb2_mid_result(midQ, ses->server);
+	if (rc) {
+		atomic_inc(&ses->server->credits);
+		wake_up(&ses->server->request_q);
+		return rc;
+	}
+
+	if (!midQ->resp_buf || (midQ->mid_state != MID_RESPONSE_RECEIVED)) {
+		rc = -EIO;
+		cFYI(1, "Bad MID state?");
+		goto out;
+	}
+
+	buf = (struct smb2_hdr *)midQ->resp_buf;
+	receive_len = be32_to_cpu(buf->smb2_buf_length);
+
+	if (receive_len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) {
+		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
+			receive_len, xid);
+		rc = -EIO;
+		goto out;
+	}
+
+	/* rcvd frame is ok */
+
+	iov[0].iov_base = (char *)buf;
+	iov[0].iov_len = receive_len + 4;
+
+	if (midQ->large_buf)
+		*presp_buftype = CIFS_LARGE_BUFFER;
+	else
+		*presp_buftype = CIFS_SMALL_BUFFER;
+
+	rc = smb2_check_receive(midQ, ses->server, receive_len,
+				flags & CIFS_LOG_ERROR);
+
+	if (status)
+		*status = le32_to_cpu(buf->Status);
+
+	if ((flags & CIFS_NO_RESP) == 0)
+		/* mark it so buf will not be freed by free_smb2mid */
+		midQ->resp_buf = NULL;
+
+	credits = le16_to_cpu(buf->CreditRequest);
+out:
+	atomic_add(credits, &ses->server->credits);
+	free_smb2_mid(midQ);
+	wake_up(&ses->server->request_q);
+	return rc;
+}
 /* BB add missing functions here */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 25d04df..ee8a1f8 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -120,18 +120,24 @@ delete_mid(struct mid_q_entry *mid)
 	DeleteMidQEntry(mid);
 }
 
-static int
+int
 smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 {
 	int rc = 0;
 	int i = 0;
 	struct msghdr smb_msg;
+	__be32 *buf_length = (__be32 *)iov[0].iov_base;
 	struct smb_hdr *smb_buffer = iov[0].iov_base;
+#ifdef CONFIG_CIFS_SMB2
+	struct smb2_hdr *smb2_buffer = iov[0].iov_base;
+#endif
 	unsigned int len = iov[0].iov_len;
 	unsigned int total_len;
 	int first_vec = 0;
-	unsigned int smb_buf_length = be32_to_cpu(smb_buffer->smb_buf_length);
 	struct socket *ssocket = server->ssocket;
+	unsigned int smb_buf_length;
+
+	smb_buf_length = get_rfc1002_length(iov[0].iov_base);
 
 	if (ssocket == NULL)
 		return -ENOTSOCK; /* BB eventually add reconnect code here */
@@ -150,7 +156,12 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 		total_len += iov[i].iov_len;
 
 	cFYI(1, "Sending smb:  total_len %d", total_len);
-	dump_smb(smb_buffer, len);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		dump_smb2(smb2_buffer, len);
+	else
+#endif
+		dump_smb(smb_buffer, len);
 
 	i = 0;
 	while (total_len) {
@@ -158,24 +169,25 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
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
+			 * Similarly we wait for 15 seconds for
+			 * a response from the server in SendReceive[2]
+			 * for the server to send a response back for
+			 * most types of requests (except SMB Write
+			 * past end of file which can be slow, and
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
@@ -196,8 +208,10 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 			break;
 		}
 		if (rc == 0) {
-			/* should never happen, letting socket clear before
-			   retrying is our only obvious option here */
+			/*
+			 * Should never happen, letting socket clear before
+			 * retrying is our only obvious option here.
+			 */
 			cERROR(1, "tcp sent no data");
 			msleep(500);
 			continue;
@@ -223,10 +237,12 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	if ((total_len > 0) && (total_len != smb_buf_length + 4)) {
 		cFYI(1, "partial send (%d remaining), terminating session",
 			total_len);
-		/* If we have only sent part of an SMB then the next SMB
-		   could be taken as the remainder of this one.  We need
-		   to kill the socket so the server throws away the partial
-		   SMB */
+		/*
+		 * If we have only sent part of an SMB then the next SMB
+		 * could be taken as the remainder of this one.  We need
+		 * to kill the socket so the server throws away the partial
+		 * SMB.
+		 */
 		server->tcpStatus = CifsNeedReconnect;
 	}
 
@@ -235,9 +251,8 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	else
 		rc = 0;
 
-	/* Don't want to modify the buffer as a
-	   side effect of this call. */
-	smb_buffer->smb_buf_length = cpu_to_be32(smb_buf_length);
+	/* Don't want to modify the buffer as a side effect of this call. */
+	*buf_length = cpu_to_be32(smb_buf_length);
 
 	return rc;
 }
-- 
1.7.1
