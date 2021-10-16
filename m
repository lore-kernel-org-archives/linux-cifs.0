Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91507C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Oct 2021 23:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 654EB610D1
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Oct 2021 23:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbhJPX7f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Oct 2021 19:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241211AbhJPX7e (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Oct 2021 19:59:34 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC0CC061765
        for <linux-cifs@vger.kernel.org>; Sat, 16 Oct 2021 16:57:25 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l38-20020a05600c1d2600b0030d80c3667aso5153248wms.5
        for <linux-cifs@vger.kernel.org>; Sat, 16 Oct 2021 16:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Or6HiEzpdXr7wF6rHtA1YbXu7VxAvmlzVdS3znn+dww=;
        b=ICeEDksEHwpykWzCTiXJt57IGdzWMZBNx26Wktiqu3agMLqbhGCvKW4nl4cuO/1EVt
         LWbswVwwIz9cJ8QjQPwJ8B+2Od4F4974UIIOOmnkNpFOrEOK7PDRlt3xt/hzknzQwHC1
         tUBX2DLFy/COue8xYhHESMNUtnvP/BOb/4FMOS8tN0MFJnGaJKMCUPg7Q6CV7AqBBAuw
         YYb67ZOX9N9X4Khg7tqWNncicNGc8Hpj0iD9VUnOaVK+32ku14P63rP/4ekXsyS4DJaO
         C4ybf9UMcy1Uxce6h2HjlKMe/TuHWgGPtG2u0Lq0IvlAn2f1/rpJA0/bqWUod/2Lk6E1
         I6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Or6HiEzpdXr7wF6rHtA1YbXu7VxAvmlzVdS3znn+dww=;
        b=F0JB8On+IPghSzk0EZr3/b43Z0cllMOKpRKJQoLIq7U81qxkaU1zYeDsSCBp1UF8r6
         wHAXIcW92iLObIU1PcB2qSlNiHD25AdA4uRZxuFjxmtnd1qvYIqcVhFImjn+Z912kbTd
         H8IS07A3XyMT6zwjgnT/JqaKiQFgQx42ChXV81YWRf+Wb/Yto+AIOFSL5vLk5QFQnHX7
         f6Ysbyv4CZDxwpWMyRxJgsddWVamenQExGEwbUpT4NiM18qG1n9SIedjsiiCjHlnBOd8
         gw9MuvHC75U6fWZg8TCNPtlGPelvmb0Ymmo9s8WV10xCrWKiHTpeRQBKyB3ZuvVCRwma
         L1+g==
X-Gm-Message-State: AOAM530B0golBuESafhX+Qsj9oO5HG/EUWnrxvdZ6E487sGmpZTNvOd4
        9QXPfawXfuI9DCkzCIkf25r9K4JWhgPDxQ==
X-Google-Smtp-Source: ABdhPJyvgrimmyU6kkupZtmZ3G9IQMSL6/cyWeuak+Tz5SmijRFwKRWrirfqvZ2ZgGzYNm8VSuhNog==
X-Received: by 2002:a1c:9ac4:: with SMTP id c187mr35473384wme.18.1634428644040;
        Sat, 16 Oct 2021 16:57:24 -0700 (PDT)
Received: from localhost.localdomain (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id u5sm8100247wmm.39.2021.10.16.16.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 16:57:23 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH v2] ksmbd: add buffer validation in session setup
Date:   Sun, 17 Oct 2021 01:57:15 +0200
Message-Id: <20211016235715.3469969-1-mmakassikis@freebox.fr>
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
Changes since v1:
 - check that securitybuffer is large enough to hold a struct
   authenticate_message in session_user() 
 - simplified check for UserName field
 - added check for NtChallengeResponse and DomainName in
   ksmbd_decode_ntlmssp_auth_blob()
 - removed check in smb2_sess_setup() that is redundant with
   ksmbd_smb2_check_message()
 
 As an aside, I find auditing the current code for missing checks to be quite
 difficult. The received buffer is cast to some struct right before usage and
 it's unclear whether the values read using the le*_to_cpu() macros have been
 validated. For example, ksmbd_decode_ntlmssp_auth_blob() has a blob_len
 parameter. Fortunately, there's a single call-site, but it looks like this:

	struct authenticate_message *authblob;

	authblob = user_authblob(conn, req);
	sz = le16_to_cpu(req->SecurityBufferLength);
	rc = ksmbd_decode_ntlmssp_auth_blob(authblob, sz, sess);

It's not immediately obvious that 'sz' here is a valid value. The actual check
is done in ksmbd_smb2_check_message().

I wonder if we wouldn't be better off carrying a size and offset variable
alongside the request buffer and decode the request header into a struct as we
go. I'm afraid there are checks missing -- or that future changes may not
properly validate the input buffer.

 fs/ksmbd/auth.c    | 18 +++++++++++------
 fs/ksmbd/smb2pdu.c | 50 +++++++++++++++++++++++++++-------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 71c989f1568d..e3c54888544f 100644
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
+			dn_len, true, sess->conn->local_nls);
 	if (IS_ERR(domain_name))
 		return PTR_ERR(domain_name);
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 005aa93a49d6..c4e84537b5ca 100644
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
@@ -1709,10 +1714,15 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	if (sess->state == SMB2_SESSION_EXPIRED)
 		sess->state = SMB2_SESSION_IN_PROGRESS;
 
+	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
+	negblob_len = le16_to_cpu(req->SecurityBufferLength);
+	if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4))
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
@@ -1736,7 +1746,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
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

