Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D81F188596
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093640; cv=none; b=nd/vTaW8CCPM7lHjwdjIwt3KQ87ahTUAWrm8mLsI48Y90RyQf3hgmcmHpIxmjqmsQ04OKbIHrjBdCXD8nlmH39uwh12AYA5QpoPGBUpvmlmKH/+o85O1m+dE+RWD9NKEjWdA6++/gd6oLP2Sg+nFUwhx097eg//G59uLO6deEBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093640; c=relaxed/simple;
	bh=tMJ1knFkVc4mQMSnQqMtxc4wyUQOnnS3cJwQmzXi+Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=im1sGSB96uazjH/5PX9VTUKXZ3/MOZZ1S8/nL86IvZ6D7p++KcsacXNe0rOytHBdVPqHVRi7YqSBnCiIMizGeI3OvwCzor0ABlpDLxzNjxsYeHe3BAHUnGYITRn71ehnBN7j6IsM/lJlkEJydaIjkIqcIhjND53MjDdJYhlwwDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WoPsBF9A; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WoPsBF9A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=kZQa3iM25fC00aod4gXaDzVb0AOwYTy7HISCOSrLleY=; b=WoPsBF9Ai2p2w/ohE0/wAWkzvs
	WOWoqD882TIws1ej97vqbY3jdO9mNgr/cwS3PFqu+g/aRxCjk+sYIe4dPXl3Xzmpqxe4BJ8BnqKt3
	OOd8czms77cpgZvAn032gKW+cvLE8CTV2dtkaXSwFRkr0+r078VIcz/eKBuflTsfaG8olgA96mQHb
	YLfdujoF1Q2FckY/oZ1Vt/X8DBPd9FnoJ9lwm+B5x64NEpnBSrc9MEXO2kf/6PIHMqWjb225Ttxdf
	lLeQZC0nRHEdGqXL2/Rugz53JXhkgYiZFchwVmU7I1TF+KSGMcSJ8+SkJdk6G61r4yi2YdVBVTaul
	OjXfCEi6wvxSbffPJH6ef507upLWmC7FUqPWJM0fklI7CLUfs7tpo1s0pZqmJj2DuDFfcBJQzSUjo
	/M4hc6cOn8rBuIpptr2jn62Fi2phF2IQh20uX5U0+oYVrItmyi+PFHdrde9EQxjZVZW6hA3P3Rvk+
	d4Q9osteBXQQxsWEyayuIgcl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxL4-00Fd4d-2T;
	Tue, 25 Nov 2025 18:00:32 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 038/145] smb: smbdirect: introduce smbdirect_connection_recv_io_done()
Date: Tue, 25 Nov 2025 18:54:44 +0100
Message-ID: <f278687eb65fb23b1cba9f724c41815979572655.1764091285.git.metze@samba.org>
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

This is basically a copy of recv_done() in client and server,
with the following additions:

- Only handling the SMBDIRECT_EXPECT_DATA_TRANSFER code path,
  as we'll have separate functions for the negotiate messages.
- Using more helper variables
- Improved logging
- Add credits_requested == 0 error check
- Add data_offset not 8 bytes aligned error check
- Use disable_work(&sc->recv_io.posted.refill_work)
  before smbdirect_connection_put_recv_io, when it
  is followed by smbdirect_socket_schedule_cleanup()

This will be used on common between client and server in future
and replace the existing recv_done() functions.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 167 ++++++++++++++++++
 1 file changed, 167 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 5c604b6bc853..c1e159b41a36 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -683,6 +683,173 @@ static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 	return ret;
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct smbdirect_recv_io *recv_io =
+		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
+	struct smbdirect_socket *sc = recv_io->socket;
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_data_transfer *data_transfer;
+	u16 old_recv_credit_target;
+	u16 credits_requested;
+	u16 credits_granted;
+	u16 flags;
+	u32 data_offset;
+	u32 data_length;
+	u32 remaining_data_length;
+
+	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_RECV))) {
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
+				"wc->status=%s (%d) wc->opcode=%d\n",
+				ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+		goto error;
+	}
+
+	smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_INFO,
+		"recv_io=0x%p type=%d wc status=%s wc opcode %d byte_len=%d pkey_index=%u\n",
+		recv_io, sc->recv_io.expected,
+		ib_wc_status_msg(wc->status), wc->opcode,
+		wc->byte_len, wc->pkey_index);
+
+	/*
+	 * Reset timer to the keepalive interval in
+	 * order to trigger our next keepalive message.
+	 */
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->keepalive_interval_msec));
+
+	ib_dma_sync_single_for_cpu(sc->ib.dev,
+				   recv_io->sge.addr,
+				   recv_io->sge.length,
+				   DMA_FROM_DEVICE);
+
+	if (unlikely(wc->byte_len <
+	    offsetof(struct smbdirect_data_transfer, padding))) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"wc->byte_len=%u < %zu\n",
+			wc->byte_len,
+			offsetof(struct smbdirect_data_transfer, padding));
+		goto error;
+	}
+
+	data_transfer = (struct smbdirect_data_transfer *)recv_io->packet;
+	credits_requested = le16_to_cpu(data_transfer->credits_requested);
+	credits_granted = le16_to_cpu(data_transfer->credits_granted);
+	flags = le16_to_cpu(data_transfer->flags);
+	remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
+	data_offset = le32_to_cpu(data_transfer->data_offset);
+	data_length = le32_to_cpu(data_transfer->data_length);
+
+	smbdirect_log_incoming(sc, SMBDIRECT_LOG_INFO,
+		"DataIn: %s=%u, %s=%u, %s=0x%x, %s=%u, %s=%u, %s=%u\n",
+		"CreditsRequested",
+		credits_requested,
+		"CreditsGranted",
+		credits_granted,
+		"Flags",
+		flags,
+		"RemainingDataLength",
+		remaining_data_length,
+		"DataOffset",
+		data_offset,
+		"DataLength",
+		data_length);
+
+	if (unlikely(credits_requested == 0)) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: credits_requested == 0\n");
+		goto error;
+	}
+
+	if (unlikely(data_offset % 8 != 0)) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: data_offset=%u (0x%x) not aligned to 8\n",
+			data_offset, data_offset);
+		goto error;
+	}
+
+	if (unlikely(wc->byte_len < data_offset ||
+	    (u64)wc->byte_len < (u64)data_offset + data_length)) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"wc->byte_len=%u < date_offset=%u + data_length=%u\n",
+			wc->byte_len, data_offset, data_length);
+		goto error;
+	}
+
+	if (unlikely(remaining_data_length > sp->max_fragmented_recv_size ||
+	    data_length > sp->max_fragmented_recv_size ||
+	    (u64)remaining_data_length + (u64)data_length > (u64)sp->max_fragmented_recv_size)) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"remaining_data_length=%u + data_length=%u > max_fragmented=%u\n",
+			remaining_data_length, data_length, sp->max_fragmented_recv_size);
+		goto error;
+	}
+
+	if (data_length) {
+		if (sc->recv_io.reassembly.full_packet_received)
+			recv_io->first_segment = true;
+
+		if (remaining_data_length)
+			sc->recv_io.reassembly.full_packet_received = false;
+		else
+			sc->recv_io.reassembly.full_packet_received = true;
+	}
+
+	atomic_dec(&sc->recv_io.posted.count);
+	atomic_dec(&sc->recv_io.credits.count);
+	old_recv_credit_target = sc->recv_io.credits.target;
+	/*
+	 * We take the value from the peer, which is checked to be higher than 0,
+	 * but we limit it to the max value we support in order to have
+	 * the main logic simpler.
+	 */
+	sc->recv_io.credits.target = credits_requested;
+	sc->recv_io.credits.target = min_t(u16, sc->recv_io.credits.target,
+					   sp->recv_credit_max);
+	if (credits_granted) {
+		atomic_add(credits_granted, &sc->send_io.credits.count);
+		/*
+		 * We have new send credits granted from remote peer
+		 * If any sender is waiting for credits, unblock it
+		 */
+		wake_up(&sc->send_io.credits.wait_queue);
+	}
+
+	/* Send an immediate response right away if requested */
+	if (flags & SMBDIRECT_FLAG_RESPONSE_REQUESTED) {
+		smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
+			"schedule send of immediate response\n");
+		queue_work(sc->workqueue, &sc->idle.immediate_work);
+	}
+
+	/*
+	 * If this is a packet with data playload place the data in
+	 * reassembly queue and wake up the reading thread
+	 */
+	if (data_length) {
+		if (sc->recv_io.credits.target > old_recv_credit_target)
+			queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
+
+		smbdirect_connection_reassembly_append_recv_io(sc, recv_io, data_length);
+		wake_up(&sc->recv_io.reassembly.wait_queue);
+	} else
+		smbdirect_connection_put_recv_io(recv_io);
+
+	return;
+
+error:
+	/*
+	 * Make sure smbdirect_connection_put_recv_io() does not
+	 * start recv_io.posted.refill_work.
+	 */
+	disable_work(&sc->recv_io.posted.refill_work);
+	smbdirect_connection_put_recv_io(recv_io);
+	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+}
+
 static int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
 {
 	int missing;
-- 
2.43.0

