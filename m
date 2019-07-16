Return-Path: <SRS0=queM=VN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CFAC76188
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 05:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98E16206C2
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 05:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfGPFHU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Jul 2019 01:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfGPFHU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Jul 2019 01:07:20 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7EEAEB2DC5;
        Tue, 16 Jul 2019 05:07:19 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-77.bne.redhat.com [10.64.54.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D52135C21A;
        Tue, 16 Jul 2019 05:07:18 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: prepare SMB2_Flush to be usable in compounds
Date:   Tue, 16 Jul 2019 15:07:08 +1000
Message-Id: <20190716050708.14482-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 16 Jul 2019 05:07:19 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Create smb2_flush_init() and smb2_flush_free() so we can use the flush command
in compounds.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c   | 58 ++++++++++++++++++++++++++++++++++++-----------------
 fs/cifs/smb2proto.h |  4 ++++
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f58e4dc3987b..b352f453a6d2 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3262,44 +3262,64 @@ SMB2_echo(struct TCP_Server_Info *server)
 	return rc;
 }
 
+void
+SMB2_flush_free(struct smb_rqst *rqst)
+{
+	if (rqst && rqst->rq_iov)
+		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+}
+
 int
-SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
-	   u64 volatile_fid)
+SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
+		struct cifs_tcon *tcon, u64 persistent_fid, u64 volatile_fid)
 {
-	struct smb_rqst rqst;
 	struct smb2_flush_req *req;
-	struct cifs_ses *ses = tcon->ses;
-	struct kvec iov[1];
-	struct kvec rsp_iov;
-	int resp_buftype;
-	int rc = 0;
-	int flags = 0;
+	struct kvec *iov = rqst->rq_iov;
 	unsigned int total_len;
-
-	cifs_dbg(FYI, "Flush\n");
-
-	if (!ses || !(ses->server))
-		return -EIO;
+	int rc;
 
 	rc = smb2_plain_req_init(SMB2_FLUSH, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
-	if (smb3_encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
 	req->PersistentFileId = persistent_fid;
 	req->VolatileFileId = volatile_fid;
 
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
 
+	return 0;
+}
+
+int
+SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
+	   u64 volatile_fid)
+{
+	struct cifs_ses *ses = tcon->ses;
+	struct smb_rqst rqst;
+	struct kvec iov[1];
+	struct kvec rsp_iov = {NULL, 0};
+	int resp_buftype = CIFS_NO_BUFFER;
+	int flags = 0;
+	int rc = 0;
+
+	cifs_dbg(FYI, "flush\n");
+	if (!ses || !(ses->server))
+		return -EIO;
+
+	if (smb3_encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
 	memset(&rqst, 0, sizeof(struct smb_rqst));
+	memset(&iov, 0, sizeof(iov));
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 1;
 
+	rc = SMB2_flush_init(xid, &rqst, tcon, persistent_fid, volatile_fid);
+	if (rc)
+		goto flush_exit;
+
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
-	cifs_small_buf_release(req);
 
 	if (rc != 0) {
 		cifs_stats_fail_inc(tcon, SMB2_FLUSH_HE);
@@ -3307,6 +3327,8 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 				     rc);
 	}
 
+ flush_exit:
+	SMB2_flush_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	return rc;
 }
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 52df125e9189..e4ca98cf3af3 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -158,6 +158,10 @@ extern int SMB2_close_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
 extern void SMB2_close_free(struct smb_rqst *rqst);
 extern int SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
+extern int SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
+			   struct cifs_tcon *tcon,
+			   u64 persistent_file_id, u64 volatile_file_id);
+extern void SMB2_flush_free(struct smb_rqst *rqst);
 extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   struct smb2_file_all_info *data);
-- 
2.13.6

