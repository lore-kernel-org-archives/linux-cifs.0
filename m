From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/18] cifs: move mid result processing into common function
Date: Fri, 17 Dec 2010 10:08:05 -0500
Message-ID: <1292598497-29796-7-git-send-email-jlayton@redhat.com>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |  121 ++++++++++++++++++---------------------------------
 1 files changed, 43 insertions(+), 78 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 801726b..15059c7 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -389,6 +389,42 @@ SendReceiveNoRsp(const unsigned int xid, struct cifsSesInfo *ses,
 	return rc;
 }
 
+static int
+sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
+{
+	int rc = 0;
+
+	spin_lock(&GlobalMid_Lock);
+
+	if (mid->resp_buf) {
+		spin_unlock(&GlobalMid_Lock);
+		return rc;
+	}
+
+	cERROR(1, "No response to cmd %d mid %d", mid->command, mid->mid);
+	if (mid->midState == MID_REQUEST_SUBMITTED) {
+		if (server->tcpStatus == CifsExiting)
+			rc = -EHOSTDOWN;
+		else {
+			server->tcpStatus = CifsNeedReconnect;
+			mid->midState = MID_RETRY_NEEDED;
+		}
+	}
+
+	if (rc != -EHOSTDOWN) {
+		if (mid->midState == MID_RETRY_NEEDED) {
+			rc = -EAGAIN;
+			cFYI(1, "marking request for retry");
+		} else {
+			rc = -EIO;
+		}
+	}
+	spin_unlock(&GlobalMid_Lock);
+
+	delete_mid(mid);
+	return rc;
+}
+
 int
 SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	     struct kvec *iov, int n_vec, int *pRespBufType /* ret */,
@@ -492,37 +528,13 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	/* No user interrupts in wait - wreaks havoc with performance */
 	wait_for_response(ses, midQ, timeout, 10 * HZ);
 
-	spin_lock(&GlobalMid_Lock);
-
-	if (midQ->resp_buf == NULL) {
-		cERROR(1, "No response to cmd %d mid %d",
-			midQ->command, midQ->mid);
-		if (midQ->midState == MID_REQUEST_SUBMITTED) {
-			if (ses->server->tcpStatus == CifsExiting)
-				rc = -EHOSTDOWN;
-			else {
-				ses->server->tcpStatus = CifsNeedReconnect;
-				midQ->midState = MID_RETRY_NEEDED;
-			}
-		}
-
-		if (rc != -EHOSTDOWN) {
-			if (midQ->midState == MID_RETRY_NEEDED) {
-				rc = -EAGAIN;
-				cFYI(1, "marking request for retry");
-			} else {
-				rc = -EIO;
-			}
-		}
-		spin_unlock(&GlobalMid_Lock);
-		delete_mid(midQ);
-		/* Update # of requests on wire to server */
+	rc = sync_mid_result(midQ, ses->server);
+	if (rc != 0) {
 		atomic_dec(&ses->server->inFlight);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
 
-	spin_unlock(&GlobalMid_Lock);
 	receive_len = midQ->resp_buf->smb_buf_length;
 
 	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
@@ -684,36 +696,13 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 	/* No user interrupts in wait - wreaks havoc with performance */
 	wait_for_response(ses, midQ, timeout, 10 * HZ);
 
-	spin_lock(&GlobalMid_Lock);
-	if (midQ->resp_buf == NULL) {
-		cERROR(1, "No response for cmd %d mid %d",
-			  midQ->command, midQ->mid);
-		if (midQ->midState == MID_REQUEST_SUBMITTED) {
-			if (ses->server->tcpStatus == CifsExiting)
-				rc = -EHOSTDOWN;
-			else {
-				ses->server->tcpStatus = CifsNeedReconnect;
-				midQ->midState = MID_RETRY_NEEDED;
-			}
-		}
-
-		if (rc != -EHOSTDOWN) {
-			if (midQ->midState == MID_RETRY_NEEDED) {
-				rc = -EAGAIN;
-				cFYI(1, "marking request for retry");
-			} else {
-				rc = -EIO;
-			}
-		}
-		spin_unlock(&GlobalMid_Lock);
-		delete_mid(midQ);
-		/* Update # of requests on wire to server */
+	rc = sync_mid_result(midQ, ses->server);
+	if (rc != 0) {
 		atomic_dec(&ses->server->inFlight);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
 
-	spin_unlock(&GlobalMid_Lock);
 	receive_len = midQ->resp_buf->smb_buf_length;
 
 	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
@@ -933,35 +922,11 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 		}
 	}
 
-	spin_lock(&GlobalMid_Lock);
-	if (midQ->resp_buf) {
-		spin_unlock(&GlobalMid_Lock);
-		receive_len = midQ->resp_buf->smb_buf_length;
-	} else {
-		cERROR(1, "No response for cmd %d mid %d",
-			  midQ->command, midQ->mid);
-		if (midQ->midState == MID_REQUEST_SUBMITTED) {
-			if (ses->server->tcpStatus == CifsExiting)
-				rc = -EHOSTDOWN;
-			else {
-				ses->server->tcpStatus = CifsNeedReconnect;
-				midQ->midState = MID_RETRY_NEEDED;
-			}
-		}
-
-		if (rc != -EHOSTDOWN) {
-			if (midQ->midState == MID_RETRY_NEEDED) {
-				rc = -EAGAIN;
-				cFYI(1, "marking request for retry");
-			} else {
-				rc = -EIO;
-			}
-		}
-		spin_unlock(&GlobalMid_Lock);
-		delete_mid(midQ);
+	rc = sync_mid_result(midQ, ses->server);
+	if (rc != 0)
 		return rc;
-	}
 
+	receive_len = midQ->resp_buf->smb_buf_length;
 	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
 		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
 			receive_len, xid);
-- 
1.7.3.3
