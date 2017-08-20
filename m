From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 07/19] CIFS: SMBD: Destroy SMBDirect session on shutdown or umount
Date: Sun, 20 Aug 2017 12:04:31 -0700
Message-ID: <1503255883-3041-8-git-send-email-longli@exchange.microsoft.com>
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

Finally, when CIFS wants to umount, do a proper shutdown on transport.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b337ca7..f65950f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -708,6 +708,11 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	/* give those requests time to exit */
 	msleep(125);
 
+	if (server->smbd_conn) {
+		smbd_destroy(server->smbd_conn);
+		server->smbd_conn = NULL;
+	}
+
 	if (server->ssocket) {
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
@@ -2194,6 +2199,9 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 		return;
 	}
 
+	if (server->smbd_conn)
+		smbd_destroy(server->smbd_conn);
+
 	put_net(cifs_net_ns(server));
 
 	list_del_init(&server->tcp_ses_list);
-- 
2.7.4
