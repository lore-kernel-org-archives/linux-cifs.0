Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56C824DD17
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744544; cv=none; b=pPmhk5QnbBOpnd83o2pmiYJPukDhzCZc7CA/PQR26g4dPw9sw4uUhO6cBY0himAl+sDHHeG4/8yTZpF8TLewvtnUcao+rlnASiCG1+Gt/Xea0LXIODONcSXQqBJcUasmnLrYtMcA2hATEP0jwvmKzqoznhwC5yCtmWNdG2WIa2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744544; c=relaxed/simple;
	bh=7+D7pcvIUa5Gu4vRCIlaZZ4fjYko8GSdKm4VsZHke2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwK6Hp4HqnIcNkVF4cWOi8vuIL0JaoZQQCYfQqegEOwbf3uWpzq5k1KapX37MyKS5aLEps3r34gWL6+vLbPeyt2JOejQN2Koy4ebXCuCRSS2fEMPvzo0JRDmNESSBb0enEtBMAaRQ+9JMhEpd1n8T7KCIJGCljCwrRjVYvqXaB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ifo0Z/ly; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ifo0Z/ly"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=7ubsP+SWHfRC2bI9lCg3c2d7FSEDuWknQuvsHJZhbFw=; b=ifo0Z/lyfZ5cYUSR+bhvzRW5Mt
	TIFTdzfTLP+mDTXF8Qb4k6JrfIfaYXgszHLg3/ufDKwnjDLAf3gNry1si9crQfdYSNkoAuKEDwjEj
	tG6vUHSNluBdMdITwncluY5n0n5Ngf6OVkmbBoKrb9KwqYUydzOfrNeDUOzTCSbf/dLQ9ihCeD0sA
	t+Obw16a04tPIjwVfHgRIRU6Lr9n/Ae8f3LzMvYsvKN0R9YezJy6gePAmHvkcpRIA7wnEQB9pyTGI
	FhBmHS7ZkTcwY900Ho/0EdsACv1RnJ/Ed4eSpWlLJEsQuAZmhPo5trzb+/C/GoGAjXDOiO3c8dQNE
	BzHlkSjbqGiqe/mIu8UpYjFLOatGEo4iy8lbYSjAiytBos3GXIsMKgNxeM4YkuB8a9909K7Hszves
	cpl6UXp2YWly9XLZZeAG0Xy0VyJu4+xLr6i+iPqH5V+16lSLcWW7tuUxxLI+1DC8O61NVFXjjbkH/
	iA12d1Wl1Qp94CXpM2M5wv9L;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6EU-00BcB5-0H;
	Wed, 29 Oct 2025 13:28:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 066/127] smb: client: make use of smbdirect_connection_{alloc,free}_send_io()
Date: Wed, 29 Oct 2025 14:20:44 +0100
Message-ID: <d9892df7ea6e7f2ebcbb2ab92863ca087d510a77.1761742839.git.metze@samba.org>
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
index ab8ce4c46bd6..1eed0686a34d 100644
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
@@ -835,15 +830,13 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
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
@@ -855,7 +848,6 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	packet->max_fragmented_size =
 		cpu_to_le32(sp->max_fragmented_recv_size);
 
-	request->num_sge = 1;
 	request->sge[0].addr = ib_dma_map_single(
 				sc->ib.dev, (void *)packet,
 				sizeof(*packet), DMA_TO_DEVICE);
@@ -866,6 +858,7 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 
 	request->sge[0].length = sizeof(*packet);
 	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
+	request->num_sge = 1;
 
 	ib_dma_sync_single_for_device(
 		sc->ib.dev, request->sge[0].addr,
@@ -892,13 +885,11 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	/* if we reach here, post send failed */
 	log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
 	atomic_dec(&sc->send_io.pending.count);
-	ib_dma_unmap_single(sc->ib.dev, request->sge[0].addr,
-		request->sge[0].length, DMA_TO_DEVICE);
 
 	smbdirect_connection_schedule_disconnect(sc, rc);
 
 dma_mapping_failed:
-	mempool_free(request, sc->send_io.mem.pool);
+	smbdirect_connection_free_send_io(request);
 	return rc;
 }
 
@@ -996,7 +987,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			       int *_remaining_data_length)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int i, rc;
+	int rc;
 	int header_length;
 	int data_length;
 	struct smbdirect_send_io *request;
@@ -1039,13 +1030,12 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
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
@@ -1135,13 +1125,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
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

