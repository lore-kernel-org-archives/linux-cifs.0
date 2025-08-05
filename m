Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBB0292B25
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410548; cv=none; b=Rjm9tIUl66NP/7wcuUszV6RJzQjuNBH8UNtan2djZyOIlsL91XZdN/erbK1TK0jRyyzDwMgUeYINRuQEbIBWT6qT2x/1bv1BcsW3373a4FDh4bJjs1tSQMTVINaDX7hGFmTUODrkvQu3avrLA+HcYkpMy7oeIhUOBaXEFm/3JmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410548; c=relaxed/simple;
	bh=chVPECEGP2H1bEDH6GU/9mIbdE6LTeAxgCRGiStkrM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu0loTTNIHQigpdxqMrJMHQtEJfMCIx/v8A857lOmBBcaCB1kv1W7fZ6xHMyQiSrGqdxvE5ca2cE3kbiAwF4GrOC2fWrc6ooVMIDcsISf4got9n53MKGmxES9QoCbwKYCeWbESaWIRQuwY5W5XimWlyPGbfgXWzQWcY32+XNkAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UixHu8iq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UixHu8iq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Q8m9AB0Pkg4OME4mAZ4u0V8E66Kn5RWyS7S240vCbLc=; b=UixHu8iqzkZ+iW+Xh+r1F8kJK5
	5IhRJRq3qFKBbZiNdfO+6UT3StTkpzAr51GUip3V3Us8TPMay+9yj9Tw3XK26rN0CW12qhv37N/6V
	nGv86k28c5IIJhrV3j2coPKLwZDXj0DH1KZNPaYHAv507KNK2zDd0toVIzf0MBubC1P2k8oBBBwT4
	aMhk/M9kE7GLfrgTZV6SzVsQpIh4CddB954yl9E9pPzYXnQ20fx+ZGlvt3L+RmZpNPObZsl3R6OpC
	qYcBozmtv3J8LWHrZWCLs8hYRhhMGFvjl8TxayB6iAaZYT/c2QDD2V6l0T64lY1mPcmLo+fhFU7Jt
	dDohbb5co7Skl2wh91uFrBCsUSun6Na2fuo7FUY+aOhy7w1r0njtcPNr0gCiFW+z09aQYJ9L/JbN9
	irChiMXYnsYNYGFEy4HAPrkqahWk1dX8VaohbJYRqlFVwy1MoucE0qVgL8o4L6222TPKHzt2VfQuV
	ZteDVzBf/WIBx46ctjO1pjLn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKKF-001A0L-1G;
	Tue, 05 Aug 2025 16:15:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 14/17] smb: server: make use of smbdirect_socket->recv_io.expected
Date: Tue,  5 Aug 2025 18:13:34 +0200
Message-ID: <ab5d5ef3052b9dde7e0887c44137f374612c893f.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expected incoming message type can be per connection.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 44 +++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index d81f1694a9af..14d338a380a3 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -141,10 +141,6 @@ struct smb_direct_transport {
 #define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
 #define SMBD_TRANS(t)	((struct smb_direct_transport *)container_of(t, \
 				struct smb_direct_transport, transport))
-enum {
-	SMB_DIRECT_MSG_NEGOTIATE_REQ = 0,
-	SMB_DIRECT_MSG_DATA_TRANSFER
-};
 
 static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops;
 
@@ -168,7 +164,6 @@ struct smb_direct_sendmsg {
 struct smb_direct_recvmsg {
 	struct smb_direct_transport	*transport;
 	struct list_head	list;
-	int			type;
 	struct ib_sge		sge;
 	struct ib_cqe		cqe;
 	bool			first_segment;
@@ -465,8 +460,10 @@ static void smb_direct_free_sendmsg(struct smb_direct_transport *t,
 
 static int smb_direct_check_recvmsg(struct smb_direct_recvmsg *recvmsg)
 {
-	switch (recvmsg->type) {
-	case SMB_DIRECT_MSG_DATA_TRANSFER: {
+	struct smbdirect_socket *sc = &recvmsg->transport->socket;
+
+	switch (sc->recv_io.expected) {
+	case SMBDIRECT_EXPECT_DATA_TRANSFER: {
 		struct smbdirect_data_transfer *req =
 			(struct smbdirect_data_transfer *)recvmsg->packet;
 		struct smb2_hdr *hdr = (struct smb2_hdr *)(recvmsg->packet
@@ -477,9 +474,9 @@ static int smb_direct_check_recvmsg(struct smb_direct_recvmsg *recvmsg)
 			    le16_to_cpu(req->credits_requested),
 			    req->data_length, req->remaining_data_length,
 			    hdr->ProtocolId, hdr->Command);
-		break;
+		return 0;
 	}
-	case SMB_DIRECT_MSG_NEGOTIATE_REQ: {
+	case SMBDIRECT_EXPECT_NEGOTIATE_REQ: {
 		struct smbdirect_negotiate_req *req =
 			(struct smbdirect_negotiate_req *)recvmsg->packet;
 		ksmbd_debug(RDMA,
@@ -499,12 +496,15 @@ static int smb_direct_check_recvmsg(struct smb_direct_recvmsg *recvmsg)
 					128 * 1024)
 			return -ECONNABORTED;
 
-		break;
+		return 0;
 	}
-	default:
-		return -EINVAL;
+	case SMBDIRECT_EXPECT_NEGOTIATE_REP:
+		/* client only */
+		break;
 	}
-	return 0;
+
+	/* This is an internal error */
+	return -EINVAL;
 }
 
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -535,8 +535,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	ib_dma_sync_single_for_cpu(wc->qp->device, recvmsg->sge.addr,
 				   recvmsg->sge.length, DMA_FROM_DEVICE);
 
-	switch (recvmsg->type) {
-	case SMB_DIRECT_MSG_NEGOTIATE_REQ:
+	switch (sc->recv_io.expected) {
+	case SMBDIRECT_EXPECT_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
 			put_recvmsg(t, recvmsg);
 			smb_direct_disconnect_rdma_connection(t);
@@ -548,7 +548,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
 		return;
-	case SMB_DIRECT_MSG_DATA_TRANSFER: {
+	case SMBDIRECT_EXPECT_DATA_TRANSFER: {
 		struct smbdirect_data_transfer *data_transfer =
 			(struct smbdirect_data_transfer *)recvmsg->packet;
 		unsigned int data_length;
@@ -613,12 +613,15 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 		return;
 	}
+	case SMBDIRECT_EXPECT_NEGOTIATE_REP:
+		/* client only */
+		break;
 	}
 
 	/*
 	 * This is an internal error!
 	 */
-	WARN_ON_ONCE(recvmsg->type != SMB_DIRECT_MSG_DATA_TRANSFER);
+	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
 	put_recvmsg(t, recvmsg);
 	smb_direct_disconnect_rdma_connection(t);
 }
@@ -807,7 +810,6 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 			if (!recvmsg)
 				break;
 
-			recvmsg->type = SMB_DIRECT_MSG_DATA_TRANSFER;
 			recvmsg->first_segment = false;
 
 			ret = smb_direct_post_recv(t, recvmsg);
@@ -1606,6 +1608,8 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 		resp->max_receive_size = cpu_to_le32(sp->max_recv_size);
 		resp->max_fragmented_size =
 				cpu_to_le32(sp->max_fragmented_recv_size);
+
+		sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
 	}
 
 	sendmsg->sge[0].addr = ib_dma_map_single(sc->ib.dev,
@@ -1671,13 +1675,15 @@ static int smb_direct_accept_client(struct smb_direct_transport *t)
 
 static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	int ret;
 	struct smb_direct_recvmsg *recvmsg;
 
+	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REQ;
+
 	recvmsg = get_free_recvmsg(t);
 	if (!recvmsg)
 		return -ENOMEM;
-	recvmsg->type = SMB_DIRECT_MSG_NEGOTIATE_REQ;
 
 	ret = smb_direct_post_recv(t, recvmsg);
 	if (ret) {
-- 
2.43.0

