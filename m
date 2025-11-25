Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA03F2512E6
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094146; cv=none; b=lllSoy2G7U+IdSkybBb4E4fTd6uFVSyAXMdKGnRXDf0i9mNHxFviLL8Zz1mA6ql2esWhmx2gOvJzx9fxbUH955Q7FUn/rJUPpkdvXewbIAkYnchGRovlTXjsXr7yWUhlwT0AvIDWN4cgnumCn5oINGPlUWluCvC+WrpcvkP01v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094146; c=relaxed/simple;
	bh=nVSRxXaObOfnF5pcbv6G/hMjQCrhjSmEBG/SBIyn14Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVv3EnRop3Obe8qLPWYAOae9gH7vtFqKWWsqkQYoCUebLw+R79ZBLS9kXU+za2IH9nPN/SQUFPyVv/pPnS3E0KucgFztfxmqw2dSQJ753XrIsqIuK3pDtjiF2wY1CqP69/coITjjfBlNaigf7diT94ZXukA5lOP2GHVgQfIjN14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=SKdTtxWO; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="SKdTtxWO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=JLXYklc2v0OJi/kXWdFh3NFjh1+CGIliGmE46ACE/xU=; b=SKdTtxWOh07A0okDER+X/qT/2G
	wCSK6soMjtoSMKr6GxXoBd254Xi1JchGjhwiVw79DkAehGz7xsVBxCpFv05GyUeKNZTocg1bBXdqu
	ZWcAcoAZebnAVv+2qnV9Ym976+uW5wkrpZzZ5mH0t3nU7AsSijn3DfIexOtfl+/f+TV2tZAtQavev
	nYDePJ+qDjilmMjScinWOyQbI1DnzLQ9qu/ndCYmg6QJOo8GB/dgLoleEUgs6BEgG0N5Q7yST4DRi
	PwVONHd5qlXW/R+Cyp77uecaDymY6n6hRoQP8pis9VOGOqv4cO8/OuLxjvUVu9xyg1W1LVuf6SNyJ
	v2WSPr039SyM/2Sc2wcz6pjY1MoCbcQ985n0qeurm1DMWQmcbAflWENiAIebtIHmpm40f8E3wu2Tg
	Z9xhOZGnwR9FZihdZyNjfMmg9kHg2mAVAUnC2spt6XcthbXtjNBvsoizsn9NBS2VcZaZHhCMz2H6k
	rUdpUwnz+eQ3tX6btFff1AcI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxPY-00FdgV-15;
	Tue, 25 Nov 2025 18:05:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 071/145] smb: client: make use of smbdirect_connection_{alloc,free}_send_io()
Date: Tue, 25 Nov 2025 18:55:17 +0100
Message-ID: <481ffd5c56eef00261c19a9dfc588d8f1fee3a7e.1764091285.git.metze@samba.org>
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

This simplifies the code and allows us to share more code in common
with the server.

The only difference is that we use ib_dma_unmap_page() for all sges,
this simplifies the logic and doesn't matter as
ib_dma_unmap_single() and ib_dma_unmap_page() both operate
on dma_addr_t and dma_unmap_single_attrs() is just an
alias for dma_unmap_page_attrs().

We already had such an inconsistency before
as we called ib_dma_unmap_single(), while we mapped
using ib_dma_map_page() in smb_set_sge().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 42 ++++++++++++---------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 11c72871981d..e1a2238d249a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -390,7 +390,6 @@ static inline void *smbdirect_recv_io_payload(struct smbdirect_recv_io *response
 /* Called when a RDMA send is done */
 static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	int i;
 	struct smbdirect_send_io *request =
 		container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
 	struct smbdirect_socket *sc = request->socket;
@@ -399,12 +398,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
 		request, ib_wc_status_msg(wc->status));
 
-	for (i = 0; i < request->num_sge; i++)
-		ib_dma_unmap_single(sc->ib.dev,
-			request->sge[i].addr,
-			request->sge[i].length,
-			DMA_TO_DEVICE);
-	mempool_free(request, sc->send_io.mem.pool);
+	/* Note this frees wc->wr_cqe, but not wc */
+	smbdirect_connection_free_send_io(request);
 	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
@@ -836,15 +831,13 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_send_wr send_wr;
-	int rc = -ENOMEM;
+	int rc;
 	struct smbdirect_send_io *request;
 	struct smbdirect_negotiate_req *packet;
 
-	request = mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
-	if (!request)
-		return rc;
-
-	request->socket = sc;
+	request = smbdirect_connection_alloc_send_io(sc);
+	if (IS_ERR(request))
+		return PTR_ERR(request);
 
 	packet = smbdirect_send_io_payload(request);
 	packet->min_version = cpu_to_le16(SMBDIRECT_V1);
@@ -856,7 +849,6 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	packet->max_fragmented_size =
 		cpu_to_le32(sp->max_fragmented_recv_size);
 
-	request->num_sge = 1;
 	request->sge[0].addr = ib_dma_map_single(
 				sc->ib.dev, (void *)packet,
 				sizeof(*packet), DMA_TO_DEVICE);
@@ -867,6 +859,7 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 
 	request->sge[0].length = sizeof(*packet);
 	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
+	request->num_sge = 1;
 
 	ib_dma_sync_single_for_device(
 		sc->ib.dev, request->sge[0].addr,
@@ -893,13 +886,11 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	/* if we reach here, post send failed */
 	log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
 	atomic_dec(&sc->send_io.pending.count);
-	ib_dma_unmap_single(sc->ib.dev, request->sge[0].addr,
-		request->sge[0].length, DMA_TO_DEVICE);
 
 	smbdirect_socket_schedule_cleanup(sc, rc);
 
 dma_mapping_failed:
-	mempool_free(request, sc->send_io.mem.pool);
+	smbdirect_connection_free_send_io(request);
 	return rc;
 }
 
@@ -997,7 +988,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			       int *_remaining_data_length)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int i, rc;
+	int rc;
 	int header_length;
 	int data_length;
 	struct smbdirect_send_io *request;
@@ -1040,13 +1031,12 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		goto wait_credit;
 	}
 
-	request = mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
-	if (!request) {
-		rc = -ENOMEM;
+	request = smbdirect_connection_alloc_send_io(sc);
+	if (IS_ERR(request)) {
+		rc = PTR_ERR(request);
 		goto err_alloc;
 	}
 
-	request->socket = sc;
 	memset(request->sge, 0, sizeof(request->sge));
 
 	/* Map the packet to DMA */
@@ -1136,13 +1126,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	wake_up(&sc->send_io.pending.dec_wait_queue);
 
 err_dma:
-	for (i = 0; i < request->num_sge; i++)
-		if (request->sge[i].addr)
-			ib_dma_unmap_single(sc->ib.dev,
-					    request->sge[i].addr,
-					    request->sge[i].length,
-					    DMA_TO_DEVICE);
-	mempool_free(request, sc->send_io.mem.pool);
+	smbdirect_connection_free_send_io(request);
 
 	/* roll back the granted receive credits */
 	atomic_sub(new_credits, &sc->recv_io.credits.count);
-- 
2.43.0

