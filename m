From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v4 08/22] CIFS: SMBD: Upper layer reconnects to SMBDirect session
Date: Sun,  1 Oct 2017 19:30:16 -0700
Message-ID: <20171002023030.3582-9-longli@exchange.microsoft.com>
References: <20171002023030.3582-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171002023030.3582-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Do a reconnect on SMBDirect when it is used as the connection. Reconnect can
happen for many reasons and it's mostly the decision of upper layer SMB2.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 94b6357..26ad706 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -405,7 +405,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 		/* we should try only the port we connected to before */
 		mutex_lock(&server->srv_mutex);
-		rc = generic_ip_connect(server);
+		if (server->rdma)
+			rc = smbd_reconnect(server);
+		else
+			rc = generic_ip_connect(server);
+
 		if (rc) {
 			cifs_dbg(FYI, "reconnect error %d\n", rc);
 			mutex_unlock(&server->srv_mutex);
-- 
2.7.4
