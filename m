Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744A34D0A1F;
	Mon,  5 Oct 2026 18:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791225426; cv=none; b=UMjHYtv89oe70mE2GiBgXpf/sjDhWr3o35bPjbQmsjigaAxxLbhd5m22G1Ifc0t38D9WOHN2JogZsDmFdCk4g9pvVPrHeGEkIq0Q/75U6M42s6Yfm6VS1rKFY11HRkf2+fpnNPJRITMZwFSagXyVluq2HF3qBYHLsdA6haJc4yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791225426; c=relaxed/simple;
	bh=nlxNKLTxtCGCJhUjYU9tc9I7ItX6gDxW/6VNH0ckWXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdHpt3FVzoJr6xU8RpyvwkQlvd4s/nuSLy5nMKitVZpwZCSZUoUtAncRkQdGZ4Q3FZYHLLRg+8E1lXPU/VyAX9JJBPtAiwTtIFh1fcbYQOpzk2Fg9F3WPbMLeOot1s0PGL8RwO5ZHruHDTQo0Pvo3dlEIAIsO7ke4nRyqGjSshw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZPlDifuV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZPlDifuV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=zTfblxxnInZhWQsr0kcjdO8r7ihPT85D9PkwUZk7olY=; b=ZPlDifuVH7jMdIt8nl+E2Hjq/u
	FgLf8DPEmjxc03VKBgtdz+ecyZnUzf2oZn2ZzRZrcFAfMiC0QpdvJoUv9mstPhUxrfWFB/CUa1hr3
	O5Hr8K5aekL0W3V/M9ipZWXpXCRPpuWfTIl79AW7+6d03VF6mWUjCR/Z2FNrts9fBq5kAfIetJH2G
	V5Sj4iHSxDBUm2WY46iql37fi5+BOylZhw9OHtani6tTb22APAmnkCG8WyXlS3aUio5QzFnm0NzrS
	HjD7PfTI8Ftw8QvOPWT52edzpnAHxTvPCSqCcLVbSqMi7VpbRMUhQ0WsFvTO/Wmr+wjZRggI9fOnr
	J8w+p60zlt9115gndXfvRT26PI77K9ZENbljQzn0hOO1SDzSx/80UNuMHEmmTBj3iovuI3jwpWfDK
	pq7Ga8nGkqBYUKUeueG5Xu6hTjBM9C2K/M3iDF9/LfGH98l5CH6Xnxvhmk6PRmDI2bxLqAbLsjWF2
	BQHuIdQ1ZhJ/sq+YgSAoqXBB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDnXi-00000005erX-30VT;
	Mon, 05 Oct 2026 18:36:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	linux-rdma@vger.kernel.org
Subject: [PATCH 1/3] smb: smbdirect: don't wait for RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()
Date: Mon,  5 Oct 2026 20:35:50 +0200
Message-ID: <22ab29ca3288e96cf92d4991c32b8975297d9a28.1791224972.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791224972.git.metze@samba.org>
References: <cover.1791224972.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smbdirect_socket_destroy_sync() waited for RDMA_CM_EVENT_DISCONNECTED
after smbdirect_socket_cleanup_work() called rdma_disconnect(). That
can take very long, e.g. if the peer just disappeared, until the
rdma cm gives up, or forever if the event already happened, but the
status was overwritten afterwards.

This is not needed: smbdirect_socket_destroy() drains the qp under
rdma_lock_handler(), destroys it and calls rdma_destroy_id(), which
only waits for a currently running event handler and makes sure no
further events are delivered. The rest of the disconnect protocol
(DREQ/DREP and timewait for IB, abrupt close for iWarp) is handled
by the rdma core asynchronously. drivers/nvme/host/rdma.c also just
calls rdma_disconnect() and ib_drain_qp() before rdma_destroy_id().

So smbdirect_socket_destroy() now also accepts
SMBDIRECT_SOCKET_DISCONNECTING and changes the status to
SMBDIRECT_SOCKET_DISCONNECTED itself under rdma_lock_handler().

We could still get RDMA_CM_EVENT_DISCONNECTED in the small
windows between rdma_unlock_handler() and rdma_destroy_id(),
but in that case smbdirect_connection_rdma_event_handler()
is basically a no-op.

Fixes: 422a2436697d ("smb: smbdirect: introduce smbdirect_socket_destroy[_sync]()")
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-rdma@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/connection.c | 12 ++++----
 fs/smb/smbdirect/socket.c     | 56 ++++++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index afd31fa12a36..f48c857bda5a 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -83,9 +83,9 @@ static int smbdirect_connection_rdma_event_handler(struct rdma_cm_id *id,
 		 * smbdirect_socket_schedule_cleanup[_status]() =>
 		 * smbdirect_socket_cleanup_work().
 		 *
-		 * As otherwise we'd set SMBDIRECT_SOCKET_DISCONNECTING,
-		 * but never ever get RDMA_CM_EVENT_DISCONNECTED and
-		 * never reach SMBDIRECT_SOCKET_DISCONNECTED.
+		 * As otherwise we'd set SMBDIRECT_SOCKET_DISCONNECTING
+		 * and call rdma_disconnect(), but never ever get
+		 * RDMA_CM_EVENT_DISCONNECTED.
 		 */
 		if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
 			smbdirect_socket_schedule_cleanup_status(sc,
@@ -113,9 +113,9 @@ static int smbdirect_connection_rdma_event_handler(struct rdma_cm_id *id,
 		 * smbdirect_socket_schedule_cleanup_status() =>
 		 * smbdirect_socket_cleanup_work().
 		 *
-		 * As otherwise we'd set SMBDIRECT_SOCKET_DISCONNECTING,
-		 * but never ever get RDMA_CM_EVENT_DISCONNECTED and
-		 * never reach SMBDIRECT_SOCKET_DISCONNECTED.
+		 * As otherwise we'd set SMBDIRECT_SOCKET_DISCONNECTING
+		 * and call rdma_disconnect(), but never ever get
+		 * RDMA_CM_EVENT_DISCONNECTED.
 		 *
 		 * This is also a normal disconnect so
 		 * SMBDIRECT_LOG_INFO should be good enough
diff --git a/fs/smb/smbdirect/socket.c b/fs/smb/smbdirect/socket.c
index bb02df6158b9..c36cb7cc0088 100644
--- a/fs/smb/smbdirect/socket.c
+++ b/fs/smb/smbdirect/socket.c
@@ -511,7 +511,13 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 	if (sc->status == SMBDIRECT_SOCKET_DESTROYED)
 		return;
 
-	WARN_ONCE(sc->status != SMBDIRECT_SOCKET_DISCONNECTED,
+	/*
+	 * smbdirect_socket_destroy_sync() doesn't wait
+	 * for RDMA_CM_EVENT_DISCONNECTED, so we may still
+	 * be in SMBDIRECT_SOCKET_DISCONNECTING
+	 * (or already reached SMBDIRECT_SOCKET_DISCONNECTED)
+	 */
+	WARN_ONCE(sc->status < SMBDIRECT_SOCKET_DISCONNECTING,
 		  "status=%s first_error=%1pe",
 		  smbdirect_socket_status_string(sc->status),
 		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
@@ -542,6 +548,32 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 	if (sc->rdma.cm_id)
 		rdma_lock_handler(sc->rdma.cm_id);
 
+	/*
+	 * We hold the handler lock, so the rdma event
+	 * handlers can't change the status anymore.
+	 *
+	 * If RDMA_CM_EVENT_DISCONNECTED didn't arrive yet,
+	 * we just stop waiting for it here.
+	 *
+	 * We already disabled disconnect_work above
+	 * and before we call rdma_unlock_handler below
+	 * we call smbdirect_connection_destroy_qp which
+	 * sets sc->ib.qp = NULL.
+	 *
+	 * Between rdma_unlock_handler() and
+	 * rdma_destroy_id() below there's a small
+	 * windows where RDMA_CM_EVENT_DISCONNECTED
+	 * could still arrive.
+	 *
+	 * But smbdirect_connection_rdma_event_handler
+	 * will be a noop when calling smbdirect_socket_schedule_cleanup*
+	 * ib_drain_qp() also won't be called.
+	 */
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED) {
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		smbdirect_socket_wake_up_all(sc);
+	}
+
 	if (sc->ib.qp) {
 		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 			"drain qp\n");
@@ -679,17 +711,21 @@ void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
 		"destroying rdma session\n");
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
 		smbdirect_socket_cleanup_work(&sc->disconnect_work);
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED) {
-		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
-			"wait for transport being disconnected\n");
-		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
-		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
-			"waited for transport being disconnected\n");
-	}
 
 	/*
-	 * Once we reached SMBDIRECT_SOCKET_DISCONNECTED,
-	 * we should call smbdirect_socket_destroy()
+	 * We don't wait for RDMA_CM_EVENT_DISCONNECTED,
+	 * rdma_disconnect() was already called by
+	 * smbdirect_socket_cleanup_work() if needed
+	 * and smbdirect_socket_destroy() drains the qp,
+	 * destroys it and calls rdma_destroy_id(), which
+	 * only waits for a currently running event handler
+	 * and makes sure no further events are delivered.
+	 * The rest of the disconnect protocol is handled
+	 * by the rdma core asynchronously.
+	 *
+	 * Waiting for RDMA_CM_EVENT_DISCONNECTED could
+	 * take very long or forever, e.g. if the peer
+	 * just disappeared.
 	 */
 	smbdirect_socket_destroy(sc);
 	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
-- 
2.43.0

