Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D503370E9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744870; cv=none; b=r9KcDKnPXXICN6e3pw1V3alRiCNRxMou+c6n8gtFMlyjtDyl3HzKmV7sVAD1topqhe0TttVcCGsdQHrl8iP6VJWs3n4nHPrD8WfSdAnbR6RN3GBEI8URCHlQO57Go2Us0IURgRbDsPKjVlcIX/Vfx9An4ESdiyj5T9CzGbFuUsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744870; c=relaxed/simple;
	bh=ARjBfZPb9nBpddWBxjPRpJufCNOrJpgaCNLWDBetz/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuyJ2SJjEb77cSetSxYn9F+ONbBt7toLcYbzQNcIJ6M7Zy7HnFCOo8t3Jb97BRcAZIzWovZZHDEWbhRY/4wBnLtm1UzQfkopBqkn2QC9G8Y6qJ7agtHu8SiO9Yc/bgwnQZITSROEv0kCnkRkIvd4icqulIoRc/SQOXH9JUKVjRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NlkUTEmm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NlkUTEmm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Cip7zn16BoxJ/N+wC8tfrTnyb88VXJEJfOYFyFx+afc=; b=NlkUTEmmTWf2jQ3vgzbe05bU7J
	FKBXDcRDmGs6GcDXsDjXd+yTLU0X9DX4ext6oio1BBVEWrXSMNNr5Agpmda9j9Z8wzhyXORg06fFY
	tWBkeUBSFKKwuP529839e+SZALEZqn6nqgwYAch5mHUZ7w07auVztvREqSgvP2bFXd6ayuPkax2Ti
	odEq1N8fMbdu3J4Dp8Xp7o5+w6rdzl6pGS6oI8qfTInS6sJ5RqQb42Nxc+AuEL4WnSgtQ3Z2e841C
	xYoPIorC4G8CyFBiYtTs+F2WV0pCdSsEAlHtnKN4ah05ldWEY2iaOw3k/KBu4dW4QdPw+RVvUET16
	WLvhC9K372ecHjZHjA0nSISkxcQTL0sDEXjLcmAlfnwHk2PxapRQEV+ETnaNDUa7JoUUVB4xNZ/ly
	r5XJa7801/QXTYuh5P2hZIW3LqIS2aPGLftIh27R4AEHfaVqfH2czGncvtzdjszL+gtSv4yeI0SuV
	NWcUPPbuhF13QDLp1EcttelH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Jm-00Bd46-0M;
	Wed, 29 Oct 2025 13:34:26 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 119/127] smb: server: inline smb_direct_create_header() into smb_direct_post_send_data()
Date: Wed, 29 Oct 2025 14:21:37 +0100
Message-ID: <4a807b7b2b4d52014312b96bfaca313c66dd73f1.1761742839.git.metze@samba.org>
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

The point is that ib_dma_map_single() is done first, but
the 'Fill in the packet header' will be done after
smbdirect_map_sges_from_iter().

This will simplify further changes in order to
share common code with the client.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 128 +++++++++++++++------------------
 1 file changed, 57 insertions(+), 71 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 03aedfa92c88..463520e1c07c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -605,73 +605,6 @@ static int wait_for_send_credits(struct smbdirect_socket *sc,
 						     1);
 }
 
-static int smb_direct_create_header(struct smbdirect_socket *sc,
-				    int size, int remaining_data_length,
-				    struct smbdirect_send_io **sendmsg_out)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_send_io *sendmsg;
-	struct smbdirect_data_transfer *packet;
-	u16 new_credits = 0;
-	int header_length;
-	int ret;
-
-	sendmsg = smbdirect_connection_alloc_send_io(sc);
-	if (IS_ERR(sendmsg))
-		return PTR_ERR(sendmsg);
-
-	/* Fill in the packet header */
-	packet = (struct smbdirect_data_transfer *)sendmsg->packet;
-	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
-	new_credits = smbdirect_connection_grant_recv_credits(sc);
-	packet->credits_granted = cpu_to_le16(new_credits);
-
-	packet->flags = 0;
-	if (smbdirect_connection_request_keep_alive(sc))
-		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
-
-	packet->reserved = 0;
-	if (!size)
-		packet->data_offset = 0;
-	else
-		packet->data_offset = cpu_to_le32(24);
-	packet->data_length = cpu_to_le32(size);
-	packet->remaining_data_length = cpu_to_le32(remaining_data_length);
-	packet->padding = 0;
-
-	ksmbd_debug(RDMA,
-		    "credits_requested=%d credits_granted=%d data_offset=%d data_length=%d remaining_data_length=%d\n",
-		    le16_to_cpu(packet->credits_requested),
-		    le16_to_cpu(packet->credits_granted),
-		    le32_to_cpu(packet->data_offset),
-		    le32_to_cpu(packet->data_length),
-		    le32_to_cpu(packet->remaining_data_length));
-
-	/* Map the packet to DMA */
-	header_length = sizeof(struct smbdirect_data_transfer);
-	/* If this is a packet without payload, don't send padding */
-	if (!size)
-		header_length =
-			offsetof(struct smbdirect_data_transfer, padding);
-
-	sendmsg->sge[0].addr = ib_dma_map_single(sc->ib.dev,
-						 (void *)packet,
-						 header_length,
-						 DMA_TO_DEVICE);
-	ret = ib_dma_mapping_error(sc->ib.dev, sendmsg->sge[0].addr);
-	if (ret) {
-		smbdirect_connection_free_send_io(sendmsg);
-		return ret;
-	}
-
-	sendmsg->num_sge = 1;
-	sendmsg->sge[0].length = header_length;
-	sendmsg->sge[0].lkey = sc->ib.pd->local_dma_lkey;
-
-	*sendmsg_out = sendmsg;
-	return 0;
-}
-
 static int post_sendmsg(struct smbdirect_socket *sc,
 			struct smbdirect_send_batch *send_ctx,
 			struct smbdirect_send_io *msg)
@@ -715,11 +648,22 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct iov_iter *iter,
 				     size_t *_remaining_data_length)
 {
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_send_io *msg;
+	struct smbdirect_data_transfer *packet;
+	size_t header_length;
+	u16 new_credits = 0;
 	u32 remaining_data_length = 0;
 	u32 data_length = 0;
 	int ret;
 
+	if (iter) {
+		header_length = sizeof(struct smbdirect_data_transfer);
+	} else {
+		/* If this is a packet without payload, don't send padding */
+		header_length = offsetof(struct smbdirect_data_transfer, padding);
+	}
+
 	ret = wait_for_send_lcredit(sc, send_ctx);
 	if (ret)
 		goto lcredit_failed;
@@ -736,10 +680,24 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 		remaining_data_length = *_remaining_data_length;
 	}
 
-	ret = smb_direct_create_header(sc, data_length, remaining_data_length,
-				       &msg);
+	msg = smbdirect_connection_alloc_send_io(sc);
+	if (IS_ERR(msg)) {
+		ret = PTR_ERR(msg);
+		goto alloc_failed;
+	}
+
+	/* Map the packet to DMA */
+	msg->sge[0].addr = ib_dma_map_single(sc->ib.dev,
+					     msg->packet,
+					     header_length,
+					     DMA_TO_DEVICE);
+	ret = ib_dma_mapping_error(sc->ib.dev, msg->sge[0].addr);
 	if (ret)
-		goto header_failed;
+		goto err;
+
+	msg->sge[0].length = header_length;
+	msg->sge[0].lkey = sc->ib.pd->local_dma_lkey;
+	msg->num_sge = 1;
 
 	if (iter) {
 		struct smbdirect_map_sges extract = {
@@ -761,13 +719,41 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 		msg->num_sge = extract.num_sge;
 	}
 
+	/* Fill in the packet header */
+	packet = (struct smbdirect_data_transfer *)msg->packet;
+	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
+	new_credits = smbdirect_connection_grant_recv_credits(sc);
+	packet->credits_granted = cpu_to_le16(new_credits);
+
+	packet->flags = 0;
+	if (smbdirect_connection_request_keep_alive(sc))
+		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
+
+	packet->reserved = 0;
+	if (!data_length)
+		packet->data_offset = 0;
+	else
+		packet->data_offset = cpu_to_le32(24);
+	packet->data_length = cpu_to_le32(data_length);
+	packet->remaining_data_length = cpu_to_le32(remaining_data_length);
+	packet->padding = 0;
+
+	ksmbd_debug(RDMA,
+		    "credits_req=%u credits_granted=%u flags=0x%x ofs=%u len=%u remaining=%u\n",
+		    le16_to_cpu(packet->credits_requested),
+		    le16_to_cpu(packet->credits_granted),
+		    le16_to_cpu(packet->flags),
+		    le32_to_cpu(packet->data_offset),
+		    le32_to_cpu(packet->data_length),
+		    le32_to_cpu(packet->remaining_data_length));
+
 	ret = post_sendmsg(sc, send_ctx, msg);
 	if (ret)
 		goto err;
 	return 0;
 err:
 	smbdirect_connection_free_send_io(msg);
-header_failed:
+alloc_failed:
 	atomic_inc(&sc->send_io.credits.count);
 credit_failed:
 	atomic_inc(&sc->send_io.lcredits.count);
-- 
2.43.0

