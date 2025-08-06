Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578AF1A23A9
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501852; cv=none; b=mc+3/ZuxzRkafB/EVh/SjPXNv+6g9lX4CnGQImEBqO5ZLuiWyxyRRQ7hunmT6ZcEda9RROEilYtqHprcgwUOp5DVQe8y0Py6sN5st5icPZyPxv3MXuEXbAImYqElYhFmcATaTBsPeD1q2ssD0YokhF+ZnIFWT8slaJVre/modnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501852; c=relaxed/simple;
	bh=4mXpmtnYQ7EVlGKhRpSMWDdmWeSL6TLy57yTjk4ioXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHjr+x2O2eNjYkHQ/G9FT4R34rgvHHzIQeNPwdp0dvW1glka9C+sm8PuVyq6dVdxbD9VBcFdOZ1p6rIiGfBRHKTHzzOEIuiDzwoQEl1L+ytr3fETFjSx+p4vwHHWLqheWSxjjrbYrBSxW3H9ex8dhoWd4oWmiJXdifTlpY/CcPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UaB74fOH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UaB74fOH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=lLmHoZZ2QAsoP0uxugafNnyk5f7xRCEp/FTGxTeOVyQ=; b=UaB74fOHj9tkrWp4p/Qt2lnrjt
	ZPceNnQv4M4RkqQcyTtLW1VJnEgbabrCCC565hqi0T+SbI1yvdgKtxiT3IYrlc6AjxqH5XCqNdnQl
	HA610id6ZL71eRB2C0Z9HnlX7g2ahHJdl8/E8oXx28jvPwE/DHcGC2xZQfrrZqVUE+s5aUjE8/d2o
	jGCTGEV1jrluRFYWhi3BcBZo82p3i4HtjFijbUbR1OFF8HOjlM069yqdVpw1ssyenG+VshU5NZpT1
	D6gZa0PAVejI8Of4rvFS9dENkxuZverwQ73y0Tf9wceifNqFXWOn5hHSw7GITzHoQlSHtRqf0V74M
	Db3NphNcNiLGOFUUbWlseOBKN5Z1hGTNvR4c2i2mi28J/RnLaAZONpBe4JE8RqvkVW+Ezd7D/QdsS
	T0mWaNLyLGPpD2ETYBsrfzneRM145JJNrpTEQUkqAqpTO4esjDpIQ37Mx4jdA2sNwnMIxZApZeOhq
	I4Amh4UWWMxei+HR7wcwnAwU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji4q-001Oj7-28;
	Wed, 06 Aug 2025 17:37:25 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Subject: [PATCH 10/18] smb: server: make use of common smbdirect_socket
Date: Wed,  6 Aug 2025 19:35:56 +0200
Message-ID: <afb782c547047edefc0bb814c4b5be99070a3a88.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754501401.git.metze@samba.org>
References: <cover.1754501401.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the next step in the direction of a common smbdirect layer.
Currently only structures are shared, but that will change
over time until everything is shared.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 249 ++++++++++++++++++---------------
 1 file changed, 137 insertions(+), 112 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 584f89b88c71..1c852c8601c6 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -25,6 +25,7 @@
 #include "../common/smb2status.h"
 #include "../common/smbdirect/smbdirect.h"
 #include "../common/smbdirect/smbdirect_pdu.h"
+#include "../common/smbdirect/smbdirect_socket.h"
 #include "transport_rdma.h"
 
 #define SMB_DIRECT_PORT_IWARP		5445
@@ -89,26 +90,14 @@ static struct smb_direct_listener {
 
 static struct workqueue_struct *smb_direct_wq;
 
-enum smb_direct_status {
-	SMB_DIRECT_CS_NEW = 0,
-	SMB_DIRECT_CS_CONNECTED,
-	SMB_DIRECT_CS_DISCONNECTING,
-	SMB_DIRECT_CS_DISCONNECTED,
-};
-
 struct smb_direct_transport {
 	struct ksmbd_transport	transport;
 
-	enum smb_direct_status	status;
+	struct smbdirect_socket socket;
+
 	bool			full_packet_received;
 	wait_queue_head_t	wait_status;
 
-	struct rdma_cm_id	*cm_id;
-	struct ib_cq		*send_cq;
-	struct ib_cq		*recv_cq;
-	struct ib_pd		*pd;
-	struct ib_qp		*qp;
-
 	int			max_send_size;
 	int			max_recv_size;
 	int			max_fragmented_send_size;
@@ -267,8 +256,10 @@ smb_direct_recvmsg *get_free_recvmsg(struct smb_direct_transport *t)
 static void put_recvmsg(struct smb_direct_transport *t,
 			struct smb_direct_recvmsg *recvmsg)
 {
+	struct smbdirect_socket *sc = &t->socket;
+
 	if (likely(recvmsg->sge.length != 0)) {
-		ib_dma_unmap_single(t->cm_id->device,
+		ib_dma_unmap_single(sc->ib.dev,
 				    recvmsg->sge.addr,
 				    recvmsg->sge.length,
 				    DMA_FROM_DEVICE);
@@ -312,17 +303,20 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 	struct smb_direct_transport *t =
 		container_of(work, struct smb_direct_transport,
 			     disconnect_work);
+	struct smbdirect_socket *sc = &t->socket;
 
-	if (t->status == SMB_DIRECT_CS_CONNECTED) {
-		t->status = SMB_DIRECT_CS_DISCONNECTING;
-		rdma_disconnect(t->cm_id);
+	if (sc->status == SMBDIRECT_SOCKET_CONNECTED) {
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTING;
+		rdma_disconnect(sc->rdma.cm_id);
 	}
 }
 
 static void
 smb_direct_disconnect_rdma_connection(struct smb_direct_transport *t)
 {
-	if (t->status == SMB_DIRECT_CS_CONNECTED)
+	struct smbdirect_socket *sc = &t->socket;
+
+	if (sc->status == SMBDIRECT_SOCKET_CONNECTED)
 		queue_work(smb_direct_wq, &t->disconnect_work);
 }
 
@@ -330,8 +324,9 @@ static void smb_direct_send_immediate_work(struct work_struct *work)
 {
 	struct smb_direct_transport *t = container_of(work,
 			struct smb_direct_transport, send_immediate_work);
+	struct smbdirect_socket *sc = &t->socket;
 
-	if (t->status != SMB_DIRECT_CS_CONNECTED)
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return;
 
 	smb_direct_post_send_data(t, NULL, NULL, 0, 0);
@@ -340,16 +335,20 @@ static void smb_direct_send_immediate_work(struct work_struct *work)
 static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 {
 	struct smb_direct_transport *t;
+	struct smbdirect_socket *sc;
 	struct ksmbd_conn *conn;
 
 	t = kzalloc(sizeof(*t), KSMBD_DEFAULT_GFP);
 	if (!t)
 		return NULL;
+	sc = &t->socket;
 
-	t->cm_id = cm_id;
+	sc->rdma.cm_id = cm_id;
 	cm_id->context = t;
 
-	t->status = SMB_DIRECT_CS_NEW;
+	sc->ib.dev = sc->rdma.cm_id->device;
+
+	sc->status = SMBDIRECT_SOCKET_CREATED;
 	init_waitqueue_head(&t->wait_status);
 
 	spin_lock_init(&t->reassembly_queue_lock);
@@ -393,6 +392,7 @@ static void smb_direct_free_transport(struct ksmbd_transport *kt)
 
 static void free_transport(struct smb_direct_transport *t)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	struct smb_direct_recvmsg *recvmsg;
 
 	wake_up_interruptible(&t->wait_send_credits);
@@ -405,11 +405,11 @@ static void free_transport(struct smb_direct_transport *t)
 	cancel_delayed_work_sync(&t->post_recv_credits_work);
 	cancel_work_sync(&t->send_immediate_work);
 
-	if (t->qp) {
-		ib_drain_qp(t->qp);
-		ib_mr_pool_destroy(t->qp, &t->qp->rdma_mrs);
-		t->qp = NULL;
-		rdma_destroy_qp(t->cm_id);
+	if (sc->ib.qp) {
+		ib_drain_qp(sc->ib.qp);
+		ib_mr_pool_destroy(sc->ib.qp, &sc->ib.qp->rdma_mrs);
+		sc->ib.qp = NULL;
+		rdma_destroy_qp(sc->rdma.cm_id);
 	}
 
 	ksmbd_debug(RDMA, "drain the reassembly queue\n");
@@ -426,14 +426,14 @@ static void free_transport(struct smb_direct_transport *t)
 	} while (recvmsg);
 	t->reassembly_data_length = 0;
 
-	if (t->send_cq)
-		ib_free_cq(t->send_cq);
-	if (t->recv_cq)
-		ib_free_cq(t->recv_cq);
-	if (t->pd)
-		ib_dealloc_pd(t->pd);
-	if (t->cm_id)
-		rdma_destroy_id(t->cm_id);
+	if (sc->ib.send_cq)
+		ib_free_cq(sc->ib.send_cq);
+	if (sc->ib.recv_cq)
+		ib_free_cq(sc->ib.recv_cq);
+	if (sc->ib.pd)
+		ib_dealloc_pd(sc->ib.pd);
+	if (sc->rdma.cm_id)
+		rdma_destroy_id(sc->rdma.cm_id);
 
 	smb_direct_destroy_pools(t);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
@@ -456,14 +456,15 @@ static struct smb_direct_sendmsg
 static void smb_direct_free_sendmsg(struct smb_direct_transport *t,
 				    struct smb_direct_sendmsg *msg)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	int i;
 
 	if (msg->num_sge > 0) {
-		ib_dma_unmap_single(t->cm_id->device,
+		ib_dma_unmap_single(sc->ib.dev,
 				    msg->sge[0].addr, msg->sge[0].length,
 				    DMA_TO_DEVICE);
 		for (i = 1; i < msg->num_sge; i++)
-			ib_dma_unmap_page(t->cm_id->device,
+			ib_dma_unmap_page(sc->ib.dev,
 					  msg->sge[i].addr, msg->sge[i].length,
 					  DMA_TO_DEVICE);
 	}
@@ -518,9 +519,11 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smb_direct_recvmsg *recvmsg;
 	struct smb_direct_transport *t;
+	struct smbdirect_socket *sc;
 
 	recvmsg = container_of(wc->wr_cqe, struct smb_direct_recvmsg, cqe);
 	t = recvmsg->transport;
+	sc = &t->socket;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
 		put_recvmsg(t, recvmsg);
@@ -549,7 +552,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 		t->negotiation_requested = true;
 		t->full_packet_received = true;
-		t->status = SMB_DIRECT_CS_CONNECTED;
+		sc->status = SMBDIRECT_SOCKET_CONNECTED;
 		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
 		return;
@@ -631,17 +634,18 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 static int smb_direct_post_recv(struct smb_direct_transport *t,
 				struct smb_direct_recvmsg *recvmsg)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	struct ib_recv_wr wr;
 	int ret;
 
-	recvmsg->sge.addr = ib_dma_map_single(t->cm_id->device,
+	recvmsg->sge.addr = ib_dma_map_single(sc->ib.dev,
 					      recvmsg->packet, t->max_recv_size,
 					      DMA_FROM_DEVICE);
-	ret = ib_dma_mapping_error(t->cm_id->device, recvmsg->sge.addr);
+	ret = ib_dma_mapping_error(sc->ib.dev, recvmsg->sge.addr);
 	if (ret)
 		return ret;
 	recvmsg->sge.length = t->max_recv_size;
-	recvmsg->sge.lkey = t->pd->local_dma_lkey;
+	recvmsg->sge.lkey = sc->ib.pd->local_dma_lkey;
 	recvmsg->cqe.done = recv_done;
 
 	wr.wr_cqe = &recvmsg->cqe;
@@ -649,10 +653,10 @@ static int smb_direct_post_recv(struct smb_direct_transport *t,
 	wr.sg_list = &recvmsg->sge;
 	wr.num_sge = 1;
 
-	ret = ib_post_recv(t->qp, &wr, NULL);
+	ret = ib_post_recv(sc->ib.qp, &wr, NULL);
 	if (ret) {
 		pr_err("Can't post recv: %d\n", ret);
-		ib_dma_unmap_single(t->cm_id->device,
+		ib_dma_unmap_single(sc->ib.dev,
 				    recvmsg->sge.addr, recvmsg->sge.length,
 				    DMA_FROM_DEVICE);
 		recvmsg->sge.length = 0;
@@ -671,9 +675,10 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 	u32 data_length, remaining_data_length, data_offset;
 	int rc;
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
+	struct smbdirect_socket *sc = &st->socket;
 
 again:
-	if (st->status != SMB_DIRECT_CS_CONNECTED) {
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
 		pr_err("disconnected\n");
 		return -ENOTCONN;
 	}
@@ -783,7 +788,7 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 	ksmbd_debug(RDMA, "wait_event on more data\n");
 	rc = wait_event_interruptible(st->wait_reassembly_queue,
 				      st->reassembly_data_length >= size ||
-				       st->status != SMB_DIRECT_CS_CONNECTED);
+				       sc->status != SMBDIRECT_SOCKET_CONNECTED);
 	if (rc)
 		return -EINTR;
 
@@ -885,10 +890,11 @@ static int manage_credits_prior_sending(struct smb_direct_transport *t)
 static int smb_direct_post_send(struct smb_direct_transport *t,
 				struct ib_send_wr *wr)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	int ret;
 
 	atomic_inc(&t->send_pending);
-	ret = ib_post_send(t->qp, wr, NULL);
+	ret = ib_post_send(sc->ib.qp, wr, NULL);
 	if (ret) {
 		pr_err("failed to post send: %d\n", ret);
 		if (atomic_dec_and_test(&t->send_pending))
@@ -953,6 +959,7 @@ static int wait_for_credits(struct smb_direct_transport *t,
 			    wait_queue_head_t *waitq, atomic_t *total_credits,
 			    int needed)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	int ret;
 
 	do {
@@ -962,9 +969,9 @@ static int wait_for_credits(struct smb_direct_transport *t,
 		atomic_add(needed, total_credits);
 		ret = wait_event_interruptible(*waitq,
 					       atomic_read(total_credits) >= needed ||
-					       t->status != SMB_DIRECT_CS_CONNECTED);
+					       sc->status != SMBDIRECT_SOCKET_CONNECTED);
 
-		if (t->status != SMB_DIRECT_CS_CONNECTED)
+		if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 			return -ENOTCONN;
 		else if (ret < 0)
 			return ret;
@@ -1002,6 +1009,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 				    int size, int remaining_data_length,
 				    struct smb_direct_sendmsg **sendmsg_out)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	struct smb_direct_sendmsg *sendmsg;
 	struct smbdirect_data_transfer *packet;
 	int header_length;
@@ -1041,11 +1049,11 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 		header_length =
 			offsetof(struct smbdirect_data_transfer, padding);
 
-	sendmsg->sge[0].addr = ib_dma_map_single(t->cm_id->device,
+	sendmsg->sge[0].addr = ib_dma_map_single(sc->ib.dev,
 						 (void *)packet,
 						 header_length,
 						 DMA_TO_DEVICE);
-	ret = ib_dma_mapping_error(t->cm_id->device, sendmsg->sge[0].addr);
+	ret = ib_dma_mapping_error(sc->ib.dev, sendmsg->sge[0].addr);
 	if (ret) {
 		smb_direct_free_sendmsg(t, sendmsg);
 		return ret;
@@ -1053,7 +1061,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 
 	sendmsg->num_sge = 1;
 	sendmsg->sge[0].length = header_length;
-	sendmsg->sge[0].lkey = t->pd->local_dma_lkey;
+	sendmsg->sge[0].lkey = sc->ib.pd->local_dma_lkey;
 
 	*sendmsg_out = sendmsg;
 	return 0;
@@ -1107,10 +1115,11 @@ static int post_sendmsg(struct smb_direct_transport *t,
 			struct smb_direct_send_ctx *send_ctx,
 			struct smb_direct_sendmsg *msg)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	int i;
 
 	for (i = 0; i < msg->num_sge; i++)
-		ib_dma_sync_single_for_device(t->cm_id->device,
+		ib_dma_sync_single_for_device(sc->ib.dev,
 					      msg->sge[i].addr, msg->sge[i].length,
 					      DMA_TO_DEVICE);
 
@@ -1146,6 +1155,7 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 				     struct kvec *iov, int niov,
 				     int remaining_data_length)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	int i, j, ret;
 	struct smb_direct_sendmsg *msg;
 	int data_length;
@@ -1171,7 +1181,7 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 		int sg_cnt;
 
 		sg_init_table(sg, SMB_DIRECT_MAX_SEND_SGES - 1);
-		sg_cnt = get_mapped_sg_list(t->cm_id->device,
+		sg_cnt = get_mapped_sg_list(sc->ib.dev,
 					    iov[i].iov_base, iov[i].iov_len,
 					    sg, SMB_DIRECT_MAX_SEND_SGES - 1,
 					    DMA_TO_DEVICE);
@@ -1182,7 +1192,7 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 		} else if (sg_cnt + msg->num_sge > SMB_DIRECT_MAX_SEND_SGES) {
 			pr_err("buffer not fitted into sges\n");
 			ret = -E2BIG;
-			ib_dma_unmap_sg(t->cm_id->device, sg, sg_cnt,
+			ib_dma_unmap_sg(sc->ib.dev, sg, sg_cnt,
 					DMA_TO_DEVICE);
 			goto err;
 		}
@@ -1191,7 +1201,7 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 			sge = &msg->sge[msg->num_sge];
 			sge->addr = sg_dma_address(&sg[j]);
 			sge->length = sg_dma_len(&sg[j]);
-			sge->lkey  = t->pd->local_dma_lkey;
+			sge->lkey  = sc->ib.pd->local_dma_lkey;
 			msg->num_sge++;
 		}
 	}
@@ -1211,6 +1221,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 			     bool need_invalidate, unsigned int remote_key)
 {
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
+	struct smbdirect_socket *sc = &st->socket;
 	int remaining_data_length;
 	int start, i, j;
 	int max_iov_size = st->max_send_size -
@@ -1219,7 +1230,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	struct kvec vec;
 	struct smb_direct_send_ctx send_ctx;
 
-	if (st->status != SMB_DIRECT_CS_CONNECTED)
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return -ENOTCONN;
 
 	//FIXME: skip RFC1002 header..
@@ -1300,7 +1311,9 @@ static void smb_direct_free_rdma_rw_msg(struct smb_direct_transport *t,
 					struct smb_direct_rdma_rw_msg *msg,
 					enum dma_data_direction dir)
 {
-	rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
+	struct smbdirect_socket *sc = &t->socket;
+
+	rdma_rw_ctx_destroy(&msg->rw_ctx, sc->ib.qp, sc->ib.qp->port,
 			    msg->sgt.sgl, msg->sgt.nents, dir);
 	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
 	kfree(msg);
@@ -1340,6 +1353,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 				unsigned int desc_len,
 				bool is_read)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	struct smb_direct_rdma_rw_msg *msg, *next_msg;
 	int i, ret;
 	DECLARE_COMPLETION_ONSTACK(completion);
@@ -1349,7 +1363,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	int credits_needed;
 	unsigned int desc_buf_len, desc_num = 0;
 
-	if (t->status != SMB_DIRECT_CS_CONNECTED)
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return -ENOTCONN;
 
 	if (buf_len > t->max_rdma_rw_size)
@@ -1419,7 +1433,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 			goto out;
 		}
 
-		ret = rdma_rw_ctx_init(&msg->rw_ctx, t->qp, t->qp->port,
+		ret = rdma_rw_ctx_init(&msg->rw_ctx, sc->ib.qp, sc->ib.qp->port,
 				       msg->sgt.sgl,
 				       get_buf_page_count(desc_buf, desc_buf_len),
 				       0,
@@ -1440,11 +1454,11 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	/* concatenate work requests of rdma_rw_ctxs */
 	first_wr = NULL;
 	list_for_each_entry_reverse(msg, &msg_list, list) {
-		first_wr = rdma_rw_ctx_wrs(&msg->rw_ctx, t->qp, t->qp->port,
+		first_wr = rdma_rw_ctx_wrs(&msg->rw_ctx, sc->ib.qp, sc->ib.qp->port,
 					   &msg->cqe, first_wr);
 	}
 
-	ret = ib_post_send(t->qp, first_wr, NULL);
+	ret = ib_post_send(sc->ib.qp, first_wr, NULL);
 	if (ret) {
 		pr_err("failed to post send wr for RDMA R/W: %d\n", ret);
 		goto out;
@@ -1485,20 +1499,22 @@ static int smb_direct_rdma_read(struct ksmbd_transport *t,
 static void smb_direct_disconnect(struct ksmbd_transport *t)
 {
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
+	struct smbdirect_socket *sc = &st->socket;
 
-	ksmbd_debug(RDMA, "Disconnecting cm_id=%p\n", st->cm_id);
+	ksmbd_debug(RDMA, "Disconnecting cm_id=%p\n", sc->rdma.cm_id);
 
 	smb_direct_disconnect_rdma_work(&st->disconnect_work);
 	wait_event_interruptible(st->wait_status,
-				 st->status == SMB_DIRECT_CS_DISCONNECTED);
+				 sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	free_transport(st);
 }
 
 static void smb_direct_shutdown(struct ksmbd_transport *t)
 {
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
+	struct smbdirect_socket *sc = &st->socket;
 
-	ksmbd_debug(RDMA, "smb-direct shutdown cm_id=%p\n", st->cm_id);
+	ksmbd_debug(RDMA, "smb-direct shutdown cm_id=%p\n", sc->rdma.cm_id);
 
 	smb_direct_disconnect_rdma_work(&st->disconnect_work);
 }
@@ -1507,28 +1523,29 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 				 struct rdma_cm_event *event)
 {
 	struct smb_direct_transport *t = cm_id->context;
+	struct smbdirect_socket *sc = &t->socket;
 
 	ksmbd_debug(RDMA, "RDMA CM event. cm_id=%p event=%s (%d)\n",
 		    cm_id, rdma_event_msg(event->event), event->event);
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_ESTABLISHED: {
-		t->status = SMB_DIRECT_CS_CONNECTED;
+		sc->status = SMBDIRECT_SOCKET_CONNECTED;
 		wake_up_interruptible(&t->wait_status);
 		break;
 	}
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_DISCONNECTED: {
-		ib_drain_qp(t->qp);
+		ib_drain_qp(sc->ib.qp);
 
-		t->status = SMB_DIRECT_CS_DISCONNECTED;
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
 		wake_up_interruptible(&t->wait_status);
 		wake_up_interruptible(&t->wait_reassembly_queue);
 		wake_up(&t->wait_send_credits);
 		break;
 	}
 	case RDMA_CM_EVENT_CONNECT_ERROR: {
-		t->status = SMB_DIRECT_CS_DISCONNECTED;
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
 		wake_up_interruptible(&t->wait_status);
 		break;
 	}
@@ -1544,9 +1561,10 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 static void smb_direct_qpair_handler(struct ib_event *event, void *context)
 {
 	struct smb_direct_transport *t = context;
+	struct smbdirect_socket *sc = &t->socket;
 
 	ksmbd_debug(RDMA, "Received QP event. cm_id=%p, event=%s (%d)\n",
-		    t->cm_id, ib_event_msg(event->event), event->event);
+		    sc->rdma.cm_id, ib_event_msg(event->event), event->event);
 
 	switch (event->event) {
 	case IB_EVENT_CQ_ERR:
@@ -1561,6 +1579,7 @@ static void smb_direct_qpair_handler(struct ib_event *event, void *context)
 static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 					      int failed)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	struct smb_direct_sendmsg *sendmsg;
 	struct smbdirect_negotiate_resp *resp;
 	int ret;
@@ -1591,10 +1610,10 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 				cpu_to_le32(t->max_fragmented_recv_size);
 	}
 
-	sendmsg->sge[0].addr = ib_dma_map_single(t->cm_id->device,
+	sendmsg->sge[0].addr = ib_dma_map_single(sc->ib.dev,
 						 (void *)resp, sizeof(*resp),
 						 DMA_TO_DEVICE);
-	ret = ib_dma_mapping_error(t->cm_id->device, sendmsg->sge[0].addr);
+	ret = ib_dma_mapping_error(sc->ib.dev, sendmsg->sge[0].addr);
 	if (ret) {
 		smb_direct_free_sendmsg(t, sendmsg);
 		return ret;
@@ -1602,7 +1621,7 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 
 	sendmsg->num_sge = 1;
 	sendmsg->sge[0].length = sizeof(*resp);
-	sendmsg->sge[0].lkey = t->pd->local_dma_lkey;
+	sendmsg->sge[0].lkey = sc->ib.pd->local_dma_lkey;
 
 	ret = post_sendmsg(t, NULL, sendmsg);
 	if (ret) {
@@ -1617,19 +1636,20 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 
 static int smb_direct_accept_client(struct smb_direct_transport *t)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	struct rdma_conn_param conn_param;
 	struct ib_port_immutable port_immutable;
 	u32 ird_ord_hdr[2];
 	int ret;
 
 	memset(&conn_param, 0, sizeof(conn_param));
-	conn_param.initiator_depth = min_t(u8, t->cm_id->device->attrs.max_qp_rd_atom,
+	conn_param.initiator_depth = min_t(u8, sc->ib.dev->attrs.max_qp_rd_atom,
 					   SMB_DIRECT_CM_INITIATOR_DEPTH);
 	conn_param.responder_resources = 0;
 
-	t->cm_id->device->ops.get_port_immutable(t->cm_id->device,
-						 t->cm_id->port_num,
-						 &port_immutable);
+	sc->ib.dev->ops.get_port_immutable(sc->ib.dev,
+					   sc->rdma.cm_id->port_num,
+					   &port_immutable);
 	if (port_immutable.core_cap_flags & RDMA_CORE_PORT_IWARP) {
 		ird_ord_hdr[0] = conn_param.responder_resources;
 		ird_ord_hdr[1] = 1;
@@ -1643,7 +1663,7 @@ static int smb_direct_accept_client(struct smb_direct_transport *t)
 	conn_param.rnr_retry_count = SMB_DIRECT_CM_RNR_RETRY;
 	conn_param.flow_control = 0;
 
-	ret = rdma_accept(t->cm_id, &conn_param);
+	ret = rdma_accept(sc->rdma.cm_id, &conn_param);
 	if (ret) {
 		pr_err("error at rdma_accept: %d\n", ret);
 		return ret;
@@ -1683,15 +1703,18 @@ static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 
 static unsigned int smb_direct_get_max_fr_pages(struct smb_direct_transport *t)
 {
+	struct smbdirect_socket *sc = &t->socket;
+
 	return min_t(unsigned int,
-		     t->cm_id->device->attrs.max_fast_reg_page_list_len,
+		     sc->ib.dev->attrs.max_fast_reg_page_list_len,
 		     256);
 }
 
 static int smb_direct_init_params(struct smb_direct_transport *t,
 				  struct ib_qp_cap *cap)
 {
-	struct ib_device *device = t->cm_id->device;
+	struct smbdirect_socket *sc = &t->socket;
+	struct ib_device *device = sc->ib.dev;
 	int max_send_sges, max_rw_wrs, max_send_wrs;
 	unsigned int max_sge_per_wr, wrs_per_credit;
 
@@ -1851,34 +1874,35 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 static int smb_direct_create_qpair(struct smb_direct_transport *t,
 				   struct ib_qp_cap *cap)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	int ret;
 	struct ib_qp_init_attr qp_attr;
 	int pages_per_rw;
 
-	t->pd = ib_alloc_pd(t->cm_id->device, 0);
-	if (IS_ERR(t->pd)) {
+	sc->ib.pd = ib_alloc_pd(sc->ib.dev, 0);
+	if (IS_ERR(sc->ib.pd)) {
 		pr_err("Can't create RDMA PD\n");
-		ret = PTR_ERR(t->pd);
-		t->pd = NULL;
+		ret = PTR_ERR(sc->ib.pd);
+		sc->ib.pd = NULL;
 		return ret;
 	}
 
-	t->send_cq = ib_alloc_cq(t->cm_id->device, t,
+	sc->ib.send_cq = ib_alloc_cq(sc->ib.dev, t,
 				 smb_direct_send_credit_target + cap->max_rdma_ctxs,
 				 0, IB_POLL_WORKQUEUE);
-	if (IS_ERR(t->send_cq)) {
+	if (IS_ERR(sc->ib.send_cq)) {
 		pr_err("Can't create RDMA send CQ\n");
-		ret = PTR_ERR(t->send_cq);
-		t->send_cq = NULL;
+		ret = PTR_ERR(sc->ib.send_cq);
+		sc->ib.send_cq = NULL;
 		goto err;
 	}
 
-	t->recv_cq = ib_alloc_cq(t->cm_id->device, t,
+	sc->ib.recv_cq = ib_alloc_cq(sc->ib.dev, t,
 				 t->recv_credit_max, 0, IB_POLL_WORKQUEUE);
-	if (IS_ERR(t->recv_cq)) {
+	if (IS_ERR(sc->ib.recv_cq)) {
 		pr_err("Can't create RDMA recv CQ\n");
-		ret = PTR_ERR(t->recv_cq);
-		t->recv_cq = NULL;
+		ret = PTR_ERR(sc->ib.recv_cq);
+		sc->ib.recv_cq = NULL;
 		goto err;
 	}
 
@@ -1888,22 +1912,22 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	qp_attr.cap = *cap;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_attr.qp_type = IB_QPT_RC;
-	qp_attr.send_cq = t->send_cq;
-	qp_attr.recv_cq = t->recv_cq;
+	qp_attr.send_cq = sc->ib.send_cq;
+	qp_attr.recv_cq = sc->ib.recv_cq;
 	qp_attr.port_num = ~0;
 
-	ret = rdma_create_qp(t->cm_id, t->pd, &qp_attr);
+	ret = rdma_create_qp(sc->rdma.cm_id, sc->ib.pd, &qp_attr);
 	if (ret) {
 		pr_err("Can't create RDMA QP: %d\n", ret);
 		goto err;
 	}
 
-	t->qp = t->cm_id->qp;
-	t->cm_id->event_handler = smb_direct_cm_handler;
+	sc->ib.qp = sc->rdma.cm_id->qp;
+	sc->rdma.cm_id->event_handler = smb_direct_cm_handler;
 
 	pages_per_rw = DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1;
-	if (pages_per_rw > t->cm_id->device->attrs.max_sgl_rd) {
-		ret = ib_mr_pool_init(t->qp, &t->qp->rdma_mrs,
+	if (pages_per_rw > sc->ib.dev->attrs.max_sgl_rd) {
+		ret = ib_mr_pool_init(sc->ib.qp, &sc->ib.qp->rdma_mrs,
 				      t->max_rw_credits, IB_MR_TYPE_MEM_REG,
 				      t->pages_per_rw_credit, 0);
 		if (ret) {
@@ -1915,21 +1939,21 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 
 	return 0;
 err:
-	if (t->qp) {
-		t->qp = NULL;
-		rdma_destroy_qp(t->cm_id);
+	if (sc->ib.qp) {
+		sc->ib.qp = NULL;
+		rdma_destroy_qp(sc->rdma.cm_id);
 	}
-	if (t->recv_cq) {
-		ib_destroy_cq(t->recv_cq);
-		t->recv_cq = NULL;
+	if (sc->ib.recv_cq) {
+		ib_destroy_cq(sc->ib.recv_cq);
+		sc->ib.recv_cq = NULL;
 	}
-	if (t->send_cq) {
-		ib_destroy_cq(t->send_cq);
-		t->send_cq = NULL;
+	if (sc->ib.send_cq) {
+		ib_destroy_cq(sc->ib.send_cq);
+		sc->ib.send_cq = NULL;
 	}
-	if (t->pd) {
-		ib_dealloc_pd(t->pd);
-		t->pd = NULL;
+	if (sc->ib.pd) {
+		ib_dealloc_pd(sc->ib.pd);
+		sc->ib.pd = NULL;
 	}
 	return ret;
 }
@@ -1937,6 +1961,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 static int smb_direct_prepare(struct ksmbd_transport *t)
 {
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
+	struct smbdirect_socket *sc = &st->socket;
 	struct smb_direct_recvmsg *recvmsg;
 	struct smbdirect_negotiate_req *req;
 	int ret;
@@ -1944,9 +1969,9 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
 	ret = wait_event_interruptible_timeout(st->wait_status,
 					       st->negotiation_requested ||
-					       st->status == SMB_DIRECT_CS_DISCONNECTED,
+					       sc->status == SMBDIRECT_SOCKET_DISCONNECTED,
 					       SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
-	if (ret <= 0 || st->status == SMB_DIRECT_CS_DISCONNECTED)
+	if (ret <= 0 || sc->status == SMBDIRECT_SOCKET_DISCONNECTED)
 		return ret < 0 ? ret : -ETIMEDOUT;
 
 	recvmsg = get_first_reassembly(st);
-- 
2.43.0

