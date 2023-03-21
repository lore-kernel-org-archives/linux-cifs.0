Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D1BC74A5B
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Mar 2023 13:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCUNdv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCUNdu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Mar 2023 09:33:50 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8302B2A8
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 06:33:48 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id j13so15561427pjd.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 06:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679405628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=af+v0o5Wr9l+KC9oniC11k4pSakhKmG8BzALyKs1vnw=;
        b=2/z5H61In05Sp9hOUaZK1iw71/ZJM3GEnz9DtS45qNsmBCeGpsI4SVlCLwYWN/870a
         8KIRlXTRatZCsyOk759zFCK05K5Cronmdyp74HzVvUQL79o2Z3qe9mLEsymvZ/SNhP5R
         V3lwmvARVwEaZ74nR+i9+iaZCO3FYhTCTtQ3xxft2cOYuy1Rgo3siuwmsmQz4r5Os7UK
         sYPNX2sFaDRvc+g004rampbhWtQaDoVLZdsptDiwwA+1W91vlBsmpQPiFWSMqlZK82ZV
         CjAxY+EnLvDmg9TLQO0YtzezQrXsIULkj9J3tcn4pjQ3g5qpjTnDBCnzXlBkqXT59leO
         9rPw==
X-Gm-Message-State: AO0yUKU8WHWcVxwB7fnXt6QGqJiiYFcMQkYVjjKwt94J9nZfGrUH5uL2
        J7mL9DY6APQUNEJ6kLZke8BM4m0NcmE=
X-Google-Smtp-Source: AK7set9taxrtOKP22X14WYu100uxISjVUMtz3TV/yqCsULqCReH6PNqi1NcJZ1ySsS8jToRNhbQZfQ==
X-Received: by 2002:a17:903:32ca:b0:19e:6c02:801c with SMTP id i10-20020a17090332ca00b0019e6c02801cmr2876340plr.14.1679405628120;
        Tue, 21 Mar 2023 06:33:48 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902b70400b001a1c2eb3950sm5487224pls.22.2023.03.21.06.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 06:33:47 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH] ksmbd: return unsupported error on smb1 mount
Date:   Tue, 21 Mar 2023 22:33:12 +0900
Message-Id: <20230321133312.103789-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230321133312.103789-1-linkinjeon@kernel.org>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd disconnect connection when mounting with vers=smb1.
ksmbd should send smb1 negotiate response to client for correct
unsupported error return. This patch add needed SMB1 macros and fill
NegProt part of the response for smb1 negotiate response.

Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/connection.c |  7 ++-----
 fs/ksmbd/smb_common.c | 23 ++++++++++++++++++++---
 fs/ksmbd/smb_common.h | 30 ++++++++----------------------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 5d914715605f..115a67d2cf78 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -319,13 +319,10 @@ int ksmbd_conn_handler_loop(void *p)
 		}
 
 		/*
-		 * Check if pdu size is valid (min : smb header size,
-		 * max : 0x00FFFFFF).
+		 * Check maximum pdu size(0x00FFFFFF).
 		 */
-		if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
-		    pdu_size > MAX_STREAM_PROT_LEN) {
+		if (pdu_size > MAX_STREAM_PROT_LEN)
 			break;
-		}
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 079c9e76818d..87fa578b141e 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -442,9 +442,26 @@ static int smb_handle_negotiate(struct ksmbd_work *work)
 {
 	struct smb_negotiate_rsp *neg_rsp = work->response_buf;
 
-	ksmbd_debug(SMB, "Unsupported SMB protocol\n");
-	neg_rsp->hdr.Status.CifsError = STATUS_INVALID_LOGON_TYPE;
-	return -EINVAL;
+	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
+
+	/*
+	 * Remove 4 byte direct TCP header, add 1 byte wc, 2 byte bcc
+	 * and 2 byte DialectIndex.
+	 */
+	*(__be32 *)work->response_buf =
+		cpu_to_be32(sizeof(struct smb_hdr) - 4 + 2 + 2);
+	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;
+
+	neg_rsp->hdr.Command = SMB_COM_NEGOTIATE;
+	*(__le32 *)neg_rsp->hdr.Protocol = SMB1_PROTO_NUMBER;
+	neg_rsp->hdr.Flags = SMBFLG_RESPONSE;
+	neg_rsp->hdr.Flags2 = SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS |
+		SMBFLG2_EXT_SEC | SMBFLG2_IS_LONG_NAME;
+
+	neg_rsp->hdr.WordCount = 1;
+	neg_rsp->DialectIndex = cpu_to_le16(work->conn->dialect);
+	neg_rsp->ByteCount = 0;
+	return 0;
 }
 
 int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index e663ab9ea759..d30ce4c1a151 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -158,8 +158,15 @@
 
 #define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
 #define SMB_COM_NEGOTIATE		0x72
-
 #define SMB1_CLIENT_GUID_SIZE		(16)
+
+#define SMBFLG_RESPONSE 0x80	/* this PDU is a response from server */
+
+#define SMBFLG2_IS_LONG_NAME	cpu_to_le16(0x40)
+#define SMBFLG2_EXT_SEC		cpu_to_le16(0x800)
+#define SMBFLG2_ERR_STATUS	cpu_to_le16(0x4000)
+#define SMBFLG2_UNICODE		cpu_to_le16(0x8000)
+
 struct smb_hdr {
 	__be32 smb_buf_length;
 	__u8 Protocol[4];
@@ -199,28 +206,7 @@ struct smb_negotiate_req {
 struct smb_negotiate_rsp {
 	struct smb_hdr hdr;     /* wct = 17 */
 	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
-	__u8 SecurityMode;
-	__le16 MaxMpxCount;
-	__le16 MaxNumberVcs;
-	__le32 MaxBufferSize;
-	__le32 MaxRawSize;
-	__le32 SessionKey;
-	__le32 Capabilities;    /* see below */
-	__le32 SystemTimeLow;
-	__le32 SystemTimeHigh;
-	__le16 ServerTimeZone;
-	__u8 EncryptionKeyLength;
 	__le16 ByteCount;
-	union {
-		unsigned char EncryptionKey[8]; /* cap extended security off */
-		/* followed by Domain name - if extended security is off */
-		/* followed by 16 bytes of server GUID */
-		/* then security blob if cap_extended_security negotiated */
-		struct {
-			unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
-			unsigned char SecurityBlob[1];
-		} __packed extended_response;
-	} __packed u;
 } __packed;
 
 struct filesystem_attribute_info {
-- 
2.25.1

