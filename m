Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5265BC77B73
	for <linux-cifs@archiver.kernel.org>; Wed, 24 May 2023 15:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbjEXPQm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 May 2023 11:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjEXPQl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 May 2023 11:16:41 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7125DA9
        for <linux-cifs@vger.kernel.org>; Wed, 24 May 2023 08:16:40 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1ae51b07338so3068925ad.0
        for <linux-cifs@vger.kernel.org>; Wed, 24 May 2023 08:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684941400; x=1687533400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qCCiokG9KKNnbY1lO++nu+kKmFcA4dj2qr7nCXk9o78=;
        b=OpzQptpLvKLcmhkh1SvhZCbhY7KnTCw9e043URmvlSCinASlSqrs7vQV+OoV7p+XSb
         0+EJ+j/315UFjZ4YiCFbJwuesVVk793WDuXPxsdaszqLdZsYsw0+LNdO5Kix4RpS/2By
         0VlF6wvWFdRhmHkE8PFQrrgAnnvbRqVCEinpCIpNOCtwWHcmJSuOGuqs8rpwpxBLW95T
         iwz0nUbALlprUwdtDA1bV60u9qT1w9UZEuvYySGnHTMVIp/9lqmedP8YpZ2pP4v9JRxS
         jBWhg/aQO/bZ+Y6sGrt3qrEyGR+kLRP1Z6VHvJTKpADejHAS1WbZRCEhBrgiOlbCqYG/
         7EMg==
X-Gm-Message-State: AC+VfDzvDWc5MH+lbo4+TaPxeh4wljBepaz/GxHuCfadMNUfJgFCw5jt
        O7gHJwggjzLEbDN6j1tPd321W+hG2hM=
X-Google-Smtp-Source: ACHHUZ6WqAp+vCg+dPLgK4BrkSP3iN60xvyiQKk1/FbtBP8Q/LICTLlDL/7Xf3etD36Hm0ZUv0qmpg==
X-Received: by 2002:a17:902:edc2:b0:1aa:fd48:f5e2 with SMTP id q2-20020a170902edc200b001aafd48f5e2mr14332950plk.32.1684941399595;
        Wed, 24 May 2023 08:16:39 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902dac700b001a6d4ffc760sm8891011plx.244.2023.05.24.08.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 08:16:39 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: call putname after using the last component
Date:   Thu, 25 May 2023 00:16:32 +0900
Message-Id: <20230524151632.8135-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

last component point filename struct. Currently putname is called after
vfs_path_parent_lookup(). And then last component is used for
lookup_one_qstr_excl(). name in last component is freed by previous
calling putname(). And It cause file lookup failure when testing
generic/464 test of xfstest.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/vfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 9bdb01c5b201..6f302919e9f7 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -86,12 +86,14 @@ static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config *share_conf,
 	err = vfs_path_parent_lookup(filename, flags,
 				     &parent_path, &last, &type,
 				     root_share_path);
-	putname(filename);
-	if (err)
+	if (err) {
+		putname(filename);
 		return err;
+	}
 
 	if (unlikely(type != LAST_NORM)) {
 		path_put(&parent_path);
+		putname(filename);
 		return -ENOENT;
 	}
 
@@ -108,12 +110,14 @@ static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config *share_conf,
 	path->dentry = d;
 	path->mnt = share_conf->vfs_path.mnt;
 	path_put(&parent_path);
+	putname(filename);
 
 	return 0;
 
 err_out:
 	inode_unlock(parent_path.dentry->d_inode);
 	path_put(&parent_path);
+	putname(filename);
 	return -ENOENT;
 }
 
-- 
2.25.1

