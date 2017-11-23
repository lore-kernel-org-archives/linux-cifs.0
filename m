From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v8 02/16] CIFS: SMBD: Implement function to reconnect to a SMB Direct transport
Date: Wed, 22 Nov 2017 17:38:35 -0700
Message-ID: <20171123003849.17093-3-longli@exchange.microsoft.com>
References: <20171123003849.17093-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171123003849.17093-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Add function to implement a reconnect to SMB Direct. This involves tearing down
the current connection and establishing/negotiating a new connection.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 36 ++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h |  4 ++++
 2 files changed, 40 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 862cdf9..a96058a 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1387,6 +1387,42 @@ static void idle_connection_timer(struct work_struct *work)
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
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index 25b3782..8948f06 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -247,11 +247,15 @@ struct smbd_response {
 struct smbd_connection *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
 
+/* Reconnect SMBDirect session */
+int smbd_reconnect(struct TCP_Server_Info *server);
+
 #else
 #define cifs_rdma_enabled(server)	0
 struct smbd_connection {};
 static inline void *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr) {return NULL;}
+static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1;}
 #endif
 
 #endif
-- 
2.7.4
