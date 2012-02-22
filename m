From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 02/11] CIFS: Introduce credit-based flow control
Date: Wed, 22 Feb 2012 10:32:55 +0300
Message-ID: <1329895984-9251-3-git-send-email-piastry@etersoft.ru>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329895984-9251-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and send no more than credits value requests at once. For SMB/CIFS
it's trivial: increment this value by receiving any message and
decrement by sending one.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   24 ++++++++++++++++++++++--
 fs/cifs/cifssmb.c   |    6 +++---
 fs/cifs/connect.c   |   17 ++++++-----------
 fs/cifs/transport.c |   30 ++++++++++++++++--------------
 4 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 44cfc9a..600d61c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -255,8 +255,9 @@ struct TCP_Server_Info {
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
@@ -318,14 +319,33 @@ in_flight(struct TCP_Server_Info *server)
 	return num;
 }
 
+static inline int
+get_credits(struct TCP_Server_Info *server)
+{
+	int num;
+	spin_lock(&server->req_lock);
+	num = server->credits;
+	spin_unlock(&server->req_lock);
+	return num;
+}
+
 static inline void
-dec_in_flight(struct TCP_Server_Info *server)
+add_credits(struct TCP_Server_Info *server, unsigned int add)
 {
 	spin_lock(&server->req_lock);
+	server->credits += add;
 	server->in_flight--;
 	spin_unlock(&server->req_lock);
 }
 
+static inline void
+set_credits(struct TCP_Server_Info *server, int val)
+{
+	spin_lock(&server->req_lock);
+	server->credits = val;
+	spin_unlock(&server->req_lock);
+}
+
 /*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0b50551..c255c25 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -716,7 +716,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = mid->callback_data;
 
 	DeleteMidQEntry(mid);
-	dec_in_flight(server);
+	add_credits(server, 1);
 	wake_up(&server->request_q);
 }
 
@@ -1669,7 +1669,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 
 	queue_work(system_nrt_wq, &rdata->work);
 	DeleteMidQEntry(mid);
-	dec_in_flight(server);
+	add_credits(server, 1);
 	wake_up(&server->request_q);
 }
 
@@ -2110,7 +2110,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 	queue_work(system_nrt_wq, &wdata->work);
 	DeleteMidQEntry(mid);
-	dec_in_flight(tcon->ses->server);
+	add_credits(tcon->ses->server, 1);
 	wake_up(&tcon->ses->server->request_q);
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 12286d0..673813f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -642,18 +642,10 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	spin_unlock(&GlobalMid_Lock);
 	wake_up_all(&server->response_q);
 
-	/*
-	 * Check if we have blocked requests that need to free. Note that
-	 * cifs_max_pending is normally 50, but can be set at module install
-	 * time to as little as two.
-	 */
+	/* check if we have blocked requests that need to free */
 	spin_lock(&server->req_lock);
-	if (server->in_flight >= cifs_max_pending)
-		server->in_flight = cifs_max_pending - 1;
-	/*
-	 * We do not want to set the max_pending too low or we could end up
-	 * with the counter going negative.
-	 */
+	if (server->credits <= 0)
+		server->credits = 1;
 	spin_unlock(&server->req_lock);
 	/*
 	 * Although there should not be any requests blocked on this queue it
@@ -1910,6 +1902,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
 	tcp_ses->in_flight = 0;
+	tcp_ses->credits = cifs_max_pending;
 	init_waitqueue_head(&tcp_ses->response_q);
 	init_waitqueue_head(&tcp_ses->request_q);
 	INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
@@ -3759,9 +3752,11 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	if (server->maxBuf != 0)
 		return 0;
 
+	set_credits(server, cifs_max_pending);
 	rc = CIFSSMBNegotiate(xid, ses);
 	if (rc == -EAGAIN) {
 		/* retry only once on 1st time connection */
+		set_credits(server, cifs_max_pending);
 		rc = CIFSSMBNegotiate(xid, ses);
 		if (rc == -EAGAIN)
 			rc = -EHOSTDOWN;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index fc1904f..44ac0aa 100644
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
-		if (server->in_flight >= cifs_max_pending) {
+		if (server->credits <= 0) {
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
-			wait_event(server->request_q,
-				   in_flight(server) < cifs_max_pending);
+			wait_event(server->request_q, get_credits(server) > 0);
 			cifs_num_waiters_dec(server);
 			spin_lock(&server->req_lock);
 		} else {
@@ -284,8 +284,10 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 			   as they are allowed to block on server */
 
 			/* update # of requests on the wire to server */
-			if (long_op != CIFS_BLOCKING_OP)
+			if (long_op != CIFS_BLOCKING_OP) {
+				server->credits--;
 				server->in_flight++;
+			}
 			spin_unlock(&server->req_lock);
 			break;
 		}
@@ -360,7 +362,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	mid = AllocMidQEntry(hdr, server);
 	if (mid == NULL) {
 		mutex_unlock(&server->srv_mutex);
-		dec_in_flight(server);
+		add_credits(server, 1);
 		wake_up(&server->request_q);
 		return -ENOMEM;
 	}
@@ -393,7 +395,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	return rc;
 out_err:
 	delete_mid(mid);
-	dec_in_flight(server);
+	add_credits(server, 1);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -565,7 +567,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(in_buf);
 		/* Update # of requests on wire to server */
-		dec_in_flight(ses->server);
+		add_credits(ses->server, 1);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -602,7 +604,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(in_buf);
-			dec_in_flight(ses->server);
+			add_credits(ses->server, 1);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -613,7 +615,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		dec_in_flight(ses->server);
+		add_credits(ses->server, 1);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -638,7 +640,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
-	dec_in_flight(ses->server);
+	add_credits(ses->server, 1);
 	wake_up(&ses->server->request_q);
 
 	return rc;
@@ -689,7 +691,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		/* Update # of requests on wire to server */
-		dec_in_flight(ses->server);
+		add_credits(ses->server, 1);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -722,7 +724,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			dec_in_flight(ses->server);
+			add_credits(ses->server, 1);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -731,7 +733,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		dec_in_flight(ses->server);
+		add_credits(ses->server, 1);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -748,7 +750,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
-	dec_in_flight(ses->server);
+	add_credits(ses->server, 1);
 	wake_up(&ses->server->request_q);
 
 	return rc;
-- 
1.7.1
