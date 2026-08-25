Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5552BEFE8
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 03:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787627410; cv=none; b=SDfSPIzdviVGhmUqCjjV0grgWu3LfGqX7s/erSZNKFjrb7ZQ5X0EuuLE8lUmq7cMX9Elpa8l8LdDm3HyaDDKFQg9vSZWITyITAfTWQd5y4cl6dL6g61IQJypi3wYCqjOFY97awfoN5VvoNIanEjMuI9fXlJnmOuJCys1Wc04BmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787627410; c=relaxed/simple;
	bh=VjzzJJY0REmFePmGv+un+MKumTAgaDWAEIs3xP9m4z0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JQS5Ixyl97z8AiRjC3GC0x/MEcvSayr2+JgFUuW3HtKh3uYCxBwQLUQqiY7uLdJ1pHhT5WoJAMgpe2mcxOCQh8FI+HVsTSkPjRCI5VRmQe/8MnjYY+w2fhTkXJTJVaC8sh5gCeRdv/5RaVoYLYpH0Jr2qP+kKuvMYHLS5x0XBaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S2S9ccff; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=k8eGBZI6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S2S9ccff";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="k8eGBZI6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787627407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Q7kJ9NxSCjyWswzqtIaS+F9FDZ/yEUyNYfEg9Rn62g8=;
	b=S2S9ccffGUUoSK3n1SbE6gXIv9P+mypwt26Z5JrgLzjvS6Cfi7Hz36NYbe9CGvpY68nDKo
	UI5S5znKzkc0gMpWCAuuNgvmwTKjyVWxuqO5OqZnGQPuKRyIrgtiEUOoiupAkdyEvog3d4
	hwbFmEqYiNwJOYDwHV1hv7NdA/0xO0g=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-1O8QqTOmPJ20PMcm4MxK3w-1; Mon, 24 Aug 2026 23:10:05 -0400
X-MC-Unique: 1O8QqTOmPJ20PMcm4MxK3w-1
X-Mimecast-MFC-AGG-ID: 1O8QqTOmPJ20PMcm4MxK3w_1787627405
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f283baf1fso5986671a91.3
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 20:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787627405; x=1788232205; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q7kJ9NxSCjyWswzqtIaS+F9FDZ/yEUyNYfEg9Rn62g8=;
        b=k8eGBZI63AblS20YfF/8SPIDnSC53KO6cYe2TTus4fU52pusnJaRBm7vsCm3xcYdNz
         h7PCBi1m38fH44ivZv2DuvUoOW2mRSgOBfC3W/AQNgZSlDa6GgAIV0ebRtryb618tf1g
         nua/bbSyL0dJpGz/+k0BYAAW7BsxbQdzO6m0Y0pTiGx+QxB0XWiyezTk4E3YDtyL1ceS
         smrbT9dnZ4XErikxm7iHYuYNYHOMCjUIVxTo1NYqVhak1dQJ5k2ZKy+R3lrOGgRgxW1y
         3gwkty6LL4tu47Eh2ypPJ2mSjrXNjPXsDG1XgY3Aw0onncax48HvL+bx3jOYaW8xHgH4
         VoTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787627405; x=1788232205;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q7kJ9NxSCjyWswzqtIaS+F9FDZ/yEUyNYfEg9Rn62g8=;
        b=euUZQaXBYE+UK3Pu/EU8A4+rkxTOdryhH6B+tHvP6Ie1898lDtjvp63yubMzASRZbb
         Q2Ud4RGu1JlmLZA609mCvk9cyMej/XPwWsP7mvenyYrUfyCIEOuSccojTl17KIr1XRqC
         weIRt9pJY6KtTUn4fRJbvBpMuJpwWASyYkAEsVXxvSMGGvnWl5DlU5gGEUj4CZce9JCF
         HDMuX/q1RuNtRpuqfmtoinJfnEP96xi31Oluu8mR0muCvB2f0pna0BT9D6tcYlw4Sn/w
         VyLAxeophNzXB+31ZedxtUgFnl4caJIJIyVuRtoMYtb4unowShtMRnRMFKsmWypvVgLQ
         2VlA==
X-Gm-Message-State: AFuF++n9xZlPEmB9kOWZs7+rUQCqDYCkLOGeiIYzYMib0FsHQ4XPo9TM
	154vJYRhUhc82pNvsw11EXInlWjKg//pnXPmA2Qd+Sxdjj18Eu7D4o2jFAy/4VJ0N3eiK9DJBLv
	bUkBEUeNndNz0tgG2GR8jE9PhOaztnx05/A0KY7Aa6/UAg0kHVTyCQsQJDUWEoewahd4+lWyL0+
	cI2+5cYOyj2C6ZekvCtVBhYyZPT7Agm6XZn91n8mRW9Zi7IuI=
X-Gm-Gg: AR+sD104WjquOwgw6qZ6tnC1YHCq98n3nfXIWvgfUDSoIH8k3wO9btI90et1QRHdDXX
	Q+OqAM5hRQAJ//sBEYWZMhd3d8fWaVXs7/N8xyAw7zF6WE5Me/zITHNz7ACUAtSvhTvr8g77R5F
	ktWz8ZELUCIC1q+BES1mtwd5MhT7/Q6+ovHCQtz0UH2OiArXuqilW4hbXEcJKm7mXZ2rphnRdD/
	ck3bMVoAFeqnROv4zfRcPk8nu88tMcU4C/8HH0DMfJRGoIZG2J228f5ExO5/VsbhHhUZq+8om7/
	3DVKpOLboxAJJ4x0GztAplyf9creXrhMBDGTk1gj06KomoU/uuSChO25jC4TYkadkaw1EvJd1wS
	o+Tq0aMb8giaXp4RcwFwsXrnT7EfOSzXCLHCTaX+zXR7taX2S2Yt10naEQvt8
X-Received: by 2002:a17:90b:254e:b0:381:28e0:6259 with SMTP id 98e67ed59e1d1-396464d2917mr6882068a91.9.1787627404298;
        Mon, 24 Aug 2026 20:10:04 -0700 (PDT)
X-Received: by 2002:a17:90b:254e:b0:381:28e0:6259 with SMTP id 98e67ed59e1d1-396464d2917mr6881904a91.9.1787627403451;
        Mon, 24 Aug 2026 20:10:03 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f90e22f8sm28141163eec.13.2026.08.24.20.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 20:10:02 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: tighten validate_t2() offset bounds against actual buffer size
Date: Mon, 24 Aug 2026 22:09:48 -0500
Message-ID: <20260825030948.3577275-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

validate_t2() rejects ParameterOffset and DataOffset only when they
exceed 1024, far below the allocated buffer ceiling.  Raise the
individual offset guard to CIFSMaxBufSize + MAX_CIFS_HDR_SIZE.  Add
joint offset+count checks against frame_end — bytes from hdr.Protocol
to the end of the received payload, derived from WordCount and BCC to
match smbCalcSize() — so a large offset with zero count cannot reach
beyond the received frame.

In CIFSFindFirst and CIFSFindNext, bound lnoff <= DataCount: since
validate_t2() guarantees data_off + DataCount <= frame_end, this
transitively bounds data_off + lnoff within the frame.

Add min_param_size and min_data_size parameters to verify the offset
clears the byte past ByteCount and that offset + struct size fits in the
frame.  validate_t2() computes the minimum valid offset dynamically as
frame_end - BCC, which accounts for SetupCount > 0 (WordCount > 10)
responses where extra setup words shift ByteCount and the data area
later.  Non-obvious sizes at the call sites:

- CIFSPOSIXCreate: sizeof(OPEN_PSX_RSP) + sizeof(FILE_UNIX_BASIC_INFO),
  as the caller memcpys FILE_UNIX_BASIC_INFO immediately after OPEN_PSX_RSP.
- CIFSSMBQPathInfo: legacy ? offsetof(FILE_INFO_STANDARD, EASize) :
  sizeof(FILE_ALL_INFO); the legacy path skips EASize intentionally.
- CIFSSMBQAllEAs: offsetof(struct fealist, list), not sizeof, because an
  empty EA list returns DataCount=4 (list_len only).
- CIFSSMBPosixLock: (0, sizeof(struct cifs_posix_lock)) — pSMBr aliases
  the small request buffer on the waitFlag path; defer
  cifs_small_buf_release(pSMB) to plk_err_exit so the pLockData branch
  does not read from freed memory.  validate_t2()'s frame_end bound covers
  both the waitFlag (small buffer) and !waitFlag (transport-chosen buffer)
  paths correctly.
- CIFSGetDFSRefer: (0, 0) — parse_dfs_referrals() reads from the fixed
  dfs_data struct offset, not from DataOffset; add an explicit check that
  dfs_data + DataCount fits within the received frame.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifssmb.c | 166 +++++++++++++++++++++++++++-------------
 1 file changed, 113 insertions(+), 53 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..2dbd2624bc97 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -332,27 +332,74 @@ smb_init_no_reconnect(int smb_command, int wct, struct cifs_tcon *tcon,
 	return __smb_init(smb_command, wct, tcon, request_buf, response_buf);
 }
 
-static int validate_t2(struct smb_t2_rsp *pSMB)
+/*
+ * min_param_size / min_data_size: when non-zero, verify the offset clears
+ * the fixed T2 header and that offset + struct size fits within the
+ * actually-received frame.  Callers using a small buffer
+ * (MAX_CIFS_SMALL_BUFFER_SIZE) must apply a tighter per-call check; passing
+ * 0, 0 here still catches offsets beyond the allocated buffer.
+ */
+static int validate_t2(struct smb_t2_rsp *pSMB, unsigned int min_param_size,
+		       unsigned int min_data_size)
 {
-	unsigned int total_size;
+	unsigned int total_size, param_off, data_off, data_count, frame_end, min_off;
 
 	/* check for plausible wct */
 	if (pSMB->hdr.WordCount < 10)
 		goto vt2_err;
 
-	/* check for parm and data offset going beyond end of smb */
-	if (get_unaligned_le16(&pSMB->t2_rsp.ParameterOffset) > 1024 ||
-	    get_unaligned_le16(&pSMB->t2_rsp.DataOffset) > 1024)
+	param_off = get_unaligned_le16(&pSMB->t2_rsp.ParameterOffset);
+	data_off  = get_unaligned_le16(&pSMB->t2_rsp.DataOffset);
+
+	/* server-supplied offsets must stay within the allocated buffer */
+	if (param_off > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE ||
+	    data_off  > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE)
+		goto vt2_err;
+
+	/*
+	 * frame_end matches smbCalcSize().  checkSMB() has already verified
+	 * that clc_len <= rfclen == total_read, so frame_end is bounded by
+	 * the actual received byte count.  Validating all offset+count pairs
+	 * against frame_end rather than the buffer size ensures that a large
+	 * DataOffset into uninitialised pool memory beyond the received frame
+	 * is rejected even when DataCount == 0.
+	 */
+	frame_end = sizeof(struct smb_hdr) +
+		    2 * pSMB->hdr.WordCount + sizeof(__le16) +
+		    get_bcc(&pSMB->hdr);
+	/*
+	 * Minimum valid offset accounts for the actual WordCount: for
+	 * WordCount > 10 (SetupCount > 0), setup words precede ByteCount,
+	 * shifting the data area two bytes per extra setup word.
+	 */
+	min_off = frame_end - get_bcc(&pSMB->hdr);
+
+	/* When the caller will dereference a struct at the offset, verify it
+	 * clears the fixed T2 header and that the struct fits in the frame.
+	 */
+	if (min_param_size &&
+	    (param_off < min_off ||
+	     param_off + min_param_size > frame_end))
+		goto vt2_err;
+
+	if (min_data_size &&
+	    (data_off < min_off ||
+	     data_off + min_data_size > frame_end))
 		goto vt2_err;
 
 	total_size = get_unaligned_le16(&pSMB->t2_rsp.ParameterCount);
-	if (total_size >= 512)
+	if (total_size >= 512 ||
+	    param_off + total_size > frame_end)
+		goto vt2_err;
+
+	data_count = get_unaligned_le16(&pSMB->t2_rsp.DataCount);
+	if (data_off + data_count > frame_end)
 		goto vt2_err;
 
 	/* check that bcc is at least as big as parms + data, and that it is
 	 * less than negotiated smb buffer
 	 */
-	total_size += get_unaligned_le16(&pSMB->t2_rsp.DataCount);
+	total_size += data_count;
 	if (total_size > get_bcc(&pSMB->hdr) ||
 	    total_size >= CIFSMaxBufSize + MAX_CIFS_HDR_SIZE)
 		goto vt2_err;
@@ -1126,7 +1173,8 @@ CIFSPOSIXCreate(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	cifs_dbg(FYI, "copying inode info\n");
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0,
+			 sizeof(OPEN_PSX_RSP) + sizeof(FILE_UNIX_BASIC_INFO));
 
 	if (rc || get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)) {
 		rc = smb_EIO2(smb_eio_trace_create_rsp_too_small,
@@ -2358,15 +2406,14 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 				&resp_buf_type, sr_flags, &rsp_iov);
 		pSMBr = (struct smb_com_transaction2_sfi_rsp *)rsp_iov.iov_base;
 	}
-	cifs_small_buf_release(pSMB);
-
 	if (rc) {
 		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
 	} else if (pLockData) {
 		/* lock structure can be returned on get */
 		__u16 data_offset;
 		__u16 data_count;
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0,
+				 sizeof(struct cifs_posix_lock));
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(*parm_data)) {
 			rc = smb_EIO2(smb_eio_trace_lock_bcc_too_small,
@@ -2401,6 +2448,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 plk_err_exit:
+	cifs_small_buf_release(pSMB);
 	free_rsp_buf(resp_buf_type, rsp_iov.iov_base);
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
@@ -2933,7 +2981,7 @@ CIFSSMBUnixQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
 	} else {
 		/* decode response */
 
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, 0);
 		/* BB also check enough total bytes returned */
 		if (rc || get_bcc(&pSMBr->hdr) < 2)
 			rc = smb_EIO2(smb_eio_trace_qsym_bcc_too_small,
@@ -3518,7 +3566,8 @@ int cifs_do_get_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	} else {
 		/* decode response */
 
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0,
+				 sizeof(struct cifs_posix_acl));
 		/* BB also check enough total bytes returned */
 		if (rc || get_bcc(&pSMBr->hdr) < 2)
 			rc = smb_EIO2(smb_eio_trace_getacl_bcc_too_small,
@@ -3690,7 +3739,7 @@ CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "error %d in GetExtAttr\n", rc);
 	} else {
 		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(struct file_chattr_info));
 		/* BB also check enough total bytes returned */
 		if (rc || get_bcc(&pSMBr->hdr) < 2)
 			/* If rc should we check for EOPNOSUPP and
@@ -4093,7 +4142,7 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFileInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_ALL_INFO));
 
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = smb_EIO2(smb_eio_trace_qfileinfo_invalid,
@@ -4182,7 +4231,16 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		/*
+		 * On legacy responses we do not read the last field, EASize;
+		 * it varies by subdialect and differs between Set and Get
+		 * (two bytes vs four bytes).  Use offsetof so both the
+		 * validation bound and the copy size exclude it.
+		 */
+		int size = legacy ? offsetof(FILE_INFO_STANDARD, EASize) :
+				    sizeof(FILE_ALL_INFO);
+
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, size);
 
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = smb_EIO2(smb_eio_trace_qpathinfo_invalid,
@@ -4195,19 +4253,8 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			rc = smb_EIO2(smb_eio_trace_qpathinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 24);
 		else if (data) {
-			int size;
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 
-			/*
-			 * On legacy responses we do not read the last field,
-			 * EAsize, fortunately since it varies by subdialect and
-			 * also note it differs on Set vs Get, ie two bytes or 4
-			 * bytes depending but we don't care here.
-			 */
-			if (legacy)
-				size = sizeof(FILE_INFO_STANDARD);
-			else
-				size = sizeof(FILE_ALL_INFO);
 			memcpy((char *) data, (char *) &pSMBr->hdr.Protocol +
 			       data_offset, size);
 		} else
@@ -4269,7 +4316,7 @@ CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in UnixQFileInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_UNIX_BASIC_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
 			cifs_dbg(VFS, "Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.\n");
@@ -4354,7 +4401,7 @@ CIFSSMBUnixQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in UnixQPathInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_UNIX_BASIC_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
 			cifs_dbg(VFS, "Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.\n");
@@ -4387,7 +4434,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FFIRST_RSP *pSMBr = NULL;
 	T2_FFIRST_RSP_PARMS *parms;
 	struct nls_table *nls_codepage;
-	unsigned int in_len, lnoff;
+	unsigned int in_len, lnoff, data_off;
 	__u16 params, byte_count;
 	int bytes_returned = 0;
 	int name_len, remap;
@@ -4499,7 +4546,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 	/* decode response */
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, sizeof(T2_FFIRST_RSP_PARMS), 0);
 	if (rc) {
 		cifs_buf_release(pSMB);
 		return rc;
@@ -4508,8 +4555,8 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
 	psrch_inf->ntwrk_buf_start = (char *)pSMBr;
 	psrch_inf->smallBuf = false;
-	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.DataOffset);
+	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
+	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol + data_off;
 
 	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol +
 					le16_to_cpu(pSMBr->t2.ParameterOffset));
@@ -4519,14 +4566,15 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->index_of_last_entry = 2 /* skip . and .. */ +
 		psrch_inf->entries_in_buffer;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
-	if (CIFSMaxBufSize < lnoff) {
+
+	if (pnetfid)
+		*pnetfid = parms->SearchHandle;
+
+	if (lnoff >= le16_to_cpu(pSMBr->t2.DataCount)) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
 		psrch_inf->last_entry = NULL;
-	} else {
+	} else
 		psrch_inf->last_entry = psrch_inf->srch_entries_start + lnoff;
-		if (pnetfid)
-			*pnetfid = parms->SearchHandle;
-	}
 	return 0;
 }
 
@@ -4538,7 +4586,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FNEXT_RSP *pSMBr = NULL;
 	T2_FNEXT_RSP_PARMS *parms;
 	unsigned int name_len, in_len;
-	unsigned int lnoff;
+	unsigned int lnoff, data_off;
 	__u16 params, byte_count;
 	char *response_data;
 	int bytes_returned;
@@ -4613,7 +4661,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* decode response */
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, sizeof(T2_FNEXT_RSP_PARMS), 0);
 	if (rc) {
 		cifs_buf_release(pSMB);
 		return rc;
@@ -4623,8 +4671,8 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	response_data = (char *)&pSMBr->hdr.Protocol +
 		le16_to_cpu(pSMBr->t2.ParameterOffset);
 	parms = (T2_FNEXT_RSP_PARMS *)response_data;
-	response_data = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.DataOffset);
+	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
+	response_data = (char *)&pSMBr->hdr.Protocol + data_off;
 
 	if (psrch_inf->smallBuf)
 		cifs_small_buf_release(psrch_inf->ntwrk_buf_start);
@@ -4638,7 +4686,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
 	psrch_inf->index_of_last_entry += psrch_inf->entries_in_buffer;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
-	if (CIFSMaxBufSize < lnoff) {
+	if (lnoff >= le16_to_cpu(pSMBr->t2.DataCount)) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
 		psrch_inf->last_entry = NULL;
 	} else {
@@ -4757,7 +4805,7 @@ CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "error %d in QueryInternalInfo\n", rc);
 	} else {
 		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(struct file_internal_info));
 		/* BB also check enough total bytes returned */
 		if (rc || get_bcc(&pSMBr->hdr) < 2)
 			/* If rc should we check for EOPNOSUPP and
@@ -4877,7 +4925,7 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 		cifs_dbg(FYI, "Send error in GetDFSRefer = %d\n", rc);
 		goto GetDFSRefExit;
 	}
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, 0);
 
 	/* BB Also check if enough total bytes returned? */
 	if (rc || get_bcc(&pSMBr->hdr) < 17) {
@@ -4889,6 +4937,18 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 	cifs_dbg(FYI, "Decoding GetDFSRefer response BCC: %d  Offset %d\n",
 		 get_bcc(&pSMBr->hdr), le16_to_cpu(pSMBr->t2.DataOffset));
 
+	/*
+	 * dfs_data is at a fixed structural offset, not at the server-supplied
+	 * DataOffset.  Verify that DataCount bytes fit within the frame from
+	 * that fixed position before passing them to parse_dfs_referrals().
+	 */
+	if (offsetof(TRANSACTION2_GET_DFS_REFER_RSP, dfs_data) +
+	    le16_to_cpu(pSMBr->t2.DataCount) > sizeof(struct smb_hdr) +
+	    2 * pSMBr->hdr.WordCount + sizeof(__le16) + get_bcc(&pSMBr->hdr)) {
+		rc = -EIO;
+		goto GetDFSRefExit;
+	}
+
 	/* parse returned result into more usable form */
 	rc = parse_dfs_referrals(&pSMBr->dfs_data,
 				 le16_to_cpu(pSMBr->t2.DataCount),
@@ -4955,7 +5015,7 @@ SMBOldQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSInfo = %d\n", rc);
 	} else {                /* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_ALLOC_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 18)
 			rc = smb_EIO2(smb_eio_trace_oldqfsinfo_bcc_too_small,
@@ -5045,7 +5105,7 @@ CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_SIZE_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 24)
 			rc = smb_EIO2(smb_eio_trace_qfsinfo_bcc_too_small,
@@ -5135,7 +5195,7 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc) {
 		cifs_dbg(VFS, "Send error in QFSAttributeInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 13) {
 			/* BB also check if enough bytes returned */
@@ -5209,7 +5269,7 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSDeviceInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_DEVICE_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) <
 			  sizeof(FILE_SYSTEM_DEVICE_INFO))
@@ -5283,7 +5343,7 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc) {
 		cifs_dbg(VFS, "Send error in QFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_UNIX_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 13) {
 			rc = smb_EIO2(smb_eio_trace_qfsunixinfo_bcc_too_small,
@@ -5368,7 +5428,7 @@ CIFSSMBSetFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon, __u64 cap)
 	if (rc) {
 		cifs_dbg(VFS, "Send error in SETFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, 0);
 		if (rc)
 			rc = -EIO;	/* bad smb */
 	}
@@ -5432,7 +5492,7 @@ CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_POSIX_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 13) {
 			rc = smb_EIO2(smb_eio_trace_qfsposixinfo_bcc_too_small,
@@ -6198,7 +6258,7 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 	/* BB we need to improve the validity checking
 	of these trans2 responses */
 
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, offsetof(struct fealist, list));
 	if (rc || get_bcc(&pSMBr->hdr) < 4) {
 		rc = smb_EIO2(smb_eio_trace_qalleas_bcc_too_small,
 			      get_bcc(&pSMBr->hdr), 4);
-- 
2.55.0

