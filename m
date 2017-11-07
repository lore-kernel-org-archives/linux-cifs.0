From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v7 08/22] CIFS: SMBD: Upper layer connects to SMBDirect session
Date: Tue,  7 Nov 2017 01:55:00 -0700
Message-ID: <20171107085514.12693-9-longli@exchange.microsoft.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107085514.12693-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

When "rdma" is specified in the mount option, make CIFS connect to
SMB Direct.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/connect.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b5a575f..75eb50b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -44,7 +44,6 @@
 #include <net/ipv6.h>
 #include <linux/parser.h>
 #include <linux/bvec.h>
-
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -56,6 +55,7 @@
 #include "rfc1002pdu.h"
 #include "fscache.h"
 #include "smb2proto.h"
+#include "smbdirect.h"
 
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
@@ -2279,13 +2279,29 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		tcp_ses->echo_interval = volume_info->echo_interval * HZ;
 	else
 		tcp_ses->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
-
+	if (tcp_ses->rdma) {
+#ifndef CONFIG_CIFS_SMB_DIRECT
+		cifs_dbg(VFS, "CONFIG_CIFS_SMB_DIRECT is not enabled\n");
+		rc = -ENOENT;
+		goto out_err_crypto_release;
+#endif
+		tcp_ses->smbd_conn = smbd_get_connection(
+			tcp_ses, (struct sockaddr *)&volume_info->dstaddr);
+		if (tcp_ses->smbd_conn) {
+			cifs_dbg(VFS, "RDMA transport established\n");
+			rc = 0;
+			goto smbd_connected;
+		} else {
+			rc = -ENOENT;
+			goto out_err_crypto_release;
+		}
+	}
 	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
 		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
 		goto out_err_crypto_release;
 	}
-
+smbd_connected:
 	/*
 	 * since we're in a cifs function already, we know that
 	 * this will succeed. No need for try_module_get().
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
