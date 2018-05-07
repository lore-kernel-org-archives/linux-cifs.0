From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 3/7] cifs: smbd: Return EINTR when interrupted
Date: Mon,  7 May 2018 15:20:02 -0700
Message-ID: <20180507222006.20781-3-longli@linuxonhyperv.com>
References: <20180507222006.20781-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507222006.20781-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When packets are waiting for outbound I/O and interrupted, return the
proper error code to user process.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 79b025e..b8dd493 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1963,7 +1963,7 @@ static int smbd_recv_buf(struct smbd_connection *info, char *buf,
 			info->transport_status != SMBD_CONNECTED);
 	/* Don't return any data if interrupted */
 	if (rc)
-		return -ENODEV;
+		return rc;
 
 	if (info->transport_status != SMBD_CONNECTED) {
 		log_read(ERR, "disconnected\n");
@@ -1991,7 +1991,7 @@ static int smbd_recv_page(struct smbd_connection *info,
 		info->reassembly_data_length >= to_read ||
 			info->transport_status != SMBD_CONNECTED);
 	if (ret)
-		return 0;
+		return ret;
 
 	/* now we can read from reassembly queue and not sleep */
 	to_address = kmap_atomic(page);
-- 
2.7.4
