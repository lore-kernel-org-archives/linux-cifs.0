From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] wait_for_free_request needs to wait on credits returned by
 server for SMB2
Date: Sat, 12 Mar 2011 17:48:13 -0600
Message-ID: <AANLkTimsJ+vQm7XuVk2NHneRc04CeWebuG3jsLxML4sd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

wait_for_free_request is called to ensure that we don't have more than
the configured maximum of requests in flight on the wire (for cifs),
but for SMB2, the number of requests that can be in flight varies
dynamically (the client may request that the server grant more
"credits" in a request, and each request uses at least one credit).
Instead of migrating over the original smb2_wait_for_free_request,
simply add a check in cifs's original wait_for_free_request for the
is_smb2 case to make sure that we don't go beyond the number of
allocated "credits" (ie those that remain from those the server has
allocated for this tcp session).  Otherwise the logic is unchanged
(other than to make it extern so that the next function to be added,
smb2_sendrcv2 in  smbtransport.c can call it - smb2_sendrcv2 will be
migrated over in the next patch).

Note that smb2 servers will typically allow many more requests in
flight at one time than cifs servers (which usually default to only
50) and can adjust this as needed.  This should provide significant
performance benefit in some workloads (for smb2 over cifs and some
other protocols which overly constrain the maximum number of
requests).

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 095cec7..73fe746 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -64,6 +64,7 @@ extern char *cifs_compose_mount_options(const char
*sb_mountdata,
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
+extern int wait_for_free_request(struct TCP_Server_Info *sv, const
int long_op);
 extern int cifs_call_async(struct TCP_Server_Info *server,
 			   struct smb_hdr *in_buf, mid_callback_t *callback,
 			   void *cbdata);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index bce3cf9..0dd675c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -189,7 +189,6 @@ extern int new_read_req(struct kvec *iov, struct
cifs_tcon *tcon,
 			int request_type);
 extern int smb2_sendv(struct TCP_Server_Info *server, struct kvec *iov,
 		      int n_vec);
-extern int wait_for_free_request(struct cifs_ses *ses, const int long_op);
 extern int smb2_wait_on_complex_mid(struct cifs_ses *ses,
 				    struct mid_q_entry *mid,
 				    unsigned long timeout,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 29dd7ed..1a2930d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -260,7 +260,7 @@ smb_send(struct TCP_Server_Info *server, struct
smb_hdr *smb_buffer,
 	return smb_sendv(server, &iov, 1);
 }

-static int wait_for_free_request(struct TCP_Server_Info *server,
+int wait_for_free_request(struct TCP_Server_Info *server,
 				 const int long_op)
 {
 	if (long_op == CIFS_ASYNC_OP) {
@@ -271,7 +271,8 @@ static int wait_for_free_request(struct
TCP_Server_Info *server,

 	spin_lock(&GlobalMid_Lock);
 	while (1) {
-		if (atomic_read(&server->inFlight) >= cifs_max_pending) {
+		if ((server->is_smb2 == false) &&
+		    atomic_read(&server->inFlight) >= cifs_max_pending) {
 			spin_unlock(&GlobalMid_Lock);
 #ifdef CONFIG_CIFS_STATS2
 			atomic_inc(&server->num_waiters);
@@ -283,6 +284,20 @@ static int wait_for_free_request(struct
TCP_Server_Info *server,
 			atomic_dec(&server->num_waiters);
 #endif
 			spin_lock(&GlobalMid_Lock);
+#ifdef CONFIG_CIFS_SMB2
+		} else if (server->is_smb2 &&
+			  (atomic_read(&server->credits) < 1)) {
+			spin_unlock(&GlobalMid_Lock);
+#ifdef CONFIG_CIFS_STATS2
+			atomic_inc(&server->num_waiters);
+#endif
+			wait_event(server->request_q,
+				   atomic_read(&server->credits) > 0);
+#ifdef CONFIG_CIFS_STATS2
+			atomic_dec(&server->num_waiters);
+#endif
+			spin_lock(&GlobalMid_Lock);
+#endif /* CONFIG_CIFS_SMB2 */
 		} else {
 			if (server->tcpStatus == CifsExiting) {
 				spin_unlock(&GlobalMid_Lock);

-- 
Thanks,

Steve
