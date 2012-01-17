From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: better instrumentation for coalesce_t2
Date: Tue, 17 Jan 2012 16:40:11 -0500
Message-ID: <1326836411-6932-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When coalesce_t2 returns an error, have it throw a cFYI message that
explains the reason. Also rename some variables to clarify what they
represent.

Reported-and-Tested-by: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   84 +++++++++++++++++++++++++++++++---------------------
 1 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4666780..5cc1585 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -225,74 +225,90 @@ static int check2ndT2(struct smb_hdr *pSMB)
 
 static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 {
-	struct smb_t2_rsp *pSMB2 = (struct smb_t2_rsp *)psecond;
+	struct smb_t2_rsp *pSMBs = (struct smb_t2_rsp *)psecond;
 	struct smb_t2_rsp *pSMBt  = (struct smb_t2_rsp *)pTargetSMB;
-	char *data_area_of_target;
-	char *data_area_of_buf2;
+	char *data_area_of_tgt;
+	char *data_area_of_src;
 	int remaining;
-	unsigned int byte_count, total_in_buf;
-	__u16 total_data_size, total_in_buf2;
+	unsigned int byte_count, total_in_tgt;
+	__u16 tgt_total_cnt, src_total_cnt, total_in_src;
 
-	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
+	src_total_cnt = get_unaligned_le16(&pSMBs->t2_rsp.TotalDataCount);
+	tgt_total_cnt = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
 
-	if (total_data_size !=
-	    get_unaligned_le16(&pSMB2->t2_rsp.TotalDataCount))
-		cFYI(1, "total data size of primary and secondary t2 differ");
+	if (tgt_total_cnt != src_total_cnt)
+		cFYI(1, "total data count of primary and secondary t2 differ "
+			"source=%hu target=%hu", src_total_cnt, tgt_total_cnt);
 
-	total_in_buf = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
+	total_in_tgt = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
 
-	remaining = total_data_size - total_in_buf;
+	remaining = tgt_total_cnt - total_in_tgt;
 
-	if (remaining < 0)
+	if (remaining < 0) {
+		cFYI(1, "Server sent too much data. tgt_total_cnt=%hu "
+			"total_in_tgt=%hu", tgt_total_cnt, total_in_tgt);
 		return -EPROTO;
+	}
 
-	if (remaining == 0) /* nothing to do, ignore */
+	if (remaining == 0) {
+		/* nothing to do, ignore */
+		cFYI(1, "no more data remains");
 		return 0;
+	}
 
-	total_in_buf2 = get_unaligned_le16(&pSMB2->t2_rsp.DataCount);
-	if (remaining < total_in_buf2) {
+	total_in_src = get_unaligned_le16(&pSMBs->t2_rsp.DataCount);
+	if (remaining < total_in_src)
 		cFYI(1, "transact2 2nd response contains too much data");
-	}
 
 	/* find end of first SMB data area */
-	data_area_of_target = (char *)&pSMBt->hdr.Protocol +
+	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
 				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
-	/* validate target area */
 
-	data_area_of_buf2 = (char *)&pSMB2->hdr.Protocol +
-				get_unaligned_le16(&pSMB2->t2_rsp.DataOffset);
+	/* validate target area */
+	data_area_of_src = (char *)&pSMBs->hdr.Protocol +
+				get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
 
-	data_area_of_target += total_in_buf;
+	data_area_of_tgt += total_in_tgt;
 
-	/* copy second buffer into end of first buffer */
-	total_in_buf += total_in_buf2;
+	total_in_tgt += total_in_src;
 	/* is the result too big for the field? */
-	if (total_in_buf > USHRT_MAX)
+	if (total_in_tgt > USHRT_MAX) {
+		cFYI(1, "coalesced DataCount too large (%u)", total_in_tgt);
 		return -EPROTO;
-	put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCount);
+	}
+	put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCount);
 
 	/* fix up the BCC */
 	byte_count = get_bcc(pTargetSMB);
-	byte_count += total_in_buf2;
+	byte_count += total_in_src;
 	/* is the result too big for the field? */
-	if (byte_count > USHRT_MAX)
+	if (byte_count > USHRT_MAX) {
+		cFYI(1, "coalesced BCC too large (%u)", byte_count);
 		return -EPROTO;
+	}
 	put_bcc(byte_count, pTargetSMB);
 
 	byte_count = be32_to_cpu(pTargetSMB->smb_buf_length);
-	byte_count += total_in_buf2;
+	byte_count += total_in_src;
 	/* don't allow buffer to overflow */
-	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4)
+	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+		cFYI(1, "coalesced BCC exceeds buffer size (%u)", byte_count);
 		return -ENOBUFS;
+	}
 	pTargetSMB->smb_buf_length = cpu_to_be32(byte_count);
 
-	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
+	/* copy second buffer into end of first buffer */
+	memcpy(data_area_of_tgt, data_area_of_src, total_in_src);
 
-	if (remaining == total_in_buf2) {
-		cFYI(1, "found the last secondary response");
-		return 0; /* we are done */
-	} else /* more responses to go */
+	if (remaining != total_in_src) {
+		/* more responses to go */
+		cFYI(1, "waiting for more secondary responses");
 		return 1;
+	}
+
+	/* we are done */
+	cFYI(1, "found the last secondary response");
+	return 0;
 }
 
 static void
-- 
1.7.7.5
