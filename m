From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 18/19] CIFS: SMBD: Deregister memory when finishing SMB READ
Date: Sun, 20 Aug 2017 12:04:42 -0700
Message-ID: <1503255883-3041-19-git-send-email-longli@exchange.microsoft.com>
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

When SMB READ is finished, deregister the memory regions if RDMA write is used for this SMB READ. smbd_deregister_mr may need to do local invalidation and sleep, if server remote invalidation is not used.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1f08c75..43a7b60 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2504,6 +2504,16 @@ smb2_readv_callback(struct mid_q_entry *mid)
 			rdata->result = -EIO;
 	}
 
+	/*
+	 * If this rdata has a memmory registered, the MR can be freed
+	 * MR needs to be freed as soon as I/O finishes to prevent deadlock
+	 * because they have limited number and are used for future I/Os
+	 */
+	if (rdata->mr) {
+		smbd_deregister_mr(rdata->mr);
+		rdata->mr = NULL;
+	}
+
 	if (rdata->result)
 		cifs_stats_fail_inc(tcon, SMB2_READ_HE);
 
-- 
2.7.4
