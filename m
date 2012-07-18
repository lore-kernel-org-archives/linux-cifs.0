From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/11] cifs: convert send code to use smb_rqst structs
Date: Wed, 18 Jul 2012 13:58:59 -0400
Message-ID: <1342634346-22818-5-git-send-email-jlayton@redhat.com>
References: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342634346-22818-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Again, just a change in the arguments and some function renaming here.
In later patches, we'll change this code to deal with page arrays.

In this patch, we add a new smb_send_rqst wrapper and have smb_sendv
call that. Then we move most of the existing smb_sendv code into a new
function -- smb_send_kvec. This seems a little redundant, but later
we'll flesh this out to deal with arrays of pages.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |  135 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 90 insertions(+), 45 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 531da42..5a1d817 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -120,18 +120,29 @@ delete_mid(struct mid_q_entry *mid)
 	DeleteMidQEntry(mid);
 }
 
+/*
+ * smb_send_kvec - send an array of kvecs to the server
+ * @server:	Server to send the data to
+ * @iov:	Pointer to array of kvecs
+ * @n_vec:	length of kvec array
+ * @sent:	amount of data sent on socket is stored here
+ *
+ * Our basic "send data to server" function. Should be called with srv_mutex
+ * held. The caller is responsible for handling the results.
+ */
 static int
-smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
+smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov, size_t n_vec,
+		size_t *sent)
 {
 	int rc = 0;
 	int i = 0;
 	struct msghdr smb_msg;
-	unsigned int len = iov[0].iov_len;
-	unsigned int total_len;
-	int first_vec = 0;
-	unsigned int smb_buf_length = get_rfc1002_length(iov[0].iov_base);
+	unsigned int remaining;
+	size_t first_vec = 0;
 	struct socket *ssocket = server->ssocket;
 
+	*sent = 0;
+
 	if (ssocket == NULL)
 		return -ENOTSOCK; /* BB eventually add reconnect code here */
 
@@ -144,56 +155,60 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	else
 		smb_msg.msg_flags = MSG_NOSIGNAL;
 
-	total_len = 0;
+	remaining = 0;
 	for (i = 0; i < n_vec; i++)
-		total_len += iov[i].iov_len;
-
-	cFYI(1, "Sending smb:  total_len %d", total_len);
-	dump_smb(iov[0].iov_base, len);
+		remaining += iov[i].iov_len;
 
 	i = 0;
-	while (total_len) {
+	while (remaining) {
+		/*
+		 * If blocking send, we try 3 times, since each can block
+		 * for 5 seconds. For nonblocking  we have to try more
+		 * but wait increasing amounts of time allowing time for
+		 * socket to clear.  The overall time we wait in either
+		 * case to send on the socket is about 15 seconds.
+		 * Similarly we wait for 15 seconds for a response from
+		 * the server in SendReceive[2] for the server to send
+		 * a response back for most types of requests (except
+		 * SMB Write past end of file which can be slow, and
+		 * blocking lock operations). NFS waits slightly longer
+		 * than CIFS, but this can make it take longer for
+		 * nonresponsive servers to be detected and 15 seconds
+		 * is more than enough time for modern networks to
+		 * send a packet.  In most cases if we fail to send
+		 * after the retries we will kill the socket and
+		 * reconnect which may clear the network problem.
+		 */
 		rc = kernel_sendmsg(ssocket, &smb_msg, &iov[first_vec],
-				    n_vec - first_vec, total_len);
-		if ((rc == -ENOSPC) || (rc == -EAGAIN)) {
+				    n_vec - first_vec, remaining);
+		if (rc == -ENOSPC || rc == -EAGAIN) {
 			i++;
-			/*
-			 * If blocking send we try 3 times, since each can block
-			 * for 5 seconds. For nonblocking  we have to try more
-			 * but wait increasing amounts of time allowing time for
-			 * socket to clear.  The overall time we wait in either
-			 * case to send on the socket is about 15 seconds.
-			 * Similarly we wait for 15 seconds for a response from
-			 * the server in SendReceive[2] for the server to send
-			 * a response back for most types of requests (except
-			 * SMB Write past end of file which can be slow, and
-			 * blocking lock operations). NFS waits slightly longer
-			 * than CIFS, but this can make it take longer for
-			 * nonresponsive servers to be detected and 15 seconds
-			 * is more than enough time for modern networks to
-			 * send a packet.  In most cases if we fail to send
-			 * after the retries we will kill the socket and
-			 * reconnect which may clear the network problem.
-			 */
-			if ((i >= 14) || (!server->noblocksnd && (i > 2))) {
-				cERROR(1, "sends on sock %p stuck for 15 seconds",
-				    ssocket);
+			if (i >= 14 || (!server->noblocksnd && (i > 2))) {
+				cERROR(1, "sends on sock %p stuck for 15 "
+					  "seconds", ssocket);
 				rc = -EAGAIN;
 				break;
 			}
 			msleep(1 << i);
 			continue;
 		}
+
 		if (rc < 0)
 			break;
 
-		if (rc == total_len) {
-			total_len = 0;
+		/* send was at least partially successful */
+		*sent += rc;
+
+		if (rc == remaining) {
+			remaining = 0;
 			break;
-		} else if (rc > total_len) {
-			cERROR(1, "sent %d requested %d", rc, total_len);
+		}
+
+		if (rc > remaining) {
+			cERROR(1, "sent %d requested %d", rc, remaining);
 			break;
 		}
+
 		if (rc == 0) {
 			/* should never happen, letting socket clear before
 			   retrying is our only obvious option here */
@@ -201,7 +216,9 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 			msleep(500);
 			continue;
 		}
-		total_len -= rc;
+
+		remaining -= rc;
+
 		/* the line below resets i */
 		for (i = first_vec; i < n_vec; i++) {
 			if (iov[i].iov_len) {
@@ -216,16 +233,35 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 				}
 			}
 		}
+
 		i = 0; /* in case we get ENOSPC on the next send */
+		rc = 0;
 	}
+	return rc;
+}
+
+static int
+smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
+{
+	int rc;
+	struct kvec *iov = rqst->rq_iov;
+	int n_vec = rqst->rq_nvec;
+	unsigned int smb_buf_length = get_rfc1002_length(iov[0].iov_base);
+	size_t total_len;
+
+	cFYI(1, "Sending smb: smb_len=%u", smb_buf_length);
+	dump_smb(iov[0].iov_base, iov[0].iov_len);
+
+	rc = smb_send_kvec(server, iov, n_vec, &total_len);
 
 	if ((total_len > 0) && (total_len != smb_buf_length + 4)) {
-		cFYI(1, "partial send (%d remaining), terminating session",
-			total_len);
-		/* If we have only sent part of an SMB then the next SMB
-		   could be taken as the remainder of this one.  We need
-		   to kill the socket so the server throws away the partial
-		   SMB */
+		cFYI(1, "partial send (wanted=%u sent=%zu): terminating "
+			"session", smb_buf_length + 4, total_len);
+		/*
+		 * If we have only sent part of an SMB then the next SMB could
+		 * be taken as the remainder of this one. We need to kill the
+		 * socket so the server throws away the partial SMB
+		 */
 		server->tcpStatus = CifsNeedReconnect;
 	}
 
@@ -237,6 +273,15 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	return rc;
 }
 
+static int
+smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
+{
+	struct smb_rqst rqst = { .rq_iov = iov,
+				 .rq_nvec = n_vec };
+
+	return smb_send_rqst(server, &rqst);
+}
+
 int
 smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 	 unsigned int smb_buf_length)
-- 
1.7.10.4
