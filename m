From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 4/7] CIFS: Extend credit mechanism to process request type
Date: Tue, 29 May 2012 20:19:01 +0400
Message-ID: <1338308344-29149-5-git-send-email-pshilovsky@samba.org>
References: <1338308344-29149-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338308344-29149-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Split all requests to echos, oplocks and others - each group uses
its own credit slot. This change is required to support SMB2 code.

As for CIFS - we don't use this approach and the logic isn't changed.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   14 ++++++++++----
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/cifssmb.c   |   12 ++++++------
 fs/cifs/smb1ops.c   |   12 ++++++++++--
 fs/cifs/transport.c |   34 +++++++++++++++++++---------------
 5 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3b8828b..b0afcb6 100644
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
@@ -410,9 +412,10 @@ has_credits(struct TCP_Server_Info *server, int *credits)
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
@@ -974,6 +977,9 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   CIFS_LOG_ERROR    0x010    /* log NT STATUS if non-zero */
 #define   CIFS_LARGE_BUF_OP 0x020    /* large request buffer */
 #define   CIFS_NO_RESP      0x040    /* no response buffer required */
+#define   CIFS_ECHO_OP      0x080    /* echo request */
+#define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
+#define   CIFS_REQ_MASK    0x0180    /* mask request type */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0a6cbfe..41d5a76 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -71,7 +71,7 @@ extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
 			   mid_callback_t *callback, void *cbdata,
-			   bool ignore_pend);
+			   const int optype);
 extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5b40073..65898cc 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -720,7 +720,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = mid->callback_data;
 
 	DeleteMidQEntry(mid);
-	add_credits(server, 1);
+	add_credits(server, 1, 0);
 }
 
 int
@@ -747,7 +747,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
 	rc = cifs_call_async(server, &iov, 1, NULL, cifs_echo_callback,
-			     server, true);
+			     server, CIFS_ASYNC_OP);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
 
@@ -1563,7 +1563,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 
 	queue_work(cifsiod_wq, &rdata->work);
 	DeleteMidQEntry(mid);
-	add_credits(server, 1);
+	add_credits(server, 1, 0);
 }
 
 /* cifs_async_readv - send an async write, and set up mid to handle result */
@@ -1619,7 +1619,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, rdata->iov, 1,
 			     cifs_readv_receive, cifs_readv_callback,
-			     rdata, false);
+			     rdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_reads);
@@ -2010,7 +2010,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 	queue_work(cifsiod_wq, &wdata->work);
 	DeleteMidQEntry(mid);
-	add_credits(tcon->ses->server, 1);
+	add_credits(tcon->ses->server, 1, 0);
 }
 
 /* cifs_async_writev - send an async write, and set up mid to handle result */
@@ -2090,7 +2090,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 
 	kref_get(&wdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
-			     NULL, cifs_writev_callback, wdata, false);
+			     NULL, cifs_writev_callback, wdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_writes);
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
index 6fdb5be..0497c65 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -305,7 +305,7 @@ static int
 wait_for_free_request(struct TCP_Server_Info *server, const int optype)
 {
 	return wait_for_free_credits(server, optype,
-				     server->ops->get_credits_field(server));
+				server->ops->get_credits_field(server, optype));
 }
 
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
@@ -384,12 +384,12 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
 int
 cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 		unsigned int nvec, mid_receive_t *receive,
-		mid_callback_t *callback, void *cbdata, bool ignore_pend)
+		mid_callback_t *callback, void *cbdata, const int optype)
 {
 	int rc;
 	struct mid_q_entry *mid;
 
-	rc = wait_for_free_request(server, ignore_pend ? CIFS_ASYNC_OP : 0);
+	rc = wait_for_free_request(server, optype);
 	if (rc)
 		return rc;
 
@@ -397,7 +397,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	rc = cifs_setup_async_request(server, iov, nvec, &mid);
 	if (rc) {
 		mutex_unlock(&server->srv_mutex);
-		add_credits(server, 1);
+		add_credits(server, 1, optype);
 		wake_up(&server->request_q);
 		return rc;
 	}
@@ -419,7 +419,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	return rc;
 out_err:
 	delete_mid(mid);
-	add_credits(server, 1);
+	add_credits(server, 1, optype);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -538,11 +538,13 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	     const int flags)
 {
 	int rc = 0;
-	int long_op;
+	int long_op, optype;
 	struct mid_q_entry *midQ;
 	char *buf = iov[0].iov_base;
+	unsigned int credits = 1;
 
 	long_op = flags & CIFS_TIMEOUT_MASK;
+	optype = flags & CIFS_REQ_MASK;
 
 	*pRespBufType = CIFS_NO_BUFFER;  /* no response buf yet */
 
@@ -563,7 +565,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	 * use ses->maxReq.
 	 */
 
-	rc = wait_for_free_request(ses->server, long_op);
+	rc = wait_for_free_request(ses->server, optype);
 	if (rc) {
 		cifs_small_buf_release(buf);
 		return rc;
@@ -582,7 +584,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(buf);
 		/* Update # of requests on wire to server */
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, optype);
 		return rc;
 	}
 
@@ -612,7 +614,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(buf);
-			add_credits(ses->server, 1);
+			add_credits(ses->server, 1, optype);
 			return rc;
 		}
 		spin_unlock(&GlobalMid_Lock);
@@ -622,7 +624,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, optype);
 		return rc;
 	}
 
@@ -640,6 +642,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	else
 		*pRespBufType = CIFS_SMALL_BUFFER;
 
+	credits = ses->server->ops->get_credits(midQ);
+
 	rc = ses->server->ops->check_receive(midQ, ses->server,
 					     flags & CIFS_LOG_ERROR);
 
@@ -648,7 +652,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
-	add_credits(ses->server, 1);
+	add_credits(ses->server, credits, optype);
 
 	return rc;
 }
@@ -698,7 +702,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		/* Update # of requests on wire to server */
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, 0);
 		return rc;
 	}
 
@@ -730,7 +734,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			add_credits(ses->server, 1);
+			add_credits(ses->server, 1, 0);
 			return rc;
 		}
 		spin_unlock(&GlobalMid_Lock);
@@ -738,7 +742,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, 0);
 		return rc;
 	}
 
@@ -754,7 +758,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
-	add_credits(ses->server, 1);
+	add_credits(ses->server, 1, 0);
 
 	return rc;
 }
-- 
1.7.1
