From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/18] cifs: move locked sections out of DeleteMidQEntry and AllocMidQEntry
Date: Sun, 26 Dec 2010 21:29:53 -0500
Message-ID: <1293417006-6417-6-git-send-email-jlayton@redhat.com>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In later patches, we're going to need to have finer-grained control
over the addition and removal of these structs from the pending_mid_q
and we'll need to be able to call the destructor while holding the
spinlock. Move the locked sections out of both routines and into
the callers. Fix up current callers of DeleteMidQEntry to call a new
routine that dequeues the entry and then destroys it.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |   41 ++++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b9eb0cf..801726b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -63,9 +63,6 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 
 	atomic_inc(&midCount);
 	temp->midState = MID_REQUEST_ALLOCATED;
-	spin_lock(&GlobalMid_Lock);
-	list_add_tail(&temp->qhead, &server->pending_mid_q);
-	spin_unlock(&GlobalMid_Lock);
 	return temp;
 }
 
@@ -75,10 +72,7 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 #ifdef CONFIG_CIFS_STATS2
 	unsigned long now;
 #endif
-	spin_lock(&GlobalMid_Lock);
 	midEntry->midState = MID_FREE;
-	list_del(&midEntry->qhead);
-	spin_unlock(&GlobalMid_Lock);
 	atomic_dec(&midCount);
 	if (midEntry->largeBuf)
 		cifs_buf_release(midEntry->resp_buf);
@@ -103,6 +97,16 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	mempool_free(midEntry, cifs_mid_poolp);
 }
 
+static void
+delete_mid(struct mid_q_entry *mid)
+{
+	spin_lock(&GlobalMid_Lock);
+	list_del(&mid->qhead);
+	spin_unlock(&GlobalMid_Lock);
+
+	DeleteMidQEntry(mid);
+}
+
 static int
 smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 {
@@ -308,6 +312,9 @@ static int allocate_mid(struct cifsSesInfo *ses, struct smb_hdr *in_buf,
 	*ppmidQ = AllocMidQEntry(in_buf, ses->server);
 	if (*ppmidQ == NULL)
 		return -ENOMEM;
+	spin_lock(&GlobalMid_Lock);
+	list_add_tail(&(*ppmidQ)->qhead, &ses->server->pending_mid_q);
+	spin_unlock(&GlobalMid_Lock);
 	return 0;
 }
 
@@ -508,7 +515,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 			}
 		}
 		spin_unlock(&GlobalMid_Lock);
-		DeleteMidQEntry(midQ);
+		delete_mid(midQ);
 		/* Update # of requests on wire to server */
 		atomic_dec(&ses->server->inFlight);
 		wake_up(&ses->server->request_q);
@@ -564,14 +571,14 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		if ((flags & CIFS_NO_RESP) == 0)
 			midQ->resp_buf = NULL;  /* mark it so buf will
 						   not be freed by
-						   DeleteMidQEntry */
+						   delete_mid */
 	} else {
 		rc = -EIO;
 		cFYI(1, "Bad MID state?");
 	}
 
 out:
-	DeleteMidQEntry(midQ);
+	delete_mid(midQ);
 	atomic_dec(&ses->server->inFlight);
 	wake_up(&ses->server->request_q);
 
@@ -699,7 +706,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 			}
 		}
 		spin_unlock(&GlobalMid_Lock);
-		DeleteMidQEntry(midQ);
+		delete_mid(midQ);
 		/* Update # of requests on wire to server */
 		atomic_dec(&ses->server->inFlight);
 		wake_up(&ses->server->request_q);
@@ -755,7 +762,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 	}
 
 out:
-	DeleteMidQEntry(midQ);
+	delete_mid(midQ);
 	atomic_dec(&ses->server->inFlight);
 	wake_up(&ses->server->request_q);
 
@@ -863,7 +870,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 
 	rc = cifs_sign_smb(in_buf, ses->server, &midQ->sequence_number);
 	if (rc) {
-		DeleteMidQEntry(midQ);
+		delete_mid(midQ);
 		mutex_unlock(&ses->server->srv_mutex);
 		return rc;
 	}
@@ -880,7 +887,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 	mutex_unlock(&ses->server->srv_mutex);
 
 	if (rc < 0) {
-		DeleteMidQEntry(midQ);
+		delete_mid(midQ);
 		return rc;
 	}
 
@@ -902,7 +909,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 
 			rc = send_nt_cancel(tcon, in_buf, midQ);
 			if (rc) {
-				DeleteMidQEntry(midQ);
+				delete_mid(midQ);
 				return rc;
 			}
 		} else {
@@ -914,7 +921,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 			/* If we get -ENOLCK back the lock may have
 			   already been removed. Don't exit in this case. */
 			if (rc && rc != -ENOLCK) {
-				DeleteMidQEntry(midQ);
+				delete_mid(midQ);
 				return rc;
 			}
 		}
@@ -951,7 +958,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 			}
 		}
 		spin_unlock(&GlobalMid_Lock);
-		DeleteMidQEntry(midQ);
+		delete_mid(midQ);
 		return rc;
 	}
 
@@ -1001,7 +1008,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 		BCC(out_buf) = le16_to_cpu(BCC_LE(out_buf));
 
 out:
-	DeleteMidQEntry(midQ);
+	delete_mid(midQ);
 	if (rstart && rc == -EACCES)
 		return -ERESTARTSYS;
 	return rc;
-- 
1.7.3.4
