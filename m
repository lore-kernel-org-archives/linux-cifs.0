From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 28/37] [CIFS] SMBD: Implement API for upper layer to destroy the transport
Date: Wed,  2 Aug 2017 13:10:39 -0700
Message-ID: <1501704648-20159-29-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Upper layer calls to destroy transport when SMB directory is umounted or system is in shutdown state. SMBD is responsible for disconnecting from remote peer and freeing all the resources after it's disconnected.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 20 ++++++++++++++++++++
 fs/cifs/cifsrdma.h |  4 ++++
 2 files changed, 24 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index a1ef7f6..fb94975 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -193,6 +193,7 @@ static void cifs_destroy_rdma_work(struct work_struct *work)
 	kmem_cache_destroy(info->response_cache);
 
 	info->transport_status = CIFS_RDMA_DESTROYED;
+	wake_up_all(&info->wait_destroy);
 }
 
 static int cifs_rdma_process_disconnected(struct cifs_rdma_info *info)
@@ -1315,6 +1316,22 @@ static void idle_connection_timer(struct work_struct *work)
 				info->keep_alive_interval*HZ);
 }
 
+void cifs_destroy_rdma_session(struct cifs_rdma_info *info)
+{
+	log_rdma_event("destroying rdma session\n");
+
+	// kick off the disconnection process
+	if (info->transport_status == CIFS_RDMA_CONNECTED)
+		rdma_disconnect(info->id);
+
+	info->server_info->tcpStatus = CifsExiting;
+
+	log_rdma_event("wait for transport being destroyed\n");
+	// wait until the transport is destroyed
+	wait_event(info->wait_destroy,
+		info->transport_status == CIFS_RDMA_DESTROYED);
+}
+
 int cifs_reconnect_rdma_session(struct TCP_Server_Info *server)
 {
 	log_rdma_event("reconnecting rdma session\n");
@@ -1423,6 +1440,8 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	conn_param.rnr_retry_count = 6;
 	conn_param.flow_control = 0;
 	init_waitqueue_head(&info->conn_wait);
+	init_waitqueue_head(&info->wait_destroy);
+
 	rc = rdma_connect(info->id, &conn_param);
 	if (rc) {
 		log_rdma_event("rdma_connect() failed with %i\n", rc);
@@ -1483,6 +1502,7 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 
 	// negotiation failed
 	log_rdma_event("cifs_rdma_negotiate rc=%d\n", rc);
+	cifs_destroy_rdma_session(info);
 
 out2:
 	rdma_destroy_id(info->id);
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 5d0d86d..424ea8e 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -62,6 +62,7 @@ struct cifs_rdma_info {
 	int ri_rc;
 	struct completion ri_done;
 	wait_queue_head_t conn_wait;
+	wait_queue_head_t wait_destroy;
 
 	struct completion negotiate_completion;
 	bool negotiate_done;
@@ -229,6 +230,9 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 // Reconnect SMBDirect session
 int cifs_reconnect_rdma_session(struct TCP_Server_Info *server);
 
+// Destroy SMBDirect session
+void cifs_destroy_rdma_session(struct cifs_rdma_info *info);
+
 // SMBDirect interface for carrying upper layer CIFS I/O
 int cifs_rdma_read(
 	struct cifs_rdma_info *rdma, char *buf, unsigned int to_read);
-- 
2.7.4
