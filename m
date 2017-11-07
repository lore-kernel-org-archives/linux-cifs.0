From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v7 09/22] CIFS: SMBD: Implement function to reconnect to a SMB Direct transport
Date: Tue,  7 Nov 2017 01:55:01 -0700
Message-ID: <20171107085514.12693-10-longli@exchange.microsoft.com>
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

Add function to implement a reconnect to SMB Direct. This involves tearing down
the current connection and establishing/negotiating a new connection.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 1db39a34..9f23330 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1392,6 +1392,42 @@ static void idle_connection_timer(struct work_struct *work)
 			info->keep_alive_interval*HZ);
 }
 
+/*
+ * Reconnect this SMBD connection, called from upper layer
+ * return value: 0 on success, or actual error code
+ */
+int smbd_reconnect(struct TCP_Server_Info *server)
+{
+	log_rdma_event(INFO, "reconnecting rdma session\n");
+
+	if (!server->smbd_conn) {
+		log_rdma_event(ERR, "rdma session already destroyed\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * This is possible if transport is disconnected and we haven't received
+	 * notification from RDMA, but upper layer has detected timeout
+	 */
+	if (server->smbd_conn->transport_status == SMBD_CONNECTED) {
+		log_rdma_event(INFO, "disconnecting transport\n");
+		smbd_disconnect_rdma_connection(server->smbd_conn);
+	}
+
+	/* wait until the transport is destroyed */
+	wait_event(server->smbd_conn->wait_destroy,
+		server->smbd_conn->transport_status == SMBD_DESTROYED);
+
+	destroy_workqueue(server->smbd_conn->workqueue);
+	kfree(server->smbd_conn);
+
+	log_rdma_event(INFO, "creating rdma session\n");
+	server->smbd_conn = smbd_get_connection(
+		server, (struct sockaddr *) &server->dstaddr);
+
+	return server->smbd_conn ? 0 : -ENOENT;
+}
+
 static void destroy_caches_and_workqueue(struct smbd_connection *info)
 {
 	destroy_receive_buffers(info);
-- 
2.7.4
