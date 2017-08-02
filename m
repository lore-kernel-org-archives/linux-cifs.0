From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 37/37] [CIFS] Write to SMBD transport when it's used
Date: Wed,  2 Aug 2017 13:10:48 -0700
Message-ID: <1501704648-20159-38-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When sending data, send to SMBD is it's currently used.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index ba62aaf..10b9d15 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -37,6 +37,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
+#include "cifsrdma.h"
 
 void
 cifs_wake_up_task(struct mid_q_entry *mid)
@@ -230,6 +231,11 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	struct msghdr smb_msg;
 	int val = 1;
 
+       if(server->rdma_ses) {
+               rc = cifs_rdma_write(server->rdma_ses, rqst);
+               goto done;
+       }
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
