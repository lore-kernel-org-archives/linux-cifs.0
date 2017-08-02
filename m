From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [[PATCH v1] 20/37] [CIFS] SMBD: Implement reassembly queue for receiving data
Date: Wed,  2 Aug 2017 13:10:31 -0700
Message-ID: <1501704648-20159-21-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

All the data recevied via SMBD are placed in the reassembly queue. When upper layer reads data, it looks into reassembly queue. The SMBD layer is responsibe for passing a complete SMB packet to upper layer.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsrdma.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h | 11 +++++++++++
 2 files changed, 63 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 97cde3f..1d3fd26 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -62,6 +62,12 @@ static void put_receive_buffer(
 static int allocate_receive_buffers(struct cifs_rdma_info *info, int num_buf);
 static void destroy_receive_buffers(struct cifs_rdma_info *info);
 
+static void enqueue_reassembly(
+		struct cifs_rdma_info *info,
+		struct cifs_rdma_response *response, int data_length);
+static struct cifs_rdma_response* _get_first_reassembly(
+		struct cifs_rdma_info *info);
+
 static int cifs_rdma_post_recv(
 		struct cifs_rdma_info *info,
 		struct cifs_rdma_response *response);
@@ -377,6 +383,12 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			else
 				info->full_packet_received = true;
 
+			enqueue_reassembly(
+				info,
+				response,
+				le32_to_cpu(data_transfer->data_length));
+
+			wake_up(&info->wait_reassembly_queue);
 			goto queue_done;
 		}
 
@@ -1041,6 +1053,41 @@ static int cifs_rdma_negotiate(struct cifs_rdma_info *info)
 }
 
 /*
+ * Implement Connection.FragmentReassemblyBuffer defined in [MS-SMBD] 3.1.1.1
+ * This is a queue for reassembling upper layer payload and present to upper
+ * layer. All the inncoming payload go to the reassembly queue, regardless of
+ * reassembly is rquired. The uuper layer code reads from the queue for any
+ * incoming payloads.
+ */
+static void enqueue_reassembly(
+	struct cifs_rdma_info *info,
+	struct cifs_rdma_response *response,
+	int data_length)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&info->reassembly_queue_lock, flags);
+	list_add_tail(&response->list, &info->reassembly_queue);
+	atomic_add(data_length, &info->reassembly_data_length);
+	log_reassembly_queue("info->reassembly_data_length=%d\n",
+			atomic_read(&info->reassembly_data_length));
+	info->count_reassembly_queue++;
+	info->count_enqueue_reassembly_queue++;
+	spin_unlock_irqrestore(&info->reassembly_queue_lock, flags);
+}
+
+static struct cifs_rdma_response * _get_first_reassembly(struct cifs_rdma_info *info)
+{
+	struct cifs_rdma_response *ret = NULL;
+
+	if (!list_empty(&info->reassembly_queue)) {
+		ret = list_first_entry(
+			&info->reassembly_queue,
+			struct cifs_rdma_response, list);
+	}
+	return ret;
+}
+
+/*
  * Receive buffer operations.
  * For each remote send, we need to post a receive. The receive buffers are
  * pre-allocated in advance.
@@ -1084,6 +1131,10 @@ static int allocate_receive_buffers(struct cifs_rdma_info *info, int num_buf)
 	int i;
 	struct cifs_rdma_response *response;
 
+	INIT_LIST_HEAD(&info->reassembly_queue);
+	spin_lock_init(&info->reassembly_queue_lock);
+	atomic_set(&info->reassembly_data_length, 0);
+
 	INIT_LIST_HEAD(&info->receive_queue);
 	spin_lock_init(&info->receive_queue_lock);
 
@@ -1241,6 +1292,7 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 
 	allocate_receive_buffers(info, info->receive_credit_max);
 	init_waitqueue_head(&info->wait_send_queue);
+	init_waitqueue_head(&info->wait_reassembly_queue);
 
 	init_waitqueue_head(&info->wait_send_pending);
 	atomic_set(&info->send_pending, 0);
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 90746a4..b26e3b7 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -82,6 +82,14 @@ struct cifs_rdma_info {
 	struct list_head receive_queue;
 	spinlock_t receive_queue_lock;
 
+	/* reassembly queue */
+	struct list_head reassembly_queue;
+	spinlock_t reassembly_queue_lock;
+	wait_queue_head_t wait_reassembly_queue;
+
+	// total data length of reassembly queue
+	atomic_t reassembly_data_length;
+
 	wait_queue_head_t wait_send_queue;
 
 	// request pool for RDMA send
@@ -98,6 +106,9 @@ struct cifs_rdma_info {
 	unsigned int count_receive_buffer;
 	unsigned int count_get_receive_buffer;
 	unsigned int count_put_receive_buffer;
+	unsigned int count_reassembly_queue;
+	unsigned int count_enqueue_reassembly_queue;
+	unsigned int count_dequeue_reassembly_queue;
 	unsigned int count_send_empty;
 };
 
-- 
2.7.4
