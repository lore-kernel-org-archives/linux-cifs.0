Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22825246BB7
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744303; cv=none; b=oweGq6/Gw1WXrxYQlIigD7Uei3GfVC1/TjsHjb3mkdlaLIZmWoGAr5oZvlWbsW8GAyjM0mvKglg08EWfx3Ara+G5tSIaiWAdoBT3TdSn9o3jDHTn/MkvQdtVWahXQzUWJCYCQYix0+67tdxQiHYLRbThMUH84p/J/bdVt1Pheyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744303; c=relaxed/simple;
	bh=VStKP/9Xta8mMk2NYgFPZxcitTZu3L90O5AD8bopZug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0Q94Na3u8fKurH2PrlwPV2iuJTBwPmorIlV90BEUmuLW6GP50UdbdrZ2KT/QDFt0Bx2yuM4Mm685Pamol3Qd6AhiEo+aJDe3kK4hxs9MfJWA3Vt1kDR1WdmrCrnv7qdMdaQE104b7qn72MlQ0dWChocs36hv752HyKyaZrQeZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hhvhGaNX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hhvhGaNX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=KLxijjkUmSusCUbmp/iXQsx+kOjnaLiioTxxjcJi4ns=; b=hhvhGaNXPrN9N8wJQ5MXr0Duml
	vJbijOwcUNTXd9tndkcINEgdpwn4KFEw1uAzQX8qGFKZxJp3vzQvW9f894CzEQKGgZ/r7wZ5/m83h
	d5mNjfJLIbCZalXRTEtOTcTqPhBQd04/dNMzVA/18U3Ic7h1oeEBxZgVy2zzkVRL6JUwiZslbvlNE
	aUc+mafgCyBXlWQmnAUh3FXPKs5LCNZUkLFizY1n6MUYptLwJJ4EGVITZeO6WxKHLlgx8yUGPTh7+
	m7J/pMtubw6196WBf9BwRXbU6Tv++3sEfn9pJcvITlXf9xSfs77OygBeucPXLy8HOCUjULZdXUX7g
	i0miHvv6ymGwxrsdt+SRIOLguLlI3UPemEQudUX1nNEkou5ziefrnTwnx2m5Q/BzeoclHwJFWukW3
	8jb32xLBoeQCa3ApBzxcdI3QMW6HW4lvjcRADSHqnWwgaNaIxUmjul2MOn2tjwGZjzUpzi7q2OMEu
	3wyAoG4vrGQ0Fxk9tKfhdv6d;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Ac-00BbZn-2k;
	Wed, 29 Oct 2025 13:24:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 025/127] smb: smbdirect: introduce smbdirect_connection_{create,destroy}_qp()
Date: Wed, 29 Oct 2025 14:20:03 +0100
Message-ID: <705a1a07cd5c9f8b609cc4233e98382822b46508.1761742839.git.metze@samba.org>
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

smbdirect_connection_create_qp() is basically a copy of
smb_direct_create_qpair() in the server, it just adds
extra send_wr space for MR requests.

smbdirect_connection_destroy_qp() is the cleanup code
smb_direct_create_qpair() has, plus calling
ib_drain_qp(), it be a no-op if no requests are posted.

These additions allow the functions to be used by client and
server.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 214 ++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_socket.h    |   3 +
 2 files changed, 217 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 7a8a351d0484..448723d438af 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -126,6 +126,220 @@ static void smbdirect_connection_qp_event_handler(struct ib_event *event, void *
 	}
 }
 
+static u32 smbdirect_rdma_rw_send_wrs(struct ib_device *dev,
+				      const struct ib_qp_init_attr *attr)
+{
+	/*
+	 * This could be split out of rdma_rw_init_qp()
+	 * and be a helper function next to rdma_rw_mr_factor()
+	 *
+	 * We can't check unlikely(rdma_rw_force_mr) here,
+	 * but that is most likely 0 anyway.
+	 */
+	u32 factor;
+
+	WARN_ON_ONCE(attr->port_num == 0);
+
+	/*
+	 * Each context needs at least one RDMA READ or WRITE WR.
+	 *
+	 * For some hardware we might need more, eventually we should ask the
+	 * HCA driver for a multiplier here.
+	 */
+	factor = 1;
+
+	/*
+	 * If the device needs MRs to perform RDMA READ or WRITE operations,
+	 * we'll need two additional MRs for the registrations and the
+	 * invalidation.
+	 */
+	if (rdma_protocol_iwarp(dev, attr->port_num) || dev->attrs.max_sgl_rd)
+		factor += 2;	/* inv + reg */
+
+	return factor * attr->cap.max_rdma_ctxs;
+}
+
+static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc);
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
+{
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct ib_qp_init_attr qp_attr;
+	struct ib_qp_cap qp_cap;
+	u32 rdma_send_wr;
+	u32 max_send_wr;
+	int ret;
+
+	/*
+	 * Note that {rdma,ib}_create_qp() will call
+	 * rdma_rw_init_qp() if max_rdma_ctxs is not 0.
+	 * It will adjust max_send_wr to the required
+	 * number of additional WRs for the RDMA RW operations.
+	 * It will cap max_send_wr to the device limit.
+	 *
+	 * We use allocate sp->responder_resources * 2 MRs
+	 * and each MR needs WRs for REG and INV, so
+	 * we use '* 4'.
+	 *
+	 * +1 for ib_drain_qp()
+	 */
+	memset(&qp_cap, 0, sizeof(qp_cap));
+	qp_cap.max_send_wr = sp->send_credit_target + sp->responder_resources * 4 + 1;
+	qp_cap.max_recv_wr = sp->recv_credit_max + 1;
+	qp_cap.max_send_sge = SMBDIRECT_SEND_IO_MAX_SGE;
+	qp_cap.max_recv_sge = SMBDIRECT_RECV_IO_MAX_SGE;
+	qp_cap.max_inline_data = 0;
+	qp_cap.max_rdma_ctxs = sc->rw_io.credits.max;
+
+	/*
+	 * Find out the number of max_send_wr
+	 * after rdma_rw_init_qp() adjusted it.
+	 *
+	 * We only do it on a temporary variable,
+	 * as rdma_create_qp() will trigger
+	 * rdma_rw_init_qp() again.
+	 */
+	memset(&qp_attr, 0, sizeof(qp_attr));
+	qp_attr.cap = qp_cap;
+	qp_attr.port_num = sc->rdma.cm_id->port_num;
+	rdma_send_wr = smbdirect_rdma_rw_send_wrs(sc->ib.dev, &qp_attr);
+	max_send_wr = qp_cap.max_send_wr + rdma_send_wr;
+
+	if (qp_cap.max_send_wr > sc->ib.dev->attrs.max_cqe ||
+	    qp_cap.max_send_wr > sc->ib.dev->attrs.max_qp_wr) {
+		pr_err("Possible CQE overrun: max_send_wr %d\n",
+		       qp_cap.max_send_wr);
+		pr_err("device %.*s reporting max_cqe %d max_qp_wr %d\n",
+		       IB_DEVICE_NAME_MAX,
+		       sc->ib.dev->name,
+		       sc->ib.dev->attrs.max_cqe,
+		       sc->ib.dev->attrs.max_qp_wr);
+		pr_err("consider lowering send_credit_target = %d\n",
+		       sp->send_credit_target);
+		return -EINVAL;
+	}
+
+	if (qp_cap.max_rdma_ctxs &&
+	    (max_send_wr >= sc->ib.dev->attrs.max_cqe ||
+	     max_send_wr >= sc->ib.dev->attrs.max_qp_wr)) {
+		pr_err("Possible CQE overrun: rdma_send_wr %d + max_send_wr %d = %d\n",
+		       rdma_send_wr, qp_cap.max_send_wr, max_send_wr);
+		pr_err("device %.*s reporting max_cqe %d max_qp_wr %d\n",
+		       IB_DEVICE_NAME_MAX,
+		       sc->ib.dev->name,
+		       sc->ib.dev->attrs.max_cqe,
+		       sc->ib.dev->attrs.max_qp_wr);
+		pr_err("consider lowering send_credit_target = %d, max_rdma_ctxs = %d\n",
+		       sp->send_credit_target, qp_cap.max_rdma_ctxs);
+		return -EINVAL;
+	}
+
+	if (qp_cap.max_recv_wr > sc->ib.dev->attrs.max_cqe ||
+	    qp_cap.max_recv_wr > sc->ib.dev->attrs.max_qp_wr) {
+		pr_err("Possible CQE overrun: max_recv_wr %d\n",
+		       qp_cap.max_recv_wr);
+		pr_err("device %.*s reporting max_cqe %d max_qp_wr %d\n",
+		       IB_DEVICE_NAME_MAX,
+		       sc->ib.dev->name,
+		       sc->ib.dev->attrs.max_cqe,
+		       sc->ib.dev->attrs.max_qp_wr);
+		pr_err("consider lowering receive_credit_max = %d\n",
+		       sp->recv_credit_max);
+		return -EINVAL;
+	}
+
+	if (qp_cap.max_send_sge > sc->ib.dev->attrs.max_send_sge ||
+	    qp_cap.max_recv_sge > sc->ib.dev->attrs.max_recv_sge) {
+		pr_err("device %.*s max_send_sge/max_recv_sge = %d/%d too small\n",
+		       IB_DEVICE_NAME_MAX,
+		       sc->ib.dev->name,
+		       sc->ib.dev->attrs.max_send_sge,
+		       sc->ib.dev->attrs.max_recv_sge);
+		return -EINVAL;
+	}
+
+	sc->ib.pd = ib_alloc_pd(sc->ib.dev, 0);
+	if (IS_ERR(sc->ib.pd)) {
+		pr_err("Can't create RDMA PD: %1pe\n", sc->ib.pd);
+		ret = PTR_ERR(sc->ib.pd);
+		sc->ib.pd = NULL;
+		return ret;
+	}
+
+	sc->ib.send_cq = ib_alloc_cq_any(sc->ib.dev, sc,
+					 max_send_wr,
+					 sc->ib.poll_ctx);
+	if (IS_ERR(sc->ib.send_cq)) {
+		pr_err("Can't create RDMA send CQ: %1pe\n", sc->ib.send_cq);
+		ret = PTR_ERR(sc->ib.send_cq);
+		sc->ib.send_cq = NULL;
+		goto err;
+	}
+
+	sc->ib.recv_cq = ib_alloc_cq_any(sc->ib.dev, sc,
+					 qp_cap.max_recv_wr,
+					 sc->ib.poll_ctx);
+	if (IS_ERR(sc->ib.recv_cq)) {
+		pr_err("Can't create RDMA recv CQ: %1pe\n", sc->ib.recv_cq);
+		ret = PTR_ERR(sc->ib.recv_cq);
+		sc->ib.recv_cq = NULL;
+		goto err;
+	}
+
+	/*
+	 * We reset completely here!
+	 * As the above use was just temporary
+	 * to calc max_send_wr and rdma_send_wr.
+	 *
+	 * rdma_create_qp() will trigger rdma_rw_init_qp()
+	 * again if max_rdma_ctxs is not 0.
+	 */
+	memset(&qp_attr, 0, sizeof(qp_attr));
+	qp_attr.event_handler = smbdirect_connection_qp_event_handler;
+	qp_attr.qp_context = sc;
+	qp_attr.cap = qp_cap;
+	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
+	qp_attr.qp_type = IB_QPT_RC;
+	qp_attr.send_cq = sc->ib.send_cq;
+	qp_attr.recv_cq = sc->ib.recv_cq;
+	qp_attr.port_num = ~0;
+
+	ret = rdma_create_qp(sc->rdma.cm_id, sc->ib.pd, &qp_attr);
+	if (ret) {
+		pr_err("Can't create RDMA QP: %1pe\n",
+		       SMBDIRECT_DEBUG_ERR_PTR(ret));
+		goto err;
+	}
+	sc->ib.qp = sc->rdma.cm_id->qp;
+
+	return 0;
+err:
+	smbdirect_connection_destroy_qp(sc);
+	return ret;
+}
+
+static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
+{
+	if (sc->ib.qp) {
+		ib_drain_qp(sc->ib.qp);
+		sc->ib.qp = NULL;
+		rdma_destroy_qp(sc->rdma.cm_id);
+	}
+	if (sc->ib.recv_cq) {
+		ib_destroy_cq(sc->ib.recv_cq);
+		sc->ib.recv_cq = NULL;
+	}
+	if (sc->ib.send_cq) {
+		ib_destroy_cq(sc->ib.send_cq);
+		sc->ib.send_cq = NULL;
+	}
+	if (sc->ib.pd) {
+		ib_dealloc_pd(sc->ib.pd);
+		sc->ib.pd = NULL;
+	}
+}
+
 static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
 
 __maybe_unused /* this is temporary while this file is included in orders */
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index a25bf92cfff7..5856ce287afa 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -120,6 +120,7 @@ struct smbdirect_socket {
 	/* IB verbs related */
 	struct {
 		struct ib_pd *pd;
+		enum ib_poll_context poll_ctx;
 		struct ib_cq *send_cq;
 		struct ib_cq *recv_cq;
 
@@ -476,6 +477,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_WORK(&sc->disconnect_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->disconnect_work);
 
+	sc->ib.poll_ctx = IB_POLL_UNBOUND_WORKQUEUE;
+
 	INIT_WORK(&sc->idle.immediate_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->idle.immediate_work);
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
-- 
2.43.0

