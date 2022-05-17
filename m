Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C998FC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 17 May 2022 21:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiEQVq3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 May 2022 17:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiEQVq2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 May 2022 17:46:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6DA12D06
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 14:46:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gg20so129612pjb.1
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 14:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6oXgoy8FMD/jCvY029l1jP4ZI0t4F7mesEct5xA3FuE=;
        b=n7nEXMlWTWZ4Z3N2E47KeSuP09VsyUI6zMU0rDiv22lfhi4wJ+ijWf//w+I2F4qJiK
         0QJwuWWBpify+gQ/CZfhKIBNgiBzSiehMGyWPDWtRjHDb7TFROMHhOKkijUqc63SiCqP
         TzHOzEl0/Xt8RGjxTE6PiGsAW7JB0tt7/Xiyj3gWQBsJlOJ1dIKYstWCG9ZGtsdv+oGD
         9EB+Dh6PO/c52Y0cyt1Wh1pQR0AQ/Fdmc9LOWDGYazfIeI9vDChmKaDvLL8VUGq/pX8a
         QHXhxBEjgfxpxH4C2LK1bHXsdeZGV87tnhlpSvO9GffHfjj0tNnbGnly0BW9VzC+Vdqo
         xaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6oXgoy8FMD/jCvY029l1jP4ZI0t4F7mesEct5xA3FuE=;
        b=dCUSlVsjanpTPTqtJwkxZ+0bB9A7oGBqGxG0/2EoXXMknPJJYRHfI1V2Lw8PLM4Xk+
         /v8gfYxu3XwGyr8ViW628A5r+xnWlveqmC2niaC0+l1cxsC4hKHkj28SvsRh9euFT6Ty
         EAdmtNhJgd9GmUKg4OHz5yutexRchrwAqtk5vb8eQi9QQtuA7Jegtg3GHqAIVp+BBqzB
         2teoTz1qgXP3g58yJCgtwAWcZvS7Ide8Wi6xVh6FJaJ8vYhRYB9PQ9jv2O0UJWXc9XuQ
         iH5V/+xjPpy/6l4N7ojVTl4r6SMtRwjPumtYCGI+69/mEageo9nqrIA6/1q3szJ5euex
         CRuA==
X-Gm-Message-State: AOAM531Xc4Mp1U0Aa6h0mYumlRDc8d/Re17nbjQkyMR2psiph/9O2NPl
        FS4+0jvQQ+K+rBb1gMxq7yrW0/M/mCohmw==
X-Google-Smtp-Source: ABdhPJxz7INAnTS+Q/oPkY1+Rg54mxFoTH82B+DTWk7kcjBI1Emn60+hsRNe9GOzciIghhlOSUMV4w==
X-Received: by 2002:a17:90b:1650:b0:1df:a92d:c614 with SMTP id il16-20020a17090b165000b001dfa92dc614mr1189757pjb.205.1652823986772;
        Tue, 17 May 2022 14:46:26 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id r2-20020a17090a0ac200b001cd498dc153sm2764145pje.3.2022.05.17.14.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 14:46:26 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>
Subject: [PATCH 1/2] ksmbd: fix outstanding credits related bugs
Date:   Wed, 18 May 2022 06:46:07 +0900
Message-Id: <20220517214608.283538-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

outstanding credits must be initialized to 0,
because it means the sum of credits consumed by
in-flight requests.
And outstanding credits must be compared with
total credits in smb2_validate_credit_charge(),
because total credits are the sum of credits
granted by ksmbd.

This patch fix the following error,
while frametest with Windows clients:

Limits exceeding the maximum allowable outstanding requests,
given : 128, pending : 8065

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Reported-by: Yufan Chen <wiz.chen@gmail.com>
Tested-by: Yufan Chen <wiz.chen@gmail.com>
---
 fs/ksmbd/connection.c | 2 +-
 fs/ksmbd/smb2misc.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 7db87771884a..e8f476c5f189 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -62,7 +62,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	conn->total_credits = 1;
-	conn->outstanding_credits = 1;
+	conn->outstanding_credits = 0;
 
 	init_waitqueue_head(&conn->req_running_q);
 	INIT_LIST_HEAD(&conn->conns_list);
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 4a9460153b59..f8f456377a51 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -338,7 +338,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 		ret = 1;
 	}
 
-	if ((u64)conn->outstanding_credits + credit_charge > conn->vals->max_credits) {
+	if ((u64)conn->outstanding_credits + credit_charge > conn->total_credits) {
 		ksmbd_debug(SMB, "Limits exceeding the maximum allowable outstanding requests, given : %u, pending : %u\n",
 			    credit_charge, conn->outstanding_credits);
 		ret = 1;
-- 
2.25.1

