From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 09/37] [CIFS] SMBD: Add SMBD request and cache
Date: Wed,  2 Aug 2017 13:10:20 -0700
Message-ID: <1501704648-20159-10-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Define SMBD request. Unlike SMBD response, SMBD request doesn't use pre-allocated buffers. Data payload is passed from upper layer provided data buffers. SMBD requests are allocated through per-channel mempool.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 12 ++++++++++++
 fs/cifs/cifsrdma.h | 19 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index b3e43b1..9610897 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -459,6 +459,18 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 
 	log_rdma_event("rdma_connect connected\n");
 
+	sprintf(cache_name, "cifs_smbd_request_%p", info);
+	info->request_cache =
+		kmem_cache_create(
+			cache_name,
+			sizeof(struct cifs_rdma_request) +
+				sizeof(struct smbd_data_transfer),
+			0, SLAB_HWCACHE_ALIGN, NULL);
+
+	info->request_mempool =
+		mempool_create(info->send_credit_target, mempool_alloc_slab,
+			mempool_free_slab, info->request_cache);
+
 	sprintf(cache_name, "cifs_smbd_response_%p", info);
 	info->response_cache =
 		kmem_cache_create(
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index ed0ff54..e925aa4 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -62,6 +62,10 @@ struct cifs_rdma_info {
 	struct list_head receive_queue;
 	spinlock_t receive_queue_lock;
 
+	// request pool for RDMA send
+	struct kmem_cache *request_cache;
+	mempool_t *request_mempool;
+
 	// response pool for RDMA receive
 	struct kmem_cache *response_cache;
 	mempool_t *response_mempool;
@@ -93,6 +97,21 @@ struct smbd_data_transfer {
 	char buffer[0];
 } __packed;
 
+// The context for a SMBD request
+struct cifs_rdma_request {
+	struct cifs_rdma_info *info;
+
+	// completion queue entry
+	struct ib_cqe cqe;
+
+	// the SGE entries for this packet
+	struct ib_sge *sge;
+	int num_sge;
+
+	// SMBD packet header follows this structure
+	char packet[0];
+};
+
 // The context for a SMBD response
 struct cifs_rdma_response {
 	struct cifs_rdma_info *info;
-- 
2.7.4
