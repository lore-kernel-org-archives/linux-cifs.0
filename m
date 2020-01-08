Return-Path: <SRS0=ymiT=25=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0C4C33C9E
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 207D02077B
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:08:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OVZtzjsN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgAHDI0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jan 2020 22:08:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40255 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726149AbgAHDI0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jan 2020 22:08:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578452904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=+RXwiB3X5s7nXRZIpYogyGPk2a8NGizWQsKTxZE+iD0=;
        b=OVZtzjsNQdJRiAwOv1lgf4+aOPwKTw2sPQ91DyVrklJjSvs1OUvvD+HZRFkIA2UFIfaaiz
        sr8yDH+KpNzdFb3iCKqedx9j2rbCDigWTAqqJ7A4XgLGU5/uBh2js2QIu5J8RVCrC1gbWr
        Yw2f6dn+x5nK+49dEO4VGLZUq4nDUyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-IYHNO9bXP3mOCkD7_NAKAA-1; Tue, 07 Jan 2020 22:08:22 -0500
X-MC-Unique: IYHNO9bXP3mOCkD7_NAKAA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C113FDB21
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jan 2020 03:08:21 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-61.bne.redhat.com [10.64.54.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 258F35C1BB;
        Wed,  8 Jan 2020 03:08:20 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/4] cifs: create a helper function to parse the query-directory response buffer
Date:   Wed,  8 Jan 2020 13:08:05 +1000
Message-Id: <20200108030807.2460-3-lsahlber@redhat.com>
In-Reply-To: <20200108030807.2460-1-lsahlber@redhat.com>
References: <20200108030807.2460-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c | 109 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 63 insertions(+), 46 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 50466062c1da..a23ca3d0dcd9 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4370,6 +4370,67 @@ void SMB2_query_directory_free(struct smb_rqst *rqst)
 }
 
 int
+smb2_parse_query_directory(struct cifs_tcon *tcon,
+			   struct kvec *rsp_iov,
+			   int resp_buftype,
+			   struct cifs_search_info *srch_inf)
+{
+	struct smb2_query_directory_rsp *rsp;
+	size_t info_buf_size;
+	char *end_of_smb;
+	int rc;
+
+	rsp = (struct smb2_query_directory_rsp *)rsp_iov->iov_base;
+
+	switch (srch_inf->info_level) {
+	case SMB_FIND_FILE_DIRECTORY_INFO:
+		info_buf_size = sizeof(FILE_DIRECTORY_INFO) - 1;
+		break;
+	case SMB_FIND_FILE_ID_FULL_DIR_INFO:
+		info_buf_size = sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
+		break;
+	default:
+		cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
+			 srch_inf->info_level);
+		return -EINVAL;
+	}
+
+	rc = smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
+			       le32_to_cpu(rsp->OutputBufferLength), rsp_iov,
+			       info_buf_size);
+	if (rc)
+		return rc;
+
+	srch_inf->unicode = true;
+
+	if (srch_inf->ntwrk_buf_start) {
+		if (srch_inf->smallBuf)
+			cifs_small_buf_release(srch_inf->ntwrk_buf_start);
+		else
+			cifs_buf_release(srch_inf->ntwrk_buf_start);
+	}
+	srch_inf->ntwrk_buf_start = (char *)rsp;
+	srch_inf->srch_entries_start = srch_inf->last_entry =
+		(char *)rsp + le16_to_cpu(rsp->OutputBufferOffset);
+	end_of_smb = rsp_iov->iov_len + (char *)rsp;
+	srch_inf->entries_in_buffer =
+			num_entries(srch_inf->srch_entries_start, end_of_smb,
+				    &srch_inf->last_entry, info_buf_size);
+	srch_inf->index_of_last_entry += srch_inf->entries_in_buffer;
+	cifs_dbg(FYI, "num entries %d last_index %lld srch start %p srch end %p\n",
+		 srch_inf->entries_in_buffer, srch_inf->index_of_last_entry,
+		 srch_inf->srch_entries_start, srch_inf->last_entry);
+	if (resp_buftype == CIFS_LARGE_BUFFER)
+		srch_inf->smallBuf = false;
+	else if (resp_buftype == CIFS_SMALL_BUFFER)
+		srch_inf->smallBuf = true;
+	else
+		cifs_tcon_dbg(VFS, "illegal search buffer type\n");
+
+	return 0;
+}
+
+int
 SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, int index,
 		     struct cifs_search_info *srch_inf)
@@ -4382,8 +4443,6 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses = tcon->ses;
-	char *end_of_smb;
-	size_t info_buf_size;
 	int flags = 0;
 
 	if (ses && (ses->server))
@@ -4423,55 +4482,13 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qdir_exit;
 	}
 
-	switch (srch_inf->info_level) {
-	case SMB_FIND_FILE_DIRECTORY_INFO:
-		info_buf_size = sizeof(FILE_DIRECTORY_INFO) - 1;
-		break;
-	case SMB_FIND_FILE_ID_FULL_DIR_INFO:
-		info_buf_size = sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
-		break;
-	default:
-		cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
-			 srch_inf->info_level);
-		rc = -EINVAL;
-		goto qdir_exit;
-	}
-
-	rc = smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
-			       le32_to_cpu(rsp->OutputBufferLength), &rsp_iov,
-			       info_buf_size);
+	rc = smb2_parse_query_directory(tcon, &rsp_iov,	resp_buftype,
+					srch_inf);
 	if (rc) {
 		trace_smb3_query_dir_err(xid, persistent_fid, tcon->tid,
 			tcon->ses->Suid, index, 0, rc);
 		goto qdir_exit;
 	}
-
-	srch_inf->unicode = true;
-
-	if (srch_inf->ntwrk_buf_start) {
-		if (srch_inf->smallBuf)
-			cifs_small_buf_release(srch_inf->ntwrk_buf_start);
-		else
-			cifs_buf_release(srch_inf->ntwrk_buf_start);
-	}
-	srch_inf->ntwrk_buf_start = (char *)rsp;
-	srch_inf->srch_entries_start = srch_inf->last_entry =
-		(char *)rsp + le16_to_cpu(rsp->OutputBufferOffset);
-	end_of_smb = rsp_iov.iov_len + (char *)rsp;
-	srch_inf->entries_in_buffer =
-			num_entries(srch_inf->srch_entries_start, end_of_smb,
-				    &srch_inf->last_entry, info_buf_size);
-	srch_inf->index_of_last_entry += srch_inf->entries_in_buffer;
-	cifs_dbg(FYI, "num entries %d last_index %lld srch start %p srch end %p\n",
-		 srch_inf->entries_in_buffer, srch_inf->index_of_last_entry,
-		 srch_inf->srch_entries_start, srch_inf->last_entry);
-	if (resp_buftype == CIFS_LARGE_BUFFER)
-		srch_inf->smallBuf = false;
-	else if (resp_buftype == CIFS_SMALL_BUFFER)
-		srch_inf->smallBuf = true;
-	else
-		cifs_tcon_dbg(VFS, "illegal search buffer type\n");
-
 	resp_buftype = CIFS_NO_BUFFER;
 
 	trace_smb3_query_dir_done(xid, persistent_fid, tcon->tid,
-- 
2.13.6

