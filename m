Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4C3C54EE9
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 14:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiIVOlB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiIVOkd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 10:40:33 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CFA101F7
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:39:42 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id q35-20020a17090a752600b002038d8a68fbso2619870pjk.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Vepw6+922QKEDGQVwaxZlyBI5feFMxCy+R+AFA7j8yo=;
        b=2bHT6HvpF1canhWn29TNjvJnpXNUGyOLhMtegwMgKM1pJSEQBWT944jlzqZZjxADRE
         5fZiD8CEMO0V8evL1BBea6ePaznhWf9L9ne/lHj/NJwQ08gR1yGx+l2tBxpP9MZpV9o+
         TsusDXGgsK5nZ1Lt8kBuyfVSkGS8pPm2uy+q7A9oJs8pd1nPsohzB+Svod7f9grJjG/6
         oYC/7c2TVjZ1p2C8lJanN3cLyModbopG/GIQuLakLNQAdScz2IDVk50G4vBPnw9kYbIc
         WH+F1b1LKjyiqrlwVW9dwAyVZwIKyvNTJlAVo809MQ5++22emwo0cfpNTxw7WEvolpDd
         sDug==
X-Gm-Message-State: ACrzQf1rLFqtK0c0CkTdY0b5hi6zWEcM+anN09ZQH9VnaeTFBH13iIIX
        FKFnP76ZTK/JJD4xkg1IHxi+6gZgqik=
X-Google-Smtp-Source: AMsMyM6N/IPMmBZ/hp35Alh1iYOM2Hh/bRVm3AmsA/8aqlrSqjptxe5qHE4ao2DcxWhkbl42OYE7yw==
X-Received: by 2002:a17:90a:e7d1:b0:200:94fd:967a with SMTP id kb17-20020a17090ae7d100b0020094fd967amr4007248pjb.57.1663857580912;
        Thu, 22 Sep 2022 07:39:40 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id b67-20020a621b46000000b0053e22c7f135sm4500311pfb.141.2022.09.22.07.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 07:39:40 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ksmbd: fix encryption failure issue for session logoff response
Date:   Thu, 22 Sep 2022 23:39:05 +0900
Message-Id: <20220922143906.10826-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922143906.10826-1-linkinjeon@kernel.org>
References: <20220922143906.10826-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If client send encrypted session logoff request on seal mount,
Encryption for that response fails.

ksmbd: Could not get encryption key
CIFS: VFS: cifs_put_smb_ses: Session Logoff failure rc=-512

Session lookup fails in ksmbd_get_encryption_key() because sess->state is
set to SMB2_SESSION_EXPIRED in session logoff. There is no need to do
session lookup again to encrypt the response. This patch change to use
ksmbd_session in ksmbd_work.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/auth.c    | 12 ++++++++----
 fs/ksmbd/auth.h    |  3 ++-
 fs/ksmbd/smb2pdu.c |  7 +++----
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index c5a5c7b90d72..2330d7754cf6 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -984,13 +984,16 @@ int ksmbd_gen_sd_hash(struct ksmbd_conn *conn, char *sd_buf, int len,
 	return rc;
 }
 
-static int ksmbd_get_encryption_key(struct ksmbd_conn *conn, __u64 ses_id,
+static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 				    int enc, u8 *key)
 {
 	struct ksmbd_session *sess;
 	u8 *ses_enc_key;
 
-	sess = ksmbd_session_lookup_all(conn, ses_id);
+	if (enc)
+		sess = work->sess;
+	else
+		sess = ksmbd_session_lookup_all(work->conn, ses_id);
 	if (!sess)
 		return -EINVAL;
 
@@ -1078,9 +1081,10 @@ static struct scatterlist *ksmbd_init_sg(struct kvec *iov, unsigned int nvec,
 	return sg;
 }
 
-int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
+int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 			unsigned int nvec, int enc)
 {
+	struct ksmbd_conn *conn = work->conn;
 	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(iov[0].iov_base);
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc;
@@ -1094,7 +1098,7 @@ int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	struct ksmbd_crypto_ctx *ctx;
 
-	rc = ksmbd_get_encryption_key(conn,
+	rc = ksmbd_get_encryption_key(work,
 				      le64_to_cpu(tr_hdr->SessionId),
 				      enc,
 				      key);
diff --git a/fs/ksmbd/auth.h b/fs/ksmbd/auth.h
index 25b772653de0..362b6159a6cf 100644
--- a/fs/ksmbd/auth.h
+++ b/fs/ksmbd/auth.h
@@ -33,9 +33,10 @@
 
 struct ksmbd_session;
 struct ksmbd_conn;
+struct ksmbd_work;
 struct kvec;
 
-int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
+int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 			unsigned int nvec, int enc);
 void ksmbd_copy_gss_neg_header(void *buf);
 int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 6f48b6331bfc..649f9b72707a 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8589,7 +8589,7 @@ int smb3_encrypt_resp(struct ksmbd_work *work)
 	buf_size += iov[1].iov_len;
 	work->resp_hdr_sz = iov[1].iov_len;
 
-	rc = ksmbd_crypt_message(work->conn, iov, rq_nvec, 1);
+	rc = ksmbd_crypt_message(work, iov, rq_nvec, 1);
 	if (rc)
 		return rc;
 
@@ -8608,7 +8608,6 @@ bool smb3_is_transform_hdr(void *buf)
 
 int smb3_decrypt_req(struct ksmbd_work *work)
 {
-	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess;
 	char *buf = work->request_buf;
 	unsigned int pdu_length = get_rfc1002_len(buf);
@@ -8628,7 +8627,7 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 		return -ECONNABORTED;
 	}
 
-	sess = ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId));
+	sess = ksmbd_session_lookup_all(work->conn, le64_to_cpu(tr_hdr->SessionId));
 	if (!sess) {
 		pr_err("invalid session id(%llx) in transform header\n",
 		       le64_to_cpu(tr_hdr->SessionId));
@@ -8639,7 +8638,7 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
 	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr) + 4;
 	iov[1].iov_len = buf_data_size;
-	rc = ksmbd_crypt_message(conn, iov, 2, 0);
+	rc = ksmbd_crypt_message(work, iov, 2, 0);
 	if (rc)
 		return rc;
 
-- 
2.25.1

