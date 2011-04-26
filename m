From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] cifs: handle errors from coalesce_t2
Date: Tue, 26 Apr 2011 08:03:21 -0400
Message-ID: <1303819401-14789-6-git-send-email-jlayton@redhat.com>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303819401-14789-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs_demultiplex_thread calls coalesce_t2 to try and merge follow-on t2
responses into the original mid buffer. coalesce_t2 however can return
errors, but the caller doesn't handle that situation properly. Fix the
thread to treat such a case as it would a malformed packet. Mark the
mid as being malformed and issue the callback.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a2cde4c..d025249 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -629,12 +629,16 @@ incomplete_rcv:
 				isMultiRsp = true;
 				if (mid_entry->resp_buf) {
 					/* merge response - fix up 1st*/
-					if (coalesce_t2(smb_buffer,
-							mid_entry->resp_buf)) {
+					length = coalesce_t2(smb_buffer,
+							mid_entry->resp_buf);
+					if (length > 0) {
+						length = 0;
 						mid_entry->multiRsp = true;
 						break;
 					} else {
-						/* all parts received */
+						/* all parts received or
+						 * packet is malformed
+						 */
 						mid_entry->multiEnd = true;
 						goto multi_t2_fnd;
 					}
-- 
1.7.4.4
