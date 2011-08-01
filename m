From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v5 PATCH 4/5] CIFS: Move mid search to a separate function
Date: Mon,  1 Aug 2011 13:19:43 +0400
Message-ID: <1312190384-3376-5-git-send-email-piastryyy@gmail.com>
References: <1312190384-3376-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312190384-3376-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-and-Tested-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |  126 +++++++++++++++++++++++++---------------------------
 1 files changed, 61 insertions(+), 65 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2a53ade..12b2741 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -473,6 +473,64 @@ check_rfc1002_header(struct TCP_Server_Info *server, char *buf)
 	return true;
 }
 
+static struct mid_q_entry *
+find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
+	      int *length, bool is_large_buf, bool *is_multi_rsp, char **bigbuf)
+{
+	struct mid_q_entry *mid = NULL, *tmp_mid, *ret = NULL;
+
+	spin_lock(&GlobalMid_Lock);
+	list_for_each_entry_safe(mid, tmp_mid, &server->pending_mid_q, qhead) {
+		if (mid->mid != buf->Mid ||
+		    mid->midState != MID_REQUEST_SUBMITTED ||
+		    mid->command != buf->Command)
+			continue;
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
+		ret = mid;
+		break;
+	}
+	spin_unlock(&GlobalMid_Lock);
+
+	return ret;
+}
+
 static int
 cifs_demultiplex_thread(void *p)
 {
@@ -487,7 +545,7 @@ cifs_demultiplex_thread(void *p)
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 	bool isLargeBuf = false;
-	bool isMultiRsp;
+	bool isMultiRsp = false;
 	int rc;
 
 	current->flags |= PF_MEMALLOC;
@@ -589,72 +647,10 @@ incomplete_rcv:
 			cifs_dump_mem("Bad SMB: ", buf,
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
