From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/18] cifs: handle cancelled requests better
Date: Fri, 17 Dec 2010 10:08:10 -0500
Message-ID: <1292598497-29796-12-git-send-email-jlayton@redhat.com>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, when a request is cancelled via signal, we delete the mid
immediately. If the request was already transmitted however, the client
is still likely to receive a response. When it does, it won't recognize
it however and will pop a printk.

It's also a little dangerous to just delete the mid entry like this. We
may end up reusing that mid. If we do then we could potentially get the
response from the first request confused with the later one.

Prevent the reuse of mids by marking them as cancelled and keeping them
on the pending_mid_q list. If the reply comes in, we'll delete it from
the list then. If it never comes, then we'll delete it at reconnect
or when cifsd comes down.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index d77b615..ad78cbd 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -486,8 +486,17 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		goto out;
 
 	rc = wait_for_response(ses->server, midQ);
-	if (rc != 0)
-		goto out;
+	if (rc != 0) {
+		spin_lock(&GlobalMid_Lock);
+		if (midQ->midState == MID_REQUEST_SUBMITTED) {
+			midQ->callback = DeleteMidQEntry;
+			spin_unlock(&GlobalMid_Lock);
+		        atomic_dec(&ses->server->inFlight);
+			wake_up(&ses->server->request_q);
+			return rc;
+		}
+		spin_unlock(&GlobalMid_Lock);
+	}
 
 	rc = sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
@@ -632,8 +641,18 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		goto out;
 
 	rc = wait_for_response(ses->server, midQ);
-	if (rc != 0)
-		goto out;
+	if (rc != 0) {
+		spin_lock(&GlobalMid_Lock);
+		if (midQ->midState == MID_REQUEST_SUBMITTED) {
+			/* no longer considered to be "in-flight" */
+			midQ->callback = DeleteMidQEntry;
+			spin_unlock(&GlobalMid_Lock);
+		        atomic_dec(&ses->server->inFlight);
+			wake_up(&ses->server->request_q);
+			return rc;
+		}
+		spin_unlock(&GlobalMid_Lock);
+	}
 
 	rc = sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
@@ -854,10 +873,20 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 			}
 		}
 
-		if (wait_for_response(ses->server, midQ) == 0) {
-			/* We got the response - restart system call. */
-			rstart = 1;
+		rc = wait_for_response(ses->server, midQ);
+		if (rc) {
+			spin_lock(&GlobalMid_Lock);
+			if (midQ->midState == MID_REQUEST_SUBMITTED) {
+				/* no longer considered to be "in-flight" */
+				midQ->callback = DeleteMidQEntry;
+				spin_unlock(&GlobalMid_Lock);
+				return rc;
+			}
+			spin_unlock(&GlobalMid_Lock);
 		}
+
+		/* We got the response - restart system call. */
+		rstart = 1;
 	}
 
 	rc = sync_mid_result(midQ, ses->server);
-- 
1.7.3.3
