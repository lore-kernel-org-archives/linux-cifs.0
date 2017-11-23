From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v8 10/16] CIFS: SMBD: Upper layer sends data via RDMA send
Date: Wed, 22 Nov 2017 17:38:43 -0700
Message-ID: <20171123003849.17093-11-longli@exchange.microsoft.com>
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

With SMB Direct connected, use it for sending data via RDMA send.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/transport.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e678307..4001842 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -37,6 +37,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
+#include "smbdirect.h"
 
 void
 cifs_wake_up_task(struct mid_q_entry *mid)
@@ -229,7 +230,10 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	struct socket *ssocket = server->ssocket;
 	struct msghdr smb_msg;
 	int val = 1;
-
+	if (cifs_rdma_enabled(server) && server->smbd_conn) {
+		rc = smbd_send(server->smbd_conn, rqst);
+		goto smbd_done;
+	}
 	if (ssocket == NULL)
 		return -ENOTSOCK;
 
@@ -298,7 +302,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		 */
 		server->tcpStatus = CifsNeedReconnect;
 	}
-
+smbd_done:
 	if (rc < 0 && rc != -EINTR)
 		cifs_dbg(VFS, "Error %d sending data on socket to server\n",
 			 rc);
-- 
2.7.4
