Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3922C77B7C
	for <linux-cifs@archiver.kernel.org>; Fri,  5 May 2023 15:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjEEPLg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 11:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjEEPLf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 11:11:35 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B4B6EB5
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 08:11:35 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso1666146a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 08:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299494; x=1685891494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/CdgG7gn6PUq2E/FvriiLf3vI1YTBomKC3uP2GmAzQ=;
        b=EfxwYM9UwSBSLYuWt7JQEVCpkkEcTnwSQLGwQdUMh79pFO8o3GG79U+YjVLgPTIkjF
         uBMd0GTpwNYPm0gIDuQRuKZK8/m7Liujcv5d1dkE+myfMZxLeFcDFfDPcK6ixM3F2kZB
         +eV11X67hIBWKYLvhh1zJcw0r7Lqhj1GmU5h7F0Yc1XmpulFkhML7Zu3teou/iL6e7+0
         I1jwrm9OgsguRAshlUf22yfYhAoJbY7D6sE0ikbYoQPV9x82L3rx3iNNr2FaDupxaEWw
         vpoaaGQQo7tq6fkjmJafpzaqyUTWX9myO42gEdcR9Gx69v9N9osp6ELGIYPQEnMSOJOk
         ArCQ==
X-Gm-Message-State: AC+VfDyVp/6xWvrGNk50hdzPQVgGtJy3c13fJhiI9Epjziu14lqjKtou
        wNmjBhRNwn5weguaps27cgg6rpo0zdw=
X-Google-Smtp-Source: ACHHUZ6rPLbBgrJe80/455lSpnvSLn1PFUnN+Wuj6aZa97EYbMd5qAzvumBxAtvocsWVcd99TGKi+g==
X-Received: by 2002:a17:902:f7d3:b0:1a6:dfb3:5f4b with SMTP id h19-20020a170902f7d300b001a6dfb35f4bmr1553096plw.55.1683299494050;
        Fri, 05 May 2023 08:11:34 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902d4c400b001a2135e7eabsm1950898plg.16.2023.05.05.08.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 08:11:33 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Pumpkin <cc85nod@gmail.com>
Subject: [PATCH 3/6] ksmbd: allocate one more byte for implied bcc[0]
Date:   Sat,  6 May 2023 00:11:05 +0900
Message-Id: <20230505151108.5911-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230505151108.5911-1-linkinjeon@kernel.org>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Pumpkin <cc85nod@gmail.com>

ksmbd_smb2_check_message allows client to return one byte more, so we
need to allocate additional memory in ksmbd_conn_handler_loop to avoid
out-of-bound access.

Signed-off-by: Pumpkin <cc85nod@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/connection.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 4ed379f9b1aa..4882a812ea86 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -351,7 +351,8 @@ int ksmbd_conn_handler_loop(void *p)
 			break;
 
 		/* 4 for rfc1002 length field */
-		size = pdu_size + 4;
+		/* 1 for implied bcc[0] */
+		size = pdu_size + 4 + 1;
 		conn->request_buf = kvmalloc(size, GFP_KERNEL);
 		if (!conn->request_buf)
 			break;
-- 
2.25.1

