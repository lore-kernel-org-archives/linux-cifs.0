From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 10/37] [CIFS] SMBD: Introduce wait queue when sending SMBD request
Date: Wed,  2 Aug 2017 13:10:21 -0700
Message-ID: <1501704648-20159-11-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Define wait queue in preparation for implement SMBD send. SMBD uses credit based flow control system, if the client doesn't have enough credits then it must wait for credits.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 1 +
 fs/cifs/cifsrdma.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 9610897..8aa8a47 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -484,6 +484,7 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 		       mempool_free_slab, info->response_cache);
 
 	allocate_receive_buffers(info, info->receive_credit_max);
+	init_waitqueue_head(&info->wait_send_queue);
 out2:
 	rdma_destroy_id(info->id);
 
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index e925aa4..287b5b1 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -62,6 +62,8 @@ struct cifs_rdma_info {
 	struct list_head receive_queue;
 	spinlock_t receive_queue_lock;
 
+	wait_queue_head_t wait_send_queue;
+
 	// request pool for RDMA send
 	struct kmem_cache *request_cache;
 	mempool_t *request_mempool;
-- 
2.7.4
