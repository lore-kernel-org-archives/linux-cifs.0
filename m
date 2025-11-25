Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5533C32C92D
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094025; cv=none; b=FV3w7J2G6nCzV5LxtvUSdPKuGu06NH/JS4lCPhKgoaxpTwJZ3lwSjONzzkUozfBbNPdHNhAghnDfXZFl1yojQPuXZgdLbhlyVX2BDphrGKYO2CnVmJt+/sboFCE4EKDrNFS5issmZI++JB8dxZ9dG2kjIpzXVKQZfdMvbVOHumU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094025; c=relaxed/simple;
	bh=q4pbLYWAv43QKZfESdXjurEdBlZscbyXGHxLMsXGvyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJmAga51pEWViGiYL12poEQ29P+d+PZYxHN+27pvam6c9iiFr9wkcJ6yZM6khX8LkeLc1EuQn2tvCoRbUa8c6IPbuUDBPVh/PbIrC4xEqH+WEY422BbViifvEDWhd/89k8/kigpiQJhF4QtzRkEAF8GVnC89sDwNEVTuVK2TQmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=31LGh6gV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="31LGh6gV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=eAGuAwzrn2sopTNxxvdK11I+e3HMf3Tq862eWmfdIbQ=; b=31LGh6gVTvH09I6sAz3a/V29MM
	vzkqnura9YRIQ/hMsnLGVu+c5I/RkwwCRCgsJzNjmYSqBtAK1xvxI8Q0de7DKsuZCKHW9qmpVfTfB
	dui95Wf1+AQJLsq/NMNDiwTJ+R1x9KS0+M+CArPvTAvTeAkMx4ri7daj32hAnj/KaW8DEjedYLm0U
	bQwmeQ9iuZlo3nC9X2S7SzQNjnzgIndaPXDfDq36+UnuV+WmL66+aNSIJx7O5+rDZQhDnveZBhgad
	M31yY8WKzOdFZzbiFw4bC7DiZ4GgvrFJnctOP6ACZUnsY3cGFdlvcte0zPQyJFfALn5f35s+Z3RuP
	uwcG9/Fxv7Ax/Z2wL7i78r4PrPCxPrVt8OwIf50+KPcQNPaRxxT2giVFcO/0Z78hwzzszuv3BFymO
	UPS5+J0tZ7g6Lo+4gnS8VAh9xKFdjZBrqyENbywl8h/zIqOFJiM3mF78QC+bhGih9fVTcb58ZEUIQ
	h4Xcr9jyz5or/xkDwLZt/1dp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxOE-00Fde3-1y;
	Tue, 25 Nov 2025 18:03:47 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 067/145] smb: client: make use of smbdirect_connection_{get,put}_recv_io()
Date: Tue, 25 Nov 2025 18:55:13 +0100
Message-ID: <d7630ff3ad4fa82df445c1c188ab55cb055f915f.1764091285.git.metze@samba.org>
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

These are basically copies of {get,put}_receive_buffer().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 78 ++++++---------------------------------
 1 file changed, 11 insertions(+), 67 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b501060d6e3c..21d08171cc85 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -23,11 +23,6 @@ const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connec
 	return &sc->parameters;
 }
 
-static struct smbdirect_recv_io *get_receive_buffer(
-		struct smbdirect_socket *sc);
-static void put_receive_buffer(
-		struct smbdirect_socket *sc,
-		struct smbdirect_recv_io *response);
 static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf);
 static void destroy_receive_buffers(struct smbdirect_socket *sc);
 
@@ -531,7 +526,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 	if (sc->recv_io.credits.target >
 		atomic_read(&sc->recv_io.credits.count)) {
 		while (true) {
-			response = get_receive_buffer(sc);
+			response = smbdirect_connection_get_recv_io(sc);
 			if (!response)
 				break;
 
@@ -540,7 +535,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 			if (rc) {
 				log_rdma_recv(ERR,
 					"post_recv failed rc=%d\n", rc);
-				put_receive_buffer(sc, response);
+				smbdirect_connection_put_recv_io(response);
 				break;
 			}
 
@@ -604,7 +599,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		sc->recv_io.reassembly.full_packet_received = true;
 		negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
-		put_receive_buffer(sc, response);
+		smbdirect_connection_put_recv_io(response);
 		if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_NEGOTIATE_RUNNING))
 			negotiate_done = false;
 		if (!negotiate_done) {
@@ -690,7 +685,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			enqueue_reassembly(sc, response, data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
-			put_receive_buffer(sc, response);
+			smbdirect_connection_put_recv_io(response);
 
 		return;
 
@@ -705,7 +700,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	log_rdma_recv(ERR, "unexpected response type=%d\n", sc->recv_io.expected);
 	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
 error:
-	put_receive_buffer(sc, response);
+	smbdirect_connection_put_recv_io(response);
 	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 }
 
@@ -1263,7 +1258,7 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int rc;
-	struct smbdirect_recv_io *response = get_receive_buffer(sc);
+	struct smbdirect_recv_io *response = smbdirect_connection_get_recv_io(sc);
 
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
@@ -1274,7 +1269,7 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
 		       rc, response->sge.addr,
 		       response->sge.length, response->sge.lkey);
 	if (rc) {
-		put_receive_buffer(sc, response);
+		smbdirect_connection_put_recv_io(response);
 		return rc;
 	}
 
@@ -1350,57 +1345,6 @@ static struct smbdirect_recv_io *_get_first_reassembly(struct smbdirect_socket *
 	return ret;
 }
 
-/*
- * Get a receive buffer
- * For each remote send, we need to post a receive. The receive buffers are
- * pre-allocated in advance.
- * return value: the receive buffer, NULL if none is available
- */
-static struct smbdirect_recv_io *get_receive_buffer(struct smbdirect_socket *sc)
-{
-	struct smbdirect_recv_io *ret = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
-	if (!list_empty(&sc->recv_io.free.list)) {
-		ret = list_first_entry(
-			&sc->recv_io.free.list,
-			struct smbdirect_recv_io, list);
-		list_del(&ret->list);
-		sc->statistics.get_receive_buffer++;
-	}
-	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
-
-	return ret;
-}
-
-/*
- * Return a receive buffer
- * Upon returning of a receive buffer, we can post new receive and extend
- * more receive credits to remote peer. This is done immediately after a
- * receive buffer is returned.
- */
-static void put_receive_buffer(
-	struct smbdirect_socket *sc, struct smbdirect_recv_io *response)
-{
-	unsigned long flags;
-
-	if (likely(response->sge.length != 0)) {
-		ib_dma_unmap_single(sc->ib.dev,
-				    response->sge.addr,
-				    response->sge.length,
-				    DMA_FROM_DEVICE);
-		response->sge.length = 0;
-	}
-
-	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
-	list_add_tail(&response->list, &sc->recv_io.free.list);
-	sc->statistics.put_receive_buffer++;
-	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
-
-	queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
-}
-
 /* Preallocate all receive buffer on transport establishment */
 static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf)
 {
@@ -1437,7 +1381,7 @@ static void destroy_receive_buffers(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *response;
 
-	while ((response = get_receive_buffer(sc)))
+	while ((response = smbdirect_connection_get_recv_io(sc)))
 		mempool_free(response, sc->recv_io.mem.pool);
 }
 
@@ -1543,7 +1487,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 			list_del(&response->list);
 			spin_unlock_irqrestore(
 				&sc->recv_io.reassembly.lock, flags);
-			put_receive_buffer(sc, response);
+			smbdirect_connection_put_recv_io(response);
 		} else
 			spin_unlock_irqrestore(
 				&sc->recv_io.reassembly.lock, flags);
@@ -2082,9 +2026,9 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 				}
 				queue_removed++;
 				sc->statistics.dequeue_reassembly_queue++;
-				put_receive_buffer(sc, response);
+				smbdirect_connection_put_recv_io(response);
 				offset = 0;
-				log_read(INFO, "put_receive_buffer offset=0\n");
+				log_read(INFO, "smbdirect_connection_put_recv_io offset=0\n");
 			} else
 				offset += to_copy;
 
-- 
2.43.0

