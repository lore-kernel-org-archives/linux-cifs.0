Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33222882D7
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154707; cv=none; b=lLGuItzNX1Fog/ECnmIj1jGy6MrKZXZRzyKoTn57tcPgvWhcyeoCWEKxH+6bAblIfg6FU3D1fcmppQwFv+IWPpNBpQb2iCjU0ekXzaqb1+oGtESU9qWg+U2xZDeUjaNXE4/D0zYfp+SGMTZh1Twq5anRRP6KMh+TBTQ5UmbloEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154707; c=relaxed/simple;
	bh=xyuukrNjxtnxWA6a8iRj9U55RrDPLSeuGMoZbh2zWyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blo/eea0FOeF6X6oErXhyWw9inNlc3iQeWWgnjr/LEtReOyYxERL6Tf9fCr1ddwx3HbQKa1i5GGkNrvE2opAHHu5ozp81wBDWBwikyPRR81xnTqo72GdOuCjgHsrRviklvtPiEqfm7iK2tNoP3JaXaHP+Jo5T4J3Rrh/zjZTbi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Au1zbtyL; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Au1zbtyL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=x4dfi8P27Xc82DtB2D5ti/7sMEqKF2LGdX0GmfUgZf4=; b=Au1zbtyL+t8QAcwRdnuFQZw4kZ
	hEv+QIyxlLltJWt3DSUk8KFy+omLLQLzI7A2594n92IsolTxntw2GTCdUgV0mrLrL/IVyoto7Spfy
	qC2Vgt0pPMN/52FtnVNbLNHp2aRtvtK95DTCfAH86JI9+PafQJ91BM1EYxKy38OnIF8nYnXWkK3rq
	wSHeGswguW2d+WtyElEAKWDHGTLNUGSRAhW7wUdHOMQ9RsD3tiVatT/bNa7YDhQlqHI3g60OAzcJg
	MG6nlbWCsgTOJfJYznXTWFI3Vrs0a1irrW6YHt7b2f1/X+ZfMaOyFKNCfcumWuaw9E/vlmsOOxSSS
	NqlHUdgXmnG9OfqoMGp52mcG+gC04mheLEyZYlX4hmAtJn6DQGpMTFImkr/Yt1tWpvbFRNZkt3oPB
	4jwfTm7B846CiFSC9CiavGJgoEv09g5/mL05cq6U32/K7+MO62orHvDlF17zb7UZSidqyVS2NTgXp
	UApMBbqNP/7Fz+JSRdFfgzzT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe3p-000jni-08;
	Mon, 25 Aug 2025 20:45:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 019/142] smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with more detailed states
Date: Mon, 25 Aug 2025 22:39:40 +0200
Message-ID: <4b499adfcfffe43e8486442478997f6e44f2ea3d.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The process of reaching a functional connection represented by
SMBDIRECT_SOCKET_CONNECTED, is more complex than using a single
SMBDIRECT_SOCKET_CONNECTING state.

This will allow us to remove a lot of special variables and
completions in the following commits.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c                  | 73 ++++++++++++++++++++--
 fs/smb/common/smbdirect/smbdirect_socket.h | 14 ++++-
 2 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 669408b113cb..cfc5e17bc055 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -161,9 +161,36 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 		container_of(work, struct smbd_connection, disconnect_work);
 	struct smbdirect_socket *sc = &info->socket;
 
-	if (sc->status == SMBDIRECT_SOCKET_CONNECTED) {
+	switch (sc->status) {
+	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
+	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
+	case SMBDIRECT_SOCKET_CONNECTED:
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTING;
 		rdma_disconnect(sc->rdma.cm_id);
+		break;
+
+	case SMBDIRECT_SOCKET_CREATED:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
+		/*
+		 * rdma_connect() never reached
+		 * RDMA_CM_EVENT_ESTABLISHED
+		 */
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		break;
+
+	case SMBDIRECT_SOCKET_DISCONNECTING:
+	case SMBDIRECT_SOCKET_DISCONNECTED:
+	case SMBDIRECT_SOCKET_DESTROYED:
+		break;
 	}
 }
 
@@ -187,19 +214,31 @@ static int smbd_conn_upcall(
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED;
+		info->ri_rc = 0;
+		complete(&info->ri_done);
+		break;
+
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
+		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED;
 		info->ri_rc = 0;
 		complete(&info->ri_done);
 		break;
 
 	case RDMA_CM_EVENT_ADDR_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
 		info->ri_rc = -EHOSTUNREACH;
 		complete(&info->ri_done);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
 		info->ri_rc = -ENETUNREACH;
 		complete(&info->ri_done);
 		break;
@@ -259,7 +298,8 @@ static int smbd_conn_upcall(
 				min_t(u8, info->responder_resources,
 				      peer_responder_resources);
 
-		sc->status = SMBDIRECT_SOCKET_CONNECTED;
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
+		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
 		wake_up_interruptible(&info->status_wait);
 		break;
 
@@ -267,7 +307,8 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_UNREACHABLE:
 	case RDMA_CM_EVENT_REJECTED:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
-		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
+		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
 		wake_up_interruptible(&info->status_wait);
 		break;
 
@@ -536,6 +577,12 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		info->negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
 		put_receive_buffer(info, response);
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING);
+		if (!info->negotiate_done)
+			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
+		else
+			sc->status = SMBDIRECT_SOCKET_CONNECTED;
+
 		complete(&info->negotiate_completion);
 		return;
 
@@ -611,6 +658,7 @@ static struct rdma_cm_id *smbd_create_id(
 		struct smbd_connection *info,
 		struct sockaddr *dstaddr, int port)
 {
+	struct smbdirect_socket *sc = &info->socket;
 	struct rdma_cm_id *id;
 	int rc;
 	__be16 *sport;
@@ -633,6 +681,8 @@ static struct rdma_cm_id *smbd_create_id(
 	init_completion(&info->ri_done);
 	info->ri_rc = -ETIMEDOUT;
 
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING;
 	rc = rdma_resolve_addr(id, NULL, (struct sockaddr *)dstaddr,
 		RDMA_RESOLVE_TIMEOUT);
 	if (rc) {
@@ -653,6 +703,8 @@ static struct rdma_cm_id *smbd_create_id(
 	}
 
 	info->ri_rc = -ETIMEDOUT;
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING;
 	rc = rdma_resolve_route(id, RDMA_RESOLVE_TIMEOUT);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_resolve_route() failed %i\n", rc);
@@ -699,6 +751,9 @@ static int smbd_ia_open(
 	struct smbdirect_socket *sc = &info->socket;
 	int rc;
 
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED);
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED;
+
 	sc->rdma.cm_id = smbd_create_id(info, dstaddr, port);
 	if (IS_ERR(sc->rdma.cm_id)) {
 		rc = PTR_ERR(sc->rdma.cm_id);
@@ -1140,6 +1195,9 @@ static int smbd_negotiate(struct smbd_connection *info)
 	int rc;
 	struct smbdirect_recv_io *response = get_receive_buffer(info);
 
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
+
 	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
 	rc = smbd_post_recv(info, response);
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
@@ -1594,7 +1652,7 @@ static struct smbd_connection *_smbd_get_connection(
 	info->initiator_depth = 1;
 	info->responder_resources = SMBD_CM_RESPONDER_RESOURCES;
 
-	sc->status = SMBDIRECT_SOCKET_CONNECTING;
+	sc->status = SMBDIRECT_SOCKET_CREATED;
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
@@ -1706,6 +1764,9 @@ static struct smbd_connection *_smbd_get_connection(
 
 	init_waitqueue_head(&info->status_wait);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
+
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING;
 	rc = rdma_connect(sc->rdma.cm_id, &conn_param);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_connect() failed with %i\n", rc);
@@ -1714,10 +1775,10 @@ static struct smbd_connection *_smbd_get_connection(
 
 	wait_event_interruptible_timeout(
 		info->status_wait,
-		sc->status != SMBDIRECT_SOCKET_CONNECTING,
+		sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+	if (sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED) {
 		log_rdma_event(ERR, "rdma_connect failed port=%d\n", port);
 		goto rdma_connect_failed;
 	}
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 350ccb362718..64abe6932fef 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -10,9 +10,19 @@
 
 enum smbdirect_socket_status {
 	SMBDIRECT_SOCKET_CREATED,
-	SMBDIRECT_SOCKET_CONNECTING,
-	SMBDIRECT_SOCKET_CONNECTED,
+	SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED,
+	SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING,
+	SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED,
+	SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED,
+	SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING,
+	SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED,
+	SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED,
+	SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
+	SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED,
+	SMBDIRECT_SOCKET_NEGOTIATE_NEEDED,
+	SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
 	SMBDIRECT_SOCKET_NEGOTIATE_FAILED,
+	SMBDIRECT_SOCKET_CONNECTED,
 	SMBDIRECT_SOCKET_DISCONNECTING,
 	SMBDIRECT_SOCKET_DISCONNECTED,
 	SMBDIRECT_SOCKET_DESTROYED
-- 
2.43.0

