Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F2B275AED
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754666933; cv=none; b=Ev4SpZ/m025IxOh76VJ10nJsDnhY+XbGEdAK6o8ii+eRUCu5+Rm2HzSwlR5eb+Trb8WMWM//W9Gdhi1Sd31jg9gtqNSbAFt/zZzu5G18xxOu3SnpIUz3+ipbp/H3QbLtsWaFZvTnUiuwWGNdt0s08hSQhAvNybWzjFXMIjn2NTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754666933; c=relaxed/simple;
	bh=oPy8xnfeCXcXbyf/jTD25wRXOpK62uK8gWEuUE9DR1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE6ua45weWLQyA56P8KZA4sKf3sTB5BnSflb3a8CfzSvgbf5+ns3GSHlzYpbD88tgfOjwakIIwYP5F5kZz0CottFMVe9QZ0cBkpTT5uPocN3hIe8VSe2/8Mfm0Hyymg1wX5/l83SL/h9+ehJ1fSOidMUTwSXOBAl/6IE5nBHN1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=EkF/cLVe; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EkF/cLVe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=eXbsRj8mKE/T03oWx7kMbqx7HXKNiF6SvCybERyXI+k=; b=EkF/cLVet45WFQmEQSxzkjP3V5
	U4dMTyMCoxjQ87OzOmnhIp96mlTbzqCj+qMQFgNvT/AWMkgnHD+F2PPmek27zQglYBZ+rIH+/IURv
	tNulFPS6ddCP+w7XIvfDUvF6xhRRjyp2Y3F8MJkWB9wDBd8lIt6PwnEDFBAw8j4Tajwaveqbx/dWb
	n3/4VX0K8qtYrH2jDfR8MZvoppb1swIR/xHPsy7ACS8XKox6t6p+KKluxtGfaEZBVURAYAF5CLTvL
	kiteSwl8Eza62DTvjTRrQBxc4KHKGDcEAIwxsNhUayiS398l5OqRU6PZj9X/9AWlwmnm0R/dvrFC2
	TkdttqmdZWViHm9PnmIvIs/Buj8AFDVtg8iEyCNw6FfTluvnFEHjtf4d/Sq0C66JuCKg+kPVCq8jS
	WXpAtxZASCl99iz92lr7oyUf0gV4EQE9oGZx1k8GBpKi5LBr+95cmXvorLTvF9hUOkKS5UhW1cKq9
	6lqCdV8igyGGbXRvE7TaFZTT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukP1T-001pQD-1c;
	Fri, 08 Aug 2025 15:28:47 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 5/9] smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with more detailed states
Date: Fri,  8 Aug 2025 17:28:03 +0200
Message-ID: <1d5975ad17ca39ea17d73f157edeeae7814db5d7.1754666549.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754666549.git.metze@samba.org>
References: <cover.1754666549.git.metze@samba.org>
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
 fs/smb/client/smbdirect.c                  | 44 +++++++++++++++++++---
 fs/smb/common/smbdirect/smbdirect_socket.h | 14 ++++++-
 2 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c628e91c328b..fd26c6202f09 100644
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
+		if (!info->negotiate_done)
+			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
+		else
+			sc->status = SMBDIRECT_SOCKET_CONNECTED;
+
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

