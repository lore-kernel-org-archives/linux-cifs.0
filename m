Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618C6223DFB
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154929; cv=none; b=o4xisoVU4wfXRYStWr655elIgTxrDuBp0dtfQugb73DnV2p/smXC1Anibk3IS7/zQteCAXbD4TNSXEzZeDgpHHhnb+zWuMm5l7VyEnDKFFxXseeQVlltOzB6n2k14nY432sjjQmP0gxZmxElPI0lXkpHWuUi2qQrKwFQ8KwaFiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154929; c=relaxed/simple;
	bh=1AZt5taPaKwX5P6seLY20is6gCUdq/2BLYS4+L7UVxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmjHQUweDorekia+ZRFKtLQgBJUci/YwhieIFWFmVAOf6DbMY2mwY7EwDFLNAeez6Xi2GwtE5LTCbRacKVF/jwcUsoWoo9E8mAyD3wsZFrBSHgZC2Jntl+kS91I6a1dKG1TXa99EIAI+QfrcCTe/eBlaRzJTzm7xK9OU6X2ky54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ePEY0wXh; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ePEY0wXh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Ll2EyGXJpIsL8eDVf1I7bIRzxO08DW/rRg0YiaZu8fY=; b=ePEY0wXh3wELuBXaZ2g6Eu6Z33
	jn6iQghaIRBLpuSp5+yGrGkbmCsGlM/AC0W4fi1QHJSuSHWzqCqiLZR7Yh29cO96rpCfHzJkqaT1T
	502BFJcMs2a08n4GSwddHh05XwH2nuC153GPB6zDBGrhRS7Fr+V9G/ENTQr9Ssf+ucv03OfQIjJbs
	pludTC5QZX1Rl6xTugdR7bSKCydfQRH/yYXAQI6Yj762PAlansvxffWnm3QoMOMjnmQuqAcRlE5AN
	iQop0RHFgHXpxiswB4g1IYPD93gZN57UZRk2L9zQVwHJXD8FuW6hMS8k5yD2+BBxUkQHZ7/sQ5RjO
	yyllbQ0YgsoefoZKDAxSckjEzR1X6vs+HTj73u/VXpCaFjDm9XljcYUqwqwdCtyt70cI8p3y2sfUA
	sAacMKdIVe1vsWnmVObOLZ3oUmp/NEZpLy5nX/UgLYSbSP3ITmVUYXndFtLQtyKaxRhUMdUqcfT4T
	suqTdb8rNVP48xoNZulb+de1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe7Q-000kcK-1h;
	Mon, 25 Aug 2025 20:48:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 042/142] smb: client: send empty packets via send_immediate_work
Date: Mon, 25 Aug 2025 22:40:03 +0200
Message-ID: <ba39beed93ac155a3911e3c401064d98942a5e2b.1756139607.git.metze@samba.org>
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

This is what the server already does and it makes
refactoring for common structures and functions much easier.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 25 +++++++++++++++++++++----
 fs/smb/client/smbdirect.h |  1 +
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ab1f5050e616..b7c5f30fa271 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -173,6 +173,7 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	disable_work(&sc->disconnect_work);
 	disable_work(&sc->recv_io.posted.refill_work);
 	disable_work(&info->mr_recovery_work);
+	disable_work(&info->send_immediate_work);
 	disable_delayed_work(&info->idle_timer_work);
 
 	switch (sc->status) {
@@ -542,8 +543,8 @@ static void smbd_post_send_credits(struct work_struct *work)
 	/* Promptly send an immediate packet as defined in [MS-SMBD] 3.1.1.1 */
 	if (atomic_read(&sc->recv_io.credits.count) <
 		sc->recv_io.credits.target - 1) {
-		log_keep_alive(INFO, "send an empty message\n");
-		smbd_post_send_empty(info);
+		log_keep_alive(INFO, "schedule send of an empty message\n");
+		queue_work(info->workqueue, &info->send_immediate_work);
 	}
 }
 
@@ -1409,6 +1410,19 @@ static void destroy_receive_buffers(struct smbd_connection *info)
 		mempool_free(response, sc->recv_io.mem.pool);
 }
 
+static void send_immediate_empty_message(struct work_struct *work)
+{
+	struct smbd_connection *info =
+		container_of(work, struct smbd_connection, send_immediate_work);
+	struct smbdirect_socket *sc = &info->socket;
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+		return;
+
+	log_keep_alive(INFO, "send an empty message\n");
+	smbd_post_send_empty(info);
+}
+
 /* Implement idle connection timer [MS-SMBD] 3.1.6.2 */
 static void idle_connection_timer(struct work_struct *work)
 {
@@ -1426,8 +1440,8 @@ static void idle_connection_timer(struct work_struct *work)
 		return;
 	}
 
-	log_keep_alive(INFO, "about to send an empty idle message\n");
-	smbd_post_send_empty(info);
+	log_keep_alive(INFO, "schedule send of empty idle message\n");
+	queue_work(info->workqueue, &info->send_immediate_work);
 
 	/* Setup the next idle timeout work */
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
@@ -1474,6 +1488,8 @@ void smbd_destroy(struct TCP_Server_Info *server)
 
 	log_rdma_event(INFO, "cancelling idle timer\n");
 	disable_delayed_work_sync(&info->idle_timer_work);
+	log_rdma_event(INFO, "cancelling send immediate work\n");
+	disable_work_sync(&info->send_immediate_work);
 
 	/* It's not possible for upper layer to get to reassembly */
 	log_rdma_event(INFO, "drain the reassembly queue\n");
@@ -1817,6 +1833,7 @@ static struct smbd_connection *_smbd_get_connection(
 		goto allocate_cache_failed;
 	}
 
+	INIT_WORK(&info->send_immediate_work, send_immediate_empty_message);
 	INIT_DELAYED_WORK(&info->idle_timer_work, idle_connection_timer);
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
 		msecs_to_jiffies(sp->keepalive_interval_msec));
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index f5f4188ad7cd..d51ec4d01be7 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -74,6 +74,7 @@ struct smbd_connection {
 	wait_queue_head_t wait_post_send;
 
 	struct workqueue_struct *workqueue;
+	struct work_struct send_immediate_work;
 	struct delayed_work idle_timer_work;
 
 	/* for debug purposes */
-- 
2.43.0

