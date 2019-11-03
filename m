Return-Path: <SRS0=MPEU=Y3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EF0CA9EC7
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 01:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E54215EA
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 01:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfKCBV2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Nov 2019 21:21:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:57544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727346AbfKCBV1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Nov 2019 21:21:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2C1FAE9A;
        Sun,  3 Nov 2019 01:21:25 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v4 3/6] cifs: add server param
Date:   Sun,  3 Nov 2019 02:21:09 +0100
Message-Id: <20191103012112.12212-4-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191103012112.12212-1-aaptel@suse.com>
References: <20191103012112.12212-1-aaptel@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As we get down to the transport layer, plenty of functions are passed
the session pointer and assume the transport to use is ses->server.

Instead we modify those functions to pass (ses, server) so that we
can decouple the session from the server.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsglob.h      |  3 ++-
 fs/cifs/cifsproto.h     |  1 +
 fs/cifs/smb2proto.h     |  3 ++-
 fs/cifs/smb2transport.c | 27 ++++++++++++++-------------
 fs/cifs/transport.c     |  5 +++--
 5 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 132dd8fd81ff..bff3c97288e0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -230,7 +230,8 @@ struct smb_version_operations {
 	bool (*compare_fids)(struct cifsFileInfo *, struct cifsFileInfo *);
 	/* setup request: allocate mid, sign message */
 	struct mid_q_entry *(*setup_request)(struct cifs_ses *,
-						struct smb_rqst *);
+					     struct TCP_Server_Info *,
+					     struct smb_rqst *);
 	/* setup async request: allocate mid, sign message */
 	struct mid_q_entry *(*setup_async_request)(struct TCP_Server_Info *,
 						struct smb_rqst *);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index fe597d3d5208..737547ddfa79 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -109,6 +109,7 @@ extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 			    char *in_buf, int flags);
 extern struct mid_q_entry *cifs_setup_request(struct cifs_ses *,
+				struct TCP_Server_Info *,
 				struct smb_rqst *);
 extern struct mid_q_entry *cifs_setup_async_request(struct TCP_Server_Info *,
 						struct smb_rqst *);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 71b2930b8e0b..a469fa211f37 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -46,7 +46,8 @@ extern int smb2_verify_signature(struct smb_rqst *, struct TCP_Server_Info *);
 extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
-			      struct smb_rqst *rqst);
+					      struct TCP_Server_Info *,
+					      struct smb_rqst *rqst);
 extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
 extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 148d7942c796..c6ef52e44408 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -610,18 +610,18 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
 }
 
 static int
-smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_sync_hdr *shdr,
-		   struct mid_q_entry **mid)
+smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
+		   struct smb2_sync_hdr *shdr, struct mid_q_entry **mid)
 {
-	if (ses->server->tcpStatus == CifsExiting)
+	if (server->tcpStatus == CifsExiting)
 		return -ENOENT;
 
-	if (ses->server->tcpStatus == CifsNeedReconnect) {
+	if (server->tcpStatus == CifsNeedReconnect) {
 		cifs_dbg(FYI, "tcp session dead - return to caller to retry\n");
 		return -EAGAIN;
 	}
 
-	if (ses->server->tcpStatus == CifsNeedNegotiate &&
+	if (server->tcpStatus == CifsNeedNegotiate &&
 	   shdr->Command != SMB2_NEGOTIATE)
 		return -EAGAIN;
 
@@ -638,11 +638,11 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_sync_hdr *shdr,
 		/* else ok - we are shutting down the session */
 	}
 
-	*mid = smb2_mid_entry_alloc(shdr, ses->server);
+	*mid = smb2_mid_entry_alloc(shdr, server);
 	if (*mid == NULL)
 		return -ENOMEM;
 	spin_lock(&GlobalMid_Lock);
-	list_add_tail(&(*mid)->qhead, &ses->server->pending_mid_q);
+	list_add_tail(&(*mid)->qhead, &server->pending_mid_q);
 	spin_unlock(&GlobalMid_Lock);
 
 	return 0;
@@ -675,24 +675,25 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 }
 
 struct mid_q_entry *
-smb2_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
+smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
+		   struct smb_rqst *rqst)
 {
 	int rc;
 	struct smb2_sync_hdr *shdr =
 			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
-	smb2_seq_num_into_buf(ses->server, shdr);
+	smb2_seq_num_into_buf(server, shdr);
 
-	rc = smb2_get_mid_entry(ses, shdr, &mid);
+	rc = smb2_get_mid_entry(ses, server, shdr, &mid);
 	if (rc) {
-		revert_current_mid_from_hdr(ses->server, shdr);
+		revert_current_mid_from_hdr(server, shdr);
 		return ERR_PTR(rc);
 	}
 
-	rc = smb2_sign_rqst(rqst, ses->server);
+	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
-		revert_current_mid_from_hdr(ses->server, shdr);
+		revert_current_mid_from_hdr(server, shdr);
 		cifs_delete_mid(mid);
 		return ERR_PTR(rc);
 	}
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index ed4ce2954db1..94f6ea02aa3e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -930,7 +930,8 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 }
 
 struct mid_q_entry *
-cifs_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
+cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *ignored,
+		   struct smb_rqst *rqst)
 {
 	int rc;
 	struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
@@ -1047,7 +1048,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	for (i = 0; i < num_rqst; i++) {
-		midQ[i] = server->ops->setup_request(ses, &rqst[i]);
+		midQ[i] = server->ops->setup_request(ses, server, &rqst[i]);
 		if (IS_ERR(midQ[i])) {
 			revert_current_mid(server, i);
 			for (j = 0; j < i; j++)
-- 
2.16.4

