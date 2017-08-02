From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 35/37] [CIFS] Destroy SMBD transport on exit
Date: Wed,  2 Aug 2017 13:10:46 -0700
Message-ID: <1501704648-20159-36-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When SMBD is used in the SMB session, destroy it on exit.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 54c1f7c..cc58cd8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -708,6 +708,11 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	/* give those requests time to exit */
 	msleep(125);
 
+       if (server->rdma && server->rdma_ses) {
+               cifs_destroy_rdma_session(server->rdma_ses);
+               server->rdma_ses = NULL;
+       }
+
 	if (server->ssocket) {
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
@@ -2179,6 +2184,10 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 		return;
 	}
 
+       if (server->rdma && server->rdma_ses) {
+               cifs_destroy_rdma_session(server->rdma_ses);
+       }
+
 	put_net(cifs_net_ns(server));
 
 	list_del_init(&server->tcp_ses_list);
-- 
2.7.4
