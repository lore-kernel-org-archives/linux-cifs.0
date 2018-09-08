From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v3 10/16] CIFS: SMBD: Do not call ib_dereg_mr on invalidated memory registration
Date: Sat,  8 Sep 2018 02:13:42 +0000
Message-ID: <20180908021348.19956-11-longli@linuxonhyperv.com>
References: <20180908021348.19956-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180908021348.19956-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

It is not necessary to deregister a memory registration after it has been
successfully invalidated.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 82 ++++++++++++++++++++++++++---------------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index ba53c52..b470cd0 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2296,50 +2296,50 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 	int rc;
 
 	list_for_each_entry(smbdirect_mr, &info->mr_list, list) {
-		if (smbdirect_mr->state == MR_INVALIDATED ||
-			smbdirect_mr->state == MR_ERROR) {
-
-			if (smbdirect_mr->state == MR_INVALIDATED) {
-				ib_dma_unmap_sg(
-					info->id->device, smbdirect_mr->sgl,
-					smbdirect_mr->sgl_count,
-					smbdirect_mr->dir);
-				smbdirect_mr->state = MR_READY;
-			} else if (smbdirect_mr->state == MR_ERROR) {
-
-				/* recover this MR entry */
-				rc = ib_dereg_mr(smbdirect_mr->mr);
-				if (rc) {
-					log_rdma_mr(ERR,
-						"ib_dereg_mr failed rc=%x\n",
-						rc);
-					smbd_disconnect_rdma_connection(info);
-				}
+		if (smbdirect_mr->state == MR_INVALIDATED)
+			ib_dma_unmap_sg(
+				info->id->device, smbdirect_mr->sgl,
+				smbdirect_mr->sgl_count,
+				smbdirect_mr->dir);
+		else if (smbdirect_mr->state == MR_ERROR) {
+
+			/* recover this MR entry */
+			rc = ib_dereg_mr(smbdirect_mr->mr);
+			if (rc) {
+				log_rdma_mr(ERR,
+					"ib_dereg_mr failed rc=%x\n",
+					rc);
+				smbd_disconnect_rdma_connection(info);
+				continue;
+			}
 
-				smbdirect_mr->mr = ib_alloc_mr(
-					info->pd, info->mr_type,
+			smbdirect_mr->mr = ib_alloc_mr(
+				info->pd, info->mr_type,
+				info->max_frmr_depth);
+			if (IS_ERR(smbdirect_mr->mr)) {
+				log_rdma_mr(ERR,
+					"ib_alloc_mr failed mr_type=%x "
+					"max_frmr_depth=%x\n",
+					info->mr_type,
 					info->max_frmr_depth);
-				if (IS_ERR(smbdirect_mr->mr)) {
-					log_rdma_mr(ERR,
-						"ib_alloc_mr failed mr_type=%x "
-						"max_frmr_depth=%x\n",
-						info->mr_type,
-						info->max_frmr_depth);
-					smbd_disconnect_rdma_connection(info);
-				}
-
-				smbdirect_mr->state = MR_READY;
+				smbd_disconnect_rdma_connection(info);
+				continue;
 			}
-			/* smbdirect_mr->state is updated by this function
-			 * and is read and updated by I/O issuing CPUs trying
-			 * to get a MR, the call to atomic_inc_return
-			 * implicates a memory barrier and guarantees this
-			 * value is updated before waking up any calls to
-			 * get_mr() from the I/O issuing CPUs
-			 */
-			if (atomic_inc_return(&info->mr_ready_count) == 1)
-				wake_up_interruptible(&info->wait_mr);
-		}
+		} else
+			/* This MR is being used, don't recover it */
+			continue;
+
+		smbdirect_mr->state = MR_READY;
+
+		/* smbdirect_mr->state is updated by this function
+		 * and is read and updated by I/O issuing CPUs trying
+		 * to get a MR, the call to atomic_inc_return
+		 * implicates a memory barrier and guarantees this
+		 * value is updated before waking up any calls to
+		 * get_mr() from the I/O issuing CPUs
+		 */
+		if (atomic_inc_return(&info->mr_ready_count) == 1)
+			wake_up_interruptible(&info->wait_mr);
 	}
 }
 
-- 
2.7.4
