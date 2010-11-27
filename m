From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH 12/14] cifs: reconnect unresponsive servers
Date: Sat, 27 Nov 2010 08:01:24 -0500
Message-ID: <1290862886-2914-13-git-send-email-jlayton@redhat.com>
References: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290862886-2914-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

MS-CIFS says:

    "The server MUST NOT disconnect clients that have been inactive less
     than 5 minutes."

Using that guideline, perform a reconnect to any server that hasn't
responded in the last 5 minutes. Eventually, we may want to make this
tunable, but it seems like a reasonable default.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9c90f1d..ece7275 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -55,6 +55,9 @@
 /* SMB echo every 60s -- FIXME: tunable? */
 #define SMB_ECHO_INTERVAL (60 * HZ)
 
+/* reconnect if no response from server in this time period */
+#define UNRESPONSIVE_SERVER_TIMEOUT (5 * 60 * HZ)
+
 extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
 			 unsigned char *p24);
 
@@ -183,6 +186,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	kfree(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
+	server->lstrp = jiffies;
 
 	INIT_LIST_HEAD(&dispose);
 	spin_lock(&GlobalMid_Lock);
@@ -436,6 +440,16 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 		smb_msg.msg_control = NULL;
 		smb_msg.msg_controllen = 0;
 		pdu_length = 4; /* enough to get RFC1001 header */
+
+		if (time_after(jiffies,
+			       server->lstrp + UNRESPONSIVE_SERVER_TIMEOUT)) {
+			cFYI(1, "Reconnecting unresponsive server %s",
+				server->hostname);
+			cifs_reconnect(server);
+			csocket = server->ssocket;
+			wake_up(&server->response_q);
+			continue;
+		}
 incomplete_rcv:
 		length =
 		    kernel_recvmsg(csocket, &smb_msg,
@@ -597,6 +611,8 @@ incomplete_rcv:
 		}
 
 		mid_entry = NULL;
+		server->lstrp = jiffies;
+
 		spin_lock(&GlobalMid_Lock);
 		list_for_each(tmp, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
@@ -647,10 +663,6 @@ multi_t2_fnd:
 #ifdef CONFIG_CIFS_STATS2
 				mid_entry->when_received = jiffies;
 #endif
-				/* so we do not time out requests to  server
-				which is still responding (since server could
-				be busy but not dead) */
-				server->lstrp = jiffies;
 				break;
 			}
 next_mid:
@@ -1704,6 +1716,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		volume_info->target_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
 	tcp_ses->session_estab = false;
 	tcp_ses->sequence_number = 0;
+	tcp_ses->lstrp = jiffies;
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
-- 
1.7.3.2
