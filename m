From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 25/37] [CIFS] SMBD: Support SMBD idle connection timer
Date: Wed,  2 Aug 2017 13:10:36 -0700
Message-ID: <1501704648-20159-26-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

This is part of the keep alive protocol. Each peer maintains a timer, and will send a message to peer when it expires.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 25 +++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |  6 ++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index e275834..523c80f 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -89,6 +89,7 @@ static int send_credit_target = 512;
 static int max_send_size = 8192;
 static int max_fragmented_recv_size = 1024*1024;
 static int max_receive_size = 8192;
+static int keep_alive_interval = 120;
 
 // maximum number of SGEs in a RDMA I/O
 static int max_send_sge = 16;
@@ -1200,6 +1201,25 @@ static void destroy_receive_buffers(struct cifs_rdma_info *info)
 		mempool_free(response, info->response_mempool);
 }
 
+// Implement idle connection timer [MS-SMBD] 3.1.6.2
+static void idle_connection_timer(struct work_struct *work)
+{
+	struct cifs_rdma_info *info = container_of(
+					work, struct cifs_rdma_info,
+					idle_timer_work.work);
+
+	if (info->keep_alive_requested != KEEP_ALIVE_NONE)
+		log_keep_alive("error status info->keep_alive_requested=%d\n",
+				info->keep_alive_requested);
+
+	log_keep_alive("about to send an empty idle message\n");
+	cifs_rdma_post_send_empty(info);
+
+	// setup the next idle timeout work
+	schedule_delayed_work(&info->idle_timer_work,
+				info->keep_alive_interval*HZ);
+}
+
 int cifs_reconnect_rdma_session(struct TCP_Server_Info *server)
 {
 	log_rdma_event("reconnecting rdma session\n");
@@ -1262,6 +1282,7 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	info->max_send_size = max_send_size;
 	info->max_fragmented_recv_size = max_fragmented_recv_size;
 	info->max_receive_size = max_receive_size;
+	info->keep_alive_interval = keep_alive_interval;
 
 	max_send_sge = min_t(int, max_send_sge,
 		info->id->device->attrs.max_sge);
@@ -1348,6 +1369,10 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	init_waitqueue_head(&info->wait_send_queue);
 	init_waitqueue_head(&info->wait_reassembly_queue);
 
+	INIT_DELAYED_WORK(&info->idle_timer_work, idle_connection_timer);
+	schedule_delayed_work(&info->idle_timer_work,
+		info->keep_alive_interval*HZ);
+
 	init_waitqueue_head(&info->wait_send_pending);
 	atomic_set(&info->send_pending, 0);
 
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 62d0bb8..dd497ce 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -73,6 +73,7 @@ struct cifs_rdma_info {
 	int max_fragmented_recv_size;
 	int max_fragmented_send_size;
 	int max_receive_size;
+	int keep_alive_interval;
 	int max_readwrite_size;
 	enum keep_alive_status keep_alive_requested;
 	int protocol;
@@ -101,12 +102,13 @@ struct cifs_rdma_info {
 
 	wait_queue_head_t wait_send_queue;
 
+	bool full_packet_received;
+	struct delayed_work idle_timer_work;;
+
 	// request pool for RDMA send
 	struct kmem_cache *request_cache;
 	mempool_t *request_mempool;
 
-	bool full_packet_received;
-
 	// response pool for RDMA receive
 	struct kmem_cache *response_cache;
 	mempool_t *response_mempool;
-- 
2.7.4
