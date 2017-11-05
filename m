From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v6 08/22] CIFS: SMBD: Upper layer connects to SMBDirect session
Date: Sat,  4 Nov 2017 22:43:50 -0700
Message-ID: <20171105054404.23886-9-longli@exchange.microsoft.com>
References: <20171105054404.23886-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171105054404.23886-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

When "rdma" is specified in the mount option, make CIFS connect to
SMB Direct.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/connect.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b5a575f..2c0b34a 100644
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
@@ -56,6 +55,9 @@
 #include "rfc1002pdu.h"
 #include "fscache.h"
 #include "smb2proto.h"
+#ifdef CONFIG_CIFS_SMB_DIRECT
+#include "smbdirect.h"
+#endif
 
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
@@ -2279,13 +2281,32 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		tcp_ses->echo_interval = volume_info->echo_interval * HZ;
 	else
 		tcp_ses->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
-
+	if (tcp_ses->rdma) {
+#ifdef CONFIG_CIFS_SMB_DIRECT
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
+#else
+		cifs_dbg(VFS, "CONFIG_CIFS_SMB_DIRECT is not enabled\n");
+		rc = -ENOENT;
+		goto out_err_crypto_release;
+#endif
+	}
 	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
 		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
 		goto out_err_crypto_release;
 	}
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+smbd_connected:
+#endif
 	/*
 	 * since we're in a cifs function already, we know that
 	 * this will succeed. No need for try_module_get().
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
