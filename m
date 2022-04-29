Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751D0C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Apr 2022 23:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243996AbiD2Xfa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Apr 2022 19:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381657AbiD2Xf2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Apr 2022 19:35:28 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CADCDBD3F
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 16:32:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id h12so8375901plf.12
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 16:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=saYKkxcWtTN8BNOBrjRvYRYtLK0TpKU8rN4ZgeQ+MgU=;
        b=nPRS380N5WLBA5za/UDRGhIOv/PjzXjhagVgfXzvxDSC6km3wdBM122BW+4neBg0WZ
         n/vXcg2+pzfeyg5IhU7iqfjYnVkJbRTB2a/gOZc0dQj4Dv9NlqXU2Uv01OW8clBH0Vz7
         ppHV9iDxxMuiHTcy+4TNGwIYVwmsGy60C9ne3IXyoY3NTFr1hXQ1nNnZuNHh6YXFng5b
         YTsu4EU84TMHjBoPUSgzKZg2NT1Suxt9Y7JurgVs3GKUbE/zxDAAtRRfk4kItWkqlTF5
         6ar87HPhCEZklVvl214/szwTtvpv2smro4jIs8ZE/8uyKZZ1vwkg60ZA2vviigZEccpn
         mgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=saYKkxcWtTN8BNOBrjRvYRYtLK0TpKU8rN4ZgeQ+MgU=;
        b=26CIKTx/XcSFkM/W7Nr6dCDMPLaSxRFGBU7RlxEzyZsOWMj5OqbbR0yL9++ty/3dsa
         oe7GzCsxHBQAmbdyeqTZZ8NMq8cmF5kNYY23RqnE1wVfeBvB/Y6FDkRoPxJf+2dzxyTu
         +ppdh4uSOJ6DRdWiqDmaZKFpu7hy/1P4MIQn9Zr/Kyae8N2p0XPHuF7sT2JqGHCw3MLy
         9+IIrrSllGlL3w9BOJ6Cx8Fv9rC+xZ7nc37KaBCEA4GRynmQ/yuFD+X3l0/MgtA84fLZ
         WYMfbxtHqlaT6YTWULi95Ja6aESbqPmwU0tv02F6l8SQJ3iO9Uy3sNXQpbye5xTnN8qW
         Vs7w==
X-Gm-Message-State: AOAM530UMA/POnLcNzjBK6IufsTLK60pLbpUVuLNGsDyjgLzBZRLsmV1
        dl7t61Lzr033Kj5DR9Ol5S9I5NvAg+M=
X-Google-Smtp-Source: ABdhPJy38Q11l9lQ7At6eNgL9ILBFlIlxN0UEqkwWkfubXJ1MaMDCTvq+V2S1OCRUMcz+gLLLobKMQ==
X-Received: by 2002:a17:902:d509:b0:15c:fd46:8db with SMTP id b9-20020a170902d50900b0015cfd4608dbmr1633298plg.52.1651275126058;
        Fri, 29 Apr 2022 16:32:06 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id h9-20020a62b409000000b0050dc7628180sm230227pfn.90.2022.04.29.16.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 16:32:05 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v4 3/5] ksmbd: smbd: simplify tracking pending packets
Date:   Sat, 30 Apr 2022 08:30:27 +0900
Message-Id: <20220429233029.42741-3-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429233029.42741-1-hyc.lee@gmail.com>
References: <20220429233029.42741-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Because we don't have to tracking pending packets
by dividing these into packets with payload and
packets without payload, merge the tracking code.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
changes from v2:
 - Split a v2 patch to 4 patches.

 fs/ksmbd/transport_rdma.c | 34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 2edb5acfb1f6..4372d631735e 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -157,8 +157,6 @@ struct smb_direct_transport {
 	mempool_t		*recvmsg_mempool;
 	struct kmem_cache	*recvmsg_cache;
 
-	wait_queue_head_t	wait_send_payload_pending;
-	atomic_t		send_payload_pending;
 	wait_queue_head_t	wait_send_pending;
 	atomic_t		send_pending;
 
@@ -386,8 +384,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	spin_lock_init(&t->empty_recvmsg_queue_lock);
 	INIT_LIST_HEAD(&t->empty_recvmsg_queue);
 
-	init_waitqueue_head(&t->wait_send_payload_pending);
-	atomic_set(&t->send_payload_pending, 0);
 	init_waitqueue_head(&t->wait_send_pending);
 	atomic_set(&t->send_pending, 0);
 
@@ -417,8 +413,6 @@ static void free_transport(struct smb_direct_transport *t)
 	wake_up_interruptible(&t->wait_send_credits);
 
 	ksmbd_debug(RDMA, "wait for all send posted to IB to finish\n");
-	wait_event(t->wait_send_payload_pending,
-		   atomic_read(&t->send_payload_pending) == 0);
 	wait_event(t->wait_send_pending,
 		   atomic_read(&t->send_pending) == 0);
 
@@ -873,13 +867,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		smb_direct_disconnect_rdma_connection(t);
 	}
 
-	if (sendmsg->num_sge > 1) {
-		if (atomic_dec_and_test(&t->send_payload_pending))
-			wake_up(&t->wait_send_payload_pending);
-	} else {
-		if (atomic_dec_and_test(&t->send_pending))
-			wake_up(&t->wait_send_pending);
-	}
+	if (atomic_dec_and_test(&t->send_pending))
+		wake_up(&t->wait_send_pending);
 
 	/* iterate and free the list of messages in reverse. the list's head
 	 * is invalid.
@@ -911,21 +900,12 @@ static int smb_direct_post_send(struct smb_direct_transport *t,
 {
 	int ret;
 
-	if (wr->num_sge > 1)
-		atomic_inc(&t->send_payload_pending);
-	else
-		atomic_inc(&t->send_pending);
-
+	atomic_inc(&t->send_pending);
 	ret = ib_post_send(t->qp, wr, NULL);
 	if (ret) {
 		pr_err("failed to post send: %d\n", ret);
-		if (wr->num_sge > 1) {
-			if (atomic_dec_and_test(&t->send_payload_pending))
-				wake_up(&t->wait_send_payload_pending);
-		} else {
-			if (atomic_dec_and_test(&t->send_pending))
-				wake_up(&t->wait_send_pending);
-		}
+		if (atomic_dec_and_test(&t->send_pending))
+			wake_up(&t->wait_send_pending);
 		smb_direct_disconnect_rdma_connection(t);
 	}
 	return ret;
@@ -1326,8 +1306,8 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	 * that means all the I/Os have been out and we are good to return
 	 */
 
-	wait_event(st->wait_send_payload_pending,
-		   atomic_read(&st->send_payload_pending) == 0);
+	wait_event(st->wait_send_pending,
+		   atomic_read(&st->send_pending) == 0);
 	return ret;
 }
 
-- 
2.25.1

