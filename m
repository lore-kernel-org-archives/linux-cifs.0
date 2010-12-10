From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/13] cifs: make wait_for_free_request take a TCP_Server_Info pointer
Date: Fri, 10 Dec 2010 10:44:26 -0500
Message-ID: <1291995877-2276-3-git-send-email-jlayton@redhat.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The cifsSesInfo pointer is only used to get at the server.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e0588cd..9763f89 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -244,31 +244,31 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 	return smb_sendv(server, &iov, 1);
 }
 
-static int wait_for_free_request(struct cifsSesInfo *ses, const int long_op)
+static int wait_for_free_request(struct TCP_Server_Info *server,
+				 const int long_op)
 {
 	if (long_op == CIFS_ASYNC_OP) {
 		/* oplock breaks must not be held up */
-		atomic_inc(&ses->server->inFlight);
+		atomic_inc(&server->inFlight);
 		return 0;
 	}
 
 	spin_lock(&GlobalMid_Lock);
 	while (1) {
-		if (atomic_read(&ses->server->inFlight) >=
-				cifs_max_pending){
+		if (atomic_read(&server->inFlight) >= cifs_max_pending) {
 			spin_unlock(&GlobalMid_Lock);
 #ifdef CONFIG_CIFS_STATS2
-			atomic_inc(&ses->server->num_waiters);
+			atomic_inc(&server->num_waiters);
 #endif
-			wait_event(ses->server->request_q,
-				   atomic_read(&ses->server->inFlight)
+			wait_event(server->request_q,
+				   atomic_read(&server->inFlight)
 				     < cifs_max_pending);
 #ifdef CONFIG_CIFS_STATS2
-			atomic_dec(&ses->server->num_waiters);
+			atomic_dec(&server->num_waiters);
 #endif
 			spin_lock(&GlobalMid_Lock);
 		} else {
-			if (ses->server->tcpStatus == CifsExiting) {
+			if (server->tcpStatus == CifsExiting) {
 				spin_unlock(&GlobalMid_Lock);
 				return -ENOENT;
 			}
@@ -278,7 +278,7 @@ static int wait_for_free_request(struct cifsSesInfo *ses, const int long_op)
 
 			/* update # of requests on the wire to server */
 			if (long_op != CIFS_BLOCKING_OP)
-				atomic_inc(&ses->server->inFlight);
+				atomic_inc(&server->inFlight);
 			spin_unlock(&GlobalMid_Lock);
 			break;
 		}
@@ -413,7 +413,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	   to the same server. We may make this configurable later or
 	   use ses->maxReq */
 
-	rc = wait_for_free_request(ses, long_op);
+	rc = wait_for_free_request(ses->server, long_op);
 	if (rc) {
 		cifs_small_buf_release(in_buf);
 		return rc;
@@ -610,7 +610,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses, long_op);
+	rc = wait_for_free_request(ses->server, long_op);
 	if (rc)
 		return rc;
 
@@ -845,7 +845,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses, CIFS_BLOCKING_OP);
+	rc = wait_for_free_request(ses->server, CIFS_BLOCKING_OP);
 	if (rc)
 		return rc;
 
-- 
1.7.3.2
