From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 05/53] CIFS: wait_for_free_request needs to wait on credits returned by server (for SMB2)
Date: Tue, 25 Oct 2011 10:11:38 +0400
Message-ID: <1319523146-2859-6-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

wait_for_free_request is called to ensure that we don't have more than the
configured maximum of requests in flight on the wire (for cifs), but for SMB2,
the number of requests that can be in flight varies dynamically (the client
may request that the server grant more "credits" in a request, and each
request uses at least one credit).   Instead of migrating over the original
smb2_wait_for_free_request function, simply add a check in cifs's original
wait_for_free_request for the is_smb2 case to make sure that we don't go
beyond the number of allocated "credits" (ie those that remain from those
the server has allocated for this tcp session).  Otherwise the logic is unchanged
(other than to make it extern so that the next function to be added, smb2_sendrcv2
in  smbtransport.c can call it - smb2_sendrcv2 will be migrated over in the next patch).

Note that smb2 servers will typically allow many more requests in flight at one time
than cifs servers (which usually default to only 50) and can adjust this as needed.
This should provide significant performance benefit in some workloads (ie smb2
in many cases will get more parallelism than cifs and some other protocols
since some artificially constrain the maximum number of requests).

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/transport.c |   22 +++++++++++++++++++---
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 179b784..b440329 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -311,6 +311,7 @@ struct TCP_Server_Info {
 	wait_queue_head_t read_q; /* used by readpages */
 	atomic_t active_readpage_req; /* used by readpages */
 	atomic_t resp_rdy; /* used by readpages and demultiplex */
+	atomic_t credits;  /* send no more simultaneous requests than this */
 	__le16 smb2_dialect_revision; /* SMB2.0 implemented, 2.1 recognized */
 	struct task_struct *observe;
 	char smb2_crypt_key[CIFS_CRYPTO_KEY_SIZE]; /* BB can we use cifs key */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ef4f631..823597a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -68,6 +68,7 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
+extern int wait_for_free_request(struct TCP_Server_Info *sv, const int long_op);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
 			   mid_callback_t *callback, void *cbdata,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0cc9584..25d04df 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -254,7 +254,7 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 	return smb_sendv(server, &iov, 1);
 }
 
-static int wait_for_free_request(struct TCP_Server_Info *server,
+int wait_for_free_request(struct TCP_Server_Info *server,
 				 const int long_op)
 {
 	if (long_op == CIFS_ASYNC_OP) {
@@ -265,7 +265,8 @@ static int wait_for_free_request(struct TCP_Server_Info *server,
 
 	spin_lock(&GlobalMid_Lock);
 	while (1) {
-		if (atomic_read(&server->inFlight) >= cifs_max_pending) {
+		if ((server->is_smb2 == false) &&
+		    atomic_read(&server->inFlight) >= cifs_max_pending) {
 			spin_unlock(&GlobalMid_Lock);
 			cifs_num_waiters_inc(server);
 			wait_event(server->request_q,
@@ -273,6 +274,16 @@ static int wait_for_free_request(struct TCP_Server_Info *server,
 				     < cifs_max_pending);
 			cifs_num_waiters_dec(server);
 			spin_lock(&GlobalMid_Lock);
+#ifdef CONFIG_CIFS_SMB2
+		} else if (server->is_smb2 &&
+			  (atomic_read(&server->credits) < 1)) {
+			spin_unlock(&GlobalMid_Lock);
+			cifs_num_waiters_inc(server);
+			wait_event(server->request_q,
+				   atomic_read(&server->credits) > 0);
+			cifs_num_waiters_dec(server);
+			spin_lock(&GlobalMid_Lock);
+#endif /* CONFIG_CIFS_SMB2 */
 		} else {
 			if (server->tcpStatus == CifsExiting) {
 				spin_unlock(&GlobalMid_Lock);
@@ -283,8 +294,13 @@ static int wait_for_free_request(struct TCP_Server_Info *server,
 			   as they are allowed to block on server */
 
 			/* update # of requests on the wire to server */
-			if (long_op != CIFS_BLOCKING_OP)
+			if (server->is_smb2 == false &&
+			    long_op != CIFS_BLOCKING_OP)
 				atomic_inc(&server->inFlight);
+#ifdef CONFIG_CIFS_SMB2
+			else if (server->is_smb2)
+				atomic_dec(&server->credits);
+#endif
 			spin_unlock(&GlobalMid_Lock);
 			break;
 		}
-- 
1.7.1
