From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/14] cifs: break out 3rd receive phase into separate function
Date: Fri, 19 Aug 2011 21:55:38 -0400
Message-ID: <1313805339-1233-14-git-send-email-jlayton@redhat.com>
References: <1313805339-1233-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313805339-1233-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Move the entire 3rd phase of the receive codepath into a separate
function in preparation for the addition of a pluggable receive
function.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |  101 +++++++++++++++++++++++++++++++----------------------
 1 files changed, 59 insertions(+), 42 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 18171cf..f122bfa 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -692,6 +692,61 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 }
 
 static int
+standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+{
+	int length;
+	char *buf = server->smallbuf;
+	struct smb_hdr *smb_buffer = (struct smb_hdr *)buf;
+	unsigned int pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
+
+	/* make sure this will fit in a large buffer */
+	if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+		cERROR(1, "SMB response too long (%u bytes)",
+			pdu_length);
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return -EAGAIN;
+	}
+
+	/* switch to large buffer if too big for a small one */
+	if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
+		server->large_buf = true;
+		memcpy(server->bigbuf, server->smallbuf, server->total_read);
+		buf = server->bigbuf;
+		smb_buffer = (struct smb_hdr *)buf;
+	}
+
+	/* now read the rest */
+	length = read_from_socket(server,
+			  buf + sizeof(struct smb_hdr) - 1,
+			  pdu_length - sizeof(struct smb_hdr) + 1 + 4);
+	if (length < 0)
+		return length;
+	server->total_read += length;
+
+	dump_smb(smb_buffer, server->total_read);
+
+	/*
+	 * We know that we received enough to get to the MID as we
+	 * checked the pdu_length earlier. Now check to see
+	 * if the rest of the header is OK. We borrow the length
+	 * var for the rest of the loop to avoid a new stack var.
+	 *
+	 * 48 bytes is enough to display the header and a little bit
+	 * into the payload for debugging purposes.
+	 */
+	length = checkSMB(smb_buffer, smb_buffer->Mid, server->total_read);
+	if (length != 0)
+		cifs_dump_mem("Bad SMB: ", buf,
+			min_t(unsigned int, server->total_read, 48));
+
+	if (mid)
+		handle_mid(mid, server, smb_buffer, length);
+
+	return length;
+}
+
+static int
 cifs_demultiplex_thread(void *p)
 {
 	int length;
@@ -756,57 +811,19 @@ cifs_demultiplex_thread(void *p)
 
 		mid_entry = find_mid(server, smb_buffer);
 
-		if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-			cERROR(1, "SMB response too long (%u bytes)",
-				pdu_length);
-			cifs_reconnect(server);
-			wake_up(&server->response_q);
+		length = standard_receive3(server, mid_entry);
+		if (length < 0)
 			continue;
-		}
 
-		/* else length ok */
-		if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
-			server->large_buf = true;
-			memcpy(server->bigbuf, server->smallbuf,
-			       server->total_read);
-			smb_buffer = (struct smb_hdr *)server->bigbuf;
+		if (server->large_buf) {
 			buf = server->bigbuf;
+			smb_buffer = (struct smb_hdr *)buf;
 		}
 
-		/* now read the rest */
-		length = read_from_socket(server,
-				  buf + sizeof(struct smb_hdr) - 1,
-				  pdu_length - sizeof(struct smb_hdr) + 1 + 4);
-		if (length < 0)
-			continue;
-		server->total_read += length;
-
-		dump_smb(smb_buffer, server->total_read);
-
-		/*
-		 * We know that we received enough to get to the MID as we
-		 * checked the pdu_length earlier. Now check to see
-		 * if the rest of the header is OK. We borrow the length
-		 * var for the rest of the loop to avoid a new stack var.
-		 *
-		 * 48 bytes is enough to display the header and a little bit
-		 * into the payload for debugging purposes.
-		 */
-		length = checkSMB(smb_buffer, smb_buffer->Mid,
-				  server->total_read);
-		if (length != 0)
-			cifs_dump_mem("Bad SMB: ", buf,
-				min_t(unsigned int, server->total_read, 48));
-
 		server->lstrp = jiffies;
-
 		if (mid_entry != NULL) {
-			handle_mid(mid_entry, server, smb_buffer, length);
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
-		} else if (length != 0) {
-			/* response sanity checks failed */
-			continue;
 		} else if (!is_valid_oplock_break(smb_buffer, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
-- 
1.7.6
