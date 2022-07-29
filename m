Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF139C00140
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jul 2022 01:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiG2BBj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jul 2022 21:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiG2BBU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jul 2022 21:01:20 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC5D42AEB
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 18:01:18 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 15-20020a17090a098f00b001f305b453feso6922769pjo.1
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 18:01:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z8uVhYLqAh5DklynNlwyMATmPnanaKzNb0Q2ljuGZrI=;
        b=LlcYadp5LvsOhATk5ncIGUCFC9UiD2Z4m0lI/Q8Nb4qj737cqWsuGoPzdh+ZDuFlvu
         8z5ELXkph6jVzvefa+o1q7JKgTj0Au1fbB6hKgF3nN3Jt4IglhQ4qwE3dZeUou/GPd2M
         AJrIAwcqBVYb2i3zu5mBZM5v3fdX8zfolHjGZCTTfxiKj9K0MJGi7vsSW03IWDWvXqhA
         oVJ83JBxdBRsjH1gS4H/to2NT3aCsF1b+RC7fhPauZILOnitVYzshyPXovh3sD2HMUt2
         RSyIc4rFJpCzZDzy6qk0yEoWYD3ptYmJWt6PIOsuIpWy6/QEEu8pBzKyzM8poxcrXjVs
         Sv/g==
X-Gm-Message-State: ACgBeo0HNEEC/FXHqLOyhT4ydOE2H1CuaKuRyvknJw1JJK5cliKWu28K
        PamCk8jMjVvkzoJW2V3c6U+UF1ID9Zk=
X-Google-Smtp-Source: AA6agR6GwfXxBQqch7kd9lY9iS5Yy7rMGXq6tHaSzDbZahPCVxoY7MPMCJhy0IIr2Vk1vTO6nLwE6Q==
X-Received: by 2002:a17:90a:540c:b0:1f2:26f1:6a37 with SMTP id z12-20020a17090a540c00b001f226f16a37mr1394027pjh.68.1659056477773;
        Thu, 28 Jul 2022 18:01:17 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id i11-20020a170902c94b00b0016d81098d9asm728354pla.34.2022.07.28.18.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 18:01:17 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v3] ksmbd: use wait_event instead of schedule_timeout()
Date:   Fri, 29 Jul 2022 10:00:32 +0900
Message-Id: <20220729010032.15226-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd threads eating masses of cputime when connection is disconnected.
If connection is disconnected, ksmbd thread waits for pending requests
to be processed using schedule_timeout. schedule_timeout() incorrectly
is used, and it is more efficient to use wait_event/wake_up than to check
r_count every time with timeout.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 v2:
   - When r_count is zero, call wake_up event.
 v3:
   - change wake_up_all with wake_up().
   - add the comments to fix waitqueue_active() warnings from checkpatch.pl

 fs/ksmbd/connection.c |  6 +++---
 fs/ksmbd/connection.h |  1 +
 fs/ksmbd/oplock.c     | 35 ++++++++++++++++++++++-------------
 fs/ksmbd/server.c     |  8 +++++++-
 4 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index ce23cc89046e..756ad631c019 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -66,6 +66,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	conn->outstanding_credits = 0;
 
 	init_waitqueue_head(&conn->req_running_q);
+	init_waitqueue_head(&conn->r_count_q);
 	INIT_LIST_HEAD(&conn->conns_list);
 	INIT_LIST_HEAD(&conn->requests);
 	INIT_LIST_HEAD(&conn->async_requests);
@@ -165,7 +166,6 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 	struct kvec iov[3];
 	int iov_idx = 0;
 
-	ksmbd_conn_try_dequeue_request(work);
 	if (!work->response_buf) {
 		pr_err("NULL response header\n");
 		return -EINVAL;
@@ -347,8 +347,8 @@ int ksmbd_conn_handler_loop(void *p)
 
 out:
 	/* Wait till all reference dropped to the Server object*/
-	while (atomic_read(&conn->r_count) > 0)
-		schedule_timeout(HZ);
+	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
+
 
 	unload_nls(conn->local_nls);
 	if (default_conn_ops.terminate_fn)
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 5b39f0bdeff8..2e4730457c92 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -65,6 +65,7 @@ struct ksmbd_conn {
 	unsigned int			outstanding_credits;
 	spinlock_t			credits_lock;
 	wait_queue_head_t		req_running_q;
+	wait_queue_head_t		r_count_q;
 	/* Lock to protect requests list*/
 	spinlock_t			request_lock;
 	struct list_head		requests;
diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 8b5560574d4c..3ef33ed4cdba 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -615,18 +615,13 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 	struct ksmbd_file *fp;
 
 	fp = ksmbd_lookup_durable_fd(br_info->fid);
-	if (!fp) {
-		atomic_dec(&conn->r_count);
-		ksmbd_free_work_struct(work);
-		return;
-	}
+	if (!fp)
+		goto out;
 
 	if (allocate_oplock_break_buf(work)) {
 		pr_err("smb2_allocate_rsp_buf failed! ");
-		atomic_dec(&conn->r_count);
 		ksmbd_fd_put(work, fp);
-		ksmbd_free_work_struct(work);
-		return;
+		goto out;
 	}
 
 	rsp_hdr = smb2_get_msg(work->response_buf);
@@ -667,8 +662,16 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 
 	ksmbd_fd_put(work, fp);
 	ksmbd_conn_write(work);
+
+out:
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	/*
+	 * Checking waitqueue to dropping pending requests on
+	 * disconnection. waitqueue_active is safe because it
+	 * uses atomic operation for condition.
+	 */
+	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
+		wake_up(&conn->r_count_q);
 }
 
 /**
@@ -731,9 +734,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 
 	if (allocate_oplock_break_buf(work)) {
 		ksmbd_debug(OPLOCK, "smb2_allocate_rsp_buf failed! ");
-		ksmbd_free_work_struct(work);
-		atomic_dec(&conn->r_count);
-		return;
+		goto out;
 	}
 
 	rsp_hdr = smb2_get_msg(work->response_buf);
@@ -771,8 +772,16 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 	inc_rfc1001_len(work->response_buf, 44);
 
 	ksmbd_conn_write(work);
+
+out:
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	/*
+	 * Checking waitqueue to dropping pending requests on
+	 * disconnection. waitqueue_active is safe because it
+	 * uses atomic operation for condition.
+	 */
+	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
+		wake_up(&conn->r_count_q);
 }
 
 /**
diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 4cd03d661df0..ce42bff42ef9 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -261,7 +261,13 @@ static void handle_ksmbd_work(struct work_struct *wk)
 
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	/*
+	 * Checking waitqueue to dropping pending requests on
+	 * disconnection. waitqueue_active is safe because it
+	 * uses atomic operation for condition.
+	 */
+	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
+		wake_up(&conn->r_count_q);
 }
 
 /**
-- 
2.25.1

