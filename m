From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v7 10/22] CIFS: SMBD: Upper layer reconnects to SMB Direct session
Date: Tue,  7 Nov 2017 01:55:02 -0700
Message-ID: <20171107085514.12693-11-longli@exchange.microsoft.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107085514.12693-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Do a reconnect on SMB Direct when it is used as the connection. Reconnect can
happen for many reasons and it's mostly the decision of SMB2 upper layer.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 75eb50b..3ccd703 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -404,7 +404,10 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 		/* we should try only the port we connected to before */
 		mutex_lock(&server->srv_mutex);
-		rc = generic_ip_connect(server);
+		if (cifs_rdma_enabled(server))
+			rc = smbd_reconnect(server);
+		else
+			rc = generic_ip_connect(server);
 		if (rc) {
 			cifs_dbg(FYI, "reconnect error %d\n", rc);
 			mutex_unlock(&server->srv_mutex);
-- 
2.7.4
