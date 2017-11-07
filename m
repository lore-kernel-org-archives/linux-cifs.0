From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v7 07/22] CIFS: SMBD: Implement function to create a SMB Direct connection
Date: Tue,  7 Nov 2017 01:54:59 -0700
Message-ID: <20171107085514.12693-8-longli@exchange.microsoft.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107085514.12693-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

The upper layer calls this function to connect to peer through SMB Direct.
Each SMB Direct connection is based on a RDMA RC Queue Pair.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 021d527..1db39a34 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1651,3 +1651,20 @@ struct smbd_connection *_smbd_get_connection(
 	kfree(info);
 	return NULL;
 }
+
+struct smbd_connection *smbd_get_connection(
+	struct TCP_Server_Info *server, struct sockaddr *dstaddr)
+{
+	struct smbd_connection *ret;
+	int port = SMBD_PORT;
+
+try_again:
+	ret = _smbd_get_connection(server, dstaddr, port);
+
+	/* Try SMB_PORT if SMBD_PORT doesn't work */
+	if (!ret && port == SMBD_PORT) {
+		port = SMB_PORT;
+		goto try_again;
+	}
+	return ret;
+}
-- 
2.7.4
