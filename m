Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800F3CA0EEB
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Sep 2023 14:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbjILObp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Sep 2023 10:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbjILObi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Sep 2023 10:31:38 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A2A1B6
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 07:31:34 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c0c6d4d650so48051365ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 07:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694529093; x=1695133893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6YPiKuxd6trXXycvrpNzLOgRUJJGgXT7un75cyrDp8=;
        b=ZSMtS9fJPeshoHM/OCs57iaPsQPX2S8YD4chDR/oS8opIHreqRMbPdwU+KkpzcR3TD
         vLYZl/mhA1DaZ8SjsDIRUOEtAAW+NmwzVRx6B3BQIXC+1U/mDvCZxr/jKXgI4V5AXps5
         0yjXxHAefrfRayyiRiNOg1C2a0hW11JpVIGjSSkkwP2S3V//VyMHXZ8Dbi+/eIPHzJcU
         A3L7Wv6KZLzjXYyCZpOkFNAlJ9kyC1tatLb3MLvtI7UMPKSrZA99csAE84zxXiK49laQ
         7Az2nYESfk8NgWFybFVpn26Gk1EojEygd9JlV2o0w09Mo6uU45jm9RAufQOJwq3+lSLT
         zqFg==
X-Gm-Message-State: AOJu0YwE5CMJbSlsmX3iYMvyDbd3RfWJUFiX57y07kxWgNqgYbJOOoTk
        vY+QX+5Mzf86fUDIWmne3cRNAl0/5gs=
X-Google-Smtp-Source: AGHT+IGOAoE1FxJRIbyo0qhGLREuA5z8HpaQ2lM7/+LT2BhX2S+tEPYldLhZZeXWLJXHO0ns/fSfIw==
X-Received: by 2002:a17:902:f544:b0:1c3:a91a:627f with SMTP id h4-20020a170902f54400b001c3a91a627fmr7799804plf.47.1694529093169;
        Tue, 12 Sep 2023 07:31:33 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id jb22-20020a170903259600b001bc9bfaba3esm8538670plb.126.2023.09.12.07.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 07:31:32 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] ksmbd: fix passing freed memory 'aux_payload_buf'
Date:   Tue, 12 Sep 2023 23:31:18 +0900
Message-Id: <20230912143118.6829-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230912143118.6829-1-linkinjeon@kernel.org>
References: <20230912143118.6829-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch e2b76ab8b5c9: "ksmbd: add support for read compound" leads
to the following Smatch static checker warning:

  fs/smb/server/smb2pdu.c:6329 smb2_read()
        warn: passing freed memory 'aux_payload_buf'

It doesn't matter that we're passing a freed variable because nbytes is
zero. This patch set "aux_payload_buf = NULL" to make smatch silence.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 749660110878..544022dd6d20 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6312,7 +6312,7 @@ int smb2_read(struct ksmbd_work *work)
 						      aux_payload_buf,
 						      nbytes);
 		kvfree(aux_payload_buf);
-
+		aux_payload_buf = NULL;
 		nbytes = 0;
 		if (remain_bytes < 0) {
 			err = (int)remain_bytes;
-- 
2.25.1

