From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] cifs: sanitize length checking in coalesce_t2 (try #2)
Date: Wed, 27 Apr 2011 08:03:16 -0400
Message-ID: <1303905796-28087-1-git-send-email-jlayton@redhat.com>
References: <17747.1303828052@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <17747.1303828052-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There are a couple of places in this code where these values can wrap or
go negative, and that could potentially end up overflowing the buffer.
Ensure that that doesn't happen. Do all of the length calculation and
checks first, and only perform the memcpy after they pass.

Also, increase some stack variables to 32 bits to ensure that they don't
wrap without being detected.

Finally, change the error codes to be a bit more descriptive of any
problems detected. -EINVAL isn't very accurate.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Reported-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index db9d55b..77031a3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -274,7 +274,8 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	char *data_area_of_target;
 	char *data_area_of_buf2;
 	int remaining;
-	__u16 byte_count, total_data_size, total_in_buf, total_in_buf2;
+	unsigned int byte_count, total_in_buf;
+	__u16 total_data_size, total_in_buf2;
 
 	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
 
@@ -287,7 +288,7 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	remaining = total_data_size - total_in_buf;
 
 	if (remaining < 0)
-		return -EINVAL;
+		return -EPROTO;
 
 	if (remaining == 0) /* nothing to do, ignore */
 		return 0;
@@ -308,20 +309,30 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	data_area_of_target += total_in_buf;
 
 	/* copy second buffer into end of first buffer */
-	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
 	total_in_buf += total_in_buf2;
+
+	/* is the result too big for the field? */
+	if (total_in_buf & USHRT_MAX)
+		return -EPROTO;
 	put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCount);
+
 	byte_count = get_bcc_le(pTargetSMB);
 	byte_count += total_in_buf2;
+
+	/* is the result too big for the field? */
+	if (byte_count & USHRT_MAX)
+		return -EPROTO;
 	put_bcc_le(byte_count, pTargetSMB);
 
 	byte_count = pTargetSMB->smb_buf_length;
 	byte_count += total_in_buf2;
-
-	/* BB also add check that we are not beyond maximum buffer size */
-
+	/* don't allow buffer to overflow */
+	if (byte_count > CIFSMaxBufSize)
+		return -ENOBUFS;
 	pTargetSMB->smb_buf_length = byte_count;
 
+	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
+
 	if (remaining == total_in_buf2) {
 		cFYI(1, "found the last secondary response");
 		return 0; /* we are done */
-- 
1.7.4.4
