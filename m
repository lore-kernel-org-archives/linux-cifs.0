From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] cifs: clean up length checks in check2ndT2
Date: Thu, 31 Mar 2011 17:36:44 -0400
Message-ID: <1301607405-4379-5-git-send-email-jlayton@redhat.com>
References: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301607405-4379-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thus spake David Howells:

The code that follows this:

  	remaining = total_data_size - data_in_this_rsp;
	if (remaining == 0)
		return 0;
	else if (remaining < 0) {

generates better code if you drop the 'remaining' variable and compare
the values directly.

Clean it up per his recommendation...

Reported-and-acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 66d8de3..94e60c5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -251,24 +251,24 @@ static int check2ndT2(struct smb_hdr *pSMB, unsigned int maxBufSize)
 	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
 	data_in_this_rsp = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
 
-	remaining = total_data_size - data_in_this_rsp;
-
-	if (remaining == 0)
+	if (total_data_size == data_in_this_rsp)
 		return 0;
-	else if (remaining < 0) {
+	else if (total_data_size < data_in_this_rsp) {
 		cFYI(1, "total data %d smaller than data in frame %d",
 			total_data_size, data_in_this_rsp);
 		return -EINVAL;
-	} else {
-		cFYI(1, "missing %d bytes from transact2, check next response",
-			remaining);
-		if (total_data_size > maxBufSize) {
-			cERROR(1, "TotalDataSize %d is over maximum buffer %d",
-				total_data_size, maxBufSize);
-			return -EINVAL;
-		}
-		return remaining;
 	}
+
+	remaining = total_data_size - data_in_this_rsp;
+
+	cFYI(1, "missing %d bytes from transact2, check next response",
+		remaining);
+	if (total_data_size > maxBufSize) {
+		cERROR(1, "TotalDataSize %d is over maximum buffer %d",
+			total_data_size, maxBufSize);
+		return -EINVAL;
+	}
+	return remaining;
 }
 
 static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
-- 
1.7.4
