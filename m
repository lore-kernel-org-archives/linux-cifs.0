Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3177CC77B73
	for <linux-cifs@archiver.kernel.org>; Tue, 30 May 2023 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjE3NAL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 May 2023 09:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjE3NAH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 May 2023 09:00:07 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D21E46
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 05:59:43 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-64fd7723836so1654041b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 05:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685451504; x=1688043504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EW/lR62yN5QduTryb9HoYLNdTJynDviSdWzzVsd6QJE=;
        b=CDqZyDRMMohwbDhWy1nG9E/jTYM6/Yp5TgEEvKel+O0Y9AiAIRsv9zynssQL2H4nz7
         JKYKWLFRtT8pVIcYZJ5BJswDZs0c1AquMiI/mqqcAY4pbmX8Uc2wwMZXATyoQDUaEejs
         TIqpwWBuIkB7KSjHkG2RJXP4IcqH7ivsp0RrBDXFi74ev/gXH0t33UUM4+zVSVg6ZT0A
         dUrEI/0qRqjEwDIxEwQAkX/7xJ5nuZeC+T74BsDRy4IsbphkNY4weBXbwySvM71wLtIH
         Wp9mpjFA2en/5YLItH8mK5xqTReiU05Q2i0QM6d6OegqUS6LZ4lY7SlzVg93Brrv4VC0
         0G6Q==
X-Gm-Message-State: AC+VfDxGI4atcsbheqitag1MfIIDroDJr50bZOfaI0u3x/JUW84TflLw
        knufw8BVK0KkSQZSXwtxuUBzUq3to0o=
X-Google-Smtp-Source: ACHHUZ4cLNKmXx1Sc9cq30WfBEoWRjBzQKocc2w2a/dH3pDISgaUYiTqFvmyc3lEybhU5TQFAV83nw==
X-Received: by 2002:a05:6a21:999d:b0:10b:fb01:a72a with SMTP id ve29-20020a056a21999d00b0010bfb01a72amr2353727pzb.60.1685451504330;
        Tue, 30 May 2023 05:58:24 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c17-20020aa78c11000000b0063afb08afeesm1605007pfd.67.2023.05.30.05.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 05:58:24 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] ksmbd: return a literal instead of 'err' in ksmbd_vfs_kern_path_locked()
Date:   Tue, 30 May 2023 21:57:57 +0900
Message-Id: <20230530125757.12910-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530125757.12910-1-linkinjeon@kernel.org>
References: <20230530125757.12910-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Return a literal instead of 'err' in ksmbd_vfs_kern_path_locked().

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index f9fb778247e7..4f14f111a367 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1161,7 +1161,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 
 	err = ksmbd_vfs_path_lookup_locked(share_conf, name, flags, path);
 	if (!err)
-		return err;
+		return 0;
 
 	if (caseless) {
 		char *filepath;
-- 
2.25.1

