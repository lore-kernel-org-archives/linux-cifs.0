From: Long Li <longli@linuxonhyperv.com>
Subject: [RFC PATCH 05/09] Change RDMA send to regonize page offset in the 1st page
Date: Thu, 17 May 2018 17:22:10 -0700
Message-ID: <20180518002214.5657-6-longli@linuxonhyperv.com>
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

When doing RDMA send, the offset needs to be checked as data may start in an offset
in the 1st page.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c   |  3 ++-
 fs/cifs/smbdirect.c | 25 +++++++++++++++++++------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5097f28..fdcf97e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3015,7 +3015,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
-	rqst.rq_pages = wdata->pages;
+	rqst.rq_pages = wdata->direct_pages ? wdata->direct_pages : wdata->pages;
+	rqst.rq_offset = wdata->page_offset;
 	rqst.rq_npages = wdata->nr_pages;
 	rqst.rq_pagesz = wdata->pagesz;
 	rqst.rq_tailsz = wdata->tailsz;
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b0a1955..b46586d 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2084,8 +2084,10 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
 
 	/* add in the page array if there is one */
 	if (rqst->rq_npages) {
-		buflen += rqst->rq_pagesz * (rqst->rq_npages - 1);
-		buflen += rqst->rq_tailsz;
+		if (rqst->rq_npages == 1)
+			buflen += rqst->rq_tailsz;
+		else
+			buflen += rqst->rq_pagesz * (rqst->rq_npages - 1) - rqst->rq_offset + rqst->rq_tailsz;
 	}
 
 	if (buflen + sizeof(struct smbd_data_transfer) >
@@ -2182,8 +2184,19 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
 
 	/* now sending pages if there are any */
 	for (i = 0; i < rqst->rq_npages; i++) {
-		buflen = (i == rqst->rq_npages-1) ?
-			rqst->rq_tailsz : rqst->rq_pagesz;
+		unsigned int offset = 0;
+		if (i == 0)
+			offset = rqst->rq_offset;
+		if (rqst->rq_npages == 1 || i == rqst->rq_npages-1)
+			buflen = rqst->rq_tailsz;
+		else {
+			/* We have at least two pages, and this is not the last page */
+			if (i == 0)
+				buflen = rqst->rq_pagesz - rqst->rq_offset;
+			else
+				buflen = rqst->rq_pagesz;
+		}
+
 		nvecs = (buflen + max_iov_size - 1) / max_iov_size;
 		log_write(INFO, "sending pages buflen=%d nvecs=%d\n",
 			buflen, nvecs);
@@ -2194,9 +2207,9 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
 			remaining_data_length -= size;
 			log_write(INFO, "sending pages i=%d offset=%d size=%d"
 				" remaining_data_length=%d\n",
-				i, j*max_iov_size, size, remaining_data_length);
+				i, j*max_iov_size+offset, size, remaining_data_length);
 			rc = smbd_post_send_page(
-				info, rqst->rq_pages[i], j*max_iov_size,
+				info, rqst->rq_pages[i], j*max_iov_size + offset,
 				size, remaining_data_length);
 			if (rc)
 				goto done;
-- 
2.7.4
