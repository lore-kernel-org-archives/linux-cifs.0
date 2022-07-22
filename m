Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA035C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 03:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiGVDES (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jul 2022 23:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiGVDEP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Jul 2022 23:04:15 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AFA8E6D9
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:14 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id x24-20020a17090ab01800b001f21556cf48so7017850pjq.4
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=grNeLWtZYFJ3RkLxog/1pkXE7UjKVu+BnE1fSU9oTdM=;
        b=66tyiHUhisi/w0VaBJG6Ui4xoHhUSh1EQRTcCgBSLXX32jkc+cITHXWFJkVb8nc8Kj
         g2uSQ+F39AY8AqlR3ddrgzE3nMc6M7PCAf3A15R48hOHjBi5OTcB7Fj61GSJ+Zl7Yjl1
         pvqqq7okygdd2TGI63xVhW+eJhmhY4xuamGe5V56eJItlFyQQMRhO/bytJqXUJLSnsnB
         e4tLWNqAH/It6t+rOG2Er/IYd3+T9aYeZsv7oF7GsThYhHxzxfesI/btxJkMNXWjLxn1
         qtefZIhYWmLeM4KYeZRLO0Jc2Uhns7hrpkOzrlICelCB7P//4wDrFO5tLOUwio1bTir1
         0GIA==
X-Gm-Message-State: AJIora/OWplwwV2cDYFdyU87GWlGo9tpOW8K5Zawv4iqHzLjasptikJv
        00bggHDJVzpUOAc1OlZsZTjc9MYHTgc=
X-Google-Smtp-Source: AGRyM1tGQ7CH6p2cBMX4Co1dLDaC5uoB9ksz/i0FKQ5fgrhOBlHjTCJnJgRNK9uPj34q4P7T+lP6IA==
X-Received: by 2002:a17:90b:1c85:b0:1f1:d78a:512b with SMTP id oo5-20020a17090b1c8500b001f1d78a512bmr14798265pjb.92.1658459053627;
        Thu, 21 Jul 2022 20:04:13 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090a1d0a00b001f216407204sm2115450pjd.36.2022.07.21.20.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 20:04:12 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/5] ksmbd: use wait_event instead of schedule_timeout()
Date:   Fri, 22 Jul 2022 12:03:45 +0900
Message-Id: <20220722030346.28534-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722030346.28534-1-linkinjeon@kernel.org>
References: <20220722030346.28534-1-linkinjeon@kernel.org>
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
---
 fs/ksmbd/connection.c |  6 +++---
 fs/ksmbd/connection.h |  1 +
 fs/ksmbd/oplock.c     | 21 ++++++++++-----------
 fs/ksmbd/server.c     |  1 +
 4 files changed, 15 insertions(+), 14 deletions(-)

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
index 8b5560574d4c..9bb4fb8b80de 100644
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
@@ -667,8 +662,11 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 
 	ksmbd_fd_put(work, fp);
 	ksmbd_conn_write(work);
+
+out:
 	ksmbd_free_work_struct(work);
 	atomic_dec(&conn->r_count);
+	wake_up_all(&conn->r_count_q);
 }
 
 /**
@@ -731,9 +729,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 
 	if (allocate_oplock_break_buf(work)) {
 		ksmbd_debug(OPLOCK, "smb2_allocate_rsp_buf failed! ");
-		ksmbd_free_work_struct(work);
-		atomic_dec(&conn->r_count);
-		return;
+		goto out;
 	}
 
 	rsp_hdr = smb2_get_msg(work->response_buf);
@@ -771,8 +767,11 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 	inc_rfc1001_len(work->response_buf, 44);
 
 	ksmbd_conn_write(work);
+
+out:
 	ksmbd_free_work_struct(work);
 	atomic_dec(&conn->r_count);
+	wake_up_all(&conn->r_count_q);
 }
 
 /**
diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 4cd03d661df0..dfddc8dc1919 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -262,6 +262,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
 	atomic_dec(&conn->r_count);
+	wake_up_all(&conn->r_count_q);
 }
 
 /**
-- 
2.25.1

