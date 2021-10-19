Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235CDC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Oct 2021 08:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF1986134F
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Oct 2021 08:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbhJSIkg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Oct 2021 04:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbhJSIkg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Oct 2021 04:40:36 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D73C06161C
        for <linux-cifs@vger.kernel.org>; Tue, 19 Oct 2021 01:38:23 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m22so46468184wrb.0
        for <linux-cifs@vger.kernel.org>; Tue, 19 Oct 2021 01:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=it03Nn2vpw5ZwvTRVcS8VM9fD91DzZ/n2bD8313pxFc=;
        b=hLlS7ALwmNhsRP9OHpNkGekNa7eckmexWqIJD0gAIxNgu9uFwuZNsXlVFtCo9EjAbq
         iSC4lZafWZvTxizs2WE5ZsJzdVGLwGRuPiIwMEZTxgVJzqbVf2LFjU9eBXNRRXMQPacZ
         0FAv8oNKF3W3NNUhcM6g3mFXcFWZXPDpYzsJSqfN8J+fTPgtra5qnoDOb4PO62xdWBtU
         TCyrY84+QCuc75D22oV2noMxsmAVT5R6VrSQuYLKAnVkVnK0ViJHbs1oPRjRcWxxR/7M
         aqWBSK+/4sqe6tJyFwWZQYK/z9AzoFtjKYjvKeyqoZJB5L5x5Y9sXx9OZfQvA1qBHVrm
         qziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=it03Nn2vpw5ZwvTRVcS8VM9fD91DzZ/n2bD8313pxFc=;
        b=PRv0y8imAfQLtbXRZ4GYaFDTALtsZ2/D/DBV/9YvK+rPAt4ShMesCFHB12ZzrcJS3Q
         /2yhWvoXdY+pj7g8PTqOBLavLYl5RVN07QXXuzP2KdezdNEnGoY7RQgxWWpcwTi5tWVf
         IbF8hwYplLj1QQAfl6JlxmhH6TUtLtX1+Ki+4StUdvhe62rTpxtzyVO9SW5ewYv6T/BQ
         1IQf0lX3YuYuCz8sGpqk0uL2KfWQQRoGZ/kNg0qIiHgePwZgXjFChzPSEszWqS5p1l4s
         WYwi7R/TRQ/mVlbvsLB4MCtj//zS6XF2bndvfoncm5BtZhis9QaWV9w0VnD3u5iLJnr9
         O2Gg==
X-Gm-Message-State: AOAM530m3Wx+nsdW10Y7BQ0br8Ekr65BIap0Si5IKfoCI/a+YiHyNE5h
        NpjtpzZbVVTCgDK1IWO1ZAhGKQ07UwGOtg==
X-Google-Smtp-Source: ABdhPJxqpRP+TdCcwGfsz/Fsb8kP72iH9is7Jb8Lo7foEVOCTB+08GOLhyFUYfsIhz4SzdGUcp7NQQ==
X-Received: by 2002:adf:8bdd:: with SMTP id w29mr41860252wra.49.1634632702245;
        Tue, 19 Oct 2021 01:38:22 -0700 (PDT)
Received: from localhost.localdomain (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id m15sm1695630wmq.0.2021.10.19.01.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 01:38:21 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH v3] ksmbd: add buffer validation in session setup
Date:   Tue, 19 Oct 2021 10:36:42 +0200
Message-Id: <20211019083641.116783-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make sure the security buffer's length/offset are valid with regards to
the packet length.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 Changes since v2:
 - check that negblob in smb2_sess_setup() is large enough to access the
   MessageType field

fs/ksmbd/auth.c    | 18 ++++++++++------
 fs/ksmbd/smb2pdu.c | 51 ++++++++++++++++++++++++++++------------------
 2 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 71c989f1568d..c9d32fea5669 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -298,8 +298,9 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 				   int blob_len, struct ksmbd_session *sess)
 {
 	char *domain_name;
-	unsigned int lm_off, nt_off;
-	unsigned short nt_len;
+	uintptr_t auth_msg_off;
+	unsigned int lm_off, nt_off, dn_off;
+	unsigned short nt_len, dn_len;
 	int ret;
 
 	if (blob_len < sizeof(struct authenticate_message)) {
@@ -314,15 +315,20 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 		return -EINVAL;
 	}
 
+	auth_msg_off = (uintptr_t)((char *)authblob + blob_len);
 	lm_off = le32_to_cpu(authblob->LmChallengeResponse.BufferOffset);
 	nt_off = le32_to_cpu(authblob->NtChallengeResponse.BufferOffset);
 	nt_len = le16_to_cpu(authblob->NtChallengeResponse.Length);
+	dn_off = le32_to_cpu(authblob->DomainName.BufferOffset);
+	dn_len = le16_to_cpu(authblob->DomainName.Length);
+
+	if (auth_msg_off < (u64)dn_off + dn_len ||
+	    auth_msg_off < (u64)nt_off + nt_len)
+		return -EINVAL;
 
 	/* TODO : use domain name that imported from configuration file */
-	domain_name = smb_strndup_from_utf16((const char *)authblob +
-			le32_to_cpu(authblob->DomainName.BufferOffset),
-			le16_to_cpu(authblob->DomainName.Length), true,
-			sess->conn->local_nls);
+	domain_name = smb_strndup_from_utf16((const char *)authblob + dn_off,
+					     dn_len, true, sess->conn->local_nls);
 	if (IS_ERR(domain_name))
 		return PTR_ERR(domain_name);
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 005aa93a49d6..f02766b1e9ce 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1274,19 +1274,13 @@ static int generate_preauth_hash(struct ksmbd_work *work)
 	return 0;
 }
 
-static int decode_negotiation_token(struct ksmbd_work *work,
-				    struct negotiate_message *negblob)
+static int decode_negotiation_token(struct ksmbd_conn *conn,
+				    struct negotiate_message *negblob,
+				    size_t sz)
 {
-	struct ksmbd_conn *conn = work->conn;
-	struct smb2_sess_setup_req *req;
-	int sz;
-
 	if (!conn->use_spnego)
 		return -EINVAL;
 
-	req = work->request_buf;
-	sz = le16_to_cpu(req->SecurityBufferLength);
-
 	if (ksmbd_decode_negTokenInit((char *)negblob, sz, conn)) {
 		if (ksmbd_decode_negTokenTarg((char *)negblob, sz, conn)) {
 			conn->auth_mechs |= KSMBD_AUTH_NTLMSSP;
@@ -1298,9 +1292,9 @@ static int decode_negotiation_token(struct ksmbd_work *work,
 }
 
 static int ntlm_negotiate(struct ksmbd_work *work,
-			  struct negotiate_message *negblob)
+			  struct negotiate_message *negblob,
+			  size_t negblob_len)
 {
-	struct smb2_sess_setup_req *req = work->request_buf;
 	struct smb2_sess_setup_rsp *rsp = work->response_buf;
 	struct challenge_message *chgblob;
 	unsigned char *spnego_blob = NULL;
@@ -1309,8 +1303,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
 	int sz, rc;
 
 	ksmbd_debug(SMB, "negotiate phase\n");
-	sz = le16_to_cpu(req->SecurityBufferLength);
-	rc = ksmbd_decode_ntlmssp_neg_blob(negblob, sz, work->sess);
+	rc = ksmbd_decode_ntlmssp_neg_blob(negblob, negblob_len, work->sess);
 	if (rc)
 		return rc;
 
@@ -1378,12 +1371,23 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
 	struct authenticate_message *authblob;
 	struct ksmbd_user *user;
 	char *name;
-	int sz;
+	unsigned int auth_msg_len, name_off, name_len, secbuf_len;
 
+	secbuf_len = le16_to_cpu(req->SecurityBufferLength);
+	if (secbuf_len < sizeof(struct authenticate_message)) {
+		ksmbd_debug(SMB, "blob len %d too small\n", secbuf_len);
+		return NULL;
+	}
 	authblob = user_authblob(conn, req);
-	sz = le32_to_cpu(authblob->UserName.BufferOffset);
-	name = smb_strndup_from_utf16((const char *)authblob + sz,
-				      le16_to_cpu(authblob->UserName.Length),
+	name_off = le32_to_cpu(authblob->UserName.BufferOffset);
+	name_len = le16_to_cpu(authblob->UserName.Length);
+	auth_msg_len = le16_to_cpu(req->SecurityBufferOffset) + secbuf_len;
+
+	if (auth_msg_len < (u64)name_off + name_len)
+		return NULL;
+
+	name = smb_strndup_from_utf16((const char *)authblob + name_off,
+				      name_len,
 				      true,
 				      conn->local_nls);
 	if (IS_ERR(name)) {
@@ -1629,6 +1633,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	struct smb2_sess_setup_rsp *rsp = work->response_buf;
 	struct ksmbd_session *sess;
 	struct negotiate_message *negblob;
+	unsigned int negblob_len, negblob_off;
 	int rc = 0;
 
 	ksmbd_debug(SMB, "Received request for session setup\n");
@@ -1709,10 +1714,16 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	if (sess->state == SMB2_SESSION_EXPIRED)
 		sess->state = SMB2_SESSION_IN_PROGRESS;
 
+	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
+	negblob_len = le16_to_cpu(req->SecurityBufferLength);
+	if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4) ||
+	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags))
+		return -EINVAL;
+
 	negblob = (struct negotiate_message *)((char *)&req->hdr.ProtocolId +
-			le16_to_cpu(req->SecurityBufferOffset));
+			negblob_off);
 
-	if (decode_negotiation_token(work, negblob) == 0) {
+	if (decode_negotiation_token(conn, negblob, negblob_len) == 0) {
 		if (conn->mechToken)
 			negblob = (struct negotiate_message *)conn->mechToken;
 	}
@@ -1736,7 +1747,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			sess->Preauth_HashValue = NULL;
 		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
 			if (negblob->MessageType == NtLmNegotiate) {
-				rc = ntlm_negotiate(work, negblob);
+				rc = ntlm_negotiate(work, negblob, negblob_len);
 				if (rc)
 					goto out_err;
 				rsp->hdr.Status =
-- 
2.25.1

