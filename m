Return-Path: <SRS0=T25Y=5S=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C75C43331
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Apr 2020 20:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E113420721
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Apr 2020 20:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="JGaem04a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387819AbgDBU4y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Apr 2020 16:56:54 -0400
Received: from linux.microsoft.com ([13.77.154.182]:39526 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730837AbgDBU4y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Apr 2020 16:56:54 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 1282420B4749; Thu,  2 Apr 2020 13:56:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1282420B4749
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585861012;
        bh=FvaNoOx21Cd6mPDK6XeyIi4QS+y8/3ReU6fqi8EDsGg=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=JGaem04aJTJqzJ0UYX4wIeR5NitkC1stRH7TVijp2rWA62pJPP36G0SD7fp3HokcI
         pvCYgzGXyrLcO2vrGl5yiisPFmf07T+cJFdAWth9djfrHrbDy3zPQVegE4z22+YTlk
         hd+LewaYloKqXVGdsIp8p1lme1aeHn7rvDFW/0K4=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH v2] cifs: smbd: Properly process errors on ib_post_send
Date:   Thu,  2 Apr 2020 13:56:48 -0700
Message-Id: <1585861008-74004-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When processing errors from ib_post_send(), the transport state needs to be
rolled back to the condition before the error.

Refactor the old code to make it easy to roll back on IB errors, and fix this.

Signed-off-by: Long Li <longli@microsoft.com>
---

change in v2: rebased

 fs/cifs/smbdirect.c | 220 +++++++++++++++++++-------------------------
 1 file changed, 97 insertions(+), 123 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index fa52bf3e0236..dd3e119da296 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -800,41 +800,91 @@ static int manage_keep_alive_before_sending(struct smbd_connection *info)
 	return 0;
 }
 
-/*
- * Build and prepare the SMBD packet header
- * This function waits for avaialbe send credits and build a SMBD packet
- * header. The caller then optional append payload to the packet after
- * the header
- * intput values
- * size: the size of the payload
- * remaining_data_length: remaining data to send if this is part of a
- * fragmented packet
- * output values
- * request_out: the request allocated from this function
- * return values: 0 on success, otherwise actual error code returned
- */
-static int smbd_create_header(struct smbd_connection *info,
-		int size, int remaining_data_length,
-		struct smbd_request **request_out)
+/* Post the send request */
+static int smbd_post_send(struct smbd_connection *info,
+		struct smbd_request *request)
+{
+	struct ib_send_wr send_wr;
+	int rc, i;
+
+	for (i = 0; i < request->num_sge; i++) {
+		log_rdma_send(INFO,
+			"rdma_request sge[%d] addr=%llu length=%u\n",
+			i, request->sge[i].addr, request->sge[i].length);
+		ib_dma_sync_single_for_device(
+			info->id->device,
+			request->sge[i].addr,
+			request->sge[i].length,
+			DMA_TO_DEVICE);
+	}
+
+	request->cqe.done = send_done;
+
+	send_wr.next = NULL;
+	send_wr.wr_cqe = &request->cqe;
+	send_wr.sg_list = request->sge;
+	send_wr.num_sge = request->num_sge;
+	send_wr.opcode = IB_WR_SEND;
+	send_wr.send_flags = IB_SEND_SIGNALED;
+
+	rc = ib_post_send(info->id->qp, &send_wr, NULL);
+	if (rc) {
+		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
+		smbd_disconnect_rdma_connection(info);
+		rc = -EAGAIN;
+	} else
+		/* Reset timer for idle connection after packet is sent */
+		mod_delayed_work(info->workqueue, &info->idle_timer_work,
+			info->keep_alive_interval*HZ);
+
+	return rc;
+}
+
+static int smbd_post_send_sgl(struct smbd_connection *info,
+	struct scatterlist *sgl, int data_length, int remaining_data_length)
 {
+	int num_sgs;
+	int i, rc;
+	int header_length;
 	struct smbd_request *request;
 	struct smbd_data_transfer *packet;
-	int header_length;
 	int new_credits;
-	int rc;
+	struct scatterlist *sg;
 
+wait_credit:
 	/* Wait for send credits. A SMBD packet needs one credit */
 	rc = wait_event_interruptible(info->wait_send_queue,
 		atomic_read(&info->send_credits) > 0 ||
 		info->transport_status != SMBD_CONNECTED);
 	if (rc)
-		return rc;
+		goto err_wait_credit;
 
 	if (info->transport_status != SMBD_CONNECTED) {
-		log_outgoing(ERR, "disconnected not sending\n");
-		return -EAGAIN;
+		log_outgoing(ERR, "disconnected not sending on wait_credit\n");
+		rc = -EAGAIN;
+		goto err_wait_credit;
+	}
+	if (unlikely(atomic_dec_return(&info->send_credits) < 0)) {
+		atomic_inc(&info->send_credits);
+		goto wait_credit;
+	}
+
+wait_send_queue:
+	wait_event(info->wait_post_send,
+		atomic_read(&info->send_pending) < info->send_credit_target ||
+		info->transport_status != SMBD_CONNECTED);
+
+	if (info->transport_status != SMBD_CONNECTED) {
+		log_outgoing(ERR, "disconnected not sending on wait_send_queue\n");
+		rc = -EAGAIN;
+		goto err_wait_send_queue;
+	}
+
+	if (unlikely(atomic_inc_return(&info->send_pending) >
+				info->send_credit_target)) {
+		atomic_dec(&info->send_pending);
+		goto wait_send_queue;
 	}
-	atomic_dec(&info->send_credits);
 
 	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
 	if (!request) {
@@ -859,11 +909,11 @@ static int smbd_create_header(struct smbd_connection *info,
 		packet->flags |= cpu_to_le16(SMB_DIRECT_RESPONSE_REQUESTED);
 
 	packet->reserved = 0;
-	if (!size)
+	if (!data_length)
 		packet->data_offset = 0;
 	else
 		packet->data_offset = cpu_to_le32(24);
-	packet->data_length = cpu_to_le32(size);
+	packet->data_length = cpu_to_le32(data_length);
 	packet->remaining_data_length = cpu_to_le32(remaining_data_length);
 	packet->padding = 0;
 
@@ -878,7 +928,7 @@ static int smbd_create_header(struct smbd_connection *info,
 	/* Map the packet to DMA */
 	header_length = sizeof(struct smbd_data_transfer);
 	/* If this is a packet without payload, don't send padding */
-	if (!size)
+	if (!data_length)
 		header_length = offsetof(struct smbd_data_transfer, padding);
 
 	request->num_sge = 1;
@@ -887,107 +937,15 @@ static int smbd_create_header(struct smbd_connection *info,
 						 header_length,
 						 DMA_TO_DEVICE);
 	if (ib_dma_mapping_error(info->id->device, request->sge[0].addr)) {
-		mempool_free(request, info->request_mempool);
 		rc = -EIO;
+		request->sge[0].addr = 0;
 		goto err_dma;
 	}
 
 	request->sge[0].length = header_length;
 	request->sge[0].lkey = info->pd->local_dma_lkey;
 
-	*request_out = request;
-	return 0;
-
-err_dma:
-	/* roll back receive credits */
-	spin_lock(&info->lock_new_credits_offered);
-	info->new_credits_offered += new_credits;
-	spin_unlock(&info->lock_new_credits_offered);
-	atomic_sub(new_credits, &info->receive_credits);
-
-err_alloc:
-	/* roll back send credits */
-	atomic_inc(&info->send_credits);
-
-	return rc;
-}
-
-static void smbd_destroy_header(struct smbd_connection *info,
-		struct smbd_request *request)
-{
-
-	ib_dma_unmap_single(info->id->device,
-			    request->sge[0].addr,
-			    request->sge[0].length,
-			    DMA_TO_DEVICE);
-	mempool_free(request, info->request_mempool);
-	atomic_inc(&info->send_credits);
-}
-
-/* Post the send request */
-static int smbd_post_send(struct smbd_connection *info,
-		struct smbd_request *request)
-{
-	struct ib_send_wr send_wr;
-	int rc, i;
-
-	for (i = 0; i < request->num_sge; i++) {
-		log_rdma_send(INFO,
-			"rdma_request sge[%d] addr=%llu length=%u\n",
-			i, request->sge[i].addr, request->sge[i].length);
-		ib_dma_sync_single_for_device(
-			info->id->device,
-			request->sge[i].addr,
-			request->sge[i].length,
-			DMA_TO_DEVICE);
-	}
-
-	request->cqe.done = send_done;
-
-	send_wr.next = NULL;
-	send_wr.wr_cqe = &request->cqe;
-	send_wr.sg_list = request->sge;
-	send_wr.num_sge = request->num_sge;
-	send_wr.opcode = IB_WR_SEND;
-	send_wr.send_flags = IB_SEND_SIGNALED;
-
-wait_sq:
-	wait_event(info->wait_post_send,
-		atomic_read(&info->send_pending) < info->send_credit_target);
-	if (unlikely(atomic_inc_return(&info->send_pending) >
-				info->send_credit_target)) {
-		atomic_dec(&info->send_pending);
-		goto wait_sq;
-	}
-
-	rc = ib_post_send(info->id->qp, &send_wr, NULL);
-	if (rc) {
-		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-		if (atomic_dec_and_test(&info->send_pending))
-			wake_up(&info->wait_send_pending);
-		smbd_disconnect_rdma_connection(info);
-		rc = -EAGAIN;
-	} else
-		/* Reset timer for idle connection after packet is sent */
-		mod_delayed_work(info->workqueue, &info->idle_timer_work,
-			info->keep_alive_interval*HZ);
-
-	return rc;
-}
-
-static int smbd_post_send_sgl(struct smbd_connection *info,
-	struct scatterlist *sgl, int data_length, int remaining_data_length)
-{
-	int num_sgs;
-	int i, rc;
-	struct smbd_request *request;
-	struct scatterlist *sg;
-
-	rc = smbd_create_header(
-		info, data_length, remaining_data_length, &request);
-	if (rc)
-		return rc;
-
+	/* Fill in the packet data payload */
 	num_sgs = sgl ? sg_nents(sgl) : 0;
 	for_each_sg(sgl, sg, num_sgs, i) {
 		request->sge[i+1].addr =
@@ -997,7 +955,7 @@ static int smbd_post_send_sgl(struct smbd_connection *info,
 				info->id->device, request->sge[i+1].addr)) {
 			rc = -EIO;
 			request->sge[i+1].addr = 0;
-			goto dma_mapping_failure;
+			goto err_dma;
 		}
 		request->sge[i+1].length = sg->length;
 		request->sge[i+1].lkey = info->pd->local_dma_lkey;
@@ -1008,14 +966,30 @@ static int smbd_post_send_sgl(struct smbd_connection *info,
 	if (!rc)
 		return 0;
 
-dma_mapping_failure:
-	for (i = 1; i < request->num_sge; i++)
+err_dma:
+	for (i = 0; i < request->num_sge; i++)
 		if (request->sge[i].addr)
 			ib_dma_unmap_single(info->id->device,
 					    request->sge[i].addr,
 					    request->sge[i].length,
 					    DMA_TO_DEVICE);
-	smbd_destroy_header(info, request);
+	mempool_free(request, info->request_mempool);
+
+	/* roll back receive credits and credits to be offered */
+	spin_lock(&info->lock_new_credits_offered);
+	info->new_credits_offered += new_credits;
+	spin_unlock(&info->lock_new_credits_offered);
+	atomic_sub(new_credits, &info->receive_credits);
+
+err_alloc:
+	if (atomic_dec_and_test(&info->send_pending))
+		wake_up(&info->wait_send_pending);
+
+err_wait_send_queue:
+	/* roll back send credits and pending */
+	atomic_inc(&info->send_credits);
+
+err_wait_credit:
 	return rc;
 }
 
-- 
2.17.1

