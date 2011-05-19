From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/7] cifs: consolidate SendReceive response checks
Date: Thu, 19 May 2011 16:22:52 -0400
Message-ID: <1305836578-26333-2-git-send-email-jlayton@redhat.com>
References: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305836578-26333-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Further consolidate the SendReceive code by moving the checks run over
the packet into a separate function that all the SendReceive variants
can call.

We can also eliminate the check for a receive_len that's too big or too
small. cifs_demultiplex_thread already checks that and disconnects the
socket if that occurs, while setting the midStatus to MALFORMED. It'll
never call this code if that's the case.

Finally do a little cleanup. Use "goto out" on errors so that the flow
of code in the normal case is more evident. Also switch the logErr
variable in map_smb_to_linux_error to a bool.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 +-
 fs/cifs/netmisc.c   |    2 +-
 fs/cifs/transport.c |  157 +++++++++++++-------------------------------------
 3 files changed, 45 insertions(+), 118 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index a1c94d3..bf140c2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -76,6 +76,8 @@ extern int SendReceive(const unsigned int /* xid */ , struct cifsSesInfo *,
 			int * /* bytes returned */ , const int long_op);
 extern int SendReceiveNoRsp(const unsigned int xid, struct cifsSesInfo *ses,
 			struct smb_hdr *in_buf, int flags);
+extern int cifs_check_receive(struct mid_q_entry *mid,
+			struct TCP_Server_Info *server, bool log_error);
 extern int SendReceive2(const unsigned int /* xid */ , struct cifsSesInfo *,
 			struct kvec *, int /* nvec to send */,
 			int * /* type of buf returned */ , const int flags);
@@ -99,7 +101,7 @@ extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
 extern int cifs_set_port(struct sockaddr *addr, const unsigned short int port);
 extern int cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
 				const unsigned short int port);
-extern int map_smb_to_linux_error(struct smb_hdr *smb, int logErr);
+extern int map_smb_to_linux_error(struct smb_hdr *smb, bool logErr);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifsTconInfo *, int /* length of
 			    fixed section (word count) in two byte units */);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 79b71c2..73e47e8 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -836,7 +836,7 @@ ntstatus_to_dos(__u32 ntstatus, __u8 *eclass, __u16 *ecode)
 }
 
 int
-map_smb_to_linux_error(struct smb_hdr *smb, int logErr)
+map_smb_to_linux_error(struct smb_hdr *smb, bool logErr)
 {
 	unsigned int i;
 	int rc = -EIO;	/* if transport error smb error may not be set */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f2513fb..43633a7 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -502,13 +502,31 @@ send_nt_cancel(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
 }
 
 int
+cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+		   bool log_error)
+{
+	dump_smb(mid->resp_buf,
+		 min_t(u32, 92, be32_to_cpu(mid->resp_buf->smb_buf_length)));
+
+	/* convert the length into a more usable form */
+	if (server->secMode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+		/* FIXME: add code to kill session */
+		if (cifs_verify_signature(mid->resp_buf, server,
+					  mid->sequence_number + 1) != 0)
+			cERROR(1, "Unexpected SMB signature");
+	}
+
+	/* BB special case reconnect tid and uid here? */
+	return map_smb_to_linux_error(mid->resp_buf, log_error);
+}
+
+int
 SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	     struct kvec *iov, int n_vec, int *pRespBufType /* ret */,
 	     const int flags)
 {
 	int rc = 0;
 	int long_op;
-	unsigned int receive_len;
 	struct mid_q_entry *midQ;
 	struct smb_hdr *in_buf = iov[0].iov_base;
 
@@ -605,54 +623,24 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		return rc;
 	}
 
-	receive_len = be32_to_cpu(midQ->resp_buf->smb_buf_length);
-
-	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
-		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
-			receive_len, xid);
+	if (!midQ->resp_buf || midQ->midState != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
+		cFYI(1, "Bad MID state?");
 		goto out;
 	}
 
-	/* rcvd frame is ok */
-
-	if (midQ->resp_buf &&
-	    (midQ->midState == MID_RESPONSE_RECEIVED)) {
-
-		iov[0].iov_base = (char *)midQ->resp_buf;
-		if (midQ->largeBuf)
-			*pRespBufType = CIFS_LARGE_BUFFER;
-		else
-			*pRespBufType = CIFS_SMALL_BUFFER;
-		iov[0].iov_len = receive_len + 4;
-
-		dump_smb(midQ->resp_buf, 80);
-		/* convert the length into a more usable form */
-		if ((receive_len > 24) &&
-		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
-					     SECMODE_SIGN_ENABLED))) {
-			rc = cifs_verify_signature(midQ->resp_buf,
-						ses->server,
-						midQ->sequence_number+1);
-			if (rc) {
-				cERROR(1, "Unexpected SMB signature");
-				/* BB FIXME add code to kill session */
-			}
-		}
-
-		/* BB special case reconnect tid and uid here? */
-		rc = map_smb_to_linux_error(midQ->resp_buf,
-					    flags & CIFS_LOG_ERROR);
+	iov[0].iov_base = (char *)midQ->resp_buf;
+	iov[0].iov_len = be32_to_cpu(midQ->resp_buf->smb_buf_length) + 4;
+	if (midQ->largeBuf)
+		*pRespBufType = CIFS_LARGE_BUFFER;
+	else
+		*pRespBufType = CIFS_SMALL_BUFFER;
 
-		if ((flags & CIFS_NO_RESP) == 0)
-			midQ->resp_buf = NULL;  /* mark it so buf will
-						   not be freed by
-						   delete_mid */
-	} else {
-		rc = -EIO;
-		cFYI(1, "Bad MID state?");
-	}
+	rc = cifs_check_receive(midQ, ses->server, flags & CIFS_LOG_ERROR);
 
+	/* mark it so buf will not be freed by delete_mid */
+	if ((flags & CIFS_NO_RESP) == 0)
+		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
 	atomic_dec(&ses->server->inFlight);
@@ -667,7 +655,6 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 	    int *pbytes_returned, const int long_op)
 {
 	int rc = 0;
-	unsigned int receive_len;
 	struct mid_q_entry *midQ;
 
 	if (ses == NULL) {
@@ -757,47 +744,16 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		return rc;
 	}
 
-	receive_len = be32_to_cpu(midQ->resp_buf->smb_buf_length);
-
-	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
-		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
-			receive_len, xid);
-		rc = -EIO;
-		goto out;
-	}
-
-	/* rcvd frame is ok */
-
-	if (midQ->resp_buf && out_buf
-	    && (midQ->midState == MID_RESPONSE_RECEIVED)) {
-		out_buf->smb_buf_length = cpu_to_be32(receive_len);
-		memcpy((char *)out_buf + 4,
-		       (char *)midQ->resp_buf + 4,
-		       receive_len);
-
-		dump_smb(out_buf, 92);
-		/* convert the length into a more usable form */
-		if ((receive_len > 24) &&
-		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
-					     SECMODE_SIGN_ENABLED))) {
-			rc = cifs_verify_signature(out_buf,
-						ses->server,
-						midQ->sequence_number+1);
-			if (rc) {
-				cERROR(1, "Unexpected SMB signature");
-				/* BB FIXME add code to kill session */
-			}
-		}
-
-		*pbytes_returned = be32_to_cpu(out_buf->smb_buf_length);
-
-		/* BB special case reconnect tid and uid here? */
-		rc = map_smb_to_linux_error(out_buf, 0 /* no log */ );
-	} else {
+	if (!midQ->resp_buf || !out_buf ||
+	    midQ->midState != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
 		cERROR(1, "Bad MID state?");
+		goto out;
 	}
 
+	*pbytes_returned = be32_to_cpu(midQ->resp_buf->smb_buf_length);
+	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
+	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
 	atomic_dec(&ses->server->inFlight);
@@ -838,7 +794,6 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 {
 	int rc = 0;
 	int rstart = 0;
-	unsigned int receive_len;
 	struct mid_q_entry *midQ;
 	struct cifsSesInfo *ses;
 
@@ -961,46 +916,16 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 	if (rc != 0)
 		return rc;
 
-	receive_len = be32_to_cpu(midQ->resp_buf->smb_buf_length);
-	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
-		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
-			receive_len, xid);
-		rc = -EIO;
-		goto out;
-	}
-
 	/* rcvd frame is ok */
-
-	if ((out_buf == NULL) || (midQ->midState != MID_RESPONSE_RECEIVED)) {
+	if (out_buf == NULL || midQ->midState != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
 		cERROR(1, "Bad MID state?");
 		goto out;
 	}
 
-	out_buf->smb_buf_length = cpu_to_be32(receive_len);
-	memcpy((char *)out_buf + 4,
-	       (char *)midQ->resp_buf + 4,
-	       receive_len);
-
-	dump_smb(out_buf, 92);
-	/* convert the length into a more usable form */
-	if ((receive_len > 24) &&
-	    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
-				     SECMODE_SIGN_ENABLED))) {
-		rc = cifs_verify_signature(out_buf,
-					   ses->server,
-					   midQ->sequence_number+1);
-		if (rc) {
-			cERROR(1, "Unexpected SMB signature");
-			/* BB FIXME add code to kill session */
-		}
-	}
-
-	*pbytes_returned = be32_to_cpu(out_buf->smb_buf_length);
-
-	/* BB special case reconnect tid and uid here? */
-	rc = map_smb_to_linux_error(out_buf, 0 /* no log */ );
-
+	*pbytes_returned = be32_to_cpu(midQ->resp_buf->smb_buf_length);
+	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
+	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
 	if (rstart && rc == -EACCES)
-- 
1.7.4.4
