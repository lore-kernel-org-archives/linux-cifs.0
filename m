Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D21C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Oct 2021 15:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 987A860FDA
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Oct 2021 15:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhJSPnQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhJSPnL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Oct 2021 11:43:11 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE054C06161C
        for <linux-cifs@vger.kernel.org>; Tue, 19 Oct 2021 08:40:58 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b189-20020a1c1bc6000000b0030da052dd4fso3688012wmb.3
        for <linux-cifs@vger.kernel.org>; Tue, 19 Oct 2021 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pray0YL9Xpgon9w10zkXrjQClc70cS5lb6qxzuwVzjY=;
        b=bVFbZZlXpD9M1mY6JhtPVSgylwoxm5OgxeqnYaVvnZnZsb1JgER/fkYgLbuQ+WfpTB
         c47BHOMedoWRdFr2lz64Uzn8EBJBg9dgCuptctZYdsyFW20BPQT+aM5Rj5PIGapmTzvE
         YCYtMNw3sZ327iuOYl1Wskw+oytLPOokiPrBhOzJpYJC7fLVjfeLgXLDsWVyFLeMd5hC
         o8iPGkNwB3mOO0ufHK9TJG08hSR1Kh+y5E8plBRFw21Td3Xx6ah5+C+IdBdGY6pyZJ7y
         1xC3uDPdOj9Rgy0sSYD8eh2xFc9sAOBIjd3P4/0oEhH1gXRkXzfCJZ9KVzvcjHts+aMm
         W14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pray0YL9Xpgon9w10zkXrjQClc70cS5lb6qxzuwVzjY=;
        b=fooGt8xJHu14p7akAV2pjb+ZIvg0SZoWTUEI/VPBJ5Q0+4ZAY698gglVnnpHBkqtTt
         KR6Cu72BhM3N9cQP3ivq2xUyhWvp2D+Xid/EEy42gbk+6noSzZVy4WXhIT3qDMbZL5Xu
         qipW41hJwwjV3qXnHMrbk9TPnuAa4FiPm6ma48nTnx3NJgtf066MPwUQmw97w4dblvVu
         NIlLrBLsOLTLe8ZFXZSph07cgiptmTR7QzTbdkNZunfHTXA8Nr3bN2fmbL5dMKy6ZQTt
         eZ7bHnQdC8K14pKjau3AMeLufrhsZWmcHhHPaKBUftqm27enAK+Pgw8TIVhNPyEAsESx
         52tw==
X-Gm-Message-State: AOAM532TTsxdNO3vE+NmcySof6ysSZzrzcqR1aDpLPs+u9fPSEFdSMO0
        d+M+65FT2ZYmrZEQiMBYuxXoXVOHcLV8FQ==
X-Google-Smtp-Source: ABdhPJyQnaXCCbJL0ct+xqYQf3CfEC+7jTKh5HddzlMX3ALKQSArXT3+NdHTF4TConeg+mDQvwCbcg==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr44206989wrt.149.1634658057258;
        Tue, 19 Oct 2021 08:40:57 -0700 (PDT)
Received: from localhost.localdomain (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id o10sm2573380wmq.46.2021.10.19.08.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:40:56 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH v4] ksmbd: add buffer validation in session setup
Date:   Tue, 19 Oct 2021 17:39:38 +0200
Message-Id: <20211019153937.412534-1-mmakassikis@freebox.fr>
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
Changes since v3:
 - removed unused lm_off variable in ksmbd_decode_ntlmssp_auth_blob()
 - fixed previously invalid bounds check in ksmbd_decode_ntlmssp_auth_blob()

 fs/ksmbd/auth.c    | 16 ++++++++-------
 fs/ksmbd/smb2pdu.c | 51 ++++++++++++++++++++++++++++------------------
 2 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 71c989f1568d..30a92ddc1817 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -298,8 +298,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 				   int blob_len, struct ksmbd_session *sess)
 {
 	char *domain_name;
-	unsigned int lm_off, nt_off;
-	unsigned short nt_len;
+	unsigned int nt_off, dn_off;
+	unsigned short nt_len, dn_len;
 	int ret;
 
 	if (blob_len < sizeof(struct authenticate_message)) {
@@ -314,15 +314,17 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 		return -EINVAL;
 	}
 
-	lm_off = le32_to_cpu(authblob->LmChallengeResponse.BufferOffset);
 	nt_off = le32_to_cpu(authblob->NtChallengeResponse.BufferOffset);
 	nt_len = le16_to_cpu(authblob->NtChallengeResponse.Length);
+	dn_off = le32_to_cpu(authblob->DomainName.BufferOffset);
+	dn_len = le16_to_cpu(authblob->DomainName.Length);
+
+	if (blob_len < (u64)dn_off + dn_len || blob_len < (u64)nt_off + nt_len)
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

