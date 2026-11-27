Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782598;
	b=zxOo3H0LKpOg00FPSR8XcoUL86VGpWeZeEozVaaygf3ZF6OAhWxEd95vDkDJ+fdjIkwx
	 ff6D5cWdIOApgLD3D2ijani3tq7fsJeNRBkyx6M/aM7uRYomfVsjFoTjFowOZ+D7n1ElW
	 7r62gW+cgeqquh6m2/2bJaXIRXAQO0maBIyiGh3foCl8XHumNq9q5h8eD+YytNjF1xn5n
	 Ziy4qwL0sUSbzCuMwaN9tCjT84jStxFJmvFCKwX+GYRW0XQgkEst6kLJJtJjDFDN6wjGQ
	 wUqULBIhYd3aiR4AIuZ0X45zQHXxwC9swZuA6+LCurKTnGAeqmB8UjRiHF5zULw9QtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782598;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=11ZRGd5SnGHaTQgS8bJ+qnXN5aIRj84AwpMDkgkGhi0=;
	b=S/lQDgQiDqZUtk0TFWCFHX49JaRYX5f3YdfWh6f7SxHZ5KLy21TRUv9vWwnkVta9PBiS
	 FzsLAsg8+xMtGUJl8ST2m7dZUAIZ7nUlASgew/XyQ5EHkEtZy/DVxmznI+ATku7a+6NkG
	 BmkgBC3qGpkG8tgVCj3bNPn1Qxy4QuHXBq3IjJWzEMBondCVCE/o9PQnTQ6jLUT/PEGcZ
	 LFILBVJf76dBkZ7t/wp1gqfTKrNROsRVgflqWKiMclMcPZfEvPV6wfS4NFdoXLGQ/mBvC
	 qmWolbYMCYHBy2gDNcnE6NOOGbCr6eErqijtGLfJ2vNR83AR/ccWS9CampTfojrjr/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b="rWKuXX/2";
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C509D606A32F;
	Fri, 27 Nov 2026 12:29:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C509D606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=rWKuXX/2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=11ZRGd5SnGHaTQgS8bJ+qnXN5aIRj84AwpMDkgkGhi0=; b=rWKuXX/2ge7oA9qb3fPauVlhw1
	T/Zj6mbUjSiuAPAwRQAwo9nYfD61og3JAtza3RD/26KRsH0ssWUzY8C6sqp4LRsNFSqv5m0W3bKb8
	Lzh67NbqdvwVEjswwzAGdw0GPdGDxC0bExoaQru4/ANfwIN3hPwkwD2BdrT7Ee2cpXshCwn8oSIPl
	s2Ra3rsHci0LhCqkafCf8M4npU7cTD6FWMKK0ZvGvcZp97Sg0rQ7186JQvrIryw+EGUARTLEQodJZ
	Yro/g7DWkLBqmZE0AKje2W1ToKbU/u9amMmUxWkcQLfRO1uayu6qxt1A4V3Lb7/jn0HGjxFTW+EYi
	T1vWZNJ25mvgTx1eCnTThEjd97aviPMuHBLTLQtYB1E1qtWrcnW+skj68pQTfDfwjDu1/s7T4Hlda
	eth3slyYf1QgA71l2iXg9WJqIJqiPDHYVPxyfwKGVLnhrxpofFE/RPDfMONoFkeLV1GQLQWZhNNID
	jZ6HbopcnkiyAzgaFmqMsmGZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv5O-00000001Lcg-2EwL;
	Fri, 27 Nov 2026 12:29:54 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 06/10] smb: smbdirect: introduce smbdirect_connection_invalidate_rkey() and its logic
Date: Fri, 27 Nov 2026 13:29:03 +0100
Message-ID: <c170bca1e09f6ed8068e66e4b510adc770e2cb62.1795781300.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795781300.git.metze@samba.org>
References: <cover.1795781300.git.metze@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We remember all smbdirect_mr_io structures with their base_tag
in a per connection xarray to find them again.

This keeps track of remote invalidations done by the peer
and skips the IB_WR_LOCAL_INV in such a case.

Note we now ignore the 'need_invalidate' argument
of smbdirect_connection_register_mr_io(), it will
be removed in a follow up commit.

The logic to let the caller decide and pass in
'need_invalidate' is wrong as there can be errors
in the server, so that it may skip the remote invalidation.

Now we explicitly track remote invalidations by
looking at the IB_WC_WITH_INVALIDATE flag in
smbdirect_connection_recv_io_done().

Remote invalidations we can't match are only logged at the info
level: they are races with our own deregistration or keys we don't
track, the MR is then invalidated locally as before, and as error
messages a peer could flood the log with them.

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/connection.c |  12 ++--
 fs/smb/smbdirect/internal.h   |   2 +
 fs/smb/smbdirect/mr.c         | 110 ++++++++++++++++++++++++++++++++--
 fs/smb/smbdirect/socket.h     |   3 +
 include/linux/smbdirect.h     |   2 +-
 5 files changed, 120 insertions(+), 9 deletions(-)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index 3494189f41ee..8a5ab059c005 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -1640,10 +1640,14 @@ void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
 	}
 
 	smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_INFO,
-		"recv_io=0x%p type=%d wc status=%s wc opcode %d byte_len=%d pkey_index=%u\n",
-		recv_io, sc->recv_io.expected,
-		ib_wc_status_msg(wc->status), wc->opcode,
-		wc->byte_len, wc->pkey_index);
+		"recv_io=0x%p status=%s opcode %d byte_len=%d wc_flags=0x%x inv_rkey=0x%x\n",
+		recv_io, ib_wc_status_msg(wc->status), wc->opcode,
+		wc->byte_len, wc->wc_flags,
+		(wc->wc_flags & IB_WC_WITH_INVALIDATE) ?
+		wc->ex.invalidate_rkey : 0);
+
+	if (wc->wc_flags & IB_WC_WITH_INVALIDATE)
+		smbdirect_connection_invalidate_rkey(sc, wc->ex.invalidate_rkey);
 
 	/*
 	 * Reset timer to the keepalive interval in
diff --git a/fs/smb/smbdirect/internal.h b/fs/smb/smbdirect/internal.h
index 69d0c9f899de..fec71278421a 100644
--- a/fs/smb/smbdirect/internal.h
+++ b/fs/smb/smbdirect/internal.h
@@ -128,6 +128,8 @@ void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc);
 
 int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc);
 
+void smbdirect_connection_invalidate_rkey(struct smbdirect_socket *sc, u32 rkey);
+
 int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc);
 
 void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index fa2f7c19e7ee..54c53d0b2d64 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -60,6 +60,25 @@ int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
 		mr->socket = sc;
 
 		list_add_tail(&mr->list, &sc->mr_io.all.list);
+
+		mr->base_tag = mr->mr->rkey & ~U8_MAX;
+		ret = xa_insert_irq(&sc->mr_io.all.tags,
+				    mr->base_tag,
+				    mr,
+				    GFP_KERNEL);
+		if (ret) {
+			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+				"xa_insert_irq() for base_tag=0x%x failed: ret=%d (%1pe)\n",
+				mr->base_tag,
+				ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
+			/*
+			 * Already added to sc->mr_io.all.list,
+			 * so below we can just call
+			 * smbdirect_connection_destroy_mr_list()
+			 */
+			goto xa_insert_failed;
+		}
+
 		atomic_inc(&sc->mr_io.ready.count);
 	}
 
@@ -71,6 +90,7 @@ int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
 	mutex_destroy(&mr->mutex);
 	kfree(mr);
 kzalloc_mr_failed:
+xa_insert_failed:
 	smbdirect_connection_destroy_mr_list(sc);
 	return ret;
 }
@@ -78,6 +98,7 @@ int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
 static void smbdirect_mr_io_disable_locked(struct smbdirect_mr_io *mr)
 {
 	struct smbdirect_socket *sc = mr->socket;
+	unsigned long flags;
 
 	lockdep_assert_held(&mr->mutex);
 
@@ -94,7 +115,10 @@ static void smbdirect_mr_io_disable_locked(struct smbdirect_mr_io *mr)
 	mr->sgt.sgl = NULL;
 	mr->sgt.nents = 0;
 
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
 	mr->state = SMBDIRECT_MR_DISABLED;
+	mr->need_invalidate = false;
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
 }
 
 static void smbdirect_mr_io_free_locked(struct kref *kref)
@@ -121,6 +145,11 @@ void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
 	LIST_HEAD(all_list);
 	unsigned long flags;
 
+	/*
+	 * This means we don't need explicit
+	 * xa_erase() calls below.
+	 */
+	xa_destroy(&sc->mr_io.all.tags);
 	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
 	list_splice_tail_init(&sc->mr_io.all.list, &all_list);
 	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
@@ -265,12 +294,13 @@ struct smbdirect_mr_io *
 smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
 				    bool writing,
-				    bool need_invalidate)
+				    bool _ignored_need_invalidate)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_mr_io *mr;
 	int ret, num_pages, num_mapped;
 	struct ib_reg_wr *reg_wr;
+	unsigned long flags;
 
 	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
 	if (num_pages > sp->max_frmr_depth) {
@@ -291,7 +321,6 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 	mutex_lock(&mr->mutex);
 
 	mr->dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-	mr->need_invalidate = need_invalidate;
 	mr->sgt.nents = 0;
 	mr->sgt.orig_nents = 0;
 
@@ -345,6 +374,8 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 	}
 
 	ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
+	if (mr->mr->rkey == mr->base_tag)
+		ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
 	reg_wr = &mr->wr;
 	reg_wr->wr.opcode = IB_WR_REG_MR;
 	mr->cqe.done = smbdirect_connection_mr_io_register_done;
@@ -357,6 +388,10 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
 			IB_ACCESS_REMOTE_READ;
 
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+	mr->need_invalidate = true;
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+
 	/*
 	 * There is no need for waiting for complemtion on ib_post_send
 	 * on IB_WR_REG_MR. Hardware enforces a barrier and order of execution
@@ -374,6 +409,10 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		return mr;
 	}
 
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+	mr->need_invalidate = false;
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+
 	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
 		"ib_post_send failed ret=%d (%1pe) reg_wr->key=0x%x\n",
 		ret, SMBDIRECT_DEBUG_ERR_PTR(ret), reg_wr->key);
@@ -436,6 +475,8 @@ EXPORT_SYMBOL_GPL(smbdirect_mr_io_fill_buffer_descriptor);
 void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 {
 	struct smbdirect_socket *sc = mr->socket;
+	bool need_invalidate;
+	unsigned long flags;
 	int ret = 0;
 
 lock_again:
@@ -448,7 +489,12 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 		goto put_kref;
 	}
 
-	if (mr->need_invalidate) {
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+	need_invalidate = mr->need_invalidate;
+	mr->need_invalidate = false;
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+
+	if (need_invalidate) {
 		struct ib_send_wr *wr = &mr->inv_wr;
 
 		/* Need to finish local invalidation before returning */
@@ -476,7 +522,6 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 		 */
 		mutex_unlock(&mr->mutex);
 		wait_for_completion(&mr->invalidate_done);
-		mr->need_invalidate = false;
 		goto lock_again;
 	} else
 		/*
@@ -519,3 +564,60 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 		mutex_unlock(&mr->mutex);
 }
 EXPORT_SYMBOL_GPL(smbdirect_connection_deregister_mr_io);
+
+void smbdirect_connection_invalidate_rkey(struct smbdirect_socket *sc, u32 rkey)
+{
+	u32 base_tag = rkey & ~U8_MAX;
+	struct smbdirect_mr_io *mr;
+	unsigned long flags;
+
+	/*
+	 * This might be called from an interrupt context,
+	 * so we can't call mutex_lock(&mr->mutex); here.
+	 *
+	 * We run under the sc->mr_io.all.lock spin_lock
+	 */
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+
+	mr = xa_load(&sc->mr_io.all.tags, base_tag);
+	if (!mr) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
+			"xa_load() for base_tag=0x%x rkey=0x%x failed\n",
+			base_tag, rkey);
+		goto done;
+	}
+
+	if (!mr->need_invalidate) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
+			"invalidate rkey=0x%x for base_tag=0x%x not registered\n",
+			rkey, base_tag);
+		goto done;
+	}
+
+	if (WARN_ON_ONCE(mr->base_tag != base_tag))
+		goto done; /* internal error */
+
+	if (WARN_ON_ONCE(!mr->mr))
+		goto done; /* internal error */
+
+	if (mr->mr->rkey != rkey) {
+		/*
+		 * Maybe a local invalidate was faster
+		 * than the remote invalidate
+		 */
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
+			"invalidate rkey=0x%x for base_tag=0x%x stale rkey=0x%x\n",
+			rkey, base_tag, mr->mr->rkey);
+		goto done;
+	}
+
+	/*
+	 * We can skip IB_WR_LOCAL_INV in
+	 * smbdirect_connection_deregister_mr_io()
+	 */
+	mr->state = SMBDIRECT_MR_INVALIDATED;
+	mr->need_invalidate = false;
+
+done:
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+}
diff --git a/fs/smb/smbdirect/socket.h b/fs/smb/smbdirect/socket.h
index dc1e906316ff..4dcbd9c86aaf 100644
--- a/fs/smb/smbdirect/socket.h
+++ b/fs/smb/smbdirect/socket.h
@@ -411,6 +411,7 @@ struct smbdirect_socket {
 		 */
 		struct {
 			struct list_head list;
+			struct xarray tags;
 			spinlock_t lock;
 		} all;
 
@@ -671,6 +672,7 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 
 	spin_lock_init(&sc->mr_io.all.lock);
 	INIT_LIST_HEAD(&sc->mr_io.all.list);
+	xa_init_flags(&sc->mr_io.all.tags, XA_FLAGS_LOCK_IRQ);
 	atomic_set(&sc->mr_io.ready.count, 0);
 	init_waitqueue_head(&sc->mr_io.ready.wait_queue);
 	atomic_set(&sc->mr_io.used.count, 0);
@@ -837,6 +839,7 @@ struct smbdirect_mr_io {
 	struct list_head list;
 
 	enum smbdirect_mr_state state;
+	u32 base_tag;
 	struct ib_mr *mr;
 	struct sg_table sgt;
 	enum dma_data_direction dir;
diff --git a/include/linux/smbdirect.h b/include/linux/smbdirect.h
index 74fff00cdf88..f797cba849cd 100644
--- a/include/linux/smbdirect.h
+++ b/include/linux/smbdirect.h
@@ -175,7 +175,7 @@ struct smbdirect_mr_io *
 smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
 				    bool writing,
-				    bool need_invalidate);
+				    bool _ignored_need_invalidate);
 
 void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 					    struct smbdirect_buffer_descriptor_v1 *v1);
-- 
2.43.0

