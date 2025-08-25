Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958CD2AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154903; cv=none; b=szattrcfTYehbqyWmX4M1FNAkp/klNvjH+aR+T9PIOAKtBu/I9f48v6Vnoh+GQtgqNQyx8eGOcp2sA9a62WkR3WRsZ7fcCGOq9NqPgvqUvR482AEeQGjLlO4J8cUgK+etLKw3bccItEm6jvMG++lN3zNddPlRvNSXYmhSgGf7Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154903; c=relaxed/simple;
	bh=mPPJytqFXfORQQdNlJBb66YUTGq7I7eVJAkaLAi0FPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=of2m2BUCyy1umOfW36Er+RCmtBaqFKuRa2rC0u11j9GgI2o88iQswtfSagbi8yaJv7ujJYQuJvg+oBQSa1NHnPE2cItRa3pYv4Lx0GbfbiAdsAFeBtbL6pjk8Z0BvSlWHyv37CcycGlj9lQSvV97wtvCnjx5v70NZonQ+bxcLYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pu5HZVdp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pu5HZVdp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=iQ7dPcLn9KMzc14gXzguNMAH82MrCskw7TCNH4Z0UiY=; b=pu5HZVdpmQOFQIhexl4DO5yX7G
	ARhnsaXgJK7vwCIxgYjTtniIFsQFiG8LmkaSs3Y3qll5z5yFaNbIPFzXTxm06IG4r2evWyHDthxYk
	3nZAAFRuwPIuWTSoA73hZhVEiuCCSxIEhh/mbv7BQgYavuDWTjRmqqKjMMxP46fXx0+Od7Dr0e61k
	qFNcSD1+bHr00wAmlYpA//weLpiRFObCaWbWRWy6oyIv0DMkrAlZvESOAXyzIhmjyG8WHL1R1YoxS
	iOhsodnDdPvv4c6ivt2ntA3BhkitZ30buEMoWwVdWYi28M779G/sMsVYSAsEf93RTe1QKxUYeQe3q
	HJtteWSBkAg6zntTvVzvYbYaEybuWyCCN9rvVmbl/SRV9JHaz/YEmQWfuJuSc9GvPJb+OrwnOl3Tt
	3UUq33sgPyR21E0HTG4nD//SSXLi2T1zfCJMOQA8tJRtS/v7cSeXu3UPzv9xgpov3JbBWkGoAx0YD
	fexqd54Tl94bR8+QIdvEWwky;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe6z-000kVe-25;
	Mon, 25 Aug 2025 20:48:17 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 039/142] smb: client: make use of smbdirect_socket_parameters.{resolve_{addr,route},rdma_connect,negotiate}_timeout_msec
Date: Mon, 25 Aug 2025 22:40:00 +0200
Message-ID: <c291b3020791c599cb944cc1e3e0aea5541a3d07.1756139607.git.metze@samba.org>
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

This will make future changes to these values much saner.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index a1ca18dbb758..80d5ca0f10c2 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -57,6 +57,9 @@ static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
 /* SMBD negotiation timeout in seconds */
 #define SMBD_NEGOTIATE_TIMEOUT	120
 
+/* The timeout to wait for a keepalive message from peer in seconds */
+#define KEEPALIVE_RECV_TIMEOUT 5
+
 /* SMBD minimum receive size and fragmented sized defined in [MS-SMBD] */
 #define SMBD_MIN_RECEIVE_SIZE		128
 #define SMBD_MIN_FRAGMENTED_SIZE	131072
@@ -677,6 +680,7 @@ static struct rdma_cm_id *smbd_create_id(
 		struct sockaddr *dstaddr, int port)
 {
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct rdma_cm_id *id;
 	int rc;
 	__be16 *sport;
@@ -699,7 +703,7 @@ static struct rdma_cm_id *smbd_create_id(
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED);
 	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING;
 	rc = rdma_resolve_addr(id, NULL, (struct sockaddr *)dstaddr,
-		RDMA_RESOLVE_TIMEOUT);
+		sp->resolve_addr_timeout_msec);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_resolve_addr() failed %i\n", rc);
 		goto out;
@@ -707,7 +711,7 @@ static struct rdma_cm_id *smbd_create_id(
 	rc = wait_event_interruptible_timeout(
 		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING,
-		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
+		msecs_to_jiffies(sp->resolve_addr_timeout_msec));
 	/* e.g. if interrupted returns -ERESTARTSYS */
 	if (rc < 0) {
 		log_rdma_event(ERR, "rdma_resolve_addr timeout rc: %i\n", rc);
@@ -726,7 +730,7 @@ static struct rdma_cm_id *smbd_create_id(
 
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED);
 	sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING;
-	rc = rdma_resolve_route(id, RDMA_RESOLVE_TIMEOUT);
+	rc = rdma_resolve_route(id, sp->resolve_route_timeout_msec);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_resolve_route() failed %i\n", rc);
 		goto out;
@@ -734,7 +738,7 @@ static struct rdma_cm_id *smbd_create_id(
 	rc = wait_event_interruptible_timeout(
 		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING,
-		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
+		msecs_to_jiffies(sp->resolve_route_timeout_msec));
 	/* e.g. if interrupted returns -ERESTARTSYS */
 	if (rc < 0)  {
 		log_rdma_event(ERR, "rdma_resolve_addr timeout rc: %i\n", rc);
@@ -1222,6 +1226,7 @@ static int smbd_post_recv(
 static int smbd_negotiate(struct smbd_connection *info)
 {
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int rc;
 	struct smbdirect_recv_io *response = get_receive_buffer(info);
 
@@ -1243,7 +1248,7 @@ static int smbd_negotiate(struct smbd_connection *info)
 	rc = wait_event_interruptible_timeout(
 		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
-		secs_to_jiffies(SMBD_NEGOTIATE_TIMEOUT));
+		msecs_to_jiffies(sp->negotiate_timeout_msec));
 	log_rdma_event(INFO, "wait_event_interruptible_timeout rc=%d\n", rc);
 
 	if (sc->status == SMBDIRECT_SOCKET_CONNECTED)
@@ -1672,12 +1677,17 @@ static struct smbd_connection *_smbd_get_connection(
 
 	INIT_WORK(&sc->disconnect_work, smbd_disconnect_rdma_work);
 
+	sp->resolve_addr_timeout_msec = RDMA_RESOLVE_TIMEOUT;
+	sp->resolve_route_timeout_msec = RDMA_RESOLVE_TIMEOUT;
+	sp->rdma_connect_timeout_msec = RDMA_RESOLVE_TIMEOUT;
+	sp->negotiate_timeout_msec = SMBD_NEGOTIATE_TIMEOUT * 1000;
 	sp->recv_credit_max = smbd_receive_credit_max;
 	sp->send_credit_target = smbd_send_credit_target;
 	sp->max_send_size = smbd_max_send_size;
 	sp->max_fragmented_recv_size = smbd_max_fragmented_recv_size;
 	sp->max_recv_size = smbd_max_receive_size;
 	sp->keepalive_interval_msec = smbd_keep_alive_interval * 1000;
+	sp->keepalive_timeout_msec = KEEPALIVE_RECV_TIMEOUT * 1000;
 
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
@@ -1792,7 +1802,7 @@ static struct smbd_connection *_smbd_get_connection(
 	wait_event_interruptible_timeout(
 		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
-		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
+		msecs_to_jiffies(sp->rdma_connect_timeout_msec));
 
 	if (sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED) {
 		log_rdma_event(ERR, "rdma_connect failed port=%d\n", port);
-- 
2.43.0

