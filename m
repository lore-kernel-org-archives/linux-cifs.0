From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: [cifs srcaddr-v4] cifs:  Allow binding to local IP address.
Date: Wed,  1 Sep 2010 12:00:06 -0700
Message-ID: <1283367606-14030-1-git-send-email-greearb@candelatech.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When using multi-homed machines, it's nice to be able to specify
the local IP to use for outbound connections.  This patch gives
cifs the ability to bind to a particular IP address.

   Usage:  mount -t cifs -o srcaddr=192.168.1.50,user=foo, ...
   Usage:  mount -t cifs -o srcaddr=2002::100:1,user=foo, ...

Signed-off-by: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
---
:100644 100644 b7431af... 25590d2... M	fs/cifs/cifsfs.c
:100644 100644 c9d0cfc... 784fd4a... M	fs/cifs/cifsglob.h
:100644 100644 ec0ea4a... d3a36b4... M	fs/cifs/connect.c
 fs/cifs/cifsfs.c   |   16 +++++++++
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/connect.c  |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b7431af..25590d2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -36,6 +36,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/smp_lock.h>
+#include <net/ipv6.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
 #define DECLARE_GLOBALS_HERE
@@ -367,6 +368,8 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(m->mnt_sb);
 	struct cifsTconInfo *tcon = cifs_sb->tcon;
+	struct sockaddr *srcaddr;
+	srcaddr = (struct sockaddr *)(&tcon->ses->server->srcaddr);
 
 	seq_printf(s, ",unc=%s", tcon->treeName);
 	if (tcon->ses->userName)
@@ -374,6 +377,19 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 	if (tcon->ses->domainName)
 		seq_printf(s, ",domain=%s", tcon->ses->domainName);
 
+	if (srcaddr->sa_family != AF_UNSPEC) {
+		struct sockaddr_in *saddr4;
+		struct sockaddr_in6 *saddr6;
+		saddr4 = (struct sockaddr_in *)srcaddr;
+		saddr6 = (struct sockaddr_in6 *)srcaddr;
+		if (saddr6->sin6_family == AF_INET6)
+			seq_printf(s, ",srcaddr=%pI6c",
+				   &saddr6->sin6_addr);
+		else
+			seq_printf(s, ",srcaddr=%pI4",
+				   &saddr4->sin_addr.s_addr);
+	}
+
 	seq_printf(s, ",uid=%d", cifs_sb->mnt_uid);
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
 		seq_printf(s, ",forceuid");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c9d0cfc..784fd4a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -157,6 +157,7 @@ struct TCP_Server_Info {
 		struct sockaddr_in sockAddr;
 		struct sockaddr_in6 sockAddr6;
 	} addr;
+	struct sockaddr_storage srcaddr; /* locally bind to this IP */
 	wait_queue_head_t response_q;
 	wait_queue_head_t request_q; /* if more than maxmpx to srvr must block*/
 	struct list_head pending_mid_q;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ec0ea4a..d3a36b4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -105,6 +105,7 @@ struct smb_vol {
 	bool sockopt_tcp_nodelay:1;
 	unsigned short int port;
 	char *prepath;
+	struct sockaddr_storage srcaddr; /* allow binding to a local IP */
 	struct nls_table *local_nls;
 };
 
@@ -1064,6 +1065,22 @@ cifs_parse_mount_options(char *options, const char *devname,
 						    "long\n");
 				return 1;
 			}
+		} else if (strnicmp(data, "srcaddr", 7) == 0) {
+			vol->srcaddr.ss_family = AF_UNSPEC;
+
+			if (!value || !*value) {
+				printk(KERN_WARNING "CIFS: srcaddr value"
+				       " not specified.\n");
+				return 1;	/* needs_arg; */
+			}
+			i = cifs_convert_address((struct sockaddr *)&vol->srcaddr,
+						 value, strlen(value));
+			if (i < 0) {
+				printk(KERN_WARNING "CIFS:  Could not parse"
+				       " srcaddr: %s\n",
+				       value);
+				return 1;
+			}
 		} else if (strnicmp(data, "prefixpath", 10) == 0) {
 			if (!value || !*value) {
 				printk(KERN_WARNING
@@ -1392,8 +1409,36 @@ cifs_parse_mount_options(char *options, const char *devname,
 	return 0;
 }
 
+/** Returns true if srcaddr isn't specified and rhs isn't
+ * specified, or if srcaddr is specified and
+ * matches the IP address of the rhs argument.
+ */
+static bool
+srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
+{
+	switch (srcaddr->sa_family) {
+	case AF_UNSPEC:
+		return (rhs->sa_family == AF_UNSPEC);
+	case AF_INET: {
+		struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
+		struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
+		return (saddr4->sin_addr.s_addr == vaddr4->sin_addr.s_addr);
+	}
+	case AF_INET6: {
+		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
+		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)&rhs;
+		return ipv6_addr_equal(&saddr6->sin6_addr, &vaddr6->sin6_addr);
+	}
+	default:
+		WARN_ON(1);
+		return false; /* don't expect to be here */
+	}
+}
+
+
 static bool
-match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
+match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
+	      struct sockaddr *srcaddr)
 {
 	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
@@ -1420,6 +1465,9 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
 		break;
 	}
 
+	if (!srcip_matches(srcaddr, (struct sockaddr *)&server->srcaddr))
+		return false;
+
 	return true;
 }
 
@@ -1487,7 +1535,8 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 		if (server->tcpStatus == CifsNew)
 			continue;
 
-		if (!match_address(server, addr))
+		if (!match_address(server, addr,
+				   (struct sockaddr *)&vol->srcaddr))
 			continue;
 
 		if (!match_security(server, vol))
@@ -1602,6 +1651,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	 * no need to spinlock this init of tcpStatus or srv_count
 	 */
 	tcp_ses->tcpStatus = CifsNew;
+	memcpy(&tcp_ses->srcaddr, &volume_info->srcaddr,
+	       sizeof(tcp_ses->srcaddr));
 	++tcp_ses->srv_count;
 
 	if (addr.ss_family == AF_INET6) {
@@ -2026,6 +2077,33 @@ static void rfc1002mangle(char *target, char *source, unsigned int length)
 
 }
 
+static int
+bind_socket(struct TCP_Server_Info *server)
+{
+	int rc = 0;
+	if (server->srcaddr.ss_family != AF_UNSPEC) {
+		/* Bind to the specified local IP address */
+		struct socket *socket = server->ssocket;
+		rc = socket->ops->bind(socket,
+				       (struct sockaddr *) &server->srcaddr,
+				       sizeof(server->srcaddr));
+		if (rc < 0) {
+			struct sockaddr_in *saddr4;
+			struct sockaddr_in6 *saddr6;
+			saddr4 = (struct sockaddr_in *)&server->srcaddr;
+			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
+			if (saddr6->sin6_family == AF_INET6)
+				cERROR(1, "cifs: "
+				       "Failed to bind to: %pI6c, error: %d\n",
+				       &saddr6->sin6_addr, rc);
+			else
+				cERROR(1, "cifs: "
+				       "Failed to bind to: %pI4, error: %d\n",
+				       &saddr4->sin_addr.s_addr, rc);
+		}
+	}
+	return rc;
+}
 
 static int
 ipv4_connect(struct TCP_Server_Info *server)
@@ -2051,6 +2129,10 @@ ipv4_connect(struct TCP_Server_Info *server)
 		cifs_reclassify_socket4(socket);
 	}
 
+	rc = bind_socket(server);
+	if (rc < 0)
+		return rc;
+
 	/* user overrode default port */
 	if (server->addr.sockAddr.sin_port) {
 		rc = socket->ops->connect(socket, (struct sockaddr *)
@@ -2213,6 +2295,10 @@ ipv6_connect(struct TCP_Server_Info *server)
 		cifs_reclassify_socket6(socket);
 	}
 
+	rc = bind_socket(server);
+	if (rc < 0)
+		return rc;
+
 	/* user overrode default port */
 	if (server->addr.sockAddr6.sin6_port) {
 		rc = socket->ops->connect(socket,
-- 
1.6.2.5
