From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 23/37] [CIFS] SMBD: Implement API for upper layer to reconnect transport
Date: Wed,  2 Aug 2017 13:10:34 -0700
Message-ID: <1501704648-20159-24-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Upper layer may request to reconnect to server for multiple reason. Disconnect can happen at SMB layer or at SMBD layer. Add function to support reconnect when transport is disconnected.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 24 ++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 67a11d9..4681cda 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -1170,6 +1170,30 @@ static void destroy_receive_buffers(struct cifs_rdma_info *info)
 		mempool_free(response, info->response_mempool);
 }
 
+int cifs_reconnect_rdma_session(struct TCP_Server_Info *server)
+{
+	log_rdma_event("reconnecting rdma session\n");
+
+	// why reconnect while it is still connected?
+	if (server->rdma_ses->transport_status == CIFS_RDMA_CONNECTED) {
+		log_rdma_event("still connected, not reconnecting\n");
+		return -EINVAL;
+	}
+
+	// wait until the transport is destroyed
+	while (server->rdma_ses->transport_status != CIFS_RDMA_DESTROYED)
+		msleep(1);
+
+	if (server->rdma_ses)
+		kfree(server->rdma_ses);
+
+	log_rdma_event("creating rdma session\n");
+	server->rdma_ses = cifs_create_rdma_session(
+		server, (struct sockaddr *) &server->dstaddr);
+
+	return server->rdma_ses ? 0 : -ENOENT;
+}
+
 struct cifs_rdma_info* cifs_create_rdma_session(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr)
 {
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 36f3e4c..c27db6f 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -212,6 +212,9 @@ struct cifs_rdma_response {
 struct cifs_rdma_info* cifs_create_rdma_session(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
 
+// Reconnect SMBDirect session
+int cifs_reconnect_rdma_session(struct TCP_Server_Info *server);
+
 // SMBDirect interface for carrying upper layer CIFS I/O
 int cifs_rdma_read(
 	struct cifs_rdma_info *rdma, char *buf, unsigned int to_read);
-- 
2.7.4
