From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v3 10/19] CIFS: SMBD: Send data through SMBDirect
Date: Tue, 29 Aug 2017 12:29:06 -0700
Message-ID: <20170829192915.26251-11-longli@exchange.microsoft.com>
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

With SMBDirect connected, use it for sending data via RDMA send.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index ba62aaf..bddb699 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -37,6 +37,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
+#include "smbdirect.h"
 
 void
 cifs_wake_up_task(struct mid_q_entry *mid)
@@ -230,6 +231,11 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	struct msghdr smb_msg;
 	int val = 1;
 
+	if (server->smbd_conn) {
+		rc = smbd_send(server->smbd_conn, rqst);
+		goto done;
+	}
+
 	if (ssocket == NULL)
 		return -ENOTSOCK;
 
@@ -299,6 +305,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		server->tcpStatus = CifsNeedReconnect;
 	}
 
+done:
 	if (rc < 0 && rc != -EINTR)
 		cifs_dbg(VFS, "Error %d sending data on socket to server\n",
 			 rc);
-- 
2.7.4
