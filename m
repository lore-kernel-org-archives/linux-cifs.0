Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B52306B34
	for <linux-cifs@vger.kernel.org>; Mon,  8 Sep 2025 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757347717; cv=none; b=P1w9Xa958Y2DHnvJ3pwCnAOOzZ/9lm/8YDAZykDDHuiwjJuSZiGc3d4AykbTtIW7sARqoGa4v+XIzDPzBw5gQIrxzlUzM+5HBpmRSCUt6bCP+oH4L7SxWlUCo/IYJ5DeB4hXl4Dh5nCT6tvUdHJLRTZk3z+TYZTUpwG4VwEpKq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757347717; c=relaxed/simple;
	bh=aFr0rBm3p1tLmt32+292YGCZ+k2sPMbJSDuFSW8mUt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dbNLLhu5/2+fqqX1sTBonym6gGUPC0nJe6phElHbp+f5ji2Pl7Zg+cixWEMLLeTruf1nMuPfMDvAKu8aCLF6ZTHG4QbY54YBvqQ7+PVoHS8d2jmCy6ET40jQFh0OpF9g3Gqat/HWC5Q3sWTcpq/MxErmI2v7bSuEWNPwuaTNcpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ma59dT9E; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ma59dT9E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Uh84aSw96gyLQe3wZZok/xIhLYXKWY+UOwFpsTBx4l0=; b=ma59dT9Ej0v7wLvn5nas9719zs
	DgKzfBT8BoUamY69ETwJUBoixHkNKSqaP6Y+3aC1XwP5lRNbkVt+7zTL756EraWxIefuR4HJOH6ps
	/u6fWuBM/Ds0EGAeEBVNaLabmM+ty7ZpwrB489+rLUjmNs6f7Qukfo8xEraGfhJpzgtHG1U46kbOY
	8pSNoCcqaLj7kkI8oA7sLLO1N6SW3k1tXu9tKEDKUQDntLMsQZ5qBuzf88UMjZVkrDagp9KmIl5r9
	IEAJQFAP+F0BxgKF4eCVPSEdQzPRheaMtCPqPxXjN55HuWZ0Y3uuTlJlX8KToHFe4L5qf7Nomxqjn
	yUUgHqir5uRryvaFfBobKHqJSv9PxB/uJfY6bSjb2u5SRg9QPt9ymDokcgYGYVIoMGHsV8+Wz1LtX
	zZuaYIL2saLDTHbaGFvyfKrn83QM3dhWkhsHKzSwFSnEsbB+qG5iglSrYW7USxWqnLL0oWkASDTOR
	QiQS7fTaeOIfoqTQlJvlaGc7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uvePu-0033vF-21;
	Mon, 08 Sep 2025 16:08:30 +0000
Message-ID: <e6c0ddfe-8942-47a0-8277-b4176a5918e0@samba.org>
Date: Mon, 8 Sep 2025 18:08:29 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: replace for-next-next... Re: [PATCH v4 000/142] smb:
 smbdirect/client/server: make use of common structures
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>
References: <cover.1756139607.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <cover.1756139607.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

here's the branch that could replace your
for-next-next (6eede6a6805fb50e3131b4b8182e10a17c9005b1)

git fetch https://git.samba.org/metze/linux/wip.git for-6.18/fs-smb-20250908-v5
(d762704985c3bd93e2d2e9ab224f5795baea63e1)

https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-6.18/fs-smb-20250908-v5

The first 3 patches are the main reason why the rebase is needed.
7a9cd9e986c1f6ce3a64f4329b2e795bf24752ae smb: server: let smb_direct_writev() respect SMB_DIRECT_MAX_SEND_SGES
329efe5eb73f7b7604dab6b08f16bb6c3e500690 smb: smbdirect: introduce smbdirect_socket_status_string()
ab7a3a9ece72bce4f601d6224aa9243b7e090ca9 smb: client: adjust smbdirect related output of cifs_debug_data_proc_show()

In addition send_io.pending.wait_queue is changed to send_io.pending.zero_wait_queue to indicate
it's woken when count gets zero.

send_io.pending.dec_wait_queue is introduced to replace info->wait_post_send instead of dropping
the logic around it, that gets woken on every decrement.

The diff between the branches below:

Please replace your for-next-next if you're happy.

Thanks!
metze

  fs/smb/client/cifs_debug.c                 |  41 +++----
  fs/smb/client/smbdirect.c                  |  30 ++++--
  fs/smb/common/smbdirect/smbdirect_socket.h |  55 +++++++++-
  fs/smb/server/transport_rdma.c             | 167 +++++++++++++++++++----------
  4 files changed, 210 insertions(+), 83 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index b4d70b51c456..35c4d27d2cc0 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -457,52 +457,53 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
  		sc = &server->smbd_conn->socket;
  		sp = &sc->parameters;

-		seq_printf(m, "\nSMBDirect (in hex) protocol version: %x "
-			"transport status: %x",
+		seq_printf(m, "\nSMBDirect protocol version: 0x%x "
+			"transport status: %s (%u)",
  			SMBDIRECT_V1,
+			smbdirect_socket_status_string(sc->status),
  			sc->status);
-		seq_printf(m, "\nConn receive_credit_max: %x "
-			"send_credit_target: %x max_send_size: %x",
+		seq_printf(m, "\nConn receive_credit_max: %u "
+			"send_credit_target: %u max_send_size: %u",
  			sp->recv_credit_max,
  			sp->send_credit_target,
  			sp->max_send_size);
-		seq_printf(m, "\nConn max_fragmented_recv_size: %x "
-			"max_fragmented_send_size: %x max_receive_size:%x",
+		seq_printf(m, "\nConn max_fragmented_recv_size: %u "
+			"max_fragmented_send_size: %u max_receive_size:%u",
  			sp->max_fragmented_recv_size,
  			sp->max_fragmented_send_size,
  			sp->max_recv_size);
-		seq_printf(m, "\nConn keep_alive_interval: %x "
-			"max_readwrite_size: %x rdma_readwrite_threshold: %x",
+		seq_printf(m, "\nConn keep_alive_interval: %u "
+			"max_readwrite_size: %u rdma_readwrite_threshold: %u",
  			sp->keepalive_interval_msec * 1000,
  			sp->max_read_write_size,
  			server->rdma_readwrite_threshold);
-		seq_printf(m, "\nDebug count_get_receive_buffer: %llx "
-			"count_put_receive_buffer: %llx count_send_empty: %llx",
+		seq_printf(m, "\nDebug count_get_receive_buffer: %llu "
+			"count_put_receive_buffer: %llu count_send_empty: %llu",
  			sc->statistics.get_receive_buffer,
  			sc->statistics.put_receive_buffer,
  			sc->statistics.send_empty);
  		seq_printf(m, "\nRead Queue "
-			"count_enqueue_reassembly_queue: %llx "
-			"count_dequeue_reassembly_queue: %llx "
-			"reassembly_data_length: %x "
-			"reassembly_queue_length: %x",
+			"count_enqueue_reassembly_queue: %llu "
+			"count_dequeue_reassembly_queue: %llu "
+			"reassembly_data_length: %u "
+			"reassembly_queue_length: %u",
  			sc->statistics.enqueue_reassembly_queue,
  			sc->statistics.dequeue_reassembly_queue,
  			sc->recv_io.reassembly.data_length,
  			sc->recv_io.reassembly.queue_length);
-		seq_printf(m, "\nCurrent Credits send_credits: %x "
-			"receive_credits: %x receive_credit_target: %x",
+		seq_printf(m, "\nCurrent Credits send_credits: %u "
+			"receive_credits: %u receive_credit_target: %u",
  			atomic_read(&sc->send_io.credits.count),
  			atomic_read(&sc->recv_io.credits.count),
  			sc->recv_io.credits.target);
-		seq_printf(m, "\nPending send_pending: %x ",
+		seq_printf(m, "\nPending send_pending: %u ",
  			atomic_read(&sc->send_io.pending.count));
-		seq_printf(m, "\nMR responder_resources: %x "
-			"max_frmr_depth: %x mr_type: %x",
+		seq_printf(m, "\nMR responder_resources: %u "
+			"max_frmr_depth: %u mr_type: 0x%x",
  			sp->responder_resources,
  			sp->max_frmr_depth,
  			sc->mr_io.type);
-		seq_printf(m, "\nMR mr_ready_count: %x mr_used_count: %x",
+		seq_printf(m, "\nMR mr_ready_count: %u mr_used_count: %u",
  			atomic_read(&sc->mr_io.ready.count),
  			atomic_read(&sc->mr_io.used.count));
  skip_rdma:
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d3cd89bd2cc7..322334097e30 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -412,7 +412,9 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
  	}

  	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.wait_queue);
+		wake_up(&sc->send_io.pending.zero_wait_queue);
+
+	wake_up(&sc->send_io.pending.dec_wait_queue);

  	mempool_free(request, sc->send_io.mem.pool);
  }
@@ -1017,6 +1019,23 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
  		goto wait_credit;
  	}

+wait_send_queue:
+	wait_event(sc->send_io.pending.dec_wait_queue,
+		atomic_read(&sc->send_io.pending.count) < sp->send_credit_target ||
+		sc->status != SMBDIRECT_SOCKET_CONNECTED);
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		log_outgoing(ERR, "disconnected not sending on wait_send_queue\n");
+		rc = -EAGAIN;
+		goto err_wait_send_queue;
+	}
+
+	if (unlikely(atomic_inc_return(&sc->send_io.pending.count) >
+				sp->send_credit_target)) {
+		atomic_dec(&sc->send_io.pending.count);
+		goto wait_send_queue;
+	}
+
  	request = mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
  	if (!request) {
  		rc = -ENOMEM;
@@ -1098,14 +1117,10 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
  	request->sge[0].length = header_length;
  	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;

-	atomic_inc(&sc->send_io.pending.count);
  	rc = smbd_post_send(sc, request);
  	if (!rc)
  		return 0;

-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.wait_queue);
-
  err_dma:
  	for (i = 0; i < request->num_sge; i++)
  		if (request->sge[i].addr)
@@ -1119,7 +1134,10 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
  	atomic_sub(new_credits, &sc->recv_io.credits.count);

  err_alloc:
+	if (atomic_dec_and_test(&sc->send_io.pending.count))
+		wake_up(&sc->send_io.pending.zero_wait_queue);

+err_wait_send_queue:
  	/* roll back send credits and pending */
  	atomic_inc(&sc->send_io.credits.count);

@@ -2118,7 +2136,7 @@ int smbd_send(struct TCP_Server_Info *server,
  	 * that means all the I/Os have been out and we are good to return
  	 */

-	wait_event(sc->send_io.pending.wait_queue,
+	wait_event(sc->send_io.pending.zero_wait_queue,
  		atomic_read(&sc->send_io.pending.count) == 0 ||
  		sc->status != SMBDIRECT_SOCKET_CONNECTED);

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index c62d12f63e13..8542de12002a 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -28,6 +28,49 @@ enum smbdirect_socket_status {
  	SMBDIRECT_SOCKET_DESTROYED
  };

+static __always_inline
+const char *smbdirect_socket_status_string(enum smbdirect_socket_status status)
+{
+	switch (status) {
+	case SMBDIRECT_SOCKET_CREATED:
+		return "CREATED";
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
+		return "RESOLVE_ADDR_NEEDED";
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
+		return "RESOLVE_ADDR_RUNNING";
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
+		return "RESOLVE_ADDR_FAILED";
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
+		return "RESOLVE_ROUTE_NEEDED";
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
+		return "RESOLVE_ROUTE_RUNNING";
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
+		return "RESOLVE_ROUTE_FAILED";
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
+		return "RDMA_CONNECT_NEEDED";
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
+		return "RDMA_CONNECT_RUNNING";
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
+		return "RDMA_CONNECT_FAILED";
+	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
+		return "NEGOTIATE_NEEDED";
+	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
+		return "NEGOTIATE_RUNNING";
+	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
+		return "NEGOTIATE_FAILED";
+	case SMBDIRECT_SOCKET_CONNECTED:
+		return "CONNECTED";
+	case SMBDIRECT_SOCKET_DISCONNECTING:
+		return "DISCONNECTING";
+	case SMBDIRECT_SOCKET_DISCONNECTED:
+		return "DISCONNECTED,";
+	case SMBDIRECT_SOCKET_DESTROYED:
+		return "DESTROYED";
+	}
+
+	return "<unknown>";
+}
+
  enum smbdirect_keepalive_status {
  	SMBDIRECT_KEEPALIVE_NONE,
  	SMBDIRECT_KEEPALIVE_PENDING,
@@ -107,7 +150,14 @@ struct smbdirect_socket {
  		 */
  		struct {
  			atomic_t count;
-			wait_queue_head_t wait_queue;
+			/*
+			 * woken when count is decremented
+			 */
+			wait_queue_head_t dec_wait_queue;
+			/*
+			 * woken when count reached zero
+			 */
+			wait_queue_head_t zero_wait_queue;
  		} pending;
  	} send_io;

@@ -271,7 +321,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
  	init_waitqueue_head(&sc->send_io.credits.wait_queue);

  	atomic_set(&sc->send_io.pending.count, 0);
-	init_waitqueue_head(&sc->send_io.pending.wait_queue);
+	init_waitqueue_head(&sc->send_io.pending.dec_wait_queue);
+	init_waitqueue_head(&sc->send_io.pending.zero_wait_queue);

  	INIT_LIST_HEAD(&sc->recv_io.free.list);
  	spin_lock_init(&sc->recv_io.free.lock);
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 6e4c2bf7dd93..33d2f5bdb827 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -366,7 +366,7 @@ static void free_transport(struct smb_direct_transport *t)
  	}

  	wake_up_all(&sc->send_io.credits.wait_queue);
-	wake_up_all(&sc->send_io.pending.wait_queue);
+	wake_up_all(&sc->send_io.pending.zero_wait_queue);

  	disable_work_sync(&sc->recv_io.posted.refill_work);
  	disable_delayed_work_sync(&sc->idle.timer_work);
@@ -818,7 +818,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
  	}

  	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.wait_queue);
+		wake_up(&sc->send_io.pending.zero_wait_queue);

  	/* iterate and free the list of messages in reverse. the list's head
  	 * is invalid.
@@ -879,7 +879,7 @@ static int smb_direct_post_send(struct smbdirect_socket *sc,
  	if (ret) {
  		pr_err("failed to post send: %d\n", ret);
  		if (atomic_dec_and_test(&sc->send_io.pending.count))
-			wake_up(&sc->send_io.pending.wait_queue);
+			wake_up(&sc->send_io.pending.zero_wait_queue);
  		smb_direct_disconnect_rdma_connection(sc);
  	}
  	return ret;
@@ -1206,78 +1206,130 @@ static int smb_direct_writev(struct ksmbd_transport *t,
  	struct smb_direct_transport *st = SMBD_TRANS(t);
  	struct smbdirect_socket *sc = &st->socket;
  	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int remaining_data_length;
-	int start, i, j;
-	int max_iov_size = sp->max_send_size -
+	size_t remaining_data_length;
+	size_t iov_idx;
+	size_t iov_ofs;
+	size_t max_iov_size = sp->max_send_size -
  			sizeof(struct smbdirect_data_transfer);
  	int ret;
-	struct kvec vec;
  	struct smbdirect_send_batch send_ctx;
+	int error = 0;

  	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
  		return -ENOTCONN;

  	//FIXME: skip RFC1002 header..
+	if (WARN_ON_ONCE(niovs <= 1 || iov[0].iov_len != 4))
+		return -EINVAL;
  	buflen -= 4;
+	iov_idx = 1;
+	iov_ofs = 0;

  	remaining_data_length = buflen;
  	ksmbd_debug(RDMA, "Sending smb (RDMA): smb_len=%u\n", buflen);

  	smb_direct_send_ctx_init(&send_ctx, need_invalidate, remote_key);
-	start = i = 1;
-	buflen = 0;
-	while (true) {
-		buflen += iov[i].iov_len;
-		if (buflen > max_iov_size) {
-			if (i > start) {
-				remaining_data_length -=
-					(buflen - iov[i].iov_len);
-				ret = smb_direct_post_send_data(sc, &send_ctx,
-								&iov[start], i - start,
-								remaining_data_length);
-				if (ret)
+	while (remaining_data_length) {
+		struct kvec vecs[SMBDIRECT_SEND_IO_MAX_SGE - 1]; /* minus smbdirect hdr */
+		size_t possible_bytes = max_iov_size;
+		size_t possible_vecs;
+		size_t bytes = 0;
+		size_t nvecs = 0;
+
+		/*
+		 * For the last message remaining_data_length should be
+		 * have been 0 already!
+		 */
+		if (WARN_ON_ONCE(iov_idx >= niovs)) {
+			error = -EINVAL;
+			goto done;
+		}
+
+		/*
+		 * We have 2 factors which limit the arguments we pass
+		 * to smb_direct_post_send_data():
+		 *
+		 * 1. The number of supported sges for the send,
+		 *    while one is reserved for the smbdirect header.
+		 *    And we currently need one SGE per page.
+		 * 2. The number of negotiated payload bytes per send.
+		 */
+		possible_vecs = min_t(size_t, ARRAY_SIZE(vecs), niovs - iov_idx);
+
+		while (iov_idx < niovs && possible_vecs && possible_bytes) {
+			struct kvec *v = &vecs[nvecs];
+			int page_count;
+
+			v->iov_base = ((u8 *)iov[iov_idx].iov_base) + iov_ofs;
+			v->iov_len = min_t(size_t,
+					   iov[iov_idx].iov_len - iov_ofs,
+					   possible_bytes);
+			page_count = get_buf_page_count(v->iov_base, v->iov_len);
+			if (page_count > possible_vecs) {
+				/*
+				 * If the number of pages in the buffer
+				 * is to much (because we currently require
+				 * one SGE per page), we need to limit the
+				 * length.
+				 *
+				 * We know possible_vecs is at least 1,
+				 * so we always keep the first page.
+				 *
+				 * We need to calculate the number extra
+				 * pages (epages) we can also keep.
+				 *
+				 * We calculate the number of bytes in the
+				 * first page (fplen), this should never be
+				 * larger than v->iov_len because page_count is
+				 * at least 2, but adding a limitation feels
+				 * better.
+				 *
+				 * Then we calculate the number of bytes (elen)
+				 * we can keep for the extra pages.
+				 */
+				size_t epages = possible_vecs - 1;
+				size_t fpofs = offset_in_page(v->iov_base);
+				size_t fplen = min_t(size_t, PAGE_SIZE - fpofs, v->iov_len);
+				size_t elen = min_t(size_t, v->iov_len - fplen, epages*PAGE_SIZE);
+
+				v->iov_len = fplen + elen;
+				page_count = get_buf_page_count(v->iov_base, v->iov_len);
+				if (WARN_ON_ONCE(page_count > possible_vecs)) {
+					/*
+					 * Something went wrong in the above
+					 * logic...
+					 */
+					error = -EINVAL;
  					goto done;
-			} else {
-				/* iov[start] is too big, break it */
-				int nvec  = (buflen + max_iov_size - 1) /
-						max_iov_size;
-
-				for (j = 0; j < nvec; j++) {
-					vec.iov_base =
-						(char *)iov[start].iov_base +
-						j * max_iov_size;
-					vec.iov_len =
-						min_t(int, max_iov_size,
-						      buflen - max_iov_size * j);
-					remaining_data_length -= vec.iov_len;
-					ret = smb_direct_post_send_data(sc, &send_ctx, &vec, 1,
-									remaining_data_length);
-					if (ret)
-						goto done;
  				}
-				i++;
-				if (i == niovs)
-					break;
  			}
-			start = i;
-			buflen = 0;
-		} else {
-			i++;
-			if (i == niovs) {
-				/* send out all remaining vecs */
-				remaining_data_length -= buflen;
-				ret = smb_direct_post_send_data(sc, &send_ctx,
-								&iov[start], i - start,
-								remaining_data_length);
-				if (ret)
-					goto done;
-				break;
+			possible_vecs -= page_count;
+			nvecs += 1;
+			possible_bytes -= v->iov_len;
+			bytes += v->iov_len;
+
+			iov_ofs += v->iov_len;
+			if (iov_ofs >= iov[iov_idx].iov_len) {
+				iov_idx += 1;
+				iov_ofs = 0;
  			}
  		}
+
+		remaining_data_length -= bytes;
+
+		ret = smb_direct_post_send_data(sc, &send_ctx,
+						vecs, nvecs,
+						remaining_data_length);
+		if (unlikely(ret)) {
+			error = ret;
+			goto done;
+		}
  	}

  done:
  	ret = smb_direct_flush_send_list(sc, &send_ctx, true);
+	if (unlikely(!ret && error))
+		ret = error;

  	/*
  	 * As an optimization, we don't wait for individual I/O to finish
@@ -1286,7 +1338,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
  	 * that means all the I/Os have been out and we are good to return
  	 */

-	wait_event(sc->send_io.pending.wait_queue,
+	wait_event(sc->send_io.pending.zero_wait_queue,
  		   atomic_read(&sc->send_io.pending.count) == 0 ||
  		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
  	if (sc->status != SMBDIRECT_SOCKET_CONNECTED && ret == 0)
@@ -1620,7 +1672,7 @@ static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
  		return ret;
  	}

-	wait_event(sc->send_io.pending.wait_queue,
+	wait_event(sc->send_io.pending.zero_wait_queue,
  		   atomic_read(&sc->send_io.pending.count) == 0 ||
  		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
  	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
@@ -1773,6 +1825,11 @@ static int smb_direct_init_params(struct smbdirect_socket *sc,
  		return -EINVAL;
  	}

+	if (device->attrs.max_send_sge < SMBDIRECT_SEND_IO_MAX_SGE) {
+		pr_err("warning: device max_send_sge = %d too small\n",
+		       device->attrs.max_send_sge);
+		return -EINVAL;
+	}
  	if (device->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
  		pr_err("warning: device max_recv_sge = %d too small\n",
  		       device->attrs.max_recv_sge);
@@ -1785,7 +1842,7 @@ static int smb_direct_init_params(struct smbdirect_socket *sc,

  	cap->max_send_wr = max_send_wrs;
  	cap->max_recv_wr = sp->recv_credit_max;
-	cap->max_send_sge = max_sge_per_wr;
+	cap->max_send_sge = SMBDIRECT_SEND_IO_MAX_SGE;
  	cap->max_recv_sge = SMBDIRECT_RECV_IO_MAX_SGE;
  	cap->max_inline_data = 0;
  	cap->max_rdma_ctxs = sc->rw_io.credits.max;


