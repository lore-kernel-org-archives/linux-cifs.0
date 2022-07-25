Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436BCC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 14:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiGYOoi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiGYOoi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 10:44:38 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F76B5F59
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 07:44:37 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so10485097pjf.2
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 07:44:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xua8LowJd7i1tGTvB7r94nWCoc9ca9VjWMmIA2XucjU=;
        b=pAb4yZamZvw1+nqjyPAdIDfKtsb82vAxFru9gT8mQ/Q1vIeWC8wKqDDCZ1dkuvJCBk
         loa2IawE9VY7vgkFXklb8AzzSa0sRHF6zlK5PplrX8XM0m/w18q75yDJ4ceu3z621DIw
         coxqtDCdXMmpPw//IdnmY7DYuty2Zf9hPxVvixzUZbfh1jDOqZ4NoSMtjZ5DE7udyopW
         emdx9xmMnEd/l5DZkPVjirijLBcD6OeCSVJsYDBtTsLOGuGPf6M8VMPAvQCUTs80HdiB
         dEZQirQG54laXFdFT/K8GYIxYGkqi88tMIK36cgZ8AtMjRx+lxCwOz2i07RbRvFT6wVE
         ahLQ==
X-Gm-Message-State: AJIora9MKjqkvkVrOj8LSJmq1uaiKdtsRHSSJPhmpL4zGNh2eapZgmmi
        n0bktEsqQ1WrEgEPYkDbFdRtT0xiCFY=
X-Google-Smtp-Source: AGRyM1sLF00fKNwd9hao3EuDiWxMQ+hiIePuISuRsDHcshvDYgjHJ+0wR+wZhWDS3ETwgKHcv+iwpw==
X-Received: by 2002:a17:902:ebcb:b0:168:e3ba:4b5a with SMTP id p11-20020a170902ebcb00b00168e3ba4b5amr12352848plg.11.1658760276202;
        Mon, 25 Jul 2022 07:44:36 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902654200b0016cf8f0bdd5sm9266281pln.108.2022.07.25.07.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:44:35 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [v3 PATCH] ksmbd: use wait_event instead of schedule_timeout()
Date:   Mon, 25 Jul 2022 23:43:41 +0900
Message-Id: <20220725144341.17914-1-linkinjeon@kernel.org>
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
   - call wake_up() if the wait list is not empty.

 fs/ksmbd/connection.c |  6 +++---
 fs/ksmbd/connection.h |  1 +
 fs/ksmbd/oplock.c     | 27 ++++++++++++++-------------
 fs/ksmbd/server.c     |  4 +++-
 4 files changed, 21 insertions(+), 17 deletions(-)

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
index 8b5560574d4c..242c6e03de6c 100644
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
@@ -667,8 +662,12 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 
 	ksmbd_fd_put(work, fp);
 	ksmbd_conn_write(work);
+
+out:
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	if (!atomic_dec_return(&conn->r_count) &&
+	    waitqueue_active(&conn->r_count_q))
+		wake_up_all(&conn->r_count_q);
 }
 
 /**
@@ -731,9 +730,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 
 	if (allocate_oplock_break_buf(work)) {
 		ksmbd_debug(OPLOCK, "smb2_allocate_rsp_buf failed! ");
-		ksmbd_free_work_struct(work);
-		atomic_dec(&conn->r_count);
-		return;
+		goto out;
 	}
 
 	rsp_hdr = smb2_get_msg(work->response_buf);
@@ -771,8 +768,12 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 	inc_rfc1001_len(work->response_buf, 44);
 
 	ksmbd_conn_write(work);
+
+out:
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	if (!atomic_dec_return(&conn->r_count) &&
+	    waitqueue_active(&conn->r_count_q))
+		wake_up_all(&conn->r_count_q);
 }
 
 /**
diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 4cd03d661df0..a612e24db367 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -261,7 +261,9 @@ static void handle_ksmbd_work(struct work_struct *wk)
 
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	if (!atomic_dec_return(&conn->r_count) &&
+	    waitqueue_active(&conn->r_count_q))
+		wake_up_all(&conn->r_count_q);
 }
 
 /**
-- 
2.25.1

