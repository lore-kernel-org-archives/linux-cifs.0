Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4EA3BFE3A
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 02:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786675461; cv=none; b=O9EhN6tO+/NXz641lYJapQT/6E8kpqElVo+TLwg/vEkBJ4ohDthx58zsH2dawPkSDP/OBFJ5oS+aa3OBPbZ+ZdUyUS932hCqxoByPiHy7+K+sRuPOG2TrboX4mxnlty3WyTNmZQ7lOCVquie2HROap+JdjXMKQPtdUFM/pdtGU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786675461; c=relaxed/simple;
	bh=n16o2JsTv1cwRebubaxKxOlgkvqBFWuA4i4sHtdGd/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=loRMloRi4x6cOGvHK771NNrmMOJOq605Ag2zEAOmTErp4WaML1ApN5Q25WCB5qJZaY5D7M8G9qNwpa39sGqyLB3Fk1mxD+zZU0YBg2mCp6Z3hUnfj9LMMlZ20rVGBD6RjOhktf0kzouHN2yIblrynACcczxIRirwn1SW0+a2hf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VxKKfRps; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=odfBw+ca; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VxKKfRps";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="odfBw+ca"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786675458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXIiXp61ev5fjZ5ubSkOZGTIzzx14EdALNX70XVAoho=;
	b=VxKKfRps9SY3YypGEX+wcGI1uPdsUwO2UNtSmYBVXZQxgsh1nnB0tWBy3Z3Y4BZ5d8WEab
	5JEefMgKyZK+2utYcw9djJii4AujXF0PeYRkcemDzo6Oc5fYUo9edZrfZZqHelm0pjUoFY
	dp0sCJiWTvLzUKgfh3awr9A08UrIqmo=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-kPMioBwbPaKkVpky1uArTQ-1; Thu, 13 Aug 2026 22:44:16 -0400
X-MC-Unique: kPMioBwbPaKkVpky1uArTQ-1
X-Mimecast-MFC-AGG-ID: kPMioBwbPaKkVpky1uArTQ_1786675456
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7f1ddcd241aso841832a34.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 19:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786675456; x=1787280256; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZXIiXp61ev5fjZ5ubSkOZGTIzzx14EdALNX70XVAoho=;
        b=odfBw+cazEFASHIA1SMtTxXEWi+Gz4C/5aBcztD4IDTobK0GPmbUMkmr0TvwYY12ln
         tyuvRiTU8MgNYpjxh0kmh/4iis7s/NkSwOTuZI/0pHJvenoAlwHKLayOqREtFN7iuD3h
         M3wDBUxiTKDQD+P/05pgsqi/F9/QXRNToRkFRqAxcTpNjhGh4LexMuWZirHmCkqX0tWu
         mDQUTElWpoyEnuHMO4urPMUKZv/aVQEUsngN7xFlnUQyBBUMjBWF5hBmq5X71lFG9h0r
         pdjEgnFOJkbO3Yij3wdSmjyOwmSZ9ylFaDOIZhuYs3MWDOU52YspasbTY+7hgMx0iNHF
         1xMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786675456; x=1787280256;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZXIiXp61ev5fjZ5ubSkOZGTIzzx14EdALNX70XVAoho=;
        b=MgWqpzCS+daWjDrbJeZZ1ecLGMtWlkHZBUVUBOj7T72wysT8B8KNMYt09Baw3kFSz4
         0la4jlqOtSWoTY2rbV+zMwnaY+vwSMSQIPwReilAb2QohEjprFiVWKmY/MfOjQzfJi8c
         FbbypMOdLddyP/JRZK9hsHXiQYezQYTn6DSWZuYARC199BdedhcD+H7AP2YEQQboXPF4
         j4Qu54XygHq5H0jra5OnplwYRwi0h2OmcP5My8Aiy58Q5cLvwTygYNxWj0ZgxH5E/zkG
         HyVwJDZGSjIyXwQMQUWoRQzm5KgZOM6J3pGsZmlsE7YRw88ZL2UNCs2F7RzhV3d/alOR
         z9SA==
X-Gm-Message-State: AOJu0YzTfMWJ3vI45zoG2BSGZ6g91T8B5FJMjeaN2iwgd2iWV1sppYCL
	LZk4hcDNMI59dc6QtpkAKS3Od9CISfwX3q0eMvlHtTXcuI+8/EHYGbqVOfTP+69WbsxWT2cn7sc
	EEOrprNOlTkKUOAhMLrdD3FmoJgjUVLx5S9Io2nhUoO1flz266CoGYPGBuLP7F0b6CVPGwWbiXx
	5Nt65cxPyUKcUBpprP8ywVJmz0ikHUCuyNZTfMt0o3e3EcBGo=
X-Gm-Gg: AR+sD13EZHVU/mLw09MnPdGQAMPs8QJbhdDTjV1HsKybjZFnKnAFwYdFWWrgk2YF5QF
	ZHoiXe66vqLgUUQFSkBTGZzsckPKG8/iG/w46mzuD1tieTig4Q1x8qH5FjJ2mqzVNh5zI6PWhs1
	eMxdWOBDfymTERy/cHDd0fvV/1nJXh/H0eHzMPQKHULQF2Vg7NKMdUILXSGBrPcvk/hSMVZqYgn
	JeMCKJgqM5aziFS3gXuOCeYbLCJRtC62XUXukw9+1IUnfAAoPO0sDgWW1l9f4G/suKRB6xC751r
	8y8E+da0rvIbT5/R8/SBMbdFJJtIaA1/1oTA6JmGZysMxFP0bZn7dxg9k/gJLAOI5H8Yxo1rN7Y
	aU4zey/8g6U/1cKTUQJOz0/nampuGrouY2n9uz/jrdBF1ADK5Pm3KbreuJES7NkJ8lQ==
X-Received: by 2002:a05:6830:439e:b0:7e9:e808:e9c1 with SMTP id 46e09a7af769-7f3de424d64mr2361797a34.8.1786675455515;
        Thu, 13 Aug 2026 19:44:15 -0700 (PDT)
X-Received: by 2002:a05:6830:439e:b0:7e9:e808:e9c1 with SMTP id 46e09a7af769-7f3de424d64mr2361749a34.8.1786675454877;
        Thu, 13 Aug 2026 19:44:14 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3c9a0d87esm3631582a34.11.2026.08.13.19.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 19:44:14 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	pc@manguebit.org
Subject: [RFC PATCH 1/1] smb: client: tighten validate_t2() offset bounds against actual buffer size
Date: Thu, 13 Aug 2026 21:44:10 -0500
Message-ID: <20260814024410.2455764-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814024410.2455764-1-sorenson@redhat.com>
References: <20260814024410.2455764-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

validate_t2() rejects ParameterOffset and DataOffset only when they
exceed 1024, far below the actual allocated buffer size of
CIFSMaxBufSize + MAX_CIFS_HDR_SIZE.  A malicious server can supply an
offset anywhere in [1025, ~16468] and cause an out-of-bounds read via
any typed struct dereference at that offset.

Raise the individual offset guard to CIFSMaxBufSize + MAX_CIFS_HDR_SIZE
as a buffer-overflow backstop.  Add joint offset+count checks against
frame_end — the number of bytes from hdr.Protocol to the end of the
actually-received payload, computed from WordCount and BCC to match
smbCalcSize() — so that a large DataOffset with DataCount=0 cannot reach
stale pool memory beyond the received frame even if it passes the
individual bound.

In CIFSFindFirst and CIFSFindNext, tighten the LastNameOffset check:
since validate_t2() has verified data_off + DataCount <= frame_end,
bounding lnoff <= DataCount transitively ensures
data_off + lnoff <= frame_end.

Add min_param_size and min_data_size parameters: when non-zero, also
verify the offset clears the fixed T2 response header (SMB_T2_MIN_OFFSET)
and that offset + struct size fits in the received frame.  Propagate
appropriate minimum sizes to all 21 call sites:

- CIFSPOSIXCreate: sizeof(OPEN_PSX_RSP) + sizeof(FILE_UNIX_BASIC_INFO),
  because the caller may memcpy FILE_UNIX_BASIC_INFO immediately beyond
  OPEN_PSX_RSP at the same DataOffset base.
- CIFSSMBQPathInfo: legacy ? sizeof(FILE_INFO_STANDARD) :
  sizeof(FILE_ALL_INFO), matching the actual struct read in each path.
- CIFSSMBPosixLock: 0, 0 in validate_t2() because pSMBr uses a small
  buffer (MAX_CIFS_SMALL_BUFFER_SIZE = 448 bytes); add a per-call check
  that data_offset + sizeof(struct cifs_posix_lock) fits in 448 bytes.
- Remaining callers: 0 for whichever of param/data is not accessed as a
  typed struct, and sizeof(the accessed struct) for the other.

Rename SMB_T2_MIN_DATA_OFFSET to SMB_T2_MIN_OFFSET since it guards
both ParameterOffset and DataOffset.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifssmb.c | 133 +++++++++++++++++++++++++++++-----------
 1 file changed, 97 insertions(+), 36 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 1f77512252e7..482a4452c9b9 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -332,27 +332,74 @@ smb_init_no_reconnect(int smb_command, int wct, struct cifs_tcon *tcon,
 	return __smb_init(smb_command, wct, tcon, request_buf, response_buf);
 }
 
-static int validate_t2(struct smb_t2_rsp *pSMB)
+/*
+ * Minimum offset at which parameter/data areas can begin: past the fixed T2
+ * response header (smb_hdr + trans2_resp) and the ByteCount field.
+ */
+#define SMB_T2_MIN_OFFSET  (sizeof(struct smb_t2_rsp) + sizeof(__le16))
+
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
+	unsigned int total_size, param_off, data_off, data_count, frame_end;
 
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
+	 * Extent of the actually-received frame: Protocol is the first field
+	 * of smb_hdr at offset 0; frame_end matches smbCalcSize() and is the
+	 * number of bytes from Protocol to the end of the received data.
+	 * All offset+count pairs are validated against this, not the max
+	 * buffer size, so a large DataOffset pointing into uninitialised pool
+	 * memory beyond the received frame is rejected even if DataCount=0.
+	 */
+	frame_end = sizeof(struct smb_hdr) +
+		    2 * pSMB->hdr.WordCount + sizeof(__le16) +
+		    get_bcc(&pSMB->hdr);
+
+	/* when the caller will dereference a struct at the offset, also verify
+	 * it clears the fixed T2 header and that the struct fits in the frame.
+	 */
+	if (min_param_size &&
+	    (param_off < SMB_T2_MIN_OFFSET ||
+	     param_off + min_param_size > frame_end))
+		goto vt2_err;
+
+	if (min_data_size &&
+	    (data_off < SMB_T2_MIN_OFFSET ||
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
@@ -1120,7 +1167,8 @@ CIFSPOSIXCreate(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	cifs_dbg(FYI, "copying inode info\n");
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0,
+			 sizeof(OPEN_PSX_RSP) + sizeof(FILE_UNIX_BASIC_INFO));
 
 	if (rc || get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)) {
 		rc = smb_EIO2(smb_eio_trace_create_rsp_too_small,
@@ -2360,7 +2408,12 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		/* lock structure can be returned on get */
 		__u16 data_offset;
 		__u16 data_count;
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		/*
+		 * pSMBr uses a small buffer (MAX_CIFS_SMALL_BUFFER_SIZE = 448 bytes);
+		 * validate_t2(0, 0) only catches offsets beyond the large-buffer
+		 * bound — the tight check against 448 bytes follows below.
+		 */
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, 0);
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(*parm_data)) {
 			rc = smb_EIO2(smb_eio_trace_lock_bcc_too_small,
@@ -2369,6 +2422,12 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 		data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 		data_count  = le16_to_cpu(pSMBr->t2.DataCount);
+		if (data_offset < SMB_T2_MIN_OFFSET ||
+		    data_offset + sizeof(struct cifs_posix_lock) >
+		    MAX_CIFS_SMALL_BUFFER_SIZE) {
+			rc = -EIO;
+			goto plk_err_exit;
+		}
 		if (data_count < sizeof(struct cifs_posix_lock)) {
 			rc = smb_EIO2(smb_eio_trace_lock_data_too_small,
 				      data_count, sizeof(struct cifs_posix_lock));
@@ -2927,7 +2986,7 @@ CIFSSMBUnixQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
 	} else {
 		/* decode response */
 
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, 0);
 		/* BB also check enough total bytes returned */
 		if (rc || get_bcc(&pSMBr->hdr) < 2)
 			rc = smb_EIO2(smb_eio_trace_qsym_bcc_too_small,
@@ -3512,7 +3571,7 @@ int cifs_do_get_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	} else {
 		/* decode response */
 
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, 0);
 		/* BB also check enough total bytes returned */
 		if (rc || get_bcc(&pSMBr->hdr) < 2)
 			rc = smb_EIO2(smb_eio_trace_getacl_bcc_too_small,
@@ -3684,7 +3743,7 @@ CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "error %d in GetExtAttr\n", rc);
 	} else {
 		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(struct file_chattr_info));
 		/* BB also check enough total bytes returned */
 		if (rc || get_bcc(&pSMBr->hdr) < 2)
 			/* If rc should we check for EOPNOSUPP and
@@ -4087,7 +4146,7 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFileInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_ALL_INFO));
 
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = smb_EIO2(smb_eio_trace_qfileinfo_invalid,
@@ -4176,7 +4235,9 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0,
+				 legacy ? sizeof(FILE_INFO_STANDARD) :
+					  sizeof(FILE_ALL_INFO));
 
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = smb_EIO2(smb_eio_trace_qpathinfo_invalid,
@@ -4263,7 +4324,7 @@ CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in UnixQFileInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_UNIX_BASIC_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
 			cifs_dbg(VFS, "Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.\n");
@@ -4348,7 +4409,7 @@ CIFSSMBUnixQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in UnixQPathInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_UNIX_BASIC_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
 			cifs_dbg(VFS, "Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.\n");
@@ -4381,7 +4442,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FFIRST_RSP *pSMBr = NULL;
 	T2_FFIRST_RSP_PARMS *parms;
 	struct nls_table *nls_codepage;
-	unsigned int in_len, lnoff;
+	unsigned int in_len, lnoff, data_off;
 	__u16 params, byte_count;
 	int bytes_returned = 0;
 	int name_len, remap;
@@ -4493,7 +4554,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 	/* decode response */
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, sizeof(T2_FFIRST_RSP_PARMS), 0);
 	if (rc) {
 		cifs_buf_release(pSMB);
 		return rc;
@@ -4502,8 +4563,8 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
 	psrch_inf->ntwrk_buf_start = (char *)pSMBr;
 	psrch_inf->smallBuf = false;
-	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.DataOffset);
+	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
+	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol + data_off;
 
 	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol +
 					le16_to_cpu(pSMBr->t2.ParameterOffset));
@@ -4513,7 +4574,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->index_of_last_entry = 2 /* skip . and .. */ +
 		psrch_inf->entries_in_buffer;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
-	if (CIFSMaxBufSize < lnoff) {
+	if (lnoff > le16_to_cpu(pSMBr->t2.DataCount)) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
 		psrch_inf->last_entry = NULL;
 	} else {
@@ -4532,7 +4593,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FNEXT_RSP *pSMBr = NULL;
 	T2_FNEXT_RSP_PARMS *parms;
 	unsigned int name_len, in_len;
-	unsigned int lnoff;
+	unsigned int lnoff, data_off;
 	__u16 params, byte_count;
 	char *response_data;
 	int bytes_returned;
@@ -4607,7 +4668,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* decode response */
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, sizeof(T2_FNEXT_RSP_PARMS), 0);
 	if (rc) {
 		cifs_buf_release(pSMB);
 		return rc;
@@ -4617,8 +4678,8 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	response_data = (char *)&pSMBr->hdr.Protocol +
 		le16_to_cpu(pSMBr->t2.ParameterOffset);
 	parms = (T2_FNEXT_RSP_PARMS *)response_data;
-	response_data = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.DataOffset);
+	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
+	response_data = (char *)&pSMBr->hdr.Protocol + data_off;
 
 	if (psrch_inf->smallBuf)
 		cifs_small_buf_release(psrch_inf->ntwrk_buf_start);
@@ -4632,7 +4693,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
 	psrch_inf->index_of_last_entry += psrch_inf->entries_in_buffer;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
-	if (CIFSMaxBufSize < lnoff) {
+	if (lnoff > le16_to_cpu(pSMBr->t2.DataCount)) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
 		psrch_inf->last_entry = NULL;
 	} else {
@@ -4751,7 +4812,7 @@ CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "error %d in QueryInternalInfo\n", rc);
 	} else {
 		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(struct file_internal_info));
 		/* BB also check enough total bytes returned */
 		if (rc || get_bcc(&pSMBr->hdr) < 2)
 			/* If rc should we check for EOPNOSUPP and
@@ -4871,7 +4932,7 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 		cifs_dbg(FYI, "Send error in GetDFSRefer = %d\n", rc);
 		goto GetDFSRefExit;
 	}
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, 0);
 
 	/* BB Also check if enough total bytes returned? */
 	if (rc || get_bcc(&pSMBr->hdr) < 17) {
@@ -4949,7 +5010,7 @@ SMBOldQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSInfo = %d\n", rc);
 	} else {                /* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_ALLOC_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 18)
 			rc = smb_EIO2(smb_eio_trace_oldqfsinfo_bcc_too_small,
@@ -5039,7 +5100,7 @@ CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_SIZE_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 24)
 			rc = smb_EIO2(smb_eio_trace_qfsinfo_bcc_too_small,
@@ -5129,7 +5190,7 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc) {
 		cifs_dbg(VFS, "Send error in QFSAttributeInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 13) {
 			/* BB also check if enough bytes returned */
@@ -5203,7 +5264,7 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSDeviceInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_DEVICE_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) <
 			  sizeof(FILE_SYSTEM_DEVICE_INFO))
@@ -5277,7 +5338,7 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc) {
 		cifs_dbg(VFS, "Send error in QFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_UNIX_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 13) {
 			rc = smb_EIO2(smb_eio_trace_qfsunixinfo_bcc_too_small,
@@ -5362,7 +5423,7 @@ CIFSSMBSetFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon, __u64 cap)
 	if (rc) {
 		cifs_dbg(VFS, "Send error in SETFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, 0);
 		if (rc)
 			rc = -EIO;	/* bad smb */
 	}
@@ -5426,7 +5487,7 @@ CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+		rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(FILE_SYSTEM_POSIX_INFO));
 
 		if (rc || get_bcc(&pSMBr->hdr) < 13) {
 			rc = smb_EIO2(smb_eio_trace_qfsposixinfo_bcc_too_small,
@@ -6192,7 +6253,7 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 	/* BB we need to improve the validity checking
 	of these trans2 responses */
 
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
+	rc = validate_t2((struct smb_t2_rsp *)pSMBr, 0, sizeof(struct fealist));
 	if (rc || get_bcc(&pSMBr->hdr) < 4) {
 		rc = smb_EIO2(smb_eio_trace_qalleas_bcc_too_small,
 			      get_bcc(&pSMBr->hdr), 4);
-- 
2.55.0

