From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v4 07/22] CIFS: SMBD: Implement function to reconnect to a SMBDirect transport
Date: Sun,  1 Oct 2017 19:30:15 -0700
Message-ID: <20171002023030.3582-8-longli@exchange.microsoft.com>
References: <20171002023030.3582-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002023030.3582-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Add function to implement a reconnect to SMBDirect. This involves tearing down
the current connection and establishing/negotiating a new connection.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smbdirect.c | 36 ++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h |  3 +++
 2 files changed, 39 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 34f73e2..1f0f33c 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1416,6 +1416,42 @@ static void idle_connection_timer(struct work_struct *work)
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
index 42a9338..9818852 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -249,6 +249,9 @@ struct smbd_response {
 struct smbd_connection *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
 
+/* Reconnect SMBDirect session */
+int smbd_reconnect(struct TCP_Server_Info *server);
+
 void profiling_display_histogram(
 	struct seq_file *m, unsigned long long array[]);
 #endif
-- 
2.7.4
