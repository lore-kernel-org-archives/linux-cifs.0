From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/7] cifs: don't call mid_q_entry->callback under the Global_MidLock
Date: Thu, 19 May 2011 16:22:54 -0400
Message-ID: <1305836578-26333-4-git-send-email-jlayton@redhat.com>
References: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305836578-26333-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Holding the spinlock while we call this function means that it can't
sleep, which really limits what it can do. Taking it out from under
the spinlock also means less contention for this global lock.

Change the semantics such that the Global_MidLock is not held when
the callback is called. To do this requires that we take extra care
not to have sync_mid_result remove the mid from the list when the
mid is in a state where that has already happened. This prevents
list corruption when the mid is sitting on a private list for
reconnect or when cifsd is coming down.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    6 +++---
 fs/cifs/connect.c   |   30 ++++++++++++++++++++++++------
 fs/cifs/transport.c |   23 ++++++++---------------
 3 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 76b4517..fd877c1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -543,9 +543,8 @@ struct mid_q_entry;
  * This is the prototype for the mid callback function. When creating one,
  * take special care to avoid deadlocks. Things to bear in mind:
  *
- * - it will be called by cifsd
- * - the GlobalMid_Lock will be held
- * - the mid will be removed from the pending_mid_q list
+ * - it will be called by cifsd, with no locks held
+ * - the mid will be removed from any lists
  */
 typedef void (mid_callback_t)(struct mid_q_entry *mid);
 
@@ -656,6 +655,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   MID_RESPONSE_RECEIVED 4
 #define   MID_RETRY_NEEDED      8 /* session closed while this request out */
 #define   MID_RESPONSE_MALFORMED 0x10
+#define   MID_SHUTDOWN		 0x20
 
 /* Types of response buffer returned from SendReceive2 */
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index da284e3..ccb3ff8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -138,6 +138,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
 	struct mid_q_entry *mid_entry;
+	struct list_head retry_list;
 
 	spin_lock(&GlobalMid_Lock);
 	if (server->tcpStatus == CifsExiting) {
@@ -189,16 +190,23 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	mutex_unlock(&server->srv_mutex);
 
 	/* mark submitted MIDs for retry and issue callback */
-	cFYI(1, "%s: issuing mid callbacks", __func__);
+	INIT_LIST_HEAD(&retry_list);
+	cFYI(1, "%s: moving mids to private list", __func__);
 	spin_lock(&GlobalMid_Lock);
 	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 		if (mid_entry->midState == MID_REQUEST_SUBMITTED)
 			mid_entry->midState = MID_RETRY_NEEDED;
+		list_move(&mid_entry->qhead, &retry_list);
+	}
+	spin_unlock(&GlobalMid_Lock);
+
+	cFYI(1, "%s: moving mids to private list", __func__);
+	list_for_each_safe(tmp, tmp2, &retry_list) {
+		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 		list_del_init(&mid_entry->qhead);
 		mid_entry->callback(mid_entry);
 	}
-	spin_unlock(&GlobalMid_Lock);
 
 	while (server->tcpStatus == CifsNeedReconnect) {
 		try_to_freeze();
@@ -672,12 +680,12 @@ multi_t2_fnd:
 			mid_entry->when_received = jiffies;
 #endif
 			list_del_init(&mid_entry->qhead);
-			mid_entry->callback(mid_entry);
 			break;
 		}
 		spin_unlock(&GlobalMid_Lock);
 
 		if (mid_entry != NULL) {
+			mid_entry->callback(mid_entry);
 			/* Was previous buf put in mpx struct for multi-rsp? */
 			if (!isMultiRsp) {
 				/* smb buffer will be freed by user thread */
@@ -741,15 +749,25 @@ multi_t2_fnd:
 		cifs_small_buf_release(smallbuf);
 
 	if (!list_empty(&server->pending_mid_q)) {
+		struct list_head dispose_list;
+
+		INIT_LIST_HEAD(&dispose_list);
 		spin_lock(&GlobalMid_Lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cFYI(1, "Clearing Mid 0x%x - issuing callback",
-					 mid_entry->mid);
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
 			list_del_init(&mid_entry->qhead);
 			mid_entry->callback(mid_entry);
 		}
-		spin_unlock(&GlobalMid_Lock);
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
 	}
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 67f59c7..b3c3c6d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -425,7 +425,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifsSesInfo *ses,
 }
 
 static int
-sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
+cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
 	int rc = 0;
 
@@ -433,28 +433,21 @@ sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 		mid->mid, mid->midState);
 
 	spin_lock(&GlobalMid_Lock);
-	/* ensure that it's no longer on the pending_mid_q */
-	list_del_init(&mid->qhead);
-
 	switch (mid->midState) {
 	case MID_RESPONSE_RECEIVED:
 		spin_unlock(&GlobalMid_Lock);
 		return rc;
-	case MID_REQUEST_SUBMITTED:
-		/* socket is going down, reject all calls */
-		if (server->tcpStatus == CifsExiting) {
-			cERROR(1, "%s: canceling mid=%d cmd=0x%x state=%d",
-			       __func__, mid->mid, mid->command, mid->midState);
-			rc = -EHOSTDOWN;
-			break;
-		}
 	case MID_RETRY_NEEDED:
 		rc = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
 		rc = -EIO;
 		break;
+	case MID_SHUTDOWN:
+		rc = -EHOSTDOWN;
+		break;
 	default:
+		list_del_init(&mid->qhead);
 		cERROR(1, "%s: invalid mid state mid=%d state=%d", __func__,
 			mid->mid, mid->midState);
 		rc = -EIO;
@@ -617,7 +610,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 
 	cifs_small_buf_release(in_buf);
 
-	rc = sync_mid_result(midQ, ses->server);
+	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
 		atomic_dec(&ses->server->inFlight);
 		wake_up(&ses->server->request_q);
@@ -738,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		spin_unlock(&GlobalMid_Lock);
 	}
 
-	rc = sync_mid_result(midQ, ses->server);
+	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
 		atomic_dec(&ses->server->inFlight);
 		wake_up(&ses->server->request_q);
@@ -913,7 +906,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 		rstart = 1;
 	}
 
-	rc = sync_mid_result(midQ, ses->server);
+	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0)
 		return rc;
 
-- 
1.7.4.4
