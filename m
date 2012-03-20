From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v3 04/10] CIFS: Prepare credits code for a slot reservation
Date: Tue, 20 Mar 2012 13:00:34 +0300
Message-ID: <1332237640-10145-5-git-send-email-piastry@etersoft.ru>
References: <1332237640-10145-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332237640-10145-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that is essential for CIFS/SMB/SMB2 oplock breaks and SMB2 echos.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   14 ++++++++++++--
 fs/cifs/transport.c |   22 ++++++++++++++--------
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d55de96..2309a67 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -315,12 +315,22 @@ in_flight(struct TCP_Server_Info *server)
 	return num;
 }
 
+static inline int*
+get_credits_field(struct TCP_Server_Info *server)
+{
+	/*
+	 * This will change to switch statement when we reserve slots for echos
+	 * and oplock breaks.
+	 */
+	return &server->credits;
+}
+
 static inline bool
-has_credits(struct TCP_Server_Info *server)
+has_credits(struct TCP_Server_Info *server, int *credits)
 {
 	int num;
 	spin_lock(&server->req_lock);
-	num = server->credits;
+	num = *credits;
 	spin_unlock(&server->req_lock);
 	return num > 0;
 }
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 58b31da..310918b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -255,26 +255,26 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 }
 
 static int
-wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
+wait_for_free_credits(struct TCP_Server_Info *server, const int optype,
+		      int *credits)
 {
 	int rc;
 
 	spin_lock(&server->req_lock);
-
-	if (long_op == CIFS_ASYNC_OP) {
+	if (optype == CIFS_ASYNC_OP) {
 		/* oplock breaks must not be held up */
 		server->in_flight++;
-		server->credits--;
+		*credits -= 1;
 		spin_unlock(&server->req_lock);
 		return 0;
 	}
 
 	while (1) {
-		if (server->credits <= 0) {
+		if (*credits <= 0) {
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
 			rc = wait_event_killable(server->request_q,
-						 has_credits(server));
+						 has_credits(server, credits));
 			cifs_num_waiters_dec(server);
 			if (rc)
 				return rc;
@@ -291,8 +291,8 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 			 */
 
 			/* update # of requests on the wire to server */
-			if (long_op != CIFS_BLOCKING_OP) {
-				server->credits--;
+			if (optype != CIFS_BLOCKING_OP) {
+				*credits -= 1;
 				server->in_flight++;
 			}
 			spin_unlock(&server->req_lock);
@@ -302,6 +302,12 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 	return 0;
 }
 
+static int
+wait_for_free_request(struct TCP_Server_Info *server, const int optype)
+{
+	return wait_for_free_credits(server, optype, get_credits_field(server));
+}
+
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 			struct mid_q_entry **ppmidQ)
 {
-- 
1.7.1
