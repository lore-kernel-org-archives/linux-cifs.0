From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with no payload
Date: Wed,  2 Aug 2017 13:10:27 -0700
Message-ID: <1501704648-20159-17-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Implement the function to send a SMBD message with no payload. This is required at times when we want to extend credtis to server to have it continue to send data, without sending any actual data payload.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h | 11 +++++++
 2 files changed, 107 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 989cad8..cf71bb1 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -66,6 +66,7 @@ static int cifs_rdma_post_recv(
 		struct cifs_rdma_info *info,
 		struct cifs_rdma_response *response);
 
+static int cifs_rdma_post_send_empty(struct cifs_rdma_info *info);
 static int cifs_rdma_post_send_data(
 		struct cifs_rdma_info *info,
 		struct kvec *iov, int n_vec, int remaining_data_length);
@@ -674,6 +675,101 @@ static int cifs_rdma_post_send_page(struct cifs_rdma_info *info, struct page *pa
 }
 
 /*
+ * Send an empty message
+ * Empty message is used to extend credits to peer to for keep live
+ */
+static int cifs_rdma_post_send_empty(struct cifs_rdma_info *info)
+{
+	struct cifs_rdma_request *request;
+	struct smbd_data_transfer_no_data *packet;
+	struct ib_send_wr send_wr, *send_wr_fail;
+	int rc;
+	u16 credits_granted, flags=0;
+
+	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
+	if (!request) {
+		log_rdma_send("failed to get send buffer for empty packet\n");
+		return -ENOMEM;
+	}
+
+	request->info = info;
+	packet = (struct smbd_data_transfer_no_data *) request->packet;
+
+	/* nothing to do? */
+	if (credits_granted==0 && flags==0) {
+		mempool_free(request, info->request_mempool);
+		log_keep_alive("nothing to do, not sending anything\n");
+		return 0;
+	}
+
+	packet->credits_requested = cpu_to_le16(info->send_credit_target);
+	packet->credits_granted = cpu_to_le16(credits_granted);
+	packet->flags = cpu_to_le16(flags);
+	packet->reserved = cpu_to_le16(0);
+	packet->remaining_data_length = cpu_to_le32(0);
+	packet->data_offset = cpu_to_le32(0);
+	packet->data_length = cpu_to_le32(0);
+
+	log_outgoing("credits_requested=%d credits_granted=%d data_offset=%d "
+		     "data_length=%d remaining_data_length=%d\n",
+		le16_to_cpu(packet->credits_requested),
+		le16_to_cpu(packet->credits_granted),
+		le32_to_cpu(packet->data_offset),
+		le32_to_cpu(packet->data_length),
+		le32_to_cpu(packet->remaining_data_length));
+
+	request->num_sge = 1;
+	request->sge = kzalloc(sizeof(struct ib_sge), GFP_KERNEL);
+	if (!request->sge) {
+		rc = -ENOMEM;
+		goto allocate_sge_failed;
+	}
+
+	request->sge[0].addr = ib_dma_map_single(info->id->device,
+				(void *)packet, sizeof(*packet), DMA_TO_DEVICE);
+	if(ib_dma_mapping_error(info->id->device, request->sge[0].addr)) {
+		rc = -EIO;
+		goto dma_mapping_failure;
+	}
+
+	request->sge[0].length = sizeof(*packet);
+	request->sge[0].lkey = info->pd->local_dma_lkey;
+	ib_dma_sync_single_for_device(info->id->device, request->sge[0].addr,
+				request->sge[0].length, DMA_TO_DEVICE);
+
+	wait_event(info->wait_send_queue, atomic_read(&info->send_credits) > 0);
+	atomic_dec(&info->send_credits);
+	info->count_send_empty++;
+	log_rdma_send("rdma_request sge addr=%llu legnth=%u lkey=%u\n",
+		request->sge[0].addr, request->sge[0].length,
+		request->sge[0].lkey);
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
+	log_rdma_send("ib_post_send failed rc=%d\n", rc);
+	ib_dma_unmap_single(info->id->device, request->sge[0].addr,
+			    request->sge[0].length, DMA_TO_DEVICE);
+
+dma_mapping_failure:
+	kfree(request->sge);
+
+allocate_sge_failed:
+	mempool_free(request, info->request_mempool);
+	return rc;
+}
+
+/*
  * Send a data buffer
  * iov: the iov array describing the data buffers
  * n_vec: number of iov array
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index a766cbf..4a4c191 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -120,6 +120,17 @@ struct smbd_negotiate_resp {
 	__le32 max_fragmented_size;
 } __packed;
 
+// SMBD data transfer packet with no payload [MS-SMBD] 2.2.3
+struct smbd_data_transfer_no_data {
+	__le16 credits_requested;
+	__le16 credits_granted;
+	__le16 flags;
+	__le16 reserved;
+	__le32 remaining_data_length;
+	__le32 data_offset;
+	__le32 data_length;
+} __packed;
+
 // SMBD data transfer packet with payload [MS-SMBD] 2.2.3
 struct smbd_data_transfer {
 	__le16 credits_requested;
-- 
2.7.4
