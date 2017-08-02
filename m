From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 17/37] [CIFS] SMBD: Track status for transport
Date: Wed,  2 Aug 2017 13:10:28 -0700
Message-ID: <1501704648-20159-18-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Introduce status for tracking the status of SMBD transport. They are used in transport reconnect and shutdown.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 25 +++++++++++++++++++++++++
 fs/cifs/cifsrdma.h | 11 +++++++++++
 2 files changed, 36 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index cf71bb1..ef21f1c 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -173,9 +173,12 @@ static int cifs_rdma_conn_upcall(
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		log_rdma_event("connected event=%d\n", event->event);
 		info->connect_state = event->event;
+		info->transport_status = CIFS_RDMA_CONNECTED;
+		wake_up_all(&info->conn_wait);
 		break;
 
 	case RDMA_CM_EVENT_DISCONNECTED:
+		info->transport_status = CIFS_RDMA_DISCONNECTED;
 		break;
 
 	default:
@@ -581,6 +584,12 @@ static int cifs_rdma_post_send_page(struct cifs_rdma_info *info, struct page *pa
 	int rc = -ENOMEM;
 	int i;
 
+	// disconnected?
+	if (info->transport_status != CIFS_RDMA_CONNECTED) {
+		log_outgoing("disconnected not sending\n");
+		return -ENOENT;
+	}
+
 	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
 	if (!request)
 		return rc;
@@ -686,6 +695,12 @@ static int cifs_rdma_post_send_empty(struct cifs_rdma_info *info)
 	int rc;
 	u16 credits_granted, flags=0;
 
+	// disconnected?
+	if (info->transport_status != CIFS_RDMA_CONNECTED) {
+		log_outgoing("disconnected not sending\n");
+		return -ENOENT;
+	}
+
 	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
 	if (!request) {
 		log_rdma_send("failed to get send buffer for empty packet\n");
@@ -785,6 +800,12 @@ static int cifs_rdma_post_send_data(
 	int rc = -ENOMEM, i;
 	u32 data_length;
 
+	// disconnected?
+	if (info->transport_status != CIFS_RDMA_CONNECTED) {
+		log_outgoing("disconnected not sending\n");
+		return -ENOENT;
+	}
+
 	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
 	if (!request)
 		return rc;
@@ -1056,6 +1077,7 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 		return NULL;
 
 	info->server_info = server;
+	info->transport_status = CIFS_RDMA_CONNECTING;
 
 	rc = cifs_rdma_ia_open(info, dstaddr);
 	if (rc) {
@@ -1122,12 +1144,15 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	conn_param.retry_count = 6;
 	conn_param.rnr_retry_count = 6;
 	conn_param.flow_control = 0;
+	init_waitqueue_head(&info->conn_wait);
 	rc = rdma_connect(info->id, &conn_param);
 	if (rc) {
 		log_rdma_event("rdma_connect() failed with %i\n", rc);
 		goto out2;
 	}
 
+	wait_event_interruptible(
+		info->conn_wait, info->transport_status == CIFS_RDMA_CONNECTED);
 	if (info->connect_state != RDMA_CM_EVENT_ESTABLISHED)
 		goto out2;
 
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 4a4c191..9618e0b 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -25,6 +25,15 @@
 #include <rdma/rdma_cm.h>
 #include <linux/mempool.h>
 
+enum cifs_rdma_transport_status {
+	CIFS_RDMA_CREATED,
+	CIFS_RDMA_CONNECTING,
+	CIFS_RDMA_CONNECTED,
+	CIFS_RDMA_DISCONNECTING,
+	CIFS_RDMA_DISCONNECTED,
+	CIFS_RDMA_DESTROYED
+};
+
 /*
  * The context for the SMBDirect transport
  * Everything related to the transport is here. It has several logical parts
@@ -35,6 +44,7 @@
  */
 struct cifs_rdma_info {
 	struct TCP_Server_Info *server_info;
+	enum cifs_rdma_transport_status transport_status;
 
 	// RDMA related
 	struct rdma_cm_id *id;
@@ -45,6 +55,7 @@ struct cifs_rdma_info {
 	int connect_state;
 	int ri_rc;
 	struct completion ri_done;
+	wait_queue_head_t conn_wait;
 
 	struct completion negotiate_completion;
 	bool negotiate_done;
-- 
2.7.4
