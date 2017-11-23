From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v8 08/16] CIFS: SMBD: Upper layer receives data via RDMA receive
Date: Wed, 22 Nov 2017 17:38:41 -0700
Message-ID: <20171123003849.17093-9-longli@exchange.microsoft.com>
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

With SMB Direct connected, use it for receiving data via RDMA receive.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d8bfa89..1677401 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -542,8 +542,10 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 
 		if (server_unresponsive(server))
 			return -ECONNABORTED;
-
-		length = sock_recvmsg(server->ssocket, smb_msg, 0);
+		if (cifs_rdma_enabled(server) && server->smbd_conn)
+			length = smbd_recv(server->smbd_conn, smb_msg);
+		else
+			length = sock_recvmsg(server->ssocket, smb_msg, 0);
 
 		if (server->tcpStatus == CifsExiting)
 			return -ESHUTDOWN;
-- 
2.7.4
