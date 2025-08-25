Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18781283FCB
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155116; cv=none; b=HdegtVK2Ml5lgopbFTCfMOV5wxcMYIGxJZamBWhnIs6wyXMQHD3KmBnUuxc14mmSuPJ1PB50yZL0vsBtA8rozPbNh/Md+XLuR5Re4/9M8brB1crmW33fmfvc2Ce5Tif1NfYjxkQrGueAfEcjBU+fbsWETdCp/inwa77Ze8IhAzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155116; c=relaxed/simple;
	bh=kyMYyNG1hq261wqmhZEZZv6w+J2Yj00uXVtmf+x+dXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEwcTCmXOGBYxVkfd8JGB8loynI5JmjfCc2+0jMIfhFSFGapExLxx1DaZuhAx80tfwTbeqs7J4GlhrNBQAM63lM0Ns7/fFd+NdTYsJsi/oc649D3q3ePxhl3Q/bR07yE0WsFixgcEkniHkBWVyQTOi+eAOl6yDjMgWwzqiXBbZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MDxneH8m; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MDxneH8m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/HR5x7MktGy+L/g6062T3212v3sAh7LXMr93IS0QTHg=; b=MDxneH8moYgMwhhFYjze7oUM26
	0AP0VmZj48I0aliJkI9FsU2GjRZJKYxOTgt7pitHkWC+mvjrH7zCf23G8Ouszok1pnitumS74XVyu
	ct+SqqyuswMup8kODuUZXpIv+ZmUt8kixUkxr5P3qFQFLLd01Y7UpWlYClcffyrqVnTu7uhl6nBxK
	E59qpT8JvYxOTTWcoBZ7LySdcM/gtOnQVtXyTvRWfEaBkeNwVn/5h2JCak7fvYStMGzJ6FgS91HyT
	s6Tp2nPuCK9kVBYsdqsqgwmnBuZeAfyge8H01SN8QYGT8SZIfRnN9U0qjRK/Pix4J4qsowLg4mwFh
	bIcekcKERcGuF3Wmctts2gvk6I3aJ3puREGrY8cJpV8wTpDaXekZRTJkI2t3SEDX+E5Gk/kncBOtR
	9t3jGV7dv2HguZQ9va1DVPOUntNwdrk9FU/2Xaqf0pQfMxADtW2QjAajJaqx3KxYBadI5MDAYb+ZC
	hs4byaA9nYV86HuMfLZDYj8R;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeAS-000lEe-02;
	Mon, 25 Aug 2025 20:51:52 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 060/142] smb: client: pass struct smbdirect_socket to smbd_disconnect_rdma_connection()
Date: Mon, 25 Aug 2025 22:40:21 +0200
Message-ID: <881e6efd76281714885243df129dd70ba550f021.1756139607.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 41 +++++++++++++--------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 4db70c2c369a..31b9b398b6e5 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -214,10 +214,8 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	}
 }
 
-static void smbd_disconnect_rdma_connection(struct smbd_connection *info)
+static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
-
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
 
@@ -363,6 +361,7 @@ static void
 smbd_qp_async_error_upcall(struct ib_event *event, void *context)
 {
 	struct smbd_connection *info = context;
+	struct smbdirect_socket *sc = &info->socket;
 
 	log_rdma_event(ERR, "%s on device %s info %p\n",
 		ib_event_msg(event->event), event->device->name, info);
@@ -370,7 +369,7 @@ smbd_qp_async_error_upcall(struct ib_event *event, void *context)
 	switch (event->event) {
 	case IB_EVENT_CQ_ERR:
 	case IB_EVENT_QP_FATAL:
-		smbd_disconnect_rdma_connection(info);
+		smbd_disconnect_rdma_connection(sc);
 		break;
 
 	default:
@@ -395,8 +394,6 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_send_io *request =
 		container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
 	struct smbdirect_socket *sc = request->socket;
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 
 	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
 		request, ib_wc_status_msg(wc->status));
@@ -412,7 +409,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
 				ib_wc_status_msg(wc->status), wc->opcode);
 		mempool_free(request, sc->send_io.mem.pool);
-		smbd_disconnect_rdma_connection(info);
+		smbd_disconnect_rdma_connection(sc);
 		return;
 	}
 
@@ -552,8 +549,6 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
 	struct smbdirect_socket *sc = response->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 	u16 old_recv_credit_target;
 	int data_length = 0;
 	bool negotiate_done = false;
@@ -678,7 +673,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
 error:
 	put_receive_buffer(sc, response);
-	smbd_disconnect_rdma_connection(info);
+	smbd_disconnect_rdma_connection(sc);
 }
 
 static struct rdma_cm_id *smbd_create_id(
@@ -903,7 +898,7 @@ static int smbd_post_send_negotiate_req(struct smbd_connection *info)
 	ib_dma_unmap_single(sc->ib.dev, request->sge[0].addr,
 		request->sge[0].length, DMA_TO_DEVICE);
 
-	smbd_disconnect_rdma_connection(info);
+	smbd_disconnect_rdma_connection(sc);
 
 dma_mapping_failed:
 	mempool_free(request, sc->send_io.mem.pool);
@@ -995,7 +990,7 @@ static int smbd_post_send(struct smbd_connection *info,
 	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
 	if (rc) {
 		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-		smbd_disconnect_rdma_connection(info);
+		smbd_disconnect_rdma_connection(sc);
 		rc = -EAGAIN;
 	}
 
@@ -1212,7 +1207,7 @@ static int smbd_post_recv(
 		ib_dma_unmap_single(sc->ib.dev, response->sge.addr,
 				    response->sge.length, DMA_FROM_DEVICE);
 		response->sge.length = 0;
-		smbd_disconnect_rdma_connection(info);
+		smbd_disconnect_rdma_connection(sc);
 		log_rdma_recv(ERR, "ib_post_recv failed rc=%d\n", rc);
 	}
 
@@ -1417,14 +1412,12 @@ static void idle_connection_timer(struct work_struct *work)
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, idle.timer_work.work);
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 
 	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
 		log_keep_alive(ERR,
 			"error status sc->idle.keepalive=%d\n",
 			sc->idle.keepalive);
-		smbd_disconnect_rdma_connection(info);
+		smbd_disconnect_rdma_connection(sc);
 		return;
 	}
 
@@ -2156,12 +2149,10 @@ static void register_mr_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_mr_io *mr =
 		container_of(wc->wr_cqe, struct smbdirect_mr_io, cqe);
 	struct smbdirect_socket *sc = mr->socket;
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 
 	if (wc->status) {
 		log_rdma_mr(ERR, "status=%d\n", wc->status);
-		smbd_disconnect_rdma_connection(info);
+		smbd_disconnect_rdma_connection(sc);
 	}
 }
 
@@ -2179,8 +2170,6 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, mr_io.recovery_work);
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 	struct smbdirect_mr_io *smbdirect_mr;
 	int rc;
 
@@ -2193,7 +2182,7 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 				log_rdma_mr(ERR,
 					"ib_dereg_mr failed rc=%x\n",
 					rc);
-				smbd_disconnect_rdma_connection(info);
+				smbd_disconnect_rdma_connection(sc);
 				continue;
 			}
 
@@ -2204,7 +2193,7 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 				log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
 					    sc->mr_io.type,
 					    sp->max_frmr_depth);
-				smbd_disconnect_rdma_connection(info);
+				smbd_disconnect_rdma_connection(sc);
 				continue;
 			}
 		} else
@@ -2460,7 +2449,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	if (atomic_dec_and_test(&sc->mr_io.used.count))
 		wake_up(&sc->mr_io.cleanup.wait_queue);
 
-	smbd_disconnect_rdma_connection(info);
+	smbd_disconnect_rdma_connection(sc);
 
 	return NULL;
 }
@@ -2490,8 +2479,6 @@ int smbd_deregister_mr(struct smbdirect_mr_io *smbdirect_mr)
 {
 	struct ib_send_wr *wr;
 	struct smbdirect_socket *sc = smbdirect_mr->socket;
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 	int rc = 0;
 
 	if (smbdirect_mr->need_invalidate) {
@@ -2508,7 +2495,7 @@ int smbd_deregister_mr(struct smbdirect_mr_io *smbdirect_mr)
 		rc = ib_post_send(sc->ib.qp, wr, NULL);
 		if (rc) {
 			log_rdma_mr(ERR, "ib_post_send failed rc=%x\n", rc);
-			smbd_disconnect_rdma_connection(info);
+			smbd_disconnect_rdma_connection(sc);
 			goto done;
 		}
 		wait_for_completion(&smbdirect_mr->invalidate_done);
-- 
2.43.0

