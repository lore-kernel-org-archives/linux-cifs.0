Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7786128C860
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155311; cv=none; b=tz+sVYYCMx1UZLV54uZdzjOYtjd4wz3aWPY52iwjCzd+gQGMgtZluoVkpNw0Fyyi21R7eu7xcjzOWZuxrMMpKc2Eo2dlDCEyfKW0vM98xh6z9gZTD/mVgL25dPhobb1VAwcDTI7vK7Z+XWQ/XVce5EKUO9aXQySEHpyD3fBSaGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155311; c=relaxed/simple;
	bh=UFux9j47PuexrSGil4VzG+nKdVwpe44ifwx2STy3PbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDf3+39iq4AMIubTb29epLqR6Y9GDu+n0iXZd8nhD8+EJ2iRPSAL96K8koo77S5OXqco3lN8HqHOFFSd4drMONDykmmTbQG8tZuTcJbFk7KpwJFxdMDISxxPm5DrXzToLQigrY4Ty89YQ1ATG1JQJauHdy33tquawGjHkYk5rLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WzyVhCAf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WzyVhCAf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Fmv9aIXjD1wMirArxBev7CJVufrxxNZKFI692D0LQNY=; b=WzyVhCAfSIecGdLfDKYdHu0voN
	KA5/prHQCd6tm2zCwTb0XijqQbWjGHUdwOvEn7ZbC4i47vjFz5+vYYhfEKKSDkP945lmWTThp7BbS
	/7GngwItutBu/ogkqrRG+o9XK9HHU2S/ytdXWxEVHOV2WIEl33FduaRl4D+OB058SC6wl12++8cpS
	81WfXk48NmBm5oPTxCq1DQ/WwSSafm5h6gmXFi4DhdwrPos43w0/wuBTwgOV9z9B+N7f2nLN/cTS+
	XniyBGz36/uyn+2xVwXttOHPoditrUWbyQ2H8hX1md8SkUFoMzzZD57D8aJDq/d2KflnoUmRooPE2
	+7rXqhoeDigWkfRplzMcRtG6H7xuv9su/Qm1bjjxeHS4YxLJGtC/FMuAf/zq603JPYUbcqh5Z6HFp
	GQsu0qiNtLMFzQL+hkCbSULuoZtoZqnMyJqsmLXLWig909SmQf/rft0p1xC+6NQIvYvblNL0zp8Ei
	be1hGEFW12KjlY7E1rTU7ndA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeDX-000ltx-2U;
	Mon, 25 Aug 2025 20:55:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 080/142] smb: server: make use of smbdirect_socket->recv_io.expected
Date: Mon, 25 Aug 2025 22:40:41 +0200
Message-ID: <e3ee4ea1061c805c40d32f844c52eaf1d1d19dee.1756139607.git.metze@samba.org>
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

The expected incoming message type can be per connection.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 44 +++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 9f2a0c94988e..2cf6941a643d 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -145,10 +145,6 @@ struct smb_direct_transport {
 #define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
 #define SMBD_TRANS(t)	((struct smb_direct_transport *)container_of(t, \
 				struct smb_direct_transport, transport))
-enum {
-	SMB_DIRECT_MSG_NEGOTIATE_REQ = 0,
-	SMB_DIRECT_MSG_DATA_TRANSFER
-};
 
 static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops;
 
@@ -172,7 +168,6 @@ struct smb_direct_sendmsg {
 struct smb_direct_recvmsg {
 	struct smb_direct_transport	*transport;
 	struct list_head	list;
-	int			type;
 	struct ib_sge		sge;
 	struct ib_cqe		cqe;
 	bool			first_segment;
@@ -472,8 +467,10 @@ static void smb_direct_free_sendmsg(struct smb_direct_transport *t,
 
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
@@ -484,9 +481,9 @@ static int smb_direct_check_recvmsg(struct smb_direct_recvmsg *recvmsg)
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
@@ -506,12 +503,15 @@ static int smb_direct_check_recvmsg(struct smb_direct_recvmsg *recvmsg)
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
@@ -542,8 +542,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	ib_dma_sync_single_for_cpu(wc->qp->device, recvmsg->sge.addr,
 				   recvmsg->sge.length, DMA_FROM_DEVICE);
 
-	switch (recvmsg->type) {
-	case SMB_DIRECT_MSG_NEGOTIATE_REQ:
+	switch (sc->recv_io.expected) {
+	case SMBDIRECT_EXPECT_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
 			put_recvmsg(t, recvmsg);
 			smb_direct_disconnect_rdma_connection(t);
@@ -555,7 +555,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
 		return;
-	case SMB_DIRECT_MSG_DATA_TRANSFER: {
+	case SMBDIRECT_EXPECT_DATA_TRANSFER: {
 		struct smbdirect_data_transfer *data_transfer =
 			(struct smbdirect_data_transfer *)recvmsg->packet;
 		unsigned int data_length;
@@ -620,12 +620,15 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
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
@@ -814,7 +817,6 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 			if (!recvmsg)
 				break;
 
-			recvmsg->type = SMB_DIRECT_MSG_DATA_TRANSFER;
 			recvmsg->first_segment = false;
 
 			ret = smb_direct_post_recv(t, recvmsg);
@@ -1613,6 +1615,8 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 		resp->max_receive_size = cpu_to_le32(sp->max_recv_size);
 		resp->max_fragmented_size =
 				cpu_to_le32(sp->max_fragmented_recv_size);
+
+		sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
 	}
 
 	sendmsg->sge[0].addr = ib_dma_map_single(sc->ib.dev,
@@ -1678,13 +1682,15 @@ static int smb_direct_accept_client(struct smb_direct_transport *t)
 
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

