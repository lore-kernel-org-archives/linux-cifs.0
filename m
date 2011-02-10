From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't always drop malformed replies on the floor (try #3)
Date: Thu, 10 Feb 2011 08:05:28 -0500
Message-ID: <1297343128-29236-1-git-send-email-jlayton@redhat.com>
References: <AANLkTiniSV+ys2nnTjiBtncr3QccppbFVXEHWiiUxpXX@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTiniSV+ys2nnTjiBtncr3QccppbFVXEHWiiUxpXX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Slight revision to this patch...use min_t() instead of conditional
assignment. Also, remove the FIXME comment and replace it with the
explanation that Steve gave earlier.

After receiving a packet, we currently check the header. If it's no
good, then we toss it out and continue the loop, leaving the caller
waiting on that response.

In cases where the packet has length inconsistencies, but the MID is
valid, this leads to unneeded delays. That's especially problematic now
that the client waits indefinitely for responses.

Instead, don't immediately discard the packet if checkSMB fails. Try to
find a matching mid_q_entry, mark it as having a malformed response and
issue the callback.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    2 +-
 fs/cifs/connect.c   |   30 ++++++++++++++++++++++++------
 fs/cifs/transport.c |    3 +++
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1ab33eb..17afb0f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -654,7 +654,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   MID_REQUEST_SUBMITTED 2
 #define   MID_RESPONSE_RECEIVED 4
 #define   MID_RETRY_NEEDED      8 /* session closed while this request out */
-#define   MID_NO_RESP_NEEDED 0x10
+#define   MID_RESPONSE_MALFORMED 0x10
 
 /* Types of response buffer returned from SendReceive2 */
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 161f24c..eb56e0f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -586,11 +586,20 @@ incomplete_rcv:
 		total_read += 4; /* account for rfc1002 hdr */
 
 		dump_smb(smb_buffer, total_read);
-		if (checkSMB(smb_buffer, smb_buffer->Mid, total_read)) {
+
+		/*
+		 * We know that we received enough to get to the MID as we
+		 * checked the pdu_length earlier. Now check to see
+		 * if the rest of the header is OK. We borrow the length
+		 * var for the rest of the loop to avoid a new stack var.
+		 *
+		 * 48 bytes is enough to display the header and a little bit
+		 * into the payload for debugging purposes.
+		 */
+		length = checkSMB(smb_buffer, smb_buffer->Mid, total_read);
+		if (length != 0)
 			cifs_dump_mem("Bad SMB: ", smb_buffer,
-					total_read < 48 ? total_read : 48);
-			continue;
-		}
+					min_t(unsigned int, total_read, 48));
 
 		mid_entry = NULL;
 		server->lstrp = jiffies;
@@ -602,7 +611,8 @@ incomplete_rcv:
 			if ((mid_entry->mid == smb_buffer->Mid) &&
 			    (mid_entry->midState == MID_REQUEST_SUBMITTED) &&
 			    (mid_entry->command == smb_buffer->Command)) {
-				if (check2ndT2(smb_buffer,server->maxBuf) > 0) {
+				if (length == 0 &&
+				    check2ndT2(smb_buffer,server->maxBuf) > 0) {
 					/* We have a multipart transact2 resp */
 					isMultiRsp = true;
 					if (mid_entry->resp_buf) {
@@ -637,7 +647,12 @@ incomplete_rcv:
 				mid_entry->resp_buf = smb_buffer;
 				mid_entry->largeBuf = isLargeBuf;
 multi_t2_fnd:
-				mid_entry->midState = MID_RESPONSE_RECEIVED;
+				if (length == 0)
+					mid_entry->midState =
+							MID_RESPONSE_RECEIVED;
+				else
+					mid_entry->midState =
+							MID_RESPONSE_MALFORMED;
 #ifdef CONFIG_CIFS_STATS2
 				mid_entry->when_received = jiffies;
 #endif
@@ -658,6 +673,9 @@ multi_t2_fnd:
 				else
 					smallbuf = NULL;
 			}
+		} else if (length != 0) {
+			/* response sanity checks failed */
+			continue;
 		} else if (!is_valid_oplock_break(smb_buffer, server) &&
 			   !isMultiRsp) {
 			cERROR(1, "No task to wake, unknown frame received! "
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index fbc5aac..46d8756 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -457,6 +457,9 @@ sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 	case MID_RETRY_NEEDED:
 		rc = -EAGAIN;
 		break;
+	case MID_RESPONSE_MALFORMED:
+		rc = -EIO;
+		break;
 	default:
 		cERROR(1, "%s: invalid mid state mid=%d state=%d", __func__,
 			mid->mid, mid->midState);
-- 
1.7.4
