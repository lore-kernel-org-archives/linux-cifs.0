Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C143A9D9F
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186200; cv=none; b=BczKrKMkMU1bSBwHjVL22TqSlt8UCpYK/kcixLzTuvfuvWpZ1KUhnzsgqvb9IgSXGyA+CTKo5lj/ccvfF+7A4SiBkhU0eSmuURuMDGzfZjX7MVzPTLe0YctHRF9hgQAVZPPMas/jq32eMN72osF8YMzNNWp/3okuoXfkotsqfTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186200; c=relaxed/simple;
	bh=XShjgtXhP+tYiq2TplGgGhv4z9FLJ6VOMvOUzEinfso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8isfzdFwi429Vh889k/hNpuxE04kaCFBqnCYeEi2Of+TmwpMkMePYUgSjuIMgAX/0sMmr8Gk6ptREWx+0BJs0yKgc8noguVDg5lz1sR//rWRjBk6FvgFNFnzL1BAaxXB1zJmOREJTVgGLjfSZXZ/FXVaUk7iMGIPrzz0C5M93A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R4sdTTqy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R4sdTTqy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R38LEhSUg0zG7CZXQr66Y4eG2u+dIMP8sPcWKJpzAyM=;
	b=R4sdTTqyQSpfrkZhD/L/xam1s0FHNdyhz5AgZwotQNrz5EwMnlLDZz8fgIiZPLuDftRTXF
	WQ+CKR99W4tVJIRDmuAziqvZHkBs/wSvY+Vglrd2xIl8uvu4CNC/Jk7rf9VsEOeoysC4hY
	gSKtBkLjXND8L+PVurPYRn+W2gcCCEc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-676-rZEWN4nsNFyMhzQSAIXsaQ-1; Tue,
 19 May 2026 06:23:12 -0400
X-MC-Unique: rZEWN4nsNFyMhzQSAIXsaQ-1
X-Mimecast-MFC-AGG-ID: rZEWN4nsNFyMhzQSAIXsaQ_1779186190
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4574C19560A7;
	Tue, 19 May 2026 10:23:10 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1BD7519560A2;
	Tue, 19 May 2026 10:23:06 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 13/36] cifs: Remove validate_t2()
Date: Tue, 19 May 2026 11:21:31 +0100
Message-ID: <20260519102158.592165-14-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

validate_t2() is no longer necessary as the checking is now done up front.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifssmb.c | 132 +++++++---------------------------------
 1 file changed, 22 insertions(+), 110 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index c537cc3e66c8..901f8aff6134 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -332,40 +332,6 @@ smb_init_no_reconnect(int smb_command, int wct, struct cifs_tcon *tcon,
 	return __smb_init(smb_command, wct, tcon, request_buf, response_buf);
 }
 
-static int validate_t2(struct smb_t2_rsp *pSMB)
-{
-	unsigned int total_size;
-
-	return 0; /* Checking now done in reception routine. */
-
-	/* check for plausible wct */
-	if (pSMB->hdr.WordCount < 10)
-		goto vt2_err;
-
-	/* check for parm and data offset going beyond end of smb */
-	if (get_unaligned_le16(&pSMB->t2_rsp.ParameterOffset) > 1024 ||
-	    get_unaligned_le16(&pSMB->t2_rsp.DataOffset) > 1024)
-		goto vt2_err;
-
-	total_size = get_unaligned_le16(&pSMB->t2_rsp.ParameterCount);
-	if (total_size >= 512)
-		goto vt2_err;
-
-	/* check that bcc is at least as big as parms + data, and that it is
-	 * less than negotiated smb buffer
-	 */
-	total_size += get_unaligned_le16(&pSMB->t2_rsp.DataCount);
-	if (total_size > get_bcc(&pSMB->hdr) ||
-	    total_size >= CIFSMaxBufSize + MAX_CIFS_HDR_SIZE)
-		goto vt2_err;
-
-	return 0;
-vt2_err:
-	cifs_dump_mem("Invalid transact2 SMB: ", (char *)pSMB,
-		sizeof(struct smb_t2_rsp) + 16);
-	return -EINVAL;
-}
-
 static int
 decode_ext_sec_blob(struct cifs_ses *ses, SMB_NEGOTIATE_RSP *pSMBr)
 {
@@ -1122,9 +1088,7 @@ CIFSPOSIXCreate(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	cifs_dbg(FYI, "copying inode info\n");
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-	if (rc || get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)) {
+	if (get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)) {
 		rc = smb_EIO2(smb_eio_trace_create_rsp_too_small,
 			      get_bcc(&pSMBr->hdr), sizeof(OPEN_PSX_RSP));
 		goto psx_create_err;
@@ -2372,9 +2336,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		/* lock structure can be returned on get */
 		__u16 data_offset;
 		__u16 data_count;
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc || get_bcc(&pSMBr->hdr) < sizeof(*parm_data)) {
+		if (get_bcc(&pSMBr->hdr) < sizeof(*parm_data)) {
 			rc = smb_EIO2(smb_eio_trace_lock_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), sizeof(*parm_data));
 			goto plk_err_exit;
@@ -2939,9 +2901,8 @@ CIFSSMBUnixQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
 	} else {
 		/* decode response */
 
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 		/* BB also check enough total bytes returned */
-		if (rc || get_bcc(&pSMBr->hdr) < 2)
+		if (get_bcc(&pSMBr->hdr) < 2)
 			rc = smb_EIO2(smb_eio_trace_qsym_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 2);
 		else {
@@ -3524,9 +3485,8 @@ int cifs_do_get_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	} else {
 		/* decode response */
 
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 		/* BB also check enough total bytes returned */
-		if (rc || get_bcc(&pSMBr->hdr) < 2)
+		if (get_bcc(&pSMBr->hdr) < 2)
 			rc = smb_EIO2(smb_eio_trace_getacl_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 2);
 		else {
@@ -3696,9 +3656,8 @@ CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "error %d in GetExtAttr\n", rc);
 	} else {
 		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 		/* BB also check enough total bytes returned */
-		if (rc || get_bcc(&pSMBr->hdr) < 2)
+		if (get_bcc(&pSMBr->hdr) < 2)
 			/* If rc should we check for EOPNOSUPP and
 			   disable the srvino flag? or in caller? */
 			rc = smb_EIO2(smb_eio_trace_getextattr_bcc_too_small,
@@ -4099,12 +4058,7 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFileInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc) /* BB add auto retry on EOPNOTSUPP? */
-			rc = smb_EIO2(smb_eio_trace_qfileinfo_invalid,
-				      get_bcc(&pSMBr->hdr), 40);
-		else if (get_bcc(&pSMBr->hdr) < 40)
+		if (get_bcc(&pSMBr->hdr) < 40)
 			rc = smb_EIO2(smb_eio_trace_qfileinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 40);
 		else if (pFindData) {
@@ -4188,12 +4142,7 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc) /* BB add auto retry on EOPNOTSUPP? */
-			rc = smb_EIO2(smb_eio_trace_qpathinfo_invalid,
-				      get_bcc(&pSMBr->hdr), 40);
-		else if (!legacy && get_bcc(&pSMBr->hdr) < 40)
+		if (!legacy && get_bcc(&pSMBr->hdr) < 40)
 			rc = smb_EIO2(smb_eio_trace_qpathinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 40);
 		else if (legacy && get_bcc(&pSMBr->hdr) < 24)
@@ -4275,9 +4224,7 @@ CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in UnixQFileInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
+		if (get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
 			cifs_dbg(VFS, "Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.\n");
 			rc = smb_EIO2(smb_eio_trace_unixqfileinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), sizeof(FILE_UNIX_BASIC_INFO));
@@ -4360,9 +4307,7 @@ CIFSSMBUnixQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in UnixQPathInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
+		if (get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
 			cifs_dbg(VFS, "Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.\n");
 			rc = smb_EIO2(smb_eio_trace_unixqpathinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), sizeof(FILE_UNIX_BASIC_INFO));
@@ -4504,13 +4449,8 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 			goto findFirstRetry;
 		return rc;
 	}
-	/* decode response */
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-	if (rc) {
-		cifs_buf_release(pSMB);
-		return rc;
-	}
 
+	/* decode response */
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
 	psrch_inf->ntwrk_buf_start = (char *)pSMBr;
 	psrch_inf->smallBuf = false;
@@ -4619,11 +4559,6 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* decode response */
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-	if (rc) {
-		cifs_buf_release(pSMB);
-		return rc;
-	}
 	/* BB fixme add lock for file (srch_info) struct here */
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
 	response_data = (char *)&pSMBr->hdr.Protocol +
@@ -4763,9 +4698,8 @@ CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "error %d in QueryInternalInfo\n", rc);
 	} else {
 		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 		/* BB also check enough total bytes returned */
-		if (rc || get_bcc(&pSMBr->hdr) < 2)
+		if (get_bcc(&pSMBr->hdr) < 2)
 			/* If rc should we check for EOPNOSUPP and
 			disable the srvino flag? or in caller? */
 			rc = smb_EIO2(smb_eio_trace_getsrvinonum_bcc_too_small,
@@ -4883,10 +4817,9 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 		cifs_dbg(FYI, "Send error in GetDFSRefer = %d\n", rc);
 		goto GetDFSRefExit;
 	}
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 	/* BB Also check if enough total bytes returned? */
-	if (rc || get_bcc(&pSMBr->hdr) < 17) {
+	if (get_bcc(&pSMBr->hdr) < 17) {
 		rc = smb_EIO2(smb_eio_trace_getdfsrefer_bcc_too_small,
 			      get_bcc(&pSMBr->hdr), 17);
 		goto GetDFSRefExit;
@@ -4961,12 +4894,10 @@ SMBOldQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSInfo = %d\n", rc);
 	} else {                /* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc || get_bcc(&pSMBr->hdr) < 18)
+		if (get_bcc(&pSMBr->hdr) < 18) {
 			rc = smb_EIO2(smb_eio_trace_oldqfsinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 18);
-		else {
+		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 			cifs_dbg(FYI, "qfsinf resp BCC: %d  Offset %d\n",
 				 get_bcc(&pSMBr->hdr), data_offset);
@@ -5051,12 +4982,10 @@ CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc || get_bcc(&pSMBr->hdr) < 24)
+		if (get_bcc(&pSMBr->hdr) < 24) {
 			rc = smb_EIO2(smb_eio_trace_qfsinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 24);
-		else {
+		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 
 			response_data =
@@ -5141,9 +5070,7 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc) {
 		cifs_dbg(VFS, "Send error in QFSAttributeInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc || get_bcc(&pSMBr->hdr) < 13) {
+		if (get_bcc(&pSMBr->hdr) < 13) {
 			/* BB also check if enough bytes returned */
 			rc = smb_EIO2(smb_eio_trace_qfsattrinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 13);
@@ -5215,9 +5142,7 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSDeviceInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc || get_bcc(&pSMBr->hdr) <
+		if (get_bcc(&pSMBr->hdr) <
 			  sizeof(FILE_SYSTEM_DEVICE_INFO))
 			rc = smb_EIO2(smb_eio_trace_qfsdevinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr),
@@ -5289,9 +5214,7 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc) {
 		cifs_dbg(VFS, "Send error in QFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc || get_bcc(&pSMBr->hdr) < 13) {
+		if (get_bcc(&pSMBr->hdr) < 13) {
 			rc = smb_EIO2(smb_eio_trace_qfsunixinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 13);
 		} else {
@@ -5371,13 +5294,8 @@ CIFSSMBSetFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon, __u64 cap)
 
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB, in_len,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	if (rc) {
+	if (rc)
 		cifs_dbg(VFS, "Send error in SETFSUnixInfo = %d\n", rc);
-	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-		if (rc)
-			rc = -EIO;	/* bad smb */
-	}
 	cifs_buf_release(pSMB);
 
 	if (rc == -EAGAIN)
@@ -5438,9 +5356,7 @@ CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
-		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-
-		if (rc || get_bcc(&pSMBr->hdr) < 13) {
+		if (get_bcc(&pSMBr->hdr) < 13) {
 			rc = smb_EIO2(smb_eio_trace_qfsposixinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 13);
 		} else {
@@ -6237,11 +6153,7 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 
 
 	/* BB also check enough total bytes returned */
-	/* BB we need to improve the validity checking
-	of these trans2 responses */
-
-	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
-	if (rc || get_bcc(&pSMBr->hdr) < 4) {
+	if (get_bcc(&pSMBr->hdr) < 4) {
 		rc = smb_EIO2(smb_eio_trace_qalleas_bcc_too_small,
 			      get_bcc(&pSMBr->hdr), 4);
 		goto QAllEAsOut;

