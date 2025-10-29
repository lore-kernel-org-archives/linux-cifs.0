Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EECB2D2388
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744400; cv=none; b=S+JAflKlzfXpjKRRaG63g4hSE3vDXcjAuGqxYoKgl2qPZBr63RoZfR2gda8s/bdJhOu1KTDMmCUkP2wVTk/GkzaCCjJ5OeHaQZ+sz6Xr1jhkV0Fex4uEmjBVmPOgrIQ8q6kfITbgcsbKSZ4Z2jP6wHqCgl7xyYJMN0TbpOtijEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744400; c=relaxed/simple;
	bh=7pcNWW9dDoPAIoI8RoqTSo07X1jRCa5xcBXGSzILLe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRQBGeZz36uKppdvmAPmpLOkzrpdYsc7DiWXPdzpF1KmGm+ELQ7nRBbD9+d4DocRdYXr+ZISlGJ8tQz35wCV5AxGuoR+BeZvNLOwuPVSKJqqpVmO8bA0YPEd3wMO/B6ypwlHe/fI/TN1mi2WjblccRqEPQ2qYhKVdKyUZl5+YvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=J+yH9mp8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="J+yH9mp8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=UEGCeDZHC2l6mYojxECJqaLAeC1tNywc4Um0+Xx5d1w=; b=J+yH9mp8zqmw7KybntUUtslhcv
	VXiNAxjy/p1SAyqlq0RIBYL10qZUGQB0v+leBVceOt48VsSHVGIlsWQkI0xRpy0pWOAqlhfr0cd2D
	hi8SpMp4CxKQvgDg77lA2dp3qg/VeU0j4/+pD7yoAxOOC2oghGZ6uRDuv0DVBWuG1sgRAQzB/u6EM
	0mMHm0nQOWPFbFeSs7lWXGGI/UoWGwC90fvvMB/kR+igFNZA4Iyz3lIqkfl2ikJC/CatipyZ5HG53
	S94dtVKAqW1xEN9xXLQrUKQ9YSk9bim0vfKeRqAt/sEUwUiTaqaG+6iRqGqQn0sbZx7vnm1LHdrEb
	9xy83gmm3v6Em/1Wv84t3smQBPuos6wT4w861B1DB1ViAsLOr/GEVnKwmPwJfl08dSveQ9jO98c2c
	Udm9wm9BLBTPNbyJAWo0Jeb31WrvqAv9FqBW4wnMdIi+/K+RDNwB7OcTCNcwXVCgUnYKdi5Q+UFau
	XcAvj6/AgVFQpmh5ZTYP1o19;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6CA-00Bbo5-3B;
	Wed, 29 Oct 2025 13:26:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH v2 041/127] smb: smbdirect: introduce smbdirect_connection_send_iter() and related functions
Date: Wed, 29 Oct 2025 14:20:19 +0100
Message-ID: <68ffe9bd112ea2111ecd92f809085d61420d94b2.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is basically a copy of the following functions in the server:

smb_direct_post_send       => smbdirect_connection_post_send_wr
smb_direct_send_ctx_init   => smbdirect_connection_send_batch_init
smb_direct_flush_send_list => smbdirect_connection_send_batch_flush
wait_for_send_lcredit      => smbdirect_connection_wait_for_send_lcredit
wait_for_send_credits      => smbdirect_connection_wait_for_send_credits
post_sendmsg               => smbdirect_connection_post_send_io
smb_direct_post_send_data  => smbdirect_connection_send_single_iter
smb_direct_send_iter       => smbdirect_connection_send_iter

They will replace the server functions soon and will also be used in
the client as smbdirect_connection_send_single_iter() is very similar to
smbd_post_send_iter().

There's also a smbdirect_connection_send_wait_zero_pending()
helper that can be used together with
smbdirect_connection_send_single_iter() in the client
until it can use smbdirect_connection_send_iter(),
which can happen with David's refactoring.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 404 +++++++++++++++++-
 1 file changed, 403 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index e2eb3c6cf0f1..e834fcfe05af 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -1076,7 +1076,410 @@ static bool smbdirect_connection_request_keep_alive(struct smbdirect_socket *sc)
 	return false;
 }
 
+static int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
+					     struct ib_send_wr *wr)
+{
+	int ret;
+
+	if (unlikely(sc->first_error))
+		return sc->first_error;
+
+	atomic_inc(&sc->send_io.pending.count);
+	ret = ib_post_send(sc->ib.qp, wr, NULL);
+	if (ret) {
+		atomic_dec(&sc->send_io.pending.count);
+		smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_ERR,
+			"ib_post_send() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		smbdirect_connection_schedule_disconnect(sc, ret);
+	}
+
+	return ret;
+}
+
+static void smbdirect_connection_send_batch_init(struct smbdirect_send_batch *batch,
+						 bool need_invalidate_rkey,
+						 unsigned int remote_key)
+{
+	INIT_LIST_HEAD(&batch->msg_list);
+	batch->wr_cnt = 0;
+	batch->need_invalidate_rkey = need_invalidate_rkey;
+	batch->remote_key = remote_key;
+}
+
+static int smbdirect_connection_send_batch_flush(struct smbdirect_socket *sc,
+						 struct smbdirect_send_batch *batch,
+						 bool is_last)
+{
+	struct smbdirect_send_io *first, *last;
+	int ret;
+
+	if (list_empty(&batch->msg_list))
+		return 0;
+
+	first = list_first_entry(&batch->msg_list,
+				 struct smbdirect_send_io,
+				 sibling_list);
+	last = list_last_entry(&batch->msg_list,
+			       struct smbdirect_send_io,
+			       sibling_list);
+
+	if (batch->need_invalidate_rkey) {
+		first->wr.opcode = IB_WR_SEND_WITH_INV;
+		first->wr.ex.invalidate_rkey = batch->remote_key;
+		batch->need_invalidate_rkey = false;
+		batch->remote_key = 0;
+	}
+
+	last->wr.send_flags = IB_SEND_SIGNALED;
+	last->wr.wr_cqe = &last->cqe;
+
+	/*
+	 * Remove last from send_ctx->msg_list
+	 * and splice the rest of send_ctx->msg_list
+	 * to last->sibling_list.
+	 *
+	 * send_ctx->msg_list is a valid empty list
+	 * at the end.
+	 */
+	list_del_init(&last->sibling_list);
+	list_splice_tail_init(&batch->msg_list, &last->sibling_list);
+	batch->wr_cnt = 0;
+
+	ret = smbdirect_connection_post_send_wr(sc, &first->wr);
+	if (ret) {
+		struct smbdirect_send_io *sibling, *next;
+
+		list_for_each_entry_safe(sibling, next, &last->sibling_list, sibling_list) {
+			list_del_init(&sibling->sibling_list);
+			smbdirect_connection_free_send_io(sibling);
+		}
+		smbdirect_connection_free_send_io(last);
+	}
+
+	return ret;
+}
+
+
+static int smbdirect_connection_wait_for_send_lcredit(struct smbdirect_socket *sc,
+						      struct smbdirect_send_batch *batch)
+{
+	if (batch && atomic_read(&sc->send_io.lcredits.count) <= 1) {
+		int ret;
+
+		ret = smbdirect_connection_send_batch_flush(sc, batch, false);
+		if (ret)
+			return ret;
+	}
+
+	return smbdirect_connection_wait_for_credits(sc,
+						     &sc->send_io.lcredits.wait_queue,
+						     &sc->send_io.lcredits.count,
+						     1);
+}
+
+static int smbdirect_connection_wait_for_send_credits(struct smbdirect_socket *sc,
+						      struct smbdirect_send_batch *batch)
+{
+	if (batch && (batch->wr_cnt >= 16 || atomic_read(&sc->send_io.credits.count) <= 1)) {
+		int ret;
+
+		ret = smbdirect_connection_send_batch_flush(sc, batch, false);
+		if (ret)
+			return ret;
+	}
+
+	return smbdirect_connection_wait_for_credits(sc,
+						     &sc->send_io.credits.wait_queue,
+						     &sc->send_io.credits.count,
+						     1);
+}
+
+static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc);
+
+static int smbdirect_connection_post_send_io(struct smbdirect_socket *sc,
+					     struct smbdirect_send_batch *batch,
+					     struct smbdirect_send_io *msg)
+{
+	int i;
+
+	for (i = 0; i < msg->num_sge; i++)
+		ib_dma_sync_single_for_device(sc->ib.dev,
+					      msg->sge[i].addr, msg->sge[i].length,
+					      DMA_TO_DEVICE);
+
+	msg->cqe.done = smbdirect_connection_send_io_done;
+	msg->wr.wr_cqe = &msg->cqe;
+	msg->wr.opcode = IB_WR_SEND;
+	msg->wr.sg_list = &msg->sge[0];
+	msg->wr.num_sge = msg->num_sge;
+	msg->wr.next = NULL;
+
+	if (batch) {
+		msg->wr.send_flags = 0;
+		if (!list_empty(&batch->msg_list)) {
+			struct smbdirect_send_io *last;
+
+			last = list_last_entry(&batch->msg_list,
+					       struct smbdirect_send_io,
+					       sibling_list);
+			last->wr.next = &msg->wr;
+		}
+		list_add_tail(&msg->sibling_list, &batch->msg_list);
+		batch->wr_cnt++;
+		return 0;
+	}
+
+	msg->wr.send_flags = IB_SEND_SIGNALED;
+	return smbdirect_connection_post_send_wr(sc, &msg->wr);
+}
+
+static int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
+						 struct smbdirect_send_batch *batch,
+						 struct iov_iter *iter,
+						 unsigned int flags,
+						 u32 remaining_data_length)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_send_io *msg;
+	struct smbdirect_data_transfer *packet;
+	size_t header_length;
+	u16 new_credits = 0;
+	u32 data_length = 0;
+	int ret;
+
+	if (WARN_ON_ONCE(flags))
+		return -EINVAL; /* no flags support for now */
+
+	if (iter) {
+		if (WARN_ON_ONCE(iov_iter_rw(iter) != ITER_SOURCE))
+			return -EINVAL; /* It's a bug in upper layer to get there */
+
+		header_length = sizeof(struct smbdirect_data_transfer);
+		if (WARN_ON_ONCE(remaining_data_length == 0 ||
+				 iov_iter_count(iter) > remaining_data_length))
+			return -EINVAL;
+	} else {
+		/* If this is a packet without payload, don't send padding */
+		header_length = offsetof(struct smbdirect_data_transfer, padding);
+		if (WARN_ON_ONCE(remaining_data_length))
+			return -EINVAL;
+	}
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
+			"status=%s first_error=%1pe => %s\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			errname(-ENOTCONN));
+		return -ENOTCONN;
+	}
+
+	ret = smbdirect_connection_wait_for_send_lcredit(sc, batch);
+	if (ret)
+		goto lcredit_failed;
+
+	ret = smbdirect_connection_wait_for_send_credits(sc, batch);
+	if (ret)
+		goto credit_failed;
+
+	msg = smbdirect_connection_alloc_send_io(sc);
+	if (IS_ERR(msg)) {
+		ret = PTR_ERR(msg);
+		goto alloc_failed;
+	}
+
+	/* Map the packet to DMA */
+	msg->sge[0].addr = ib_dma_map_single(sc->ib.dev,
+					     msg->packet,
+					     header_length,
+					     DMA_TO_DEVICE);
+	ret = ib_dma_mapping_error(sc->ib.dev, msg->sge[0].addr);
+	if (ret)
+		goto err;
+
+	msg->sge[0].length = header_length;
+	msg->sge[0].lkey = sc->ib.pd->local_dma_lkey;
+	msg->num_sge = 1;
+
+	if (iter) {
+		struct smbdirect_map_sges extract = {
+			.num_sge	= msg->num_sge,
+			.max_sge	= ARRAY_SIZE(msg->sge),
+			.sge		= msg->sge,
+			.device		= sc->ib.dev,
+			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
+			.direction	= DMA_TO_DEVICE,
+		};
+		size_t payload_len = umin(iov_iter_count(iter),
+					  sp->max_send_size - sizeof(*packet));
+
+		ret = smbdirect_map_sges_from_iter(iter, payload_len, &extract);
+		if (ret < 0)
+			goto err;
+		data_length = ret;
+		remaining_data_length -= data_length;
+		msg->num_sge = extract.num_sge;
+	}
+
+	/* Fill in the packet header */
+	packet = (struct smbdirect_data_transfer *)msg->packet;
+	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
+	new_credits = smbdirect_connection_grant_recv_credits(sc);
+	packet->credits_granted = cpu_to_le16(new_credits);
+
+	packet->flags = 0;
+	if (smbdirect_connection_request_keep_alive(sc))
+		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
+
+	packet->reserved = 0;
+	if (!data_length)
+		packet->data_offset = 0;
+	else
+		packet->data_offset = cpu_to_le32(24);
+	packet->data_length = cpu_to_le32(data_length);
+	packet->remaining_data_length = cpu_to_le32(remaining_data_length);
+	packet->padding = 0;
+
+	smbdirect_log_outgoing(sc, SMBDIRECT_LOG_INFO,
+		"DataOut: %s=%u, %s=%u, %s=0x%x, %s=%u, %s=%u, %s=%u\n",
+		"CreditsRequested",
+		le16_to_cpu(packet->credits_requested),
+		"CreditsGranted",
+		le16_to_cpu(packet->credits_granted),
+		"Flags",
+		le16_to_cpu(packet->flags),
+		"RemainingDataLength",
+		le32_to_cpu(packet->remaining_data_length),
+		"DataOffset",
+		le32_to_cpu(packet->data_offset),
+		"DataLength",
+		le32_to_cpu(packet->data_length));
+
+	ret = smbdirect_connection_post_send_io(sc, batch, msg);
+	if (ret)
+		goto err;
+	return data_length;
+err:
+	smbdirect_connection_free_send_io(msg);
+alloc_failed:
+	atomic_inc(&sc->send_io.credits.count);
+credit_failed:
+	atomic_inc(&sc->send_io.lcredits.count);
+lcredit_failed:
+	return ret;
+}
+
 __maybe_unused /* this is temporary while this file is included in orders */
+static int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
+{
+	/*
+	 * As an optimization, we don't wait for individual I/O to finish
+	 * before sending the next one.
+	 * Send them all and wait for pending send count to get to 0
+	 * that means all the I/Os have been out and we are good to return
+	 */
+
+	wait_event(sc->send_io.pending.zero_wait_queue,
+		   atomic_read(&sc->send_io.pending.count) == 0 ||
+		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
+			"status=%s first_error=%1pe => %s\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			errname(-ENOTCONN));
+		return -ENOTCONN;
+	}
+
+	return 0;
+}
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
+					  struct iov_iter *iter,
+					  unsigned int flags,
+					  bool need_invalidate,
+					  unsigned int remote_key)
+{
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_send_batch batch;
+	int total_count = iov_iter_count(iter);
+	int ret;
+	int error = 0;
+	__be32 hdr;
+
+	if (WARN_ON_ONCE(flags))
+		return -EINVAL; /* no flags support for now */
+
+	if (WARN_ON_ONCE(iov_iter_rw(iter) != ITER_SOURCE))
+		return -EINVAL; /* It's a bug in upper layer to get there */
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
+			"status=%s first_error=%1pe => %s\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			errname(-ENOTCONN));
+		return -ENOTCONN;
+	}
+
+	/*
+	 * For now we expect the iter to have the full
+	 * message, including a 4 byte length header.
+	 */
+	if (iov_iter_count(iter) <= 4)
+		return -EINVAL;
+	if (!copy_from_iter_full(&hdr, sizeof(hdr), iter))
+		return -EFAULT;
+	if (iov_iter_count(iter) != be32_to_cpu(hdr))
+		return -EINVAL;
+
+	/*
+	 * The size must fit into the negotiated
+	 * fragmented send size.
+	 */
+	if (iov_iter_count(iter) > sp->max_fragmented_send_size)
+		return -EMSGSIZE;
+
+	smbdirect_log_write(sc, SMBDIRECT_LOG_INFO,
+		"Sending (RDMA): length=%zu\n",
+		iov_iter_count(iter));
+
+	smbdirect_connection_send_batch_init(&batch, need_invalidate, remote_key);
+	while (iov_iter_count(iter)) {
+		ret = smbdirect_connection_send_single_iter(sc,
+							    &batch,
+							    iter,
+							    flags,
+							    iov_iter_count(iter));
+		if (unlikely(ret < 0)) {
+			error = ret;
+			break;
+		}
+	}
+
+	ret = smbdirect_connection_send_batch_flush(sc, &batch, true);
+	if (unlikely(ret && !error))
+		error = ret;
+
+	/*
+	 * As an optimization, we don't wait for individual I/O to finish
+	 * before sending the next one.
+	 * Send them all and wait for pending send count to get to 0
+	 * that means all the I/Os have been out and we are good to return
+	 */
+
+	ret = smbdirect_connection_send_wait_zero_pending(sc);
+	if (unlikely(ret && !error))
+		error = ret;
+
+	if (unlikely(error))
+		return error;
+
+	return total_count;
+}
+
 static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_send_io *msg =
@@ -1788,7 +2191,6 @@ static ssize_t smbdirect_map_sges_from_folioq(struct iov_iter *iter,
  * BVEC-type iterator and the pages pinned, ref'd or otherwise held in some
  * way.
  */
-__maybe_unused /* this is temporary while this file is included in orders */
 static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
 					    struct smbdirect_map_sges *state)
 {
-- 
2.43.0

