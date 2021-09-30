Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874DCC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 01:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C109611C0
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 01:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345793AbhI3BXq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 21:23:46 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:43565 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhI3BXp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 21:23:45 -0400
Received: by mail-pl1-f177.google.com with SMTP id y1so2801151plk.10
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 18:22:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oA5t6MY4WiLKYTVD0IODNDp9hOLSeEjJWcdHeIp1aC4=;
        b=jKErEzacVlElHabjW7DQY2d20/2TOZu231okRIYb4JZZ22KSR8Mot9MEpe6K16fXFW
         8oqiTyxqssUeMy2K65Ep+2nPX6F2zhGXsxR/2DEKyyyYWm38yu+Bj/d3/G7k8rz3OA0n
         RHcKfdLQN/5FDjn5hIXzMlECnsnjQg7/YJloReGKDNd5xOWY/ENZd0HVvF6KHjamZ55p
         aUyGK3WklKLUhaBLc8tOd3Fgrkr+0KOFjMdCMi0HrhJOWKHuMPPt+Bh64/C2nlyHgG8L
         UzhLw6MAgX7lshTQ4K8PKQKT+wc0642KLC8pwXyyo9BOAZz+RawwOgX1MPs3KbELoBXV
         cy/Q==
X-Gm-Message-State: AOAM532l/AYREuzE4eVObm44b65PjPbbdLLTyP9CDew5u5VN1Vl596nz
        v7f2M9GYNSmVvtrlpOBNFz0wFV0rLfxGRg==
X-Google-Smtp-Source: ABdhPJy4lfQwCDim3qOHchgdNxCFWxtWAuSC2afddLXlnhoukwRepXQwQNof/hwdkf4kGmfKEhHPRg==
X-Received: by 2002:a17:90a:7185:: with SMTP id i5mr3285428pjk.236.1632964923811;
        Wed, 29 Sep 2021 18:22:03 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id i2sm863837pfa.34.2021.09.29.18.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 18:22:03 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, Tom Talpey <tom@talpey.com>
Subject: [PATCH v2] ksmbd: fix transform header validation
Date:   Thu, 30 Sep 2021 10:21:08 +0900
Message-Id: <20210930012108.12396-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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
 v2:
   - reword patch description.

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
2.25.1

