From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH V3 (resend) 1/7] CIFS: pass page offsets on SMB1 read/write
Date: Thu, 20 Sep 2018 21:18:38 +0000
Message-ID: <20180920211842.13721-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When issuing SMB1 read/write, pass the page offset to transport.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifssmb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 41329f4..f82fd34 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1607,6 +1607,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
 				 .rq_nvec = 2,
 				 .rq_pages = rdata->pages,
+				 .rq_offset = rdata->page_offset,
 				 .rq_npages = rdata->nr_pages,
 				 .rq_pagesz = rdata->pagesz,
 				 .rq_tailsz = rdata->tailsz };
@@ -2210,6 +2211,7 @@ cifs_async_writev(struct cifs_writedata *wdata,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
 	rqst.rq_pages = wdata->pages;
+	rqst.rq_offset = wdata->page_offset;
 	rqst.rq_npages = wdata->nr_pages;
 	rqst.rq_pagesz = wdata->pagesz;
 	rqst.rq_tailsz = wdata->tailsz;
-- 
2.7.4
