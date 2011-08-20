From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/14] cifs: eliminate is_multi_rsp parm to find_cifs_mid
Date: Fri, 19 Aug 2011 21:55:35 -0400
Message-ID: <1313805339-1233-11-git-send-email-jlayton@redhat.com>
References: <1313805339-1233-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313805339-1233-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Change find_cifs_mid to only return NULL if a mid could not be found.
If we got part of a multi-part T2 response, then coalesce it and still
return the mid. The caller can determine the T2 receive status from
the flags in the mid.

With this change, there is no need to pass a pointer to "length" as
well and just pass by value. If a mid is found, then we can just mark
it as malformed. If one isn't found, then the value of "length" won't
change anyway.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   35 ++++++++++++++++-------------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index bfd9622..49c7eee 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -563,8 +563,7 @@ dequeue_mid(struct mid_q_entry *mid, int malformed)
 
 static struct mid_q_entry *
 find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
-	      int *malformed, bool is_large_buf, bool *is_multi_rsp,
-	      char **bigbuf)
+	      int malformed, bool is_large_buf, char **bigbuf)
 {
 	struct mid_q_entry *mid = NULL;
 
@@ -572,16 +571,14 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
 	if (!mid)
 		return mid;
 
-	if (*malformed == 0 && check2ndT2(buf) > 0) {
-		/* We have a multipart transact2 resp */
-		*is_multi_rsp = true;
+	if (malformed == 0 && check2ndT2(buf) > 0) {
+		mid->multiRsp = true;
 		if (mid->resp_buf) {
 			/* merge response - fix up 1st*/
-			*malformed = coalesce_t2(buf, mid->resp_buf);
-			if (*malformed > 0) {
-				*malformed = 0;
-				mid->multiRsp = true;
-				return NULL;
+			malformed = coalesce_t2(buf, mid->resp_buf);
+			if (malformed > 0) {
+				malformed = 0;
+				return mid;
 			}
 			/* All parts received or packet is malformed. */
 			mid->multiEnd = true;
@@ -601,7 +598,7 @@ find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
 	mid->resp_buf = buf;
 	mid->largeBuf = is_large_buf;
 multi_t2_fnd:
-	dequeue_mid(mid, *malformed);
+	dequeue_mid(mid, malformed);
 	return mid;
 }
 
@@ -711,7 +708,6 @@ cifs_demultiplex_thread(void *p)
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 	bool isLargeBuf = false;
-	bool isMultiRsp = false;
 
 	current->flags |= PF_MEMALLOC;
 	cFYI(1, "Demultiplex PID: %d", task_pid_nr(current));
@@ -731,7 +727,6 @@ cifs_demultiplex_thread(void *p)
 			continue;
 
 		isLargeBuf = false;
-		isMultiRsp = false;
 		smb_buffer = (struct smb_hdr *)smallbuf;
 		buf = smallbuf;
 		pdu_length = 4; /* enough to get RFC1001 header */
@@ -809,23 +804,25 @@ cifs_demultiplex_thread(void *p)
 
 		server->lstrp = jiffies;
 
-		mid_entry = find_cifs_mid(server, smb_buffer, &length,
-					  isLargeBuf, &isMultiRsp, &bigbuf);
+		mid_entry = find_cifs_mid(server, smb_buffer, length,
+					  isLargeBuf, &bigbuf);
 		if (mid_entry != NULL) {
-			mid_entry->callback(mid_entry);
+			if (mid_entry->multiRsp && !mid_entry->multiEnd)
+				continue;
+
 			/* Was previous buf put in mpx struct for multi-rsp? */
-			if (!isMultiRsp) {
+			if (!mid_entry->multiRsp) {
 				/* smb buffer will be freed by user thread */
 				if (isLargeBuf)
 					bigbuf = NULL;
 				else
 					smallbuf = NULL;
 			}
+			mid_entry->callback(mid_entry);
 		} else if (length != 0) {
 			/* response sanity checks failed */
 			continue;
-		} else if (!is_valid_oplock_break(smb_buffer, server) &&
-			   !isMultiRsp) {
+		} else if (!is_valid_oplock_break(smb_buffer, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
 			cifs_dump_mem("Received Data is: ", buf,
-- 
1.7.6
