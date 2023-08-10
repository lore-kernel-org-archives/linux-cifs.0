Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC4DC04A6A
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Aug 2023 20:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbjHJUBt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Aug 2023 16:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbjHJUBt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Aug 2023 16:01:49 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEE9273E
        for <linux-cifs@vger.kernel.org>; Thu, 10 Aug 2023 13:01:47 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4fe44955decso1499618e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 10 Aug 2023 13:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691697706; x=1692302506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YhA2qkH5nFi2oE8RDaiEgYN6l1LxvJg5gDrjf45L5tI=;
        b=kzyQBMXs8yqpwUtPHFAxw3vsRSNVP/C18ddd8VO2WbDxY4FqMd+pY0NcU7dQu/ITH3
         sWWRq2LJW9sqiyPbL8OvIa2/QzLZOa8+oq3T2A1XAYGgTSL3oBf46qxzctJzsUEfD8Bv
         iE70JEHXNBOgxqB6sFRxHH03ZkezWTe/gMZvgA4UOTpHSFxhIxcREh2t7jdqOv2Sln1s
         juNjCzhfugLECMl4H0SAjTGi5HYcw6vuDxdOpC9Wws8OWQ2m2CfTWIcxZZFY+R0F9Gtg
         daWg8dGXx0sjk3x9WNFE51wWceHI/cUgxkwQaSLjmjbpg3TyqNO0nPr980d/PUGStxRA
         mSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691697706; x=1692302506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YhA2qkH5nFi2oE8RDaiEgYN6l1LxvJg5gDrjf45L5tI=;
        b=SyVzKHZa2pC6J5g34jNmTNYbVe33M4g2+Pu5JhhnDbNl8Pd/kATf127X5Uw3PeJdG8
         bXSGJEpDXhWtcUKs6NMVnXXmjAnjywYhM0KarFb6CaOb/dwq17wduscf2hOuRVwlJhFg
         Y/2adDM7Oq9dXextD9UEzVb/QDJie7EpUZUw91XzTvJKsy+Uj60YwJ4r140GzwHrXdEc
         uLWsNkOAmEirYCVmkNWivOTHHIiNCBoGES49ovKbsf8VtaTclK/n4FB8eqPjPfOBww5V
         HEDO9K/wAEa9BAl2ckyKGvLFGq1eKBlWECtE2HJMXbZh7gDnwPXYwmWQ4ajaiN4uAq5R
         3Kfg==
X-Gm-Message-State: AOJu0Yy9/gQQteGqwgkvcQkAyXLSQ6RbQgu9rukEUDwwuOgeHbiwXIqJ
        tDC0bUovQxzynzM+wmoe/fzJwnKdEvg=
X-Google-Smtp-Source: AGHT+IHtLqnaZuWth28lbwTSOvTdkcI3bivsPfPV/TWpBBYkZodoInspUqnd1VOiUk1V33/XWaLLQA==
X-Received: by 2002:a05:6512:214b:b0:4fe:5741:9eb6 with SMTP id s11-20020a056512214b00b004fe57419eb6mr1135419lfr.26.1691697705496;
        Thu, 10 Aug 2023 13:01:45 -0700 (PDT)
Received: from pohjola.. (mobile-user-c1d2eb-200.dhcp.inet.fi. [193.210.235.200])
        by smtp.gmail.com with ESMTPSA id x14-20020ac2488e000000b004fe3a2e3952sm412909lfc.100.2023.08.10.13.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 13:01:44 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Subject: [PATCH] ksmbd: fix `force create mode' and `force directory mode'
Date:   Thu, 10 Aug 2023 23:01:32 +0300
Message-ID: <20230810200132.9733-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

`force create mode' and `force directory mode' should be bitwise ORed
with the perms after `create mask' and `directory mask' have been
applied, respectively.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 fs/smb/server/mgmt/share_config.h | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/mgmt/share_config.h b/fs/smb/server/mgmt/share_config.h
index 3fd338293942..5f591751b923 100644
--- a/fs/smb/server/mgmt/share_config.h
+++ b/fs/smb/server/mgmt/share_config.h
@@ -34,29 +34,22 @@ struct ksmbd_share_config {
 #define KSMBD_SHARE_INVALID_UID	((__u16)-1)
 #define KSMBD_SHARE_INVALID_GID	((__u16)-1)
 
-static inline int share_config_create_mode(struct ksmbd_share_config *share,
-					   umode_t posix_mode)
+static inline umode_t
+share_config_create_mode(struct ksmbd_share_config *share,
+			 umode_t posix_mode)
 {
-	if (!share->force_create_mode) {
-		if (!posix_mode)
-			return share->create_mask;
-		else
-			return posix_mode & share->create_mask;
-	}
-	return share->force_create_mode & share->create_mask;
+	umode_t mode = (posix_mode ?: (umode_t)-1) & share->create_mask;
+
+	return mode | share->force_create_mode;
 }
 
-static inline int share_config_directory_mode(struct ksmbd_share_config *share,
-					      umode_t posix_mode)
+static inline umode_t
+share_config_directory_mode(struct ksmbd_share_config *share,
+			    umode_t posix_mode)
 {
-	if (!share->force_directory_mode) {
-		if (!posix_mode)
-			return share->directory_mask;
-		else
-			return posix_mode & share->directory_mask;
-	}
+	umode_t mode = (posix_mode ?: (umode_t)-1) & share->directory_mask;
 
-	return share->force_directory_mode & share->directory_mask;
+	return mode | share->force_directory_mode;
 }
 
 static inline int test_share_config_flag(struct ksmbd_share_config *share,
-- 
2.41.0

