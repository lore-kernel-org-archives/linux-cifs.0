From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 07/16] CIFS: Add SMB2 credits support
Date: Mon, 26 Mar 2012 13:21:34 +0400
Message-ID: <1332753703-4315-8-git-send-email-piastry@etersoft.ru>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For SMB2 protocol we can add more than one credit for one received
request: it depends on CreditRequest field in SMB2 response header.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   24 +++++++++++++++++++-----
 fs/cifs/cifsproto.h |    5 +++--
 fs/cifs/cifssmb.c   |   12 ++++++------
 fs/cifs/connect.c   |    2 +-
 fs/cifs/misc.c      |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/transport.c |   47 ++++++++++++++++++++++++++++++++---------------
 6 files changed, 107 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5db61db..2805c91 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -273,6 +273,9 @@ struct TCP_Server_Info {
 	bool session_estab; /* mark when very first sess is established */
 #ifdef CONFIG_CIFS_SMB2
 	bool is_smb2;	/* SMB2 not CIFS protocol negotiated */
+	int echo_credits;  /* echo reserved slots */
+	int oplock_credits;  /* oplock break reserved slots */
+	bool echos:1; /* enable echos */
 #endif
 	u16 dialect; /* dialect index that server chose */
 	enum securityEnum secType;
@@ -331,14 +334,25 @@ in_flight(struct TCP_Server_Info *server)
 	return num;
 }
 
+#define   CIFS_OBREAK_OP    0x080    /* oplock break request */
+#define   CIFS_ECHO_OP     0x0100    /* echo request */
+#define   CIFS_REQ_MASK    0x0180    /* mask request type */
+
 static inline int*
-get_credits_field(struct TCP_Server_Info *server)
+get_credits_field(struct TCP_Server_Info *server, const int optype)
 {
-	/*
-	 * This will change to switch statement when we reserve slots for echos
-	 * and oplock breaks.
-	 */
+#ifdef CONFIG_CIFS_SMB2
+	switch (optype) {
+	case CIFS_ECHO_OP:
+		return &server->echo_credits;
+	case CIFS_OBREAK_OP:
+		return &server->oplock_credits;
+	default:
+		return &server->credits;
+	}
+#else
 	return &server->credits;
+#endif
 }
 
 static inline bool
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 9f8ff33..e901bb6 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -76,7 +76,7 @@ extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
 			   mid_callback_t *callback, void *cbdata,
-			   bool ignore_pend);
+			   const int optype);
 extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
@@ -94,8 +94,9 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
 extern void cifs_add_credits(struct TCP_Server_Info *server,
-			     const unsigned int add);
+			     const unsigned int add, const int optype);
 extern void cifs_set_credits(struct TCP_Server_Info *server, const int val);
+extern int cifs_reconnect(struct TCP_Server_Info *server);
 extern int checkSMB(char *buf, unsigned int length);
 extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8fecc99..3e61c73 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -721,7 +721,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = mid->callback_data;
 
 	DeleteMidQEntry(mid);
-	cifs_add_credits(server, 1);
+	cifs_add_credits(server, 1, 0);
 }
 
 int
@@ -748,7 +748,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
 	rc = cifs_call_async(server, &iov, 1, NULL, cifs_echo_callback,
-			     server, true);
+			     server, CIFS_ASYNC_OP);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
 
@@ -1691,7 +1691,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 
 	queue_work(cifsiod_wq, &rdata->work);
 	DeleteMidQEntry(mid);
-	cifs_add_credits(server, 1);
+	cifs_add_credits(server, 1, 0);
 }
 
 /* cifs_async_readv - send an async write, and set up mid to handle result */
@@ -1746,7 +1746,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
 
 	rc = cifs_call_async(tcon->ses->server, rdata->iov, 1,
 			     cifs_readv_receive, cifs_readv_callback,
-			     rdata, false);
+			     rdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_reads);
@@ -2135,7 +2135,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 	queue_work(cifsiod_wq, &wdata->work);
 	DeleteMidQEntry(mid);
-	cifs_add_credits(tcon->ses->server, 1);
+	cifs_add_credits(tcon->ses->server, 1, 0);
 }
 
 /* cifs_async_writev - send an async write, and set up mid to handle result */
@@ -2215,7 +2215,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 
 	kref_get(&wdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
-			     NULL, cifs_writev_callback, wdata, false);
+			     NULL, cifs_writev_callback, wdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_writes);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1fbc21f..e6daae2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -266,7 +266,7 @@ static int cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
  * reconnect tcp session
  * wake up waiters on reconnection? - (not needed currently)
  */
-static int
+int
 cifs_reconnect(struct TCP_Server_Info *server)
 {
 	int rc = 0;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index e8fa7a4..2e0bb8c 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -712,12 +712,52 @@ backup_cred(struct cifs_sb_info *cifs_sb)
 	return false;
 }
 
+#ifdef CONFIG_CIFS_SMB2
+static void
+cifs_change_conf(struct TCP_Server_Info *server)
+{
+	server->oplock_credits = server->echo_credits = 0;
+	switch (server->credits) {
+	case 0:
+		cifs_reconnect(server);
+		return;
+	case 1:
+		server->echos = false;
+		server->oplocks = false;
+		cERROR(1, "disabling echos and oplocks");
+		break;
+	case 2:
+		server->echos = true;
+		server->oplocks = false;
+		server->echo_credits = 1;
+		cFYI(1, "disabling oplocks");
+		break;
+	default:
+		server->echos = true;
+		server->oplocks = true;
+		server->echo_credits = 1;
+		server->oplock_credits = 1;
+	}
+	server->credits -= server->echo_credits + server->oplock_credits;
+}
+#endif
+
 void
-cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add)
+cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add,
+		 const int optype)
 {
+	int *val;
 	spin_lock(&server->req_lock);
-	server->credits += add;
+	val = get_credits_field(server, optype);
+	*val += add;
 	server->in_flight--;
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2 && server->in_flight == 0) {
+		server->credits += server->echo_credits +
+				   server->oplock_credits;
+		cifs_change_conf(server);
+	}
+#endif
 	spin_unlock(&server->req_lock);
 	wake_up(&server->request_q);
 }
@@ -727,6 +767,9 @@ cifs_set_credits(struct TCP_Server_Info *server, const int val)
 {
 	spin_lock(&server->req_lock);
 	server->credits = val;
-	server->oplocks = val > 1 ? enable_oplocks : false;
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2 == false)
+#endif
+		server->oplocks = val > 1 ? enable_oplocks : false;
 	spin_unlock(&server->req_lock);
 }
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 79126b9..c36ed64 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -312,7 +312,8 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int optype,
 static int
 wait_for_free_request(struct TCP_Server_Info *server, const int optype)
 {
-	return wait_for_free_credits(server, optype, get_credits_field(server));
+	return wait_for_free_credits(server, optype,
+				     get_credits_field(server, optype));
 }
 
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
@@ -391,12 +392,12 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
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
 
@@ -404,7 +405,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	rc = cifs_setup_async_request(server, iov, nvec, &mid);
 	if (rc) {
 		mutex_unlock(&server->srv_mutex);
-		cifs_add_credits(server, 1);
+		cifs_add_credits(server, 1, optype);
 		wake_up(&server->request_q);
 		return rc;
 	}
@@ -426,7 +427,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	return rc;
 out_err:
 	delete_mid(mid);
-	cifs_add_credits(server, 1);
+	cifs_add_credits(server, 1, optype);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -599,17 +600,31 @@ setup_request(struct cifs_ses *ses, struct kvec *iov,
 		return cifs_setup_request(ses, iov, nvec, ret_mid);
 }
 
+static unsigned int
+get_credits(struct mid_q_entry *mid)
+{
+#ifdef CONFIG_CIFS_SMB2
+	if (mid->is_smb2)
+		return le16_to_cpu(
+			((struct smb2_hdr *)mid->resp_buf)->CreditRequest);
+	else
+#endif
+		return 1;
+}
+
 int
 SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	     struct kvec *iov, int n_vec, int *pRespBufType /* ret */,
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
 
@@ -630,7 +645,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	 * use ses->maxReq.
 	 */
 
-	rc = wait_for_free_request(ses->server, long_op);
+	rc = wait_for_free_request(ses->server, optype);
 	if (rc) {
 		cifs_small_buf_release(buf);
 		return rc;
@@ -649,7 +664,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(buf);
 		/* Update # of requests on wire to server */
-		cifs_add_credits(ses->server, 1);
+		cifs_add_credits(ses->server, 1, optype);
 		return rc;
 	}
 
@@ -679,7 +694,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(buf);
-			cifs_add_credits(ses->server, 1);
+			cifs_add_credits(ses->server, 1, optype);
 			return rc;
 		}
 		spin_unlock(&GlobalMid_Lock);
@@ -689,7 +704,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		cifs_add_credits(ses->server, 1);
+		cifs_add_credits(ses->server, 1, optype);
 		return rc;
 	}
 
@@ -707,6 +722,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	else
 		*pRespBufType = CIFS_SMALL_BUFFER;
 
+	credits = get_credits(midQ);
+
 	rc = check_receive(midQ, ses->server, flags & CIFS_LOG_ERROR);
 
 	/* mark it so buf will not be freed by delete_mid */
@@ -714,7 +731,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
-	cifs_add_credits(ses->server, 1);
+	cifs_add_credits(ses->server, credits, optype);
 
 	return rc;
 }
@@ -764,7 +781,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		/* Update # of requests on wire to server */
-		cifs_add_credits(ses->server, 1);
+		cifs_add_credits(ses->server, 1, 0);
 		return rc;
 	}
 
@@ -796,7 +813,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			cifs_add_credits(ses->server, 1);
+			cifs_add_credits(ses->server, 1, 0);
 			return rc;
 		}
 		spin_unlock(&GlobalMid_Lock);
@@ -804,7 +821,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		cifs_add_credits(ses->server, 1);
+		cifs_add_credits(ses->server, 1, 0);
 		return rc;
 	}
 
@@ -820,7 +837,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
-	cifs_add_credits(ses->server, 1);
+	cifs_add_credits(ses->server, 1, 0);
 
 	return rc;
 }
-- 
1.7.1
