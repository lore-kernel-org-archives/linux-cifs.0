From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v5 PATCH 5/5] CIFS: Cleanup demupltiplex thread exiting code
Date: Mon,  1 Aug 2011 13:19:44 +0400
Message-ID: <1312190384-3376-6-git-send-email-piastryyy@gmail.com>
References: <1312190384-3376-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312190384-3376-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-and-Tested-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |  173 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 96 insertions(+), 77 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 12b2741..80c2e3a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -531,6 +531,101 @@ multi_t2_fnd:
 	return ret;
 }
 
+static void clean_demultiplex_info(struct TCP_Server_Info *server)
+{
+	int length;
+
+	/* take it off the list, if it's not already */
+	spin_lock(&cifs_tcp_ses_lock);
+	list_del_init(&server->tcp_ses_list);
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	spin_lock(&GlobalMid_Lock);
+	server->tcpStatus = CifsExiting;
+	spin_unlock(&GlobalMid_Lock);
+	wake_up_all(&server->response_q);
+
+	/*
+	 * Check if we have blocked requests that need to free. Note that
+	 * cifs_max_pending is normally 50, but can be set at module install
+	 * time to as little as two.
+	 */
+	spin_lock(&GlobalMid_Lock);
+	if (atomic_read(&server->inFlight) >= cifs_max_pending)
+		atomic_set(&server->inFlight, cifs_max_pending - 1);
+	/*
+	 * We do not want to set the max_pending too low or we could end up
+	 * with the counter going negative.
+	 */
+	spin_unlock(&GlobalMid_Lock);
+	/*
+	 * Although there should not be any requests blocked on this queue it
+	 * can not hurt to be paranoid and try to wake up requests that may
+	 * haven been blocked when more than 50 at time were on the wire to the
+	 * same server - they now will see the session is in exit state and get
+	 * out of SendReceive.
+	 */
+	wake_up_all(&server->request_q);
+	/* give those requests time to exit */
+	msleep(125);
+
+	if (server->ssocket) {
+		sock_release(server->ssocket);
+		server->ssocket = NULL;
+	}
+
+	if (!list_empty(&server->pending_mid_q)) {
+		struct list_head dispose_list;
+		struct mid_q_entry *mid_entry;
+		struct list_head *tmp, *tmp2;
+
+		INIT_LIST_HEAD(&dispose_list);
+		spin_lock(&GlobalMid_Lock);
+		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
+			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+			cFYI(1, "Clearing mid 0x%x", mid_entry->mid);
+			mid_entry->midState = MID_SHUTDOWN;
+			list_move(&mid_entry->qhead, &dispose_list);
+		}
+		spin_unlock(&GlobalMid_Lock);
+
+		/* now walk dispose list and issue callbacks */
+		list_for_each_safe(tmp, tmp2, &dispose_list) {
+			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+			cFYI(1, "Callback mid 0x%x", mid_entry->mid);
+			list_del_init(&mid_entry->qhead);
+			mid_entry->callback(mid_entry);
+		}
+		/* 1/8th of sec is more than enough time for them to exit */
+		msleep(125);
+	}
+
+	if (!list_empty(&server->pending_mid_q)) {
+		/*
+		 * mpx threads have not exited yet give them at least the smb
+		 * send timeout time for long ops.
+		 *
+		 * Due to delays on oplock break requests, we need to wait at
+		 * least 45 seconds before giving up on a request getting a
+		 * response and going ahead and killing cifsd.
+		 */
+		cFYI(1, "Wait for exit from demultiplex thread");
+		msleep(46000);
+		/*
+		 * If threads still have not exited they are probably never
+		 * coming home not much else we can do but free the memory.
+		 */
+	}
+
+	kfree(server->hostname);
+	kfree(server);
+
+	length = atomic_dec_return(&tcpSesAllocCount);
+	if (length > 0)
+		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
+				GFP_KERNEL);
+}
+
 static int
 cifs_demultiplex_thread(void *p)
 {
@@ -541,7 +636,6 @@ cifs_demultiplex_thread(void *p)
 	struct smb_hdr *smb_buffer = NULL;
 	struct msghdr smb_msg;
 	struct kvec iov;
-	struct list_head *tmp, *tmp2;
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 	bool isLargeBuf = false;
@@ -678,88 +772,13 @@ incomplete_rcv:
 		}
 	} /* end while !EXITING */
 
-	/* take it off the list, if it's not already */
-	spin_lock(&cifs_tcp_ses_lock);
-	list_del_init(&server->tcp_ses_list);
-	spin_unlock(&cifs_tcp_ses_lock);
-
-	spin_lock(&GlobalMid_Lock);
-	server->tcpStatus = CifsExiting;
-	spin_unlock(&GlobalMid_Lock);
-	wake_up_all(&server->response_q);
-
-	/* check if we have blocked requests that need to free */
-	/* Note that cifs_max_pending is normally 50, but
-	can be set at module install time to as little as two */
-	spin_lock(&GlobalMid_Lock);
-	if (atomic_read(&server->inFlight) >= cifs_max_pending)
-		atomic_set(&server->inFlight, cifs_max_pending - 1);
-	/* We do not want to set the max_pending too low or we
-	could end up with the counter going negative */
-	spin_unlock(&GlobalMid_Lock);
-	/* Although there should not be any requests blocked on
-	this queue it can not hurt to be paranoid and try to wake up requests
-	that may haven been blocked when more than 50 at time were on the wire
-	to the same server - they now will see the session is in exit state
-	and get out of SendReceive.  */
-	wake_up_all(&server->request_q);
-	/* give those requests time to exit */
-	msleep(125);
-
-	if (server->ssocket) {
-		sock_release(server->ssocket);
-		server->ssocket = NULL;
-	}
 	/* buffer usually freed in free_mid - need to free it here on exit */
 	cifs_buf_release(bigbuf);
 	if (smallbuf) /* no sense logging a debug message if NULL */
 		cifs_small_buf_release(smallbuf);
 
-	if (!list_empty(&server->pending_mid_q)) {
-		struct list_head dispose_list;
-
-		INIT_LIST_HEAD(&dispose_list);
-		spin_lock(&GlobalMid_Lock);
-		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
-			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cFYI(1, "Clearing mid 0x%x", mid_entry->mid);
-			mid_entry->midState = MID_SHUTDOWN;
-			list_move(&mid_entry->qhead, &dispose_list);
-		}
-		spin_unlock(&GlobalMid_Lock);
-
-		/* now walk dispose list and issue callbacks */
-		list_for_each_safe(tmp, tmp2, &dispose_list) {
-			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cFYI(1, "Callback mid 0x%x", mid_entry->mid);
-			list_del_init(&mid_entry->qhead);
-			mid_entry->callback(mid_entry);
-		}
-		/* 1/8th of sec is more than enough time for them to exit */
-		msleep(125);
-	}
-
-	if (!list_empty(&server->pending_mid_q)) {
-		/* mpx threads have not exited yet give them
-		at least the smb send timeout time for long ops */
-		/* due to delays on oplock break requests, we need
-		to wait at least 45 seconds before giving up
-		on a request getting a response and going ahead
-		and killing cifsd */
-		cFYI(1, "Wait for exit from demultiplex thread");
-		msleep(46000);
-		/* if threads still have not exited they are probably never
-		coming home not much else we can do but free the memory */
-	}
-
-	kfree(server->hostname);
 	task_to_wake = xchg(&server->tsk, NULL);
-	kfree(server);
-
-	length = atomic_dec_return(&tcpSesAllocCount);
-	if (length  > 0)
-		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
-				GFP_KERNEL);
+	clean_demultiplex_info(server);
 
 	/* if server->tsk was NULL then wait for a signal before exiting */
 	if (!task_to_wake) {
-- 
1.7.1
