Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C4EC4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 09:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiL2JlI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 04:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiL2JjD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 04:39:03 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D26013CC6
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 01:38:58 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id o2so13160952pjh.4
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 01:38:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jPML/DA9q7748AhCrZhoOSPcu029DLJ6kFfIc0XDj3k=;
        b=yJZ7VenAehgG+z23PrN3VtC+rPLO5cMceZiTfJ8BeHRHJ6lOmyWveaRZh+aWv9TyYh
         9L9A1Wo+5pS97qumwyRULxGKzbGMRgILZms9YkImRB1fgsC+UoaF6Ek10gTPbuXcO1dB
         Pkyj4pP3t7oSyuCHKhRNAO/k5kX8NzjQiW3poRhLl6yGNc/pJwXXgUoGLrCebdQI8DsZ
         977hdhs1/c2EHx1G1EiZdxwAXdKOdpcgb1oCdN20dQPeQQNSZvcI/RYAynuO8OLyV6Fq
         Hq8ZKryZnSHr51ouV2DwCHiPwRnpohAsVj6v+9ezjNM4IXCQm5nuXz5OkQf5yrazBepX
         EYkw==
X-Gm-Message-State: AFqh2krGecCB+xA3q01ZOLj32pxnyM6+CHtwm4HYa2mj22xOdabIcHar
        sYp63XF/9FAHq9cS9zJ+MRePuOPOHOo=
X-Google-Smtp-Source: AMrXdXt+Y5xeJdy9TdBq35p2B97WzLd0szAVW9uxE5Y3vMMlFq069FPFgTe8pEi/fWO4aDKlwSy72A==
X-Received: by 2002:a17:902:e845:b0:188:fc0c:b736 with SMTP id t5-20020a170902e84500b00188fc0cb736mr67065580plg.67.1672306737457;
        Thu, 29 Dec 2022 01:38:57 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b00189847cd4acsm12411849pla.237.2022.12.29.01.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 01:38:57 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2] ksmbd: add max connections parameter
Date:   Thu, 29 Dec 2022 18:38:36 +0900
Message-Id: <20221229093836.7804-1-linkinjeon@kernel.org>
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
 v2:
   - use atomic_inc_return() to avoid racy issue.
   - change pr_info to pr_info_ratelimited() to avoid message flood. 

 fs/ksmbd/ksmbd_netlink.h |  3 ++-
 fs/ksmbd/server.h        |  1 +
 fs/ksmbd/transport_ipc.c |  3 +++
 fs/ksmbd/transport_tcp.c | 17 ++++++++++++++++-
 4 files changed, 22 insertions(+), 2 deletions(-)

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
index 63d55f543bd2..cec73dc765f4 100644
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
@@ -239,6 +243,15 @@ static int ksmbd_kthread_fn(void *p)
 			continue;
 		}
 
+		if (server_conf.max_connections &&
+		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
+			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",
+					    atomic_read(&active_num_conn));
+			atomic_dec(&active_num_conn);
+			sock_release(client_sk);
+			continue;
+		}
+
 		ksmbd_debug(CONN, "connect success: accepted new connection\n");
 		client_sk->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
 		client_sk->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
@@ -365,6 +378,8 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *iov,
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
 {
 	free_transport(TCP_TRANS(t));
+	if (server_conf.max_connections)
+		atomic_dec(&active_num_conn);
 }
 
 static void tcp_destroy_socket(struct socket *ksmbd_socket)
-- 
2.25.1

