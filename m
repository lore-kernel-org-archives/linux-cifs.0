From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 1/7] cifs: smbd: Make upper layer decide when to destroy the transport
Date: Mon,  7 May 2018 15:20:00 -0700
Message-ID: <20180507222006.20781-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

On transport recoonect, upper layer CIFS code destroys the current
transport and then recoonect. This code path is not used by SMBD, in that
SMBD destroys its transport on RDMA disconnect notification independent of
CIFS upper layer behavior.

This approach adds some costs to SMBD layer to handle transport shutdown
and restart, and to deal with several racing conditions on reconnecting
transport.

Re-work this code path by introducing a new smbd_destroy. This function is
called form upper layer to ask SMBD to destroy the transport. SMBD will no
longer need to destroy the transport by itself while worrying about data
transfer is in progress. The upper layer guarantees the transport is
locked.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c   |   9 ++---
 fs/cifs/smbdirect.c | 114 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/smbdirect.h |   3 +-
 3 files changed, 100 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 83b0234..5db3e9d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -377,7 +377,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
 			 server->ssocket->state, server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
-	}
+	} else if (cifs_rdma_enabled(server))
+		smbd_destroy(server);
 	server->sequence_number = 0;
 	server->session_estab = false;
 	kfree(server->session_key.response);
@@ -710,10 +711,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	wake_up_all(&server->request_q);
 	/* give those requests time to exit */
 	msleep(125);
-	if (cifs_rdma_enabled(server) && server->smbd_conn) {
-		smbd_destroy(server->smbd_conn);
-		server->smbd_conn = NULL;
-	}
+	if (cifs_rdma_enabled(server))
+		smbd_destroy(server);
 	if (server->ssocket) {
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index c62f7c9..1aa2d35 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -318,6 +318,9 @@ static int smbd_conn_upcall(
 
 		info->transport_status = SMBD_DISCONNECTED;
 		smbd_process_disconnected(info);
+		wake_up(&info->disconn_wait);
+		wake_up_interruptible(&info->wait_reassembly_queue);
+		wake_up_interruptible_all(&info->wait_send_queue);
 		break;
 
 	default:
@@ -1476,17 +1479,97 @@ static void idle_connection_timer(struct work_struct *work)
 			info->keep_alive_interval*HZ);
 }
 
-/* Destroy this SMBD connection, called from upper layer */
-void smbd_destroy(struct smbd_connection *info)
+/*
+ * Destroy the transport and related RDMA and memory resources
+ * Need to go through all the pending counters and make sure on one is using
+ * the transport while it is destroyed
+ */
+void smbd_destroy(struct TCP_Server_Info *server)
 {
+	struct smbd_connection *info = server->smbd_conn;
+	struct smbd_response *response;
+	unsigned long flags;
+
+	if (!info) {
+		log_rdma_event(INFO, "rdma session already destroyed\n");
+		return;
+	}
+
 	log_rdma_event(INFO, "destroying rdma session\n");
+	if (info->transport_status != SMBD_DISCONNECTED) {
+		rdma_disconnect(server->smbd_conn->id);
+		log_rdma_event(INFO, "wait for transport being disconnected\n");
+		wait_event(
+			info->disconn_wait,
+			info->transport_status == SMBD_DISCONNECTED);
+	}
 
-	/* Kick off the disconnection process */
-	smbd_disconnect_rdma_connection(info);
+	log_rdma_event(INFO, "destroying qp\n");
+	ib_drain_qp(info->id->qp);
+	rdma_destroy_qp(info->id);
+
+	log_rdma_event(INFO, "cancelling idle timer\n");
+	cancel_delayed_work_sync(&info->idle_timer_work);
+	log_rdma_event(INFO, "cancelling send immediate work\n");
+	cancel_delayed_work_sync(&info->send_immediate_work);
 
-	log_rdma_event(INFO, "wait for transport being destroyed\n");
-	wait_event(info->wait_destroy,
-		info->transport_status == SMBD_DESTROYED);
+	log_rdma_event(INFO, "wait for all send posted to IB to finish\n");
+	wait_event(info->wait_send_pending,
+		atomic_read(&info->send_pending) == 0);
+	wait_event(info->wait_send_payload_pending,
+		atomic_read(&info->send_payload_pending) == 0);
+
+	/* It's not posssible for upper layer to get to reassembly */
+	log_rdma_event(INFO, "drain the reassembly queue\n");
+	do {
+		spin_lock_irqsave(&info->reassembly_queue_lock, flags);
+		response = _get_first_reassembly(info);
+		if (response) {
+			list_del(&response->list);
+			spin_unlock_irqrestore(
+				&info->reassembly_queue_lock, flags);
+			put_receive_buffer(info, response);
+		} else
+			spin_unlock_irqrestore(
+				&info->reassembly_queue_lock, flags);
+	} while (response);
+	info->reassembly_data_length = 0;
+
+	log_rdma_event(INFO, "free receive buffers\n");
+	wait_event(info->wait_receive_queues,
+		info->count_receive_queue + info->count_empty_packet_queue
+			== info->receive_credit_max);
+	destroy_receive_buffers(info);
+
+	/*
+	 * For performance reasons, memory registration and deregistration
+	 * are not locked by srv_mutex. It is possible some processes are
+	 * blocked on transport srv_mutex while holding memory registration.
+	 * Release the transport srv_mutex to allow them to hit the failure
+	 * path when sending data, and then release memory registartions.
+	 */
+	log_rdma_event(INFO, "freeing mr list\n");
+	wake_up_interruptible_all(&info->wait_mr);
+	while (atomic_read(&info->mr_used_count)) {
+		mutex_unlock(&server->srv_mutex);
+		msleep(1000);
+		mutex_lock(&server->srv_mutex);
+	}
+	destroy_mr_list(info);
+
+	ib_free_cq(info->send_cq);
+	ib_free_cq(info->recv_cq);
+	ib_dealloc_pd(info->pd);
+	rdma_destroy_id(info->id);
+
+	/* free mempools */
+	mempool_destroy(info->request_mempool);
+	kmem_cache_destroy(info->request_cache);
+
+	mempool_destroy(info->response_mempool);
+	kmem_cache_destroy(info->response_cache);
+
+	info->transport_status = SMBD_DESTROYED;
 
 	destroy_workqueue(info->workqueue);
 	kfree(info);
@@ -1511,17 +1594,9 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 	 */
 	if (server->smbd_conn->transport_status == SMBD_CONNECTED) {
 		log_rdma_event(INFO, "disconnecting transport\n");
-		smbd_disconnect_rdma_connection(server->smbd_conn);
+		smbd_destroy(server);
 	}
 
-	/* wait until the transport is destroyed */
-	if (!wait_event_timeout(server->smbd_conn->wait_destroy,
-		server->smbd_conn->transport_status == SMBD_DESTROYED, 5*HZ))
-		return -EAGAIN;
-
-	destroy_workqueue(server->smbd_conn->workqueue);
-	kfree(server->smbd_conn);
-
 create_conn:
 	log_rdma_event(INFO, "creating rdma session\n");
 	server->smbd_conn = smbd_get_connection(
@@ -1730,12 +1805,13 @@ static struct smbd_connection *_smbd_get_connection(
 	conn_param.retry_count = SMBD_CM_RETRY;
 	conn_param.rnr_retry_count = SMBD_CM_RNR_RETRY;
 	conn_param.flow_control = 0;
-	init_waitqueue_head(&info->wait_destroy);
 
 	log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
 		&addr_in->sin_addr, port);
 
 	init_waitqueue_head(&info->conn_wait);
+	init_waitqueue_head(&info->disconn_wait);
+	init_waitqueue_head(&info->wait_reassembly_queue);
 	rc = rdma_connect(info->id, &conn_param);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_connect() failed with %i\n", rc);
@@ -1759,8 +1835,6 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	init_waitqueue_head(&info->wait_send_queue);
-	init_waitqueue_head(&info->wait_reassembly_queue);
-
 	INIT_DELAYED_WORK(&info->idle_timer_work, idle_connection_timer);
 	INIT_DELAYED_WORK(&info->send_immediate_work, send_immediate_work);
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
@@ -1801,7 +1875,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_mr_failed:
 	/* At this point, need to a full transport shutdown */
-	smbd_destroy(info);
+	smbd_destroy(server);
 	return NULL;
 
 negotiation_failed:
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index f9038da..7849989 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -71,6 +71,7 @@ struct smbd_connection {
 	struct completion ri_done;
 	wait_queue_head_t conn_wait;
 	wait_queue_head_t wait_destroy;
+	wait_queue_head_t disconn_wait;
 
 	struct completion negotiate_completion;
 	bool negotiate_done;
@@ -288,7 +289,7 @@ struct smbd_connection *smbd_get_connection(
 /* Reconnect SMBDirect session */
 int smbd_reconnect(struct TCP_Server_Info *server);
 /* Destroy SMBDirect session */
-void smbd_destroy(struct smbd_connection *info);
+void smbd_destroy(struct TCP_Server_Info *server);
 
 /* Interface for carrying upper layer I/O through send/recv */
 int smbd_recv(struct smbd_connection *info, struct msghdr *msg);
-- 
2.7.4
