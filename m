Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B7DDAB
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154949; cv=none; b=rXbVcm7C5SK2M4FEL9dpWfiZbirNSYTOu8kHXSmot1mPTAkJEAk3xHRFlN+SUE8EtPjuodZLeaMWgDUTvrCl5DsJLz6/V725AjVDyNi76QrPj12LQ7xOnJTupaBt9sGBroIPGv7mMt0mDQza9V+oM4dPXTRpAFHXtWeoMim9u/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154949; c=relaxed/simple;
	bh=Lqj4QPRnCtSqFb+xGTJyU47Vc7rXMLwn6fb+S5ry0ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glFZ7RTAQps559NV6wW4xZks+WK1UXjo+f9kU2vRtA8p3z8jq/lXgY5dGZp/wEBDUBw6Fg+sVJ+sFsSgwZYuxW9EJA92LiEi5UylWhbrM6YamnlqsPHsGLwOr7Zd712Yygo67uveVMBAg0vZXzu0r0eROea/rTb8tBDjiB1WsDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XZ+rc3d+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XZ+rc3d+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=pJ79xbc4WZ7mqYEznHD8Pr1giGvza9I7WhZe9hCzhVQ=; b=XZ+rc3d+6/vhOpxhwCIadoigYN
	muX8ePsjq5/V4DW6kUBuw1EvuLOkSYeJOVcBvQipY55jQ9kbSxIQGAEnGzhF0gP8rM8Tg9NJVpATf
	m2iAq+qdH8XLJg1AaEb5jY2e3/PnHpvoMMNddzdQOhA0vWcEZQrCE/oablkE1tqVE79TOOKybLfJs
	obpL23vJ8CbclLYEdEBpjdUBRwkIr6jiBWQR1diIKqeUp6tLSxZ1bU7pnhRwG+kO8z+r0JyGFRx3I
	e0rcjs5FmzJ/qCIKObB6oGtMXWU7Vh+NjazPC3gr/xSxUY5NfX0e5jeC9LQTNBf6Ia4yS5tplhO6O
	GKacyHy/6glm0SxZ6FRRYFi9I1jOLmsF9yT8n9eM5a4tX2vpi1Ox90TksQgaOv4pJHLAwBCUIsQiC
	uiXCyB7zXMIwHsc1QtKKkeZ7OwM3yPEFw2z2XpHLROLxgXeqzMpOllqZpEuKIXC8YLyBa2TQkjaLv
	YLXHaZZJRxslUXzLcn9QY/I0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe7k-000kgV-0t;
	Mon, 25 Aug 2025 20:49:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 044/142] smb: client: make use of smbdirect_socket.idle.{keepalive,immediate_work,timer_work}
Date: Mon, 25 Aug 2025 22:40:05 +0200
Message-ID: <e9a91f95c92d491ac778a03f198ee0857109d6ea.1756139607.git.metze@samba.org>
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

This will allow client and server to use the common structures in order
to share common functions later.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 59 ++++++++++++++++++++-------------------
 fs/smb/client/smbdirect.h |  9 ------
 2 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index cd00b4801795..450e43f1fe39 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -173,8 +173,8 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	disable_work(&sc->disconnect_work);
 	disable_work(&sc->recv_io.posted.refill_work);
 	disable_work(&info->mr_recovery_work);
-	disable_work(&info->send_immediate_work);
-	disable_delayed_work(&info->idle_timer_work);
+	disable_work(&sc->idle.immediate_work);
+	disable_delayed_work(&sc->idle.timer_work);
 
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
@@ -544,7 +544,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 	if (atomic_read(&sc->recv_io.credits.count) <
 		sc->recv_io.credits.target - 1) {
 		log_keep_alive(INFO, "schedule send of an empty message\n");
-		queue_work(info->workqueue, &info->send_immediate_work);
+		queue_work(info->workqueue, &sc->idle.immediate_work);
 	}
 }
 
@@ -585,8 +585,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	 * Reset timer to the keepalive interval in
 	 * order to trigger our next keepalive message.
 	 */
-	info->keep_alive_requested = KEEP_ALIVE_NONE;
-	mod_delayed_work(info->workqueue, &info->idle_timer_work,
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
+	mod_delayed_work(info->workqueue, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->keepalive_interval_msec));
 
 	switch (sc->recv_io.expected) {
@@ -652,7 +652,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (le16_to_cpu(data_transfer->flags) &
 				SMBDIRECT_FLAG_RESPONSE_REQUESTED) {
 			log_keep_alive(INFO, "schedule send of immediate response\n");
-			queue_work(info->workqueue, &info->send_immediate_work);
+			queue_work(info->workqueue, &sc->idle.immediate_work);
 		}
 
 		/*
@@ -954,13 +954,13 @@ static int manage_keep_alive_before_sending(struct smbd_connection *info)
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 
-	if (info->keep_alive_requested == KEEP_ALIVE_PENDING) {
-		info->keep_alive_requested = KEEP_ALIVE_SENT;
+	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
+		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_SENT;
 		/*
 		 * Now use the keepalive timeout (instead of keepalive interval)
 		 * in order to wait for a response
 		 */
-		mod_delayed_work(info->workqueue, &info->idle_timer_work,
+		mod_delayed_work(info->workqueue, &sc->idle.timer_work,
 				 msecs_to_jiffies(sp->keepalive_timeout_msec));
 		return 1;
 	}
@@ -1425,9 +1425,10 @@ static void destroy_receive_buffers(struct smbd_connection *info)
 
 static void send_immediate_empty_message(struct work_struct *work)
 {
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, idle.immediate_work);
 	struct smbd_connection *info =
-		container_of(work, struct smbd_connection, send_immediate_work);
-	struct smbdirect_socket *sc = &info->socket;
+		container_of(sc, struct smbd_connection, socket);
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return;
@@ -1439,16 +1440,16 @@ static void send_immediate_empty_message(struct work_struct *work)
 /* Implement idle connection timer [MS-SMBD] 3.1.6.2 */
 static void idle_connection_timer(struct work_struct *work)
 {
-	struct smbd_connection *info = container_of(
-					work, struct smbd_connection,
-					idle_timer_work.work);
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, idle.timer_work.work);
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbd_connection *info =
+		container_of(sc, struct smbd_connection, socket);
 
-	if (info->keep_alive_requested != KEEP_ALIVE_NONE) {
+	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
 		log_keep_alive(ERR,
-			"error status info->keep_alive_requested=%d\n",
-			info->keep_alive_requested);
+			"error status sc->idle.keepalive=%d\n",
+			sc->idle.keepalive);
 		smbd_disconnect_rdma_connection(info);
 		return;
 	}
@@ -1460,11 +1461,11 @@ static void idle_connection_timer(struct work_struct *work)
 	 * Now use the keepalive timeout (instead of keepalive interval)
 	 * in order to wait for a response
 	 */
-	info->keep_alive_requested = KEEP_ALIVE_PENDING;
-	mod_delayed_work(info->workqueue, &info->idle_timer_work,
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+	mod_delayed_work(info->workqueue, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->keepalive_timeout_msec));
 	log_keep_alive(INFO, "schedule send of empty idle message\n");
-	queue_work(info->workqueue, &info->send_immediate_work);
+	queue_work(info->workqueue, &sc->idle.immediate_work);
 }
 
 /*
@@ -1506,9 +1507,9 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	sc->ib.qp = NULL;
 
 	log_rdma_event(INFO, "cancelling idle timer\n");
-	disable_delayed_work_sync(&info->idle_timer_work);
+	disable_delayed_work_sync(&sc->idle.timer_work);
 	log_rdma_event(INFO, "cancelling send immediate work\n");
-	disable_work_sync(&info->send_immediate_work);
+	disable_work_sync(&sc->idle.immediate_work);
 
 	/* It's not possible for upper layer to get to reassembly */
 	log_rdma_event(INFO, "drain the reassembly queue\n");
@@ -1852,14 +1853,14 @@ static struct smbd_connection *_smbd_get_connection(
 		goto allocate_cache_failed;
 	}
 
-	INIT_WORK(&info->send_immediate_work, send_immediate_empty_message);
-	INIT_DELAYED_WORK(&info->idle_timer_work, idle_connection_timer);
+	INIT_WORK(&sc->idle.immediate_work, send_immediate_empty_message);
+	INIT_DELAYED_WORK(&sc->idle.timer_work, idle_connection_timer);
 	/*
-	 * start with the negotiate timeout and KEEP_ALIVE_PENDING
+	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
 	 * so that the timer will cause a disconnect.
 	 */
-	info->keep_alive_requested = KEEP_ALIVE_PENDING;
-	mod_delayed_work(info->workqueue, &info->idle_timer_work,
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+	mod_delayed_work(info->workqueue, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->negotiate_timeout_msec));
 
 	init_waitqueue_head(&info->wait_post_send);
@@ -1887,7 +1888,7 @@ static struct smbd_connection *_smbd_get_connection(
 	return NULL;
 
 negotiation_failed:
-	disable_delayed_work_sync(&info->idle_timer_work);
+	disable_delayed_work_sync(&sc->idle.timer_work);
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 	rdma_disconnect(sc->rdma.cm_id);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index d51ec4d01be7..0197a9da294e 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -27,12 +27,6 @@ extern int smbd_max_send_size;
 extern int smbd_send_credit_target;
 extern int smbd_receive_credit_max;
 
-enum keep_alive_status {
-	KEEP_ALIVE_NONE,
-	KEEP_ALIVE_PENDING,
-	KEEP_ALIVE_SENT,
-};
-
 /*
  * The context for the SMBDirect transport
  * Everything related to the transport is here. It has several logical parts
@@ -46,7 +40,6 @@ struct smbd_connection {
 	struct smbdirect_socket socket;
 
 	/* dynamic connection parameters defined in [MS-SMBD] 3.1.1.1 */
-	enum keep_alive_status keep_alive_requested;
 	int protocol;
 
 	/* Memory registrations */
@@ -74,8 +67,6 @@ struct smbd_connection {
 	wait_queue_head_t wait_post_send;
 
 	struct workqueue_struct *workqueue;
-	struct work_struct send_immediate_work;
-	struct delayed_work idle_timer_work;
 
 	/* for debug purposes */
 	unsigned int count_get_receive_buffer;
-- 
2.43.0

