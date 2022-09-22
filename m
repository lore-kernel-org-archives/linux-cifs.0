Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAADC54EE9
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 14:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiIVOk6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiIVOkc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 10:40:32 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7ACDEE5
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:39:37 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id y136so9530161pfb.3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:39:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=n+3kez6c0aFiISnxWSwNdJhkurv8pG9BnQ2+UBrsox0=;
        b=7oCQGXVosGF+9CgQmH8/qvvni1KgH9fZR7mfSbZVbXiMtJ+2qd1zu/R50uUH2XnDeK
         5d7IrCscPuoP67SnseUfjbzqWJfGFhI+lp3piAsM16AlSccLgD9TVFiR3XOb7puyvBxZ
         XdpdYLkkHD4w92oc86soP6Pq234d5EeDJPHu9Z+djoTIjiR5xr1t5Ut1YQBhO+TPuFdd
         /BjV9sGJrf9RNeAGUri2+2UM3GkbRdknRsem7MTo47iTf8W9WfwDZ7LpoeGph8ZAbej9
         WG8ZQgihUETfUYtP+7t65NGz7Zcm6Z22Fwg+7xZAsPU7S/0HS6a27a8yJ5RLCxVr5caf
         vNhw==
X-Gm-Message-State: ACrzQf35r1G1TqjBEWvkc7KsvCdX0/bDLGOPSvKZFPwg8CRpN1+AkQ+E
        xCsDp4EKoHEyOPtOhyjeksYIA9z+zTo=
X-Google-Smtp-Source: AMsMyM6GKefdmvaMfcJOFva5eG7ZdIum79lgGq/Jg75GnMXZLuZB8Yh6oqlKc4ScdMnALPgmv5C6jg==
X-Received: by 2002:a63:8b42:0:b0:435:c63:f282 with SMTP id j63-20020a638b42000000b004350c63f282mr3265322pge.528.1663857576918;
        Thu, 22 Sep 2022 07:39:36 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id b67-20020a621b46000000b0053e22c7f135sm4500311pfb.141.2022.09.22.07.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 07:39:36 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/3] ksmbd: fix endless loop when encryption for response fails
Date:   Thu, 22 Sep 2022 23:39:04 +0900
Message-Id: <20220922143906.10826-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If ->encrypt_resp return error, goto statement cause endless loop.
It send an error response immediately after removing it.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/server.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index ce42bff42ef9..a0d635304754 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -235,10 +235,8 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	if (work->sess && work->sess->enc && work->encrypted &&
 	    conn->ops->encrypt_resp) {
 		rc = conn->ops->encrypt_resp(work);
-		if (rc < 0) {
+		if (rc < 0)
 			conn->ops->set_rsp_status(work, STATUS_DATA_ERROR);
-			goto send;
-		}
 	}
 
 	ksmbd_conn_write(work);
-- 
2.25.1

