Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782613;
	b=cg9ww/IxtVT+Uq3ix6u3FLnhc2jHqe1H+BdvBvQKb9mZfuxIgaw7tAVAcW8LCY11erai
	 spdgYw7Zx7+1dK8GTJkx7KkXZo6HDANEAwyrSlrTvYtWtktpxdebuycSw4f84ZNi58LKV
	 dEOqFG60BLWhvBROSWCcWI/livJMqBAl0ysSUpsBgKcioT5Zby2hQgfuaDSTBJCprYmBC
	 t9r/zu8vLgid2d8tXUJAAPBQXC8+mbesevOR7sA4g1w5vcdE5MDTNObrdHrEUtS9eDF1j
	 oFZtYLv3filOfqrdtevgfDh22BlerHVqdjItdG4AJcxTeME1SKTKbGND1PkufGgmIfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782613;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tgdLuir78ESrZeiImSthA9000HKtIEmRbDAQl4bsMjg=;
	b=IhUvw53wvdFgBFpe6AlNHggoOIVpfLAEcZczyZM6c2p96jwhTmbHpUhhK6Jz43uRUlKB
	 MUKyNHJv7LGmQ9A6ugUrIdR7YiDX1084iktSl9+5vutjsIRQXiWjMhEoXcFL0kDvU/pQQ
	 Yck9Szi8oVDDKTlV/RSeNo+Q7+1T968KM5a4lkgRtfvpXgTYKYuxr/P9E6jHs0Z63q3dl
	 tOm/qWLcBW983EU0hs6kIzza+M1FM1HmW2xMIQBiaJT37IIJUa9/hO8aaBmZBB6zAnBZR
	 y41zjnW+gvB1qunSzyIzBGdeMKoXtN8GGbEz7T4y7m3QHvwUQras6c9o64biLdE2poA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=YD4qpR0P;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5841606A31E;
	Fri, 27 Nov 2026 12:30:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5841606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=YD4qpR0P
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=tgdLuir78ESrZeiImSthA9000HKtIEmRbDAQl4bsMjg=; b=YD4qpR0PEoyeiSFnGK3YOrWd3B
	pE+gInb8iaC4KmBU67bx7vCHbD1+sveZG3qsTayw8ouB4HMfv5T0iMFsWeraFdzP3QUTDEcYgqzc2
	AXNiU5u8O1A9/lDelTuBsrSdbDA/BJhkdh/8M2yb6KHPec+6b7v5gp3aqij4fCqWHnXkIiJguEGz5
	RYdXyxf+bLd8gNzaSO/Jmcw80nW+ApclIdwEOIttK5bmDbGTIX16dr+Zc4ea0f4HY+67PO5pjz2dI
	zBlzVb14QNpb1yEZUOKRQfpLjQrgj4KOhaWk1ce7UFQrJ46YOYtOJ3/nXv9bGnXXYQ9207QVI7bak
	guqJS7hwIl2+jCSE7ba0Ce1EaVtof8RgFjzDJRD61/rR/kI2TwU0Nljy0RVxRC+0QAOIV7QvUHYDV
	lcrcgNKf2W66kAjwfrGQ7uERE7/Q0ntJGKTV1BADI31FmRToCPy8h9Pp7W0NZYkxiXvmaG/6W1oLr
	ZS1WwnHqpfS4AAZ1z9Fidjp8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv5a-00000001LfO-1mcX;
	Fri, 27 Nov 2026 12:30:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	syzbot+a989758ffc6f93223eb6@syzkaller.appspotmail.com
Subject: [PATCH 08/10] smb: smbdirect: don't let INIT_[DELAYED_]WORK() undo a disable from the teardown
Date: Fri, 27 Nov 2026 13:29:05 +0100
Message-ID: <7bd2aa79baa6ae43cb999d3ce894f6d9c1eb62db.1795781300.git.metze@samba.org>
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

smbdirect_socket_init() initializes all work items as disabled and
the connect and accept code activates them with INIT_WORK() or
INIT_DELAYED_WORK() once they are needed, e.g.
smbdirect_connect_rdma_connect() for the idle timer.

But INIT_[DELAYED_]WORK() also resets the disable count. The teardown
in __smbdirect_socket_schedule_cleanup() and smbdirect_socket_destroy()
disables the work items without holding the locks of the rdma cm event
handler or the recv done handlers, so it can disable a work item
between the status check of a handler and its INIT_[DELAYED_]WORK().
Then the work item is enabled again and queued, e.g. the idle timer by
mod_delayed_work() in smbdirect_connect_rdma_connect(), after
smbdirect_socket_destroy() already disabled it with
disable_delayed_work_sync(), so it can run after the socket is freed.

syzbot found this together with a warning in
smbdirect_connect_rdma_event_handler(), which is fixed in the next
commit.

So set first_error and disable the work items together under the new
sc->cleanup_lock in the teardown and only activate them under the same
lock while first_error is still 0: either the activation happens
before the disable or it sees first_error and leaves the work item
disabled. So the teardown only needs to disable them once, when it
sets first_error. The final disable_[delayed_]work_sync() in
smbdirect_socket_destroy() doesn't need the lock, as first_error is
always set before. The failure of rdma_listen() in
smbdirect_socket_listen() now uses smbdirect_socket_schedule_cleanup()
instead of setting first_error and the status itself, so that
first_error is always only written with cleanup_lock held.

sc->cleanup_lock replaces sc->connect.lock, which was only used for the
activation of sc->connect.work, but the teardown didn't take it.

Fixes: d1f187656797 ("smb: smbdirect: introduce smbdirect_connect[_sync]()")
Fixes: eb3ed1e9048c ("smb: smbdirect: introduce smbdirect_accept_connect_request()")
Fixes: 099db5093e4d ("smb: smbdirect: introduce smbdirect_connection_negotiation_done()")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Reported-by: syzbot+a989758ffc6f93223eb6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a989758ffc6f93223eb6
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/accept.c     | 23 ++++++---
 fs/smb/smbdirect/connect.c    | 19 ++++---
 fs/smb/smbdirect/connection.c | 15 +++++-
 fs/smb/smbdirect/listen.c     | 19 ++++++-
 fs/smb/smbdirect/socket.c     | 93 +++++++++++++++++++++++------------
 fs/smb/smbdirect/socket.h     | 14 +++++-
 6 files changed, 131 insertions(+), 52 deletions(-)

diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index 9fb0676a3035..b360f77b40f6 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -24,6 +24,7 @@ int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
 	u8 peer_responder_resources;
 	struct rdma_conn_param conn_param;
 	__be32 ird_ord_hdr[2];
+	unsigned long flags;
 	int ret;
 
 	/*
@@ -152,11 +153,17 @@ int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
 	/*
 	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
 	 * so that the timer will cause a disconnect.
+	 *
+	 * Only if the teardown didn't start, see cleanup_lock.
 	 */
-	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
-	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
-			 msecs_to_jiffies(sp->negotiate_timeout_msec));
+	spin_lock_irqsave(&sc->cleanup_lock, flags);
+	if (!sc->first_error) {
+		INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
+		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+		mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
+				 msecs_to_jiffies(sp->negotiate_timeout_msec));
+	}
+	spin_unlock_irqrestore(&sc->cleanup_lock, flags);
 
 	return 0;
 
@@ -287,13 +294,13 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
 	 * smbdirect_accept_rdma_event_handler() will do it, when
 	 * RDMA_CM_EVENT_ESTABLISHED arrived.
 	 */
-	spin_lock_irqsave(&sc->connect.lock, flags);
+	spin_lock_irqsave(&sc->cleanup_lock, flags);
 	if (!sc->first_error) {
 		INIT_WORK(&sc->connect.work, smbdirect_accept_negotiate_recv_work);
 		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_NEEDED)
 			queue_work(sc->workqueues.accept, &sc->connect.work);
 	}
-	spin_unlock_irqrestore(&sc->connect.lock, flags);
+	spin_unlock_irqrestore(&sc->cleanup_lock, flags);
 
 	return;
 
@@ -796,10 +803,10 @@ static int smbdirect_accept_rdma_event_handler(struct rdma_cm_id *id,
 		if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING))
 			return 0;
 		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
-		spin_lock_irqsave(&sc->connect.lock, flags);
+		spin_lock_irqsave(&sc->cleanup_lock, flags);
 		if (!sc->first_error)
 			queue_work(sc->workqueues.accept, &sc->connect.work);
-		spin_unlock_irqrestore(&sc->connect.lock, flags);
+		spin_unlock_irqrestore(&sc->cleanup_lock, flags);
 
 		/*
 		 * wait for smbdirect_accept_negotiate_recv_done()
diff --git a/fs/smb/smbdirect/connect.c b/fs/smb/smbdirect/connect.c
index ce00e6466690..c1e236ebbb52 100644
--- a/fs/smb/smbdirect/connect.c
+++ b/fs/smb/smbdirect/connect.c
@@ -130,6 +130,7 @@ static int smbdirect_connect_rdma_connect(struct smbdirect_socket *sc)
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct rdma_conn_param conn_param;
 	__be32 ird_ord_hdr[2];
+	unsigned long flags;
 	int ret;
 
 	sc->ib.dev = sc->rdma.cm_id->device;
@@ -231,11 +232,17 @@ static int smbdirect_connect_rdma_connect(struct smbdirect_socket *sc)
 	/*
 	 * start with the rdma connect timeout and SMBDIRECT_KEEPALIVE_PENDING
 	 * so that the timer will cause a disconnect.
+	 *
+	 * Only if the teardown didn't start, see cleanup_lock.
 	 */
-	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
-	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
-			 msecs_to_jiffies(sp->rdma_connect_timeout_msec));
+	spin_lock_irqsave(&sc->cleanup_lock, flags);
+	if (!sc->first_error) {
+		INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
+		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+		mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
+				 msecs_to_jiffies(sp->rdma_connect_timeout_msec));
+	}
+	spin_unlock_irqrestore(&sc->cleanup_lock, flags);
 
 	return 0;
 }
@@ -629,13 +636,13 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
 	 * So we defer further processing of the negotiation
 	 * to smbdirect_connect_negotiate_recv_work().
 	 */
-	spin_lock_irqsave(&sc->connect.lock, flags);
+	spin_lock_irqsave(&sc->cleanup_lock, flags);
 	if (!sc->first_error) {
 		INIT_WORK(&sc->connect.work, smbdirect_connect_negotiate_recv_work);
 		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_RUNNING)
 			queue_work(sc->workqueues.connect, &sc->connect.work);
 	}
-	spin_unlock_irqrestore(&sc->connect.lock, flags);
+	spin_unlock_irqrestore(&sc->cleanup_lock, flags);
 
 	return;
 
diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index 8a5ab059c005..e6b45e603bfd 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -157,6 +157,8 @@ void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
 
 void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
 {
+	unsigned long flags;
+
 	if (unlikely(sc->first_error))
 		return;
 
@@ -195,8 +197,17 @@ void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
 	 * in order to get a working connection.
 	 */
 done:
-	INIT_WORK(&sc->recv_io.posted.refill_work, smbdirect_connection_recv_io_refill_work);
-	INIT_WORK(&sc->idle.immediate_work, smbdirect_connection_send_immediate_work);
+	/*
+	 * Only if the teardown didn't start, see cleanup_lock.
+	 */
+	spin_lock_irqsave(&sc->cleanup_lock, flags);
+	if (!sc->first_error) {
+		INIT_WORK(&sc->recv_io.posted.refill_work,
+			  smbdirect_connection_recv_io_refill_work);
+		INIT_WORK(&sc->idle.immediate_work,
+			  smbdirect_connection_send_immediate_work);
+	}
+	spin_unlock_irqrestore(&sc->cleanup_lock, flags);
 
 	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 		"negotiated: local: %pISpsfc remote: %pISpsfc\n",
diff --git a/fs/smb/smbdirect/listen.c b/fs/smb/smbdirect/listen.c
index 3c91f00d95ce..2c4a2f249f45 100644
--- a/fs/smb/smbdirect/listen.c
+++ b/fs/smb/smbdirect/listen.c
@@ -124,8 +124,23 @@ int smbdirect_socket_listen(struct smbdirect_socket *sc, int backlog)
 
 	ret = rdma_listen(sc->rdma.cm_id, backlog);
 	if (ret) {
-		sc->first_error = ret;
-		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		/*
+		 * This sets first_error under cleanup_lock,
+		 * changes the status to SMBDIRECT_SOCKET_DISCONNECTED
+		 * and queues disconnect_work.
+		 *
+		 * It's safe to use sc->rdma.cm_id and
+		 * sc->rdma.cm_id->device afterwards: neither this
+		 * nor smbdirect_socket_cleanup_work() touch the cm_id
+		 * of a socket that never reached
+		 * RDMA_CM_EVENT_ESTABLISHED. Only
+		 * smbdirect_socket_destroy() calls rdma_destroy_id(),
+		 * via smbdirect_socket_release() of our caller,
+		 * which can't run while we are still here.
+		 * listen.backlog is still -1, so there are no
+		 * pending or ready child sockets to clean up either.
+		 */
+		smbdirect_socket_schedule_cleanup_lvl(sc, SMBDIRECT_LOG_INFO, ret);
 		if (sc->rdma.cm_id->device)
 			smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 				"listening failed %1pe on addr: %pISpsfc dev: %.*s\n",
diff --git a/fs/smb/smbdirect/socket.c b/fs/smb/smbdirect/socket.c
index 749a85274f97..cb090c558321 100644
--- a/fs/smb/smbdirect/socket.c
+++ b/fs/smb/smbdirect/socket.c
@@ -271,7 +271,34 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 	unsigned long flags;
 	bool was_first = false;
 
+	/*
+	 * first_error is set under cleanup_lock, together with
+	 * disabling the work items, see cleanup_lock: an activation
+	 * either happened before or sees first_error, so the
+	 * work items only need to be disabled once.
+	 */
+	spin_lock_irqsave(&sc->cleanup_lock, flags);
 	if (!sc->first_error) {
+		if (error)
+			sc->first_error = error;
+		else
+			sc->first_error = -ECONNABORTED;
+		was_first = true;
+
+		/*
+		 * make sure other work (than disconnect_work)
+		 * is not queued again but here we don't block and avoid
+		 * disable[_delayed]_work_sync()
+		 */
+		disable_work(&sc->connect.work);
+		disable_work(&sc->recv_io.posted.refill_work);
+		disable_work(&sc->idle.immediate_work);
+		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
+		disable_delayed_work(&sc->idle.timer_work);
+	}
+	spin_unlock_irqrestore(&sc->cleanup_lock, flags);
+
+	if (was_first)
 		___smbdirect_log_generic(sc, func, line,
 			lvl,
 			SMBDIRECT_LOG_RDMA_EVENT,
@@ -282,23 +309,6 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 			force_status ? smbdirect_socket_status_string(*force_status) : "",
 			func, line,
 			smbdirect_socket_status_string(sc->status));
-		if (error)
-			sc->first_error = error;
-		else
-			sc->first_error = -ECONNABORTED;
-		was_first = true;
-	}
-
-	/*
-	 * make sure other work (than disconnect_work)
-	 * is not queued again but here we don't block and avoid
-	 * disable[_delayed]_work_sync()
-	 */
-	disable_work(&sc->connect.work);
-	disable_work(&sc->recv_io.posted.refill_work);
-	disable_work(&sc->idle.immediate_work);
-	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
-	disable_delayed_work(&sc->idle.timer_work);
 
 	/*
 	 * In case we were a listener we need to
@@ -396,6 +406,7 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, disconnect_work);
 	struct smbdirect_socket *psc, *tsc;
+	bool was_first = false;
 	unsigned long flags;
 
 	/*
@@ -403,25 +414,35 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	 */
 	WARN_ON_ONCE(in_interrupt());
 
-	if (!sc->first_error) {
-		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
-			"%s called with first_error==0\n",
-			smbdirect_socket_status_string(sc->status));
-
-		sc->first_error = -ECONNABORTED;
-	}
-
 	/*
-	 * make sure this and other work is not queued again
+	 * make sure this work is not queued again
 	 * but here we don't block and avoid
-	 * disable[_delayed]_work_sync()
+	 * disable_work_sync()
 	 */
 	disable_work(&sc->disconnect_work);
-	disable_work(&sc->connect.work);
-	disable_work(&sc->recv_io.posted.refill_work);
-	disable_work(&sc->idle.immediate_work);
-	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
-	disable_delayed_work(&sc->idle.timer_work);
+
+	/*
+	 * Normally __smbdirect_socket_schedule_cleanup() already
+	 * set first_error and disabled the other work items,
+	 * otherwise do it here, see cleanup_lock.
+	 */
+	spin_lock_irqsave(&sc->cleanup_lock, flags);
+	if (!sc->first_error) {
+		sc->first_error = -ECONNABORTED;
+		was_first = true;
+
+		disable_work(&sc->connect.work);
+		disable_work(&sc->recv_io.posted.refill_work);
+		disable_work(&sc->idle.immediate_work);
+		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
+		disable_delayed_work(&sc->idle.timer_work);
+	}
+	spin_unlock_irqrestore(&sc->cleanup_lock, flags);
+
+	if (was_first)
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"%s called with first_error==0\n",
+			smbdirect_socket_status_string(sc->status));
 
 	/*
 	 * In case we were a listener we need to
@@ -569,6 +590,14 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 	 */
 	smbdirect_socket_wake_up_all(sc);
 
+	/*
+	 * These don't need cleanup_lock: smbdirect_socket_destroy_sync()
+	 * makes sure first_error is set before we get here, so no work
+	 * item can be activated anymore, see cleanup_lock. The work items
+	 * are already disabled, either by the cleanup that set first_error
+	 * or because they were never activated, here we only wait for an
+	 * instance that is still running.
+	 */
 	disable_work_sync(&sc->disconnect_work);
 	disable_work_sync(&sc->connect.work);
 	disable_work_sync(&sc->recv_io.posted.refill_work);
diff --git a/fs/smb/smbdirect/socket.h b/fs/smb/smbdirect/socket.h
index 1fc4aebcdda5..1520b6e48e7d 100644
--- a/fs/smb/smbdirect/socket.h
+++ b/fs/smb/smbdirect/socket.h
@@ -108,6 +108,17 @@ struct smbdirect_socket {
 	wait_queue_head_t status_wait;
 	int first_error;
 
+	/*
+	 * The cleanup sets first_error and disables the work items
+	 * under cleanup_lock and the work items are only activated with
+	 * INIT_[DELAYED_]WORK() under cleanup_lock while first_error is
+	 * still 0. INIT_[DELAYED_]WORK() resets the disable count,
+	 * so without the lock an activation could undo a disable of
+	 * a concurrent teardown. All other writers of first_error
+	 * also hold cleanup_lock.
+	 */
+	spinlock_t cleanup_lock;
+
 	/*
 	 * This points to the workqueues to
 	 * be used for this socket.
@@ -194,7 +205,6 @@ struct smbdirect_socket {
 	 * The state for connect/negotiation
 	 */
 	struct {
-		spinlock_t lock;
 		struct work_struct work;
 	} connect;
 
@@ -598,6 +608,7 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	memset(sc, 0, sizeof(*sc));
 
 	init_waitqueue_head(&sc->status_wait);
+	spin_lock_init(&sc->cleanup_lock);
 
 	sc->workqueues.accept = smbdirect_globals.workqueues.accept;
 	sc->workqueues.connect = smbdirect_globals.workqueues.connect;
@@ -616,7 +627,6 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 
 	sc->ib.poll_ctx = IB_POLL_UNBOUND_WORKQUEUE;
 
-	spin_lock_init(&sc->connect.lock);
 	INIT_WORK(&sc->connect.work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->connect.work);
 
-- 
2.43.0

