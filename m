From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v3 14/19] CIFS: SMBD: Deregister memory on finishing SMB write
Date: Tue, 29 Aug 2017 12:29:10 -0700
Message-ID: <20170829192915.26251-15-longli@exchange.microsoft.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170829192915.26251-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

On write I/O finish, deregister the memory region if this was for a RDMA read.
If remote invalidation is not used, the call to smbd_deregister_mr will do
local invalidation and possibly wait. Memory region is normally deregistered
in MID callback as soon as it's used. There are situations where the MID may
not be created on I/O failure, under which memory region is deregistered when
write data context is released.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifssmb.c |  6 ++++++
 fs/cifs/smb2pdu.c | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index fbb0d4c..6e1de21 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -43,6 +43,7 @@
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
 #include "fscache.h"
+#include "smbdirect.h"
 
 #ifdef CONFIG_CIFS_POSIX
 static struct {
@@ -1905,6 +1906,11 @@ cifs_writedata_release(struct kref *refcount)
 	struct cifs_writedata *wdata = container_of(refcount,
 					struct cifs_writedata, refcount);
 
+	if (wdata->mr) {
+		smbd_deregister_mr(wdata->mr);
+		wdata->mr = NULL;
+	}
+
 	if (wdata->cfile)
 		cifsFileInfo_put(wdata->cfile);
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5581afd..5551053 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2666,6 +2666,18 @@ smb2_writev_callback(struct mid_q_entry *mid)
 		break;
 	}
 
+	/*
+	 * If this wdata has a memory registered, the MR can be freed
+	 * The number of MRs available is limited, it's important to recover
+	 * used MR as soon as I/O is finished. Hold MR longer in the later
+	 * I/O process can possibly result in I/O deadlock due to lack of MR
+	 * to send request on I/O retry
+	 */
+	if (wdata->mr) {
+		smbd_deregister_mr(wdata->mr);
+		wdata->mr = NULL;
+	}
+
 	if (wdata->result)
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 
-- 
2.7.4
