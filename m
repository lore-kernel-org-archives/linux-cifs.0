Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456A32DFF28
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744740; cv=none; b=WZ0kQyrW4Ue5C6bRJRU/b6h2PBOtCuqCuzAAjepTtJtFSmAkBTzp7LK2pVofpuTD0P6mq6yHQyeeRCFu9l7SjaDWJ/vthnrTb2LMxeoViKOt+67hoIEDCv0xw2B7fd3Nwii2Da1vIt1KwEEC6f9oYqZjt0oGuj+b5ACFGO+FOPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744740; c=relaxed/simple;
	bh=61bmPtCrL0jAvCTUjLFdLaW7eitWyH0x0AHkDHh0Nx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poBXwYohcSTX5yavAS3zF3ljG2tGi/g7f48TdkwUTK9ot+10iVKZ+oFrOQ972UqhDidg1twep1qVsp8H4kQ51063U3mfibfxR9W0MOWTGB/ft4eUP07Y+QXOyuwQRHusYkH5UynajZ1YWsC/VjtiFdOD5lm1HOISpz/qA3dgk8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=mM+bxr2O; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="mM+bxr2O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=fPrgaiWfnNpccxjgcdrCYh+EgGe6gPk4QuqgysM3MV8=; b=mM+bxr2OPz8EI5XfnGFxKZ0vHb
	p7ngnT4N0Y6snn6OFiwWP3wut4FJIOHhVT5Fual59eUAvInCXVYwYQCnKdIbWdFyt4Ws6q6kEfMhC
	yCuKSIlmn/qsfvJsm/zxqyZjOtI2xsccnKqGLQNhtALBtHETBYP1TO7yYLystYY4JSu9vY9LMe8mG
	QXnEwbfbPmWcsKdzAtNnIJGZrEu/57hJ2Yxu4rB+fjcvZ+XFpu3d38ozJypqcxm0vPenHTZL+0/6n
	ArpYo30ZIr69B7i0j1EiBpT2LF23V/eNBHnvzBQqZH4laaz3O+Pq5B/Jw+nGiRsSYJ3bjPXGRE6ok
	sWcfG6RtPZmmTPDmjF+fXAHV5ZkRP/BzuJ1hIkCGhJyccwGJ+IIneiWlU1BDYCgNbMuAg6O2AGXD1
	cqCverAWbu9ye3hleLaTjWiVefJ5c08iUpq48ZsPeIwYVEvBulBA40RbQARl0uTq7X66o/U5DIeDk
	fgKLxlNqfSvXiPweJYzRHN06;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Hc-00BchZ-1P;
	Wed, 29 Oct 2025 13:32:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 097/127] smb: server: make use of smbdirect_connection_{get,put}_recv_io()
Date: Wed, 29 Oct 2025 14:21:15 +0100
Message-ID: <c1c248360cbf0e9253d310ab7fe1128234a53c36.1761742839.git.metze@samba.org>
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
 fs/smb/server/transport_rdma.c | 67 ++++++++--------------------------
 1 file changed, 15 insertions(+), 52 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 89db1cc921d2..cc64be846daf 100644
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
 			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 			return;
 		}
@@ -589,7 +552,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 		if (wc->byte_len <
 		    offsetof(struct smbdirect_data_transfer, padding)) {
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 			return;
 		}
@@ -599,7 +562,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		data_offset = le32_to_cpu(data_transfer->data_offset);
 		if (wc->byte_len < data_offset ||
 		    wc->byte_len < (u64)data_offset + data_length) {
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 			return;
 		}
@@ -607,7 +570,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		    data_length > sp->max_fragmented_recv_size ||
 		    (u64)remaining_data_length + (u64)data_length >
 		    (u64)sp->max_fragmented_recv_size) {
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 			return;
 		}
@@ -649,7 +612,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			enqueue_reassembly(sc, recvmsg, (int)data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
-			put_recvmsg(sc, recvmsg);
+			smbdirect_connection_put_recv_io(recvmsg);
 
 		return;
 	}
@@ -662,7 +625,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	 * This is an internal error!
 	 */
 	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
-	put_recvmsg(sc, recvmsg);
+	smbdirect_connection_put_recv_io(recvmsg);
 	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 }
 
@@ -788,7 +751,7 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 					spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
 				}
 				queue_removed++;
-				put_recvmsg(sc, recvmsg);
+				smbdirect_connection_put_recv_io(recvmsg);
 				offset = 0;
 			} else {
 				offset += to_copy;
@@ -832,7 +795,7 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
 	if (atomic_read(&sc->recv_io.credits.count) < sc->recv_io.credits.target) {
 		while (true) {
-			recvmsg = get_free_recvmsg(sc);
+			recvmsg = smbdirect_connection_get_recv_io(sc);
 			if (!recvmsg)
 				break;
 
@@ -841,7 +804,7 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 			ret = smb_direct_post_recv(sc, recvmsg);
 			if (ret) {
 				pr_err("Can't post recv: %d\n", ret);
-				put_recvmsg(sc, recvmsg);
+				smbdirect_connection_put_recv_io(recvmsg);
 				break;
 			}
 			credits++;
@@ -1830,7 +1793,7 @@ static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
 
 	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REQ;
 
-	recvmsg = get_free_recvmsg(sc);
+	recvmsg = smbdirect_connection_get_recv_io(sc);
 	if (!recvmsg)
 		return -ENOMEM;
 
@@ -1848,7 +1811,7 @@ static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
 
 	return 0;
 out_err:
-	put_recvmsg(sc, recvmsg);
+	smbdirect_connection_put_recv_io(recvmsg);
 	return ret;
 }
 
@@ -1888,7 +1851,7 @@ static void smb_direct_destroy_pools(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *recvmsg;
 
-	while ((recvmsg = get_free_recvmsg(sc)))
+	while ((recvmsg = smbdirect_connection_get_recv_io(sc)))
 		mempool_free(recvmsg, sc->recv_io.mem.pool);
 
 	mempool_destroy(sc->recv_io.mem.pool);
@@ -2211,7 +2174,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	sc->recv_io.reassembly.queue_length--;
 	list_del(&recvmsg->list);
 	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-	put_recvmsg(sc, recvmsg);
+	smbdirect_connection_put_recv_io(recvmsg);
 
 	if (ret == -ECONNABORTED)
 		return ret;
-- 
2.43.0

