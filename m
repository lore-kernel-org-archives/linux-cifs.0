From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] cifs: refactor mid finding loop in cifs_demultiplex_thread
Date: Tue, 26 Apr 2011 08:03:20 -0400
Message-ID: <1303819401-14789-5-git-send-email-jlayton@redhat.com>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303819401-14789-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...to reduce the extreme indentation. This should introduce no
behavioral changes.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   92 ++++++++++++++++++++++++++--------------------------
 1 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a038f29..a2cde4c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -616,59 +616,59 @@ incomplete_rcv:
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 
-			if ((mid_entry->mid == smb_buffer->Mid) &&
-			    (mid_entry->midState == MID_REQUEST_SUBMITTED) &&
-			    (mid_entry->command == smb_buffer->Command)) {
-				if (length == 0 &&
-				   check2ndT2(smb_buffer, server->maxBuf) > 0) {
-					/* We have a multipart transact2 resp */
-					isMultiRsp = true;
-					if (mid_entry->resp_buf) {
-						/* merge response - fix up 1st*/
-						if (coalesce_t2(smb_buffer,
+			if (mid_entry->mid != smb_buffer->Mid ||
+			    mid_entry->midState != MID_REQUEST_SUBMITTED ||
+			    mid_entry->command != smb_buffer->Command) {
+				mid_entry = NULL;
+				continue;
+			}
+
+			if (length == 0 &&
+			    check2ndT2(smb_buffer, server->maxBuf) > 0) {
+				/* We have a multipart transact2 resp */
+				isMultiRsp = true;
+				if (mid_entry->resp_buf) {
+					/* merge response - fix up 1st*/
+					if (coalesce_t2(smb_buffer,
 							mid_entry->resp_buf)) {
-							mid_entry->multiRsp =
-								 true;
-							break;
-						} else {
-							/* all parts received */
-							mid_entry->multiEnd =
-								 true;
-							goto multi_t2_fnd;
-						}
+						mid_entry->multiRsp = true;
+						break;
 					} else {
-						if (!isLargeBuf) {
-							cERROR(1, "1st trans2 resp needs bigbuf");
-					/* BB maybe we can fix this up,  switch
-					   to already allocated large buffer? */
-						} else {
-							/* Have first buffer */
-							mid_entry->resp_buf =
-								 smb_buffer;
-							mid_entry->largeBuf =
-								 true;
-							bigbuf = NULL;
-						}
+						/* all parts received */
+						mid_entry->multiEnd = true;
+						goto multi_t2_fnd;
+					}
+				} else {
+					if (!isLargeBuf) {
+						/*
+						 * FIXME: switch to already
+						 *        allocated largebuf?
+						 */
+						cERROR(1, "1st trans2 resp "
+							  "needs bigbuf");
+					} else {
+						/* Have first buffer */
+						mid_entry->resp_buf =
+							 smb_buffer;
+						mid_entry->largeBuf = true;
+						bigbuf = NULL;
 					}
-					break;
 				}
-				mid_entry->resp_buf = smb_buffer;
-				mid_entry->largeBuf = isLargeBuf;
+				break;
+			}
+			mid_entry->resp_buf = smb_buffer;
+			mid_entry->largeBuf = isLargeBuf;
 multi_t2_fnd:
-				if (length == 0)
-					mid_entry->midState =
-							MID_RESPONSE_RECEIVED;
-				else
-					mid_entry->midState =
-							MID_RESPONSE_MALFORMED;
+			if (length == 0)
+				mid_entry->midState = MID_RESPONSE_RECEIVED;
+			else
+				mid_entry->midState = MID_RESPONSE_MALFORMED;
 #ifdef CONFIG_CIFS_STATS2
-				mid_entry->when_received = jiffies;
+			mid_entry->when_received = jiffies;
 #endif
-				list_del_init(&mid_entry->qhead);
-				mid_entry->callback(mid_entry);
-				break;
-			}
-			mid_entry = NULL;
+			list_del_init(&mid_entry->qhead);
+			mid_entry->callback(mid_entry);
+			break;
 		}
 		spin_unlock(&GlobalMid_Lock);
 
-- 
1.7.4.4
