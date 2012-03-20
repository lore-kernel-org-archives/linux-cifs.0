From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v3 05/10] CIFS: Delete echo_retries module parm
Date: Tue, 20 Mar 2012 13:00:35 +0300
Message-ID: <1332237640-10145-6-git-send-email-piastry@etersoft.ru>
References: <1332237640-10145-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332237640-10145-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's the essential step before respecting MaxMpxCount value during
negotiating because we will keep only one extra slot for sending
echo requests. If there is no response during two echo intervals -
reconnect the tcp session.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/README     |    6 +-----
 fs/cifs/cifsfs.c   |    5 -----
 fs/cifs/cifsglob.h |    3 ---
 fs/cifs/connect.c  |   18 ++++++++++++++----
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index 895da1d..b7d782b 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -753,10 +753,6 @@ module loading or during the runtime by using the interface
 
 i.e. echo "value" > /sys/module/cifs/parameters/<param>
 
-1. echo_retries - The number of echo attempts before giving up and
-		  reconnecting to the server. The default is 5. The value 0
-		  means never reconnect.
-
-2. enable_oplocks - Enable or disable oplocks. Oplocks are enabled by default.
+1. enable_oplocks - Enable or disable oplocks. Oplocks are enabled by default.
 		    [Y/y/1]. To disable use any of [N/n/0].
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6ee1cb4..f266161 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -77,11 +77,6 @@ unsigned int cifs_max_pending = CIFS_MAX_REQ;
 module_param(cifs_max_pending, int, 0444);
 MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
 				   "Default: 32767 Range: 2 to 32767.");
-unsigned short echo_retries = 5;
-module_param(echo_retries, ushort, 0644);
-MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
-			       "reconnecting server. Default: 5. 0 means "
-			       "never reconnect.");
 module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool). Default:"
 				 "y/Y/1");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2309a67..339ebe3 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1038,9 +1038,6 @@ GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
 GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 
-/* reconnect after this many failed echo attempts */
-GLOBAL_EXTERN unsigned short echo_retries;
-
 #ifdef CONFIG_CIFS_ACL
 GLOBAL_EXTERN struct rb_root uidtree;
 GLOBAL_EXTERN struct rb_root gidtree;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f3a0c49..9f40e46 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -373,12 +373,22 @@ allocate_buffers(struct TCP_Server_Info *server)
 static bool
 server_unresponsive(struct TCP_Server_Info *server)
 {
-	if (echo_retries > 0 && server->tcpStatus == CifsGood &&
-	    time_after(jiffies, server->lstrp +
-				(echo_retries * SMB_ECHO_INTERVAL))) {
+	/*
+	 * We need to wait 2 echo intervals to make sure we handle such
+	 * situations right:
+	 * 1s  client sends a normal SMB request
+	 * 2s  client gets a response
+	 * 30s echo workqueue job pops, and decides we got a response recently
+	 *     and don't need to send another
+	 * ...
+	 * 65s kernel_recvmsg times out, and we see that we haven't gotten
+	 *     a response in >60s.
+	 */
+	if (server->tcpStatus == CifsGood &&
+	    time_after(jiffies, server->lstrp + 2 * SMB_ECHO_INTERVAL)) {
 		cERROR(1, "Server %s has not responded in %d seconds. "
 			  "Reconnecting...", server->hostname,
-			  (echo_retries * SMB_ECHO_INTERVAL / HZ));
+			  (2 * SMB_ECHO_INTERVAL) / HZ);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
-- 
1.7.1
