Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8D3279918
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094016; cv=none; b=FcPdunx3dRjCxjxhbzIOe/kOgeDecLw2hvDmtujbXOS8ck+hamio5/X8su+IYJw+pyhAFG21QKeLiTzNwrrd/L6yrxvQ16eMO8J49LRukWPNZLScnKDyHAHUnn8mR43mWq9gISeBZq1RxQBhJSPfM8387YZqZneLnHVAyQBoNEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094016; c=relaxed/simple;
	bh=t+ujjz6Fuj46vTjm4kZHXORc7B06qAKWdpKRePsheBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlaZ/IQdiTUJ5Cs5HnNAjMnQDir0FnISTIoWquvSwuRXMF0F/kWECLX7oZVmIo9Zzx+bniQYnQj3WG3gMajwJrXsuEk4/JIIq5TZU+ovbqGBY61aJK+8AK5O3RdSBDP3wVjo//YonkUiMurOeDMfgWJ61WvZpDwgRABS6UlkThk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Y0bY6FC4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Y0bY6FC4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=46RAVuvVSG1urJlIf2OQiqLC5amlFyTbYy/IzUOhwGM=; b=Y0bY6FC4SLfpT2hc+jsD3u7jGN
	9HobkHLi8QV1R5Aqym+GulhG+B71up9nHdYaf64sMQ1JhAvhif6Gi/lDwf2s7U0k58UktEPWaNTGY
	NYH8xX/T6qsEu7XdNTgX5hCQyFLDgAi3ixO838X1yseV30FfNBDPsssGYzKuRQdU6w9GoTSZQAnwd
	GBP6Nfmfp/uJLnqbWmA1UYBvvC5bopCAlL7vwvfJVDTlMJp/CaHD3wg5kbfsTfv/d30AFQrtf+HAk
	E/ad7rVNsrwXtSupVnfkRuseHLxaYgmKe3atZ4WhlH+qYdFmOkj4l8IYHoyk0iN77bBytVJWWhMVJ
	Ber0Nv7I8lVX09BnRZ5Grej+X/fsmQVBh+tjYF1SWNNxFw4JnhcfSPDLaZ0JB0z9sNYHhBAjY9wCR
	dhK3kfqAQx76jdIfQT4K3T05/G1pV5kf4KTrMmMO9a5RCY1Jo/LpCeza6aBWqt0Q4Eq4I7sP8EZ0X
	xkjpkKTJb8wA8OyUGs2Ua+hw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxO7-00FddH-2r;
	Tue, 25 Nov 2025 18:03:40 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 066/145] smb: client: make use of smbdirect_socket_schedule_cleanup()
Date: Tue, 25 Nov 2025 18:55:12 +0100
Message-ID: <8af4e38994d04bbdc76d0a6740a542abe11847a9.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This removes smbd_disconnect_rdma_connection() which is basically
the same as smbdirect_socket_schedule_cleanup().
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
 fs/smb/client/smbdirect.c | 97 ++++++---------------------------------
 1 file changed, 14 insertions(+), 83 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 1ad34066fbcb..b501060d6e3c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/folio_queue.h>
-#define __SMBDIRECT_SOCKET_DISCONNECT(__sc) smbd_disconnect_rdma_connection(__sc)
 #include "../common/smbdirect/smbdirect_pdu.h"
 #include "smbdirect.h"
 #include "cifs_debug.h"
@@ -146,8 +145,6 @@ module_param(smbd_logging_level, uint, 0644);
 MODULE_PARM_DESC(smbd_logging_level,
 	"Logging level for SMBD transport, 0 (default): error, 1: info");
 
-static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc);
-
 /*
  * This is a temporary solution until all code
  * is moved to smbdirect_all_c_files.c and we
@@ -216,73 +213,6 @@ do {									\
 #define log_rdma_mr(level, fmt, args...) \
 		log_rdma(level, LOG_RDMA_MR, fmt, ##args)
 
-static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
-{
-	if (sc->first_error == 0)
-		sc->first_error = -ECONNABORTED;
-
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
-		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		break;
-
-	case SMBDIRECT_SOCKET_CONNECTED:
-		sc->status = SMBDIRECT_SOCKET_ERROR;
-		break;
-	}
-
-	/*
-	 * Wake up all waiters in all wait queues
-	 * in order to notice the broken connection.
-	 */
-	smbdirect_socket_wake_up_all(sc);
-
-	queue_work(sc->workqueue, &sc->disconnect_work);
-}
-
 /* Upcall from RDMA CM */
 static int smbd_conn_upcall(
 		struct rdma_cm_id *id, struct rdma_cm_event *event)
@@ -450,7 +380,7 @@ smbd_qp_async_error_upcall(struct ib_event *event, void *context)
 	switch (event->event) {
 	case IB_EVENT_CQ_ERR:
 	case IB_EVENT_QP_FATAL:
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 		break;
 
 	default:
@@ -492,7 +422,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
 				ib_wc_status_msg(wc->status), wc->opcode);
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 		return;
 	}
 
@@ -679,7 +609,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			negotiate_done = false;
 		if (!negotiate_done) {
 			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-			smbd_disconnect_rdma_connection(sc);
+			smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 		} else {
 			sc->status = SMBDIRECT_SOCKET_CONNECTED;
 			wake_up(&sc->status_wait);
@@ -776,7 +706,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
 error:
 	put_receive_buffer(sc, response);
-	smbd_disconnect_rdma_connection(sc);
+	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 }
 
 static struct rdma_cm_id *smbd_create_id(
@@ -991,7 +921,7 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	ib_dma_unmap_single(sc->ib.dev, request->sge[0].addr,
 		request->sge[0].length, DMA_TO_DEVICE);
 
-	smbd_disconnect_rdma_connection(sc);
+	smbdirect_socket_schedule_cleanup(sc, rc);
 
 dma_mapping_failed:
 	mempool_free(request, sc->send_io.mem.pool);
@@ -1080,7 +1010,7 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
 	if (rc) {
 		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_socket_schedule_cleanup(sc, rc);
 		rc = -EAGAIN;
 	}
 
@@ -1321,7 +1251,7 @@ static int smbd_post_recv(
 		ib_dma_unmap_single(sc->ib.dev, response->sge.addr,
 				    response->sge.length, DMA_FROM_DEVICE);
 		response->sge.length = 0;
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_socket_schedule_cleanup(sc, rc);
 		log_rdma_recv(ERR, "ib_post_recv failed rc=%d\n", rc);
 	}
 
@@ -1534,7 +1464,7 @@ static void idle_connection_timer(struct work_struct *work)
 		log_keep_alive(ERR,
 			"error status sc->idle.keepalive=%d\n",
 			sc->idle.keepalive);
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_socket_schedule_cleanup(sc, -ETIMEDOUT);
 		return;
 	}
 
@@ -2293,7 +2223,7 @@ static void register_mr_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	if (wc->status) {
 		log_rdma_mr(ERR, "status=%d\n", wc->status);
-		smbd_disconnect_rdma_connection(sc);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 	}
 }
 
@@ -2323,7 +2253,7 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 				log_rdma_mr(ERR,
 					"ib_dereg_mr failed rc=%x\n",
 					rc);
-				smbd_disconnect_rdma_connection(sc);
+				smbdirect_socket_schedule_cleanup(sc, rc);
 				continue;
 			}
 
@@ -2331,10 +2261,11 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 				sc->ib.pd, sc->mr_io.type,
 				sp->max_frmr_depth);
 			if (IS_ERR(smbdirect_mr->mr)) {
+				rc = PTR_ERR(smbdirect_mr->mr);
 				log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
 					    sc->mr_io.type,
 					    sp->max_frmr_depth);
-				smbd_disconnect_rdma_connection(sc);
+				smbdirect_socket_schedule_cleanup(sc, rc);
 				continue;
 			}
 		} else
@@ -2670,7 +2601,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	if (atomic_dec_and_test(&sc->mr_io.used.count))
 		wake_up(&sc->mr_io.cleanup.wait_queue);
 
-	smbd_disconnect_rdma_connection(sc);
+	smbdirect_socket_schedule_cleanup(sc, rc);
 
 	/*
 	 * get_mr() gave us a reference
@@ -2745,7 +2676,7 @@ void smbd_deregister_mr(struct smbdirect_mr_io *mr)
 		if (rc) {
 			log_rdma_mr(ERR, "ib_post_send failed rc=%x\n", rc);
 			smbd_mr_disable_locked(mr);
-			smbd_disconnect_rdma_connection(sc);
+			smbdirect_socket_schedule_cleanup(sc, rc);
 			goto done;
 		}
 		wait_for_completion(&mr->invalidate_done);
-- 
2.43.0

