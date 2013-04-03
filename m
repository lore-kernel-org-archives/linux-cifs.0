From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: on send failure, readjust server sequence number downward
Date: Wed,  3 Apr 2013 14:07:10 -0400
Message-ID: <1365012430-6795-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If sending a call to the server fails for some reason (for instance, the
sending thread caught a signal), then we must readjust the sequence
number downward again or the next send will have it too high.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb1ops.c   |  3 +++
 fs/cifs/transport.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 23bcd11..3efdb9d 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -61,6 +61,9 @@ send_nt_cancel(struct TCP_Server_Info *server, void *buf,
 	 */
 	--server->sequence_number;
 	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
+	if (rc < 0)
+		server->sequence_number--;
+
 	mutex_unlock(&server->srv_mutex);
 
 	cifs_dbg(FYI, "issued NT_CANCEL for mid %u, rc = %d\n",
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 653bf26..293d2c8 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -522,6 +522,9 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	rc = smb_send_rqst(server, rqst);
 	cifs_in_send_dec(server);
 	cifs_save_when_sent(mid);
+
+	if (rc < 0)
+		server->sequence_number -= 2;
 	mutex_unlock(&server->srv_mutex);
 
 	if (rc == 0)
@@ -711,6 +714,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	cifs_in_send_dec(ses->server);
 	cifs_save_when_sent(midQ);
 
+	if (rc < 0)
+		ses->server->sequence_number -= 2;
 	mutex_unlock(&ses->server->srv_mutex);
 
 	if (rc < 0) {
@@ -835,6 +840,10 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	cifs_in_send_dec(ses->server);
 	cifs_save_when_sent(midQ);
+
+	if (rc < 0)
+		ses->server->sequence_number -= 2;
+
 	mutex_unlock(&ses->server->srv_mutex);
 
 	if (rc < 0)
@@ -968,6 +977,10 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	cifs_in_send_dec(ses->server);
 	cifs_save_when_sent(midQ);
+
+	if (rc < 0)
+		ses->server->sequence_number -= 2;
+
 	mutex_unlock(&ses->server->srv_mutex);
 
 	if (rc < 0) {
-- 
1.7.11.7
