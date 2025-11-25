Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB2B32BF23
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094004; cv=none; b=Gal/S8hNu9/QV7+OpJny0FfI6A/YGMFcF6vfex69fiRIEWalwZlu6E+xkBJKL3blgPW2Uwr5SvliVFpG2pPgqL4j9Xx7tqogtcFKLaVOUowmgoFOPvPZC2le7T+Cve4nBlug1qHbwxn7nqz/HP4Ne8QUosYpeYpYpRuLnMsMlrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094004; c=relaxed/simple;
	bh=RSHuci5EEM0JvC1gAno/cMKSP3UItYhkByY0m8hLSqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CECB857MZonU4GEaFMOTUaPyenYUeac+RKiEc5aHbSPI6HdxKDwYaoZLJGuJGhKotuSDOVlI+ZY21jtPQcA+zFw1DisNtV2P56i+xjAHCmitNlw7CQi3X+kNBiEgk1M/6VN+pM+WeJqtoPOC9gctOtKa2j1IMKlxSrEMkJDRzNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=p245cYkR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="p245cYkR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=QS9GoDQ1rh9VRVeM8776IqDFlvfcs/cTHrcAYyciI1Y=; b=p245cYkRt8E9cEF6Y1b3RKt/Kg
	tEegB/ofbPmlE5EQkZ7ROMfe119fXlqxiD83bJw3lUKJJLRWrYBat9IbR9D7dnAfJWuxuzMXBzTLI
	QnZO2ehW0lwd4h7sVCkm423SluYOvmAr37CCtCgkSSJuaJMZ4icHEVQTYxFDknDDoaZmPLvYigXy4
	NqbG7NKw/L89Gp1cY1VQeUBVI6xawT3TqOuzhh1nkaruoyJyGsfpv1Vb89AaitYlzX0bj5Xf1h6fN
	/lPinBDAvVLMSK7KfohTG9axXJATgk94mGafjzFD/p2PB/ju1dgKaTjUxejta0ZlLS6N376m6Qpk+
	0394+nqVy6NY22sACNltZpFjwgRDlZdifRMag4FMrRsGCMGQQkcZyABydLhHzOPsC721nQ05geY0a
	fbsbid2a3W2zMJKiS21WrM9bsJ+uEYiqBHVtKcGPdSLU1YbR2X7xjKdnCPgEWK7RPpPJWzekkKS2b
	fbgZHrAOyiQEpKEuyXcOTks9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxO1-00Fdce-0U;
	Tue, 25 Nov 2025 18:03:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 065/145] smb: client: make use of smbdirect_socket_cleanup_work()
Date: Tue, 25 Nov 2025 18:55:11 +0100
Message-ID: <91d51cd9289d61d24469799c22892b9ab32696ff.1764091285.git.metze@samba.org>
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
index 33f3cbc0bbd9..1ad34066fbcb 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -216,65 +216,6 @@ do {									\
 #define log_rdma_mr(level, fmt, args...) \
 		log_rdma(level, LOG_RDMA_MR, fmt, ##args)
 
-static void smbd_disconnect_rdma_work(struct work_struct *work)
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
-	disable_work(&sc->mr_io.recovery_work);
-	disable_work(&sc->idle.immediate_work);
-	disable_delayed_work(&sc->idle.timer_work);
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
-	smbdirect_socket_wake_up_all(sc);
-}
-
 static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
 	if (sc->first_error == 0)
@@ -373,13 +314,13 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_ADDR_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_socket_cleanup_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_socket_cleanup_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_ESTABLISHED:
@@ -474,7 +415,7 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_REJECTED:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_socket_cleanup_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -485,7 +426,7 @@ static int smbd_conn_upcall(
 		}
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_socket_cleanup_work(&sc->disconnect_work);
 		break;
 
 	default:
@@ -1634,7 +1575,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 
 	log_rdma_event(INFO, "destroying rdma session\n");
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
-		smbd_disconnect_rdma_work(&sc->disconnect_work);
+		smbdirect_socket_cleanup_work(&sc->disconnect_work);
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED) {
 		log_rdma_event(INFO, "wait for transport being disconnected\n");
 		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
@@ -1646,7 +1587,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	 * in order to notice the broken connection.
 	 *
 	 * Most likely this was already called via
-	 * smbd_disconnect_rdma_work(), but call it again...
+	 * smbdirect_socket_cleanup_work(), but call it again...
 	 */
 	smbdirect_socket_wake_up_all(sc);
 
@@ -1868,8 +1809,6 @@ static struct smbd_connection *_smbd_get_connection(
 	 */
 	sp = &sc->parameters;
 
-	INIT_WORK(&sc->disconnect_work, smbd_disconnect_rdma_work);
-
 	rc = smbd_ia_open(sc, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
-- 
2.43.0

