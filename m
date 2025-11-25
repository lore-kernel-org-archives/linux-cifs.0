Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBA732BF5B
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093573; cv=none; b=gBkB4ANQQVura0s6Jpg6KS7p8NqP5rQkQgHDG4X9WZOCPhiIzpKgAssjpumeJtIHP4JOXGYdhYOf5M6CWrIJ/LiYImWGGThVAo4KmAwqSrgdosIxQBGWuPNWLIh3YXRY17M1K03SCw2BmkUdJI4N+dwGmHLaFddOMvcr6BGrxpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093573; c=relaxed/simple;
	bh=UAaE2wZvwiLrqxOAKkjBM9yyEBoFJvr5PdfH6UPiCOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIAT+a5nwBiKtIEozzLx8vuKud+76cRBZk1qSk9Hlt2M4VxHEhTrPo1qZvkBk2AkwWAPSpuiYIcxhXD29Ji30TtlIi8tgWt5Z+6sKW85E570fdkhD2lrPnvOFiyF8nlzSQdHewnxGr4hwUPD9mxNFAvhGqsz3GPHGPJLz4zn65I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yzZHGYiq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yzZHGYiq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=IOqB61fDes8g86SNv50UAySiAS9/Rvtxy1tbR0UZarY=; b=yzZHGYiq5fkwfsMo9WDFETSfqk
	fGH8gwHrEXCXpCdlqk3iEDwshZe6hyhsmaW5BMwC7RbxkMN58yNnSvlS31NHKFkX8hvi0qWhNewmp
	xq8gChfCCjaDLzIQiN09+ebP8pm74eK+M4vS/gpW7GEgs0ZrFMo3/D7OpkB5stQCOe9scrhqHeqty
	qOxeiXJu2ZqJmXuDiYMZs9nl+EFGdZxaW/M6uQzJIN9+wzhOnzIgQWHMTLZt7rMtriEdl3f0BsD5M
	IPXdJSPtUzYei0hkXDMut6+mTHX9dWPI2WF8c3W4cvO3DE5jOayHKmoAWea5VdjA8YXV+Fz8WWaf3
	ZfBmg3C4O0PMJkpnyft4BBrh62ENxv7dMjoFYnQ23jq9tUNNc4M0iB6XPsxxsiy3VPgsst0gPsVne
	wnwcqQpafUHjHLxKHXnktQI5QPX7InQQMfG9aH6g9TdrT25DI1pUvlajKq0NJQeINeqykTurgLEcR
	VuhM3DTnS/wxvBU5OKvKXJ5t;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxK4-00FcvW-0H;
	Tue, 25 Nov 2025 17:59:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 028/145] smb: smbdirect: introduce smbdirect_connection_{create,destroy}_qp()
Date: Tue, 25 Nov 2025 18:54:34 +0100
Message-ID: <4dc208da4364af79a8b1a5061cf1c2bb67eaafbe.1764091285.git.metze@samba.org>
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
index aecd994f5845..6ac4e88da1b0 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -44,6 +44,220 @@ static void smbdirect_connection_qp_event_handler(struct ib_event *event, void *
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
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
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
 
 __maybe_unused /* this is temporary while this file is included in others */
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 5564cf9d999f..66582847530c 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -120,6 +120,7 @@ struct smbdirect_socket {
 	/* IB verbs related */
 	struct {
 		struct ib_pd *pd;
+		enum ib_poll_context poll_ctx;
 		struct ib_cq *send_cq;
 		struct ib_cq *recv_cq;
 
@@ -478,6 +479,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_WORK(&sc->disconnect_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->disconnect_work);
 
+	sc->ib.poll_ctx = IB_POLL_UNBOUND_WORKQUEUE;
+
 	INIT_WORK(&sc->idle.immediate_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->idle.immediate_work);
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
-- 
2.43.0

