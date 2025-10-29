Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6962C028D
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744725; cv=none; b=sauoh+WL3vS8xP0dPH829x543i1xgAXDloj3Q7S4qFm6BwGlSO576+01Eb+zj6q1sjHx6bUvbjlIwI3iPfTTYRV9U/v7jdaR0bYEZ30wG52zwzRrQ2rrdCTlqOP9nmxUiv3Munlcj8FXATYZOu2nWZmcELX7z9Z34MhPYddHHh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744725; c=relaxed/simple;
	bh=uPuOxCS/aHDDttgK5xSPeR/uv8LQd/5HUzKqjT71MKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl2pJJIyQUqAxvuuoHZ5VdTxtDTUG3JS5W8wxiFUyuCg4F7vukLJIN7BFnKgzkcKRMMYnE88yNa7UCNiUAaJe82Ii5NzvZ7HBfQsCzzGuu5pG8sUADst/mVx0kXEQHMDjOIbESZSOwYGSKeK35Cq37VLPxFfSjYwDvjzv+vuKpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=kJkfvB/u; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="kJkfvB/u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=x3RKBq5bQS7gxztO8s3r+jkzX6f094h3iqIdMA88o+k=; b=kJkfvB/usyEW1yYcwouipWtA6w
	1dOB5eU1aaTQfAvj1cXm5WMCBvV6YGD8UtIQiwaoh5j62v6ylO/uXiDFeXttQuI0wY/NTF7xfD0kF
	IzfrqSBDYWZx45hB7iNwJ6iKNaqfnjyYeFK7Z5g44m7tvvvax5ivxCFBrN+nQb9ubhlhuQ0M6Og41
	/58trBcW6q99RD8kM1mP6qtsyGg3PrBkBK9iuwX/TYdz/mEfCqd8rYep7Umo/1y9nwU4t5BN63pZn
	NO+paM8clt/Gz1QPRgUd8bVSe4GM4lt34RGTSa7pMPxDJK6KGhpH4wI0i5gN8xsxPueO4vuCfFE+J
	azFNnnMBDkJey7zkTL8/yvaXkNQx/ymhVEFgccw1cJ186frVMn9ICaTHrZFM2/1uIxUoUkeQ1THRx
	DsgB448fm7rW6RwaY7xGof6g8cDczwhWlJbL48Ahy5iH3s/VsDa9u1v3bfMxXftMGRgM//3Vs7S66
	efo0BS/CfzdhYkaRVMVDNOZA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6HR-00Bcfz-00;
	Wed, 29 Oct 2025 13:32:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 095/127] smb: server: make use of smbdirect_connection_disconnect_work()
Date: Wed, 29 Oct 2025 14:21:13 +0100
Message-ID: <762f2fbc1b1dbd5fb1484bb8d550ddeb7e6aacd5.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note smbdirect_socket_prepare_create() already calls INIT_WORK()
with smbdirect_connection_disconnect_work.

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
index b78753801fe5..a649194ab6c8 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -281,64 +281,6 @@ static struct smbdirect_recv_io *get_first_reassembly(struct smbdirect_socket *s
 		return NULL;
 }
 
-static void smb_direct_disconnect_rdma_work(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, disconnect_work);
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
-	if (sc->first_error == 0)
-		sc->first_error = -ECONNABORTED;
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
-	smbdirect_connection_wake_up_all(sc);
-}
-
 static void
 smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
@@ -475,8 +417,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	 */
 	sp = &sc->parameters;
 
-	INIT_WORK(&sc->disconnect_work, smb_direct_disconnect_rdma_work);
-
 	sc->rdma.cm_id = cm_id;
 	cm_id->context = sc;
 
@@ -513,7 +453,7 @@ static void free_transport(struct smb_direct_transport *t)
 
 	disable_work_sync(&sc->disconnect_work);
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
-		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_connection_disconnect_work(&sc->disconnect_work);
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED)
 		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 
@@ -522,7 +462,7 @@ static void free_transport(struct smb_direct_transport *t)
 	 * in order to notice the broken connection.
 	 *
 	 * Most likely this was already called via
-	 * smb_direct_disconnect_rdma_work(), but call it again...
+	 * smbdirect_connection_disconnect_work(), but call it again...
 	 */
 	smbdirect_connection_wake_up_all(sc);
 
@@ -1773,7 +1713,7 @@ static void smb_direct_shutdown(struct ksmbd_transport *t)
 
 	ksmbd_debug(RDMA, "smb-direct shutdown cm_id=%p\n", sc->rdma.cm_id);
 
-	smb_direct_disconnect_rdma_work(&sc->disconnect_work);
+	smbdirect_connection_disconnect_work(&sc->disconnect_work);
 }
 
 static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
@@ -1794,14 +1734,14 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_DISCONNECTED: {
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_connection_disconnect_work(&sc->disconnect_work);
 		if (sc->ib.qp)
 			ib_drain_qp(sc->ib.qp);
 		break;
 	}
 	case RDMA_CM_EVENT_CONNECT_ERROR: {
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_connection_disconnect_work(&sc->disconnect_work);
 		break;
 	}
 	default:
-- 
2.43.0

