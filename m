Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B9C44B695
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391891; cv=none; b=lxao9h3YKgRv/PlIzc73l9Nz+HSP5l5XH0AcxZqSNj1LpMNWTVcxPndiMfAr3yevPeofn7cC72FVQALR8McJ9UoVp7/RNdW44CO/eWGsCO6REx3UBHaBNgLvOViS0fHwXPdeTMgiR5i1kOn95iKDIb4bWHkSeqSoY2rqsYd4l/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391891; c=relaxed/simple;
	bh=jAOuX9dpwzMx7Akp2cQbJrd5q2Lz2mSKiMfiFBm7Qz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYzHvf8wU+1z2fgIJuG/HYYo+ubjoRW8zRawVqOcI/TcSiBDpfqB5pl7Qw7ePrJPoE5ev5CDTtYP/8kNJ8GvjUEL7VmGktkCzfijEqvQoj0/xiuux2nZ4sVurFuPb9fr2WEGo057MeOYlwebUZBAqovDwXzvw1M+b2iYTWSNLzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DZy0Az63; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DZy0Az63"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so153206485e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391888; x=1777996688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eXSup0OYn4CuueYI1U5YMs8zAmzWfq3Ux8UxQSH2V6w=;
        b=DZy0Az63YBvMTVFHjEyW7KJQXUIa1pN7naJPthDzeRXZCOdNuIzlbLNm7/Oi435qKr
         C1INBZJD06v/eOa/jjMqPdDpW1MhIxRnnlRTWqHnx63qoTiNETw3MXUmwMWo+nxyfESG
         l3Uegi2KVeu+GqLQw8em/i/AHjhYxUHdiBIveLtj1rhgNleBrsniDRebSXMIijU8b+Fm
         yNtcKZs/zJuoUrvDp87MVFpv3VCESqIqV4Dv5rR0v1sZty+Lgfv8coEKxd2fKzrNPWNZ
         iqdc6BbVdViBtVcfkZUGMSIlCQAzLJX6mrdyZu72XSkRpwBHXdRqr+MY08kAQ7M13i+J
         Iryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391888; x=1777996688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eXSup0OYn4CuueYI1U5YMs8zAmzWfq3Ux8UxQSH2V6w=;
        b=BHMGkoCkUL8w/AK4TTBTpAMI9Xgfhf+r/VlJR+tCRAMUKPP+rXhDPcoR4PcIqGec6P
         u1jbQMAN6LdfiDWUtO3st7IlZxjZh3C/M1mnlUyBAcM/xbK79lIeBY0YK0w7HwymjqWG
         0L5cO58kGMbF2q3955apEGnyJwMr/nPhJjpoJDjsHPdA2jkXSoUZ74fIltJyOCWyMpE3
         pC3pM4e3NdGaYIoKcejePIwRj40qZROlXk7NIyKUO8l5TVZFAbOHbKD3viKlGWyTJdNL
         PnbbZG+vrCqdba5b1vtpmondleAUThlh966x8uSkldOa2/7pIOdYvUJVXhXdiqpjn9Go
         TpZQ==
X-Gm-Message-State: AOJu0Yx6ShklNVPavUQba3yCuTC/foc/HeKZPAfPq85nUWQlS9J+clPc
	egOWpqAsj7zQYfKWo3bYUPyjBRVykzl4nT4TRRbzzNzUct/zZdoMPi8aIRQrYXp+pOUtW2YLqdc
	8xwuJokjW2w==
X-Gm-Gg: AeBDievrpHG7p3iCHjmCtww9JdC+7bXeMlFFyMlGpn5+lVj9omnNNt4DPUpg7w2Ut8x
	Z8SPdNd3gmBFBuR1y6JOaLRVcoQKeWSgJ1u7FJI6z0Lrul+iTNCEqDLGX8/P3Taj2k90HHnmn0t
	4zUBNGcWdRRNtpnww94m/F9lS1y0RZSNYu7CZFxZVQ/kVBdT+ygOE0UfwV17qC9HaLRxncGEjcL
	06p7tzfXnlrZZe0qIxTfPJg3BOnhV8fut7Bso1+MZc24x1tG97F7ivCl+RSIqI2Tlz5cU2td44w
	7lM3AEMe3KR/moPZn39aIWlyEWVeSCqDK8pc3VIHXRzD8YaRxalJTTNPMl3UPtY8khoyYreOv9J
	VlidKAMP5P0utXLgzBgDlUdPsjEiKIHs/jmru2nopn1ioq0/BbEjl6ixOQqEEY1fGiXTJBtW9vp
	ahfXoiNukKXQvS8D56hRUWrg8nKa1l6ZGE/vO8Zs2brYi9
X-Received: by 2002:a05:600c:1c1b:b0:483:2c98:4368 with SMTP id 5b1f17b1804b1-48a77b0a516mr57355225e9.18.1777391887837;
        Tue, 28 Apr 2026 08:58:07 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7b560a84sm3409255e9.4.2026.04.28.08.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:58:07 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	sfrench@samba.org,
	metze@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 06/11] smb: server: add shared transport helpers in preparation for QUIC
Date: Tue, 28 Apr 2026 12:57:55 -0300
Message-ID: <20260428155759.226368-2-henrique.carvalho@suse.com>
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

Move the generic transport functions out of the TCP transport code into
a shared transport layer. This keeps the common socket setup and checks,
accepted-connection initialization, and receive helpers in one place
instead of open-coding them in the individual transport implementation.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/server/Makefile        |   3 +-
 fs/smb/server/connection.c    |   1 +
 fs/smb/server/connection.h    |   5 -
 fs/smb/server/transport.c     | 344 ++++++++++++++++++++++++++++++++++
 fs/smb/server/transport.h     |  40 ++++
 fs/smb/server/transport_tcp.c |   1 +
 6 files changed, 388 insertions(+), 6 deletions(-)
 create mode 100644 fs/smb/server/transport.c
 create mode 100644 fs/smb/server/transport.h

diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index 7bd6501bfdc9..89a9955f607d 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -8,7 +8,8 @@ ksmbd-y :=	unicode.o auth.o vfs.o vfs_cache.o server.o ndr.o \
 		misc.o oplock.o connection.o ksmbd_work.o crypto_ctx.o \
 		mgmt/ksmbd_ida.o mgmt/user_config.o mgmt/share_config.o \
 		mgmt/tree_connect.o mgmt/user_session.o smb_common.o \
-		interface.o transport_tcp.o transport_ipc.o smbacl.o smb2pdu.o \
+		transport.o transport_tcp.o transport_ipc.o interface.o \
+		smbacl.o smb2pdu.o \
 		smb2ops.o smb2misc.o ksmbd_spnego_negtokeninit.asn1.o \
 		ksmbd_spnego_negtokentarg.asn1.o asn1.o
 
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 7465b364c35c..07bbf4eb7b05 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -13,6 +13,7 @@
 #include "mgmt/ksmbd_ida.h"
 #include "connection.h"
 #include "interface.h"
+#include "transport.h"
 #include "transport_tcp.h"
 #include "transport_rdma.h"
 #include "misc.h"
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index b060baf5f688..0e87283a9ddb 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -145,11 +145,6 @@ struct ksmbd_transport_ops {
 	void (*free_transport)(struct ksmbd_transport *kt);
 };
 
-struct ksmbd_transport {
-	struct ksmbd_conn			*conn;
-	const struct ksmbd_transport_ops	*ops;
-};
-
 #define KSMBD_TCP_RECV_TIMEOUT	(7 * HZ)
 #define KSMBD_TCP_SEND_TIMEOUT	(5 * HZ)
 #define KSMBD_TCP_PEER_SOCKADDR(c)	((struct sockaddr *)&((c)->peer_addr))
diff --git a/fs/smb/server/transport.c b/fs/smb/server/transport.c
new file mode 100644
index 000000000000..0a99fb821e02
--- /dev/null
+++ b/fs/smb/server/transport.c
@@ -0,0 +1,344 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/freezer.h>
+
+#include "server.h"
+#include "glob.h"
+#include "connection.h"
+#include "interface.h"
+#include "transport.h"
+
+/*
+ * ksmbd_transport_iovec - get iovec for reading from socket
+ * @t:		ksmbd transport struct
+ * @nr_segs:	number of iov segments needed for reading
+ *
+ * Return:	return existing or newly allocate iovec
+ */
+struct kvec *ksmbd_transport_iovec(struct ksmbd_transport *t,
+				   unsigned int nr_segs)
+{
+	struct kvec *new_iov;
+
+	if (t->io.iov && nr_segs <= t->io.nr_iov)
+		return t->io.iov;
+
+	/* not big enough -- allocate a new one and release the old */
+	new_iov = kmalloc_array(nr_segs, sizeof(*new_iov), KSMBD_DEFAULT_GFP);
+	if (new_iov) {
+		kfree(t->io.iov);
+		t->io.iov = new_iov;
+		t->io.nr_iov = nr_segs;
+	}
+	return new_iov;
+}
+
+int ksmbd_transport_alloc_conn(struct ksmbd_transport *t,
+			       struct socket *client_sk)
+{
+	struct task_struct *handler;
+	struct ksmbd_conn *conn;
+
+	conn = ksmbd_conn_alloc();
+	if (!conn)
+		return -ENOMEM;
+
+	conn->transport = t;
+	t->conn = conn;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (client_sk->sk->sk_family == AF_INET6) {
+		memcpy(&conn->inet6_addr, &client_sk->sk->sk_v6_daddr, 16);
+		conn->inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
+	} else {
+		conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
+		conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
+	}
+#else
+	conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
+	conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
+#endif
+	down_write(&conn_list_lock);
+	hash_add(conn_list, &conn->hlist, conn->inet_hash);
+	up_write(&conn_list_lock);
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (client_sk->sk->sk_family == AF_INET6)
+		handler = kthread_run(ksmbd_conn_handler_loop,
+				      conn, "ksmbd:%pI6c",
+				      &conn->inet6_addr);
+	else
+		handler = kthread_run(ksmbd_conn_handler_loop,
+				      conn, "ksmbd:%pI4",
+				      &conn->inet_addr);
+#else
+	handler = kthread_run(ksmbd_conn_handler_loop,
+			      conn, "ksmbd:%pI4",
+			      &conn->inet_addr);
+#endif
+	if (IS_ERR(handler)) {
+		pr_err("cannot start conn thread\n");
+		return PTR_ERR(handler);
+	}
+
+	return 0;
+}
+
+/**
+ * kvec_array_init() - initialize a IO vector segment
+ * @new:	IO vector to be initialized
+ * @iov:	base IO vector
+ * @nr_segs:	number of segments in base iov
+ * @bytes:	total iovec length so far for read
+ *
+ * Return:	Number of IO segments
+ */
+static unsigned int kvec_array_init(struct kvec *new, struct kvec *iov,
+				    unsigned int nr_segs, size_t bytes)
+{
+	size_t base = 0;
+
+	while (bytes || !iov->iov_len) {
+		int copy = min(bytes, iov->iov_len);
+
+		bytes -= copy;
+		base += copy;
+		if (iov->iov_len == base) {
+			iov++;
+			nr_segs--;
+			base = 0;
+		}
+	}
+
+	memcpy(new, iov, sizeof(*iov) * nr_segs);
+	new->iov_base += base;
+	new->iov_len -= base;
+	return nr_segs;
+}
+
+/**
+ * ksmbd_readv() - read data from socket in given iovec
+ * @t:			ksmbd transport instance
+ * @sock:		socket to read from
+ * @iov_orig:		base IO vector
+ * @nr_segs:		number of segments in base iov
+ * @to_read:		number of bytes to read from socket
+ * @max_retries:	maximum retry count
+ *
+ * Return:	on success return number of bytes read from socket,
+ *		otherwise return error number
+ */
+int ksmbd_readv(struct ksmbd_transport *t, struct socket *sock,
+		struct kvec *iov_orig, unsigned int nr_segs,
+		unsigned int to_read, int max_retries)
+{
+	int length = 0;
+	int total_read;
+	unsigned int segs;
+	struct msghdr ksmbd_msg;
+	struct kvec *iov;
+	struct ksmbd_conn *conn = t->conn;
+
+	iov = ksmbd_transport_iovec(t, nr_segs);
+	if (!iov)
+		return -ENOMEM;
+
+	ksmbd_msg.msg_control = NULL;
+	ksmbd_msg.msg_controllen = 0;
+
+	for (total_read = 0; to_read; total_read += length, to_read -= length) {
+		try_to_freeze();
+
+		if (!ksmbd_conn_alive(conn)) {
+			total_read = -ESHUTDOWN;
+			break;
+		}
+		segs = kvec_array_init(iov, iov_orig, nr_segs, total_read);
+
+		length = kernel_recvmsg(sock, &ksmbd_msg,
+					iov, segs, to_read, 0);
+
+		if (length == -EINTR) {
+			total_read = -ESHUTDOWN;
+			break;
+		} else if (ksmbd_conn_need_reconnect(conn)) {
+			total_read = -EAGAIN;
+			break;
+		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
+			/*
+			 * If max_retries is negative, Allow unlimited
+			 * retries to keep connection with inactive sessions.
+			 */
+			if (max_retries == 0) {
+				total_read = length;
+				break;
+			} else if (max_retries > 0) {
+				max_retries--;
+			}
+
+			usleep_range(1000, 2000);
+			length = 0;
+			continue;
+		} else if (length <= 0) {
+			total_read = length;
+			break;
+		}
+	}
+	return total_read;
+}
+
+struct socket *ksmbd_create_socket(struct interface *iface, int sock_type,
+				   int ipproto, int port)
+{
+	int ret;
+	struct sockaddr_in6 sin6;
+	struct sockaddr_in sin;
+	struct socket *ksmbd_socket;
+	bool ipv4 = false;
+
+	ret = sock_create_kern(iface->net, PF_INET6, sock_type,
+			       ipproto, &ksmbd_socket);
+	if (ret) {
+		if (ret != -EAFNOSUPPORT)
+			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
+		ret = sock_create_kern(iface->net, PF_INET, sock_type,
+				       ipproto, &ksmbd_socket);
+		if (ret) {
+			pr_err("Can't create socket for ipv4: %d\n", ret);
+			return ERR_PTR(ret);
+		}
+
+		sin.sin_family = PF_INET;
+		sin.sin_addr.s_addr = htonl(INADDR_ANY);
+		sin.sin_port = htons(port);
+		ipv4 = true;
+	} else {
+		sin6.sin6_family = PF_INET6;
+		sin6.sin6_addr = in6addr_any;
+		sin6.sin6_port = htons(port);
+
+		lock_sock(ksmbd_socket->sk);
+		ksmbd_socket->sk->sk_ipv6only = false;
+		release_sock(ksmbd_socket->sk);
+	}
+
+	ret = sock_setsockopt(ksmbd_socket,
+			      SOL_SOCKET,
+			      SO_BINDTODEVICE,
+			      KERNEL_SOCKPTR(iface->name),
+			      strlen(iface->name));
+	if (ret != -ENODEV && ret < 0) {
+		pr_err("Failed to set SO_BINDTODEVICE: %d\n", ret);
+		goto out_error;
+	}
+
+	if (ipv4)
+		ret = kernel_bind(ksmbd_socket, (struct sockaddr_unsized *)&sin,
+				  sizeof(sin));
+	else
+		ret = kernel_bind(ksmbd_socket, (struct sockaddr_unsized *)&sin6,
+				  sizeof(sin6));
+	if (ret) {
+		pr_err("Failed to bind socket: %d\n", ret);
+		goto out_error;
+	}
+
+	ret = kernel_listen(ksmbd_socket, KSMBD_SOCKET_BACKLOG);
+	if (ret) {
+		pr_err("Port listen() error: %d\n", ret);
+		goto out_error;
+	}
+
+	return ksmbd_socket;
+
+out_error:
+	ksmbd_destroy_socket(ksmbd_socket);
+	return ERR_PTR(ret);
+}
+
+void ksmbd_destroy_socket(struct socket *ksmbd_socket)
+{
+	int ret;
+
+	if (!ksmbd_socket)
+		return;
+
+	ret = kernel_sock_shutdown(ksmbd_socket, SHUT_RDWR);
+	if (ret)
+		pr_err("Failed to shutdown socket: %d\n", ret);
+	sock_release(ksmbd_socket);
+}
+
+/**
+ * ksmbd_check_max_ip_conns() - reject when per-IP connection cap reached
+ * @client_sk:	freshly accepted client socket
+ *
+ * Return:	0 if a new connection from this peer is allowed, -EAGAIN
+ *		when server_conf.max_ip_connections has been reached.
+ */
+int ksmbd_check_max_ip_conns(struct socket *client_sk)
+{
+	struct ksmbd_conn *conn;
+	unsigned int max_ip_conns = 0;
+	int inet_hash;
+	int ret = 0;
+
+	if (!server_conf.max_ip_connections)
+		return 0;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (client_sk->sk->sk_family == AF_INET6)
+		inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
+	else
+		inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
+#else
+	inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
+#endif
+
+	down_read(&conn_list_lock);
+	hash_for_each_possible(conn_list, conn, hlist, inet_hash) {
+#if IS_ENABLED(CONFIG_IPV6)
+		if (client_sk->sk->sk_family == AF_INET6) {
+			if (memcmp(&client_sk->sk->sk_v6_daddr,
+				   &conn->inet6_addr, 16) == 0)
+				max_ip_conns++;
+		} else if (inet_sk(client_sk->sk)->inet_daddr ==
+			   conn->inet_addr)
+			max_ip_conns++;
+#else
+		if (inet_sk(client_sk->sk)->inet_daddr == conn->inet_addr)
+			max_ip_conns++;
+#endif
+		if (server_conf.max_ip_connections <= max_ip_conns) {
+			pr_info_ratelimited("Maximum IP connections exceeded (%u/%u)\n",
+					    max_ip_conns,
+					    server_conf.max_ip_connections);
+			ret = -EAGAIN;
+			break;
+		}
+	}
+	up_read(&conn_list_lock);
+	return ret;
+}
+
+/**
+ * ksmbd_check_max_conns() - reserve a slot under the global connection cap
+ *
+ * On success the global counter is incremented; the caller is responsible for
+ * decrementing it on disconnect.
+ *
+ * Return:	0 if allowed, -EAGAIN if server_conf.max_connections reached.
+ */
+int ksmbd_check_max_conns(void)
+{
+	if (!server_conf.max_connections)
+		return 0;
+
+	if (atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
+		pr_info_ratelimited("Limit the maximum number of connections(%u)\n",
+				    atomic_read(&active_num_conn));
+		atomic_dec(&active_num_conn);
+		return -EAGAIN;
+	}
+	return 0;
+}
diff --git a/fs/smb/server/transport.h b/fs/smb/server/transport.h
new file mode 100644
index 000000000000..6b2fb4f9005c
--- /dev/null
+++ b/fs/smb/server/transport.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (C) 2026, SUSE LLC
+ *
+ *   Author: Henrique Carvalho <henrique.carvalho@suse.com>
+ */
+
+#ifndef __KSMBD_TRANSPORT_H__
+#define __KSMBD_TRANSPORT_H__
+
+#include <net/sock.h>
+
+#include "connection.h"
+#include "interface.h"
+
+struct ksmbd_transport {
+	struct ksmbd_conn			*conn;
+	const struct ksmbd_transport_ops	*ops;
+	struct {
+		struct kvec			*iov;
+		unsigned int			nr_iov;
+	} io;
+};
+
+#define KSMBD_TRANS(t)	(&(t)->transport)
+
+struct kvec *ksmbd_transport_iovec(struct ksmbd_transport *t,
+				   unsigned int nr_segs);
+int ksmbd_transport_alloc_conn(struct ksmbd_transport *t,
+			       struct socket *client_sk);
+int ksmbd_readv(struct ksmbd_transport *t, struct socket *sock,
+		struct kvec *iov_orig, unsigned int nr_segs,
+		unsigned int to_read, int max_retries);
+struct socket *ksmbd_create_socket(struct interface *iface, int sock_type,
+				   int ipproto, int port);
+void ksmbd_destroy_socket(struct socket *ksmbd_socket);
+int ksmbd_check_max_ip_conns(struct socket *client_sk);
+int ksmbd_check_max_conns(void);
+
+#endif /* __KSMBD_TRANSPORT_H__ */
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 37f4238f72f5..07123ebcf8fd 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -10,6 +10,7 @@
 #include "server.h"
 #include "auth.h"
 #include "connection.h"
+#include "transport.h"
 #include "transport_tcp.h"
 #include "interface.h"
 
-- 
2.53.0

