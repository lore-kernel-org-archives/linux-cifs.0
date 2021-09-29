Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89E4C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EA5D6128E
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244830AbhI2IrL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:47:11 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:44898 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244861AbhI2IrJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 04:47:09 -0400
Received: by mail-pf1-f169.google.com with SMTP id 145so1341331pfz.11
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 01:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ccg5f3yXNg3ulOaCkoumtMFbMC82UiqpyFMzy/2Skxw=;
        b=1ILg0djXtxk941YLvGuIdf+CnIJ5XnGz/yvlPB2yZoStj7x7ICMTkrenePI2qlxCp0
         82EKI8oRcSrCKvRnmjG6TYVtK0WiLC/vzQjCSegwoR2OoXH/ElNNZgl3BxKOiCGNBmgK
         VGE9D3Nqb8Ad5Xw4t86akFaqM4fe4V7hdimO5J3OLleRtKQPuhYAfmYZITFoKF8KrsTX
         UMe1fciwrgEWODFtf79bu5Qu2YMcJrbfR+BEP3Sp1pyNaZvhiNMTIa42LXygbgrklgnJ
         e+ycvWIB0P+7fv+UAqDQyqQfwOeCYlOA6TG6XCDdJwvXxYakMss5rkuW4+XHgBmTfomf
         08TQ==
X-Gm-Message-State: AOAM530omBxVmdlx2uyT9DqBKscZ3sho3zRM7qmUQ4ysOKd3AA4GhuYZ
        5zqFuam0QJ+cgVQIVEOf0xgUw3zX/UJfuA==
X-Google-Smtp-Source: ABdhPJxc6Jiczg3Lfdh0mI0kiZBKXlnwTBiyF2QkmILH2ZQMn8esQfhV5Uz91Li5BabuU50vfr/L+Q==
X-Received: by 2002:a63:ce52:: with SMTP id r18mr8383407pgi.350.1632905128852;
        Wed, 29 Sep 2021 01:45:28 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id q3sm1912344pgf.18.2021.09.29.01.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 01:45:28 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v4 6/9] ksmbd: add validation in smb2 negotiate
Date:   Wed, 29 Sep 2021 17:44:58 +0900
Message-Id: <20210929084501.94846-7-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210929084501.94846-1-linkinjeon@kernel.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org>
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
Reviewed-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c    | 42 +++++++++++++++++++++++++++++++++++++++++-
 fs/ksmbd/smb_common.c | 32 +++++++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c434390ffcae..0b0ab3297e05 100644
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
+	if (smb2_neg_size > smb2_buf_len) {
+		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		rc = -EINVAL;
+		goto err_out;
+	}
+
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
index 20bd5b8e3c0a..b6c4c7e960fa 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -168,10 +168,12 @@ static bool supported_protocol(int idx)
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
 
@@ -186,7 +188,9 @@ static int ksmbd_lookup_dialect_by_name(char *cli_dialects, __le16 byte_count)
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
@@ -234,13 +238,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count)
 
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
@@ -250,10 +263,19 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
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

