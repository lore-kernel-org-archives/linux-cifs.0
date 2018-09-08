From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v3 04/16] CIFS: pass page offset when issuing SMB write
Date: Sat,  8 Sep 2018 02:13:36 +0000
Message-ID: <20180908021348.19956-5-longli@linuxonhyperv.com>
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

When issuing SMB writes, pass along the write data page offset to transport.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifssmb.c | 1 +
 fs/cifs/smb2pdu.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 503e0ed..0a57c61 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2200,6 +2200,7 @@ cifs_async_writev(struct cifs_writedata *wdata,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
 	rqst.rq_pages = wdata->pages;
+	rqst.rq_offset = wdata->page_offset;
 	rqst.rq_npages = wdata->nr_pages;
 	rqst.rq_pagesz = wdata->pagesz;
 	rqst.rq_tailsz = wdata->tailsz;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6c22da8..f603fbe 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3046,6 +3046,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
 	rqst.rq_pages = wdata->pages;
+	rqst.rq_offset = wdata->page_offset;
 	rqst.rq_npages = wdata->nr_pages;
 	rqst.rq_pagesz = wdata->pagesz;
 	rqst.rq_tailsz = wdata->tailsz;
-- 
2.7.4
