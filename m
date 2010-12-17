From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 18/18] cifs: send an NT_CANCEL request when a process is signalled
Date: Fri, 17 Dec 2010 10:08:17 -0500
Message-ID: <1292598497-29796-19-git-send-email-jlayton@redhat.com>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use the new send_nt_cancel function to send an NT_CANCEL when the
process is delivered a fatal signal. This is a "best effort" enterprise
however, so don't bother to check the return code. There's nothing we
can reasonably do if it fails anyway.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 1488b7e..e2e66f3 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -570,20 +570,25 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 #endif
 
 	mutex_unlock(&ses->server->srv_mutex);
-	cifs_small_buf_release(in_buf);
 
-	if (rc < 0)
+	if (rc < 0) {
+		cifs_small_buf_release(in_buf);
 		goto out;
+	}
 
-	if (long_op == CIFS_ASYNC_OP)
+	if (long_op == CIFS_ASYNC_OP) {
+		cifs_small_buf_release(in_buf);
 		goto out;
+	}
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
+		send_nt_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->midState == MID_REQUEST_SUBMITTED) {
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
+			cifs_small_buf_release(in_buf);
 		        atomic_dec(&ses->server->inFlight);
 			wake_up(&ses->server->request_q);
 			return rc;
@@ -591,6 +596,8 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		spin_unlock(&GlobalMid_Lock);
 	}
 
+	cifs_small_buf_release(in_buf);
+
 	rc = sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
 		atomic_dec(&ses->server->inFlight);
@@ -735,6 +742,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
+		send_nt_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->midState == MID_REQUEST_SUBMITTED) {
 			/* no longer considered to be "in-flight" */
@@ -944,6 +952,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 
 		rc = wait_for_response(ses->server, midQ);
 		if (rc) {
+			send_nt_cancel(ses->server, in_buf, midQ);
 			spin_lock(&GlobalMid_Lock);
 			if (midQ->midState == MID_REQUEST_SUBMITTED) {
 				/* no longer considered to be "in-flight" */
-- 
1.7.3.3
