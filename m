Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F17544BCB1
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391895; cv=none; b=HwcfxW//2HkH9uRsH66w+b/vJQZEoOePQEzJbtZ8gl6tHbfDShJtYmgs8pjqyJPsdZ06RORWB70MqcgvaJIOIPPMS9kWW3FZZBojZV77VvkZKMpqtpsKkdLCIdsXW1yV9dc9jDvAMygSEaKROUsyT/aEq3f1Pw6BSP6ELcrCAtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391895; c=relaxed/simple;
	bh=7Xc8Ab+80baGi5ee41MeMddy361+Xx0bS8BLEz1DutE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KE1n7eQtp0SX4VTR3p7qGNgvQR8HYvI2lTi2KqmQHBBoqirFl9G4rq3x+zZ5oYLO75qmt2G1S2KQK6ng6v3bUykoV9BvnW6gN987XF08cy886MjEdQcS05ss7j3pG8xfWYqqk/lyOuF/63i3Hu/YQx3ZNU3v/YpsvN+lxW9+TLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dUsZV+LE; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dUsZV+LE"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso107664425e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391891; x=1777996691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QuByOnTmHBNyAlDIgKmsfjc9HoNP34BF7+9rPQpnoCI=;
        b=dUsZV+LEkmeuMds6onPNXFaXwnUVszuh03IW2yR9pVZMUG10sdeQ4ry+Cenw34a/Zs
         CxinjayNlP22j8g/bheiDfXFNQexFmWYa5bGHlKoHzgmnt6iGOPiENJrfHv4DD4qn5OB
         RSsT4UY/GuMWsLIOeO4tfttyR1jVovBCvLfKrVrRdFTBo1TR/tfiCBDIa2YR7hCHlOUI
         D20Hc7rW4m27aRTj2JWtJjTdfijn4K/ZeMq7/FL9JRA1kZ9weGwkGAGmQJ2Q7vU9d+ds
         vsoEK26+7/XSClIHG0Yq+hTMiSnacIoYQ4P/xTLPlMK1YpcpexrDyyouYYg5z9OAaQLT
         hRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391891; x=1777996691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QuByOnTmHBNyAlDIgKmsfjc9HoNP34BF7+9rPQpnoCI=;
        b=rrNeL490Bt7XYFBsRIrPqt+7V1jWgwXxt9BPvYKFU5Xb/mjl4fpqX5pBQVaNGN2YGB
         zBJuu4KKZZ/eLezTc8CaY2oRVgCFiU5PqImTlgZmSgPcqxKNRckijT28NgrGHE/Walk0
         sLh9Eh4Srr/ilGxGowRdizpgedrlgiiebq5HOwpthMhokvkfxMK4RHnRxVDyoVwofvcs
         DtK3ekMWXR1cke/VS3RMVzWpCAG8O0FyWZ3fsqQORSCNoaaY6/6gp1EVufSni1EM4W1t
         cnC3kjQM5l9K+e/FmnUqxLODA7B5ridMDAmKSg2MQCi5jpEvGmzdKt0TkohY0NG0/Vnk
         /R7g==
X-Gm-Message-State: AOJu0YyLlcndybqIszkAqAJyLnRs7iptKRF5aYvKQaEqKsUjgpPky8K1
	7317UYG/3WpMw+h1wDwkpVOzh3NQZb5pYG2Y327hxd5UpWf48vHsoS2uvlYx/4PV/NBbDZSzVwL
	mKm9F0FaNPw==
X-Gm-Gg: AeBDieuzVYgcniI21KtXHnjTljappSQFs1SIr2mW2TF+t49Bjs394lom6hcFP5ADIcy
	NpEsWzQ63PDwWdagazg/0vmamv4ftx275UPtTbphOg5QoVfyi3Q6Mje+Z6B+aexXpt3cJKw8Azi
	v8CtOlFFAAQ4/THyXdWDfx6MBlhDhrZSXUBOJ5M+AflFk7YdGR1zO4MoS+kKTAcTt+GBw55agpr
	b/68pcJHcfUr24p8f6i9fmdtf4ki2EBdudzKeNdw9mQgvSZEK4fRgwNmDEgAV21BpccEymLrTam
	Hi74TXp9kcULAOIqx5PMqufy09jfSEMoIv98MJLvEWbtA2cxbYwhfpPVcy1R4trS5zHOWLQRLFj
	5fS4Q+6O2HnWbuNdFZAfZ++UFM4nEig3d7h2urBBYX5fbz2jAAgdts/ma1UIWWl8M/qrPhORPc2
	oTAPFcQ9zDt3o63NFk5W7lOFz6r1yPdA1E+W7cZX1LO7EF
X-Received: by 2002:a05:600c:3541:b0:489:a4:e578 with SMTP id 5b1f17b1804b1-48a77b19c77mr59557575e9.14.1777391891330;
        Tue, 28 Apr 2026 08:58:11 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7b560a84sm3409255e9.4.2026.04.28.08.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:58:10 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	sfrench@samba.org,
	metze@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 07/11] smb: server: reuse common transport helpers in TCP transport
Date: Tue, 28 Apr 2026 12:57:56 -0300
Message-ID: <20260428155759.226368-3-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428155759.226368-1-henrique.carvalho@suse.com>
References: <20260428155759.226368-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new transport core already provides shared helpers for listener
creation, accepted-connection setup, receive-side iovec handling, and
connection-limit checks. Keep the TCP transport focused on TCP-specific
socket options and send/disconnect behavior by switching it over to the
common helpers.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/server/transport_tcp.c | 312 +++-------------------------------
 1 file changed, 19 insertions(+), 293 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 07123ebcf8fd..1496f0336af6 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -17,8 +17,6 @@
 struct tcp_transport {
 	struct ksmbd_transport		transport;
 	struct socket			*sock;
-	struct kvec			*iov;
-	unsigned int			nr_iov;
 };
 
 static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops;
@@ -39,50 +37,11 @@ static inline void ksmbd_tcp_reuseaddr(struct socket *sock)
 	sock_set_reuseaddr(sock->sk);
 }
 
-static struct tcp_transport *alloc_transport(struct socket *client_sk)
-{
-	struct tcp_transport *t;
-	struct ksmbd_conn *conn;
-
-	t = kzalloc_obj(*t, KSMBD_DEFAULT_GFP);
-	if (!t)
-		return NULL;
-	t->sock = client_sk;
-
-	conn = ksmbd_conn_alloc();
-	if (!conn) {
-		kfree(t);
-		return NULL;
-	}
-
-#if IS_ENABLED(CONFIG_IPV6)
-	if (client_sk->sk->sk_family == AF_INET6) {
-		memcpy(&conn->inet6_addr, &client_sk->sk->sk_v6_daddr, 16);
-		conn->inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
-	} else {
-		conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
-		conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
-	}
-#else
-	conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
-	conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
-#endif
-	down_write(&conn_list_lock);
-	hash_add(conn_list, &conn->hlist, conn->inet_hash);
-	up_write(&conn_list_lock);
-
-	conn->transport = KSMBD_TRANS(t);
-	KSMBD_TRANS(t)->conn = conn;
-	KSMBD_TRANS(t)->ops = &ksmbd_tcp_transport_ops;
-	return t;
-}
-
 static void ksmbd_tcp_free_transport(struct ksmbd_transport *kt)
 {
 	struct tcp_transport *t = TCP_TRANS(kt);
 
 	sock_release(t->sock);
-	kfree(t->iov);
 	kfree(t);
 }
 
@@ -92,62 +51,6 @@ static void free_transport(struct tcp_transport *t)
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
 }
 
-/**
- * kvec_array_init() - initialize a IO vector segment
- * @new:	IO vector to be initialized
- * @iov:	base IO vector
- * @nr_segs:	number of segments in base iov
- * @bytes:	total iovec length so far for read
- *
- * Return:	Number of IO segments
- */
-static unsigned int kvec_array_init(struct kvec *new, struct kvec *iov,
-				    unsigned int nr_segs, size_t bytes)
-{
-	size_t base = 0;
-
-	while (bytes || !iov->iov_len) {
-		int copy = min(bytes, iov->iov_len);
-
-		bytes -= copy;
-		base += copy;
-		if (iov->iov_len == base) {
-			iov++;
-			nr_segs--;
-			base = 0;
-		}
-	}
-
-	memcpy(new, iov, sizeof(*iov) * nr_segs);
-	new->iov_base += base;
-	new->iov_len -= base;
-	return nr_segs;
-}
-
-/**
- * get_conn_iovec() - get connection iovec for reading from socket
- * @t:		TCP transport instance
- * @nr_segs:	number of segments in iov
- *
- * Return:	return existing or newly allocate iovec
- */
-static struct kvec *get_conn_iovec(struct tcp_transport *t, unsigned int nr_segs)
-{
-	struct kvec *new_iov;
-
-	if (t->iov && nr_segs <= t->nr_iov)
-		return t->iov;
-
-	/* not big enough -- allocate a new one and release the old */
-	new_iov = kmalloc_objs(*new_iov, nr_segs, KSMBD_DEFAULT_GFP);
-	if (new_iov) {
-		kfree(t->iov);
-		t->iov = new_iov;
-		t->nr_iov = nr_segs;
-	}
-	return new_iov;
-}
-
 /**
  * ksmbd_tcp_new_connection() - create a new tcp session on mount
  * @client_sk:	socket associated with new connection
@@ -161,33 +64,19 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
 {
 	int rc = 0;
 	struct tcp_transport *t;
-	struct task_struct *handler;
 
-	t = alloc_transport(client_sk);
+	t = kzalloc_obj(*t, KSMBD_DEFAULT_GFP);
 	if (!t) {
 		sock_release(client_sk);
 		return -ENOMEM;
 	}
+	t->sock = client_sk;
+	KSMBD_TRANS(t)->ops = &ksmbd_tcp_transport_ops;
 
-#if IS_ENABLED(CONFIG_IPV6)
-	if (client_sk->sk->sk_family == AF_INET6)
-		handler = kthread_run(ksmbd_conn_handler_loop,
-				KSMBD_TRANS(t)->conn, "ksmbd:%pI6c",
-				&KSMBD_TRANS(t)->conn->inet6_addr);
-	else
-		handler = kthread_run(ksmbd_conn_handler_loop,
-				KSMBD_TRANS(t)->conn, "ksmbd:%pI4",
-				&KSMBD_TRANS(t)->conn->inet_addr);
-#else
-	handler = kthread_run(ksmbd_conn_handler_loop,
-			KSMBD_TRANS(t)->conn, "ksmbd:%pI4",
-			&KSMBD_TRANS(t)->conn->inet_addr);
-#endif
-	if (IS_ERR(handler)) {
-		pr_err("cannot start conn thread\n");
-		rc = PTR_ERR(handler);
+	rc = ksmbd_transport_alloc_conn(KSMBD_TRANS(t), client_sk);
+	if (rc)
 		ksmbd_tcp_disconnect(KSMBD_TRANS(t));
-	}
+
 	return rc;
 }
 
@@ -201,9 +90,7 @@ static int tcp_kthread_fn(void *p)
 {
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
-	struct ksmbd_conn *conn;
-	int ret, inet_hash;
-	unsigned int max_ip_conns;
+	int ret;
 
 	while (!kthread_should_stop()) {
 		if (!iface->ksmbd_tcp_socket)
@@ -214,57 +101,14 @@ static int tcp_kthread_fn(void *p)
 		if (ret)
 			continue;
 
-		if (!server_conf.max_ip_connections)
-			goto skip_max_ip_conns_limit;
-
-		/*
-		 * Limits repeated connections from clients with the same IP.
-		 */
-#if IS_ENABLED(CONFIG_IPV6)
-		if (client_sk->sk->sk_family == AF_INET6)
-			inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
-		else
-			inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
-#else
-		inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
-#endif
-
-		max_ip_conns = 0;
-		down_read(&conn_list_lock);
-		hash_for_each_possible(conn_list, conn, hlist, inet_hash) {
-#if IS_ENABLED(CONFIG_IPV6)
-			if (client_sk->sk->sk_family == AF_INET6) {
-				if (memcmp(&client_sk->sk->sk_v6_daddr,
-					   &conn->inet6_addr, 16) == 0)
-					max_ip_conns++;
-			} else if (inet_sk(client_sk->sk)->inet_daddr ==
-				 conn->inet_addr)
-				max_ip_conns++;
-#else
-			if (inet_sk(client_sk->sk)->inet_daddr ==
-			    conn->inet_addr)
-				max_ip_conns++;
-#endif
-			if (server_conf.max_ip_connections <= max_ip_conns) {
-				pr_info_ratelimited("Maximum IP connections exceeded (%u/%u)\n",
-						    max_ip_conns, server_conf.max_ip_connections);
-				ret = -EAGAIN;
-				break;
-			}
-		}
-		up_read(&conn_list_lock);
+		ret = ksmbd_check_max_ip_conns(client_sk);
 		if (ret == -EAGAIN) {
-			/* Per-IP limit hit: release the just-accepted socket. */
 			sock_release(client_sk);
 			continue;
 		}
 
-skip_max_ip_conns_limit:
-		if (server_conf.max_connections &&
-		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
-			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",
-					    atomic_read(&active_num_conn));
-			atomic_dec(&active_num_conn);
+		ret = ksmbd_check_max_conns();
+		if (ret == -EAGAIN) {
 			sock_release(client_sk);
 			continue;
 		}
@@ -280,76 +124,6 @@ static int tcp_kthread_fn(void *p)
 	return 0;
 }
 
-/**
- * ksmbd_tcp_readv() - read data from socket in given iovec
- * @t:			TCP transport instance
- * @iov_orig:		base IO vector
- * @nr_segs:		number of segments in base iov
- * @to_read:		number of bytes to read from socket
- * @max_retries:	maximum retry count
- *
- * Return:	on success return number of bytes read from socket,
- *		otherwise return error number
- */
-static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
-			   unsigned int nr_segs, unsigned int to_read,
-			   int max_retries)
-{
-	int length = 0;
-	int total_read;
-	unsigned int segs;
-	struct msghdr ksmbd_msg;
-	struct kvec *iov;
-	struct ksmbd_conn *conn = KSMBD_TRANS(t)->conn;
-
-	iov = get_conn_iovec(t, nr_segs);
-	if (!iov)
-		return -ENOMEM;
-
-	ksmbd_msg.msg_control = NULL;
-	ksmbd_msg.msg_controllen = 0;
-
-	for (total_read = 0; to_read; total_read += length, to_read -= length) {
-		try_to_freeze();
-
-		if (!ksmbd_conn_alive(conn)) {
-			total_read = -ESHUTDOWN;
-			break;
-		}
-		segs = kvec_array_init(iov, iov_orig, nr_segs, total_read);
-
-		length = kernel_recvmsg(t->sock, &ksmbd_msg,
-					iov, segs, to_read, 0);
-
-		if (length == -EINTR) {
-			total_read = -ESHUTDOWN;
-			break;
-		} else if (ksmbd_conn_need_reconnect(conn)) {
-			total_read = -EAGAIN;
-			break;
-		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
-			/*
-			 * If max_retries is negative, Allow unlimited
-			 * retries to keep connection with inactive sessions.
-			 */
-			if (max_retries == 0) {
-				total_read = length;
-				break;
-			} else if (max_retries > 0) {
-				max_retries--;
-			}
-
-			usleep_range(1000, 2000);
-			length = 0;
-			continue;
-		} else if (length <= 0) {
-			total_read = length;
-			break;
-		}
-	}
-	return total_read;
-}
-
 /**
  * ksmbd_tcp_read() - read data from socket in given buffer
  * @t:		TCP transport instance
@@ -368,7 +142,8 @@ static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf,
 	iov.iov_base = buf;
 	iov.iov_len = to_read;
 
-	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read, max_retries);
+	return ksmbd_readv(t, TCP_TRANS(t)->sock, &iov, 1, to_read,
+			   max_retries);
 }
 
 static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *iov,
@@ -409,69 +184,20 @@ void ksmbd_tcp_destroy_socket(struct socket *ksmbd_socket)
  */
 int ksmbd_tcp_create_socket(struct interface *iface)
 {
-	int ret;
-	struct sockaddr_in6 sin6;
-	struct sockaddr_in sin;
 	struct socket *ksmbd_socket;
 	struct task_struct *kthread;
-	bool ipv4 = false;
-
-	ret = sock_create_kern(iface->net, PF_INET6, SOCK_STREAM,
-			       IPPROTO_TCP, &ksmbd_socket);
-	if (ret) {
-		if (ret != -EAFNOSUPPORT)
-			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
-		ret = sock_create_kern(iface->net, PF_INET, SOCK_STREAM,
-				       IPPROTO_TCP, &ksmbd_socket);
-		if (ret) {
-			pr_err("Can't create socket for ipv4: %d\n", ret);
-			goto out_clear;
-		}
+	int ret;
 
-		sin.sin_family = PF_INET;
-		sin.sin_addr.s_addr = htonl(INADDR_ANY);
-		sin.sin_port = htons(server_conf.tcp_port);
-		ipv4 = true;
-	} else {
-		sin6.sin6_family = PF_INET6;
-		sin6.sin6_addr = in6addr_any;
-		sin6.sin6_port = htons(server_conf.tcp_port);
-
-		lock_sock(ksmbd_socket->sk);
-		ksmbd_socket->sk->sk_ipv6only = false;
-		release_sock(ksmbd_socket->sk);
+	ksmbd_socket = ksmbd_create_socket(iface, SOCK_STREAM, IPPROTO_TCP,
+					   server_conf.tcp_port);
+	if (IS_ERR(ksmbd_socket)) {
+		ret = PTR_ERR(ksmbd_socket);
+		goto out_clear;
 	}
 
 	ksmbd_tcp_nodelay(ksmbd_socket);
 	ksmbd_tcp_reuseaddr(ksmbd_socket);
 
-	ret = sock_setsockopt(ksmbd_socket,
-			      SOL_SOCKET,
-			      SO_BINDTODEVICE,
-			      KERNEL_SOCKPTR(iface->name),
-			      strlen(iface->name));
-	if (ret != -ENODEV && ret < 0) {
-		pr_err("Failed to set SO_BINDTODEVICE: %d\n", ret);
-		goto out_error;
-	}
-
-	if (ipv4)
-		ret = kernel_bind(ksmbd_socket, (struct sockaddr_unsized *)&sin,
-				  sizeof(sin));
-	else
-		ret = kernel_bind(ksmbd_socket, (struct sockaddr_unsized *)&sin6,
-				  sizeof(sin6));
-	if (ret) {
-		pr_err("Failed to bind socket: %d\n", ret);
-		goto out_error;
-	}
-
-	ret = kernel_listen(ksmbd_socket, KSMBD_SOCKET_BACKLOG);
-	if (ret) {
-		pr_err("Port listen() error: %d\n", ret);
-		goto out_error;
-	}
-
 	iface->ksmbd_tcp_socket = ksmbd_socket;
 
 	kthread = ksmbd_interface_run_kthread(iface, tcp_kthread_fn, "tcp");
@@ -487,7 +213,7 @@ int ksmbd_tcp_create_socket(struct interface *iface)
 	return 0;
 
 out_error:
-	ksmbd_tcp_destroy_socket(ksmbd_socket);
+	ksmbd_destroy_socket(ksmbd_socket);
 out_clear:
 	iface->ksmbd_tcp_socket = NULL;
 	iface->ksmbd_tcp_kthread = NULL;
-- 
2.53.0

