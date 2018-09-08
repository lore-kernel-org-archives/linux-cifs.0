From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v3 11/16] CIFS: SMBD: Support page offset in memory registration
Date: Sat,  8 Sep 2018 02:13:43 +0000
Message-ID: <20180908021348.19956-12-longli@linuxonhyperv.com>
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

Change code to pass the correct page offset during memory registration for
RDMA read/write.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c   | 18 ++++++++++++------
 fs/cifs/smbdirect.c | 29 +++++++++++++++++++++--------
 fs/cifs/smbdirect.h |  2 +-
 3 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f603fbe..fc30774 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2623,8 +2623,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 
 		rdata->mr = smbd_register_mr(
 				server->smbd_conn, rdata->pages,
-				rdata->nr_pages, rdata->tailsz,
-				true, need_invalidate);
+				rdata->nr_pages, rdata->page_offset,
+				rdata->tailsz, true, need_invalidate);
 		if (!rdata->mr)
 			return -ENOBUFS;
 
@@ -3013,16 +3013,22 @@ smb2_async_writev(struct cifs_writedata *wdata,
 
 		wdata->mr = smbd_register_mr(
 				server->smbd_conn, wdata->pages,
-				wdata->nr_pages, wdata->tailsz,
-				false, need_invalidate);
+				wdata->nr_pages, wdata->page_offset,
+				wdata->tailsz, false, need_invalidate);
 		if (!wdata->mr) {
 			rc = -ENOBUFS;
 			goto async_writev_out;
 		}
 		req->Length = 0;
 		req->DataOffset = 0;
-		req->RemainingBytes =
-			cpu_to_le32((wdata->nr_pages-1)*PAGE_SIZE + wdata->tailsz);
+		if (wdata->nr_pages > 1)
+			req->RemainingBytes =
+				cpu_to_le32(
+					(wdata->nr_pages - 1) * wdata->pagesz -
+					wdata->page_offset + wdata->tailsz
+				);
+		else
+			req->RemainingBytes = cpu_to_le32(wdata->tailsz);
 		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
 		if (need_invalidate)
 			req->Channel = SMB2_CHANNEL_RDMA_V1;
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b470cd0..f61daa9 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2475,7 +2475,7 @@ static struct smbd_mr *get_mr(struct smbd_connection *info)
  */
 struct smbd_mr *smbd_register_mr(
 	struct smbd_connection *info, struct page *pages[], int num_pages,
-	int tailsz, bool writing, bool need_invalidate)
+	int offset, int tailsz, bool writing, bool need_invalidate)
 {
 	struct smbd_mr *smbdirect_mr;
 	int rc, i;
@@ -2498,17 +2498,30 @@ struct smbd_mr *smbd_register_mr(
 	smbdirect_mr->sgl_count = num_pages;
 	sg_init_table(smbdirect_mr->sgl, num_pages);
 
-	for (i = 0; i < num_pages - 1; i++)
-		sg_set_page(&smbdirect_mr->sgl[i], pages[i], PAGE_SIZE, 0);
+	log_rdma_mr(INFO, "num_pages=0x%x offset=0x%x tailsz=0x%x\n",
+			num_pages, offset, tailsz);
+
+	if (num_pages == 1) {
+		sg_set_page(&smbdirect_mr->sgl[0], pages[0], tailsz, offset);
+		goto skip_multiple_pages;
+	}
 
-	sg_set_page(&smbdirect_mr->sgl[i], pages[i],
-		tailsz ? tailsz : PAGE_SIZE, 0);
+	/* We have at least two pages to register */
+	sg_set_page(
+		&smbdirect_mr->sgl[0], pages[0], PAGE_SIZE - offset, offset);
+	i = 1;
+	while (i < num_pages - 1) {
+		sg_set_page(&smbdirect_mr->sgl[i], pages[i], PAGE_SIZE, 0);
+		i++;
+	}
+	sg_set_page(&smbdirect_mr->sgl[i], pages[i], tailsz, 0);
 
+skip_multiple_pages:
 	dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	smbdirect_mr->dir = dir;
 	rc = ib_dma_map_sg(info->id->device, smbdirect_mr->sgl, num_pages, dir);
 	if (!rc) {
-		log_rdma_mr(INFO, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
+		log_rdma_mr(ERR, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
 			num_pages, dir, rc);
 		goto dma_map_error;
 	}
@@ -2516,8 +2529,8 @@ struct smbd_mr *smbd_register_mr(
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
index f9038da..1e419c2 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -321,7 +321,7 @@ struct smbd_mr {
 /* Interfaces to register and deregister MR for RDMA read/write */
 struct smbd_mr *smbd_register_mr(
 	struct smbd_connection *info, struct page *pages[], int num_pages,
-	int tailsz, bool writing, bool need_invalidate);
+	int offset, int tailsz, bool writing, bool need_invalidate);
 int smbd_deregister_mr(struct smbd_mr *mr);
 
 #else
-- 
2.7.4
