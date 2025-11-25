Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5901632D0F5
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094222; cv=none; b=u2Ji03rh5RavbgO5wCSbNYQuP8o7qRcKYUNu07LOCP5f3w/vxkDlBc0w73y1oR67nP5tiADj2+KhOLOsPOC4fvi7+Gns/f975/A22IgIqGPvMk184rVOS9G6PxWxQ1fOcxPAdEF0BLqHL0LU7DmeRNjf7QxtNOc8N8wMj7bSyJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094222; c=relaxed/simple;
	bh=DzcyPZ8V0iXl/SgMB7M3szVXvJ8xYbP8I1y6to7diCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpJFAUWW3U/yQZunnk7nXMaMNdvVIFt6XmVw9C5JJlWhPi9p1xEkxr4U804B6aDMxF+Ydl5C10jI+QRwho4p/Qaas2s9YiJ1Qz5DpiF5IQzrILKKbr0xoBv/dTzhxf3VPl//B5QbdV16QWOSW1z3LriecKQXbpTvZtC0JCvqJ7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JZbUl74F; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JZbUl74F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nmLIKRmmnqhEMW8pMCuhxdGnwliWReb148uT2yO/Pzw=; b=JZbUl74Fe10zSahcY/7RQy9RG4
	4IhT73Ug13cfANKeeylmBHYjxQMeyHB9VcnBX80PoGBslLQfbBpbAKpWAycUK+A3CJCtYS9jLDeNS
	Tyc6ya3piealMCGdPEgqjFrquk+y2DJ8AAwOi9H8KWxPAQna39unA5ftXTPg7Q7ZD2hJo53dYsIJy
	Lgyn9qa1fKW+CuN3cncQIGV4vTcePsfghLwxO2j8c+of5eismWPDSVZ/8/VJDNqexVqYaUNnlIJYm
	gHmsFZCVkaG3ZLA5TucirvBaN6ADu6rhuEbPM6urrTmV5l/BeQZ8gqfC4Jo58Ax/Ug69M29bvE+VD
	E7H3A6NjIkJQvrUUnWInYm2h1P0TumJ25xZDY7QYqfDvLSC1YdgtQU4TYXk7UxB+VvU1KeCQwUeD4
	X2HLckSmFq9oFDnA3B0EZ5q3GrMerLgnHiDBT6cCAMn6h8BFspli60ffvfaGK8UCXqc7eEAZ3sq9d
	c5KaNIhMtzt9FLTYsOO7D5TT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxTH-00Fe40-1N;
	Tue, 25 Nov 2025 18:09:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 090/145] smb: client: make use of smbdirect_connection_send_{single_iter,immediate_work}()
Date: Tue, 25 Nov 2025 18:55:36 +0100
Message-ID: <ee3431afc545f9d5c2e526d61cb60d2d07380114.1764091285.git.metze@samba.org>
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

With this the low level send functions are in common,
we'll have to do some more changes in generic smb code
in order to use smbdirect_connection_send_iter() instead
of looping around smbdirect_connection_send_single_iter().

David's cleanups will allow us to use
smbdirect_connection_send_iter().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 253 +++-----------------------------------
 1 file changed, 15 insertions(+), 238 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 1f7b31cb15af..18b71f58e387 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -729,223 +729,6 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	return rc;
 }
 
-/* Post the send request */
-static int smbd_post_send(struct smbdirect_socket *sc,
-		struct smbdirect_send_io *request)
-{
-	int rc, i;
-
-	for (i = 0; i < request->num_sge; i++) {
-		log_rdma_send(INFO,
-			"rdma_request sge[%d] addr=0x%llx length=%u\n",
-			i, request->sge[i].addr, request->sge[i].length);
-		ib_dma_sync_single_for_device(
-			sc->ib.dev,
-			request->sge[i].addr,
-			request->sge[i].length,
-			DMA_TO_DEVICE);
-	}
-
-	request->cqe.done = smbdirect_connection_send_io_done;
-
-	request->wr.next = NULL;
-	request->wr.wr_cqe = &request->cqe;
-	request->wr.sg_list = request->sge;
-	request->wr.num_sge = request->num_sge;
-	request->wr.opcode = IB_WR_SEND;
-	request->wr.send_flags = IB_SEND_SIGNALED;
-
-	rc = ib_post_send(sc->ib.qp, &request->wr, NULL);
-	if (rc) {
-		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-		smbdirect_socket_schedule_cleanup(sc, rc);
-		rc = -EAGAIN;
-	}
-
-	return rc;
-}
-
-static int smbd_post_send_iter(struct smbdirect_socket *sc,
-			       struct iov_iter *iter,
-			       u32 remaining_data_length)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int rc;
-	int header_length;
-	int data_length;
-	struct smbdirect_send_io *request;
-	struct smbdirect_data_transfer *packet;
-	u16 new_credits = 0;
-
-	if (iter) {
-		header_length = sizeof(struct smbdirect_data_transfer);
-		if (WARN_ON_ONCE(remaining_data_length == 0 ||
-				 iov_iter_count(iter) > remaining_data_length))
-			return -EINVAL;
-	} else {
-		/* If this is a packet without payload, don't send padding */
-		header_length = offsetof(struct smbdirect_data_transfer, padding);
-		if (WARN_ON_ONCE(remaining_data_length))
-			return -EINVAL;
-	}
-
-wait_lcredit:
-	/* Wait for local send credits */
-	rc = wait_event_interruptible(sc->send_io.lcredits.wait_queue,
-		atomic_read(&sc->send_io.lcredits.count) > 0 ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
-	if (rc)
-		goto err_wait_lcredit;
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		log_outgoing(ERR, "disconnected not sending on wait_credit\n");
-		rc = -EAGAIN;
-		goto err_wait_lcredit;
-	}
-	if (unlikely(atomic_dec_return(&sc->send_io.lcredits.count) < 0)) {
-		atomic_inc(&sc->send_io.lcredits.count);
-		goto wait_lcredit;
-	}
-
-wait_credit:
-	/* Wait for send credits. A SMBD packet needs one credit */
-	rc = wait_event_interruptible(sc->send_io.credits.wait_queue,
-		atomic_read(&sc->send_io.credits.count) > 0 ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
-	if (rc)
-		goto err_wait_credit;
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		log_outgoing(ERR, "disconnected not sending on wait_credit\n");
-		rc = -EAGAIN;
-		goto err_wait_credit;
-	}
-	if (unlikely(atomic_dec_return(&sc->send_io.credits.count) < 0)) {
-		atomic_inc(&sc->send_io.credits.count);
-		goto wait_credit;
-	}
-
-	request = smbdirect_connection_alloc_send_io(sc);
-	if (IS_ERR(request)) {
-		rc = PTR_ERR(request);
-		goto err_alloc;
-	}
-
-	memset(request->sge, 0, sizeof(request->sge));
-
-	packet = smbdirect_send_io_payload(request);
-	request->sge[0].addr = ib_dma_map_single(sc->ib.dev,
-						 (void *)packet,
-						 header_length,
-						 DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(sc->ib.dev, request->sge[0].addr)) {
-		rc = -EIO;
-		goto err_dma;
-	}
-
-	request->sge[0].length = header_length;
-	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
-	request->num_sge = 1;
-
-	/* Fill in the data payload to find out how much data we can add */
-	if (iter) {
-		struct smbdirect_map_sges extract = {
-			.num_sge	= request->num_sge,
-			.max_sge	= ARRAY_SIZE(request->sge),
-			.sge		= request->sge,
-			.device		= sc->ib.dev,
-			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
-			.direction	= DMA_TO_DEVICE,
-		};
-		size_t payload_len = umin(iov_iter_count(iter),
-					  sp->max_send_size - sizeof(*packet));
-
-		rc = smbdirect_map_sges_from_iter(iter, payload_len, &extract);
-		if (rc < 0)
-			goto err_dma;
-		data_length = rc;
-		request->num_sge = extract.num_sge;
-		remaining_data_length -= data_length;
-	} else {
-		data_length = 0;
-	}
-
-	/* Fill in the packet header */
-	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
-
-	new_credits = smbdirect_connection_grant_recv_credits(sc);
-	packet->credits_granted = cpu_to_le16(new_credits);
-
-	packet->flags = 0;
-	if (smbdirect_connection_request_keep_alive(sc))
-		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
-
-	packet->reserved = 0;
-	if (!data_length)
-		packet->data_offset = 0;
-	else
-		packet->data_offset = cpu_to_le32(24);
-	packet->data_length = cpu_to_le32(data_length);
-	packet->remaining_data_length = cpu_to_le32(remaining_data_length);
-	packet->padding = 0;
-
-	log_outgoing(INFO, "credits_requested=%d credits_granted=%d data_offset=%d data_length=%d remaining_data_length=%d\n",
-		     le16_to_cpu(packet->credits_requested),
-		     le16_to_cpu(packet->credits_granted),
-		     le32_to_cpu(packet->data_offset),
-		     le32_to_cpu(packet->data_length),
-		     le32_to_cpu(packet->remaining_data_length));
-
-	/*
-	 * Now that we got a local and a remote credit
-	 * we add us as pending
-	 */
-	atomic_inc(&sc->send_io.pending.count);
-
-	rc = smbd_post_send(sc, request);
-	if (!rc)
-		return data_length;
-
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-	wake_up(&sc->send_io.pending.dec_wait_queue);
-
-err_dma:
-	smbdirect_connection_free_send_io(request);
-
-	/* roll back the granted receive credits */
-	atomic_sub(new_credits, &sc->recv_io.credits.count);
-
-err_alloc:
-	atomic_inc(&sc->send_io.credits.count);
-	wake_up(&sc->send_io.credits.wait_queue);
-
-err_wait_credit:
-	atomic_inc(&sc->send_io.lcredits.count);
-	wake_up(&sc->send_io.lcredits.wait_queue);
-
-err_wait_lcredit:
-	return rc;
-}
-
-/*
- * Send an empty message
- * Empty message is used to extend credits to peer to for keep live
- * while there is no upper layer payload to send at the time
- */
-static void smbd_post_send_empty(struct smbdirect_socket *sc)
-{
-	int ret;
-
-	sc->statistics.send_empty++;
-	ret = smbd_post_send_iter(sc, NULL, 0);
-	if (ret < 0) {
-		log_rdma_send(ERR, "smbd_post_send_iter failed ret=%d\n", ret);
-		smbdirect_socket_schedule_cleanup(sc, ret);
-	}
-}
-
 static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
 				    u32 remaining_data_length)
@@ -953,7 +736,7 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	int bytes = 0;
 
 	/*
-	 * smbd_post_send_iter() respects the
+	 * smbdirect_connection_send_single_iter() respects the
 	 * negotiated max_send_size, so we need to
 	 * loop until the full iter is posted
 	 */
@@ -961,7 +744,11 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	while (iov_iter_count(iter) > 0) {
 		int rc;
 
-		rc = smbd_post_send_iter(sc, iter, remaining_data_length);
+		rc = smbdirect_connection_send_single_iter(sc,
+							   NULL, /* batch */
+							   iter,
+							   0, /* flags */
+							   remaining_data_length);
 		if (rc < 0)
 			return rc;
 		remaining_data_length -= rc;
@@ -1014,18 +801,6 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
 	return rc;
 }
 
-static void send_immediate_empty_message(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, idle.immediate_work);
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
-		return;
-
-	log_keep_alive(INFO, "send an empty message\n");
-	smbd_post_send_empty(sc);
-}
-
 /*
  * Destroy the transport and related RDMA and memory resources
  * Need to go through all the pending counters and make sure on one is using
@@ -1208,7 +983,7 @@ static struct smbd_connection *_smbd_get_connection(
 	list_for_each_entry(recv_io, &sc->recv_io.free.list, list)
 		recv_io->cqe.done = recv_done;
 
-	INIT_WORK(&sc->idle.immediate_work, send_immediate_empty_message);
+	INIT_WORK(&sc->idle.immediate_work, smbdirect_connection_send_immediate_work);
 	/*
 	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
 	 * so that the timer will cause a disconnect.
@@ -1326,6 +1101,7 @@ int smbd_send(struct TCP_Server_Info *server,
 	struct iov_iter iter;
 	unsigned int remaining_data_length, klen;
 	int rc, i, rqst_idx;
+	int error = 0;
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return -EAGAIN;
@@ -1393,14 +1169,15 @@ int smbd_send(struct TCP_Server_Info *server,
 	 * that means all the I/Os have been out and we are good to return
 	 */
 
-	wait_event(sc->send_io.pending.zero_wait_queue,
-		atomic_read(&sc->send_io.pending.count) == 0 ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
+	error = rc;
+	rc = smbdirect_connection_send_wait_zero_pending(sc);
+	if (unlikely(rc && !error))
+		error = -EAGAIN;
 
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED && rc == 0)
-		rc = -EAGAIN;
+	if (unlikely(error))
+		return error;
 
-	return rc;
+	return 0;
 }
 
 /*
-- 
2.43.0

