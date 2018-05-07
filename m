From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 7/7] cifs: Call MID callback before destroying transport
Date: Mon,  7 May 2018 15:20:06 -0700
Message-ID: <20180507222006.20781-7-longli@linuxonhyperv.com>
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

When transport is being destroyed, it's possible that some processes may
hold memory registrations that need to be deregistred.

Call them first so nobody is using transport resources, and it can be
destroyed.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5db3e9d..7e7d40e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -369,22 +369,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	/* do not want to be sending data on a socket we are freeing */
 	cifs_dbg(FYI, "%s: tearing down socket\n", __func__);
 	mutex_lock(&server->srv_mutex);
-	if (server->ssocket) {
-		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
-			 server->ssocket->state, server->ssocket->flags);
-		kernel_sock_shutdown(server->ssocket, SHUT_WR);
-		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
-			 server->ssocket->state, server->ssocket->flags);
-		sock_release(server->ssocket);
-		server->ssocket = NULL;
-	} else if (cifs_rdma_enabled(server))
-		smbd_destroy(server);
-	server->sequence_number = 0;
-	server->session_estab = false;
-	kfree(server->session_key.response);
-	server->session_key.response = NULL;
-	server->session_key.len = 0;
-	server->lstrp = jiffies;
 
 	/* mark submitted MIDs for retry and issue callback */
 	INIT_LIST_HEAD(&retry_list);
@@ -397,7 +381,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		list_move(&mid_entry->qhead, &retry_list);
 	}
 	spin_unlock(&GlobalMid_Lock);
-	mutex_unlock(&server->srv_mutex);
 
 	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
 	list_for_each_safe(tmp, tmp2, &retry_list) {
@@ -406,6 +389,25 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		mid_entry->callback(mid_entry);
 	}
 
+	if (server->ssocket) {
+		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
+			 server->ssocket->state, server->ssocket->flags);
+		kernel_sock_shutdown(server->ssocket, SHUT_WR);
+		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
+			 server->ssocket->state, server->ssocket->flags);
+		sock_release(server->ssocket);
+		server->ssocket = NULL;
+	} else if (cifs_rdma_enabled(server))
+		smbd_destroy(server);
+	server->sequence_number = 0;
+	server->session_estab = false;
+	kfree(server->session_key.response);
+	server->session_key.response = NULL;
+	server->session_key.len = 0;
+	server->lstrp = jiffies;
+
+	mutex_unlock(&server->srv_mutex);
+
 	do {
 		try_to_freeze();
 
-- 
2.7.4
