From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 06/37] [CIFS] SMBD: Add definition and cache for SMBD response
Date: Wed,  2 Aug 2017 13:10:17 -0700
Message-ID: <1501704648-20159-7-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Define the data structure for receiving a SMBD response. SMBD responses are allocated through a per-channel mempool. For each server initiated response message, the SMB client must post a SMBD response to the local hardware.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 13 +++++++++++++
 fs/cifs/cifsrdma.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index b18fb79..1636304 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -287,6 +287,7 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	struct cifs_rdma_info *info;
 	struct rdma_conn_param conn_param;
 	struct ib_qp_init_attr qp_attr;
+	char cache_name[80];
 	int max_pending = receive_credit_max + send_credit_target;
 
 	info = kzalloc(sizeof(struct cifs_rdma_info), GFP_KERNEL);
@@ -370,6 +371,18 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 		goto out2;
 
 	log_rdma_event("rdma_connect connected\n");
+
+	sprintf(cache_name, "cifs_smbd_response_%p", info);
+	info->response_cache =
+		kmem_cache_create(
+			cache_name,
+			sizeof(struct cifs_rdma_response) +
+				info->max_receive_size,
+			0, SLAB_HWCACHE_ALIGN, NULL);
+
+	info->response_mempool =
+		mempool_create(info->receive_credit_max, mempool_alloc_slab,
+		       mempool_free_slab, info->response_cache);
 out2:
 	rdma_destroy_id(info->id);
 
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 71ea380..41ae61a 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -59,6 +59,10 @@ struct cifs_rdma_info {
 	atomic_t receive_credits;
 	atomic_t receive_credit_target;
 
+	// response pool for RDMA receive
+	struct kmem_cache *response_cache;
+	mempool_t *response_mempool;
+
 	// for debug purposes
 	unsigned int count_receive_buffer;
 	unsigned int count_get_receive_buffer;
@@ -66,6 +70,33 @@ struct cifs_rdma_info {
 	unsigned int count_send_empty;
 };
 
+enum smbd_message_type {
+	SMBD_NEGOTIATE_RESP,
+	SMBD_TRANSFER_DATA,
+};
+
+// The context for a SMBD response
+struct cifs_rdma_response {
+	struct cifs_rdma_info *info;
+
+	// completion queue entry
+	struct ib_cqe cqe;
+
+	// the SGE entry for the packet
+	struct ib_sge sge;
+
+	enum smbd_message_type type;
+
+	// link to receive queue or reassembly queue
+	struct list_head list;
+
+	// indicate if this is the 1st packet of a payload
+	bool first_segment;
+
+	// SMBD packet header and payload follows this structure
+	char packet[0];
+};
+
 // Create a SMBDirect session
 struct cifs_rdma_info* cifs_create_rdma_session(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
-- 
2.7.4
