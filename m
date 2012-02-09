From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/6] CIFS: Introduce credit-based flow control
Date: Thu,  9 Feb 2012 11:41:24 +0300
Message-ID: <1328776890-4190-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and send no more than credits value requests at once. For SMB/CIFS
it's trivial: increment this value by receiving any message and
decrement by sending one.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/cifssmb.c   |    3 +++
 fs/cifs/connect.c   |   10 ++++------
 fs/cifs/transport.c |   20 ++++++++++++++++----
 4 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 76e7d8b..f96752a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -256,6 +256,7 @@ struct TCP_Server_Info {
 	bool noautotune;		/* do not autotune send buf sizes */
 	bool tcp_nodelay;
 	atomic_t inFlight;  /* number of requests on the wire to server */
+	atomic_t credits;  /* send no more requests at once */
 	struct mutex srv_mutex;
 	struct task_struct *tsk;
 	char server_GUID[16];
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8b7794c..fbc4437 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -717,6 +717,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 
 	DeleteMidQEntry(mid);
 	atomic_dec(&server->inFlight);
+	atomic_inc(&server->credits);
 	wake_up(&server->request_q);
 }
 
@@ -1670,6 +1671,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	queue_work(system_nrt_wq, &rdata->work);
 	DeleteMidQEntry(mid);
 	atomic_dec(&server->inFlight);
+	atomic_inc(&server->credits);
 	wake_up(&server->request_q);
 }
 
@@ -2111,6 +2113,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 	queue_work(system_nrt_wq, &wdata->work);
 	DeleteMidQEntry(mid);
 	atomic_dec(&tcon->ses->server->inFlight);
+	atomic_inc(&tcon->ses->server->credits);
 	wake_up(&tcon->ses->server->request_q);
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 602f77c..6b95304 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -648,12 +648,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	 * time to as little as two.
 	 */
 	spin_lock(&GlobalMid_Lock);
-	if (atomic_read(&server->inFlight) >= cifs_max_pending)
-		atomic_set(&server->inFlight, cifs_max_pending - 1);
-	/*
-	 * We do not want to set the max_pending too low or we could end up
-	 * with the counter going negative.
-	 */
+	if (atomic_read(&server->credits) == 0)
+		atomic_set(&server->credits, 1);
 	spin_unlock(&GlobalMid_Lock);
 	/*
 	 * Although there should not be any requests blocked on this queue it
@@ -3759,9 +3755,11 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	if (server->maxBuf != 0)
 		return 0;
 
+	atomic_set(&ses->server->credits, cifs_max_pending);
 	rc = CIFSSMBNegotiate(xid, ses);
 	if (rc == -EAGAIN) {
 		/* retry only once on 1st time connection */
+		atomic_set(&ses->server->credits, cifs_max_pending);
 		rc = CIFSSMBNegotiate(xid, ses);
 		if (rc == -EAGAIN)
 			rc = -EHOSTDOWN;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0cc9584..f1f927f 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -260,17 +260,17 @@ static int wait_for_free_request(struct TCP_Server_Info *server,
 	if (long_op == CIFS_ASYNC_OP) {
 		/* oplock breaks must not be held up */
 		atomic_inc(&server->inFlight);
+		atomic_dec(&server->credits);
 		return 0;
 	}
 
 	spin_lock(&GlobalMid_Lock);
 	while (1) {
-		if (atomic_read(&server->inFlight) >= cifs_max_pending) {
+		if (atomic_read(&server->credits) == 0) {
 			spin_unlock(&GlobalMid_Lock);
 			cifs_num_waiters_inc(server);
 			wait_event(server->request_q,
-				   atomic_read(&server->inFlight)
-				     < cifs_max_pending);
+				   atomic_read(&server->credits) > 0);
 			cifs_num_waiters_dec(server);
 			spin_lock(&GlobalMid_Lock);
 		} else {
@@ -283,8 +283,10 @@ static int wait_for_free_request(struct TCP_Server_Info *server,
 			   as they are allowed to block on server */
 
 			/* update # of requests on the wire to server */
-			if (long_op != CIFS_BLOCKING_OP)
+			if (long_op != CIFS_BLOCKING_OP) {
 				atomic_inc(&server->inFlight);
+				atomic_dec(&server->credits);
+			}
 			spin_unlock(&GlobalMid_Lock);
 			break;
 		}
@@ -360,6 +362,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	if (mid == NULL) {
 		mutex_unlock(&server->srv_mutex);
 		atomic_dec(&server->inFlight);
+		atomic_inc(&server->credits);
 		wake_up(&server->request_q);
 		return -ENOMEM;
 	}
@@ -393,6 +396,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 out_err:
 	delete_mid(mid);
 	atomic_dec(&server->inFlight);
+	atomic_inc(&server->credits);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -565,6 +569,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		cifs_small_buf_release(in_buf);
 		/* Update # of requests on wire to server */
 		atomic_dec(&ses->server->inFlight);
+		atomic_inc(&ses->server->credits);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -602,6 +607,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(in_buf);
 			atomic_dec(&ses->server->inFlight);
+			atomic_inc(&ses->server->credits);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -613,6 +619,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
 		atomic_dec(&ses->server->inFlight);
+		atomic_inc(&ses->server->credits);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -638,6 +645,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 out:
 	delete_mid(midQ);
 	atomic_dec(&ses->server->inFlight);
+	atomic_inc(&ses->server->credits);
 	wake_up(&ses->server->request_q);
 
 	return rc;
@@ -689,6 +697,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		/* Update # of requests on wire to server */
 		atomic_dec(&ses->server->inFlight);
+		atomic_inc(&ses->server->credits);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -722,6 +731,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			atomic_dec(&ses->server->inFlight);
+			atomic_inc(&ses->server->credits);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -731,6 +741,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
 		atomic_dec(&ses->server->inFlight);
+		atomic_inc(&ses->server->credits);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -748,6 +759,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 out:
 	delete_mid(midQ);
 	atomic_dec(&ses->server->inFlight);
+	atomic_inc(&ses->server->credits);
 	wake_up(&ses->server->request_q);
 
 	return rc;
-- 
1.7.1
