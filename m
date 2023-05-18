Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73138C7EE23
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 14:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjEROmi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 May 2023 10:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbjEROmg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 May 2023 10:42:36 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3B1E1
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 07:42:34 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-51b0f9d7d70so1872330a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 07:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684420954; x=1687012954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Xt3wdwBaezZi829BAZyd3dShfMmd/beulpfdNkkWlc=;
        b=iGjflk3WNVoKLy6lsOcBH/zdxXbrgr+Q1kmVxik5PKMBqyh+Hrs1JVozuONg+/y0kz
         iiawXqWMrTQNmLlfYjG3SRl5yFuIljZYQkjGRuuNNmUpOwQGRQl2G58/HL/FKfh319M9
         wNIQYqbXtme/X1mYrDkpuEbWjxV4c7/U26Nk62tvv9IfghsauprqdEhBxrnprdf4fNh5
         VRBf8suInwYlt291KIC/yKCo9FwIhMyY6SW3no5Zhef5uz9DKvAdZ9zCAgPlxGW3pma2
         Hb6DC6iEzudvmZyofCGPMFv5hpg/kfyaZGa+sTMQHR3ccCEumIdpZRAG+hQHkrwi2/wr
         Ih5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684420954; x=1687012954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Xt3wdwBaezZi829BAZyd3dShfMmd/beulpfdNkkWlc=;
        b=ls0W3is54LNzAt0uCL3uH/xUtqxn+byud7ZSnAzWFlbxOszEETKez7IayJcJxj14mN
         2UYEVYXR9xMgOhiWggMAgZP6pgY1s3wXcn24NkBFUd9MHaV9Yb9V4zAfe9o6zKaIhlbP
         B5Bj9RlygJlRpltP1+WTg6oQU001JMqMl8a/i/0Wds/ueWKrkOxAKlIXpDPE9gfkBkty
         YHRGDmWxVdKFHpCZ0SwWHIoxGiUQ50kWxiJwe1Skr6DE1cg6vQbhFmingTCa85upwq1a
         k+x11re49ZzPEhtgldx8o02Oy7yM7Yhj9QscQVREAKbKcfdLk4UvvmidaYxr4n+7//P/
         pLtg==
X-Gm-Message-State: AC+VfDw8NwC+b4XCs4/iA0CkIScXI7wHPa9wPkisymJ+jFXhiY9EMXwc
        Pv75vGnTLamwd4aQmX0PDXk=
X-Google-Smtp-Source: ACHHUZ7o2tsqecRswvt3Y41FMl1tVi2bC5oRsyOOKzmSmq2IhkJGEDiRwFm3+7J53FIZrVpKflL2gA==
X-Received: by 2002:a17:902:c1c4:b0:1a8:1320:133 with SMTP id c4-20020a170902c1c400b001a813200133mr2723834plc.51.1684420953986;
        Thu, 18 May 2023 07:42:33 -0700 (PDT)
Received: from localhost.localdomain (netlab-9.cs.nctu.edu.tw. [140.113.203.211])
        by smtp.gmail.com with ESMTPSA id jd5-20020a170903260500b001a96562642dsm1495706plb.277.2023.05.18.07.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 07:42:33 -0700 (PDT)
From:   HexRabbit <h3xrabbit@gmail.com>
To:     linkinjeon@kernel.org
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org, Kuan-Ting Chen <h3xrabbit@gmail.com>
Subject: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
Date:   Thu, 18 May 2023 14:42:08 +0000
Message-Id: <20230518144208.2099772-1-h3xrabbit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Kuan-Ting Chen <h3xrabbit@gmail.com>

Check the remaining data length before accessing the context structure
to ensure that the entire structure is contained within the packet.
Additionally, since the context data length `ctxt_len` has already been
checked against the total packet length `len_of_ctxts`, update the
comparison to use `ctxt_len`.

Signed-off-by: Kuan-Ting Chen <h3xrabbit@gmail.com>
---
 fs/ksmbd/smb2pdu.c | 52 +++++++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 972176bff..0285c3f9e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -849,13 +849,13 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 
 static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
 				  struct smb2_preauth_neg_context *pneg_ctxt,
-				  int len_of_ctxts)
+				  int ctxt_len)
 {
 	/*
 	 * sizeof(smb2_preauth_neg_context) assumes SMB311_SALT_SIZE Salt,
 	 * which may not be present. Only check for used HashAlgorithms[1].
 	 */
-	if (len_of_ctxts < MIN_PREAUTH_CTXT_DATA_LEN)
+	if (ctxt_len < MIN_PREAUTH_CTXT_DATA_LEN)
 		return STATUS_INVALID_PARAMETER;
 
 	if (pneg_ctxt->HashAlgorithms != SMB2_PREAUTH_INTEGRITY_SHA512)
@@ -867,15 +867,23 @@ static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
 
 static void decode_encrypt_ctxt(struct ksmbd_conn *conn,
 				struct smb2_encryption_neg_context *pneg_ctxt,
-				int len_of_ctxts)
+				int ctxt_len)
 {
-	int cph_cnt = le16_to_cpu(pneg_ctxt->CipherCount);
-	int i, cphs_size = cph_cnt * sizeof(__le16);
+	int cph_cnt;
+	int i, cphs_size;
+
+	if (sizeof(struct smb2_encryption_neg_context) > ctxt_len) {
+		pr_err("Invalid SMB2_ENCRYPTION_CAPABILITIES context size\n");
+		return;
+	}
 
 	conn->cipher_type = 0;
 
+	cph_cnt = le16_to_cpu(pneg_ctxt->CipherCount);
+	cphs_size = cph_cnt * sizeof(__le16);
+
 	if (sizeof(struct smb2_encryption_neg_context) + cphs_size >
-	    len_of_ctxts) {
+	    ctxt_len) {
 		pr_err("Invalid cipher count(%d)\n", cph_cnt);
 		return;
 	}
@@ -923,15 +931,22 @@ static void decode_compress_ctxt(struct ksmbd_conn *conn,
 
 static void decode_sign_cap_ctxt(struct ksmbd_conn *conn,
 				 struct smb2_signing_capabilities *pneg_ctxt,
-				 int len_of_ctxts)
+				 int ctxt_len)
 {
-	int sign_algo_cnt = le16_to_cpu(pneg_ctxt->SigningAlgorithmCount);
-	int i, sign_alos_size = sign_algo_cnt * sizeof(__le16);
+	int sign_algo_cnt;
+	int i, sign_alos_size;
+
+	if (sizeof(struct smb2_signing_capabilities) > ctxt_len) {
+		pr_err("Invalid SMB2_SIGNING_CAPABILITIES context length\n");
+		return;
+	}
 
 	conn->signing_negotiated = false;
+	sign_algo_cnt = le16_to_cpu(pneg_ctxt->SigningAlgorithmCount);
+	sign_alos_size = sign_algo_cnt * sizeof(__le16);
 
 	if (sizeof(struct smb2_signing_capabilities) + sign_alos_size >
-	    len_of_ctxts) {
+	    ctxt_len) {
 		pr_err("Invalid signing algorithm count(%d)\n", sign_algo_cnt);
 		return;
 	}
@@ -969,18 +984,16 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 	len_of_ctxts = len_of_smb - offset;
 
 	while (i++ < neg_ctxt_cnt) {
-		int clen;
-
-		/* check that offset is not beyond end of SMB */
-		if (len_of_ctxts == 0)
-			break;
+		int clen, ctxt_len;
 
 		if (len_of_ctxts < sizeof(struct smb2_neg_context))
 			break;
 
 		pctx = (struct smb2_neg_context *)((char *)pctx + offset);
 		clen = le16_to_cpu(pctx->DataLength);
-		if (clen + sizeof(struct smb2_neg_context) > len_of_ctxts)
+		ctxt_len = clen + sizeof(struct smb2_neg_context);
+
+		if (ctxt_len > len_of_ctxts)
 			break;
 
 		if (pctx->ContextType == SMB2_PREAUTH_INTEGRITY_CAPABILITIES) {
@@ -991,7 +1004,7 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 
 			status = decode_preauth_ctxt(conn,
 						     (struct smb2_preauth_neg_context *)pctx,
-						     len_of_ctxts);
+						     ctxt_len);
 			if (status != STATUS_SUCCESS)
 				break;
 		} else if (pctx->ContextType == SMB2_ENCRYPTION_CAPABILITIES) {
@@ -1002,7 +1015,7 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 
 			decode_encrypt_ctxt(conn,
 					    (struct smb2_encryption_neg_context *)pctx,
-					    len_of_ctxts);
+					    ctxt_len);
 		} else if (pctx->ContextType == SMB2_COMPRESSION_CAPABILITIES) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_COMPRESSION_CAPABILITIES context\n");
@@ -1021,9 +1034,10 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 		} else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_SIGNING_CAPABILITIES context\n");
+
 			decode_sign_cap_ctxt(conn,
 					     (struct smb2_signing_capabilities *)pctx,
-					     len_of_ctxts);
+					     ctxt_len);
 		}
 
 		/* offsets must be 8 byte aligned */
-- 
2.25.1

