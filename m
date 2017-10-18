From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v5 11/21] CIFS: SMBD: Set SMB Direct maximum read or write size for I/O
Date: Wed, 18 Oct 2017 16:09:10 -0700
Message-ID: <20171018230920.21042-12-longli@exchange.microsoft.com>
References: <20171018230920.21042-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171018230920.21042-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

When connecting over SMB Direct, the transport negotiates its maximum I/O sizes
with the server and determines how to choose to do RDMA send/recv vs
read/write. Expose these maximum I/O sizes to upper layer so we will get the
correct sized payloads.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb2ops.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index fb2934b..25028da 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -32,6 +32,9 @@
 #include "smb2status.h"
 #include "smb2glob.h"
 #include "cifs_ioctl.h"
+#ifdef CONFIG_CIFS_SMB_DIRECT
+#include "smbdirect.h"
+#endif
 
 static int
 change_conf(struct TCP_Server_Info *server)
@@ -250,7 +253,11 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	/* start with specified wsize, or default */
 	wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
 	wsize = min_t(unsigned int, wsize, server->max_write);
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (server->rdma)
+		wsize = min_t(unsigned int,
+				wsize, server->smbd_conn->max_readwrite_size);
+#endif
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
 
@@ -266,6 +273,11 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	/* start with specified rsize, or default */
 	rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
 	rsize = min_t(unsigned int, rsize, server->max_read);
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (server->rdma)
+		rsize = min_t(unsigned int,
+				rsize, server->smbd_conn->max_readwrite_size);
+#endif
 
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
