Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60E9CA0EEC
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Sep 2023 14:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbjILObn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Sep 2023 10:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbjILObe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Sep 2023 10:31:34 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675141718
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 07:31:30 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c1e3a4a06fso41003295ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 07:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694529089; x=1695133889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QOIR80oLXJt/XB21uNagI3Kc/7zE1b0K55yVxxInZ/A=;
        b=A9I3wFs2OUE7x1fNg9tZ69ZJ8mja8qQUUYHt1gjXGsWJdo9LGV3lyiRPEydKwMora+
         O8KCaWEglec0XfJz2Iodvx31UM3jYvsozhKbqzXA/3+vmEcjPtUkpsxdP729vyEuBgv5
         kg1cqJZ0V72VYJFkgN2LyCLz4JgXTYIb4u39s79pvmMpvRPdjsn5DCABcSCt4LEnjdXU
         Ho6xxypndHaopS06PCrWOE+mq0eWqvFw2dX2gczcYJkAHIvkjGLdnl0vibaldxUOMhrw
         rTQENy65JsWrc0y+JOqgwtSdzZKFUIE1AZrDqshGXPF8x9wlPMzix+Pm/8xE0xaUtmBj
         081A==
X-Gm-Message-State: AOJu0Yz7bxz/MrdUBax2QE+gIRh91Ju7fDlgm62VxnjEVZAeJCX8hfTC
        2Idrh8kxFadcpnvj8wH/6T/4cSqxEbg=
X-Google-Smtp-Source: AGHT+IHgR/m0F5gsZEzpwmBzEnl2hPMcObLO8fHwQ+7MFWPC13d9+BiJsN9sm9l28KLOBkxEhaAupw==
X-Received: by 2002:a17:902:ce8b:b0:1c3:9bce:817 with SMTP id f11-20020a170902ce8b00b001c39bce0817mr6862618plg.3.1694529089314;
        Tue, 12 Sep 2023 07:31:29 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id jb22-20020a170903259600b001bc9bfaba3esm8538670plb.126.2023.09.12.07.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 07:31:28 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: remove unneeded mark_inode_dirty in set_info_sec()
Date:   Tue, 12 Sep 2023 23:31:17 +0900
Message-Id: <20230912143118.6829-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

mark_inode_dirty will be called in notify_change().
This patch remove unneeded mark_inode_dirty in set_info_sec().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smbacl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index e5e438bf5499..6c0305be895e 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1420,7 +1420,6 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 out:
 	posix_acl_release(fattr.cf_acls);
 	posix_acl_release(fattr.cf_dacls);
-	mark_inode_dirty(inode);
 	return rc;
 }
 
-- 
2.25.1

