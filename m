From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] [SMB3] Fix reconnect to not defer smb3 session reconnect long after socket reconnect
Date: Thu, 23 Jun 2016 23:30:46 -0500
Message-ID: <1466742647-9805-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Azure server blocks clients that open a socket and don't do anything on it.
In our reconnect scenarios, we can reconnect the tcp session and
detect the socket is available but we defer the negprot and SMB3 session
setup and tree connect reconnection until the next i/o is requested, but
this looks suspicous to some servers who expect SMB3 negprog and session
setup soon after a socket is created.

In the echo thread, reconnect SMB3 sessions and tree connections
that are disconnected.  A later patch will replay persistent (and
resilient) handle opens.

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/connect.c |  4 +++-
 fs/cifs/smb2pdu.c | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 66736f5..7d2b15c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -428,7 +428,9 @@ cifs_echo_request(struct work_struct *work)
 	 * server->ops->need_neg() == true. Also, no need to ping if
 	 * we got a response recently.
 	 */
-	if (!server->ops->need_neg || server->ops->need_neg(server) ||
+
+	if (server->tcpStatus == CifsNeedReconnect ||
+	    server->tcpStatus == CifsExiting || server->tcpStatus == CifsNew ||
 	    (server->ops->can_echo && !server->ops->can_echo(server)) ||
 	    time_before(jiffies, server->lstrp + echo_interval - HZ))
 		goto requeue_echo;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8f38e33..4030cbd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1818,6 +1818,30 @@ SMB2_echo(struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "In echo request\n");
 
+	if (server->tcpStatus == CifsNeedNegotiate) {
+		struct list_head *tmp, *tmp2;
+		struct cifs_ses *ses;
+		struct cifs_tcon *tcon;
+
+		cifs_dbg(FYI, "Need negotiate, reconnecting tcons\n");
+		spin_lock(&cifs_tcp_ses_lock);
+		list_for_each(tmp, &server->smb_ses_list) {
+			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+			list_for_each(tmp2, &ses->tcon_list) {
+				tcon = list_entry(tmp2, struct cifs_tcon,
+						  tcon_list);
+				/* add check for persistent handle reconnect */
+				if (tcon && tcon->need_reconnect)
+					rc = smb2_reconnect(SMB2_ECHO, tcon);
+			}
+		}
+		spin_unlock(&cifs_tcp_ses_lock);
+	}
+
+	/* if no session, renegotiate failed above */
+	if (server->tcpStatus == CifsNeedNegotiate)
+		return -EIO;
+
 	rc = small_smb2_init(SMB2_ECHO, NULL, (void **)&req);
 	if (rc)
 		return rc;
-- 
1.9.1
