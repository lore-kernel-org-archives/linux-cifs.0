Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D427E3314B9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744508; cv=none; b=e0pJY2NsWNzL+GUTMkNMUCrIx3GQ9v/hRRuLwDFgN1MFWHLXk0QPR30gl16iWkOJdkJjb9JFx3Ji7SB/y1o6SLwPh9/BQZVnF3n4n276iu+dHBuFddDREmm8/9KLm+1GLD3FhDgKyBS23rbwSgdMFiEgbfy/sOrCd5PS3ZYjGEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744508; c=relaxed/simple;
	bh=zWL0RzEgxVSrjE2Xlg7T7CUYt6tKrzKW+UUOb6o9P24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTqg5f0WtzGziKe8qNQFLtP5Qq2z90wTdndUZY8GBvtao1QgLH4DXXy3zyagC0Wlbaz4CgKWIPu/y/NsVqftWTbDdc24/iR0O840Cm5IMHbMBNXASylfZQ85Xnsyk0NhxsxcIm4bVF/fkur5dL7LEFF6HXINqTUj2shnd9W5VLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=LD7ot6wb; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="LD7ot6wb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ewn7hEpn46xqrg3f/aglcZOHkTJEgenulzg1xHIIinU=; b=LD7ot6wbX9Xki36CB3zagXZ+lU
	pkSKdNYyTHXHsW38V2CozJ6/tcJEb9dtftw+9bcR5lB29FaDcLx+ye3QLbO0Obb7K5yN6QpXSVr5c
	AMWfEtAntLH2Dqmwq8MPPNm6M0OQloNOYEJnYlXiREXBF4cRsMP5GOBw1csW+qJM3yiObVYoYVgqq
	lM4bnQC1PpYUkH1PkCIEND/A32ifhPSRPuZMSFxYgrWaYncytxTbeQAbH4cU0mwqpGYn2blEohWuo
	4qUd+WAuqv7tC2QAXQGtEA31Y8D6p6o+JSTUZmMShbt3LqOP8e3KwfpM5QhjBTRLkKz/yhnfdZaE0
	76dOtr1kMhNGdVwrTIs5JqLZaNwK2IeJG6a394j1CGa9Kmk5HWxJpT3qU41600apeB47dMeNipEMB
	1zDyW2j35AmKgtsqHr4c+6Ac43h1qSrplliX013G7SW69iRCqZdT3qjbMHow/2dvzlhb8FmTpzWOo
	7M9psWKOjQSv94Eer5ggRT4J;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Dv-00Bc5W-2p;
	Wed, 29 Oct 2025 13:28:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 060/127] smb: client: make use of smbdirect_connection_disconnect_work()
Date: Wed, 29 Oct 2025 14:20:38 +0100
Message-ID: <af982eebbb96f3d8c4b4c26fcebdc882d9f1859a.1761742839.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 73 ++++-----------------------------------
 1 file changed, 6 insertions(+), 67 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c6f2bb5fc262..137fad17e5a1 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -213,65 +213,6 @@ do {									\
 #define log_rdma_mr(level, fmt, args...) \
 		log_rdma(level, LOG_RDMA_MR, fmt, ##args)
 
-static void smbd_disconnect_rdma_work(struct work_struct *work)
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
-	disable_work(&sc->mr_io.recovery_work);
-	disable_work(&sc->idle.immediate_work);
-	disable_delayed_work(&sc->idle.timer_work);
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
-		 * rdma_connect() never reached
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
 static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
 	/*
@@ -366,14 +307,14 @@ static int smbd_conn_upcall(
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_connection_disconnect_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_connection_disconnect_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_ESTABLISHED:
@@ -468,7 +409,7 @@ static int smbd_conn_upcall(
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_connection_disconnect_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -479,7 +420,7 @@ static int smbd_conn_upcall(
 		}
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_connection_disconnect_work(&sc->disconnect_work);
 		break;
 
 	default:
@@ -1625,7 +1566,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 
 	log_rdma_event(INFO, "destroying rdma session\n");
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_connection_disconnect_work(&sc->disconnect_work);
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED) {
 		log_rdma_event(INFO, "wait for transport being disconnected\n");
 		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
@@ -1637,7 +1578,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	 * in order to notice the broken connection.
 	 *
 	 * Most likely this was already called via
-	 * smbd_disconnect_rdma_work(), but call it again...
+	 * smbdirect_connection_disconnect_work(), but call it again...
 	 */
 	smbdirect_connection_wake_up_all(sc);
 
@@ -1859,8 +1800,6 @@ static struct smbd_connection *_smbd_get_connection(
 	 */
 	sp = &sc->parameters;
 
-	INIT_WORK(&sc->disconnect_work, smbd_disconnect_rdma_work);
-
 	rc = smbd_ia_open(sc, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
-- 
2.43.0

