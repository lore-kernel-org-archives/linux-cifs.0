Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CAA22128B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155368; cv=none; b=P48RyCqkZclJkcGLvynoQTh5N6kWiBydOlh0Azvtr772pPXf4u6L4jNGQESvRlr3UoDQdlieKrHFK/ggm3Knn6fZMr9pl7Xqz/8Q+4giN8NGHPIB3vn79ODul+2xRit2dDvOSEsNZ8Dx6s8MNelLgAirLBEzeKGylYVkor9reJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155368; c=relaxed/simple;
	bh=TKR51UH7PfP2BcTYYaWsrQ3mGsMHRRyBg9G9EaybJiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj3cFrmMJzQoRod2dvMDdNVrTNT9/OtiRXUxPNp01l8MPu5CbZ4VkkFyIeQh727ruqftch5XywnNljr2usGocK9CIqjPlG6vukJ22ujiBqa3gjtJHBp98wGZNclkFFnK3nY+tgGPt/Q0zSZLO1eMLmKQqXekBEnbyA8sm3fi/7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1O62zkIs; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1O62zkIs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=sxL8bGZIIqFvVEdz3z02rtVEBj3kN4JFlIGintwHj+Q=; b=1O62zkIsydvoRKD+eie9BRdGrP
	4B75SvxzFzR5j7AB3jZABemMPe6JY/aaXv5s3VFCMCfrrsnAwF0TEHoagmVxPeU1jFBIdRplax89j
	agB8LDGXYXfDuQDVbU03BKw5cXqi7YPa+ZpmD1gyIfcR5BzG1TNE8CJzfeYs3R0IvldyGIFnaDwv/
	Y5qWL2syn8R6BXKDv8B3SU1g6DaB7aBKLaEThJQ7EnlpsQTdNmL+dZTQ36oxHwhs9QGAoEwA2UAvQ
	DFNixP04E3RD/V7r+lK426pruk++XT3HXlOtlwQYTRkbDSBc3GOTREBt1LD2tx2Vczh5vy70jW3sm
	qOZQqFZqvNvmVzaTl9Nmxkn9oebqwZ43+yWDZcRSSQPGM/CcU3dWTDxJU+3Relb+wEEn2cfNtdWKW
	0PORGkhaNRrcGrOTODy6q1pzZMHttxeYgeS58NiVF1LZUNdySoehqHZht0LJwI0EyRok+Bb5tLo73
	AcXX39Jv1bReqnyhg4Ao5CSP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeET-000m1P-2E;
	Mon, 25 Aug 2025 20:56:03 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 085/142] smb: server: make use of struct smbdirect_send_io
Date: Mon, 25 Aug 2025 22:40:46 +0200
Message-ID: <ce56470b0c68e12580cd91888e5e6de8da51dfe5.1756139607.git.metze@samba.org>
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

This is already used by the client and will allow us
to use common helper functions soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 81 +++++++++++++++-------------------
 1 file changed, 36 insertions(+), 45 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index c56cbd6ab0af..57e1140d488e 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -36,8 +36,6 @@
 /* SMB_DIRECT negotiation timeout in seconds */
 #define SMB_DIRECT_NEGOTIATE_TIMEOUT		120
 
-#define SMB_DIRECT_MAX_SEND_SGES		6
-
 /*
  * Default maximum number of RDMA read/write outstanding on this connection
  * This value is possibly decreased during QP creation on hardware limit
@@ -143,16 +141,6 @@ struct smb_direct_send_ctx {
 	unsigned int		remote_key;
 };
 
-struct smb_direct_sendmsg {
-	struct smb_direct_transport	*transport;
-	struct ib_send_wr	wr;
-	struct list_head	list;
-	int			num_sge;
-	struct ib_sge		sge[SMB_DIRECT_MAX_SEND_SGES];
-	struct ib_cqe		cqe;
-	u8			packet[];
-};
-
 struct smb_direct_rdma_rw_msg {
 	struct smb_direct_transport	*t;
 	struct ib_cqe		cqe;
@@ -418,22 +406,23 @@ static void free_transport(struct smb_direct_transport *t)
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
 }
 
-static struct smb_direct_sendmsg
+static struct smbdirect_send_io
 *smb_direct_alloc_sendmsg(struct smb_direct_transport *t)
 {
-	struct smb_direct_sendmsg *msg;
+	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_send_io *msg;
 
 	msg = mempool_alloc(t->sendmsg_mempool, KSMBD_DEFAULT_GFP);
 	if (!msg)
 		return ERR_PTR(-ENOMEM);
-	msg->transport = t;
-	INIT_LIST_HEAD(&msg->list);
+	msg->socket = sc;
+	INIT_LIST_HEAD(&msg->sibling_list);
 	msg->num_sge = 0;
 	return msg;
 }
 
 static void smb_direct_free_sendmsg(struct smb_direct_transport *t,
-				    struct smb_direct_sendmsg *msg)
+				    struct smbdirect_send_io *msg)
 {
 	struct smbdirect_socket *sc = &t->socket;
 	int i;
@@ -829,12 +818,14 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
 static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct smb_direct_sendmsg *sendmsg, *sibling;
+	struct smbdirect_send_io *sendmsg, *sibling;
 	struct smb_direct_transport *t;
+	struct smbdirect_socket *sc;
 	struct list_head *pos, *prev, *end;
 
-	sendmsg = container_of(wc->wr_cqe, struct smb_direct_sendmsg, cqe);
-	t = sendmsg->transport;
+	sendmsg = container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
+	sc = sendmsg->socket;
+	t = container_of(sc, struct smb_direct_transport, socket);
 
 	ksmbd_debug(RDMA, "Send completed. status='%s (%d)', opcode=%d\n",
 		    ib_wc_status_msg(wc->status), wc->status,
@@ -853,13 +844,13 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	/* iterate and free the list of messages in reverse. the list's head
 	 * is invalid.
 	 */
-	for (pos = &sendmsg->list, prev = pos->prev, end = sendmsg->list.next;
+	for (pos = &sendmsg->sibling_list, prev = pos->prev, end = sendmsg->sibling_list.next;
 	     prev != end; pos = prev, prev = prev->prev) {
-		sibling = container_of(pos, struct smb_direct_sendmsg, list);
+		sibling = container_of(pos, struct smbdirect_send_io, sibling_list);
 		smb_direct_free_sendmsg(t, sibling);
 	}
 
-	sibling = container_of(pos, struct smb_direct_sendmsg, list);
+	sibling = container_of(pos, struct smbdirect_send_io, sibling_list);
 	smb_direct_free_sendmsg(t, sibling);
 }
 
@@ -907,18 +898,18 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 				      struct smb_direct_send_ctx *send_ctx,
 				      bool is_last)
 {
-	struct smb_direct_sendmsg *first, *last;
+	struct smbdirect_send_io *first, *last;
 	int ret;
 
 	if (list_empty(&send_ctx->msg_list))
 		return 0;
 
 	first = list_first_entry(&send_ctx->msg_list,
-				 struct smb_direct_sendmsg,
-				 list);
+				 struct smbdirect_send_io,
+				 sibling_list);
 	last = list_last_entry(&send_ctx->msg_list,
-			       struct smb_direct_sendmsg,
-			       list);
+			       struct smbdirect_send_io,
+			       sibling_list);
 
 	last->wr.send_flags = IB_SEND_SIGNALED;
 	last->wr.wr_cqe = &last->cqe;
@@ -936,7 +927,7 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 		atomic_add(send_ctx->wr_cnt, &t->send_credits);
 		wake_up(&t->wait_send_credits);
 		list_for_each_entry_safe(first, last, &send_ctx->msg_list,
-					 list) {
+					 sibling_list) {
 			smb_direct_free_sendmsg(t, first);
 		}
 	}
@@ -995,11 +986,11 @@ static int calc_rw_credits(struct smb_direct_transport *t,
 
 static int smb_direct_create_header(struct smb_direct_transport *t,
 				    int size, int remaining_data_length,
-				    struct smb_direct_sendmsg **sendmsg_out)
+				    struct smbdirect_send_io **sendmsg_out)
 {
 	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smb_direct_sendmsg *sendmsg;
+	struct smbdirect_send_io *sendmsg;
 	struct smbdirect_data_transfer *packet;
 	int header_length;
 	int ret;
@@ -1102,7 +1093,7 @@ static int get_mapped_sg_list(struct ib_device *device, void *buf, int size,
 
 static int post_sendmsg(struct smb_direct_transport *t,
 			struct smb_direct_send_ctx *send_ctx,
-			struct smb_direct_sendmsg *msg)
+			struct smbdirect_send_io *msg)
 {
 	struct smbdirect_socket *sc = &t->socket;
 	int i;
@@ -1122,14 +1113,14 @@ static int post_sendmsg(struct smb_direct_transport *t,
 		msg->wr.wr_cqe = NULL;
 		msg->wr.send_flags = 0;
 		if (!list_empty(&send_ctx->msg_list)) {
-			struct smb_direct_sendmsg *last;
+			struct smbdirect_send_io *last;
 
 			last = list_last_entry(&send_ctx->msg_list,
-					       struct smb_direct_sendmsg,
-					       list);
+					       struct smbdirect_send_io,
+					       sibling_list);
 			last->wr.next = &msg->wr;
 		}
-		list_add_tail(&msg->list, &send_ctx->msg_list);
+		list_add_tail(&msg->sibling_list, &send_ctx->msg_list);
 		send_ctx->wr_cnt++;
 		return 0;
 	}
@@ -1146,9 +1137,9 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 {
 	struct smbdirect_socket *sc = &t->socket;
 	int i, j, ret;
-	struct smb_direct_sendmsg *msg;
+	struct smbdirect_send_io *msg;
 	int data_length;
-	struct scatterlist sg[SMB_DIRECT_MAX_SEND_SGES - 1];
+	struct scatterlist sg[SMBDIRECT_SEND_IO_MAX_SGE - 1];
 
 	ret = wait_for_send_credits(t, send_ctx);
 	if (ret)
@@ -1169,16 +1160,16 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 		struct ib_sge *sge;
 		int sg_cnt;
 
-		sg_init_table(sg, SMB_DIRECT_MAX_SEND_SGES - 1);
+		sg_init_table(sg, SMBDIRECT_SEND_IO_MAX_SGE - 1);
 		sg_cnt = get_mapped_sg_list(sc->ib.dev,
 					    iov[i].iov_base, iov[i].iov_len,
-					    sg, SMB_DIRECT_MAX_SEND_SGES - 1,
+					    sg, SMBDIRECT_SEND_IO_MAX_SGE - 1,
 					    DMA_TO_DEVICE);
 		if (sg_cnt <= 0) {
 			pr_err("failed to map buffer\n");
 			ret = -ENOMEM;
 			goto err;
-		} else if (sg_cnt + msg->num_sge > SMB_DIRECT_MAX_SEND_SGES) {
+		} else if (sg_cnt + msg->num_sge > SMBDIRECT_SEND_IO_MAX_SGE) {
 			pr_err("buffer not fitted into sges\n");
 			ret = -E2BIG;
 			ib_dma_unmap_sg(sc->ib.dev, sg, sg_cnt,
@@ -1572,7 +1563,7 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 {
 	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smb_direct_sendmsg *sendmsg;
+	struct smbdirect_send_io *sendmsg;
 	struct smbdirect_negotiate_resp *resp;
 	int ret;
 
@@ -1720,7 +1711,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	 */
 	sp->max_send_size = smb_direct_max_send_size;
 	max_send_sges = DIV_ROUND_UP(sp->max_send_size, PAGE_SIZE) + 3;
-	if (max_send_sges > SMB_DIRECT_MAX_SEND_SGES) {
+	if (max_send_sges > SMBDIRECT_SEND_IO_MAX_SGE) {
 		pr_err("max_send_size %d is too large\n", sp->max_send_size);
 		return -EINVAL;
 	}
@@ -1824,9 +1815,9 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 	int i;
 	struct smbdirect_recv_io *recvmsg;
 
-	snprintf(name, sizeof(name), "smb_direct_rqst_pool_%p", t);
+	snprintf(name, sizeof(name), "smbdirect_send_io_pool_%p", t);
 	t->sendmsg_cache = kmem_cache_create(name,
-					     sizeof(struct smb_direct_sendmsg) +
+					     sizeof(struct smbdirect_send_io) +
 					      sizeof(struct smbdirect_negotiate_resp),
 					     0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!t->sendmsg_cache)
-- 
2.43.0

