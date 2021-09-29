Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555DFC4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37ED9613A6
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbhI2IrQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:47:16 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:52762 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244764AbhI2IrP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 04:47:15 -0400
Received: by mail-pj1-f49.google.com with SMTP id v19so1117382pjh.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 01:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s54i1bBIh+ADPW7tuJeMCiqJC4vb5gF1jDIW+Fb6hio=;
        b=HarAvxtc9ncyskQKsYSVzYHijkYKFgL5CGdkR8nXnkaLe4FQHDMQSmLSKioKONg9PH
         k8N5f9ONZAWnAk9oSP0j+sFoWvoDCXCN55C/fGPGD5os9+1TVGvXU88wLLZuCrnO9mbw
         v7K824ucku9ZCxJEf6IvCcxq71VsNB4S1e0xwzXpFW0aLVNFJmyQfvzqRG5XIaZxIoJi
         rw5YYDa5W84jYg6yEmY2LLc4ij9sBH4BoDVfkDOjeBvc8tf6axNzShadPGuqZRg65gf/
         T8DwmFitfPbR27yxnElVPueEJFYxn4cwee5TO3bWq/DlSmUh3ZPaJ0NLH9ZNE2eImfbw
         Gw2g==
X-Gm-Message-State: AOAM533tzSO51KdjogxrUwNNakimu4PrO+gPQtFSXWsStAYAp1lXcc04
        nauBXcMoyDP3X6l0GdrdlVQh++PR4+oYEw==
X-Google-Smtp-Source: ABdhPJx3ewAhcieuvVseTmn7KDerfcYCUqcbAFyZswRmNnnRxLiEoaMeSxFGd4Z6C9KWTZM4EMCymA==
X-Received: by 2002:a17:90b:946:: with SMTP id dw6mr5108024pjb.41.1632905134820;
        Wed, 29 Sep 2021 01:45:34 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id q3sm1912344pgf.18.2021.09.29.01.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 01:45:34 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v4 8/9] ksmbd: remove the leftover of smb2.0 dialect support
Date:   Wed, 29 Sep 2021 17:45:00 +0900
Message-Id: <20210929084501.94846-9-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210929084501.94846-1-linkinjeon@kernel.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Although ksmbd doesn't send SMB2.0 support in supported dialect list of smb
negotiate response, There is the leftover of smb2.0 dialect.
This patch remove it not to support SMB2.0 in ksmbd.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2ops.c    |  5 -----
 fs/ksmbd/smb2pdu.c    | 34 +++++++++-------------------------
 fs/ksmbd/smb2pdu.h    |  1 -
 fs/ksmbd/smb_common.c |  6 +++---
 4 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index 197473871aa4..b06456eb587b 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -187,11 +187,6 @@ static struct smb_version_cmds smb2_0_server_cmds[NUMBER_OF_SMB2_COMMANDS] = {
 	[SMB2_CHANGE_NOTIFY_HE]	=	{ .proc = smb2_notify},
 };
 
-int init_smb2_0_server(struct ksmbd_conn *conn)
-{
-	return -EOPNOTSUPP;
-}
-
 /**
  * init_smb2_1_server() - initialize a smb server connection with smb2.1
  *			command dispatcher
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e40bcc86f3b3..ec05d9dc6436 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -236,9 +236,6 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
 
 	if (conn->need_neg == false)
 		return -EINVAL;
-	if (!(conn->dialect >= SMB20_PROT_ID &&
-	      conn->dialect <= SMB311_PROT_ID))
-		return -EINVAL;
 
 	rsp_hdr = work->response_buf;
 
@@ -1166,13 +1163,6 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	case SMB21_PROT_ID:
 		init_smb2_1_server(conn);
 		break;
-	case SMB20_PROT_ID:
-		rc = init_smb2_0_server(conn);
-		if (rc) {
-			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
-			goto err_out;
-		}
-		break;
 	case SMB2X_PROT_ID:
 	case BAD_PROT_ID:
 	default:
@@ -1191,11 +1181,9 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	rsp->MaxReadSize = cpu_to_le32(conn->vals->max_read_size);
 	rsp->MaxWriteSize = cpu_to_le32(conn->vals->max_write_size);
 
-	if (conn->dialect > SMB20_PROT_ID) {
-		memcpy(conn->ClientGUID, req->ClientGUID,
-		       SMB2_CLIENT_GUID_SIZE);
-		conn->cli_sec_mode = le16_to_cpu(req->SecurityMode);
-	}
+	memcpy(conn->ClientGUID, req->ClientGUID,
+			SMB2_CLIENT_GUID_SIZE);
+	conn->cli_sec_mode = le16_to_cpu(req->SecurityMode);
 
 	rsp->StructureSize = cpu_to_le16(65);
 	rsp->DialectRevision = cpu_to_le16(conn->dialect);
@@ -1537,11 +1525,9 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 		}
 	}
 
-	if (conn->dialect > SMB20_PROT_ID) {
-		if (!ksmbd_conn_lookup_dialect(conn)) {
-			pr_err("fail to verify the dialect\n");
-			return -ENOENT;
-		}
+	if (!ksmbd_conn_lookup_dialect(conn)) {
+		pr_err("fail to verify the dialect\n");
+		return -ENOENT;
 	}
 	return 0;
 }
@@ -1623,11 +1609,9 @@ static int krb5_authenticate(struct ksmbd_work *work)
 		}
 	}
 
-	if (conn->dialect > SMB20_PROT_ID) {
-		if (!ksmbd_conn_lookup_dialect(conn)) {
-			pr_err("fail to verify the dialect\n");
-			return -ENOENT;
-		}
+	if (!ksmbd_conn_lookup_dialect(conn)) {
+		pr_err("fail to verify the dialect\n");
+		return -ENOENT;
 	}
 	return 0;
 }
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index 261825d06391..a6dec5ec6a54 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -1637,7 +1637,6 @@ struct smb2_posix_info {
 } __packed;
 
 /* functions */
-int init_smb2_0_server(struct ksmbd_conn *conn);
 void init_smb2_1_server(struct ksmbd_conn *conn);
 void init_smb3_0_server(struct ksmbd_conn *conn);
 void init_smb3_02_server(struct ksmbd_conn *conn);
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index b6c4c7e960fa..707490ab1f4c 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -88,7 +88,7 @@ unsigned int ksmbd_server_side_copy_max_total_size(void)
 
 inline int ksmbd_min_protocol(void)
 {
-	return SMB2_PROT;
+	return SMB21_PROT;
 }
 
 inline int ksmbd_max_protocol(void)
@@ -427,7 +427,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 
 static int __smb2_negotiate(struct ksmbd_conn *conn)
 {
-	return (conn->dialect >= SMB20_PROT_ID &&
+	return (conn->dialect >= SMB21_PROT_ID &&
 		conn->dialect <= SMB311_PROT_ID);
 }
 
@@ -457,7 +457,7 @@ int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
 		}
 	}
 
-	if (command == SMB2_NEGOTIATE_HE) {
+	if (command == SMB2_NEGOTIATE_HE && __smb2_negotiate(conn)) {
 		ret = smb2_handle_negotiate(work);
 		init_smb2_neg_rsp(work);
 		return ret;
-- 
2.25.1

