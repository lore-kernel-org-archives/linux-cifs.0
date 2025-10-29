Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2FB3314B9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744520; cv=none; b=r432p3z4mOu0hXtKXa2YXLKxKPDk/3aNfkUIkgF0XoNWHYovTuxX131gHGXMZTUKBQhhwVwapDKmOvNIrISo4WaGaXA1QvkhnmtbEyKZtUx82ga1QhG/NV1+cKn9bkW/+CW2zuOIozcHN1q+w7LTGW4MW0QivzhhbQKjFv0IE/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744520; c=relaxed/simple;
	bh=DUL0HHICdCG0/s4YeRKU5kIUyq61cX3HR7SONKueLiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tM1wxrJPq1DKfDEHTIgK60Cce2ucRwwB7JkH3HyCFyOfVntTsU2f6+fYz6CE8hETKD8j5bzINiK5hy6MjUsaaJytjuPbf3Mso+yU/BXv+XELWCEMIZ6T7lxFq3OLzjz6yoxZbRdvgfhwVLL5Duilk98+OlO2/grCoeSR6+z+iEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OwRkhuaT; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OwRkhuaT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=c+2TCKs9knHpgaM2psNwVfAyJqiz46ksPKV802Vkb3s=; b=OwRkhuaTN4eycB3eH0IQqsziHY
	qm1OaUftTK0xhP82X8K7MvzmXB82CPl4Kd3zz6jLSng/wl1NthV/P41cmT/piyvYPDjrJ2GFoMUKn
	s9rUG0zRK7w1AkAWb6wp6D/8dXJCC1rKtGfqiYssJhR6b+EpOFSHv+H0Lt57OL0XyO51ElMhBNXp4
	gDtKORi3EkZVHB4Xpdv8t5447V+VhyIP5OsAL2DBm8mQ2SEeRvsyIiJfUrluW2zmx34T6S2p9K1Ql
	7hmASlbqaIslDXmEgVSZXog6IFNqI9VUMwHlD1aur/EKoft8IJ4O/DBen5x4IWLTfkc9DZCkolkDq
	3Igl0cTOz0UWI/lhyqik9eJ4YdW7t7CgG+jN9IXUyFshF2Dr3D5ulZv8125rnox4QbQJlCXvH6MDw
	rJo+BvJbIQUvedfVU4fDOKzyR6P7xqZwHXMRV1IJdhI3DACK+wSPQlJvb739mNNhNXpLCUVGd2ap8
	dortAGMqod3U7n2elUUPTwh6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6E7-00Bc6w-0S;
	Wed, 29 Oct 2025 13:28:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 062/127] smb: client: make use of smbdirect_connection_{get,put}_recv_io()
Date: Wed, 29 Oct 2025 14:20:40 +0100
Message-ID: <179854e6c2f24988416983186f5e748494c91826.1761742839.git.metze@samba.org>
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
index 8b98ef1d41e1..d76b25fc80f1 100644
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
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING);
 		if (!negotiate_done) {
 			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
@@ -689,7 +684,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			enqueue_reassembly(sc, response, data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
-			put_receive_buffer(sc, response);
+			smbdirect_connection_put_recv_io(response);
 
 		return;
 
@@ -704,7 +699,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	log_rdma_recv(ERR, "unexpected response type=%d\n", sc->recv_io.expected);
 	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
 error:
-	put_receive_buffer(sc, response);
+	smbdirect_connection_put_recv_io(response);
 	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 }
 
@@ -1262,7 +1257,7 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int rc;
-	struct smbdirect_recv_io *response = get_receive_buffer(sc);
+	struct smbdirect_recv_io *response = smbdirect_connection_get_recv_io(sc);
 
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
@@ -1273,7 +1268,7 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
 		       rc, response->sge.addr,
 		       response->sge.length, response->sge.lkey);
 	if (rc) {
-		put_receive_buffer(sc, response);
+		smbdirect_connection_put_recv_io(response);
 		return rc;
 	}
 
@@ -1349,57 +1344,6 @@ static struct smbdirect_recv_io *_get_first_reassembly(struct smbdirect_socket *
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
@@ -1434,7 +1378,7 @@ static void destroy_receive_buffers(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *response;
 
-	while ((response = get_receive_buffer(sc)))
+	while ((response = smbdirect_connection_get_recv_io(sc)))
 		mempool_free(response, sc->recv_io.mem.pool);
 }
 
@@ -1540,7 +1484,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 			list_del(&response->list);
 			spin_unlock_irqrestore(
 				&sc->recv_io.reassembly.lock, flags);
-			put_receive_buffer(sc, response);
+			smbdirect_connection_put_recv_io(response);
 		} else
 			spin_unlock_irqrestore(
 				&sc->recv_io.reassembly.lock, flags);
@@ -2079,9 +2023,9 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
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

