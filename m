Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41A52C11D3;
	Sun,  1 Mar 2026 01:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329054; cv=none; b=orm4vL5kSgaUj6Zg1sznrnCgTOAnw+ZzSXkVmkxnimvd37kC3ES457F1ja6ykWLUlICvROZusN2wMwk/UiHuJPZ4O2TYBmOiyX6Y8Uet9CNJvjcB4h7bGoeC7IpmhRYaG2jk9EBxpCXD6oUiMm32oTFiaTgjyXbe02AzSrz+hoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329054; c=relaxed/simple;
	bh=AwtIggx69zhCqqYC27/WE47yiBrW1jd9fwIfy9N66dE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PFeoTwz4Ec+RpE+uknG+Y/dlO4FEti/tzFjhc4pd1LrDr92LgJuNVX++L4R5BlsHVuo7NsxndkHWvWJDSpgtQ6I2zH4TtyKehWUWGk9rxcVf8i6ZEPy9Qq0GWkY6893iTbcmgO7zFOvOL3hj8byVeRTY+nXgfG0YfoLfmuyIbj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DyBrE3az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyBrE3az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC987C19425;
	Sun,  1 Mar 2026 01:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329054;
	bh=AwtIggx69zhCqqYC27/WE47yiBrW1jd9fwIfy9N66dE=;
	h=From:To:Cc:Subject:Date:From;
	b=DyBrE3azc7Ab64hhMZS5fbrMTgFLU0upK61kNjyny0NMLHN7riJT/8woiMuW+6glW
	 Z1zy61ifL5W08kSc3S5iyEZ3YmYei7K/9i3x03QV1nnStk6TrAeG+25sVlRcOR+SYc
	 nxe4PfG72Ou5Y9l9gEm3gpXdNBAS4j05WI4M3zr+kTNfIe06KCnCtBrc5bTmeGlrI2
	 eUbX/qSBOomhmRjAKq7qoGyym7ZId57cQNmsJ9BNrmCbCqbCVwDX3dzas3piUWROOp
	 AG1z0aHDo3X+0nh87lPVuoh8D3UtoKA/6M+yntq2BT2V+occQPCpuwvVd9oF072Lfk
	 zAfvwnCNSSfgw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: client: introduce and use smbd_{alloc, free}_send_io()" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:37:32 -0500
Message-ID: <20260301013732.1697772-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From dc77da0373529d43175984b390106be2d8f03609 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:55 +0100
Subject: [PATCH] smb: client: introduce and use smbd_{alloc, free}_send_io()

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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 87 ++++++++++++++++++++++++++-------------
 1 file changed, 58 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 75c0ac9cc65c7..6cb40da7e5897 100644
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
2.51.0




