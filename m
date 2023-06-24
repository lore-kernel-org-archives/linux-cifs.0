Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0A9EB64DA
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Jun 2023 04:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjFXEIR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 24 Jun 2023 00:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjFXEIQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 24 Jun 2023 00:08:16 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C0026A9
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 21:08:15 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-25eee11a9f1so721913a91.1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 21:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687579695; x=1690171695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lo/jyHwapnz17dpsy0erF+YNTNEBFFu0c0W4ko3Fuek=;
        b=aG/wTssgd+VTBIz5ohY1HQWiAxVA2tKPXp4azLqlc2S1hAB6DNBzushvjbXtVALPpJ
         d4dsSpbJFXxW8Ky0LR3HxfXnogxh7YwJRTYIU3yz0vIphSCpuoPBnCCxlwhAYECVkYtc
         s3teObNRbnLHC2CigunJlTfKlXSkDzLerrHXH9SL41o/xbR0HSWtyHnjibZ67Hz8BdIL
         rKAi+zTzn/tXTufG5kQwLcHCsPmwAJfplKCI8YCYNwSqpM2tyfw2EpuBJeoAKE9mzmlx
         cwQ3Ucfv3MYMMF1I/+tFC3r2aPBqsSq6HbOGMDcrY+ZLVicrQ5qy85D7a+ebhcJkASFF
         P/Hw==
X-Gm-Message-State: AC+VfDw5+unHi2MAKWLPad9fWYxkBkwpU41ghglRTz2e4mUt7g7uwYWQ
        El8Ysh3XyhaXWPS+kTaYBFctylJDv9g=
X-Google-Smtp-Source: ACHHUZ6ICNJZLNa6oFS6uQv2QW7gEGCaVDrkIoyd7BUkDOhS/9N66/8lSmbPsDRU6bVdC9VcAVsxdQ==
X-Received: by 2002:a17:902:db09:b0:1b5:e38:7bbe with SMTP id m9-20020a170902db0900b001b50e387bbemr707732plx.1.1687579695104;
        Fri, 23 Jun 2023 21:08:15 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id s3-20020a170902a50300b001b2063d43a7sm283327plq.249.2023.06.23.21.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 21:08:14 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH] ksmbd: fix out of bounds read in smb2_sess_setup
Date:   Sat, 24 Jun 2023 13:01:40 +0900
Message-Id: <20230624040141.16088-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd does not consider the case of that smb2 session setup is
in compound request. If this is the second payload of the compound,
OOB read issue occurs while processing the first payload in
the smb2_sess_setup().

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21355
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d31926194ebf..38738b430e11 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1322,9 +1322,8 @@ static int decode_negotiation_token(struct ksmbd_conn *conn,
 
 static int ntlm_negotiate(struct ksmbd_work *work,
 			  struct negotiate_message *negblob,
-			  size_t negblob_len)
+			  size_t negblob_len, struct smb2_sess_setup_rsp *rsp)
 {
-	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct challenge_message *chgblob;
 	unsigned char *spnego_blob = NULL;
 	u16 spnego_blob_len;
@@ -1429,10 +1428,10 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
 	return user;
 }
 
-static int ntlm_authenticate(struct ksmbd_work *work)
+static int ntlm_authenticate(struct ksmbd_work *work,
+			     struct smb2_sess_setup_req *req,
+			     struct smb2_sess_setup_rsp *rsp)
 {
-	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	struct channel *chann = NULL;
@@ -1566,10 +1565,10 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 }
 
 #ifdef CONFIG_SMB_SERVER_KERBEROS5
-static int krb5_authenticate(struct ksmbd_work *work)
+static int krb5_authenticate(struct ksmbd_work *work,
+			     struct smb2_sess_setup_req *req,
+			     struct smb2_sess_setup_rsp *rsp)
 {
-	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	char *in_blob, *out_blob;
@@ -1647,7 +1646,9 @@ static int krb5_authenticate(struct ksmbd_work *work)
 	return 0;
 }
 #else
-static int krb5_authenticate(struct ksmbd_work *work)
+static int krb5_authenticate(struct ksmbd_work *work,
+			     struct smb2_sess_setup_req *req,
+			     struct smb2_sess_setup_rsp *rsp)
 {
 	return -EOPNOTSUPP;
 }
@@ -1656,8 +1657,8 @@ static int krb5_authenticate(struct ksmbd_work *work)
 int smb2_sess_setup(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_sess_setup_req *req = smb2_get_msg(work->request_buf);
-	struct smb2_sess_setup_rsp *rsp = smb2_get_msg(work->response_buf);
+	struct smb2_sess_setup_req *req;
+	struct smb2_sess_setup_rsp *rsp;
 	struct ksmbd_session *sess;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
@@ -1665,6 +1666,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "Received request for session setup\n");
 
+	WORK_BUFFERS(work, req, rsp);
+
 	rsp->StructureSize = cpu_to_le16(9);
 	rsp->SessionFlags = 0;
 	rsp->SecurityBufferOffset = cpu_to_le16(72);
@@ -1786,7 +1789,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (conn->preferred_auth_mech &
 				(KSMBD_AUTH_KRB5 | KSMBD_AUTH_MSKRB5)) {
-			rc = krb5_authenticate(work);
+			rc = krb5_authenticate(work, req, rsp);
 			if (rc) {
 				rc = -EINVAL;
 				goto out_err;
@@ -1800,7 +1803,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			sess->Preauth_HashValue = NULL;
 		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
 			if (negblob->MessageType == NtLmNegotiate) {
-				rc = ntlm_negotiate(work, negblob, negblob_len);
+				rc = ntlm_negotiate(work, negblob, negblob_len, rsp);
 				if (rc)
 					goto out_err;
 				rsp->hdr.Status =
@@ -1813,7 +1816,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 						le16_to_cpu(rsp->SecurityBufferLength) - 1);
 
 			} else if (negblob->MessageType == NtLmAuthenticate) {
-				rc = ntlm_authenticate(work);
+				rc = ntlm_authenticate(work, req, rsp);
 				if (rc)
 					goto out_err;
 
-- 
2.25.1

