From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cifs: convert send_nt_cancel into a version specific op
Date: Fri, 11 May 2012 14:47:01 -0400
Message-ID: <1336762021-6954-4-git-send-email-jlayton@redhat.com>
References: <1336762021-6954-1-git-send-email-jlayton@redhat.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336762021-6954-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For SMB2, this should be a no-op. Obviously if we wanted to do something
for the SMB2 case, we could also define an operation here for it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    5 ++++-
 fs/cifs/smb1ops.c   |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c |   45 ++++++++-------------------------------------
 3 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3eae273..fcf3f91 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -155,8 +155,12 @@ enum smb_version {
 	Smb_21,
 };
 
+struct mid_q_entry;
+struct TCP_Server_Info;
+
 struct smb_version_operations {
 	char		*version_string;
+	int (*send_cancel)(struct TCP_Server_Info *server, struct smb_hdr *in_buf, struct mid_q_entry *mid);
 };
 
 struct smb_vol {
@@ -714,7 +718,6 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
 
 #endif
 
-struct mid_q_entry;
 
 /*
  * This is the prototype for the mid receive function. This function is for
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 5237591..033984b 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -18,7 +18,47 @@
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
+send_nt_cancel(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
+		struct mid_q_entry *mid)
+{
+	int rc = 0;
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
 
 struct smb_version_operations smb1_version_operations = {
 	.version_string = "1",
+	.send_cancel = send_nt_cancel,
 };
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0961336..6172a11 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -483,41 +483,12 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
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
+static inline int
+send_cancel(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
 		struct mid_q_entry *mid)
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
+			server->ops->send_cancel(server, in_buf, mid) : 0;
 }
 
 int
@@ -636,7 +607,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
-		send_nt_cancel(ses->server, (struct smb_hdr *)buf, midQ);
+		send_cancel(ses->server, (struct smb_hdr *)buf, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			midQ->callback = DeleteMidQEntry;
@@ -753,7 +724,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
-		send_nt_cancel(ses->server, in_buf, midQ);
+		send_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			/* no longer considered to be "in-flight" */
@@ -898,7 +869,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		if (in_buf->Command == SMB_COM_TRANSACTION2) {
 			/* POSIX lock. We send a NT_CANCEL SMB to cause the
 			   blocking lock to return. */
-			rc = send_nt_cancel(ses->server, in_buf, midQ);
+			rc = send_cancel(ses->server, in_buf, midQ);
 			if (rc) {
 				delete_mid(midQ);
 				return rc;
@@ -919,7 +890,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 		rc = wait_for_response(ses->server, midQ);
 		if (rc) {
-			send_nt_cancel(ses->server, in_buf, midQ);
+			send_cancel(ses->server, in_buf, midQ);
 			spin_lock(&GlobalMid_Lock);
 			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 				/* no longer considered to be "in-flight" */
-- 
1.7.7.6
