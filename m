From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 08/19] CIFS: SMBD: Set SMBDirect maximum read or write size for I/O
Date: Sun, 20 Aug 2017 12:04:32 -0700
Message-ID: <1503255883-3041-9-git-send-email-longli@exchange.microsoft.com>
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

When connecting over SMBDirect, the transport negotiates its maximum I/O sizes with the server and determines how to choose to do RDMA send/recv vs read/write. Expose these maximum I/O sizes to upper layer so we will get the correct sized payloads.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2ops.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 06494e1..e67f5f0 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -32,6 +32,7 @@
 #include "smb2status.h"
 #include "smb2glob.h"
 #include "cifs_ioctl.h"
+#include "smbdirect.h"
 
 static int
 change_conf(struct TCP_Server_Info *server)
@@ -249,7 +250,11 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 
 	/* start with specified wsize, or default */
 	wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
-	wsize = min_t(unsigned int, wsize, server->max_write);
+	if (server->rdma)
+		wsize = min_t(unsigned int,
+				wsize, server->smbd_conn->max_readwrite_size);
+	else
+		wsize = min_t(unsigned int, wsize, server->max_write);
 
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
@@ -265,7 +270,11 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 
 	/* start with specified rsize, or default */
 	rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
-	rsize = min_t(unsigned int, rsize, server->max_read);
+	if (server->rdma)
+		rsize = min_t(unsigned int,
+				rsize, server->smbd_conn->max_readwrite_size);
+	else
+		rsize = min_t(unsigned int, rsize, server->max_read);
 
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
-- 
2.7.4
