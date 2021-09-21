Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1843C433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 12:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CF6860EE7
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 12:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhIUMnW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 08:43:22 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:40677 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbhIUMnU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 08:43:20 -0400
Received: by mail-pg1-f169.google.com with SMTP id h3so20579252pgb.7
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 05:41:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TscF5aL76QOIfd+LuFeUnYJd6cstd4+TrgvEpI/mcHk=;
        b=YT7+POJ5t8xzK+EsASqsHKVOENSq6XBTDbp1caqGQsvN4zMYPUoz0MKqLttvCHgMY+
         TX5bnbHtb8eASx5ZuOz4KAFmM5NL/bYR5cAnMQbOKIQgax3tsdfkTnkieXg1kqxUTSfa
         m6ezKQLbgxVdW739A4P3cW1GNr9IG4yP2Z9IndG1zpERT/3uT/3gefON0pWXyR5Dx+xx
         Q28wsO9vNpUjjC7+O3vklwYWz5g9ERQbkUSU9TQxNLnnPj1VclBvcJ/l1rfO2TN51Sbl
         hCMs/wK3m/TL86luKdPda80j6NZBRYqbjruS+0e20icw7XMo+ZpcUW19bHtTzhutfE/R
         91wg==
X-Gm-Message-State: AOAM5309lxKJhYyumHTK2SXq+/LK5Wvxx7/OjEQpGh0jm7qGZJDAhs4Q
        ZUJnFohKBOfoE2SFgR8SXBJ73itL+BQYGA==
X-Google-Smtp-Source: ABdhPJzVU9TMxyTSYPspjAUuSt9OWb7pHuR146MSXxWwYk3lyaj+qatQ+bGjrou1Z1G1p1g65ktpyA==
X-Received: by 2002:a65:6084:: with SMTP id t4mr28067188pgu.25.1632228111424;
        Tue, 21 Sep 2021 05:41:51 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id a11sm17248354pfo.31.2021.09.21.05.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 05:41:51 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 2/3] ksmbd: add validation in smb2 negotiate
Date:   Tue, 21 Sep 2021 21:41:38 +0900
Message-Id: <20210921124139.18312-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210921124139.18312-1-linkinjeon@kernel.org>
References: <20210921124139.18312-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch add validation to check request buffer check in smb2
negotiate.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c    | 41 ++++++++++++++++++++++++++++++++++++++++-
 fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index baf7ce31d557..1fe37ad4e5bc 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1071,7 +1071,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_negotiate_req *req = work->request_buf;
 	struct smb2_negotiate_rsp *rsp = work->response_buf;
-	int rc = 0;
+	int rc = 0, smb2_buf_len, smb2_neg_size;
 	__le32 status;
 
 	ksmbd_debug(SMB, "Received negotiate request\n");
@@ -1089,6 +1089,45 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	smb2_buf_len = get_rfc1002_len(work->request_buf);
+	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects) - 4;
+	if (conn->dialect == SMB311_PROT_ID) {
+		int nego_ctxt_off = le32_to_cpu(req->NegotiateContextOffset);
+		int nego_ctxt_count = le16_to_cpu(req->NegotiateContextCount);
+
+		if (smb2_buf_len < nego_ctxt_off + nego_ctxt_count) {
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
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 1da67217698d..da17b21ac685 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -229,13 +229,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count)
 
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
@@ -245,10 +254,19 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
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

