Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2172DC433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 13:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02B5661076
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 13:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhKCNgl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 09:36:41 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:45570 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhKCNgl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Nov 2021 09:36:41 -0400
Received: by mail-pg1-f177.google.com with SMTP id f5so2361949pgc.12
        for <linux-cifs@vger.kernel.org>; Wed, 03 Nov 2021 06:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hb8Zp0vsB6F60+UxyxsLZ3rqgNPpuqgrAqBkNV5rbUU=;
        b=JwqTqQ6A1ISvV4T1IurmG6Cu81IzlxOC+jFW/LuzsQ6Wnoj4CP7CWMXggUbsVaTfna
         NcIEE3K7TzvyCNWJJmO40ISatsjROfaK9qJCxV+sKIl8Kwcp/NHg8OM/qbY/kA3alEtA
         ONY5jdvzwhTyBRiR/uH0yNy5FBhoGCrGU5TMjhl7wuMR1B0Lg7q4W/97KDoPELMSGeWh
         62HvCJ0U6ggYmrDXPsjmsYRS60PHI+JYDkKMq9qY0ezWmlwXrEzfiupQOBVp3Y0b0cFs
         bD4wbw0+EAKaj9i7QYVH3GBjG6w2kDTSeTyeG5ZBQov2Ztib8i0/KA8y4FxxGu7RQNah
         U8ng==
X-Gm-Message-State: AOAM532hBGS+vlY+Paeiw1zhpSZHFuD+1+x6wsNUzC8oFEfr0vO5WNXO
        T8gMhv+uNWwKHu9DmzDi44nyACOkW3w=
X-Google-Smtp-Source: ABdhPJzoAd4eiu3Xwx1vS3d4KnY3xij10XBYweDXcMqmpa0dto63Uj5o2js/tF4satkEH+6ysDhvCQ==
X-Received: by 2002:a63:d857:: with SMTP id k23mr26143376pgj.31.1635946444463;
        Wed, 03 Nov 2021 06:34:04 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s14sm2692024pfk.95.2021.11.03.06.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 06:34:04 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ksmbd: remove smb2_buf_length in smb2_transform_hdr
Date:   Wed,  3 Nov 2021 22:33:52 +0900
Message-Id: <20211103133353.6650-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211103133353.6650-1-linkinjeon@kernel.org>
References: <20211103133353.6650-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

To move smb2_transform_hdr to smbfs_common, This patch remove
smb2_buf_length variable in smb2_transform_hdr.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/auth.c       |  7 +++----
 fs/ksmbd/connection.c |  2 +-
 fs/ksmbd/smb2pdu.c    | 37 +++++++++++++++++--------------------
 fs/ksmbd/smb2pdu.h    |  5 -----
 4 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index c69c5471db1c..3503b1c48cb4 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -983,7 +983,7 @@ static struct scatterlist *ksmbd_init_sg(struct kvec *iov, unsigned int nvec,
 					 u8 *sign)
 {
 	struct scatterlist *sg;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 24;
+	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int i, nr_entries[3] = {0}, total_entries = 0, sg_idx = 0;
 
 	if (!nvec)
@@ -1047,9 +1047,8 @@ static struct scatterlist *ksmbd_init_sg(struct kvec *iov, unsigned int nvec,
 int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
 			unsigned int nvec, int enc)
 {
-	struct smb2_transform_hdr *tr_hdr =
-		(struct smb2_transform_hdr *)iov[0].iov_base;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 24;
+	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(iov[0].iov_base);
+	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc;
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 12f710ccbdff..83a94d0bb480 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -171,7 +171,7 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 
 	if (work->tr_buf) {
 		iov[iov_idx] = (struct kvec) { work->tr_buf,
-				sizeof(struct smb2_transform_hdr) };
+				sizeof(struct smb2_transform_hdr) + 4 };
 		len += iov[iov_idx++].iov_len;
 	}
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 63bf185530c2..ba68a27cabf8 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8424,13 +8424,13 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)
 	}
 }
 
-static void fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, char *old_buf,
-			       __le16 cipher_type)
+static void fill_transform_hdr(void *tr_buf, char *old_buf, __le16 cipher_type)
 {
-	struct smb2_hdr *hdr = (struct smb2_hdr *)old_buf;
+	struct smb2_transform_hdr *tr_hdr = tr_buf + 4;
+	struct smb2_hdr *hdr = smb2_get_msg(old_buf);
 	unsigned int orig_len = get_rfc1002_len(old_buf);
 
-	memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
+	memset(tr_buf, 0, sizeof(struct smb2_transform_hdr) + 4);
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
 	tr_hdr->OriginalMessageSize = cpu_to_le32(orig_len);
 	tr_hdr->Flags = cpu_to_le16(0x01);
@@ -8440,14 +8440,13 @@ static void fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, char *old_buf,
 	else
 		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
 	memcpy(&tr_hdr->SessionId, &hdr->SessionId, 8);
-	inc_rfc1001_len(tr_hdr, sizeof(struct smb2_transform_hdr) - 4);
-	inc_rfc1001_len(tr_hdr, orig_len);
+	inc_rfc1001_len(tr_buf, sizeof(struct smb2_transform_hdr));
+	inc_rfc1001_len(tr_buf, orig_len);
 }
 
 int smb3_encrypt_resp(struct ksmbd_work *work)
 {
 	char *buf = work->response_buf;
-	struct smb2_transform_hdr *tr_hdr;
 	struct kvec iov[3];
 	int rc = -ENOMEM;
 	int buf_size = 0, rq_nvec = 2 + (work->aux_payload_sz ? 1 : 0);
@@ -8455,15 +8454,15 @@ int smb3_encrypt_resp(struct ksmbd_work *work)
 	if (ARRAY_SIZE(iov) < rq_nvec)
 		return -ENOMEM;
 
-	tr_hdr = kzalloc(sizeof(struct smb2_transform_hdr), GFP_KERNEL);
-	if (!tr_hdr)
+	work->tr_buf = kzalloc(sizeof(struct smb2_transform_hdr) + 4, GFP_KERNEL);
+	if (!work->tr_buf)
 		return rc;
 
 	/* fill transform header */
-	fill_transform_hdr(tr_hdr, buf, work->conn->cipher_type);
+	fill_transform_hdr(work->tr_buf, buf, work->conn->cipher_type);
 
-	iov[0].iov_base = tr_hdr;
-	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
+	iov[0].iov_base = work->tr_buf;
+	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
 	buf_size += iov[0].iov_len - 4;
 
 	iov[1].iov_base = buf + 4;
@@ -8483,15 +8482,14 @@ int smb3_encrypt_resp(struct ksmbd_work *work)
 		return rc;
 
 	memmove(buf, iov[1].iov_base, iov[1].iov_len);
-	tr_hdr->smb2_buf_length = cpu_to_be32(buf_size);
-	work->tr_buf = tr_hdr;
+	*(__be32 *)work->tr_buf = cpu_to_be32(buf_size);
 
 	return rc;
 }
 
 bool smb3_is_transform_hdr(void *buf)
 {
-	struct smb2_transform_hdr *trhdr = buf;
+	struct smb2_transform_hdr *trhdr = smb2_get_msg(buf);
 
 	return trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM;
 }
@@ -8503,9 +8501,8 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	char *buf = work->request_buf;
 	unsigned int pdu_length = get_rfc1002_len(buf);
 	struct kvec iov[2];
-	int buf_data_size = pdu_length + 4 -
-		sizeof(struct smb2_transform_hdr);
-	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
+	int buf_data_size = pdu_length - sizeof(struct smb2_transform_hdr);
+	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(buf);
 	int rc = 0;
 
 	if (buf_data_size < sizeof(struct smb2_hdr)) {
@@ -8527,8 +8524,8 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	}
 
 	iov[0].iov_base = buf;
-	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
-	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
+	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
+	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr) + 4;
 	iov[1].iov_len = buf_data_size;
 	rc = ksmbd_crypt_message(conn, iov, 2, 0);
 	if (rc)
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index a70f5461bffe..f418b001b999 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -159,11 +159,6 @@ struct smb2_pdu {
 #define SMB3_AES_GCM_NONCE 12
 
 struct smb2_transform_hdr {
-	__be32 smb2_buf_length; /* big endian on wire */
-	/*
-	 * length is only two or three bytes - with
-	 * one or two byte type preceding it that MBZ
-	 */
 	__le32 ProtocolId;      /* 0xFD 'S' 'M' 'B' */
 	__u8   Signature[16];
 	__u8   Nonce[16];
-- 
2.25.1

