Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4E432D423
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760617171; cv=none; b=Ib52veNTgtruG0J4AZFY+aA8IxKeubNSbKuEOlpkKShXIgKlcfkxH+fHyTbRoAMe30cALMlQ6xIvtgUGaF/3dPzzCUuRaJCWrEVBnlGutwh4QexkG6jSAodsN+ORwUGQaw87Fi2UQCpHAlqFbXpJcXtJTmWBasfyTiT+EVph+K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760617171; c=relaxed/simple;
	bh=IfcIz+Pq3TdELSElLaK3x6/Izwh1Xvxm3U+0yvp/c08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D+1ach1FqqjI3RtFwq5bOsNMgk8llW6UXRp0PGaY/30LYoU6qYA5PHUwq+cXhMr6rM1/iyazsFKqrqxuRM2MdEfvtK6WqfhAAcKG4Fs4jqy5wmAAdq4B/q9mbnecNPzSvRO9wjlB/4B7GUpMJIae+e2xiGCKluZAANsKYXEvhSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0N2KZ71o; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0N2KZ71o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=NQXEjkuoqp7JdQLaiIvI5Inp/xHvVO+aU4PlHq2Ui8g=; b=0N2KZ71oWmTQ9jjffuHvLZ9M1J
	/1owHyqijwanztP2bd3bAV+RwmVbRIUd0Uj5N64vu55PIKaB9fAJ+K96Uhql58m18nZIgNqsLBzQ1
	SlNdMkH1BntJCz11wEL1U1yKl9dVqy1u3P+jztP1zfX36IzleZbOApEzXg0Lfsx9DWrdUEnefrr4n
	DUpEylE0VhI4ywaJeGpF8XUJ2LRb7FTKx1WOUR2BUx5Jr4xu3hWmPo3l9dBDXucbIQOuBHBu79nLc
	qf0xZ6XjLnLBMQ/VUsbxRW8dXIbKv/E4ndrAagaRVaObg180EuQidJia5VYapA4aKdx/wuAmgcs/B
	GXrUD94M+2koBgmra0uPP++akiaySYFqRGIFBavOTymNJjcyw8C0F1pB25fGZkoouVPKMkAFloDri
	CxloyKb3bSBdCPh1Zbxturd8ivglzjF+pRZHcL3X0M9OxMouSW1laFi74oECEYDTQsEMnRYTYUosk
	qxSsHrEB0EYYBw0B4Gp4sO8R;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v9Mx4-009YDW-0q;
	Thu, 16 Oct 2025 12:19:26 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v3] smb: server: allocate enough space for RW WRs and ib_drain_qp()
Date: Thu, 16 Oct 2025 14:19:23 +0200
Message-ID: <20251016121923.1252869-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make use of rdma_rw_mr_factor() to calculate the number of rw
credits and the number of pages per RDMA RW operation.

We get the same numbers for iWarp connections, tested
with siw.ko and irdma.ko (in iWarp mode).

siw:

CIFS: max_qp_rd_atom=128, max_fast_reg_page_list_len = 256
CIFS: max_sgl_rd=0, max_sge_rd=1
CIFS: responder_resources=32 max_frmr_depth=256 mr_io.type=0
CIFS: max_send_wr 384, device reporting max_cqe 3276800 max_qp_wr 32768
ksmbd: max_fast_reg_page_list_len = 256, max_sgl_rd=0, max_sge_rd=1
ksmbd: device reporting max_cqe 3276800 max_qp_wr 32768
ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256
ksmbd: New sc->rw_io.credits: max = 9, num_pages = 256, maxpages=2048
ksmbd: Info: rdma_send_wr 27 + max_send_wr 256 = 283

irdma (in iWarp mode):

CIFS: max_qp_rd_atom=127, max_fast_reg_page_list_len = 262144
CIFS: max_sgl_rd=0, max_sge_rd=13
CIFS: responder_resources=32 max_frmr_depth=2048 mr_io.type=0
CIFS: max_send_wr 384, device reporting max_cqe 1048574 max_qp_wr 4063
ksmbd: max_fast_reg_page_list_len = 262144, max_sgl_rd=0, max_sge_rd=13
ksmbd: device reporting max_cqe 1048574 max_qp_wr 4063
ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256
ksmbd: New sc->rw_io.credits: max = 9, num_pages = 256, maxpages=2048
ksmbd: rdma_send_wr 27 + max_send_wr 256 = 283

This means that we get the different correct numbers for ROCE,
tested with rdma_rxe.ko and irdma.ko (in RoCEv2 mode).

rxe:

CIFS: max_qp_rd_atom=128, max_fast_reg_page_list_len = 512
CIFS: max_sgl_rd=0, max_sge_rd=32
CIFS: responder_resources=32 max_frmr_depth=512 mr_io.type=0
CIFS: max_send_wr 384, device reporting max_cqe 32767 max_qp_wr 1048576
ksmbd: max_fast_reg_page_list_len = 512, max_sgl_rd=0, max_sge_rd=32
ksmbd: device reporting max_cqe 32767 max_qp_wr 1048576
ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256
ksmbd: New sc->rw_io.credits: max = 65, num_pages = 32, maxpages=2048
ksmbd: rdma_send_wr 65 + max_send_wr 256 = 321

irdma (in RoCEv2 mode):

CIFS: max_qp_rd_atom=127, max_fast_reg_page_list_len = 262144,
CIFS: max_sgl_rd=0, max_sge_rd=13
CIFS: responder_resources=32 max_frmr_depth=2048 mr_io.type=0
CIFS: max_send_wr 384, device reporting max_cqe 1048574 max_qp_wr 4063
ksmbd: max_fast_reg_page_list_len = 262144, max_sgl_rd=0, max_sge_rd=13
ksmbd: device reporting max_cqe 1048574 max_qp_wr 4063
ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256,
ksmbd: New sc->rw_io.credits: max = 159, num_pages = 13, maxpages=2048
ksmbd: rdma_send_wr 159 + max_send_wr 256 = 415

And rely on rdma_rw_init_qp() to setup ib_mr_pool_init() for
RW MRs.

It seems the code was implemented before the rdma_rw_* layer
was fully established in the kernel.

While there also add additional space for ib_drain_qp().

This should make sure ib_post_send() will never fail
because the submission queue is full.

Fixes: ddbdc861e37c ("ksmbd: smbd: introduce read/write credits for RDMA read/write")
Fixes: 4c564f03e23b ("smb: server: make use of common smbdirect_socket")
Fixes: 177368b99243 ("smb: server: make use of common smbdirect_socket_parameters")
Fixes: 95475d8886bd ("smb: server: make use smbdirect_socket.rw_io.credits")
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 228 ++++++++++++++++++++-------------
 1 file changed, 138 insertions(+), 90 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 94851ff25a02..b2244ef7cd78 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1870,20 +1870,11 @@ static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
 	return ret;
 }
 
-static unsigned int smb_direct_get_max_fr_pages(struct smbdirect_socket *sc)
-{
-	return min_t(unsigned int,
-		     sc->ib.dev->attrs.max_fast_reg_page_list_len,
-		     256);
-}
-
-static int smb_direct_init_params(struct smbdirect_socket *sc,
-				  struct ib_qp_cap *cap)
+static int smb_direct_init_params(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct ib_device *device = sc->ib.dev;
-	int max_send_sges, max_rw_wrs, max_send_wrs;
-	unsigned int max_sge_per_wr, wrs_per_credit;
+	int max_send_sges;
+	unsigned int maxpages;
 
 	/* need 3 more sge. because a SMB_DIRECT header, SMB2 header,
 	 * SMB2 response could be mapped.
@@ -1894,67 +1885,18 @@ static int smb_direct_init_params(struct smbdirect_socket *sc,
 		return -EINVAL;
 	}
 
-	/* Calculate the number of work requests for RDMA R/W.
-	 * The maximum number of pages which can be registered
-	 * with one Memory region can be transferred with one
-	 * R/W credit. And at least 4 work requests for each credit
-	 * are needed for MR registration, RDMA R/W, local & remote
-	 * MR invalidation.
-	 */
-	sc->rw_io.credits.num_pages = smb_direct_get_max_fr_pages(sc);
-	sc->rw_io.credits.max = DIV_ROUND_UP(sp->max_read_write_size,
-					 (sc->rw_io.credits.num_pages - 1) *
-					 PAGE_SIZE);
-
-	max_sge_per_wr = min_t(unsigned int, device->attrs.max_send_sge,
-			       device->attrs.max_sge_rd);
-	max_sge_per_wr = max_t(unsigned int, max_sge_per_wr,
-			       max_send_sges);
-	wrs_per_credit = max_t(unsigned int, 4,
-			       DIV_ROUND_UP(sc->rw_io.credits.num_pages,
-					    max_sge_per_wr) + 1);
-	max_rw_wrs = sc->rw_io.credits.max * wrs_per_credit;
-
-	max_send_wrs = sp->send_credit_target + max_rw_wrs;
-	if (max_send_wrs > device->attrs.max_cqe ||
-	    max_send_wrs > device->attrs.max_qp_wr) {
-		pr_err("consider lowering send_credit_target = %d\n",
-		       sp->send_credit_target);
-		pr_err("Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
-		       device->attrs.max_cqe, device->attrs.max_qp_wr);
-		return -EINVAL;
-	}
-
-	if (sp->recv_credit_max > device->attrs.max_cqe ||
-	    sp->recv_credit_max > device->attrs.max_qp_wr) {
-		pr_err("consider lowering receive_credit_max = %d\n",
-		       sp->recv_credit_max);
-		pr_err("Possible CQE overrun, device reporting max_cpe %d max_qp_wr %d\n",
-		       device->attrs.max_cqe, device->attrs.max_qp_wr);
-		return -EINVAL;
-	}
-
-	if (device->attrs.max_send_sge < SMBDIRECT_SEND_IO_MAX_SGE) {
-		pr_err("warning: device max_send_sge = %d too small\n",
-		       device->attrs.max_send_sge);
-		return -EINVAL;
-	}
-	if (device->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
-		pr_err("warning: device max_recv_sge = %d too small\n",
-		       device->attrs.max_recv_sge);
-		return -EINVAL;
-	}
+	maxpages = DIV_ROUND_UP(sp->max_read_write_size, PAGE_SIZE);
+	sc->rw_io.credits.max = rdma_rw_mr_factor(sc->ib.dev,
+						  sc->rdma.cm_id->port_num,
+						  maxpages);
+	sc->rw_io.credits.num_pages = DIV_ROUND_UP(maxpages, sc->rw_io.credits.max);
+	/* add one extra in order to handle unaligned pages */
+	sc->rw_io.credits.max += 1;
 
 	sc->recv_io.credits.target = 1;
 
 	atomic_set(&sc->rw_io.credits.count, sc->rw_io.credits.max);
 
-	cap->max_send_wr = max_send_wrs;
-	cap->max_recv_wr = sp->recv_credit_max;
-	cap->max_send_sge = SMBDIRECT_SEND_IO_MAX_SGE;
-	cap->max_recv_sge = SMBDIRECT_RECV_IO_MAX_SGE;
-	cap->max_inline_data = 0;
-	cap->max_rdma_ctxs = sc->rw_io.credits.max;
 	return 0;
 }
 
@@ -2028,13 +1970,125 @@ static int smb_direct_create_pools(struct smbdirect_socket *sc)
 	return -ENOMEM;
 }
 
-static int smb_direct_create_qpair(struct smbdirect_socket *sc,
-				   struct ib_qp_cap *cap)
+static u32 smb_direct_rdma_rw_send_wrs(struct ib_device *dev, const struct ib_qp_init_attr *attr)
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
+static int smb_direct_create_qpair(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int ret;
+	struct ib_qp_cap qp_cap;
 	struct ib_qp_init_attr qp_attr;
-	int pages_per_rw;
+	u32 max_send_wr;
+	u32 rdma_send_wr;
+
+	/*
+	 * Note that {rdma,ib}_create_qp() will call
+	 * rdma_rw_init_qp() if cap->max_rdma_ctxs is not 0.
+	 * It will adjust cap->max_send_wr to the required
+	 * number of additional WRs for the RDMA RW operations.
+	 * It will cap cap->max_send_wr to the device limit.
+	 *
+	 * +1 for ib_drain_qp
+	 */
+	qp_cap.max_send_wr = sp->send_credit_target + 1;
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
+	rdma_send_wr = smb_direct_rdma_rw_send_wrs(sc->ib.dev, &qp_attr);
+	max_send_wr = qp_cap.max_send_wr + rdma_send_wr;
+
+	if (qp_cap.max_send_wr > sc->ib.dev->attrs.max_cqe ||
+	    qp_cap.max_send_wr > sc->ib.dev->attrs.max_qp_wr) {
+		pr_err("Possible CQE overrun: max_send_wr %d, "
+		       "device reporting max_cqe %d max_qp_wr %d\n",
+		       qp_cap.max_send_wr,
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
+		pr_err("Possible CQE overrun: rdma_send_wr %d + max_send_wr %d = %d, "
+		       "device reporting max_cqe %d max_qp_wr %d\n",
+		       rdma_send_wr, qp_cap.max_send_wr, max_send_wr,
+		       sc->ib.dev->attrs.max_cqe,
+		       sc->ib.dev->attrs.max_qp_wr);
+		pr_err("consider lowering send_credit_target = %d, max_rdma_ctxs = %d\n",
+		       sp->send_credit_target, qp_cap.max_rdma_ctxs);
+		return -EINVAL;
+	}
+
+	if (qp_cap.max_recv_wr > sc->ib.dev->attrs.max_cqe ||
+	    qp_cap.max_recv_wr > sc->ib.dev->attrs.max_qp_wr) {
+		pr_err("Possible CQE overrun: max_recv_wr %d, "
+		       "device reporting max_cpe %d max_qp_wr %d\n",
+		       qp_cap.max_recv_wr,
+		       sc->ib.dev->attrs.max_cqe,
+		       sc->ib.dev->attrs.max_qp_wr);
+		pr_err("consider lowering receive_credit_max = %d\n",
+		       sp->recv_credit_max);
+		return -EINVAL;
+	}
+
+	if (qp_cap.max_send_sge > sc->ib.dev->attrs.max_send_sge) {
+		pr_err("warning: device max_send_sge = %d too small\n",
+		       sc->ib.dev->attrs.max_send_sge);
+		return -EINVAL;
+	}
+
+	if (qp_cap.max_recv_sge > sc->ib.dev->attrs.max_recv_sge) {
+		pr_err("warning: device max_recv_sge = %d too small\n",
+		       sc->ib.dev->attrs.max_recv_sge);
+		return -EINVAL;
+	}
 
 	sc->ib.pd = ib_alloc_pd(sc->ib.dev, 0);
 	if (IS_ERR(sc->ib.pd)) {
@@ -2045,8 +2099,7 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
 	}
 
 	sc->ib.send_cq = ib_alloc_cq_any(sc->ib.dev, sc,
-					 sp->send_credit_target +
-					 cap->max_rdma_ctxs,
+					 max_send_wr,
 					 IB_POLL_WORKQUEUE);
 	if (IS_ERR(sc->ib.send_cq)) {
 		pr_err("Can't create RDMA send CQ\n");
@@ -2056,7 +2109,7 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
 	}
 
 	sc->ib.recv_cq = ib_alloc_cq_any(sc->ib.dev, sc,
-					 sp->recv_credit_max,
+					 qp_cap.max_recv_wr,
 					 IB_POLL_WORKQUEUE);
 	if (IS_ERR(sc->ib.recv_cq)) {
 		pr_err("Can't create RDMA recv CQ\n");
@@ -2065,10 +2118,18 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
 		goto err;
 	}
 
+	/*
+	 * We reset completely here!
+	 * As the above use was just temporary
+	 * to calc max_send_wr and rdma_send_wr.
+	 *
+	 * rdma_create_qp() will trigger rdma_rw_init_qp()
+	 * again if max_rdma_ctxs is not 0.
+	 */
 	memset(&qp_attr, 0, sizeof(qp_attr));
 	qp_attr.event_handler = smb_direct_qpair_handler;
 	qp_attr.qp_context = sc;
-	qp_attr.cap = *cap;
+	qp_attr.cap = qp_cap;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_attr.qp_type = IB_QPT_RC;
 	qp_attr.send_cq = sc->ib.send_cq;
@@ -2084,18 +2145,6 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
 	sc->ib.qp = sc->rdma.cm_id->qp;
 	sc->rdma.cm_id->event_handler = smb_direct_cm_handler;
 
-	pages_per_rw = DIV_ROUND_UP(sp->max_read_write_size, PAGE_SIZE) + 1;
-	if (pages_per_rw > sc->ib.dev->attrs.max_sgl_rd) {
-		ret = ib_mr_pool_init(sc->ib.qp, &sc->ib.qp->rdma_mrs,
-				      sc->rw_io.credits.max, IB_MR_TYPE_MEM_REG,
-				      sc->rw_io.credits.num_pages, 0);
-		if (ret) {
-			pr_err("failed to init mr pool count %zu pages %zu\n",
-			       sc->rw_io.credits.max, sc->rw_io.credits.num_pages);
-			goto err;
-		}
-	}
-
 	return 0;
 err:
 	if (sc->ib.qp) {
@@ -2182,10 +2231,9 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 
 static int smb_direct_connect(struct smbdirect_socket *sc)
 {
-	struct ib_qp_cap qp_cap;
 	int ret;
 
-	ret = smb_direct_init_params(sc, &qp_cap);
+	ret = smb_direct_init_params(sc);
 	if (ret) {
 		pr_err("Can't configure RDMA parameters\n");
 		return ret;
@@ -2197,7 +2245,7 @@ static int smb_direct_connect(struct smbdirect_socket *sc)
 		return ret;
 	}
 
-	ret = smb_direct_create_qpair(sc, &qp_cap);
+	ret = smb_direct_create_qpair(sc);
 	if (ret) {
 		pr_err("Can't accept RDMA client: %d\n", ret);
 		return ret;
-- 
2.43.0

