From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 33/37] [CIFS] Connect to SMBD transport when specified in mount option
Date: Wed,  2 Aug 2017 13:10:44 -0700
Message-ID: <1501704648-20159-34-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When "-o rdma" is specified, attempt to connect to SMB server via SMBD.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0dc942c..1ba5b92 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -45,6 +45,7 @@
 #include <linux/parser.h>
 #include <linux/bvec.h>
 
+#include "cifsrdma.h"
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -2284,12 +2285,26 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	else
 		tcp_ses->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
 
-	rc = ip_connect(tcp_ses);
-	if (rc < 0) {
-		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
-		goto out_err_crypto_release;
+	if (tcp_ses->rdma) {
+		tcp_ses->rdma_ses = cifs_create_rdma_session(tcp_ses, (struct sockaddr *)&volume_info->dstaddr);
+		if (tcp_ses->rdma_ses) {
+			cifs_dbg(VFS, "%s: RDMA transport established\n", __func__);
+			rc = 0;
+			goto connected;
+		}
+		else {
+			rc = -ENOENT;
+			goto out_err_crypto_release;
+		}
+	}
+
+        rc = ip_connect(tcp_ses);
+        if (rc < 0) {
+                cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
+                goto out_err_crypto_release;
 	}
 
+connected:
 	/*
 	 * since we're in a cifs function already, we know that
 	 * this will succeed. No need for try_module_get().
-- 
2.7.4
