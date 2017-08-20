From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 06/19] CIFS: SMBD: Reconnect to SMBDirect session
Date: Sun, 20 Aug 2017 12:04:30 -0700
Message-ID: <1503255883-3041-7-git-send-email-longli@exchange.microsoft.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Do a reconnect on SMBDirect when it is used as the connection. Reconnect can happen for many reasons and it's mostly the decision of upper layer SMB2 not SMBDirect.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 309eba0..b337ca7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -409,7 +409,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
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
