Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E696C7EE22
	for <linux-cifs@archiver.kernel.org>; Fri,  5 May 2023 15:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjEEPLp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 11:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjEEPLo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 11:11:44 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB186EB5
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 08:11:43 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5191796a483so1325453a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 08:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299503; x=1685891503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOXPjqvMMoAafjBIsNZ3V+vTfWMMSzGigeANy4HIEwE=;
        b=Vg/LR4dsHwo4wwG5DD8k0MWpRJNXPbvKHpy984vWyF8BNhlNob1eYOlrb03/2Quxn6
         ay2N7zy8O5Qp4D17+B0CElg9zUdOslaE+9SYnCZoG6FEbtDQcm7dgm9zXIXPn8v4zAik
         3glKwk4crKOSkhAFQG3/WNpFGD6uxQE9n02oaUSzjl42wRmX6FUmBhuWECj6qxrYkt0G
         O8jCQpK0gXhevaE83Kqyfr5ERSuDp1jC1QWawLidM5AnT1jxngoj3epbcoVUOlUUs1qg
         rKw8KDfwWe4Q05AlsrOpIhBKNggD5qOFPq95kNx+H4YHf5fEty43akNjptLclIxmCvJy
         zlag==
X-Gm-Message-State: AC+VfDyvmJBdeIQFaEfWDpCpuA96M9qJG0TerwvcgNfVwxKgVkHgQo7D
        ox66EeDGMV0P3SCRjIFj5NdXiGZamxM=
X-Google-Smtp-Source: ACHHUZ7ih3k9/U4McizhdoPmKthf5ZUraZt6rrqiuAh64OD9XGeXg3D3/rwfuIOmK4ydO3qvfXNrFQ==
X-Received: by 2002:a17:902:e850:b0:1aa:e5e9:6769 with SMTP id t16-20020a170902e85000b001aae5e96769mr2214028plg.23.1683299503003;
        Fri, 05 May 2023 08:11:43 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902d4c400b001a2135e7eabsm1950898plg.16.2023.05.05.08.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 08:11:42 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH 6/6] ksmbd: use kzalloc() instead of __GFP_ZERO
Date:   Sat,  6 May 2023 00:11:08 +0900
Message-Id: <20230505151108.5911-6-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230505151108.5911-1-linkinjeon@kernel.org>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use kzalloc() instead of __GFP_ZERO.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index af0c2a9b8529..c6e4d38319df 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -347,8 +347,8 @@ static int smb1_check_user_session(struct ksmbd_work *work)
  */
 static int smb1_allocate_rsp_buf(struct ksmbd_work *work)
 {
-	work->response_buf = kmalloc(MAX_CIFS_SMALL_BUFFER_SIZE,
-			GFP_KERNEL | __GFP_ZERO);
+	work->response_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE,
+			GFP_KERNEL);
 	work->response_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 
 	if (!work->response_buf) {
-- 
2.25.1

