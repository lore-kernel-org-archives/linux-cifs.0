Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEFF3A1A3F
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391904; cv=none; b=EheOmUXGb/VOwoIOpGnW/wIvkr9gqDVctJ4GhPSYDfyThjV5dAJFm8fePoRBISY7m6DJM4pZdgVIjFQUOzQSYp/9CeXooIet+N6SAKX8+lmoNF3Ja8naVLNGF42+K+qDB2m+tv0747ewyTZ9GAImVNXlDWSX4Fw3dpVJpTju2OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391904; c=relaxed/simple;
	bh=biHoc+S3ZNaPblcRytjpFSB2ud4qrURq1hCyLlogTRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCqFXbJB/WOAzkNbt3UoSkPYAbtzSEzfLlDM/kuEg55JRwI8KbXGlwj9hvk3AWSi16OijWjNtAEqLl4XBXYELqZKN0zsBY9Z2UMu5vlX5yyRN14+aYbgCqDbjInpzdEJKnv3d1CN66IcPzGKhGbtIVfeHPkSt0HxYIU4MMbNxCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ODRn7BoK; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ODRn7BoK"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488d2079582so136925905e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391901; x=1777996701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=09ViX6UWiF3HhVw6Pnm4KFSTchtVcjkElgpqnR5pDBM=;
        b=ODRn7BoKHaZOR5ufjPPZRBdMMuQrZ6M0sgH15KwfDfFPYRVRmnCJQUVHLmU9orcHNq
         8AS0K6HZgYKh+9SeK2z2HAY0cCFexVeUkfSyrvb0GC8GyWCZNtSQuBb+xnSH2RVzL14F
         cgzUK5D87SA7/TGOhuB4980wkAGqpBeZOqBiUeyzNb+64r6rqLiyWX5cX9jrbXMB3ci7
         r9OHfMVZBsNC1m5wxWPcKxv2By4MLVfjfkbbeBZuEUBX55DjqU1MGheZ1SuYc7jwfVwc
         EGixHyCtwepgPvq5uQoW9QJiknOzP7DVq4Q4aq0/mWQyNOhCdjjTsL8/8ehICwGXvXgs
         tBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391901; x=1777996701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=09ViX6UWiF3HhVw6Pnm4KFSTchtVcjkElgpqnR5pDBM=;
        b=UqgPo0z8TA93NYCT7gJS/iaK09n728cMrSkfex/qQraskXrh010k1794UYKx7qLBcb
         +Bb8V5xupGtvSX3ca7Wiq+O+ElrqTok67n6pmtJzerVzGGr9kvnKoKalnmRNKphoIDTn
         h+WnAVFNYsS55OAW2fJZGgVu8NtOagEYs55Ro4Rgd7Qbm83hwATpAH51nrH33pul9CDm
         LYjwUhGFcDTHkmykLfWFJKaTq7js1LbQ7wwzkzU9EX4xEvH9KeYOXvBVyTzcRd/bST1x
         nhDvn9cokIkXZyu1Tt4bfFRrQyFuzeVsIjFt+NWxd7xhuc2RuDe09KB+I3DFOkWf5ZaO
         gGHg==
X-Gm-Message-State: AOJu0YwsQBjf8A5lXWq8z+t6VKI9v0km195OkkAczfgUZdzcSjd3hBYc
	ID3cuGnR3AWVFrWufX3PmssodZ1FzvkJQTlfmG+YjM7EeO/fk7EsvFalCS1eAaJezgKt3rufX8W
	/V6nxx4Az0A==
X-Gm-Gg: AeBDieukf+5kfWbsgaUDNwDVWRpGGvQsTpPspVJVfDoByXxqR1ESeIrRVJ3dsEneFJU
	ClBomj9noTYDrQ15ldHcnIITqCu7PWNIqJgA8VFR+xp6CZewHH4K6Io19fikNQAabZY8MO+gv7f
	XlDCnXfxiYaogb2hiopxlD/lDTftCyL0cRYSMJOvp/CiBbF4djTaYRIAuILra2FL6gc+w0CAt0+
	sRT3YM80OrC3NAochOW22vov5eJLhcy4ElWLm8WbmaHi4XZCvRyIdICv7eug4Ff0Nywn6APB8Jn
	wzI7WfQCiCF5h5N/P2xc3OO9GD6hn36QKDhQ96kZecQeyats4JT25vMe+SuKKL4a14K1IWNj8Ll
	BEK+/X79BNIWv5kZbYmZLDpjVPtIGDH4DUD4kJ7slhVoRx84Bj4vNTjSDNwkynj5BbiKpn9ozA5
	z6Viv5Q8T2CGkOQn+y/eoh8RYqm7+TD44VL92I4eS8C+vS
X-Received: by 2002:a05:600c:1f13:b0:48a:7772:c26b with SMTP id 5b1f17b1804b1-48a7b546cf4mr3740485e9.26.1777391900382;
        Tue, 28 Apr 2026 08:58:20 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7b560a84sm3409255e9.4.2026.04.28.08.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:58:19 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	sfrench@samba.org,
	metze@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 08/11] smb: server: add QUIC transport support
Date: Tue, 28 Apr 2026 12:57:57 -0300
Message-ID: <20260428155759.226368-4-henrique.carvalho@suse.com>
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

Add a QUIC listener and connection transport for ksmbd on top of the
shared server transport helpers. This wires in the QUIC transport file,
adds the per-interface QUIC socket/kthread state, and enables QUIC
listener startup and teardown alongside the existing TCP path.

Also add the server-side QUIC port configuration and pass the client
peer address through the existing tree connect management path for QUIC
connections.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/server/Makefile         |   4 +-
 fs/smb/server/connection.c     |   1 +
 fs/smb/server/interface.c      |  30 ++-
 fs/smb/server/interface.h      |   2 +
 fs/smb/server/server.h         |   1 +
 fs/smb/server/smb2pdu.c        |   1 +
 fs/smb/server/transport_ipc.c  |   1 +
 fs/smb/server/transport_quic.c | 327 +++++++++++++++++++++++++++++++++
 fs/smb/server/transport_quic.h |  20 ++
 9 files changed, 380 insertions(+), 7 deletions(-)
 create mode 100644 fs/smb/server/transport_quic.c
 create mode 100644 fs/smb/server/transport_quic.h

diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index 89a9955f607d..569be14b32d4 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -8,8 +8,8 @@ ksmbd-y :=	unicode.o auth.o vfs.o vfs_cache.o server.o ndr.o \
 		misc.o oplock.o connection.o ksmbd_work.o crypto_ctx.o \
 		mgmt/ksmbd_ida.o mgmt/user_config.o mgmt/share_config.o \
 		mgmt/tree_connect.o mgmt/user_session.o smb_common.o \
-		transport.o transport_tcp.o transport_ipc.o interface.o \
-		smbacl.o smb2pdu.o \
+		transport.o transport_tcp.o transport_ipc.o transport_quic.o \
+		interface.o smbacl.o smb2pdu.o \
 		smb2ops.o smb2misc.o ksmbd_spnego_negtokeninit.asn1.o \
 		ksmbd_spnego_negtokentarg.asn1.o asn1.o
 
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 07bbf4eb7b05..1db8e0a8b47d 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -15,6 +15,7 @@
 #include "interface.h"
 #include "transport.h"
 #include "transport_tcp.h"
+#include "transport_quic.h"
 #include "transport_rdma.h"
 #include "misc.h"
 
diff --git a/fs/smb/server/interface.c b/fs/smb/server/interface.c
index a5e59a420639..25b8e7f44059 100644
--- a/fs/smb/server/interface.c
+++ b/fs/smb/server/interface.c
@@ -11,6 +11,7 @@
 #include "auth.h"
 #include "connection.h"
 #include "transport_tcp.h"
+#include "transport_quic.h"
 #include "interface.h"
 
 static LIST_HEAD(iface_list);
@@ -36,12 +37,14 @@ static struct interface *alloc_iface(char *ifname)
 }
 
 /**
- * ksmbd_interface_run_kthread() - start a per-interface forker thread
- * @iface:	pointer to struct interface
- * @kthread_fn:	thread routine to run
- * @suf:	suffix to append to the thread name (e.g. "tcp")
+ * ksmbd_tcp_run_kthread() - start forker thread
+ * @iface: pointer to struct interface
  *
- * Return:	the started task_struct, or ERR_PTR on failure.
+ * start forker thread(ksmbd/0) at module init time to listen
+ * on port 445 for new SMB connection requests. It creates per connection
+ * server threads(ksmbd/x)
+ *
+ * Return:	0 on success or error number
  */
 struct task_struct *ksmbd_interface_run_kthread(struct interface *iface,
 						int (*kthread_fn)(void *), const char *suf)
@@ -87,6 +90,10 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 			ret = ksmbd_tcp_create_socket(iface);
 			if (ret)
 				break;
+
+			ret = ksmbd_quic_create_socket(iface);
+			if (ret)
+				break;
 		}
 		if (!iface && bind_additional_ifaces) {
 			iface = alloc_iface(kstrdup(netdev->name, KSMBD_DEFAULT_GFP));
@@ -101,6 +108,10 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 			ret = ksmbd_tcp_create_socket(iface);
 			if (ret)
 				break;
+
+			ret = ksmbd_quic_create_socket(iface);
+			if (ret)
+				break;
 		}
 		break;
 	case NETDEV_DOWN:
@@ -111,15 +122,23 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 
 			if (iface->ksmbd_tcp_socket)
 				kernel_sock_shutdown(iface->ksmbd_tcp_socket, SHUT_RDWR);
+			if (iface->ksmbd_quic_socket)
+				kernel_sock_shutdown(iface->ksmbd_quic_socket, SHUT_RDWR);
 
 			if (iface->ksmbd_tcp_kthread)
 				ksmbd_interface_stop_kthread(iface->ksmbd_tcp_kthread);
+			if (iface->ksmbd_quic_kthread)
+				ksmbd_interface_stop_kthread(iface->ksmbd_quic_kthread);
 
 			if (iface->ksmbd_tcp_socket)
 				sock_release(iface->ksmbd_tcp_socket);
+			if (iface->ksmbd_quic_socket)
+				sock_release(iface->ksmbd_quic_socket);
 
 			iface->ksmbd_tcp_kthread = NULL;
+			iface->ksmbd_quic_kthread = NULL;
 			iface->ksmbd_tcp_socket = NULL;
+			iface->ksmbd_quic_socket = NULL;
 
 			put_net(iface->net);
 			iface->net = NULL;
@@ -194,3 +213,4 @@ int ksmbd_set_interfaces(char *ifc_list, int ifc_list_sz)
 
 	return 0;
 }
+
diff --git a/fs/smb/server/interface.h b/fs/smb/server/interface.h
index 7e35645076a9..94ffb73fd635 100644
--- a/fs/smb/server/interface.h
+++ b/fs/smb/server/interface.h
@@ -16,6 +16,8 @@
 struct interface {
 	struct task_struct	*ksmbd_tcp_kthread;
 	struct socket		*ksmbd_tcp_socket;
+	struct task_struct	*ksmbd_quic_kthread;
+	struct socket		*ksmbd_quic_socket;
 	struct list_head	entry;
 	char			*name;
 	int			state;
diff --git a/fs/smb/server/server.h b/fs/smb/server/server.h
index b8a7317be86b..197d99264071 100644
--- a/fs/smb/server/server.h
+++ b/fs/smb/server/server.h
@@ -35,6 +35,7 @@ struct ksmbd_server_config {
 	short			min_protocol;
 	short			max_protocol;
 	unsigned short		tcp_port;
+	unsigned short		quic_port;
 	unsigned short		ipc_timeout;
 	unsigned long		ipc_last_active;
 	unsigned long		deadtime;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1f579ef0e9d6..6f82f6bd378a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -31,6 +31,7 @@
 
 #include "server.h"
 #include "smb_common.h"
+#include "interface.h"
 #include "../common/smb2status.h"
 #include "ksmbd_work.h"
 #include "mgmt/user_config.h"
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 6ccfb1cf8ed7..d14f282f3337 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -315,6 +315,7 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 	server_conf.flags = req->flags;
 	server_conf.signing = req->signing;
 	server_conf.tcp_port = req->tcp_port;
+	server_conf.quic_port = 443; /* MS-SMB2 1.9 */
 	server_conf.ipc_timeout = req->ipc_timeout * HZ;
 	if (check_mul_overflow(req->deadtime, SMB_ECHO_INTERVAL,
 					&server_conf.deadtime)) {
diff --git a/fs/smb/server/transport_quic.c b/fs/smb/server/transport_quic.c
new file mode 100644
index 000000000000..84067225c1d3
--- /dev/null
+++ b/fs/smb/server/transport_quic.c
@@ -0,0 +1,327 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2026, SUSE LLC
+ *
+ *   Author: Henrique Carvalho <henrique.carvalho@suse.com>
+ */
+
+#include <linux/freezer.h>
+#include <linux/socket.h>
+#include <linux/quic.h>
+#include <linux/key.h>
+#include <net/handshake.h>
+#include <keys/asymmetric-type.h>
+
+#include "smb_common.h"
+#include "server.h"
+#include "auth.h"
+#include "connection.h"
+#include "transport.h"
+#include "glob.h"
+#include "transport_quic.h"
+#include "interface.h"
+
+struct quic_transport {
+	struct ksmbd_transport		transport;
+	struct socket			*sock;
+};
+
+static const struct ksmbd_transport_ops ksmbd_quic_transport_ops;
+
+#define QUIC_TRANS(t)	((struct quic_transport *)container_of(t, struct quic_transport, transport))
+
+static inline void ksmbd_quic_reuseaddr(struct socket *sock)
+{
+	sock_set_reuseaddr(sock->sk);
+}
+
+static void ksmbd_quic_disconnect(struct ksmbd_transport *kt)
+{
+	struct quic_transport *t = QUIC_TRANS(kt);
+
+	kernel_sock_shutdown(t->sock, SHUT_RDWR);
+	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
+	if (server_conf.max_connections)
+		atomic_dec(&active_num_conn);
+}
+
+static void ksmbd_quic_close_client_sk(struct socket *client_sk)
+{
+	if (client_sk->file)
+		fput(client_sk->file);
+	else
+		sock_release(client_sk);
+}
+
+static struct quic_transport *ksmbd_quic_alloc(void)
+{
+	struct quic_transport *t;
+
+	t = kzalloc_obj(*t, KSMBD_DEFAULT_GFP);
+	if (!t)
+		return NULL;
+
+	KSMBD_TRANS(t)->ops = &ksmbd_quic_transport_ops;
+	return t;
+}
+
+static void ksmbd_quic_free(struct ksmbd_transport *kt)
+{
+	struct quic_transport *t = QUIC_TRANS(kt);
+
+	ksmbd_quic_close_client_sk(t->sock);
+	kfree(kt->io.iov); /* TODO (transport.c): move to ksmbd_conn_free */
+	kfree(t);
+}
+
+/**
+ * ksmbd_quic_new_connection() - create a new quic session on mount
+ * @client_sk:	socket associated with new connection
+ *
+ * whenever a new connection is requested, create a conn thread
+ * (session thread) to handle new incoming smb requests from the connection
+ *
+ * Return:	0 on success, otherwise error
+ */
+static int ksmbd_quic_new_connection(struct socket *client_sk)
+{
+	int rc;
+	struct quic_transport *t;
+
+	t = ksmbd_quic_alloc();
+	if (!t) {
+		ksmbd_quic_close_client_sk(client_sk);
+		return -ENOMEM;
+	}
+
+	t->sock = client_sk;
+
+	rc = ksmbd_transport_alloc_conn(KSMBD_TRANS(t), client_sk);
+	if (rc) {
+		if (KSMBD_TRANS(t)->conn) {
+			/*
+			 * conn was allocated and hashed but the handler
+			 * thread failed; tear down via the conn refcount
+			 * path which also calls ->free_transport().
+			 */
+			ksmbd_quic_disconnect(KSMBD_TRANS(t));
+		} else {
+			ksmbd_quic_close_client_sk(client_sk);
+			kfree(t);
+		}
+	}
+
+	return rc;
+}
+
+static void ksmbd_tls_done(void *data, int status, key_serial_t peerid)
+{
+	struct smb_tls *kstls = (struct smb_tls *)data;
+
+	kstls->status = status;
+	kstls->peerid = peerid;
+
+	complete(&kstls->handshake_done);
+}
+
+static struct smb_tls *ksmbd_tls_init(void)
+{
+	struct smb_tls *kstls;
+	const unsigned int timeout_ms = 5000;
+
+	kstls = kzalloc_obj(*kstls, KSMBD_DEFAULT_GFP);
+	if (!kstls)
+		return ERR_PTR(-ENOMEM);
+
+	kstls->status = 0;
+
+	kstls->args.ta_done = ksmbd_tls_done;
+	kstls->args.ta_data = kstls;
+	kstls->args.ta_timeout_ms = timeout_ms;
+
+	init_completion(&kstls->handshake_done);
+
+	return kstls;
+}
+
+static void ksmbd_tls_reinit(struct smb_tls *kstls, struct socket *client_sk)
+{
+	kstls->status = 0;
+	kstls->peerid = TLS_NO_PEERID;
+	kstls->args.ta_sock = client_sk;
+	reinit_completion(&kstls->handshake_done);
+}
+
+static void ksmbd_tls_free(struct smb_tls **kstls)
+{
+	kfree_sensitive(*kstls);
+	*kstls = NULL;
+}
+
+/**
+ * ksmbd_quic_kthread_fn() - listen to new SMB QUIC connections and callback server
+ * @p:		arguments to forker thread
+ *
+ * Return:	0 on success, error number otherwise
+ */
+static int ksmbd_quic_kthread_fn(void *p)
+{
+	struct socket *client_sk = NULL;
+	struct interface *iface = (struct interface *)p;
+	struct smb_tls *ksmbd_tls;
+	int ret;
+
+	ksmbd_tls = ksmbd_tls_init();
+	if (IS_ERR(ksmbd_tls))
+		return PTR_ERR(ksmbd_tls);
+
+	while (!kthread_should_stop()) {
+		struct file *filp;
+
+		if (!iface->ksmbd_quic_socket)
+			break;
+
+		ret = kernel_accept(iface->ksmbd_quic_socket, &client_sk, 0);
+		if (ret == -EINVAL)
+			break;
+		if (ret)
+			continue;
+
+		ret = quic_do_setsockopt(client_sk->sk,
+					 QUIC_SOCKOPT_ALPN,
+					 KERNEL_SOCKPTR("smb"),
+					 3);
+		if (ret < 0) {
+			ksmbd_debug(CONN, "Failed to set QUIC_SOCKOPT_ALPN: %d\n", ret);
+			ksmbd_quic_close_client_sk(client_sk);
+			continue;
+		}
+
+		filp = sock_alloc_file(client_sk, 0, NULL);
+		if (IS_ERR(filp)) {
+			ksmbd_debug(CONN, "Socket file allocation failed: %ld", PTR_ERR(filp));
+			ksmbd_quic_close_client_sk(client_sk);
+			continue;
+		}
+
+		ksmbd_tls_reinit(ksmbd_tls, client_sk);
+
+		ret = tls_server_hello_x509(&ksmbd_tls->args, KSMBD_DEFAULT_GFP);
+		if (ret < 0) {
+			ksmbd_debug(CONN, "Handshake failed: %d", ret);
+			ksmbd_quic_close_client_sk(client_sk);
+			continue;
+		}
+
+		ret = wait_for_completion_interruptible(&ksmbd_tls->handshake_done);
+		if (ret < 0) {
+			tls_handshake_cancel(client_sk->sk);
+			ksmbd_quic_close_client_sk(client_sk);
+			ksmbd_debug(CONN, "Handshake failed: %d", ret);
+			continue;
+		}
+		if (ksmbd_tls->status) {
+			ksmbd_quic_close_client_sk(client_sk);
+			ksmbd_debug(CONN, "Handshake failed: %d", ksmbd_tls->status);
+			continue;
+		}
+		ksmbd_debug(CONN, "Handshake successful");
+
+		if (ksmbd_check_max_ip_conns(client_sk)) {
+			ksmbd_quic_close_client_sk(client_sk);
+			continue;
+		}
+
+		if (ksmbd_check_max_conns()) {
+			ksmbd_quic_close_client_sk(client_sk);
+			continue;
+		}
+
+		ksmbd_debug(CONN, "connect success: accepted new connection\n");
+		client_sk->sk->sk_rcvtimeo = KSMBD_QUIC_RECV_TIMEOUT;
+		client_sk->sk->sk_sndtimeo = KSMBD_QUIC_SEND_TIMEOUT;
+
+		ksmbd_quic_new_connection(client_sk);
+	}
+
+	ksmbd_tls_free(&ksmbd_tls);
+
+	ksmbd_debug(CONN, "releasing socket\n");
+	return 0;
+}
+
+/**
+ * ksmbd_quic_read() - read data from socket in given buffer
+ * @t:		transport instance
+ * @buf:	buffer to store read data from socket
+ * @to_read:	number of bytes to read from socket
+ * @max_retries: number of retries if reading from socket fails
+ *
+ * Return:	on success return number of bytes read from socket,
+ *		otherwise return error number
+ */
+static int ksmbd_quic_readv(struct ksmbd_transport *t, char *buf,
+			   unsigned int to_read, int max_retries)
+{
+	struct kvec iov;
+
+	iov.iov_base = buf;
+	iov.iov_len = to_read;
+
+	return ksmbd_readv(t, QUIC_TRANS(t)->sock, &iov, 1, to_read, max_retries);
+}
+
+static int ksmbd_quic_writev(struct ksmbd_transport *t, struct kvec *iov,
+			    int nvecs, int size, bool need_invalidate,
+			    unsigned int remote_key)
+
+{
+	int err = -EOPNOTSUPP;
+#if IS_ENABLED(CONFIG_IP_QUIC)
+	struct msghdr ksmbd_msg = {.msg_flags = MSG_NOSIGNAL};
+
+	err = kernel_sendmsg(QUIC_TRANS(t)->sock, &ksmbd_msg, iov, nvecs, size);
+#endif
+	return err;
+}
+
+void ksmbd_quic_destroy_socket(struct socket *ksmbd_socket)
+{
+	ksmbd_destroy_socket(ksmbd_socket);
+}
+
+int ksmbd_quic_create_socket(struct interface *iface)
+{
+#if IS_ENABLED(CONFIG_IP_QUIC)
+	struct task_struct *kthread;
+	struct socket *ksmbd_socket;
+	int ret;
+
+	ksmbd_socket = ksmbd_create_socket(iface, SOCK_DGRAM, IPPROTO_QUIC,
+					   server_conf.quic_port);
+	if (IS_ERR(ksmbd_socket))
+		return PTR_ERR(ksmbd_socket);
+
+	ksmbd_quic_reuseaddr(ksmbd_socket);
+
+	kthread = ksmbd_interface_run_kthread(iface, ksmbd_quic_kthread_fn, "quic");
+	if (IS_ERR(kthread)) {
+		ret = PTR_ERR(kthread);
+		pr_err("Can't start ksmbd main kthread for quic: %d\n", ret);
+		ksmbd_destroy_socket(ksmbd_socket);
+		return ret;
+	}
+
+	iface->ksmbd_quic_socket  = ksmbd_socket;
+	iface->ksmbd_quic_kthread = kthread;
+	iface->state = IFACE_STATE_CONFIGURED;
+#endif /* CONFIG_IP_QUIC */
+	return 0;
+}
+
+static const struct ksmbd_transport_ops ksmbd_quic_transport_ops = {
+	.read		= ksmbd_quic_readv,
+	.writev		= ksmbd_quic_writev,
+	.disconnect	= ksmbd_quic_disconnect,
+	.free_transport = ksmbd_quic_free,
+};
diff --git a/fs/smb/server/transport_quic.h b/fs/smb/server/transport_quic.h
new file mode 100644
index 000000000000..5c62c45affc4
--- /dev/null
+++ b/fs/smb/server/transport_quic.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (C) 2026, SUSE LLC.
+ */
+
+#ifndef __KSMBD_TRANSPORT_QUIC_H__
+#define __KSMBD_TRANSPORT_QUIC_H__
+
+#include "interface.h"
+
+#define KSMBD_QUIC_RECV_TIMEOUT	(7 * HZ)
+#define KSMBD_QUIC_SEND_TIMEOUT	(5 * HZ)
+
+int ksmbd_quic_init(void);
+void ksmbd_quic_destroy(void);
+int ksmbd_quic_create_socket(struct interface *iface);
+void ksmbd_quic_destroy_socket(struct socket *ksmbd_socket);
+void ksmbd_quic_stop_kthread(struct task_struct *kthread);
+
+#endif /* __KSMBD_TRANSPORT_QUIC_H__ */
-- 
2.53.0

