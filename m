Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D7FC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Dec 2022 15:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiL0PCD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Dec 2022 10:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiL0PCB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Dec 2022 10:02:01 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA862F6D
        for <linux-cifs@vger.kernel.org>; Tue, 27 Dec 2022 07:02:00 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id u4-20020a17090a518400b00223f7eba2c4so13429819pjh.5
        for <linux-cifs@vger.kernel.org>; Tue, 27 Dec 2022 07:02:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4gJ20N3Rbmsqog9geloTo37a9qnQot2o212KrS0oKE=;
        b=lBrh5nKTiqPAVDrz/2nEPVkiiXCbG0hvFWBoNQiUDjibbc5nYlj1YkgAOVrbw4oaSC
         GU17eU4fVhLJu/px5qF9UL8uuuHAejwLdrevLoXOYiRJpDTFC9Lqe7dEpny4dHhX8s2/
         MpGDFFmxoxxoYw1LKwrBppTKL0UWaIwFRM6YPlY5bjWEH8dUyYNYYpkqyjWSOt9oKXMY
         LeShmShz1gBJbl7G6+ewimC6vJEh1X2qNxii96vGU2G3G5cMDuIw0j/9Jp5aaINwy7QG
         9bkh7s28d6ZhiMtq7mBvWG6NMUUdIknvGEiSduR2UMCU/fjpMEC9K+5b2Tndt9VNvA9a
         cDdw==
X-Gm-Message-State: AFqh2kqRicX9V9O9Mf01motq0oPPUFCoiKaM+9mcyHYoxNONX9CYVEF9
        o7hfjeNGaNhhgQm7MC61Ok+P28QlyqA=
X-Google-Smtp-Source: AMrXdXs8KqtK4dAXkBvJ0upPt8j6tLzXSUIs/E08SoYJBwvag6udlbmBR8xzB36H7/D+XvWSF3t7WQ==
X-Received: by 2002:a05:6a20:e61a:b0:a9:f48e:aea0 with SMTP id my26-20020a056a20e61a00b000a9f48eaea0mr47751621pzb.9.1672153319872;
        Tue, 27 Dec 2022 07:01:59 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id 32-20020a631060000000b0046feca0883fsm7858815pgq.64.2022.12.27.07.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 07:01:59 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add max connections parameter
Date:   Tue, 27 Dec 2022 23:59:54 +0900
Message-Id: <20221227145954.9663-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add max connections parameter to limit number of maximum simultaneous
connections.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/ksmbd_netlink.h |  3 ++-
 fs/ksmbd/server.h        |  1 +
 fs/ksmbd/transport_ipc.c |  3 +++
 fs/ksmbd/transport_tcp.c | 19 ++++++++++++++++++-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index b6bd8311e6b4..fb8b2d566efb 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -106,7 +106,8 @@ struct ksmbd_startup_request {
 	__u32	sub_auth[3];		/* Subauth value for Security ID */
 	__u32	smb2_max_credits;	/* MAX credits */
 	__u32	smbd_max_io_size;	/* smbd read write size */
-	__u32	reserved[127];		/* Reserved room */
+	__u32	max_connections;	/* Number of maximum simultaneous connections */
+	__u32	reserved[126];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 };
diff --git a/fs/ksmbd/server.h b/fs/ksmbd/server.h
index ac9d932f8c8a..db7278181760 100644
--- a/fs/ksmbd/server.h
+++ b/fs/ksmbd/server.h
@@ -41,6 +41,7 @@ struct ksmbd_server_config {
 	unsigned int		share_fake_fscaps;
 	struct smb_sid		domain_sid;
 	unsigned int		auth_mechs;
+	unsigned int		max_connections;
 
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
 };
diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index c9aca21637d5..40c721f9227e 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -308,6 +308,9 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 	if (req->smbd_max_io_size)
 		init_smbd_max_io_size(req->smbd_max_io_size);
 
+	if (req->max_connections)
+		server_conf.max_connections = req->max_connections;
+
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
 	ret |= ksmbd_set_work_group(req->work_group);
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 63d55f543bd2..c60f7b8b22fe 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -15,6 +15,8 @@
 #define IFACE_STATE_DOWN		BIT(0)
 #define IFACE_STATE_CONFIGURED		BIT(1)
 
+static atomic_t active_num_conn;
+
 struct interface {
 	struct task_struct	*ksmbd_kthread;
 	struct socket		*ksmbd_socket;
@@ -185,8 +187,10 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
 	struct tcp_transport *t;
 
 	t = alloc_transport(client_sk);
-	if (!t)
+	if (!t) {
+		sock_release(client_sk);
 		return -ENOMEM;
+	}
 
 	csin = KSMBD_TCP_PEER_SOCKADDR(KSMBD_TRANS(t)->conn);
 	if (kernel_getpeername(client_sk, csin) < 0) {
@@ -239,6 +243,17 @@ static int ksmbd_kthread_fn(void *p)
 			continue;
 		}
 
+		if (server_conf.max_connections) {
+			if (atomic_read(&active_num_conn) >= server_conf.max_connections) {
+				pr_info("Limit the maximum number of connections(%u)\n",
+						atomic_read(&active_num_conn));
+				sock_release(client_sk);
+				continue;
+			}
+
+			atomic_inc(&active_num_conn);
+		}
+
 		ksmbd_debug(CONN, "connect success: accepted new connection\n");
 		client_sk->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
 		client_sk->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
@@ -365,6 +380,8 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *iov,
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
 {
 	free_transport(TCP_TRANS(t));
+	if (server_conf.max_connections)
+		atomic_dec(&active_num_conn);
 }
 
 static void tcp_destroy_socket(struct socket *ksmbd_socket)
-- 
2.25.1

