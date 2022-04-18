Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6192C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Apr 2022 05:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbiDRFSD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Apr 2022 01:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiDRFSB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Apr 2022 01:18:01 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8314B10FD1
        for <linux-cifs@vger.kernel.org>; Sun, 17 Apr 2022 22:15:23 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id k14so16934475pga.0
        for <linux-cifs@vger.kernel.org>; Sun, 17 Apr 2022 22:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=As8ZDUP2FyzWTyAhpVFyvjkmY2f2jw37F6WuuikUH8Q=;
        b=b+r5S+f5aICSLMfbPu7d7MRElKVGmDVMF+NsJaDcDzzcIm1TlYld5ETLIw5nkx5ITk
         Onmc2KeddjJJLKTjpWAqbh9k/LLQ3qAL80IsbpsKpNJYf+GKN8U5PDWtFV1AYkjBxHvo
         pL4ji6NxmMtMGroi5yphqZa95to9KPBpFYJaK0LqM+hXJAG1CizpzhNB1szdEtWm9Vm+
         u20zM3yI+oMGPWt+UHpwotwCV+Jw6crGTSlEilIRWGSg51LrS5VdYUm50gAUYesXTe9r
         Yz8f9NGnx68Skg4um5nht/B/MFOBHCUl5yJ9ZtHYXT8v0nkHA82R9wPu99deqdKX415n
         wBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=As8ZDUP2FyzWTyAhpVFyvjkmY2f2jw37F6WuuikUH8Q=;
        b=wxMrM8f4FukEV+f6mBWkrKJGtfUF9btwTb43jQtMkrMbzoSg6vAs1rWJHGY8CnnDBf
         4l+KPeDG+ExA9oDIC/nNCJxBrbQxDRFAJEVVPEc/A0vmAhwmeIyV/izlch6614Jw8JMb
         SSO/sF8zWQ55CU9tyKCAkCuirt1nJ6E7IWII2R6nZGeWXdbYnpsNzw2wjrkP4cqpU5Nd
         y0cWOGdMmuOQgp40nG34G73fu1ALZnJizANuFuYxOAwKh4aUluyv581nfuESddunPhKg
         EeH04FgZwa0Pv8fhcCfCDuyX6v9eRYYeQR1sOEKIB/ayin4+DamaDI9mr9YWqjeqL7W4
         4kuQ==
X-Gm-Message-State: AOAM5322Yh62uQVeFb808t6nBpXJL9UJxSG7hVUCBiAILEryDPFDCErV
        IofoVEacpJ+09m5DCxMzmzchS/WuJXI=
X-Google-Smtp-Source: ABdhPJxWlPcwrDNZGwBerBKLtDOXr/AJTYv7X3K202q8QZ5ajs9NGpi1Low4ze+d4nmXV2dKRBTptQ==
X-Received: by 2002:a05:6a00:21c7:b0:4fd:f89f:ec17 with SMTP id t7-20020a056a0021c700b004fdf89fec17mr10424411pfj.72.1650258922897;
        Sun, 17 Apr 2022 22:15:22 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm11453028pge.23.2022.04.17.22.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 22:15:22 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v3 3/4] ksmbd: smbd: simplify tracking pending packets
Date:   Mon, 18 Apr 2022 14:14:11 +0900
Message-Id: <20220418051412.13193-3-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418051412.13193-1-hyc.lee@gmail.com>
References: <20220418051412.13193-1-hyc.lee@gmail.com>
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
index 895600cc8c5d..1343ff8e00fd 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -159,8 +159,6 @@ struct smb_direct_transport {
 	mempool_t		*recvmsg_mempool;
 	struct kmem_cache	*recvmsg_cache;
 
-	wait_queue_head_t	wait_send_payload_pending;
-	atomic_t		send_payload_pending;
 	wait_queue_head_t	wait_send_pending;
 	atomic_t		send_pending;
 
@@ -388,8 +386,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	spin_lock_init(&t->empty_recvmsg_queue_lock);
 	INIT_LIST_HEAD(&t->empty_recvmsg_queue);
 
-	init_waitqueue_head(&t->wait_send_payload_pending);
-	atomic_set(&t->send_payload_pending, 0);
 	init_waitqueue_head(&t->wait_send_pending);
 	atomic_set(&t->send_pending, 0);
 
@@ -419,8 +415,6 @@ static void free_transport(struct smb_direct_transport *t)
 	wake_up_interruptible(&t->wait_send_credits);
 
 	ksmbd_debug(RDMA, "wait for all send posted to IB to finish\n");
-	wait_event(t->wait_send_payload_pending,
-		   atomic_read(&t->send_payload_pending) == 0);
 	wait_event(t->wait_send_pending,
 		   atomic_read(&t->send_pending) == 0);
 
@@ -875,13 +869,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
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
@@ -913,21 +902,12 @@ static int smb_direct_post_send(struct smb_direct_transport *t,
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
@@ -1328,8 +1308,8 @@ static int smb_direct_writev(struct ksmbd_transport *t,
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

