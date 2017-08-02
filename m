From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 14/37] [CIFS] SMBD: Post a SMBD data transfer message with page payload
Date: Wed,  2 Aug 2017 13:10:25 -0700
Message-ID: <1501704648-20159-15-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Add the function to send a SMBD data transfer message to server with page passed from upper layer.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index aa3d1a5..b3ec109 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -66,6 +66,10 @@ static int cifs_rdma_post_recv(
 		struct cifs_rdma_info *info,
 		struct cifs_rdma_response *response);
 
+static int cifs_rdma_post_send_page(struct cifs_rdma_info *info,
+		struct page *page, unsigned long offset,
+		size_t size, int remaining_data_length);
+
 /*
  * Per RDMA transport connection parameters
  * as defined in [MS-SMBD] 3.1.1.1
@@ -558,6 +562,115 @@ static int cifs_rdma_post_send_negotiate_req(struct cifs_rdma_info *info)
 }
 
 /*
+ * Send a page
+ * page: the page to send
+ * offset: offset in the page to send
+ * size: length in the page to send
+ * remaining_data_length: remaining data to send in this payload
+ */
+static int cifs_rdma_post_send_page(struct cifs_rdma_info *info, struct page *page,
+		unsigned long offset, size_t size, int remaining_data_length)
+{
+	struct cifs_rdma_request *request;
+	struct smbd_data_transfer *packet;
+	struct ib_send_wr send_wr, *send_wr_fail;
+	int rc = -ENOMEM;
+	int i;
+
+	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
+	if (!request)
+		return rc;
+
+	request->info = info;
+
+	wait_event(info->wait_send_queue, atomic_read(&info->send_credits) > 0);
+	atomic_dec(&info->send_credits);
+
+	packet = (struct smbd_data_transfer *) request->packet;
+	packet->credits_requested = cpu_to_le16(info->send_credit_target);
+	packet->flags = cpu_to_le16(0);
+
+	packet->reserved = cpu_to_le16(0);
+	packet->data_offset = cpu_to_le32(24);
+	packet->data_length = cpu_to_le32(size);
+	packet->remaining_data_length = cpu_to_le32(remaining_data_length);
+
+	packet->padding = cpu_to_le32(0);
+
+	log_outgoing("credits_requested=%d credits_granted=%d data_offset=%d "
+		     "data_length=%d remaining_data_length=%d\n",
+		le16_to_cpu(packet->credits_requested),
+		le16_to_cpu(packet->credits_granted),
+		le32_to_cpu(packet->data_offset),
+		le32_to_cpu(packet->data_length),
+		le32_to_cpu(packet->remaining_data_length));
+
+	request->sge = kzalloc(sizeof(struct ib_sge)*2, GFP_KERNEL);
+	if (!request->sge)
+		goto allocate_sge_failed;
+	request->num_sge = 2;
+
+	request->sge[0].addr = ib_dma_map_single(info->id->device,
+						 (void *)packet,
+						 sizeof(*packet),
+						 DMA_BIDIRECTIONAL);
+	if(ib_dma_mapping_error(info->id->device, request->sge[0].addr)) {
+		rc = -EIO;
+		goto dma_mapping_failed;
+	}
+	request->sge[0].length = sizeof(*packet);
+	request->sge[0].lkey = info->pd->local_dma_lkey;
+	ib_dma_sync_single_for_device(info->id->device, request->sge[0].addr,
+				      request->sge[0].length, DMA_TO_DEVICE);
+
+	request->sge[1].addr = ib_dma_map_page(info->id->device, page,
+					       offset, size, DMA_BIDIRECTIONAL);
+	if(ib_dma_mapping_error(info->id->device, request->sge[1].addr)) {
+		rc = -EIO;
+		goto dma_mapping_failed;
+	}
+	request->sge[1].length = size;
+	request->sge[1].lkey = info->pd->local_dma_lkey;
+	ib_dma_sync_single_for_device(info->id->device, request->sge[1].addr,
+				      request->sge[1].length, DMA_TO_DEVICE);
+
+	log_rdma_send("rdma_request sge[0] addr=%llu legnth=%u lkey=%u sge[1] "
+		      "addr=%llu length=%u lkey=%u\n",
+		request->sge[0].addr, request->sge[0].length,
+		request->sge[0].lkey, request->sge[1].addr,
+		request->sge[1].length, request->sge[1].lkey);
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
+	rc = ib_post_send(info->id->qp, &send_wr, &send_wr_fail);
+	if (!rc)
+		return 0;
+
+	// post send failed
+	log_rdma_send("ib_post_send failed rc=%d\n", rc);
+
+dma_mapping_failed:
+	for (i=0; i<2; i++)
+		if (request->sge[i].addr)
+			ib_dma_unmap_single(info->id->device,
+					    request->sge[i].addr,
+					    request->sge[i].length,
+					    DMA_TO_DEVICE);
+	kfree(request->sge);
+
+allocate_sge_failed:
+	mempool_free(request, info->request_mempool);
+	return rc;
+}
+
+/*
  * Post a receive request to the transport
  * The remote peer can only send data when a receive is posted
  * The interaction is controlled by send/recieve credit system
-- 
2.7.4
