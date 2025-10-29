Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAAB3314CE
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744515; cv=none; b=d6sT7WW0q2cn1WWZgVvvmhPzfnRe9YZCuOBQubexYSPR2rHq49XXWp4e2OkKb/4hdVqtk18acbsKAqEdHiG7Dbe8K9r4ZhS1HU00sLUBBS8Sb7YQgSeUmjZwLd4VGdxbzvpVxBDKI+sgYCztcqVEP0kPpqQmyEqQ/geVAGyEyIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744515; c=relaxed/simple;
	bh=dQD/J4XD6dDMVxd1sfXOQlpnAACP/L9Rpneis2+pfhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjZKVzeQyRNEqBRDuasccUfhn4G8Gh2YBwEH49OatmZ3Jukx0hj2/lp7rkK79xV+hgWcWjHEIH/esH2nKeSSSCrC4QgfAXX4O5lY2pD4pkQitj/Xx18CVOdRTjpHarAKauLfRlu4+icy5SGYvm03TnNM4/XU/sljKtaxSJTq9HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yCeny92Y; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yCeny92Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=stQETD4AoCdOa3jvF2qFWSZymTawxm5Y5vDZ8YAkMoI=; b=yCeny92Y7SjOUnio5Avwo6pRT4
	NKD/8m8jaDLuLiPE3tBrtohItJhYvAatlqifKAY8QrfMNkv3iYi+/+97TDddeIVheUAM/TafdWX0y
	WS76ZDTClnpzEGmX8ccZ+vg1SjXucy/ducn4YLwQCdp1hA1KCCmK3Mgu4YBHYjK2YkKjV2bQaiqhp
	37HgB+nslm8RzoTlIPgustWTD1VmFmOA37r6goTX9eMtTYa532IMbjoWtVKBSU5sYud9SajZdVP8i
	/gg7W3KBH440bP9a7F26Tjh9gRRQvuyF1xoPcDBNTewFKfuzatOf+TvXugLruc7KVfj3SEKRHetnO
	nYBjb0THFu81ws+rBu4KwSphj4+nvhUtlIKKpUImP+Lf/Bx1nUWbE4V+nvvS7pm5hTmyhbaz4ng/2
	rATs563Rl8sTq4P8K0S0BWRqWDGoE2UYQZwNbvna6g3qwJZJQgeHU3tROXtbD/SANQHb16H/ISsEf
	1ecXL0Lc1A3z3VwC9JZlEXup;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6E1-00Bc69-1P;
	Wed, 29 Oct 2025 13:28:29 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 061/127] smb: client: make use of smbdirect_connection_schedule_disconnect()
Date: Wed, 29 Oct 2025 14:20:39 +0100
Message-ID: <720656ed2a9768b557560db9e5bd38a01a04f0ca.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This removes smbd_disconnect_rdma_connection() which is basically
the same as smbdirect_connection_schedule_disconnect().
And we pass more useful errors than -ECONNABORTED if we have them.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 91 ++++++---------------------------------
 1 file changed, 14 insertions(+), 77 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 137fad17e5a1..8b98ef1d41e1 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -213,70 +213,6 @@ do {									\
 #define log_rdma_mr(level, fmt, args...) \
 		log_rdma(level, LOG_RDMA_MR, fmt, ##args)
 
-static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
-{
-	/*
-	 * make sure other work (than disconnect_work) is
-	 * not queued again but here we don't block and avoid
-	 * disable[_delayed]_work_sync()
-	 */
-	disable_work(&sc->recv_io.posted.refill_work);
-	disable_work(&sc->mr_io.recovery_work);
-	disable_work(&sc->idle.immediate_work);
-	disable_delayed_work(&sc->idle.timer_work);
-
-	if (sc->first_error == 0)
-		sc->first_error = -ECONNABORTED;
-
-	switch (sc->status) {
-	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
-	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
-	case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
-	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
-	case SMBDIRECT_SOCKET_ERROR:
-	case SMBDIRECT_SOCKET_DISCONNECTING:
-	case SMBDIRECT_SOCKET_DISCONNECTED:
-	case SMBDIRECT_SOCKET_DESTROYED:
-		/*
-		 * Keep the current error status
-		 */
-		break;
-
-	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
-	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
-		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
-		break;
-
-	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
-	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
-		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
-		break;
-
-	case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
-	case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
-		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
-		break;
-
-	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
-	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
-		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-		break;
-
-	case SMBDIRECT_SOCKET_CREATED:
-	case SMBDIRECT_SOCKET_CONNECTED:
-		sc->status = SMBDIRECT_SOCKET_ERROR;
-		break;
-	}
-
-	/*
-	 * Wake up all waiters in all wait queues
-	 * in order to notice the broken connection.
-	 */
-	smbdirect_connection_wake_up_all(sc);
-
-	queue_work(sc->workqueue, &sc->disconnect_work);
-}
-
 /* Upcall from RDMA CM */
 static int smbd_conn_upcall(
 		struct rdma_cm_id *id, struct rdma_cm_event *event)
@@ -444,7 +380,7 @@ smbd_qp_async_error_upcall(struct ib_event *event, void *context)
 	switch (event->event) {
 	case IB_EVENT_CQ_ERR:
 	case IB_EVENT_QP_FATAL:
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 		break;
 
 	default:
@@ -486,7 +422,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
 				ib_wc_status_msg(wc->status), wc->opcode);
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 		return;
 	}
 
@@ -672,7 +608,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING);
 		if (!negotiate_done) {
 			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-			smbd_disconnect_rdma_connection(sc);
+			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 		} else {
 			sc->status = SMBDIRECT_SOCKET_CONNECTED;
 			wake_up(&sc->status_wait);
@@ -769,7 +705,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
 error:
 	put_receive_buffer(sc, response);
-	smbd_disconnect_rdma_connection(sc);
+	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 }
 
 static struct rdma_cm_id *smbd_create_id(
@@ -984,7 +920,7 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	ib_dma_unmap_single(sc->ib.dev, request->sge[0].addr,
 		request->sge[0].length, DMA_TO_DEVICE);
 
-	smbd_disconnect_rdma_connection(sc);
+	smbdirect_connection_schedule_disconnect(sc, rc);
 
 dma_mapping_failed:
 	mempool_free(request, sc->send_io.mem.pool);
@@ -1073,7 +1009,7 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
 	if (rc) {
 		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, rc);
 		rc = -EAGAIN;
 	}
 
@@ -1314,7 +1250,7 @@ static int smbd_post_recv(
 		ib_dma_unmap_single(sc->ib.dev, response->sge.addr,
 				    response->sge.length, DMA_FROM_DEVICE);
 		response->sge.length = 0;
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, rc);
 		log_rdma_recv(ERR, "ib_post_recv failed rc=%d\n", rc);
 	}
 
@@ -1525,7 +1461,7 @@ static void idle_connection_timer(struct work_struct *work)
 		log_keep_alive(ERR,
 			"error status sc->idle.keepalive=%d\n",
 			sc->idle.keepalive);
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, -ETIMEDOUT);
 		return;
 	}
 
@@ -2284,7 +2220,7 @@ static void register_mr_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	if (wc->status) {
 		log_rdma_mr(ERR, "status=%d\n", wc->status);
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 	}
 }
 
@@ -2314,7 +2250,7 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 				log_rdma_mr(ERR,
 					"ib_dereg_mr failed rc=%x\n",
 					rc);
-				smbd_disconnect_rdma_connection(sc);
+				smbdirect_connection_schedule_disconnect(sc, rc);
 				continue;
 			}
 
@@ -2322,10 +2258,11 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 				sc->ib.pd, sc->mr_io.type,
 				sp->max_frmr_depth);
 			if (IS_ERR(smbdirect_mr->mr)) {
+				rc = PTR_ERR(smbdirect_mr->mr);
 				log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
 					    sc->mr_io.type,
 					    sp->max_frmr_depth);
-				smbd_disconnect_rdma_connection(sc);
+				smbdirect_connection_schedule_disconnect(sc, rc);
 				continue;
 			}
 		} else
@@ -2661,7 +2598,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	if (atomic_dec_and_test(&sc->mr_io.used.count))
 		wake_up(&sc->mr_io.cleanup.wait_queue);
 
-	smbd_disconnect_rdma_connection(sc);
+	smbdirect_connection_schedule_disconnect(sc, rc);
 
 	/*
 	 * get_mr() gave us a reference
@@ -2736,7 +2673,7 @@ void smbd_deregister_mr(struct smbdirect_mr_io *mr)
 		if (rc) {
 			log_rdma_mr(ERR, "ib_post_send failed rc=%x\n", rc);
 			smbd_mr_disable_locked(mr);
-			smbd_disconnect_rdma_connection(sc);
+			smbdirect_connection_schedule_disconnect(sc, rc);
 			goto done;
 		}
 		wait_for_completion(&mr->invalidate_done);
-- 
2.43.0

