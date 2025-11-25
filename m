Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF85127510E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094731; cv=none; b=Ynm5iuvBA4+hw4okCwCFrlxSUBvFt+qh6MPLvINQCdd5X8pQULqqFZU9Yn+NLcBdKPoIpfvVBFg8ureOnKrSOD7uW7wGVB2uMKoNqLpN57hs/gwS0kane95Jr0yrQ5qgGCIruPePL8IO0jhv93EwHtEjq6WbY2DLsQaP0FTCi7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094731; c=relaxed/simple;
	bh=e/WMA9S+NoPk5N7R7ERa7Rv4UDmyGzat+wvlRkjBNHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajcg4xxfVudzaYm6lJeDmftwdD3POpYpKQeYUtHc9Bx6emxX28Tr9E1jVkaJ7ZKz1UjhjVuPCyStJmdoGBUCZaEpvkG7uVOl+Zp5do5Qsk2SkYm0mUTRashU00H5jUvY1R5nZIPqy/CH1x21N3v7FyqKVCm6BSoG4+piIIk1UU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VLPXXUxF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VLPXXUxF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=mpaj7bJbEtEpbhx6XtR3fWvXYrtu1mvvJQoxHzozDh8=; b=VLPXXUxFPJOe9UUAMFlB0qmqkO
	UGJ+OvUGBJEIb00yA5gP8iKK+e0x3JAzLVdGuyRN0qqCaGaMgqYjonrC2RvJJD9+L+YFoAKlJtwUk
	hyKZ/2a6Lit448QkZ8/eoXPNBg2MSdT/BWsce8xg+nvTJVyD1Qe02OobBBFpXWGtNwizzmAtdvzQp
	nIzvyZDn5JHGnis0qv7f5hB8g9ky9Se43BncEPZ/ilgsCZzfiibqtK0esCcH3LdwsjU6CVSchRrrQ
	+rhOW7ltb+bH9Gr8elLo09adU+iwe6/NXzxtX60AK45ZYh66qLtyXnYEHSZU+MiO4xFalvcMlPntl
	FIjUDk6uHaURnX+tMlAgT4Nd/v6G1zBjHUPSgGBrfua5LRDiwmR9Jtwod/bj0Bfxwz49MDqjcXvi2
	Dbue2bxUtdQI7g6hNBXcdAfkF+bt/KfcvqrLfM/Mhs91QSv5z0z9w5ad1gE/NfriPoKetwKe+p3pK
	cNvUj2EDoYqSatjAyy6bh93Z;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxVI-00FeIb-1h;
	Tue, 25 Nov 2025 18:11:07 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 103/145] smb: server: make use of smbdirect_connection_{get,put}_recv_io()
Date: Tue, 25 Nov 2025 18:55:49 +0100
Message-ID: <76bb7c8f946f30ccc1fb5d74306b4b116314527b.1764091285.git.metze@samba.org>
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

These are basically copies of {get,put}_receive_buffer() in the client.
They are very similar to {get_free,put}_recvmsg() the only logical
difference is the updating of the sc->statistics.*.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 69 ++++++++--------------------------
 1 file changed, 16 insertions(+), 53 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 88c4b4bf568d..1c926e46a354 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -215,43 +215,6 @@ static inline void
 	return (void *)recvmsg->packet;
 }
 
-static struct
-smbdirect_recv_io *get_free_recvmsg(struct smbdirect_socket *sc)
-{
-	struct smbdirect_recv_io *recvmsg = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
-	if (!list_empty(&sc->recv_io.free.list)) {
-		recvmsg = list_first_entry(&sc->recv_io.free.list,
-					   struct smbdirect_recv_io,
-					   list);
-		list_del(&recvmsg->list);
-	}
-	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
-	return recvmsg;
-}
-
-static void put_recvmsg(struct smbdirect_socket *sc,
-			struct smbdirect_recv_io *recvmsg)
-{
-	unsigned long flags;
-
-	if (likely(recvmsg->sge.length != 0)) {
-		ib_dma_unmap_single(sc->ib.dev,
-				    recvmsg->sge.addr,
-				    recvmsg->sge.length,
-				    DMA_FROM_DEVICE);
-		recvmsg->sge.length = 0;
-	}
-
-	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
-	list_add(&recvmsg->list, &sc->recv_io.free.list);
-	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
-
-	queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
-}
-
 static void enqueue_reassembly(struct smbdirect_socket *sc,
 			       struct smbdirect_recv_io *recvmsg,
 			       int data_length)
@@ -424,7 +387,7 @@ static void free_transport(struct smb_direct_transport *t)
 		if (recvmsg) {
 			list_del(&recvmsg->list);
 			spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 		} else {
 			spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
 		}
@@ -543,7 +506,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	sp = &sc->parameters;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
-		put_recvmsg(sc, recvmsg);
+		smbdirect_connection_put_recv_io(recvmsg);
 		if (wc->status != IB_WC_WR_FLUSH_ERR) {
 			pr_err("Recv error. status='%s (%d)' opcode=%d\n",
 			       ib_wc_status_msg(wc->status), wc->status,
@@ -571,7 +534,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	switch (sc->recv_io.expected) {
 	case SMBDIRECT_EXPECT_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 			smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 			return;
 		}
@@ -584,7 +547,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (!sc->first_error && sc->status == SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING)
 			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
 		if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_NEGOTIATE_NEEDED)) {
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 			smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 			return;
 		}
@@ -600,7 +563,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 		if (wc->byte_len <
 		    offsetof(struct smbdirect_data_transfer, padding)) {
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 			smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 			return;
 		}
@@ -610,7 +573,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		data_offset = le32_to_cpu(data_transfer->data_offset);
 		if (wc->byte_len < data_offset ||
 		    wc->byte_len < (u64)data_offset + data_length) {
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 			smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 			return;
 		}
@@ -618,7 +581,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		    data_length > sp->max_fragmented_recv_size ||
 		    (u64)remaining_data_length + (u64)data_length >
 		    (u64)sp->max_fragmented_recv_size) {
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 			smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 			return;
 		}
@@ -660,7 +623,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			enqueue_reassembly(sc, recvmsg, (int)data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 
 		return;
 	}
@@ -673,7 +636,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	 * This is an internal error!
 	 */
 	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
-	put_recvmsg(sc, recvmsg);
+	smbdirect_connection_put_recv_io(recvmsg);
 	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 }
 
@@ -799,7 +762,7 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 					spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
 				}
 				queue_removed++;
-				put_recvmsg(sc, recvmsg);
+				smbdirect_connection_put_recv_io(recvmsg);
 				offset = 0;
 			} else {
 				offset += to_copy;
@@ -843,7 +806,7 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
 	if (atomic_read(&sc->recv_io.credits.count) < sc->recv_io.credits.target) {
 		while (true) {
-			recvmsg = get_free_recvmsg(sc);
+			recvmsg = smbdirect_connection_get_recv_io(sc);
 			if (!recvmsg)
 				break;
 
@@ -852,7 +815,7 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 			ret = smb_direct_post_recv(sc, recvmsg);
 			if (ret) {
 				pr_err("Can't post recv: %d\n", ret);
-				put_recvmsg(sc, recvmsg);
+				smbdirect_connection_put_recv_io(recvmsg);
 				break;
 			}
 			credits++;
@@ -1853,7 +1816,7 @@ static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
 
 	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REQ;
 
-	recvmsg = get_free_recvmsg(sc);
+	recvmsg = smbdirect_connection_get_recv_io(sc);
 	if (!recvmsg)
 		return -ENOMEM;
 
@@ -1879,7 +1842,7 @@ static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
 	 * will unmap it exactly once.
 	 */
 	if (!recv_posted)
-		put_recvmsg(sc, recvmsg);
+		smbdirect_connection_put_recv_io(recvmsg);
 	return ret;
 }
 
@@ -1919,7 +1882,7 @@ static void smb_direct_destroy_pools(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *recvmsg;
 
-	while ((recvmsg = get_free_recvmsg(sc)))
+	while ((recvmsg = smbdirect_connection_get_recv_io(sc)))
 		mempool_free(recvmsg, sc->recv_io.mem.pool);
 
 	mempool_destroy(sc->recv_io.mem.pool);
@@ -2244,7 +2207,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	sc->recv_io.reassembly.queue_length--;
 	list_del(&recvmsg->list);
 	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-	put_recvmsg(sc, recvmsg);
+	smbdirect_connection_put_recv_io(recvmsg);
 
 	if (ret == -ECONNABORTED)
 		return ret;
-- 
2.43.0

