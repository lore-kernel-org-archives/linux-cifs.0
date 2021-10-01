Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2502C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 883D161A55
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354185AbhJAM1F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353397AbhJAM1E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:04 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE95C061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=GJ6/GkDvZZxumGF9X6kh0wVdtvWV67L6QDPsqqQ8/3s=; b=pByUBAVkV0xjoDTGozXgAFdbEy
        RLfev4+Ys972YUWif7UjJrae9FmVBsqTjTk45WOHkaSqByvGLbshPovl/2AwxIocJocPg1Unm4XKL
        eDJZ+G67WWBLmbz4LoBFcX4Lu2ndLBol7JnId5v6AojHYf8+TSFq2ARfuahxET9a+8Wx8bMdPRKWC
        g9j5pS6d+yCP27XJwllTIJ9HT66grjYHA2nHBNoIGyLql4saqAS6OhCwOzObTu5wCaN7Ubcg50S4M
        HGXwnqm4UJ5r4HXVt9W91NPEt4cjwzQBG9gAy8hm8S7g3v3xwtP565NHwCep/78KAOBjUa0tgGI6n
        bDluCsVU39oeevF7C0cq7Ydu8tH8EQAltOCgjpKy7wHqcyeptv5t6ujGTnKzYnv0kYu7muSNMrHDV
        dkbbs96ZiaZd+oKGGoi/R0TkMNxkrUf/FFacBBUWfBvNZ6XK17xKtAq8oIXhnx3s0xWSRQhlfU67k
        ebaPgKm8snuAs7N4DUL16047;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIO-0013Z3-55; Fri, 01 Oct 2021 12:05:44 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v5 06/20] ksmbd: add validation in smb2 negotiate
Date:   Fri,  1 Oct 2021 14:04:07 +0200
Message-Id: <20211001120421.327245-7-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

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
2.31.1

