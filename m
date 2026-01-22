Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2386D389DEC;
	Thu, 22 Jan 2026 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102336; cv=none; b=rKA0ykHRWfWnMJ+rKz0pkj44Mv0K0CrKp+EHhjoKfHuk5nu+H077I3QQJpqOx2v4qO1OVKRTAHGz8qTECJaZUSyyjaMyv+FYumjG31Wyzhg0OzKSmNDN1Goqoy9RQ+VoH+d4GtG5c1QbMGWe2DKmL6OQ+7M4S59z9aCW/QfmDoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102336; c=relaxed/simple;
	bh=+R7A6WAc4fk9mP82elV2wAaSTkeISquc1CclIOyO77E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Usbdw1WwhhRU1mAFXAAaSDPBm3kVo80yf2m0+MFpKUttFpEdj68pfbVhi9uxZ/cvTN7f5XK9PJy0ooVZLEu1p2eJ6U9k4MnwCVPvafvdDOxhOtoXFi7NHh7X6hxF0mjRw6kgREqgRavZ1lDzl7Aa2wiFw/tSZGWcD/+o9MSeKJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OTc76Oyj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OTc76Oyj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=l5CPNYvoBO97msDGXq9JqWSxpj3Rm9FTFcL77FsvIuc=; b=OTc76OyjCSy5ScHkidNhdkJxCD
	vr14Y1VUEDuZtWrk/xtrTiPY7FXwf89xlYpDInSuM96JA+xm3t1H8OefY/OtYpsYjbiMztgeaxdDb
	hBgABNzvPZiSoh7DbPHU6RsQeZ55sQoFrWKnzXlQm6IzimPpvb+aCsWdxl7BWoQEwPeQI9P7zs8Ki
	n5ez8JEfSMUcs+vuqPbNYfSjsJ223xN7xz0VOqMqNCqWaPMx8ueL2j9//iMcrrgDisxzmxR3kL0xQ
	xXqgieddW8G6wxZqCKHtA0GBD5Ldf1mupSeZy7TbCQLDPE0caAxOj2kRTt1YSxpNGCAZoyPEulqEy
	UtuHEY0YkgQTKK5Pv/VceRX4w+vIvqmz/6LX3oQjzEqScRQgQF5azGtHNSxO+XsdSYFqIoTHKwkfP
	f43udoBwmeN9z4ZP0sgNDLjCp2Blr+HfNTejmooXvAOd5EquuRyRNt00VPT448E645QWOfbYh7tsz
	FdlRdWMbedk0S2iT+dXDVLyp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyKK-00000001pw1-2b9F;
	Thu, 22 Jan 2026 17:18:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 15/20] smb: client: introduce and use smbd_{alloc,free}_send_io()
Date: Thu, 22 Jan 2026 18:16:55 +0100
Message-ID: <9958888ffb776d74467accdd546efb7c417c4372.1769101771.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769101771.git.metze@samba.org>
References: <cover.1769101771.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is basically a copy of smb_direct_{alloc,free}_sendmsg()
in the server, with just using ib_dma_unmap_page() in all
cases, which is the same as ib_dma_unmap_single().

We'll use this logic in common code in future.
(I basically backported it from my branch that
as already has everything in common).

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 87 ++++++++++++++++++++++++++-------------
 1 file changed, 58 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 75c0ac9cc65c..6cb40da7e589 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -493,10 +493,54 @@ static inline void *smbdirect_recv_io_payload(struct smbdirect_recv_io *response
 	return (void *)response->packet;
 }
 
+static struct smbdirect_send_io *smbd_alloc_send_io(struct smbdirect_socket *sc)
+{
+	struct smbdirect_send_io *msg;
+
+	msg = mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
+	if (!msg)
+		return ERR_PTR(-ENOMEM);
+	msg->socket = sc;
+	INIT_LIST_HEAD(&msg->sibling_list);
+	msg->num_sge = 0;
+
+	return msg;
+}
+
+static void smbd_free_send_io(struct smbdirect_send_io *msg)
+{
+	struct smbdirect_socket *sc = msg->socket;
+	size_t i;
+
+	/*
+	 * The list needs to be empty!
+	 * The caller should take care of it.
+	 */
+	WARN_ON_ONCE(!list_empty(&msg->sibling_list));
+
+	/*
+	 * Note we call ib_dma_unmap_page(), even if some sges are mapped using
+	 * ib_dma_map_single().
+	 *
+	 * The difference between _single() and _page() only matters for the
+	 * ib_dma_map_*() case.
+	 *
+	 * For the ib_dma_unmap_*() case it does not matter as both take the
+	 * dma_addr_t and dma_unmap_single_attrs() is just an alias to
+	 * dma_unmap_page_attrs().
+	 */
+	for (i = 0; i < msg->num_sge; i++)
+		ib_dma_unmap_page(sc->ib.dev,
+				  msg->sge[i].addr,
+				  msg->sge[i].length,
+				  DMA_TO_DEVICE);
+
+	mempool_free(msg, sc->send_io.mem.pool);
+}
+
 /* Called when a RDMA send is done */
 static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	int i;
 	struct smbdirect_send_io *request =
 		container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
 	struct smbdirect_socket *sc = request->socket;
@@ -505,12 +549,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
 		request, ib_wc_status_msg(wc->status));
 
-	for (i = 0; i < request->num_sge; i++)
-		ib_dma_unmap_single(sc->ib.dev,
-			request->sge[i].addr,
-			request->sge[i].length,
-			DMA_TO_DEVICE);
-	mempool_free(request, sc->send_io.mem.pool);
+	/* Note this frees wc->wr_cqe, but not wc */
+	smbd_free_send_io(request);
 	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
@@ -963,15 +1003,13 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
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
+	request = smbd_alloc_send_io(sc);
+	if (IS_ERR(request))
+		return PTR_ERR(request);
 
 	packet = smbdirect_send_io_payload(request);
 	packet->min_version = cpu_to_le16(SMBDIRECT_V1);
@@ -983,7 +1021,6 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	packet->max_fragmented_size =
 		cpu_to_le32(sp->max_fragmented_recv_size);
 
-	request->num_sge = 1;
 	request->sge[0].addr = ib_dma_map_single(
 				sc->ib.dev, (void *)packet,
 				sizeof(*packet), DMA_TO_DEVICE);
@@ -991,6 +1028,7 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 		rc = -EIO;
 		goto dma_mapping_failed;
 	}
+	request->num_sge = 1;
 
 	request->sge[0].length = sizeof(*packet);
 	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
@@ -1020,13 +1058,11 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	/* if we reach here, post send failed */
 	log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
 	atomic_dec(&sc->send_io.pending.count);
-	ib_dma_unmap_single(sc->ib.dev, request->sge[0].addr,
-		request->sge[0].length, DMA_TO_DEVICE);
 
 	smbd_disconnect_rdma_connection(sc);
 
 dma_mapping_failed:
-	mempool_free(request, sc->send_io.mem.pool);
+	smbd_free_send_io(request);
 	return rc;
 }
 
@@ -1187,7 +1223,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			       int *_remaining_data_length)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int i, rc;
+	int rc;
 	int header_length;
 	int data_length;
 	struct smbdirect_send_io *request;
@@ -1208,13 +1244,12 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		goto err_wait_credit;
 	}
 
-	request = mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
-	if (!request) {
-		rc = -ENOMEM;
+	request = smbd_alloc_send_io(sc);
+	if (IS_ERR(request)) {
+		rc = PTR_ERR(request);
 		goto err_alloc;
 	}
 
-	request->socket = sc;
 	memset(request->sge, 0, sizeof(request->sge));
 
 	/* Map the packet to DMA */
@@ -1292,13 +1327,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		return 0;
 
 err_dma:
-	for (i = 0; i < request->num_sge; i++)
-		if (request->sge[i].addr)
-			ib_dma_unmap_single(sc->ib.dev,
-					    request->sge[i].addr,
-					    request->sge[i].length,
-					    DMA_TO_DEVICE);
-	mempool_free(request, sc->send_io.mem.pool);
+	smbd_free_send_io(request);
 
 err_alloc:
 	atomic_inc(&sc->send_io.credits.count);
-- 
2.43.0

