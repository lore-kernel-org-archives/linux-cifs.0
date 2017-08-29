From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v3 05/19] CIFS: SMBD: Connect to SMBDirect session
Date: Tue, 29 Aug 2017 12:29:01 -0700
Message-ID: <20170829192915.26251-6-longli@exchange.microsoft.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170829192915.26251-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When "rdma" is specified in the mount option, CIFS attempts to connect to
SMBDirect instead of TCP socket.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 19fdca8..43b4d54 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -45,6 +45,7 @@
 #include <linux/parser.h>
 #include <linux/bvec.h>
 
+#include "smbdirect.h"
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -2289,12 +2290,26 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	else
 		tcp_ses->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
 
+	if (tcp_ses->rdma) {
+		tcp_ses->smbd_conn = smbd_get_connection(
+			tcp_ses, (struct sockaddr *)&volume_info->dstaddr);
+		if (tcp_ses->smbd_conn) {
+			cifs_dbg(VFS, "RDMA transport established\n");
+			rc = 0;
+			goto connected;
+		} else {
+			rc = -ENOENT;
+			goto out_err_crypto_release;
+		}
+	}
+
 	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
 		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
 		goto out_err_crypto_release;
 	}
 
+connected:
 	/*
 	 * since we're in a cifs function already, we know that
 	 * this will succeed. No need for try_module_get().
-- 
2.7.4
