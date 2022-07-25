Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0FEC43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 04:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiGYEms (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 00:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiGYEmr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 00:42:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16928DFA9
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 21:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92E6761009
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 04:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B48C385A2
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 04:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658724165;
        bh=d8tiSRfFSbPPvT58x+A1j7rby6fEdN/7hRA48rxy6rs=;
        h=From:Date:Subject:To:Cc:From;
        b=SfzUQPUW34p98WeNNrUrDY6U+qM/YDFxkUfEp79nOTAIbGGHEAGp1n//yOau7EWru
         tVFdfriWn7QX0BPTRyn7N/PvZGK1ZQr+Q38C057YTvk5nngIQrTmRhEZVhmDaKomi1
         gmrvvgj6g0iF6J17FO9X6WY+fQ0d+zciYzm1+aRTw18J91dcaw0S9lOsLVtKlZu7Ld
         oGW+279BMrYJW/TGlO8gw202CenCIutrxdrD3q46vHD6oNLQrfOqmDXEP/mWTNCVHG
         rm6pcdy6k8UWaqlOyc2VhdAtc0Cy5a54P8lfcaaV853kWyZIL8L/h6Kz0sqMOecBqK
         QfhJVO3YgmVfg==
Received: by mail-wr1-f53.google.com with SMTP id bn9so3393397wrb.9
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 21:42:45 -0700 (PDT)
X-Gm-Message-State: AJIora9WdpRaWv9YSHXSnglCeYr+lUHgn4SevnW1dc75TGjJWGW4aKFL
        Rf+YmpsoWm8YbKp/8AsRkF6FuE1lcophFdnVD4E=
X-Google-Smtp-Source: AGRyM1sl6HXng8UyzVmTp50GKDpWZ4fF3PfgEkFP6c7nMB8hW5Kv4cs3IoxB09K14/qPfA6mqVzJatGjECDdl53MLgM=
X-Received: by 2002:a5d:65cd:0:b0:21e:6e3b:b1a8 with SMTP id
 e13-20020a5d65cd000000b0021e6e3bb1a8mr5663708wrw.470.1658724164125; Sun, 24
 Jul 2022 21:42:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:644a:0:0:0:0:0 with HTTP; Sun, 24 Jul 2022 21:42:43
 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 25 Jul 2022 13:42:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8HGh0Bp0JUezSGTxCeDAd__Ops7yQZ8HdB3AXZKT21zQ@mail.gmail.com>
Message-ID: <CAKYAXd8HGh0Bp0JUezSGTxCeDAd__Ops7yQZ8HdB3AXZKT21zQ@mail.gmail.com>
Subject: [PATCH v2 1/2] ksmbd: use wait_event instead of schedule_timeout()
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
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
 v2:
   - When r_count is zero, call wake_up event.

 fs/ksmbd/connection.c |  6 +++---
 fs/ksmbd/connection.h |  1 +
 fs/ksmbd/oplock.c     | 25 ++++++++++++-------------
 fs/ksmbd/server.c     |  3 ++-
 4 files changed, 18 insertions(+), 17 deletions(-)

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
index 8b5560574d4c..7bd019ea628f 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -615,18 +615,13 @@ static void __smb2_oplock_break_noti(struct
work_struct *wk)
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
@@ -667,8 +662,11 @@ static void __smb2_oplock_break_noti(struct
work_struct *wk)

 	ksmbd_fd_put(work, fp);
 	ksmbd_conn_write(work);
+
+out:
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	if (atomic_dec_return(&conn->r_count) == 0)
+		wake_up_all(&conn->r_count_q);
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
-	atomic_dec(&conn->r_count);
+	if (atomic_dec_return(&conn->r_count) == 0)
+		wake_up_all(&conn->r_count_q);
 }

 /**
diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 4cd03d661df0..4a122412eff8 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -261,7 +261,8 @@ static void handle_ksmbd_work(struct work_struct *wk)

 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	if (atomic_dec_return(&conn->r_count) == 0)
+		wake_up_all(&conn->r_count_q);
 }

 /**
-- 
2.34.1
