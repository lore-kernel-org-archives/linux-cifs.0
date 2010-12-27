From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/18] cifs: reconnect unresponsive servers
Date: Sun, 26 Dec 2010 21:30:03 -0500
Message-ID: <1293417006-6417-16-git-send-email-jlayton@redhat.com>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If the server isn't responding to echoes, we don't want to leave tasks
hung waiting for it to reply. At that point, we'll want to reconnect
so that soft mounts can return an error to userspace quickly.

If the client hasn't received a reply after a specified number of echo
intervals, assume that the transport is down and attempt to reconnect
the socket.

The number of echo_intervals to wait before attempting to reconnect is
tunable via a module parameter. Setting it to 0, means that the client
will never attempt to reconnect. The default is 5.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    5 +++++
 fs/cifs/cifsglob.h |    3 +++
 fs/cifs/connect.c  |   21 +++++++++++++++++----
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e0fabbf..27fa0a2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -80,6 +80,11 @@ bool sign_zero_copy = false;
 module_param(sign_zero_copy, bool, 0644);
 MODULE_PARM_DESC(sign_zero_copy, "Don't copy pages on write with signing "
 				 "enabled. Default: N");
+unsigned short echo_retries = 5;
+module_param(echo_retries, ushort, 0644);
+MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
+				 "reconnecting server. Default: 5. 0 means "
+				 "never reconnect.");
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 64d69f9..1dc74f4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -799,6 +799,9 @@ GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
 GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 GLOBAL_EXTERN bool sign_zero_copy; /* don't copy written pages with signing */
 
+/* reconnect after this many failed echo attempts */
+GLOBAL_EXTERN unsigned short echo_retries;
+
 void cifs_oplock_break(struct work_struct *work);
 void cifs_oplock_break_get(struct cifsFileInfo *cfile);
 void cifs_oplock_break_put(struct cifsFileInfo *cfile);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 57187c6..0e7ae1e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -186,6 +186,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	kfree(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
+	server->lstrp = jiffies;
 	mutex_unlock(&server->srv_mutex);
 
 	/* mark submitted MIDs for retry and issue callback */
@@ -420,7 +421,20 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 		smb_msg.msg_control = NULL;
 		smb_msg.msg_controllen = 0;
 		pdu_length = 4; /* enough to get RFC1001 header */
+
 incomplete_rcv:
+		if (echo_retries > 0 &&
+		    time_after(jiffies, server->lstrp +
+					(echo_retries * SMB_ECHO_INTERVAL))) {
+			cERROR(1, "Server %s has not responded in %d seconds. "
+				  "Reconnecting...", server->hostname,
+				  (echo_retries * SMB_ECHO_INTERVAL / HZ));
+			cifs_reconnect(server);
+			csocket = server->ssocket;
+			wake_up(&server->response_q);
+			continue;
+		}
+
 		length =
 		    kernel_recvmsg(csocket, &smb_msg,
 				&iov, 1, pdu_length, 0 /* BB other flags? */);
@@ -581,6 +595,8 @@ incomplete_rcv:
 		}
 
 		mid_entry = NULL;
+		server->lstrp = jiffies;
+
 		spin_lock(&GlobalMid_Lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
@@ -629,10 +645,6 @@ multi_t2_fnd:
 #ifdef CONFIG_CIFS_STATS2
 				mid_entry->when_received = jiffies;
 #endif
-				/* so we do not time out requests to  server
-				which is still responding (since server could
-				be busy but not dead) */
-				server->lstrp = jiffies;
 				break;
 			}
 			mid_entry = NULL;
@@ -1683,6 +1695,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		volume_info->target_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
 	tcp_ses->session_estab = false;
 	tcp_ses->sequence_number = 0;
+	tcp_ses->lstrp = jiffies;
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
-- 
1.7.3.4
