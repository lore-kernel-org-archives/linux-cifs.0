Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02234220F2F
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155299; cv=none; b=SFwJxeXnyIf5rJJ6b8lcow/3R0UPAqzjilGppb24iWKKjqkHoBkuk6x0JwZnmZB9h6qIDJ9PySkPqsaeP27hE7oREi6yHClvUPoi3uBZyc9n/6qLXHHjxb6WHgSXc9Wb5LaQqHg1lPk7Az9mSu78EsrBVErUvLknYSvDFfh4e6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155299; c=relaxed/simple;
	bh=ayEa6UeHD4Zwybqrc+vO4O1Cut1Y8S5n9bufEJi9BXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nay43/0mChilEUXTBVgW1emG/efAIFIxyF1bZ0STSH8M78RqycXpj7QYIncaqG1DGFAJRcQOWFkpU28YUdsrt/OwisBeCfkWoyoIS1Ms4ZEZ03T0IQgWglY3TZpyKo/TyizR42xsRFBO0PZNGyqAnB00qj95FTQ0dMozTggiRJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3yQpjhTt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3yQpjhTt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=LdPyu7/+jBBPquJ3Tknqtym76H44DEATCsdQlN6V59I=; b=3yQpjhTt464rt+74pKNZWLh+uR
	pC9CLMg3ECHDfxgxHnRnlZTxIjzun5e+LhoB+qR0nUONPaUYDP7Z3XAxhk8KUxjnted4rNXOEa8R/
	J2Oq2k7+gsImGdRrYS4Mx9zHILkqpqHpHrVy3MOOPuuv59F2+3L89+EGyTXtbsH1Hf1ZjnrN5hgho
	ZTjSvUUImxLyg5YaPf0z2Dxikz/tEtOfOv2HL/QyokeeHsChka6G41hOILYbAlJ8vie0Fx5lcgq1X
	MXrllnKLxJfGukGFhEumg1d5BMwWeMcNOd4kSL/9JUa3cp3p2uMfqeJb2j8q0jSexXj5uXv2Yp0Rf
	KBDxLhopRYMItsAuDvYt47EHyjKwFItOw909d4hhJB03kP901AINOVrlQVF19kVg2bV00m7oMamwn
	lIoR3cw+ys5TkH2eGcdltblAaPMESYk/49ZBQjvHeMkHDdNRc6n9txbkHKryHmY1/C8uiPJ3cjy7L
	/T/A7/JFOfz6ITEkeSoOg1aC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeDP-000lr9-04;
	Mon, 25 Aug 2025 20:54:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 079/142] smb: server: make use of common smbdirect_socket_parameters
Date: Mon, 25 Aug 2025 22:40:40 +0200
Message-ID: <c149a4e9f758074dbbc2a6e010feb7abf0ae7675.1756139607.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 85 ++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 41 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index a7b6c618353e..9f2a0c94988e 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -98,12 +98,6 @@ struct smb_direct_transport {
 	bool			full_packet_received;
 	wait_queue_head_t	wait_status;
 
-	int			max_send_size;
-	int			max_recv_size;
-	int			max_fragmented_send_size;
-	int			max_fragmented_recv_size;
-	int			max_rdma_rw_size;
-
 	spinlock_t		reassembly_queue_lock;
 	struct list_head	reassembly_queue;
 	int			reassembly_data_length;
@@ -114,13 +108,11 @@ struct smb_direct_transport {
 	spinlock_t		receive_credit_lock;
 	int			recv_credits;
 	int			count_avail_recvmsg;
-	int			recv_credit_max;
 	int			recv_credit_target;
 
 	spinlock_t		recvmsg_queue_lock;
 	struct list_head	recvmsg_queue;
 
-	int			send_credit_target;
 	atomic_t		send_credits;
 	spinlock_t		lock_new_recv_credits;
 	int			new_recv_credits;
@@ -642,16 +634,18 @@ static int smb_direct_post_recv(struct smb_direct_transport *t,
 				struct smb_direct_recvmsg *recvmsg)
 {
 	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_recv_wr wr;
 	int ret;
 
 	recvmsg->sge.addr = ib_dma_map_single(sc->ib.dev,
-					      recvmsg->packet, t->max_recv_size,
+					      recvmsg->packet,
+					      sp->max_recv_size,
 					      DMA_FROM_DEVICE);
 	ret = ib_dma_mapping_error(sc->ib.dev, recvmsg->sge.addr);
 	if (ret)
 		return ret;
-	recvmsg->sge.length = t->max_recv_size;
+	recvmsg->sge.length = sp->max_recv_size;
 	recvmsg->sge.lkey = sc->ib.pd->local_dma_lkey;
 	recvmsg->cqe.done = recv_done;
 
@@ -1017,6 +1011,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 				    struct smb_direct_sendmsg **sendmsg_out)
 {
 	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smb_direct_sendmsg *sendmsg;
 	struct smbdirect_data_transfer *packet;
 	int header_length;
@@ -1028,7 +1023,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 
 	/* Fill in the packet header */
 	packet = (struct smbdirect_data_transfer *)sendmsg->packet;
-	packet->credits_requested = cpu_to_le16(t->send_credit_target);
+	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
 	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(t));
 
 	packet->flags = 0;
@@ -1229,9 +1224,10 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 {
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
 	struct smbdirect_socket *sc = &st->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int remaining_data_length;
 	int start, i, j;
-	int max_iov_size = st->max_send_size -
+	int max_iov_size = sp->max_send_size -
 			sizeof(struct smbdirect_data_transfer);
 	int ret;
 	struct kvec vec;
@@ -1361,6 +1357,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 				bool is_read)
 {
 	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smb_direct_rdma_rw_msg *msg, *next_msg;
 	int i, ret;
 	DECLARE_COMPLETION_ONSTACK(completion);
@@ -1373,7 +1370,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return -ENOTCONN;
 
-	if (buf_len > t->max_rdma_rw_size)
+	if (buf_len > sp->max_read_write_size)
 		return -EINVAL;
 
 	/* calculate needed credits */
@@ -1587,6 +1584,7 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 					      int failed)
 {
 	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smb_direct_sendmsg *sendmsg;
 	struct smbdirect_negotiate_resp *resp;
 	int ret;
@@ -1608,13 +1606,13 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 		resp->negotiated_version = SMB_DIRECT_VERSION_LE;
 		resp->reserved = 0;
 		resp->credits_requested =
-				cpu_to_le16(t->send_credit_target);
+				cpu_to_le16(sp->send_credit_target);
 		resp->credits_granted = cpu_to_le16(manage_credits_prior_sending(t));
-		resp->max_readwrite_size = cpu_to_le32(t->max_rdma_rw_size);
-		resp->preferred_send_size = cpu_to_le32(t->max_send_size);
-		resp->max_receive_size = cpu_to_le32(t->max_recv_size);
+		resp->max_readwrite_size = cpu_to_le32(sp->max_read_write_size);
+		resp->preferred_send_size = cpu_to_le32(sp->max_send_size);
+		resp->max_receive_size = cpu_to_le32(sp->max_recv_size);
 		resp->max_fragmented_size =
-				cpu_to_le32(t->max_fragmented_recv_size);
+				cpu_to_le32(sp->max_fragmented_recv_size);
 	}
 
 	sendmsg->sge[0].addr = ib_dma_map_single(sc->ib.dev,
@@ -1721,6 +1719,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 				  struct ib_qp_cap *cap)
 {
 	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_device *device = sc->ib.dev;
 	int max_send_sges, max_rw_wrs, max_send_wrs;
 	unsigned int max_sge_per_wr, wrs_per_credit;
@@ -1728,10 +1727,10 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	/* need 3 more sge. because a SMB_DIRECT header, SMB2 header,
 	 * SMB2 response could be mapped.
 	 */
-	t->max_send_size = smb_direct_max_send_size;
-	max_send_sges = DIV_ROUND_UP(t->max_send_size, PAGE_SIZE) + 3;
+	sp->max_send_size = smb_direct_max_send_size;
+	max_send_sges = DIV_ROUND_UP(sp->max_send_size, PAGE_SIZE) + 3;
 	if (max_send_sges > SMB_DIRECT_MAX_SEND_SGES) {
-		pr_err("max_send_size %d is too large\n", t->max_send_size);
+		pr_err("max_send_size %d is too large\n", sp->max_send_size);
 		return -EINVAL;
 	}
 
@@ -1742,9 +1741,9 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	 * are needed for MR registration, RDMA R/W, local & remote
 	 * MR invalidation.
 	 */
-	t->max_rdma_rw_size = smb_direct_max_read_write_size;
+	sp->max_read_write_size = smb_direct_max_read_write_size;
 	t->pages_per_rw_credit = smb_direct_get_max_fr_pages(t);
-	t->max_rw_credits = DIV_ROUND_UP(t->max_rdma_rw_size,
+	t->max_rw_credits = DIV_ROUND_UP(sp->max_read_write_size,
 					 (t->pages_per_rw_credit - 1) *
 					 PAGE_SIZE);
 
@@ -1785,20 +1784,20 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	t->recv_credits = 0;
 	t->count_avail_recvmsg = 0;
 
-	t->recv_credit_max = smb_direct_receive_credit_max;
+	sp->recv_credit_max = smb_direct_receive_credit_max;
 	t->recv_credit_target = 10;
 	t->new_recv_credits = 0;
 
-	t->send_credit_target = smb_direct_send_credit_target;
+	sp->send_credit_target = smb_direct_send_credit_target;
 	atomic_set(&t->send_credits, 0);
 	atomic_set(&t->rw_credits, t->max_rw_credits);
 
-	t->max_send_size = smb_direct_max_send_size;
-	t->max_recv_size = smb_direct_max_receive_size;
-	t->max_fragmented_recv_size = smb_direct_max_fragmented_recv_size;
+	sp->max_send_size = smb_direct_max_send_size;
+	sp->max_recv_size = smb_direct_max_receive_size;
+	sp->max_fragmented_recv_size = smb_direct_max_fragmented_recv_size;
 
 	cap->max_send_wr = max_send_wrs;
-	cap->max_recv_wr = t->recv_credit_max;
+	cap->max_recv_wr = sp->recv_credit_max;
 	cap->max_send_sge = max_sge_per_wr;
 	cap->max_recv_sge = SMB_DIRECT_MAX_RECV_SGES;
 	cap->max_inline_data = 0;
@@ -1828,6 +1827,8 @@ static void smb_direct_destroy_pools(struct smb_direct_transport *t)
 
 static int smb_direct_create_pools(struct smb_direct_transport *t)
 {
+	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	char name[80];
 	int i;
 	struct smb_direct_recvmsg *recvmsg;
@@ -1840,7 +1841,7 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 	if (!t->sendmsg_cache)
 		return -ENOMEM;
 
-	t->sendmsg_mempool = mempool_create(t->send_credit_target,
+	t->sendmsg_mempool = mempool_create(sp->send_credit_target,
 					    mempool_alloc_slab, mempool_free_slab,
 					    t->sendmsg_cache);
 	if (!t->sendmsg_mempool)
@@ -1849,20 +1850,20 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 	snprintf(name, sizeof(name), "smb_direct_resp_%p", t);
 	t->recvmsg_cache = kmem_cache_create(name,
 					     sizeof(struct smb_direct_recvmsg) +
-					      t->max_recv_size,
+					     sp->max_recv_size,
 					     0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!t->recvmsg_cache)
 		goto err;
 
 	t->recvmsg_mempool =
-		mempool_create(t->recv_credit_max, mempool_alloc_slab,
+		mempool_create(sp->recv_credit_max, mempool_alloc_slab,
 			       mempool_free_slab, t->recvmsg_cache);
 	if (!t->recvmsg_mempool)
 		goto err;
 
 	INIT_LIST_HEAD(&t->recvmsg_queue);
 
-	for (i = 0; i < t->recv_credit_max; i++) {
+	for (i = 0; i < sp->recv_credit_max; i++) {
 		recvmsg = mempool_alloc(t->recvmsg_mempool, KSMBD_DEFAULT_GFP);
 		if (!recvmsg)
 			goto err;
@@ -1870,7 +1871,7 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 		recvmsg->sge.length = 0;
 		list_add(&recvmsg->list, &t->recvmsg_queue);
 	}
-	t->count_avail_recvmsg = t->recv_credit_max;
+	t->count_avail_recvmsg = sp->recv_credit_max;
 
 	return 0;
 err:
@@ -1882,6 +1883,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 				   struct ib_qp_cap *cap)
 {
 	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int ret;
 	struct ib_qp_init_attr qp_attr;
 	int pages_per_rw;
@@ -1905,7 +1907,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	}
 
 	sc->ib.recv_cq = ib_alloc_cq(sc->ib.dev, t,
-				 t->recv_credit_max, 0, IB_POLL_WORKQUEUE);
+				     sp->recv_credit_max, 0, IB_POLL_WORKQUEUE);
 	if (IS_ERR(sc->ib.recv_cq)) {
 		pr_err("Can't create RDMA recv CQ\n");
 		ret = PTR_ERR(sc->ib.recv_cq);
@@ -1932,7 +1934,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	sc->ib.qp = sc->rdma.cm_id->qp;
 	sc->rdma.cm_id->event_handler = smb_direct_cm_handler;
 
-	pages_per_rw = DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1;
+	pages_per_rw = DIV_ROUND_UP(sp->max_read_write_size, PAGE_SIZE) + 1;
 	if (pages_per_rw > sc->ib.dev->attrs.max_sgl_rd) {
 		ret = ib_mr_pool_init(sc->ib.qp, &sc->ib.qp->rdma_mrs,
 				      t->max_rw_credits, IB_MR_TYPE_MEM_REG,
@@ -1969,6 +1971,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 {
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
 	struct smbdirect_socket *sc = &st->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smb_direct_recvmsg *recvmsg;
 	struct smbdirect_negotiate_req *req;
 	int ret;
@@ -1990,14 +1993,14 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 		goto out;
 
 	req = (struct smbdirect_negotiate_req *)recvmsg->packet;
-	st->max_recv_size = min_t(int, st->max_recv_size,
+	sp->max_recv_size = min_t(int, sp->max_recv_size,
 				  le32_to_cpu(req->preferred_send_size));
-	st->max_send_size = min_t(int, st->max_send_size,
+	sp->max_send_size = min_t(int, sp->max_send_size,
 				  le32_to_cpu(req->max_receive_size));
-	st->max_fragmented_send_size =
+	sp->max_fragmented_send_size =
 		le32_to_cpu(req->max_fragmented_size);
-	st->max_fragmented_recv_size =
-		(st->recv_credit_max * st->max_recv_size) / 2;
+	sp->max_fragmented_recv_size =
+		(sp->recv_credit_max * sp->max_recv_size) / 2;
 
 	ret = smb_direct_send_negotiate_response(st, ret);
 out:
-- 
2.43.0

