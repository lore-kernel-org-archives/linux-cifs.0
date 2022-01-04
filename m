Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAE5C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Jan 2022 05:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiADF4k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Jan 2022 00:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiADF4k (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Jan 2022 00:56:40 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D548C061761
        for <linux-cifs@vger.kernel.org>; Mon,  3 Jan 2022 21:56:39 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so2016115pji.3
        for <linux-cifs@vger.kernel.org>; Mon, 03 Jan 2022 21:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YBAFJm+TfHYyB8SjY70pll+U0BcD4NTjg5erCl1fGAo=;
        b=AMru2BUKDyVUPz0KJIdNhp2xXjRB3N8aPd/S7fUjKPT6rq7DJ+cxVat0LEj/Z5GNB+
         qwhGx/e9EhaSf4vVZCxcdiELaAgQhT2e1sm5xCQRqdscfHuuKo9UbhuXgY23ulOkXDDA
         Ic5ZdrS+oHVBbwGy9hNHTSPkF1ppiKBi1dJ37aSh/9ecgYKnH1ByhO9vCCi/cnBBDcBE
         D8TXwRV9DEu4iZF1POODSawTe6ffv5Zlu33LtmpZ7eNVxdqZGHB3hTjdGggVlu3qcict
         keM6d9X6yLB0iIvhm8FGtiCjB7Mlj5d8+1X1SkXh/kjxQOoE0BN6uewN4XIQ32sBx10q
         mZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YBAFJm+TfHYyB8SjY70pll+U0BcD4NTjg5erCl1fGAo=;
        b=3yBiZyaEyMrwvhn5LfNoU/r8r+WEaXglWk24cl1zMS3S5jK/Y+uuCW3fiFe5QIrdw5
         cZOfncYW2k3jNB9WRLM8mlWP4LGR+al4GxCh6j7MiHZrW5Kp9mhQzmjWp6Vh470lFc78
         /b6dGP0SwFns3ExLILFRUfOye/ka+LOb/90EYXzwt9l9JbeW8IHQaiU8M9SCXSenHhvy
         5aCNWE7TzFt9e7cxYfpuyZazIsRBlXE+sOJr1RZx5mylZRB3XXn/ejd7wlqCJPxscCJc
         5uqYur7N9Td6GrqnR+s87/eJHKYa6PpUuYn8FY0G8aVxxMGIgEo0x9IiEn45mBlGpmpR
         TGUw==
X-Gm-Message-State: AOAM530MNo7E4orBGLdmRbhCBeSWChIF2yM9lFXqHvOC1ZkEQic4Ml7h
        5yFkpW75EWh+7Lj/DHEzAq7iDhFk7cc=
X-Google-Smtp-Source: ABdhPJx59hp98Ty03K49/XYpnkjk2vxoRHax1nS/GsX0Aaz03X0c6RUbYaIAQbFswcA8IuyPIETq6A==
X-Received: by 2002:a17:902:8549:b0:149:64f4:bd0a with SMTP id d9-20020a170902854900b0014964f4bd0amr43451946plo.74.1641275798861;
        Mon, 03 Jan 2022 21:56:38 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id e3sm328878pgm.51.2022.01.03.21.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 21:56:38 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2] ksmbd: smbd: call rdma_accept() under CM handler
Date:   Tue,  4 Jan 2022 14:56:26 +0900
Message-Id: <20220104055626.295912-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

if CONFIG_LOCKDEP is enabled, the following
kernel warning message is generated because
rdma_accept() checks whehter the handler_mutex
is held by lockdep_assert_held. CM(Connection
Manager) holds the mutex before CM handler
callback is called.

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
Changes from v1:
 - Add why the kernel warning is generated into the commit description.
 - Use goto statement to free memory and return in
   smb_direct_handle_connect_request().

 fs/ksmbd/transport_rdma.c | 102 ++++++++++++++++++++++----------------
 1 file changed, 59 insertions(+), 43 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index f89b64e27836..0fd706d01790 100644
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
@@ -1945,18 +1956,23 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
 	if (!t)
 		return -ENOMEM;
 
+	ret = smb_direct_connect(t);
+	if (ret)
+		goto out_err;
+
 	KSMBD_TRANS(t)->handler = kthread_run(ksmbd_conn_handler_loop,
 					      KSMBD_TRANS(t)->conn, "ksmbd:r%u",
 					      smb_direct_port);
 	if (IS_ERR(KSMBD_TRANS(t)->handler)) {
-		int ret = PTR_ERR(KSMBD_TRANS(t)->handler);
-
+		ret = PTR_ERR(KSMBD_TRANS(t)->handler);
 		pr_err("Can't start thread\n");
-		free_transport(t);
-		return ret;
+		goto out_err;
 	}
 
 	return 0;
+out_err:
+	free_transport(t);
+	return ret;
 }
 
 static int smb_direct_listen_handler(struct rdma_cm_id *cm_id,
-- 
2.25.1

