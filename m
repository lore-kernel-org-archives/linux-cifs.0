Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD441C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 03:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E7E6103C
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 03:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbhIWDu7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 23:50:59 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:40494 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbhIWDuo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 23:50:44 -0400
Received: by mail-pg1-f169.google.com with SMTP id h3so4964255pgb.7
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 20:49:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vSW4qZXrracnIWsPdfbxmPif1l69DD2iiiT3U7qLgAU=;
        b=H9rEF1YbIHoOUZDUkKeuqtLD4xalaS3RZP4vP3LhxOZOpK2Rkvh2/TKKipsINzs64U
         Gqw/Y9wh2/gF8SJMsyCvHJPe0pWN4QfwoScXihXXQJUk2Eu6EnwJ+QnZp8sg3CU+FU2T
         mDCtiwj9ICW4HSv8oJhCYZWrRq8kPXrXTt8ZGhhMGaXMS7+96qTo8V1bEQB6H5QbQn7+
         Q1EJMG4WX4FLqgz30+Zs6fC+Ow4UQ2d2o+kJjZn+BeTY3lGtviLP6FNzboz8yq3XO19Q
         ZhcEtAfyKKUf2/utBYpzR8/O7DNiYrF8DR5ZvKJujYYgOFkw1bmhgExVMSxnIUzgbUeN
         MCPA==
X-Gm-Message-State: AOAM533CtHjzWrguXjLnRygHEP+R4tQk+20QBx97DQeMI5pwQq//o3zQ
        u0onVE+vIjdKmskPF5u3MhPYzKzPwbvfnw==
X-Google-Smtp-Source: ABdhPJyQJCfVHtV/rOPdBSeXA6+BZXjVDHrgg2/s1XX5hzSjBEO0sTiRuDiQko2jemATQoKSv3wUTg==
X-Received: by 2002:a63:4e45:: with SMTP id o5mr2273518pgl.191.1632368953272;
        Wed, 22 Sep 2021 20:49:13 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id y204sm3045883pfc.100.2021.09.22.20.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 20:49:12 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH] ksmbd: add the check to vaildate if stream protocol length exceeds maximum value
Date:   Thu, 23 Sep 2021 12:48:53 +0900
Message-Id: <20210923034855.612832-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch add MAX_STREAM_PROT_LEN macro and check if stream protocol
length exceeds maximum value in ksmbd_pdu_size_has_room().

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb_common.c | 3 ++-
 fs/ksmbd/smb_common.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 5901b2884c60..ebc835ab414c 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -274,7 +274,8 @@ int ksmbd_init_smb_server(struct ksmbd_work *work)
 
 bool ksmbd_pdu_size_has_room(unsigned int pdu)
 {
-	return (pdu >= KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4);
+	return (pdu >= KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4 &&
+		pdu <= MAX_STREAM_PROT_LEN);
 }
 
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index 994abede27e9..10b8d7224dfa 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -48,6 +48,8 @@
 #define CIFS_DEFAULT_IOSIZE	(64 * 1024)
 #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
 
+#define MAX_STREAM_PROT_LEN	0x00FFFFFF
+
 /* Responses when opening a file. */
 #define F_SUPERSEDED	0
 #define F_OPENED	1
-- 
2.25.1

