From: Arnd Hannemann <arnd-BCMAnToX5e2ELgA04lAiVw@public.gmane.org>
Subject: [PATCH] [CIFS] Print IP address of unresponsive server
Date: Mon, 16 Nov 2015 17:38:28 +0100
Message-ID: <1447691908-4740-1-git-send-email-arnd@arndnet.de>
Cc: Arnd Hannemann <arnd-BCMAnToX5e2ELgA04lAiVw@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Before this patch, only the hostname of the server
is printed when it becomes unresponsive.
This might not be helpful, if the IP-Address has
changed since initial mount when the name was
resolved (e.g. because the IPv6-Prefix changed).

This patch adds the cached IP address of the unresponsive server,
to the log message.

Signed-off-by: Arnd Hannemann <arnd-BCMAnToX5e2ELgA04lAiVw@public.gmane.org>
---
 fs/cifs/connect.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3f22285..8993309 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -482,8 +482,11 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 */
 	if (server->tcpStatus == CifsGood &&
 	    time_after(jiffies, server->lstrp + 2 * SMB_ECHO_INTERVAL)) {
-		cifs_dbg(VFS, "Server %s has not responded in %d seconds. Reconnecting...\n",
-			 server->hostname, (2 * SMB_ECHO_INTERVAL) / HZ);
+		cifs_dbg(VFS, "Server %s (addr=%pISc) has not responded in "
+			 "%d seconds. Reconnecting...\n",
+			 server->hostname,
+			 (struct sockaddr *)&server->dstaddr,
+			 (2 * SMB_ECHO_INTERVAL) / HZ);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
-- 
2.5.0
