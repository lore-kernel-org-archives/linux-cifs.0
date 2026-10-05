Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739EB2F691D
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 19:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791229279; cv=none; b=FkGw5YBZ29zmQHAUhTJN+XSTbH0Oz2omqqyr2sD4UsLanj8gqLoYJBbPxVsVY20XZI9afABAB0LeIhOEqknvSSq2bnrteofMF+EHHCw8BTc+neznJsXpo0doV0giMT+zmpyfHBcecvJ7y1e3erxYdrCoR9tlRGniVW7+ShlT+s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791229279; c=relaxed/simple;
	bh=3l0RJdZ2ajwlUc/KimWycgHKZeIKv6G57h1m4ZIde8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c5k6LsqYa5FEL2OkfUdqua2A8wHmYBrkc5hpcjNhdhAx6toh2hMXlyCUNKNwsP2vl8jtrhLuJwIMZIzrF8hvm4pj+n0Iah7nBBivCU3uXteLWS6eiQblI7WW86GtKRB6bgKhXepjoRnknxvWy5esbf7d4NQVJYPyMJ4ffFFboR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=KoZz2ir6; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="KoZz2ir6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=kgriVvDRlBemiTtQkWFxkxRMykQhulQRKqyh444qjM0=; b=KoZz2ir6+xMNW+IvFc1noFf7Bx
	xx1TXN1zSekAC8RW2IxpURCR9wMYaySNduQ/BiGOB1ueujNERjy+ZqnJ+ad1CB4DOTchs0IdJugDa
	jc/Jf5yIcWRVxbqldfmzj/aUAJb/1elF3VnExmGptBGoghQgJE9DN128l4ljq9riJ4Ss29+pf8N42
	ypg3GRdDesLHr1gxoKdTBLjTYb6+qc+/x/2XNjWNP9CVbNyI97sCM6wMU2wjaDPIHLwK3L/8KaIvP
	IHgMLjJ+KeDbaqYTivzsS5qmmqjEDQ/tqgeWP//25u9QVzxMLPix2rlO3WlkyKpY7cHPCx+uRS/CA
	zRJAD5iJ6kDHqjNnydoumktP1CYkk6Q4fkdPSj4ITnuhNjXXe68npHbi1OwRnW5TfXhw6wnRsb152
	GnQMRYyJTxHz1Bct/3yg/9ks6ggKFgvZt9U7lM3gImX1oPl/oht/KyG8bJ7E6MyBbBmUkBn0V+jax
	64Ddw2ryGecN3bFQxyfqUatu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDoYj-00000005g2k-3qvV;
	Mon, 05 Oct 2026 19:41:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	=?UTF-8?q?=EB=A0=88=EB=93=9C=ED=8C=80=ED=95=98=EA=B3=A0=EC=8B=B6=EC=96=B4=EC=9A=94?= <ihopenre@gmail.com>,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 2/3] smb: smbdirect: release failed pending sockets of a listener
Date: Mon,  5 Oct 2026 21:40:47 +0200
Message-ID: <d59e3ee5218c4fe0f9fe0db5d20ce49dfb937502.1791229120.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791229120.git.metze@samba.org>
References: <cover.1791229120.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A child of a listener only left the listen.pending or listen.ready
list via smbdirect_socket_accept() or when the listener was
destroyed. So every connection that failed before it was accepted
(negotiate timeout, peer disconnect, invalid negotiate request, ...)
stayed on the list and counted against the backlog until the listener
was destroyed. After about backlog (10 for ksmbd) such connections
smbdirect_listen_connect_request() rejected every new connection with
-EBUSY, so an unauthenticated peer was able to permanently stop
ksmbd from accepting SMB-Direct connections.

Now a failed child moves itself to a new listen.orphaned list at the
end of smbdirect_socket_cleanup_work(), after the disconnect was
started, and queues listen.purge_orphaned_work, which releases it
with smbdirect_socket_release(), without holding the listener's
rdma_lock_handler() lock, in the same way smbdirect_socket_destroy()
does for the remaining children. Orphaned sockets still count against
the backlog until they are released.

sc->accept.listener is now only changed under listener->listen.lock
and whoever clears it is responsible for releasing the socket:
smbdirect_socket_accept(), purge_orphaned_work or the destroy of the
listener.

In order to make that work:

- a struct smbdirect_socket that is a listener is now freed via
  kfree_rcu(), so that a child can dereference sc->accept.listener
  under rcu_read_lock(), even if the listener is released concurrently.

- smbdirect_listen_connect_request() only sets nsc->accept.listener
  after smbdirect_accept_connect_request() succeeded, so that a
  failure within it can't let nsc orphan itself before we release it.

- smbdirect_accept_negotiate_recv_work() no longer moves a socket to
  the ready list if it already failed or no longer belongs to the
  listener. Every accepting socket has a listener, so if
  sc->accept.listener is already cleared, it no longer sends a
  negotiate response, as the socket is about to be released.

- smbdirect_socket_destroy() of the listener disables
  purge_orphaned_work and also releases the orphaned sockets.

Fixes: dc691b91ad16 ("smb: smbdirect: introduce smbdirect_socket_{listen,accept}()")
Reported-by: 레드팀하고싶어요 <ihopenre@gmail.com>
Closes: https://lore.kernel.org/linux-cifs/CANTrAmxL5sWU8Sn29JAGZvSq5PBB2OA+VKA0MHsZJMesagtfzA@mail.gmail.com/
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1791224972.git.metze%40samba.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/accept.c   |  67 +++++++++++++------
 fs/smb/smbdirect/internal.h |   2 +
 fs/smb/smbdirect/listen.c   | 124 ++++++++++++++++++++++++++++++++++--
 fs/smb/smbdirect/socket.c   |  57 ++++++++++++++++-
 fs/smb/smbdirect/socket.h   |  37 +++++++++++
 5 files changed, 260 insertions(+), 27 deletions(-)

diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index 1b30ca8476c1..1da95cdd1ebd 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -302,6 +302,7 @@ static void smbdirect_accept_negotiate_recv_work(struct work_struct *work)
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, connect.work);
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_socket *lsc;
 	struct smbdirect_recv_io *recv_io;
 	struct smbdirect_negotiate_req *nreq;
 	unsigned long flags;
@@ -464,29 +465,55 @@ static void smbdirect_accept_negotiate_recv_work(struct work_struct *work)
 	 */
 	sp->max_fragmented_send_size = max_fragmented_size;
 
-	if (sc->accept.listener) {
-		struct smbdirect_socket *lsc = sc->accept.listener;
-		unsigned long flags;
+	/*
+	 * Every accepting socket was created by
+	 * smbdirect_listen_connect_request() and has a
+	 * listener. If it's already cleared, the listener
+	 * (or its purge_orphaned_work) is responsible for
+	 * releasing us, so we must not send a negotiate
+	 * response.
+	 *
+	 * The memory of the listener is freed via kfree_rcu(),
+	 * see smbdirect_listen_orphan_socket().
+	 */
+	rcu_read_lock();
+	lsc = READ_ONCE(sc->accept.listener);
+	if (!lsc) {
+		rcu_read_unlock();
+		return;
+	}
 
-		spin_lock_irqsave(&lsc->listen.lock, flags);
-		list_del(&sc->accept.list);
-		list_add_tail(&sc->accept.list, &lsc->listen.ready);
+	spin_lock_irqsave(&lsc->listen.lock, flags);
+	/*
+	 * The listener (or its purge_orphaned_work)
+	 * may have cleared sc->accept.listener in the
+	 * meantime and is responsible for releasing us.
+	 *
+	 * If we already failed, we're either
+	 * already on the orphaned list or
+	 * smbdirect_socket_cleanup_work() will
+	 * move us there.
+	 *
+	 * In both cases we must not move us
+	 * to the ready list.
+	 */
+	if (sc->accept.listener == lsc && !READ_ONCE(sc->first_error)) {
+		list_move_tail(&sc->accept.list, &lsc->listen.ready);
 		wake_up(&lsc->listen.wait_queue);
-		spin_unlock_irqrestore(&lsc->listen.lock, flags);
-
-		/*
-		 * smbdirect_socket_accept() will call
-		 * smbdirect_accept_negotiate_finish(nsc, 0);
-		 *
-		 * So that we don't send the negotiation
-		 * response that grants credits to the peer
-		 * before the socket is accepted by the
-		 * application.
-		 */
-		return;
 	}
+	spin_unlock_irqrestore(&lsc->listen.lock, flags);
+	rcu_read_unlock();
 
-	ntstatus = le32_to_cpu(STATUS_SUCCESS);
+	/*
+	 * smbdirect_socket_accept() will call
+	 * smbdirect_accept_negotiate_finish(nsc, 0);
+	 *
+	 * So that we don't send the negotiation
+	 * response that grants credits to the peer
+	 * before the socket is accepted by the
+	 * application.
+	 */
+	return;
 
 not_supported:
 	smbdirect_accept_negotiate_finish(sc, ntstatus);
@@ -839,7 +866,7 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 				       struct smbdirect_socket,
 				       accept.list);
 	if (nsc) {
-		nsc->accept.listener = NULL;
+		WRITE_ONCE(nsc->accept.listener, NULL);
 		list_del_init_careful(&nsc->accept.list);
 		arg->is_empty = list_empty_careful(&lsc->listen.ready);
 	}
diff --git a/fs/smb/smbdirect/internal.h b/fs/smb/smbdirect/internal.h
index e9959e6dc13a..69d0c9f899de 100644
--- a/fs/smb/smbdirect/internal.h
+++ b/fs/smb/smbdirect/internal.h
@@ -74,6 +74,8 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 
 void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc);
 
+void smbdirect_listen_orphan_socket(struct smbdirect_socket *sc);
+
 int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
 				      enum smbdirect_socket_status expected_status,
 				      int unexpected_errno,
diff --git a/fs/smb/smbdirect/listen.c b/fs/smb/smbdirect/listen.c
index 2f78bcaedbf8..eba8dd45cd6d 100644
--- a/fs/smb/smbdirect/listen.c
+++ b/fs/smb/smbdirect/listen.c
@@ -10,6 +10,78 @@
 static int smbdirect_listen_rdma_event_handler(struct rdma_cm_id *id,
 					       struct rdma_cm_event *event);
 
+/*
+ * This is called by a socket that failed while it
+ * is still on the pending or ready list of its
+ * listener, typically at the end of
+ * smbdirect_socket_cleanup_work(), when the
+ * disconnect was already started.
+ *
+ * It moves itself to the orphaned list and
+ * lets smbdirect_listen_purge_orphaned_work()
+ * release it. Otherwise it would stay on the
+ * pending or ready list until the listener is
+ * destroyed and fill up the backlog, so that
+ * no new connections would be accepted.
+ *
+ * It's fine to call this more than once.
+ */
+void smbdirect_listen_orphan_socket(struct smbdirect_socket *sc)
+{
+	struct smbdirect_socket *lsc;
+	unsigned long flags;
+
+	/*
+	 * The memory of the listener is freed via
+	 * kfree_rcu(), so it's safe to dereference it
+	 * under rcu_read_lock(), even if sc->accept.listener
+	 * is cleared and the listener is released concurrently.
+	 */
+	rcu_read_lock();
+	lsc = READ_ONCE(sc->accept.listener);
+	if (!lsc) {
+		rcu_read_unlock();
+		return;
+	}
+
+	spin_lock_irqsave(&lsc->listen.lock, flags);
+	if (sc->accept.listener == lsc) {
+		list_move_tail(&sc->accept.list, &lsc->listen.orphaned);
+		queue_work(lsc->workqueues.cleanup, &lsc->listen.purge_orphaned_work);
+	}
+	spin_unlock_irqrestore(&lsc->listen.lock, flags);
+	rcu_read_unlock();
+}
+
+static void smbdirect_listen_purge_orphaned_work(struct work_struct *work)
+{
+	struct smbdirect_socket *lsc =
+		container_of(work, struct smbdirect_socket, listen.purge_orphaned_work);
+	struct smbdirect_socket *psc, *tsc;
+	LIST_HEAD(orphaned_list);
+	unsigned long flags;
+
+	/*
+	 * Clearing accept.listener under listen.lock
+	 * makes us responsible for releasing them.
+	 */
+	spin_lock_irqsave(&lsc->listen.lock, flags);
+	list_splice_tail_init(&lsc->listen.orphaned, &orphaned_list);
+	list_for_each_entry(psc, &orphaned_list, accept.list)
+		WRITE_ONCE(psc->accept.listener, NULL);
+	spin_unlock_irqrestore(&lsc->listen.lock, flags);
+
+	/*
+	 * We don't hold the listener's rdma_lock_handler()
+	 * lock here, see smbdirect_socket_destroy()
+	 * for why that's important.
+	 */
+	list_for_each_entry_safe(psc, tsc, &orphaned_list, accept.list) {
+		list_del_init(&psc->accept.list);
+		smbdirect_socket_release(psc);
+	}
+}
+
 int smbdirect_socket_listen(struct smbdirect_socket *sc, int backlog)
 {
 	int ret;
@@ -47,6 +119,9 @@ int smbdirect_socket_listen(struct smbdirect_socket *sc, int backlog)
 	sc->rdma.cm_id->event_handler = smbdirect_listen_rdma_event_handler;
 	rdma_unlock_handler(sc->rdma.cm_id);
 
+	INIT_WORK(&sc->listen.purge_orphaned_work,
+		  smbdirect_listen_purge_orphaned_work);
+
 	ret = rdma_listen(sc->rdma.cm_id, backlog);
 	if (ret) {
 		sc->first_error = ret;
@@ -214,6 +289,7 @@ static int smbdirect_listen_connect_request(struct smbdirect_socket *lsc,
 	size_t backlog = max_t(size_t, 1, lsc->listen.backlog);
 	size_t psockets;
 	size_t rsockets;
+	size_t osockets;
 	int ret;
 
 	if (!smbdirect_frwr_is_supported(&new_id->device->attrs)) {
@@ -254,14 +330,21 @@ static int smbdirect_listen_connect_request(struct smbdirect_socket *lsc,
 	spin_lock_irqsave(&lsc->listen.lock, flags);
 	psockets = list_count_nodes(&lsc->listen.pending);
 	rsockets = list_count_nodes(&lsc->listen.ready);
+	/*
+	 * Orphaned sockets still count against
+	 * the backlog until they are released by
+	 * smbdirect_listen_purge_orphaned_work().
+	 */
+	osockets = list_count_nodes(&lsc->listen.orphaned);
 	spin_unlock_irqrestore(&lsc->listen.lock, flags);
 
 	if (psockets > backlog ||
 	    rsockets > backlog ||
-	    (psockets + rsockets) > backlog) {
+	    osockets > backlog ||
+	    (psockets + rsockets + osockets) > backlog) {
 		smbdirect_log_rdma_event(lsc, SMBDIRECT_LOG_ERR,
-			"Backlog[%d][%zu] full pending[%zu] ready[%zu]\n",
-			lsc->listen.backlog, backlog, psockets, rsockets);
+			"Backlog[%d][%zu] full pending[%zu] ready[%zu] orphaned[%zu]\n",
+			lsc->listen.backlog, backlog, psockets, rsockets, osockets);
 		return -EBUSY;
 	}
 
@@ -279,21 +362,52 @@ static int smbdirect_listen_connect_request(struct smbdirect_socket *lsc,
 	if (ret)
 		goto set_settings_failed;
 
+	/*
+	 * Note that nsc->accept.listener is only set
+	 * after smbdirect_accept_connect_request()
+	 * succeeded, so that a failure within it
+	 * can't let nsc orphan itself via
+	 * smbdirect_listen_orphan_socket(), as we
+	 * release it below in that case.
+	 *
+	 * The listener's handler_mutex is held while
+	 * we're called, so smbdirect_socket_destroy()
+	 * of the listener can't see nsc on the
+	 * pending list before we're done.
+	 */
 	spin_lock_irqsave(&lsc->listen.lock, flags);
 	list_add_tail(&nsc->accept.list, &lsc->listen.pending);
-	nsc->accept.listener = lsc;
 	spin_unlock_irqrestore(&lsc->listen.lock, flags);
 
 	ret = smbdirect_accept_connect_request(nsc, &event->param.conn);
 	if (ret)
 		goto accept_connect_failed;
 
+	spin_lock_irqsave(&lsc->listen.lock, flags);
+	WRITE_ONCE(nsc->accept.listener, lsc);
+	/*
+	 * If nsc already failed before we set accept.listener, its
+	 * smbdirect_socket_cleanup_work() ran smbdirect_listen_orphan_socket()
+	 * with accept.listener still NULL and could not orphan it, so we do
+	 * it here. Doing this under listen.lock, together with setting
+	 * accept.listener, means it can't race with a concurrent
+	 * smbdirect_socket_cleanup_work(): either we observe first_error and
+	 * orphan nsc, or cleanup_work observes accept.listener and orphans it.
+	 * It also keeps nsc alive while we touch it, as
+	 * smbdirect_listen_purge_orphaned_work() needs listen.lock to remove
+	 * and release it.
+	 */
+	if (READ_ONCE(nsc->first_error)) {
+		list_move_tail(&nsc->accept.list, &lsc->listen.orphaned);
+		queue_work(lsc->workqueues.cleanup, &lsc->listen.purge_orphaned_work);
+	}
+	spin_unlock_irqrestore(&lsc->listen.lock, flags);
+
 	return 0;
 
 accept_connect_failed:
 	spin_lock_irqsave(&lsc->listen.lock, flags);
 	list_del_init(&nsc->accept.list);
-	nsc->accept.listener = NULL;
 	spin_unlock_irqrestore(&lsc->listen.lock, flags);
 set_settings_failed:
 set_params_failed:
diff --git a/fs/smb/smbdirect/socket.c b/fs/smb/smbdirect/socket.c
index c36cb7cc0088..e270e36b3145 100644
--- a/fs/smb/smbdirect/socket.c
+++ b/fs/smb/smbdirect/socket.c
@@ -319,6 +319,15 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 	 * (smbdirect_socket_destroy) to reap.
 	 */
 	if (sc->listen.backlog != -1) { /* was a listener */
+		/*
+		 * We don't move them to the orphaned list here,
+		 * each child does that itself at the end of its
+		 * smbdirect_socket_cleanup_work(), see
+		 * smbdirect_listen_orphan_socket(). Only that checks
+		 * accept.listener, which is still NULL for a child
+		 * that smbdirect_listen_connect_request() is still
+		 * setting up and will release itself on failure.
+		 */
 		spin_lock_irqsave(&sc->listen.lock, flags);
 		list_splice_init(&sc->listen.ready, &sc->listen.pending);
 		list_for_each_entry_safe(psc, tsc, &sc->listen.pending, accept.list)
@@ -427,6 +436,15 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	 * instances of one class -- harmless, but lockdep cannot tell).
 	 */
 	if (sc->listen.backlog != -1) { /* was a listener */
+		/*
+		 * We don't move them to the orphaned list here,
+		 * each child does that itself at the end of its
+		 * smbdirect_socket_cleanup_work(), see
+		 * smbdirect_listen_orphan_socket(). Only that checks
+		 * accept.listener, which is still NULL for a child
+		 * that smbdirect_listen_connect_request() is still
+		 * setting up and will release itself on failure.
+		 */
 		spin_lock_irqsave(&sc->listen.lock, flags);
 		list_splice_init(&sc->listen.ready, &sc->listen.pending);
 		list_for_each_entry_safe(psc, tsc, &sc->listen.pending, accept.list)
@@ -486,6 +504,18 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	 * in order to notice the broken connection.
 	 */
 	smbdirect_socket_wake_up_all(sc);
+
+	/*
+	 * If we're still on the pending or ready list
+	 * of a listener, we started the disconnect
+	 * as far as possible above, so we move ourself
+	 * to the orphaned list of the listener,
+	 * which will release us.
+	 *
+	 * This is a no-op internally if
+	 * sc->accept.listener is NULL.
+	 */
+	smbdirect_listen_orphan_socket(sc);
 }
 
 static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
@@ -544,6 +574,7 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 	disable_work_sync(&sc->recv_io.posted.refill_work);
 	disable_work_sync(&sc->idle.immediate_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
+	disable_work_sync(&sc->listen.purge_orphaned_work);
 
 	if (sc->rdma.cm_id)
 		rdma_lock_handler(sc->rdma.cm_id);
@@ -607,6 +638,19 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 	spin_lock_irqsave(&sc->listen.lock, flags);
 	list_splice_tail_init(&sc->listen.ready, &pending_list);
 	list_splice_tail_init(&sc->listen.pending, &pending_list);
+	/*
+	 * purge_orphaned_work is already disabled above,
+	 * so we also need to release the orphaned sockets.
+	 *
+	 * Clearing accept.listener under listen.lock
+	 * makes us responsible for releasing them and
+	 * prevents them from moving themselves to
+	 * the orphaned list via
+	 * smbdirect_listen_orphan_socket().
+	 */
+	list_splice_tail_init(&sc->listen.orphaned, &pending_list);
+	list_for_each_entry(psc, &pending_list, accept.list)
+		WRITE_ONCE(psc->accept.listener, NULL);
 	spin_unlock_irqrestore(&sc->listen.lock, flags);
 
 	/* It's not possible for upper layer to get to reassembly */
@@ -650,7 +694,6 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 			"release %zu pending sockets\n", psockets);
 	list_for_each_entry_safe(psc, tsc, &pending_list, accept.list) {
 		list_del_init(&psc->accept.list);
-		psc->accept.listener = NULL;
 		smbdirect_socket_release(psc);
 	}
 	if (sc->listen.backlog != -1) /* was a listener */
@@ -777,7 +820,17 @@ static void smbdirect_socket_release_destroy(struct kref *kref)
 	 * in DESTROYED state, before we free the memory.
 	 */
 	smbdirect_socket_destroy_sync(sc);
-	kfree(sc);
+
+	/*
+	 * Only a listener (backlog != -1) is ever dereferenced
+	 * via sc->accept.listener under rcu_read_lock(), see
+	 * smbdirect_listen_orphan_socket(). Other sockets can be
+	 * freed immediately.
+	 */
+	if (sc->listen.backlog != -1) /* was a listener */
+		kfree_rcu(sc, refs.rcu);
+	else
+		kfree(sc);
 }
 
 void smbdirect_socket_release(struct smbdirect_socket *sc)
diff --git a/fs/smb/smbdirect/socket.h b/fs/smb/smbdirect/socket.h
index c09eddd8ad16..36623980ec17 100644
--- a/fs/smb/smbdirect/socket.h
+++ b/fs/smb/smbdirect/socket.h
@@ -151,6 +151,12 @@ struct smbdirect_socket {
 		 * the disconnect refcount.
 		 */
 		struct kref destroy;
+
+		/*
+		 * smbdirect_socket_release_destroy() uses
+		 * kfree_rcu(), see accept.listener.
+		 */
+		struct rcu_head rcu;
 	} refs;
 
 	/* RDMA related */
@@ -216,6 +222,16 @@ struct smbdirect_socket {
 		 * only be > 0.
 		 */
 		int backlog;
+		/*
+		 * Sockets on pending or ready that failed
+		 * move themselves to orphaned and queue
+		 * purge_orphaned_work, which releases them.
+		 * So that they are freed while the listener
+		 * is still alive. They still count against
+		 * the backlog until they are released.
+		 */
+		struct list_head orphaned;
+		struct work_struct purge_orphaned_work;
 	} listen;
 
 	/*
@@ -226,7 +242,25 @@ struct smbdirect_socket {
 	 * connection.
 	 */
 	struct {
+		/*
+		 * This is only set, protected by
+		 * listener->listen.lock, while the socket
+		 * is owned by the listener (on its pending,
+		 * ready or orphaned list). The one who clears
+		 * it is responsible for releasing the socket.
+		 *
+		 * The memory of a struct smbdirect_socket is
+		 * freed via kfree_rcu(), so the listener
+		 * can be dereferenced under rcu_read_lock(),
+		 * even if accept.listener is cleared and
+		 * the listener is released concurrently.
+		 */
 		struct smbdirect_socket *listener;
+		/*
+		 * Note even with listener being NULL,
+		 * the socket can be on listeners.listen.pending
+		 * before smbdirect_accept_connect_request() finished.
+		 */
 		struct list_head list;
 	} accept;
 
@@ -588,6 +622,9 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	spin_lock_init(&sc->listen.lock);
 	INIT_LIST_HEAD(&sc->listen.pending);
 	INIT_LIST_HEAD(&sc->listen.ready);
+	INIT_LIST_HEAD(&sc->listen.orphaned);
+	INIT_WORK(&sc->listen.purge_orphaned_work, __smbdirect_socket_disabled_work);
+	disable_work_sync(&sc->listen.purge_orphaned_work);
 	sc->listen.backlog = -1; /* not a listener */
 	init_waitqueue_head(&sc->listen.wait_queue);
 
-- 
2.43.0

