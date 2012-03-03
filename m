From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 03/17] CIFS: Count blocking lock command
Date: Sat,  3 Mar 2012 12:37:04 +0300
Message-ID: <1330767438-19469-4-git-send-email-piastry@etersoft.ru>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330767438-19469-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to make sure we don't exceed the number of credits we have in this case.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    6 ++++-
 fs/cifs/cifssmb.c   |    6 ++--
 fs/cifs/connect.c   |    1 +
 fs/cifs/transport.c |   57 +++++++++++++++++++++++++++++++++-----------------
 4 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 35d3df4..fa1a9f9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -257,6 +257,7 @@ struct TCP_Server_Info {
 	bool tcp_nodelay;
 	int credits;  /* send no more requests at once */
 	unsigned int in_flight;  /* number of requests on the wire to server */
+	unsigned int block_locks;  /* number of oustanding blocking locks */
 	spinlock_t req_lock;  /* protect the two values above */
 	struct mutex srv_mutex;
 	struct task_struct *tsk;
@@ -330,11 +331,14 @@ get_credits(struct TCP_Server_Info *server)
 }
 
 static inline void
-add_credits(struct TCP_Server_Info *server, const unsigned int add)
+add_credits(struct TCP_Server_Info *server, const unsigned int add, int optype)
 {
 	spin_lock(&server->req_lock);
 	server->credits += add;
 	server->in_flight--;
+	/* blocking lock case */
+	if (optype == 1)
+		server->block_locks--;
 	spin_unlock(&server->req_lock);
 }
 
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c255c25..b1040c7 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -716,7 +716,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = mid->callback_data;
 
 	DeleteMidQEntry(mid);
-	add_credits(server, 1);
+	add_credits(server, 1, 0);
 	wake_up(&server->request_q);
 }
 
@@ -1669,7 +1669,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 
 	queue_work(system_nrt_wq, &rdata->work);
 	DeleteMidQEntry(mid);
-	add_credits(server, 1);
+	add_credits(server, 1, 0);
 	wake_up(&server->request_q);
 }
 
@@ -2110,7 +2110,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 	queue_work(system_nrt_wq, &wdata->work);
 	DeleteMidQEntry(mid);
-	add_credits(tcon->ses->server, 1);
+	add_credits(tcon->ses->server, 1, 0);
 	wake_up(&tcon->ses->server->request_q);
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 673813f..708be6c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1903,6 +1903,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
 	tcp_ses->in_flight = 0;
 	tcp_ses->credits = cifs_max_pending;
+	tcp_ses->block_locks = 0;
 	init_waitqueue_head(&tcp_ses->response_q);
 	init_waitqueue_head(&tcp_ses->request_q);
 	INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 44ac0aa..5fab0f1 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -267,6 +267,11 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 		return 0;
 	}
 
+	/* we can't leave the client without available credits */
+	if (long_op == CIFS_BLOCKING_OP &&
+	    (server->block_locks >= (server->in_flight + server->credits) / 2))
+		return -ENOLCK;
+
 	while (1) {
 		if (server->credits <= 0) {
 			spin_unlock(&server->req_lock);
@@ -279,15 +284,10 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 				spin_unlock(&server->req_lock);
 				return -ENOENT;
 			}
-
-			/* can not count locking commands against total
-			   as they are allowed to block on server */
-
-			/* update # of requests on the wire to server */
-			if (long_op != CIFS_BLOCKING_OP) {
-				server->credits--;
-				server->in_flight++;
-			}
+			server->credits--;
+			server->in_flight++;
+			if (long_op == CIFS_BLOCKING_OP)
+				server->block_locks++;
 			spin_unlock(&server->req_lock);
 			break;
 		}
@@ -362,7 +362,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	mid = AllocMidQEntry(hdr, server);
 	if (mid == NULL) {
 		mutex_unlock(&server->srv_mutex);
-		add_credits(server, 1);
+		add_credits(server, 1, 0);
 		wake_up(&server->request_q);
 		return -ENOMEM;
 	}
@@ -395,7 +395,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	return rc;
 out_err:
 	delete_mid(mid);
-	add_credits(server, 1);
+	add_credits(server, 1, 0);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -567,7 +567,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(in_buf);
 		/* Update # of requests on wire to server */
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, 0);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -604,7 +604,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(in_buf);
-			add_credits(ses->server, 1);
+			add_credits(ses->server, 1, 0);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -615,7 +615,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, 0);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -640,7 +640,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
-	add_credits(ses->server, 1);
+	add_credits(ses->server, 1, 0);
 	wake_up(&ses->server->request_q);
 
 	return rc;
@@ -691,7 +691,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		/* Update # of requests on wire to server */
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, 0);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -724,7 +724,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			add_credits(ses->server, 1);
+			add_credits(ses->server, 1, 0);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -733,7 +733,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		add_credits(ses->server, 1);
+		add_credits(ses->server, 1, 0);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -750,7 +750,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
-	add_credits(ses->server, 1);
+	add_credits(ses->server, 1, 0);
 	wake_up(&ses->server->request_q);
 
 	return rc;
@@ -829,6 +829,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = allocate_mid(ses, in_buf, &midQ);
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
+		add_credits(ses->server, 1, CIFS_BLOCKING_OP);
+		wake_up(&ses->server->request_q);
 		return rc;
 	}
 
@@ -836,6 +838,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		delete_mid(midQ);
 		mutex_unlock(&ses->server->srv_mutex);
+		add_credits(ses->server, 1, CIFS_BLOCKING_OP);
+		wake_up(&ses->server->request_q);
 		return rc;
 	}
 
@@ -848,6 +852,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (rc < 0) {
 		delete_mid(midQ);
+		add_credits(ses->server, 1, CIFS_BLOCKING_OP);
+		wake_up(&ses->server->request_q);
 		return rc;
 	}
 
@@ -869,6 +875,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			rc = send_nt_cancel(ses->server, in_buf, midQ);
 			if (rc) {
 				delete_mid(midQ);
+				add_credits(ses->server, 1, CIFS_BLOCKING_OP);
+				wake_up(&ses->server->request_q);
 				return rc;
 			}
 		} else {
@@ -881,6 +889,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			   already been removed. Don't exit in this case. */
 			if (rc && rc != -ENOLCK) {
 				delete_mid(midQ);
+				add_credits(ses->server, 1, CIFS_BLOCKING_OP);
+				wake_up(&ses->server->request_q);
 				return rc;
 			}
 		}
@@ -893,6 +903,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 				/* no longer considered to be "in-flight" */
 				midQ->callback = DeleteMidQEntry;
 				spin_unlock(&GlobalMid_Lock);
+				add_credits(ses->server, 1, CIFS_BLOCKING_OP);
+				wake_up(&ses->server->request_q);
 				return rc;
 			}
 			spin_unlock(&GlobalMid_Lock);
@@ -903,8 +915,11 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
-	if (rc != 0)
+	if (rc != 0) {
+		add_credits(ses->server, 1, CIFS_BLOCKING_OP);
+		wake_up(&ses->server->request_q);
 		return rc;
+	}
 
 	/* rcvd frame is ok */
 	if (out_buf == NULL || midQ->midState != MID_RESPONSE_RECEIVED) {
@@ -918,6 +933,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
+	add_credits(ses->server, 1, CIFS_BLOCKING_OP);
+	wake_up(&ses->server->request_q);
 	if (rstart && rc == -EACCES)
 		return -ERESTARTSYS;
 	return rc;
-- 
1.7.1
