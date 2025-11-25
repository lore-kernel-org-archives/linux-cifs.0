Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F09432938F
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094716; cv=none; b=o2PLpDqQr6zujR24rvxSLV3H9ONkTNnbdxIJ6+AtBQ+vJNJq5fZnG0GWjmsB7qLIGvw7Kplt1fAen6WG55BmovZy2vQVtKF4TF/0jvjnhEwUu0JSPEDt6oTffqt1rBUCwoAMr0AfDLPn2NbRSXLkaEUF6gqBFyzhaoYsXSWgn7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094716; c=relaxed/simple;
	bh=0BcJcDkcYbkXkJwfDkWXTtzTesTdVK6OWqryiXCRCKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jk2ZKYZWZcYnWF/nRTei4ZrY9KuzgVtOFoQVbQf+6sBnpzuSbsw5Be5118H1CY7gYTtyhiUnQwrlzsqSq9TkzQSTEa2P9O4uwVCZRt5POaGeBuX3xT2gD6MOTkQT+F719jDrDhQRCGk0uCDlWcmXSFOT/pTgJZqRlNosT/R6r4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pVJMH2Uy; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pVJMH2Uy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Y1mWTUboue/n+Dtwr2ru+Odi42lsD7K8QEiFpG3ApCU=; b=pVJMH2UyRHgli/QRSHSJA9QZUL
	BSosBYktKgcZuTCSSisw7fbZG7nBP3kzzNbw6OucVLzDeLelTZt2fO5YOk5xteGycNIu5vYrKTpBY
	7qx7UAEsHmUuhEAEoLMDMoSN3SFPrDsqwu16urMtwXfDR/ztuC8bfT71XEJf1zKqkXs9r1DTW8XqG
	ji83rQN8nSqvYbRfRoEtRelNoql8O316LBb3pMiCLmWIm+UF28A1q3CuQ1pUiAb584PJsjtrjc5eN
	2H8cNPjywG6m75tjU7XjGW3pDndL56dz+wxyV7Dp+kN0X8qUX0D71lJS6Ax49bIH6Pkvm7jawDTnP
	xEBZJV7hg7imyRZd9RVizVsLEzWBqz19CkFUdZPdLU9rgNhAtIivxpKnb/FTIX5D0ZXU41PnhoCCz
	I/krISg/z4CvTNj/RKU1l1fcsyZkHgMnvi/NthOuOQ37ejNGDk2iajUVbeF/Fsys50GZd06FV6hSp
	NRTaHLUGZIJaaSV+VxUXbud0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxV3-00FeH9-26;
	Tue, 25 Nov 2025 18:10:50 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 101/145] smb: server: make use of smbdirect_socket_cleanup_work()
Date: Tue, 25 Nov 2025 18:55:47 +0100
Message-ID: <e9c66251d0913867dff87e72e4b2cbddfb4f754c.1764091285.git.metze@samba.org>
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

Note smbdirect_socket_prepare_create() already calls INIT_WORK()
with smbdirect_socket_cleanup_work.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 70 +++-------------------------------
 1 file changed, 5 insertions(+), 65 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 84da674bef85..e29351780b90 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -285,64 +285,6 @@ static struct smbdirect_recv_io *get_first_reassembly(struct smbdirect_socket *s
 		return NULL;
 }
 
-static void smb_direct_disconnect_rdma_work(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, disconnect_work);
-
-	if (sc->first_error == 0)
-		sc->first_error = -ECONNABORTED;
-
-	/*
-	 * make sure this and other work is not queued again
-	 * but here we don't block and avoid
-	 * disable[_delayed]_work_sync()
-	 */
-	disable_work(&sc->disconnect_work);
-	disable_work(&sc->recv_io.posted.refill_work);
-	disable_delayed_work(&sc->idle.timer_work);
-	disable_work(&sc->idle.immediate_work);
-
-	switch (sc->status) {
-	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
-	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
-	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
-	case SMBDIRECT_SOCKET_CONNECTED:
-	case SMBDIRECT_SOCKET_ERROR:
-		sc->status = SMBDIRECT_SOCKET_DISCONNECTING;
-		rdma_disconnect(sc->rdma.cm_id);
-		break;
-
-	case SMBDIRECT_SOCKET_CREATED:
-	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
-	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
-	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
-	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
-	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
-	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
-	case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
-	case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
-	case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
-		/*
-		 * rdma_accept() never reached
-		 * RDMA_CM_EVENT_ESTABLISHED
-		 */
-		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		break;
-
-	case SMBDIRECT_SOCKET_DISCONNECTING:
-	case SMBDIRECT_SOCKET_DISCONNECTED:
-	case SMBDIRECT_SOCKET_DESTROYED:
-		break;
-	}
-
-	/*
-	 * Wake up all waiters in all wait queues
-	 * in order to notice the broken connection.
-	 */
-	smbdirect_socket_wake_up_all(sc);
-}
-
 static void
 smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
@@ -482,8 +424,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	 */
 	sp = &sc->parameters;
 
-	INIT_WORK(&sc->disconnect_work, smb_direct_disconnect_rdma_work);
-
 	sc->rdma.cm_id = cm_id;
 	cm_id->context = sc;
 
@@ -520,7 +460,7 @@ static void free_transport(struct smb_direct_transport *t)
 
 	disable_work_sync(&sc->disconnect_work);
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
-		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_socket_cleanup_work(&sc->disconnect_work);
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED)
 		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 
@@ -529,7 +469,7 @@ static void free_transport(struct smb_direct_transport *t)
 	 * in order to notice the broken connection.
 	 *
 	 * Most likely this was already called via
-	 * smb_direct_disconnect_rdma_work(), but call it again...
+	 * smbdirect_socket_cleanup_work(), but call it again...
 	 */
 	smbdirect_socket_wake_up_all(sc);
 
@@ -1791,7 +1731,7 @@ static void smb_direct_shutdown(struct ksmbd_transport *t)
 
 	ksmbd_debug(RDMA, "smb-direct shutdown cm_id=%p\n", sc->rdma.cm_id);
 
-	smb_direct_disconnect_rdma_work(&sc->disconnect_work);
+	smbdirect_socket_cleanup_work(&sc->disconnect_work);
 }
 
 static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
@@ -1823,14 +1763,14 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_DISCONNECTED: {
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_socket_cleanup_work(&sc->disconnect_work);
 		if (sc->ib.qp)
 			ib_drain_qp(sc->ib.qp);
 		break;
 	}
 	case RDMA_CM_EVENT_CONNECT_ERROR: {
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_socket_cleanup_work(&sc->disconnect_work);
 		break;
 	}
 	default:
-- 
2.43.0

