Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2793306B2E
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744481; cv=none; b=nszHs7vBeVR/bJXafs0339fjZwIdGALh0zLJuvoMJkLTizdMjcB0v/uKXN1vs9YyxJZKwlK6uriHTzrmftUPItbslvHVFeWTfuOjSJcRx0wiXP/1lfHddtJGeMyo3FvTxeqs+XNue+4KolsOhZEuvCSfS7xK6VeMn7fh2pZYqto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744481; c=relaxed/simple;
	bh=AbzYQbqaQFZ9peR7dWHww4dZ+iyAF4wJaldnOszLBRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHAa0XPggQG4p4gd9GjOxlHB8d9oLbLflb+ZWWR6UCV0STBAfqIDMNypVhCXEmTMXjUOierFTEqFOGbAi5UE1GybZwZAXdSmYRiZFYZIJZc67vK6oWjmYGmgln6C6EBr4yQD5wVT+ZtxGTrdlMLs2A+8HDtJbOsdw5+EyCKFFwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=x1k+Ny6g; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="x1k+Ny6g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=BhABtKtl6/jVhHnw/YMl3z+8dUtNaZLdht6LVXIURpo=; b=x1k+Ny6giXqSjE54NxJCjjI6Rl
	57gv1NusUzvbao13b/6Lx0XeAPNrrbqHO1RPHxqFvF+MumXgVIKLIRPeblOffhlip8Y2PrVjBlTEa
	SGXMDJM4jYdxIZqpR8QUySL2XfgUyi6l39OmiWOatU08fdp5/dL6jGCo38n5KnO/Zs+Xopzg16DS0
	o+tsgTthwZgc6Ci8PoMM82v45LisOPOEVPxV2dDIb7mJRy9Q94FSd0rSwyXlPMBnEKhPYHaGn284N
	mY4o8W8Yz3pvQh69wvFG/8aOe5txFgnUSLQsRsLEmPju8mg3E900a64gH4rOWX7Hqz8vJ1CtNR2Kn
	Opxhu5nzIf5VDBRmrzIHxFFOylzFKvKLIh3nRd2sfppH1NT6JHFqp5Nbi77K2X+g4CDaGpkw0Ipts
	jlgcpdLYqjQVAZxjbGklvXVL9grZYFtiMVj571g4QlkXCtqQ//3ubTWOx/liWIlNFIqK3hxTuiJ2u
	J7GUaZrF6UEZG+QrVlotBmSe;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6DT-00Bc1J-2g;
	Wed, 29 Oct 2025 13:27:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 055/127] smb: smbdirect: introduce smbdirect_private.h with prototypes
Date: Wed, 29 Oct 2025 14:20:33 +0100
Message-ID: <1b1aaa832b7bda4bbf2990a4951bc8ce4328adda.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This has prototypes of functions used between private .c files,
when they will be compiled alone into smbdirect.ko.

For now this uses the SMBDIRECT_USE_INLINE_C_FILES code path
and marks all function as '__maybe_unused static',
but this will make further changes easier.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 98 +++++++++----------
 fs/smb/common/smbdirect/smbdirect_internal.h  |  1 +
 fs/smb/common/smbdirect/smbdirect_mr.c        |  8 +-
 fs/smb/common/smbdirect/smbdirect_private.h   | 92 +++++++++++++++++
 4 files changed, 145 insertions(+), 54 deletions(-)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_private.h

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index b102e8014fe7..ae9626888b5c 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -19,15 +19,10 @@ struct smbdirect_map_sges {
 static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
 					    struct smbdirect_map_sges *state);
 
-static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
-						     int error);
 static void smbdirect_connection_disconnect_work(struct work_struct *work);
-static void smbdirect_connection_idle_timer_work(struct work_struct *work);
 static void smbdirect_connection_recv_io_refill_work(struct work_struct *work);
 static void smbdirect_connection_send_immediate_work(struct work_struct *work);
 
-static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
-
 __SMBDIRECT_PUBLIC__
 bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 {
@@ -95,7 +90,8 @@ static int smbdirect_socket_rdma_event_handler(struct rdma_cm_id *id,
 	return 1;
 }
 
-static int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc)
 {
 	struct rdma_cm_id *id;
 
@@ -407,8 +403,8 @@ static int smbdirect_connection_rdma_event_handler(struct rdma_cm_id *id,
 	return 0;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
 {
 	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 		"rdma established: device: %.*s local: %pISpsfc remote: %pISpsfc\n",
@@ -421,8 +417,8 @@ static void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
 	sc->rdma.expected_event = RDMA_CM_EVENT_DISCONNECTED;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
 {
 	if (unlikely(sc->first_error))
 		return;
@@ -497,10 +493,8 @@ static u32 smbdirect_rdma_rw_send_wrs(struct ib_device *dev,
 	return factor * attr->cap.max_rdma_ctxs;
 }
 
-static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc);
-
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_qp_init_attr qp_attr;
@@ -657,7 +651,8 @@ static int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
 	return ret;
 }
 
-static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
 {
 	if (sc->ib.qp) {
 		ib_drain_qp(sc->ib.qp);
@@ -678,10 +673,8 @@ static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
 	}
 }
 
-static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
-
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	char name[80];
@@ -758,7 +751,8 @@ static int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
 	return -ENOMEM;
 }
 
-static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *recv_io, *next_io;
 
@@ -785,8 +779,8 @@ static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
 	sc->send_io.mem.cache = NULL;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_socket *sc)
 {
 	struct smbdirect_send_io *msg;
 
@@ -800,8 +794,8 @@ static struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdi
 	return msg;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg)
 {
 	struct smbdirect_socket *sc = msg->socket;
 	size_t i;
@@ -832,8 +826,8 @@ static void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg)
 	mempool_free(msg, sc->send_io.mem.pool);
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *msg = NULL;
 	unsigned long flags;
@@ -851,8 +845,8 @@ static struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdire
 	return msg;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
 {
 	struct smbdirect_socket *sc = msg->socket;
 	unsigned long flags;
@@ -908,11 +902,11 @@ smbdirect_connection_reassembly_first_recv_io(struct smbdirect_socket *sc)
 	return msg;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socket *sc,
-							  u8 peer_initiator_depth,
-							  u8 peer_responder_resources,
-							  const struct rdma_conn_param *param)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socket *sc,
+						   u8 peer_initiator_depth,
+						   u8 peer_responder_resources,
+						   const struct rdma_conn_param *param)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 
@@ -970,8 +964,9 @@ static void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socke
 						peer_responder_resources);
 }
 
-static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
-						     int error)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
+					      int error)
 {
 	/*
 	 * make sure other work (than disconnect_work)
@@ -1266,8 +1261,8 @@ static void smbdirect_connection_destroy(struct smbdirect_socket *sc)
 		"rdma session destroyed\n");
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_connection_destroy_sync(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_sync(struct smbdirect_socket *sc)
 {
 	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 		"status=%s first_error=%1pe",
@@ -1357,7 +1352,8 @@ void smbdirect_socket_release(struct smbdirect_socket *sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_release);
 
-static void smbdirect_connection_idle_timer_work(struct work_struct *work)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, idle.timer_work.work);
@@ -1388,11 +1384,11 @@ static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 	queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_connection_wait_for_credits(struct smbdirect_socket *sc,
-						 wait_queue_head_t *waitq,
-						 atomic_t *total_credits,
-						 int needed)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_wait_for_credits(struct smbdirect_socket *sc,
+					  wait_queue_head_t *waitq,
+					  atomic_t *total_credits,
+					  int needed)
 {
 	int ret;
 
@@ -1454,8 +1450,9 @@ static bool smbdirect_connection_request_keep_alive(struct smbdirect_socket *sc)
 	return false;
 }
 
-static int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
-					     struct ib_send_wr *wr)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
+				      struct ib_send_wr *wr)
 {
 	int ret;
 
@@ -1925,8 +1922,8 @@ static void smbdirect_connection_send_immediate_work(struct work_struct *work)
 	}
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 {
 	struct smbdirect_socket *sc = msg->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -1967,8 +1964,8 @@ static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 	return ret;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_recv_io *recv_io =
 		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
@@ -2134,7 +2131,8 @@ static void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc
 	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 }
 
-static int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
 {
 	int missing;
 	int posted = 0;
diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 348de3ec92b4..579f2ffb73da 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -15,5 +15,6 @@
 #include "smbdirect_pdu.h"
 #include "smbdirect_public.h"
 #include "smbdirect_socket.h"
+#include "smbdirect_private.h"
 
 #endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index b4b43df50096..93b276ae3429 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -6,7 +6,6 @@
 
 #include "smbdirect_internal.h"
 
-static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
 static void smbdirect_connection_mr_io_recovery_work(struct work_struct *work);
 
 /*
@@ -16,8 +15,8 @@ static void smbdirect_connection_mr_io_recovery_work(struct work_struct *work);
  * Recovery is done in smbd_mr_recovery_work. The content of list entry changes
  * as MRs are used and recovered for I/O, but the list links will not change
  */
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_mr_io *mr;
@@ -122,7 +121,8 @@ static void smbdirect_mr_io_free_locked(struct kref *kref)
 	kfree(mr);
 }
 
-static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
 {
 	struct smbdirect_mr_io *mr, *tmp;
 	LIST_HEAD(all_list);
diff --git a/fs/smb/common/smbdirect/smbdirect_private.h b/fs/smb/common/smbdirect/smbdirect_private.h
new file mode 100644
index 000000000000..2abb905ed8b8
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_private.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (c) 2025 Stefan Metzmacher
+ */
+
+#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PRIVATE_H__
+#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PRIVATE_H__
+
+#include <rdma/rw.h>
+
+#ifdef SMBDIRECT_USE_INLINE_C_FILES
+/* this is temporary while this file is included in others */
+#define __SMBDIRECT_PRIVATE__ __maybe_unused static
+#else
+#define __SMBDIRECT_PRIVATE__
+#endif
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_rdma_established(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_qp(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg);
+
+__SMBDIRECT_PRIVATE__
+struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socket *sc,
+						   u8 peer_initiator_depth,
+						   u8 peer_responder_resources,
+						   const struct rdma_conn_param *param);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
+					      int error);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_sync(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_idle_timer_work(struct work_struct *work);
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_wait_for_credits(struct smbdirect_socket *sc,
+					  wait_queue_head_t *waitq,
+					  atomic_t *total_credits,
+					  int needed);
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
+				      struct ib_send_wr *wr);
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc);
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
+
+#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PRIVATE_H__ */
-- 
2.43.0

