Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C775C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 11:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CB5360F21
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 11:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbhIFLOw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 07:14:52 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:35817 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbhIFLOv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 07:14:51 -0400
Received: by mail-pg1-f171.google.com with SMTP id e7so6477577pgk.2
        for <linux-cifs@vger.kernel.org>; Mon, 06 Sep 2021 04:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M5pAJOTKfpYeO7ZQtWbYAly7BVoEp1ixUMsWRx041sI=;
        b=VIFzcvK6wSl+HgMftHoYWRcCiW5Gsuz+3rMe5wBnUq8t4d6vltVKzjp7dNyopjoWON
         Zc1hWb7ERMW5WWfCFJuL8+tJll5scFqOXWaxa9SwaIsDLlhVo9SuIciFysPVQjH4Gxmu
         osyP43F66z8xgo14n2rW1VGE4ncGCBXSfdimKilDtbI6y+Otxql2WOBRcnVjh3GDki1g
         nqGFyM+9TLPlcnOFRqG8hdnEn8ACg6CmcfnGC/hUtu8xXB8czdU3eBao4cliuHbbHou9
         G+92hwq7wcp3OxTr+P56OXkBx0NkeS3PiPWjAOE8lPAAnyPGtMIv9YY3MUk9Vpaa9OEM
         bpAQ==
X-Gm-Message-State: AOAM532WkRtkBAUo7iqRf6Luq7RZU3GAxyS+DcB17fI7nLiEvacIev5M
        Ekjs9chuyoep5xDmJznfRCRvu6XExKmnZA==
X-Google-Smtp-Source: ABdhPJzGT/Zovi9AwFnaZh+CxY0myV/Th2e2/VIIWoB4gpjvPxY2EJ5Gh4VxFd4YcecCxDnzjZexBA==
X-Received: by 2002:aa7:9e4d:0:b0:3f8:6326:a038 with SMTP id z13-20020aa79e4d000000b003f86326a038mr11264755pfq.73.1630926826934;
        Mon, 06 Sep 2021 04:13:46 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id m26sm7724054pfo.146.2021.09.06.04.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 04:13:46 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH v2 2/2] ksmbd: remove smb2_buf_length in smb2_transform_hdr
Date:   Mon,  6 Sep 2021 20:13:37 +0900
Message-Id: <20210906111337.12716-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210906111337.12716-1-linkinjeon@kernel.org>
References: <20210906111337.12716-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

To move smb2_transform_hdr to cifs_common, This patch remove
smb2_buf_length variable in smb2_transform_hdr.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/auth.c       |  7 +++----
 fs/ksmbd/connection.c |  2 +-
 fs/ksmbd/smb2pdu.c    | 40 +++++++++++++++++++---------------------
 fs/ksmbd/smb2pdu.h    |  5 -----
 4 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 1aa199cee668..035e6aee3466 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -1186,7 +1186,7 @@ static struct scatterlist *ksmbd_init_sg(struct kvec *iov, unsigned int nvec,
 					 u8 *sign)
 {
 	struct scatterlist *sg;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 24;
+	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int i, nr_entries[3] = {0}, total_entries = 0, sg_idx = 0;
 
 	if (!nvec)
@@ -1250,9 +1250,8 @@ static struct scatterlist *ksmbd_init_sg(struct kvec *iov, unsigned int nvec,
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
index af086d35398a..c58eba157a8a 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -170,7 +170,7 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 
 	if (work->tr_buf) {
 		iov[iov_idx] = (struct kvec) { work->tr_buf,
-				sizeof(struct smb2_transform_hdr) };
+				sizeof(struct smb2_transform_hdr) + 4 };
 		len += iov[iov_idx++].iov_len;
 	}
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 9b2875bdd9be..745d3f5eac09 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8235,13 +8235,13 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)
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
@@ -8251,14 +8251,13 @@ static void fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, char *old_buf,
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
@@ -8266,15 +8265,15 @@ int smb3_encrypt_resp(struct ksmbd_work *work)
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
@@ -8294,15 +8293,14 @@ int smb3_encrypt_resp(struct ksmbd_work *work)
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
@@ -8314,9 +8312,9 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	char *buf = work->request_buf;
 	unsigned int pdu_length = get_rfc1002_len(buf);
 	struct kvec iov[2];
-	unsigned int buf_data_size = pdu_length + 4 -
+	unsigned int buf_data_size = pdu_length -
 		sizeof(struct smb2_transform_hdr);
-	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
+	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(buf);
 	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	int rc = 0;
 
@@ -8327,21 +8325,21 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 		return -ECONNABORTED;
 	}
 
-	if (pdu_length + 4 <
+	if (pdu_length <
 	    sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr)) {
 		pr_err("Transform message is too small (%u)\n",
 		       pdu_length);
 		return -ECONNABORTED;
 	}
 
-	if (pdu_length + 4 < orig_len + sizeof(struct smb2_transform_hdr)) {
+	if (pdu_length < orig_len + sizeof(struct smb2_transform_hdr)) {
 		pr_err("Transform message is broken\n");
 		return -ECONNABORTED;
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
index d975e044704f..c13b425c0f62 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -157,11 +157,6 @@ struct smb2_pdu {
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

