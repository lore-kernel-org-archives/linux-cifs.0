From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v7 11/22] CIFS: SMBD: Implement function to destroy a SMB Direct connection
Date: Tue,  7 Nov 2017 01:55:03 -0700
Message-ID: <20171107085514.12693-12-longli@exchange.microsoft.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107085514.12693-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Add function to tear down a SMB Direct connection. This is used by upper layer
to free all SMB Direct connection and transport resources.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 9f23330..a8e7239 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1392,6 +1392,22 @@ static void idle_connection_timer(struct work_struct *work)
 			info->keep_alive_interval*HZ);
 }
 
+/* Destroy this SMBD connection, called from upper layer */
+void smbd_destroy(struct smbd_connection *info)
+{
+	log_rdma_event(INFO, "destroying rdma session\n");
+
+	/* Kick off the disconnection process */
+	smbd_disconnect_rdma_connection(info);
+
+	log_rdma_event(INFO, "wait for transport being destroyed\n");
+	wait_event(info->wait_destroy,
+		info->transport_status == SMBD_DESTROYED);
+
+	destroy_workqueue(info->workqueue);
+	kfree(info);
+}
+
 /*
  * Reconnect this SMBD connection, called from upper layer
  * return value: 0 on success, or actual error code
-- 
2.7.4
