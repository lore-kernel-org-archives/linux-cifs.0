Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17D2C10F11
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 04:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98EDF2177E
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 04:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfCMEiA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 00:38:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbfCMEiA (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Mar 2019 00:38:00 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80D5C316891A;
        Wed, 13 Mar 2019 04:37:59 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-89.bne.redhat.com [10.64.54.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E117F60FE0;
        Wed, 13 Mar 2019 04:37:58 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 1/2] cifs: add SMB2_ioctl_init/free helpers to be used with compounding
Date:   Wed, 13 Mar 2019 14:37:48 +1000
Message-Id: <20190313043749.832-2-lsahlber@redhat.com>
In-Reply-To: <20190313043749.832-1-lsahlber@redhat.com>
References: <20190313043749.832-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 13 Mar 2019 04:37:59 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Define an _init() and a _free() function for SMB2_init so that we will
be able to use it with compounds.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c   | 133 ++++++++++++++++++++++++++++++----------------------
 fs/cifs/smb2proto.h |   4 ++
 2 files changed, 80 insertions(+), 57 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 60fbe306f604..e074cc12b4b4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2466,65 +2466,46 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	return rc;
 }
 
-/*
- *	SMB2 IOCTL is used for both IOCTLs and FSCTLs
- */
 int
-SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
-	   u64 volatile_fid, u32 opcode, bool is_fsctl,
-	   char *in_data, u32 indatalen,
-	   char **out_data, u32 *plen /* returned data len */)
+SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
+		u64 persistent_fid, u64 volatile_fid, u32 opcode,
+		bool is_fsctl, char *in_data, u32 indatalen)
 {
-	struct smb_rqst rqst;
 	struct smb2_ioctl_req *req;
-	struct smb2_ioctl_rsp *rsp;
-	struct cifs_ses *ses;
-	struct kvec iov[2];
-	struct kvec rsp_iov;
-	int resp_buftype;
-	int n_iov;
-	int rc = 0;
-	int flags = 0;
+	struct kvec *iov = rqst->rq_iov;
 	unsigned int total_len;
-
-	cifs_dbg(FYI, "SMB2 IOCTL\n");
-
-	if (out_data != NULL)
-		*out_data = NULL;
-
-	/* zero out returned data len, in case of error */
-	if (plen)
-		*plen = 0;
-
-	if (tcon)
-		ses = tcon->ses;
-	else
-		return -EIO;
-
-	if (!ses || !(ses->server))
-		return -EIO;
+	int rc;
 
 	rc = smb2_plain_req_init(SMB2_IOCTL, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
-	if (smb3_encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
 	req->CtlCode = cpu_to_le32(opcode);
 	req->PersistentFileId = persistent_fid;
 	req->VolatileFileId = volatile_fid;
 
+	iov[0].iov_base = (char *)req;
+	/*
+	 * If no input data, the size of ioctl struct in
+	 * protocol spec still includes a 1 byte data buffer,
+	 * but if input data passed to ioctl, we do not
+	 * want to double count this, so we do not send
+	 * the dummy one byte of data in iovec[0] if sending
+	 * input data (in iovec[1]).
+	 */
 	if (indatalen) {
 		req->InputCount = cpu_to_le32(indatalen);
 		/* do not set InputOffset if no input data */
 		req->InputOffset =
 		       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer));
+		rqst->rq_nvec = 2;
+		iov[0].iov_len = total_len - 1;
 		iov[1].iov_base = in_data;
 		iov[1].iov_len = indatalen;
-		n_iov = 2;
-	} else
-		n_iov = 1;
+	} else {
+		rqst->rq_nvec = 1;
+		iov[0].iov_len = total_len;
+	}
 
 	req->OutputOffset = 0;
 	req->OutputCount = 0; /* MBZ */
@@ -2546,33 +2527,70 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	else
 		req->Flags = 0;
 
-	iov[0].iov_base = (char *)req;
-
-	/*
-	 * If no input data, the size of ioctl struct in
-	 * protocol spec still includes a 1 byte data buffer,
-	 * but if input data passed to ioctl, we do not
-	 * want to double count this, so we do not send
-	 * the dummy one byte of data in iovec[0] if sending
-	 * input data (in iovec[1]).
-	 */
-
-	if (indatalen) {
-		iov[0].iov_len = total_len - 1;
-	} else
-		iov[0].iov_len = total_len;
-
 	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
 	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
 		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 
+	return 0;
+}
+
+void
+SMB2_ioctl_free(struct smb_rqst *rqst)
+{
+	if (rqst && rqst->rq_iov)
+		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+}
+
+/*
+ *	SMB2 IOCTL is used for both IOCTLs and FSCTLs
+ */
+int
+SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
+	   u64 volatile_fid, u32 opcode, bool is_fsctl,
+	   char *in_data, u32 indatalen,
+	   char **out_data, u32 *plen /* returned data len */)
+{
+	struct smb_rqst rqst;
+	struct smb2_ioctl_rsp *rsp = NULL;
+	struct cifs_ses *ses;
+	struct kvec iov[2];
+	struct kvec rsp_iov = {NULL, 0};
+	int resp_buftype = CIFS_NO_BUFFER;
+	int rc = 0;
+	int flags = 0;
+
+	cifs_dbg(FYI, "SMB2 IOCTL\n");
+
+	if (out_data != NULL)
+		*out_data = NULL;
+
+	/* zero out returned data len, in case of error */
+	if (plen)
+		*plen = 0;
+
+	if (tcon)
+		ses = tcon->ses;
+	else
+		return -EIO;
+
+	if (!ses || !(ses->server))
+		return -EIO;
+
+	if (smb3_encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
 	memset(&rqst, 0, sizeof(struct smb_rqst));
+	memset(&iov, 0, sizeof(iov));
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = n_iov;
+	rqst.rq_nvec = 2;
+
+	rc = SMB2_ioctl_init(tcon, &rqst, persistent_fid, volatile_fid,
+			     opcode, is_fsctl, in_data, indatalen);
+	if (rc)
+		goto ioctl_exit;
 
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
 			    &rsp_iov);
-	cifs_small_buf_release(req);
 	rsp = (struct smb2_ioctl_rsp *)rsp_iov.iov_base;
 
 	if (rc != 0)
@@ -2622,6 +2640,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	}
 
 ioctl_exit:
+	SMB2_ioctl_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 87733b27a65f..2f32e620071f 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -144,6 +144,10 @@ extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, u32 opcode,
 		     bool is_fsctl, char *in_data, u32 indatalen,
 		     char **out_data, u32 *plen /* returned data len */);
+extern int SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
+			   u64 persistent_fid, u64 volatile_fid, u32 opcode,
+			   bool is_fsctl, char *in_data, u32 indatalen);
+extern void SMB2_ioctl_free(struct smb_rqst *rqst);
 extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
 extern int SMB2_close_flags(const unsigned int xid, struct cifs_tcon *tcon,
-- 
2.13.6

