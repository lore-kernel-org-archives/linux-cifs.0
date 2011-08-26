From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/16] cifs: check for unresponsive server every time we call kernel_recvmsg
Date: Fri, 26 Aug 2011 15:06:18 -0400
Message-ID: <1314385589-27136-6-git-send-email-jlayton@redhat.com>
References: <1314385589-27136-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314385589-27136-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If the server stops sending data while in the middle of sending a
response then we still want to reconnect it if it doesn't come back.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 012d970..e899fec 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -358,6 +358,23 @@ allocate_buffers(char **bigbuf, char **smallbuf, unsigned int size,
 	return true;
 }
 
+static bool
+server_unresponsive(struct TCP_Server_Info *server)
+{
+	if (echo_retries > 0 && server->tcpStatus == CifsGood &&
+	    time_after(jiffies, server->lstrp +
+				(echo_retries * SMB_ECHO_INTERVAL))) {
+		cERROR(1, "Server %s has not responded in %d seconds. "
+			  "Reconnecting...", server->hostname,
+			  (echo_retries * SMB_ECHO_INTERVAL / HZ));
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return true;
+	}
+
+	return false;
+}
+
 static int
 read_from_socket(struct TCP_Server_Info *server,
 		 struct kvec *iov, unsigned int to_read,
@@ -372,6 +389,11 @@ read_from_socket(struct TCP_Server_Info *server,
 	smb_msg.msg_controllen = 0;
 
 	for (total_read = 0; total_read < to_read; total_read += length) {
+		if (server_unresponsive(server)) {
+			rc = 1;
+			break;
+		}
+
 		length = kernel_recvmsg(server->ssocket, &smb_msg, iov, 1,
 					to_read - total_read, 0);
 		if (server->tcpStatus == CifsExiting) {
@@ -669,17 +691,6 @@ cifs_demultiplex_thread(void *p)
 		pdu_length = 4; /* enough to get RFC1001 header */
 
 incomplete_rcv:
-		if (echo_retries > 0 && server->tcpStatus == CifsGood &&
-		    time_after(jiffies, server->lstrp +
-					(echo_retries * SMB_ECHO_INTERVAL))) {
-			cERROR(1, "Server %s has not responded in %d seconds. "
-				  "Reconnecting...", server->hostname,
-				  (echo_retries * SMB_ECHO_INTERVAL / HZ));
-			cifs_reconnect(server);
-			wake_up(&server->response_q);
-			continue;
-		}
-
 		rc = read_from_socket(server, &iov, pdu_length,
 				      &total_read, true /* header read */);
 		if (rc == 3)
-- 
1.7.6
