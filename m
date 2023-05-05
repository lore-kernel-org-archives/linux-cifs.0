Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61812C77B7C
	for <linux-cifs@archiver.kernel.org>; Fri,  5 May 2023 15:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjEEPLk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 11:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjEEPLj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 11:11:39 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E482722
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 08:11:38 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1ab14cb3aaeso13485755ad.2
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 08:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299497; x=1685891497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WV5ybtRR3ORMkRDjTYyyT1UGlYuJ3V24X2JTsvfRzyg=;
        b=WQ3gCyC30+EnHkKc2ZHH/mXop9qnyJnbv1IKEvctINENhDBSLscT+chp+zFxsiGyc2
         UtSQeM96A0msPbV2xuZutJqaobewSm+HJoCTCRa6GApJSYlnMOw7I+PDdkKgzLHVtClK
         Zr2XkifxRln2RF2qvOQo9PZ/CXbzin4qsBb0VPzj5t8hNjeFPRdg3Wm+G3GpAltTXkTI
         MfoSHhndNWaz/xm98i1l7/P/8RNToVG2L+DiVq8/21EMc/LdWOayUhA8GAcrFltOg4c3
         8fsM+bQmULCoZPBLe1yQTaMPFIqv/z/PIx7pxWtWURHnaJyWWc+7ceto1TYBp1q0PVoK
         KX8Q==
X-Gm-Message-State: AC+VfDxf1VBIgJwA1YOuTEhMsUKgtI6+37HI2WVIw9kaZBS1rYkwfsOC
        WDqDGnVjs8TgSHl9K/BZifTQReUeSkI=
X-Google-Smtp-Source: ACHHUZ7XJMHEGm817fvZi59rCnSu3PiypVdUYjyascZ35OVwIDuiXcPlwr90w3/QFcK2of3k/LtdzA==
X-Received: by 2002:a17:902:ab94:b0:1ab:1cf:5a56 with SMTP id f20-20020a170902ab9400b001ab01cf5a56mr1560772plr.22.1683299497045;
        Fri, 05 May 2023 08:11:37 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902d4c400b001a2135e7eabsm1950898plg.16.2023.05.05.08.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 08:11:36 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Gustav Johansson <gustajo@axis.com>
Subject: [PATCH 4/6] ksmbd: smb2: Allow messages padded to 8byte boundary
Date:   Sat,  6 May 2023 00:11:06 +0900
Message-Id: <20230505151108.5911-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230505151108.5911-1-linkinjeon@kernel.org>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Gustav Johansson <gustajo@axis.com>

clc length is now accepted to <= 8 less than length,
rather than < 8.

Solve issues on some of Axis's smb clients which send
messages where clc length is 8 bytes less than length.

The specific client was running kernel 4.19.217 with
smb dialect 3.0.2 on armv7l.

Signed-off-by: Gustav Johansson <gustajo@axis.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2misc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index fbdde426dd01..0ffe663b7590 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -416,8 +416,11 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 
 		/*
 		 * Allow a message that padded to 8byte boundary.
+		 * Linux 4.19.217 with smb 3.0.2 are sometimes
+		 * sending messages where the cls_len is exactly
+		 * 8 bytes less than len.
 		 */
-		if (clc_len < len && (len - clc_len) < 8)
+		if (clc_len < len && (len - clc_len) <= 8)
 			goto validate_credit;
 
 		pr_err_ratelimited(
-- 
2.25.1

