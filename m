Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35198C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D11560FC2
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhIZOOL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Sep 2021 10:14:11 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:35458 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhIZOOL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 26 Sep 2021 10:14:11 -0400
Received: by mail-pg1-f182.google.com with SMTP id e7so15221984pgk.2
        for <linux-cifs@vger.kernel.org>; Sun, 26 Sep 2021 07:12:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BTcI0heHQU8Ojlx3N/Tu2VRkE3CKcNibHsGOwViSlxY=;
        b=xesfKFhb+PAtr14v8InXvZ+5WB8fNq1ZxICNKUOwWIxImNHaP9DP7po+LyIcD71I6+
         yiLv9z+SROxNSkPYLEMm47NshnR/kosD2nVKmCd7uT+LCS9r3AvX0HyO7A+9K3O/zlfG
         /Lw25AtrtBzL38K+qwH9j6unh0e6Tw4z9YVNK5OHvp16+40mQKlGRIDqn8oj3dXhfIO3
         8MYOR35QntUhjrgTaTJz4Ydo1LozH7RjeJ1CtBQnSt5Fh/aDIZ2RbS1QYPsV88L1RA/m
         73xKlxEJVIY5NNKVgx9Tuiuzv9tul4Ma4xheBedqLTQbjWmeHugevC7S0v3DeqFHchuZ
         5yWA==
X-Gm-Message-State: AOAM530DS8isWa1BJ/LtYJNpQZoLWuK8zzeqH1pr6b11JhZ/wFjVmPuy
        CQZAKP5fFeiR9tu2t5c4GpXLIyRvP0QMCQ==
X-Google-Smtp-Source: ABdhPJxS4fdp+d9ohv2WJTd7/XMNBCrVzwPfBzRdg/yCeCFGZ+/2HuRDZqmuMbhNxeieJ1DmURl0iw==
X-Received: by 2002:a63:6e41:: with SMTP id j62mr12482078pgc.120.1632665554762;
        Sun, 26 Sep 2021 07:12:34 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g3sm16521742pgf.1.2021.09.26.07.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 07:12:34 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 5/5] ksmbd: add validation in smb2 negotiate
Date:   Sun, 26 Sep 2021 22:55:43 +0900
Message-Id: <20210926135543.119127-6-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210926135543.119127-1-linkinjeon@kernel.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch add validation to check request buffer check in smb2
negotiate and fix null pointer deferencing oops in smb3_preauth_hash_rsp()
that found from manual test.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c    | 42 +++++++++++++++++++++++++++++++++++++++++-
 fs/ksmbd/smb_common.c | 32 +++++++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index dca979d2ef52..6e93ff0f164e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1067,6 +1067,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	struct smb2_negotiate_req *req = work->request_buf;
 	struct smb2_negotiate_rsp *rsp = work->response_buf;
 	int rc = 0;
+	unsigned int smb2_buf_len, smb2_neg_size;
 	__le32 status;
 
 	ksmbd_debug(SMB, "Received negotiate request\n");
@@ -1084,6 +1085,44 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	smb2_buf_len = get_rfc1002_len(work->request_buf);
+	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects) - 4;
+	if (conn->dialect == SMB311_PROT_ID) {
+		unsigned int nego_ctxt_off = le32_to_cpu(req->NegotiateContextOffset);
+
+		if (smb2_buf_len < nego_ctxt_off) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+
+		if (smb2_neg_size > nego_ctxt_off) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+
+		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
+		    nego_ctxt_off) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+	} else {
+		if (smb2_neg_size > smb2_buf_len) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+
+		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
+		    smb2_buf_len) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+	}
+
 	conn->cli_cap = le32_to_cpu(req->Capabilities);
 	switch (conn->dialect) {
 	case SMB311_PROT_ID:
@@ -8301,7 +8340,8 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
-	if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE)
+	if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE &&
+	    conn->preauth_info)
 		ksmbd_gen_preauth_integrity_hash(conn, (char *)rsp,
 						 conn->preauth_info->Preauth_HashValue);
 
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 36fd9695fbc5..5d8e32041c15 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -162,10 +162,12 @@ static bool supported_protocol(int idx)
 		idx <= server_conf.max_protocol);
 }
 
-static char *next_dialect(char *dialect, int *next_off)
+static char *next_dialect(char *dialect, int *next_off, int bcount)
 {
 	dialect = dialect + *next_off;
-	*next_off = strlen(dialect);
+	*next_off = strnlen(dialect, bcount);
+	if (dialect[*next_off] != '\0')
+		return NULL;
 	return dialect;
 }
 
@@ -180,7 +182,9 @@ static int ksmbd_lookup_dialect_by_name(char *cli_dialects, __le16 byte_count)
 		dialect = cli_dialects;
 		bcount = le16_to_cpu(byte_count);
 		do {
-			dialect = next_dialect(dialect, &next);
+			dialect = next_dialect(dialect, &next, bcount);
+			if (!dialect)
+				break;
 			ksmbd_debug(SMB, "client requested dialect %s\n",
 				    dialect);
 			if (!strcmp(dialect, smb1_protos[i].name)) {
@@ -228,13 +232,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count)
 
 static int ksmbd_negotiate_smb_dialect(void *buf)
 {
-	__le32 proto;
+	int smb_buf_length = get_rfc1002_len(buf);
+	__le32 proto = ((struct smb2_hdr *)buf)->ProtocolId;
 
-	proto = ((struct smb2_hdr *)buf)->ProtocolId;
 	if (proto == SMB2_PROTO_NUMBER) {
 		struct smb2_negotiate_req *req;
+		int smb2_neg_size =
+			offsetof(struct smb2_negotiate_req, Dialects) - 4;
 
 		req = (struct smb2_negotiate_req *)buf;
+		if (smb2_neg_size > smb_buf_length)
+			goto err_out;
+
+		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
+		    smb_buf_length)
+			goto err_out;
+
 		return ksmbd_lookup_dialect_by_id(req->Dialects,
 						  req->DialectCount);
 	}
@@ -244,10 +257,19 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
 		struct smb_negotiate_req *req;
 
 		req = (struct smb_negotiate_req *)buf;
+		if (le16_to_cpu(req->ByteCount) < 2)
+			goto err_out;
+
+		if (offsetof(struct smb_negotiate_req, DialectsArray) - 4 +
+			le16_to_cpu(req->ByteCount) > smb_buf_length) {
+			goto err_out;
+		}
+
 		return ksmbd_lookup_dialect_by_name(req->DialectsArray,
 						    req->ByteCount);
 	}
 
+err_out:
 	return BAD_PROT_ID;
 }
 
-- 
2.25.1

