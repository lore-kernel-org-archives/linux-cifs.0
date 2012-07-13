From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 02/32] CIFS: Extend credit mechanism to process request type
Date: Fri, 13 Jul 2012 11:53:15 +0400
Message-ID: <1342166025-29377-3-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Split all requests to echos, oplocks and others - each group uses
its own credit slot. This is indicated by new flags

CIFS_ECHO_OP and CIFS_OBREAK_OP

that are not used now for CIFS. This change is required to support
SMB2 protocol because of different processing of these commands.

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   16 ++++++++---
 fs/cifs/cifsproto.h |    4 +-
 fs/cifs/cifssmb.c   |   21 ++++++++-------
 fs/cifs/smb1ops.c   |   12 +++++++-
 fs/cifs/transport.c |   70 ++++++++++++++++++++++++++++----------------------
 5 files changed, 74 insertions(+), 49 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2aac4e5..844b77c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -171,9 +171,11 @@ struct smb_version_operations {
 	/* check response: verify signature, map error */
 	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     bool);
-	void (*add_credits)(struct TCP_Server_Info *, const unsigned int);
+	void (*add_credits)(struct TCP_Server_Info *, const unsigned int,
+			    const int);
 	void (*set_credits)(struct TCP_Server_Info *, const int);
-	int * (*get_credits_field)(struct TCP_Server_Info *);
+	int * (*get_credits_field)(struct TCP_Server_Info *, const int);
+	unsigned int (*get_credits)(struct mid_q_entry *);
 	__u64 (*get_next_mid)(struct TCP_Server_Info *);
 	/* data offset from read response message */
 	unsigned int (*read_data_offset)(char *);
@@ -392,9 +394,10 @@ has_credits(struct TCP_Server_Info *server, int *credits)
 }
 
 static inline void
-add_credits(struct TCP_Server_Info *server, const unsigned int add)
+add_credits(struct TCP_Server_Info *server, const unsigned int add,
+	    const int optype)
 {
-	server->ops->add_credits(server, add);
+	server->ops->add_credits(server, add, optype);
 }
 
 static inline void
@@ -957,6 +960,11 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   CIFS_LARGE_BUF_OP 0x020    /* large request buffer */
 #define   CIFS_NO_RESP      0x040    /* no response buffer required */
 
+/* Type of request operation */
+#define   CIFS_ECHO_OP      0x080    /* echo request */
+#define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
+#define   CIFS_OP_MASK     0x0180    /* mask request type */
+
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
 #define   CIFSSEC_MAY_NTLM	0x00002
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0a6cbfe..f52074d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -71,11 +71,11 @@ extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
 			   mid_callback_t *callback, void *cbdata,
-			   bool ignore_pend);
+			   const int flags);
 extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
-			int * /* bytes returned */ , const int long_op);
+			int * /* bytes returned */ , const int);
 extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 			    char *in_buf, int flags);
 extern int cifs_setup_request(struct cifs_ses *, struct kvec *, unsigned int,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4ee522b..6cfbeec 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -744,7 +744,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = mid->callback_data;
 
 	DeleteMidQEntry(mid);
-	add_credits(server, 1);
+	add_credits(server, 1, CIFS_ECHO_OP);
 }
 
 int
@@ -771,7 +771,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
 	rc = cifs_call_async(server, &iov, 1, NULL, cifs_echo_callback,
-			     server, true);
+			     server, CIFS_ASYNC_OP | CIFS_ECHO_OP);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
 
@@ -1589,7 +1589,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 
 	queue_work(cifsiod_wq, &rdata->work);
 	DeleteMidQEntry(mid);
-	add_credits(server, 1);
+	add_credits(server, 1, 0);
 }
 
 /* cifs_async_readv - send an async write, and set up mid to handle result */
@@ -1645,7 +1645,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, rdata->iov, 1,
 			     cifs_readv_receive, cifs_readv_callback,
-			     rdata, false);
+			     rdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_reads);
@@ -2036,7 +2036,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 	queue_work(cifsiod_wq, &wdata->work);
 	DeleteMidQEntry(mid);
-	add_credits(tcon->ses->server, 1);
+	add_credits(tcon->ses->server, 1, 0);
 }
 
 /* cifs_async_writev - send an async write, and set up mid to handle result */
@@ -2118,7 +2118,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 
 	kref_get(&wdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
-			     NULL, cifs_writev_callback, wdata, false);
+			     NULL, cifs_writev_callback, wdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_writes);
@@ -2296,7 +2296,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 	LOCK_REQ *pSMB = NULL;
 /*	LOCK_RSP *pSMBr = NULL; */ /* No response data other than rc to parse */
 	int bytes_returned;
-	int timeout = 0;
+	int flags = 0;
 	__u16 count;
 
 	cFYI(1, "CIFSSMBLock timeout %d numLock %d", (int)waitFlag, numLock);
@@ -2306,10 +2306,11 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 		return rc;
 
 	if (lockType == LOCKING_ANDX_OPLOCK_RELEASE) {
-		timeout = CIFS_ASYNC_OP; /* no response expected */
+		/* no response expected */
+		flags = CIFS_ASYNC_OP | CIFS_OBREAK_OP;
 		pSMB->Timeout = 0;
 	} else if (waitFlag) {
-		timeout = CIFS_BLOCKING_OP; /* blocking operation, no timeout */
+		flags = CIFS_BLOCKING_OP; /* blocking operation, no timeout */
 		pSMB->Timeout = cpu_to_le32(-1);/* blocking - do not time out */
 	} else {
 		pSMB->Timeout = 0;
@@ -2342,7 +2343,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 			(struct smb_hdr *) pSMB, &bytes_returned);
 		cifs_small_buf_release(pSMB);
 	} else {
-		rc = SendReceiveNoRsp(xid, tcon->ses, (char *)pSMB, timeout);
+		rc = SendReceiveNoRsp(xid, tcon->ses, (char *)pSMB, flags);
 		/* SMB buffer freed by function above */
 	}
 	cifs_stats_inc(&tcon->num_locks);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 28359e7..f4f8394 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -101,7 +101,8 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
 }
 
 static void
-cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add)
+cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add,
+		 const int optype)
 {
 	spin_lock(&server->req_lock);
 	server->credits += add;
@@ -120,11 +121,17 @@ cifs_set_credits(struct TCP_Server_Info *server, const int val)
 }
 
 static int *
-cifs_get_credits_field(struct TCP_Server_Info *server)
+cifs_get_credits_field(struct TCP_Server_Info *server, const int optype)
 {
 	return &server->credits;
 }
 
+static unsigned int
+cifs_get_credits(struct mid_q_entry *mid)
+{
+	return 1;
+}
+
 /*
  * Find a free multiplex id (SMB mid). Otherwise there could be
  * mid collisions which might cause problems, demultiplexing the
@@ -390,6 +397,7 @@ struct smb_version_operations smb1_operations = {
 	.add_credits = cifs_add_credits,
 	.set_credits = cifs_set_credits,
 	.get_credits_field = cifs_get_credits_field,
+	.get_credits = cifs_get_credits,
 	.get_next_mid = cifs_get_next_mid,
 	.read_data_offset = cifs_read_data_offset,
 	.read_data_length = cifs_read_data_length,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f25d4ea..fb9daf5 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -254,13 +254,13 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 }
 
 static int
-wait_for_free_credits(struct TCP_Server_Info *server, const int optype,
+wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
 		      int *credits)
 {
 	int rc;
 
 	spin_lock(&server->req_lock);
-	if (optype == CIFS_ASYNC_OP) {
+	if (timeout == CIFS_ASYNC_OP) {
 		/* oplock breaks must not be held up */
 		server->in_flight++;
 		*credits -= 1;
@@ -290,7 +290,7 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int optype,
 			 */
 
 			/* update # of requests on the wire to server */
-			if (optype != CIFS_BLOCKING_OP) {
+			if (timeout != CIFS_BLOCKING_OP) {
 				*credits -= 1;
 				server->in_flight++;
 			}
@@ -302,10 +302,11 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int optype,
 }
 
 static int
-wait_for_free_request(struct TCP_Server_Info *server, const int optype)
+wait_for_free_request(struct TCP_Server_Info *server, const int timeout,
+		      const int optype)
 {
-	return wait_for_free_credits(server, optype,
-				     server->ops->get_credits_field(server));
+	return wait_for_free_credits(server, timeout,
+				server->ops->get_credits_field(server, optype));
 }
 
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
@@ -382,12 +383,15 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
 int
 cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 		unsigned int nvec, mid_receive_t *receive,
-		mid_callback_t *callback, void *cbdata, bool ignore_pend)
+		mid_callback_t *callback, void *cbdata, const int flags)
 {
-	int rc;
+	int rc, timeout, optype;
 	struct mid_q_entry *mid;
 
-	rc = wait_for_free_request(server, ignore_pend ? CIFS_ASYNC_OP : 0);
+	timeout = flags & CIFS_TIMEOUT_MASK;
+	optype = flags & CIFS_OP_MASK;
+
+	rc = wait_for_free_request(server, timeout, optype);
 	if (rc)
 		return rc;
 
@@ -395,7 +399,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	rc = cifs_setup_async_request(server, iov, nvec, &mid);
 	if (rc) {
 		mutex_unlock(&server->srv_mutex);
-		add_credits(server, 1);
+		add_credits(server, 1, optype);
 		wake_up(&server->request_q);
 		return rc;
 	}
@@ -421,7 +425,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 		return 0;
 
 	delete_mid(mid);
-	add_credits(server, 1);
+	add_credits(server, 1, optype);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -537,17 +541,19 @@ cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
 
 int
 SendReceive2(const unsigned int xid, struct cifs_ses *ses,
-	     struct kvec *iov, int n_vec, int *pRespBufType /* ret */,
+	     struct kvec *iov, int n_vec, int *resp_buf_type /* ret */,
 	     const int flags)
 {
 	int rc = 0;
-	int long_op;
+	int timeout, optype;
 	struct mid_q_entry *midQ;
 	char *buf = iov[0].iov_base;
+	unsigned int credits = 1;
 
-	long_op = flags & CIFS_TIMEOUT_MASK;
+	timeout = flags & CIFS_TIMEOUT_MASK;
+	optype = flags & CIFS_OP_MASK;
 
-	*pRespBufType = CIFS_NO_BUFFER;  /* no response buf yet */
+	*resp_buf_type = CIFS_NO_BUFFER;  /* no response buf yet */
 
 	if ((ses == NULL) || (ses->server == NULL)) {
 		cifs_small_buf_release(buf);
@@ -566,7 +572,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	 * use ses->maxReq.
 	 */
 
-	rc = wait_for_free_request(ses->server, long_op);
+	rc = wait_for_free_request(ses->server, timeout, optype);
 	if (rc) {
 		cifs_small_buf_release(buf);
 		return rc;
@@ -585,7 +591,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(buf);
 		/* Update # of requests on wire to server */
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, optype);
 		return rc;
 	}
 
@@ -602,7 +608,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	if (long_op == CIFS_ASYNC_OP) {
+	if (timeout == CIFS_ASYNC_OP) {
 		cifs_small_buf_release(buf);
 		goto out;
 	}
@@ -615,7 +621,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(buf);
-			add_credits(ses->server, 1);
+			add_credits(ses->server, 1, optype);
 			return rc;
 		}
 		spin_unlock(&GlobalMid_Lock);
@@ -625,7 +631,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, optype);
 		return rc;
 	}
 
@@ -639,9 +645,11 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	iov[0].iov_base = buf;
 	iov[0].iov_len = get_rfc1002_length(buf) + 4;
 	if (midQ->large_buf)
-		*pRespBufType = CIFS_LARGE_BUFFER;
+		*resp_buf_type = CIFS_LARGE_BUFFER;
 	else
-		*pRespBufType = CIFS_SMALL_BUFFER;
+		*resp_buf_type = CIFS_SMALL_BUFFER;
+
+	credits = ses->server->ops->get_credits(midQ);
 
 	rc = ses->server->ops->check_receive(midQ, ses->server,
 					     flags & CIFS_LOG_ERROR);
@@ -651,7 +659,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
-	add_credits(ses->server, 1);
+	add_credits(ses->server, credits, optype);
 
 	return rc;
 }
@@ -659,7 +667,7 @@ out:
 int
 SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	    struct smb_hdr *in_buf, struct smb_hdr *out_buf,
-	    int *pbytes_returned, const int long_op)
+	    int *pbytes_returned, const int timeout)
 {
 	int rc = 0;
 	struct mid_q_entry *midQ;
@@ -687,7 +695,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, long_op);
+	rc = wait_for_free_request(ses->server, timeout, 0);
 	if (rc)
 		return rc;
 
@@ -701,7 +709,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		/* Update # of requests on wire to server */
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, 0);
 		return rc;
 	}
 
@@ -722,7 +730,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc < 0)
 		goto out;
 
-	if (long_op == CIFS_ASYNC_OP)
+	if (timeout == CIFS_ASYNC_OP)
 		goto out;
 
 	rc = wait_for_response(ses->server, midQ);
@@ -733,7 +741,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			add_credits(ses->server, 1);
+			add_credits(ses->server, 1, 0);
 			return rc;
 		}
 		spin_unlock(&GlobalMid_Lock);
@@ -741,7 +749,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, 0);
 		return rc;
 	}
 
@@ -757,7 +765,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
-	add_credits(ses->server, 1);
+	add_credits(ses->server, 1, 0);
 
 	return rc;
 }
@@ -822,7 +830,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, CIFS_BLOCKING_OP);
+	rc = wait_for_free_request(ses->server, CIFS_BLOCKING_OP, 0);
 	if (rc)
 		return rc;
 
-- 
1.7.1
