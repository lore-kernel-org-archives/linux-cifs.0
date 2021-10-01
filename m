Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D2FC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B17861A85
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353431AbhJAM13 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhJAM12 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:28 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9195DC061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=WpkZ1NfFD6FTS92J7O5drCFrrBVUGBRTq1+XIBakZpQ=; b=XBcFwqxjdrO+fxyMcK+im9mTr2
        xQDGo78HbkOl7kfJOaiZhBV3MrlIVFsG1UCT+YaBixVFqs6CwLmC7YaDseX9m+ieIAiLDa2BPyOKI
        6szuWF96q/u5SxCIRIzYVzgPtUIO1EAhLLFyLx7tKKEckO2NsECoM3mS88WdD2w0SwUB2lA+AUxpP
        p0OlHl9Lwp59jrdMW3v9oU6hmKnP5jL33KbPpiHm+C9Tq9SnTALwDfd5+fEkFAldsIiYiawTriPFX
        jLZB4LO1Yg3+YCtFwIjO1cmExdmBdEpRHJkg1vsXbRNeKFiDUgEVMOv9FSzitdLQEr6WkMq2CDs7N
        ehYgcAuLIYNGrbQB6X8uRGQm8nUw1Nw5EAtfKvR5FaRTBOdvT3jdnhBrMycgj4yNZdD6xlPhnylCH
        MV9bGMt+eBCsWAwujA9wjO7f3W6HMclu5SOW/tcMlNWMe/eBw46pJstD60nS/zmCOzI/YVHi+VDfY
        BbXntEwEnLZCAH9i72e8+onW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIQ-0013Z3-KI; Fri, 01 Oct 2021 12:05:46 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, Tom Talpey <tom@talpey.com>
Subject: [PATCH v5 10/20] ksmbd: fix transform header validation
Date:   Fri,  1 Oct 2021 14:04:11 +0200
Message-Id: <20211001120421.327245-11-slow@samba.org>
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

Validate that the transform and smb request headers are present
before checking OriginalMessageSize and SessionId fields.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Reviewed-By: Tom Talpey <tom@talpey.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ec05d9dc6436..b06361313889 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8455,16 +8455,8 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	unsigned int buf_data_size = pdu_length + 4 -
 		sizeof(struct smb2_transform_hdr);
 	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
-	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	int rc = 0;
 
-	sess = ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId));
-	if (!sess) {
-		pr_err("invalid session id(%llx) in transform header\n",
-		       le64_to_cpu(tr_hdr->SessionId));
-		return -ECONNABORTED;
-	}
-
 	if (pdu_length + 4 <
 	    sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr)) {
 		pr_err("Transform message is too small (%u)\n",
@@ -8472,11 +8464,19 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 		return -ECONNABORTED;
 	}
 
-	if (pdu_length + 4 < orig_len + sizeof(struct smb2_transform_hdr)) {
+	if (pdu_length + 4 <
+	    le32_to_cpu(tr_hdr->OriginalMessageSize) + sizeof(struct smb2_transform_hdr)) {
 		pr_err("Transform message is broken\n");
 		return -ECONNABORTED;
 	}
 
+	sess = ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId));
+	if (!sess) {
+		pr_err("invalid session id(%llx) in transform header\n",
+		       le64_to_cpu(tr_hdr->SessionId));
+		return -ECONNABORTED;
+	}
+
 	iov[0].iov_base = buf;
 	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
 	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
-- 
2.31.1

