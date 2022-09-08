Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A85ECAAD5
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Sep 2022 08:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiIHI0x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Sep 2022 04:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiIHI0k (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Sep 2022 04:26:40 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92E2D741F;
        Thu,  8 Sep 2022 01:26:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c24so16010366pgg.11;
        Thu, 08 Sep 2022 01:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=EssDbWO2QmNIdFbB/rXdHnulSsEkrt+/imWjUvwKh/Y=;
        b=HuIk/D5DaeabnS5yXmQfmhqvrYNHo6QAGi/VsBXdIj7NlKyVwCofkYNnxxoMGslzUx
         jJDANUNG1zlmKLg6utoNz4bmROpBuHOdNFIoE+aFZroB0ppc75Jbjf5IGICCijQGvau5
         8/9t1faegoxxEGWhktK272TPAvTaGNJO1+Gkfe42mmIRKesc3GIJKv4p7RetKCnU8z0T
         Bky67U51G+Eap9dSpuRVfL8OY5Qfjn5TWcehX30lD/jgyJsr+cta2h1fq3NIiH77x6sC
         FiDCyYWm0NlOsjmshYwir16MuV+e/qsxDoET5QZ1MgeiMrgdCQlt/xBqQvfmPq3QROM3
         ztlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=EssDbWO2QmNIdFbB/rXdHnulSsEkrt+/imWjUvwKh/Y=;
        b=Wwu6XwpBcZq7UJvyE0Ju3SCysxK8pvK2KsEX5xv7qczgwqwufENkHs3mWLn35vwkye
         a8ietriYT+OEQ5SbipdAV4yI24oosrxZg8/AYXFlekAkr7FammWLncFVk+Na0Nh14El1
         AfCBsImP4aCICxX8YSi/U7qoZMD0suWpmprXRtrlCXHKWXB5Urpj9mghLOoNQ+OKIMoh
         GFXtWd2aqzdaQT/p1G7ZIdY3OJ998OUApL0qBF0X1eGEmgRh33CSkASrJRfIJWygcDxi
         bcHobCfvKP6XOJoUesjsg7pfLZS829q/RwLRCSpOwhduu/v6o9h2WvM4NajTg0xMNatc
         ev/g==
X-Gm-Message-State: ACgBeo3AOOaB/ZxBM65QT71mse9JtbK7CK+qdZ85g9WxnqUTiZEMI5VI
        PMtXG3eQgdCNv8ZhlUMss1wtVLpA/m4=
X-Google-Smtp-Source: AA6agR4fXpi9UrmjJiOPkspRPgIAoy71Z1MmNri3gOlLNxQRaoWPIts1ORrcVXofd6uHjoDyZFfMkQ==
X-Received: by 2002:a63:ff5c:0:b0:434:dc60:73d with SMTP id s28-20020a63ff5c000000b00434dc60073dmr7228429pgk.136.1662625592025;
        Thu, 08 Sep 2022 01:26:32 -0700 (PDT)
Received: from localhost.localdomain ([210.217.8.148])
        by smtp.googlemail.com with ESMTPSA id w15-20020a1709026f0f00b001769cfa5cd4sm7816853plk.49.2022.09.08.01.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 01:26:30 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] MAINTAINERS: remove Hyunchul Lee from ksmbd maintainers
Date:   Thu,  8 Sep 2022 17:26:01 +0900
Message-Id: <20220908082601.23330-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I don't have the necessary time to maintain
the ksmbd code. So remove myself from maintainers
of ksmbd.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f512b430c7cb..e34c961f8b01 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11068,7 +11068,6 @@ F:	tools/testing/selftests/
 KERNEL SMB3 SERVER (KSMBD)
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Steve French <sfrench@samba.org>
-M:	Hyunchul Lee <hyc.lee@gmail.com>
 R:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-cifs@vger.kernel.org
 S:	Maintained
-- 
2.25.1

