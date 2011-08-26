From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/16] cifs: find mid earlier in receive codepath
Date: Fri, 26 Aug 2011 15:06:27 -0400
Message-ID: <1314385589-27136-15-git-send-email-jlayton@redhat.com>
References: <1314385589-27136-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314385589-27136-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In order to receive directly into a preallocated buffer, we need to ID
the mid earlier, before the bulk of the response is read. Call the mid
finding routine as soon as we're able to read the mid.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5c0898a..8a43619 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -568,16 +568,10 @@ dequeue_mid(struct mid_q_entry *mid, int malformed)
 	spin_unlock(&GlobalMid_Lock);
 }
 
-static struct mid_q_entry *
-find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
-	      int malformed)
+static void
+handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+	   struct smb_hdr *buf, int malformed)
 {
-	struct mid_q_entry *mid = NULL;
-
-	mid = find_mid(server, buf);
-	if (!mid)
-		return mid;
-
 	if (malformed == 0 && check2ndT2(buf) > 0) {
 		mid->multiRsp = true;
 		if (mid->resp_buf) {
@@ -585,11 +579,11 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
 			malformed = coalesce_t2(buf, mid->resp_buf);
 			if (malformed > 0) {
 				malformed = 0;
-				return mid;
+				return;
 			}
 			/* All parts received or packet is malformed. */
 			mid->multiEnd = true;
-			goto multi_t2_fnd;
+			return dequeue_mid(mid, malformed);
 		}
 		if (!server->large_buf) {
 			/*FIXME: switch to already allocated largebuf?*/
@@ -600,7 +594,7 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
 			mid->largeBuf = true;
 			server->bigbuf = NULL;
 		}
-		return mid;
+		return;
 	}
 	mid->resp_buf = buf;
 	mid->largeBuf = server->large_buf;
@@ -612,9 +606,7 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
 		else
 			server->smallbuf = NULL;
 	}
-multi_t2_fnd:
 	dequeue_mid(mid, malformed);
-	return mid;
 }
 
 static void clean_demultiplex_info(struct TCP_Server_Info *server)
@@ -776,6 +768,8 @@ cifs_demultiplex_thread(void *p)
 			continue;
 		server->total_read += length;
 
+		mid_entry = find_mid(server, smb_buffer);
+
 		if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
 			cERROR(1, "SMB response too long (%u bytes)",
 				pdu_length);
@@ -820,8 +814,8 @@ cifs_demultiplex_thread(void *p)
 
 		server->lstrp = jiffies;
 
-		mid_entry = find_cifs_mid(server, smb_buffer, length);
 		if (mid_entry != NULL) {
+			handle_mid(mid_entry, server, smb_buffer, length);
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
 		} else if (length != 0) {
-- 
1.7.6
