Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B13186E2D
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754671746; cv=none; b=ux+E/TvIrj0KyZx5tVOgF7EtTt0Nzk1Ag2PCsFuNbQM372Uqd7KIEsMZpqz9fhgV+eD0mTAV7ZBIgwyNWj9nDzVzCwhEKtXqL8wCNKMrcCrFdSng27BuY53gpI1aQGZPWMTm416UTBUHS12lrF6HTZ3SR/5vlT7yzjfdGCfcDuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754671746; c=relaxed/simple;
	bh=IRnAe9YK6hPlf9Q5jygiFuAiGGdfSQpfUoHynkSxVoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZ56kEs3GqqAd5ngUplkypINYsdVnvR9v3bDdfQdYBrYMeyS258TvML+IgGLXR4amahggy82Dw3+vpSNYWus8tR/BX3mFJ0oPFMuWuNm834WeNZ46tAOFsfVH6Z+oLFweOHFUYm/N1A3hw2fyB8sk5jXt44KwD3+tsF8ZPdOXzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MxWmBEqA; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MxWmBEqA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=J05HwXspHObg9ug+KKfnAql8P2sJhwMdv0ciAHmlPaM=; b=MxWmBEqA7CFDzG0iRreKSMPraz
	KbiCfZnNAgPaBKwkh7H3Mqck8WfNyc11W5gsp6DWZxkBKnQxdgTHuO1eIkYX89+LjNo3gkZAQ0Y81
	083OCcgKBkKVmB+rRtE7+mSHJ+4YilFiAlKalXHg9xOSdqx6pfI2kBvP+/soicDxB3Jq37my/RKUK
	ooYTivLwiTX6MXWWW3k2W5EgSGY2XJPhvSGIMccLCRwIv7t5pknR7jUJdI6zUULTsgQ5vaalUq3cC
	wt4WdhOe7UCA9JwZA8N0o349gXqdSz/c9zgqRyqpKRcfjYnc1IXN8erUqwNpPgu2EbwTPk48z4uxT
	SvCnc9DQqYa17XTSmE3290gSt6HMtI9EJajPJfR5Nzz4T5XupGKAZ/l8NHUZjWDcsMxO7TXHI5u85
	xYWMA3251eqPE3XdtzIIxnu5q/KAYokN3DTZ6+Of5zTRlbh3e38HQURcxn47ESxnK9z5ybv6umcAH
	8V0C8jSoj95K/hwtnVFhffIg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukQH7-001qRD-1V;
	Fri, 08 Aug 2025 16:49:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 5/9] smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with more detailed states
Date: Fri,  8 Aug 2025 18:48:13 +0200
Message-ID: <499154755d3d2d29d7092daffd16b01bc657974c.1754671444.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754671444.git.metze@samba.org>
References: <cover.1754671444.git.metze@samba.org>
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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c                  | 73 ++++++++++++++++++++--
 fs/smb/common/smbdirect/smbdirect_socket.h | 14 ++++-
 2 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c628e91c328b..1337d35a22f9 100644
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
 
@@ -185,26 +212,39 @@ static int smbd_conn_upcall(
 
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
 
@@ -212,7 +252,8 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_UNREACHABLE:
 	case RDMA_CM_EVENT_REJECTED:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
-		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
+		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
 		wake_up_interruptible(&info->status_wait);
 		break;
 
@@ -481,6 +522,12 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
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
 
@@ -556,6 +603,7 @@ static struct rdma_cm_id *smbd_create_id(
 		struct smbd_connection *info,
 		struct sockaddr *dstaddr, int port)
 {
+	struct smbdirect_socket *sc = &info->socket;
 	struct rdma_cm_id *id;
 	int rc;
 	__be16 *sport;
@@ -578,6 +626,8 @@ static struct rdma_cm_id *smbd_create_id(
 	init_completion(&info->ri_done);
 	info->ri_rc = -ETIMEDOUT;
 
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING;
 	rc = rdma_resolve_addr(id, NULL, (struct sockaddr *)dstaddr,
 		RDMA_RESOLVE_TIMEOUT);
 	if (rc) {
@@ -598,6 +648,8 @@ static struct rdma_cm_id *smbd_create_id(
 	}
 
 	info->ri_rc = -ETIMEDOUT;
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING;
 	rc = rdma_resolve_route(id, RDMA_RESOLVE_TIMEOUT);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_resolve_route() failed %i\n", rc);
@@ -644,6 +696,9 @@ static int smbd_ia_open(
 	struct smbdirect_socket *sc = &info->socket;
 	int rc;
 
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED);
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED;
+
 	sc->rdma.cm_id = smbd_create_id(info, dstaddr, port);
 	if (IS_ERR(sc->rdma.cm_id)) {
 		rc = PTR_ERR(sc->rdma.cm_id);
@@ -1085,6 +1140,9 @@ static int smbd_negotiate(struct smbd_connection *info)
 	int rc;
 	struct smbdirect_recv_io *response = get_receive_buffer(info);
 
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
+
 	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
 	rc = smbd_post_recv(info, response);
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
@@ -1540,7 +1598,7 @@ static struct smbd_connection *_smbd_get_connection(
 	sc = &info->socket;
 	sp = &sc->parameters;
 
-	sc->status = SMBDIRECT_SOCKET_CONNECTING;
+	sc->status = SMBDIRECT_SOCKET_CREATED;
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
@@ -1652,6 +1710,9 @@ static struct smbd_connection *_smbd_get_connection(
 
 	init_waitqueue_head(&info->status_wait);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
+
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
+	sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING;
 	rc = rdma_connect(sc->rdma.cm_id, &conn_param);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_connect() failed with %i\n", rc);
@@ -1660,10 +1721,10 @@ static struct smbd_connection *_smbd_get_connection(
 
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

