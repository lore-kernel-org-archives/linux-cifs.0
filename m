From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 2/2] cifs: smbd: disconnect transport on RDMA errors
Date: Fri, 30 Mar 2018 15:16:36 -0700
Message-ID: <20180330221636.32512-2-longli@linuxonhyperv.com>
References: <20180330221636.32512-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180330221636.32512-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

On RDMA errors, transport should disconnect the RDMA CM connection. This
will notify the upper layer, and it will attempt transport reconnect.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 3f7883e..5008af5 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -862,6 +862,8 @@ static int smbd_post_send_negotiate_req(struct smbd_connection *info)
 	ib_dma_unmap_single(info->id->device, request->sge[0].addr,
 		request->sge[0].length, DMA_TO_DEVICE);
 
+	smbd_disconnect_rdma_connection(info);
+
 dma_mapping_failed:
 	mempool_free(request, info->request_mempool);
 	return rc;
@@ -1061,6 +1063,7 @@ static int smbd_post_send(struct smbd_connection *info,
 			if (atomic_dec_and_test(&info->send_pending))
 				wake_up(&info->wait_send_pending);
 		}
+		smbd_disconnect_rdma_connection(info);
 	} else
 		/* Reset timer for idle connection after packet is sent */
 		mod_delayed_work(info->workqueue, &info->idle_timer_work,
@@ -1202,7 +1205,7 @@ static int smbd_post_recv(
 	if (rc) {
 		ib_dma_unmap_single(info->id->device, response->sge.addr,
 				    response->sge.length, DMA_FROM_DEVICE);
-
+		smbd_disconnect_rdma_connection(info);
 		log_rdma_recv(ERR, "ib_post_recv failed rc=%d\n", rc);
 	}
 
@@ -2546,6 +2549,8 @@ struct smbd_mr *smbd_register_mr(
 	if (atomic_dec_and_test(&info->mr_used_count))
 		wake_up(&info->wait_for_mr_cleanup);
 
+	smbd_disconnect_rdma_connection(info);
+
 	return NULL;
 }
 
-- 
2.7.4
