From: Long Li <longli@linuxonhyperv.com>
Subject: [RFC PATCH 07/09] Support page offset in memory regsitrations
Date: Thu, 17 May 2018 17:22:12 -0700
Message-ID: <20180518002214.5657-8-longli@linuxonhyperv.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518002214.5657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Now momory registration needs to recognize offset in page when direct transfer is
used.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c   | 19 +++++++++-----
 fs/cifs/smbdirect.c | 74 +++++++++++++++++++++++++++++++----------------------
 fs/cifs/smbdirect.h |  2 +-
 3 files changed, 57 insertions(+), 38 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index fdcf97e..a23c7cb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2586,6 +2586,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	req->MinimumCount = 0;
 	req->Length = cpu_to_le32(io_parms->length);
 	req->Offset = cpu_to_le64(io_parms->offset);
+	if (!rdata->tailsz)
+		rdata->tailsz = rdata->pagesz;
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
 	 * If we want to do a RDMA write, fill in and append
@@ -2601,8 +2603,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		rcu_read_lock();
 		rcu_dereference(server->smbd_conn);
 		rdata->mr = smbd_register_mr(
-				server->smbd_conn, rdata->pages,
-				rdata->nr_pages, rdata->tailsz,
+				server->smbd_conn, rdata->direct_pages ? rdata->direct_pages : rdata->pages,
+				rdata->nr_pages, rdata->page_offset, rdata->tailsz,
 				true, need_invalidate);
 		rcu_read_unlock();
 		if (!rdata->mr)
@@ -2967,6 +2969,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	req->DataOffset = cpu_to_le16(
 				offsetof(struct smb2_write_req, Buffer));
 	req->RemainingBytes = 0;
+	if (!wdata->tailsz)
+		wdata->tailsz = wdata->pagesz;
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
 	 * If we want to do a server RDMA read, fill in and append
@@ -2981,8 +2985,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 		rcu_read_lock();
 		rcu_dereference(server->smbd_conn);
 		wdata->mr = smbd_register_mr(
-				server->smbd_conn, wdata->pages,
-				wdata->nr_pages, wdata->tailsz,
+				server->smbd_conn, wdata->direct_pages ? wdata->direct_pages : wdata->pages,
+				wdata->nr_pages, wdata->page_offset, wdata->tailsz,
 				false, need_invalidate);
 		rcu_read_unlock();
 		if (!wdata->mr) {
@@ -2991,8 +2995,11 @@ smb2_async_writev(struct cifs_writedata *wdata,
 		}
 		req->Length = 0;
 		req->DataOffset = 0;
-		req->RemainingBytes =
-			cpu_to_le32((wdata->nr_pages-1)*PAGE_SIZE + wdata->tailsz);
+		if (wdata->nr_pages > 1)
+			req->RemainingBytes =
+				cpu_to_le32((wdata->nr_pages-1)*PAGE_SIZE - wdata->page_offset + wdata->tailsz);
+		else
+			req->RemainingBytes = cpu_to_le32(wdata->tailsz);
 		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
 		if (need_invalidate)
 			req->Channel = SMB2_CHANNEL_RDMA_V1;
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 939c289..bce1e7a 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2267,37 +2267,37 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 		if (smbdirect_mr->state == MR_INVALIDATED ||
 			smbdirect_mr->state == MR_ERROR) {
 
-			if (smbdirect_mr->state == MR_INVALIDATED) {
+			/* recover this MR entry */
+			rc = ib_dereg_mr(smbdirect_mr->mr);
+			if (rc) {
+				log_rdma_mr(ERR,
+					"ib_dereg_mr failed rc=%x\n",
+					rc);
+				smbd_disconnect_rdma_connection(info);
+				continue;
+			}
+
+			smbdirect_mr->mr = ib_alloc_mr(
+				info->pd, info->mr_type,
+				info->max_frmr_depth);
+			if (IS_ERR(smbdirect_mr->mr)) {
+				log_rdma_mr(ERR,
+					"ib_alloc_mr failed mr_type=%x "
+					"max_frmr_depth=%x\n",
+					info->mr_type,
+					info->max_frmr_depth);
+				smbd_disconnect_rdma_connection(info);
+				continue;
+			}
+
+			if (smbdirect_mr->state == MR_INVALIDATED)
 				ib_dma_unmap_sg(
 					info->id->device, smbdirect_mr->sgl,
 					smbdirect_mr->sgl_count,
 					smbdirect_mr->dir);
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
 
-				smbdirect_mr->mr = ib_alloc_mr(
-					info->pd, info->mr_type,
-					info->max_frmr_depth);
-				if (IS_ERR(smbdirect_mr->mr)) {
-					log_rdma_mr(ERR,
-						"ib_alloc_mr failed mr_type=%x "
-						"max_frmr_depth=%x\n",
-						info->mr_type,
-						info->max_frmr_depth);
-					smbd_disconnect_rdma_connection(info);
-				}
+			smbdirect_mr->state = MR_READY;
 
-				smbdirect_mr->state = MR_READY;
-			}
 			/* smbdirect_mr->state is updated by this function
 			 * and is read and updated by I/O issuing CPUs trying
 			 * to get a MR, the call to atomic_inc_return
@@ -2443,7 +2443,7 @@ static struct smbd_mr *get_mr(struct smbd_connection *info)
  */
 struct smbd_mr *smbd_register_mr(
 	struct smbd_connection *info, struct page *pages[], int num_pages,
-	int tailsz, bool writing, bool need_invalidate)
+	int offset, int tailsz, bool writing, bool need_invalidate)
 {
 	struct smbd_mr *smbdirect_mr;
 	int rc, i;
@@ -2466,17 +2466,29 @@ struct smbd_mr *smbd_register_mr(
 	smbdirect_mr->sgl_count = num_pages;
 	sg_init_table(smbdirect_mr->sgl, num_pages);
 
-	for (i = 0; i < num_pages - 1; i++)
-		sg_set_page(&smbdirect_mr->sgl[i], pages[i], PAGE_SIZE, 0);
+	log_rdma_mr(INFO, "num_pages=0x%x offset=0x%x tailsz=0x%x\n", num_pages, offset, tailsz);
 
+	if (num_pages==1) {
+		sg_set_page(&smbdirect_mr->sgl[0], pages[0], tailsz, offset);
+		goto next;
+	}
+
+	/* We have at least two pages to register */
+	sg_set_page(&smbdirect_mr->sgl[0], pages[0], PAGE_SIZE - offset, offset);
+	i = 1;
+	while (i < num_pages - 1) {
+		sg_set_page(&smbdirect_mr->sgl[i], pages[i], PAGE_SIZE, 0);
+		i++;
+	}
 	sg_set_page(&smbdirect_mr->sgl[i], pages[i],
 		tailsz ? tailsz : PAGE_SIZE, 0);
 
+next:
 	dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	smbdirect_mr->dir = dir;
 	rc = ib_dma_map_sg(info->id->device, smbdirect_mr->sgl, num_pages, dir);
 	if (!rc) {
-		log_rdma_mr(INFO, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
+		log_rdma_mr(ERR, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
 			num_pages, dir, rc);
 		goto dma_map_error;
 	}
@@ -2484,8 +2496,8 @@ struct smbd_mr *smbd_register_mr(
 	rc = ib_map_mr_sg(smbdirect_mr->mr, smbdirect_mr->sgl, num_pages,
 		NULL, PAGE_SIZE);
 	if (rc != num_pages) {
-		log_rdma_mr(INFO,
-			"ib_map_mr_sg failed rc = %x num_pages = %x\n",
+		log_rdma_mr(ERR,
+			"ib_map_mr_sg failed rc = %d num_pages = %x\n",
 			rc, num_pages);
 		goto map_mr_error;
 	}
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index f568577..bb1e0c4 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -314,7 +314,7 @@ struct smbd_mr {
 /* Interfaces to register and deregister MR for RDMA read/write */
 struct smbd_mr *smbd_register_mr(
 	struct smbd_connection *info, struct page *pages[], int num_pages,
-	int tailsz, bool writing, bool need_invalidate);
+	int offset, int tailsz, bool writing, bool need_invalidate);
 int smbd_deregister_mr(struct smbd_mr *mr);
 
 #else
-- 
2.7.4
