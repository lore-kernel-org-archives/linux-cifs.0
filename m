Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F612DFF28
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744731; cv=none; b=lMZO0oO246FfIpA8CuWrNxBEWZKqdQseGt9UiJ6zOgpj/R50P0teqvC1cIq27x9miN/qCyTuGm1hstL98SIhGBE3iIiWCjkPWwTSMyyVa1jxPUNJP1wXo9jIppMbMSsVCBqNQBjXwvhWlOfUCXLzlZbb0xwVuqLQOmkDDFIJHdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744731; c=relaxed/simple;
	bh=WtDyzjM1bmY8KC0bfz75b7GDCDJF6RCNrvx/biaQmak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhFZh1dOpTZ6I0Q0hqgaWTB1oj7Z4LpUxMTWdlXWnBAF32DFzdDJptWAAx+5eCH/O4bSQ7RnAIYE+ujnv43Fztpm20h+D4d08kIx/HNUKK7x8BDgcpSm+RVdoFG9uQXMF6fKreSDObQZd4st+nLVxwFlEP3TiT3kd/nGjiS5oRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1Kb5vNkL; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1Kb5vNkL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ESoI4Dakx8fVTtWtkJ63+b27Op2dd+jya3FENM81ye4=; b=1Kb5vNkL9bGsVbdSMhmJVUX4Yw
	7ySykql7CSluap0MN9M4nPoaihmY3XXgcdZ71UDD2A33Z8YcdXojNfuVAwWqnAzV92P2wO67FQHk/
	azMPdJpvKf37YmbNmrL48aV336LDQz6cUiMcj1VUmunwSgnEi7hlVcU7HO8nn8E7JpBHpkOxeKtEN
	8XOjYWksG8vAehnhuoYRDUhI+eYNOssNb6SkWctuN/sQXjqOyiekzwutVkPwTVQ4USsU1K7OH2OXZ
	VRYQ77XwX/EarhsIFvYvtNTM64z4q8ikPtWeeMvd62wlAKV96TYU6X7Wvw10UtggbTfOBOfoZGYDx
	pIS5LXDkZgPGwPXv4/AOFZ+lKAuFJ3aaRCKZ/4HSQU5+8CXFC0Btgs+Zqkro03RgV/aICPd29PZM4
	Ddz9+hZN2WE+4OgR6f370UkPvhCu0ZumMs+XNC7Bz2yp0HZLbh2e/Bsw0I3VS6Bxyrw3nc9eo6Ena
	FmG5ZxNNHGPBZMbrxsnUWaca;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6HW-00Bcgr-2C;
	Wed, 29 Oct 2025 13:32:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 096/127] smb: server: make use of smbdirect_connection_schedule_disconnect()
Date: Wed, 29 Oct 2025 14:21:14 +0100
Message-ID: <d4eb5ec3482a398df5413562407f64d13454cc04.1761742839.git.metze@samba.org>
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

This removes smb_direct_disconnect_rdma_connection() which is basically
the same as smbdirect_connection_schedule_disconnect().
And we pass more useful errors than -ECONNABORTED if we have them.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 88 +++++-----------------------------
 1 file changed, 12 insertions(+), 76 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index a649194ab6c8..89db1cc921d2 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -281,70 +281,6 @@ static struct smbdirect_recv_io *get_first_reassembly(struct smbdirect_socket *s
 		return NULL;
 }
 
-static void
-smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
-{
-	/*
-	 * make sure other work (than disconnect_work) is
-	 * not queued again but here we don't block and avoid
-	 * disable[_delayed]_work_sync()
-	 */
-	disable_work(&sc->recv_io.posted.refill_work);
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
 static void smb_direct_send_immediate_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -363,7 +299,7 @@ static void smb_direct_idle_connection_timer(struct work_struct *work)
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 
 	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
-		smb_direct_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, -ETIMEDOUT);
 		return;
 	}
 
@@ -612,7 +548,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			pr_err("Recv error. status='%s (%d)' opcode=%d\n",
 			       ib_wc_status_msg(wc->status), wc->status,
 			       wc->opcode);
-			smb_direct_disconnect_rdma_connection(sc);
+			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 		}
 		return;
 	}
@@ -636,7 +572,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	case SMBDIRECT_EXPECT_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
 			put_recvmsg(sc, recvmsg);
-			smb_direct_disconnect_rdma_connection(sc);
+			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 			return;
 		}
 		sc->recv_io.reassembly.full_packet_received = true;
@@ -654,7 +590,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (wc->byte_len <
 		    offsetof(struct smbdirect_data_transfer, padding)) {
 			put_recvmsg(sc, recvmsg);
-			smb_direct_disconnect_rdma_connection(sc);
+			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 			return;
 		}
 
@@ -664,7 +600,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (wc->byte_len < data_offset ||
 		    wc->byte_len < (u64)data_offset + data_length) {
 			put_recvmsg(sc, recvmsg);
-			smb_direct_disconnect_rdma_connection(sc);
+			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 			return;
 		}
 		if (remaining_data_length > sp->max_fragmented_recv_size ||
@@ -672,7 +608,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		    (u64)remaining_data_length + (u64)data_length >
 		    (u64)sp->max_fragmented_recv_size) {
 			put_recvmsg(sc, recvmsg);
-			smb_direct_disconnect_rdma_connection(sc);
+			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 			return;
 		}
 
@@ -727,7 +663,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	 */
 	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
 	put_recvmsg(sc, recvmsg);
-	smb_direct_disconnect_rdma_connection(sc);
+	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 }
 
 static int smb_direct_post_recv(struct smbdirect_socket *sc,
@@ -760,7 +696,7 @@ static int smb_direct_post_recv(struct smbdirect_socket *sc,
 				    recvmsg->sge.addr, recvmsg->sge.length,
 				    DMA_FROM_DEVICE);
 		recvmsg->sge.length = 0;
-		smb_direct_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, ret);
 		return ret;
 	}
 	return ret;
@@ -947,7 +883,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		pr_err("Send error. status='%s (%d)', opcode=%d\n",
 		       ib_wc_status_msg(wc->status), wc->status,
 		       wc->opcode);
-		smb_direct_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 		return;
 	}
 
@@ -1003,7 +939,7 @@ static int smb_direct_post_send(struct smbdirect_socket *sc,
 	ret = ib_post_send(sc->ib.qp, wr, NULL);
 	if (ret) {
 		pr_err("failed to post send: %d\n", ret);
-		smb_direct_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, ret);
 	}
 	return ret;
 }
@@ -1530,7 +1466,7 @@ static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
 		pr_err("read/write error. opcode = %d, status = %s(%d)\n",
 		       wc->opcode, ib_wc_status_msg(wc->status), wc->status);
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			smb_direct_disconnect_rdma_connection(sc);
+			smbdirect_connection_schedule_disconnect(sc, msg->error);
 	}
 
 	complete(msg->completion);
@@ -1763,7 +1699,7 @@ static void smb_direct_qpair_handler(struct ib_event *event, void *context)
 	switch (event->event) {
 	case IB_EVENT_CQ_ERR:
 	case IB_EVENT_QP_FATAL:
-		smb_direct_disconnect_rdma_connection(sc);
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 		break;
 	default:
 		break;
-- 
2.43.0

