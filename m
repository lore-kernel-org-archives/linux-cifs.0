From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v2 4/5] CIFS: Move mid search to a separate function
Date: Fri, 24 Jun 2011 13:48:00 +0400
Message-ID: <1308908881-22760-5-git-send-email-piastryyy@gmail.com>
References: <1308908881-22760-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308908881-22760-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |  125 ++++++++++++++++++++++++++---------------------------
 1 files changed, 61 insertions(+), 64 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5389f04..b3659be 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -471,6 +471,65 @@ check_rfc1002_header(struct TCP_Server_Info *server, char *buf)
 	return true;
 }
 
+static struct mid_q_entry *
+find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
+	      int *length, bool is_large_buf, bool *is_multi_rsp, char **bigbuf)
+{
+	struct mid_q_entry *mid = NULL, *tmp_mid;
+
+	spin_lock(&GlobalMid_Lock);
+	list_for_each_entry_safe(mid, tmp_mid, &server->pending_mid_q, qhead) {
+		if (mid->mid != buf->Mid ||
+		    mid->midState != MID_REQUEST_SUBMITTED ||
+		    mid->command != buf->Command) {
+			mid = NULL;
+			continue;
+		}
+
+		if (*length == 0 && check2ndT2(buf, server->maxBuf) > 0) {
+			/* We have a multipart transact2 resp */
+			*is_multi_rsp = true;
+			if (mid->resp_buf) {
+				/* merge response - fix up 1st*/
+				*length = coalesce_t2(buf, mid->resp_buf);
+				if (*length > 0) {
+					*length = 0;
+					mid->multiRsp = true;
+					break;
+				}
+				/* All parts received or packet is malformed. */
+				mid->multiEnd = true;
+				goto multi_t2_fnd;
+			}
+			if (!is_large_buf) {
+				/*FIXME: switch to already allocated largebuf?*/
+				cERROR(1, "1st trans2 resp needs bigbuf");
+			} else {
+				/* Have first buffer */
+				mid->resp_buf = buf;
+				mid->largeBuf = true;
+				*bigbuf = NULL;
+			}
+			break;
+		}
+		mid->resp_buf = buf;
+		mid->largeBuf = is_large_buf;
+multi_t2_fnd:
+		if (*length == 0)
+			mid->midState = MID_RESPONSE_RECEIVED;
+		else
+			mid->midState = MID_RESPONSE_MALFORMED;
+#ifdef CONFIG_CIFS_STATS2
+		mid->when_received = jiffies;
+#endif
+		list_del_init(&mid->qhead);
+		break;
+	}
+	spin_unlock(&GlobalMid_Lock);
+
+	return mid;
+}
+
 static int
 cifs_demultiplex_thread(struct TCP_Server_Info *server)
 {
@@ -586,72 +645,10 @@ incomplete_rcv:
 			cifs_dump_mem("Bad SMB: ", smb_buffer,
 					min_t(unsigned int, total_read, 48));
 
-		mid_entry = NULL;
 		server->lstrp = jiffies;
 
-		spin_lock(&GlobalMid_Lock);
-		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
-			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-
-			if (mid_entry->mid != smb_buffer->Mid ||
-			    mid_entry->midState != MID_REQUEST_SUBMITTED ||
-			    mid_entry->command != smb_buffer->Command) {
-				mid_entry = NULL;
-				continue;
-			}
-
-			if (length == 0 &&
-			    check2ndT2(smb_buffer, server->maxBuf) > 0) {
-				/* We have a multipart transact2 resp */
-				isMultiRsp = true;
-				if (mid_entry->resp_buf) {
-					/* merge response - fix up 1st*/
-					length = coalesce_t2(smb_buffer,
-							mid_entry->resp_buf);
-					if (length > 0) {
-						length = 0;
-						mid_entry->multiRsp = true;
-						break;
-					} else {
-						/* all parts received or
-						 * packet is malformed
-						 */
-						mid_entry->multiEnd = true;
-						goto multi_t2_fnd;
-					}
-				} else {
-					if (!isLargeBuf) {
-						/*
-						 * FIXME: switch to already
-						 *        allocated largebuf?
-						 */
-						cERROR(1, "1st trans2 resp "
-							  "needs bigbuf");
-					} else {
-						/* Have first buffer */
-						mid_entry->resp_buf =
-							 smb_buffer;
-						mid_entry->largeBuf = true;
-						bigbuf = NULL;
-					}
-				}
-				break;
-			}
-			mid_entry->resp_buf = smb_buffer;
-			mid_entry->largeBuf = isLargeBuf;
-multi_t2_fnd:
-			if (length == 0)
-				mid_entry->midState = MID_RESPONSE_RECEIVED;
-			else
-				mid_entry->midState = MID_RESPONSE_MALFORMED;
-#ifdef CONFIG_CIFS_STATS2
-			mid_entry->when_received = jiffies;
-#endif
-			list_del_init(&mid_entry->qhead);
-			break;
-		}
-		spin_unlock(&GlobalMid_Lock);
-
+		mid_entry = find_cifs_mid(server, smb_buffer, &length,
+					  isLargeBuf, &isMultiRsp, &bigbuf);
 		if (mid_entry != NULL) {
 			mid_entry->callback(mid_entry);
 			/* Was previous buf put in mpx struct for multi-rsp? */
-- 
1.7.1
