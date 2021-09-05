Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8266C433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Sep 2021 12:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE9B60EE6
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Sep 2021 12:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhIEMU1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Sep 2021 08:20:27 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:36746 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhIEMU1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Sep 2021 08:20:27 -0400
Received: by mail-pg1-f175.google.com with SMTP id t1so3841715pgv.3
        for <linux-cifs@vger.kernel.org>; Sun, 05 Sep 2021 05:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ch+4AhcDPSP7QXjXV28sNvuFQ77RHIZoli0T9PMI0MA=;
        b=QhXcH1KJxYc8FYGbukUE/myu6Pa6WmS+DZwDoqAn38wlP8V8aEbpdZgES6aCc1fh8u
         KnSAFsLPBEF7Spo6O5TmF0irOTgfLiS7bbVQGvThD3BJjsM4ytfDK3SCuqmwqzph+NDq
         EiohgTmm8G7uC3H68reKEfmGieSkAK8xsMwuUplpy9GF8DjLgEvfDwNAUblIFFKucukx
         z/vxmQEvhs4Aa2gPlkdpOc6qkJWlXP0JspBtBJA+b8EbP5ehzKu+7MtuN/epxCLNDtvo
         79b3/geHrDMipNl5rg7ILUb9kWESWhYSYKehyix1CQ6dErs2TJBx1VPzvlXfOSvs6TMz
         4u0g==
X-Gm-Message-State: AOAM530/4bFKSiLqpL26vkfZDstJiV+drdixhX0nVzWArXQfSFNEKHf5
        2bA7reYkZHvb/su1O1OOhKXdJlx8YPLiLg==
X-Google-Smtp-Source: ABdhPJzaLkMvm0/4nFqxLGJ/BQGvjsaGxAi5woofidDGoRP5c4HHCLZmL6wqimR14T3xKliwP1PLqw==
X-Received: by 2002:aa7:8201:0:b0:3fd:7dbd:fbbe with SMTP id k1-20020aa78201000000b003fd7dbdfbbemr7195402pfi.43.1630844364165;
        Sun, 05 Sep 2021 05:19:24 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id n14sm5667767pgd.48.2021.09.05.05.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 05:19:23 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 2/2] ksmbd: remove smb2_buf_length in smb2_transform_hdr
Date:   Sun,  5 Sep 2021 21:18:57 +0900
Message-Id: <20210905121857.7383-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210905121857.7383-1-linkinjeon@kernel.org>
References: <20210905121857.7383-1-linkinjeon@kernel.org>
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
 fs/ksmbd/smb2pdu.c    | 44 ++++++++++++++++++++-----------------------
 fs/ksmbd/smb2pdu.h    |  5 -----
 4 files changed, 24 insertions(+), 34 deletions(-)

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
index ed1105f3a139..745d3f5eac09 100644
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
@@ -8312,12 +8310,11 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess;
 	char *buf = work->request_buf;
-	struct smb2_hdr *hdr;
 	unsigned int pdu_length = get_rfc1002_len(buf);
 	struct kvec iov[2];
-	unsigned int buf_data_size = pdu_length + 4 -
+	unsigned int buf_data_size = pdu_length -
 		sizeof(struct smb2_transform_hdr);
-	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
+	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(buf);
 	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	int rc = 0;
 
@@ -8328,29 +8325,28 @@ int smb3_decrypt_req(struct ksmbd_work *work)
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
 		return rc;
 
 	memmove(buf + 4, iov[1].iov_base, buf_data_size);
-	hdr = (struct smb2_hdr *)buf;
-	hdr->smb2_buf_length = cpu_to_be32(buf_data_size);
+	*(__be32 *)buf = cpu_to_be32(buf_data_size);
 
 	return rc;
 }
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

