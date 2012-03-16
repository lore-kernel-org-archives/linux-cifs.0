From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 03/11] CIFS: Introduce credit-based flow control
Date: Fri, 16 Mar 2012 18:09:26 +0300
Message-ID: <1331910574-998-4-git-send-email-piastry@etersoft.ru>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331910574-998-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and send no more than credits value requests at once. For SMB/CIFS
it's trivial: increment this value by receiving any message and
decrement by sending one.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   11 +++++++----
 fs/cifs/cifsproto.h |    3 +++
 fs/cifs/cifssmb.c   |   10 +++++-----
 fs/cifs/connect.c   |   14 ++++++--------
 fs/cifs/misc.c      |   18 ++++++++++++++++++
 fs/cifs/transport.c |   36 ++++++++++++++++++++----------------
 6 files changed, 59 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index fb78bc9..d55de96 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -250,8 +250,9 @@ struct TCP_Server_Info {
 	bool noblocksnd;		/* use blocking sendmsg */
 	bool noautotune;		/* do not autotune send buf sizes */
 	bool tcp_nodelay;
+	int credits;  /* send no more requests at once */
 	unsigned int in_flight;  /* number of requests on the wire to server */
-	spinlock_t req_lock; /* protect the value above */
+	spinlock_t req_lock;  /* protect the two values above */
 	struct mutex srv_mutex;
 	struct task_struct *tsk;
 	char server_GUID[16];
@@ -314,12 +315,14 @@ in_flight(struct TCP_Server_Info *server)
 	return num;
 }
 
-static inline void
-dec_in_flight(struct TCP_Server_Info *server)
+static inline bool
+has_credits(struct TCP_Server_Info *server)
 {
+	int num;
 	spin_lock(&server->req_lock);
-	server->in_flight--;
+	num = server->credits;
 	spin_unlock(&server->req_lock);
+	return num > 0;
 }
 
 /*
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6f4e243..47a769e 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -88,6 +88,9 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *in_buf ,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
+extern void cifs_add_credits(struct TCP_Server_Info *server,
+			     const unsigned int add);
+extern void cifs_set_credits(struct TCP_Server_Info *server, const int val);
 extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
 extern bool is_valid_oplock_break(struct smb_hdr *smb,
 				  struct TCP_Server_Info *);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d7cbcfa..08c84a1 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -461,7 +461,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 		server->maxReq = min_t(unsigned int,
 				       le16_to_cpu(rsp->MaxMpxCount),
 				       cifs_max_pending);
-		server->oplocks = server->maxReq > 1 ? enable_oplocks : false;
+		cifs_set_credits(server, server->maxReq);
 		server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
 		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
 		/* even though we do not use raw we might as well set this
@@ -569,7 +569,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 	   little endian */
 	server->maxReq = min_t(unsigned int, le16_to_cpu(pSMBr->MaxMpxCount),
 			       cifs_max_pending);
-	server->oplocks = server->maxReq > 1 ? enable_oplocks : false;
+	cifs_set_credits(server, server->maxReq);
 	/* probably no need to store and check maxvcs */
 	server->maxBuf = le32_to_cpu(pSMBr->MaxBufferSize);
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
@@ -721,7 +721,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = mid->callback_data;
 
 	DeleteMidQEntry(mid);
-	dec_in_flight(server);
+	cifs_add_credits(server, 1);
 	wake_up(&server->request_q);
 }
 
@@ -1674,7 +1674,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 
 	queue_work(system_nrt_wq, &rdata->work);
 	DeleteMidQEntry(mid);
-	dec_in_flight(server);
+	cifs_add_credits(server, 1);
 	wake_up(&server->request_q);
 }
 
@@ -2115,7 +2115,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 	queue_work(system_nrt_wq, &wdata->work);
 	DeleteMidQEntry(mid);
-	dec_in_flight(tcon->ses->server);
+	cifs_add_credits(tcon->ses->server, 1);
 	wake_up(&tcon->ses->server->request_q);
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a7627f2..f3a0c49 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -642,14 +642,10 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	spin_unlock(&GlobalMid_Lock);
 	wake_up_all(&server->response_q);
 
-	/* Check if we have blocked requests that need to free. */
+	/* check if we have blocked requests that need to free */
 	spin_lock(&server->req_lock);
-	if (server->in_flight >= server->maxReq)
-		server->in_flight = server->maxReq - 1;
-	/*
-	 * We do not want to set the max_pending too low or we could end up
-	 * with the counter going negative.
-	 */
+	if (server->credits <= 0)
+		server->credits = 1;
 	spin_unlock(&server->req_lock);
 	/*
 	 * Although there should not be any requests blocked on this queue it
@@ -1906,7 +1902,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
 	tcp_ses->in_flight = 0;
-	tcp_ses->maxReq = 1; /* enough to send negotiate request */
+	tcp_ses->credits = 1;
 	init_waitqueue_head(&tcp_ses->response_q);
 	init_waitqueue_head(&tcp_ses->request_q);
 	INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
@@ -3756,9 +3752,11 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	if (server->maxBuf != 0)
 		return 0;
 
+	cifs_set_credits(server, 1);
 	rc = CIFSSMBNegotiate(xid, ses);
 	if (rc == -EAGAIN) {
 		/* retry only once on 1st time connection */
+		cifs_set_credits(server, 1);
 		rc = CIFSSMBNegotiate(xid, ses);
 		if (rc == -EAGAIN)
 			rc = -EHOSTDOWN;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 703ef5c..5dc936b 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -690,3 +690,21 @@ backup_cred(struct cifs_sb_info *cifs_sb)
 
 	return false;
 }
+
+void
+cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add)
+{
+	spin_lock(&server->req_lock);
+	server->credits += add;
+	server->in_flight--;
+	spin_unlock(&server->req_lock);
+}
+
+void
+cifs_set_credits(struct TCP_Server_Info *server, const int val)
+{
+	spin_lock(&server->req_lock);
+	server->credits = val;
+	server->oplocks = val > 1 ? enable_oplocks : false;
+	spin_unlock(&server->req_lock);
+}
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e2673aa..e8a4fd3 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -262,16 +262,16 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 	if (long_op == CIFS_ASYNC_OP) {
 		/* oplock breaks must not be held up */
 		server->in_flight++;
+		server->credits--;
 		spin_unlock(&server->req_lock);
 		return 0;
 	}
 
 	while (1) {
-		if (server->in_flight >= server->maxReq) {
+		if (server->credits <= 0) {
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
-			wait_event(server->request_q,
-				   in_flight(server) < server->maxReq);
+			wait_event(server->request_q, has_credits(server));
 			cifs_num_waiters_dec(server);
 			spin_lock(&server->req_lock);
 		} else {
@@ -280,12 +280,16 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 				return -ENOENT;
 			}
 
-			/* can not count locking commands against total
-			   as they are allowed to block on server */
+			/*
+			 * Can not count locking commands against total
+			 * as they are allowed to block on server.
+			 */
 
 			/* update # of requests on the wire to server */
-			if (long_op != CIFS_BLOCKING_OP)
+			if (long_op != CIFS_BLOCKING_OP) {
+				server->credits--;
 				server->in_flight++;
+			}
 			spin_unlock(&server->req_lock);
 			break;
 		}
@@ -360,7 +364,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	mid = AllocMidQEntry(hdr, server);
 	if (mid == NULL) {
 		mutex_unlock(&server->srv_mutex);
-		dec_in_flight(server);
+		cifs_add_credits(server, 1);
 		wake_up(&server->request_q);
 		return -ENOMEM;
 	}
@@ -393,7 +397,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	return rc;
 out_err:
 	delete_mid(mid);
-	dec_in_flight(server);
+	cifs_add_credits(server, 1);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -565,7 +569,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(in_buf);
 		/* Update # of requests on wire to server */
-		dec_in_flight(ses->server);
+		cifs_add_credits(ses->server, 1);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -602,7 +606,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(in_buf);
-			dec_in_flight(ses->server);
+			cifs_add_credits(ses->server, 1);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -613,7 +617,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		dec_in_flight(ses->server);
+		cifs_add_credits(ses->server, 1);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -638,7 +642,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
-	dec_in_flight(ses->server);
+	cifs_add_credits(ses->server, 1);
 	wake_up(&ses->server->request_q);
 
 	return rc;
@@ -689,7 +693,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		/* Update # of requests on wire to server */
-		dec_in_flight(ses->server);
+		cifs_add_credits(ses->server, 1);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -722,7 +726,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			dec_in_flight(ses->server);
+			cifs_add_credits(ses->server, 1);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -731,7 +735,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		dec_in_flight(ses->server);
+		cifs_add_credits(ses->server, 1);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -748,7 +752,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
-	dec_in_flight(ses->server);
+	cifs_add_credits(ses->server, 1);
 	wake_up(&ses->server->request_q);
 
 	return rc;
-- 
1.7.1
