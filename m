From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v5 08/21] CIFS: SMBD: Upper layer reconnects to SMB Direct session
Date: Wed, 18 Oct 2017 16:09:07 -0700
Message-ID: <20171018230920.21042-9-longli@exchange.microsoft.com>
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

Do a reconnect on SMB Direct when it is used as the connection. Reconnect can
happen for many reasons and it's mostly the decision of SMB2 upper layer.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2c0b34a..8ca3c13 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -406,7 +406,14 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 		/* we should try only the port we connected to before */
 		mutex_lock(&server->srv_mutex);
+#ifdef CONFIG_CIFS_SMB_DIRECT
+		if (server->rdma)
+			rc = smbd_reconnect(server);
+		else
+			rc = generic_ip_connect(server);
+#else
 		rc = generic_ip_connect(server);
+#endif
 		if (rc) {
 			cifs_dbg(FYI, "reconnect error %d\n", rc);
 			mutex_unlock(&server->srv_mutex);
-- 
2.7.4
