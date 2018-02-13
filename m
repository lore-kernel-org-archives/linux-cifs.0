From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/14] cifs: add compound_send_recv()
Date: Tue, 13 Feb 2018 15:42:29 +1100
Message-ID: <20180213044234.18364-10-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |   4 ++
 fs/cifs/transport.c | 136 ++++++++++++++++++++++++++++++----------------------
 2 files changed, 82 insertions(+), 58 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4143c9dec463..c1d049aa6a75 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -87,6 +87,10 @@ extern int cifs_call_async(struct TCP_Server_Info *server,
 extern int cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			  struct smb_rqst *rqst, int *resp_buf_type,
 			  const int flags, struct kvec *resp_iov);
+extern int compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
+			      const int flags, const int num_rqst,
+			      struct smb_rqst *rqst, int *resp_buf_type,
+			      struct kvec *resp_iov);
 extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 6f3733380e41..d810d4af33ad 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -707,20 +707,22 @@ cifs_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
 }
 
 int
-cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
-	       struct smb_rqst *rqst, int *resp_buf_type, const int flags,
-	       struct kvec *resp_iov)
+compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
+		   const int flags, const int num_rqst, struct smb_rqst *rqst,
+		   int *resp_buf_type, struct kvec *resp_iov)
 {
-	int rc = 0;
+	int i, rc = 0;
 	int timeout, optype;
-	struct mid_q_entry *midQ;
+	struct mid_q_entry *midQ[MAX_COMPOUND];
 	unsigned int credits = 1;
 	char *buf;
 
+	/* FIXME fix sequence_number and credits */
 	timeout = flags & CIFS_TIMEOUT_MASK;
 	optype = flags & CIFS_OP_MASK;
 
-	*resp_buf_type = CIFS_NO_BUFFER;  /* no response buf yet */
+	for (i = 0; i < num_rqst; i++)
+		resp_buf_type[i] = CIFS_NO_BUFFER;  /* no response buf yet */
 
 	if ((ses == NULL) || (ses->server == NULL)) {
 		cifs_dbg(VFS, "Null session\n");
@@ -747,83 +749,101 @@ cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 	mutex_lock(&ses->server->srv_mutex);
 
-	midQ = ses->server->ops->setup_request(ses, rqst);
-	if (IS_ERR(midQ)) {
-		mutex_unlock(&ses->server->srv_mutex);
-		/* Update # of requests on wire to server */
-		add_credits(ses->server, 1, optype);
-		return PTR_ERR(midQ);
+	for (i = 0; i < num_rqst; i++) {
+		midQ[i] = ses->server->ops->setup_request(ses, &rqst[i]);
+		if (IS_ERR(midQ[i])) {
+			mutex_unlock(&ses->server->srv_mutex);
+			/* Update # of requests on wire to server */
+			add_credits(ses->server, 1, optype);
+			return PTR_ERR(midQ[i]);
+		}
+
+		midQ[i]->mid_state = MID_REQUEST_SUBMITTED;
 	}
 
-	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
-	rc = smb_send_rqst(ses->server, 1, rqst, flags);
+	rc = smb_send_rqst(ses->server, num_rqst, rqst, flags);
 	cifs_in_send_dec(ses->server);
-	cifs_save_when_sent(midQ);
 
-	if (rc < 0)
-		ses->server->sequence_number -= 2;
-	mutex_unlock(&ses->server->srv_mutex);
+	for (i = 0; i < num_rqst; i++) {
+		cifs_save_when_sent(midQ[i]);
 
-	if (rc < 0)
-		goto out;
+		if (rc < 0)
+			ses->server->sequence_number -= 2;
+		mutex_unlock(&ses->server->srv_mutex);
 
-	if (timeout == CIFS_ASYNC_OP)
-		goto out;
+		if (rc < 0)
+			goto out;
 
-	rc = wait_for_response(ses->server, midQ);
-	if (rc != 0) {
-		cifs_dbg(FYI, "Cancelling wait for mid %llu\n",	midQ->mid);
-		send_cancel(ses->server, rqst, midQ);
-		spin_lock(&GlobalMid_Lock);
-		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
-			midQ->mid_flags |= MID_WAIT_CANCELLED;
-			midQ->callback = DeleteMidQEntry;
+		if (timeout == CIFS_ASYNC_OP)
+			goto out;
+
+		rc = wait_for_response(ses->server, midQ[i]);
+		if (rc != 0) {
+			cifs_dbg(FYI, "Cancelling wait for mid %llu\n",
+				 midQ[i]->mid);
+			send_cancel(ses->server, &rqst[i], midQ[i]);
+			spin_lock(&GlobalMid_Lock);
+			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED) {
+				midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
+				midQ[i]->callback = DeleteMidQEntry;
+				spin_unlock(&GlobalMid_Lock);
+				add_credits(ses->server, 1, optype);
+				return rc;
+			}
 			spin_unlock(&GlobalMid_Lock);
+		}
+
+		rc = cifs_sync_mid_result(midQ[i], ses->server);
+		if (rc != 0) {
 			add_credits(ses->server, 1, optype);
 			return rc;
 		}
-		spin_unlock(&GlobalMid_Lock);
-	}
 
-	rc = cifs_sync_mid_result(midQ, ses->server);
-	if (rc != 0) {
-		add_credits(ses->server, 1, optype);
-		return rc;
-	}
-
-	if (!midQ->resp_buf || midQ->mid_state != MID_RESPONSE_RECEIVED) {
-		rc = -EIO;
-		cifs_dbg(FYI, "Bad MID state?\n");
-		goto out;
-	}
+		if (!midQ[i]->resp_buf ||
+		    midQ[i]->mid_state != MID_RESPONSE_RECEIVED) {
+			rc = -EIO;
+			cifs_dbg(FYI, "Bad MID state?\n");
+			goto out;
+		}
 
-	buf = (char *)midQ->resp_buf;
-	resp_iov->iov_base = buf;
-	resp_iov->iov_len = ses->server->total_size +
-		ses->server->vals->header_preamble_size;
+		buf = (char *)midQ[i]->resp_buf;
+		resp_iov[i].iov_base = buf;
+		resp_iov[i].iov_len = ses->server->total_size +
+			ses->server->vals->header_preamble_size;
 
-	if (midQ->large_buf)
-		*resp_buf_type = CIFS_LARGE_BUFFER;
-	else
-		*resp_buf_type = CIFS_SMALL_BUFFER;
+		if (midQ[i]->large_buf)
+			resp_buf_type[i] = CIFS_LARGE_BUFFER;
+		else
+			resp_buf_type[i] = CIFS_SMALL_BUFFER;
 
-	credits = ses->server->ops->get_credits(midQ);
+		credits = ses->server->ops->get_credits(midQ[i]);
 
-	rc = ses->server->ops->check_receive(midQ, ses->server,
-					     flags & CIFS_LOG_ERROR);
+		rc = ses->server->ops->check_receive(midQ[i], ses->server,
+						     flags & CIFS_LOG_ERROR);
 
-	/* mark it so buf will not be freed by cifs_delete_mid */
-	if ((flags & CIFS_NO_RESP) == 0)
-		midQ->resp_buf = NULL;
+		/* mark it so buf will not be freed by cifs_delete_mid */
+		if ((flags & CIFS_NO_RESP) == 0)
+			midQ[i]->resp_buf = NULL;
+	}
 out:
-	cifs_delete_mid(midQ);
+	for (i = 0; i < num_rqst; i++)
+		cifs_delete_mid(midQ[i]);
 	add_credits(ses->server, credits, optype);
 
 	return rc;
 }
 
 int
+cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
+	       struct smb_rqst *rqst, int *resp_buf_type, const int flags,
+	       struct kvec *resp_iov)
+{
+	return compound_send_recv(xid, ses, flags, 1, rqst, resp_buf_type,
+				  resp_iov);
+}
+
+int
 SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	     struct kvec *iov, int n_vec, int *resp_buf_type /* ret */,
 	     const int flags, struct kvec *resp_iov)
-- 
2.13.3
