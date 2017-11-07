From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v7 12/22] CIFS: SMBD: Upper layer destroys SMB Direct session on shutdown or umount
Date: Tue,  7 Nov 2017 01:55:04 -0700
Message-ID: <20171107085514.12693-13-longli@exchange.microsoft.com>
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

When upper layer wants to umount, make it call shutdown on transport when
SMB Direct is used.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3ccd703..3d74983 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -701,7 +701,10 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	wake_up_all(&server->request_q);
 	/* give those requests time to exit */
 	msleep(125);
-
+	if (cifs_rdma_enabled(server) && server->smbd_conn) {
+		smbd_destroy(server->smbd_conn);
+		server->smbd_conn = NULL;
+	}
 	if (server->ssocket) {
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
-- 
2.7.4
