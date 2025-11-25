Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417FB2D73B8
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764096037; cv=none; b=JpkrAB8T1qnxiXElzBEeDuZURa/wg+6jTED3cB9iZFnzgPLQSIpH0FYu98nac6YXsBr19wOTpqdXCWj2z036+adBDnBSKBZwulOSdvnt1rAhpACX3sgXP3H6VOh0S90hOK1MGZkvcANzEOvieA8O/Jbw87gR+NQgX8bAZzhKXwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764096037; c=relaxed/simple;
	bh=/528Z10ptWyrXyT0mDLXvH3rg0RB06tduP/dI32ExXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDanuWEkUUJ4/V2FMuaVfTsNtf1oWEfKaZGvRTKbvZHvdz/OIQGc94qIr8sNVUfLke67dlLpP+teOSbo0B+SNfHvdUlBEBfpG/Lky4H1AwOTTkYmvvdq/fRdh8rzlnojzz6Cm+dRtLrTS9ZHZTbECWb2lLmHoRD3A+t96ZvsTW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=AiJMebHh; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="AiJMebHh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nZ8hAaRDNwfbshXDomjXhj+Ao6uEpOUkfJNRHp3Ddz8=; b=AiJMebHh8e1+iHZgiXHxr00mh6
	T10WTGNYY2LB9UpkJg3Q6n30pFx0J6zVH/NYVYowniVk9+0kpaDyHCqmFe9uduZ1WWrUvZ+AogJI7
	pToFiC4PbPxl029qbYHWMzba0P0Q36NkiFnanxbbNy5Gj1bbkJGb0DBt1OxWnnADMwn7cVV0f4D2g
	23CR4YEaL+Yejy4qGYGSgzEJEE2fKHvq3vMQ6ZANVgpre4xtpLcD3F14YFfA4T3Z0XtzVxaui1SQT
	7z1AW/Q8ODmiYtRxjeGFqVWdujUdmmHSLEqSSe83fyitsvw9903EFu+8QobANu/yWzGrl4pvn2PnD
	QBvwXNpNT045lJ6eCdYGHR01/lSkOQ3f7DI+VJh0CrRXhkfyvOv+lV6EEgjIMq8gOTnGfwzkaf5jE
	NF8lVbE4bfno7pv8S/7kTK8rMikJxo0oWlCfVwUMzgayhA5+oHexwbWtK0XbQqcj9BZIsJAy2ab/k
	hPX6UFRoEIUK8DdTPgTwLC+D;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxsN-00Fgwk-2n;
	Tue, 25 Nov 2025 18:34:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 145/145] smb: smbdirect: remove unused SMBDIRECT_USE_INLINE_C_FILES logic
Date: Tue, 25 Nov 2025 19:34:32 +0100
Message-ID: <d72b76bd33831f43c2b1fef74619eca20236ba6b.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We always build as standalone module (or as part of the core kernel).

This also removes unused elements from struct smbdirect_socket
and unused exports.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_accept.c    |  3 -
 .../common/smbdirect/smbdirect_all_c_files.c  | 24 -------
 fs/smb/common/smbdirect/smbdirect_connect.c   |  2 -
 .../common/smbdirect/smbdirect_connection.c   | 29 --------
 fs/smb/common/smbdirect/smbdirect_debug.c     |  1 -
 fs/smb/common/smbdirect/smbdirect_internal.h  | 35 +--------
 fs/smb/common/smbdirect/smbdirect_listen.c    |  1 -
 fs/smb/common/smbdirect/smbdirect_mr.c        |  5 --
 fs/smb/common/smbdirect/smbdirect_public.h    | 40 -----------
 fs/smb/common/smbdirect/smbdirect_rw.c        |  1 -
 fs/smb/common/smbdirect/smbdirect_socket.c    | 71 -------------------
 fs/smb/common/smbdirect/smbdirect_socket.h    | 15 ----
 12 files changed, 3 insertions(+), 224 deletions(-)
 delete mode 100644 fs/smb/common/smbdirect/smbdirect_all_c_files.c

diff --git a/fs/smb/common/smbdirect/smbdirect_accept.c b/fs/smb/common/smbdirect/smbdirect_accept.c
index 73f87093db9b..efc88b3b7bce 100644
--- a/fs/smb/common/smbdirect/smbdirect_accept.c
+++ b/fs/smb/common/smbdirect/smbdirect_accept.c
@@ -14,7 +14,6 @@ static int smbdirect_accept_init_params(struct smbdirect_socket *sc);
 static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void smbdirect_accept_negotiate_send_done(struct ib_cq *cq, struct ib_wc *wc);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
 				     const struct rdma_conn_param *param)
 {
@@ -160,7 +159,6 @@ int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
 init_params_failed:
 	return ret;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_accept_connect_request);
 
 static int smbdirect_accept_init_params(struct smbdirect_socket *sc)
 {
@@ -722,7 +720,6 @@ static long smbdirect_socket_wait_for_accept(struct smbdirect_socket *lsc, long
 	return 0;
 }
 
-__SMBDIRECT_PUBLIC__
 struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 						 long timeo,
 						 struct proto_accept_arg *arg)
diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
deleted file mode 100644
index 40e2ceb9a4a4..000000000000
--- a/fs/smb/common/smbdirect/smbdirect_all_c_files.c
+++ /dev/null
@@ -1,24 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *   Copyright (c) 2025, Stefan Metzmacher
- */
-
-/*
- * This is a temporary solution in order
- * to include the common smbdirect functions
- * into .c files in order to make a transformation
- * in tiny bisectable steps possible.
- *
- * It will be replaced by a smbdirect.ko with
- * exported public functions at the end.
- */
-#ifndef SMBDIRECT_USE_INLINE_C_FILES
-#error SMBDIRECT_USE_INLINE_C_FILES define needed
-#endif
-#include "smbdirect_socket.c"
-#include "smbdirect_connection.c"
-#include "smbdirect_mr.c"
-#include "smbdirect_rw.c"
-#include "smbdirect_debug.c"
-#include "smbdirect_connect.c"
-#include "smbdirect_accept.c"
diff --git a/fs/smb/common/smbdirect/smbdirect_connect.c b/fs/smb/common/smbdirect/smbdirect_connect.c
index 79ea2fd0bc36..1c9b0f9397c8 100644
--- a/fs/smb/common/smbdirect/smbdirect_connect.c
+++ b/fs/smb/common/smbdirect/smbdirect_connect.c
@@ -15,7 +15,6 @@ static int smbdirect_connect_negotiate_start(struct smbdirect_socket *sc);
 static void smbdirect_connect_negotiate_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connect(struct smbdirect_socket *sc, const struct sockaddr *dst)
 {
 	const struct sockaddr *src = NULL;
@@ -817,7 +816,6 @@ static void smbdirect_connect_negotiate_recv_work(struct work_struct *work)
 	smbdirect_connection_negotiation_done(sc);
 }
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connect_sync(struct smbdirect_socket *sc,
 			   const struct sockaddr *dst)
 {
diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index ff38c83a61c3..ef3c1c014c01 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -22,7 +22,6 @@ static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
 static void smbdirect_connection_recv_io_refill_work(struct work_struct *work);
 static void smbdirect_connection_send_immediate_work(struct work_struct *work);
 
-__maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_connection_qp_event_handler(struct ib_event *event, void *context)
 {
 	struct smbdirect_socket *sc = context;
@@ -143,7 +142,6 @@ static int smbdirect_connection_rdma_event_handler(struct rdma_cm_id *id,
 	return 0;
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
 {
 	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
@@ -157,7 +155,6 @@ void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
 	sc->rdma.expected_event = RDMA_CM_EVENT_DISCONNECTED;
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
 {
 	if (unlikely(sc->first_error))
@@ -242,7 +239,6 @@ static u32 smbdirect_rdma_rw_send_wrs(struct ib_device *dev,
 	return factor * attr->cap.max_rdma_ctxs;
 }
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -400,7 +396,6 @@ int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
 	return ret;
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
 {
 	if (sc->ib.qp) {
@@ -422,7 +417,6 @@ void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
 	}
 }
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -502,7 +496,6 @@ int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
 	return -ENOMEM;
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *recv_io, *next_io;
@@ -534,7 +527,6 @@ void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
 	sc->send_io.mem.cache = NULL;
 }
 
-__SMBDIRECT_PRIVATE__
 struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_socket *sc)
 {
 	struct smbdirect_send_io *msg;
@@ -549,7 +541,6 @@ struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_so
 	return msg;
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg)
 {
 	struct smbdirect_socket *sc = msg->socket;
@@ -581,7 +572,6 @@ void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg)
 	mempool_free(msg, sc->send_io.mem.pool);
 }
 
-__SMBDIRECT_PRIVATE__
 struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *msg = NULL;
@@ -601,7 +591,6 @@ struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_sock
 	return msg;
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
 {
 	struct smbdirect_socket *sc = msg->socket;
@@ -628,7 +617,6 @@ void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
 	queue_work(sc->workqueues.refill, &sc->recv_io.posted.refill_work);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_connection_reassembly_append_recv_io(struct smbdirect_socket *sc,
 							   struct smbdirect_recv_io *msg,
 							   u32 data_length)
@@ -655,7 +643,6 @@ static void smbdirect_connection_reassembly_append_recv_io(struct smbdirect_sock
 	sc->statistics.enqueue_reassembly_queue++;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
 static struct smbdirect_recv_io *
 smbdirect_connection_reassembly_first_recv_io(struct smbdirect_socket *sc)
 {
@@ -668,7 +655,6 @@ smbdirect_connection_reassembly_first_recv_io(struct smbdirect_socket *sc)
 	return msg;
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socket *sc,
 						   u8 peer_initiator_depth,
 						   u8 peer_responder_resources,
@@ -730,7 +716,6 @@ void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socket *sc,
 						peer_responder_resources);
 }
 
-__SMBDIRECT_PUBLIC__
 bool smbdirect_connection_is_connected(struct smbdirect_socket *sc)
 {
 	if (unlikely(!sc || sc->first_error || sc->status != SMBDIRECT_SOCKET_CONNECTED))
@@ -739,7 +724,6 @@ bool smbdirect_connection_is_connected(struct smbdirect_socket *sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_is_connected);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -808,7 +792,6 @@ int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_wait_for_connected);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -840,7 +823,6 @@ void smbdirect_connection_idle_timer_work(struct work_struct *work)
 	queue_work(sc->workqueues.immediate, &sc->idle.immediate_work);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
 static u16 smbdirect_connection_grant_recv_credits(struct smbdirect_socket *sc)
 {
 	u16 new_credits;
@@ -860,7 +842,6 @@ static u16 smbdirect_connection_grant_recv_credits(struct smbdirect_socket *sc)
 	return new_credits;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
 static bool smbdirect_connection_request_keep_alive(struct smbdirect_socket *sc)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -879,7 +860,6 @@ static bool smbdirect_connection_request_keep_alive(struct smbdirect_socket *sc)
 	return false;
 }
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
 				      struct ib_send_wr *wr)
 {
@@ -1042,7 +1022,6 @@ static int smbdirect_connection_post_send_io(struct smbdirect_socket *sc,
 	return smbdirect_connection_post_send_wr(sc, &msg->wr);
 }
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
 					  struct smbdirect_send_batch *batch,
 					  struct iov_iter *iter,
@@ -1180,7 +1159,6 @@ int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_single_iter);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
 {
 	/*
@@ -1206,7 +1184,6 @@ int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_wait_zero_pending);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
 				   struct iov_iter *iter,
 				   unsigned int flags,
@@ -1330,8 +1307,6 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 
 	if (atomic_dec_and_test(&sc->send_io.pending.count))
 		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-	wake_up(&sc->send_io.pending.dec_wait_queue);
 }
 
 static void smbdirect_connection_send_immediate_work(struct work_struct *work)
@@ -1355,7 +1330,6 @@ static void smbdirect_connection_send_immediate_work(struct work_struct *work)
 	}
 }
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 {
 	struct smbdirect_socket *sc = msg->socket;
@@ -1397,7 +1371,6 @@ int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 	return ret;
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_recv_io *recv_io =
@@ -1564,7 +1537,6 @@ void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
 	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 }
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
 {
 	int missing;
@@ -1670,7 +1642,6 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 	}
 }
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
 				 struct msghdr *msg,
 				 unsigned int flags)
diff --git a/fs/smb/common/smbdirect/smbdirect_debug.c b/fs/smb/common/smbdirect/smbdirect_debug.c
index eac924164fd4..d8664fd7f71a 100644
--- a/fs/smb/common/smbdirect/smbdirect_debug.c
+++ b/fs/smb/common/smbdirect/smbdirect_debug.c
@@ -7,7 +7,6 @@
 #include "smbdirect_internal.h"
 #include <linux/seq_file.h>
 
-__SMBDIRECT_PUBLIC__
 void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
 						 unsigned int rdma_readwrite_threshold,
 						 struct seq_file *m)
diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 8a032078175c..f5752537f5ac 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -6,9 +6,7 @@
 #ifndef __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__
 #define __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__
 
-#ifndef SMBDIRECT_USE_INLINE_C_FILES
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#endif /* ! SMBDIRECT_USE_INLINE_C_FILES */
 
 #include <linux/errname.h>
 #include "smbdirect.h"
@@ -34,20 +32,10 @@ extern struct smbdirect_module_state smbdirect_globals;
 
 #include "smbdirect_socket.h"
 
-#ifdef SMBDIRECT_USE_INLINE_C_FILES
-/* this is temporary while this file is included in others */
-#define __SMBDIRECT_PRIVATE__ __maybe_unused static
-#else
-#define __SMBDIRECT_PRIVATE__
-#endif
-
-__SMBDIRECT_PRIVATE__
 int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 					 const char *macro_name,
 					 unsigned int lvl,
@@ -70,10 +58,8 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 		__func__, __LINE__, __error, &__force_status); \
 } while (0)
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
 				      enum smbdirect_socket_status expected_status,
 				      int unexpected_errno,
@@ -81,64 +67,49 @@ int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
 				      atomic_t *total_credits,
 				      int needed);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_rdma_established(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_create_qp(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg);
 
-__SMBDIRECT_PRIVATE__
 struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socket *sc,
 						   u8 peer_initiator_depth,
 						   u8 peer_responder_resources,
 						   const struct rdma_conn_param *param);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_idle_timer_work(struct work_struct *work);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
 				      struct ib_send_wr *wr);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
 
+int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
+				     const struct rdma_conn_param *param);
+
 void smbdirect_accept_negotiate_finish(struct smbdirect_socket *sc, u32 ntstatus);
 
 #endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
diff --git a/fs/smb/common/smbdirect/smbdirect_listen.c b/fs/smb/common/smbdirect/smbdirect_listen.c
index dcbf1b817e2b..31529c51d064 100644
--- a/fs/smb/common/smbdirect/smbdirect_listen.c
+++ b/fs/smb/common/smbdirect/smbdirect_listen.c
@@ -10,7 +10,6 @@
 static int smbdirect_listen_rdma_event_handler(struct rdma_cm_id *id,
 					       struct rdma_cm_event *event);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_listen(struct smbdirect_socket *sc, int backlog)
 {
 	int ret;
diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index a4beaa706117..356f710c2b44 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -13,7 +13,6 @@
  * Recovery is done in smbd_mr_recovery_work. The content of list entry changes
  * as MRs are used and recovered for I/O, but the list links will not change
  */
-__SMBDIRECT_PRIVATE__
 int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -117,7 +116,6 @@ static void smbdirect_mr_io_free_locked(struct kref *kref)
 	kfree(mr);
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
 {
 	struct smbdirect_mr_io *mr, *tmp;
@@ -264,7 +262,6 @@ static int smbdirect_iter_to_sgt(struct iov_iter *iter,
  * need_invalidate: true if this MR needs to be locally invalidated after I/O
  * return value: the MR registered, NULL if failed.
  */
-__SMBDIRECT_PUBLIC__
 struct smbdirect_mr_io *
 smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
@@ -386,7 +383,6 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_register_mr_io);
 
-__SMBDIRECT_PUBLIC__
 void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 					    struct smbdirect_buffer_descriptor_v1 *v1)
 {
@@ -410,7 +406,6 @@ __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_mr_io_fill_buffer_descriptor);
  * and we have to locally invalidate the buffer to prevent data is being
  * modified by remote peer after upper layer consumes it
  */
-__SMBDIRECT_PUBLIC__
 void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 {
 	struct smbdirect_socket *sc = mr->socket;
diff --git a/fs/smb/common/smbdirect/smbdirect_public.h b/fs/smb/common/smbdirect/smbdirect_public.h
index c3647c6121ce..b58f4a9ead2a 100644
--- a/fs/smb/common/smbdirect/smbdirect_public.h
+++ b/fs/smb/common/smbdirect/smbdirect_public.h
@@ -13,43 +13,26 @@ struct smbdirect_socket;
 struct smbdirect_send_batch;
 struct smbdirect_mr_io;
 
-#ifdef SMBDIRECT_USE_INLINE_C_FILES
-/* this is temporary while this file is included in others */
-#define __SMBDIRECT_PUBLIC__ __maybe_unused static
-#define __SMBDIRECT_EXPORT_SYMBOL__(__sym)
-#else
-#define __SMBDIRECT_PUBLIC__
 #define __SMBDIRECT_EXPORT_SYMBOL__(__sym) EXPORT_SYMBOL_FOR_MODULES(__sym, "cifs,ksmbd")
-#endif
 
 #include <rdma/rw.h>
 
-__SMBDIRECT_PUBLIC__
 bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdirect_socket **_sc);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
 					    const struct smbdirect_socket_parameters *sp);
 
-__SMBDIRECT_PUBLIC__
 const struct smbdirect_socket_parameters *
 smbdirect_socket_get_current_parameters(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
 					 enum ib_poll_context poll_ctx,
 					 gfp_t gfp_mask);
 
-__SMBDIRECT_PUBLIC__
-int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
-					  struct workqueue_struct *workqueue);
-
 #define SMBDIRECT_LOG_ERR		0x0
 #define SMBDIRECT_LOG_INFO		0x1
 
@@ -64,7 +47,6 @@ int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
 #define SMBDIRECT_LOG_RDMA_MR			0x100
 #define SMBDIRECT_LOG_RDMA_RW			0x200
 #define SMBDIRECT_LOG_NEGOTIATE			0x400
-__SMBDIRECT_PUBLIC__
 void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
 				  void *private_ptr,
 				  bool (*needed)(struct smbdirect_socket *sc,
@@ -79,85 +61,63 @@ void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
 						   unsigned int cls,
 						   struct va_format *vaf));
 
-__SMBDIRECT_PUBLIC__
 bool smbdirect_connection_is_connected(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_bind(struct smbdirect_socket *sc, struct sockaddr *addr);
 
-__SMBDIRECT_PUBLIC__
 void smbdirect_socket_shutdown(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PUBLIC__
 void smbdirect_socket_release(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
 					  struct smbdirect_send_batch *batch,
 					  struct iov_iter *iter,
 					  unsigned int flags,
 					  u32 remaining_data_length);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
 				   struct iov_iter *iter,
 				   unsigned int flags,
 				   bool need_invalidate,
 				   unsigned int remote_key);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
 				 struct msghdr *msg,
 				 unsigned int flags);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connect(struct smbdirect_socket *sc,
 		      const struct sockaddr *dst);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connect_sync(struct smbdirect_socket *sc,
 			   const struct sockaddr *dst);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_listen(struct smbdirect_socket *sc, int backlog);
 
-__SMBDIRECT_PUBLIC__
-int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
-				     const struct rdma_conn_param *param);
-
-__SMBDIRECT_PUBLIC__
 struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 						 long timeo,
 						 struct proto_accept_arg *arg);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
 				   void *buf, size_t buf_len,
 				   struct smbdirect_buffer_descriptor_v1 *desc,
 				   size_t desc_len,
 				   bool is_read);
 
-__SMBDIRECT_PUBLIC__
 struct smbdirect_mr_io *
 smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
 				    bool writing,
 				    bool need_invalidate);
 
-__SMBDIRECT_PUBLIC__
 void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 					    struct smbdirect_buffer_descriptor_v1 *v1);
 
-__SMBDIRECT_PUBLIC__
 void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr);
 
-__SMBDIRECT_PUBLIC__
 void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
 						 unsigned int rdma_readwrite_threshold,
 						 struct seq_file *m);
diff --git a/fs/smb/common/smbdirect/smbdirect_rw.c b/fs/smb/common/smbdirect/smbdirect_rw.c
index 46d9b1430f35..f14126e15ee1 100644
--- a/fs/smb/common/smbdirect/smbdirect_rw.c
+++ b/fs/smb/common/smbdirect/smbdirect_rw.c
@@ -105,7 +105,6 @@ static void smbdirect_connection_rdma_write_done(struct ib_cq *cq, struct ib_wc
 	smbdirect_connection_rdma_rw_done(cq, wc, DMA_TO_DEVICE);
 }
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
 				   void *buf, size_t buf_len,
 				   struct smbdirect_buffer_descriptor_v1 *desc,
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index ac677f1961e9..37722a80c3df 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -6,7 +6,6 @@
 
 #include "smbdirect_internal.h"
 
-__SMBDIRECT_PUBLIC__
 bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 {
 	/*
@@ -52,7 +51,6 @@ static int smbdirect_socket_rdma_event_handler(struct rdma_cm_id *id,
 	return -ESTALE;
 }
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc)
 {
 	struct rdma_cm_id *id;
@@ -84,7 +82,6 @@ int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc)
 	return 0;
 }
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc)
 {
 	struct smbdirect_socket *sc;
@@ -111,7 +108,6 @@ int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_create_kern);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_socket *sc)
 {
 	smbdirect_socket_init(sc);
@@ -127,7 +123,6 @@ int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_sock
 	return 0;
 }
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdirect_socket **_sc)
 {
 	struct smbdirect_socket *sc;
@@ -154,7 +149,6 @@ int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdirect_so
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_create_accepting);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
 					    const struct smbdirect_socket_parameters *sp)
 {
@@ -180,7 +174,6 @@ int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_initial_parameters);
 
-__SMBDIRECT_PUBLIC__
 const struct smbdirect_socket_parameters *
 smbdirect_socket_get_current_parameters(struct smbdirect_socket *sc)
 {
@@ -188,7 +181,6 @@ smbdirect_socket_get_current_parameters(struct smbdirect_socket *sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_get_current_parameters);
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
 					 enum ib_poll_context poll_ctx,
 					 gfp_t gfp_mask)
@@ -213,58 +205,6 @@ int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_kernel_settings);
 
-__SMBDIRECT_PUBLIC__
-int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
-					  struct workqueue_struct *workqueue)
-{
-	/*
-	 * This is only allowed before connect or accept
-	 */
-	WARN_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED,
-		  "status=%s first_error=%1pe",
-		  smbdirect_socket_status_string(sc->status),
-		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
-	if (sc->status != SMBDIRECT_SOCKET_CREATED)
-		return -EINVAL;
-
-	/*
-	 * Remember the callers workqueue
-	 */
-	sc->workqueues.accept = workqueue;
-	sc->workqueues.connect = workqueue;
-	sc->workqueues.idle = workqueue;
-	sc->workqueues.refill = workqueue;
-	sc->workqueues.immediate = workqueue;
-	sc->workqueues.cleanup = workqueue;
-
-	return 0;
-}
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_custom_workqueue);
-
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
-					    const struct smbdirect_socket_parameters *sp,
-					    struct workqueue_struct *workqueue)
-{
-	smbdirect_socket_init(sc);
-
-	/*
-	 * Make a copy of the callers parameters
-	 * from here we only work on the copy
-	 */
-	smbdirect_socket_set_initial_parameters(sc, sp);
-
-	/*
-	 * Remember the callers workqueue
-	 */
-	smbdirect_socket_set_custom_workqueue(sc, workqueue);
-
-	INIT_WORK(&sc->disconnect_work, smbdirect_socket_cleanup_work);
-
-	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
-}
-
-__SMBDIRECT_PUBLIC__
 void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
 				  void *private_ptr,
 				  bool (*needed)(struct smbdirect_socket *sc,
@@ -295,15 +235,12 @@ static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->listen.wait_queue);
 	wake_up_all(&sc->send_io.lcredits.wait_queue);
 	wake_up_all(&sc->send_io.credits.wait_queue);
-	wake_up_all(&sc->send_io.pending.dec_wait_queue);
 	wake_up_all(&sc->send_io.pending.zero_wait_queue);
 	wake_up_all(&sc->recv_io.reassembly.wait_queue);
 	wake_up_all(&sc->rw_io.credits.wait_queue);
 	wake_up_all(&sc->mr_io.ready.wait_queue);
-	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
 
-__SMBDIRECT_PRIVATE__
 void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 					 const char *macro_name,
 					 unsigned int lvl,
@@ -341,7 +278,6 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 	 * disable[_delayed]_work_sync()
 	 */
 	disable_work(&sc->recv_io.posted.refill_work);
-	disable_work(&sc->mr_io.recovery_work);
 	disable_work(&sc->idle.immediate_work);
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
 	disable_delayed_work(&sc->idle.timer_work);
@@ -456,7 +392,6 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	 */
 	disable_work(&sc->disconnect_work);
 	disable_work(&sc->recv_io.posted.refill_work);
-	disable_work(&sc->mr_io.recovery_work);
 	disable_work(&sc->idle.immediate_work);
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
 	disable_delayed_work(&sc->idle.timer_work);
@@ -587,7 +522,6 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 
 	disable_work_sync(&sc->disconnect_work);
 	disable_work_sync(&sc->recv_io.posted.refill_work);
-	disable_work_sync(&sc->mr_io.recovery_work);
 	disable_work_sync(&sc->idle.immediate_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
 
@@ -681,7 +615,6 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 		"rdma session destroyed\n");
 }
 
-__SMBDIRECT_PRIVATE__
 void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
 {
 	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
@@ -730,7 +663,6 @@ void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
 		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
 }
 
-__SMBDIRECT_PUBLIC__
 int smbdirect_socket_bind(struct smbdirect_socket *sc, struct sockaddr *addr)
 {
 	int ret;
@@ -746,7 +678,6 @@ int smbdirect_socket_bind(struct smbdirect_socket *sc, struct sockaddr *addr)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_bind);
 
-__SMBDIRECT_PUBLIC__
 void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
 {
 	smbdirect_socket_schedule_cleanup(sc, -ESHUTDOWN);
@@ -778,7 +709,6 @@ static void smbdirect_socket_release_destroy(struct kref *kref)
 	kfree(sc);
 }
 
-__SMBDIRECT_PUBLIC__
 void smbdirect_socket_release(struct smbdirect_socket *sc)
 {
 	/*
@@ -797,7 +727,6 @@ void smbdirect_socket_release(struct smbdirect_socket *sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_release);
 
-__SMBDIRECT_PRIVATE__
 int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
 				      enum smbdirect_socket_status expected_status,
 				      int unexpected_errno,
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 8d56486197c5..f11f82d01624 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -257,10 +257,6 @@ struct smbdirect_socket {
 		 */
 		struct {
 			atomic_t count;
-			/*
-			 * woken when count is decremented
-			 */
-			wait_queue_head_t dec_wait_queue;
 			/*
 			 * woken when count reached zero
 			 */
@@ -373,13 +369,6 @@ struct smbdirect_socket {
 		struct {
 			atomic_t count;
 		} used;
-
-		struct work_struct recovery_work;
-
-		/* Used by transport to wait until all MRs are returned */
-		struct {
-			wait_queue_head_t wait_queue;
-		} cleanup;
 	} mr_io;
 
 	/*
@@ -589,7 +578,6 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	init_waitqueue_head(&sc->send_io.credits.wait_queue);
 
 	atomic_set(&sc->send_io.pending.count, 0);
-	init_waitqueue_head(&sc->send_io.pending.dec_wait_queue);
 	init_waitqueue_head(&sc->send_io.pending.zero_wait_queue);
 
 	sc->recv_io.mem.gfp_mask = GFP_KERNEL;
@@ -616,9 +604,6 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	atomic_set(&sc->mr_io.ready.count, 0);
 	init_waitqueue_head(&sc->mr_io.ready.wait_queue);
 	atomic_set(&sc->mr_io.used.count, 0);
-	INIT_WORK(&sc->mr_io.recovery_work, __smbdirect_socket_disabled_work);
-	disable_work_sync(&sc->mr_io.recovery_work);
-	init_waitqueue_head(&sc->mr_io.cleanup.wait_queue);
 
 	sc->logging.private_ptr = NULL;
 	sc->logging.needed = __smbdirect_log_needed;
-- 
2.43.0

