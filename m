From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 03/11] CIFS: Count blocking lock command
Date: Wed, 22 Feb 2012 10:32:56 +0300
Message-ID: <1329895984-9251-4-git-send-email-piastry@etersoft.ru>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329895984-9251-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to make sure we don't exceed the number of credits we have in this case.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/transport.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 44ac0aa..fa93720 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -279,15 +279,8 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
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
 			spin_unlock(&server->req_lock);
 			break;
 		}
@@ -816,7 +809,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, CIFS_BLOCKING_OP);
+	rc = wait_for_free_request(ses->server, 0);
 	if (rc)
 		return rc;
 
@@ -829,6 +822,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = allocate_mid(ses, in_buf, &midQ);
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
+		add_credits(ses->server, 1);
+		wake_up(&ses->server->request_q);
 		return rc;
 	}
 
@@ -836,6 +831,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		delete_mid(midQ);
 		mutex_unlock(&ses->server->srv_mutex);
+		add_credits(ses->server, 1);
+		wake_up(&ses->server->request_q);
 		return rc;
 	}
 
@@ -848,6 +845,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (rc < 0) {
 		delete_mid(midQ);
+		add_credits(ses->server, 1);
+		wake_up(&ses->server->request_q);
 		return rc;
 	}
 
@@ -869,6 +868,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			rc = send_nt_cancel(ses->server, in_buf, midQ);
 			if (rc) {
 				delete_mid(midQ);
+				add_credits(ses->server, 1);
+				wake_up(&ses->server->request_q);
 				return rc;
 			}
 		} else {
@@ -881,6 +882,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			   already been removed. Don't exit in this case. */
 			if (rc && rc != -ENOLCK) {
 				delete_mid(midQ);
+				add_credits(ses->server, 1);
+				wake_up(&ses->server->request_q);
 				return rc;
 			}
 		}
@@ -893,6 +896,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 				/* no longer considered to be "in-flight" */
 				midQ->callback = DeleteMidQEntry;
 				spin_unlock(&GlobalMid_Lock);
+				add_credits(ses->server, 1);
+				wake_up(&ses->server->request_q);
 				return rc;
 			}
 			spin_unlock(&GlobalMid_Lock);
@@ -903,8 +908,11 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
-	if (rc != 0)
+	if (rc != 0) {
+		add_credits(ses->server, 1);
+		wake_up(&ses->server->request_q);
 		return rc;
+	}
 
 	/* rcvd frame is ok */
 	if (out_buf == NULL || midQ->midState != MID_RESPONSE_RECEIVED) {
@@ -918,6 +926,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
+	add_credits(ses->server, 1);
+	wake_up(&ses->server->request_q);
 	if (rstart && rc == -EACCES)
 		return -ERESTARTSYS;
 	return rc;
-- 
1.7.1
