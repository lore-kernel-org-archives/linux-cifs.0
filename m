Return-Path: <SRS0=e7zQ=TO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1601EC04A6B
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 04:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E65E720818
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 04:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbfENECF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 May 2019 00:02:05 -0400
Received: from linux.microsoft.com ([13.77.154.182]:37134 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfENECF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 May 2019 00:02:05 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id AD89B20D4DFA; Mon, 13 May 2019 21:02:04 -0700 (PDT)
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 2/2] cifs:smbd Use the correct DMA direction when sending data
Date:   Mon, 13 May 2019 21:01:29 -0700
Message-Id: <1557806489-11272-2-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557806489-11272-1-git-send-email-longli@linuxonhyperv.com>
References: <1557806489-11272-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When sending data, use the DMA_TO_DEVICE to map buffers. Also log the number
of requests in a compounding request from upper layer.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 251ef1223206..caac37b1de8c 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -903,7 +903,7 @@ static int smbd_create_header(struct smbd_connection *info,
 	request->sge[0].addr = ib_dma_map_single(info->id->device,
 						 (void *)packet,
 						 header_length,
-						 DMA_BIDIRECTIONAL);
+						 DMA_TO_DEVICE);
 	if (ib_dma_mapping_error(info->id->device, request->sge[0].addr)) {
 		mempool_free(request, info->request_mempool);
 		rc = -EIO;
@@ -1005,7 +1005,7 @@ static int smbd_post_send_sgl(struct smbd_connection *info,
 	for_each_sg(sgl, sg, num_sgs, i) {
 		request->sge[i+1].addr =
 			ib_dma_map_page(info->id->device, sg_page(sg),
-			       sg->offset, sg->length, DMA_BIDIRECTIONAL);
+			       sg->offset, sg->length, DMA_TO_DEVICE);
 		if (ib_dma_mapping_error(
 				info->id->device, request->sge[i+1].addr)) {
 			rc = -EIO;
@@ -2110,8 +2110,10 @@ int smbd_send(struct TCP_Server_Info *server,
 		goto done;
 	}
 
-	rqst_idx = 0;
+	log_write(INFO, "num_rqst=%d total length=%u\n",
+			num_rqst, remaining_data_length);
 
+	rqst_idx = 0;
 next_rqst:
 	rqst = &rqst_array[rqst_idx];
 	iov = rqst->rq_iov;
-- 
2.17.1

