Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7963C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 03:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCB496103C
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 03:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbhIWDvB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 23:51:01 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:45673 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239167AbhIWDuv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 23:50:51 -0400
Received: by mail-pf1-f177.google.com with SMTP id w19so4461678pfn.12
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 20:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k3LF3S9KUuAMs7lh3ps8Cs9i+uGzMIc/N2BaEiakiZ0=;
        b=MctcM3eeBaQ0fQxPbfUp7iMcnGm3ffg4omuOeFc6t3HQO7+9d2GmyT4yx4S06BA67f
         256Kirc61r2Jr0DBl0ntUeIH6tBtig0I+fCMBGJ0aRuYA6MSJs3pnDlQYAGmialY/mjr
         PAguAnqvdEvfoM9sVhWnw5MEhEGeMkcTQhr9C7sIbuUhhGnIb5HmWVoXj72S6798IVai
         es47Mfq4M4a1PIrbvliSK6ITYL8rN5q768GBaqzBExDEelf6uC9YJpeEa4VvkaGcr3WN
         L+OJzEu3KNyNfMPqn7xdq3N5sP89+CUmw6KVVs6nPCtVk+RqfJ9vL843wXccQdvc8qmW
         BQEw==
X-Gm-Message-State: AOAM5322PgMgksq+eZ3ZNqf4Kh6sfD3e1CXDojccNYlsyD74SYrTadp0
        FeZO0S/MkLb/RsVpewFNkKBSo9YlPzFYJA==
X-Google-Smtp-Source: ABdhPJwXsl0zTrvQN/83nAliGRbZiTZsad2yA1bdQ0/LVk5/JLLY/1Q4DLux6VIcB7cuHH2W3c47Pg==
X-Received: by 2002:a63:788d:: with SMTP id t135mr2232561pgc.116.1632368959859;
        Wed, 22 Sep 2021 20:49:19 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id y204sm3045883pfc.100.2021.09.22.20.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 20:49:19 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH v3] ksmbd: add validation in smb2 negotiate
Date:   Thu, 23 Sep 2021 12:48:55 +0900
Message-Id: <20210923034855.612832-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210923034855.612832-1-linkinjeon@kernel.org>
References: <20210923034855.612832-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch add validation to check request buffer check in smb2
negotiate.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v3:
  - fix integer(nego_ctxt_off) overflow issue.
  - change data type of variables to unsigned.

 fs/ksmbd/smb2pdu.c    | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 301558a04298..2f9719a3f089 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1080,6 +1080,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	struct smb2_negotiate_req *req = work->request_buf;
 	struct smb2_negotiate_rsp *rsp = work->response_buf;
 	int rc = 0;
+	unsigned int smb2_buf_len, smb2_neg_size;
 	__le32 status;
 
 	ksmbd_debug(SMB, "Received negotiate request\n");
@@ -1097,6 +1098,45 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	smb2_buf_len = get_rfc1002_len(work->request_buf);
+	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects) - 4;
+	if (conn->dialect == SMB311_PROT_ID) {
+		unsigned int nego_ctxt_off = le32_to_cpu(req->NegotiateContextOffset);
+		unsigned int nego_ctxt_count = le16_to_cpu(req->NegotiateContextCount);
+
+		if (smb2_buf_len < (u64)nego_ctxt_off + nego_ctxt_count) {
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
index ebc835ab414c..02fe2a06dda9 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -235,13 +235,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count)
 
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
@@ -251,10 +260,19 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
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

