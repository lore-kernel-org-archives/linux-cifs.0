Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7364E3314D2
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095650; cv=none; b=EmHVRyAhFZm5GPv0jiilQ0f0k9xCjhTSETfBaQOLS8cq+P7/nV2zH9I8VaDZCyN1FA0d9SOv/ygNowGGqDxl2ioYPTZFG1QUZhoDd6juIBZWyMocX2msxbsxbae1lH27Q23TGcgYkzu1f182sGtyzOIRCQuKwAgp684cT0WoaHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095650; c=relaxed/simple;
	bh=YsJexwlhrhuHMuPnkGwqbHB/It1ZSY82prm6ZR3sgh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzzOPikPf6GlqQuIQnOXgz68PzTMpBmg+sR2kJNToi/xMPtVQBVsSGoaU85t+FOO8iq0I1904gMy0CE1mq5qXbaxmuqOs+IgP2i3OjLVBbzoHUuwXcoQ+l1ftDJQ9u9Q3MfMZ87x92zAvuHXgdby1V7smC0LLknFd+EGtrj57hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=t7YjeSLX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="t7YjeSLX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=2T4zagamUmRlzQBs3/nTTGM5X6NAE9FT8RqWPDdJzaE=; b=t7YjeSLX6TZaxoYacxHad9Vn2M
	dIeq72KP4OgufwqINETwkmLeHilzmAbaPFbKXGTspaYuC621RBUWaeIc2Dz7MkbnDJzsD7lgCEQ4y
	fkUjdKyzSfi3hk76AlFQ2WQoGH6YURvlJ7wfzZUHHc2BLqNe9IKmvDCs3GrUFcgBWLsLmcK4gBTLR
	h9Xo+JbHIG2ApoZDID3UJN7pVS+kZw/1LsBuemk7PrBPtOLH0OYdM0Jm+ZUAAHiS8ZD1I1anVIY8j
	GFbJzfyYPSfDTcJmH/OEbEqdEKcJgCrurFostrBuP+dWpD8R57OZ+lYcTklSqC+Mtbulwy/owqkcw
	vMQwGrrCg5DWt4KAHfag5rNW1RlFnB2FpXehQPGPOW+QCYR9IlKQgZN9MihIJWuxwOkU+qtQrwXUC
	0dS9yzDLDhK+oZABENDRmUf3WSN1Vq1yT9fkRNqm1Znk0lkEHWq8I1yatk47oRbVYkRkkduF7A1tX
	HQRbDGcM++vQAe4wP+wwbBD4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxna-00FgCk-0H;
	Tue, 25 Nov 2025 18:30:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 143/145] smb: server: make use of smbdirect_socket_{listen,accept}()
Date: Tue, 25 Nov 2025 18:56:29 +0100
Message-ID: <375646a569cf92b48bfbb95508eb2fd003b0fd59.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We no longer need the custom rdma listener.

The code logic is very similar to transport_tcp.c now
using a kernel thread that loops over smbdirect_socket_accept().

This is the first step in the direction of using IPPROTO_SMBDIRECT
sockets in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 229 +++++++++++++++++----------------
 1 file changed, 116 insertions(+), 113 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 15559227ad69..54cf4456a4e9 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -75,7 +75,9 @@ struct smb_direct_device {
 };
 
 static struct smb_direct_listener {
-	struct rdma_cm_id	*cm_id;
+	struct task_struct	*thread;
+
+	struct smbdirect_socket *socket;
 } smb_direct_listener;
 
 struct smb_direct_transport {
@@ -169,46 +171,15 @@ unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt)
 	return sp->max_read_write_size;
 }
 
-static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
+static struct smb_direct_transport *alloc_transport(struct smbdirect_socket *sc)
 {
 	struct smb_direct_transport *t;
-	struct smbdirect_socket *sc;
-	struct smbdirect_socket_parameters init_params = {};
-	struct smbdirect_socket_parameters *sp;
 	struct ksmbd_conn *conn;
-	int ret;
-
-	/*
-	 * Create the initial parameters
-	 */
-	sp = &init_params;
-	sp->negotiate_timeout_msec = SMB_DIRECT_NEGOTIATE_TIMEOUT * 1000;
-	sp->initiator_depth = SMB_DIRECT_CM_INITIATOR_DEPTH;
-	sp->responder_resources = 1;
-	sp->recv_credit_max = smb_direct_receive_credit_max;
-	sp->send_credit_target = smb_direct_send_credit_target;
-	sp->max_send_size = smb_direct_max_send_size;
-	sp->max_fragmented_recv_size = smb_direct_max_fragmented_recv_size;
-	sp->max_recv_size = smb_direct_max_receive_size;
-	sp->max_read_write_size = smb_direct_max_read_write_size;
-	sp->keepalive_interval_msec = SMB_DIRECT_KEEPALIVE_SEND_INTERVAL * 1000;
-	sp->keepalive_timeout_msec = SMB_DIRECT_KEEPALIVE_RECV_TIMEOUT * 1000;
 
 	t = kzalloc(sizeof(*t), KSMBD_DEFAULT_GFP);
 	if (!t)
 		return NULL;
-	ret = smbdirect_socket_create_accepting(cm_id, &sc);
-	if (ret)
-		goto socket_create_failed;
-	smbdirect_socket_set_logging(sc, NULL,
-				     smb_direct_logging_needed,
-				     smb_direct_logging_vaprintf);
-	ret = smbdirect_socket_set_initial_parameters(sc, sp);
-	if (ret)
-		goto set_params_failed;
-	ret = smbdirect_socket_set_kernel_settings(sc, IB_POLL_WORKQUEUE, KSMBD_DEFAULT_GFP);
-	if (ret)
-		goto set_settings_failed;
+	t->socket = sc;
 
 	conn = ksmbd_conn_alloc();
 	if (!conn)
@@ -222,14 +193,9 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	KSMBD_TRANS(t)->conn = conn;
 	KSMBD_TRANS(t)->ops = &ksmbd_smb_direct_transport_ops;
 
-	t->socket = sc;
 	return t;
 
 conn_alloc_failed:
-set_settings_failed:
-set_params_failed:
-	smbdirect_socket_release(sc);
-socket_create_failed:
 	kfree(t);
 	return NULL;
 }
@@ -326,47 +292,17 @@ static void smb_direct_shutdown(struct ksmbd_transport *t)
 	smbdirect_socket_shutdown(sc);
 }
 
-static int smb_direct_prepare(struct ksmbd_transport *t)
-{
-	struct smb_direct_transport *st = SMBD_TRANS(t);
-	struct smbdirect_socket *sc = st->socket;
-	int ret;
-
-	ksmbd_debug(RDMA, "SMB_DIRECT Waiting for connection\n");
-	ret = smbdirect_connection_wait_for_connected(sc);
-	if (ret) {
-		ksmbd_debug(RDMA, "SMB_DIRECT connection failed %d => %s\n",
-			    ret, errname(ret));
-		return ret;
-	}
-
-	ksmbd_debug(RDMA, "SMB_DIRECT connection ready\n");
-	return 0;
-}
-
-static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
-					     struct rdma_cm_event *event)
+static int smb_direct_new_connection(struct smbdirect_socket *client_sc)
 {
 	struct smb_direct_transport *t;
-	struct smbdirect_socket *sc;
 	struct task_struct *handler;
 	int ret;
 
-	if (!smbdirect_frwr_is_supported(&new_cm_id->device->attrs)) {
-		ksmbd_debug(RDMA,
-			    "Fast Registration Work Requests is not supported. device capabilities=%llx\n",
-			    new_cm_id->device->attrs.device_cap_flags);
-		return -EPROTONOSUPPORT;
-	}
-
-	t = alloc_transport(new_cm_id);
-	if (!t)
+	t = alloc_transport(client_sc);
+	if (!t) {
+		smbdirect_socket_release(client_sc);
 		return -ENOMEM;
-	sc = t->socket;
-
-	ret = smbdirect_accept_connect_request(sc, &event->param.conn);
-	if (ret)
-		goto out_err;
+	}
 
 	handler = kthread_run(ksmbd_conn_handler_loop,
 			      KSMBD_TRANS(t)->conn, "ksmbd:r%u",
@@ -383,64 +319,134 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 	return ret;
 }
 
-static int smb_direct_listen_handler(struct rdma_cm_id *cm_id,
-				     struct rdma_cm_event *event)
+static int smb_direct_listener_kthread_fn(void *p)
 {
-	switch (event->event) {
-	case RDMA_CM_EVENT_CONNECT_REQUEST: {
-		int ret = smb_direct_handle_connect_request(cm_id, event);
+	struct smb_direct_listener *listener = (struct smb_direct_listener *)p;
+	struct smbdirect_socket *client_sc = NULL;
 
-		if (ret) {
-			pr_err("Can't create transport: %d\n", ret);
-			return ret;
-		}
+	while (!kthread_should_stop()) {
+		struct proto_accept_arg arg = { .err = -EINVAL, };
+		long timeo = MAX_SCHEDULE_TIMEOUT;
 
-		ksmbd_debug(RDMA, "Received connection request. cm_id=%p\n",
-			    cm_id);
-		break;
-	}
-	default:
-		pr_err("Unexpected listen event. cm_id=%p, event=%s (%d)\n",
-		       cm_id, rdma_event_msg(event->event), event->event);
-		break;
+		if (!listener->socket)
+			break;
+		client_sc = smbdirect_socket_accept(listener->socket, timeo, &arg);
+		if (!client_sc && arg.err == -EINVAL)
+			break;
+		if (!client_sc)
+			continue;
+
+		ksmbd_debug(CONN, "connect success: accepted new connection\n");
+		smb_direct_new_connection(client_sc);
 	}
+
+	ksmbd_debug(CONN, "releasing socket\n");
 	return 0;
 }
 
-static int smb_direct_listen(int port)
+static void smb_direct_listener_destroy(struct smb_direct_listener *listener)
 {
 	int ret;
-	struct rdma_cm_id *cm_id;
+
+	if (listener->socket)
+		smbdirect_socket_shutdown(listener->socket);
+
+	if (listener->thread) {
+		ret = kthread_stop(listener->thread);
+		if (ret)
+			pr_err("failed to stop forker thread\n");
+		listener->thread = NULL;
+	}
+
+	if (listener->socket) {
+		smbdirect_socket_release(listener->socket);
+		listener->socket = NULL;
+	}
+}
+
+static int smb_direct_listen(int port)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct task_struct *kthread;
 	struct sockaddr_in sin = {
 		.sin_family		= AF_INET,
 		.sin_addr.s_addr	= htonl(INADDR_ANY),
 		.sin_port		= htons(port),
 	};
+	struct smbdirect_socket_parameters init_params = {};
+	struct smbdirect_socket_parameters *sp;
+	struct smbdirect_socket *sc;
+	int ret;
 
-	cm_id = rdma_create_id(&init_net, smb_direct_listen_handler,
-			       &smb_direct_listener, RDMA_PS_TCP, IB_QPT_RC);
-	if (IS_ERR(cm_id)) {
-		pr_err("Can't create cm id: %ld\n", PTR_ERR(cm_id));
-		return PTR_ERR(cm_id);
+	ret = smbdirect_socket_create_kern(net, &sc);
+	if (ret) {
+		pr_err("smbdirect_socket_create_kern() failed: %d %s\n",
+		       ret, errname(ret));
+		return ret;
 	}
 
-	ret = rdma_bind_addr(cm_id, (struct sockaddr *)&sin);
+	/*
+	 * Create the initial parameters
+	 */
+	sp = &init_params;
+	sp->negotiate_timeout_msec = SMB_DIRECT_NEGOTIATE_TIMEOUT * 1000;
+	sp->initiator_depth = SMB_DIRECT_CM_INITIATOR_DEPTH;
+	sp->responder_resources = 1;
+	sp->recv_credit_max = smb_direct_receive_credit_max;
+	sp->send_credit_target = smb_direct_send_credit_target;
+	sp->max_send_size = smb_direct_max_send_size;
+	sp->max_fragmented_recv_size = smb_direct_max_fragmented_recv_size;
+	sp->max_recv_size = smb_direct_max_receive_size;
+	sp->max_read_write_size = smb_direct_max_read_write_size;
+	sp->keepalive_interval_msec = SMB_DIRECT_KEEPALIVE_SEND_INTERVAL * 1000;
+	sp->keepalive_timeout_msec = SMB_DIRECT_KEEPALIVE_RECV_TIMEOUT * 1000;
+
+	smbdirect_socket_set_logging(sc, NULL,
+				     smb_direct_logging_needed,
+				     smb_direct_logging_vaprintf);
+	ret = smbdirect_socket_set_initial_parameters(sc, sp);
+	if (ret) {
+		pr_err("Failed smbdirect_socket_set_initial_parameters(): %d %s\n",
+		       ret, errname(ret));
+		goto err;
+	}
+	ret = smbdirect_socket_set_kernel_settings(sc, IB_POLL_WORKQUEUE, KSMBD_DEFAULT_GFP);
 	if (ret) {
-		pr_err("Can't bind: %d\n", ret);
+		pr_err("Failed smbdirect_socket_set_kernel_settings(): %d %s\n",
+		       ret, errname(ret));
 		goto err;
 	}
 
-	smb_direct_listener.cm_id = cm_id;
+	ret = smbdirect_socket_bind(sc, (struct sockaddr *)&sin);
+	if (ret) {
+		pr_err("smbdirect_socket_bind() failed: %d %s\n",
+		       ret, errname(ret));
+		goto err;
+	}
 
-	ret = rdma_listen(cm_id, 10);
+	ret = smbdirect_socket_listen(sc, 10);
 	if (ret) {
-		pr_err("Can't listen: %d\n", ret);
+		pr_err("Port[%d] smbdirect_socket_listen() failed: %d %s\n",
+		       port, ret, errname(ret));
 		goto err;
 	}
+
+	smb_direct_listener.socket = sc;
+
+	kthread = kthread_run(smb_direct_listener_kthread_fn,
+			      &smb_direct_listener,
+			      "ksmbd-smbdirect-listener");
+	if (IS_ERR(kthread)) {
+		ret = PTR_ERR(kthread);
+		pr_err("Can't start ksmbd listen kthread: %d %s\n",
+		       ret, errname(ret));
+		goto err;
+	}
+
+	smb_direct_listener.thread = kthread;
 	return 0;
 err:
-	smb_direct_listener.cm_id = NULL;
-	rdma_destroy_id(cm_id);
+	smb_direct_listener_destroy(&smb_direct_listener);
 	return ret;
 }
 
@@ -494,7 +500,8 @@ int ksmbd_rdma_init(void)
 {
 	int ret;
 
-	smb_direct_listener.cm_id = NULL;
+	smb_direct_listener.socket = NULL;
+	smb_direct_listener.thread = NULL;
 
 	ret = ib_register_client(&smb_direct_ib_client);
 	if (ret) {
@@ -508,20 +515,17 @@ int ksmbd_rdma_init(void)
 		return ret;
 	}
 
-	ksmbd_debug(RDMA, "init RDMA listener. cm_id=%p\n",
-		    smb_direct_listener.cm_id);
+	ksmbd_debug(RDMA, "init RDMA listener\n");
 	return 0;
 }
 
 void ksmbd_rdma_stop_listening(void)
 {
-	if (!smb_direct_listener.cm_id)
+	if (!smb_direct_listener.socket)
 		return;
 
 	ib_unregister_client(&smb_direct_ib_client);
-	rdma_destroy_id(smb_direct_listener.cm_id);
-
-	smb_direct_listener.cm_id = NULL;
+	smb_direct_listener_destroy(&smb_direct_listener);
 }
 
 static bool ksmbd_find_rdma_capable_netdev(struct net_device *netdev)
@@ -589,7 +593,6 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 }
 
 static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
-	.prepare	= smb_direct_prepare,
 	.disconnect	= smb_direct_disconnect,
 	.shutdown	= smb_direct_shutdown,
 	.writev		= smb_direct_writev,
-- 
2.43.0

