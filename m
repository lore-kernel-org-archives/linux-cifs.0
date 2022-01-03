Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D32C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jan 2022 00:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiACACT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiACACS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Jan 2022 19:02:18 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A85AC061761
        for <linux-cifs@vger.kernel.org>; Sun,  2 Jan 2022 16:02:18 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so30854703pjw.2
        for <linux-cifs@vger.kernel.org>; Sun, 02 Jan 2022 16:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D6xzh87jWP7HxHY1WUkEOGulXznYwFDs2IqD0hZSBPs=;
        b=MQyClDSLgTFI9RKGvvICO1M2UgGqj6pXAE8RnUgpkjVr4z+HM7/12zv9+2cNDLhOML
         psW69+Qa8xSPcU7AfQ5K7QjDTGNjFDpnTZmcNsX/zOgoREo9GLbW6Vm8hqovt7xMvoWY
         3zHA8/Sh0NFW6UVj5kavo1cQZ0i1/TGdakcx3aUPzJEtYlQgy7ALQSXQGnXOt3JeoHFI
         NaHaLlLLM8GOXgY2srB0garIE2zASUsi/6Zjm87Oq1KXBPVixMyuoWc0UTJsexcqWrsl
         lFJh0JbxDuxmzOTxnTF6LXEQZmCqPf5vFz004ZvcXUAm0RxGCHSYjjOxyl4F9xhVEmhj
         RTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D6xzh87jWP7HxHY1WUkEOGulXznYwFDs2IqD0hZSBPs=;
        b=puSdo3FRwCbevjLXj1CjJzpadSaZmBBYNQytmf1Vxzs94CqSVLfx3jCqIZToFVBTEk
         vGql+b1DmMYxUs8Kn6ysJ1pt/g+9RcOke4rXBh2DjqLhaxBMQRdhTnmkM69cduwSgSfw
         wcgnPfV5c/Oy3igYfNBKKIwopnDSeRaMuVZBw0WQtSCqhGQZeFMk40em+1hLKkr6rxZC
         WZU6K5dT/prMBoHFyfCez3LmUL8VjS0wlbifJxFjlhFx6DJONczZc4pOiI3yME2wc80r
         wGwEf7UZ6ARcEv1MCzSYmu903okeVyHfVIphHiNbxNYJkXi90WjhbEsr9DufXMuJ4tT2
         mS5A==
X-Gm-Message-State: AOAM530KvFO8aEPhk/7zvE2r2+B2g/kdTElKe6+HiEiFG9nJmcezhENv
        LgMisMkdvpeu8lj9kCZNXMB/h0eu2Ww=
X-Google-Smtp-Source: ABdhPJwR1i/fXpN6/Z9i5A0x139l3Kq1sXTWlytReIUmIslh/7lzO5mhZYjjfMeavL7jZWg6/PPemw==
X-Received: by 2002:a17:90b:3e8b:: with SMTP id rj11mr53222049pjb.237.1641168137401;
        Sun, 02 Jan 2022 16:02:17 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id b11sm30863437pge.84.2022.01.02.16.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 16:02:17 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: smbd: call rdma_accept() under CM handler
Date:   Mon,  3 Jan 2022 09:02:03 +0900
Message-Id: <20220103000203.201107-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

if CONFIG_LOCKDEP is enabled, the following
kernel warning message is generated because
rdma_accept() is called not under CM(Connection
Manager) handler.

[   63.211405 ] WARNING: CPU: 1 PID: 345 at drivers/infiniband/core/cma.c:4405 rdma_accept+0x17a/0x350
[   63.212080 ] RIP: 0010:rdma_accept+0x17a/0x350
...
[   63.214036 ] Call Trace:
[   63.214098 ]  <TASK>
[   63.214185 ]  smb_direct_accept_client+0xb4/0x170 [ksmbd]
[   63.214412 ]  smb_direct_prepare+0x322/0x8c0 [ksmbd]
[   63.214555 ]  ? rcu_read_lock_sched_held+0x3a/0x70
[   63.214700 ]  ksmbd_conn_handler_loop+0x63/0x270 [ksmbd]
[   63.214826 ]  ? ksmbd_conn_alive+0x80/0x80 [ksmbd]
[   63.214952 ]  kthread+0x171/0x1a0
[   63.215039 ]  ? set_kthread_struct+0x40/0x40
[   63.215128 ]  ret_from_fork+0x22/0x30

To avoid this, move creating a queue pair and accepting
a client from transport_ops->prepare() to
smb_direct_handle_connect_request().

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/transport_rdma.c | 97 +++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 40 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index f89b64e27836..b37e4b9580ae 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -568,6 +568,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 		t->negotiation_requested = true;
 		t->full_packet_received = true;
+		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
 		break;
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
@@ -1594,19 +1595,13 @@ static int smb_direct_accept_client(struct smb_direct_transport *t)
 		pr_err("error at rdma_accept: %d\n", ret);
 		return ret;
 	}
-
-	wait_event_interruptible(t->wait_status,
-				 t->status != SMB_DIRECT_CS_NEW);
-	if (t->status != SMB_DIRECT_CS_CONNECTED)
-		return -ENOTCONN;
 	return 0;
 }
 
-static int smb_direct_negotiate(struct smb_direct_transport *t)
+static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 {
 	int ret;
 	struct smb_direct_recvmsg *recvmsg;
-	struct smb_direct_negotiate_req *req;
 
 	recvmsg = get_free_recvmsg(t);
 	if (!recvmsg)
@@ -1616,44 +1611,20 @@ static int smb_direct_negotiate(struct smb_direct_transport *t)
 	ret = smb_direct_post_recv(t, recvmsg);
 	if (ret) {
 		pr_err("Can't post recv: %d\n", ret);
-		goto out;
+		goto out_err;
 	}
 
 	t->negotiation_requested = false;
 	ret = smb_direct_accept_client(t);
 	if (ret) {
 		pr_err("Can't accept client\n");
-		goto out;
+		goto out_err;
 	}
 
 	smb_direct_post_recv_credits(&t->post_recv_credits_work.work);
-
-	ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
-	ret = wait_event_interruptible_timeout(t->wait_status,
-					       t->negotiation_requested ||
-						t->status == SMB_DIRECT_CS_DISCONNECTED,
-					       SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
-	if (ret <= 0 || t->status == SMB_DIRECT_CS_DISCONNECTED) {
-		ret = ret < 0 ? ret : -ETIMEDOUT;
-		goto out;
-	}
-
-	ret = smb_direct_check_recvmsg(recvmsg);
-	if (ret == -ECONNABORTED)
-		goto out;
-
-	req = (struct smb_direct_negotiate_req *)recvmsg->packet;
-	t->max_recv_size = min_t(int, t->max_recv_size,
-				 le32_to_cpu(req->preferred_send_size));
-	t->max_send_size = min_t(int, t->max_send_size,
-				 le32_to_cpu(req->max_receive_size));
-	t->max_fragmented_send_size =
-			le32_to_cpu(req->max_fragmented_size);
-
-	ret = smb_direct_send_negotiate_response(t, ret);
-out:
-	if (recvmsg)
-		put_recvmsg(t, recvmsg);
+	return 0;
+out_err:
+	put_recvmsg(t, recvmsg);
 	return ret;
 }
 
@@ -1890,6 +1861,47 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 static int smb_direct_prepare(struct ksmbd_transport *t)
 {
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
+	struct smb_direct_recvmsg *recvmsg;
+	struct smb_direct_negotiate_req *req;
+	int ret;
+
+	ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
+	ret = wait_event_interruptible_timeout(st->wait_status,
+					       st->negotiation_requested ||
+					       st->status == SMB_DIRECT_CS_DISCONNECTED,
+					       SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
+	if (ret <= 0 || st->status == SMB_DIRECT_CS_DISCONNECTED)
+		return ret < 0 ? ret : -ETIMEDOUT;
+
+	recvmsg = get_first_reassembly(st);
+	if (!recvmsg)
+		return -ECONNABORTED;
+
+	ret = smb_direct_check_recvmsg(recvmsg);
+	if (ret == -ECONNABORTED)
+		goto out;
+
+	req = (struct smb_direct_negotiate_req *)recvmsg->packet;
+	st->max_recv_size = min_t(int, st->max_recv_size,
+				  le32_to_cpu(req->preferred_send_size));
+	st->max_send_size = min_t(int, st->max_send_size,
+				  le32_to_cpu(req->max_receive_size));
+	st->max_fragmented_send_size =
+			le32_to_cpu(req->max_fragmented_size);
+
+	ret = smb_direct_send_negotiate_response(st, ret);
+out:
+	spin_lock_irq(&st->reassembly_queue_lock);
+	st->reassembly_queue_length--;
+	list_del(&recvmsg->list);
+	spin_unlock_irq(&st->reassembly_queue_lock);
+	put_recvmsg(st, recvmsg);
+
+	return ret;
+}
+
+static int smb_direct_connect(struct smb_direct_transport *st)
+{
 	int ret;
 	struct ib_qp_cap qp_cap;
 
@@ -1911,13 +1923,11 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 		return ret;
 	}
 
-	ret = smb_direct_negotiate(st);
+	ret = smb_direct_prepare_negotiation(st);
 	if (ret) {
 		pr_err("Can't negotiate: %d\n", ret);
 		return ret;
 	}
-
-	st->status = SMB_DIRECT_CS_CONNECTED;
 	return 0;
 }
 
@@ -1933,6 +1943,7 @@ static bool rdma_frwr_is_supported(struct ib_device_attr *attrs)
 static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
 {
 	struct smb_direct_transport *t;
+	int ret;
 
 	if (!rdma_frwr_is_supported(&new_cm_id->device->attrs)) {
 		ksmbd_debug(RDMA,
@@ -1945,11 +1956,17 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
 	if (!t)
 		return -ENOMEM;
 
+	ret = smb_direct_connect(t);
+	if (ret) {
+		free_transport(t);
+		return ret;
+	}
+
 	KSMBD_TRANS(t)->handler = kthread_run(ksmbd_conn_handler_loop,
 					      KSMBD_TRANS(t)->conn, "ksmbd:r%u",
 					      smb_direct_port);
 	if (IS_ERR(KSMBD_TRANS(t)->handler)) {
-		int ret = PTR_ERR(KSMBD_TRANS(t)->handler);
+		ret = PTR_ERR(KSMBD_TRANS(t)->handler);
 
 		pr_err("Can't start thread\n");
 		free_transport(t);
-- 
2.25.1

