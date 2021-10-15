Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B04C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 13:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04FAB610E5
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 13:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhJONGW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Oct 2021 09:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbhJONGV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Oct 2021 09:06:21 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3849C061570
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 06:04:14 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v17so26337885wrv.9
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 06:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1e2Z9jBo3Op3keEHbd4A5uGdQPDIUKUvgZ+t4Qt24nQ=;
        b=hIVC+FqIYkUX5HoH5Ma6C016tpakW6KPO3rlgwQsAGQGJsczCN27FOPYxHW3thA4FB
         hf/HSbrij1CkBuiXW22LZ8Jn8qnEugYrcvjkTiu2MvN4Otoc77PrF3xLY+XLbGrt8yH0
         lx9LNDLQbCWI+IAArxWbWHil2HhFiS9hQgQdVu2gqCcW6/vmMwzKlbH5Cmm7ms5aC94E
         qRxS94G5zfwZIwJkZot/JPE8t1Vayr01Cq3/C/LCZ9SsioJdO1O0GgTLIsrMKtJGjNE9
         UP3rtPOubkcmFNlalTcOu+dBOE1uF01r3FMy8cydjV5jSc7+EFo2f+oxlKrMeUt3Yh2H
         erAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1e2Z9jBo3Op3keEHbd4A5uGdQPDIUKUvgZ+t4Qt24nQ=;
        b=i4BgLcnps2CUTvSbTky+ul5ayTf76+AdM/DoA/2HGq4DW2ggd6KhtUIB3/+PdbBpgh
         fgC3yfXQ5SNEqdRGkW/Dy0RM1TS5pbtJZ4uNRcT/HC3obahH93VUKpR0GEVbuqli3xYo
         R5kHD3v8U4ArNQCcDIem2wQGGOCQgJFe+D00HAZh+Q+Oa+Piou5RizjM6yyyXhwLYUC7
         PXo72YZUWW4T4EKOp47IewxZvQn5GklmqooPdW+OWFAIhhe++J0tSgTJPfn5UPkQd20O
         WO6CvJ/AHj5DT61sUzBt0FdqBscnKhpVqhhQNptpyCswN31VVKCzOCRbeKnap7hu+evU
         9TMg==
X-Gm-Message-State: AOAM533Mm5w+QRnRl2zLxm3d3yCbxvxdMZurY2s0raIfS4Rr5cH932SM
        OgOBlbzqP5P2dIbBUvPkJZoPzxvMj90zDw==
X-Google-Smtp-Source: ABdhPJzmbXAF+99j7p+KnxQojqcvFLgA7dcc1oXpRIYlfZPj101IZ33FH9vPIzdAA7tZVb6EKB/Itw==
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr13952073wrw.407.1634303053285;
        Fri, 15 Oct 2021 06:04:13 -0700 (PDT)
Received: from localhost.localdomain (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id l20sm15182695wmq.42.2021.10.15.06.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 06:04:13 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: add buffer validation in session setup
Date:   Fri, 15 Oct 2021 15:02:23 +0200
Message-Id: <20211015130222.2976760-1-mmakassikis@freebox.fr>
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
 fs/ksmbd/smb2pdu.c | 51 ++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 005aa93a49d6..5fc766439f0f 100644
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
 
@@ -1378,12 +1371,20 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
 	struct authenticate_message *authblob;
 	struct ksmbd_user *user;
 	char *name;
-	int sz;
+	unsigned int name_off, name_len, pdu_len;
 
 	authblob = user_authblob(conn, req);
-	sz = le32_to_cpu(authblob->UserName.BufferOffset);
-	name = smb_strndup_from_utf16((const char *)authblob + sz,
-				      le16_to_cpu(authblob->UserName.Length),
+	pdu_len = get_rfc1002_len(req) + 4;
+	name_off = le32_to_cpu(authblob->UserName.BufferOffset);
+	name_len = le16_to_cpu(authblob->UserName.Length);
+
+	if (((char *)authblob + name_off > (char *)req + pdu_len) ||
+	    (sizeof(struct smb2_sess_setup_req) +
+	    sizeof(struct authenticate_message) + name_len > pdu_len))
+		return NULL;
+
+	name = smb_strndup_from_utf16((const char *)authblob + name_off,
+				      name_len,
 				      true,
 				      conn->local_nls);
 	if (IS_ERR(name)) {
@@ -1629,6 +1630,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	struct smb2_sess_setup_rsp *rsp = work->response_buf;
 	struct ksmbd_session *sess;
 	struct negotiate_message *negblob;
+	unsigned int pdu_length, negblob_len, negblob_off;
 	int rc = 0;
 
 	ksmbd_debug(SMB, "Received request for session setup\n");
@@ -1709,10 +1711,19 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	if (sess->state == SMB2_SESSION_EXPIRED)
 		sess->state = SMB2_SESSION_IN_PROGRESS;
 
+	pdu_length = get_rfc1002_len(req);
+	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
+	negblob_len = le16_to_cpu(req->SecurityBufferLength);
+	if (negblob_off != (offsetof(struct smb2_sess_setup_req, Buffer) - 4))
+		return -EINVAL;
+
+	/* account for Buffer[1] and smb2_buf_length */
+	if (sizeof(struct smb2_sess_setup_req) + negblob_len - 1 > pdu_length + 4)
+		return -EINVAL;
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

