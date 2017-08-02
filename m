From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 27/37] [CIFS] SMBD: Destroy transport when RDMA channel is disconnected
Date: Wed,  2 Aug 2017 13:10:38 -0700
Message-ID: <1501704648-20159-28-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When RDMA connection is terminated, the transport needs to destroy the transport and free its resources. At this point, we no longer have a RDMA connection to server.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |  2 ++
 2 files changed, 58 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index fe7d1f8d..a1ef7f6 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -148,6 +148,59 @@ do {									\
 			info->send_credit_target);			\
 } while (0)
 
+static void cifs_destroy_rdma_work(struct work_struct *work)
+{
+	unsigned long flags;
+	struct cifs_rdma_response *response;
+	struct cifs_rdma_info *info =
+		container_of(work, struct cifs_rdma_info, destroy_work);
+
+	log_rdma_event("cancelling all pending works\n");
+
+	cancel_delayed_work_sync(&info->idle_timer_work);
+	cancel_delayed_work_sync(&info->send_immediate_work);
+
+	ib_drain_qp(info->id->qp);
+	rdma_destroy_qp(info->id);
+
+	log_rdma_event("wait for all send or recv finish\n");
+	wait_event(info->wait_send_pending,
+		atomic_read(&info->send_pending) == 0);
+	wait_event(info->wait_recv_pending,
+		atomic_read(&info->recv_pending) == 0);
+
+	ib_free_cq(info->cq);
+	ib_dealloc_pd(info->pd);
+	rdma_destroy_id(info->id);
+
+	log_rdma_event("drain the reassembly queue\n");
+	spin_lock_irqsave(&info->reassembly_queue_lock, flags);
+	while ((response = _get_first_reassembly(info))) {
+		put_receive_buffer(info, response);
+	}
+	atomic_set(&info->reassembly_data_length, 0);
+	spin_unlock_irqrestore(&info->reassembly_queue_lock, flags);
+	wake_up(&info->wait_reassembly_queue);
+
+	log_rdma_event("free buffers\n");
+	destroy_receive_buffers(info);
+
+	// free mempools
+	mempool_destroy(info->request_mempool);
+	kmem_cache_destroy(info->request_cache);
+
+	mempool_destroy(info->response_mempool);
+	kmem_cache_destroy(info->response_cache);
+
+	info->transport_status = CIFS_RDMA_DESTROYED;
+}
+
+static int cifs_rdma_process_disconnected(struct cifs_rdma_info *info)
+{
+	schedule_work(&info->destroy_work);
+	return 0;
+}
+
 /* Upcall from RDMA CM */
 static int cifs_rdma_conn_upcall(
 		struct rdma_cm_id *id, struct rdma_cm_event *event)
@@ -186,6 +239,7 @@ static int cifs_rdma_conn_upcall(
 
 	case RDMA_CM_EVENT_DISCONNECTED:
 		info->transport_status = CIFS_RDMA_DISCONNECTED;
+		cifs_rdma_process_disconnected(info);
 		break;
 
 	default:
@@ -1421,6 +1475,8 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	init_waitqueue_head(&info->wait_recv_pending);
 	atomic_set(&info->recv_pending, 0);
 
+	INIT_WORK(&info->destroy_work, cifs_destroy_rdma_work);
+
 	rc = cifs_rdma_negotiate(info);
 	if (!rc)
 		return info;
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 025457c..5d0d86d 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -66,6 +66,8 @@ struct cifs_rdma_info {
 	struct completion negotiate_completion;
 	bool negotiate_done;
 
+	struct work_struct destroy_work;
+
 	//connection paramters
 	int receive_credit_max;
 	int send_credit_target;
-- 
2.7.4
