From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v5 PATCH 1/5] CIFS: Move buffer allocation to a separate function
Date: Mon,  1 Aug 2011 13:19:40 +0400
Message-ID: <1312190384-3376-2-git-send-email-piastryyy@gmail.com>
References: <1312190384-3376-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312190384-3376-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-and-Tested-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |   92 +++++++++++++++++++++++++++++++---------------------
 1 files changed, 55 insertions(+), 37 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 50b3523..217d365 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -319,15 +319,53 @@ requeue_echo:
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
 cifs_demultiplex_thread(void *p)
 {
 	int length;
 	struct TCP_Server_Info *server = p;
 	unsigned int pdu_length, total_read;
+	char *buf = NULL, *bigbuf = NULL, *smallbuf = NULL;
 	struct smb_hdr *smb_buffer = NULL;
-	struct smb_hdr *bigbuf = NULL;
-	struct smb_hdr *smallbuf = NULL;
 	struct msghdr smb_msg;
 	struct kvec iov;
 	struct socket *csocket = server->ssocket;
@@ -351,35 +389,16 @@ cifs_demultiplex_thread(void *p)
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
-		iov.iov_base = smb_buffer;
+		smb_buffer = (struct smb_hdr *)smallbuf;
+		buf = smallbuf;
+		iov.iov_base = buf;
 		iov.iov_len = 4;
 		smb_msg.msg_control = NULL;
 		smb_msg.msg_controllen = 0;
@@ -417,8 +436,7 @@ incomplete_rcv:
 				allowing socket to clear and app threads to set
 				tcpStatus CifsNeedReconnect if server hung */
 			if (pdu_length < 4) {
-				iov.iov_base = (4 - pdu_length) +
-							(char *)smb_buffer;
+				iov.iov_base = (4 - pdu_length) + buf;
 				iov.iov_len = pdu_length;
 				smb_msg.msg_control = NULL;
 				smb_msg.msg_controllen = 0;
@@ -446,7 +464,7 @@ incomplete_rcv:
 		/* the first byte big endian of the length field,
 		is actually not part of the length but the type
 		with the most common, zero, as regular data */
-		temp = *((char *) smb_buffer);
+		temp = *buf;
 
 		/* Note that FC 1001 length is big endian on the wire,
 		but we convert it here so it is always manipulated
@@ -480,8 +498,7 @@ incomplete_rcv:
 			continue;
 		} else if (temp != (char) 0) {
 			cERROR(1, "Unknown RFC 1002 frame");
-			cifs_dump_mem(" Received Data: ", (char *)smb_buffer,
-				      length);
+			cifs_dump_mem(" Received Data: ", buf, length);
 			cifs_reconnect(server);
 			csocket = server->ssocket;
 			continue;
@@ -504,10 +521,11 @@ incomplete_rcv:
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
@@ -562,8 +580,8 @@ incomplete_rcv:
 		 */
 		length = checkSMB(smb_buffer, smb_buffer->Mid, total_read);
 		if (length != 0)
-			cifs_dump_mem("Bad SMB: ", smb_buffer,
-					min_t(unsigned int, total_read, 48));
+			cifs_dump_mem("Bad SMB: ", buf,
+				      min_t(unsigned int, total_read, 48));
 
 		mid_entry = NULL;
 		server->lstrp = jiffies;
@@ -648,7 +666,7 @@ multi_t2_fnd:
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
