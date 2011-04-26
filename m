From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] cifs: sanitize length checking in coalesce_t2
Date: Tue, 26 Apr 2011 08:03:19 -0400
Message-ID: <1303819401-14789-4-git-send-email-jlayton@redhat.com>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303819401-14789-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There are a couple of places in this code where these values can wrap or
go negative, and that could potentially end up overflowing the buffer.
Ensure that that doesn't happen. Do all of the length calculation and
checks first, and only perform the memcpy after they pass.

Also, increase some of the field sizes to 32 bits to ensure that they
don't wrap without being detected.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Reported-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index db9d55b..a038f29 100644
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
 
@@ -308,20 +309,28 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	data_area_of_target += total_in_buf;
 
 	/* copy second buffer into end of first buffer */
-	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
 	total_in_buf += total_in_buf2;
+	/* did this field "wrap" ? */
+	if (total_in_buf & ~((1<<16)-1))
+		return -EINVAL;
 	put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCount);
+
 	byte_count = get_bcc_le(pTargetSMB);
 	byte_count += total_in_buf2;
+	/* did this field "wrap" ? */
+	if (byte_count & ~((1<<16)-1))
+		return -EINVAL;
 	put_bcc_le(byte_count, pTargetSMB);
 
 	byte_count = pTargetSMB->smb_buf_length;
 	byte_count += total_in_buf2;
-
-	/* BB also add check that we are not beyond maximum buffer size */
-
+	/* don't allow buffer to overflow */
+	if (byte_count > CIFSMaxBufSize)
+		return -EINVAL;
 	pTargetSMB->smb_buf_length = byte_count;
 
+	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
+
 	if (remaining == total_in_buf2) {
 		cFYI(1, "found the last secondary response");
 		return 0; /* we are done */
-- 
1.7.4.4
