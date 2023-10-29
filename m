Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36396C4332F
	for <linux-cifs@archiver.kernel.org>; Sun, 29 Oct 2023 12:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjJ2MBC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Oct 2023 08:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJ2MBB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Oct 2023 08:01:01 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD378BD
        for <linux-cifs@vger.kernel.org>; Sun, 29 Oct 2023 05:00:59 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6b3c2607d9bso3112582b3a.1
        for <linux-cifs@vger.kernel.org>; Sun, 29 Oct 2023 05:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698580859; x=1699185659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEVDXW+mNruLUYQB9PVdTNA6z0NQ5aR9Y+Ze5U+dTZ4=;
        b=DyNRrNsl6fJBbsZV7l1sdc+Tl8+ZYAoP64X7WkJRGvuEFy/H0T6Alp5ofAXYW+MhTX
         XUQF3Ljk2lfshZqpTxUpP62azTbtiVgWcOb5Xn83D+uus/iHHjOERVoB3YZFTA7ZcBbm
         pRC1hyrdsNr9s4LK5uq6JqwgfCiJMIOmSEJmvA8CojlBVmtRMDXpY1d/pObMxZZINi9L
         H5Vf1AdAELtGnc2IEkQ5xMJtz04EMlF2wet0W4BZSRotON8SnPh21EZNo5uG4q62ml/4
         Cd0ylUSDuWNrV+h7Aha4ltZpEHkH0NA9TzoMiQxLm+HGUigTNewvL51/k6V7XV3JpFxN
         o+KA==
X-Gm-Message-State: AOJu0YxzOKWff6tJh1muPqiCKL7NxOtjOdk9MT49UuojFim202O/H0cK
        MmoN35eo2orBlag1EgdV9WEyCT2LZkM=
X-Google-Smtp-Source: AGHT+IGXJYbL2AVMa7FVnDzhuWXElwj5t1ZUGR5WcWB/4GO+kL5MXfGquLsLVoKtOOrRpe5JkfsDrw==
X-Received: by 2002:a05:6a00:2302:b0:68b:e710:ee9c with SMTP id h2-20020a056a00230200b0068be710ee9cmr5567638pfh.19.1698580858872;
        Sun, 29 Oct 2023 05:00:58 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id m16-20020aa78a10000000b0068bc6a75848sm4199649pfa.156.2023.10.29.05.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Oct 2023 05:00:58 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: no need to wait for binded connection termination at logoff
Date:   Sun, 29 Oct 2023 21:00:44 +0900
Message-Id: <20231029120044.6619-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The connection could be binded to the existing session for Multichannel.
session will be destroyed when binded connections are released.
So no need to wait for that's connection at logoff.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 4b38c3a285f6..b6fa1e285c40 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -167,23 +167,7 @@ void ksmbd_all_conn_set_status(u64 sess_id, u32 status)
 
 void ksmbd_conn_wait_idle(struct ksmbd_conn *conn, u64 sess_id)
 {
-	struct ksmbd_conn *bind_conn;
-
 	wait_event(conn->req_running_q, atomic_read(&conn->req_running) < 2);
-
-	down_read(&conn_list_lock);
-	list_for_each_entry(bind_conn, &conn_list, conns_list) {
-		if (bind_conn == conn)
-			continue;
-
-		if ((bind_conn->binding || xa_load(&bind_conn->sessions, sess_id)) &&
-		    !ksmbd_conn_releasing(bind_conn) &&
-		    atomic_read(&bind_conn->req_running)) {
-			wait_event(bind_conn->req_running_q,
-				atomic_read(&bind_conn->req_running) == 0);
-		}
-	}
-	up_read(&conn_list_lock);
 }
 
 int ksmbd_conn_write(struct ksmbd_work *work)
-- 
2.25.1

