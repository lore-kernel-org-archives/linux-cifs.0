From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [[PATCH v1] 11/37] [CIFS] SMBD: Post a receive request
Date: Wed,  2 Aug 2017 13:10:22 -0700
Message-ID: <1501704648-20159-12-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Add code to post a receive request to RDMA. Before the SMB server can send a packet to SMB client via SMBD, a receive request must be posted to local RDMA layer.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsrdma.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |   5 +++
 2 files changed, 129 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 8aa8a47..20237b7 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -62,6 +62,10 @@ static void put_receive_buffer(
 static int allocate_receive_buffers(struct cifs_rdma_info *info, int num_buf);
 static void destroy_receive_buffers(struct cifs_rdma_info *info);
 
+static int cifs_rdma_post_recv(
+		struct cifs_rdma_info *info,
+		struct cifs_rdma_response *response);
+
 /*
  * Per RDMA transport connection parameters
  * as defined in [MS-SMBD] 3.1.1.1
@@ -193,6 +197,85 @@ cifs_rdma_qp_async_error_upcall(struct ib_event *event, void *context)
 	}
 }
 
+/* Called from softirq, when recv is done */
+static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct smbd_data_transfer *data_transfer;
+	struct cifs_rdma_response *response =
+		container_of(wc->wr_cqe, struct cifs_rdma_response, cqe);
+	struct cifs_rdma_info *info = response->info;
+
+	log_rdma_recv("response=%p type=%d wc status=%d wc opcode %d "
+		      "byte_len=%d pkey_index=%x\n",
+		response, response->type, wc->status, wc->opcode,
+		wc->byte_len, wc->pkey_index);
+
+	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
+		log_rdma_recv("wc->status=%d opcode=%d\n",
+			wc->status, wc->opcode);
+		goto error;
+	}
+
+	ib_dma_sync_single_for_cpu(
+		wc->qp->device,
+		response->sge.addr,
+		response->sge.length,
+		DMA_FROM_DEVICE);
+
+	switch(response->type) {
+	case SMBD_TRANSFER_DATA:
+		data_transfer = (struct smbd_data_transfer *) response->packet;
+		atomic_dec(&info->receive_credits);
+		atomic_set(&info->receive_credit_target,
+			le16_to_cpu(data_transfer->credits_requested));
+		atomic_add(le16_to_cpu(data_transfer->credits_granted),
+			&info->send_credits);
+
+		log_incoming("data flags %d data_offset %d data_length %d "
+			     "remaining_data_length %d\n",
+			le16_to_cpu(data_transfer->flags),
+			le32_to_cpu(data_transfer->data_offset),
+			le32_to_cpu(data_transfer->data_length),
+			le32_to_cpu(data_transfer->remaining_data_length));
+
+		log_transport_credit(info);
+
+		// process sending queue on new credits
+		if (atomic_read(&info->send_credits))
+			wake_up(&info->wait_send_queue);
+
+		// process receive queue
+		if (le32_to_cpu(data_transfer->data_length)) {
+			if (info->full_packet_received) {
+				response->first_segment = true;
+			}
+
+			if (le32_to_cpu(data_transfer->remaining_data_length))
+				info->full_packet_received = false;
+			else
+				info->full_packet_received = true;
+
+			goto queue_done;
+		}
+
+		// if we reach here, this is an empty packet, finish it
+		break;
+
+	default:
+		log_rdma_recv("unexpected response type=%d\n", response->type);
+	}
+
+error:
+	put_receive_buffer(info, response);
+
+queue_done:
+	if (atomic_dec_and_test(&info->recv_pending)) {
+		wake_up(&info->wait_recv_pending);
+	}
+
+	return;
+}
+
 static struct rdma_cm_id* cifs_rdma_create_id(
 		struct cifs_rdma_info *info, struct sockaddr *dstaddr)
 {
@@ -289,6 +372,44 @@ static int cifs_rdma_ia_open(
 }
 
 /*
+ * Post a receive request to the transport
+ * The remote peer can only send data when a receive is posted
+ * The interaction is controlled by send/recieve credit system
+ */
+static int cifs_rdma_post_recv(struct cifs_rdma_info *info, struct cifs_rdma_response *response)
+{
+	struct ib_recv_wr recv_wr, *recv_wr_fail=NULL;
+	int rc = -EIO;
+
+	response->sge.addr = ib_dma_map_single(info->id->device, response->packet,
+				info->max_receive_size, DMA_FROM_DEVICE);
+	if (ib_dma_mapping_error(info->id->device, response->sge.addr))
+		return rc;
+
+	response->sge.length = info->max_receive_size;
+	response->sge.lkey = info->pd->local_dma_lkey;
+
+	response->cqe.done = recv_done;
+
+	recv_wr.wr_cqe = &response->cqe;
+	recv_wr.next = NULL;
+	recv_wr.sg_list = &response->sge;
+	recv_wr.num_sge = 1;
+
+	atomic_inc(&info->recv_pending);
+	rc = ib_post_recv(info->id->qp, &recv_wr, &recv_wr_fail);
+	if (rc) {
+		ib_dma_unmap_single(info->id->device, response->sge.addr,
+				    response->sge.length, DMA_FROM_DEVICE);
+
+		log_rdma_recv("ib_post_recv failed rc=%d\n", rc);
+		atomic_dec(&info->recv_pending);
+	}
+
+	return rc;
+}
+
+/*
  * Receive buffer operations.
  * For each remote send, we need to post a receive. The receive buffers are
  * pre-allocated in advance.
@@ -485,6 +606,9 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 
 	allocate_receive_buffers(info, info->receive_credit_max);
 	init_waitqueue_head(&info->wait_send_queue);
+
+	init_waitqueue_head(&info->wait_recv_pending);
+	atomic_set(&info->recv_pending, 0);
 out2:
 	rdma_destroy_id(info->id);
 
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 287b5b1..8702a2b 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -59,6 +59,9 @@ struct cifs_rdma_info {
 	atomic_t receive_credits;
 	atomic_t receive_credit_target;
 
+	atomic_t recv_pending;
+	wait_queue_head_t wait_recv_pending;
+
 	struct list_head receive_queue;
 	spinlock_t receive_queue_lock;
 
@@ -68,6 +71,8 @@ struct cifs_rdma_info {
 	struct kmem_cache *request_cache;
 	mempool_t *request_mempool;
 
+	bool full_packet_received;
+
 	// response pool for RDMA receive
 	struct kmem_cache *response_cache;
 	mempool_t *response_mempool;
-- 
2.7.4
