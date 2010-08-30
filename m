From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: [cifs bindaddr v3] cifs: Allow binding to local IP address.
Date: Mon, 30 Aug 2010 11:19:40 -0700
Message-ID: <4C7BF63C.2060503@candelatech.com>
References: <1282844096-13295-1-git-send-email-greearb@candelatech.com>	<AANLkTik4Cffnr0ciYAVXz_jb_=EG5kBaKNE3V3cNVtwf@mail.gmail.com>	<4C777615.2080109@erion.co.uk>	<AANLkTi=9xBr2gABJSUSk2DMJEYho+jA3rbCk1PSfuQQ5@mail.gmail.com>	<20100827095433.26bb3c3e@corrin.poochiereds.net>	<4C77D9ED.4050101@candelatech.com>	<20100827125242.0798ffe9@tlielax.poochiereds.net>	<AANLkTim-Hsn77fJUR1TrM_szVaJ3_vYzw61j0GYMt+Rr@mail.gmail.com>	<4C77F1F0.4070800@candelatech.com>	<20100827133401.75eb7f7f@tlielax.poochiereds.net> <AANLkTikDjbWv0F18WevNbsfJyutEu28RCCgtmp1=ZBd4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000004050905080403010608"
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikDjbWv0F18WevNbsfJyutEu28RCCgtmp1=ZBd4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000004050905080403010608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Updated patch is attached.  It *should* support IPv4 & IPv6, but I've only
tested IPv4 to date.  I need to work on my test rig before I can
test v6, hopefully will get that done in a day or two.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com


--------------000004050905080403010608
Content-Type: text/plain;
 name="cifs_bind_v4_v6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cifs_bind_v4_v6.patch"

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b7431af..fb4ecbe 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -357,6 +357,24 @@ cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
 	}
 }
 
+bool
+cifs_addr_is_specified(struct sockaddr* srcaddr) {
+	struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
+	struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
+	switch (srcaddr->sa_family) {
+	case AF_INET:
+		return saddr4->sin_addr.s_addr != 0;
+		
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6:
+		/* in6addr_any isn't available if IPv6 isn't compiled in */
+		return (memcmp(&in6addr_any, &saddr6->sin6_addr,
+			       sizeof(in6addr_any)) == 0);
+#endif
+	}
+	return false;
+}
+
 /*
  * cifs_show_options() is for displaying mount options in /proc/mounts.
  * Not all settable options are displayed but most of the important
@@ -374,6 +392,19 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 	if (tcon->ses->domainName)
 		seq_printf(s, ",domain=%s", tcon->ses->domainName);
 
+	if (cifs_addr_is_specified((struct sockaddr*)(&tcon->ses->server->srcaddr))) {
+		struct sockaddr_in *saddr4;
+		struct sockaddr_in6 *saddr6;
+		saddr4 = (struct sockaddr_in *)&tcon->ses->server->srcaddr;
+		saddr6 = (struct sockaddr_in6 *)&tcon->ses->server->srcaddr;
+		if (saddr6->sin6_family == AF_INET6)
+			seq_printf(s, ",srcaddr=%pI6",
+			   &saddr6->sin6_addr);
+		else
+			seq_printf(s, ",srcaddr=%pI4",
+			   &saddr4->sin_addr.s_addr);	
+	}
+
 	seq_printf(s, ",uid=%d", cifs_sb->mnt_uid);
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
 		seq_printf(s, ",forceuid");
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index d82f5fb..0f0d786 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -110,6 +110,9 @@ extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
+struct sockaddr;
+extern bool cifs_addr_is_specified(struct sockaddr* srcaddr);
+
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 extern const struct export_operations cifs_export_ops;
 #endif /* EXPERIMENTAL */
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
index ec0ea4a..f88af63 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -49,6 +49,7 @@
 #include "rfc1002pdu.h"
 #include "cn_cifs.h"
 #include "fscache.h"
+#include "cifsfs.h"
 
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
@@ -105,6 +106,7 @@ struct smb_vol {
 	bool sockopt_tcp_nodelay:1;
 	unsigned short int port;
 	char *prepath;
+	struct sockaddr_storage srcaddr; /* allow binding to a local IP address */
 	struct nls_table *local_nls;
 };
 
@@ -1064,6 +1066,22 @@ cifs_parse_mount_options(char *options, const char *devname,
 						    "long\n");
 				return 1;
 			}
+		} else if (strnicmp(data, "srcaddr", 8) == 0) {
+			memset(&vol->srcaddr, 0, sizeof(vol->srcaddr));
+
+			if (!value || !*value) {
+				printk(KERN_WARNING "CIFS: srcaddr value"
+				       " not specified.\n");
+				return 1;	/* needs_arg; */
+			}
+			i = cifs_convert_address((struct sockaddr *)(&vol->srcaddr),
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
@@ -1392,8 +1410,37 @@ cifs_parse_mount_options(char *options, const char *devname,
 	return 0;
 }
 
+/** Returns true if srcaddr isn't specified or if it matches
+ * the IP address of the rhs argument.
+ */
 static bool
-match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
+srcip_matches(struct sockaddr* srcaddr, struct sockaddr* rhs)
+{
+	if (cifs_addr_is_specified(srcaddr)) {
+		struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
+		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
+		struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
+		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)&rhs;
+
+		switch (srcaddr->sa_family) {
+		case AF_INET:
+			if (saddr4->sin_addr.s_addr != vaddr4->sin_addr.s_addr)
+				return false;
+			break;
+		case AF_INET6:
+			if (memcmp(&saddr6->sin6_addr, &vaddr6->sin6_addr,
+				   sizeof(saddr6->sin6_addr)) != 0)
+				return false;
+			break;
+		}
+	}
+	return true;
+}
+
+
+static bool
+match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
+	      struct sockaddr* srcaddr)
 {
 	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
@@ -1420,6 +1467,9 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
 		break;
 	}
 
+	if (!srcip_matches(srcaddr, (struct sockaddr*)&server->srcaddr))
+		return false;
+	
 	return true;
 }
 
@@ -1487,7 +1537,7 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 		if (server->tcpStatus == CifsNew)
 			continue;
 
-		if (!match_address(server, addr))
+		if (!match_address(server, addr, (struct sockaddr*)&vol->srcaddr))
 			continue;
 
 		if (!match_security(server, vol))
@@ -1602,6 +1652,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	 * no need to spinlock this init of tcpStatus or srv_count
 	 */
 	tcp_ses->tcpStatus = CifsNew;
+	memcpy(&tcp_ses->srcaddr, &volume_info->srcaddr, sizeof(tcp_ses->srcaddr));
 	++tcp_ses->srv_count;
 
 	if (addr.ss_family == AF_INET6) {
@@ -1678,6 +1729,9 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))
 				continue;
+			if (!srcip_matches((struct sockaddr*)&server->srcaddr,
+					   (struct sockaddr*)&ses->server->srcaddr))
+				continue;
 		}
 		++ses->ses_count;
 		write_unlock(&cifs_tcp_ses_lock);
@@ -2051,6 +2105,24 @@ ipv4_connect(struct TCP_Server_Info *server)
 		cifs_reclassify_socket4(socket);
 	}
 
+	if (cifs_addr_is_specified((struct sockaddr*)&server->srcaddr)) {
+		/* Bind to the local IP address if specified */
+		rc = socket->ops->bind(socket, (struct sockaddr *) &server->srcaddr,
+				       sizeof(server->srcaddr));
+		if (rc < 0) {
+			struct sockaddr_in *saddr4;
+			struct sockaddr_in6 *saddr6;
+			saddr4 = (struct sockaddr_in *)&server->srcaddr;
+			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
+			if (saddr6->sin6_family == AF_INET6)
+				cERROR(1, "Failed to bind to: %pI6, error: %d\n",
+				       &saddr6->sin6_addr, rc);
+			else
+				cERROR(1, "Failed to bind to: %pI4, error: %d\n",
+				       &saddr4->sin_addr.s_addr, rc);
+		}
+	}
+	
 	/* user overrode default port */
 	if (server->addr.sockAddr.sin_port) {
 		rc = socket->ops->connect(socket, (struct sockaddr *)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index ab70a3f..4c0e04b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -234,6 +234,8 @@ const struct in6_addr in6addr_loopback = IN6ADDR_LOOPBACK_INIT;
 const struct in6_addr in6addr_linklocal_allnodes = IN6ADDR_LINKLOCAL_ALLNODES_INIT;
 const struct in6_addr in6addr_linklocal_allrouters = IN6ADDR_LINKLOCAL_ALLROUTERS_INIT;
 
+EXPORT_SYMBOL(in6addr_any);
+
 /* Check if a valid qdisc is available */
 static inline bool addrconf_qdisc_ok(const struct net_device *dev)
 {

--------------000004050905080403010608--
