Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D98E80AB3
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Sep 2023 14:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjI0Oa7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbjI0Oaz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Sep 2023 10:30:55 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324671704
        for <linux-cifs@vger.kernel.org>; Wed, 27 Sep 2023 07:30:33 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-692779f583fso8085747b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 27 Sep 2023 07:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695825032; x=1696429832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aue8jEnZY54xGvixCdj5yyUKVBLT1FEl6PdQhev0tck=;
        b=AL4R+EduhcHcAyvJeTPtLe6FGxGZzAFXuI6ojGGGdD87nP02Vg0inKadW/qNnVXhZs
         LNiEOQ6ZIvAKTFpA/Ods6WeEgbVUtm0Rq04cdn2OGoKF9Iut1egXdI5cQXihrhoQpvCK
         /VDs22homw8veOgEZFF7GSwwcVAf/bN2LGM1auVxjTD3vvo+a+mrmX8hKEsA5KURU5fw
         SO7N0mFSRXIHGHSy14n34K6Ud96YLuCCXOVFO5nEkfRKSxiMVpKb5/z8T177v9KJI1P9
         WZKY/b6EC/5mz+esShQMDhCFv/24tdmLBxo0/F/5y5qbRKRzGIUOiXRUDWBPIHLyCLvi
         pXJg==
X-Gm-Message-State: AOJu0YwBHTbeY3iyx+TZ975kKsY8Ms4j74nigR3LiNiKZCRxPdtTE5E2
        DCapofYNd+WGPEKNH8bwoOUHnMz/tm0=
X-Google-Smtp-Source: AGHT+IFntT8uongBnCdEwz3VCM7q3gcCcIem4qbN0ql184hJJFcuYqt4oiwy4KGEZlPa4J8SsyOTcA==
X-Received: by 2002:a05:6a00:468e:b0:693:3783:4a29 with SMTP id de14-20020a056a00468e00b0069337834a29mr1393398pfb.20.1695825031993;
        Wed, 27 Sep 2023 07:30:31 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id p14-20020aa7860e000000b00690c52267easm661279pfn.40.2023.09.27.07.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 07:30:31 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: not allow to open file if delelete on close bit is set
Date:   Wed, 27 Sep 2023 23:30:09 +0900
Message-Id: <20230927143009.8882-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Cthon test fail with the following error.

check for proper open/unlink operation
nfsjunk files before unlink:
  -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
./nfs2y8Jm9 open; unlink ret = 0
nfsjunk files after unlink:
  -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
data compare ok
nfsjunk files after close:
  ls: cannot access './nfs2y8Jm9': No such file or directory
special tests failed

Cthon expect to second unlink failure when file is already unlinked.
ksmbd can not allow to open file if flags of ksmbd inode is set with
S_DEL_ON_CLS flags.

Reported-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs_cache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index f41f8d6108ce..f2e2a7cc24a9 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -577,6 +577,11 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 		goto err_out;
 	}
 
+	if (fp->f_ci->m_flags & S_DEL_ON_CLS) {
+		ret = -ENOENT;
+		goto err_out;
+	}
+
 	ret = __open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
 	if (ret) {
 		ksmbd_inode_put(fp->f_ci);
-- 
2.25.1

