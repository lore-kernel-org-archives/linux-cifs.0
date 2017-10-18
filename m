From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v5 10/21] CIFS: SMBD: Upper layer destroys SMB Direct session on shutdown or umount
Date: Wed, 18 Oct 2017 16:09:09 -0700
Message-ID: <20171018230920.21042-11-longli@exchange.microsoft.com>
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

When upper layer wants to umount, make it call shutdown on transport when
SMB Direct is used.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8ca3c13..23f10d1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -707,7 +707,12 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	wake_up_all(&server->request_q);
 	/* give those requests time to exit */
 	msleep(125);
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (server->smbd_conn) {
+		smbd_destroy(server->smbd_conn);
+		server->smbd_conn = NULL;
+	}
+#endif
 	if (server->ssocket) {
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
-- 
2.7.4
