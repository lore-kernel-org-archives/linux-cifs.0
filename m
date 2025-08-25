Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4176F28D8D9
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155654; cv=none; b=b+sgjD2p1eSNd5qWt8BpQnEO296AqIuFt6ErSqVXd/uiTBU7zkmT9trKHEqFsbFrkUkxz2SHjYh7T4hi6jLCI5TdMFaT9D/uqC0CJ68Hd3Vgc/utg1cEHeXx9OeSSq2dHClL2CjtcdGHysY7L7TEgeZ+/fmIHxdjNpvV/TI7+qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155654; c=relaxed/simple;
	bh=+jtE240sUj0roChGPUkcUO0we45mRl4oa2yvwDuPM3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awy6PJ2h/k8sGXSoWVg31WNZ6JTIJaJancSOhNCTTYaGJMjvKpU+RkoO8Stg8TGciEcFGijE3ojMfvaPDHC2P26gFJm3GbllJGC0jvaBJ7kLMrvb87G4l0/5OheYJI730FNZjyutkqICxgs6uw61v4hMNO0MxPtb65yWhKPOQ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=AcQNij9k; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="AcQNij9k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=lqjxU/3aJTJJSGH5as6AqN2+PVTd+WspU+gfWeyY0LY=; b=AcQNij9k/qszkL1C3x6bMA+Xut
	ukoMXloddTNoXW1tBKXfvU28gD8d4VIPUlT6t0+7et9io3jKv5mOxKgUAB6ZBPbKwwOZlGAMmcVEY
	gifTRL1BFS/tFWwic52cUUgXcTbeVpgHsIEbglphE0U+xnEjCxupiD3+vHnK+kGk6Tlbrfq3CM6fr
	fUDEdUZ4XcejkwB0g1NB4RmSGh6wsiPRYdna4Cqmfm0ynSncVKORA7kZGyJnmS3hqKvHF/HJe8vkr
	5fC8aJqGoYhJHG7bJ0hSkQR89UUvo4aS3KxU+TVVIIfNVNnBG4I4Jyve2I8Vn09bwd6akyQqBeU0B
	SQvgpkELHW72OdpcjG4kzHQSRVmNifGxTuBK7fprnD3zeoZ33nw1h8Z/OY2vWD7iRkeQXducSMXQ1
	VTQk7Wxge+yHxc09craWno9A5Rpw8gb5pIWojzI7BEyMd6dzMGEHLlGeibJymQArCuMN/t0Fa/dgn
	vZmpEe/X1RRT2OueavJMQdI5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeJ3-000myh-1w;
	Mon, 25 Aug 2025 21:00:46 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 114/142] smb: server: implement correct keepalive and timeout handling for smbdirect
Date: Mon, 25 Aug 2025 22:41:15 +0200
Message-ID: <2fb4ec7ca90667983290d5262c30b3368d02ab2a.1756139607.git.metze@samba.org>
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

Now client and server behave in the same way and we can start to
share common functions.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 74 ++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index cca8e37a10ec..fb007963e281 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -36,6 +36,12 @@
 /* SMB_DIRECT negotiation timeout (for the server) in seconds */
 #define SMB_DIRECT_NEGOTIATE_TIMEOUT		5
 
+/* The timeout to wait for a keepalive message from peer in seconds */
+#define SMB_DIRECT_KEEPALIVE_SEND_INTERVAL	120
+
+/* The timeout to wait for a keepalive message from peer in seconds */
+#define SMB_DIRECT_KEEPALIVE_RECV_TIMEOUT	5
+
 /*
  * Default maximum number of RDMA read/write outstanding on this connection
  * This value is possibly decreased during QP creation on hardware limit
@@ -220,6 +226,7 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 	 */
 	disable_work(&sc->disconnect_work);
 	disable_work(&sc->recv_io.posted.refill_work);
+	disable_delayed_work(&sc->idle.timer_work);
 	disable_work(&sc->idle.immediate_work);
 
 	switch (sc->status) {
@@ -276,6 +283,32 @@ static void smb_direct_send_immediate_work(struct work_struct *work)
 	smb_direct_post_send_data(t, NULL, NULL, 0, 0);
 }
 
+static void smb_direct_idle_connection_timer(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, idle.timer_work.work);
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smb_direct_transport *t =
+		container_of(sc, struct smb_direct_transport, socket);
+
+	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
+		smb_direct_disconnect_rdma_connection(t);
+		return;
+	}
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+		return;
+
+	/*
+	 * Now use the keepalive timeout (instead of keepalive interval)
+	 * in order to wait for a response
+	 */
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+	mod_delayed_work(smb_direct_wq, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->keepalive_timeout_msec));
+	queue_work(smb_direct_wq, &sc->idle.immediate_work);
+}
+
 static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 {
 	struct smb_direct_transport *t;
@@ -301,6 +334,8 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	sp->max_fragmented_recv_size = smb_direct_max_fragmented_recv_size;
 	sp->max_recv_size = smb_direct_max_receive_size;
 	sp->max_read_write_size = smb_direct_max_read_write_size;
+	sp->keepalive_interval_msec = SMB_DIRECT_KEEPALIVE_SEND_INTERVAL * 1000;
+	sp->keepalive_timeout_msec = SMB_DIRECT_KEEPALIVE_RECV_TIMEOUT * 1000;
 
 	sc->rdma.cm_id = cm_id;
 	cm_id->context = t;
@@ -310,6 +345,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	INIT_WORK(&sc->recv_io.posted.refill_work,
 		  smb_direct_post_recv_credits);
 	INIT_WORK(&sc->idle.immediate_work, smb_direct_send_immediate_work);
+	INIT_DELAYED_WORK(&sc->idle.timer_work, smb_direct_idle_connection_timer);
 
 	conn = ksmbd_conn_alloc();
 	if (!conn)
@@ -344,6 +380,7 @@ static void free_transport(struct smb_direct_transport *t)
 	wake_up_all(&sc->send_io.pending.wait_queue);
 
 	disable_work_sync(&sc->recv_io.posted.refill_work);
+	disable_delayed_work_sync(&sc->idle.timer_work);
 	disable_work_sync(&sc->idle.immediate_work);
 
 	if (sc->ib.qp) {
@@ -492,6 +529,14 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	ib_dma_sync_single_for_cpu(wc->qp->device, recvmsg->sge.addr,
 				   recvmsg->sge.length, DMA_FROM_DEVICE);
 
+	/*
+	 * Reset timer to the keepalive interval in
+	 * order to trigger our next keepalive message.
+	 */
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
+	mod_delayed_work(smb_direct_wq, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->keepalive_interval_msec));
+
 	switch (sc->recv_io.expected) {
 	case SMBDIRECT_EXPECT_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
@@ -828,6 +873,24 @@ static int manage_credits_prior_sending(struct smb_direct_transport *t)
 	return new_credits;
 }
 
+static int manage_keep_alive_before_sending(struct smb_direct_transport *t)
+{
+	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+
+	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
+		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_SENT;
+		/*
+		 * Now use the keepalive timeout (instead of keepalive interval)
+		 * in order to wait for a response
+		 */
+		mod_delayed_work(smb_direct_wq, &sc->idle.timer_work,
+				 msecs_to_jiffies(sp->keepalive_timeout_msec));
+		return 1;
+	}
+	return 0;
+}
+
 static int smb_direct_post_send(struct smb_direct_transport *t,
 				struct ib_send_wr *wr)
 {
@@ -976,6 +1039,9 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(t));
 
 	packet->flags = 0;
+	if (manage_keep_alive_before_sending(t))
+		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
+
 	packet->reserved = 0;
 	if (!size)
 		packet->data_offset = 0;
@@ -1632,6 +1698,14 @@ static int smb_direct_accept_client(struct smb_direct_transport *t)
 	conn_param.rnr_retry_count = SMB_DIRECT_CM_RNR_RETRY;
 	conn_param.flow_control = 0;
 
+	/*
+	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
+	 * so that the timer will cause a disconnect.
+	 */
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+	mod_delayed_work(smb_direct_wq, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->negotiate_timeout_msec));
+
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
 	sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING;
 	ret = rdma_accept(sc->rdma.cm_id, &conn_param);
-- 
2.43.0

