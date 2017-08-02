From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 26/37] [CIFS] SMBD: Send an immediate packet when it's needed
Date: Wed,  2 Aug 2017 13:10:37 -0700
Message-ID: <1501704648-20159-27-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

At times when credits is exhausted and nearing exhausted, the peer needs to promptly extend credits to peers after freeing local resources for RDMA operations. When there is no data to send and we want to extend credits to server, an empty packet is used to extend credits to peer.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |  3 +++
 2 files changed, 45 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 523c80f..fe7d1f8d 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -318,6 +318,20 @@ static bool process_negotiation_response(struct cifs_rdma_response *response, in
 	return true;
 }
 
+/*
+ * Check and schedule to send an immediate packet
+ * This is used to extend credtis to remote peer to keep the transport busy
+ */
+static void check_and_send_immediate(struct cifs_rdma_info *info)
+{
+	info->send_immediate = true;
+
+	// promptly send a packet if running low on receive credits
+	if (atomic_read(&info->receive_credits) <
+	    atomic_read(&info->receive_credit_target) -1 )
+		schedule_delayed_work(&info->send_immediate_work, 0);
+}
+
 /* Called from softirq, when recv is done */
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
@@ -379,6 +393,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			info->keep_alive_requested = KEEP_ALIVE_PENDING;
 		}
 
+		check_and_send_immediate(info);
+
 		// process receive queue
 		if (le32_to_cpu(data_transfer->data_length)) {
 			if (info->full_packet_received) {
@@ -630,6 +646,9 @@ static int manage_credits_prior_sending(struct cifs_rdma_info *info)
 	atomic_add(ret, &info->receive_credits);
 	log_transport_credit(info);
 
+	if (ret)
+		info->send_immediate = false;
+
 	return ret;
 }
 
@@ -1155,6 +1174,9 @@ static void put_receive_buffer(
 	info->count_receive_buffer++;
 	info->count_put_receive_buffer++;
 	spin_unlock_irqrestore(&info->receive_queue_lock, flags);
+
+	// now we can post new receive credits
+	check_and_send_immediate(info);
 }
 
 static int allocate_receive_buffers(struct cifs_rdma_info *info, int num_buf)
@@ -1201,6 +1223,25 @@ static void destroy_receive_buffers(struct cifs_rdma_info *info)
 		mempool_free(response, info->response_mempool);
 }
 
+/*
+ * Check and send an immediate or keep alive packet
+ * The condition to send those packets are defined in [MS-SMBD] 3.1.1.1
+ * Connection.KeepaliveRequested and Connection.SendImmediate
+ * The idea is to extend credits to server as soon as it becomes available
+ */
+static void send_immediate_work(struct work_struct *work)
+{
+	struct cifs_rdma_info *info = container_of(
+					work, struct cifs_rdma_info,
+					send_immediate_work.work);
+
+	if (info->keep_alive_requested == KEEP_ALIVE_PENDING ||
+	    info->send_immediate) {
+		log_keep_alive("send an empty message\n");
+		cifs_rdma_post_send_empty(info);
+	}
+}
+
 // Implement idle connection timer [MS-SMBD] 3.1.6.2
 static void idle_connection_timer(struct work_struct *work)
 {
@@ -1370,6 +1411,7 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	init_waitqueue_head(&info->wait_reassembly_queue);
 
 	INIT_DELAYED_WORK(&info->idle_timer_work, idle_connection_timer);
+	INIT_DELAYED_WORK(&info->send_immediate_work, send_immediate_work);
 	schedule_delayed_work(&info->idle_timer_work,
 		info->keep_alive_interval*HZ);
 
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index dd497ce..025457c 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -100,10 +100,13 @@ struct cifs_rdma_info {
 	// the offset to first buffer in reassembly queue
 	int first_entry_offset;
 
+	bool send_immediate;
+
 	wait_queue_head_t wait_send_queue;
 
 	bool full_packet_received;
 	struct delayed_work idle_timer_work;;
+	struct delayed_work send_immediate_work;
 
 	// request pool for RDMA send
 	struct kmem_cache *request_cache;
-- 
2.7.4
