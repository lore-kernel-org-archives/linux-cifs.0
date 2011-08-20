From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/14] cifs: find mid earlier in receive codepath
Date: Fri, 19 Aug 2011 21:55:37 -0400
Message-ID: <1313805339-1233-13-git-send-email-jlayton@redhat.com>
References: <1313805339-1233-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313805339-1233-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
index 4b727c2..18171cf 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -555,16 +555,10 @@ dequeue_mid(struct mid_q_entry *mid, int malformed)
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
@@ -572,11 +566,11 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
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
@@ -587,7 +581,7 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
 			mid->largeBuf = true;
 			server->bigbuf = NULL;
 		}
-		return mid;
+		return;
 	}
 	mid->resp_buf = buf;
 	mid->largeBuf = server->large_buf;
@@ -599,9 +593,7 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
 		else
 			server->smallbuf = NULL;
 	}
-multi_t2_fnd:
 	dequeue_mid(mid, malformed);
-	return mid;
 }
 
 static void clean_demultiplex_info(struct TCP_Server_Info *server)
@@ -762,6 +754,8 @@ cifs_demultiplex_thread(void *p)
 			continue;
 		server->total_read += length;
 
+		mid_entry = find_mid(server, smb_buffer);
+
 		if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
 			cERROR(1, "SMB response too long (%u bytes)",
 				pdu_length);
@@ -806,8 +800,8 @@ cifs_demultiplex_thread(void *p)
 
 		server->lstrp = jiffies;
 
-		mid_entry = find_cifs_mid(server, smb_buffer, length);
 		if (mid_entry != NULL) {
+			handle_mid(mid_entry, server, smb_buffer, length);
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
 		} else if (length != 0) {
-- 
1.7.6
