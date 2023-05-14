Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A887C77B7D
	for <linux-cifs@archiver.kernel.org>; Sun, 14 May 2023 03:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjENDwB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 May 2023 23:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjENDv7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 May 2023 23:51:59 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99E61BE4
        for <linux-cifs@vger.kernel.org>; Sat, 13 May 2023 20:51:58 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6439e6f5a33so6966469b3a.2
        for <linux-cifs@vger.kernel.org>; Sat, 13 May 2023 20:51:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684036318; x=1686628318;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RI2H2n01YpDA5rl7KDCo9bViLYntq0O6F3yl69Fm52M=;
        b=eAnM93LUexNt8KrR8Lc43jzG7RoDfRU+fdrKLAgsFutUOvPQS2xlifdZwDy61dS9pa
         w2U9HKzCtLYT8m35BFHJt7B01wwWyv75rlyWnvnandT3tjP0n423CMAtUXtwUVzGm9Qf
         AW/m0GLW3EafKK/mKwW8du8eJxFiPRU+f7eByQN6E7dZwuHmt27/IDCVVd66fvJ/UH9R
         jN7WDiPQfsxyLS3juKKvZW4Y0dWO/d/OWsA8osHr8V63CvhbkWTE32qh9r/S+2zDqcBv
         VjcJReS836CF96FqsZD5yEUlxiv0HbKCloX66kRUAApjVKbsWOI4WjienuO3TJNgyabj
         345Q==
X-Gm-Message-State: AC+VfDy7TIDYizbktBY2B2rienJO7sMtt9tPnSUJGLU8DvXPTcez7BfX
        xzJ2LADTWCSa+k714x5G0Hx8obOlKKg=
X-Google-Smtp-Source: ACHHUZ7biaM6zxK9plvJM6S06YDQegB9RiMfpUWZlKPixyNG/uUASSQVTDvsdRPnm85ybM2g0NCG/w==
X-Received: by 2002:a05:6a20:4315:b0:f0:9cbd:78e3 with SMTP id h21-20020a056a20431500b000f09cbd78e3mr35204203pzk.0.1684036318026;
        Sat, 13 May 2023 20:51:58 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id 19-20020aa79113000000b0063b79bae907sm9281837pfh.122.2023.05.13.20.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 20:51:57 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Coverity Scan <scan-admin@coverity.com>
Subject: [PATCH] ksmbd: fix uninitialized pointer read in ksmbd_vfs_rename()
Date:   Sun, 14 May 2023 12:51:40 +0900
Message-Id: <20230514035142.7653-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Uninitialized rd.delegated_inode can be used in vfs_rename().
Fix this by setting rd.delegated_inode to NULL to avoid the uninitialized
read.

Reported-by: Coverity Scan <scan-admin@coverity.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/vfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 778c152708e4..9bdb01c5b201 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -743,6 +743,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	rd.new_dir		= new_path.dentry->d_inode,
 	rd.new_dentry		= new_dentry,
 	rd.flags		= flags,
+	rd.delegated_inode	= NULL,
 	err = vfs_rename(&rd);
 	if (err)
 		ksmbd_debug(VFS, "vfs_rename failed err %d\n", err);
-- 
2.25.1

