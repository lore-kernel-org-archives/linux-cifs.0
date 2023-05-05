Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5C1C77B7F
	for <linux-cifs@archiver.kernel.org>; Fri,  5 May 2023 15:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjEEPL3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 11:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjEEPL3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 11:11:29 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4C72722
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 08:11:28 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1ab1b79d3a7so12820145ad.3
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 08:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299488; x=1685891488;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uyQl8GszF4qIx3gXTjoyJRAZVJDr5tKMtNpsSU0My9w=;
        b=VAja3Y78oap63/OsVQ/gRy+ZHRt6Yt2uQw0kiIF48RjWeAloAXl2aDXwCE/stJLTx7
         SeeNyb8KuNcugH4fHsohsfvuqL/ssbqqcGsepakvNLSPcgETGWrlUxHQSNQlmQlPPOpQ
         pChMJfSJCkGGcfLyZIP4xUR8WpQVP97g8ovnUjCg0x/qylJyGYAzk72F6orVsMQOuvba
         xrTgPQtGbMnob4VHcOlHTBxeQwHoFqhNKTZAqTi04MIaPoHTzay2Cy2pKc/u9rqIKxvb
         hRqGLl6LxXdNHldtAhtCbyZDYbAgcTKw2HDeXAI5zyv+Jrr3xbM2XaiASAZhlLgeGEVq
         R1Cg==
X-Gm-Message-State: AC+VfDzpixq2lq7AvgkkuoMWqxctuE2J1045A8sq0beULp0c2haJHaVN
        anTfOBHuld8TjkLaGCEAjEqkGmUx07k=
X-Google-Smtp-Source: ACHHUZ5V0P1s7zCp2TUo/cVZaULn5X4KeYhb7J7MSgoFvRIWi2zRp5v+cnrzGdsS+C6XFJBuZv1HFA==
X-Received: by 2002:a17:902:ce8d:b0:1aa:fc8c:8f1f with SMTP id f13-20020a170902ce8d00b001aafc8c8f1fmr1971641plg.50.1683299487722;
        Fri, 05 May 2023 08:11:27 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902d4c400b001a2135e7eabsm1950898plg.16.2023.05.05.08.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 08:11:27 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Pumpkin <cc85nod@gmail.com>
Subject: [PATCH 1/6] ksmbd: fix global-out-of-bounds in smb2_find_context_vals
Date:   Sat,  6 May 2023 00:11:03 +0900
Message-Id: <20230505151108.5911-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Pumpkin <cc85nod@gmail.com>

If the length of CreateContext name is larger than the tag, it will access
the data following the tag and trigger KASAN global-out-of-bounds.

Currently all CreateContext names are defined as string, so we can use
strcmp instead of memcmp to avoid the out-of-bound access.

[    7.995411] ==================================================================
[    7.995866] BUG: KASAN: global-out-of-bounds in memcmp+0x83/0xa0
[    7.996248] Read of size 8 at addr ffffffff8258d940 by task kworker/0:0/7
...
[    7.998191] Call Trace:
[    7.998358]  <TASK>
[    7.998503]  dump_stack_lvl+0x33/0x50
[    7.998743]  print_report+0xcc/0x620
[    7.999458]  kasan_report+0xae/0xe0
[    7.999895]  kasan_check_range+0x35/0x1b0
[    8.000152]  memcmp+0x83/0xa0
[    8.000347]  smb2_find_context_vals+0xf7/0x1e0
[    8.000635]  smb2_open+0x1df2/0x43a0
[    8.006398]  handle_ksmbd_work+0x274/0x810
[    8.006666]  process_one_work+0x419/0x760
[    8.006922]  worker_thread+0x2a2/0x6f0
[    8.007429]  kthread+0x160/0x190
[    8.007946]  ret_from_fork+0x1f/0x30
[    8.008181]  </TASK>

Signed-off-by: Pumpkin <cc85nod@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/oplock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 2e54ded4d92c..5e09834016bb 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1492,7 +1492,7 @@ struct create_context *smb2_find_context_vals(void *open_req, const char *tag)
 			return ERR_PTR(-EINVAL);
 
 		name = (char *)cc + name_off;
-		if (memcmp(name, tag, name_len) == 0)
+		if (!strcmp(name, tag))
 			return cc;
 
 		remain_len -= next;
-- 
2.25.1

