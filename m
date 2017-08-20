From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 11/19] CIFS: SMBD: Define memory registration for I/O data
Date: Sun, 20 Aug 2017 12:04:35 -0700
Message-ID: <1503255883-3041-12-git-send-email-longli@exchange.microsoft.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

To prepare for RDMA read/write using memory registration, add memory registartion pointers to upper layer data I/O context.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsglob.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dc5404d..dcd2b63 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1166,6 +1166,7 @@ struct cifs_readdata {
 				struct cifs_readdata *rdata,
 				struct iov_iter *iter);
 	struct kvec			iov[2];
+	struct smbd_mr			*mr;
 	unsigned int			pagesz;
 	unsigned int			tailsz;
 	unsigned int			credits;
@@ -1188,6 +1189,7 @@ struct cifs_writedata {
 	pid_t				pid;
 	unsigned int			bytes;
 	int				result;
+	struct smbd_mr			*mr;
 	unsigned int			pagesz;
 	unsigned int			tailsz;
 	unsigned int			credits;
-- 
2.7.4
