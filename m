Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03946C433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE29A613B4
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhEKQhl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 12:37:41 -0400
Received: from mx.cjr.nz ([51.158.111.142]:34576 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231230AbhEKQhl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 12:37:41 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id A6AD180BAA;
        Tue, 11 May 2021 16:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1620750993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FrCHkSpp8/ENB8Yy5oeqgYV8Q6i06KVdi7R5L2s1FJY=;
        b=bQ/CKiSRB+WwFZyppciRPfLTnHES5zle/rpDdaO6IxnMaWAiLXQwtJN1RP4wvoY+q3Xw1g
        XHmztXhitaa0uUYDQkf4E+oBsmL2UudO5trokbzqoNaODFhWWq1SOrPASY8PFtYZqmgOOr
        ow4/FNF0Iq2/ADTesvyXJUKPhkUoaBjk0Zi0QJleWEqR+eu0ZpeJQ+7dcl/x7A4u89Rhiz
        +k7TcPVjGvIdMHtFXetipeDnyDKvKanhQxEmIpJmDTK48iRho9428xTNYCcP7X4bcwuQs5
        K6QrTFvUqZdmzcTrHgtsHdLqJWadOc5zJ/46ha+WjaysTXyScjmp69x62Aqr3g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/3] cifs: handle multiple ip addresses per hostname
Date:   Tue, 11 May 2021 13:36:08 -0300
Message-Id: <20210511163609.11019-3-pc@cjr.nz>
In-Reply-To: <20210511163609.11019-1-pc@cjr.nz>
References: <20210511163609.11019-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Define a maximum number of 16 (CIFS_MAX_ADDR_COUNT) ip addresses the
client can handle per hostname at mount and reconnect time.
mount.cifs(8) will be responsible for passing multiple 'ip=' options
in order to tell what ip addresses the given hostname resolved to.

cifs.ko will now connect to all resolved ip addresses and pick up the
one that got connected first. In case there is no upcall or it failed
for some reason, the client will reuse the resolved ip addresses that
came from userspace mount.cifs(8).

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifs_dfs_ref.c |   48 +-
 fs/cifs/cifsglob.h     |    8 +-
 fs/cifs/connect.c      | 1042 ++++++++++++++++++++++++----------------
 fs/cifs/dfs_cache.c    |    6 +-
 fs/cifs/dns_resolve.c  |   72 +--
 fs/cifs/dns_resolve.h  |    5 +-
 fs/cifs/fs_context.c   |   22 +-
 fs/cifs/fs_context.h   |    4 +-
 fs/cifs/misc.c         |   47 +-
 9 files changed, 758 insertions(+), 496 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index c87c37cf2914..4ca718721bf9 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -143,8 +143,10 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	const char *prepath = NULL;
 	int md_len;
 	char *tkn_e;
-	char *srvIP = NULL;
 	char sep = ',';
+	struct sockaddr_storage *addrs = NULL;
+	char ip[INET6_ADDRSTRLEN + 1];
+	int numaddrs, i;
 	int off, noff;
 
 	if (sb_mountdata == NULL)
@@ -173,21 +175,28 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		}
 	}
 
-	rc = dns_resolve_server_name_to_ip(name, &srvIP);
-	if (rc < 0) {
+	addrs = kmalloc(CIFS_MAX_ADDR_COUNT * sizeof(*addrs), GFP_KERNEL);
+	if (!addrs) {
+		rc = -ENOMEM;
+		goto compose_mount_options_err;
+	}
+
+	rc = numaddrs = dns_resolve_server_name_to_addrs(name, addrs, CIFS_MAX_ADDR_COUNT);
+	if (rc <= 0) {
 		cifs_dbg(FYI, "%s: Failed to resolve server part of %s to IP: %d\n",
 			 __func__, name, rc);
+		rc = rc == 0 ? -EINVAL : rc;
 		goto compose_mount_options_err;
 	}
 
 	/*
-	 * In most cases, we'll be building a shorter string than the original,
-	 * but we do have to assume that the address in the ip= option may be
-	 * much longer than the original. Add the max length of an address
-	 * string to the length of the original string to allow for worst case.
+	 * In most cases, we'll be building a shorter string than the original, but we do have to
+	 * assume that the address in the ip= option may be much longer than the original.
+	 * Add the max length of CIFS_MAX_ADDR_COUNT * an address string to the length of the
+	 * original string to allow for worst case.
 	 */
-	md_len = strlen(sb_mountdata) + INET6_ADDRSTRLEN;
-	mountdata = kzalloc(md_len + sizeof("ip=") + 1, GFP_KERNEL);
+	md_len = strlen(sb_mountdata) + CIFS_MAX_ADDR_COUNT * (INET6_ADDRSTRLEN + sizeof(",ip="));
+	mountdata = kzalloc(md_len + 1, GFP_KERNEL);
 	if (mountdata == NULL) {
 		rc = -ENOMEM;
 		goto compose_mount_options_err;
@@ -227,10 +236,23 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	mountdata[md_len] = '\0';
 
 	/* copy new IP and ref share name */
-	if (mountdata[strlen(mountdata) - 1] != sep)
+	if (mountdata[strlen(mountdata) - 1] == sep)
+		mountdata[strlen(mountdata) - 1] = '\0';
+
+	for (i = 0; i < numaddrs; i++) {
+		struct sockaddr_storage *addr = &addrs[i];
+
+		if (addr->ss_family == AF_INET6) {
+			scnprintf(ip, sizeof(ip), "%pI6",
+				  &((struct sockaddr_in6 *)addr)->sin6_addr);
+		} else
+			scnprintf(ip, sizeof(ip), "%pI4", &((struct sockaddr_in *)addr)->sin_addr);
 		strncat(mountdata, &sep, 1);
-	strcat(mountdata, "ip=");
-	strcat(mountdata, srvIP);
+		strcat(mountdata, "ip=");
+		strcat(mountdata, ip);
+	}
+
+	kfree(addrs);
 
 	if (devname)
 		*devname = name;
@@ -241,13 +263,13 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	/*cifs_dbg(FYI, "%s: submount mountdata: %s\n", __func__, mountdata );*/
 
 compose_mount_options_out:
-	kfree(srvIP);
 	return mountdata;
 
 compose_mount_options_err:
 	kfree(mountdata);
 	mountdata = ERR_PTR(rc);
 	kfree(name);
+	kfree(addrs);
 	goto compose_mount_options_out;
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6c65e39f0509..ccc5917c2ff3 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -87,6 +87,9 @@
 /* maximum number of PDUs in one compound */
 #define MAX_COMPOUND 5
 
+/* maximum number of addresses we can handle from a resolved hostname */
+#define CIFS_MAX_ADDR_COUNT 16
+
 /*
  * Default number of credits to keep available for SMB3.
  * This value is chosen somewhat arbitrarily. The Windows client
@@ -589,8 +592,11 @@ struct TCP_Server_Info {
 	enum statusEnum tcpStatus; /* what we think the status is */
 	char *hostname; /* hostname portion of UNC string */
 	struct socket *ssocket;
-	struct sockaddr_storage dstaddr;
+	struct sockaddr_storage dst_addr_list[CIFS_MAX_ADDR_COUNT];
+	unsigned int dst_addr_count;
+	struct sockaddr_storage dstaddr; /* current destination address */
 	struct sockaddr_storage srcaddr; /* locally bind to this IP */
+	unsigned short port_num;
 #ifdef CONFIG_NET_NS
 	struct net *net;
 #endif
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 495c395f9def..43315a0365d6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -74,51 +74,462 @@ extern bool disable_legacy_dialects;
 /* Drop the connection to not overload the server */
 #define NUM_STATUS_IO_TIMEOUT   5
 
-static int ip_connect(struct TCP_Server_Info *server);
-static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
 static void cifs_prune_tlinks(struct work_struct *work);
 
-/*
- * Resolve hostname and set ip addr in tcp ses. Useful for hostnames that may
- * get their ip addresses changed at some point.
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key cifs_key[2];
+static struct lock_class_key cifs_slock_key[2];
+
+static inline void
+cifs_reclassify_socket4(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+
+	BUG_ON(!sock_allow_reclassification(sk));
+	sock_lock_init_class_and_name(sk, "slock-AF_INET-CIFS",
+		&cifs_slock_key[0], "sk_lock-AF_INET-CIFS", &cifs_key[0]);
+}
+
+static inline void
+cifs_reclassify_socket6(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+
+	BUG_ON(!sock_allow_reclassification(sk));
+	sock_lock_init_class_and_name(sk, "slock-AF_INET6-CIFS",
+		&cifs_slock_key[1], "sk_lock-AF_INET6-CIFS", &cifs_key[1]);
+}
+#else
+static inline void
+cifs_reclassify_socket4(struct socket *sock)
+{
+}
+
+static inline void
+cifs_reclassify_socket6(struct socket *sock)
+{
+}
+#endif
+
+/* See RFC1001 section 14 on representation of Netbios names */
+static void rfc1002mangle(char *target, char *source, unsigned int length)
+{
+	unsigned int i, j;
+
+	for (i = 0, j = 0; i < (length); i++) {
+		/* mask a nibble at a time and encode */
+		target[j] = 'A' + (0x0F & (source[i] >> 4));
+		target[j+1] = 'A' + (0x0F & source[i]);
+		j += 2;
+	}
+
+}
+
+static void set_ipaddr_port(struct sockaddr_storage *addrs, unsigned int numaddrs,
+			    unsigned short port)
+{
+	unsigned int i;
+
+	for (i = 0; i < numaddrs; i++)
+		cifs_set_port((struct sockaddr *)&addrs[i], port);
+}
+
+static void release_sockets(struct socket **socks, unsigned int numsocks)
+{
+	unsigned int i;
+
+	for (i = 0; i < numsocks; i++) {
+		if (socks[i])
+			sock_release(socks[i]);
+	}
+	kfree(socks);
+}
+
+static int cifs_bind_socket(struct TCP_Server_Info *server, struct socket *socket)
+{
+	int rc = 0;
+
+	if (server->srcaddr.ss_family != AF_UNSPEC) {
+		/* Bind to the specified local IP address */
+		rc = socket->ops->bind(socket, (struct sockaddr *)&server->srcaddr,
+				       sizeof(server->srcaddr));
+		if (rc < 0) {
+			struct sockaddr_in *saddr4;
+			struct sockaddr_in6 *saddr6;
+
+			saddr4 = (struct sockaddr_in *)&server->srcaddr;
+			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
+			if (saddr6->sin6_family == AF_INET6)
+				cifs_server_dbg(VFS, "Failed to bind to: %pI6c, error: %d\n", &saddr6->sin6_addr, rc);
+			else
+				cifs_server_dbg(VFS, "Failed to bind to: %pI4, error: %d\n", &saddr4->sin_addr.s_addr, rc);
+		}
+	}
+	return rc;
+}
+
+static struct socket *cifs_create_socket(struct TCP_Server_Info *server, int stype,
+					 struct sockaddr_storage *dstaddr)
+{
+	int rc = 0;
+	__be16 *sport;
+	int slen, sfamily;
+	struct socket *socket = NULL;
+
+	if (dstaddr->ss_family == AF_INET6) {
+		struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)dstaddr;
+
+		sport = &ipv6->sin6_port;
+		slen = sizeof(struct sockaddr_in6);
+		sfamily = AF_INET6;
+		cifs_dbg(FYI, "%s: connecting to [%pI6]:%d\n", __func__, &ipv6->sin6_addr,
+				ntohs(*sport));
+	} else {
+		struct sockaddr_in *ipv4 = (struct sockaddr_in *)dstaddr;
+
+		sport = &ipv4->sin_port;
+		slen = sizeof(struct sockaddr_in);
+		sfamily = AF_INET;
+		cifs_dbg(FYI, "%s: connecting to %pI4:%d\n", __func__, &ipv4->sin_addr,
+				ntohs(*sport));
+	}
+
+	rc = __sock_create(cifs_net_ns(server), sfamily, stype, IPPROTO_TCP, &socket, 1);
+	if (rc < 0) {
+		cifs_dbg(VFS, "%s: Error %d creating socket\n", __func__, rc);
+		return ERR_PTR(rc);
+	}
+
+	/* BB other socket options to set KEEPALIVE, NODELAY? */
+	cifs_dbg(FYI, "Socket created\n");
+	socket->sk->sk_allocation = GFP_NOFS;
+	if (sfamily == AF_INET6)
+		cifs_reclassify_socket6(socket);
+	else
+		cifs_reclassify_socket4(socket);
+
+	rc = cifs_bind_socket(server, socket);
+	if (rc < 0)
+		return ERR_PTR(rc);
+
+	/*
+	 * Eventually check for other socket options to change from
+	 * the default. sock_setsockopt not used because it expects
+	 * user space buffer
+	 */
+	socket->sk->sk_rcvtimeo = 7 * HZ;
+	socket->sk->sk_sndtimeo = 5 * HZ;
+
+	/* make the bufsizes depend on wsize/rsize and max requests */
+	if (server->noautotune) {
+		if (socket->sk->sk_sndbuf < (200 * 1024))
+			socket->sk->sk_sndbuf = 200 * 1024;
+		if (socket->sk->sk_rcvbuf < (140 * 1024))
+			socket->sk->sk_rcvbuf = 140 * 1024;
+	}
+
+	if (server->tcp_nodelay)
+		tcp_sock_set_nodelay(socket->sk);
+
+	cifs_dbg(FYI, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx\n",
+		 socket->sk->sk_sndbuf,
+		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
+
+	return socket;
+}
+
+static struct socket **connect_all_ips(struct TCP_Server_Info *server,
+				       struct sockaddr_storage *addrs, unsigned int numaddrs)
+{
+	unsigned int i;
+	struct socket **socks;
+	int rc = 0;
+
+	socks = kcalloc(numaddrs, sizeof(struct socket *), GFP_KERNEL);
+	if (!socks)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < numaddrs; i++) {
+		struct sockaddr_storage *addr = &addrs[i];
+		int slen = addr->ss_family == AF_INET6 ? sizeof(struct sockaddr_in6) :
+			sizeof(struct sockaddr_in);
+
+		socks[i] = cifs_create_socket(server, SOCK_STREAM, addr);
+		if (IS_ERR(socks[i])) {
+			rc = PTR_ERR(socks[i]);
+			socks[i] = NULL;
+			break;
+		}
+
+		rc = socks[i]->ops->connect(socks[i], (struct sockaddr *)addr, slen, O_NONBLOCK);
+#ifdef CONFIG_CIFS_DEBUG2
+		if (rc != 0 && rc != -EINPROGRESS)
+			cifs_dbg(FYI, "%s: socket connect() error: %d\n", __func__, rc);
+#endif
+		rc = 0;
+	}
+
+	if (rc) {
+		release_sockets(socks, numaddrs);
+		socks = ERR_PTR(rc);
+	}
+
+	return socks;
+}
+
+static struct socket *__get_first_connected_socket(struct socket **socks,
+						   struct sockaddr_storage *addrs,
+						   unsigned int numaddrs)
+{
+	unsigned int i, k;
+	struct socket *sock = ERR_PTR(-EHOSTUNREACH);
+	int rc;
+
+	for (i = 0; i < numaddrs; i++) {
+		struct sockaddr_storage naddr;
+
+		if (!socks[i])
+			continue;
+
+		rc = kernel_getpeername(socks[i], (struct sockaddr *)&naddr);
+		if (rc >= 0) {
+#ifdef CONFIG_CIFS_DEBUG2
+			struct sockaddr_in *ip4;
+			struct sockaddr_in6 *ip6;
+			__be16 *sport;
+
+			if (naddr.ss_family == AF_INET6) {
+				ip6 = (struct sockaddr_in6 *)&naddr;
+				sport = &ip6->sin6_port;
+				cifs_dbg(FYI, "%s: found a connected socket ([%pI6]:%d)\n", __func__,
+					 &ip6->sin6_addr, ntohs(*sport));
+			} else {
+				ip4 = (struct sockaddr_in *)&naddr;
+				sport = &ip4->sin_port;
+				cifs_dbg(FYI, "%s: found a connected socket (%pI4:%d)\n", __func__,
+					 &ip4->sin_addr, ntohs(*sport));
+			}
+
+#endif
+			for (k = 0; k < numaddrs; k++) {
+				struct sockaddr_storage *addr = &addrs[k];
+				if (cifs_match_ipaddr((struct sockaddr *)&naddr,
+						      (struct sockaddr *)addr)) {
+					swap(addrs[0], *addr);
+					break;
+				}
+			}
+			sock = socks[i];
+			socks[i] = NULL;
+			break;
+		}
+	}
+	return sock;
+}
+
+static struct socket *get_first_connected_socket(struct socket **socks,
+						 struct sockaddr_storage *addrs,
+						 unsigned int numaddrs, bool canwait)
+{
+	struct socket *sock;
+	int retries = 0;
+
+	if (!canwait)
+		return __get_first_connected_socket(socks, addrs, numaddrs);
+
+	do {
+		msleep(1 << retries);
+		sock = __get_first_connected_socket(socks, addrs, numaddrs);
+	} while (IS_ERR(sock) && ++retries < 13);
+	return sock;
+}
+
+static int
+ip_rfc1001_connect(struct TCP_Server_Info *server)
+{
+	int rc = 0;
+	/*
+	 * some servers require RFC1001 sessinit before sending
+	 * negprot - BB check reconnection in case where second
+	 * sessinit is sent but no second negprot
+	 */
+	struct rfc1002_session_packet *ses_init_buf;
+	struct smb_hdr *smb_buf;
+
+	ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
+			       GFP_KERNEL);
+	if (ses_init_buf) {
+		ses_init_buf->trailer.session_req.called_len = 32;
+
+		if (server->server_RFC1001_name[0] != 0)
+			rfc1002mangle(ses_init_buf->trailer.
+				      session_req.called_name,
+				      server->server_RFC1001_name,
+				      RFC1001_NAME_LEN_WITH_NULL);
+		else
+			rfc1002mangle(ses_init_buf->trailer.
+				      session_req.called_name,
+				      DEFAULT_CIFS_CALLED_NAME,
+				      RFC1001_NAME_LEN_WITH_NULL);
+
+		ses_init_buf->trailer.session_req.calling_len = 32;
+
+		/*
+		 * calling name ends in null (byte 16) from old smb
+		 * convention.
+		 */
+		if (server->workstation_RFC1001_name[0] != 0)
+			rfc1002mangle(ses_init_buf->trailer.
+				      session_req.calling_name,
+				      server->workstation_RFC1001_name,
+				      RFC1001_NAME_LEN_WITH_NULL);
+		else
+			rfc1002mangle(ses_init_buf->trailer.
+				      session_req.calling_name,
+				      "LINUX_CIFS_CLNT",
+				      RFC1001_NAME_LEN_WITH_NULL);
+
+		ses_init_buf->trailer.session_req.scope1 = 0;
+		ses_init_buf->trailer.session_req.scope2 = 0;
+		smb_buf = (struct smb_hdr *)ses_init_buf;
+
+		/* sizeof RFC1002_SESSION_REQUEST with no scope */
+		smb_buf->smb_buf_length = cpu_to_be32(0x81000044);
+		rc = smb_send(server, smb_buf, 0x44);
+		kfree(ses_init_buf);
+		/*
+		 * RFC1001 layer in at least one server
+		 * requires very short break before negprot
+		 * presumably because not expecting negprot
+		 * to follow so fast.  This is a simple
+		 * solution that works without
+		 * complicating the code and causes no
+		 * significant slowing down on mount
+		 * for everyone else
+		 */
+		usleep_range(1000, 2000);
+	}
+	/*
+	 * else the negprot may still work without this
+	 * even though malloc failed
+	 */
+
+	return rc;
+}
+
+static int cifs_ip_connect(struct TCP_Server_Info *server)
+{
+	struct socket **socks, *sock;
+	unsigned short port = server->port_num;
+	int rc;
+	bool rootfs = server->noblockcnt;
+
+	if (port == 0) {
+		/* try with 445 port at first */
+		port = CIFS_PORT;
+
+		set_ipaddr_port(server->dst_addr_list, server->dst_addr_count, port);
+		socks = connect_all_ips(server, server->dst_addr_list, server->dst_addr_count);
+		if (IS_ERR(socks)) {
+			rc = PTR_ERR(socks);
+			cifs_server_dbg(VFS, "%s: connect_all_ips() failed: %d\n", __func__, rc);
+			return rc;
+		}
+
+		/* if it failed, try with 139 port */
+		sock = get_first_connected_socket(socks, server->dst_addr_list,
+						  server->dst_addr_count, !rootfs);
+		release_sockets(socks, server->dst_addr_count);
+
+		if (IS_ERR(sock)) {
+			port = RFC1001_PORT;
+
+			set_ipaddr_port(server->dst_addr_list, server->dst_addr_count, port);
+			socks = connect_all_ips(server, server->dst_addr_list,
+						server->dst_addr_count);
+			if (IS_ERR(socks)) {
+				rc = PTR_ERR(socks);
+				cifs_server_dbg(VFS, "%s: connect_all_ips() failed: %d\n", __func__, rc);
+				return rc;
+			}
+			sock = get_first_connected_socket(socks, server->dst_addr_list,
+							  server->dst_addr_count, !rootfs);
+			release_sockets(socks, server->dst_addr_count);
+		}
+	} else {
+		set_ipaddr_port(server->dst_addr_list, server->dst_addr_count, port);
+		socks = connect_all_ips(server, server->dst_addr_list, server->dst_addr_count);
+		if (IS_ERR(socks)) {
+			cifs_server_dbg(VFS, "%s: connect_all_ips() failed: %d\n", __func__, rc);
+			return PTR_ERR(socks);
+		}
+		sock = get_first_connected_socket(socks, server->dst_addr_list,
+						  server->dst_addr_count, !rootfs);
+		release_sockets(socks, server->dst_addr_count);
+	}
+
+	if (IS_ERR(sock))
+		return PTR_ERR(sock);
+
+	rc = kernel_getpeername(sock, (struct sockaddr *)&server->dstaddr);
+	if (rc < 0) {
+		cifs_server_dbg(VFS, "%s: getpeername() failed with rc=%d\n",
+				__func__, rc);
+		sock_release(sock);
+		return rc;
+	}
+	server->port_num = port;
+	server->ssocket = sock;
+
+	return server->port_num == RFC1001_PORT ? ip_rfc1001_connect(server) : 0;
+}
+
+/**
+ * Set resolved address list in @addrs and number of addresses in @numaddrs.
+ *
+ * Useful for hostnames that may get their ip addresses changed at some point.
  *
- * This should be called with server->srv_mutex held.
  */
-static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
+static void reconn_resolve_hostname(struct TCP_Server_Info *server, struct sockaddr_storage *addrs,
+				    unsigned int *numaddrs)
 {
 	int rc;
 	int len;
-	char *unc, *ipaddr = NULL;
+	char *unc = NULL;
 
-	if (!server->hostname)
-		return -EINVAL;
-
-	len = strlen(server->hostname) + 3;
-
-	unc = kmalloc(len, GFP_KERNEL);
-	if (!unc) {
-		cifs_dbg(FYI, "%s: failed to create UNC path\n", __func__);
-		return -ENOMEM;
+	if (server->hostname) {
+		len = strlen(server->hostname) + 3;
+		unc = kmalloc(len, GFP_KERNEL);
+		if (!unc) {
+			cifs_server_dbg(VFS, "%s: failed to allocate UNC path\n", __func__);
+			cifs_server_dbg(FYI, "%s: reusing current list of ip addresses\n", __func__);
+		}
 	}
-	scnprintf(unc, len, "\\\\%s", server->hostname);
 
-	rc = dns_resolve_server_name_to_ip(unc, &ipaddr);
-	kfree(unc);
+	if (unc) {
+		scnprintf(unc, len, "\\\\%s", server->hostname);
 
-	if (rc < 0) {
-		cifs_dbg(FYI, "%s: failed to resolve server part of %s to IP: %d\n",
-			 __func__, server->hostname, rc);
-		return rc;
-	}
+		rc = dns_resolve_server_name_to_addrs(unc, addrs, *numaddrs);
+		kfree(unc);
 
-	spin_lock(&cifs_tcp_ses_lock);
-	rc = cifs_convert_address((struct sockaddr *)&server->dstaddr, ipaddr,
-				  strlen(ipaddr));
-	spin_unlock(&cifs_tcp_ses_lock);
-	kfree(ipaddr);
-
-	return !rc ? -1 : 0;
+		if (rc <= 0) {
+			cifs_server_dbg(FYI, "%s: couldn't resolve server hostname to IP(s): %d\n", __func__, rc);
+			cifs_server_dbg(FYI, "%s: reusing current list of ip addresses\n", __func__);
+			spin_lock(&cifs_tcp_ses_lock);
+			memcpy(addrs, server->dst_addr_list,
+			       sizeof(*addrs) * server->dst_addr_count);
+			*numaddrs = server->dst_addr_count;
+			spin_unlock(&cifs_tcp_ses_lock);
+		} else
+			*numaddrs = rc;
+	} else {
+		spin_lock(&cifs_tcp_ses_lock);
+		memcpy(addrs, server->dst_addr_list, sizeof(*addrs) * server->dst_addr_count);
+		*numaddrs = server->dst_addr_count;
+		spin_unlock(&cifs_tcp_ses_lock);
+	}
+	set_ipaddr_port(addrs, *numaddrs, server->port_num);
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
@@ -129,7 +540,6 @@ static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
 				       struct dfs_cache_tgt_iterator **tgt_it)
 {
 	const char *name;
-	int rc;
 
 	if (!cifs_sb || !cifs_sb->origin_fullpath)
 		return;
@@ -150,16 +560,9 @@ static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
 
 	server->hostname = extract_hostname(name);
 	if (IS_ERR(server->hostname)) {
-		cifs_dbg(FYI,
-			 "%s: failed to extract hostname from target: %ld\n",
-			 __func__, PTR_ERR(server->hostname));
-		return;
-	}
-
-	rc = reconn_set_ipaddr_from_hostname(server);
-	if (rc) {
-		cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
-			 __func__, rc);
+		cifs_dbg(VFS, "%s: failed to extract hostname from target: %ld\n", __func__,
+			 PTR_ERR(server->hostname));
+		server->hostname = NULL;
 	}
 }
 
@@ -195,6 +598,14 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	struct dfs_cache_tgt_list tgt_list = {0};
 	struct dfs_cache_tgt_iterator *tgt_it = NULL;
 #endif
+	struct sockaddr_storage *addrs = NULL;
+	unsigned int numaddrs;
+
+	addrs = kmalloc(sizeof(*addrs) * CIFS_MAX_ADDR_COUNT, GFP_KERNEL);
+	if (!addrs) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	spin_lock(&GlobalMid_Lock);
 	server->nr_targets = 1;
@@ -231,8 +642,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		dfs_cache_free_tgts(&tgt_list);
 		cifs_put_tcp_super(sb);
 #endif
-		wake_up(&server->response_q);
-		return rc;
+		goto out;
 	} else
 		server->tcpStatus = CifsNeedReconnect;
 	spin_unlock(&GlobalMid_Lock);
@@ -312,41 +722,70 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 		mutex_lock(&server->srv_mutex);
 
-
 		if (!cifs_swn_set_server_dstaddr(server)) {
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		if (cifs_sb && cifs_sb->origin_fullpath)
-			/*
-			 * Set up next DFS target server (if any) for reconnect. If DFS
-			 * feature is disabled, then we will retry last server we
-			 * connected to before.
-			 */
-			reconn_set_next_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
-		else {
-#endif
+			if (IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
+			    cifs_sb->origin_fullpath) {
+				/*
+				 * Set up next DFS target server (if any) for reconnect. If DFS
+				 * feature is disabled, then we will retry last server we
+				 * connected to before.
+				 */
+				reconn_set_next_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
+			}
 			/*
 			 * Resolve the hostname again to make sure that IP address is up-to-date.
 			 */
-			rc = reconn_set_ipaddr_from_hostname(server);
-			if (rc) {
-				cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
-						__func__, rc);
+			numaddrs = CIFS_MAX_ADDR_COUNT;
+			reconn_resolve_hostname(server, addrs, &numaddrs);
+
+			if (cifs_rdma_enabled(server)) {
+				/* FIXME: handle multiple ips for RDMA */
+				server->dst_addr_list[0] = server->dstaddr = addrs[0];
+				server->dst_addr_count = 1;
 			}
-
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		}
-#endif
-
-
+		} else {
+			addrs[0] = server->dstaddr;
+			numaddrs = 1;
 		}
 
-		if (cifs_rdma_enabled(server))
+		if (cifs_rdma_enabled(server)) {
 			rc = smbd_reconnect(server);
-		else
-			rc = generic_ip_connect(server);
+		} else {
+			struct socket **socks, *sock;
+
+			socks = connect_all_ips(server, addrs, numaddrs);
+			if (IS_ERR(socks)) {
+				rc = PTR_ERR(socks);
+				cifs_server_dbg(VFS, "%s: connect_all_ips() failed: %d\n", __func__, rc);
+			} else {
+				mutex_unlock(&server->srv_mutex);
+				sock = get_first_connected_socket(socks, addrs, numaddrs, true);
+				release_sockets(socks, numaddrs);
+				mutex_lock(&server->srv_mutex);
+
+				if (IS_ERR(sock)) {
+					rc = PTR_ERR(sock);
+					cifs_server_dbg(FYI, "%s: couldn't find a connected socket: %d\n", __func__, rc);
+				} else {
+					rc = kernel_getpeername(sock, (struct sockaddr *)&server->dstaddr);
+					if (rc < 0) {
+						cifs_server_dbg(VFS, "%s: getpeername() failed: %d\n", __func__, rc);
+						sock_release(sock);
+					} else
+						rc = 0;
+				}
+				if (!rc) {
+					memcpy(server->dst_addr_list, addrs,
+					       sizeof(addrs[0]) * numaddrs);
+					server->dst_addr_count = numaddrs;
+					server->ssocket = sock;
+				}
+			}
+		}
+
 		if (rc) {
-			cifs_dbg(FYI, "reconnect error %d\n", rc);
 			mutex_unlock(&server->srv_mutex);
+			cifs_server_dbg(FYI, "%s: reconnect error %d\n", __func__, rc);
 			msleep(3000);
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
@@ -382,7 +821,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 
+out:
 	wake_up(&server->response_q);
+	kfree(addrs);
 	return rc;
 }
 
@@ -1093,80 +1534,77 @@ cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs)
 	}
 }
 
-/*
- * If no port is specified in addr structure, we try to match with 445 port
- * and if it fails - with 139 ports. It should be called only if address
- * families of server and addr are equal.
- */
-static bool
-match_port(struct TCP_Server_Info *server, struct sockaddr *addr)
+static bool __match_address(struct TCP_Server_Info *server, struct sockaddr_storage *caddr)
 {
-	__be16 port, *sport;
+	unsigned int i;
+	bool match = false;
 
-	/* SMBDirect manages its own ports, don't match it here */
-	if (server->rdma)
-		return true;
+	for (i = 0; i < server->dst_addr_count && !match; i++) {
+		struct sockaddr *saddr = (struct sockaddr *)&server->dst_addr_list[i];
+		__be16 port, *sport;
 
-	switch (addr->sa_family) {
-	case AF_INET:
-		sport = &((struct sockaddr_in *) &server->dstaddr)->sin_port;
-		port = ((struct sockaddr_in *) addr)->sin_port;
-		break;
-	case AF_INET6:
-		sport = &((struct sockaddr_in6 *) &server->dstaddr)->sin6_port;
-		port = ((struct sockaddr_in6 *) addr)->sin6_port;
-		break;
-	default:
-		WARN_ON(1);
-		return false;
-	}
+		switch (saddr->sa_family) {
+		case AF_INET: {
+			struct sockaddr_in *addr4 = (struct sockaddr_in *)caddr;
+			struct sockaddr_in *srv_addr4 = (struct sockaddr_in *)saddr;
 
-	if (!port) {
-		port = htons(CIFS_PORT);
-		if (port == *sport)
+			if (addr4->sin_addr.s_addr != srv_addr4->sin_addr.s_addr)
+				continue;
+
+			sport = &srv_addr4->sin_port;
+			port = addr4->sin_port;
+			break;
+		}
+		case AF_INET6: {
+			struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)caddr;
+			struct sockaddr_in6 *srv_addr6 = (struct sockaddr_in6 *)saddr;
+
+			if (!ipv6_addr_equal(&addr6->sin6_addr, &srv_addr6->sin6_addr) ||
+			    addr6->sin6_scope_id != srv_addr6->sin6_scope_id)
+				continue;
+
+			sport = &srv_addr6->sin6_port;
+			port = addr6->sin6_port;
+			break;
+		}
+		default:
+			/* don't expect to be here */
+			WARN_ON(1);
+			return false;
+		}
+		/* SMBDirect manages its own ports, don't match it here */
+		if (cifs_rdma_enabled(server))
 			return true;
-
-		port = htons(RFC1001_PORT);
+		/*
+		 * If no port is specified in addr structure, we try to match with 445 port and if
+		 * it fails - with 139 ports. It should be called only if address families of server
+		 * and addr are equal.
+		 */
+		if (!port) {
+			port = htons(CIFS_PORT);
+			match |= port == *sport;
+			port = htons(RFC1001_PORT);
+		}
+		match |= port == *sport;
 	}
-
-	return port == *sport;
+	return match;
 }
 
-static bool
-match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
-	      struct sockaddr *srcaddr)
+static bool match_address(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
-	switch (addr->sa_family) {
-	case AF_INET: {
-		struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
-		struct sockaddr_in *srv_addr4 =
-					(struct sockaddr_in *)&server->dstaddr;
+	unsigned int i;
 
-		if (addr4->sin_addr.s_addr != srv_addr4->sin_addr.s_addr)
-			return false;
-		break;
-	}
-	case AF_INET6: {
-		struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
-		struct sockaddr_in6 *srv_addr6 =
-					(struct sockaddr_in6 *)&server->dstaddr;
-
-		if (!ipv6_addr_equal(&addr6->sin6_addr,
-				     &srv_addr6->sin6_addr))
-			return false;
-		if (addr6->sin6_scope_id != srv_addr6->sin6_scope_id)
-			return false;
-		break;
-	}
-	default:
-		WARN_ON(1);
-		return false; /* don't expect to be here */
-	}
-
-	if (!cifs_match_ipaddr(srcaddr, (struct sockaddr *)&server->srcaddr))
+	if (ctx->dst_addr_count != server->dst_addr_count ||
+	    (!cifs_rdma_enabled(server) && ctx->port && ctx->port != server->port_num))
 		return false;
 
-	return true;
+	/* check if source and destination addresses match */
+	for (i = 0; i < ctx->dst_addr_count; i++) {
+		if (!__match_address(server, &ctx->dst_addr_list[i]))
+			return false;
+	}
+	return cifs_match_ipaddr((struct sockaddr *)&ctx->srcaddr,
+				 (struct sockaddr *)&server->srcaddr);
 }
 
 static bool
@@ -1194,8 +1632,6 @@ match_security(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 static int match_server(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
-	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
-
 	if (ctx->nosharesock)
 		return 0;
 
@@ -1213,11 +1649,7 @@ static int match_server(struct TCP_Server_Info *server, struct smb3_fs_context *
 	if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
 		return 0;
 
-	if (!match_address(server, addr,
-			   (struct sockaddr *)&ctx->srcaddr))
-		return 0;
-
-	if (!match_port(server, addr))
+	if (!match_address(server, ctx))
 		return 0;
 
 	if (!match_security(server, ctx))
@@ -1364,8 +1796,17 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
 	mutex_init(&tcp_ses->reconnect_mutex);
 	memcpy(&tcp_ses->srcaddr, &ctx->srcaddr,
 	       sizeof(tcp_ses->srcaddr));
-	memcpy(&tcp_ses->dstaddr, &ctx->dstaddr,
-		sizeof(tcp_ses->dstaddr));
+
+	if (WARN_ON_ONCE(!ctx->dst_addr_count || ctx->dst_addr_count > CIFS_MAX_ADDR_COUNT)) {
+		rc = -EINVAL;
+		goto out_err_crypto_release;
+	}
+	memcpy(tcp_ses->dst_addr_list, ctx->dst_addr_list,
+	       ctx->dst_addr_count * sizeof(ctx->dst_addr_list[0]));
+	tcp_ses->dst_addr_count = ctx->dst_addr_count;
+	memcpy(&tcp_ses->dstaddr, &ctx->dstaddr, sizeof(tcp_ses->dstaddr));
+	tcp_ses->port_num = ctx->port;
+
 	if (ctx->use_client_guid)
 		memcpy(tcp_ses->client_guid, ctx->client_guid,
 		       SMB2_CLIENT_GUID_SIZE);
@@ -1401,7 +1842,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
 			goto out_err_crypto_release;
 		}
 	}
-	rc = ip_connect(tcp_ses);
+	rc = cifs_ip_connect(tcp_ses);
 	if (rc < 0) {
 		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
 		goto out_err_crypto_release;
@@ -2353,277 +2794,6 @@ cifs_match_super(struct super_block *sb, void *data)
 	return rc;
 }
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-static struct lock_class_key cifs_key[2];
-static struct lock_class_key cifs_slock_key[2];
-
-static inline void
-cifs_reclassify_socket4(struct socket *sock)
-{
-	struct sock *sk = sock->sk;
-	BUG_ON(!sock_allow_reclassification(sk));
-	sock_lock_init_class_and_name(sk, "slock-AF_INET-CIFS",
-		&cifs_slock_key[0], "sk_lock-AF_INET-CIFS", &cifs_key[0]);
-}
-
-static inline void
-cifs_reclassify_socket6(struct socket *sock)
-{
-	struct sock *sk = sock->sk;
-	BUG_ON(!sock_allow_reclassification(sk));
-	sock_lock_init_class_and_name(sk, "slock-AF_INET6-CIFS",
-		&cifs_slock_key[1], "sk_lock-AF_INET6-CIFS", &cifs_key[1]);
-}
-#else
-static inline void
-cifs_reclassify_socket4(struct socket *sock)
-{
-}
-
-static inline void
-cifs_reclassify_socket6(struct socket *sock)
-{
-}
-#endif
-
-/* See RFC1001 section 14 on representation of Netbios names */
-static void rfc1002mangle(char *target, char *source, unsigned int length)
-{
-	unsigned int i, j;
-
-	for (i = 0, j = 0; i < (length); i++) {
-		/* mask a nibble at a time and encode */
-		target[j] = 'A' + (0x0F & (source[i] >> 4));
-		target[j+1] = 'A' + (0x0F & source[i]);
-		j += 2;
-	}
-
-}
-
-static int
-bind_socket(struct TCP_Server_Info *server)
-{
-	int rc = 0;
-	if (server->srcaddr.ss_family != AF_UNSPEC) {
-		/* Bind to the specified local IP address */
-		struct socket *socket = server->ssocket;
-		rc = socket->ops->bind(socket,
-				       (struct sockaddr *) &server->srcaddr,
-				       sizeof(server->srcaddr));
-		if (rc < 0) {
-			struct sockaddr_in *saddr4;
-			struct sockaddr_in6 *saddr6;
-			saddr4 = (struct sockaddr_in *)&server->srcaddr;
-			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
-			if (saddr6->sin6_family == AF_INET6)
-				cifs_server_dbg(VFS, "Failed to bind to: %pI6c, error: %d\n",
-					 &saddr6->sin6_addr, rc);
-			else
-				cifs_server_dbg(VFS, "Failed to bind to: %pI4, error: %d\n",
-					 &saddr4->sin_addr.s_addr, rc);
-		}
-	}
-	return rc;
-}
-
-static int
-ip_rfc1001_connect(struct TCP_Server_Info *server)
-{
-	int rc = 0;
-	/*
-	 * some servers require RFC1001 sessinit before sending
-	 * negprot - BB check reconnection in case where second
-	 * sessinit is sent but no second negprot
-	 */
-	struct rfc1002_session_packet *ses_init_buf;
-	struct smb_hdr *smb_buf;
-	ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
-			       GFP_KERNEL);
-	if (ses_init_buf) {
-		ses_init_buf->trailer.session_req.called_len = 32;
-
-		if (server->server_RFC1001_name[0] != 0)
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.called_name,
-				      server->server_RFC1001_name,
-				      RFC1001_NAME_LEN_WITH_NULL);
-		else
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.called_name,
-				      DEFAULT_CIFS_CALLED_NAME,
-				      RFC1001_NAME_LEN_WITH_NULL);
-
-		ses_init_buf->trailer.session_req.calling_len = 32;
-
-		/*
-		 * calling name ends in null (byte 16) from old smb
-		 * convention.
-		 */
-		if (server->workstation_RFC1001_name[0] != 0)
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.calling_name,
-				      server->workstation_RFC1001_name,
-				      RFC1001_NAME_LEN_WITH_NULL);
-		else
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.calling_name,
-				      "LINUX_CIFS_CLNT",
-				      RFC1001_NAME_LEN_WITH_NULL);
-
-		ses_init_buf->trailer.session_req.scope1 = 0;
-		ses_init_buf->trailer.session_req.scope2 = 0;
-		smb_buf = (struct smb_hdr *)ses_init_buf;
-
-		/* sizeof RFC1002_SESSION_REQUEST with no scope */
-		smb_buf->smb_buf_length = cpu_to_be32(0x81000044);
-		rc = smb_send(server, smb_buf, 0x44);
-		kfree(ses_init_buf);
-		/*
-		 * RFC1001 layer in at least one server
-		 * requires very short break before negprot
-		 * presumably because not expecting negprot
-		 * to follow so fast.  This is a simple
-		 * solution that works without
-		 * complicating the code and causes no
-		 * significant slowing down on mount
-		 * for everyone else
-		 */
-		usleep_range(1000, 2000);
-	}
-	/*
-	 * else the negprot may still work without this
-	 * even though malloc failed
-	 */
-
-	return rc;
-}
-
-static int
-generic_ip_connect(struct TCP_Server_Info *server)
-{
-	int rc = 0;
-	__be16 sport;
-	int slen, sfamily;
-	struct socket *socket = server->ssocket;
-	struct sockaddr *saddr;
-
-	saddr = (struct sockaddr *) &server->dstaddr;
-
-	if (server->dstaddr.ss_family == AF_INET6) {
-		struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&server->dstaddr;
-
-		sport = ipv6->sin6_port;
-		slen = sizeof(struct sockaddr_in6);
-		sfamily = AF_INET6;
-		cifs_dbg(FYI, "%s: connecting to [%pI6]:%d\n", __func__, &ipv6->sin6_addr,
-				ntohs(sport));
-	} else {
-		struct sockaddr_in *ipv4 = (struct sockaddr_in *)&server->dstaddr;
-
-		sport = ipv4->sin_port;
-		slen = sizeof(struct sockaddr_in);
-		sfamily = AF_INET;
-		cifs_dbg(FYI, "%s: connecting to %pI4:%d\n", __func__, &ipv4->sin_addr,
-				ntohs(sport));
-	}
-
-	if (socket == NULL) {
-		rc = __sock_create(cifs_net_ns(server), sfamily, SOCK_STREAM,
-				   IPPROTO_TCP, &socket, 1);
-		if (rc < 0) {
-			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
-			server->ssocket = NULL;
-			return rc;
-		}
-
-		/* BB other socket options to set KEEPALIVE, NODELAY? */
-		cifs_dbg(FYI, "Socket created\n");
-		server->ssocket = socket;
-		socket->sk->sk_allocation = GFP_NOFS;
-		if (sfamily == AF_INET6)
-			cifs_reclassify_socket6(socket);
-		else
-			cifs_reclassify_socket4(socket);
-	}
-
-	rc = bind_socket(server);
-	if (rc < 0)
-		return rc;
-
-	/*
-	 * Eventually check for other socket options to change from
-	 * the default. sock_setsockopt not used because it expects
-	 * user space buffer
-	 */
-	socket->sk->sk_rcvtimeo = 7 * HZ;
-	socket->sk->sk_sndtimeo = 5 * HZ;
-
-	/* make the bufsizes depend on wsize/rsize and max requests */
-	if (server->noautotune) {
-		if (socket->sk->sk_sndbuf < (200 * 1024))
-			socket->sk->sk_sndbuf = 200 * 1024;
-		if (socket->sk->sk_rcvbuf < (140 * 1024))
-			socket->sk->sk_rcvbuf = 140 * 1024;
-	}
-
-	if (server->tcp_nodelay)
-		tcp_sock_set_nodelay(socket->sk);
-
-	cifs_dbg(FYI, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx\n",
-		 socket->sk->sk_sndbuf,
-		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
-
-	rc = socket->ops->connect(socket, saddr, slen,
-				  server->noblockcnt ? O_NONBLOCK : 0);
-	/*
-	 * When mounting SMB root file systems, we do not want to block in
-	 * connect. Otherwise bail out and then let cifs_reconnect() perform
-	 * reconnect failover - if possible.
-	 */
-	if (server->noblockcnt && rc == -EINPROGRESS)
-		rc = 0;
-	if (rc < 0) {
-		cifs_dbg(FYI, "Error %d connecting to server\n", rc);
-		sock_release(socket);
-		server->ssocket = NULL;
-		return rc;
-	}
-
-	if (sport == htons(RFC1001_PORT))
-		rc = ip_rfc1001_connect(server);
-
-	return rc;
-}
-
-static int
-ip_connect(struct TCP_Server_Info *server)
-{
-	__be16 *sport;
-	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
-	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
-
-	if (server->dstaddr.ss_family == AF_INET6)
-		sport = &addr6->sin6_port;
-	else
-		sport = &addr->sin_port;
-
-	if (*sport == 0) {
-		int rc;
-
-		/* try with 445 port at first */
-		*sport = htons(CIFS_PORT);
-
-		rc = generic_ip_connect(server);
-		if (rc >= 0)
-			return rc;
-
-		/* if it failed, try with 139 port */
-		*sport = htons(RFC1001_PORT);
-	}
-
-	return generic_ip_connect(server);
-}
-
 void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 {
@@ -3161,20 +3331,36 @@ cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const c
 	}
 
 	if (mntopts) {
-		char *ip;
+		char *opts, *nopts, *key, *val, sep;
+		unsigned int count = 0;
 
-		rc = smb3_parse_opt(mntopts, "ip", &ip);
-		if (rc) {
-			cifs_dbg(VFS, "%s: failed to parse ip options: %d\n", __func__, rc);
+		opts = kstrdup(mntopts, GFP_KERNEL);
+		if (!opts)
+			return -ENOMEM;
+
+		smb3_options_for_each(opts, nopts, sep, key, val) {
+			if (strcasecmp(key, "ip"))
+				continue;
+			cifs_dbg(FYI, "%s: parsed ip address: %s\n", __func__, val);
+			if (!cifs_convert_address((struct sockaddr *)&ctx->dst_addr_list[count],
+						  val, strlen(val))) {
+				cifs_dbg(VFS, "%s: failed to convert ip address\n", __func__);
+				rc = -EINVAL;
+				break;
+			}
+			if (++count == CIFS_MAX_ADDR_COUNT)
+				break;
+		}
+		kfree(opts);
+
+		if (!rc && !count) {
+			cifs_dbg(VFS, "%s: could not find any ip address option\n", __func__);
+			rc = -EINVAL;
+		}
+		if (rc)
 			return rc;
-		}
 
-		rc = cifs_convert_address((struct sockaddr *)&ctx->dstaddr, ip, strlen(ip));
-		kfree(ip);
-		if (!rc) {
-			cifs_dbg(VFS, "%s: failed to convert ip address\n", __func__);
-			return -EINVAL;
-		}
+		ctx->dst_addr_count = count;
 	}
 
 	if (ctx->nullauth) {
@@ -3185,9 +3371,11 @@ cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const c
 		/* BB fixme parse for domain name here */
 		cifs_dbg(FYI, "Username: %s\n", ctx->username);
 	} else {
+		/*
+		 * In userspace mount helper we can get user name from alternate locations such as
+		 * env variables and files on disk.
+		 */
 		cifs_dbg(VFS, "No username specified\n");
-	/* In userspace mount helper we can get user name from alternate
-	   locations such as env variables and files on disk */
 		return -EINVAL;
 	}
 
@@ -3391,6 +3579,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	char *mntdata = NULL;
 	bool ref_server = false;
 
+	cifs_dbg(FYI, "%s: mount_options=%s\n", __func__, cifs_sb->ctx->mount_options);
+
 	rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
 	/*
 	 * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwise unconditionally
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index b1fa30fefe1f..5c3129d4af1d 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1235,8 +1235,10 @@ int dfs_cache_update_vol(const char *fullpath, struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "%s: updating volume info\n", __func__);
 	spin_lock(&vi->ctx_lock);
-	memcpy(&vi->ctx.dstaddr, &server->dstaddr,
-	       sizeof(vi->ctx.dstaddr));
+	memcpy(vi->ctx.dst_addr_list, server->dst_addr_list,
+	       server->dst_addr_count * sizeof(server->dst_addr_list[0]));
+	vi->ctx.dst_addr_count = server->dst_addr_count;
+	memcpy(&vi->ctx.dstaddr, &server->dstaddr, sizeof(vi->ctx.dstaddr));
 	spin_unlock(&vi->ctx_lock);
 
 	kref_put(&vi->refcnt, vol_release);
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 534cbba72789..977ac4ba789b 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -32,25 +32,40 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 
+static int iplist_to_addrs(char *ips, struct sockaddr_storage *addrs, int maxaddrs)
+{
+	char *ip;
+	int count = 0;
+
+	while ((ip = strsep(&ips, ",")) && count < maxaddrs) {
+		struct sockaddr_storage addr;
+
+		if (!*ip)
+			break;
+
+		cifs_dbg(FYI, "%s: add \'%s\' to the list of ip addresses\n", __func__, ip);
+		if (cifs_convert_address((struct sockaddr *)&addr, ip, strlen(ip)) > 0)
+			addrs[count++] = addr;
+	}
+	return count;
+}
+
 /**
- * dns_resolve_server_name_to_ip - Resolve UNC server name to ip address.
+ * dns_resolve_server_name_to_addrs - Resolve UNC server name to a list of addresses.
  * @unc: UNC path specifying the server (with '/' as delimiter)
- * @ip_addr: Where to return the IP address.
+ * @addrs: Where to return the list of addresses.
+ * @maxaddrs: Maximum number of addresses.
  *
- * The IP address will be returned in string form, and the caller is
- * responsible for freeing it.
- *
- * Returns length of result on success, -ve on error.
+ * Returns the number of resolved addresses, otherwise a negative error number.
  */
-int
-dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
+int dns_resolve_server_name_to_addrs(const char *unc, struct sockaddr_storage *addrs, int maxaddrs)
 {
 	struct sockaddr_storage ss;
 	const char *hostname, *sep;
-	char *name;
+	char *ips;
 	int len, rc;
 
-	if (!ip_addr || !unc)
+	if (!addrs || !maxaddrs || !unc)
 		return -EINVAL;
 
 	len = strlen(unc);
@@ -73,28 +88,23 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 
 	/* Try to interpret hostname as an IPv4 or IPv6 address */
 	rc = cifs_convert_address((struct sockaddr *)&ss, hostname, len);
-	if (rc > 0)
-		goto name_is_IP_address;
+	if (rc > 0) {
+		cifs_dbg(FYI, "%s: unc is IP, skipping dns upcall: %s\n", __func__, hostname);
+		addrs[0] = ss;
+		return 1;
+	}
 
 	/* Perform the upcall */
-	rc = dns_query(current->nsproxy->net_ns, NULL, hostname, len,
-		       NULL, ip_addr, NULL, false);
-	if (rc < 0)
-		cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n",
-			 __func__, len, len, hostname);
-	else
-		cifs_dbg(FYI, "%s: resolved: %*.*s to %s\n",
-			 __func__, len, len, hostname, *ip_addr);
+	rc = dns_query(current->nsproxy->net_ns, NULL, hostname, len, "list", &ips, NULL, false);
+	if (rc < 0) {
+		cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n", __func__, len, len, hostname);
+		return rc;
+	}
+	cifs_dbg(FYI, "%s: resolved: %*.*s to %s\n", __func__, len, len, hostname, ips);
+
+	rc = iplist_to_addrs(ips, addrs, maxaddrs);
+	cifs_dbg(FYI, "%s: num of resolved ips: %d\n", __func__, rc);
+	kfree(ips);
+
 	return rc;
-
-name_is_IP_address:
-	name = kmalloc(len + 1, GFP_KERNEL);
-	if (!name)
-		return -ENOMEM;
-	memcpy(name, hostname, len);
-	name[len] = 0;
-	cifs_dbg(FYI, "%s: unc is IP, skipping dns upcall: %s\n",
-		 __func__, name);
-	*ip_addr = name;
-	return 0;
 }
diff --git a/fs/cifs/dns_resolve.h b/fs/cifs/dns_resolve.h
index d3f5d27f4d06..b6defe354278 100644
--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -23,8 +23,11 @@
 #ifndef _DNS_RESOLVE_H
 #define _DNS_RESOLVE_H
 
+#include <linux/net.h>
+
 #ifdef __KERNEL__
-extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
+extern int dns_resolve_server_name_to_addrs(const char *unc, struct sockaddr_storage *addrs,
+					    int maxaddrs);
 #endif /* KERNEL */
 
 #endif /* _DNS_RESOLVE_H */
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 5d21cd905315..a5b80bed2719 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -591,6 +591,7 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 static int smb3_fs_context_validate(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
+	unsigned int i;
 
 	if (ctx->rdma && ctx->vals->protocol_id < SMB30_PROT_ID) {
 		cifs_errorf(fc, "SMB Direct requires Version >=3.0\n");
@@ -633,9 +634,12 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 			pr_err("Unable to determine destination address\n");
 			return -EHOSTUNREACH;
 		}
+		ctx->dst_addr_list[ctx->dst_addr_count++] = ctx->dstaddr;
 	}
 
 	/* set the port that we got earlier */
+	for (i = 0; i < ctx->dst_addr_count; i++)
+		cifs_set_port((struct sockaddr *)&ctx->dst_addr_list[i], ctx->port);
 	cifs_set_port((struct sockaddr *)&ctx->dstaddr, ctx->port);
 
 	if (ctx->override_uid && !ctx->uid_specified) {
@@ -792,6 +796,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
+	struct sockaddr_storage dstaddr;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -1096,12 +1101,25 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			ctx->got_ip = false;
 			break;
 		}
-		if (!cifs_convert_address((struct sockaddr *)&ctx->dstaddr,
-					  param->string,
+
+		if (ctx->dst_addr_count >= CIFS_MAX_ADDR_COUNT) {
+			cifs_errorf(fc, "reached max number (%u) of ip addresses.  ignoring ip=%s option.\n",
+				    CIFS_MAX_ADDR_COUNT, param->string);
+			break;
+		}
+
+		if (!cifs_convert_address((struct sockaddr *)&dstaddr, param->string,
 					  strlen(param->string))) {
 			pr_err("bad ip= option (%s)\n", param->string);
 			goto cifs_parse_mount_err;
 		}
+
+		if (ctx->dst_addr_count == 0)
+			ctx->dstaddr = dstaddr;
+
+		cifs_dbg(FYI, "%s: add \'%s\' to the list of destination addresses\n", __func__,
+			 param->string);
+		ctx->dst_addr_list[ctx->dst_addr_count++] = dstaddr;
 		ctx->got_ip = true;
 		break;
 	case Opt_domain:
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 2a71c8e411ac..08e863b6c9b1 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -247,7 +247,9 @@ struct smb3_fs_context {
 	struct smb_version_operations *ops;
 	struct smb_version_values *vals;
 	char *prepath;
-	struct sockaddr_storage dstaddr; /* destination address */
+	struct sockaddr_storage dst_addr_list[CIFS_MAX_ADDR_COUNT]; /* list of dest addresses */
+	unsigned int dst_addr_count; /* number of dest addresses */
+	struct sockaddr_storage dstaddr; /* current destination address */
 	struct sockaddr_storage srcaddr; /* allow binding to a local IP */
 	struct nls_table *local_nls; /* This is a copy of the pointer in cifs_sb */
 	unsigned int echo_interval; /* echo interval in secs */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 7b3b1ea76baf..cce3c6b709c1 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1178,43 +1178,52 @@ int match_target_ip(struct TCP_Server_Info *server,
 		    bool *result)
 {
 	int rc;
-	char *target, *tip = NULL;
-	struct sockaddr tipaddr;
+	struct sockaddr_storage *addrs = NULL;
+	unsigned int numaddrs, i, j;
+	char *target = NULL;
 
 	*result = false;
 
 	target = kzalloc(share_len + 3, GFP_KERNEL);
-	if (!target) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!target)
+		return -ENOMEM;
 
 	scnprintf(target, share_len + 3, "\\\\%.*s", (int)share_len, share);
 
 	cifs_dbg(FYI, "%s: target name: %s\n", __func__, target + 2);
 
-	rc = dns_resolve_server_name_to_ip(target, &tip);
-	if (rc < 0)
+	addrs = kcalloc(CIFS_MAX_ADDR_COUNT, sizeof(*addrs), GFP_KERNEL);
+	if (!addrs) {
+		rc = -ENOMEM;
 		goto out;
+	}
 
-	cifs_dbg(FYI, "%s: target ip: %s\n", __func__, tip);
-
-	if (!cifs_convert_address(&tipaddr, tip, strlen(tip))) {
-		cifs_dbg(VFS, "%s: failed to convert target ip address\n",
-			 __func__);
-		rc = -EINVAL;
+	rc = numaddrs = dns_resolve_server_name_to_addrs(target, addrs, CIFS_MAX_ADDR_COUNT);
+	if (rc <= 0) {
+		cifs_dbg(FYI, "%s: failed to resolve server name: %d\n", __func__, rc);
+		rc = rc == 0 ? -EINVAL : rc;
 		goto out;
 	}
 
-	*result = cifs_match_ipaddr((struct sockaddr *)&server->dstaddr,
-				    &tipaddr);
-	cifs_dbg(FYI, "%s: ip addresses match: %u\n", __func__, *result);
 	rc = 0;
 
+	if (server->dst_addr_count != numaddrs)
+		goto out;
+	for (i = 0; i < numaddrs; i++) {
+		bool match = false;
+
+		for (j = 0; j < server->dst_addr_count && !match; j++)
+			match |= cifs_match_ipaddr((struct sockaddr *)&server->dst_addr_list[j],
+						   (struct sockaddr *)&addrs[i]);
+		if (!match)
+			break;
+	}
+	*result = i == numaddrs;
+
 out:
+	cifs_dbg(FYI, "%s: ip addresses match: %u\n", __func__, *result);
 	kfree(target);
-	kfree(tip);
-
+	kfree(addrs);
 	return rc;
 }
 
-- 
2.31.1

