Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EAA2874E0
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744894; cv=none; b=Ft/eDYPIx6v1IMalyCmdTqningPDPTNQyNqjRVIy292J6OkFa/4KpMeUpdlJgtFJwTie0hB6TgP+7ccbKgmL9igO2UJ5uKM+DB21VQr27vWS6QXYq6m1C3PZEte9u8K4UDMnGInSL1DIOiqsQfjo6HMv6+Cxzxmr79iS7pfgdnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744894; c=relaxed/simple;
	bh=K/TKu1pcWw7GYV6rAvbR0/DgYi/5oqV4dpD/mzqv/Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVAcvKcGyYKYt1v2ouz5dcbJ6vMtf912cAXYC0NVH/fpNdY9ev64Vl138IxnKiLxXoBwWoqDcHtkI3V0ax8broM7u7E+7hoYQA0DlM/mjeyPjIgflDaXYTGhz5ZU9zEwLJEdfrDAA5je727tG+89Hcjs5e26y58CWC9rj1sKqIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Hbsa7QCa; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Hbsa7QCa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=iGa8wI6ItCKR+JJup/gmLa4XD3pMW4l3/pqsAu/hgK0=; b=Hbsa7QCaGqU1orx8xMWLk2RVyL
	yxFLSxCukQxtCI4E7gsBWksRCAG1nXaDJuJx0S9J1q7bDnsQ62Ous3houA29H+CYdt/tDV1+dOO3W
	7X74ANnYzeHiXrxsbSo37POsDxEhYJdCfcJ4AhMVgCevv1XuLfBXkGmm4q6P9xuaPp2z83ZMTwjdd
	7U/DMjSJozhRWxEUwWJRCX8ab/TyuXoF9+RMLEx5OtuiwheQom/gawTZhlKeTv2OPngkEtfLL5FwH
	ne8ow/b3u0lH+7jiwCYauzSDTfrL3U/sP1bZe/56sPOl+w3/7iW8IjJMX6IMXV0rbRXo3VeoJsWkN
	0HJyvpvbqzh465ekophp4XyzyT1GhK8nSX1GN1XItr3HE09g00giDPjlHxkfXNwsv+fVl6XdZ4Jyu
	qj2xyG++oomHX3LjrqhPUjmO29K7Bh8jOzuYZgh7yjHvaI6CcSYSIylcJhkKebjHllxZPGWsurTb1
	COEIWsny6O0Lv3PEiKHqBL8A;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6K8-00Bd7f-1b;
	Wed, 29 Oct 2025 13:34:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 123/127] smb: server: make use of smbdirect_connection_send_iter() and related functions
Date: Wed, 29 Oct 2025 14:21:41 +0100
Message-ID: <6e46888a07461f3a75aa9df26ecc1419d74eff79.1761742839.git.metze@samba.org>
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

This makes use of common code for sending messages, this will
allow to make more use of common code in the next commits.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 355 +--------------------------------
 1 file changed, 4 insertions(+), 351 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 070c386dd2ea..e3a410d773f6 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -196,22 +196,6 @@ unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt)
 	return sp->max_read_write_size;
 }
 
-static int smb_direct_post_send_data(struct smbdirect_socket *sc,
-				     struct smbdirect_send_batch *send_ctx,
-				     struct iov_iter *iter,
-				     u32 remaining_data_length);
-
-static void smb_direct_send_immediate_work(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, idle.immediate_work);
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
-		return;
-
-	smb_direct_post_send_data(sc, NULL, NULL, 0);
-}
-
 static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 {
 	struct smb_direct_transport *t;
@@ -492,338 +476,6 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 	return ret;
 }
 
-static int smb_direct_post_send(struct smbdirect_socket *sc,
-				struct ib_send_wr *wr)
-{
-	int ret;
-
-	atomic_inc(&sc->send_io.pending.count);
-	ret = ib_post_send(sc->ib.qp, wr, NULL);
-	if (ret) {
-		pr_err("failed to post send: %d\n", ret);
-		smbdirect_connection_schedule_disconnect(sc, ret);
-	}
-	return ret;
-}
-
-static void smb_direct_send_ctx_init(struct smbdirect_send_batch *send_ctx,
-				     bool need_invalidate_rkey,
-				     unsigned int remote_key)
-{
-	INIT_LIST_HEAD(&send_ctx->msg_list);
-	send_ctx->wr_cnt = 0;
-	send_ctx->need_invalidate_rkey = need_invalidate_rkey;
-	send_ctx->remote_key = remote_key;
-}
-
-static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
-				      struct smbdirect_send_batch *send_ctx,
-				      bool is_last)
-{
-	struct smbdirect_send_io *first, *last;
-	int ret;
-
-	if (list_empty(&send_ctx->msg_list))
-		return 0;
-
-	first = list_first_entry(&send_ctx->msg_list,
-				 struct smbdirect_send_io,
-				 sibling_list);
-	last = list_last_entry(&send_ctx->msg_list,
-			       struct smbdirect_send_io,
-			       sibling_list);
-
-	if (send_ctx->need_invalidate_rkey) {
-		first->wr.opcode = IB_WR_SEND_WITH_INV;
-		first->wr.ex.invalidate_rkey = send_ctx->remote_key;
-		send_ctx->need_invalidate_rkey = false;
-		send_ctx->remote_key = 0;
-	}
-
-	last->wr.send_flags = IB_SEND_SIGNALED;
-	last->wr.wr_cqe = &last->cqe;
-
-	/*
-	 * Remove last from send_ctx->msg_list
-	 * and splice the rest of send_ctx->msg_list
-	 * to last->sibling_list.
-	 *
-	 * send_ctx->msg_list is a valid empty list
-	 * at the end.
-	 */
-	list_del_init(&last->sibling_list);
-	list_splice_tail_init(&send_ctx->msg_list, &last->sibling_list);
-	send_ctx->wr_cnt = 0;
-
-	ret = smb_direct_post_send(sc, &first->wr);
-	if (ret) {
-		struct smbdirect_send_io *sibling, *next;
-
-		list_for_each_entry_safe(sibling, next, &last->sibling_list, sibling_list) {
-			list_del_init(&sibling->sibling_list);
-			smbdirect_connection_free_send_io(sibling);
-		}
-		smbdirect_connection_free_send_io(last);
-	}
-
-	return ret;
-}
-
-
-static int wait_for_send_lcredit(struct smbdirect_socket *sc,
-				 struct smbdirect_send_batch *send_ctx)
-{
-	if (send_ctx && (atomic_read(&sc->send_io.lcredits.count) <= 1)) {
-		int ret;
-
-		ret = smb_direct_flush_send_list(sc, send_ctx, false);
-		if (ret)
-			return ret;
-	}
-
-	return smbdirect_connection_wait_for_credits(sc,
-						     &sc->send_io.lcredits.wait_queue,
-						     &sc->send_io.lcredits.count,
-						     1);
-}
-
-static int wait_for_send_credits(struct smbdirect_socket *sc,
-				 struct smbdirect_send_batch *send_ctx)
-{
-	int ret;
-
-	if (send_ctx &&
-	    (send_ctx->wr_cnt >= 16 || atomic_read(&sc->send_io.credits.count) <= 1)) {
-		ret = smb_direct_flush_send_list(sc, send_ctx, false);
-		if (ret)
-			return ret;
-	}
-
-	return smbdirect_connection_wait_for_credits(sc,
-						     &sc->send_io.credits.wait_queue,
-						     &sc->send_io.credits.count,
-						     1);
-}
-
-static int post_sendmsg(struct smbdirect_socket *sc,
-			struct smbdirect_send_batch *send_ctx,
-			struct smbdirect_send_io *msg)
-{
-	int i;
-
-	for (i = 0; i < msg->num_sge; i++)
-		ib_dma_sync_single_for_device(sc->ib.dev,
-					      msg->sge[i].addr, msg->sge[i].length,
-					      DMA_TO_DEVICE);
-
-	msg->cqe.done = smbdirect_connection_send_io_done;
-	msg->wr.opcode = IB_WR_SEND;
-	msg->wr.sg_list = &msg->sge[0];
-	msg->wr.num_sge = msg->num_sge;
-	msg->wr.next = NULL;
-
-	if (send_ctx) {
-		msg->wr.wr_cqe = NULL;
-		msg->wr.send_flags = 0;
-		if (!list_empty(&send_ctx->msg_list)) {
-			struct smbdirect_send_io *last;
-
-			last = list_last_entry(&send_ctx->msg_list,
-					       struct smbdirect_send_io,
-					       sibling_list);
-			last->wr.next = &msg->wr;
-		}
-		list_add_tail(&msg->sibling_list, &send_ctx->msg_list);
-		send_ctx->wr_cnt++;
-		return 0;
-	}
-
-	msg->wr.wr_cqe = &msg->cqe;
-	msg->wr.send_flags = IB_SEND_SIGNALED;
-	return smb_direct_post_send(sc, &msg->wr);
-}
-
-static int smb_direct_post_send_data(struct smbdirect_socket *sc,
-				     struct smbdirect_send_batch *send_ctx,
-				     struct iov_iter *iter,
-				     u32 remaining_data_length)
-{
-	const struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_send_io *msg;
-	struct smbdirect_data_transfer *packet;
-	size_t header_length;
-	u16 new_credits = 0;
-	u32 data_length = 0;
-	int ret;
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
-	ret = wait_for_send_lcredit(sc, send_ctx);
-	if (ret)
-		goto lcredit_failed;
-
-	ret = wait_for_send_credits(sc, send_ctx);
-	if (ret)
-		goto credit_failed;
-
-	msg = smbdirect_connection_alloc_send_io(sc);
-	if (IS_ERR(msg)) {
-		ret = PTR_ERR(msg);
-		goto alloc_failed;
-	}
-
-	/* Map the packet to DMA */
-	msg->sge[0].addr = ib_dma_map_single(sc->ib.dev,
-					     msg->packet,
-					     header_length,
-					     DMA_TO_DEVICE);
-	ret = ib_dma_mapping_error(sc->ib.dev, msg->sge[0].addr);
-	if (ret)
-		goto err;
-
-	msg->sge[0].length = header_length;
-	msg->sge[0].lkey = sc->ib.pd->local_dma_lkey;
-	msg->num_sge = 1;
-
-	if (iter) {
-		struct smbdirect_map_sges extract = {
-			.num_sge	= msg->num_sge,
-			.max_sge	= ARRAY_SIZE(msg->sge),
-			.sge		= msg->sge,
-			.device		= sc->ib.dev,
-			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
-			.direction	= DMA_TO_DEVICE,
-		};
-		size_t payload_len = umin(iov_iter_count(iter),
-					  sp->max_send_size - sizeof(*packet));
-
-		ret = smbdirect_map_sges_from_iter(iter, payload_len, &extract);
-		if (ret < 0)
-			goto err;
-		data_length = ret;
-		remaining_data_length -= data_length;
-		msg->num_sge = extract.num_sge;
-	}
-
-	/* Fill in the packet header */
-	packet = (struct smbdirect_data_transfer *)msg->packet;
-	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
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
-	ksmbd_debug(RDMA,
-		    "credits_req=%u credits_granted=%u flags=0x%x ofs=%u len=%u remaining=%u\n",
-		    le16_to_cpu(packet->credits_requested),
-		    le16_to_cpu(packet->credits_granted),
-		    le16_to_cpu(packet->flags),
-		    le32_to_cpu(packet->data_offset),
-		    le32_to_cpu(packet->data_length),
-		    le32_to_cpu(packet->remaining_data_length));
-
-	ret = post_sendmsg(sc, send_ctx, msg);
-	if (ret)
-		goto err;
-	return data_length;
-err:
-	smbdirect_connection_free_send_io(msg);
-alloc_failed:
-	atomic_inc(&sc->send_io.credits.count);
-credit_failed:
-	atomic_inc(&sc->send_io.lcredits.count);
-lcredit_failed:
-	return ret;
-}
-
-static int smb_direct_send_iter(struct smbdirect_socket *sc,
-				struct iov_iter *iter,
-				bool need_invalidate,
-				unsigned int remote_key)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int ret;
-	struct smbdirect_send_batch send_ctx;
-	int error = 0;
-	__be32 hdr;
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
-		return -ENOTCONN;
-
-	/*
-	 * For now we expect the iter to have the full
-	 * message, including a 4 byte length header.
-	 */
-	if (iov_iter_count(iter) <= 4)
-		return -EINVAL;
-	if (!copy_from_iter_full(&hdr, sizeof(hdr), iter))
-		return -EFAULT;
-	if (iov_iter_count(iter) != be32_to_cpu(hdr))
-		return -EINVAL;
-
-	/*
-	 * The size must fit into the negotiated
-	 * fragmented send size.
-	 */
-	if (iov_iter_count(iter) > sp->max_fragmented_send_size)
-		return -EMSGSIZE;
-
-	ksmbd_debug(RDMA, "Sending smb (RDMA): smb_len=%zu\n",
-		    iov_iter_count(iter));
-
-	smb_direct_send_ctx_init(&send_ctx, need_invalidate, remote_key);
-	while (iov_iter_count(iter)) {
-		ret = smb_direct_post_send_data(sc,
-						&send_ctx,
-						iter,
-						iov_iter_count(iter));
-		if (unlikely(ret < 0)) {
-			error = ret;
-			break;
-		}
-	}
-
-	ret = smb_direct_flush_send_list(sc, &send_ctx, true);
-	if (unlikely(!ret && error))
-		ret = error;
-
-	/*
-	 * As an optimization, we don't wait for individual I/O to finish
-	 * before sending the next one.
-	 * Send them all and wait for pending send count to get to 0
-	 * that means all the I/Os have been out and we are good to return
-	 */
-
-	wait_event(sc->send_io.pending.zero_wait_queue,
-		   atomic_read(&sc->send_io.pending.count) == 0 ||
-		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED && ret == 0)
-		ret = -ENOTCONN;
-
-	return ret;
-}
-
 static int smb_direct_writev(struct ksmbd_transport *t,
 			     struct kvec *iov, int niovs, int buflen,
 			     bool need_invalidate, unsigned int remote_key)
@@ -834,7 +486,8 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 
 	iov_iter_kvec(&iter, ITER_SOURCE, iov, niovs, buflen);
 
-	return smb_direct_send_iter(sc, &iter, need_invalidate, remote_key);
+	return smbdirect_connection_send_iter(sc, &iter, 0,
+					      need_invalidate, remote_key);
 }
 
 static int smb_direct_rdma_write(struct ksmbd_transport *t,
@@ -970,7 +623,7 @@ static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 	sendmsg->sge[0].length = sizeof(*resp);
 	sendmsg->sge[0].lkey = sc->ib.pd->local_dma_lkey;
 
-	ret = post_sendmsg(sc, NULL, sendmsg);
+	ret = smbdirect_connection_post_send_io(sc, NULL, sendmsg);
 	if (ret) {
 		smbdirect_connection_free_send_io(sendmsg);
 		return ret;
@@ -1178,7 +831,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 		return ret;
 
 	INIT_WORK(&sc->recv_io.posted.refill_work, smbdirect_connection_recv_io_refill_work);
-	INIT_WORK(&sc->idle.immediate_work, smb_direct_send_immediate_work);
+	INIT_WORK(&sc->idle.immediate_work, smbdirect_connection_send_immediate_work);
 
 	return 0;
 }
-- 
2.43.0

