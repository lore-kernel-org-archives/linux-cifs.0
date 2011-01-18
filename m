From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] cifs: fix unaligned access in check2ndT2 and coalesce_t2
Date: Tue, 18 Jan 2011 15:33:17 -0500
Message-ID: <1295382799-7902-4-git-send-email-jlayton@redhat.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9bcdf2b..d5b779e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -232,9 +232,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
 static int check2ndT2(struct smb_hdr *pSMB, unsigned int maxBufSize)
 {
 	struct smb_t2_rsp *pSMBt;
-	int total_data_size;
-	int data_in_this_rsp;
 	int remaining;
+	__u16 total_data_size, data_in_this_rsp;
 
 	if (pSMB->Command != SMB_COM_TRANSACTION2)
 		return 0;
@@ -248,8 +247,8 @@ static int check2ndT2(struct smb_hdr *pSMB, unsigned int maxBufSize)
 
 	pSMBt = (struct smb_t2_rsp *)pSMB;
 
-	total_data_size = le16_to_cpu(pSMBt->t2_rsp.TotalDataCount);
-	data_in_this_rsp = le16_to_cpu(pSMBt->t2_rsp.DataCount);
+	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
+	data_in_this_rsp = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
 
 	remaining = total_data_size - data_in_this_rsp;
 
@@ -275,21 +274,18 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 {
 	struct smb_t2_rsp *pSMB2 = (struct smb_t2_rsp *)psecond;
 	struct smb_t2_rsp *pSMBt  = (struct smb_t2_rsp *)pTargetSMB;
-	int total_data_size;
-	int total_in_buf;
-	int remaining;
-	int total_in_buf2;
 	char *data_area_of_target;
 	char *data_area_of_buf2;
-	__u16 byte_count;
+	int remaining;
+	__u16 byte_count, total_data_size, total_in_buf, total_in_buf2;
 
-	total_data_size = le16_to_cpu(pSMBt->t2_rsp.TotalDataCount);
+	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
 
-	if (total_data_size != le16_to_cpu(pSMB2->t2_rsp.TotalDataCount)) {
+	if (total_data_size !=
+	    get_unaligned_le16(&pSMB2->t2_rsp.TotalDataCount))
 		cFYI(1, "total data size of primary and secondary t2 differ");
-	}
 
-	total_in_buf = le16_to_cpu(pSMBt->t2_rsp.DataCount);
+	total_in_buf = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
 
 	remaining = total_data_size - total_in_buf;
 
@@ -299,25 +295,25 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	if (remaining == 0) /* nothing to do, ignore */
 		return 0;
 
-	total_in_buf2 = le16_to_cpu(pSMB2->t2_rsp.DataCount);
+	total_in_buf2 = get_unaligned_le16(&pSMB2->t2_rsp.DataCount);
 	if (remaining < total_in_buf2) {
 		cFYI(1, "transact2 2nd response contains too much data");
 	}
 
 	/* find end of first SMB data area */
 	data_area_of_target = (char *)&pSMBt->hdr.Protocol +
-				le16_to_cpu(pSMBt->t2_rsp.DataOffset);
+				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
 	/* validate target area */
 
-	data_area_of_buf2 = (char *) &pSMB2->hdr.Protocol +
-					le16_to_cpu(pSMB2->t2_rsp.DataOffset);
+	data_area_of_buf2 = (char *)&pSMB2->hdr.Protocol +
+				get_unaligned_le16(&pSMB2->t2_rsp.DataOffset);
 
 	data_area_of_target += total_in_buf;
 
 	/* copy second buffer into end of first buffer */
 	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
 	total_in_buf += total_in_buf2;
-	pSMBt->t2_rsp.DataCount = cpu_to_le16(total_in_buf);
+	put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCount);
 	byte_count = get_bcc_le(pTargetSMB);
 	byte_count += total_in_buf2;
 	put_bcc_le(byte_count, pTargetSMB);
@@ -334,7 +330,6 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 		return 0; /* we are done */
 	} else /* more responses to go */
 		return 1;
-
 }
 
 static void
-- 
1.7.3.4
