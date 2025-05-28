Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF0B244670
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448214; cv=none; b=pfLWqIWOSYH9vb5IkdJbdHzf4AkQrkwU6NS3kf2t8gBnVfK4zo55T36/ZPUobwXBG01wXkqtuHg6A9JCLVAYrawWAyxBNokQqfbdhcQd2OQMoTDnIL4rumPcl8dgZuhIrJ+aeuJ6oMQM/WGA4W1aYzGAvB8xqclhKfnESGo6uXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448214; c=relaxed/simple;
	bh=/ALAqFBvK3cWxEhEb8Dx8X1YYvHEp4k0ePvNxAz+TYw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ylz2+vCQ9TZ/IsYoXTK4WP9U8K9dZi6hQklom2rPI0t+DFfO/THa/XKWyJEWk6TVx5eakM5IylJ0MYn1ysDkurRiXFnkvfUUn0EXqwqaupa/UVe7+BgHafCAp12X4v1cdOqqh2QPotR3Oh/3QLD4GmG1nuiiO0H1J+exIBCbnQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MuUZYdZz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MuUZYdZz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=bSgUDazWITLvb2ljMIyza+Hfje1af9jR4GQ4eniAk28=; b=MuUZYdZzd9BcUR0erisqu9yHKj
	Kpv6a/27JxAaQyn6NvvUbor7kGvA9TyO45L0sQw+eHpFEIC5q2fAlrQ3rnvbhKT2IeagDBlB2FjP9
	/ESNwGwJEn33mFh2JSmYD52xo/oRuVjRN2k04ubFMBSdmkw2GctNCHMy96neSDFTe1fYpXVWTUUlS
	DVy3ug39kTRXYiTXcmPCBKDBwX9Q0RnhDhKh8IbeLjNJj1lGAjYaF8U+n2GBr5BmWM6iYi8+Gl3cA
	LcovamBhHBLt4R8DTE7xYBzNpCnFJ2cweCCxqxGNG1DqSoyT/AZjmEsXoR/DojNv3XUlE3S0D1FVW
	IYfGnbEebTZ05X7d1CAzBYBeRcd1j660mdon0/mSpIyQScuN10w7ns7aaEEZXyDLGZO938e/QR+NA
	msyjUjBIgZd8VORc+B3+I7vRpcreTUv6W8bghhO9rT/Z1cDhhXwhQY30avxG7Y6jFHJcGG7CbAhxG
	NvV+6G/mdS+eL3MI4kqK++vm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJFW-007hUZ-2I;
	Wed, 28 May 2025 16:03:26 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH v2 11/12] smb: client: make use of common smbdirect_socket_parameters
Date: Wed, 28 May 2025 18:01:40 +0200
Message-Id: <e7af7efe4aa05a6a0ab3340dcbfd32777a375737.1748446473.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748446473.git.metze@samba.org>
References: <cover.1748446473.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c | 21 +++++----
 fs/smb/client/smb2ops.c    | 14 ++++--
 fs/smb/client/smbdirect.c  | 91 ++++++++++++++++++++++----------------
 fs/smb/client/smbdirect.h  | 10 +----
 4 files changed, 77 insertions(+), 59 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 56b0b5c82dd1..c0196be0e65f 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -362,6 +362,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	c = 0;
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+#ifdef CONFIG_CIFS_SMB_DIRECT
+		struct smbdirect_socket_parameters *sp;
+#endif
+
 		/* channel info will be printed as a part of sessions below */
 		if (SERVER_IS_CHAN(server))
 			continue;
@@ -383,6 +387,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			seq_printf(m, "\nSMBDirect transport not available");
 			goto skip_rdma;
 		}
+		sp = &server->smbd_conn->socket.parameters;
 
 		seq_printf(m, "\nSMBDirect (in hex) protocol version: %x "
 			"transport status: %x",
@@ -390,18 +395,18 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			server->smbd_conn->socket.status);
 		seq_printf(m, "\nConn receive_credit_max: %x "
 			"send_credit_target: %x max_send_size: %x",
-			server->smbd_conn->receive_credit_max,
-			server->smbd_conn->send_credit_target,
-			server->smbd_conn->max_send_size);
+			sp->recv_credit_max,
+			sp->send_credit_target,
+			sp->max_send_size);
 		seq_printf(m, "\nConn max_fragmented_recv_size: %x "
 			"max_fragmented_send_size: %x max_receive_size:%x",
-			server->smbd_conn->max_fragmented_recv_size,
-			server->smbd_conn->max_fragmented_send_size,
-			server->smbd_conn->max_receive_size);
+			sp->max_fragmented_recv_size,
+			sp->max_fragmented_send_size,
+			sp->max_recv_size);
 		seq_printf(m, "\nConn keep_alive_interval: %x "
 			"max_readwrite_size: %x rdma_readwrite_threshold: %x",
-			server->smbd_conn->keep_alive_interval,
-			server->smbd_conn->max_readwrite_size,
+			sp->keepalive_interval_msec * 1000,
+			sp->max_read_write_size,
 			server->smbd_conn->rdma_readwrite_threshold);
 		seq_printf(m, "\nDebug count_get_receive_buffer: %x "
 			"count_put_receive_buffer: %x count_send_empty: %x",
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 2fe8eeb98535..8ee7b3dde12f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -504,6 +504,9 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	wsize = min_t(unsigned int, wsize, server->max_write);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
+		struct smbdirect_socket_parameters *sp =
+			&server->smbd_conn->socket.parameters;
+
 		if (server->sign)
 			/*
 			 * Account for SMB2 data transfer packet header and
@@ -511,12 +514,12 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 			 */
 			wsize = min_t(unsigned int,
 				wsize,
-				server->smbd_conn->max_fragmented_send_size -
+				sp->max_fragmented_send_size -
 					SMB2_READWRITE_PDU_HEADER_SIZE -
 					sizeof(struct smb2_transform_hdr));
 		else
 			wsize = min_t(unsigned int,
-				wsize, server->smbd_conn->max_readwrite_size);
+				wsize, sp->max_read_write_size);
 	}
 #endif
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
@@ -552,6 +555,9 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	rsize = min_t(unsigned int, rsize, server->max_read);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
+		struct smbdirect_socket_parameters *sp =
+			&server->smbd_conn->socket.parameters;
+
 		if (server->sign)
 			/*
 			 * Account for SMB2 data transfer packet header and
@@ -559,12 +565,12 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 			 */
 			rsize = min_t(unsigned int,
 				rsize,
-				server->smbd_conn->max_fragmented_recv_size -
+				sp->max_fragmented_recv_size -
 					SMB2_READWRITE_PDU_HEADER_SIZE -
 					sizeof(struct smb2_transform_hdr));
 		else
 			rsize = min_t(unsigned int,
-				rsize, server->smbd_conn->max_readwrite_size);
+				rsize, sp->max_read_write_size);
 	}
 #endif
 
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 608ecd2149ed..5ae847919da5 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -320,6 +320,8 @@ static bool process_negotiation_response(
 		struct smbd_response *response, int packet_length)
 {
 	struct smbd_connection *info = response->info;
+	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_negotiate_resp *packet = smbd_response_payload(response);
 
 	if (packet_length < sizeof(struct smbdirect_negotiate_resp)) {
@@ -349,20 +351,20 @@ static bool process_negotiation_response(
 
 	atomic_set(&info->receive_credits, 0);
 
-	if (le32_to_cpu(packet->preferred_send_size) > info->max_receive_size) {
+	if (le32_to_cpu(packet->preferred_send_size) > sp->max_recv_size) {
 		log_rdma_event(ERR, "error: preferred_send_size=%d\n",
 			le32_to_cpu(packet->preferred_send_size));
 		return false;
 	}
-	info->max_receive_size = le32_to_cpu(packet->preferred_send_size);
+	sp->max_recv_size = le32_to_cpu(packet->preferred_send_size);
 
 	if (le32_to_cpu(packet->max_receive_size) < SMBD_MIN_RECEIVE_SIZE) {
 		log_rdma_event(ERR, "error: max_receive_size=%d\n",
 			le32_to_cpu(packet->max_receive_size));
 		return false;
 	}
-	info->max_send_size = min_t(int, info->max_send_size,
-					le32_to_cpu(packet->max_receive_size));
+	sp->max_send_size = min_t(u32, sp->max_send_size,
+				  le32_to_cpu(packet->max_receive_size));
 
 	if (le32_to_cpu(packet->max_fragmented_size) <
 			SMBD_MIN_FRAGMENTED_SIZE) {
@@ -370,18 +372,18 @@ static bool process_negotiation_response(
 			le32_to_cpu(packet->max_fragmented_size));
 		return false;
 	}
-	info->max_fragmented_send_size =
+	sp->max_fragmented_send_size =
 		le32_to_cpu(packet->max_fragmented_size);
 	info->rdma_readwrite_threshold =
-		rdma_readwrite_threshold > info->max_fragmented_send_size ?
-		info->max_fragmented_send_size :
+		rdma_readwrite_threshold > sp->max_fragmented_send_size ?
+		sp->max_fragmented_send_size :
 		rdma_readwrite_threshold;
 
 
-	info->max_readwrite_size = min_t(u32,
+	sp->max_read_write_size = min_t(u32,
 			le32_to_cpu(packet->max_readwrite_size),
 			info->max_frmr_depth * PAGE_SIZE);
-	info->max_frmr_depth = info->max_readwrite_size / PAGE_SIZE;
+	info->max_frmr_depth = sp->max_read_write_size / PAGE_SIZE;
 
 	return true;
 }
@@ -689,6 +691,7 @@ static int smbd_ia_open(
 static int smbd_post_send_negotiate_req(struct smbd_connection *info)
 {
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_send_wr send_wr;
 	int rc = -ENOMEM;
 	struct smbd_request *request;
@@ -704,11 +707,11 @@ static int smbd_post_send_negotiate_req(struct smbd_connection *info)
 	packet->min_version = cpu_to_le16(SMBDIRECT_V1);
 	packet->max_version = cpu_to_le16(SMBDIRECT_V1);
 	packet->reserved = 0;
-	packet->credits_requested = cpu_to_le16(info->send_credit_target);
-	packet->preferred_send_size = cpu_to_le32(info->max_send_size);
-	packet->max_receive_size = cpu_to_le32(info->max_receive_size);
+	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
+	packet->preferred_send_size = cpu_to_le32(sp->max_send_size);
+	packet->max_receive_size = cpu_to_le32(sp->max_recv_size);
 	packet->max_fragmented_size =
-		cpu_to_le32(info->max_fragmented_recv_size);
+		cpu_to_le32(sp->max_fragmented_recv_size);
 
 	request->num_sge = 1;
 	request->sge[0].addr = ib_dma_map_single(
@@ -800,6 +803,7 @@ static int smbd_post_send(struct smbd_connection *info,
 		struct smbd_request *request)
 {
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_send_wr send_wr;
 	int rc, i;
 
@@ -831,7 +835,7 @@ static int smbd_post_send(struct smbd_connection *info,
 	} else
 		/* Reset timer for idle connection after packet is sent */
 		mod_delayed_work(info->workqueue, &info->idle_timer_work,
-			info->keep_alive_interval*HZ);
+			msecs_to_jiffies(sp->keepalive_interval_msec));
 
 	return rc;
 }
@@ -841,6 +845,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 			       int *_remaining_data_length)
 {
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int i, rc;
 	int header_length;
 	int data_length;
@@ -868,7 +873,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 
 wait_send_queue:
 	wait_event(info->wait_post_send,
-		atomic_read(&info->send_pending) < info->send_credit_target ||
+		atomic_read(&info->send_pending) < sp->send_credit_target ||
 		sc->status != SMBDIRECT_SOCKET_CONNECTED);
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
@@ -878,7 +883,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	}
 
 	if (unlikely(atomic_inc_return(&info->send_pending) >
-				info->send_credit_target)) {
+				sp->send_credit_target)) {
 		atomic_dec(&info->send_pending);
 		goto wait_send_queue;
 	}
@@ -917,7 +922,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 
 	/* Fill in the packet header */
 	packet = smbd_request_payload(request);
-	packet->credits_requested = cpu_to_le16(info->send_credit_target);
+	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
 
 	new_credits = manage_credits_prior_sending(info);
 	atomic_add(new_credits, &info->receive_credits);
@@ -1017,16 +1022,17 @@ static int smbd_post_recv(
 		struct smbd_connection *info, struct smbd_response *response)
 {
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_recv_wr recv_wr;
 	int rc = -EIO;
 
 	response->sge.addr = ib_dma_map_single(
 				sc->ib.dev, response->packet,
-				info->max_receive_size, DMA_FROM_DEVICE);
+				sp->max_recv_size, DMA_FROM_DEVICE);
 	if (ib_dma_mapping_error(sc->ib.dev, response->sge.addr))
 		return rc;
 
-	response->sge.length = info->max_receive_size;
+	response->sge.length = sp->max_recv_size;
 	response->sge.lkey = sc->ib.pd->local_dma_lkey;
 
 	response->cqe.done = recv_done;
@@ -1274,6 +1280,8 @@ static void idle_connection_timer(struct work_struct *work)
 	struct smbd_connection *info = container_of(
 					work, struct smbd_connection,
 					idle_timer_work.work);
+	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 
 	if (info->keep_alive_requested != KEEP_ALIVE_NONE) {
 		log_keep_alive(ERR,
@@ -1288,7 +1296,7 @@ static void idle_connection_timer(struct work_struct *work)
 
 	/* Setup the next idle timeout work */
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
-			info->keep_alive_interval*HZ);
+			msecs_to_jiffies(sp->keepalive_interval_msec));
 }
 
 /*
@@ -1300,6 +1308,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc;
+	struct smbdirect_socket_parameters *sp;
 	struct smbd_response *response;
 	unsigned long flags;
 
@@ -1308,6 +1317,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 		return;
 	}
 	sc = &info->socket;
+	sp = &sc->parameters;
 
 	log_rdma_event(INFO, "destroying rdma session\n");
 	if (sc->status != SMBDIRECT_SOCKET_DISCONNECTED) {
@@ -1349,7 +1359,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	log_rdma_event(INFO, "free receive buffers\n");
 	wait_event(info->wait_receive_queues,
 		info->count_receive_queue + info->count_empty_packet_queue
-			== info->receive_credit_max);
+			== sp->recv_credit_max);
 	destroy_receive_buffers(info);
 
 	/*
@@ -1437,6 +1447,8 @@ static void destroy_caches_and_workqueue(struct smbd_connection *info)
 #define MAX_NAME_LEN	80
 static int allocate_caches_and_workqueue(struct smbd_connection *info)
 {
+	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	char name[MAX_NAME_LEN];
 	int rc;
 
@@ -1451,7 +1463,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 		return -ENOMEM;
 
 	info->request_mempool =
-		mempool_create(info->send_credit_target, mempool_alloc_slab,
+		mempool_create(sp->send_credit_target, mempool_alloc_slab,
 			mempool_free_slab, info->request_cache);
 	if (!info->request_mempool)
 		goto out1;
@@ -1461,13 +1473,13 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 		kmem_cache_create(
 			name,
 			sizeof(struct smbd_response) +
-				info->max_receive_size,
+				sp->max_recv_size,
 			0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!info->response_cache)
 		goto out2;
 
 	info->response_mempool =
-		mempool_create(info->receive_credit_max, mempool_alloc_slab,
+		mempool_create(sp->recv_credit_max, mempool_alloc_slab,
 		       mempool_free_slab, info->response_cache);
 	if (!info->response_mempool)
 		goto out3;
@@ -1477,7 +1489,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 	if (!info->workqueue)
 		goto out4;
 
-	rc = allocate_receive_buffers(info, info->receive_credit_max);
+	rc = allocate_receive_buffers(info, sp->recv_credit_max);
 	if (rc) {
 		log_rdma_event(ERR, "failed to allocate receive buffers\n");
 		goto out5;
@@ -1505,6 +1517,7 @@ static struct smbd_connection *_smbd_get_connection(
 	int rc;
 	struct smbd_connection *info;
 	struct smbdirect_socket *sc;
+	struct smbdirect_socket_parameters *sp;
 	struct rdma_conn_param conn_param;
 	struct ib_qp_init_attr qp_attr;
 	struct sockaddr_in *addr_in = (struct sockaddr_in *) dstaddr;
@@ -1515,6 +1528,7 @@ static struct smbd_connection *_smbd_get_connection(
 	if (!info)
 		return NULL;
 	sc = &info->socket;
+	sp = &sc->parameters;
 
 	sc->status = SMBDIRECT_SOCKET_CONNECTING;
 	rc = smbd_ia_open(info, dstaddr, port);
@@ -1541,12 +1555,12 @@ static struct smbd_connection *_smbd_get_connection(
 		goto config_failed;
 	}
 
-	info->receive_credit_max = smbd_receive_credit_max;
-	info->send_credit_target = smbd_send_credit_target;
-	info->max_send_size = smbd_max_send_size;
-	info->max_fragmented_recv_size = smbd_max_fragmented_recv_size;
-	info->max_receive_size = smbd_max_receive_size;
-	info->keep_alive_interval = smbd_keep_alive_interval;
+	sp->recv_credit_max = smbd_receive_credit_max;
+	sp->send_credit_target = smbd_send_credit_target;
+	sp->max_send_size = smbd_max_send_size;
+	sp->max_fragmented_recv_size = smbd_max_fragmented_recv_size;
+	sp->max_recv_size = smbd_max_receive_size;
+	sp->keepalive_interval_msec = smbd_keep_alive_interval * 1000;
 
 	if (sc->ib.dev->attrs.max_send_sge < SMBDIRECT_MAX_SEND_SGE ||
 	    sc->ib.dev->attrs.max_recv_sge < SMBDIRECT_MAX_RECV_SGE) {
@@ -1561,7 +1575,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	sc->ib.send_cq =
 		ib_alloc_cq_any(sc->ib.dev, info,
-				info->send_credit_target, IB_POLL_SOFTIRQ);
+				sp->send_credit_target, IB_POLL_SOFTIRQ);
 	if (IS_ERR(sc->ib.send_cq)) {
 		sc->ib.send_cq = NULL;
 		goto alloc_cq_failed;
@@ -1569,7 +1583,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	sc->ib.recv_cq =
 		ib_alloc_cq_any(sc->ib.dev, info,
-				info->receive_credit_max, IB_POLL_SOFTIRQ);
+				sp->recv_credit_max, IB_POLL_SOFTIRQ);
 	if (IS_ERR(sc->ib.recv_cq)) {
 		sc->ib.recv_cq = NULL;
 		goto alloc_cq_failed;
@@ -1578,8 +1592,8 @@ static struct smbd_connection *_smbd_get_connection(
 	memset(&qp_attr, 0, sizeof(qp_attr));
 	qp_attr.event_handler = smbd_qp_async_error_upcall;
 	qp_attr.qp_context = info;
-	qp_attr.cap.max_send_wr = info->send_credit_target;
-	qp_attr.cap.max_recv_wr = info->receive_credit_max;
+	qp_attr.cap.max_send_wr = sp->send_credit_target;
+	qp_attr.cap.max_recv_wr = sp->recv_credit_max;
 	qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SEND_SGE;
 	qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_RECV_SGE;
 	qp_attr.cap.max_inline_data = 0;
@@ -1654,7 +1668,7 @@ static struct smbd_connection *_smbd_get_connection(
 	init_waitqueue_head(&info->wait_send_queue);
 	INIT_DELAYED_WORK(&info->idle_timer_work, idle_connection_timer);
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
-		info->keep_alive_interval*HZ);
+		msecs_to_jiffies(sp->keepalive_interval_msec));
 
 	init_waitqueue_head(&info->wait_send_pending);
 	atomic_set(&info->send_pending, 0);
@@ -1971,6 +1985,7 @@ int smbd_send(struct TCP_Server_Info *server,
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
 	unsigned int remaining_data_length, klen;
@@ -1988,10 +2003,10 @@ int smbd_send(struct TCP_Server_Info *server,
 	for (i = 0; i < num_rqst; i++)
 		remaining_data_length += smb_rqst_len(server, &rqst_array[i]);
 
-	if (unlikely(remaining_data_length > info->max_fragmented_send_size)) {
+	if (unlikely(remaining_data_length > sp->max_fragmented_send_size)) {
 		/* assertion: payload never exceeds negotiated maximum */
 		log_write(ERR, "payload size %d > max size %d\n",
-			remaining_data_length, info->max_fragmented_send_size);
+			remaining_data_length, sp->max_fragmented_send_size);
 		return -EINVAL;
 	}
 
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 3d325d73364a..75b3f491c3ad 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -69,15 +69,7 @@ struct smbd_connection {
 	spinlock_t lock_new_credits_offered;
 	int new_credits_offered;
 
-	/* Connection parameters defined in [MS-SMBD] 3.1.1.1 */
-	int receive_credit_max;
-	int send_credit_target;
-	int max_send_size;
-	int max_fragmented_recv_size;
-	int max_fragmented_send_size;
-	int max_receive_size;
-	int keep_alive_interval;
-	int max_readwrite_size;
+	/* dynamic connection parameters defined in [MS-SMBD] 3.1.1.1 */
 	enum keep_alive_status keep_alive_requested;
 	int protocol;
 	atomic_t send_credits;
-- 
2.34.1

