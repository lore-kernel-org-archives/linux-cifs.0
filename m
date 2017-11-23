From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v8 04/16] CIFS: SMBD: Implement function to destroy a SMB Direct connection
Date: Wed, 22 Nov 2017 17:38:37 -0700
Message-ID: <20171123003849.17093-5-longli@exchange.microsoft.com>
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

Add function to tear down a SMB Direct connection. This is used by upper layer
to free all SMB Direct connection and transport resources.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 16 ++++++++++++++++
 fs/cifs/smbdirect.h |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index a96058a..b462a2f 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1387,6 +1387,22 @@ static void idle_connection_timer(struct work_struct *work)
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
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index 8948f06..61bb649 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -249,6 +249,8 @@ struct smbd_connection *smbd_get_connection(
 
 /* Reconnect SMBDirect session */
 int smbd_reconnect(struct TCP_Server_Info *server);
+/* Destroy SMBDirect session */
+void smbd_destroy(struct smbd_connection *info);
 
 #else
 #define cifs_rdma_enabled(server)	0
@@ -256,6 +258,7 @@ struct smbd_connection {};
 static inline void *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr) {return NULL;}
 static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1;}
+static inline void smbd_destroy(struct smbd_connection *info) {}
 #endif
 
 #endif
-- 
2.7.4
