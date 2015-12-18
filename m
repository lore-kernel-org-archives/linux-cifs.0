From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] [v4]cifs: Make echo interval tunable
Date: Fri, 18 Dec 2015 17:04:39 +0530
Message-ID: <1450438479-21772-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently the echo interval is set to 60 seconds using a macro. This
setting determines the interval at which echo requests are sent to the
server on an idling connection. This setting also affects the time
required for a connection to an unresponsive server to timeout.

Making this setting a tunable allows users to control the echo interval
times as well as control the time after which the connecting to an
unresponsive server times out.

To set echo interval, pass the echo_interval=n mount option.

v2: Change MIN and MAX timeout values
v3: Remove incorrect comment in cifs_get_tcp_session
v4: Fix bug in setting echo_interval

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |  2 ++
 fs/cifs/cifsglob.h |  8 ++++++--
 fs/cifs/connect.c  | 32 ++++++++++++++++++++++++++------
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index cbc0f4b..eab2de6 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -507,6 +507,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 
 	seq_printf(s, ",rsize=%u", cifs_sb->rsize);
 	seq_printf(s, ",wsize=%u", cifs_sb->wsize);
+	seq_printf(s, ",echo_interval=%lu",
+			tcon->ses->server->echo_interval / HZ);
 	/* convert actimeo and display it in seconds */
 	seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2b510c5..9d14926 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -70,8 +70,10 @@
 #define SERVER_NAME_LENGTH 40
 #define SERVER_NAME_LEN_WITH_NULL     (SERVER_NAME_LENGTH + 1)
 
-/* SMB echo "timeout" -- FIXME: tunable? */
-#define SMB_ECHO_INTERVAL (60 * HZ)
+/* echo interval in seconds */
+#define SMB_ECHO_INTERVAL_MIN 1
+#define SMB_ECHO_INTERVAL_MAX 600
+#define SMB_ECHO_INTERVAL_DEFAULT 60
 
 #include "cifspdu.h"
 
@@ -507,6 +509,7 @@ struct smb_vol {
 	struct sockaddr_storage dstaddr; /* destination address */
 	struct sockaddr_storage srcaddr; /* allow binding to a local IP */
 	struct nls_table *local_nls;
+	unsigned int echo_interval; /* echo interval in secs */
 };
 
 #define CIFS_MOUNT_MASK (CIFS_MOUNT_NO_PERM | CIFS_MOUNT_SET_UID | \
@@ -628,6 +631,7 @@ struct TCP_Server_Info {
 	unsigned int	max_read;
 	unsigned int	max_write;
 #endif /* CONFIG_CIFS_SMB2 */
+	unsigned long echo_interval;
 };
 
 static inline unsigned int
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ecb0803..de53c55 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -95,6 +95,7 @@ enum {
 	Opt_cruid, Opt_gid, Opt_file_mode,
 	Opt_dirmode, Opt_port,
 	Opt_rsize, Opt_wsize, Opt_actimeo,
+	Opt_echo_interval,
 
 	/* Mount options which take string value */
 	Opt_user, Opt_pass, Opt_ip,
@@ -188,6 +189,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_rsize, "rsize=%s" },
 	{ Opt_wsize, "wsize=%s" },
 	{ Opt_actimeo, "actimeo=%s" },
+	{ Opt_echo_interval, "echo_interval=%s" },
 
 	{ Opt_blank_user, "user=" },
 	{ Opt_blank_user, "username=" },
@@ -418,6 +420,7 @@ cifs_echo_request(struct work_struct *work)
 	int rc;
 	struct TCP_Server_Info *server = container_of(work,
 					struct TCP_Server_Info, echo.work);
+	unsigned long echo_interval = server->echo_interval;
 
 	/*
 	 * We cannot send an echo if it is disabled or until the
@@ -427,7 +430,7 @@ cifs_echo_request(struct work_struct *work)
 	 */
 	if (!server->ops->need_neg || server->ops->need_neg(server) ||
 	    (server->ops->can_echo && !server->ops->can_echo(server)) ||
-	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
+	    time_before(jiffies, server->lstrp + echo_interval - HZ))
 		goto requeue_echo;
 
 	rc = server->ops->echo ? server->ops->echo(server) : -ENOSYS;
@@ -436,7 +439,7 @@ cifs_echo_request(struct work_struct *work)
 			 server->hostname);
 
 requeue_echo:
-	queue_delayed_work(cifsiod_wq, &server->echo, SMB_ECHO_INTERVAL);
+	queue_delayed_work(cifsiod_wq, &server->echo, echo_interval);
 }
 
 static bool
@@ -487,9 +490,9 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 *     a response in >60s.
 	 */
 	if (server->tcpStatus == CifsGood &&
-	    time_after(jiffies, server->lstrp + 2 * SMB_ECHO_INTERVAL)) {
-		cifs_dbg(VFS, "Server %s has not responded in %d seconds. Reconnecting...\n",
-			 server->hostname, (2 * SMB_ECHO_INTERVAL) / HZ);
+	    time_after(jiffies, server->lstrp + 2 * server->echo_interval)) {
+		cifs_dbg(VFS, "Server %s has not responded in %lu seconds. Reconnecting...\n",
+			 server->hostname, (2 * server->echo_interval) / HZ);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
@@ -1624,6 +1627,14 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto cifs_parse_mount_err;
 			}
 			break;
+		case Opt_echo_interval:
+			if (get_option_ul(args, &option)) {
+				cifs_dbg(VFS, "%s: Invalid echo interval value\n",
+					 __func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->echo_interval = option;
+			break;
 
 		/* String Arguments */
 
@@ -2089,6 +2100,9 @@ static int match_server(struct TCP_Server_Info *server, struct smb_vol *vol)
 	if (!match_security(server, vol))
 		return 0;
 
+	if (server->echo_interval != vol->echo_interval)
+		return 0;
+
 	return 1;
 }
 
@@ -2208,6 +2222,12 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->tcpStatus = CifsNew;
 	++tcp_ses->srv_count;
 
+	if (volume_info->echo_interval >= SMB_ECHO_INTERVAL_MIN &&
+		volume_info->echo_interval <= SMB_ECHO_INTERVAL_MAX)
+		tcp_ses->echo_interval = volume_info->echo_interval * HZ;
+	else
+		tcp_ses->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
+
 	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
 		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
@@ -2237,7 +2257,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	cifs_fscache_get_client_cookie(tcp_ses);
 
 	/* queue echo request delayed work */
-	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, SMB_ECHO_INTERVAL);
+	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
 
 	return tcp_ses;
 
-- 
2.5.0
