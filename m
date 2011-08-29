From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/16] cifs: simplify read_from_socket
Date: Mon, 29 Aug 2011 07:16:54 -0400
Message-ID: <1314616624-5362-7-git-send-email-jlayton@redhat.com>
References: <1314616624-5362-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314616624-5362-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Move the iovec handling entirely into read_from_socket. That simplifies
the code and gets rid of the special handling for header reads. With
this we can also get rid of the "goto incomplete_rcv" label in the main
demultiplex thread function since we can now treat header and non-header
receives the same way.

Also, make it return an int (since we'll never receive enough to worry
about the sign bit anyway), and simply make it return the amount of bytes
read or a negative error code.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   77 ++++++++++++++++------------------------------------
 1 files changed, 24 insertions(+), 53 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 720a619..e6da201 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -376,35 +376,33 @@ server_unresponsive(struct TCP_Server_Info *server)
 }
 
 static int
-read_from_socket(struct TCP_Server_Info *server,
-		 struct kvec *iov, unsigned int to_read,
-		 unsigned int *ptotal_read, bool is_header_read)
+read_from_socket(struct TCP_Server_Info *server, char *buf,
+		 unsigned int to_read)
 {
-	int length, rc = 0;
-	unsigned int total_read;
+	int length = 0;
+	int total_read;
 	struct msghdr smb_msg;
-	char *buf = iov->iov_base;
+	struct kvec iov;
 
 	smb_msg.msg_control = NULL;
 	smb_msg.msg_controllen = 0;
 
-	for (total_read = 0; total_read < to_read; total_read += length) {
+	for (total_read = 0; to_read; total_read += length, to_read -= length) {
 		if (server_unresponsive(server)) {
-			rc = 1;
+			total_read = -EAGAIN;
 			break;
 		}
 
-		length = kernel_recvmsg(server->ssocket, &smb_msg, iov, 1,
-					to_read - total_read, 0);
+		iov.iov_base = buf + total_read;
+		iov.iov_len = to_read;
+		length = kernel_recvmsg(server->ssocket, &smb_msg, &iov, 1,
+					to_read, 0);
 		if (server->tcpStatus == CifsExiting) {
-			/* then will exit */
-			rc = 2;
+			total_read = -ESHUTDOWN;
 			break;
 		} else if (server->tcpStatus == CifsNeedReconnect) {
 			cifs_reconnect(server);
-			/* Reconnect wakes up rspns q */
-			/* Now we will reread sock */
-			rc = 1;
+			total_read = -EAGAIN;
 			break;
 		} else if (length == -ERESTARTSYS ||
 			   length == -EAGAIN ||
@@ -416,28 +414,16 @@ read_from_socket(struct TCP_Server_Info *server,
 			 */
 			usleep_range(1000, 2000);
 			length = 0;
-			if (!is_header_read)
-				continue;
-			/* Special handling for header read */
-			if (total_read) {
-				iov->iov_base = (to_read - total_read) +
-						buf;
-				iov->iov_len = to_read - total_read;
-				rc = 3;
-			} else
-				rc = 1;
-			break;
+			continue;
 		} else if (length <= 0) {
-			cERROR(1, "Received no data, expecting %d",
-			       to_read - total_read);
+			cFYI(1, "Received no data or error: expecting %d "
+				"got %d", to_read, length);
 			cifs_reconnect(server);
-			rc = 1;
+			total_read = -EAGAIN;
 			break;
 		}
 	}
-
-	*ptotal_read = total_read;
-	return rc;
+	return total_read;
 }
 
 static bool
@@ -658,12 +644,10 @@ cifs_demultiplex_thread(void *p)
 	unsigned int pdu_length, total_read;
 	char *buf = NULL, *bigbuf = NULL, *smallbuf = NULL;
 	struct smb_hdr *smb_buffer = NULL;
-	struct kvec iov;
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 	bool isLargeBuf = false;
 	bool isMultiRsp = false;
-	int rc;
 
 	current->flags |= PF_MEMALLOC;
 	cFYI(1, "Demultiplex PID: %d", task_pid_nr(current));
@@ -686,19 +670,12 @@ cifs_demultiplex_thread(void *p)
 		isMultiRsp = false;
 		smb_buffer = (struct smb_hdr *)smallbuf;
 		buf = smallbuf;
-		iov.iov_base = buf;
-		iov.iov_len = 4;
 		pdu_length = 4; /* enough to get RFC1001 header */
 
-incomplete_rcv:
-		rc = read_from_socket(server, &iov, pdu_length,
-				      &total_read, true /* header read */);
-		if (rc == 3)
-			goto incomplete_rcv;
-		else if (rc == 2)
-			break;
-		else if (rc == 1)
+		length = read_from_socket(server, buf, pdu_length);
+		if (length < 0)
 			continue;
+		total_read = length;
 
 		/*
 		 * The right amount was read from socket - 4 bytes,
@@ -718,16 +695,10 @@ incomplete_rcv:
 			buf = bigbuf;
 		}
 
-		iov.iov_base = 4 + buf;
-		iov.iov_len = pdu_length;
-		rc = read_from_socket(server, &iov, pdu_length,
-				      &total_read, false);
-		if (rc == 2)
-			break;
-		else if (rc == 1)
+		length = read_from_socket(server, buf + 4, pdu_length);
+		if (length < 0)
 			continue;
-
-		total_read += 4; /* account for rfc1002 hdr */
+		total_read += length;
 
 		dump_smb(smb_buffer, total_read);
 
-- 
1.7.6
