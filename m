Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C63223323;
	Fri, 13 Feb 2026 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990611; cv=none; b=Ml8MRf61kKtD6ARNHmG527h3o7+7ajGecJEZudzz8HDYkGETNYFquhgcN9f1RdnWJn3Q5toXF8LUT0U25pPLFVH0bs/aMXfKk+vLwjg2IZk0WFVyMIs9BUgTjFt3IeUZzTNUy9jqf2+IHsFWQo42mKgH4SafxPEpv271JMI5vic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990611; c=relaxed/simple;
	bh=neWX8vEZurJVYRjoC0Zm4prFKBuBGHUX9QsVQU5/82U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJOsGPxFJ3/puWj+/9EyuEaJ4UclZ3dg76+FyPswxbPcBb447AJPDvbXfET2SDz6VNfvdd1cr13AYVRfAIdGKudxSyWOYrrDSq5ffPLQDOadar3FOBbDMZam9MeujrcEeXT6zqjFG6jyaK8rUri7SNLF6MTJTFDN6afIFC0KujQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9CEJoF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9CEJoF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E25C116C6;
	Fri, 13 Feb 2026 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990611;
	bh=neWX8vEZurJVYRjoC0Zm4prFKBuBGHUX9QsVQU5/82U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9CEJoF2eQxuwxkMJg78Zx6xnsrgjbP1OdY2yXMw7z7pwGo1R3urG0SSku+l0AuFI
	 yw5VxBHCb7O+WSHFXIUQt156u/Ca5FLo5vzIYYNT5B3ejQ7Bwhmo+cDGs4doYRV0KZ
	 5d7iofvE3TZJOGoRRC4htSXys09uDrHkr1/x9RSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 21/49] smb: client: introduce and use smbd_{alloc, free}_send_io()
Date: Fri, 13 Feb 2026 14:47:40 +0100
Message-ID: <20260213134709.507934494@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit dc77da0373529d43175984b390106be2d8f03609 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |   87 ++++++++++++++++++++++++++++++----------------
 1 file changed, 58 insertions(+), 29 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -493,10 +493,54 @@ static inline void *smbdirect_recv_io_pa
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
@@ -505,12 +549,8 @@ static void send_done(struct ib_cq *cq,
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
@@ -963,15 +1003,13 @@ static int smbd_post_send_negotiate_req(
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
@@ -983,7 +1021,6 @@ static int smbd_post_send_negotiate_req(
 	packet->max_fragmented_size =
 		cpu_to_le32(sp->max_fragmented_recv_size);
 
-	request->num_sge = 1;
 	request->sge[0].addr = ib_dma_map_single(
 				sc->ib.dev, (void *)packet,
 				sizeof(*packet), DMA_TO_DEVICE);
@@ -991,6 +1028,7 @@ static int smbd_post_send_negotiate_req(
 		rc = -EIO;
 		goto dma_mapping_failed;
 	}
+	request->num_sge = 1;
 
 	request->sge[0].length = sizeof(*packet);
 	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
@@ -1020,13 +1058,11 @@ static int smbd_post_send_negotiate_req(
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
 
@@ -1187,7 +1223,7 @@ static int smbd_post_send_iter(struct sm
 			       int *_remaining_data_length)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int i, rc;
+	int rc;
 	int header_length;
 	int data_length;
 	struct smbdirect_send_io *request;
@@ -1208,13 +1244,12 @@ static int smbd_post_send_iter(struct sm
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
@@ -1292,13 +1327,7 @@ static int smbd_post_send_iter(struct sm
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


