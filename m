Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC36C433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Oct 2022 03:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiJBDBn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Oct 2022 23:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJBDBj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Oct 2022 23:01:39 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CFD26566
        for <linux-cifs@vger.kernel.org>; Sat,  1 Oct 2022 20:01:33 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id l12so7129948pjh.2
        for <linux-cifs@vger.kernel.org>; Sat, 01 Oct 2022 20:01:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ZPJnte2YcTqcIYftXePKlW4ieB0yfOH0UtZLqt5JaNU=;
        b=Z9f5vTNbTeChR9MHN/GEyHjrcybqFpkRLGVfkHCysgSLxXUSDN6xdjxZ0492GNFhAs
         yiGVuZWVNaa0TY6Vxbwbq61eQHZbamB5Wpaf+r7lqWRE+2WQkbzDUmeWPoC5l3eGoWXu
         HoQ0cYgS37sz7DldIbIe826EWlkPv3egyGn8Ws4R6G1h2te7DS65x3juOap/isAOqc4E
         enrACUloiAQCe6BlqNW6XICk/F7Nz3J2bp+yYb7pSeUgmdwjIHS9tsvdFEnLFqa2kUX3
         01gXWPdmWpPGqD3p1WRhN9zFNl3xfeNea2jHpx/q8OJvCVkQGAjcEnpB3TQgteZQyGwe
         6srw==
X-Gm-Message-State: ACrzQf3sNwGM9Y8nJLHZt4MNdSwBMnmQL1AnsQ97rFXFgXd0FslMIO/G
        xuQyuudKB7DIOYbv/lzvE7D74lPTAO4=
X-Google-Smtp-Source: AMsMyM7sZWlH9/7M3fgmY4re9eZRa5d5ANNQa+XtwJ67IeKHuDVcp6i0OVi/XgzNp5V6VbNvMtW+cA==
X-Received: by 2002:a17:902:b693:b0:178:5fa6:4b3 with SMTP id c19-20020a170902b69300b001785fa604b3mr16109490pls.63.1664679693151;
        Sat, 01 Oct 2022 20:01:33 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902ecc900b00178b9c997e5sm290320plh.138.2022.10.01.20.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 20:01:32 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: call ib_drain_qp when disconnected
Date:   Sun,  2 Oct 2022 12:01:23 +0900
Message-Id: <20221002030123.11409-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When disconnected, call ib_drain_qp to cancel all pending work requests
and prevent ksmbd_conn_handler_loop from waiting for a long time
for those work requests to compelete.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 0315bca3d53b..096eda9ef873 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1527,6 +1527,8 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 	}
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_DISCONNECTED: {
+		ib_drain_qp(t->qp);
+
 		t->status = SMB_DIRECT_CS_DISCONNECTED;
 		wake_up_interruptible(&t->wait_status);
 		wake_up_interruptible(&t->wait_reassembly_queue);
-- 
2.25.1

