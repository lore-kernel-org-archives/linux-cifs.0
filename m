From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/18] cifs: wait indefinitely for responses
Date: Fri, 17 Dec 2010 10:08:06 -0500
Message-ID: <1292598497-29796-8-git-send-email-jlayton@redhat.com>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The client should not be timing out on individual SMB requests. Too much
of the state between client and server is tied to the state of the
socket. If we time out requests and issue spurious disconnects then that
comprimises data integrity.

Instead of doing this complicated dance where we try to decide how long
to wait for a response for particular requests, have the client instead
wait indefinitely for a response. Also, use a TASK_KILLABLE sleep here
so that fatal signals will break out of this waiting.

Later patches will add support for detecting dead peers and forcing
reconnects based on that.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |  110 ++++++++-------------------------------------------
 1 files changed, 17 insertions(+), 93 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 15059c7..c41c9c4 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -318,48 +318,17 @@ static int allocate_mid(struct cifsSesInfo *ses, struct smb_hdr *in_buf,
 	return 0;
 }
 
-static int wait_for_response(struct cifsSesInfo *ses,
-			struct mid_q_entry *midQ,
-			unsigned long timeout,
-			unsigned long time_to_wait)
+static int
+wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 {
-	unsigned long curr_timeout;
-
-	for (;;) {
-		curr_timeout = timeout + jiffies;
-		wait_event_timeout(ses->server->response_q,
-			midQ->midState != MID_REQUEST_SUBMITTED, timeout);
-
-		if (time_after(jiffies, curr_timeout) &&
-			(midQ->midState == MID_REQUEST_SUBMITTED) &&
-			((ses->server->tcpStatus == CifsGood) ||
-			 (ses->server->tcpStatus == CifsNew))) {
-
-			unsigned long lrt;
+	int error;
 
-			/* We timed out. Is the server still
-			   sending replies ? */
-			spin_lock(&GlobalMid_Lock);
-			lrt = ses->server->lstrp;
-			spin_unlock(&GlobalMid_Lock);
+	error = wait_event_killable(server->response_q,
+				    midQ->midState != MID_REQUEST_SUBMITTED);
+	if (error < 0)
+		return -ERESTARTSYS;
 
-			/* Calculate time_to_wait past last receive time.
-			 Although we prefer not to time out if the
-			 server is still responding - we will time
-			 out if the server takes more than 15 (or 45
-			 or 180) seconds to respond to this request
-			 and has not responded to any request from
-			 other threads on the client within 10 seconds */
-			lrt += time_to_wait;
-			if (time_after(jiffies, lrt)) {
-				/* No replies for time_to_wait. */
-				cERROR(1, "server not responding");
-				return -1;
-			}
-		} else {
-			return 0;
-		}
-	}
+	return 0;
 }
 
 
@@ -433,7 +402,6 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	int rc = 0;
 	int long_op;
 	unsigned int receive_len;
-	unsigned long timeout;
 	struct mid_q_entry *midQ;
 	struct smb_hdr *in_buf = iov[0].iov_base;
 
@@ -500,33 +468,12 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	if (rc < 0)
 		goto out;
 
-	if (long_op == CIFS_STD_OP)
-		timeout = 15 * HZ;
-	else if (long_op == CIFS_VLONG_OP) /* e.g. slow writes past EOF */
-		timeout = 180 * HZ;
-	else if (long_op == CIFS_LONG_OP)
-		timeout = 45 * HZ; /* should be greater than
-			servers oplock break timeout (about 43 seconds) */
-	else if (long_op == CIFS_ASYNC_OP)
-		goto out;
-	else if (long_op == CIFS_BLOCKING_OP)
-		timeout = 0x7FFFFFFF; /*  large, but not so large as to wrap */
-	else {
-		cERROR(1, "unknown timeout flag %d", long_op);
-		rc = -EIO;
+	if (long_op == CIFS_ASYNC_OP)
 		goto out;
-	}
-
-	/* wait for 15 seconds or until woken up due to response arriving or
-	   due to last connection to this server being unmounted */
-	if (signal_pending(current)) {
-		/* if signal pending do not hold up user for full smb timeout
-		but we still give response a chance to complete */
-		timeout = 2 * HZ;
-	}
 
-	/* No user interrupts in wait - wreaks havoc with performance */
-	wait_for_response(ses, midQ, timeout, 10 * HZ);
+	rc = wait_for_response(ses->server, midQ);
+	if (rc != 0)
+		goto out;
 
 	rc = sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
@@ -604,7 +551,6 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 {
 	int rc = 0;
 	unsigned int receive_len;
-	unsigned long timeout;
 	struct mid_q_entry *midQ;
 
 	if (ses == NULL) {
@@ -668,33 +614,12 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 	if (rc < 0)
 		goto out;
 
-	if (long_op == CIFS_STD_OP)
-		timeout = 15 * HZ;
-	/* wait for 15 seconds or until woken up due to response arriving or
-	   due to last connection to this server being unmounted */
-	else if (long_op == CIFS_ASYNC_OP)
-		goto out;
-	else if (long_op == CIFS_VLONG_OP) /* writes past EOF can be slow */
-		timeout = 180 * HZ;
-	else if (long_op == CIFS_LONG_OP)
-		timeout = 45 * HZ; /* should be greater than
-			servers oplock break timeout (about 43 seconds) */
-	else if (long_op == CIFS_BLOCKING_OP)
-		timeout = 0x7FFFFFFF; /* large but no so large as to wrap */
-	else {
-		cERROR(1, "unknown timeout flag %d", long_op);
-		rc = -EIO;
+	if (long_op == CIFS_ASYNC_OP)
 		goto out;
-	}
 
-	if (signal_pending(current)) {
-		/* if signal pending do not hold up user for full smb timeout
-		but we still give response a chance to complete */
-		timeout = 2 * HZ;
-	}
-
-	/* No user interrupts in wait - wreaks havoc with performance */
-	wait_for_response(ses, midQ, timeout, 10 * HZ);
+	rc = wait_for_response(ses->server, midQ);
+	if (rc != 0)
+		goto out;
 
 	rc = sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
@@ -915,8 +840,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 			}
 		}
 
-		/* Wait 5 seconds for the response. */
-		if (wait_for_response(ses, midQ, 5 * HZ, 5 * HZ) == 0) {
+		if (wait_for_response(ses->server, midQ) == 0) {
 			/* We got the response - restart system call. */
 			rstart = 1;
 		}
-- 
1.7.3.3
