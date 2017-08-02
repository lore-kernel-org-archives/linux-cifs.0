From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 34/37] [CIFS] Reconnect to SMBD transport when it's used
Date: Wed,  2 Aug 2017 13:10:45 -0700
Message-ID: <1501704648-20159-35-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When CIFS wants to reconnect a SMB session, use SMBD if it's being used.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1ba5b92..54c1f7c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -409,7 +409,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 		/* we should try only the port we connected to before */
 		mutex_lock(&server->srv_mutex);
-		rc = generic_ip_connect(server);
+		if (server->rdma)
+			rc = cifs_reconnect_rdma_session(server);
+		else
+			rc = generic_ip_connect(server);
+
 		if (rc) {
 			cifs_dbg(FYI, "reconnect error %d\n", rc);
 			mutex_unlock(&server->srv_mutex);
-- 
2.7.4
