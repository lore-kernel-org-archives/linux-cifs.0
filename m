From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: smb2:  Support srcaddr= logic for smb2 protocol.
Date: Tue, 07 Sep 2010 10:21:25 -0700
Message-ID: <4C867495.1030706@candelatech.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090105090906000207020804"
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090105090906000207020804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Here's a compile-tested patch to enable srcaddr= for smb2.

It converts a bit of smb2 to be more like cifs (seems smb2 was copy
and pasted and then cifs moved on).

It also seems like much of the common code could move to a
helper module or something...way too much similarity between
cifs and smb2 to have all that duplication.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com


--------------090105090906000207020804
Content-Type: text/plain;
 name="smb2-srcaddr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="smb2-srcaddr.patch"

diff --git a/fs/smb2/connect.c b/fs/smb2/connect.c
index df1ae76..380a78e 100644
--- a/fs/smb2/connect.c
+++ b/fs/smb2/connect.c
@@ -54,6 +54,7 @@ struct smb2_vol {
 	char *prepath;
 	char source_rfc1001_name[16]; /* netbios name of client. name of server
 					 now fixed as *SMBSERVER */
+	struct sockaddr_storage srcaddr; /* allow binding to a local IP */
 	uid_t linux_uid;
 	gid_t linux_gid;
 	mode_t file_mode;
@@ -128,6 +129,33 @@ static void rfc1002mangle(char *target, char *source, unsigned int length)
 
 }
 
+static int
+bind_socket(struct tcp_srv_inf *server)
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
+				sERROR(1, "smb2: "
+				       "Failed to bind to: %pI6c, error: %d\n",
+				       &saddr6->sin6_addr, rc);
+			else
+				sERROR(1, "smb2: "
+				       "Failed to bind to: %pI4, error: %d\n",
+				       &saddr4->sin_addr.s_addr, rc);
+		}
+	}
+	return rc;
+}
 
 static int
 ipv4_connect(struct tcp_srv_inf *server)
@@ -153,6 +181,10 @@ ipv4_connect(struct tcp_srv_inf *server)
 		smb2_reclassify_socket4(socket);
 	}
 
+	rc = bind_socket(server);
+	if (rc < 0)
+		return rc;
+
 	/* user overrode default port */
 	if (server->addr.sockAddr.sin_port) {
 		rc = socket->ops->connect(socket, (struct sockaddr *)
@@ -309,6 +341,10 @@ ipv6_connect(struct tcp_srv_inf *server)
 		smb2_reclassify_socket6(socket);
 	}
 
+	rc = bind_socket(server);
+	if (rc < 0)
+		return rc;
+
 	/* user overrode default port */
 	if (server->addr.sockAddr6.sin6_port) {
 		rc = socket->ops->connect(socket,
@@ -388,6 +424,66 @@ smb2_put_tcp_session(struct tcp_srv_inf *server)
 		force_sig(SIGKILL, task);
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
+static bool
+match_address(struct tcp_srv_inf *server, struct sockaddr *addr,
+	      struct sockaddr *srcaddr)
+{
+	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
+
+	switch (addr->sa_family) {
+	case AF_INET:
+		if (addr4->sin_addr.s_addr !=
+		    server->addr.sockAddr.sin_addr.s_addr)
+			return false;
+		if (addr4->sin_port &&
+		    addr4->sin_port != server->addr.sockAddr.sin_port)
+			return false;
+		break;
+	case AF_INET6:
+		if (!ipv6_addr_equal(&addr6->sin6_addr,
+				     &server->addr.sockAddr6.sin6_addr))
+			return false;
+		if (addr6->sin6_scope_id !=
+		    server->addr.sockAddr6.sin6_scope_id)
+			return false;
+		if (addr6->sin6_port &&
+		    addr6->sin6_port != server->addr.sockAddr6.sin6_port)
+			return false;
+		break;
+	}
+
+	if (!srcip_matches(srcaddr, (struct sockaddr *)&server->srcaddr))
+		return false;
+
+	return true;
+}
 
 static struct smb2_ses *
 smb2_find_smb_ses(struct tcp_srv_inf *server, char *username)
@@ -479,12 +575,10 @@ smb2_put_tcon(struct smb2_tcon *tcon)
 }
 
 static struct tcp_srv_inf *
-smb2_find_tcp_session(struct sockaddr_storage *addr)
+smb2_find_tcp_session(struct sockaddr_storage *addr, struct smb2_vol *vol)
 {
 	struct list_head *tmp;
 	struct tcp_srv_inf *server;
-	struct sockaddr_in *addr4 = (struct sockaddr_in *) addr;
-	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *) addr;
 
 	write_lock(&smb2_tcp_ses_lock);
 	list_for_each(tmp, &smb2_tcp_ses_list) {
@@ -499,13 +593,9 @@ smb2_find_tcp_session(struct sockaddr_storage *addr)
 		if (server->tcp_status == SMB2NEW)
 			continue;
 
-		if (addr->ss_family == AF_INET &&
-		    (addr4->sin_addr.s_addr !=
-		     server->addr.sockAddr.sin_addr.s_addr))
-			continue;
-		else if (addr->ss_family == AF_INET6 &&
-			 !ipv6_addr_equal(&server->addr.sockAddr6.sin6_addr,
-					  &addr6->sin6_addr))
+
+		if (!match_address(server, (struct sockaddr *)addr,
+				   (struct sockaddr *)&vol->srcaddr))
 			continue;
 
 		++server->srv_count;
@@ -656,12 +746,12 @@ smb2_get_tcp_session(struct smb2_vol *vol_info)
 	memset(&addr, 0, sizeof(struct sockaddr_storage));
 
 	if (vol_info->UNCip && vol_info->UNC) {
-		rc = smb2_inet_pton(AF_INET, vol_info->UNCip,
+		rc = smb2_inet_pton(AF_INET, vol_info->UNCip, -1,
 				    &sin_server->sin_addr.s_addr);
 
 		if (rc <= 0) {
 			/* not ipv4 address, try ipv6 */
-			rc = smb2_inet_pton(AF_INET6, vol_info->UNCip,
+			rc = smb2_inet_pton(AF_INET6, vol_info->UNCip, -1,
 					    &sin_server6->sin6_addr.in6_u);
 			if (rc > 0)
 				addr.ss_family = AF_INET6;
@@ -691,7 +781,7 @@ smb2_get_tcp_session(struct smb2_vol *vol_info)
 	}
 
 	/* see if we already have a matching tcp_ses */
-	tcp_ses = smb2_find_tcp_session(&addr);
+	tcp_ses = smb2_find_tcp_session(&addr, vol_info);
 	if (tcp_ses)
 		return tcp_ses;
 
@@ -733,6 +823,8 @@ smb2_get_tcp_session(struct smb2_vol *vol_info)
 	 * no need to spinlock this init of tcp_status or srv_count
 	 */
 	tcp_ses->tcp_status = SMB2NEW;
+	memcpy(&tcp_ses->srcaddr, &vol_info->srcaddr,
+	       sizeof(tcp_ses->srcaddr));
 	++tcp_ses->srv_count;
 
 	if (addr.ss_family == AF_INET6) {
@@ -1069,6 +1161,22 @@ static int smb2_parse_mount_options(char *options, const char *devname,
 						    "long\n");
 				return -EINVAL;
 			}
+		} else if (strnicmp(data, "srcaddr", 7) == 0) {
+			vol->srcaddr.ss_family = AF_UNSPEC;
+
+			if (!value || !*value) {
+				printk(KERN_WARNING "SMB2: srcaddr value"
+				       " not specified.\n");
+				return 1;	/* needs_arg; */
+			}
+			i = smb2_convert_address((struct sockaddr *)&vol->srcaddr,
+						 value, strlen(value));
+			if (i < 0) {
+				printk(KERN_WARNING "SMB2:  Could not parse"
+				       " srcaddr: %s\n",
+				       value);
+				return 1;
+			}
 		} else if (strnicmp(data, "prefixpath", 10) == 0) {
 			if (!value || !*value) {
 				printk(KERN_WARNING
diff --git a/fs/smb2/dns_resolve.c b/fs/smb2/dns_resolve.c
index e762573..5eeefe1 100644
--- a/fs/smb2/dns_resolve.c
+++ b/fs/smb2/dns_resolve.c
@@ -41,12 +41,12 @@ is_ip(const char *name)
 	struct sockaddr_in sin_server;
 	struct sockaddr_in6 sin_server6;
 
-	rc = smb2_inet_pton(AF_INET, name,
+	rc = smb2_inet_pton(AF_INET, name, -1,
 			&sin_server.sin_addr.s_addr);
 
 	if (rc <= 0) {
 		/* not ipv4 address, try ipv6 */
-		rc = smb2_inet_pton(AF_INET6, name,
+		rc = smb2_inet_pton(AF_INET6, name, -1,
 				&sin_server6.sin6_addr.in6_u);
 		if (rc > 0)
 			return 1;
diff --git a/fs/smb2/misc.c b/fs/smb2/misc.c
index dfe8722..e4a7bfd 100644
--- a/fs/smb2/misc.c
+++ b/fs/smb2/misc.c
@@ -431,15 +431,15 @@ dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length)
 /* returns 0 if invalid address */
 
 int
-smb2_inet_pton(const int address_family, const char *cp, void *dst)
+smb2_inet_pton(const int address_family, const char *cp, int alen, void *dst)
 {
 	int ret = 0;
 
 	/* calculate length by finding first slash or NULL */
 	if (address_family == AF_INET)
-		ret = in4_pton(cp, -1 /* len */, dst, '\\', NULL);
+		ret = in4_pton(cp, alen, dst, '\\', NULL);
 	else if (address_family == AF_INET6)
-		ret = in6_pton(cp, -1 /* len */, dst , '\\', NULL);
+		ret = in6_pton(cp, alen, dst , '\\', NULL);
 
 	sFYI(DBG2, "address conversion returned %d for %s", ret, cp);
 	if (ret > 0)
@@ -447,6 +447,53 @@ smb2_inet_pton(const int address_family, const char *cp, void *dst)
 	return ret;
 }
 
+/*
+ * Try to convert a string to an IPv4 address and then attempt to convert
+ * it to an IPv6 address if that fails. Set the family field if either
+ * succeeds. If it's an IPv6 address and it has a '%' sign in it, try to
+ * treat the part following it as a numeric sin6_scope_id.
+ *
+ * Returns 0 on failure.
+ */
+int
+smb2_convert_address(struct sockaddr *dst, const char *src, int len)
+{
+	int rc, alen, slen;
+	const char *pct;
+	char *endp, scope_id[13];
+	struct sockaddr_in *s4 = (struct sockaddr_in *) dst;
+	struct sockaddr_in6 *s6 = (struct sockaddr_in6 *) dst;
+
+	/* IPv4 address */
+	if (smb2_inet_pton(AF_INET, src, len, &s4->sin_addr.s_addr)) {
+		s4->sin_family = AF_INET;
+		return 1;
+	}
+
+	/* attempt to exclude the scope ID from the address part */
+	pct = memchr(src, '%', len);
+	alen = pct ? pct - src : len;
+
+	rc = smb2_inet_pton(AF_INET6, src, alen, &s6->sin6_addr.s6_addr);
+	if (!rc)
+		return rc;
+
+	s6->sin6_family = AF_INET6;
+	if (pct) {
+		/* grab the scope ID */
+		slen = len - (alen + 1);
+		if (slen <= 0 || slen > 12)
+			return 0;
+		memcpy(scope_id, pct + 1, slen);
+		scope_id[slen] = '\0';
+
+		s6->sin6_scope_id = (u32) simple_strtoul(pct, &endp, 0);
+		if (endp != scope_id + slen)
+			return 0;
+	}
+
+	return rc;
+}
 
 /*
  *  The size of the variable area depends on the offset and length fields
diff --git a/fs/smb2/smb2fs.c b/fs/smb2/smb2fs.c
index 0465019..43b7b1a 100644
--- a/fs/smb2/smb2fs.c
+++ b/fs/smb2/smb2fs.c
@@ -607,6 +607,9 @@ smb2_show_options(struct seq_file *s, struct vfsmount *m)
 
 	tcon = smb2_sb->tcon;
 	if (tcon) {
+		struct sockaddr *srcaddr;
+		srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
+
 		seq_printf(s, ",unc=%s", smb2_sb->tcon->tree_name);
 		if (tcon->ses) {
 			if (tcon->ses->username)
@@ -631,6 +634,22 @@ smb2_show_options(struct seq_file *s, struct vfsmount *m)
 			}
 		}
 
+		if (srcaddr->sa_family != AF_UNSPEC) {
+			struct sockaddr_in *saddr4;
+			struct sockaddr_in6 *saddr6;
+			saddr4 = (struct sockaddr_in *)srcaddr;
+			saddr6 = (struct sockaddr_in6 *)srcaddr;
+			if (srcaddr->sa_family == AF_INET6)
+				seq_printf(s, ",srcaddr=%pI6c",
+					   &saddr6->sin6_addr);
+			else if (srcaddr->sa_family == AF_INET)
+				seq_printf(s, ",srcaddr=%pI4",
+					   &saddr4->sin_addr.s_addr);
+			else
+				seq_printf(s, ",srcaddr=BAD-AF:%i",
+					   (int)(srcaddr->sa_family));
+		}
+
 		seq_printf(s, ",uid=%d", smb2_sb->mnt_uid);
 		seq_printf(s, ",gid=%d", smb2_sb->mnt_gid);
 		seq_printf(s, ",file_mode=0%o,dir_mode=0%o",
diff --git a/fs/smb2/smb2glob.h b/fs/smb2/smb2glob.h
index 7102dad..b7638c4 100644
--- a/fs/smb2/smb2glob.h
+++ b/fs/smb2/smb2glob.h
@@ -123,6 +123,7 @@ struct tcp_srv_inf {
 		struct sockaddr_in sockAddr;
 		struct sockaddr_in6 sockAddr6;
 	} addr;
+	struct sockaddr_storage srcaddr; /* locally bind to this IP */
 	wait_queue_head_t response_q;
 	wait_queue_head_t request_q; /* if more than maxmpx to srvr must block*/
 
diff --git a/fs/smb2/smb2proto.h b/fs/smb2/smb2proto.h
index 2f7fa81..b3b0f52 100644
--- a/fs/smb2/smb2proto.h
+++ b/fs/smb2/smb2proto.h
@@ -114,8 +114,9 @@ extern void smb2_fattr_to_inode(struct inode *pinode, struct smb2_fattr *attr);
 extern void renew_parental_timestamps(struct dentry *direntry);
 extern int smb2_flush(struct file *file, fl_owner_t id);
 
-extern int smb2_inet_pton(const int, const char *source, void *dst);
+extern int smb2_inet_pton(const int, const char *source, int alen, void *dst);
 extern struct key_type key_type_dns_resolver_smb2;
+extern int smb2_convert_address(struct sockaddr *dst, const char *src, int len);
 extern int dns_resolve_smb2_server_name_to_ip(const char *unc, char **ip_addr);
 extern char *smb2_compose_mount_options(const char *sb_mountdata,
 			const char *fullpath, const struct dfs_info3_param *ref,

--------------090105090906000207020804--
