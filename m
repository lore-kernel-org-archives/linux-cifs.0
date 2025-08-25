Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE2129AB03
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155599; cv=none; b=HvbVsMBh+yXfejpLaHcN1hvAtiFx4SgbO9zeKIbBBMnl6S2G8TlxIi6Ga2sNz+lroeJKk9cm4rRto21OPt1h1XxlD/jFZufoyEd03mvxujh+cd7U89r9Xmr6LuoxOhlXnCpJz+j7TSmn7NFAGEWWwjQUzyasfrMMtPcsbeCaE58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155599; c=relaxed/simple;
	bh=ONWSLw4LZH7WtuQ2prqPF+MUw+P/oOOQ614TFFJu7PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGepZuqBy+x7nto/bQ5YobezIYMQGKiNt25ztsL6zL7t6Jkj8tYVDsDG9eH5stgjqpoz/X5GXd+A2ll+CS5xjwg370aXoHSL2vCDfNV+6qBPLOmB+xctanm8heGSF1W6fhatehgyOcJArLIetKpvPX3FlH2Zf64egKHuvmbRB78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=m6nTAUBM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="m6nTAUBM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nOW0lQkolZ9ttiBZo3H3jq1hdd72asDVQvtMra/Zgqw=; b=m6nTAUBMsnJIzG2GdI2mtf60lD
	voBsSQp4HQWXWTCJQBVArHdcVcffUr4jeovIOmQnNiUDjAwmcx+nlGqdjA3N7121adUNLZ0h0v82G
	wXvpr/bY2BH8aCiDxY5BDYEAb9n+sbpcZFSI/kERvjEP3TpawVsOZSFqIGA/hWVaaIP93oq0JLMwp
	HYWDOVS509F5OcGBqob9yC6s+P6dxmZeFgx/9Gf29XG8atwNkefC8v6ruvlUzYX0qDvN2QrL+o/sK
	721J2UKu/ICV3yVt1fcpSU0wEGMBnarXD1JFGft2Ubr6ugrRYf5G1Y5P0RLEJwGtkFwxpWIeuOnUW
	hJYaNbIWDL+0yZ0mv8OwG6zJEMabpzGe79IbZF0MGADW5SjeFqOhG156qO6ngr0YtbWORLVSjXReh
	ri/7Aq8JBXO3w54+jgRrJnWhNqBqZCv8/dO1whOgLx9qqx3J9iNA2CzwFLzP1ACmTrgrEAoGkwaTw
	eFnaHsKsZ/9BAX4OGCt1fykM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeID-000mpc-1E;
	Mon, 25 Aug 2025 20:59:53 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 109/142] smb: server: fill smbdirect_socket_parameters at the beginning and use the values from there
Date: Mon, 25 Aug 2025 22:41:10 +0200
Message-ID: <033ac1f719517e335fade90b7c6bc476ce259651.1756139607.git.metze@samba.org>
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

This is what we should do and it also simplifies the following changes.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index b65215b4dd76..dfafb4f2218e 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -287,6 +287,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 {
 	struct smb_direct_transport *t;
 	struct smbdirect_socket *sc;
+	struct smbdirect_socket_parameters *sp;
 	struct ksmbd_conn *conn;
 
 	t = kzalloc(sizeof(*t), KSMBD_DEFAULT_GFP);
@@ -294,9 +295,17 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 		return NULL;
 	sc = &t->socket;
 	smbdirect_socket_init(sc);
+	sp = &sc->parameters;
 
 	INIT_WORK(&sc->disconnect_work, smb_direct_disconnect_rdma_work);
 
+	sp->recv_credit_max = smb_direct_receive_credit_max;
+	sp->send_credit_target = smb_direct_send_credit_target;
+	sp->max_send_size = smb_direct_max_send_size;
+	sp->max_fragmented_recv_size = smb_direct_max_fragmented_recv_size;
+	sp->max_recv_size = smb_direct_max_receive_size;
+	sp->max_read_write_size = smb_direct_max_read_write_size;
+
 	sc->rdma.cm_id = cm_id;
 	cm_id->context = t;
 
@@ -1694,7 +1703,6 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	/* need 3 more sge. because a SMB_DIRECT header, SMB2 header,
 	 * SMB2 response could be mapped.
 	 */
-	sp->max_send_size = smb_direct_max_send_size;
 	max_send_sges = DIV_ROUND_UP(sp->max_send_size, PAGE_SIZE) + 3;
 	if (max_send_sges > SMBDIRECT_SEND_IO_MAX_SGE) {
 		pr_err("max_send_size %d is too large\n", sp->max_send_size);
@@ -1708,7 +1716,6 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	 * are needed for MR registration, RDMA R/W, local & remote
 	 * MR invalidation.
 	 */
-	sp->max_read_write_size = smb_direct_max_read_write_size;
 	sc->rw_io.credits.num_pages = smb_direct_get_max_fr_pages(t);
 	sc->rw_io.credits.max = DIV_ROUND_UP(sp->max_read_write_size,
 					 (sc->rw_io.credits.num_pages - 1) *
@@ -1723,20 +1730,20 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 					    max_sge_per_wr) + 1);
 	max_rw_wrs = sc->rw_io.credits.max * wrs_per_credit;
 
-	max_send_wrs = smb_direct_send_credit_target + max_rw_wrs;
+	max_send_wrs = sp->send_credit_target + max_rw_wrs;
 	if (max_send_wrs > device->attrs.max_cqe ||
 	    max_send_wrs > device->attrs.max_qp_wr) {
 		pr_err("consider lowering send_credit_target = %d\n",
-		       smb_direct_send_credit_target);
+		       sp->send_credit_target);
 		pr_err("Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
 		       device->attrs.max_cqe, device->attrs.max_qp_wr);
 		return -EINVAL;
 	}
 
-	if (smb_direct_receive_credit_max > device->attrs.max_cqe ||
-	    smb_direct_receive_credit_max > device->attrs.max_qp_wr) {
+	if (sp->recv_credit_max > device->attrs.max_cqe ||
+	    sp->recv_credit_max > device->attrs.max_qp_wr) {
 		pr_err("consider lowering receive_credit_max = %d\n",
-		       smb_direct_receive_credit_max);
+		       sp->recv_credit_max);
 		pr_err("Possible CQE overrun, device reporting max_cpe %d max_qp_wr %d\n",
 		       device->attrs.max_cqe, device->attrs.max_qp_wr);
 		return -EINVAL;
@@ -1748,16 +1755,10 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 		return -EINVAL;
 	}
 
-	sp->recv_credit_max = smb_direct_receive_credit_max;
 	sc->recv_io.credits.target = 1;
 
-	sp->send_credit_target = smb_direct_send_credit_target;
 	atomic_set(&sc->rw_io.credits.count, sc->rw_io.credits.max);
 
-	sp->max_send_size = smb_direct_max_send_size;
-	sp->max_recv_size = smb_direct_max_receive_size;
-	sp->max_fragmented_recv_size = smb_direct_max_fragmented_recv_size;
-
 	cap->max_send_wr = max_send_wrs;
 	cap->max_recv_wr = sp->recv_credit_max;
 	cap->max_send_sge = max_sge_per_wr;
@@ -1857,7 +1858,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	}
 
 	sc->ib.send_cq = ib_alloc_cq(sc->ib.dev, t,
-				 smb_direct_send_credit_target + cap->max_rdma_ctxs,
+				 sp->send_credit_target + cap->max_rdma_ctxs,
 				 0, IB_POLL_WORKQUEUE);
 	if (IS_ERR(sc->ib.send_cq)) {
 		pr_err("Can't create RDMA send CQ\n");
-- 
2.43.0

