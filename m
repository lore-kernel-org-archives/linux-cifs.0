From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 17/18] cifs: mangle existing header for SMB_COM_NT_CANCEL
Date: Sun, 26 Dec 2010 21:30:05 -0500
Message-ID: <1293417006-6417-18-git-send-email-jlayton@redhat.com>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The NT_CANCEL command looks just like the original command, except for a
few small differences. The send_nt_cancel function however currently takes
a tcon, which we don't have in SendReceive and SendReceive2.

Instead of "respinning" the entire header for an NT_CANCEL, just mangle
the existing header by replacing just the fields we need. This means we
don't need a tcon and allows us to call it from other places.

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |   63 ++++++++++++++++++++++++++++++--------------------
 1 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f769047..1488b7e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -464,6 +464,43 @@ sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 	return rc;
 }
 
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
+	in_buf->smb_buf_length = sizeof(struct smb_hdr) - 4  + 2;
+	in_buf->Command = SMB_COM_NT_CANCEL;
+	in_buf->WordCount = 0;
+	BCC_LE(in_buf) = 0;
+
+	mutex_lock(&server->srv_mutex);
+	rc = cifs_sign_smb(in_buf, server, &mid->sequence_number);
+	if (rc) {
+		mutex_unlock(&server->srv_mutex);
+		return rc;
+	}
+	rc = smb_send(server, in_buf, in_buf->smb_buf_length);
+	mutex_unlock(&server->srv_mutex);
+
+	cFYI(1, "issued NT_CANCEL for mid %u, rc = %d",
+		in_buf->Mid, rc);
+
+	return rc;
+}
+
 int
 SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	     struct kvec *iov, int n_vec, int *pRespBufType /* ret */,
@@ -772,29 +809,6 @@ out:
 	return rc;
 }
 
-/* Send an NT_CANCEL SMB to cause the POSIX blocking lock to return. */
-
-static int
-send_nt_cancel(struct cifsTconInfo *tcon, struct smb_hdr *in_buf,
-		struct mid_q_entry *midQ)
-{
-	int rc = 0;
-	struct cifsSesInfo *ses = tcon->ses;
-	__u16 mid = in_buf->Mid;
-
-	header_assemble(in_buf, SMB_COM_NT_CANCEL, tcon, 0);
-	in_buf->Mid = mid;
-	mutex_lock(&ses->server->srv_mutex);
-	rc = cifs_sign_smb(in_buf, ses->server, &midQ->sequence_number);
-	if (rc) {
-		mutex_unlock(&ses->server->srv_mutex);
-		return rc;
-	}
-	rc = smb_send(ses->server, in_buf, in_buf->smb_buf_length);
-	mutex_unlock(&ses->server->srv_mutex);
-	return rc;
-}
-
 /* We send a LOCKINGX_CANCEL_LOCK to cause the Windows
    blocking lock to return. */
 
@@ -909,8 +923,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 		if (in_buf->Command == SMB_COM_TRANSACTION2) {
 			/* POSIX lock. We send a NT_CANCEL SMB to cause the
 			   blocking lock to return. */
-
-			rc = send_nt_cancel(tcon, in_buf, midQ);
+			rc = send_nt_cancel(ses->server, in_buf, midQ);
 			if (rc) {
 				delete_mid(midQ);
 				return rc;
-- 
1.7.3.4
