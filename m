Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDD8C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Apr 2022 23:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380711AbiD2Xf1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Apr 2022 19:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381774AbiD2XfY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Apr 2022 19:35:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D83EDCE36
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 16:32:02 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g8so5702968pfh.5
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 16:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fnTIUvwSJbu69ns0WQdwVnlpBp0P+mrWURfhfkst1Hk=;
        b=b/QhoaN5iDbT0CPCDMGEAVm8HoBXCSnpXGcl9t3MzlkTK04mTDTKuk3T8M1nr8mMFA
         kCuwdPnEfxjmMpruJovVW6WuapZz47d6OvSn7LdRTch8MRbLWCk5Or5JiPNkK9Uxid46
         tdnVGvOXbyjtskDkzHO0bWlZWVTLdG8v0C4gaqfK9Nj8k+AmZWnrC2BsyjCYzXjackb2
         4+Kj7TxxK17TpaPuIoanuRW1bq1MtnMWtOkt+vJDCyVnDqNzlICPcj6M9ISij6kfkEX8
         7iJnPqSYssaeti2+YC+ggccSFJEtZfjl8qy01RDVl6ZCY0lBQ8UDmOqfz/ZfAFVNpA7V
         aL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fnTIUvwSJbu69ns0WQdwVnlpBp0P+mrWURfhfkst1Hk=;
        b=m2964uLg6M300rxipTfPMs3tvrYHRnjQfYZnklhHvlxBKxr6hNnKZHktguIY7uRm8h
         9xkWUamI1cL/XwYAcjVhd/bz5blkeiDCTH1XuIWJH8UYVek/D4VgsHcNsp5CfoueaMJj
         WwFX27Hlww5hN2v+GNV1EAXh7JH+ry55Dian4skrQm6Mwoj7fSz7HWJZw2/1caz712sR
         YtMzNXLiMdaUQaZjUMSUVPhwF+zMsN+vVcVuPmv78Kmtn7tvGTgDZ4MO0msDF55WkkzM
         P1YOxjTyhQdRZWP+YXEGYlBLonNcwUhBa+SmpQ69h1TFGKvakDPLLn8BLyi0Bagq7j8E
         vgXA==
X-Gm-Message-State: AOAM533hqHitfbdoaJORTnvtdqYQQmvLWzFHPpy+sFamos9Mr3pmV/yx
        pp+F6CwiIHd6KN12qtIZycvONBfmN+w=
X-Google-Smtp-Source: ABdhPJwq5I2TqEH1opXiHm2PRE2yPskQqW53Vfb8aANg+8T4hKje17tfrYqdTA/VatxgerqlTiyd8w==
X-Received: by 2002:a05:6a00:124e:b0:50d:bf78:936f with SMTP id u14-20020a056a00124e00b0050dbf78936fmr1084004pfi.85.1651275121467;
        Fri, 29 Apr 2022 16:32:01 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id h9-20020a62b409000000b0050dc7628180sm230227pfn.90.2022.04.29.16.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 16:32:00 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v4 2/5] ksmbd: smbd: introduce read/write credits for RDMA read/write
Date:   Sat, 30 Apr 2022 08:30:26 +0900
Message-Id: <20220429233029.42741-2-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429233029.42741-1-hyc.lee@gmail.com>
References: <20220429233029.42741-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SMB2_READ/SMB2_WRITE request has to be granted the number
of rw credits, the pages the request wants to transfer
/ the maximum pages which can be registered with one
MR to read and write a file.
And allocate enough RDMA resources for the maximum
number of rw credits allowed by ksmbd.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
changes from v2:
 - Split a v2 patch to 4 patches.
changes from v3:
 - Remove the variable, smb_direct_max_outstanding_rw_ops.

 fs/ksmbd/transport_rdma.c | 120 ++++++++++++++++++++++----------------
 1 file changed, 71 insertions(+), 49 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 5e34625b5faf..2edb5acfb1f6 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -80,9 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 /*  The maximum single-message size which can be received */
 static int smb_direct_max_receive_size = 8192;
 
-static int smb_direct_max_read_write_size = 524224;
-
-static int smb_direct_max_outstanding_rw_ops = 8;
+static int smb_direct_max_read_write_size = 8 * 1024 * 1024;
 
 static LIST_HEAD(smb_direct_device_list);
 static DEFINE_RWLOCK(smb_direct_device_lock);
@@ -147,10 +145,12 @@ struct smb_direct_transport {
 	atomic_t		send_credits;
 	spinlock_t		lock_new_recv_credits;
 	int			new_recv_credits;
-	atomic_t		rw_avail_ops;
+	int			max_rw_credits;
+	int			pages_per_rw_credit;
+	atomic_t		rw_credits;
 
 	wait_queue_head_t	wait_send_credits;
-	wait_queue_head_t	wait_rw_avail_ops;
+	wait_queue_head_t	wait_rw_credits;
 
 	mempool_t		*sendmsg_mempool;
 	struct kmem_cache	*sendmsg_cache;
@@ -377,7 +377,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	t->reassembly_queue_length = 0;
 	init_waitqueue_head(&t->wait_reassembly_queue);
 	init_waitqueue_head(&t->wait_send_credits);
-	init_waitqueue_head(&t->wait_rw_avail_ops);
+	init_waitqueue_head(&t->wait_rw_credits);
 
 	spin_lock_init(&t->receive_credit_lock);
 	spin_lock_init(&t->recvmsg_queue_lock);
@@ -983,18 +983,19 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 }
 
 static int wait_for_credits(struct smb_direct_transport *t,
-			    wait_queue_head_t *waitq, atomic_t *credits)
+			    wait_queue_head_t *waitq, atomic_t *total_credits,
+			    int needed)
 {
 	int ret;
 
 	do {
-		if (atomic_dec_return(credits) >= 0)
+		if (atomic_sub_return(needed, total_credits) >= 0)
 			return 0;
 
-		atomic_inc(credits);
+		atomic_add(needed, total_credits);
 		ret = wait_event_interruptible(*waitq,
-					       atomic_read(credits) > 0 ||
-						t->status != SMB_DIRECT_CS_CONNECTED);
+					       atomic_read(total_credits) >= needed ||
+					       t->status != SMB_DIRECT_CS_CONNECTED);
 
 		if (t->status != SMB_DIRECT_CS_CONNECTED)
 			return -ENOTCONN;
@@ -1015,7 +1016,19 @@ static int wait_for_send_credits(struct smb_direct_transport *t,
 			return ret;
 	}
 
-	return wait_for_credits(t, &t->wait_send_credits, &t->send_credits);
+	return wait_for_credits(t, &t->wait_send_credits, &t->send_credits, 1);
+}
+
+static int wait_for_rw_credits(struct smb_direct_transport *t, int credits)
+{
+	return wait_for_credits(t, &t->wait_rw_credits, &t->rw_credits, credits);
+}
+
+static int calc_rw_credits(struct smb_direct_transport *t,
+			   char *buf, unsigned int len)
+{
+	return DIV_ROUND_UP(get_buf_page_count(buf, len),
+			    t->pages_per_rw_credit);
 }
 
 static int smb_direct_create_header(struct smb_direct_transport *t,
@@ -1331,8 +1344,8 @@ static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
 		smb_direct_disconnect_rdma_connection(t);
 	}
 
-	if (atomic_inc_return(&t->rw_avail_ops) > 0)
-		wake_up(&t->wait_rw_avail_ops);
+	if (atomic_inc_return(&t->rw_credits) > 0)
+		wake_up(&t->wait_rw_credits);
 
 	rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
 			    msg->sg_list, msg->sgt.nents, dir);
@@ -1363,8 +1376,10 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	struct ib_send_wr *first_wr = NULL;
 	u32 remote_key = le32_to_cpu(desc[0].token);
 	u64 remote_offset = le64_to_cpu(desc[0].offset);
+	int credits_needed;
 
-	ret = wait_for_credits(t, &t->wait_rw_avail_ops, &t->rw_avail_ops);
+	credits_needed = calc_rw_credits(t, buf, buf_len);
+	ret = wait_for_rw_credits(t, credits_needed);
 	if (ret < 0)
 		return ret;
 
@@ -1372,7 +1387,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	msg = kmalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
 		      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
 	if (!msg) {
-		atomic_inc(&t->rw_avail_ops);
+		atomic_add(credits_needed, &t->rw_credits);
 		return -ENOMEM;
 	}
 
@@ -1381,7 +1396,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 				     get_buf_page_count(buf, buf_len),
 				     msg->sg_list, SG_CHUNK_SIZE);
 	if (ret) {
-		atomic_inc(&t->rw_avail_ops);
+		atomic_add(credits_needed, &t->rw_credits);
 		kfree(msg);
 		return -ENOMEM;
 	}
@@ -1417,7 +1432,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	return 0;
 
 err:
-	atomic_inc(&t->rw_avail_ops);
+	atomic_add(credits_needed, &t->rw_credits);
 	if (first_wr)
 		rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
 				    msg->sg_list, msg->sgt.nents,
@@ -1642,11 +1657,19 @@ static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 	return ret;
 }
 
+static unsigned int smb_direct_get_max_fr_pages(struct smb_direct_transport *t)
+{
+	return min_t(unsigned int,
+		     t->cm_id->device->attrs.max_fast_reg_page_list_len,
+		     256);
+}
+
 static int smb_direct_init_params(struct smb_direct_transport *t,
 				  struct ib_qp_cap *cap)
 {
 	struct ib_device *device = t->cm_id->device;
-	int max_send_sges, max_pages, max_rw_wrs, max_send_wrs;
+	int max_send_sges, max_rw_wrs, max_send_wrs;
+	unsigned int max_sge_per_wr, wrs_per_credit;
 
 	/* need 2 more sge. because a SMB_DIRECT header will be mapped,
 	 * and maybe a send buffer could be not page aligned.
@@ -1658,25 +1681,31 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 		return -EINVAL;
 	}
 
-	/*
-	 * allow smb_direct_max_outstanding_rw_ops of in-flight RDMA
-	 * read/writes. HCA guarantees at least max_send_sge of sges for
-	 * a RDMA read/write work request, and if memory registration is used,
-	 * we need reg_mr, local_inv wrs for each read/write.
+	/* Calculate the number of work requests for RDMA R/W.
+	 * The maximum number of pages which can be registered
+	 * with one Memory region can be transferred with one
+	 * R/W credit. And at least 4 work requests for each credit
+	 * are needed for MR registration, RDMA R/W, local & remote
+	 * MR invalidation.
 	 */
 	t->max_rdma_rw_size = smb_direct_max_read_write_size;
-	max_pages = DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1;
-	max_rw_wrs = DIV_ROUND_UP(max_pages, SMB_DIRECT_MAX_SEND_SGES);
-	max_rw_wrs += rdma_rw_mr_factor(device, t->cm_id->port_num,
-			max_pages) * 2;
-	max_rw_wrs *= smb_direct_max_outstanding_rw_ops;
+	t->pages_per_rw_credit = smb_direct_get_max_fr_pages(t);
+	t->max_rw_credits = DIV_ROUND_UP(t->max_rdma_rw_size,
+					 (t->pages_per_rw_credit - 1) *
+					 PAGE_SIZE);
+
+	max_sge_per_wr = min_t(unsigned int, device->attrs.max_send_sge,
+			       device->attrs.max_sge_rd);
+	wrs_per_credit = max_t(unsigned int, 4,
+			       DIV_ROUND_UP(t->pages_per_rw_credit,
+					    max_sge_per_wr) + 1);
+	max_rw_wrs = t->max_rw_credits * wrs_per_credit;
 
 	max_send_wrs = smb_direct_send_credit_target + max_rw_wrs;
 	if (max_send_wrs > device->attrs.max_cqe ||
 	    max_send_wrs > device->attrs.max_qp_wr) {
-		pr_err("consider lowering send_credit_target = %d, or max_outstanding_rw_ops = %d\n",
-		       smb_direct_send_credit_target,
-		       smb_direct_max_outstanding_rw_ops);
+		pr_err("consider lowering send_credit_target = %d\n",
+		       smb_direct_send_credit_target);
 		pr_err("Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
 		       device->attrs.max_cqe, device->attrs.max_qp_wr);
 		return -EINVAL;
@@ -1711,7 +1740,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 
 	t->send_credit_target = smb_direct_send_credit_target;
 	atomic_set(&t->send_credits, 0);
-	atomic_set(&t->rw_avail_ops, smb_direct_max_outstanding_rw_ops);
+	atomic_set(&t->rw_credits, t->max_rw_credits);
 
 	t->max_send_size = smb_direct_max_send_size;
 	t->max_recv_size = smb_direct_max_receive_size;
@@ -1719,12 +1748,10 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 
 	cap->max_send_wr = max_send_wrs;
 	cap->max_recv_wr = t->recv_credit_max;
-	cap->max_send_sge = SMB_DIRECT_MAX_SEND_SGES;
+	cap->max_send_sge = max_sge_per_wr;
 	cap->max_recv_sge = SMB_DIRECT_MAX_RECV_SGES;
 	cap->max_inline_data = 0;
-	cap->max_rdma_ctxs =
-		rdma_rw_mr_factor(device, t->cm_id->port_num, max_pages) *
-		smb_direct_max_outstanding_rw_ops;
+	cap->max_rdma_ctxs = t->max_rw_credits;
 	return 0;
 }
 
@@ -1817,7 +1844,8 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	}
 
 	t->send_cq = ib_alloc_cq(t->cm_id->device, t,
-				 t->send_credit_target, 0, IB_POLL_WORKQUEUE);
+				 smb_direct_send_credit_target + cap->max_rdma_ctxs,
+				 0, IB_POLL_WORKQUEUE);
 	if (IS_ERR(t->send_cq)) {
 		pr_err("Can't create RDMA send CQ\n");
 		ret = PTR_ERR(t->send_cq);
@@ -1826,8 +1854,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	}
 
 	t->recv_cq = ib_alloc_cq(t->cm_id->device, t,
-				 cap->max_send_wr + cap->max_rdma_ctxs,
-				 0, IB_POLL_WORKQUEUE);
+				 t->recv_credit_max, 0, IB_POLL_WORKQUEUE);
 	if (IS_ERR(t->recv_cq)) {
 		pr_err("Can't create RDMA recv CQ\n");
 		ret = PTR_ERR(t->recv_cq);
@@ -1856,17 +1883,12 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 
 	pages_per_rw = DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1;
 	if (pages_per_rw > t->cm_id->device->attrs.max_sgl_rd) {
-		int pages_per_mr, mr_count;
-
-		pages_per_mr = min_t(int, pages_per_rw,
-				     t->cm_id->device->attrs.max_fast_reg_page_list_len);
-		mr_count = DIV_ROUND_UP(pages_per_rw, pages_per_mr) *
-			atomic_read(&t->rw_avail_ops);
-		ret = ib_mr_pool_init(t->qp, &t->qp->rdma_mrs, mr_count,
-				      IB_MR_TYPE_MEM_REG, pages_per_mr, 0);
+		ret = ib_mr_pool_init(t->qp, &t->qp->rdma_mrs,
+				      t->max_rw_credits, IB_MR_TYPE_MEM_REG,
+				      t->pages_per_rw_credit, 0);
 		if (ret) {
 			pr_err("failed to init mr pool count %d pages %d\n",
-			       mr_count, pages_per_mr);
+			       t->max_rw_credits, t->pages_per_rw_credit);
 			goto err;
 		}
 	}
-- 
2.25.1

