Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1265C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Apr 2022 05:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiDRFSH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Apr 2022 01:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbiDRFSG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Apr 2022 01:18:06 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1C010FD9
        for <linux-cifs@vger.kernel.org>; Sun, 17 Apr 2022 22:15:28 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id md4so12124790pjb.4
        for <linux-cifs@vger.kernel.org>; Sun, 17 Apr 2022 22:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b13eIvuLN2/MDCdZYYiaADvCgKfJ2oC6nKqcLsyDcjs=;
        b=Fgvs04j7pvzOp5150TBCKZQWnOsOFqGrcLiS9c+WPPLnfZBnJ4cadw9qldlQEkcv0P
         /nAw8IKTg0sbTju8DrG8NX8Y6N8TTWlsHtEFl3hRaG1QWBi8l0oWGfwkNHDTJqOXbJ5D
         eXFY8ez04bdnkmNONAdiNOA18N00vkuR3azkEqDiysFJvdhw25inEpVnBqaUmkJPMPrM
         EE6n2x7AjR4F6jyw1wWd6+p+e6EN2OhOACrODuYW03yzvBGBpX0ze6c+L7t9tT+Rknrr
         3TRnXWXMYwdqm/xNM3sMs9YZ6Lbo8mhgYeP6Ifjk91kHsvBpoE1rNOArp8rs7h5L071p
         tytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b13eIvuLN2/MDCdZYYiaADvCgKfJ2oC6nKqcLsyDcjs=;
        b=0hC+GECPGEStLhO8bEXcNBpcTsGgmcapJiPIndN/pPyB1KUL33p35WE7MQnJnXrxDe
         HM3/bS+5tnyuE3av02ZH9t/lkI2cvL1Hf/x05M5dEDp7fivAutpZQBbPVaFkp8/3yAoA
         UAPzgWCSI2/s/Sjf4z1Ke6HdEROhQGjSbjeiHjgTix31d7J6SLPSA1K8QBnAfWFh05Dh
         S2mLH5YSQe6z5EbAvoQGzM5shahjo8EwJZx9Mq9RHZZ9VondhNdSZakMiijBhbxCjTTr
         ktLw8XrRCHgR764CtU9YU7+974pSQ+Ujpcp4eSUd9bY3VOjzsOLrmPQQmYO3zxLqchdW
         t6oA==
X-Gm-Message-State: AOAM532zIasFxqA+Eu9UOfdiIq65uys1rpheOYzPgW3z6ZhlFQTjvIfa
        6/V6is2NCK5nL7uzErBJTKIJdKWLSOA=
X-Google-Smtp-Source: ABdhPJw8ig+50RvVd3+SHlkcvDIGjTN/OGKW1TGYtbFL1UaSJ9l6S8EE9NZrcPjKZ1YJtID+gjR8WA==
X-Received: by 2002:a17:90a:17ae:b0:1cb:6921:c89c with SMTP id q43-20020a17090a17ae00b001cb6921c89cmr16611090pja.37.1650258927742;
        Sun, 17 Apr 2022 22:15:27 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm11453028pge.23.2022.04.17.22.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 22:15:27 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v3 4/4] ksmbd: smbd: handle multiple Buffer descriptors
Date:   Mon, 18 Apr 2022 14:14:12 +0900
Message-Id: <20220418051412.13193-4-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418051412.13193-1-hyc.lee@gmail.com>
References: <20220418051412.13193-1-hyc.lee@gmail.com>
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

 fs/ksmbd/smb2pdu.c        |   5 +-
 fs/ksmbd/transport_rdma.c | 166 +++++++++++++++++++++++++-------------
 2 files changed, 109 insertions(+), 62 deletions(-)

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
index 1343ff8e00fd..410b79edc9f2 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -208,7 +208,9 @@ struct smb_direct_recvmsg {
 struct smb_direct_rdma_rw_msg {
 	struct smb_direct_transport	*t;
 	struct ib_cqe		cqe;
+	int			status;
 	struct completion	*completion;
+	struct list_head	list;
 	struct rdma_rw_ctx	rw_ctx;
 	struct sg_table		sgt;
 	struct scatterlist	sg_list[];
@@ -1313,6 +1315,18 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	return ret;
 }
 
+static void smb_direct_free_rdma_rw_msg(struct smb_direct_transport *t,
+					struct smb_direct_rdma_rw_msg *msg,
+					enum dma_data_direction dir)
+{
+	if (msg->sgt.orig_nents) {
+		rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
+				    msg->sgt.sgl, msg->sgt.nents, dir);
+		sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+	}
+	kfree(msg);
+}
+
 static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
 			    enum dma_data_direction dir)
 {
@@ -1321,19 +1335,14 @@ static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
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
@@ -1352,75 +1361,116 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
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
+		if (ret <= 0) {
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

