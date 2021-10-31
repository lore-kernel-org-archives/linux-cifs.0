Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD400C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 31 Oct 2021 01:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9437260EE3
	for <linux-cifs@archiver.kernel.org>; Sun, 31 Oct 2021 01:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhJaBGu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Oct 2021 21:06:50 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:37527 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbhJaBGt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Oct 2021 21:06:49 -0400
Received: by mail-pj1-f48.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so13526624pjl.2
        for <linux-cifs@vger.kernel.org>; Sat, 30 Oct 2021 18:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xDzRyPFL4ZoTW6jptBFFTuaxBqz3qJPobEqojU738WA=;
        b=2MEQNtE2X2x71o9w2Y3Y+JMu9++naZWhOLtd90rwOHmVFu0oRTlfhJNCQdCsrE17Xj
         uXgQ6vI6nmBPodgWp8CkyCDdyXHG6mdLfX2thrUFmxk4V6t3k5NjqXZUeBH7XIk2NBXO
         KSY6t5ewKL6isW66NgFnWpq9MJzy5ha1ZqsVH2h+S8+9LBQeqy1SgSt5yQqX110c5QDz
         cLgfWVqpaCr7s/clqCVRN1WKRvA/X9Ss+4YygaRp8miG4RuoSLh8Hqo9iXaS50dIsv51
         UsZ4JZiiC+MfTKOJMdD43JlnFBpx4pKVaOS/9bIwsh+uBDsNjkyDFTB8uSRAJbqgIkwa
         kgwA==
X-Gm-Message-State: AOAM530aBu8Qb2Y++LtP9WSWLS8BVyTQNM26uWOt2VUjPyuLNhqtn7uS
        T0uo4Rh+x9QurjUQILh+L35aWI4YmHg=
X-Google-Smtp-Source: ABdhPJxVN7yy+RPiGR2bX4/ff3X+DgH8ORPUKOjCx9ZamM+zcvxsS8tvvLdwS89K00OebEJ4lT7SfA==
X-Received: by 2002:a17:902:d4cf:b0:141:d36c:78f6 with SMTP id o15-20020a170902d4cf00b00141d36c78f6mr3090328plg.56.1635642258526;
        Sat, 30 Oct 2021 18:04:18 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g7sm8714843pgp.17.2021.10.30.18.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 18:04:17 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: remove md4 leftovers
Date:   Sun, 31 Oct 2021 10:04:07 +0900
Message-Id: <20211031010407.11078-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211031010407.11078-1-linkinjeon@kernel.org>
References: <20211031010407.11078-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As NTLM authentication is removed, md4 is no longer used.
ksmbd remove md4 leftovers, i.e. select CRYPTO_MD4, MODULE_SOFTDEP md4.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/Kconfig  | 1 -
 fs/ksmbd/server.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/ksmbd/Kconfig b/fs/ksmbd/Kconfig
index 6af339cfdc04..e1fe17747ed6 100644
--- a/fs/ksmbd/Kconfig
+++ b/fs/ksmbd/Kconfig
@@ -6,7 +6,6 @@ config SMB_SERVER
 	select NLS
 	select NLS_UTF8
 	select CRYPTO
-	select CRYPTO_MD4
 	select CRYPTO_MD5
 	select CRYPTO_HMAC
 	select CRYPTO_ECB
diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 36d368e59a64..2e12f6d8483b 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -622,7 +622,6 @@ MODULE_DESCRIPTION("Linux kernel CIFS/SMB SERVER");
 MODULE_LICENSE("GPL");
 MODULE_SOFTDEP("pre: ecb");
 MODULE_SOFTDEP("pre: hmac");
-MODULE_SOFTDEP("pre: md4");
 MODULE_SOFTDEP("pre: md5");
 MODULE_SOFTDEP("pre: nls");
 MODULE_SOFTDEP("pre: aes");
-- 
2.25.1

