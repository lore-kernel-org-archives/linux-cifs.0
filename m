Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369B41400C
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754583185; cv=none; b=aNEm96YK08CB4tR//m1Wr/DmWnY8sHH9NHmdR66mmSd5hMM2HkIe8SFv9r3uL70G+AkLZSZZoxxAC2lonQwYOTZBltIvgE7w015b2afptSKigpnjOV9eQoTOP0D71oqlurs+FwDemvDY9IZvoDFug+pcGFo4eeNVqbYFgXG8s3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754583185; c=relaxed/simple;
	bh=wKxbdf3bJHUDrVMrKH0dwPCN6+cv2HOD25QujXlia+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZrWQ8nLViJCjAhO09D++UHuKFkuo2A7/pnDVe9depo2WOUfgJyx793Ara1lKRZUK2pc+Di6T+MSBfe/4xZpwzY+RdIWbTjSqu+TTEY4AZhkTXmB9e4pbTQZhIX9INLPcoY4U86P5hyOjIK4rbIm9PTRJJJe87WyZsKKoOBB848=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=GjQdFfHU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="GjQdFfHU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Il8wTCNR/c/EaqCfGgOmBzh7XYcvfMhuxCwLn3gyTR4=; b=GjQdFfHU8g2kO3S2WjE5jX0Agg
	hL9LIXCMnYU5NbpqimrVher5+rOMy2xToLkxi/iqiv6EcwEQ3+5Ka1zOOQK1bmafZqoHChypKC0bS
	d7RxIaEuOLwY734DhY+pnCEMXLqmvRK+xmu6HS34HikqqfJxN8Ra0LyP5+h65dTYm8sCfDWhrpLiD
	Qx0QyFR9lbDOT+XgH6r2rSUzlr9a1zXN1188aAs+z4ugiqHeolZNel5fW0JQL14yT+yEFZHVcxLtC
	5BnJZVezNHmEpBmSbOdOzSZTv1J+ytS2vScPk/gCS+3xLwY/wxlHiuk5zPf/VwShxCpAnXv5gGsFH
	RnVP8TtGIOcSQIK+muitynsqADqhQ/x2z1tZvsydEBctEa800l10C9k10pQ0n93BP0dk3yHIINlLV
	rf4hZFkFGDmFRPlVpHAakuWgXJZoYuvtAkQRJiJqvKPIS8Lx5iNF7G4bcRJOIQK/W61a0sHyhV50I
	SXcU81L86QY0naUAHScqZlis;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uk3Eg-001ccr-1T;
	Thu, 07 Aug 2025 16:12:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5/9] smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with more detailed states
Date: Thu,  7 Aug 2025 18:12:15 +0200
Message-ID: <3019127a117e69bd710b41de60604cbda5f630fe.1754582143.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754582143.git.metze@samba.org>
References: <cover.1754582143.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The process of reaching a functional connection regresented by
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
---
 fs/smb/client/smbdirect.c                  | 44 +++++++++++++++++++---
 fs/smb/common/smbdirect/smbdirect_socket.h | 14 ++++++-
 2 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c628e91c328b..f95ecc153249 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -185,26 +185,39 @@ static int smbd_conn_upcall(
 
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
 
 	case RDMA_CM_EVENT_ESTABLISHED:
 		log_rdma_event(INFO, "connected event=%s\n", event_name);
-		sc->status = SMBDIRECT_SOCKET_CONNECTED;
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
+		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
 		wake_up_interruptible(&info->status_wait);
 		break;
 
@@ -212,7 +225,8 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_UNREACHABLE:
 	case RDMA_CM_EVENT_REJECTED:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
-		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
+		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
 		wake_up_interruptible(&info->status_wait);
 		break;
 
@@ -481,6 +495,12 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		info->negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
 		put_receive_buffer(info, response);
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING);
+		if (!info->negotiate_done) {
+			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
+		} else {
+			sc->status = SMBDIRECT_SOCKET_CONNECTED;
+		}
 		complete(&info->negotiate_completion);
 		return;
 
@@ -556,6 +576,7 @@ static struct rdma_cm_id *smbd_create_id(
 		struct smbd_connection *info,
 		struct sockaddr *dstaddr, int port)
 {
+	struct smbdirect_socket *sc = &info->socket;
 	struct rdma_cm_id *id;
 	int rc;
 	__be16 *sport;
@@ -578,6 +599,8 @@ static struct rdma_cm_id *smbd_create_id(
 	init_completion(&info->ri_done);
 	info->ri_rc = -ETIMEDOUT;
 
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING;
 	rc = rdma_resolve_addr(id, NULL, (struct sockaddr *)dstaddr,
 		RDMA_RESOLVE_TIMEOUT);
 	if (rc) {
@@ -598,6 +621,8 @@ static struct rdma_cm_id *smbd_create_id(
 	}
 
 	info->ri_rc = -ETIMEDOUT;
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING;
 	rc = rdma_resolve_route(id, RDMA_RESOLVE_TIMEOUT);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_resolve_route() failed %i\n", rc);
@@ -644,6 +669,9 @@ static int smbd_ia_open(
 	struct smbdirect_socket *sc = &info->socket;
 	int rc;
 
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED);
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED;
+
 	sc->rdma.cm_id = smbd_create_id(info, dstaddr, port);
 	if (IS_ERR(sc->rdma.cm_id)) {
 		rc = PTR_ERR(sc->rdma.cm_id);
@@ -1085,6 +1113,9 @@ static int smbd_negotiate(struct smbd_connection *info)
 	int rc;
 	struct smbdirect_recv_io *response = get_receive_buffer(info);
 
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
+
 	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
 	rc = smbd_post_recv(info, response);
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
@@ -1540,7 +1571,7 @@ static struct smbd_connection *_smbd_get_connection(
 	sc = &info->socket;
 	sp = &sc->parameters;
 
-	sc->status = SMBDIRECT_SOCKET_CONNECTING;
+	sc->status = SMBDIRECT_SOCKET_CREATED;
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
@@ -1652,6 +1683,9 @@ static struct smbd_connection *_smbd_get_connection(
 
 	init_waitqueue_head(&info->status_wait);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
+
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING;
 	rc = rdma_connect(sc->rdma.cm_id, &conn_param);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_connect() failed with %i\n", rc);
@@ -1660,10 +1694,10 @@ static struct smbd_connection *_smbd_get_connection(
 
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
index 3c4a8d627aa3..f43eabdd413d 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -8,9 +8,19 @@
 
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

