Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E2A3C945A
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391890; cv=none; b=GRquKXBkA+Qp2sdE0Qz6n5Nlww2imjD6KFz6TNHY7HDDrlGMqCZk2RzzozU3Hb3XqcVbJytvf7BL0z6GE/GGxzP1eAUTYFIO9fNmCooEVR/TdDMT8apKvguqC5/WfnOW9KstBhmZz6cqRVqor7AR2qA0E4BTBMVErXHbBkarzrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391890; c=relaxed/simple;
	bh=mc8duuf18vGiKek7T/0raBsUgBqkfZdV+R5o90VA56k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VNg2vVkMKgx36bNSE/M6F5VkmDAgfLeujbqxzmIQxLdIe8Li8Guq4A47OcM+9ZDOEIb4kvPPlWTJqcBNQ8uO4gLmmdpR1rENP72RiQhHAHYPrZod7gE3KKUq73Yea0vsrgImZDembijZrfi//URSk59Ze39oppUFMpHeCT3pglI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PyC0KR36; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PyC0KR36"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso122444195e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391886; x=1777996686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XEWRVYzyIgG3Bi1Pa1Vh5S1rEgoz2yBSa2G8ehlgCSM=;
        b=PyC0KR36lb83Z988LHxI+6DqVlkw3aBJpHEpv3DHkwtJ2ybrxtQthtqkg9GvNDskoC
         Ehd6veECdnm5tEti0WKZytw8D81jFBUGRggpJbyStwUwPcFMQMFuLiaIZeEjJIJFO0RZ
         EhRQIB5q3YqBqOPctmO6sk3og1bu5MwFMuXn8INZT4sdTh0iWfmVLBY8jt6AHIFrnkdo
         uh+EsgKnZFn/FmfDEnm46afjbSC98PfcBRYvHbAUOHXsIVvxxC90K0qkbEjBHcGZtubg
         WDcITBLOOjOAq0jgvtJmgBopcLDQpVdlrRwvVh+qmKUsK0sTucxMEhb4IHjFjyMAEGPO
         Otpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391886; x=1777996686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XEWRVYzyIgG3Bi1Pa1Vh5S1rEgoz2yBSa2G8ehlgCSM=;
        b=mvozUZvsuNikejZJKD/WPOCFDWPKC9xDEg3ckmrAYm1Xe3MuemE5LvjZIzELjYGowZ
         5aY6pJNCWMRowrc8h1CBgH8Izkl2GLH0L3JGFKvbI+7Eb/weXJ6Jki36iHC7Fvt1z856
         e06zK4pO6eyF+UskqszD+3z8HGCB+QQwqh9FrUevuRpBADNC8QMmqOOQdKrTUvKU40+x
         nXse4/Bp3bn4gdDGA4ZufzVwWm0V3b8RQISd5l7T/5ehdydjh0eohtpoWaHlMd4cJ9B5
         eD3vDJTGMy+maxocMwbNl9AcYOCpDefEm3XK44mBShyaNXwSHqte2wB1X9tdRfhniZO9
         V3AA==
X-Gm-Message-State: AOJu0Yy9JOmtsREVdOgzrlvafTEVsjVnhRWE9DJB8eF3UlXP+Ep72YAU
	erpngFt/xezBDO2VlA7cM7eFiEvvae6EZyuA1EyuIvInk+dCTV7Cp9KbVfXr1dY/TleYKCDxvkh
	QvQJcszP3fg==
X-Gm-Gg: AeBDiet86DOo6FgM0WrmoqkjXno6o4vkEIKfY81pDlPqzi+sJa9nlfJ/XdJMIPyGTt2
	sJtaJ+EJhGAvb64+gDVcjtl8DM1V53woqbEqtChgIBp9GyFoP7kU5CA0OGsBdIH8X+Dq7YsJv08
	KB1LrO5F23xPi6HEY+HVRTirv1S+2pDMLadxasPiSAwtfU8KzmTcOtqFt4GM5ago7C01OXrQ1O4
	3xxeRLK0M59oi06sN8m1Nc/5SrLE+jc+BUSkdZ7XHbBaTOcdv5lwgyvDcU46eq7nVG7FpHAWMsI
	WJvqfu+7VnexhrzM13lGaCVQLHcg7uLSLok4EyIMLsEj78G7y1mgMnpHNFWHXPkXRQsWaPUdZuG
	Z65IWBqlmgW/yLrtUD7dwH45LCN+pvG10+O3uyASUwFy6CWpiyBcpu6XMdbQh1dxQfZUdcsUXXb
	IGnXhYi7JUoW/YXBMhZeOLW3XdsFimJgP1mJKknMugs+LR
X-Received: by 2002:a05:600c:4f92:b0:489:1ff1:74df with SMTP id 5b1f17b1804b1-48a77ae5430mr57089135e9.1.1777391885753;
        Tue, 28 Apr 2026 08:58:05 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7b560a84sm3409255e9.4.2026.04.28.08.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:58:05 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	sfrench@samba.org,
	metze@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 05/11] smb: server: split interface management from TCP in preparation for QUIC
Date: Tue, 28 Apr 2026 12:57:54 -0300
Message-ID: <20260428155759.226368-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move active_num_conn out of transport_tcp.c and define it in
connection.c.

Move the transport-agnostic bits out into a new interface.c /
interface.h, network-interface bookkeeping, the iface_list, the
netdevice notifier, alloc/find/set helpers, and the per-iface forker
kthread plumbing.

Make the necessary changes to transport_tcp.c, without functional change
for the TCP path; this is purely a layering rearrangement to make room
for additional transports.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/server/Makefile        |   2 +-
 fs/smb/server/connection.c    |   9 +-
 fs/smb/server/connection.h    |   1 +
 fs/smb/server/interface.c     | 196 ++++++++++++++++++++++++++++++
 fs/smb/server/interface.h     |  34 ++++++
 fs/smb/server/transport_ipc.c |   2 +-
 fs/smb/server/transport_tcp.c | 223 ++++------------------------------
 fs/smb/server/transport_tcp.h |   7 +-
 8 files changed, 265 insertions(+), 209 deletions(-)
 create mode 100644 fs/smb/server/interface.c
 create mode 100644 fs/smb/server/interface.h

diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index 6407ba6b9340..7bd6501bfdc9 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -8,7 +8,7 @@ ksmbd-y :=	unicode.o auth.o vfs.o vfs_cache.o server.o ndr.o \
 		misc.o oplock.o connection.o ksmbd_work.o crypto_ctx.o \
 		mgmt/ksmbd_ida.o mgmt/user_config.o mgmt/share_config.o \
 		mgmt/tree_connect.o mgmt/user_session.o smb_common.o \
-		transport_tcp.o transport_ipc.o smbacl.o smb2pdu.o \
+		interface.o transport_tcp.o transport_ipc.o smbacl.o smb2pdu.o \
 		smb2ops.o smb2misc.o ksmbd_spnego_negtokeninit.asn1.o \
 		ksmbd_spnego_negtokentarg.asn1.o asn1.o
 
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 31392d245c30..7465b364c35c 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -12,6 +12,7 @@
 #include "smb_common.h"
 #include "mgmt/ksmbd_ida.h"
 #include "connection.h"
+#include "interface.h"
 #include "transport_tcp.h"
 #include "transport_rdma.h"
 #include "misc.h"
@@ -79,6 +80,8 @@ static int create_proc_clients(void) { return 0; }
 static void delete_proc_clients(void) {}
 #endif
 
+atomic_t active_num_conn = ATOMIC_INIT(0);
+
 /**
  * ksmbd_conn_free() - free resources of the connection instance
  *
@@ -512,9 +515,9 @@ int ksmbd_conn_transport_init(void)
 	int ret;
 
 	mutex_lock(&init_lock);
-	ret = ksmbd_tcp_init();
+	ret = ksmbd_interface_init();
 	if (ret) {
-		pr_err("Failed to init TCP subsystem: %d\n", ret);
+		pr_err("Failed to init interface: %d\n", ret);
 		goto out;
 	}
 
@@ -558,7 +561,7 @@ void ksmbd_conn_transport_destroy(void)
 {
 	delete_proc_clients();
 	mutex_lock(&init_lock);
-	ksmbd_tcp_destroy();
+	ksmbd_interface_destroy();
 	ksmbd_rdma_stop_listening();
 	stop_sessions();
 	mutex_unlock(&init_lock);
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index ae21a1bd4c70..b060baf5f688 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -157,6 +157,7 @@ struct ksmbd_transport {
 #define CONN_HASH_BITS	12
 extern DECLARE_HASHTABLE(conn_list, CONN_HASH_BITS);
 extern struct rw_semaphore conn_list_lock;
+extern atomic_t active_num_conn;
 
 bool ksmbd_conn_alive(struct ksmbd_conn *conn);
 void ksmbd_conn_wait_idle(struct ksmbd_conn *conn);
diff --git a/fs/smb/server/interface.c b/fs/smb/server/interface.c
new file mode 100644
index 000000000000..a5e59a420639
--- /dev/null
+++ b/fs/smb/server/interface.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2016 Namjae Jeon <linkinjeon@kernel.org>
+ *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
+ */
+
+#include <linux/freezer.h>
+
+#include "smb_common.h"
+#include "server.h"
+#include "auth.h"
+#include "connection.h"
+#include "transport_tcp.h"
+#include "interface.h"
+
+static LIST_HEAD(iface_list);
+static int bind_additional_ifaces;
+
+static struct interface *alloc_iface(char *ifname)
+{
+	struct interface *iface;
+
+	if (!ifname)
+		return NULL;
+
+	iface = kzalloc_obj(struct interface, KSMBD_DEFAULT_GFP);
+	if (!iface) {
+		kfree(ifname);
+		return NULL;
+	}
+
+	iface->name = ifname;
+	iface->state = IFACE_STATE_DOWN;
+	list_add(&iface->entry, &iface_list);
+	return iface;
+}
+
+/**
+ * ksmbd_interface_run_kthread() - start a per-interface forker thread
+ * @iface:	pointer to struct interface
+ * @kthread_fn:	thread routine to run
+ * @suf:	suffix to append to the thread name (e.g. "tcp")
+ *
+ * Return:	the started task_struct, or ERR_PTR on failure.
+ */
+struct task_struct *ksmbd_interface_run_kthread(struct interface *iface,
+						int (*kthread_fn)(void *), const char *suf)
+{
+	struct task_struct *kthread;
+
+	kthread = kthread_run(kthread_fn, (void *)iface, "ksmbd-%s-%s", iface->name, suf);
+	return kthread;
+}
+
+void ksmbd_interface_stop_kthread(struct task_struct *kthread)
+{
+	int ret;
+
+	if (!kthread)
+		return;
+
+	ret = kthread_stop(kthread);
+	if (ret)
+		pr_err("failed to stop forker thread\n");
+}
+
+static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
+			      void *ptr)
+{
+	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+	struct interface *iface;
+	int ret;
+
+	switch (event) {
+	case NETDEV_UP:
+		if (netif_is_bridge_port(netdev))
+			return NOTIFY_OK;
+
+		iface = ksmbd_find_netdev_name_iface_list(netdev->name);
+		if (iface && iface->state == IFACE_STATE_DOWN) {
+			ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
+					iface->name);
+
+			if (!iface->net)
+				iface->net = get_net(dev_net(netdev));
+
+			ret = ksmbd_tcp_create_socket(iface);
+			if (ret)
+				break;
+		}
+		if (!iface && bind_additional_ifaces) {
+			iface = alloc_iface(kstrdup(netdev->name, KSMBD_DEFAULT_GFP));
+			if (!iface)
+				return NOTIFY_OK;
+
+			ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
+				    iface->name);
+
+			iface->net = get_net(dev_net(netdev));
+
+			ret = ksmbd_tcp_create_socket(iface);
+			if (ret)
+				break;
+		}
+		break;
+	case NETDEV_DOWN:
+		iface = ksmbd_find_netdev_name_iface_list(netdev->name);
+		if (iface && iface->state == IFACE_STATE_CONFIGURED) {
+			ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
+					iface->name);
+
+			if (iface->ksmbd_tcp_socket)
+				kernel_sock_shutdown(iface->ksmbd_tcp_socket, SHUT_RDWR);
+
+			if (iface->ksmbd_tcp_kthread)
+				ksmbd_interface_stop_kthread(iface->ksmbd_tcp_kthread);
+
+			if (iface->ksmbd_tcp_socket)
+				sock_release(iface->ksmbd_tcp_socket);
+
+			iface->ksmbd_tcp_kthread = NULL;
+			iface->ksmbd_tcp_socket = NULL;
+
+			put_net(iface->net);
+			iface->net = NULL;
+
+			iface->state = IFACE_STATE_DOWN;
+			break;
+		}
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block ksmbd_netdev_notifier = {
+	.notifier_call = ksmbd_netdev_event,
+};
+
+int ksmbd_interface_init(void)
+{
+	register_netdevice_notifier(&ksmbd_netdev_notifier);
+
+	return 0;
+}
+
+
+void ksmbd_interface_destroy(void)
+{
+	struct interface *iface, *tmp;
+
+	unregister_netdevice_notifier(&ksmbd_netdev_notifier);
+
+	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
+		list_del(&iface->entry);
+		kfree(iface->name);
+		kfree(iface);
+	}
+}
+
+struct interface *
+ksmbd_find_netdev_name_iface_list(char *netdev_name)
+{
+	struct interface *iface;
+
+	list_for_each_entry(iface, &iface_list, entry)
+		if (!strcmp(iface->name, netdev_name))
+			return iface;
+	return NULL;
+}
+
+int ksmbd_set_interfaces(char *ifc_list, int ifc_list_sz)
+{
+	int sz = 0;
+
+	if (!ifc_list_sz) {
+		bind_additional_ifaces = 1;
+		return 0;
+	}
+
+	while (ifc_list_sz > 0) {
+		if (!alloc_iface(kstrdup(ifc_list, KSMBD_DEFAULT_GFP)))
+			return -ENOMEM;
+
+		sz = strlen(ifc_list);
+		if (!sz)
+			break;
+
+		ifc_list += sz + 1;
+		ifc_list_sz -= (sz + 1);
+	}
+
+	bind_additional_ifaces = 0;
+
+	return 0;
+}
diff --git a/fs/smb/server/interface.h b/fs/smb/server/interface.h
new file mode 100644
index 000000000000..7e35645076a9
--- /dev/null
+++ b/fs/smb/server/interface.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *   Copyright (C) 2016 Namjae Jeon <linkinjeon@kernel.org>
+ *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
+ *
+ */
+
+#ifndef __KSMBD_INTERFACE_H__
+#define __KSMBD_INTERFACE_H__
+
+#include <linux/freezer.h>
+
+#define IFACE_STATE_DOWN		BIT(0)
+#define IFACE_STATE_CONFIGURED		BIT(1)
+
+struct interface {
+	struct task_struct	*ksmbd_tcp_kthread;
+	struct socket		*ksmbd_tcp_socket;
+	struct list_head	entry;
+	char			*name;
+	int			state;
+	struct net		*net;
+};
+
+int ksmbd_interface_init(void);
+void ksmbd_interface_destroy(void);
+int ksmbd_set_interfaces(char *ifc_list, int ifc_list_sz);
+struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name);
+struct task_struct *ksmbd_interface_run_kthread(struct interface *iface,
+						int (*kthread_fn)(void *),
+						const char *suf);
+void ksmbd_interface_stop_kthread(struct task_struct *kthread);
+
+#endif /* _KSMBD_INTERFACE_H */
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 2dbabe2d8005..6ccfb1cf8ed7 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -348,7 +348,7 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 	ret |= ksmbd_set_server_string(req->server_string);
 	ret |= ksmbd_set_work_group(req->work_group);
 	server_conf.bind_interfaces_only = req->bind_interfaces_only;
-	ret |= ksmbd_tcp_set_interfaces(KSMBD_STARTUP_CONFIG_INTERFACES(req),
+	ret |= ksmbd_set_interfaces(KSMBD_STARTUP_CONFIG_INTERFACES(req),
 					req->ifc_list_sz);
 out:
 	if (ret) {
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 7e29b06820e2..37f4238f72f5 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -11,23 +11,7 @@
 #include "auth.h"
 #include "connection.h"
 #include "transport_tcp.h"
-
-#define IFACE_STATE_DOWN		BIT(0)
-#define IFACE_STATE_CONFIGURED		BIT(1)
-
-static atomic_t active_num_conn;
-
-struct interface {
-	struct task_struct	*ksmbd_kthread;
-	struct socket		*ksmbd_socket;
-	struct list_head	entry;
-	char			*name;
-	int			state;
-};
-
-static LIST_HEAD(iface_list);
-
-static int bind_additional_ifaces;
+#include "interface.h"
 
 struct tcp_transport {
 	struct ksmbd_transport		transport;
@@ -38,8 +22,6 @@ struct tcp_transport {
 
 static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops;
 
-static void tcp_stop_kthread(struct task_struct *kthread);
-static struct interface *alloc_iface(char *ifname);
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t);
 
 #define KSMBD_TRANS(t)	(&(t)->transport)
@@ -214,7 +196,7 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
  *
  * Return:	0 on success, error number otherwise
  */
-static int ksmbd_kthread_fn(void *p)
+static int tcp_kthread_fn(void *p)
 {
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
@@ -223,10 +205,9 @@ static int ksmbd_kthread_fn(void *p)
 	unsigned int max_ip_conns;
 
 	while (!kthread_should_stop()) {
-		if (!iface->ksmbd_socket) {
+		if (!iface->ksmbd_tcp_socket)
 			break;
-		}
-		ret = kernel_accept(iface->ksmbd_socket, &client_sk, 0);
+		ret = kernel_accept(iface->ksmbd_tcp_socket, &client_sk, 0);
 		if (ret == -EINVAL)
 			break;
 		if (ret)
@@ -298,32 +279,6 @@ static int ksmbd_kthread_fn(void *p)
 	return 0;
 }
 
-/**
- * ksmbd_tcp_run_kthread() - start forker thread
- * @iface: pointer to struct interface
- *
- * start forker thread(ksmbd/0) at module init time to listen
- * on port 445 for new SMB connection requests. It creates per connection
- * server threads(ksmbd/x)
- *
- * Return:	0 on success or error number
- */
-static int ksmbd_tcp_run_kthread(struct interface *iface)
-{
-	int rc;
-	struct task_struct *kthread;
-
-	kthread = kthread_run(ksmbd_kthread_fn, (void *)iface, "ksmbd-%s",
-			      iface->name);
-	if (IS_ERR(kthread)) {
-		rc = PTR_ERR(kthread);
-		return rc;
-	}
-	iface->ksmbd_kthread = kthread;
-
-	return 0;
-}
-
 /**
  * ksmbd_tcp_readv() - read data from socket in given iovec
  * @t:			TCP transport instance
@@ -432,7 +387,7 @@ static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
 		atomic_dec(&active_num_conn);
 }
 
-static void tcp_destroy_socket(struct socket *ksmbd_socket)
+void ksmbd_tcp_destroy_socket(struct socket *ksmbd_socket)
 {
 	int ret;
 
@@ -451,21 +406,22 @@ static void tcp_destroy_socket(struct socket *ksmbd_socket)
  *
  * Return:	0 on success, error number otherwise
  */
-static int create_socket(struct interface *iface)
+int ksmbd_tcp_create_socket(struct interface *iface)
 {
 	int ret;
 	struct sockaddr_in6 sin6;
 	struct sockaddr_in sin;
 	struct socket *ksmbd_socket;
+	struct task_struct *kthread;
 	bool ipv4 = false;
 
-	ret = sock_create_kern(current->nsproxy->net_ns, PF_INET6, SOCK_STREAM,
-			IPPROTO_TCP, &ksmbd_socket);
+	ret = sock_create_kern(iface->net, PF_INET6, SOCK_STREAM,
+			       IPPROTO_TCP, &ksmbd_socket);
 	if (ret) {
 		if (ret != -EAFNOSUPPORT)
 			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
-		ret = sock_create_kern(current->nsproxy->net_ns, PF_INET,
-				SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
+		ret = sock_create_kern(iface->net, PF_INET, SOCK_STREAM,
+				       IPPROTO_TCP, &ksmbd_socket);
 		if (ret) {
 			pr_err("Can't create socket for ipv4: %d\n", ret);
 			goto out_clear;
@@ -515,165 +471,28 @@ static int create_socket(struct interface *iface)
 		goto out_error;
 	}
 
-	iface->ksmbd_socket = ksmbd_socket;
-	ret = ksmbd_tcp_run_kthread(iface);
-	if (ret) {
+	iface->ksmbd_tcp_socket = ksmbd_socket;
+
+	kthread = ksmbd_interface_run_kthread(iface, tcp_kthread_fn, "tcp");
+	if (IS_ERR(kthread)) {
 		pr_err("Can't start ksmbd main kthread: %d\n", ret);
+		ret = PTR_ERR(kthread);
 		goto out_error;
 	}
+
+	iface->ksmbd_tcp_kthread = kthread;
 	iface->state = IFACE_STATE_CONFIGURED;
 
 	return 0;
 
 out_error:
-	tcp_destroy_socket(ksmbd_socket);
+	ksmbd_tcp_destroy_socket(ksmbd_socket);
 out_clear:
-	iface->ksmbd_socket = NULL;
+	iface->ksmbd_tcp_socket = NULL;
+	iface->ksmbd_tcp_kthread = NULL;
 	return ret;
 }
 
-struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name)
-{
-	struct interface *iface;
-
-	list_for_each_entry(iface, &iface_list, entry)
-		if (!strcmp(iface->name, netdev_name))
-			return iface;
-	return NULL;
-}
-
-static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
-			      void *ptr)
-{
-	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
-	struct interface *iface;
-	int ret;
-
-	switch (event) {
-	case NETDEV_UP:
-		if (netif_is_bridge_port(netdev))
-			return NOTIFY_OK;
-
-		iface = ksmbd_find_netdev_name_iface_list(netdev->name);
-		if (iface && iface->state == IFACE_STATE_DOWN) {
-			ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
-					iface->name);
-			ret = create_socket(iface);
-			if (ret)
-				return NOTIFY_OK;
-		}
-		if (!iface && bind_additional_ifaces) {
-			iface = alloc_iface(kstrdup(netdev->name, KSMBD_DEFAULT_GFP));
-			if (!iface)
-				return NOTIFY_OK;
-			ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
-				    iface->name);
-			ret = create_socket(iface);
-			if (ret)
-				break;
-		}
-		break;
-	case NETDEV_DOWN:
-		iface = ksmbd_find_netdev_name_iface_list(netdev->name);
-		if (iface && iface->state == IFACE_STATE_CONFIGURED) {
-			ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
-					iface->name);
-			kernel_sock_shutdown(iface->ksmbd_socket, SHUT_RDWR);
-			tcp_stop_kthread(iface->ksmbd_kthread);
-			iface->ksmbd_kthread = NULL;
-			sock_release(iface->ksmbd_socket);
-			iface->ksmbd_socket = NULL;
-
-			iface->state = IFACE_STATE_DOWN;
-			break;
-		}
-		break;
-	}
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block ksmbd_netdev_notifier = {
-	.notifier_call = ksmbd_netdev_event,
-};
-
-int ksmbd_tcp_init(void)
-{
-	register_netdevice_notifier(&ksmbd_netdev_notifier);
-
-	return 0;
-}
-
-static void tcp_stop_kthread(struct task_struct *kthread)
-{
-	int ret;
-
-	if (!kthread)
-		return;
-
-	ret = kthread_stop(kthread);
-	if (ret)
-		pr_err("failed to stop forker thread\n");
-}
-
-void ksmbd_tcp_destroy(void)
-{
-	struct interface *iface, *tmp;
-
-	unregister_netdevice_notifier(&ksmbd_netdev_notifier);
-
-	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
-		list_del(&iface->entry);
-		kfree(iface->name);
-		kfree(iface);
-	}
-}
-
-static struct interface *alloc_iface(char *ifname)
-{
-	struct interface *iface;
-
-	if (!ifname)
-		return NULL;
-
-	iface = kzalloc_obj(struct interface, KSMBD_DEFAULT_GFP);
-	if (!iface) {
-		kfree(ifname);
-		return NULL;
-	}
-
-	iface->name = ifname;
-	iface->state = IFACE_STATE_DOWN;
-	list_add(&iface->entry, &iface_list);
-	return iface;
-}
-
-int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz)
-{
-	int sz = 0;
-
-	if (!ifc_list_sz) {
-		bind_additional_ifaces = 1;
-		return 0;
-	}
-
-	while (ifc_list_sz > 0) {
-		if (!alloc_iface(kstrdup(ifc_list, KSMBD_DEFAULT_GFP)))
-			return -ENOMEM;
-
-		sz = strlen(ifc_list);
-		if (!sz)
-			break;
-
-		ifc_list += sz + 1;
-		ifc_list_sz -= (sz + 1);
-	}
-
-	bind_additional_ifaces = 0;
-
-	return 0;
-}
-
 static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
diff --git a/fs/smb/server/transport_tcp.h b/fs/smb/server/transport_tcp.h
index 1e51675ee1b2..d122e4b69d65 100644
--- a/fs/smb/server/transport_tcp.h
+++ b/fs/smb/server/transport_tcp.h
@@ -6,10 +6,13 @@
 #ifndef __KSMBD_TRANSPORT_TCP_H__
 #define __KSMBD_TRANSPORT_TCP_H__
 
-int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz);
-struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name);
+#include "interface.h"
+
 void ksmbd_free_transport(struct ksmbd_transport *kt);
 int ksmbd_tcp_init(void);
 void ksmbd_tcp_destroy(void);
+int ksmbd_tcp_create_socket(struct interface *iface);
+void ksmbd_tcp_stop_kthread(struct task_struct *kthread);
+void ksmbd_tcp_destroy_socket(struct socket *ksmbd_socket);
 
 #endif /* __KSMBD_TRANSPORT_TCP_H__ */
-- 
2.53.0

