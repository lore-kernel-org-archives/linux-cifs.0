Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B21C433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 04:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60B9661222
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 04:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhJCEdH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Oct 2021 00:33:07 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:38553 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhJCEdG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Oct 2021 00:33:06 -0400
Received: by mail-pg1-f175.google.com with SMTP id s75so2477047pgs.5
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 21:31:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oiGPYO//uQR+2WZggUlZIn+39GD8bQ9leIyENDjGmwQ=;
        b=bCJ7NFOty+X+3CfxwjRGUSrNa+t2EZC6UrkqabZ6xGf/K2C3ECD8LwWwM89brav6ox
         tAIXNsf4HHh8H8AqVqY4rCeqXuV26+LPYdZUSlFCz4iL6SFuSxAQugUz7s0GTyW5NLC6
         YJ4yXsm+EiEf1LRelv+zA5RaUmoCddg2V2nvLw5GkX7p2DAnscr2/X4fq9mFuu/5embg
         TJhu6WjkFPhfSvoxO1FHjbgyxFEXUg+G0aV/GfgSPQxHjHe/BpXLBYaOho6ZMOSEBNjD
         y5rwFjL0AOXWuIdABaUVE/JOWlUN0vQQmziRJaYImLPpfMXUHEwnETV6HdfwNnsdhVw1
         C6dw==
X-Gm-Message-State: AOAM531iLBxESl+um/MCDVp9RB3d2JALc65U2mXJCPB9zsCrfM7ditSu
        yKjCX6c+TQyjJTr1xYFZ97uuDlsnZwWypA==
X-Google-Smtp-Source: ABdhPJxzLkJvzEQ5lWnTunt35tpgIqKEgeJwWhFDGdPTdWWwL3b1uBZLuAFTMx5WX8SWVTinUmmYCg==
X-Received: by 2002:aa7:96ab:0:b0:43d:f9e0:10bf with SMTP id g11-20020aa796ab000000b0043df9e010bfmr18203002pfk.32.1633235479885;
        Sat, 02 Oct 2021 21:31:19 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id w136sm3845782pfc.50.2021.10.02.21.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 21:31:19 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH 2/3] ksmbd: fix version mismatch with out of tree
Date:   Sun,  3 Oct 2021 13:31:04 +0900
Message-Id: <20211003043105.10453-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003043105.10453-1-linkinjeon@kernel.org>
References: <20211003043105.10453-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix version mismatch with out of tree, This updated version will be
matched with ksmbd-tools.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/glob.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/glob.h b/fs/ksmbd/glob.h
index 49a5a3afa118..5b8f3e0ebdb3 100644
--- a/fs/ksmbd/glob.h
+++ b/fs/ksmbd/glob.h
@@ -12,7 +12,7 @@
 #include "unicode.h"
 #include "vfs_cache.h"
 
-#define KSMBD_VERSION	"3.1.9"
+#define KSMBD_VERSION	"3.4.2"
 
 extern int ksmbd_debug_types;
 
-- 
2.25.1

