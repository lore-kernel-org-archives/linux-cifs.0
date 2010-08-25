From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: [cifs] cifs:  Allow binding to local IP address.
Date: Wed, 25 Aug 2010 16:00:35 -0700
Message-ID: <1282777235-20218-1-git-send-email-greearb@candelatech.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When using multi-homed machines, it's nice to be able to specify
the local IP to use for outbound connections.  This patch gives
cifs the ability to bind to a particular IP address.

Usage:  mount -t cifs -o bindaddr=192.168.1.50,user=foo, ...

Signed-off-by: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
---
:100644 100644 b7431af... 7466533... M	fs/cifs/cifsfs.c
:100644 100644 c9d0cfc... c0176d8... M	fs/cifs/cifsglob.h
:100644 100644 ec0ea4a... cc0a16a... M	fs/cifs/connect.c
 fs/cifs/cifsfs.c   |    3 +++
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/connect.c  |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b7431af..7466533 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -374,6 +374,9 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 	if (tcon->ses->domainName)
 		seq_printf(s, ",domain=%s", tcon->ses->domainName);
 
+	if (tcon->ses->server->ip4_local_ip)
+		seq_printf(s, ",bindaddr=%pI4", &tcon->ses->server->ip4_local_ip);
+	
 	seq_printf(s, ",uid=%d", cifs_sb->mnt_uid);
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
 		seq_printf(s, ",forceuid");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c9d0cfc..c0176d8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -157,6 +157,7 @@ struct TCP_Server_Info {
 		struct sockaddr_in sockAddr;
 		struct sockaddr_in6 sockAddr6;
 	} addr;
+	u32 ip4_local_ip;
 	wait_queue_head_t response_q;
 	wait_queue_head_t request_q; /* if more than maxmpx to srvr must block*/
 	struct list_head pending_mid_q;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ec0ea4a..cc0a16a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -105,6 +105,7 @@ struct smb_vol {
 	bool sockopt_tcp_nodelay:1;
 	unsigned short int port;
 	char *prepath;
+	u32 local_ip; /* allow binding to a local IP address if != 0 */
 	struct nls_table *local_nls;
 };
 
@@ -1064,6 +1065,31 @@ cifs_parse_mount_options(char *options, const char *devname,
 						    "long\n");
 				return 1;
 			}
+		} else if (strnicmp(data, "bindaddr", 8) == 0) {
+			struct sockaddr_storage tmp_laddr;
+			memset(&tmp_laddr, 0, sizeof(tmp_laddr));
+			
+			if (!value || !*value) {
+				printk(KERN_WARNING "CIFS: bindaddr value not specified.\n");
+				return 1;	/* needs_arg; */
+			}
+			i = cifs_convert_address((struct sockaddr*)(&tmp_laddr), value, strlen(value));
+			if (i < 0) {
+				vol->local_ip = 0;
+				printk(KERN_WARNING "CIFS:  Could not parse bindaddr: %s\n",
+				       value);
+				return 1;
+			}
+			else {
+				struct sockaddr_in *s4 = (struct sockaddr_in *) &tmp_laddr;
+				//struct sockaddr_in6 *s6 = (struct sockaddr_in6 *) &tmp_laddr;
+				if (s4->sin_family == AF_INET) {
+					vol->local_ip = s4->sin_addr.s_addr;
+				}
+				else {
+					printk("WARNING:  IPv6 bindaddr not supported yet.\n");
+				}
+			}
 		} else if (strnicmp(data, "prefixpath", 10) == 0) {
 			if (!value || !*value) {
 				printk(KERN_WARNING
@@ -1393,7 +1419,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 }
 
 static bool
-match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
+match_address(struct TCP_Server_Info *server, struct sockaddr *addr, u32 local_ip4)
 {
 	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
@@ -1406,6 +1432,8 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
 		if (addr4->sin_port &&
 		    addr4->sin_port != server->addr.sockAddr.sin_port)
 			return false;
+		if (local_ip4 && (local_ip4 != server->ip4_local_ip))
+			return false;
 		break;
 	case AF_INET6:
 		if (!ipv6_addr_equal(&addr6->sin6_addr,
@@ -1487,7 +1515,7 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 		if (server->tcpStatus == CifsNew)
 			continue;
 
-		if (!match_address(server, addr))
+		if (!match_address(server, addr, vol->local_ip))
 			continue;
 
 		if (!match_security(server, vol))
@@ -1602,6 +1630,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	 * no need to spinlock this init of tcpStatus or srv_count
 	 */
 	tcp_ses->tcpStatus = CifsNew;
+	tcp_ses->ip4_local_ip = volume_info->local_ip;
 	++tcp_ses->srv_count;
 
 	if (addr.ss_family == AF_INET6) {
@@ -1678,6 +1707,10 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))
 				continue;
+			if (server->ip4_local_ip &&
+			    (server->ip4_local_ip != ses->server->ip4_local_ip))
+				continue;
+			/* TODO:  Deal with IPv6 local addr matching? --Ben */
 		}
 		++ses->ses_count;
 		write_unlock(&cifs_tcp_ses_lock);
@@ -2051,6 +2084,20 @@ ipv4_connect(struct TCP_Server_Info *server)
 		cifs_reclassify_socket4(socket);
 	}
 
+	/* Bind to the local IP address if specified */
+	if (server->ip4_local_ip) {
+		struct sockaddr_in myaddr = {
+			.sin_family = AF_INET,
+		};
+		myaddr.sin_addr.s_addr = server->ip4_local_ip;
+		myaddr.sin_port = 0; /* any */
+		rc = socket->ops->bind(socket, (struct sockaddr *) &myaddr,
+				       sizeof(myaddr));
+		if (rc < 0)
+			cERROR(1, "Failed to bind to: %pI4, error: %d\n",
+			       &server->ip4_local_ip, rc);
+	}
+
 	/* user overrode default port */
 	if (server->addr.sockAddr.sin_port) {
 		rc = socket->ops->connect(socket, (struct sockaddr *)
-- 
1.6.2.5
