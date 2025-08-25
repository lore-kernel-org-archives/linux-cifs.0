Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22B42AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154844; cv=none; b=UAAo9/7Lw9AXJktE6G91s+0nEcB/sqbGyWD882IOoB2NfwISJLCbVjwuZam73BpBvKjvA5GE5r8emDeeCg427eRoVnvlPyD7fojsyVs1UCDFewUgR3uhWc/6RBr+5zBZBvD6HDxjCQDXPZ1bv/odXRSq9AEVI2py48yq7T01B7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154844; c=relaxed/simple;
	bh=LFIHZqPcbbW1VkzcaXikj30cl3MRH1VmE2D/I+XXMsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNzW4jmNFMxwbwgyZE0ZLYdJS93PFNTF8WpsHX9p75SQTKEryuZNHvhv1pEnAdIIiiwELL1MlmWpGtg4TCuEOvSgdI6fpEPpa3OX+DSStpw6ZjrUXnz3oofYtm63Z0JAj27dkb1Od0Ik+L4T+U0Ueg3lG/LC/fbjRu44wKJ4hcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MY2+mHaI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MY2+mHaI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=wHKNpfS/FLWiLkNSzBcpV+mnjq4zZa7/mYsvpUfrZcM=; b=MY2+mHaItoZGWdvVr07Xzw1DjS
	S0YOz9RuHc3hz5Nc/I8RyXakoijDq2kDEnjBdRe8CcisNr6oktx+IXlUqEjubQuXXu8bl9/5Krmdy
	6REwpI0R7wOv+m49hqXIu9dXE2QZYUYJTozqbkojZuS95kw0OTVnZ25mXmes9gZ7NrAg7DgAxDZEg
	wF9RjssTYKMU1CCj9n4fnpEMfzF6q7nDL+Id0hBZrERMQ0/s9eaAFiUP2Dn1toohnCxtn1qYguwiJ
	rLS4NWANTJoNmOATshI34aPGIoxt/Wig0Q0gxp0BmDQG79QfxilhkvpqcB8WlfsUFLZw/mgR1xBwd
	7xE+y5/Azx/NDhZ9CKny9QPwKTSYeLfG6biIjLMEMCAznTI9pTMN9kaUaLMAYUCPVWQHhLkgVbpJ7
	vEnzb/tLlgDzLOzgN8tiTVscicDKGuIzb16yEs0mKsfD/EaWtuP/T6FDL+QYeSlHJ9GyAu60ileVw
	jZnRbcdwcV4BEcytDrjAEC5i;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe62-000kJB-34;
	Mon, 25 Aug 2025 20:47:19 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 033/142] smb: client: remove info->wait_receive_queues handling in smbd_destroy()
Date: Mon, 25 Aug 2025 22:39:54 +0200
Message-ID: <19e7299ed26036970779103412337424986899fe.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We already call ib_drain_qp() before, which is an sync operation
that only returns in the queues are fully drained.

ib_drain_qp() completes pending requests with IB_WC_WR_FLUSH_ERR
so we have already called put_receive_buffer().

So all smbdirect_recv_io objects are either in the
smbdirect_socket.recv_io.free.list or
smbdirect_socket.recv_io.reassembly.list.

Then we explicitly iterate smbdirect_socket.recv_io.reassembly.list
and call put_receive_buffer(), so every object is
in smbdirect_socket.recv_io.free.list.

It means info->count_receive_queue == sp->recv_credit_max was
already true and calling wait_event(info->wait_receive_queues...
is pointless.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c |  2 --
 fs/smb/client/smbdirect.c  | 13 -------------
 fs/smb/client/smbdirect.h  |  4 ----
 3 files changed, 19 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index b80ddacd8c8f..3717a0081847 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -481,8 +481,6 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			server->smbd_conn->receive_credit_target);
 		seq_printf(m, "\nPending send_pending: %x ",
 			atomic_read(&sc->send_io.pending.count));
-		seq_printf(m, "\nReceive buffers count_receive_queue: %x ",
-			server->smbd_conn->count_receive_queue);
 		seq_printf(m, "\nMR responder_resources: %x "
 			"max_frmr_depth: %x mr_type: %x",
 			server->smbd_conn->responder_resources,
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ec3ebf6e3c88..b1ecfdbbc67d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -514,7 +514,6 @@ static void smbd_post_send_credits(struct work_struct *work)
 	struct smbdirect_socket *sc = &info->socket;
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		wake_up_all(&info->wait_receive_queues);
 		return;
 	}
 
@@ -1331,7 +1330,6 @@ static struct smbdirect_recv_io *get_receive_buffer(struct smbd_connection *info
 			&sc->recv_io.free.list,
 			struct smbdirect_recv_io, list);
 		list_del(&ret->list);
-		info->count_receive_queue--;
 		info->count_get_receive_buffer++;
 	}
 	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
@@ -1361,7 +1359,6 @@ static void put_receive_buffer(
 
 	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
 	list_add_tail(&response->list, &sc->recv_io.free.list);
-	info->count_receive_queue++;
 	info->count_put_receive_buffer++;
 	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
 
@@ -1375,10 +1372,6 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 	struct smbdirect_recv_io *response;
 	int i;
 
-	info->count_receive_queue = 0;
-
-	init_waitqueue_head(&info->wait_receive_queues);
-
 	for (i = 0; i < num_buf; i++) {
 		response = mempool_alloc(sc->recv_io.mem.pool, GFP_KERNEL);
 		if (!response)
@@ -1387,7 +1380,6 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 		response->socket = sc;
 		response->sge.length = 0;
 		list_add_tail(&response->list, &sc->recv_io.free.list);
-		info->count_receive_queue++;
 	}
 
 	return 0;
@@ -1398,7 +1390,6 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 				&sc->recv_io.free.list,
 				struct smbdirect_recv_io, list);
 		list_del(&response->list);
-		info->count_receive_queue--;
 
 		mempool_free(response, sc->recv_io.mem.pool);
 	}
@@ -1448,7 +1439,6 @@ void smbd_destroy(struct TCP_Server_Info *server)
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc;
-	struct smbdirect_socket_parameters *sp;
 	struct smbdirect_recv_io *response;
 	unsigned long flags;
 
@@ -1457,7 +1447,6 @@ void smbd_destroy(struct TCP_Server_Info *server)
 		return;
 	}
 	sc = &info->socket;
-	sp = &sc->parameters;
 
 	log_rdma_event(INFO, "cancelling and disable disconnect_work\n");
 	disable_work_sync(&sc->disconnect_work);
@@ -1499,8 +1488,6 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	sc->recv_io.reassembly.data_length = 0;
 
 	log_rdma_event(INFO, "free receive buffers\n");
-	wait_event(info->wait_receive_queues,
-		info->count_receive_queue == sp->recv_credit_max);
 	destroy_receive_buffers(info);
 
 	/*
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 1c4e03491964..693876f2d836 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -84,10 +84,6 @@ struct smbd_connection {
 	/* Activity accounting */
 	wait_queue_head_t wait_post_send;
 
-	/* Receive queue */
-	int count_receive_queue;
-	wait_queue_head_t wait_receive_queues;
-
 	bool send_immediate;
 
 	struct workqueue_struct *workqueue;
-- 
2.43.0

