Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9130C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 23:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A670E610CA
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 23:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhJ1XPy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Oct 2021 19:15:54 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:38621 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhJ1XPx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Oct 2021 19:15:53 -0400
Received: by mail-pf1-f180.google.com with SMTP id l1so993756pfu.5
        for <linux-cifs@vger.kernel.org>; Thu, 28 Oct 2021 16:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yeHrycLhnBnPb9PJvRTWmcAph5jEMj3KlZ3YoFaYlA0=;
        b=mT+KFmbQLxl+crIiPTKhxYKesFYT/manACgBkwrHDUI4TOhpAqRsTfPvBMABmdyykQ
         nJKzdqJ900j+sm5wpiwLUrgt8pKaz3HaR0JYVnqi+J8JsK6l05eKq6XfElNQ9U35J6xK
         4nIGai7DYaoQ5PCOdPQrvMqjNOseOo/R7j2jZmxxFGzAQCM0Zsecw9wzeGp3d+lmDKa+
         ri3A8jf4xieBlElWFjAWxzn2BcLqWpt9tw/Nk5mJbMkgHnStqSqYDVN4obGD4t+5Ghyt
         APRhZUnS68/T2V9OtKp71QDCmqobQ/qbJEVNnkeDBcVtpdXcTWUh61c7G2f2WkRs0k2R
         xZLg==
X-Gm-Message-State: AOAM533TeJlPNfNIU9f1WQhRKwt4zgkeFPgOj3fJDs6qr8QDaS1cQ8YE
        BEC+xjPQjfaAmQT8tDC6doS4R5QOQtU=
X-Google-Smtp-Source: ABdhPJz+ygXpvww/uRgcZgeiFo2yBaXuzkEL/DCF8K2PmG7XVWpqTz55yVAZQYXmHYIRnbu/nhAPrg==
X-Received: by 2002:a63:e208:: with SMTP id q8mr4121174pgh.291.1635462806055;
        Thu, 28 Oct 2021 16:13:26 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id b10sm4765871pfl.200.2021.10.28.16.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 16:13:25 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: don't need 8byte alignment for request length in ksmbd_check_message
Date:   Fri, 29 Oct 2021 08:13:17 +0900
Message-Id: <20211028231317.18522-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When validating request length in ksmbd_check_message, 8byte alignment
is not needed for compound request. It can cause wrong validation
of request length.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2misc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 2385622cc3c8..0239fa96926c 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -353,12 +353,10 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 	__u32 clc_len;  /* calculated length */
 	__u32 len = get_rfc1002_len(pdu);
 
-	if (le32_to_cpu(hdr->NextCommand) > 0) {
+	if (le32_to_cpu(hdr->NextCommand) > 0)
 		len = le32_to_cpu(hdr->NextCommand);
-	} else if (work->next_smb2_rcv_hdr_off) {
+	else if (work->next_smb2_rcv_hdr_off)
 		len -= work->next_smb2_rcv_hdr_off;
-		len = round_up(len, 8);
-	}
 
 	if (check_smb2_hdr(hdr))
 		return 1;
-- 
2.25.1

