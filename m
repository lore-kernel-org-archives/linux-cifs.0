From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v4 06/22] CIFS: SMBD: Upper layer connects to SMBDirect session
Date: Sun,  1 Oct 2017 19:30:14 -0700
Message-ID: <20171002023030.3582-7-longli@exchange.microsoft.com>
References: <20171002023030.3582-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002023030.3582-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

When "rdma" is specified in the mount option, CIFS attempts to connect to
SMBDirect instead of TCP socket.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/connect.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b5a575f..94b6357 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -45,6 +45,7 @@
 #include <linux/parser.h>
 #include <linux/bvec.h>
 
+#include "smbdirect.h"
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -2280,12 +2281,26 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
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
