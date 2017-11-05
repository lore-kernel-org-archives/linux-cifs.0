From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v6 17/22] CIFS: SMBD: Upper layer sends data via RDMA send
Date: Sat,  4 Nov 2017 22:43:59 -0700
Message-ID: <20171105054404.23886-18-longli@exchange.microsoft.com>
References: <20171105054404.23886-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171105054404.23886-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

With SMB Direct connected, use it for sending data via RDMA send.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/transport.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 7efbab0..1b51d08 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -37,6 +37,9 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
+#ifdef CONFIG_CIFS_SMB_DIRECT
+#include "smbdirect.h"
+#endif
 
 void
 cifs_wake_up_task(struct mid_q_entry *mid)
@@ -229,7 +232,12 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	struct socket *ssocket = server->ssocket;
 	struct msghdr smb_msg;
 	int val = 1;
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (server->smbd_conn) {
+		rc = smbd_send(server->smbd_conn, rqst);
+		goto smbd_done;
+	}
+#endif
 	if (ssocket == NULL)
 		return -ENOTSOCK;
 
@@ -298,7 +306,9 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		 */
 		server->tcpStatus = CifsNeedReconnect;
 	}
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+smbd_done:
+#endif
 	if (rc < 0 && rc != -EINTR)
 		cifs_dbg(VFS, "Error %d sending data on socket to server\n",
 			 rc);
-- 
2.7.4
