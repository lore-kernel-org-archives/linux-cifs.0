From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] CIFS: Simplify ipv*_connect functions into one (try #4)
Date: Mon, 13 Dec 2010 19:08:35 +0300
Message-ID: <1292256516-4343-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Make connect logic more ip-protocol independent and move RFC1001 stuff into
a separate function. Also replace union addr in TCP_Server_Info structure
with sockaddr_storage.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cache.c       |   16 ++-
 fs/cifs/cifs_spnego.c |   10 +-
 fs/cifs/cifsfs.c      |   15 +-
 fs/cifs/cifsglob.h    |    5 +-
 fs/cifs/connect.c     |  383 ++++++++++++++++++++-----------------------------
 fs/cifs/transport.c   |    2 +-
 6 files changed, 184 insertions(+), 247 deletions(-)

diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
index 224d7bb..e654dfd 100644
--- a/fs/cifs/cache.c
+++ b/fs/cifs/cache.c
@@ -64,7 +64,9 @@ static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
 				   void *buffer, uint16_t maxbuf)
 {
 	const struct TCP_Server_Info *server = cookie_netfs_data;
-	const struct sockaddr *sa = (struct sockaddr *) &server->addr.sockAddr;
+	const struct sockaddr *sa = (struct sockaddr *) &server->dstaddr;
+	const struct sockaddr_in *addr = (struct sockaddr_in *) sa;
+	const struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *) sa;
 	struct cifs_server_key *key = buffer;
 	uint16_t key_len = sizeof(struct cifs_server_key);
 
@@ -76,16 +78,16 @@ static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
 	 */
 	switch (sa->sa_family) {
 	case AF_INET:
-		key->family = server->addr.sockAddr.sin_family;
-		key->port = server->addr.sockAddr.sin_port;
-		key->addr[0].ipv4_addr = server->addr.sockAddr.sin_addr;
+		key->family = sa->sa_family;
+		key->port = addr->sin_port;
+		key->addr[0].ipv4_addr = addr->sin_addr;
 		key_len += sizeof(key->addr[0].ipv4_addr);
 		break;
 
 	case AF_INET6:
-		key->family = server->addr.sockAddr6.sin6_family;
-		key->port = server->addr.sockAddr6.sin6_port;
-		key->addr[0].ipv6_addr = server->addr.sockAddr6.sin6_addr;
+		key->family = sa->sa_family;
+		key->port = addr6->sin6_port;
+		key->addr[0].ipv6_addr = addr6->sin6_addr;
 		key_len += sizeof(key->addr[0].ipv6_addr);
 		break;
 
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 8704490..4dfba82 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -98,6 +98,8 @@ struct key *
 cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
 {
 	struct TCP_Server_Info *server = sesInfo->server;
+	struct sockaddr_in *sa = (struct sockaddr_in *) &server->dstaddr;
+	struct sockaddr_in6 *sa6 = (struct sockaddr_in6 *) &server->dstaddr;
 	char *description, *dp;
 	size_t desc_len;
 	struct key *spnego_key;
@@ -127,10 +129,10 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
 	dp = description + strlen(description);
 
 	/* add the server address */
-	if (server->addr.sockAddr.sin_family == AF_INET)
-		sprintf(dp, "ip4=%pI4", &server->addr.sockAddr.sin_addr);
-	else if (server->addr.sockAddr.sin_family == AF_INET6)
-		sprintf(dp, "ip6=%pI6", &server->addr.sockAddr6.sin6_addr);
+	if (server->dstaddr.ss_family == AF_INET)
+		sprintf(dp, "ip4=%pI4", &sa->sin_addr);
+	else if (server->dstaddr.ss_family == AF_INET6)
+		sprintf(dp, "ip6=%pI6", &sa6->sin6_addr);
 	else
 		goto out;
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3936aa7..9df5c0b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -351,18 +351,19 @@ cifs_evict_inode(struct inode *inode)
 static void
 cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
 {
+	struct sockaddr_in *sa = (struct sockaddr_in *) &server->dstaddr;
+	struct sockaddr_in6 *sa6 = (struct sockaddr_in6 *) &server->dstaddr;
+
 	seq_printf(s, ",addr=");
 
-	switch (server->addr.sockAddr.sin_family) {
+	switch (server->dstaddr.ss_family) {
 	case AF_INET:
-		seq_printf(s, "%pI4", &server->addr.sockAddr.sin_addr.s_addr);
+		seq_printf(s, "%pI4", &sa->sin_addr.s_addr);
 		break;
 	case AF_INET6:
-		seq_printf(s, "%pI6",
-			   &server->addr.sockAddr6.sin6_addr.s6_addr);
-		if (server->addr.sockAddr6.sin6_scope_id)
-			seq_printf(s, "%%%u",
-				   server->addr.sockAddr6.sin6_scope_id);
+		seq_printf(s, "%pI6", &sa6->sin6_addr.s6_addr);
+		if (sa6->sin6_scope_id)
+			seq_printf(s, "%%%u", sa6->sin6_scope_id);
 		break;
 	default:
 		seq_printf(s, "(unknown)");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7136c0c..dfd2d46 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -163,10 +163,7 @@ struct TCP_Server_Info {
 	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	char *hostname; /* hostname portion of UNC string */
 	struct socket *ssocket;
-	union {
-		struct sockaddr_in sockAddr;
-		struct sockaddr_in6 sockAddr6;
-	} addr;
+	struct sockaddr_storage dstaddr;
 	struct sockaddr_storage srcaddr; /* locally bind to this IP */
 	wait_queue_head_t response_q;
 	wait_queue_head_t request_q; /* if more than maxmpx to srvr must block*/
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cc1a860..b90c741 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -115,8 +115,8 @@ struct smb_vol {
 #define TLINK_ERROR_EXPIRE	(1 * HZ)
 #define TLINK_IDLE_EXPIRE	(600 * HZ)
 
-static int ipv4_connect(struct TCP_Server_Info *server);
-static int ipv6_connect(struct TCP_Server_Info *server);
+static int ip_connect(struct TCP_Server_Info *server);
+static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
 static void cifs_prune_tlinks(struct work_struct *work);
 
@@ -200,10 +200,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	while ((server->tcpStatus != CifsExiting) &&
 	       (server->tcpStatus != CifsGood)) {
 		try_to_freeze();
-		if (server->addr.sockAddr6.sin6_family == AF_INET6)
-			rc = ipv6_connect(server);
-		else
-			rc = ipv4_connect(server);
+
+		/* we should try only the port we connected to before */
+		rc = generic_ip_connect(server);
 		if (rc) {
 			cFYI(1, "reconnect error %d", rc);
 			msleep(3000);
@@ -477,7 +476,7 @@ incomplete_rcv:
 			 * initialize frame)
 			 */
 			cifs_set_port((struct sockaddr *)
-					&server->addr.sockAddr, CIFS_PORT);
+					&server->dstaddr, CIFS_PORT);
 			cifs_reconnect(server);
 			csocket = server->ssocket;
 			wake_up(&server->response_q);
@@ -1459,30 +1458,37 @@ static bool
 match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
 	      struct sockaddr *srcaddr)
 {
-	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
-	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
-
 	switch (addr->sa_family) {
-	case AF_INET:
-		if (addr4->sin_addr.s_addr !=
-		    server->addr.sockAddr.sin_addr.s_addr)
+	case AF_INET: {
+		struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
+		struct sockaddr_in *srv_addr4 =
+					(struct sockaddr_in *)&server->dstaddr;
+
+		if (addr4->sin_addr.s_addr != srv_addr4->sin_addr.s_addr)
 			return false;
-		if (addr4->sin_port &&
-		    addr4->sin_port != server->addr.sockAddr.sin_port)
+		if (addr4->sin_port && addr4->sin_port != srv_addr4->sin_port)
 			return false;
 		break;
-	case AF_INET6:
+	}
+	case AF_INET6: {
+		struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
+		struct sockaddr_in6 *srv_addr6 =
+					(struct sockaddr_in6 *)&server->dstaddr;
+
 		if (!ipv6_addr_equal(&addr6->sin6_addr,
-				     &server->addr.sockAddr6.sin6_addr))
+				     &srv_addr6->sin6_addr))
 			return false;
-		if (addr6->sin6_scope_id !=
-		    server->addr.sockAddr6.sin6_scope_id)
+		if (addr6->sin6_scope_id != srv_addr6->sin6_scope_id)
 			return false;
 		if (addr6->sin6_port &&
-		    addr6->sin6_port != server->addr.sockAddr6.sin6_port)
+		    addr6->sin6_port != srv_addr6->sin6_port)
 			return false;
 		break;
 	}
+	default:
+		WARN_ON(1);
+		return false; /* don't expect to be here */
+	}
 
 	if (!srcip_matches(srcaddr, (struct sockaddr *)&server->srcaddr))
 		return false;
@@ -1681,14 +1687,13 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		cFYI(1, "attempting ipv6 connect");
 		/* BB should we allow ipv6 on port 139? */
 		/* other OS never observed in Wild doing 139 with v6 */
-		memcpy(&tcp_ses->addr.sockAddr6, sin_server6,
-			sizeof(struct sockaddr_in6));
-		rc = ipv6_connect(tcp_ses);
-	} else {
-		memcpy(&tcp_ses->addr.sockAddr, sin_server,
-			sizeof(struct sockaddr_in));
-		rc = ipv4_connect(tcp_ses);
-	}
+		memcpy(&tcp_ses->dstaddr, sin_server6,
+		       sizeof(struct sockaddr_in6));
+	} else
+		memcpy(&tcp_ses->dstaddr, sin_server,
+		       sizeof(struct sockaddr_in));
+
+	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
 		cERROR(1, "Error connecting to socket. Aborting operation");
 		goto out_err_crypto_release;
@@ -1793,6 +1798,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
 	int rc = -ENOMEM, xid;
 	struct cifsSesInfo *ses;
+	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
 
 	xid = GetXid();
 
@@ -1836,12 +1843,10 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 
 	/* new SMB session uses our server ref */
 	ses->server = server;
-	if (server->addr.sockAddr6.sin6_family == AF_INET6)
-		sprintf(ses->serverName, "%pI6",
-			&server->addr.sockAddr6.sin6_addr);
+	if (server->dstaddr.ss_family == AF_INET6)
+		sprintf(ses->serverName, "%pI6", &addr6->sin6_addr);
 	else
-		sprintf(ses->serverName, "%pI4",
-			&server->addr.sockAddr.sin_addr.s_addr);
+		sprintf(ses->serverName, "%pI4", &addr->sin_addr);
 
 	if (volume_info->username)
 		strncpy(ses->userName, volume_info->username,
@@ -2136,19 +2141,106 @@ bind_socket(struct TCP_Server_Info *server)
 }
 
 static int
-ipv4_connect(struct TCP_Server_Info *server)
+ip_rfc1001_connect(struct TCP_Server_Info *server)
 {
 	int rc = 0;
-	int val;
-	bool connected = false;
-	__be16 orig_port = 0;
+	/*
+	 * some servers require RFC1001 sessinit before sending
+	 * negprot - BB check reconnection in case where second
+	 * sessinit is sent but no second negprot
+	 */
+	struct rfc1002_session_packet *ses_init_buf;
+	struct smb_hdr *smb_buf;
+	ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
+			       GFP_KERNEL);
+	if (ses_init_buf) {
+		ses_init_buf->trailer.session_req.called_len = 32;
+
+		if (server->server_RFC1001_name &&
+		    server->server_RFC1001_name[0] != 0)
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
+		if (server->workstation_RFC1001_name &&
+		    server->workstation_RFC1001_name[0] != 0)
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
+		smb_buf->smb_buf_length = 0x81000044;
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
+static int
+generic_ip_connect(struct TCP_Server_Info *server)
+{
+	int rc = 0;
+	unsigned short int sport;
+	int slen, sfamily;
 	struct socket *socket = server->ssocket;
+	struct sockaddr *saddr;
+
+	saddr = (struct sockaddr *) &server->dstaddr;
+
+	if (server->dstaddr.ss_family == AF_INET6) {
+		sport = ((struct sockaddr_in6 *) saddr)->sin6_port;
+		slen = sizeof(struct sockaddr_in6);
+		sfamily = AF_INET6;
+	} else {
+		sport = ((struct sockaddr_in *) saddr)->sin_port;
+		slen = sizeof(struct sockaddr_in);
+		sfamily = AF_INET;
+	}
 
 	if (socket == NULL) {
-		rc = sock_create_kern(PF_INET, SOCK_STREAM,
+		rc = sock_create_kern(sfamily, SOCK_STREAM,
 				      IPPROTO_TCP, &socket);
 		if (rc < 0) {
 			cERROR(1, "Error %d creating socket", rc);
+			server->ssocket = NULL;
 			return rc;
 		}
 
@@ -2156,63 +2248,28 @@ ipv4_connect(struct TCP_Server_Info *server)
 		cFYI(1, "Socket created");
 		server->ssocket = socket;
 		socket->sk->sk_allocation = GFP_NOFS;
-		cifs_reclassify_socket4(socket);
+		if (sfamily == AF_INET6)
+			cifs_reclassify_socket6(socket);
+		else
+			cifs_reclassify_socket4(socket);
 	}
 
 	rc = bind_socket(server);
 	if (rc < 0)
 		return rc;
 
-	/* user overrode default port */
-	if (server->addr.sockAddr.sin_port) {
-		rc = socket->ops->connect(socket, (struct sockaddr *)
-					  &server->addr.sockAddr,
-					  sizeof(struct sockaddr_in), 0);
-		if (rc >= 0)
-			connected = true;
-	}
-
-	if (!connected) {
-		/* save original port so we can retry user specified port
-			later if fall back ports fail this time  */
-		orig_port = server->addr.sockAddr.sin_port;
-
-		/* do not retry on the same port we just failed on */
-		if (server->addr.sockAddr.sin_port != htons(CIFS_PORT)) {
-			server->addr.sockAddr.sin_port = htons(CIFS_PORT);
-			rc = socket->ops->connect(socket,
-						(struct sockaddr *)
-						&server->addr.sockAddr,
-						sizeof(struct sockaddr_in), 0);
-			if (rc >= 0)
-				connected = true;
-		}
-	}
-	if (!connected) {
-		server->addr.sockAddr.sin_port = htons(RFC1001_PORT);
-		rc = socket->ops->connect(socket, (struct sockaddr *)
-					      &server->addr.sockAddr,
-					      sizeof(struct sockaddr_in), 0);
-		if (rc >= 0)
-			connected = true;
-	}
-
-	/* give up here - unless we want to retry on different
-		protocol families some day */
-	if (!connected) {
-		if (orig_port)
-			server->addr.sockAddr.sin_port = orig_port;
-		cFYI(1, "Error %d connecting to server via ipv4", rc);
+	rc = socket->ops->connect(socket, saddr, slen, 0);
+	if (rc < 0) {
+		cFYI(1, "Error %d connecting to server", rc);
 		sock_release(socket);
 		server->ssocket = NULL;
 		return rc;
 	}
 
-
 	/*
 	 * Eventually check for other socket options to change from
-	 *  the default. sock_setsockopt not used because it expects
-	 *  user space buffer
+	 * the default. sock_setsockopt not used because it expects
+	 * user space buffer
 	 */
 	socket->sk->sk_rcvtimeo = 7 * HZ;
 	socket->sk->sk_sndtimeo = 5 * HZ;
@@ -2226,7 +2283,7 @@ ipv4_connect(struct TCP_Server_Info *server)
 	}
 
 	if (server->tcp_nodelay) {
-		val = 1;
+		int val = 1;
 		rc = kernel_setsockopt(socket, SOL_TCP, TCP_NODELAY,
 				(char *)&val, sizeof(val));
 		if (rc)
@@ -2237,161 +2294,39 @@ ipv4_connect(struct TCP_Server_Info *server)
 		 socket->sk->sk_sndbuf,
 		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
 
-	/* send RFC1001 sessinit */
-	if (server->addr.sockAddr.sin_port == htons(RFC1001_PORT)) {
-		/* some servers require RFC1001 sessinit before sending
-		negprot - BB check reconnection in case where second
-		sessinit is sent but no second negprot */
-		struct rfc1002_session_packet *ses_init_buf;
-		struct smb_hdr *smb_buf;
-		ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
-				       GFP_KERNEL);
-		if (ses_init_buf) {
-			ses_init_buf->trailer.session_req.called_len = 32;
-			if (server->server_RFC1001_name &&
-			    server->server_RFC1001_name[0] != 0)
-				rfc1002mangle(ses_init_buf->trailer.
-						session_req.called_name,
-					      server->server_RFC1001_name,
-					      RFC1001_NAME_LEN_WITH_NULL);
-			else
-				rfc1002mangle(ses_init_buf->trailer.
-						session_req.called_name,
-					      DEFAULT_CIFS_CALLED_NAME,
-					      RFC1001_NAME_LEN_WITH_NULL);
-
-			ses_init_buf->trailer.session_req.calling_len = 32;
-
-			/* calling name ends in null (byte 16) from old smb
-			convention. */
-			if (server->workstation_RFC1001_name &&
-			    server->workstation_RFC1001_name[0] != 0)
-				rfc1002mangle(ses_init_buf->trailer.
-						session_req.calling_name,
-					      server->workstation_RFC1001_name,
-					      RFC1001_NAME_LEN_WITH_NULL);
-			else
-				rfc1002mangle(ses_init_buf->trailer.
-						session_req.calling_name,
-					      "LINUX_CIFS_CLNT",
-					      RFC1001_NAME_LEN_WITH_NULL);
-
-			ses_init_buf->trailer.session_req.scope1 = 0;
-			ses_init_buf->trailer.session_req.scope2 = 0;
-			smb_buf = (struct smb_hdr *)ses_init_buf;
-			/* sizeof RFC1002_SESSION_REQUEST with no scope */
-			smb_buf->smb_buf_length = 0x81000044;
-			rc = smb_send(server, smb_buf, 0x44);
-			kfree(ses_init_buf);
-			msleep(1); /* RFC1001 layer in at least one server
-				      requires very short break before negprot
-				      presumably because not expecting negprot
-				      to follow so fast.  This is a simple
-				      solution that works without
-				      complicating the code and causes no
-				      significant slowing down on mount
-				      for everyone else */
-		}
-		/* else the negprot may still work without this
-		even though malloc failed */
-
-	}
+	if (sport == htons(RFC1001_PORT))
+		rc = ip_rfc1001_connect(server);
 
 	return rc;
 }
 
 static int
-ipv6_connect(struct TCP_Server_Info *server)
+ip_connect(struct TCP_Server_Info *server)
 {
-	int rc = 0;
-	int val;
-	bool connected = false;
-	__be16 orig_port = 0;
-	struct socket *socket = server->ssocket;
+	unsigned short int *sport;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
+	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
 
-	if (socket == NULL) {
-		rc = sock_create_kern(PF_INET6, SOCK_STREAM,
-				      IPPROTO_TCP, &socket);
-		if (rc < 0) {
-			cERROR(1, "Error %d creating ipv6 socket", rc);
-			socket = NULL;
-			return rc;
-		}
+	if (server->dstaddr.ss_family == AF_INET6)
+		sport = &addr6->sin6_port;
+	else
+		sport = &addr->sin_port;
 
-		/* BB other socket options to set KEEPALIVE, NODELAY? */
-		cFYI(1, "ipv6 Socket created");
-		server->ssocket = socket;
-		socket->sk->sk_allocation = GFP_NOFS;
-		cifs_reclassify_socket6(socket);
-	}
+	if (*sport == 0) {
+		int rc;
 
-	rc = bind_socket(server);
-	if (rc < 0)
-		return rc;
+		/* try with 445 port at first */
+		*sport = htons(CIFS_PORT);
 
-	/* user overrode default port */
-	if (server->addr.sockAddr6.sin6_port) {
-		rc = socket->ops->connect(socket,
-				(struct sockaddr *) &server->addr.sockAddr6,
-				sizeof(struct sockaddr_in6), 0);
-		if (rc >= 0)
-			connected = true;
-	}
-
-	if (!connected) {
-		/* save original port so we can retry user specified port
-			later if fall back ports fail this time  */
-
-		orig_port = server->addr.sockAddr6.sin6_port;
-		/* do not retry on the same port we just failed on */
-		if (server->addr.sockAddr6.sin6_port != htons(CIFS_PORT)) {
-			server->addr.sockAddr6.sin6_port = htons(CIFS_PORT);
-			rc = socket->ops->connect(socket, (struct sockaddr *)
-					&server->addr.sockAddr6,
-					sizeof(struct sockaddr_in6), 0);
-			if (rc >= 0)
-				connected = true;
-		}
-	}
-	if (!connected) {
-		server->addr.sockAddr6.sin6_port = htons(RFC1001_PORT);
-		rc = socket->ops->connect(socket, (struct sockaddr *)
-				&server->addr.sockAddr6,
-				sizeof(struct sockaddr_in6), 0);
+		rc = generic_ip_connect(server);
 		if (rc >= 0)
-			connected = true;
-	}
-
-	/* give up here - unless we want to retry on different
-		protocol families some day */
-	if (!connected) {
-		if (orig_port)
-			server->addr.sockAddr6.sin6_port = orig_port;
-		cFYI(1, "Error %d connecting to server via ipv6", rc);
-		sock_release(socket);
-		server->ssocket = NULL;
-		return rc;
-	}
-
-	/*
-	 * Eventually check for other socket options to change from
-	 * the default. sock_setsockopt not used because it expects
-	 * user space buffer
-	 */
-	socket->sk->sk_rcvtimeo = 7 * HZ;
-	socket->sk->sk_sndtimeo = 5 * HZ;
+			return rc;
 
-	if (server->tcp_nodelay) {
-		val = 1;
-		rc = kernel_setsockopt(socket, SOL_TCP, TCP_NODELAY,
-				(char *)&val, sizeof(val));
-		if (rc)
-			cFYI(1, "set TCP_NODELAY socket option error %d", rc);
+		/* if it failed, try with 139 port */
+		*sport = htons(RFC1001_PORT);
 	}
 
-	server->ssocket = socket;
-
-	return rc;
+	return generic_ip_connect(server);
 }
 
 void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e0588cd..59ca81b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -119,7 +119,7 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	if (ssocket == NULL)
 		return -ENOTSOCK; /* BB eventually add reconnect code here */
 
-	smb_msg.msg_name = (struct sockaddr *) &server->addr.sockAddr;
+	smb_msg.msg_name = (struct sockaddr *) &server->dstaddr;
 	smb_msg.msg_namelen = sizeof(struct sockaddr);
 	smb_msg.msg_control = NULL;
 	smb_msg.msg_controllen = 0;
-- 
1.7.3.2
