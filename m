From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 3/3] cifs: convert send_nt_cancel into a version specific op
Date: Wed, 16 May 2012 23:15:05 +0400
Message-ID: <1337195705-1381-4-git-send-email-piastry@etersoft.ru>
References: <1337195705-1381-1-git-send-email-piastry@etersoft.ru>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337195705-1381-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

For SMB2, this should be a no-op. Obviously if we wanted to do something
for the SMB2 case, we could also define an operation here for it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    6 +++++-
 fs/cifs/smb1ops.c   |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c |   46 ++++++++--------------------------------------
 3 files changed, 54 insertions(+), 39 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 812e22a..c41bf6d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -154,7 +154,12 @@ enum smb_version {
 	Smb_1 = 1,
 };
 
+struct mid_q_entry;
+struct TCP_Server_Info;
+
 struct smb_version_operations {
+	int (*send_cancel)(struct TCP_Server_Info *, void *,
+			   struct mid_q_entry *);
 };
 
 struct smb_version_values {
@@ -718,7 +723,6 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
 
 #endif
 
-struct mid_q_entry;
 
 /*
  * This is the prototype for the mid receive function. This function is for
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index d2850d1..fa486f0 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -18,8 +18,49 @@
  */
 
 #include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+
+/*
+ * An NT cancel request header looks just like the original request except:
+ *
+ * The Command is SMB_COM_NT_CANCEL
+ * The WordCount is zeroed out
+ * The ByteCount is zeroed out
+ *
+ * This function mangles an existing request buffer into a
+ * SMB_COM_NT_CANCEL request and then sends it.
+ */
+static int
+send_nt_cancel(struct TCP_Server_Info *server, void *buf,
+	       struct mid_q_entry *mid)
+{
+	int rc = 0;
+	struct smb_hdr *in_buf = (struct smb_hdr *)buf;
+
+	/* -4 for RFC1001 length and +2 for BCC field */
+	in_buf->smb_buf_length = cpu_to_be32(sizeof(struct smb_hdr) - 4  + 2);
+	in_buf->Command = SMB_COM_NT_CANCEL;
+	in_buf->WordCount = 0;
+	put_bcc(0, in_buf);
+
+	mutex_lock(&server->srv_mutex);
+	rc = cifs_sign_smb(in_buf, server, &mid->sequence_number);
+	if (rc) {
+		mutex_unlock(&server->srv_mutex);
+		return rc;
+	}
+	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
+	mutex_unlock(&server->srv_mutex);
+
+	cFYI(1, "issued NT_CANCEL for mid %u, rc = %d",
+		in_buf->Mid, rc);
+
+	return rc;
+}
 
 struct smb_version_operations smb1_operations = {
+	.send_cancel = send_nt_cancel,
 };
 
 struct smb_version_values smb1_values = {
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0961336..269a5a7 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -483,41 +483,11 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 	return rc;
 }
 
-/*
- * An NT cancel request header looks just like the original request except:
- *
- * The Command is SMB_COM_NT_CANCEL
- * The WordCount is zeroed out
- * The ByteCount is zeroed out
- *
- * This function mangles an existing request buffer into a
- * SMB_COM_NT_CANCEL request and then sends it.
- */
-static int
-send_nt_cancel(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
-		struct mid_q_entry *mid)
+static inline int
+send_cancel(struct TCP_Server_Info *server, void *buf, struct mid_q_entry *mid)
 {
-	int rc = 0;
-
-	/* -4 for RFC1001 length and +2 for BCC field */
-	in_buf->smb_buf_length = cpu_to_be32(sizeof(struct smb_hdr) - 4  + 2);
-	in_buf->Command = SMB_COM_NT_CANCEL;
-	in_buf->WordCount = 0;
-	put_bcc(0, in_buf);
-
-	mutex_lock(&server->srv_mutex);
-	rc = cifs_sign_smb(in_buf, server, &mid->sequence_number);
-	if (rc) {
-		mutex_unlock(&server->srv_mutex);
-		return rc;
-	}
-	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
-	mutex_unlock(&server->srv_mutex);
-
-	cFYI(1, "issued NT_CANCEL for mid %u, rc = %d",
-		in_buf->Mid, rc);
-
-	return rc;
+	return server->ops->send_cancel ?
+				server->ops->send_cancel(server, buf, mid) : 0;
 }
 
 int
@@ -636,7 +606,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
-		send_nt_cancel(ses->server, (struct smb_hdr *)buf, midQ);
+		send_cancel(ses->server, buf, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			midQ->callback = DeleteMidQEntry;
@@ -753,7 +723,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
-		send_nt_cancel(ses->server, in_buf, midQ);
+		send_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			/* no longer considered to be "in-flight" */
@@ -898,7 +868,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		if (in_buf->Command == SMB_COM_TRANSACTION2) {
 			/* POSIX lock. We send a NT_CANCEL SMB to cause the
 			   blocking lock to return. */
-			rc = send_nt_cancel(ses->server, in_buf, midQ);
+			rc = send_cancel(ses->server, in_buf, midQ);
 			if (rc) {
 				delete_mid(midQ);
 				return rc;
@@ -919,7 +889,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 		rc = wait_for_response(ses->server, midQ);
 		if (rc) {
-			send_nt_cancel(ses->server, in_buf, midQ);
+			send_cancel(ses->server, in_buf, midQ);
 			spin_lock(&GlobalMid_Lock);
 			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 				/* no longer considered to be "in-flight" */
-- 
1.7.1
