Return-Path: <SRS0=ymiT=25=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE08CC33C9E
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B464E2080A
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:08:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mb0hT/06"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgAHDIX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jan 2020 22:08:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22447 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726149AbgAHDIX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jan 2020 22:08:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578452901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Q36GqiqSX1/Ljg08h9iGc01oxDAlyVG4IjrHMfLy5YA=;
        b=Mb0hT/06TTnFJFPJpF4trdQqamFUx62Z/UGxHgZIZnnF8ICu0Nux031dc89Rk9siL2vJG3
        PN+FyJHEWRGGj2IxlYIRXfZHgL2pFbQdOSJAL8Whp1jI71swaOt8XTFzesvT4v4rdmSy4M
        8qmYWh550NGDVCvLwAuI0M++NJKu6vA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-w6UV0cw3NxmPfOekFjAhXQ-1; Tue, 07 Jan 2020 22:08:20 -0500
X-MC-Unique: w6UV0cw3NxmPfOekFjAhXQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4B72800D41
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jan 2020 03:08:19 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-61.bne.redhat.com [10.64.54.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 482865D9E2;
        Wed,  8 Jan 2020 03:08:19 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 3/4] cifs: use compounding for open and first query-dir for readdir()
Date:   Wed,  8 Jan 2020 13:08:06 +1000
Message-Id: <20200108030807.2460-4-lsahlber@redhat.com>
In-Reply-To: <20200108030807.2460-1-lsahlber@redhat.com>
References: <20200108030807.2460-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Combine the initial SMB2_Open and the first SMB2_Query_Directory in a compound.
This shaves one round-trip of each directory listing, changing it from 4 to 3
for small directories.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsproto.h |  3 ++
 fs/cifs/smb2ops.c   | 96 ++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 9c229408a251..f6f3cc90cd18 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -596,6 +596,9 @@ bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
 
 void extract_unc_hostname(const char *unc, const char **h, size_t *len);
 int copy_path_name(char *dst, const char *src);
+int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
+			       int resp_buftype,
+			       struct cifs_search_info *srch_inf);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6250370c1170..ca8e807f9b07 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2053,14 +2053,33 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		     struct cifs_search_info *srch_inf)
 {
 	__le16 *utf16_path;
-	int rc;
-	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	struct smb_rqst rqst[2];
+	struct kvec rsp_iov[2];
+	int resp_buftype[2];
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
+	int rc, flags = 0;
+	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
+	struct smb2_query_directory_rsp *qd_rsp = NULL;
+	struct smb2_create_rsp *op_rsp = NULL;
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path)
 		return -ENOMEM;
 
+	if (smb3_encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
+	memset(rqst, 0, sizeof(rqst));
+	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
+	memset(rsp_iov, 0, sizeof(rsp_iov));
+
+	/* Open */
+	memset(&open_iov, 0, sizeof(open_iov));
+	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
 	oparms.disposition = FILE_OPEN;
@@ -2071,22 +2090,75 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = fid;
 	oparms.reconnect = false;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL);
-	kfree(utf16_path);
-	if (rc) {
-		cifs_dbg(FYI, "open dir failed rc=%d\n", rc);
-		return rc;
-	}
+	rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, utf16_path);
+	if (rc)
+		goto qdf_free;
+	smb2_set_next_command(tcon, &rqst[0]);
 
+	/* Query directory */
 	srch_inf->entries_in_buffer = 0;
 	srch_inf->index_of_last_entry = 2;
 
-	rc = SMB2_query_directory(xid, tcon, fid->persistent_fid,
-				  fid->volatile_fid, 0, srch_inf);
-	if (rc) {
-		cifs_dbg(FYI, "query directory failed rc=%d\n", rc);
+	memset(&qd_iov, 0, sizeof(qd_iov));
+	rqst[1].rq_iov = qd_iov;
+	rqst[1].rq_nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
+
+	rc = SMB2_query_directory_init(xid, tcon, &rqst[1],
+				       COMPOUND_FID, COMPOUND_FID,
+				       0, srch_inf->info_level);
+	if (rc)
+		goto qdf_free;
+
+	smb2_set_related(&rqst[1]);
+
+	rc = compound_send_recv(xid, tcon->ses, flags, 2, rqst,
+				resp_buftype, rsp_iov);
+
+	/* If the open failed there is nothing to do */
+	op_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
+	if (op_rsp == NULL || op_rsp->sync_hdr.Status != STATUS_SUCCESS) {
+		cifs_dbg(FYI, "query_dir_first: open failed rc=%d\n", rc);
+		goto qdf_free;
+	}
+	fid->persistent_fid = op_rsp->PersistentFileId;
+	fid->volatile_fid = op_rsp->VolatileFileId;
+
+	/* Anything else than ENODATA means a genuine error */
+	if (rc && rc != -ENODATA) {
 		SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
+		cifs_dbg(FYI, "query_dir_first: query directory failed rc=%d\n", rc);
+		trace_smb3_query_dir_err(xid, fid->persistent_fid,
+					 tcon->tid, tcon->ses->Suid, 0, 0, rc);
+		goto qdf_free;
 	}
+
+	qd_rsp = (struct smb2_query_directory_rsp *)rsp_iov[1].iov_base;
+	if (qd_rsp->sync_hdr.Status == STATUS_NO_MORE_FILES) {
+		trace_smb3_query_dir_done(xid, fid->persistent_fid,
+					  tcon->tid, tcon->ses->Suid, 0, 0);
+		srch_inf->endOfSearch = true;
+		rc = 0;
+		goto qdf_free;
+	}
+
+	rc = smb2_parse_query_directory(tcon, &rsp_iov[1], resp_buftype[1],
+					srch_inf);
+	if (rc) {
+		trace_smb3_query_dir_err(xid, fid->persistent_fid, tcon->tid,
+			tcon->ses->Suid, 0, 0, rc);
+		goto qdf_free;
+	}
+	resp_buftype[1] = CIFS_NO_BUFFER;
+
+	trace_smb3_query_dir_done(xid, fid->persistent_fid, tcon->tid,
+			tcon->ses->Suid, 0, srch_inf->entries_in_buffer);
+
+ qdf_free:
+	kfree(utf16_path);
+	SMB2_open_free(&rqst[0]);
+	SMB2_query_directory_free(&rqst[1]);
+	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
+	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	return rc;
 }
 
-- 
2.13.6

