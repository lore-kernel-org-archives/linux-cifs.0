Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3706230DD2E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094972; cv=none; b=sNujA+XxAoli98qVtJBcg5xIrRDpXOoBSQH4CNuU22GVAgg+yDv2VvMOuV5MDtqZgF2bbcxEX3oAi2lnYbst5yzsL4KbtVEsf6fBcUDKKXIqH3AMM2tTXkUl5/pn+vCncHS6lrieFQMWcOJu9nYj3EnfBgFHoiAtuwT+mfhdf68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094972; c=relaxed/simple;
	bh=kYebc04NUWcewTbK+juoaEYw5zxKsTSw2zYN0Hl78wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlorzL+WA7r/O/O1Kk0oHUHoduZxRYdDIGrpc0F5l/7heif+6wkiXJTXSXYxsjYFdW6TLTBNDYclaFfJoJxtVx/dDouKQjqU/gqVDLRwhKRWITW7ct35e+vuAX1A2ocYPzaLnJD+J3Xs7UdtCdhqGBS8JplDI2ObO1Gkwc243dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=n803GVwZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="n803GVwZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=02PB0ckPBfNzrVb0UHSPqjEfp5N2bfzLjTqRlsZYImU=; b=n803GVwZ+gtPruwBSsAFUaX6cq
	uIfhr5Fy3j6NW2TIlPKxykLSgHlRp5tcqS6JjFp8czjextZei/vva0tLzchFYkboVaLZe8Nx3yaB8
	raFQUT40Oa6F173ZVv3cyZLnyYqRlc+4yakby1T2+7XngCoEOcLym+yUxxwWP0fYR4VcFgYggpTIW
	JvxR9GXTUJchH0l9oONMr8O9VSqY4xWIId35Ofq4w04L1jk+jwi7C4T6FB6fdReNkiEEriqPWYLLx
	YaObzWAEy1RFGZhChDzPUN9DGul3DcIl/PEdy8hphyQeO9WDjV4h9zb5vUxr8hcf2EAdNQrFsykdA
	3uLTDR2Jv+BvnLWSWvcL41YxQ0pxV6jvr3ReRxj+BaWswazFjQygWdZMEIgM6ow1MCwyL2Zf9Kth0
	rl5jgV/lKt5hjya2KkiGN9lJI6tsKCOElyS2FW8ZCPVgsRs6WvyXXC5kD8BRKVLqbU2EhQYcNg21A
	kmLWfdW+dHucqShLUt6BgvHO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxdo-00FfHx-2W;
	Tue, 25 Nov 2025 18:19:53 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 119/145] smb: server: make use of functions from smbdirect_rw.c
Date: Tue, 25 Nov 2025 18:56:05 +0100
Message-ID: <08db88a35aca774f10670df485a867c1fff548a4.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The copied code only got new names, some indentation/formatting changes,
some variable names are changed too.

They also only use struct smbdirect_socket instead of
struct smb_direct_transport.

But the logic is still the same.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 236 ++-------------------------------
 1 file changed, 11 insertions(+), 225 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 84ea45058cb5..a6afa7eefa20 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -253,6 +253,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	sc->ib.poll_ctx = IB_POLL_WORKQUEUE;
 	sc->send_io.mem.gfp_mask = KSMBD_DEFAULT_GFP;
 	sc->recv_io.mem.gfp_mask = KSMBD_DEFAULT_GFP;
+	sc->rw_io.mem.gfp_mask = KSMBD_DEFAULT_GFP;
 	/*
 	 * from here we operate on the copy.
 	 */
@@ -808,23 +809,6 @@ static int wait_for_send_credits(struct smbdirect_socket *sc,
 						 1);
 }
 
-static int wait_for_rw_credits(struct smbdirect_socket *sc, int credits)
-{
-	return smbdirect_socket_wait_for_credits(sc,
-						 SMBDIRECT_SOCKET_CONNECTED,
-						 -ENOTCONN,
-						 &sc->rw_io.credits.wait_queue,
-						 &sc->rw_io.credits.count,
-						 credits);
-}
-
-static int calc_rw_credits(struct smbdirect_socket *sc,
-			   char *buf, unsigned int len)
-{
-	return DIV_ROUND_UP(smbdirect_get_buf_page_count(buf, len),
-			    sc->rw_io.credits.num_pages);
-}
-
 static int smb_direct_create_header(struct smbdirect_socket *sc,
 				    int size, int remaining_data_length,
 				    struct smbdirect_send_io **sendmsg_out)
@@ -890,38 +874,6 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 	return 0;
 }
 
-static int get_sg_list(void *buf, int size, struct scatterlist *sg_list, int nentries)
-{
-	bool high = is_vmalloc_addr(buf);
-	struct page *page;
-	int offset, len;
-	int i = 0;
-
-	if (size <= 0 || nentries < smbdirect_get_buf_page_count(buf, size))
-		return -EINVAL;
-
-	offset = offset_in_page(buf);
-	buf -= offset;
-	while (size > 0) {
-		len = min_t(int, PAGE_SIZE - offset, size);
-		if (high)
-			page = vmalloc_to_page(buf);
-		else
-			page = kmap_to_page(buf);
-
-		if (!sg_list)
-			return -EINVAL;
-		sg_set_page(sg_list, page, len, offset);
-		sg_list = sg_next(sg_list);
-
-		buf += PAGE_SIZE;
-		size -= len;
-		offset = 0;
-		i++;
-	}
-	return i;
-}
-
 static int post_sendmsg(struct smbdirect_socket *sc,
 			struct smbdirect_send_batch *send_ctx,
 			struct smbdirect_send_io *msg)
@@ -1171,185 +1123,16 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	return ret;
 }
 
-static void smb_direct_free_rdma_rw_msg(struct smb_direct_transport *t,
-					struct smbdirect_rw_io *msg,
-					enum dma_data_direction dir)
-{
-	struct smbdirect_socket *sc = &t->socket;
-
-	rdma_rw_ctx_destroy(&msg->rdma_ctx, sc->ib.qp, sc->ib.qp->port,
-			    msg->sgt.sgl, msg->sgt.nents, dir);
-	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
-	kfree(msg);
-}
-
-static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
-			    enum dma_data_direction dir)
-{
-	struct smbdirect_rw_io *msg =
-		container_of(wc->wr_cqe, struct smbdirect_rw_io, cqe);
-	struct smbdirect_socket *sc = msg->socket;
-
-	if (wc->status != IB_WC_SUCCESS) {
-		msg->error = -EIO;
-		pr_err("read/write error. opcode = %d, status = %s(%d)\n",
-		       wc->opcode, ib_wc_status_msg(wc->status), wc->status);
-		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			smbdirect_socket_schedule_cleanup(sc, msg->error);
-	}
-
-	complete(msg->completion);
-}
-
-static void read_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	read_write_done(cq, wc, DMA_FROM_DEVICE);
-}
-
-static void write_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	read_write_done(cq, wc, DMA_TO_DEVICE);
-}
-
-static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
-				void *buf, int buf_len,
-				struct smbdirect_buffer_descriptor_v1 *desc,
-				unsigned int desc_len,
-				bool is_read)
-{
-	struct smbdirect_socket *sc = &t->socket;
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_rw_io *msg, *next_msg;
-	int i, ret;
-	DECLARE_COMPLETION_ONSTACK(completion);
-	struct ib_send_wr *first_wr;
-	LIST_HEAD(msg_list);
-	char *desc_buf;
-	int credits_needed;
-	unsigned int desc_buf_len, desc_num = 0;
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
-		return -ENOTCONN;
-
-	if (buf_len > sp->max_read_write_size)
-		return -EINVAL;
-
-	/* calculate needed credits */
-	credits_needed = 0;
-	desc_buf = buf;
-	for (i = 0; i < desc_len / sizeof(*desc); i++) {
-		if (!buf_len)
-			break;
-
-		desc_buf_len = le32_to_cpu(desc[i].length);
-		if (!desc_buf_len)
-			return -EINVAL;
-
-		if (desc_buf_len > buf_len) {
-			desc_buf_len = buf_len;
-			desc[i].length = cpu_to_le32(desc_buf_len);
-			buf_len = 0;
-		}
-
-		credits_needed += calc_rw_credits(sc, desc_buf, desc_buf_len);
-		desc_buf += desc_buf_len;
-		buf_len -= desc_buf_len;
-		desc_num++;
-	}
-
-	ksmbd_debug(RDMA, "RDMA %s, len %#x, needed credits %#x\n",
-		    str_read_write(is_read), buf_len, credits_needed);
-
-	ret = wait_for_rw_credits(sc, credits_needed);
-	if (ret < 0)
-		return ret;
-
-	/* build rdma_rw_ctx for each descriptor */
-	desc_buf = buf;
-	for (i = 0; i < desc_num; i++) {
-		msg = kzalloc(struct_size(msg, sg_list, SG_CHUNK_SIZE),
-			      KSMBD_DEFAULT_GFP);
-		if (!msg) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		desc_buf_len = le32_to_cpu(desc[i].length);
-
-		msg->socket = sc;
-		msg->cqe.done = is_read ? read_done : write_done;
-		msg->completion = &completion;
-
-		msg->sgt.sgl = &msg->sg_list[0];
-		ret = sg_alloc_table_chained(&msg->sgt,
-					     smbdirect_get_buf_page_count(desc_buf, desc_buf_len),
-					     msg->sg_list, SG_CHUNK_SIZE);
-		if (ret) {
-			ret = -ENOMEM;
-			goto free_msg;
-		}
-
-		ret = get_sg_list(desc_buf, desc_buf_len,
-				  msg->sgt.sgl, msg->sgt.orig_nents);
-		if (ret < 0)
-			goto free_table;
-
-		ret = rdma_rw_ctx_init(&msg->rdma_ctx, sc->ib.qp, sc->ib.qp->port,
-				       msg->sgt.sgl,
-				       smbdirect_get_buf_page_count(desc_buf, desc_buf_len),
-				       0,
-				       le64_to_cpu(desc[i].offset),
-				       le32_to_cpu(desc[i].token),
-				       is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
-		if (ret < 0) {
-			pr_err("failed to init rdma_rw_ctx: %d\n", ret);
-			goto free_table;
-		}
-
-		list_add_tail(&msg->list, &msg_list);
-		desc_buf += desc_buf_len;
-	}
-
-	/* concatenate work requests of rdma_rw_ctxs */
-	first_wr = NULL;
-	list_for_each_entry_reverse(msg, &msg_list, list) {
-		first_wr = rdma_rw_ctx_wrs(&msg->rdma_ctx, sc->ib.qp, sc->ib.qp->port,
-					   &msg->cqe, first_wr);
-	}
-
-	ret = ib_post_send(sc->ib.qp, first_wr, NULL);
-	if (ret) {
-		pr_err("failed to post send wr for RDMA R/W: %d\n", ret);
-		goto out;
-	}
-
-	msg = list_last_entry(&msg_list, struct smbdirect_rw_io, list);
-	wait_for_completion(&completion);
-	ret = msg->error;
-out:
-	list_for_each_entry_safe(msg, next_msg, &msg_list, list) {
-		list_del(&msg->list);
-		smb_direct_free_rdma_rw_msg(t, msg,
-					    is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	}
-	atomic_add(credits_needed, &sc->rw_io.credits.count);
-	wake_up(&sc->rw_io.credits.wait_queue);
-	return ret;
-
-free_table:
-	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
-free_msg:
-	kfree(msg);
-	goto out;
-}
-
 static int smb_direct_rdma_write(struct ksmbd_transport *t,
 				 void *buf, unsigned int buflen,
 				 struct smbdirect_buffer_descriptor_v1 *desc,
 				 unsigned int desc_len)
 {
-	return smb_direct_rdma_xmit(SMBD_TRANS(t), buf, buflen,
-				    desc, desc_len, false);
+	struct smb_direct_transport *st = SMBD_TRANS(t);
+	struct smbdirect_socket *sc = &st->socket;
+
+	return smbdirect_connection_rdma_xmit(sc, buf, buflen,
+					      desc, desc_len, false);
 }
 
 static int smb_direct_rdma_read(struct ksmbd_transport *t,
@@ -1357,8 +1140,11 @@ static int smb_direct_rdma_read(struct ksmbd_transport *t,
 				struct smbdirect_buffer_descriptor_v1 *desc,
 				unsigned int desc_len)
 {
-	return smb_direct_rdma_xmit(SMBD_TRANS(t), buf, buflen,
-				    desc, desc_len, true);
+	struct smb_direct_transport *st = SMBD_TRANS(t);
+	struct smbdirect_socket *sc = &st->socket;
+
+	return smbdirect_connection_rdma_xmit(sc, buf, buflen,
+					      desc, desc_len, true);
 }
 
 static void smb_direct_disconnect(struct ksmbd_transport *t)
-- 
2.43.0

