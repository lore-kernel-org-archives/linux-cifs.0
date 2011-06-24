From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v2 1/5] CIFS: Move buffer allocation to a separate function
Date: Fri, 24 Jun 2011 13:47:57 +0400
Message-ID: <1308908881-22760-2-git-send-email-piastryyy@gmail.com>
References: <1308908881-22760-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308908881-22760-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |   86 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 52 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 19fdbda..285325b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -317,14 +317,52 @@ requeue_echo:
 	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
 }
 
+static bool
+allocate_buffers(char **bigbuf, char **smallbuf, unsigned int size,
+		 bool is_large_buf)
+{
+	char *bbuf = *bigbuf, *sbuf = *smallbuf;
+
+	if (bbuf == NULL) {
+		bbuf = (char *)cifs_buf_get();
+		if (!bbuf) {
+			cERROR(1, "No memory for large SMB response");
+			msleep(3000);
+			/* retry will check if exiting */
+			return false;
+		}
+	} else if (is_large_buf) {
+		/* we are reusing a dirty large buf, clear its start */
+		memset(bbuf, 0, size);
+	}
+
+	if (sbuf == NULL) {
+		sbuf = (char *)cifs_small_buf_get();
+		if (!sbuf) {
+			cERROR(1, "No memory for SMB response");
+			msleep(1000);
+			/* retry will check if exiting */
+			return false;
+		}
+		/* beginning of smb buffer is cleared in our buf_get */
+	} else {
+		/* if existing small buf clear beginning */
+		memset(sbuf, 0, size);
+	}
+
+	*bigbuf = bbuf;
+	*smallbuf = sbuf;
+
+	return true;
+}
+
 static int
 cifs_demultiplex_thread(struct TCP_Server_Info *server)
 {
 	int length;
 	unsigned int pdu_length, total_read;
+	char *buf = NULL, *bigbuf = NULL, *smallbuf = NULL;
 	struct smb_hdr *smb_buffer = NULL;
-	struct smb_hdr *bigbuf = NULL;
-	struct smb_hdr *smallbuf = NULL;
 	struct msghdr smb_msg;
 	struct kvec iov;
 	struct socket *csocket = server->ssocket;
@@ -348,34 +386,15 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 	while (server->tcpStatus != CifsExiting) {
 		if (try_to_freeze())
 			continue;
-		if (bigbuf == NULL) {
-			bigbuf = cifs_buf_get();
-			if (!bigbuf) {
-				cERROR(1, "No memory for large SMB response");
-				msleep(3000);
-				/* retry will check if exiting */
-				continue;
-			}
-		} else if (isLargeBuf) {
-			/* we are reusing a dirty large buf, clear its start */
-			memset(bigbuf, 0, sizeof(struct smb_hdr));
-		}
 
-		if (smallbuf == NULL) {
-			smallbuf = cifs_small_buf_get();
-			if (!smallbuf) {
-				cERROR(1, "No memory for SMB response");
-				msleep(1000);
-				/* retry will check if exiting */
-				continue;
-			}
-			/* beginning of smb buffer is cleared in our buf_get */
-		} else /* if existing small buf clear beginning */
-			memset(smallbuf, 0, sizeof(struct smb_hdr));
+		if (!allocate_buffers(&bigbuf, &smallbuf,
+				      sizeof(struct smb_hdr), isLargeBuf))
+			continue;
 
 		isLargeBuf = false;
 		isMultiRsp = false;
-		smb_buffer = smallbuf;
+		smb_buffer = (struct smb_hdr *)smallbuf;
+		buf = smallbuf;
 		iov.iov_base = smb_buffer;
 		iov.iov_len = 4;
 		smb_msg.msg_control = NULL;
@@ -414,8 +433,7 @@ incomplete_rcv:
 				allowing socket to clear and app threads to set
 				tcpStatus CifsNeedReconnect if server hung */
 			if (pdu_length < 4) {
-				iov.iov_base = (4 - pdu_length) +
-							(char *)smb_buffer;
+				iov.iov_base = (4 - pdu_length) + buf;
 				iov.iov_len = pdu_length;
 				smb_msg.msg_control = NULL;
 				smb_msg.msg_controllen = 0;
@@ -443,7 +461,7 @@ incomplete_rcv:
 		/* the first byte big endian of the length field,
 		is actually not part of the length but the type
 		with the most common, zero, as regular data */
-		temp = *((char *) smb_buffer);
+		temp = *buf;
 
 		/* Note that FC 1001 length is big endian on the wire,
 		but we convert it here so it is always manipulated
@@ -477,8 +495,7 @@ incomplete_rcv:
 			continue;
 		} else if (temp != (char) 0) {
 			cERROR(1, "Unknown RFC 1002 frame");
-			cifs_dump_mem(" Received Data: ", (char *)smb_buffer,
-				      length);
+			cifs_dump_mem(" Received Data: ", buf, length);
 			cifs_reconnect(server);
 			csocket = server->ssocket;
 			continue;
@@ -501,10 +518,11 @@ incomplete_rcv:
 		if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
 			isLargeBuf = true;
 			memcpy(bigbuf, smallbuf, 4);
-			smb_buffer = bigbuf;
+			smb_buffer = (struct smb_hdr *)bigbuf;
+			buf = bigbuf;
 		}
 		length = 0;
-		iov.iov_base = 4 + (char *)smb_buffer;
+		iov.iov_base = 4 + buf;
 		iov.iov_len = pdu_length;
 		for (total_read = 0; total_read < pdu_length;
 		     total_read += length) {
@@ -645,7 +663,7 @@ multi_t2_fnd:
 			   !isMultiRsp) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
-			cifs_dump_mem("Received Data is: ", (char *)smb_buffer,
+			cifs_dump_mem("Received Data is: ", buf,
 				      sizeof(struct smb_hdr));
 #ifdef CONFIG_CIFS_DEBUG2
 			cifs_dump_detail(smb_buffer);
-- 
1.7.1
