Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81AE25A65B
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744590; cv=none; b=jK8Tm8enXtAuHVKEK+8O0J9HbXzV53cVR0bpDjdBprFFc/SZ4+ubMlkmW9K11Ab30h9zra7Do7Q2soe99ZIGt/6t8OK40pOVx7YNLW+bybMkm6XoEP7jFJt8ocrYX9bo5jc755WKGIm3Zfze6R5k6zRf2XrUHhw37FHWjLbXxis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744590; c=relaxed/simple;
	bh=YTpCyMO5ypLDn+KFYWr4STHjZigC+v9llJZ8bJxKjlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkODBpRdpxxntzwI3crjH3sL7PFTnGi5B5oz7YVV2FPzPjyTYRK0sfFToWcVTAkscV01fgaUpKGA37FlMJ9uco9Dhtx9Z3dULCcDiwZC2Omz3ReoID6KMZYvYtA1i90eb+sFyAfBVREKbhSFk1rfAfstXNy7TARHaHYBRdyu128=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pv5Hh79G; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pv5Hh79G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=+hM/sxpj38gsUiEeGPnkyOdMsaYtPf4EJqmi+YW7ekg=; b=pv5Hh79GhV8BdP7Pl1HafO/awU
	0drbef6HicSWZfSmA4s6iHDoL1l9i4sj86JbP0Xf1EGJzpRMx0g1FR7dclN4H0RI6qXHWS/d5QHMD
	qwczIs6WWygw9HjvZpTP5SIt7GJ4mPOCvQwHYTleVZyiNW4i5wn6EaRog9ixavWxI3tQ+jO5sGTeC
	PvRjyBeI8Nr/vuQlQibKRx4NEgIl4eiXowmqgdPDvoyaWkCRElj5TeCyF7+KMrJc37SYHBLewD8Ee
	8zrtBPtTOsF4/eCYiH4u+NYMvFBderEsyQHgJ/coadsTO6A49saWZryYtaaaYWgPkeQlbbv6Pxydm
	YaSiL85Pk0E6GBa348kkCASAQ/Ab/VyAsUg3umy14Z9c/fQmIgF9YPikvW5msjno5DYerdLt8tX41
	F+Tt8iBWMBDydaBa2W5g991M7xVUj5j94qCF/YaB8Agntld+jFudq9ZoW6kktOkQ8dbY8qprdDXhP
	ZCOdqiR2cGDTcVirvqkfKLCT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6FF-00BcIL-0i;
	Wed, 29 Oct 2025 13:29:45 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 074/127] smb: client: make use of smbdirect_connection_post_recv_io()
Date: Wed, 29 Oct 2025 14:20:52 +0100
Message-ID: <26a2cb57eababef21fdfdce0bfa20f8a449a5c58.1761742839.git.metze@samba.org>
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

The only difference is that smbdirect_connection_post_recv_io()
returns early if the connection is already broken.

And that the error code from ib_dma_mapping_error() (currently only -ENOMEM
is possible) is returned instead of -EIO.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 46 ++-------------------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 60582394ba29..9dfee81396c7 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -23,10 +23,6 @@ const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connec
 	return &sc->parameters;
 }
 
-static int smbd_post_recv(
-		struct smbdirect_socket *sc,
-		struct smbdirect_recv_io *response);
-
 static int smbd_post_send_empty(struct smbdirect_socket *sc);
 
 static void destroy_mr_list(struct smbdirect_socket *sc);
@@ -403,7 +399,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 				break;
 
 			response->first_segment = false;
-			rc = smbd_post_recv(sc, response);
+			rc = smbdirect_connection_post_recv_io(response);
 			if (rc) {
 				log_rdma_recv(ERR,
 					"post_recv failed rc=%d\n", rc);
@@ -1058,44 +1054,6 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	return rc;
 }
 
-/*
- * Post a receive request to the transport
- * The remote peer can only send data when a receive request is posted
- * The interaction is controlled by send/receive credit system
- */
-static int smbd_post_recv(
-		struct smbdirect_socket *sc, struct smbdirect_recv_io *response)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct ib_recv_wr recv_wr;
-	int rc = -EIO;
-
-	response->sge.addr = ib_dma_map_single(
-				sc->ib.dev, response->packet,
-				sp->max_recv_size, DMA_FROM_DEVICE);
-	if (ib_dma_mapping_error(sc->ib.dev, response->sge.addr))
-		return rc;
-
-	response->sge.length = sp->max_recv_size;
-	response->sge.lkey = sc->ib.pd->local_dma_lkey;
-
-	recv_wr.wr_cqe = &response->cqe;
-	recv_wr.next = NULL;
-	recv_wr.sg_list = &response->sge;
-	recv_wr.num_sge = 1;
-
-	rc = ib_post_recv(sc->ib.qp, &recv_wr, NULL);
-	if (rc) {
-		ib_dma_unmap_single(sc->ib.dev, response->sge.addr,
-				    response->sge.length, DMA_FROM_DEVICE);
-		response->sge.length = 0;
-		smbdirect_connection_schedule_disconnect(sc, rc);
-		log_rdma_recv(ERR, "ib_post_recv failed rc=%d\n", rc);
-	}
-
-	return rc;
-}
-
 /* Perform SMBD negotiate according to [MS-SMBD] 3.1.5.2 */
 static int smbd_negotiate(struct smbdirect_socket *sc)
 {
@@ -1107,7 +1065,7 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
 
 	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
-	rc = smbd_post_recv(sc, response);
+	rc = smbdirect_connection_post_recv_io(response);
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
 		       rc, response->sge.addr,
 		       response->sge.length, response->sge.lkey);
-- 
2.43.0

