From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/14] cifs: clean up check_rfc1002_header
Date: Fri, 19 Aug 2011 21:55:31 -0400
Message-ID: <1313805339-1233-7-git-send-email-jlayton@redhat.com>
References: <1313805339-1233-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313805339-1233-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Rename it for better clarity as to what it does and have the caller pass
in just the single type byte. Turn the if statement into a switch and
optimize it by placing the most common message type at the top. Move the
header length check back into cifs_demultiplex_thread in preparation
for adding a new receive phase and normalize the cFYI messages.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   63 +++++++++++++++++++++++++---------------------------
 1 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 430e563..ecd8ae7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -485,29 +485,29 @@ read_from_socket(struct TCP_Server_Info *server, char *buf,
 }
 
 static bool
-check_rfc1002_header(struct TCP_Server_Info *server, char *buf)
+is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 {
-	char temp = *buf;
-	unsigned int pdu_length = be32_to_cpu(
-				((struct smb_hdr *)buf)->smb_buf_length);
-
 	/*
 	 * The first byte big endian of the length field,
 	 * is actually not part of the length but the type
 	 * with the most common, zero, as regular data.
 	 */
-	if (temp == (char) RFC1002_SESSION_KEEP_ALIVE) {
-		return false;
-	} else if (temp == (char)RFC1002_POSITIVE_SESSION_RESPONSE) {
-		cFYI(1, "Good RFC 1002 session rsp");
-		return false;
-	} else if (temp == (char)RFC1002_NEGATIVE_SESSION_RESPONSE) {
+	switch (type) {
+	case RFC1002_SESSION_MESSAGE:
+		/* Regular SMB response */
+		return true;
+	case RFC1002_SESSION_KEEP_ALIVE:
+		cFYI(1, "RFC 1002 session keep alive");
+		break;
+	case RFC1002_POSITIVE_SESSION_RESPONSE:
+		cFYI(1, "RFC 1002 positive session response");
+		break;
+	case RFC1002_NEGATIVE_SESSION_RESPONSE:
 		/*
 		 * We get this from Windows 98 instead of an error on
 		 * SMB negprot response.
 		 */
-		cFYI(1, "Negative RFC1002 Session Response Error 0x%x)",
-			pdu_length);
+		cFYI(1, "RFC 1002 negative session response");
 		/* give server a second to clean up */
 		msleep(1000);
 		/*
@@ -516,29 +516,16 @@ check_rfc1002_header(struct TCP_Server_Info *server, char *buf)
 		 * is since we do not begin with RFC1001 session
 		 * initialize frame).
 		 */
-		cifs_set_port((struct sockaddr *)
-				&server->dstaddr, CIFS_PORT);
+		cifs_set_port((struct sockaddr *)&server->dstaddr, CIFS_PORT);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
-		return false;
-	} else if (temp != (char) 0) {
-		cERROR(1, "Unknown RFC 1002 frame");
-		cifs_dump_mem(" Received Data: ", buf, 4);
-		cifs_reconnect(server);
-		return false;
-	}
-
-	/* else we have an SMB response */
-	if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) ||
-	    (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
-		cERROR(1, "Invalid size SMB length %d pdu_length %d",
-		       4, pdu_length+4);
+		break;
+	default:
+		cERROR(1, "RFC 1002 unknown response type 0x%x", type);
 		cifs_reconnect(server);
-		wake_up(&server->response_q);
-		return false;
 	}
 
-	return true;
+	return false;
 }
 
 static struct mid_q_entry *
@@ -741,10 +728,20 @@ cifs_demultiplex_thread(void *p)
 		 */
 		pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
 
-		cFYI(1, "rfc1002 length 0x%x", pdu_length+4);
-		if (!check_rfc1002_header(server, buf))
+		cFYI(1, "RFC1002 header 0x%x", pdu_length);
+		if (!is_smb_response(server, buf[0]))
 			continue;
 
+		/* check the length */
+		if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) ||
+		    (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
+			cERROR(1, "Invalid size SMB length %d pdu_length %d",
+			       4, pdu_length + 4);
+			cifs_reconnect(server);
+			wake_up(&server->response_q);
+			continue;
+		}
+
 		/* else length ok */
 		if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
 			isLargeBuf = true;
-- 
1.7.6
