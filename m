From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v3 01/10] CIFS: Simplify inFlight logic
Date: Tue, 20 Mar 2012 13:00:31 +0300
Message-ID: <1332237640-10145-2-git-send-email-piastry@etersoft.ru>
References: <1332237640-10145-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332237640-10145-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by making it as unsigned integer and surround access with req_lock
from server structure.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_debug.c |    3 +--
 fs/cifs/cifsglob.h   |   21 ++++++++++++++++++++-
 fs/cifs/cifssmb.c    |    6 +++---
 fs/cifs/connect.c    |   10 +++++-----
 fs/cifs/transport.c  |   45 +++++++++++++++++++++++----------------------
 5 files changed, 52 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 24b3dfc..573b899 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -171,8 +171,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			seq_printf(m, "TCP status: %d\n\tLocal Users To "
 				   "Server: %d SecMode: 0x%x Req On Wire: %d",
 				   server->tcpStatus, server->srv_count,
-				   server->sec_mode,
-				   atomic_read(&server->inFlight));
+				   server->sec_mode, in_flight(server));
 
 #ifdef CONFIG_CIFS_STATS2
 			seq_printf(m, " In Send: %d In MaxReq Wait: %d",
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d47d20a..fb78bc9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -250,7 +250,8 @@ struct TCP_Server_Info {
 	bool noblocksnd;		/* use blocking sendmsg */
 	bool noautotune;		/* do not autotune send buf sizes */
 	bool tcp_nodelay;
-	atomic_t inFlight;  /* number of requests on the wire to server */
+	unsigned int in_flight;  /* number of requests on the wire to server */
+	spinlock_t req_lock; /* protect the value above */
 	struct mutex srv_mutex;
 	struct task_struct *tsk;
 	char server_GUID[16];
@@ -303,6 +304,24 @@ struct TCP_Server_Info {
 #endif
 };
 
+static inline unsigned int
+in_flight(struct TCP_Server_Info *server)
+{
+	unsigned int num;
+	spin_lock(&server->req_lock);
+	num = server->in_flight;
+	spin_unlock(&server->req_lock);
+	return num;
+}
+
+static inline void
+dec_in_flight(struct TCP_Server_Info *server)
+{
+	spin_lock(&server->req_lock);
+	server->in_flight--;
+	spin_unlock(&server->req_lock);
+}
+
 /*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index cd66b76..d7cbcfa 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -721,7 +721,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = mid->callback_data;
 
 	DeleteMidQEntry(mid);
-	atomic_dec(&server->inFlight);
+	dec_in_flight(server);
 	wake_up(&server->request_q);
 }
 
@@ -1674,7 +1674,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 
 	queue_work(system_nrt_wq, &rdata->work);
 	DeleteMidQEntry(mid);
-	atomic_dec(&server->inFlight);
+	dec_in_flight(server);
 	wake_up(&server->request_q);
 }
 
@@ -2115,7 +2115,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 	queue_work(system_nrt_wq, &wdata->work);
 	DeleteMidQEntry(mid);
-	atomic_dec(&tcon->ses->server->inFlight);
+	dec_in_flight(tcon->ses->server);
 	wake_up(&tcon->ses->server->request_q);
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 03f71fb..a7627f2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -643,14 +643,14 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	wake_up_all(&server->response_q);
 
 	/* Check if we have blocked requests that need to free. */
-	spin_lock(&GlobalMid_Lock);
-	if (atomic_read(&server->inFlight) >= server->maxReq)
-		atomic_set(&server->inFlight, server->maxReq - 1);
+	spin_lock(&server->req_lock);
+	if (server->in_flight >= server->maxReq)
+		server->in_flight = server->maxReq - 1;
 	/*
 	 * We do not want to set the max_pending too low or we could end up
 	 * with the counter going negative.
 	 */
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&server->req_lock);
 	/*
 	 * Although there should not be any requests blocked on this queue it
 	 * can not hurt to be paranoid and try to wake up requests that may
@@ -1905,7 +1905,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
-	atomic_set(&tcp_ses->inFlight, 0);
+	tcp_ses->in_flight = 0;
 	tcp_ses->maxReq = 1; /* enough to send negotiate request */
 	init_waitqueue_head(&tcp_ses->response_q);
 	init_waitqueue_head(&tcp_ses->request_q);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 99a27cf..e2673aa 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -254,28 +254,29 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 	return smb_sendv(server, &iov, 1);
 }
 
-static int wait_for_free_request(struct TCP_Server_Info *server,
-				 const int long_op)
+static int
+wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 {
+	spin_lock(&server->req_lock);
+
 	if (long_op == CIFS_ASYNC_OP) {
 		/* oplock breaks must not be held up */
-		atomic_inc(&server->inFlight);
+		server->in_flight++;
+		spin_unlock(&server->req_lock);
 		return 0;
 	}
 
-	spin_lock(&GlobalMid_Lock);
 	while (1) {
-		if (atomic_read(&server->inFlight) >= server->maxReq) {
-			spin_unlock(&GlobalMid_Lock);
+		if (server->in_flight >= server->maxReq) {
+			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
 			wait_event(server->request_q,
-				   atomic_read(&server->inFlight)
-				     < server->maxReq);
+				   in_flight(server) < server->maxReq);
 			cifs_num_waiters_dec(server);
-			spin_lock(&GlobalMid_Lock);
+			spin_lock(&server->req_lock);
 		} else {
 			if (server->tcpStatus == CifsExiting) {
-				spin_unlock(&GlobalMid_Lock);
+				spin_unlock(&server->req_lock);
 				return -ENOENT;
 			}
 
@@ -284,8 +285,8 @@ static int wait_for_free_request(struct TCP_Server_Info *server,
 
 			/* update # of requests on the wire to server */
 			if (long_op != CIFS_BLOCKING_OP)
-				atomic_inc(&server->inFlight);
-			spin_unlock(&GlobalMid_Lock);
+				server->in_flight++;
+			spin_unlock(&server->req_lock);
 			break;
 		}
 	}
@@ -359,7 +360,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	mid = AllocMidQEntry(hdr, server);
 	if (mid == NULL) {
 		mutex_unlock(&server->srv_mutex);
-		atomic_dec(&server->inFlight);
+		dec_in_flight(server);
 		wake_up(&server->request_q);
 		return -ENOMEM;
 	}
@@ -392,7 +393,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	return rc;
 out_err:
 	delete_mid(mid);
-	atomic_dec(&server->inFlight);
+	dec_in_flight(server);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -564,7 +565,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(in_buf);
 		/* Update # of requests on wire to server */
-		atomic_dec(&ses->server->inFlight);
+		dec_in_flight(ses->server);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -601,7 +602,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(in_buf);
-			atomic_dec(&ses->server->inFlight);
+			dec_in_flight(ses->server);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -612,7 +613,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		atomic_dec(&ses->server->inFlight);
+		dec_in_flight(ses->server);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -637,7 +638,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
-	atomic_dec(&ses->server->inFlight);
+	dec_in_flight(ses->server);
 	wake_up(&ses->server->request_q);
 
 	return rc;
@@ -688,7 +689,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		/* Update # of requests on wire to server */
-		atomic_dec(&ses->server->inFlight);
+		dec_in_flight(ses->server);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -721,7 +722,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			atomic_dec(&ses->server->inFlight);
+			dec_in_flight(ses->server);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -730,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		atomic_dec(&ses->server->inFlight);
+		dec_in_flight(ses->server);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -747,7 +748,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
-	atomic_dec(&ses->server->inFlight);
+	dec_in_flight(ses->server);
 	wake_up(&ses->server->request_q);
 
 	return rc;
-- 
1.7.1
