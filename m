Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826778;
	b=oHkNJQuYaiZXbPV7YgxybtTKg0oQTxkmFRo11J1Nr9dXrJEBQuBHNNDwbDLgkrqYw2cY
	 Jd938plQICr28ZdD9MgvDp1CyGUAFD0gYDT+kq93mh8UJVuPG9DorY1cpbabrTmhodJzU
	 nRNczu9tzw0LwWlDMH+Pwp4mk1E1KLevXka/uk0qdniXihxPloiXegZj4B85S0YeBNTne
	 Hwsyp5EGwoK/5KkgeqtTYpAC+D3JjGZPN5AdzY6UbWYb83EYaHiRJ4jeOyAT9sBHA1JuG
	 L1+0nkxpAXMl162xX3+5yWHRJ79waVBOXlEcwRWv+olvkJe/1pgG5RQjIoeSxV9WGdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Js3H5w5P7g1bfalxuJQng6+wcgfsNELPLVPcB1aF3Qg=;
	b=FKyUoQxTeGnwN8CeL67qVt/DhP9SNLnlzBtRiUo0K6yRKOIEDcy9Zz5r2KKAkpbJspjz
	 8eFxR+8dbvOSaig2Mvx0EwxoDot3veWQoHnGkZYtGDVFp5ECSR29kez0q+Uq14F0GizTs
	 ZWC/mIT8j1PkvJhlRX5+jHgkoCmOJ2NdSwVVtjslrZu3BScEP6URNM2LuST1fsq5TARlg
	 mDqSqQWyvO2Rl4nmxc9xFnX82TagQqIbzvEXZ3bqP1Atg58bB3udoNELMyT/rU9lgeARm
	 0xOUcjVe/t95uS5vG/5U2a4ggvQGnyFuoSOewAY3QNu+ow6mKRn2HcQyBNh9SJWgSbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dU1sE/L9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF5B6071A05;
	Wed,  4 Nov 2026 21:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dU1sE/L9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F7B1F00A16;
	Wed,  4 Nov 2026 21:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826778;
	bh=Js3H5w5P7g1bfalxuJQng6+wcgfsNELPLVPcB1aF3Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dU1sE/L9VHjS831NIo9QQqmWBPK5UMM8Y4snY/gmPYHsEgwuOzJvl850CKyqbajS1
	 uuC0eikU4eP2h46K/dnPZKrAUQsxlNDcW6j11YrAXYsmeZhwQgBaerPc8UI9VF4hBM
	 bPcPAni3Q4y0FOz+jpIp0Gxa8DRsRjeNnnn36iJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-rdma@vger.kernel.org,
	Stefan Metzmacher <metze@samba.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 003/547] smb: smbdirect: dont wait for RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()
Date: Wed,  4 Nov 2026 16:03:07 -0500
Message-ID: <20261104211038.498675154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 4ca76b89917ad5b317e07ae4f0edc16f7c2a1248 ]

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
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/smbdirect/connection.c | 12 ++++----
 fs/smb/smbdirect/socket.c     | 56 ++++++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index afd31fa12a368..f48c857bda5a4 100644
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
index bb02df6158b97..c36cb7cc0088b 100644
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
2.53.0



