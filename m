Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797679;
	b=3JfqSualWfA3WYj7/wH8vrlrl/rvwD6pjhAXk/zcMlzSz4K6T16Z4EYuNWO2wtZsU37q
	 1b/A7MqLL52L88wsZXlgHGKNIUkQ9R+8ZL/U+4+sxzgway1OFxn57dtQy14QqvNppVzAN
	 junxyIeR+venHFwMVOxpWlQ09BWW8YZhKaa6lGHt3OXgiLODLEFsFNVE8LdUwfzQCucIr
	 V7IqloltDeJBG9CXLKUMCVmZi+gbTsQvTWr6OeWFFDpUE9xq4kZSoWqgJKVdR0cYzMyXJ
	 nkjYGBospeWk6HDbOWf3nvakba7/fy6rzqEJXifYKVH/a5ikI12vpIed2WsjgIH0glQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797679;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LqBTL9Uyvbs9ijEQE9o6wq6Wxsuod6bePmHEO21XuHk=;
	b=G8RDWre5JMeUV6ietoDnc1OOoxo33eM+UrxeQLjt9mUuDHoyrSX1oz/saxSu7cfEn1PQ
	 Dn/m8JxvANk27Xtm0WWbBCVe0NkSYNRk0xoGV289dvJgxvGnOeFLWPADwm6RN7O6B8Vbr
	 3EFZHOlBaPYpA9GxVM+FaKwbQ2bCR9mr9z3CjURuzXcLeqsRH2ZonPooCUtstP0kehEzs
	 dGgC4yim8nyaQQFyBUTPkj4qEBAa78Y+P6fkBaqeRo0oGKxeuCWQqR1S/a5AEVNuYyVWZ
	 TJZ66SuSoKGSYtIeCiCyChIL3EXcFAZH2E2YKYcHAEDAOCrSYr/l3TFGlVsfvjQ0HUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=pRGYjk1B;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD771606A326;
	Fri, 27 Nov 2026 16:41:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD771606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=pRGYjk1B
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=LqBTL9Uyvbs9ijEQE9o6wq6Wxsuod6bePmHEO21XuHk=; b=pRGYjk1BpLFKK+c0mOucJ9y/Fb
	KFlQD2rOi7d5yd8CSDYSBjQNZxYJR4fERYBbq2UdkfqH7gsBeOPRBtXkaJe6Eo32TNCYbk2VYTHgK
	fJzZ5tB9lxoUi+UTWnE4Iynqn/MoeBwCjFa5Agy2qVqWqNJIzZE58a4se7JzWSoPPPvSkni1+50NK
	MbrhlamYusDgt/iYv5IqILLQTZKGwZy35HkW0ZWSf1QjPkNJlw1LQ/1rUuAe+3XhVPY//wXxviDzr
	IUlyAJdGAdAJxempOIEI+LjqpBGLMwoFVZempGdSAPdjZi+EPFbuu8j8COqHzJaN2SgjWsuuiEU76
	Xip8afiXnAIodRAKugWQVbKYT0K0zHM5cm4gMZDaR9kRzOCRzLg6WJDAJcNbttbeCUkj+Ts+8lcZb
	Ce/5qeNrd103sghhgg61FJdZCNZyG4cOaFDDBmQPylXT9CxI8OHWQpUuRKhy6hEjyPe0MfkatEBzl
	Q16lhXPCdwRR1YVc0NCpq8GX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz0a-00000001Px3-0LlW;
	Fri, 27 Nov 2026 16:41:12 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 06/13] smb: smbdirect: introduce smbdirect_connection_invalidate_rkey() and its logic
Date: Fri, 27 Nov 2026 17:40:25 +0100
Message-ID: <8a8728d593681589b149ef5993bda8fe4ee21c46.1795794871.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795794871.git.metze@samba.org>
References: <cover.1795794871.git.metze@samba.org>
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

smbdirect_mr_io_disable_locked() clears need_invalidate under
sc->mr_io.all.lock before it deregisters mr->mr, so a concurrent
smbdirect_connection_invalidate_rkey() for a receive with
IB_WC_WITH_INVALIDATE never looks at a deregistered mr->mr.

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/connection.c |  12 ++--
 fs/smb/smbdirect/internal.h   |   2 +
 fs/smb/smbdirect/mr.c         | 119 ++++++++++++++++++++++++++++++++--
 fs/smb/smbdirect/socket.h     |   3 +
 include/linux/smbdirect.h     |   2 +-
 5 files changed, 127 insertions(+), 11 deletions(-)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index 9a824f4f76c5..871750529a98 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -1646,10 +1646,14 @@ void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
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
index c50cdb1b6cc4..7c7607c26b0b 100644
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
@@ -78,12 +98,23 @@ int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
 static void smbdirect_mr_io_disable_locked(struct smbdirect_mr_io *mr)
 {
 	struct smbdirect_socket *sc = mr->socket;
+	unsigned long flags;
 
 	lockdep_assert_held(&mr->mutex);
 
 	if (mr->state == SMBDIRECT_MR_DISABLED)
 		return;
 
+	/*
+	 * smbdirect_connection_invalidate_rkey() only looks at mr->mr
+	 * while need_invalidate is set, so clear it before mr->mr
+	 * is deregistered.
+	 */
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+	mr->state = SMBDIRECT_MR_DISABLED;
+	mr->need_invalidate = false;
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+
 	if (mr->mr)
 		ib_dereg_mr(mr->mr);
 	if (mr->sgt.nents)
@@ -93,8 +124,6 @@ static void smbdirect_mr_io_disable_locked(struct smbdirect_mr_io *mr)
 	mr->mr = NULL;
 	mr->sgt.sgl = NULL;
 	mr->sgt.nents = 0;
-
-	mr->state = SMBDIRECT_MR_DISABLED;
 }
 
 static void smbdirect_mr_io_free_locked(struct kref *kref)
@@ -121,6 +150,11 @@ void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
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
@@ -265,12 +299,13 @@ struct smbdirect_mr_io *
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
@@ -291,7 +326,6 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 	mutex_lock(&mr->mutex);
 
 	mr->dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-	mr->need_invalidate = need_invalidate;
 	mr->sgt.nents = 0;
 	mr->sgt.orig_nents = 0;
 
@@ -351,6 +385,8 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 	}
 
 	ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
+	if (mr->mr->rkey == mr->base_tag)
+		ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
 	reg_wr = &mr->wr;
 	reg_wr->wr.opcode = IB_WR_REG_MR;
 	mr->cqe.done = smbdirect_connection_mr_io_register_done;
@@ -363,6 +399,10 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
 			IB_ACCESS_REMOTE_READ;
 
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+	mr->need_invalidate = true;
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+
 	/*
 	 * There is no need for waiting for complemtion on ib_post_send
 	 * on IB_WR_REG_MR. Hardware enforces a barrier and order of execution
@@ -380,6 +420,10 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		return mr;
 	}
 
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+	mr->need_invalidate = false;
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+
 	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
 		"ib_post_send failed ret=%d (%1pe) reg_wr->key=0x%x\n",
 		ret, SMBDIRECT_DEBUG_ERR_PTR(ret), reg_wr->key);
@@ -443,6 +487,8 @@ EXPORT_SYMBOL_GPL(smbdirect_mr_io_fill_buffer_descriptor);
 void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 {
 	struct smbdirect_socket *sc = mr->socket;
+	bool need_invalidate;
+	unsigned long flags;
 	int ret = 0;
 
 lock_again:
@@ -455,7 +501,12 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
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
@@ -483,7 +534,6 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 		 */
 		mutex_unlock(&mr->mutex);
 		wait_for_completion(&mr->invalidate_done);
-		mr->need_invalidate = false;
 		goto lock_again;
 	} else
 		/*
@@ -526,3 +576,60 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
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

