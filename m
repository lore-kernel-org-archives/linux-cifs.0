From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 12/37] [CIFS] SMBD: Handle send completion from CQ
Date: Wed,  2 Aug 2017 13:10:23 -0700
Message-ID: <1501704648-20159-13-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

In preparation for handling sending SMBD requests, add code to handle the send completion. In send complemention, the SMBD transport is responsible for freeing resources used in send.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 20237b7..ecbc832 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -197,6 +197,31 @@ cifs_rdma_qp_async_error_upcall(struct ib_event *event, void *context)
 	}
 }
 
+/* Called in softirq, when a RDMA send is donea */
+static void send_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	int i;
+	struct cifs_rdma_request *request =
+		container_of(wc->wr_cqe, struct cifs_rdma_request, cqe);
+
+	log_rdma_send("cifs_rdma_request %p completed wc->status=%d\n",
+		request, wc->status);
+
+	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
+		log_rdma_send("wc->status=%d wc->opcode=%d\n",
+			wc->status, wc->opcode);
+	}
+
+	for (i=0; i<request->num_sge; i++)
+		ib_dma_unmap_single(request->info->id->device,
+			request->sge[i].addr,
+			request->sge[i].length,
+			DMA_TO_DEVICE);
+
+	kfree(request->sge);
+	mempool_free(request, request->info->request_mempool);
+}
+
 /* Called from softirq, when recv is done */
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-- 
2.7.4
