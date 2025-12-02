Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93572F60A7
	for <linux-cifs@vger.kernel.org>; Tue,  2 Dec 2025 21:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764710169; cv=none; b=lKzCxmVkWbxLDnlv5ulM9RacLhaIjKF+pLBh1PeVmjYNglSm9vnlnwxWZbt0iB2vNM/rzECWm3fvzsWWEV86yhuisSf0NZIpdUrPChdvRhkXdTg4fiZX4A3dSZX6bpBVLBC7TYGswH9diTo+ybnt6COrxa9Z+Qsel4d1HypBFCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764710169; c=relaxed/simple;
	bh=aw2FPbOktGYQy2yj9lm52JLGCRm+YFljc2NGfUDi8Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuONnErt7+xNzbVDpAXHV+Z+vg4Xqu9z/RlFvIINJBN+ReIM9yGOSRjLCZIjQmkzXw4v9Ycn8CAXE8318xV5+HhQAHgbi/LRIr2hb/fSwSGr+WS4dN7YVOQbTQSiNl391QYed6PIRGpAxSk8JFM1wkVXGTcguzv70CPb2W0cHg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bnZXvv1I; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bnZXvv1I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=cwRzIba9qx4vhBw9/XtVBGMr3tS8oRMXfUh4vP3ggbg=; b=bnZXvv1I9bs8VwIWkEujttC5sI
	hwRn5GoTXLDEx0GdbGqLUxs/7FiGMRRxGX5cPLkgVlVSaJCKvW2L70QCbBApLGMXLN6blzzyfrKoO
	n1DerVD08zup0X7Wp25u/oh85dpdjrgTgubw+7jCRbIxgfOWjLD8SVoNSfzDd/c0Rmqt9Y3VLBtOB
	ItRAzHZvnIwKai1nhW3VJfX36j+Q/OQXLct1EYAlqiZOqhh9J14PBYjJwMaouJo2NqOt+1kWt5YVz
	pal0OX5sPXzOwDcfZNsuITGvUudXv9TfuvGGw5KIDj7ERHaIGA9qvzRMgrvufJM7OmzmfOjVVE4iA
	wbnACzIoERBQwnIsxve8nZjoXhCQYp9+XTh2DkW9iMMHRPXIBg9Y0fSNG4nNLdcjger2mA2JFwwAw
	I03lYU80DdABm31HQ706s64O4zZltzC1hPHPGX8oPJWM8SkYABtp0hx4ONrCkz+4s5z8WDtgP7K3q
	j6Sm1197IiwV+oCmtp7zG4jK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vQXj8-00GhtA-2R;
	Tue, 02 Dec 2025 21:16:02 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [RFC PATCH 3/4] smb: server: defer the initial recv completion logic to smb_direct_negotiate_recv_work()
Date: Tue,  2 Dec 2025 22:15:26 +0100
Message-ID: <1648ba477d8a42c0e8e43970ae1e87e4f7cd788d.1764709225.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764709225.git.metze@samba.org>
References: <cover.1764709225.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous change to relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
recv_done() and smb_direct_cm_handler() seems to work around the
problem that the order of initial recv completion and
RDMA_CM_EVENT_ESTABLISHED is random, but it's still
a bit ugly.

This implements a better solution deferring the recv completion
processing to smb_direct_negotiate_recv_work(), which is queued
only if both events arrived.

In order to avoid more basic changes to the main recv_done
callback, I introduced a smb_direct_negotiate_recv_done,
which is only used for the first pdu, this will allow
further cleanup and simplifications in recv_done
as a future patch.

smb_direct_negotiate_recv_work() is also very basic
with only basic error checking and the transition
from SMBDIRECT_SOCKET_NEGOTIATE_NEEDED to
SMBDIRECT_SOCKET_NEGOTIATE_RUNNING, which allows
smb_direct_prepare() to continue as before.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 170 +++++++++++++++++++++++++++------
 1 file changed, 142 insertions(+), 28 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 222d1b5365e8..f585359684d4 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -242,6 +242,7 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 	 * disable[_delayed]_work_sync()
 	 */
 	disable_work(&sc->disconnect_work);
+	disable_work(&sc->connect.work);
 	disable_work(&sc->recv_io.posted.refill_work);
 	disable_delayed_work(&sc->idle.timer_work);
 	disable_work(&sc->idle.immediate_work);
@@ -297,6 +298,7 @@ smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 	 * not queued again but here we don't block and avoid
 	 * disable[_delayed]_work_sync()
 	 */
+	disable_work(&sc->connect.work);
 	disable_work(&sc->recv_io.posted.refill_work);
 	disable_work(&sc->idle.immediate_work);
 	disable_delayed_work(&sc->idle.timer_work);
@@ -467,6 +469,7 @@ static void free_transport(struct smb_direct_transport *t)
 	 */
 	smb_direct_disconnect_wake_up_all(sc);
 
+	disable_work_sync(&sc->connect.work);
 	disable_work_sync(&sc->recv_io.posted.refill_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
 	disable_work_sync(&sc->idle.immediate_work);
@@ -635,28 +638,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	switch (sc->recv_io.expected) {
 	case SMBDIRECT_EXPECT_NEGOTIATE_REQ:
-		if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
-			put_recvmsg(sc, recvmsg);
-			smb_direct_disconnect_rdma_connection(sc);
-			return;
-		}
-		sc->recv_io.reassembly.full_packet_received = true;
-		/*
-		 * Some drivers (at least mlx5_ib) might post a
-		 * recv completion before RDMA_CM_EVENT_ESTABLISHED,
-		 * we need to adjust our expectation in that case.
-		 */
-		if (!sc->first_error && sc->status == SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING)
-			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
-		if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_NEGOTIATE_NEEDED)) {
-			put_recvmsg(sc, recvmsg);
-			smb_direct_disconnect_rdma_connection(sc);
-			return;
-		}
-		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
-		enqueue_reassembly(sc, recvmsg, 0);
-		wake_up(&sc->status_wait);
-		return;
+		/* see smb_direct_negotiate_recv_done */
+		break;
 	case SMBDIRECT_EXPECT_DATA_TRANSFER: {
 		struct smbdirect_data_transfer *data_transfer =
 			(struct smbdirect_data_transfer *)recvmsg->packet;
@@ -742,6 +725,126 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	smb_direct_disconnect_rdma_connection(sc);
 }
 
+static void smb_direct_negotiate_recv_work(struct work_struct *work);
+
+static void smb_direct_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct smbdirect_recv_io *recv_io =
+		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
+	struct smbdirect_socket *sc = recv_io->socket;
+	unsigned long flags;
+
+	/*
+	 * reset the common recv_done for later reuse.
+	 */
+	recv_io->cqe.done = recv_done;
+
+	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
+		put_recvmsg(sc, recv_io);
+		if (wc->status != IB_WC_WR_FLUSH_ERR) {
+			pr_err("Negotiate Recv error. status='%s (%d)' opcode=%d\n",
+			       ib_wc_status_msg(wc->status), wc->status,
+			       wc->opcode);
+			smb_direct_disconnect_rdma_connection(sc);
+		}
+		return;
+	}
+
+	ksmbd_debug(RDMA, "Negotiate Recv completed. status='%s (%d)', opcode=%d\n",
+		    ib_wc_status_msg(wc->status), wc->status,
+		    wc->opcode);
+
+	ib_dma_sync_single_for_cpu(sc->ib.dev,
+				   recv_io->sge.addr,
+				   recv_io->sge.length,
+				   DMA_FROM_DEVICE);
+
+	/*
+	 * This is an internal error!
+	 */
+	if (WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_NEGOTIATE_REQ)) {
+		put_recvmsg(sc, recv_io);
+		smb_direct_disconnect_rdma_connection(sc);
+		return;
+	}
+
+	/*
+	 * Don't reset timer to the keepalive interval in
+	 * this will be done in smb_direct_negotiate_recv_work.
+	 */
+
+	/*
+	 * Only remember the recv_io if it has enough bytes,
+	 * this gives smb_direct_negotiate_recv_work enough
+	 * information in order to disconnect if it was not
+	 * valid.
+	 */
+	sc->recv_io.reassembly.full_packet_received = true;
+	if (wc->byte_len >= sizeof(struct smbdirect_negotiate_req))
+		enqueue_reassembly(sc, recv_io, 0);
+	else
+		put_recvmsg(sc, recv_io);
+
+	/*
+	 * Some drivers (at least mlx5_ib and irdma in roce mode)
+	 * might post a recv completion before RDMA_CM_EVENT_ESTABLISHED,
+	 * we need to adjust our expectation in that case.
+	 *
+	 * So we defer further processing of the negotiation
+	 * to smb_direct_negotiate_recv_work().
+	 *
+	 * If we are already in SMBDIRECT_SOCKET_NEGOTIATE_NEEDED
+	 * we queue the work directly otherwise
+	 * smb_direct_cm_handler() will do it, when
+	 * RDMA_CM_EVENT_ESTABLISHED arrived.
+	 */
+	spin_lock_irqsave(&sc->connect.lock, flags);
+	if (!sc->first_error) {
+		INIT_WORK(&sc->connect.work, smb_direct_negotiate_recv_work);
+		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_NEEDED)
+			queue_work(sc->workqueue, &sc->connect.work);
+	}
+	spin_unlock_irqrestore(&sc->connect.lock, flags);
+}
+
+static void smb_direct_negotiate_recv_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, connect.work);
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_recv_io *recv_io;
+
+	if (sc->first_error)
+		return;
+
+	ksmbd_debug(RDMA, "Negotiate Recv Work running\n");
+
+	/*
+	 * Reset timer to the keepalive interval in
+	 * order to trigger our next keepalive message.
+	 */
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->keepalive_interval_msec));
+
+	/*
+	 * If smb_direct_negotiate_recv_done() detected an
+	 * invalid request we want to disconnect.
+	 */
+	recv_io = get_first_reassembly(sc);
+	if (!recv_io) {
+		smb_direct_disconnect_rdma_connection(sc);
+		return;
+	}
+
+	if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_NEGOTIATE_NEEDED)) {
+		smb_direct_disconnect_rdma_connection(sc);
+		return;
+	}
+	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
+	wake_up(&sc->status_wait);
+}
+
 static int smb_direct_post_recv(struct smbdirect_socket *sc,
 				struct smbdirect_recv_io *recvmsg)
 {
@@ -1731,6 +1834,7 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 				 struct rdma_cm_event *event)
 {
 	struct smbdirect_socket *sc = cm_id->context;
+	unsigned long flags;
 
 	ksmbd_debug(RDMA, "RDMA CM event. cm_id=%p event=%s (%d)\n",
 		    cm_id, rdma_event_msg(event->event), event->event);
@@ -1738,18 +1842,27 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 	switch (event->event) {
 	case RDMA_CM_EVENT_ESTABLISHED: {
 		/*
-		 * Some drivers (at least mlx5_ib) might post a
-		 * recv completion before RDMA_CM_EVENT_ESTABLISHED,
+		 * Some drivers (at least mlx5_ib and irdma in roce mode)
+		 * might post a recv completion before RDMA_CM_EVENT_ESTABLISHED,
 		 * we need to adjust our expectation in that case.
 		 *
-		 * As we already started the negotiation, we just
-		 * ignore RDMA_CM_EVENT_ESTABLISHED here.
+		 * If smb_direct_negotiate_recv_done was called first
+		 * it initialized sc->connect.work only for us to
+		 * start, so that we turned into
+		 * SMBDIRECT_SOCKET_NEGOTIATE_NEEDED, before
+		 * smb_direct_negotiate_recv_work() runs.
+		 *
+		 * If smb_direct_negotiate_recv_done didn't happen
+		 * yet. sc->connect.work is still be disabled and
+		 * queue_work() is a no-op.
 		 */
-		if (!sc->first_error && sc->status > SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING)
-			break;
 		if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING))
 			break;
 		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
+		spin_lock_irqsave(&sc->connect.lock, flags);
+		if (!sc->first_error)
+			queue_work(sc->workqueue, &sc->connect.work);
+		spin_unlock_irqrestore(&sc->connect.lock, flags);
 		wake_up(&sc->status_wait);
 		break;
 	}
@@ -1920,6 +2033,7 @@ static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
 	recvmsg = get_free_recvmsg(sc);
 	if (!recvmsg)
 		return -ENOMEM;
+	recvmsg->cqe.done = smb_direct_negotiate_recv_done;
 
 	ret = smb_direct_post_recv(sc, recvmsg);
 	if (ret) {
-- 
2.43.0

