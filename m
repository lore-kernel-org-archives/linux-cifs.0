Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606E1223DFB
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154941; cv=none; b=i72IuKwLLaxCARfebRkY2HC1zWqARAgg1s2LmpyQNwDQvZGNnI1n/ZRvozeuoZu4kzpemGdpb2gL5WgyRmJA7M6ce4TAmfyjfCBJKnRsjQpmQMnPKhF80SeOco8g9EBANSzxhs2AhpDTOV3xI6LoHRlzaQNlgonVNrmJbdz1wfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154941; c=relaxed/simple;
	bh=07sQU3yWF5pu3OnOMwFEE7KtnDnLkkawdjfl5nT4P5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyeYBOSP0QdnWcukkSRFcH1BJ8zrzn6ApNgJ0fk63rGy4DBlzMzLrwDUjUgHBKJF7QKQ1SuybRtKSKtK4ecG0ARJkop2ct28HmYrOKRuIrnc6jx/mmQq4ub+dToDScxbW2/188z0aW0NVkMuk2mA3wHKEe8HegHkanmc9C3pC9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=mZ+1PmJV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="mZ+1PmJV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Cs+QedzzYWtz47fz9DAkrcvk/8HE0kMTEqn4JVOViD0=; b=mZ+1PmJV4lcayOJQ3gyQgoQUP+
	Q2vpEOCo43/BX8zKPtZG14zWskzs19DSPCJM+W+D89ybBGQUp8x+u93lUMvkYyVlMkSLxgblbFYCw
	YaJ3GgMrdMUdoxkfog0lVoTkvQeNbLS0D+C1xhY4VYKlxXo6SmCzHCmWVW4N874lbdRxc4aIDBvd5
	PpRr+Brf6NBL4XVgHdrMHQGSDdjd4b7GsP+GkLihUbpFgEqJ8n/kBb+dwLdFF845hFaVQ5nP9IevH
	faPSorlIgO5L7q1hMQNGo3s8MZIf+ZUxmKX1FTRmGLYLu6lRX7/6xzbKKzGJyA87ZkMG6sorK1MF3
	uyokDio/xLh7FSgLuKQgd78D21/8tAlT8z2jsW7b8NPHvqrrEbY385uGOdW8azPCzMz7cl3b9kC1I
	OIaNt6vaGclZAtGCnQqVgUuZd6a/WQbcitRbszisYKI9Ku/3ntY2Q4R3Rn+RR7zHB/P+OdO7jMCyb
	v59N594Bj01wQ3s9odbdwXXo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe7a-000keH-1W;
	Mon, 25 Aug 2025 20:48:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 043/142] smb: client: fix smbdirect keep alive handling to match the documentation
Date: Mon, 25 Aug 2025 22:40:04 +0200
Message-ID: <3d85965be951e12f9b2f474ada64121870eb8e9a.1756139607.git.metze@samba.org>
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

We setup the first timer with the negotiate timeout and set
KEEP_ALIVE_PENDING, so that the expired timer disconnects.

On every incoming message we need to reset the timer to the keepalive
interval (120s).

On SMBDIRECT_FLAG_RESPONSE_REQUESTED we need to schedule a response
instead of setting KEEP_ALIVE_PENDING. Doing both would mean
we would also set SMBDIRECT_FLAG_RESPONSE_REQUESTED in that
response. If both ends would do that we'd play ping pong in
a busy loop.

If we move to KEEP_ALIVE_SENT and send the keepalive request
with SMBDIRECT_FLAG_RESPONSE_REQUESTED, we need to setup the
timer with keepalive timeout (5s) in order to disconnect
if no incoming message reset the timer.

The fired timer sets KEEP_ALIVE_PENDING and also
setup timer with keepalive timeout (5s) in order to disconnect
if no incoming message reset the timer.
We do that before queueing the send_immediate_work
and have that timer in case we didn't reach the send code
that typically sets the timer to keepalive timeout.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 52 ++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b7c5f30fa271..cd00b4801795 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -581,6 +581,14 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		response->sge.length,
 		DMA_FROM_DEVICE);
 
+	/*
+	 * Reset timer to the keepalive interval in
+	 * order to trigger our next keepalive message.
+	 */
+	info->keep_alive_requested = KEEP_ALIVE_NONE;
+	mod_delayed_work(info->workqueue, &info->idle_timer_work,
+			 msecs_to_jiffies(sp->keepalive_interval_msec));
+
 	switch (sc->recv_io.expected) {
 	/* SMBD negotiation response */
 	case SMBDIRECT_EXPECT_NEGOTIATE_REP:
@@ -640,11 +648,11 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			     le32_to_cpu(data_transfer->data_length),
 			     le32_to_cpu(data_transfer->remaining_data_length));
 
-		/* Send a KEEP_ALIVE response right away if requested */
-		info->keep_alive_requested = KEEP_ALIVE_NONE;
+		/* Send an immediate response right away if requested */
 		if (le16_to_cpu(data_transfer->flags) &
 				SMBDIRECT_FLAG_RESPONSE_REQUESTED) {
-			info->keep_alive_requested = KEEP_ALIVE_PENDING;
+			log_keep_alive(INFO, "schedule send of immediate response\n");
+			queue_work(info->workqueue, &info->send_immediate_work);
 		}
 
 		/*
@@ -943,8 +951,17 @@ static int manage_credits_prior_sending(struct smbd_connection *info)
  */
 static int manage_keep_alive_before_sending(struct smbd_connection *info)
 {
+	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+
 	if (info->keep_alive_requested == KEEP_ALIVE_PENDING) {
 		info->keep_alive_requested = KEEP_ALIVE_SENT;
+		/*
+		 * Now use the keepalive timeout (instead of keepalive interval)
+		 * in order to wait for a response
+		 */
+		mod_delayed_work(info->workqueue, &info->idle_timer_work,
+				 msecs_to_jiffies(sp->keepalive_timeout_msec));
 		return 1;
 	}
 	return 0;
@@ -955,7 +972,6 @@ static int smbd_post_send(struct smbd_connection *info,
 		struct smbdirect_send_io *request)
 {
 	struct smbdirect_socket *sc = &info->socket;
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_send_wr send_wr;
 	int rc, i;
 
@@ -984,10 +1000,7 @@ static int smbd_post_send(struct smbd_connection *info,
 		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
 		smbd_disconnect_rdma_connection(info);
 		rc = -EAGAIN;
-	} else
-		/* Reset timer for idle connection after packet is sent */
-		mod_delayed_work(info->workqueue, &info->idle_timer_work,
-			msecs_to_jiffies(sp->keepalive_interval_msec));
+	}
 
 	return rc;
 }
@@ -1440,12 +1453,18 @@ static void idle_connection_timer(struct work_struct *work)
 		return;
 	}
 
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+		return;
+
+	/*
+	 * Now use the keepalive timeout (instead of keepalive interval)
+	 * in order to wait for a response
+	 */
+	info->keep_alive_requested = KEEP_ALIVE_PENDING;
+	mod_delayed_work(info->workqueue, &info->idle_timer_work,
+			 msecs_to_jiffies(sp->keepalive_timeout_msec));
 	log_keep_alive(INFO, "schedule send of empty idle message\n");
 	queue_work(info->workqueue, &info->send_immediate_work);
-
-	/* Setup the next idle timeout work */
-	queue_delayed_work(info->workqueue, &info->idle_timer_work,
-			msecs_to_jiffies(sp->keepalive_interval_msec));
 }
 
 /*
@@ -1835,8 +1854,13 @@ static struct smbd_connection *_smbd_get_connection(
 
 	INIT_WORK(&info->send_immediate_work, send_immediate_empty_message);
 	INIT_DELAYED_WORK(&info->idle_timer_work, idle_connection_timer);
-	queue_delayed_work(info->workqueue, &info->idle_timer_work,
-		msecs_to_jiffies(sp->keepalive_interval_msec));
+	/*
+	 * start with the negotiate timeout and KEEP_ALIVE_PENDING
+	 * so that the timer will cause a disconnect.
+	 */
+	info->keep_alive_requested = KEEP_ALIVE_PENDING;
+	mod_delayed_work(info->workqueue, &info->idle_timer_work,
+			 msecs_to_jiffies(sp->negotiate_timeout_msec));
 
 	init_waitqueue_head(&info->wait_post_send);
 
-- 
2.43.0

