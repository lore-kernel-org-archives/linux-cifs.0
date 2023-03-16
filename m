Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E687DC74A5B
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Mar 2023 13:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjCPNky (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Mar 2023 09:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCPNkw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Mar 2023 09:40:52 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301FDBAD08
        for <linux-cifs@vger.kernel.org>; Thu, 16 Mar 2023 06:40:50 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id ay8so1293606wmb.1
        for <linux-cifs@vger.kernel.org>; Thu, 16 Mar 2023 06:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112; t=1678974049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GcGENDEJd5wvM3QphTd68cXz45S413z3jii2ne/89rA=;
        b=8XbuFY0lDPyFRX6ObSVeHcX0YBNxf3nmDa6mRkTsZ0usdkNmAmkfI3Ucc8JAisBV0j
         bPidO1GNJREngcaETXmwVq/jyKpR6VY+QlFKsoMaUC5wgnnkhZ8Ox7GmeK7KKWvHbEnW
         aXZUskcKly/7T16OKagaKtgF+Big0H07Uc8t9hWTXqcjoI5R1EwT4o+4+DpPMDdZRvpU
         U/NZWTvud2GpjVtrLqPKPiBOzG7qClXMeq8wvB6VNj66IK+OeFs4pN+3OerixZBMr7BG
         ejknnUbUeadlhgdWX46WMIP8Kq0jjS8dmwEuIgMd4WJbb1EEuQOGs96lvo+3vIhRj8Ap
         fauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678974049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GcGENDEJd5wvM3QphTd68cXz45S413z3jii2ne/89rA=;
        b=vXWzVxJ07W+ikzWhC+NyLNFL3J9GoIAew0dWBYr9h1g790t8L7l+E3PlSVFtyOf2Va
         vIXlh5XkvmcHDLoZ6GdHaKJ2f5cV8O5dxJXmWPJQXpbJZHCS3OgJ1N3SbNfjc7VQieOw
         SO+Tt6GYYZwgjZxEbMQ9LI12qb+KNy1m5JLcsEoDWpqPO0MDLazV2styWNDmDWkaOFNu
         wVURFHJhmqiVEFgjjty4pzHShnGLs2DkGEzmppf3rZJp/ZaMUDjLa3/X/XvpYefb0s37
         UAw3OmRFvA+2cGbNCmWamaj8EQi4fZOM0Ag0hTXN/LKOCnoZxOM7Ht7srERUaSEKsrtl
         RhGQ==
X-Gm-Message-State: AO0yUKVD+KBjHXsJNr5VBsxz2ceXyMKJ/pVeuiSfLTJGNX5v9PvPaP/N
        MYL5fVoEWmP0o1SH70eKA9O3xdr891lWtnR+DGlAHA==
X-Google-Smtp-Source: AK7set8jjWDEEZq4ZRO9si3TI/uUqcW8c+va0KhyoIzU58ayLyplCFQojYuf6k9dpDvMjQDJ4WH56A==
X-Received: by 2002:a05:600c:444a:b0:3ed:1fa2:e25b with SMTP id v10-20020a05600c444a00b003ed1fa2e25bmr14851109wmn.20.1678974049493;
        Thu, 16 Mar 2023 06:40:49 -0700 (PDT)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id x2-20020a05600c21c200b003e1f2e43a1csm4937600wmj.48.2023.03.16.06.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 06:40:49 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN
Date:   Thu, 16 Mar 2023 14:40:43 +0100
Message-Id: <20230316134043.1824345-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Commit 83dcedd5540 ("ksmbd: fix infinite loop in ksmbd_conn_handler_loop()"),
changes GFP modifiers passed to kvmalloc(). However, the latter calls
kvmalloc_node() which does not support __GFP_NORETRY.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/ksmbd/connection.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 5b10b03800c1..54e077597f4e 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -329,10 +329,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
-		conn->request_buf = kvmalloc(size,
-					     GFP_KERNEL |
-					     __GFP_NOWARN |
-					     __GFP_NORETRY);
+		conn->request_buf = kvmalloc(size, GFP_KERNEL);
 		if (!conn->request_buf)
 			break;
 
-- 
2.34.1

