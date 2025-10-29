Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0DF24E4C3
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744767; cv=none; b=H0K8lsgRjH9RXLbEPYCtM0oqtv9+8YM1rGcFq3S0lB5KsrVcl5Vr5U2MqdI57C3kbvH5IYOIeyhvvKXu/n86TdZ2AYfGYMAao5YDfo2SLlrkwi5JElSp2uQtgQpqbVRCVvIrIluEqbeK6aGSVpxEHO/zoFVav7H8wjkT+IF7XQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744767; c=relaxed/simple;
	bh=pk159mjNu9VDPJAK+RrrKLDBnG5mqjEbugIHBtyisXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hc3mKycD+i/7wDodN+G2XZcPJpvH6mbUgJo9aZudVYgrRVXErEHv84xWrZkoOL8ml3rs6mEi7nwxrTmi/Nq3L8iIydasCvcKs4+cnHdEgJETBZcqLx8TtuqflbyOKJ/Yw+V4MUs6DTSu0T+C7DcmBYdX+6Ehxh9aPXBeIG9yN+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1mPSgIHK; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1mPSgIHK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vOWnZHx5TglcuZpW1gF2v3nGaLKQzim0DMs4bZhlTGs=; b=1mPSgIHKBA9h6o0MnKcRQ5Pkvl
	f+lybn3PiucmkRRok4Z+AeE3kOPamA97pi6idRW0u6BDokl3Ube5RdeZdfcPvld85BnoivWc96hOf
	00doOpuQStoJZA2a6vYNvlemLu8wujLo00XcjCMsKC+00XZpOeGOk4GpGKTc5hyN7XCsR2Hs/liQi
	w02wwOxr5quSdeLPG2dlSyKAR2bmtK6gVEXVHsRw6DxY+WKY4GK+KM0+Yvyve949Nmy31Ct4zDnx7
	pkrAPIXK9vgo26Xw9EEOOz9NNFD8X1kxteXD5ndujW/htJG9LdbzSmPbYEnbEiDGhOiAfb7clYmwg
	JL2ozcyT3YrZrWaX8aRYJ1coMhoQmBwWCZrB5+qHwtnmCulFQMtsnV3OjrlH7VvmiWHy3myd1MI6h
	BB8SRBZRHiHsTodJlwwdq9XHWN5D8Mj4/QJdv3M/z3/RQwZp/+nxSoUVOlaJ5F/jwy8PXLrL4CjLo
	4HH8EZoWq0MntV83Titx4vo9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6I6-00BcmV-1x;
	Wed, 29 Oct 2025 13:32:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 101/127] smb: server: make use of smbdirect_connection_{alloc,free}_send_io()
Date: Wed, 29 Oct 2025 14:21:19 +0100
Message-ID: <a233b459321354d6586e5878104f043068b3efa1.1761742839.git.metze@samba.org>
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

These are basically copies of smb_direct_{alloc,free}_sendmsg() just
a bit simpler and with the gfp_mask mask abstracted.

For now we still use KSMBD_DEFAULT_GFP, which includes
__GFP_RETRY_MAYFAIL.

The only difference is that we use ib_dma_unmap_page() for all sges,
this simplifies the logic and doesn't matter as
ib_dma_unmap_single() and ib_dma_unmap_page() both operate
on dma_addr_t and dma_unmap_single_attrs() is just an
alias for dma_unmap_page_attrs().
We already had such an inconsistency in the client
code where we use ib_dma_unmap_single(), while we mapped
using ib_dma_map_page().

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 58 +++++++---------------------------
 1 file changed, 11 insertions(+), 47 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 7181d9f62b09..50dc87660b25 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -258,6 +258,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	smbdirect_socket_set_logging(sc, NULL,
 				     smb_direct_logging_needed,
 				     smb_direct_logging_vaprintf);
+	sc->send_io.mem.gfp_mask = KSMBD_DEFAULT_GFP;
 	/*
 	 * from here we operate on the copy.
 	 */
@@ -354,43 +355,6 @@ static void free_transport(struct smb_direct_transport *t)
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
 }
 
-static struct smbdirect_send_io
-*smb_direct_alloc_sendmsg(struct smbdirect_socket *sc)
-{
-	struct smbdirect_send_io *msg;
-
-	msg = mempool_alloc(sc->send_io.mem.pool, KSMBD_DEFAULT_GFP);
-	if (!msg)
-		return ERR_PTR(-ENOMEM);
-	msg->socket = sc;
-	INIT_LIST_HEAD(&msg->sibling_list);
-	msg->num_sge = 0;
-	return msg;
-}
-
-static void smb_direct_free_sendmsg(struct smbdirect_socket *sc,
-				    struct smbdirect_send_io *msg)
-{
-	int i;
-
-	/*
-	 * The list needs to be empty!
-	 * The caller should take care of it.
-	 */
-	WARN_ON_ONCE(!list_empty(&msg->sibling_list));
-
-	if (msg->num_sge > 0) {
-		ib_dma_unmap_single(sc->ib.dev,
-				    msg->sge[0].addr, msg->sge[0].length,
-				    DMA_TO_DEVICE);
-		for (i = 1; i < msg->num_sge; i++)
-			ib_dma_unmap_page(sc->ib.dev,
-					  msg->sge[i].addr, msg->sge[i].length,
-					  DMA_TO_DEVICE);
-	}
-	mempool_free(msg, sc->send_io.mem.pool);
-}
-
 static int smb_direct_check_recvmsg(struct smbdirect_recv_io *recvmsg)
 {
 	struct smbdirect_socket *sc = recvmsg->socket;
@@ -780,11 +744,11 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	 */
 	list_for_each_entry_safe(sibling, next, &sendmsg->sibling_list, sibling_list) {
 		list_del_init(&sibling->sibling_list);
-		smb_direct_free_sendmsg(sc, sibling);
+		smbdirect_connection_free_send_io(sibling);
 		lcredits += 1;
 	}
 	/* Note this frees wc->wr_cqe, but not wc */
-	smb_direct_free_sendmsg(sc, sendmsg);
+	smbdirect_connection_free_send_io(sendmsg);
 	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
@@ -907,9 +871,9 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 
 		list_for_each_entry_safe(sibling, next, &last->sibling_list, sibling_list) {
 			list_del_init(&sibling->sibling_list);
-			smb_direct_free_sendmsg(sc, sibling);
+			smbdirect_connection_free_send_io(sibling);
 		}
-		smb_direct_free_sendmsg(sc, last);
+		smbdirect_connection_free_send_io(last);
 	}
 
 	return ret;
@@ -994,7 +958,7 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 	int header_length;
 	int ret;
 
-	sendmsg = smb_direct_alloc_sendmsg(sc);
+	sendmsg = smbdirect_connection_alloc_send_io(sc);
 	if (IS_ERR(sendmsg))
 		return PTR_ERR(sendmsg);
 
@@ -1037,7 +1001,7 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 						 DMA_TO_DEVICE);
 	ret = ib_dma_mapping_error(sc->ib.dev, sendmsg->sge[0].addr);
 	if (ret) {
-		smb_direct_free_sendmsg(sc, sendmsg);
+		smbdirect_connection_free_send_io(sendmsg);
 		return ret;
 	}
 
@@ -1193,7 +1157,7 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 		goto err;
 	return 0;
 err:
-	smb_direct_free_sendmsg(sc, msg);
+	smbdirect_connection_free_send_io(msg);
 header_failed:
 	atomic_inc(&sc->send_io.credits.count);
 credit_failed:
@@ -1622,7 +1586,7 @@ static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 	struct smbdirect_negotiate_resp *resp;
 	int ret;
 
-	sendmsg = smb_direct_alloc_sendmsg(sc);
+	sendmsg = smbdirect_connection_alloc_send_io(sc);
 	if (IS_ERR(sendmsg))
 		return -ENOMEM;
 
@@ -1658,7 +1622,7 @@ static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 						 DMA_TO_DEVICE);
 	ret = ib_dma_mapping_error(sc->ib.dev, sendmsg->sge[0].addr);
 	if (ret) {
-		smb_direct_free_sendmsg(sc, sendmsg);
+		smbdirect_connection_free_send_io(sendmsg);
 		return ret;
 	}
 
@@ -1668,7 +1632,7 @@ static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 
 	ret = post_sendmsg(sc, NULL, sendmsg);
 	if (ret) {
-		smb_direct_free_sendmsg(sc, sendmsg);
+		smbdirect_connection_free_send_io(sendmsg);
 		return ret;
 	}
 
-- 
2.43.0

