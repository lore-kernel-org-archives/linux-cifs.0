Return-Path: <SRS0=ymiT=25=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F111BC33C99
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0A272077B
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FFPucPTY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgAHDIU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jan 2020 22:08:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46998 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725812AbgAHDIU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jan 2020 22:08:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578452898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=x8G3F+nx74prFSdimHXOsKMyZPlKwUt5krE2vSDHvQw=;
        b=FFPucPTYR1hVj0gpsvgfYjNcSTD7eOSPp+Xe/6UPVoQnzTHJ2Yc6BlHqXuP8PrZVwHLj1i
        b/9OoI7jJd/UUkCYq7TYDRDwNMbGucE5W+QlDCGGx4m95NMtCP9m3Z0Dce6cK/d7bYiUZr
        SjP5vSceobzCNJwwg+c5PfhKE7YGyN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-Vb74-pOfNGOp7AggWUNHAA-1; Tue, 07 Jan 2020 22:08:17 -0500
X-MC-Unique: Vb74-pOfNGOp7AggWUNHAA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68E2B1800D4E
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jan 2020 03:08:16 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-61.bne.redhat.com [10.64.54.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0D0B100164D;
        Wed,  8 Jan 2020 03:08:15 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 1/4] cifs: prepare SMB2_query_directory to be used with compounding
Date:   Wed,  8 Jan 2020 13:08:04 +1000
Message-Id: <20200108030807.2460-2-lsahlber@redhat.com>
In-Reply-To: <20200108030807.2460-1-lsahlber@redhat.com>
References: <20200108030807.2460-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c   | 111 +++++++++++++++++++++++++++++++++++-----------------
 fs/cifs/smb2pdu.h   |   2 +
 fs/cifs/smb2proto.h |   5 +++
 3 files changed, 82 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9434f6dd8df3..50466062c1da 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4296,56 +4296,38 @@ num_entries(char *bufstart, char *end_of_buf, char **lastentry, size_t size)
 /*
  * Readdir/FindFirst
  */
-int
-SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
-		     u64 persistent_fid, u64 volatile_fid, int index,
-		     struct cifs_search_info *srch_inf)
+int SMB2_query_directory_init(const unsigned int xid,
+			      struct cifs_tcon *tcon, struct smb_rqst *rqst,
+			      u64 persistent_fid, u64 volatile_fid,
+			      int index, int info_level)
 {
-	struct smb_rqst rqst;
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct smb2_query_directory_req *req;
-	struct smb2_query_directory_rsp *rsp = NULL;
-	struct kvec iov[2];
-	struct kvec rsp_iov;
-	int rc = 0;
-	int len;
-	int resp_buftype = CIFS_NO_BUFFER;
 	unsigned char *bufptr;
-	struct TCP_Server_Info *server;
-	struct cifs_ses *ses = tcon->ses;
 	__le16 asteriks = cpu_to_le16('*');
-	char *end_of_smb;
-	unsigned int output_size = CIFSMaxBufSize;
-	size_t info_buf_size;
-	int flags = 0;
+	unsigned int output_size = CIFSMaxBufSize -
+		MAX_SMB2_CREATE_RESPONSE_SIZE -
+		MAX_SMB2_CLOSE_RESPONSE_SIZE;
 	unsigned int total_len;
-
-	if (ses && (ses->server))
-		server = ses->server;
-	else
-		return -EIO;
+	struct kvec *iov = rqst->rq_iov;
+	int len, rc;
 
 	rc = smb2_plain_req_init(SMB2_QUERY_DIRECTORY, tcon, (void **) &req,
 			     &total_len);
 	if (rc)
 		return rc;
 
-	if (smb3_encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
-	switch (srch_inf->info_level) {
+	switch (info_level) {
 	case SMB_FIND_FILE_DIRECTORY_INFO:
 		req->FileInformationClass = FILE_DIRECTORY_INFORMATION;
-		info_buf_size = sizeof(FILE_DIRECTORY_INFO) - 1;
 		break;
 	case SMB_FIND_FILE_ID_FULL_DIR_INFO:
 		req->FileInformationClass = FILEID_FULL_DIRECTORY_INFORMATION;
-		info_buf_size = sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
 		break;
 	default:
 		cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
-			 srch_inf->info_level);
-		rc = -EINVAL;
-		goto qdir_exit;
+			info_level);
+		return -EINVAL;
 	}
 
 	req->FileIndex = cpu_to_le32(index);
@@ -4374,15 +4356,56 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[1].iov_base = (char *)(req->Buffer);
 	iov[1].iov_len = len;
 
+	trace_smb3_query_dir_enter(xid, persistent_fid, tcon->tid,
+			tcon->ses->Suid, index, output_size);
+
+	return 0;
+}
+
+void SMB2_query_directory_free(struct smb_rqst *rqst)
+{
+	if (rqst && rqst->rq_iov) {
+		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+	}
+}
+
+int
+SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
+		     u64 persistent_fid, u64 volatile_fid, int index,
+		     struct cifs_search_info *srch_inf)
+{
+	struct smb_rqst rqst;
+	struct kvec iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
+	struct smb2_query_directory_rsp *rsp = NULL;
+	int resp_buftype = CIFS_NO_BUFFER;
+	struct kvec rsp_iov;
+	int rc = 0;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	char *end_of_smb;
+	size_t info_buf_size;
+	int flags = 0;
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	if (smb3_encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
 	memset(&rqst, 0, sizeof(struct smb_rqst));
+	memset(&iov, 0, sizeof(iov));
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = 2;
+	rqst.rq_nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
 
-	trace_smb3_query_dir_enter(xid, persistent_fid, tcon->tid,
-			tcon->ses->Suid, index, output_size);
+	rc = SMB2_query_directory_init(xid, tcon, &rqst, persistent_fid,
+				       volatile_fid, index,
+				       srch_inf->info_level);
+	if (rc)
+		goto qdir_exit;
 
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
-	cifs_small_buf_release(req);
 	rsp = (struct smb2_query_directory_rsp *)rsp_iov.iov_base;
 
 	if (rc) {
@@ -4400,6 +4423,20 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qdir_exit;
 	}
 
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
+		rc = -EINVAL;
+		goto qdir_exit;
+	}
+
 	rc = smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
 			       le32_to_cpu(rsp->OutputBufferLength), &rsp_iov,
 			       info_buf_size);
@@ -4435,11 +4472,13 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	else
 		cifs_tcon_dbg(VFS, "illegal search buffer type\n");
 
+	resp_buftype = CIFS_NO_BUFFER;
+
 	trace_smb3_query_dir_done(xid, persistent_fid, tcon->tid,
 			tcon->ses->Suid, index, srch_inf->entries_in_buffer);
-	return rc;
 
 qdir_exit:
+	SMB2_query_directory_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 7b1c379fdf7a..4c43dbd1e089 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1282,6 +1282,8 @@ struct smb2_echo_rsp {
 #define SMB2_INDEX_SPECIFIED		0x04
 #define SMB2_REOPEN			0x10
 
+#define SMB2_QUERY_DIRECTORY_IOV_SIZE 2
+
 struct smb2_query_directory_req {
 	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 33 */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 27d29f2eb6c8..6c678e00046f 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -197,6 +197,11 @@ extern int SMB2_echo(struct TCP_Server_Info *server);
 extern int SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 				u64 persistent_fid, u64 volatile_fid, int index,
 				struct cifs_search_info *srch_inf);
+extern int SMB2_query_directory_init(unsigned int xid, struct cifs_tcon *tcon,
+				     struct smb_rqst *rqst,
+				     u64 persistent_fid, u64 volatile_fid,
+				     int index, int info_level);
+extern void SMB2_query_directory_free(struct smb_rqst *rqst);
 extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 			u64 persistent_fid, u64 volatile_fid, u32 pid,
 			__le64 *eof);
-- 
2.13.6

