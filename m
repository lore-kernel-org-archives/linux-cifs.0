Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A3D2512F1
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744578; cv=none; b=ixNcFOh3pZK3yoq5CW74Tta3oK3w2KLL8nXXARSWJ+m0bKwGlogm4zOTON00JvwEdhVpAFWgSVAAaijS0WjC1YKa4bCHIdSUnMfmBs6ZuB/5M6SxS2nxdqM/xHv/VERjLBM25ag6Hh0xLXge5BYh56S2Hk3AMYNsZLbnMUx27E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744578; c=relaxed/simple;
	bh=5ChVU+zGyh8TIjcF0b0K2arGHecnMvUbdoht2D9X72w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB2gudb18hI7cUxXUgB/pSOj5mOQJF2DlEGs/K/DShxKaZDZDbtma6Kmd5Y4nGElTUgBuhyUSFkM1aS4DodJlLtKGNlPZk8okumeTSKeVfNCmbaTY7eIpaDDc4y5Z00NV98a4J4tdPQenuErCUAlN/fCHSN/QzgYXqDPrVqZVUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ssw5kG1U; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ssw5kG1U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Ejb8whXYm59wv76a0NqRcjb81d6rN0RB0qaS+vhhU+k=; b=ssw5kG1UpHVeLIEsE/dcwQNiUS
	HswnugsTOyOVQt8TDpKdHsnPrc8tW7culXYLuKsjRN5nqWsA0nx7Lq1OerUcmPEMV4G1INp1wsZWj
	x3ycavQoRF6g5222Ys3GDBWbeU18qL5Qs766tsRskMTbc+k4yn9GES7A0PeRpUAj+GUpt4EvcNU6C
	q43YzPyi8pg0a6Zbt9+vUCadDACC1L0k4Intyj9/6ZWJmoY71gY7/eQrzdeatDt6vxOrvnoCL1DIA
	+mknx4hfJDPXrW+FvTwAelKZRoBSbWytrevn8X/ZdYindy7X/YqgqL58qQAzaYg4FrnwrmxkXhY0k
	7xfa2hFgiZ5v5ZT6R/Ye4sBTLKu5gEqhqZdbtdcg1UarErC8DTojGk3/w/iwh7Wyc+4O/cRxYxxDp
	ZARs0SWxoEtmcms2rXp+zx52fZlA8ujKRE3wThEScIrec0QK3yVNxZ7A3lsu5b7AZ4B2js96iev8f
	BKHw2WknctY4M2DLM4h8ccjW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6F3-00BcGP-1X;
	Wed, 29 Oct 2025 13:29:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 072/127] smb: client: make use of smbdirect_connection_{create,destroy}_qp()
Date: Wed, 29 Oct 2025 14:20:50 +0100
Message-ID: <d65b9ea121e38dc866b7ac850ce618489c76f17d.1761742839.git.metze@samba.org>
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

It's good a use common code for this and it will allow us
to share more code in the next steps.

Calling ib_drain_qp() twice is ok.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 105 +++-----------------------------------
 1 file changed, 7 insertions(+), 98 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b2d94411ecc2..59ab8489ad9f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1195,10 +1195,8 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	log_rdma_event(INFO, "cancelling recv_io.posted.refill_work\n");
 	disable_work_sync(&sc->recv_io.posted.refill_work);
 
-	log_rdma_event(INFO, "destroying qp\n");
+	log_rdma_event(INFO, "drain qp\n");
 	ib_drain_qp(sc->ib.qp);
-	rdma_destroy_qp(sc->rdma.cm_id);
-	sc->ib.qp = NULL;
 
 	log_rdma_event(INFO, "cancelling idle timer\n");
 	disable_delayed_work_sync(&sc->idle.timer_work);
@@ -1224,9 +1222,8 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	log_rdma_event(INFO, "freeing mr list\n");
 	destroy_mr_list(sc);
 
-	ib_free_cq(sc->ib.send_cq);
-	ib_free_cq(sc->ib.recv_cq);
-	ib_dealloc_pd(sc->ib.pd);
+	log_rdma_event(INFO, "destroying qp\n");
+	smbdirect_connection_destroy_qp(sc);
 	rdma_destroy_id(sc->rdma.cm_id);
 
 	/* free mempools */
@@ -1286,8 +1283,6 @@ static struct smbd_connection *_smbd_get_connection(
 	struct smbdirect_socket_parameters init_params = {};
 	struct smbdirect_socket_parameters *sp;
 	struct rdma_conn_param conn_param;
-	struct ib_qp_cap qp_cap;
-	struct ib_qp_init_attr qp_attr;
 	struct sockaddr_in *addr_in = (struct sockaddr_in *) dstaddr;
 	struct ib_port_immutable port_immutable;
 	__be32 ird_ord_hdr[2];
@@ -1323,6 +1318,7 @@ static struct smbd_connection *_smbd_get_connection(
 		goto create_wq_failed;
 	smbdirect_socket_prepare_create(sc, sp, workqueue);
 	smbdirect_socket_set_logging(sc, NULL, smbd_logging_needed, smbd_logging_vaprintf);
+	sc->ib.poll_ctx = IB_POLL_SOFTIRQ;
 	/*
 	 * from here we operate on the copy.
 	 */
@@ -1334,94 +1330,17 @@ static struct smbd_connection *_smbd_get_connection(
 		goto create_id_failed;
 	}
 
-	if (sp->send_credit_target > sc->ib.dev->attrs.max_cqe ||
-	    sp->send_credit_target > sc->ib.dev->attrs.max_qp_wr) {
-		log_rdma_event(ERR, "consider lowering send_credit_target = %d. Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
-			       sp->send_credit_target,
-			       sc->ib.dev->attrs.max_cqe,
-			       sc->ib.dev->attrs.max_qp_wr);
-		goto config_failed;
-	}
-
-	if (sp->recv_credit_max > sc->ib.dev->attrs.max_cqe ||
-	    sp->recv_credit_max > sc->ib.dev->attrs.max_qp_wr) {
-		log_rdma_event(ERR, "consider lowering receive_credit_max = %d. Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
-			       sp->recv_credit_max,
-			       sc->ib.dev->attrs.max_cqe,
-			       sc->ib.dev->attrs.max_qp_wr);
-		goto config_failed;
-	}
-
-	if (sc->ib.dev->attrs.max_send_sge < SMBDIRECT_SEND_IO_MAX_SGE ||
-	    sc->ib.dev->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
-		log_rdma_event(ERR,
-			"device %.*s max_send_sge/max_recv_sge = %d/%d too small\n",
-			IB_DEVICE_NAME_MAX,
-			sc->ib.dev->name,
-			sc->ib.dev->attrs.max_send_sge,
-			sc->ib.dev->attrs.max_recv_sge);
-		goto config_failed;
-	}
-
 	sp->responder_resources =
 		min_t(u8, sp->responder_resources,
 		      sc->ib.dev->attrs.max_qp_rd_atom);
 	log_rdma_mr(INFO, "responder_resources=%d\n",
 		sp->responder_resources);
 
-	/*
-	 * We use allocate sp->responder_resources * 2 MRs
-	 * and each MR needs WRs for REG and INV, so
-	 * we use '* 4'.
-	 *
-	 * +1 for ib_drain_qp()
-	 */
-	memset(&qp_cap, 0, sizeof(qp_cap));
-	qp_cap.max_send_wr = sp->send_credit_target + sp->responder_resources * 4 + 1;
-	qp_cap.max_recv_wr = sp->recv_credit_max + 1;
-	qp_cap.max_send_sge = SMBDIRECT_SEND_IO_MAX_SGE;
-	qp_cap.max_recv_sge = SMBDIRECT_RECV_IO_MAX_SGE;
-
-	sc->ib.pd = ib_alloc_pd(sc->ib.dev, 0);
-	if (IS_ERR(sc->ib.pd)) {
-		rc = PTR_ERR(sc->ib.pd);
-		sc->ib.pd = NULL;
-		log_rdma_event(ERR, "ib_alloc_pd() returned %d\n", rc);
-		goto alloc_pd_failed;
-	}
-
-	sc->ib.send_cq =
-		ib_alloc_cq_any(sc->ib.dev, sc,
-				qp_cap.max_send_wr, IB_POLL_SOFTIRQ);
-	if (IS_ERR(sc->ib.send_cq)) {
-		sc->ib.send_cq = NULL;
-		goto alloc_cq_failed;
-	}
-
-	sc->ib.recv_cq =
-		ib_alloc_cq_any(sc->ib.dev, sc,
-				qp_cap.max_recv_wr, IB_POLL_SOFTIRQ);
-	if (IS_ERR(sc->ib.recv_cq)) {
-		sc->ib.recv_cq = NULL;
-		goto alloc_cq_failed;
-	}
-
-	memset(&qp_attr, 0, sizeof(qp_attr));
-	qp_attr.event_handler = smbdirect_connection_qp_event_handler;
-	qp_attr.qp_context = sc;
-	qp_attr.cap = qp_cap;
-	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
-	qp_attr.qp_type = IB_QPT_RC;
-	qp_attr.send_cq = sc->ib.send_cq;
-	qp_attr.recv_cq = sc->ib.recv_cq;
-	qp_attr.port_num = ~0;
-
-	rc = rdma_create_qp(sc->rdma.cm_id, sc->ib.pd, &qp_attr);
+	rc = smbdirect_connection_create_qp(sc);
 	if (rc) {
-		log_rdma_event(ERR, "rdma_create_qp failed %i\n", rc);
+		log_rdma_event(ERR, "smbdirect_connection_create_qp failed %i\n", rc);
 		goto create_qp_failed;
 	}
-	sc->ib.qp = sc->rdma.cm_id->qp;
 
 	memset(&conn_param, 0, sizeof(conn_param));
 	conn_param.initiator_depth = sp->initiator_depth;
@@ -1514,19 +1433,9 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_cache_failed:
 rdma_connect_failed:
-	rdma_destroy_qp(sc->rdma.cm_id);
+	smbdirect_connection_destroy_qp(sc);
 
 create_qp_failed:
-alloc_cq_failed:
-	if (sc->ib.send_cq)
-		ib_free_cq(sc->ib.send_cq);
-	if (sc->ib.recv_cq)
-		ib_free_cq(sc->ib.recv_cq);
-
-	ib_dealloc_pd(sc->ib.pd);
-
-alloc_pd_failed:
-config_failed:
 	rdma_destroy_id(sc->rdma.cm_id);
 
 create_id_failed:
-- 
2.43.0

