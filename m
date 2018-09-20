From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH V3 (resend) 2/7] CIFS: SMBD: Do not call ib_dereg_mr on invalidated memory registration
Date: Thu, 20 Sep 2018 21:18:39 +0000
Message-ID: <20180920211842.13721-2-longli@linuxonhyperv.com>
References: <20180920211842.13721-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920211842.13721-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

It is not necessary to deregister a memory registration after it has been
successfully invalidated.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5fdb9a5..5e28236 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2295,8 +2295,12 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 	int rc;
 
 	list_for_each_entry(smbdirect_mr, &info->mr_list, list) {
-		if (smbdirect_mr->state == MR_INVALIDATED ||
-			smbdirect_mr->state == MR_ERROR) {
+		if (smbdirect_mr->state == MR_INVALIDATED)
+			ib_dma_unmap_sg(
+				info->id->device, smbdirect_mr->sgl,
+				smbdirect_mr->sgl_count,
+				smbdirect_mr->dir);
+		else if (smbdirect_mr->state == MR_ERROR) {
 
 			/* recover this MR entry */
 			rc = ib_dereg_mr(smbdirect_mr->mr);
@@ -2320,25 +2324,21 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 				smbd_disconnect_rdma_connection(info);
 				continue;
 			}
+		} else
+			/* This MR is being used, don't recover it */
+			continue;
 
-			if (smbdirect_mr->state == MR_INVALIDATED)
-				ib_dma_unmap_sg(
-					info->id->device, smbdirect_mr->sgl,
-					smbdirect_mr->sgl_count,
-					smbdirect_mr->dir);
-
-			smbdirect_mr->state = MR_READY;
+		smbdirect_mr->state = MR_READY;
 
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
