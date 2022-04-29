Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C11C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Apr 2022 23:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349716AbiD2Xfl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Apr 2022 19:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381834AbiD2Xfi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Apr 2022 19:35:38 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFB9DC5A2
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 16:32:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id fv2so8305773pjb.4
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 16:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nqta/mmVKlBUQGrQ1RMoPWdAv0CpQsJkhaZmCS7s2AA=;
        b=mhMap+m4T4caFKWzXH4qSJuFACCr3U8Crcs3lkOwGbTEE0t+BMg85S/SnXGjGA5sRK
         g710yx80MoOyE1Q4l1ZZrGU5kNx+ryFqZeSMGQD/62u2oT7Vw8Ecu+yG2jVtWjeqkAxJ
         fJDQE8DPLEOUSb1uXYlF+GiTp7/gU13t036WzLC0BrpH32hecnqfDmFpeiU6Wzbygw2i
         24I1sFf7K8p7gW+bcEgf/WawbPx34uCa8JBwtWzwZYb3akOKZ7mizmZyYuSxNaQ2rfzO
         LQVidIThY50X7+7jzo2vHwkUD9BwypHPk6xup6OC4ZLXjWEvrfaYuYa+IzQa3vpizMJz
         miEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nqta/mmVKlBUQGrQ1RMoPWdAv0CpQsJkhaZmCS7s2AA=;
        b=mcWY71Ekxxtpx9V2CTRDR/w2gO2bRF1tW2qpP5mi0HizyHlj67JwWnuIzs2LYiiJdi
         HacOFrOgXT2w5k7pRs0SYgfIjDPICCdStevy9cK1QUCpQQaYvoefw8NwMn2aoeH5hWOs
         c+tgURngDeEjiZzjkvIwrF10x0p1CW4/2yhgDXtpaRfHImvkCIdZR3OnBtXKT+3NqwIc
         T8hkwT/QAgvyCUdhN2gd5nufKGx9xC2RpJFKAdFOE/sGGqSJWlaun+9iXHk+Z0gdmCdd
         oh5P5KZ5fM32QPISAJbcvU0Rh5I7PvUemCVyogMS0N8C69ov1LQN7nD+FfN9WSEJxs7z
         X9Qg==
X-Gm-Message-State: AOAM531wzJ156uN+3P7cP9XwTy1SYfcTEOiFcr8v7lGOaGrBTbEPzBzM
        8ixnD5V1/cq05GgaJhlr4viGlHBCE9g=
X-Google-Smtp-Source: ABdhPJzHoCircYYiZV7VDW00NOIO7rlDontwkF5xylDD2gXeWu1niSRkPH9k8s9N0YeO4sK+q0ZaxA==
X-Received: by 2002:a17:902:a712:b0:158:9e75:686c with SMTP id w18-20020a170902a71200b001589e75686cmr1720306plq.56.1651275133968;
        Fri, 29 Apr 2022 16:32:13 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id h9-20020a62b409000000b0050dc7628180sm230227pfn.90.2022.04.29.16.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 16:32:13 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v4 5/5] ksmbd: smbd: handle multiple Buffer descriptors
Date:   Sat, 30 Apr 2022 08:30:29 +0900
Message-Id: <20220429233029.42741-5-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429233029.42741-1-hyc.lee@gmail.com>
References: <20220429233029.42741-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make ksmbd handle multiple buffer descriptors
when reading and writing files using SMB direct:
Post the work requests of rdma_rw_ctx for
RDMA read/write in smb_direct_rdma_xmit(), and
the work request for the READ/WRITE response
with a remote invalidation in smb_direct_writev().

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
changes from v2:
 - Split a v2 patch to 4 patches.
changes from v3:
 - Remove the unnecessary if condition in smb_direct_free_rdma_rw_msg().
 - Check the non-zero return value from get_sg_list().

 fs/ksmbd/smb2pdu.c        |   5 +-
 fs/ksmbd/transport_rdma.c | 164 ++++++++++++++++++++++++--------------
 2 files changed, 107 insertions(+), 62 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index fc9b8def50df..621fa3e55fab 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6133,11 +6133,8 @@ static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
 				le32_to_cpu(desc[i].length));
 		}
 	}
-	if (ch_count != 1) {
-		ksmbd_debug(RDMA, "RDMA multiple buffer descriptors %d are not supported yet\n",
-			    ch_count);
+	if (!ch_count)
 		return -EINVAL;
-	}
 
 	work->need_invalidate_rkey =
 		(Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 696ffd2ae661..19a605fd46ff 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -206,7 +206,9 @@ struct smb_direct_recvmsg {
 struct smb_direct_rdma_rw_msg {
 	struct smb_direct_transport	*t;
 	struct ib_cqe		cqe;
+	int			status;
 	struct completion	*completion;
+	struct list_head	list;
 	struct rdma_rw_ctx	rw_ctx;
 	struct sg_table		sgt;
 	struct scatterlist	sg_list[];
@@ -1311,6 +1313,16 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	return ret;
 }
 
+static void smb_direct_free_rdma_rw_msg(struct smb_direct_transport *t,
+					struct smb_direct_rdma_rw_msg *msg,
+					enum dma_data_direction dir)
+{
+	rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
+			    msg->sgt.sgl, msg->sgt.nents, dir);
+	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+	kfree(msg);
+}
+
 static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
 			    enum dma_data_direction dir)
 {
@@ -1319,19 +1331,14 @@ static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
 	struct smb_direct_transport *t = msg->t;
 
 	if (wc->status != IB_WC_SUCCESS) {
+		msg->status = -EIO;
 		pr_err("read/write error. opcode = %d, status = %s(%d)\n",
 		       wc->opcode, ib_wc_status_msg(wc->status), wc->status);
-		smb_direct_disconnect_rdma_connection(t);
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			smb_direct_disconnect_rdma_connection(t);
 	}
 
-	if (atomic_inc_return(&t->rw_credits) > 0)
-		wake_up(&t->wait_rw_credits);
-
-	rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
-			    msg->sg_list, msg->sgt.nents, dir);
-	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
 	complete(msg->completion);
-	kfree(msg);
 }
 
 static void read_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -1350,75 +1357,116 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 				unsigned int desc_len,
 				bool is_read)
 {
-	struct smb_direct_rdma_rw_msg *msg;
-	int ret;
+	struct smb_direct_rdma_rw_msg *msg, *next_msg;
+	int i, ret;
 	DECLARE_COMPLETION_ONSTACK(completion);
-	struct ib_send_wr *first_wr = NULL;
-	u32 remote_key = le32_to_cpu(desc[0].token);
-	u64 remote_offset = le64_to_cpu(desc[0].offset);
+	struct ib_send_wr *first_wr;
+	LIST_HEAD(msg_list);
+	char *desc_buf;
 	int credits_needed;
+	unsigned int desc_buf_len;
+	size_t total_length = 0;
+
+	if (t->status != SMB_DIRECT_CS_CONNECTED)
+		return -ENOTCONN;
+
+	/* calculate needed credits */
+	credits_needed = 0;
+	desc_buf = buf;
+	for (i = 0; i < desc_len / sizeof(*desc); i++) {
+		desc_buf_len = le32_to_cpu(desc[i].length);
+
+		credits_needed += calc_rw_credits(t, desc_buf, desc_buf_len);
+		desc_buf += desc_buf_len;
+		total_length += desc_buf_len;
+		if (desc_buf_len == 0 || total_length > buf_len ||
+		    total_length > t->max_rdma_rw_size)
+			return -EINVAL;
+	}
+
+	ksmbd_debug(RDMA, "RDMA %s, len %#x, needed credits %#x\n",
+		    is_read ? "read" : "write", buf_len, credits_needed);
 
-	credits_needed = calc_rw_credits(t, buf, buf_len);
 	ret = wait_for_rw_credits(t, credits_needed);
 	if (ret < 0)
 		return ret;
 
-	/* TODO: mempool */
-	msg = kmalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
-		      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
-	if (!msg) {
-		atomic_add(credits_needed, &t->rw_credits);
-		return -ENOMEM;
-	}
+	/* build rdma_rw_ctx for each descriptor */
+	desc_buf = buf;
+	for (i = 0; i < desc_len / sizeof(*desc); i++) {
+		msg = kzalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
+			      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
+		if (!msg) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
-	msg->sgt.sgl = &msg->sg_list[0];
-	ret = sg_alloc_table_chained(&msg->sgt,
-				     get_buf_page_count(buf, buf_len),
-				     msg->sg_list, SG_CHUNK_SIZE);
-	if (ret) {
-		atomic_add(credits_needed, &t->rw_credits);
-		kfree(msg);
-		return -ENOMEM;
-	}
+		desc_buf_len = le32_to_cpu(desc[i].length);
 
-	ret = get_sg_list(buf, buf_len, msg->sgt.sgl, msg->sgt.orig_nents);
-	if (ret <= 0) {
-		pr_err("failed to get pages\n");
-		goto err;
-	}
+		msg->t = t;
+		msg->cqe.done = is_read ? read_done : write_done;
+		msg->completion = &completion;
 
-	ret = rdma_rw_ctx_init(&msg->rw_ctx, t->qp, t->qp->port,
-			       msg->sg_list, get_buf_page_count(buf, buf_len),
-			       0, remote_offset, remote_key,
-			       is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	if (ret < 0) {
-		pr_err("failed to init rdma_rw_ctx: %d\n", ret);
-		goto err;
+		msg->sgt.sgl = &msg->sg_list[0];
+		ret = sg_alloc_table_chained(&msg->sgt,
+					     get_buf_page_count(desc_buf, desc_buf_len),
+					     msg->sg_list, SG_CHUNK_SIZE);
+		if (ret) {
+			kfree(msg);
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = get_sg_list(desc_buf, desc_buf_len,
+				  msg->sgt.sgl, msg->sgt.orig_nents);
+		if (ret < 0) {
+			sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+			kfree(msg);
+			goto out;
+		}
+
+		ret = rdma_rw_ctx_init(&msg->rw_ctx, t->qp, t->qp->port,
+				       msg->sgt.sgl,
+				       get_buf_page_count(desc_buf, desc_buf_len),
+				       0,
+				       le64_to_cpu(desc[i].offset),
+				       le32_to_cpu(desc[i].token),
+				       is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+		if (ret < 0) {
+			pr_err("failed to init rdma_rw_ctx: %d\n", ret);
+			sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+			kfree(msg);
+			goto out;
+		}
+
+		list_add_tail(&msg->list, &msg_list);
+		desc_buf += desc_buf_len;
 	}
 
-	msg->t = t;
-	msg->cqe.done = is_read ? read_done : write_done;
-	msg->completion = &completion;
-	first_wr = rdma_rw_ctx_wrs(&msg->rw_ctx, t->qp, t->qp->port,
-				   &msg->cqe, NULL);
+	/* concatenate work requests of rdma_rw_ctxs */
+	first_wr = NULL;
+	list_for_each_entry_reverse(msg, &msg_list, list) {
+		first_wr = rdma_rw_ctx_wrs(&msg->rw_ctx, t->qp, t->qp->port,
+					   &msg->cqe, first_wr);
+	}
 
 	ret = ib_post_send(t->qp, first_wr, NULL);
 	if (ret) {
-		pr_err("failed to post send wr: %d\n", ret);
-		goto err;
+		pr_err("failed to post send wr for RDMA R/W: %d\n", ret);
+		goto out;
 	}
 
+	msg = list_last_entry(&msg_list, struct smb_direct_rdma_rw_msg, list);
 	wait_for_completion(&completion);
-	return 0;
-
-err:
+	ret = msg->status;
+out:
+	list_for_each_entry_safe(msg, next_msg, &msg_list, list) {
+		list_del(&msg->list);
+		smb_direct_free_rdma_rw_msg(t, msg,
+					    is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+	}
 	atomic_add(credits_needed, &t->rw_credits);
-	if (first_wr)
-		rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
-				    msg->sg_list, msg->sgt.nents,
-				    is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
-	kfree(msg);
+	wake_up(&t->wait_rw_credits);
 	return ret;
 }
 
-- 
2.25.1

