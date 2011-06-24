From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v2 3/5] CIFS: Move RFC1002 check to a separate function
Date: Fri, 24 Jun 2011 13:47:59 +0400
Message-ID: <1308908881-22760-4-git-send-email-piastryyy@gmail.com>
References: <1308908881-22760-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308908881-22760-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |  116 ++++++++++++++++++++++++++++++----------------------
 1 files changed, 67 insertions(+), 49 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fd1c46c..5389f04 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -414,6 +414,63 @@ read_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 	return rc;
 }
 
+static bool
+check_rfc1002_header(struct TCP_Server_Info *server, char *buf)
+{
+	char temp = *buf;
+	unsigned int pdu_length = be32_to_cpu(
+				((struct smb_hdr *)buf)->smb_buf_length);
+
+	/*
+	 * The first byte big endian of the length field,
+	 * is actually not part of the length but the type
+	 * with the most common, zero, as regular data.
+	 */
+	if (temp == (char) RFC1002_SESSION_KEEP_ALIVE) {
+		return false;
+	} else if (temp == (char)RFC1002_POSITIVE_SESSION_RESPONSE) {
+		cFYI(1, "Good RFC 1002 session rsp");
+		return false;
+	} else if (temp == (char)RFC1002_NEGATIVE_SESSION_RESPONSE) {
+		/*
+		 * We get this from Windows 98 instead of an error on
+		 * SMB negprot response.
+		 */
+		cFYI(1, "Negative RFC1002 Session Response Error 0x%x)",
+			pdu_length);
+		/* give server a second to clean up */
+		msleep(1000);
+		/*
+		 * Always try 445 first on reconnect since we get NACK
+		 * on some if we ever connected to port 139 (the NACK
+		 * is since we do not begin with RFC1001 session
+		 * initialize frame).
+		 */
+		cifs_set_port((struct sockaddr *)
+				&server->dstaddr, CIFS_PORT);
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return false;
+	} else if (temp != (char) 0) {
+		cERROR(1, "Unknown RFC 1002 frame");
+		cifs_dump_mem(" Received Data: ", buf, 4);
+		cifs_reconnect(server);
+		return false;
+	}
+
+	/* else we have an SMB response */
+	if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) ||
+	    (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
+		cERROR(1, "Invalid size SMB length %d pdu_length %d",
+		       4, pdu_length+4);
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return false;
+	}
+
+	return true;
+}
+
 static int
 cifs_demultiplex_thread(struct TCP_Server_Info *server)
 {
@@ -426,7 +483,6 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 	struct list_head *tmp, *tmp2;
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
-	char temp;
 	bool isLargeBuf = false;
 	bool isMultiRsp;
 	int rc;
@@ -479,59 +535,21 @@ incomplete_rcv:
 		else if (rc == 1)
 			continue;
 
-		/* The right amount was read from socket - 4 bytes */
-		/* so we can now interpret the length field */
-
-		/* the first byte big endian of the length field,
-		is actually not part of the length but the type
-		with the most common, zero, as regular data */
-		temp = *buf;
+		/*
+		 * The right amount was read from socket - 4 bytes,
+		 * so we can now interpret the length field.
+		 */
 
-		/* Note that FC 1001 length is big endian on the wire,
-		but we convert it here so it is always manipulated
-		as host byte order */
+		/*
+		 * Note that RFC 1001 length is big endian on the wire,
+		 * but we convert it here so it is always manipulated
+		 * as host byte order.
+		 */
 		pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
 
 		cFYI(1, "rfc1002 length 0x%x", pdu_length+4);
-
-		if (temp == (char) RFC1002_SESSION_KEEP_ALIVE) {
-			continue;
-		} else if (temp == (char)RFC1002_POSITIVE_SESSION_RESPONSE) {
-			cFYI(1, "Good RFC 1002 session rsp");
-			continue;
-		} else if (temp == (char)RFC1002_NEGATIVE_SESSION_RESPONSE) {
-			/* we get this from Windows 98 instead of
-			   an error on SMB negprot response */
-			cFYI(1, "Negative RFC1002 Session Response Error 0x%x)",
-				pdu_length);
-			/* give server a second to clean up  */
-			msleep(1000);
-			/* always try 445 first on reconnect since we get NACK
-			 * on some if we ever connected to port 139 (the NACK
-			 * is since we do not begin with RFC1001 session
-			 * initialize frame)
-			 */
-			cifs_set_port((struct sockaddr *)
-					&server->dstaddr, CIFS_PORT);
-			cifs_reconnect(server);
-			wake_up(&server->response_q);
-			continue;
-		} else if (temp != (char) 0) {
-			cERROR(1, "Unknown RFC 1002 frame");
-			cifs_dump_mem(" Received Data: ", buf, length);
-			cifs_reconnect(server);
-			continue;
-		}
-
-		/* else we have an SMB response */
-		if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) ||
-			    (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
-			cERROR(1, "Invalid size SMB length %d pdu_length %d",
-					length, pdu_length+4);
-			cifs_reconnect(server);
-			wake_up(&server->response_q);
+		if (!check_rfc1002_header(server, buf))
 			continue;
-		}
 
 		/* else length ok */
 		if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
-- 
1.7.1
