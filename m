From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/16] cifs: add a third receive phase to cifs_demultiplex_thread
Date: Mon, 29 Aug 2011 07:16:58 -0400
Message-ID: <1314616624-5362-11-git-send-email-jlayton@redhat.com>
References: <1314616624-5362-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314616624-5362-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have the demultiplex thread receive just enough to get to the MID, and
then find it before receiving the rest. Later, we'll use this to swap
in a preallocated receive buffer for some calls.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1093d46..bc16873 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -746,11 +746,25 @@ cifs_demultiplex_thread(void *p)
 		if (!is_smb_response(server, buf[0]))
 			continue;
 
-		/* check the length */
-		if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) ||
-		    (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
-			cERROR(1, "Invalid size SMB length %d pdu_length %d",
-			       4, pdu_length + 4);
+		/* make sure we have enough to get to the MID */
+		if (pdu_length < sizeof(struct smb_hdr) - 1 - 4) {
+			cERROR(1, "SMB response too short (%u bytes)",
+				pdu_length);
+			cifs_reconnect(server);
+			wake_up(&server->response_q);
+			continue;
+		}
+
+		/* read down to the MID */
+		length = read_from_socket(server, buf + 4,
+					  sizeof(struct smb_hdr) - 1 - 4);
+		if (length < 0)
+			continue;
+		total_read += length;
+
+		if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+			cERROR(1, "SMB response too long (%u bytes)",
+				pdu_length);
 			cifs_reconnect(server);
 			wake_up(&server->response_q);
 			continue;
@@ -759,12 +773,15 @@ cifs_demultiplex_thread(void *p)
 		/* else length ok */
 		if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
 			isLargeBuf = true;
-			memcpy(bigbuf, smallbuf, 4);
+			memcpy(bigbuf, smallbuf, total_read);
 			smb_buffer = (struct smb_hdr *)bigbuf;
 			buf = bigbuf;
 		}
 
-		length = read_from_socket(server, buf + 4, pdu_length);
+		/* now read the rest */
+		length = read_from_socket(server,
+				  buf + sizeof(struct smb_hdr) - 1,
+				  pdu_length - sizeof(struct smb_hdr) + 1 + 4);
 		if (length < 0)
 			continue;
 		total_read += length;
-- 
1.7.6
