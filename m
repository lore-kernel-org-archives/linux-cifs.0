Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FE0C00140
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 12:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiHHM5J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 08:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243046AbiHHM5H (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 08:57:07 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60425DF0B
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 05:57:03 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id p125so4488948pfp.2
        for <linux-cifs@vger.kernel.org>; Mon, 08 Aug 2022 05:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=+1+T8nt9E9GEG5rRYczCiyAgGYXRWkjU1Gf4uutP4iU=;
        b=mefXaboGQzfTqLsmiseArtVZU4TqK6vm4VnSvbzUoNtfyol8ptn0zH89fSaQueJ3oL
         116AVM7lFHzvNWp8lxCEimVNlWXm3eoFlD1es/03EOkXXxy6VioeqRIRGAYv1FIoCUfm
         i2cPLP8ld5prx+HK31tts1fnGgoLf/KoGoblpv/sgNUaY5yRnrWFa7aHl02LZLZizoFV
         TVa4KOuu42l02WbOIO/TtNLVl8hCrAMGueUaTqKiCSBCKkBFCYxHRFbYl0JC2yYjFPXI
         pboetLULMlj7+gRPYl79TFE/yQp3tOMnMLvz0BvHkko2sKxSQQYhe3zSPJ22WJK0Vb8j
         xjeA==
X-Gm-Message-State: ACgBeo1AJRHycnyRAllmYM7HDtuxOCF4Zwo7zOH/pbP/xLjfz+neulIv
        kxaOcmNgJ5oUBHAwWL3/rkzOgQAlUCk=
X-Google-Smtp-Source: AA6agR5A+9j3VP52KyaeC2Qj+ur8jJIuAf8tuJiSwla20ZcYnFPmFqM+5E6xTa04+DsKlzKdWwYWIw==
X-Received: by 2002:a65:4605:0:b0:41c:3d73:9385 with SMTP id v5-20020a654605000000b0041c3d739385mr15073526pgq.168.1659963422144;
        Mon, 08 Aug 2022 05:57:02 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id ep8-20020a17090ae64800b001ef9659d711sm7996773pjb.48.2022.08.08.05.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 05:57:01 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: return STATUS_BAD_NETWORK_NAME error status if share is not configured
Date:   Mon,  8 Aug 2022 21:56:48 +0900
Message-Id: <20220808125648.10919-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If share is not configured in smb.conf, smb2 tree connect should return
STATUS_BAD_NETWORK_NAME instead of STATUS_BAD_NETWORK_PATH.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/mgmt/tree_connect.c | 2 +-
 fs/ksmbd/smb2pdu.c           | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
index b35ea6a6abc5..dd262daa2c4a 100644
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -19,7 +19,7 @@ struct ksmbd_tree_conn_status
 ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 			char *share_name)
 {
-	struct ksmbd_tree_conn_status status = {-EINVAL, NULL};
+	struct ksmbd_tree_conn_status status = {-ENOENT, NULL};
 	struct ksmbd_tree_connect_response *resp = NULL;
 	struct ksmbd_share_config *sc;
 	struct ksmbd_tree_connect *tree_conn = NULL;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 4c3c840df455..d478c3ea4215 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1944,8 +1944,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_SUCCESS;
 		rc = 0;
 		break;
+	case -ENOENT:
 	case KSMBD_TREE_CONN_STATUS_NO_SHARE:
-		rsp->hdr.Status = STATUS_BAD_NETWORK_PATH;
+		rsp->hdr.Status = STATUS_BAD_NETWORK_NAME;
 		break;
 	case -ENOMEM:
 	case KSMBD_TREE_CONN_STATUS_NOMEM:
-- 
2.25.1

