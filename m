From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/13] cifs: reconnect unresponsive servers
Date: Fri, 10 Dec 2010 10:44:36 -0500
Message-ID: <1291995877-2276-13-git-send-email-jlayton@redhat.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If the server isn't responding to echoes, we don't want to leave tasks
hung waiting for it to reply. At that point, we'll want to reconnect
so that soft mounts can return an error to userspace quickly.

If the client hasn't received a reply after 3 echo intervals, assume
that the transport is down and attempt to reconnect the socket.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 98e1d38..c596515 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -55,6 +55,9 @@
 /* SMB echo "timeout" -- FIXME: tunable? */
 #define SMB_ECHO_INTERVAL (30 * HZ)
 
+/* reconnect if no response from server in this time period */
+#define UNRESPONSIVE_SERVER_TIMEOUT (3 * SMB_ECHO_INTERVAL)
+
 extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
 			 unsigned char *p24);
 
@@ -187,6 +190,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	kfree(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
+	server->lstrp = jiffies;
 	mutex_unlock(&server->srv_mutex);
 
 	/*
@@ -442,7 +446,19 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 		smb_msg.msg_control = NULL;
 		smb_msg.msg_controllen = 0;
 		pdu_length = 4; /* enough to get RFC1001 header */
+
 incomplete_rcv:
+		if (time_after(jiffies,
+			       server->lstrp + UNRESPONSIVE_SERVER_TIMEOUT)) {
+			cERROR(1, "Server %s has not responded in %d seconds. "
+				  "Reconnecting...", server->hostname,
+				  UNRESPONSIVE_SERVER_TIMEOUT / HZ);
+			cifs_reconnect(server);
+			csocket = server->ssocket;
+			wake_up(&server->response_q);
+			continue;
+		}
+
 		length =
 		    kernel_recvmsg(csocket, &smb_msg,
 				&iov, 1, pdu_length, 0 /* BB other flags? */);
@@ -603,6 +619,8 @@ incomplete_rcv:
 		}
 
 		mid_entry = NULL;
+		server->lstrp = jiffies;
+
 		spin_lock(&GlobalMid_Lock);
 		list_for_each(tmp, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
@@ -653,10 +671,6 @@ multi_t2_fnd:
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
@@ -1724,6 +1738,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		volume_info->target_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
 	tcp_ses->session_estab = false;
 	tcp_ses->sequence_number = 0;
+	tcp_ses->lstrp = jiffies;
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
-- 
1.7.3.2
