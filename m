From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/9] cifs: move mid finding into separate routine
Date: Wed, 19 Oct 2011 09:16:54 -0400
Message-ID: <1319030219-3811-5-git-send-email-jlayton@redhat.com>
References: <1319030219-3811-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319030219-3811-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Begin breaking up find_cifs_mid into smaller pieces. The parts that
coalesce T2 responses don't really need to be done under the
GlobalMid_lock anyway. Create a new function that just finds the
mid on the list, and then later takes it off the list if the entire
response has been received.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |  113 +++++++++++++++++++++++++++++++----------------------
 1 files changed, 66 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5308bc6..0f69b31 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -542,61 +542,80 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 }
 
 static struct mid_q_entry *
-find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
-	      int *length, bool is_large_buf, bool *is_multi_rsp, char **bigbuf)
+find_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
 {
-	struct mid_q_entry *mid = NULL, *tmp_mid, *ret = NULL;
+	struct mid_q_entry *mid;
 
 	spin_lock(&GlobalMid_Lock);
-	list_for_each_entry_safe(mid, tmp_mid, &server->pending_mid_q, qhead) {
-		if (mid->mid != buf->Mid ||
-		    mid->midState != MID_REQUEST_SUBMITTED ||
-		    mid->command != buf->Command)
-			continue;
-
-		if (*length == 0 && check2ndT2(buf) > 0) {
-			/* We have a multipart transact2 resp */
-			*is_multi_rsp = true;
-			if (mid->resp_buf) {
-				/* merge response - fix up 1st*/
-				*length = coalesce_t2(buf, mid->resp_buf);
-				if (*length > 0) {
-					*length = 0;
-					mid->multiRsp = true;
-					break;
-				}
-				/* All parts received or packet is malformed. */
-				mid->multiEnd = true;
-				goto multi_t2_fnd;
-			}
-			if (!is_large_buf) {
-				/*FIXME: switch to already allocated largebuf?*/
-				cERROR(1, "1st trans2 resp needs bigbuf");
-			} else {
-				/* Have first buffer */
-				mid->resp_buf = buf;
-				mid->largeBuf = true;
-				*bigbuf = NULL;
-			}
-			break;
+	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
+		if (mid->mid == buf->Mid &&
+		    mid->midState == MID_REQUEST_SUBMITTED &&
+		    mid->command == buf->Command) {
+			spin_unlock(&GlobalMid_Lock);
+			return mid;
 		}
-		mid->resp_buf = buf;
-		mid->largeBuf = is_large_buf;
-multi_t2_fnd:
-		if (*length == 0)
-			mid->midState = MID_RESPONSE_RECEIVED;
-		else
-			mid->midState = MID_RESPONSE_MALFORMED;
+	}
+	spin_unlock(&GlobalMid_Lock);
+	return NULL;
+}
+
+static void
+dequeue_mid(struct mid_q_entry *mid, int malformed)
+{
 #ifdef CONFIG_CIFS_STATS2
-		mid->when_received = jiffies;
+	mid->when_received = jiffies;
 #endif
-		list_del_init(&mid->qhead);
-		ret = mid;
-		break;
-	}
+	spin_lock(&GlobalMid_Lock);
+	if (!malformed)
+		mid->midState = MID_RESPONSE_RECEIVED;
+	else
+		mid->midState = MID_RESPONSE_MALFORMED;
+	list_del_init(&mid->qhead);
 	spin_unlock(&GlobalMid_Lock);
+}
 
-	return ret;
+static struct mid_q_entry *
+find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
+	      int *malformed, bool is_large_buf, bool *is_multi_rsp,
+	      char **bigbuf)
+{
+	struct mid_q_entry *mid = NULL;
+
+	mid = find_mid(server, buf);
+	if (!mid)
+		return mid;
+
+	if (*malformed == 0 && check2ndT2(buf) > 0) {
+		/* We have a multipart transact2 resp */
+		*is_multi_rsp = true;
+		if (mid->resp_buf) {
+			/* merge response - fix up 1st*/
+			*malformed = coalesce_t2(buf, mid->resp_buf);
+			if (*malformed > 0) {
+				*malformed = 0;
+				mid->multiRsp = true;
+				return NULL;
+			}
+			/* All parts received or packet is malformed. */
+			mid->multiEnd = true;
+			goto multi_t2_fnd;
+		}
+		if (!is_large_buf) {
+			/*FIXME: switch to already allocated largebuf?*/
+			cERROR(1, "1st trans2 resp needs bigbuf");
+		} else {
+			/* Have first buffer */
+			mid->resp_buf = buf;
+			mid->largeBuf = true;
+			*bigbuf = NULL;
+		}
+		return mid;
+	}
+	mid->resp_buf = buf;
+	mid->largeBuf = is_large_buf;
+multi_t2_fnd:
+	dequeue_mid(mid, *malformed);
+	return mid;
 }
 
 static void clean_demultiplex_info(struct TCP_Server_Info *server)
-- 
1.7.6.4
