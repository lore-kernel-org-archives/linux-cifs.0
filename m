Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362525;
	b=EyyApxNIGgTXP+8ELaWAn3OQeXOcUuDIAKM/63hvVG0Uk1VMXsa+VxApBKrKMvnKFnh9
	 6mgAbF+zibbhNmgmIyXaDGnA2KLC3sowHKs5fkAOqzZNhHhQNC56Qm/CKcwOvo3L6pBRz
	 AuURLQQTZI5dO4i32uqEWt/2AcvJcc8nr8WBdjFgTc+gBrMSlYCjW2RHneNRKUUYgSSFl
	 3mOkxdzM8BePAPiv9sc3AfMx8fjZN56d0BsDUBNQHkZ4yBE2C0YzRS9WptXK+p3yNL39d
	 b7eUP27iL7gWGZdBgHiZM2UmcES5xug1/R2QvCChykh35eK9VFMROGvzj6+yogZc6ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iVAPCz/duq6Ei4fLDza3hQbfWkjOOCGWD3IMy9t7VoA=;
	b=WxyxkAn9sHr4IQWq0ZYUn3gxzLse33sU2y1EN4XO5fz3yHfEdHCe+gLcfpdiLYyTwb2P
	 2+U9R/7NvNSoKR8QzQAPTb93wo1q/Z6BhaqP1eJbcmT+pRzWVt0Ko5Y8oQteymlKGzR5k
	 mBcWrbfJG9cbsDgjOoY9fmyQLVf0zRwXVnVFJUxvvi0WuApZPnT3xzoCcXuHHbztnhjsc
	 02SQwL106uRP9Drgp8e55rwZ0dVN9QGD8fIXtoV3ubIvoOqfQYnD3mCyFrAni9MkI25ig
	 Uu/rJmuQo4zkWWfbz/AqnjSv3gHw5HzGDoi3yG/2fkloFt2rv4rS3YfDRz7oHIRygSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTxzaPT0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2233606A32C;
	Fri, 30 Oct 2026 12:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTxzaPT0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECDD1F00A02;
	Fri, 30 Oct 2026 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793362524;
	bh=iVAPCz/duq6Ei4fLDza3hQbfWkjOOCGWD3IMy9t7VoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTxzaPT0jmrVB7ydTbKQve1uPyPNUge10DKvr2lmhc6zBwUe/jKd8xL0v4GixtJNs
	 3gP02xNK3xab2xOCp6G6jeFAzsDVUcrTVhgy2EOl/4Oz2c9kmxa8uk1fjDOL+fMIvF
	 ofIz9g7n4hUcP8neUnBL9vTMo7X7UL4F50x8m9Rw=
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
Subject: [PATCH 7.2 02/10] smb: smbdirect: dont wait for RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()
Date: Fri, 30 Oct 2026 13:15:03 +0100
Message-ID: <20261030121255.317472282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index fe99537207176..32327f96a03ab 100644
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



