Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04298331223
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095578; cv=none; b=N66llY6tiRNWUyXIO+2pVJe8XSXyD2Yy+y2SGmqTHrTF/gIoyl08+oOfZPcZuhhtM9asGmopvCPQNj7f+FWID68hO+6ZNAmb15vgcQaehmPBzmOGGq/gdjnv8u2QVhvvgLMrTiuBpxlFKTAH0yuIaMiePZz3q30CK2jDsRTKm2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095578; c=relaxed/simple;
	bh=QCJIvO9WrFqvGeiMVE4cr1lN6TtDMm4UIVUzQiQXnz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHxjqMsXEKvFE7d95+NJIT6qZiUbRYIHIZNrht1neAe/tSDL1ljrsNq2CeRDWUuZAe2KqQF8M7n16S7tRpLSl/buKN9czscwLxPr+TANzW9Mi6C930SYa4RY5RthTeFsplX3kma6N+EFJJPvZuLU2cFHeF2KzW/nRGtTIlzsHu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bVTmKkrV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bVTmKkrV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Igd70e3OUh2iiN3nmELUpUcfguWULXwnNoyrDA4MoFY=; b=bVTmKkrVQVaOUFM39geCpLDXXx
	h4QExjHbAvj5qUV3/cA4uz4zBadOwOYwIiefOaB/sJCprox07FWiovI+qpD7RWgkpAzL/5EiWv6Xq
	+M0UOwMNbyoguqq61CpsEk6Smik5IJM4Nq7dZPQuVnij2IURF3PPclrITpGVs+7R82PP11cZmqBOe
	VQYiDu8dsy4OHPZu9NLydmWrWULHoFtPqVtCq4i8ooEQeZUS3Ju55iuEzJvk0XnKmGf0Nzp0gSRO1
	bh7FzqACd2G3Skl1sfScOAXdxYGZx70Yl5rvqECNqlAoHvPiLFMnmsUR+lsG7/4F/WzQ/+FDzjeRT
	jcGdIbtkVy5+sKjxd+RuyVC0gMNoJNmJMQey4NSEU/P53YGO1j5sjymYRBudCkHzlc9YyccwGxANq
	ZE1/1wcFm9wQWpBJZHGSkD85UD5N7ZYDNwi6YskWurjWtvVEvnaJKqmRY9tcwODEzEd3zLHRC4lqh
	6QUImVVZsduRRHVejFranKU8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxmW-00Ffrz-2L;
	Tue, 25 Nov 2025 18:28:56 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 136/145] smb: smbdirect: prepare use of dedicated workqueues for different steps
Date: Tue, 25 Nov 2025 18:56:22 +0100
Message-ID: <5ea40dc604b654c91bbb6031b536d3da2046b685.1764091285.git.metze@samba.org>
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

This is a preparation in order to have global workqueues in
the smbdirect module instead of having the caller to
provide one.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_accept.c     |  6 +++---
 fs/smb/common/smbdirect/smbdirect_connect.c    |  8 ++++----
 fs/smb/common/smbdirect/smbdirect_connection.c | 16 ++++++++--------
 fs/smb/common/smbdirect/smbdirect_socket.c     |  9 +++++++--
 fs/smb/common/smbdirect/smbdirect_socket.h     | 11 +++++++++--
 5 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_accept.c b/fs/smb/common/smbdirect/smbdirect_accept.c
index f27992cf393b..2ff61a4617be 100644
--- a/fs/smb/common/smbdirect/smbdirect_accept.c
+++ b/fs/smb/common/smbdirect/smbdirect_accept.c
@@ -137,7 +137,7 @@ int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
 	 */
 	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->negotiate_timeout_msec));
 
 	return 0;
@@ -234,7 +234,7 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
 	 * order to trigger our next keepalive message.
 	 */
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->keepalive_interval_msec));
 
 	ib_dma_sync_single_for_cpu(sc->ib.dev,
@@ -266,7 +266,7 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
 	 */
 	smbdirect_connection_put_recv_io(recv_io);
 	INIT_WORK(&recv_io->complex_work, smbdirect_accept_negotiate_recv_work);
-	queue_work(sc->workqueue, &recv_io->complex_work);
+	queue_work(sc->workqueues.accept, &recv_io->complex_work);
 	return;
 
 error:
diff --git a/fs/smb/common/smbdirect/smbdirect_connect.c b/fs/smb/common/smbdirect/smbdirect_connect.c
index 797916dc8481..79ea2fd0bc36 100644
--- a/fs/smb/common/smbdirect/smbdirect_connect.c
+++ b/fs/smb/common/smbdirect/smbdirect_connect.c
@@ -210,7 +210,7 @@ static int smbdirect_connect_rdma_connect(struct smbdirect_socket *sc)
 	 */
 	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->rdma_connect_timeout_msec));
 
 	return 0;
@@ -475,7 +475,7 @@ static int smbdirect_connect_negotiate_start(struct smbdirect_socket *sc)
 	 * so that the timer will cause a disconnect.
 	 */
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->negotiate_timeout_msec));
 
 	return 0;
@@ -562,7 +562,7 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
 	 * order to trigger our next keepalive message.
 	 */
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->keepalive_interval_msec));
 
 	ib_dma_sync_single_for_cpu(sc->ib.dev,
@@ -594,7 +594,7 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
 	 */
 	smbdirect_connection_put_recv_io(recv_io);
 	INIT_WORK(&recv_io->complex_work, smbdirect_connect_negotiate_recv_work);
-	queue_work(sc->workqueue, &recv_io->complex_work);
+	queue_work(sc->workqueues.connect, &recv_io->complex_work);
 	return;
 
 error:
diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index c9208bdfded5..31db64550424 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -616,7 +616,7 @@ void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
 	sc->statistics.put_receive_buffer++;
 	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
 
-	queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
+	queue_work(sc->workqueues.refill, &sc->recv_io.posted.refill_work);
 }
 
 __maybe_unused /* this is temporary while this file is included in others */
@@ -824,11 +824,11 @@ void smbdirect_connection_idle_timer_work(struct work_struct *work)
 	 * in order to wait for a response
 	 */
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->keepalive_timeout_msec));
 	smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
 		"schedule send of empty idle message\n");
-	queue_work(sc->workqueue, &sc->idle.immediate_work);
+	queue_work(sc->workqueues.immediate, &sc->idle.immediate_work);
 }
 
 __maybe_unused /* this is temporary while this file is included in others */
@@ -862,7 +862,7 @@ static bool smbdirect_connection_request_keep_alive(struct smbdirect_socket *sc)
 		 * Now use the keepalive timeout (instead of keepalive interval)
 		 * in order to wait for a response
 		 */
-		mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+		mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
 				 msecs_to_jiffies(sp->keepalive_timeout_msec));
 		return true;
 	}
@@ -1423,7 +1423,7 @@ void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
 	 * order to trigger our next keepalive message.
 	 */
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueues.idle, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->keepalive_interval_msec));
 
 	ib_dma_sync_single_for_cpu(sc->ib.dev,
@@ -1527,7 +1527,7 @@ void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (flags & SMBDIRECT_FLAG_RESPONSE_REQUESTED) {
 		smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
 			"schedule send of immediate response\n");
-		queue_work(sc->workqueue, &sc->idle.immediate_work);
+		queue_work(sc->workqueues.immediate, &sc->idle.immediate_work);
 	}
 
 	/*
@@ -1536,7 +1536,7 @@ void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
 	 */
 	if (data_length) {
 		if (sc->recv_io.credits.target > old_recv_credit_target)
-			queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
+			queue_work(sc->workqueues.refill, &sc->recv_io.posted.refill_work);
 
 		smbdirect_connection_reassembly_append_recv_io(sc, recv_io, data_length);
 		wake_up(&sc->recv_io.reassembly.wait_queue);
@@ -1657,7 +1657,7 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 	if (posted > 0) {
 		smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
 			"schedule send of an empty message\n");
-		queue_work(sc->workqueue, &sc->idle.immediate_work);
+		queue_work(sc->workqueues.immediate, &sc->idle.immediate_work);
 	}
 }
 
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 41f69b6f8494..cb57ed994c6c 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -230,7 +230,12 @@ int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
 	/*
 	 * Remember the callers workqueue
 	 */
-	sc->workqueue = workqueue;
+	sc->workqueues.accept = workqueue;
+	sc->workqueues.connect = workqueue;
+	sc->workqueues.idle = workqueue;
+	sc->workqueues.refill = workqueue;
+	sc->workqueues.immediate = workqueue;
+	sc->workqueues.cleanup = workqueue;
 
 	return 0;
 }
@@ -405,7 +410,7 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 	 */
 	smbdirect_socket_wake_up_all(sc);
 
-	queue_work(sc->workqueue, &sc->disconnect_work);
+	queue_work(sc->workqueues.cleanup, &sc->disconnect_work);
 }
 
 static void smbdirect_socket_cleanup_work(struct work_struct *work)
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 95c20b8d7ec3..b3769be07df0 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -106,12 +106,19 @@ struct smbdirect_socket {
 	int first_error;
 
 	/*
-	 * This points to the workqueue to
+	 * This points to the workqueues to
 	 * be used for this socket.
 	 * It can be per socket (on the client)
 	 * or point to a global workqueue (on the server)
 	 */
-	struct workqueue_struct *workqueue;
+	struct {
+		struct workqueue_struct *accept;
+		struct workqueue_struct *connect;
+		struct workqueue_struct *idle;
+		struct workqueue_struct *refill;
+		struct workqueue_struct *immediate;
+		struct workqueue_struct *cleanup;
+	} workqueues;
 
 	struct work_struct disconnect_work;
 
-- 
2.43.0

