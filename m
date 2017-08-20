From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 14/19] CIFS: SMBD: Deregister memory when finishing SMB write
Date: Sun, 20 Aug 2017 12:04:38 -0700
Message-ID: <1503255883-3041-15-git-send-email-longli@exchange.microsoft.com>
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

On write I/O finish, deregister the memory region if this was for a RDMA read. The call to smbd_deregister_mr will do local invalidation and possibly wait, if remote invalidate is not used.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

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
