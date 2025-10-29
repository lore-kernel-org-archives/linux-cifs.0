Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BFC2877D0
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744349; cv=none; b=fQ66xni1S9TtWgpN57QunJgc3UZRYtRkr9or/9r5lFIWhmr6hKIdJYWl6B/4+WFCVfVvFi3onQcHEuNw+fTxLNTjExROJVBIxXrY1jtpuFZQBjTDf2xHCmJJ48TUv6hccWQpMbvh1PXZCBbJZJ3h0BoVWe1MPPMw6TgSM1uVdpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744349; c=relaxed/simple;
	bh=vBUahATFbNLXoEA33yRNGJJXrSuIIug7pZkQBpK6UsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRCsnDCMzxYz3KZfSRRxYnQpUQCjrQghkAWuZlr5v6pZnTWSxPHIhQ5/eQzr9AihGGdnuBNgx7ZG/0ho7r9tUNUWCIFEt7XMIBpXGvckqsgdIJ4svzdWRW7oXvtmc796K9MElF/eMazAmwLtoraBhSvGQJG4Der/1JlD2wLjBOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VdclBOyi; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VdclBOyi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=28D6orzukcizWytuTeSTWaYI28PiLw7fuK4rETH6Y+Q=; b=VdclBOyi5j3bQLRh4Hx3kLDIDr
	LqjAQ8ukfnGOwCKgvIQnsmzOGWY+cZdQlyFE6XV0r98CzzWJRLmUU+Dgw9VzsL6h7L/BHOrEp7v6+
	Qx1WMhaove+JRRc1sG4oN2mXUIFqoCLM9MWGSCITvFIogVuj5DpfNItgvpD27bpav06X9uBP399xB
	UMksaWFsgINJNf5kg9uTxmiZkZfB7tXATSdpuRrD8DCjbG+b1oBJKugVD5mb3GYBwD7xFi5HxABie
	9jxRdNvJZu8b4COPuMf4lm1AHBD2tuSRcjx6PVSCGewl+xG7FXsBOCJuYBgRCmiBrvQCSMTvFch55
	PP3RaoHORzPgRg17t9E3VsI9wr05zvOEBN5p3cZjQ0XZn4TJz1OL43M1DDoYcmHry59c3oJgvLHEh
	yHMiUKJQqhA3FtlXoNTLi3eXlhGhstdw7pNya73OgOB96FU2ihdnohuqA2wKxivLxxPvnyD+eQWV4
	tThHH/ZzX6uF/wV/GDb9lTky;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6BJ-00Bbeg-1O;
	Wed, 29 Oct 2025 13:25:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 032/127] smb: smbdirect: introduce smbdirect_rw.c with server rw code
Date: Wed, 29 Oct 2025 14:20:10 +0100
Message-ID: <da8140b0f70e63b3c1306d778250d747032f264c.1761742839.git.metze@samba.org>
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

This is basically contains the following functions copied from
the server: wait_for_rw_credits, calc_rw_credits, get_sg_list,
smb_direct_free_rdma_rw_msg, read_write_done, read_done,
write_done, smb_direct_rdma_xmit.

They got new names, some indentation/formatting changes,
some variable names are changed too.

They also only use struct smbdirect_socket instead of
struct smb_direct_transport.

But the logic is still the same. They will be used
by the server soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_all_c_files.c  |   1 +
 fs/smb/common/smbdirect/smbdirect_rw.c        | 253 ++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_socket.h    |   9 +
 3 files changed, 263 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_rw.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
index 15022ca39815..3423330465ae 100644
--- a/fs/smb/common/smbdirect/smbdirect_all_c_files.c
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -17,3 +17,4 @@
 #endif
 #include "smbdirect_connection.c"
 #include "smbdirect_mr.c"
+#include "smbdirect_rw.c"
diff --git a/fs/smb/common/smbdirect/smbdirect_rw.c b/fs/smb/common/smbdirect/smbdirect_rw.c
new file mode 100644
index 000000000000..2f6a1e34e665
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_rw.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *   Copyright (C) 2018, LG Electronics.
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+#include "smbdirect_internal.h"
+
+static int smbdirect_connection_wait_for_rw_credits(struct smbdirect_socket *sc,
+						    int credits)
+{
+	return smbdirect_connection_wait_for_credits(sc,
+						     &sc->rw_io.credits.wait_queue,
+						     &sc->rw_io.credits.count,
+						     credits);
+}
+
+static int smbdirect_connection_calc_rw_credits(struct smbdirect_socket *sc,
+						const void *buf,
+						size_t len)
+{
+	return DIV_ROUND_UP(smbdirect_get_buf_page_count(buf, len),
+			    sc->rw_io.credits.num_pages);
+}
+
+static int smbdirect_connection_rdma_get_sg_list(void *buf,
+						 size_t size,
+						 struct scatterlist *sg_list,
+						 size_t nentries)
+{
+	bool high = is_vmalloc_addr(buf);
+	struct page *page;
+	size_t offset, len;
+	int i = 0;
+
+	if (size == 0 || nentries < smbdirect_get_buf_page_count(buf, size))
+		return -EINVAL;
+
+	offset = offset_in_page(buf);
+	buf -= offset;
+	while (size > 0) {
+		len = min_t(size_t, PAGE_SIZE - offset, size);
+		if (high)
+			page = vmalloc_to_page(buf);
+		else
+			page = kmap_to_page(buf);
+
+		if (!sg_list)
+			return -EINVAL;
+		sg_set_page(sg_list, page, len, offset);
+		sg_list = sg_next(sg_list);
+
+		buf += PAGE_SIZE;
+		size -= len;
+		offset = 0;
+		i++;
+	}
+
+	return i;
+}
+
+static void smbdirect_connection_rw_io_free(struct smbdirect_rw_io *msg,
+					    enum dma_data_direction dir)
+{
+	struct smbdirect_socket *sc = msg->socket;
+
+	rdma_rw_ctx_destroy(&msg->rdma_ctx,
+			    sc->ib.qp,
+			    sc->ib.qp->port,
+			    msg->sgt.sgl,
+			    msg->sgt.nents,
+			    dir);
+	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+	kfree(msg);
+}
+
+static void smbdirect_connection_rdma_rw_done(struct ib_cq *cq, struct ib_wc *wc,
+					      enum dma_data_direction dir)
+{
+	struct smbdirect_rw_io *msg =
+		container_of(wc->wr_cqe, struct smbdirect_rw_io, cqe);
+	struct smbdirect_socket *sc = msg->socket;
+
+	if (wc->status != IB_WC_SUCCESS) {
+		msg->error = -EIO;
+		pr_err("read/write error. opcode = %d, status = %s(%d)\n",
+		       wc->opcode, ib_wc_status_msg(wc->status), wc->status);
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			smbdirect_connection_schedule_disconnect(sc, msg->error);
+	}
+
+	complete(msg->completion);
+}
+
+static void smbdirect_connection_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	smbdirect_connection_rdma_rw_done(cq, wc, DMA_FROM_DEVICE);
+}
+
+static void smbdirect_connection_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	smbdirect_connection_rdma_rw_done(cq, wc, DMA_TO_DEVICE);
+}
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
+					  void *buf, size_t buf_len,
+					  struct smbdirect_buffer_descriptor_v1 *desc,
+					  size_t desc_len,
+					  bool is_read)
+{
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	enum dma_data_direction direction = is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	struct smbdirect_rw_io *msg, *next_msg;
+	size_t i;
+	int ret;
+	DECLARE_COMPLETION_ONSTACK(completion);
+	struct ib_send_wr *first_wr;
+	LIST_HEAD(msg_list);
+	u8 *desc_buf;
+	int credits_needed;
+	size_t desc_buf_len, desc_num = 0;
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+		return -ENOTCONN;
+
+	if (buf_len > sp->max_read_write_size)
+		return -EINVAL;
+
+	/* calculate needed credits */
+	credits_needed = 0;
+	desc_buf = buf;
+	for (i = 0; i < desc_len / sizeof(*desc); i++) {
+		if (!buf_len)
+			break;
+
+		desc_buf_len = le32_to_cpu(desc[i].length);
+		if (!desc_buf_len)
+			return -EINVAL;
+
+		if (desc_buf_len > buf_len) {
+			desc_buf_len = buf_len;
+			desc[i].length = cpu_to_le32(desc_buf_len);
+			buf_len = 0;
+		}
+
+		credits_needed += smbdirect_connection_calc_rw_credits(sc,
+								       desc_buf,
+								       desc_buf_len);
+		desc_buf += desc_buf_len;
+		buf_len -= desc_buf_len;
+		desc_num++;
+	}
+
+	smbdirect_log_rdma_rw(sc, SMBDIRECT_LOG_INFO,
+		"RDMA %s, len %zu, needed credits %d\n",
+		str_read_write(is_read), buf_len, credits_needed);
+
+	ret = smbdirect_connection_wait_for_rw_credits(sc, credits_needed);
+	if (ret < 0)
+		return ret;
+
+	/* build rdma_rw_ctx for each descriptor */
+	desc_buf = buf;
+	for (i = 0; i < desc_num; i++) {
+		size_t page_count;
+
+		msg = kzalloc(struct_size(msg, sg_list, SG_CHUNK_SIZE),
+			      sc->rw_io.mem.gfp_mask);
+		if (!msg) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		desc_buf_len = le32_to_cpu(desc[i].length);
+		page_count = smbdirect_get_buf_page_count(desc_buf, desc_buf_len);
+
+		msg->socket = sc;
+		msg->cqe.done = is_read ?
+			smbdirect_connection_rdma_read_done :
+			smbdirect_connection_rdma_write_done;
+		msg->completion = &completion;
+
+		msg->sgt.sgl = &msg->sg_list[0];
+		ret = sg_alloc_table_chained(&msg->sgt,
+					     page_count,
+					     msg->sg_list,
+					     SG_CHUNK_SIZE);
+		if (ret) {
+			ret = -ENOMEM;
+			goto free_msg;
+		}
+
+		ret = smbdirect_connection_rdma_get_sg_list(desc_buf,
+							    desc_buf_len,
+							    msg->sgt.sgl,
+							    msg->sgt.orig_nents);
+		if (ret < 0)
+			goto free_table;
+
+		ret = rdma_rw_ctx_init(&msg->rdma_ctx,
+				       sc->ib.qp,
+				       sc->ib.qp->port,
+				       msg->sgt.sgl,
+				       page_count,
+				       0,
+				       le64_to_cpu(desc[i].offset),
+				       le32_to_cpu(desc[i].token),
+				       direction);
+		if (ret < 0) {
+			pr_err("failed to init rdma_rw_ctx: %d\n", ret);
+			goto free_table;
+		}
+
+		list_add_tail(&msg->list, &msg_list);
+		desc_buf += desc_buf_len;
+	}
+
+	/* concatenate work requests of rdma_rw_ctxs */
+	first_wr = NULL;
+	list_for_each_entry_reverse(msg, &msg_list, list) {
+		first_wr = rdma_rw_ctx_wrs(&msg->rdma_ctx,
+					   sc->ib.qp,
+					   sc->ib.qp->port,
+					   &msg->cqe,
+					   first_wr);
+	}
+
+	ret = ib_post_send(sc->ib.qp, first_wr, NULL);
+	if (ret) {
+		pr_err("failed to post send wr for RDMA R/W: %d\n", ret);
+		goto out;
+	}
+
+	msg = list_last_entry(&msg_list, struct smbdirect_rw_io, list);
+	wait_for_completion(&completion);
+	ret = msg->error;
+out:
+	list_for_each_entry_safe(msg, next_msg, &msg_list, list) {
+		list_del(&msg->list);
+		smbdirect_connection_rw_io_free(msg, direction);
+	}
+	atomic_add(credits_needed, &sc->rw_io.credits.count);
+	wake_up(&sc->rw_io.credits.wait_queue);
+	return ret;
+
+free_table:
+	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+free_msg:
+	kfree(msg);
+	goto out;
+}
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 983e08c8d2ee..14c5d8503fca 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -306,6 +306,14 @@ struct smbdirect_socket {
 	 * The state for RDMA read/write requests on the server
 	 */
 	struct {
+		/*
+		 * Memory hints for
+		 * smbdirect_rw_io structs
+		 */
+		struct {
+			gfp_t gfp_mask;
+		} mem;
+
 		/*
 		 * The credit state for the send side
 		 */
@@ -511,6 +519,7 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	spin_lock_init(&sc->recv_io.reassembly.lock);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
 
+	sc->rw_io.mem.gfp_mask = GFP_KERNEL;
 	atomic_set(&sc->rw_io.credits.count, 0);
 	init_waitqueue_head(&sc->rw_io.credits.wait_queue);
 
-- 
2.43.0

