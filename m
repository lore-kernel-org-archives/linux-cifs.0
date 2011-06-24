From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] CIFS: Simplify socket reading in demultiplex thread
Date: Fri, 24 Jun 2011 10:51:54 +0400
Message-ID: <1308898317-7667-3-git-send-email-piastryyy@gmail.com>
References: <1308898317-7667-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308898317-7667-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Move reading to separate function and remove csocket variable.

Also change semantic in a little: goto incomplete_rcv only when
we get -EAGAIN (or a familiar error) while reading rfc1002 header.
In this case we don't check for echo timeout when we don't get whole
header at once, as it was before.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |  154 ++++++++++++++++++++++++----------------------------
 1 files changed, 71 insertions(+), 83 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 566080d..681e5e6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -355,6 +355,64 @@ allocate_buffers(char **pbigbuf, char **psmallbuf, unsigned int size,
 }
 
 static int
+read_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg,
+		 struct kvec *iov, unsigned int to_read,
+		 unsigned int *ptotal_read, bool is_header_read)
+{
+	int length, rc = 0;
+	unsigned int total_read;
+	char *buf = iov->iov_base;
+
+	for (total_read = 0; total_read < to_read; total_read += length) {
+		length = kernel_recvmsg(server->ssocket, smb_msg, iov, 1,
+					to_read - total_read, 0);
+		if (server->tcpStatus == CifsExiting) {
+			/* then will exit */
+			rc = 2;
+			break;
+		} else if (server->tcpStatus == CifsNeedReconnect) {
+			cifs_reconnect(server);
+			/* Reconnect wakes up rspns q */
+			/* Now we will reread sock */
+			rc = 1;
+			break;
+		} else if (length == -ERESTARTSYS ||
+			   length == -EAGAIN ||
+			   length == -EINTR) {
+			/*
+			 * Minimum sleep to prevent looping, allowing socket
+			 * to clear and app threads to set tcpStatus
+			 * CifsNeedReconnect if server hung.
+			 */
+			usleep_range(1000, 2000);
+			length = 0;
+			if (!is_header_read)
+				continue;
+			/* Special handling for header read */
+			if (total_read) {
+				iov->iov_base = (to_read - total_read) +
+						buf;
+				iov->iov_len = to_read - total_read;
+				smb_msg->msg_control = NULL;
+				smb_msg->msg_controllen = 0;
+				rc = 3;
+			} else
+				rc = 1;
+			break;
+		} else if (length <= 0) {
+			cERROR(1, "Received no data, expecting %d",
+			       to_read - total_read);
+			cifs_reconnect(server);
+			rc = 1;
+			break;
+		}
+	}
+
+	*ptotal_read = total_read;
+	return rc;
+}
+
+static int
 cifs_demultiplex_thread(struct TCP_Server_Info *server)
 {
 	int length;
@@ -363,14 +421,13 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 	struct smb_hdr *smb_buffer = NULL;
 	struct msghdr smb_msg;
 	struct kvec iov;
-	struct socket *csocket = server->ssocket;
 	struct list_head *tmp, *tmp2;
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 	char temp;
 	bool isLargeBuf = false;
 	bool isMultiRsp;
-	int reconnect;
+	int rc;
 
 	current->flags |= PF_MEMALLOC;
 	cFYI(1, "Demultiplex PID: %d", task_pid_nr(current));
@@ -407,51 +464,18 @@ incomplete_rcv:
 				  "Reconnecting...", server->hostname,
 				  (echo_retries * SMB_ECHO_INTERVAL / HZ));
 			cifs_reconnect(server);
-			csocket = server->ssocket;
 			wake_up(&server->response_q);
 			continue;
 		}
 
-		length =
-		    kernel_recvmsg(csocket, &smb_msg,
-				&iov, 1, pdu_length, 0 /* BB other flags? */);
-
-		if (server->tcpStatus == CifsExiting) {
+		rc = read_from_socket(server, &smb_msg, &iov, pdu_length,
+				      &total_read, true /* header read */);
+		if (rc == 3)
+			goto incomplete_rcv;
+		else if (rc == 2)
 			break;
-		} else if (server->tcpStatus == CifsNeedReconnect) {
-			cFYI(1, "Reconnect after server stopped responding");
-			cifs_reconnect(server);
-			cFYI(1, "call to reconnect done");
-			csocket = server->ssocket;
-			continue;
-		} else if (length == -ERESTARTSYS ||
-			   length == -EAGAIN ||
-			   length == -EINTR) {
-			msleep(1); /* minimum sleep to prevent looping
-				allowing socket to clear and app threads to set
-				tcpStatus CifsNeedReconnect if server hung */
-			if (pdu_length < 4) {
-				iov.iov_base = (4 - pdu_length) + buf;
-				iov.iov_len = pdu_length;
-				smb_msg.msg_control = NULL;
-				smb_msg.msg_controllen = 0;
-				goto incomplete_rcv;
-			} else
-				continue;
-		} else if (length <= 0) {
-			cFYI(1, "Reconnect after unexpected peek error %d",
-				length);
-			cifs_reconnect(server);
-			csocket = server->ssocket;
-			wake_up(&server->response_q);
+		else if (rc == 1)
 			continue;
-		} else if (length < pdu_length) {
-			cFYI(1, "requested %d bytes but only got %d bytes",
-				  pdu_length, length);
-			pdu_length -= length;
-			msleep(1);
-			goto incomplete_rcv;
-		}
 
 		/* The right amount was read from socket - 4 bytes */
 		/* so we can now interpret the length field */
@@ -488,14 +512,12 @@ incomplete_rcv:
 			cifs_set_port((struct sockaddr *)
 					&server->dstaddr, CIFS_PORT);
 			cifs_reconnect(server);
-			csocket = server->ssocket;
 			wake_up(&server->response_q);
 			continue;
 		} else if (temp != (char) 0) {
 			cERROR(1, "Unknown RFC 1002 frame");
 			cifs_dump_mem(" Received Data: ", buf, length);
 			cifs_reconnect(server);
-			csocket = server->ssocket;
 			continue;
 		}
 
@@ -505,59 +527,25 @@ incomplete_rcv:
 			cERROR(1, "Invalid size SMB length %d pdu_length %d",
 					length, pdu_length+4);
 			cifs_reconnect(server);
-			csocket = server->ssocket;
 			wake_up(&server->response_q);
 			continue;
 		}
 
 		/* else length ok */
-		reconnect = 0;
-
 		if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
 			isLargeBuf = true;
 			memcpy(bigbuf, smallbuf, 4);
 			smb_buffer = (struct smb_hdr *)bigbuf;
 			buf = bigbuf;
 		}
-		length = 0;
+
 		iov.iov_base = 4 + buf;
 		iov.iov_len = pdu_length;
-		for (total_read = 0; total_read < pdu_length;
-		     total_read += length) {
-			length = kernel_recvmsg(csocket, &smb_msg, &iov, 1,
-						pdu_length - total_read, 0);
-			if (server->tcpStatus == CifsExiting) {
-				/* then will exit */
-				reconnect = 2;
-				break;
-			} else if (server->tcpStatus == CifsNeedReconnect) {
-				cifs_reconnect(server);
-				csocket = server->ssocket;
-				/* Reconnect wakes up rspns q */
-				/* Now we will reread sock */
-				reconnect = 1;
-				break;
-			} else if (length == -ERESTARTSYS ||
-				   length == -EAGAIN ||
-				   length == -EINTR) {
-				msleep(1); /* minimum sleep to prevent looping,
-					      allowing socket to clear and app
-					      threads to set tcpStatus
-					      CifsNeedReconnect if server hung*/
-				length = 0;
-				continue;
-			} else if (length <= 0) {
-				cERROR(1, "Received no data, expecting %d",
-					      pdu_length - total_read);
-				cifs_reconnect(server);
-				csocket = server->ssocket;
-				reconnect = 1;
-				break;
-			}
-		}
-		if (reconnect == 2)
+		rc = read_from_socket(server, &smb_msg, &iov, pdu_length,
+				      &total_read, false);
+		if (rc == 2)
 			break;
-		else if (reconnect == 1)
+		else if (rc == 1)
 			continue;
 
 		total_read += 4; /* account for rfc1002 hdr */
@@ -700,7 +688,7 @@ multi_t2_fnd:
 	msleep(125);
 
 	if (server->ssocket) {
-		sock_release(csocket);
+		sock_release(server->ssocket);
 		server->ssocket = NULL;
 	}
 	/* buffer usually freed in free_mid - need to free it here on exit */
-- 
1.7.1
