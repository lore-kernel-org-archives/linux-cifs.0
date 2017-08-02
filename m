From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 13/37] [CIFS] SMBD: Implement SMBD protocol negotiation
Date: Wed,  2 Aug 2017 13:10:24 -0700
Message-ID: <1501704648-20159-14-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Now we have all the code in place to support SMBD protocol negotiation with SMB server. SMBD negotiation is defined in [MS-SMBD] 3.1.5. After negotiation, the client and server are connected through SMBD, and they can use SMBD to transfer data payloads.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 208 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |  29 ++++++++
 2 files changed, 237 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index ecbc832..aa3d1a5 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -222,6 +222,80 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	mempool_free(request, request->info->request_mempool);
 }
 
+static void dump_smbd_negotiate_resp(struct smbd_negotiate_resp *resp)
+{
+	log_rdma_event("resp message min_version %u max_version %u "
+		      "negotiated_version %u credits_requested %u "
+		      "credits_granted %u status %u max_readwrite_size %u "
+		      "preferred_send_size %u max_receive_size %u "
+		      "max_fragmented_size %u\n",
+		resp->min_version, resp->max_version, resp->negotiated_version,
+		resp->credits_requested, resp->credits_granted, resp->status,
+		resp->max_readwrite_size, resp->preferred_send_size,
+		resp->max_receive_size, resp->max_fragmented_size);
+}
+
+/* Process a negotiation response message, according to [MS-SMBD]3.1.5.7 */
+static bool process_negotiation_response(struct cifs_rdma_response *response, int packet_length)
+{
+	struct cifs_rdma_info *info = response->info;
+	struct smbd_negotiate_resp *packet =
+		(struct smbd_negotiate_resp *) response->packet;
+
+	if (packet_length < sizeof (struct smbd_negotiate_resp)) {
+		log_rdma_event("error: packet_length=%d\n", packet_length);
+		return false;
+	}
+
+	if (le16_to_cpu(packet->negotiated_version) != 0x100) {
+		log_rdma_event("error: negotiated_version=%x\n",
+			le16_to_cpu(packet->negotiated_version));
+		return false;
+	}
+	info->protocol = le16_to_cpu(packet->negotiated_version);
+
+	if (packet->credits_requested == 0) {
+		log_rdma_event("error: credits_requested==0\n");
+		return false;
+	}
+	atomic_set(&info->receive_credit_target,
+			le16_to_cpu(packet->credits_requested));
+
+	if (packet->credits_granted == 0) {
+		log_rdma_event("error: credits_granted==0\n");
+		return false;
+	}
+	atomic_set(&info->send_credits, le16_to_cpu(packet->credits_granted));
+
+	atomic_set(&info->receive_credits, 0);
+
+	if (le32_to_cpu(packet->preferred_send_size) > info->max_receive_size) {
+		log_rdma_event("error: preferred_send_size=%d\n",
+			le32_to_cpu(packet->preferred_send_size));
+		return false;
+	}
+	info->max_receive_size = le32_to_cpu(packet->preferred_send_size);
+
+	if (le32_to_cpu(packet->max_receive_size) < 128) {
+		log_rdma_event("error: max_receive_size=%d\n",
+			le32_to_cpu(packet->max_receive_size));
+		return false;
+	}
+	info->max_send_size = min_t(int, info->max_send_size,
+					le32_to_cpu(packet->max_receive_size));
+
+	if (le32_to_cpu(packet->max_fragmented_size) < 131072) {
+		log_rdma_event("error: max_fragmented_size=%d\n",
+			le32_to_cpu(packet->max_fragmented_size));
+		return false;
+	}
+	info->max_fragmented_send_size = le32_to_cpu(packet->max_fragmented_size);
+
+	info->max_readwrite_size = le32_to_cpu(packet->max_readwrite_size);
+
+	return true;
+}
+
 /* Called from softirq, when recv is done */
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
@@ -248,6 +322,14 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		DMA_FROM_DEVICE);
 
 	switch(response->type) {
+	case SMBD_NEGOTIATE_RESP:
+		dump_smbd_negotiate_resp(
+			(struct smbd_negotiate_resp *) response->packet);
+		info->full_packet_received = true;
+		info->negotiate_done = process_negotiation_response(response, wc->byte_len);
+		complete(&info->negotiate_completion);
+		break;
+
 	case SMBD_TRANSFER_DATA:
 		data_transfer = (struct smbd_data_transfer *) response->packet;
 		atomic_dec(&info->receive_credits);
@@ -397,6 +479,85 @@ static int cifs_rdma_ia_open(
 }
 
 /*
+ * Send a negotiation request message to the peer
+ * The negotiation procedure is in [MS-SMBD] 3.1.5.2 and 3.1.5.3
+ * After negotiation, the transport is connected and ready for
+ * carrying upper layer SMB payload
+ */
+static int cifs_rdma_post_send_negotiate_req(struct cifs_rdma_info *info)
+{
+	struct ib_send_wr send_wr, *send_wr_fail;
+	int rc = -ENOMEM;
+	struct cifs_rdma_request *request;
+	struct smbd_negotiate_req *packet;
+
+	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
+	if (!request)
+		return rc;
+
+	request->info = info;
+
+	packet = (struct smbd_negotiate_req *) request->packet;
+	packet->min_version = cpu_to_le16(0x100);
+	packet->max_version = cpu_to_le16(0x100);
+	packet->reserved = cpu_to_le16(0);
+	packet->credits_requested = cpu_to_le16(info->send_credit_target);
+	packet->preferred_send_size = cpu_to_le32(info->max_send_size);
+	packet->max_receive_size = cpu_to_le32(info->max_receive_size);
+	packet->max_fragmented_size =
+		cpu_to_le32(info->max_fragmented_recv_size);
+
+	request->sge = kzalloc(sizeof(struct ib_sge), GFP_KERNEL);
+	if (!request->sge)
+		goto allocate_sge_failed;
+
+	request->num_sge = 1;
+	request->sge[0].addr = ib_dma_map_single(
+				info->id->device, (void *)packet,
+				sizeof(*packet), DMA_TO_DEVICE);
+	if(ib_dma_mapping_error(info->id->device, request->sge[0].addr)) {
+		rc = -EIO;
+		goto dma_mapping_failed;
+	}
+
+	request->sge[0].length = sizeof(*packet);
+	request->sge[0].lkey = info->pd->local_dma_lkey;
+
+	ib_dma_sync_single_for_device(
+		info->id->device, request->sge[0].addr,
+		request->sge[0].length, DMA_TO_DEVICE);
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
+	log_rdma_send("sge addr=%llx length=%x lkey=%x\n",
+		request->sge[0].addr,
+		request->sge[0].length, request->sge[0].lkey);
+
+	rc = ib_post_send(info->id->qp, &send_wr, &send_wr_fail);
+	if (!rc)
+		return 0;
+
+	// if we reach here, post send failed
+	log_rdma_send("ib_post_send failed rc=%d\n", rc);
+	ib_dma_unmap_single(info->id->device, request->sge[0].addr,
+		request->sge[0].length, DMA_TO_DEVICE);
+
+dma_mapping_failed:
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
@@ -434,6 +595,45 @@ static int cifs_rdma_post_recv(struct cifs_rdma_info *info, struct cifs_rdma_res
 	return rc;
 }
 
+// Perform SMBD negotiate according to [MS-SMBD] 3.1.5.2
+static int cifs_rdma_negotiate(struct cifs_rdma_info *info)
+{
+	int rc;
+	struct cifs_rdma_response* response = get_receive_buffer(info);
+	response->type = SMBD_NEGOTIATE_RESP;
+
+	rc = cifs_rdma_post_recv(info, response);
+
+	log_rdma_event("cifs_rdma_post_recv rc=%d iov.addr=%llx iov.length=%x "
+		       "iov.lkey=%x\n",
+		rc, response->sge.addr,
+		response->sge.length, response->sge.lkey);
+	if (rc)
+		return rc;
+
+	init_completion(&info->negotiate_completion);
+	info->negotiate_done = false;
+	rc = cifs_rdma_post_send_negotiate_req(info);
+	if (rc)
+		return rc;
+
+	rc = wait_for_completion_interruptible_timeout(
+		&info->negotiate_completion, 60 * HZ);
+	log_rdma_event("wait_for_completion_timeout rc=%d\n", rc);
+
+	if (info->negotiate_done)
+		return 0;
+
+	if (rc == 0)
+		rc = -ETIMEDOUT;
+	else if (rc == -ERESTARTSYS)
+		rc = -EINTR;
+	else
+		rc = -ENOTCONN;
+
+	return rc;
+}
+
 /*
  * Receive buffer operations.
  * For each remote send, we need to post a receive. The receive buffers are
@@ -634,6 +834,14 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 
 	init_waitqueue_head(&info->wait_recv_pending);
 	atomic_set(&info->recv_pending, 0);
+
+	rc = cifs_rdma_negotiate(info);
+	if (!rc)
+		return info;
+
+	// negotiation failed
+	log_rdma_event("cifs_rdma_negotiate rc=%d\n", rc);
+
 out2:
 	rdma_destroy_id(info->id);
 
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 8702a2b..a766cbf 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -46,6 +46,9 @@ struct cifs_rdma_info {
 	int ri_rc;
 	struct completion ri_done;
 
+	struct completion negotiate_completion;
+	bool negotiate_done;
+
 	//connection paramters
 	int receive_credit_max;
 	int send_credit_target;
@@ -91,6 +94,32 @@ enum smbd_message_type {
 
 #define SMB_DIRECT_RESPONSE_REQUESTED 0x0001
 
+// SMBD negotiation request packet [MS-SMBD] 2.2.1
+struct smbd_negotiate_req {
+	__le16 min_version;
+	__le16 max_version;
+	__le16 reserved;
+	__le16 credits_requested;
+	__le32 preferred_send_size;
+	__le32 max_receive_size;
+	__le32 max_fragmented_size;
+} __packed;
+
+// SMBD negotiation response packet [MS-SMBD] 2.2.2
+struct smbd_negotiate_resp {
+	__le16 min_version;
+	__le16 max_version;
+	__le16 negotiated_version;
+	__le16 reserved;
+	__le16 credits_requested;
+	__le16 credits_granted;
+	__le32 status;
+	__le32 max_readwrite_size;
+	__le32 preferred_send_size;
+	__le32 max_receive_size;
+	__le32 max_fragmented_size;
+} __packed;
+
 // SMBD data transfer packet with payload [MS-SMBD] 2.2.3
 struct smbd_data_transfer {
 	__le16 credits_requested;
-- 
2.7.4
