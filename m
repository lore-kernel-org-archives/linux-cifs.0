From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 3/7] CIFS: Move trans2 processing to ops struct
Date: Mon, 28 May 2012 13:30:10 +0400
Message-ID: <1338197414-22340-4-git-send-email-pshilovsky@samba.org>
References: <1338197414-22340-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338197414-22340-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    3 +
 fs/cifs/connect.c  |  160 +------------------------------------------------
 fs/cifs/smb1ops.c  |  170 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+), 159 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8e42c91..3b2d313 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -187,6 +187,9 @@ struct smb_version_operations {
 	/* verify the message */
 	int (*check_message)(char *, unsigned int);
 	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
+	/* process transaction2 response */
+	bool (*check_trans2)(struct mid_q_entry *, struct TCP_Server_Info *,
+			     char *, int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5402432..1c7af1d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -394,143 +394,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	return rc;
 }
 
-/*
-	return codes:
-		0 	not a transact2, or all data present
-		>0 	transact2 with that much data missing
-		-EINVAL = invalid transact2
-
- */
-static int check2ndT2(char *buf)
-{
-	struct smb_hdr *pSMB = (struct smb_hdr *)buf;
-	struct smb_t2_rsp *pSMBt;
-	int remaining;
-	__u16 total_data_size, data_in_this_rsp;
-
-	if (pSMB->Command != SMB_COM_TRANSACTION2)
-		return 0;
-
-	/* check for plausible wct, bcc and t2 data and parm sizes */
-	/* check for parm and data offset going beyond end of smb */
-	if (pSMB->WordCount != 10) { /* coalesce_t2 depends on this */
-		cFYI(1, "invalid transact2 word count");
-		return -EINVAL;
-	}
-
-	pSMBt = (struct smb_t2_rsp *)pSMB;
-
-	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
-	data_in_this_rsp = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
-
-	if (total_data_size == data_in_this_rsp)
-		return 0;
-	else if (total_data_size < data_in_this_rsp) {
-		cFYI(1, "total data %d smaller than data in frame %d",
-			total_data_size, data_in_this_rsp);
-		return -EINVAL;
-	}
-
-	remaining = total_data_size - data_in_this_rsp;
-
-	cFYI(1, "missing %d bytes from transact2, check next response",
-		remaining);
-	if (total_data_size > CIFSMaxBufSize) {
-		cERROR(1, "TotalDataSize %d is over maximum buffer %d",
-			total_data_size, CIFSMaxBufSize);
-		return -EINVAL;
-	}
-	return remaining;
-}
-
-static int coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
-{
-	struct smb_t2_rsp *pSMBs = (struct smb_t2_rsp *)second_buf;
-	struct smb_t2_rsp *pSMBt  = (struct smb_t2_rsp *)target_hdr;
-	char *data_area_of_tgt;
-	char *data_area_of_src;
-	int remaining;
-	unsigned int byte_count, total_in_tgt;
-	__u16 tgt_total_cnt, src_total_cnt, total_in_src;
-
-	src_total_cnt = get_unaligned_le16(&pSMBs->t2_rsp.TotalDataCount);
-	tgt_total_cnt = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
-
-	if (tgt_total_cnt != src_total_cnt)
-		cFYI(1, "total data count of primary and secondary t2 differ "
-			"source=%hu target=%hu", src_total_cnt, tgt_total_cnt);
-
-	total_in_tgt = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
-
-	remaining = tgt_total_cnt - total_in_tgt;
-
-	if (remaining < 0) {
-		cFYI(1, "Server sent too much data. tgt_total_cnt=%hu "
-			"total_in_tgt=%hu", tgt_total_cnt, total_in_tgt);
-		return -EPROTO;
-	}
-
-	if (remaining == 0) {
-		/* nothing to do, ignore */
-		cFYI(1, "no more data remains");
-		return 0;
-	}
-
-	total_in_src = get_unaligned_le16(&pSMBs->t2_rsp.DataCount);
-	if (remaining < total_in_src)
-		cFYI(1, "transact2 2nd response contains too much data");
-
-	/* find end of first SMB data area */
-	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
-				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
-
-	/* validate target area */
-	data_area_of_src = (char *)&pSMBs->hdr.Protocol +
-				get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
-
-	data_area_of_tgt += total_in_tgt;
-
-	total_in_tgt += total_in_src;
-	/* is the result too big for the field? */
-	if (total_in_tgt > USHRT_MAX) {
-		cFYI(1, "coalesced DataCount too large (%u)", total_in_tgt);
-		return -EPROTO;
-	}
-	put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCount);
-
-	/* fix up the BCC */
-	byte_count = get_bcc(target_hdr);
-	byte_count += total_in_src;
-	/* is the result too big for the field? */
-	if (byte_count > USHRT_MAX) {
-		cFYI(1, "coalesced BCC too large (%u)", byte_count);
-		return -EPROTO;
-	}
-	put_bcc(byte_count, target_hdr);
-
-	byte_count = be32_to_cpu(target_hdr->smb_buf_length);
-	byte_count += total_in_src;
-	/* don't allow buffer to overflow */
-	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-		cFYI(1, "coalesced BCC exceeds buffer size (%u)", byte_count);
-		return -ENOBUFS;
-	}
-	target_hdr->smb_buf_length = cpu_to_be32(byte_count);
-
-	/* copy second buffer into end of first buffer */
-	memcpy(data_area_of_tgt, data_area_of_src, total_in_src);
-
-	if (remaining != total_in_src) {
-		/* more responses to go */
-		cFYI(1, "waiting for more secondary responses");
-		return 1;
-	}
-
-	/* we are done */
-	cFYI(1, "found the last secondary response");
-	return 0;
-}
-
 static void
 cifs_echo_request(struct work_struct *work)
 {
@@ -803,29 +666,8 @@ static void
 handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	   char *buf, int malformed)
 {
-	if (malformed == 0 && check2ndT2(buf) > 0) {
-		mid->multiRsp = true;
-		if (mid->resp_buf) {
-			/* merge response - fix up 1st*/
-			malformed = coalesce_t2(buf, mid->resp_buf);
-			if (malformed > 0)
-				return;
-
-			/* All parts received or packet is malformed. */
-			mid->multiEnd = true;
-			return dequeue_mid(mid, malformed);
-		}
-		if (!server->large_buf) {
-			/*FIXME: switch to already allocated largebuf?*/
-			cERROR(1, "1st trans2 resp needs bigbuf");
-		} else {
-			/* Have first buffer */
-			mid->resp_buf = buf;
-			mid->large_buf = true;
-			server->bigbuf = NULL;
-		}
+	if (S_OP(server, check_trans2, false, mid, server, buf, malformed))
 		return;
-	}
 	mid->resp_buf = buf;
 	mid->large_buf = server->large_buf;
 	/* Was previous buf put in mpx struct for multi-rsp? */
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 6dec38f..28359e7 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -213,6 +213,175 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 	return mid;
 }
 
+/*
+	return codes:
+		0	not a transact2, or all data present
+		>0	transact2 with that much data missing
+		-EINVAL	invalid transact2
+ */
+static int
+check2ndT2(char *buf)
+{
+	struct smb_hdr *pSMB = (struct smb_hdr *)buf;
+	struct smb_t2_rsp *pSMBt;
+	int remaining;
+	__u16 total_data_size, data_in_this_rsp;
+
+	if (pSMB->Command != SMB_COM_TRANSACTION2)
+		return 0;
+
+	/* check for plausible wct, bcc and t2 data and parm sizes */
+	/* check for parm and data offset going beyond end of smb */
+	if (pSMB->WordCount != 10) { /* coalesce_t2 depends on this */
+		cFYI(1, "invalid transact2 word count");
+		return -EINVAL;
+	}
+
+	pSMBt = (struct smb_t2_rsp *)pSMB;
+
+	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
+	data_in_this_rsp = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
+
+	if (total_data_size == data_in_this_rsp)
+		return 0;
+	else if (total_data_size < data_in_this_rsp) {
+		cFYI(1, "total data %d smaller than data in frame %d",
+			total_data_size, data_in_this_rsp);
+		return -EINVAL;
+	}
+
+	remaining = total_data_size - data_in_this_rsp;
+
+	cFYI(1, "missing %d bytes from transact2, check next response",
+		remaining);
+	if (total_data_size > CIFSMaxBufSize) {
+		cERROR(1, "TotalDataSize %d is over maximum buffer %d",
+			total_data_size, CIFSMaxBufSize);
+		return -EINVAL;
+	}
+	return remaining;
+}
+
+static int
+coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
+{
+	struct smb_t2_rsp *pSMBs = (struct smb_t2_rsp *)second_buf;
+	struct smb_t2_rsp *pSMBt  = (struct smb_t2_rsp *)target_hdr;
+	char *data_area_of_tgt;
+	char *data_area_of_src;
+	int remaining;
+	unsigned int byte_count, total_in_tgt;
+	__u16 tgt_total_cnt, src_total_cnt, total_in_src;
+
+	src_total_cnt = get_unaligned_le16(&pSMBs->t2_rsp.TotalDataCount);
+	tgt_total_cnt = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
+
+	if (tgt_total_cnt != src_total_cnt)
+		cFYI(1, "total data count of primary and secondary t2 differ "
+			"source=%hu target=%hu", src_total_cnt, tgt_total_cnt);
+
+	total_in_tgt = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
+
+	remaining = tgt_total_cnt - total_in_tgt;
+
+	if (remaining < 0) {
+		cFYI(1, "Server sent too much data. tgt_total_cnt=%hu "
+			"total_in_tgt=%hu", tgt_total_cnt, total_in_tgt);
+		return -EPROTO;
+	}
+
+	if (remaining == 0) {
+		/* nothing to do, ignore */
+		cFYI(1, "no more data remains");
+		return 0;
+	}
+
+	total_in_src = get_unaligned_le16(&pSMBs->t2_rsp.DataCount);
+	if (remaining < total_in_src)
+		cFYI(1, "transact2 2nd response contains too much data");
+
+	/* find end of first SMB data area */
+	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
+				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
+
+	/* validate target area */
+	data_area_of_src = (char *)&pSMBs->hdr.Protocol +
+				get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
+
+	data_area_of_tgt += total_in_tgt;
+
+	total_in_tgt += total_in_src;
+	/* is the result too big for the field? */
+	if (total_in_tgt > USHRT_MAX) {
+		cFYI(1, "coalesced DataCount too large (%u)", total_in_tgt);
+		return -EPROTO;
+	}
+	put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCount);
+
+	/* fix up the BCC */
+	byte_count = get_bcc(target_hdr);
+	byte_count += total_in_src;
+	/* is the result too big for the field? */
+	if (byte_count > USHRT_MAX) {
+		cFYI(1, "coalesced BCC too large (%u)", byte_count);
+		return -EPROTO;
+	}
+	put_bcc(byte_count, target_hdr);
+
+	byte_count = be32_to_cpu(target_hdr->smb_buf_length);
+	byte_count += total_in_src;
+	/* don't allow buffer to overflow */
+	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+		cFYI(1, "coalesced BCC exceeds buffer size (%u)", byte_count);
+		return -ENOBUFS;
+	}
+	target_hdr->smb_buf_length = cpu_to_be32(byte_count);
+
+	/* copy second buffer into end of first buffer */
+	memcpy(data_area_of_tgt, data_area_of_src, total_in_src);
+
+	if (remaining != total_in_src) {
+		/* more responses to go */
+		cFYI(1, "waiting for more secondary responses");
+		return 1;
+	}
+
+	/* we are done */
+	cFYI(1, "found the last secondary response");
+	return 0;
+}
+
+static bool
+cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+		  char *buf, int malformed)
+{
+	if (malformed)
+		return false;
+	if (check2ndT2(buf) <= 0)
+		return false;
+	mid->multiRsp = true;
+	if (mid->resp_buf) {
+		/* merge response - fix up 1st*/
+		malformed = coalesce_t2(buf, mid->resp_buf);
+		if (malformed > 0)
+			return true;
+		/* All parts received or packet is malformed. */
+		mid->multiEnd = true;
+		dequeue_mid(mid, malformed);
+		return true;
+	}
+	if (!server->large_buf) {
+		/*FIXME: switch to already allocated largebuf?*/
+		cERROR(1, "1st trans2 resp needs bigbuf");
+	} else {
+		/* Have first buffer */
+		mid->resp_buf = buf;
+		mid->large_buf = true;
+		server->bigbuf = NULL;
+	}
+	return true;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -229,6 +398,7 @@ struct smb_version_operations smb1_operations = {
 	.check_message = checkSMB,
 	.dump_detail = cifs_dump_detail,
 	.is_oplock_break = is_valid_oplock_break,
+	.check_trans2 = cifs_check_trans2,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
