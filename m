Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A7FC7EE23
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 18:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjEQS7D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 14:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjEQS7C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 14:59:02 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045BAA5EF
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 11:59:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64354231003so272927b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 11:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684349941; x=1686941941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9eN7Jj1o3pb7RUZ6QHzY3cb0UEZpbcfy+cldBq92Eks=;
        b=ZwjgDOGoc2aExeqR1+W8D7dmSNGQg6hh1zMZBte2vdO6YM3UPrCi8jWGkx5lIols9q
         Fyz2BsVEJmSiF6R5w7nrPbukkfVT4owSv/aYOoRUd2o3wxzvBZwlDopYyMeHdEbESQHJ
         cnIf2RLye6SUrqM+Kl1TetPHbhxuQWfXlRLNKcLtPR6MRtCMyIy2Sod9Z5xgUFeBYrog
         L/aPTW1eP4TIWDb7tqrwB+aGZvF+x8MCcvi5nNh9QRnsGQis4Vd2k57QVQ/Skl3Tbnds
         xj2Lxb0ndK2RRsP5JzaLKqKu1D5yLrj3qL5WEWyFO4XJPzMVh9LFcH+VTnKroRIM/LzD
         6UaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684349941; x=1686941941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9eN7Jj1o3pb7RUZ6QHzY3cb0UEZpbcfy+cldBq92Eks=;
        b=kktZqq97iFitL863ULpTGWvaFYDdpashxLhgpAxUdnYH4XZen17Kaq+JNjB609R1Wl
         ag9T0BS0EkfnAqok14rO73XkH4IovCQZEfGdnhulfv4FfH9fvP9yrCp1Iwu05Zrty8tn
         hlCiN80xJBEJOXo+IhURtzOcXMs30Y4BLb6P/riKA9Vsnpvr7ohlonDjrOXHD8fIIawz
         5ILUEvBK2tB1R2GrvDdrbl9tM+vucyll7GCvVtE/pGyu0tTzpNhcxYDDa2SalYmgAJr8
         //fvv0yWdx6halWMsH/Co15+6H7SvUYFS/lUYyZGpp+KBAufEStATGSqFagzKWqqiGNA
         jgQQ==
X-Gm-Message-State: AC+VfDz2XJJJjg7Jdcfj0oQhajg0YBZNKBgi+voZ4+vnXywzZtRB+UUp
        t3kpm849W46DSj7dvX+5i1w=
X-Google-Smtp-Source: ACHHUZ5BgTxuz0bHfo1D3caZtu+TpWJYi9FG3ukONlWLCvgmz8Vx0lJv7jk13pxpRd2nDyqx6rjFzQ==
X-Received: by 2002:a05:6a00:4c0a:b0:63c:56f5:5053 with SMTP id ea10-20020a056a004c0a00b0063c56f55053mr553852pfb.13.1684349941244;
        Wed, 17 May 2023 11:59:01 -0700 (PDT)
Received: from localhost.localdomain (netlab-9.cs.nctu.edu.tw. [140.113.203.211])
        by smtp.gmail.com with ESMTPSA id x25-20020aa793b9000000b006258dd63a3fsm15413015pff.56.2023.05.17.11.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 11:59:00 -0700 (PDT)
From:   HexRabbit <h3xrabbit@gmail.com>
To:     linkinjeon@kernel.org
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org, Kuan-Ting Chen <h3xrabbit@gmail.com>
Subject: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
Date:   Wed, 17 May 2023 18:58:20 +0000
Message-Id: <20230517185820.1264368-1-h3xrabbit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Kuan-Ting Chen <h3xrabbit@gmail.com>

Ensure the context's length is valid (excluding VLAs) before casting the
pointer to the corresponding structure pointer type, also removed
redundant check on `len_of_ctxts`.

Signed-off-by: Kuan-Ting Chen <h3xrabbit@gmail.com>
---
 fs/ksmbd/smb2pdu.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 972176bff..83b877254 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -969,18 +969,16 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
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
@@ -989,6 +987,9 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 			if (conn->preauth_info->Preauth_HashId)
 				break;
 
+			if (ctxt_len < sizeof(struct smb2_preauth_neg_context))
+				break;
+
 			status = decode_preauth_ctxt(conn,
 						     (struct smb2_preauth_neg_context *)pctx,
 						     len_of_ctxts);
@@ -1000,6 +1001,9 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 			if (conn->cipher_type)
 				break;
 
+			if (ctxt_len < sizeof(struct smb2_encryption_neg_context))
+				break;
+
 			decode_encrypt_ctxt(conn,
 					    (struct smb2_encryption_neg_context *)pctx,
 					    len_of_ctxts);
@@ -1009,6 +1013,9 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 			if (conn->compress_algorithm)
 				break;
 
+			if (ctxt_len < sizeof(struct smb2_compression_capabilities_context))
+				break;
+
 			decode_compress_ctxt(conn,
 					     (struct smb2_compression_capabilities_context *)pctx);
 		} else if (pctx->ContextType == SMB2_NETNAME_NEGOTIATE_CONTEXT_ID) {
@@ -1021,6 +1028,10 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 		} else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_SIGNING_CAPABILITIES context\n");
+
+			if (ctxt_len < sizeof(struct smb2_signing_capabilities))
+				break;
+
 			decode_sign_cap_ctxt(conn,
 					     (struct smb2_signing_capabilities *)pctx,
 					     len_of_ctxts);
-- 
2.25.1

