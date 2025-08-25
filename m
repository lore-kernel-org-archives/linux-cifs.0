Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1191E89C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155526; cv=none; b=dGHwBnDbVFrIvd22bRFvruHyVaoD5GUIFhVw3NijEh2uAyai/QmOcbrYHj+CE0EHN4lOXc+EFn1T4Puu0zSvU56KHpg6J1JGQwPJ3Y+82x49/7h3vP+rkveQJarr8rHqmuPfz8S+8498s7lBpkGdv/QC2L4Wy80HR96xCUpYcP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155526; c=relaxed/simple;
	bh=mL6lgND0yRXq14nkvpnt8AkNBH8CqV0GCGqyRsHbTtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JELnhl4YKwrVGtRQaxm11UJbThw4+twZf9FN86cOp4ykZCJrE1TgliTlcMQi6b9mTQY3ugT0biuUtdoOnq//Qxn7AM5ui1MPpD4W6PNxi19QXdG0B9ijM3h7ib4fCqk6nk75DDe5ffNBV79S5s6I0GgEZjNzjSenuWTPxUBBkHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xHFDneBj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xHFDneBj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=F2i2yVJ3JEEb2w+H6DOrBgIaraY/eUuM4fBPMj+Xg6k=; b=xHFDneBjf8E2MS45biAWFKplVG
	8jSCUJthwEOg+TA2uQgJODRGXsvxNupcMCYfQRbO5XgzJYNJsRaM/qc/JQxaoIVQdomeA7xjE/3ZC
	ykx19Nwnz9nNuakjG/AGC2qc7CIWwqlUDJnEppla/hfe8nHnQ6stJkJnPaFRgVZ3LQ2aRuL0Y/CnS
	abrZqAtfQsu1NDyD45pFhgPHpobOu7ZvJxJ1x1GTYUl1P0aEPSX3lexzT5Rn6yVFc8lQ5h1kEC/EN
	sZ43UaT6VACPh0xwIQYLoGDK4ijCA/+6xFYnDSKaJdvgZHieDTT35hixM4XRKUnJYwNMsbG1zUXXq
	TeDsg9NtF2axNGT/CchMe3AJSEHSZF31OcNU1foumLmvbKZ7lIkAR3sE4OVy4szFL192hucKWeyvN
	Iyfau9eUhAP9ImgNpCAEoBwyo3cziTh1exU2wUUEX+N+4TfevlhepgLJ9aDL+ShaYFkxpk3uSCkhb
	bBQIOPRQRaRq0Lw1K9y/a4t+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeH4-000mbM-0p;
	Mon, 25 Aug 2025 20:58:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 102/142] smb: server: make use of struct smbdirect_rw_io
Date: Mon, 25 Aug 2025 22:41:03 +0200
Message-ID: <3e213cf04939f452690ac1dc65d8a2685e8fd127.1756139607.git.metze@samba.org>
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

This will allow us to create functions in the common
smbdirect code to be used by the server in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 37 +++++++++++++---------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index f04a3d1d0395..3a0244943dc7 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -113,17 +113,6 @@ struct smb_direct_transport {
 
 static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops;
 
-struct smb_direct_rdma_rw_msg {
-	struct smb_direct_transport	*t;
-	struct ib_cqe		cqe;
-	int			status;
-	struct completion	*completion;
-	struct list_head	list;
-	struct rdma_rw_ctx	rw_ctx;
-	struct sg_table		sgt;
-	struct scatterlist	sg_list[];
-};
-
 void init_smbd_max_io_size(unsigned int sz)
 {
 	sz = clamp_val(sz, SMBD_MIN_IOSIZE, SMBD_MAX_IOSIZE);
@@ -1275,12 +1264,12 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 }
 
 static void smb_direct_free_rdma_rw_msg(struct smb_direct_transport *t,
-					struct smb_direct_rdma_rw_msg *msg,
+					struct smbdirect_rw_io *msg,
 					enum dma_data_direction dir)
 {
 	struct smbdirect_socket *sc = &t->socket;
 
-	rdma_rw_ctx_destroy(&msg->rw_ctx, sc->ib.qp, sc->ib.qp->port,
+	rdma_rw_ctx_destroy(&msg->rdma_ctx, sc->ib.qp, sc->ib.qp->port,
 			    msg->sgt.sgl, msg->sgt.nents, dir);
 	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
 	kfree(msg);
@@ -1289,12 +1278,14 @@ static void smb_direct_free_rdma_rw_msg(struct smb_direct_transport *t,
 static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
 			    enum dma_data_direction dir)
 {
-	struct smb_direct_rdma_rw_msg *msg = container_of(wc->wr_cqe,
-							  struct smb_direct_rdma_rw_msg, cqe);
-	struct smb_direct_transport *t = msg->t;
+	struct smbdirect_rw_io *msg =
+		container_of(wc->wr_cqe, struct smbdirect_rw_io, cqe);
+	struct smbdirect_socket *sc = msg->socket;
+	struct smb_direct_transport *t =
+		container_of(sc, struct smb_direct_transport, socket);
 
 	if (wc->status != IB_WC_SUCCESS) {
-		msg->status = -EIO;
+		msg->error = -EIO;
 		pr_err("read/write error. opcode = %d, status = %s(%d)\n",
 		       wc->opcode, ib_wc_status_msg(wc->status), wc->status);
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
@@ -1322,7 +1313,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 {
 	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smb_direct_rdma_rw_msg *msg, *next_msg;
+	struct smbdirect_rw_io *msg, *next_msg;
 	int i, ret;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct ib_send_wr *first_wr;
@@ -1379,7 +1370,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 
 		desc_buf_len = le32_to_cpu(desc[i].length);
 
-		msg->t = t;
+		msg->socket = sc;
 		msg->cqe.done = is_read ? read_done : write_done;
 		msg->completion = &completion;
 
@@ -1401,7 +1392,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 			goto out;
 		}
 
-		ret = rdma_rw_ctx_init(&msg->rw_ctx, sc->ib.qp, sc->ib.qp->port,
+		ret = rdma_rw_ctx_init(&msg->rdma_ctx, sc->ib.qp, sc->ib.qp->port,
 				       msg->sgt.sgl,
 				       get_buf_page_count(desc_buf, desc_buf_len),
 				       0,
@@ -1422,7 +1413,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	/* concatenate work requests of rdma_rw_ctxs */
 	first_wr = NULL;
 	list_for_each_entry_reverse(msg, &msg_list, list) {
-		first_wr = rdma_rw_ctx_wrs(&msg->rw_ctx, sc->ib.qp, sc->ib.qp->port,
+		first_wr = rdma_rw_ctx_wrs(&msg->rdma_ctx, sc->ib.qp, sc->ib.qp->port,
 					   &msg->cqe, first_wr);
 	}
 
@@ -1432,9 +1423,9 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 		goto out;
 	}
 
-	msg = list_last_entry(&msg_list, struct smb_direct_rdma_rw_msg, list);
+	msg = list_last_entry(&msg_list, struct smbdirect_rw_io, list);
 	wait_for_completion(&completion);
-	ret = msg->status;
+	ret = msg->error;
 out:
 	list_for_each_entry_safe(msg, next_msg, &msg_list, list) {
 		list_del(&msg->list);
-- 
2.43.0

