Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280A0C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AD6660EE4
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245011AbhIYNS7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 09:18:59 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:43942 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245184AbhIYNS6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 09:18:58 -0400
Received: by mail-pl1-f180.google.com with SMTP id y1so8420601plk.10
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 06:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5MdRnE9OXiD55XHJSGLi2Ya/hxnzlLQGhrH2k28WEBM=;
        b=O4uDMXz3/vMuxZGdlOECACNig+9URWX3EvwdqMmFACo9xUt7WHAP8Ns6JncGr6P1nB
         4Zy9z7j40lA1NdPJkEeBYxyg6cKL50luTikvnLhHgjKUjihLxJTKDwAEOHtHljcd40B/
         toynkA4iRBJ6YhPqTBrKrFGcShQTOc+S/Y0mCC2gvSZWEPwwMLVcz446rDyJIUk4hakX
         nfT2sp8xwG47e1aiOOOKr5k8twHyEOAojH2+TzW8RuTqAor4APvhBnBnNgeLKZmraeD0
         8gXSp5cp/I4KO1tUhsbwpb9l2mJv5OG4R8YHkr6bL8YbTJUdeg3YL+YMpspnXpYjIi2a
         V/YQ==
X-Gm-Message-State: AOAM530XzT+xK5e8K7ryIz/w0gxbyfFK21Kk0wWwxz2EusktwVCqXFC6
        gpmZab25NELTlg5LSqN9DcnqOXOULhH2ZA==
X-Google-Smtp-Source: ABdhPJxLsMVDhgG3yr711ROlzgky8KVS8I1e9J687eQ1N3u9881wEGgGIKP/a4741XytBW1qyr8Klw==
X-Received: by 2002:a17:90a:1a19:: with SMTP id 25mr8354331pjk.34.1632575843947;
        Sat, 25 Sep 2021 06:17:23 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id x8sm4714698pjf.43.2021.09.25.06.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:17:23 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 7/7] ksmbd: add validation in smb2 negotiate
Date:   Sat, 25 Sep 2021 22:16:25 +0900
Message-Id: <20210925131625.29617-8-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925131625.29617-1-linkinjeon@kernel.org>
References: <20210925131625.29617-1-linkinjeon@kernel.org>
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
 fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 713f861fdaad..9d85b3ca6a9c 100644
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
@@ -8295,7 +8334,8 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)
 
 	WORK_BUFFERS(work, req, rsp);
 
-	if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE)
+	if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE &&
+	    conn->preauth_info)
 		ksmbd_gen_preauth_integrity_hash(conn, (char *)rsp,
 						 conn->preauth_info->Preauth_HashValue);
 
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 36fd9695fbc5..dd54520f1907 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -228,13 +228,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count)
 
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
@@ -244,10 +253,19 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
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

