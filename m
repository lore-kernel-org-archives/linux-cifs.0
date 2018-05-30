From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 01/15] CIFS: Introduce offset for the 1st page in data transfer structures
Date: Wed, 30 May 2018 12:47:53 -0700
Message-ID: <20180530194807.31657-2-longli@linuxonhyperv.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When direct I/O is used, the data buffer may not always align to page
boundaries. Introduce a page offset in transport data structures to
describe the location of the buffer within the page.

Also change the function to pass the page offset when sending data to
transport.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsglob.h | 3 +++
 fs/cifs/smb2pdu.c  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 4f674b7..8d16c3e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -176,6 +176,7 @@ struct smb_rqst {
 	struct kvec	*rq_iov;	/* array of kvecs */
 	unsigned int	rq_nvec;	/* number of kvecs in array */
 	struct page	**rq_pages;	/* pointer to array of page ptrs */
+	unsigned int	rq_offset;	/* the offset to the 1st page */
 	unsigned int	rq_npages;	/* number pages in array */
 	unsigned int	rq_pagesz;	/* page size to use */
 	unsigned int	rq_tailsz;	/* length of last page */
@@ -1174,6 +1175,7 @@ struct cifs_readdata {
 	struct smbd_mr			*mr;
 #endif
 	unsigned int			pagesz;
+	unsigned int			page_offset;
 	unsigned int			tailsz;
 	unsigned int			credits;
 	unsigned int			nr_pages;
@@ -1199,6 +1201,7 @@ struct cifs_writedata {
 	struct smbd_mr			*mr;
 #endif
 	unsigned int			pagesz;
+	unsigned int			page_offset;
 	unsigned int			tailsz;
 	unsigned int			credits;
 	unsigned int			nr_pages;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 47d5331..a02f6b6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3045,6 +3045,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
 	rqst.rq_pages = wdata->pages;
+	rqst.rq_offset = wdata->page_offset;
 	rqst.rq_npages = wdata->nr_pages;
 	rqst.rq_pagesz = wdata->pagesz;
 	rqst.rq_tailsz = wdata->tailsz;
-- 
2.7.4
