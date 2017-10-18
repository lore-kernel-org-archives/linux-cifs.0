From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v5 13/21] CIFS: SMBD: Upper layer receives data via RDMA receive
Date: Wed, 18 Oct 2017 16:09:12 -0700
Message-ID: <20171018230920.21042-14-longli@exchange.microsoft.com>
References: <20171018230920.21042-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171018230920.21042-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

With SMB Direct connected, use it for receiving data via RDMA receive.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 23f10d1..6325062 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -545,8 +545,14 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 
 		if (server_unresponsive(server))
 			return -ECONNABORTED;
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+		if (server->smbd_conn)
+			length = smbd_recv(server->smbd_conn, smb_msg);
+		else
+			length = sock_recvmsg(server->ssocket, smb_msg, 0);
+#else
 		length = sock_recvmsg(server->ssocket, smb_msg, 0);
+#endif
 
 		if (server->tcpStatus == CifsExiting)
 			return -ESHUTDOWN;
-- 
2.7.4
