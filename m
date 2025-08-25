Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD54287277
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155712; cv=none; b=KO1gkVcZRRclC3cNZ04UyugMLKUU1czFtSDdX4IfICSKggZzgDF5+I78qUJ20VYC9WTmiLKnFZgv7GFYNUunJBPGYKtNGS8iRvI5TLxwCRZxImHH6last81dS4z1tEUvs0xL/YKx1glUCV+86j+6Xpogpd/sgLB6SGu5tZrt4T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155712; c=relaxed/simple;
	bh=HyCjcvgVCkgelvuY/5+Oy54p0ht2KQwK/cB0HR9iBDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D33siSGe27op4xFslryJKo9dQ6Ov1NidhSaiM8Lb3V948gaWLjggGAyWwQsd1Jae8XAvtA1dzO6ECCtCS7T95LRdI63u4E2fXvX9xj9kEWm6O1XNIEbsxJFHXknGoTNDq0A4/5NO/B4oRJxl+V8iN7W3gGz9uJrFOGU+ucUaVgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Zg6/CMrl; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Zg6/CMrl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=t126UvUMb0uSxTm6j6MSqxQAhqlaP1rWFg+qzX8D9xI=; b=Zg6/CMrlUBtv6bqC+XqRx0vg17
	I6pQi0GdS6BFPeeyEshHt04klBMiaznfZdVkIX1AEP4OGxtB7/Z2fZwgFrXfV2vYiGV8lkbPD90qC
	tAFXbn7HRRQG6MNtg0KvaH+yJfiMxtWrP/Z5XoxOPM+6XuDf2nIIEzZ1Y1ti79jt6y+r6GuTnua4u
	nKY65Q7ok+Hx381OEohb270NJnI7igFJOYu3iddmSOYw7jAG2/SxIATXAHnLny6JuFa3KeJ2vyXYB
	wCDn2j1VA5fZ8CtPzcyk55XR5tsCJ7S1oVi2bFTXBV+tjSSt7brrw+z1TBA4u4kxa5TkCCvXvd8Ks
	jd3yaFY0i9xMHOsHimYhlbkUClJ8V8rQwTxdFcLHjb5WcKicyC2cB4euvUSQ5tP83fhJjb8X+x1Tg
	7J4te6g9HjIfjRZby9aBeqV8lvI5U527bgW3UUmwp3WL5zNNlCO2KtgMP3p1ycu1HewNva3GboZ1/
	/BnipM2905jklgaGfwa5PaqZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeK3-000nD3-2A;
	Mon, 25 Aug 2025 21:01:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 120/142] smb: server: pass struct smbdirect_socket to smb_direct_disconnect_rdma_connection()
Date: Mon, 25 Aug 2025 22:41:21 +0200
Message-ID: <3c0b869d25c9ddb3c5367622b08559dde7aae7d5.1756139607.git.metze@samba.org>
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

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 64af3e3b373a..8b6de0a6bf9d 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -260,10 +260,8 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 }
 
 static void
-smb_direct_disconnect_rdma_connection(struct smb_direct_transport *t)
+smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
-
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
 
@@ -285,11 +283,9 @@ static void smb_direct_idle_connection_timer(struct work_struct *work)
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, idle.timer_work.work);
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smb_direct_transport *t =
-		container_of(sc, struct smb_direct_transport, socket);
 
 	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
-		smb_direct_disconnect_rdma_connection(t);
+		smb_direct_disconnect_rdma_connection(sc);
 		return;
 	}
 
@@ -516,7 +512,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			pr_err("Recv error. status='%s (%d)' opcode=%d\n",
 			       ib_wc_status_msg(wc->status), wc->status,
 			       wc->opcode);
-			smb_direct_disconnect_rdma_connection(t);
+			smb_direct_disconnect_rdma_connection(sc);
 		}
 		return;
 	}
@@ -540,7 +536,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	case SMBDIRECT_EXPECT_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
 			put_recvmsg(sc, recvmsg);
-			smb_direct_disconnect_rdma_connection(t);
+			smb_direct_disconnect_rdma_connection(sc);
 			return;
 		}
 		sc->recv_io.reassembly.full_packet_received = true;
@@ -558,7 +554,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (wc->byte_len <
 		    offsetof(struct smbdirect_data_transfer, padding)) {
 			put_recvmsg(sc, recvmsg);
-			smb_direct_disconnect_rdma_connection(t);
+			smb_direct_disconnect_rdma_connection(sc);
 			return;
 		}
 
@@ -567,7 +563,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			if (wc->byte_len < sizeof(struct smbdirect_data_transfer) +
 			    (u64)data_length) {
 				put_recvmsg(sc, recvmsg);
-				smb_direct_disconnect_rdma_connection(t);
+				smb_direct_disconnect_rdma_connection(sc);
 				return;
 			}
 
@@ -621,7 +617,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	 */
 	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
 	put_recvmsg(sc, recvmsg);
-	smb_direct_disconnect_rdma_connection(t);
+	smb_direct_disconnect_rdma_connection(sc);
 }
 
 static int smb_direct_post_recv(struct smb_direct_transport *t,
@@ -655,7 +651,7 @@ static int smb_direct_post_recv(struct smb_direct_transport *t,
 				    recvmsg->sge.addr, recvmsg->sge.length,
 				    DMA_FROM_DEVICE);
 		recvmsg->sge.length = 0;
-		smb_direct_disconnect_rdma_connection(t);
+		smb_direct_disconnect_rdma_connection(sc);
 		return ret;
 	}
 	return ret;
@@ -833,7 +829,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		pr_err("Send error. status='%s (%d)', opcode=%d\n",
 		       ib_wc_status_msg(wc->status), wc->status,
 		       wc->opcode);
-		smb_direct_disconnect_rdma_connection(t);
+		smb_direct_disconnect_rdma_connection(sc);
 	}
 
 	if (atomic_dec_and_test(&sc->send_io.pending.count))
@@ -902,7 +898,7 @@ static int smb_direct_post_send(struct smb_direct_transport *t,
 		pr_err("failed to post send: %d\n", ret);
 		if (atomic_dec_and_test(&sc->send_io.pending.count))
 			wake_up(&sc->send_io.pending.wait_queue);
-		smb_direct_disconnect_rdma_connection(t);
+		smb_direct_disconnect_rdma_connection(sc);
 	}
 	return ret;
 }
@@ -1346,15 +1342,13 @@ static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
 	struct smbdirect_rw_io *msg =
 		container_of(wc->wr_cqe, struct smbdirect_rw_io, cqe);
 	struct smbdirect_socket *sc = msg->socket;
-	struct smb_direct_transport *t =
-		container_of(sc, struct smb_direct_transport, socket);
 
 	if (wc->status != IB_WC_SUCCESS) {
 		msg->error = -EIO;
 		pr_err("read/write error. opcode = %d, status = %s(%d)\n",
 		       wc->opcode, ib_wc_status_msg(wc->status), wc->status);
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			smb_direct_disconnect_rdma_connection(t);
+			smb_direct_disconnect_rdma_connection(sc);
 	}
 
 	complete(msg->completion);
@@ -1592,7 +1586,7 @@ static void smb_direct_qpair_handler(struct ib_event *event, void *context)
 	switch (event->event) {
 	case IB_EVENT_CQ_ERR:
 	case IB_EVENT_QP_FATAL:
-		smb_direct_disconnect_rdma_connection(t);
+		smb_direct_disconnect_rdma_connection(sc);
 		break;
 	default:
 		break;
-- 
2.43.0

