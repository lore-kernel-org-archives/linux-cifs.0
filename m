From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Avoid umount hangs with smb2 when server is unresponsive
Date: Thu,  3 Oct 2013 05:48:35 -0500
Message-ID: <1380797315-4996-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Do not send SMB2 Logoff command when reconnecting, the way smb1
code base works.

Also, no need to wait for a credit for an echo command when one is already
in flight.

Without these changes, umount command hangs if the server is unresponsive
e.g. hibernating.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2pdu.c   | 6 ++++++
 fs/cifs/transport.c | 9 +++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index eba0efd..edccb52 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -687,6 +687,10 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	else
 		return -EIO;
 
+	/* no need to send SMB logoff if uid already closed due to reconnect */
+	if (ses->need_reconnect)
+		goto smb2_session_already_dead;
+
 	rc = small_smb2_init(SMB2_LOGOFF, NULL, (void **) &req);
 	if (rc)
 		return rc;
@@ -701,6 +705,8 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	 * No tcon so can't do
 	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
 	 */
+
+smb2_session_already_dead:
 	return rc;
 }
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 6fdcb1b..800b938 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -410,8 +410,13 @@ static int
 wait_for_free_request(struct TCP_Server_Info *server, const int timeout,
 		      const int optype)
 {
-	return wait_for_free_credits(server, timeout,
-				server->ops->get_credits_field(server, optype));
+	int *val;
+
+	val = server->ops->get_credits_field(server, optype);
+	/* Since an echo is already inflight, no need to wait to send another */
+	if (*val <= 0 && optype == CIFS_ECHO_OP)
+		return -EAGAIN;
+	return wait_for_free_credits(server, timeout, val);
 }
 
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
-- 
1.8.1.2
