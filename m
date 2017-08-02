From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [[PATCH v1] 07/37] [CIFS] SMBD: Implement receive buffer for handling SMBD response
Date: Wed,  2 Aug 2017 13:10:18 -0700
Message-ID: <1501704648-20159-8-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Create recevie buffers to handling SMBD response messages. Each SMBD response message is assocated with a receive buffer, where the message payload is received. The number of receive buffer is determine after negotiating SMBD transport with the server.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsrdma.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |  3 ++
 2 files changed, 92 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 1636304..b3e43b1 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -54,6 +54,14 @@
 
 #include "cifsrdma.h"
 
+static struct cifs_rdma_response* get_receive_buffer(
+		struct cifs_rdma_info *info);
+static void put_receive_buffer(
+		struct cifs_rdma_info *info,
+		struct cifs_rdma_response *response);
+static int allocate_receive_buffers(struct cifs_rdma_info *info, int num_buf);
+static void destroy_receive_buffers(struct cifs_rdma_info *info);
+
 /*
  * Per RDMA transport connection parameters
  * as defined in [MS-SMBD] 3.1.1.1
@@ -280,6 +288,85 @@ static int cifs_rdma_ia_open(
 	return rc;
 }
 
+/*
+ * Receive buffer operations.
+ * For each remote send, we need to post a receive. The receive buffers are
+ * pre-allocated in advance.
+ */
+static struct cifs_rdma_response* get_receive_buffer(struct cifs_rdma_info *info)
+{
+	struct cifs_rdma_response *ret = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->receive_queue_lock, flags);
+	if (!list_empty(&info->receive_queue)) {
+		ret = list_first_entry(
+			&info->receive_queue,
+			struct cifs_rdma_response, list);
+		list_del(&ret->list);
+		info->count_receive_buffer--;
+		info->count_get_receive_buffer++;
+	}
+	spin_unlock_irqrestore(&info->receive_queue_lock, flags);
+
+	return ret;
+}
+
+static void put_receive_buffer(
+	struct cifs_rdma_info *info, struct cifs_rdma_response *response)
+{
+	unsigned long flags;
+
+	ib_dma_unmap_single(info->id->device, response->sge.addr,
+		response->sge.length, DMA_FROM_DEVICE);
+
+	spin_lock_irqsave(&info->receive_queue_lock, flags);
+	list_add_tail(&response->list, &info->receive_queue);
+	info->count_receive_buffer++;
+	info->count_put_receive_buffer++;
+	spin_unlock_irqrestore(&info->receive_queue_lock, flags);
+}
+
+static int allocate_receive_buffers(struct cifs_rdma_info *info, int num_buf)
+{
+	int i;
+	struct cifs_rdma_response *response;
+
+	INIT_LIST_HEAD(&info->receive_queue);
+	spin_lock_init(&info->receive_queue_lock);
+
+	for (i=0; i<num_buf; i++) {
+		response = mempool_alloc(info->response_mempool, GFP_KERNEL);
+		if (!response)
+			goto allocate_failed;
+
+		response->info = info;
+		list_add_tail(&response->list, &info->receive_queue);
+		info->count_receive_buffer++;
+	}
+
+	return 0;
+
+allocate_failed:
+	while (!list_empty(&info->receive_queue)) {
+		response = list_first_entry(
+				&info->receive_queue,
+				struct cifs_rdma_response, list);
+		list_del(&response->list);
+		info->count_receive_buffer--;
+
+		mempool_free(response, info->response_mempool);
+	}
+	return -ENOMEM;
+}
+
+static void destroy_receive_buffers(struct cifs_rdma_info *info)
+{
+	struct cifs_rdma_response *response;
+	while ((response = get_receive_buffer(info)))
+		mempool_free(response, info->response_mempool);
+}
+
 struct cifs_rdma_info* cifs_create_rdma_session(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr)
 {
@@ -383,6 +470,8 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	info->response_mempool =
 		mempool_create(info->receive_credit_max, mempool_alloc_slab,
 		       mempool_free_slab, info->response_cache);
+
+	allocate_receive_buffers(info, info->receive_credit_max);
 out2:
 	rdma_destroy_id(info->id);
 
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 41ae61a..78ce2bf 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -59,6 +59,9 @@ struct cifs_rdma_info {
 	atomic_t receive_credits;
 	atomic_t receive_credit_target;
 
+	struct list_head receive_queue;
+	spinlock_t receive_queue_lock;
+
 	// response pool for RDMA receive
 	struct kmem_cache *response_cache;
 	mempool_t *response_mempool;
-- 
2.7.4
