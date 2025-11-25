Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADD032C949
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093957; cv=none; b=HuCGwGk4n4wolDCWB69xMcnYC7hE6d7PXcLcRbPPjbkUfks5hB+W6c1INSKuPKoX92vs/fg91gaFKDdvf2Irxw09cK2qAFbxjDw2vOkXCVvr+qJpLLN6vm8l8TUS50flrvpq87807TgCgvTIt4XD0LxifmYqC/4AYocS2lBXVr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093957; c=relaxed/simple;
	bh=uHHIK9Bm2R2kc9aYk6s6IvsbTGu+Vq5OAF2zo8ZpiLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwbD9XxnFfTgDtvm4pjyWdnPDFsksgLFtA6AwRKuCL0d6q55Bg3jR5Y0XPLUEGTvlAduEEEGcMv6XFaNOPbqZz+yFSr06Gg02HhTOTdVN+kqM7/C4zIbGyy8MAgeUCLy6NA9UIWU8m5xwxcSHCENQ0ZQ92FBl9MhZU+A/1r5PkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=TQOhc5YI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="TQOhc5YI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=9mtvYtROTKB0ZOuCelpKzHJ4Dp/EO2AKk5RzR5yObYs=; b=TQOhc5YIqANtwsBSh7vi5R9rUc
	Xa91skU6k/3U74sXn0Sx7ZbK4oZZ7XCVLoJhkuKO6xfehFddHbu0PErvCbfQQlOHqaj4psLj8EjBU
	72TEPKRyZ14FnfHsfMe4Ep6hBKoLm3SAZuxsd0nMOMrRd8XMq8I8PfEpKPl2kgDDvSyY7oT+4ESsU
	70TwR5en88kANRtqPwy6UBXk/Zy6h4KSDDj6NmHOfibuXTVAS0g4lfOgKLb0DALhxyWZKs8y3v60E
	u+ZJj7+XHiyJnJbFFsBofZx3k4bvv4nQTRjI4A2wDADRQAUxZiCkdiqt2Im72Df0R0wA3hw4Vaxuz
	tQgpS2SfauWu5lJTGDZNuQj8SimyaI2VovFI/pCPj0T55/vAkhyxaRDOOVc0G5ILRgr2MAZPM1B4b
	+iG8f/0gYKk2T5droZZI/XhKMn3+ik8PpDe0e+oCmvqxW9qE+vYdtVCvpVlvHriylR9ISWE+sw2zs
	ITL+39dTmjMf9vDXZvg0F/Pf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxNF-00FdYj-08;
	Tue, 25 Nov 2025 18:02:45 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 058/145] smb: smbdirect: introduce smbdirect_public.h with prototypes
Date: Tue, 25 Nov 2025 18:55:04 +0100
Message-ID: <935c14de0622950ee8ebed7ced70666e1bae0edd.1764091285.git.metze@samba.org>
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

smbdirect_public.h contains functions which will be still be
eported when we move to an smbdirect.ko.

For now this uses the SMBDIRECT_USE_INLINE_C_FILES code path
and marks all function as '__maybe_unused static',
but this will make further changes easier.

Note this generates the following things from checkpatch.pl,
so I passed --ignore=FILE_PATH_CHANGES,EXPORT_SYMBOL,COMPLEX_MACRO

 ERROR: Macros with complex values should be enclosed in parentheses
 #514: FILE: fs/smb/common/smbdirect/smbdirect_public.h:18:
 +#define __SMBDIRECT_PUBLIC__ __maybe_unused static

 WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
 #515: FILE: fs/smb/common/smbdirect/smbdirect_public.h:19:
 +#define __SMBDIRECT_EXPORT_SYMBOL__(__sym)

 WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
 #518: FILE: fs/smb/common/smbdirect/smbdirect_public.h:22:
 +#define __SMBDIRECT_EXPORT_SYMBOL__(__sym) EXPORT_SYMBOL_FOR_MODULES(__sym, "cifs,ksmbd")

This is exactly what we want here, so we should ignore the
checkpatch.pl problems.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_accept.c    |   7 +-
 fs/smb/common/smbdirect/smbdirect_connect.c   |  13 +-
 .../common/smbdirect/smbdirect_connection.c   |  51 +++---
 fs/smb/common/smbdirect/smbdirect_debug.c     |   9 +-
 fs/smb/common/smbdirect/smbdirect_internal.h  |   1 +
 fs/smb/common/smbdirect/smbdirect_mr.c        |  17 +-
 fs/smb/common/smbdirect/smbdirect_public.h    | 154 ++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_rw.c        |  13 +-
 fs/smb/common/smbdirect/smbdirect_socket.c    |  82 ++++++----
 fs/smb/common/smbdirect/smbdirect_socket.h    |  14 --
 10 files changed, 263 insertions(+), 98 deletions(-)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_public.h

diff --git a/fs/smb/common/smbdirect/smbdirect_accept.c b/fs/smb/common/smbdirect/smbdirect_accept.c
index db829e82fde4..f27992cf393b 100644
--- a/fs/smb/common/smbdirect/smbdirect_accept.c
+++ b/fs/smb/common/smbdirect/smbdirect_accept.c
@@ -13,9 +13,9 @@ static int smbdirect_accept_init_params(struct smbdirect_socket *sc);
 static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void smbdirect_accept_negotiate_send_done(struct ib_cq *cq, struct ib_wc *wc);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
-					    const struct rdma_conn_param *param)
+__SMBDIRECT_PUBLIC__
+int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
+				     const struct rdma_conn_param *param)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_recv_io *recv_io;
@@ -159,6 +159,7 @@ static int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
 init_params_failed:
 	return ret;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_accept_connect_request);
 
 static int smbdirect_accept_init_params(struct smbdirect_socket *sc)
 {
diff --git a/fs/smb/common/smbdirect/smbdirect_connect.c b/fs/smb/common/smbdirect/smbdirect_connect.c
index 0a3629dcf150..797916dc8481 100644
--- a/fs/smb/common/smbdirect/smbdirect_connect.c
+++ b/fs/smb/common/smbdirect/smbdirect_connect.c
@@ -15,9 +15,8 @@ static int smbdirect_connect_negotiate_start(struct smbdirect_socket *sc);
 static void smbdirect_connect_negotiate_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connect(struct smbdirect_socket *sc,
-			     const struct sockaddr *dst)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connect(struct smbdirect_socket *sc, const struct sockaddr *dst)
 {
 	const struct sockaddr *src = NULL;
 	union {
@@ -61,6 +60,7 @@ static int smbdirect_connect(struct smbdirect_socket *sc,
 	 */
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connect);
 
 static int smbdirect_connect_setup_connection(struct smbdirect_socket *sc)
 {
@@ -817,9 +817,9 @@ static void smbdirect_connect_negotiate_recv_work(struct work_struct *work)
 	smbdirect_connection_negotiation_done(sc);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connect_sync(struct smbdirect_socket *sc,
-				  const struct sockaddr *dst)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connect_sync(struct smbdirect_socket *sc,
+			   const struct sockaddr *dst)
 {
 	int ret;
 
@@ -841,3 +841,4 @@ static int smbdirect_connect_sync(struct smbdirect_socket *sc,
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connect_sync);
diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index c270c9ac1c81..a2ced59171ac 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -719,16 +719,17 @@ static void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socke
 						peer_responder_resources);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static bool smbdirect_connection_is_connected(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+bool smbdirect_connection_is_connected(struct smbdirect_socket *sc)
 {
 	if (unlikely(!sc || sc->first_error || sc->status != SMBDIRECT_SOCKET_CONNECTED))
 		return false;
 	return true;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_is_connected);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	union {
@@ -794,6 +795,7 @@ static int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_wait_for_connected);
 
 static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
@@ -1027,11 +1029,12 @@ static int smbdirect_connection_post_send_io(struct smbdirect_socket *sc,
 	return smbdirect_connection_post_send_wr(sc, &msg->wr);
 }
 
-static int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
-						 struct smbdirect_send_batch *batch,
-						 struct iov_iter *iter,
-						 unsigned int flags,
-						 u32 remaining_data_length)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
+					  struct smbdirect_send_batch *batch,
+					  struct iov_iter *iter,
+					  unsigned int flags,
+					  u32 remaining_data_length)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_send_io *msg;
@@ -1162,9 +1165,10 @@ static int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
 lcredit_failed:
 	return ret;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_single_iter);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
 {
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
@@ -1187,13 +1191,14 @@ static int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *
 
 	return 0;
 }
-
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
-					  struct iov_iter *iter,
-					  unsigned int flags,
-					  bool need_invalidate,
-					  unsigned int remote_key)
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_wait_zero_pending);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
+				   struct iov_iter *iter,
+				   unsigned int flags,
+				   bool need_invalidate,
+				   unsigned int remote_key)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_send_batch batch;
@@ -1272,6 +1277,7 @@ static int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
 
 	return total_count;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_iter);
 
 static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
@@ -1650,10 +1656,10 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 	}
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
-					struct msghdr *msg,
-					unsigned int flags)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
+				 struct msghdr *msg,
+				 unsigned int flags)
 {
 	struct smbdirect_recv_io *response;
 	struct smbdirect_data_transfer *data_transfer;
@@ -1800,6 +1806,7 @@ static int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
 
 	goto again;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_recvmsg);
 
 static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
 					   struct page *page, size_t off, size_t len)
diff --git a/fs/smb/common/smbdirect/smbdirect_debug.c b/fs/smb/common/smbdirect/smbdirect_debug.c
index 20b87d8aa6d1..eac924164fd4 100644
--- a/fs/smb/common/smbdirect/smbdirect_debug.c
+++ b/fs/smb/common/smbdirect/smbdirect_debug.c
@@ -7,10 +7,10 @@
 #include "smbdirect_internal.h"
 #include <linux/seq_file.h>
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
-							unsigned int rdma_readwrite_threshold,
-							struct seq_file *m)
+__SMBDIRECT_PUBLIC__
+void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
+						 unsigned int rdma_readwrite_threshold,
+						 struct seq_file *m)
 {
 	const struct smbdirect_socket_parameters *sp;
 
@@ -86,3 +86,4 @@ static void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket
 		   atomic_read(&sc->mr_io.ready.count),
 		   atomic_read(&sc->mr_io.used.count));
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_legacy_debug_proc_show);
diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 8ea10f8f8501..b61f2473a28b 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -13,6 +13,7 @@
 #include <linux/errname.h>
 #include "smbdirect.h"
 #include "smbdirect_pdu.h"
+#include "smbdirect_public.h"
 #include "smbdirect_socket.h"
 
 static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index 3c2f653f70e8..c7be46c7ffe4 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -330,8 +330,8 @@ static int smbdirect_iter_to_sgt(struct iov_iter *iter,
  * need_invalidate: true if this MR needs to be locally invalidated after I/O
  * return value: the MR registered, NULL if failed.
  */
-__maybe_unused /* this is temporary while this file is included in others */
-static struct smbdirect_mr_io *
+__SMBDIRECT_PUBLIC__
+struct smbdirect_mr_io *
 smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
 				    bool writing,
@@ -452,10 +452,11 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		mutex_unlock(&mr->mutex);
 	return NULL;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_register_mr_io);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
-						   struct smbdirect_buffer_descriptor_v1 *v1)
+__SMBDIRECT_PUBLIC__
+void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
+					    struct smbdirect_buffer_descriptor_v1 *v1)
 {
 	mutex_lock(&mr->mutex);
 	if (mr->state == SMBDIRECT_MR_REGISTERED) {
@@ -469,6 +470,7 @@ static void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 	}
 	mutex_unlock(&mr->mutex);
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_mr_io_fill_buffer_descriptor);
 
 /*
  * Deregister a MR after I/O is done
@@ -476,8 +478,8 @@ static void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
  * and we have to locally invalidate the buffer to prevent data is being
  * modified by remote peer after upper layer consumes it
  */
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
+__SMBDIRECT_PUBLIC__
+void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 {
 	struct smbdirect_socket *sc = mr->socket;
 	int ret = 0;
@@ -559,3 +561,4 @@ static void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 	if (!kref_put(&mr->kref, smbdirect_mr_io_free_locked))
 		mutex_unlock(&mr->mutex);
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_deregister_mr_io);
diff --git a/fs/smb/common/smbdirect/smbdirect_public.h b/fs/smb/common/smbdirect/smbdirect_public.h
new file mode 100644
index 000000000000..a5b15fce840c
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_public.h
@@ -0,0 +1,154 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (C) 2025, Stefan Metzmacher
+ */
+
+#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PUBLIC_H__
+#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PUBLIC_H__
+
+struct smbdirect_buffer_descriptor_v1;
+struct smbdirect_socket_parameters;
+
+struct smbdirect_socket;
+struct smbdirect_send_batch;
+struct smbdirect_mr_io;
+
+#ifdef SMBDIRECT_USE_INLINE_C_FILES
+/* this is temporary while this file is included in others */
+#define __SMBDIRECT_PUBLIC__ __maybe_unused static
+#define __SMBDIRECT_EXPORT_SYMBOL__(__sym)
+#else
+#define __SMBDIRECT_PUBLIC__
+#define __SMBDIRECT_EXPORT_SYMBOL__(__sym) EXPORT_SYMBOL_FOR_MODULES(__sym, "cifs,ksmbd")
+#endif
+
+#include <rdma/rw.h>
+
+__SMBDIRECT_PUBLIC__
+bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdirect_socket **_sc);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
+					    const struct smbdirect_socket_parameters *sp);
+
+__SMBDIRECT_PUBLIC__
+const struct smbdirect_socket_parameters *
+smbdirect_socket_get_current_parameters(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
+					 enum ib_poll_context poll_ctx,
+					 gfp_t gfp_mask);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
+					  struct workqueue_struct *workqueue);
+
+#define SMBDIRECT_LOG_ERR		0x0
+#define SMBDIRECT_LOG_INFO		0x1
+
+#define SMBDIRECT_LOG_OUTGOING			0x1
+#define SMBDIRECT_LOG_INCOMING			0x2
+#define SMBDIRECT_LOG_READ			0x4
+#define SMBDIRECT_LOG_WRITE			0x8
+#define SMBDIRECT_LOG_RDMA_SEND			0x10
+#define SMBDIRECT_LOG_RDMA_RECV			0x20
+#define SMBDIRECT_LOG_KEEP_ALIVE		0x40
+#define SMBDIRECT_LOG_RDMA_EVENT		0x80
+#define SMBDIRECT_LOG_RDMA_MR			0x100
+#define SMBDIRECT_LOG_RDMA_RW			0x200
+#define SMBDIRECT_LOG_NEGOTIATE			0x400
+__SMBDIRECT_PUBLIC__
+void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
+				  void *private_ptr,
+				  bool (*needed)(struct smbdirect_socket *sc,
+						 void *private_ptr,
+						 unsigned int lvl,
+						 unsigned int cls),
+				  void (*vaprintf)(struct smbdirect_socket *sc,
+						   const char *func,
+						   unsigned int line,
+						   void *private_ptr,
+						   unsigned int lvl,
+						   unsigned int cls,
+						   struct va_format *vaf));
+
+__SMBDIRECT_PUBLIC__
+bool smbdirect_connection_is_connected(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PUBLIC__
+void smbdirect_socket_shutdown(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PUBLIC__
+void smbdirect_socket_release(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
+					  struct smbdirect_send_batch *batch,
+					  struct iov_iter *iter,
+					  unsigned int flags,
+					  u32 remaining_data_length);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
+				   struct iov_iter *iter,
+				   unsigned int flags,
+				   bool need_invalidate,
+				   unsigned int remote_key);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
+				 struct msghdr *msg,
+				 unsigned int flags);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_connect(struct smbdirect_socket *sc,
+		      const struct sockaddr *dst);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_connect_sync(struct smbdirect_socket *sc,
+			   const struct sockaddr *dst);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
+				     const struct rdma_conn_param *param);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
+				   void *buf, size_t buf_len,
+				   struct smbdirect_buffer_descriptor_v1 *desc,
+				   size_t desc_len,
+				   bool is_read);
+
+__SMBDIRECT_PUBLIC__
+struct smbdirect_mr_io *
+smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
+				    struct iov_iter *iter,
+				    bool writing,
+				    bool need_invalidate);
+
+__SMBDIRECT_PUBLIC__
+void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
+					    struct smbdirect_buffer_descriptor_v1 *v1);
+
+__SMBDIRECT_PUBLIC__
+void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr);
+
+__SMBDIRECT_PUBLIC__
+void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
+						 unsigned int rdma_readwrite_threshold,
+						 struct seq_file *m);
+
+#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PUBLIC_H__ */
diff --git a/fs/smb/common/smbdirect/smbdirect_rw.c b/fs/smb/common/smbdirect/smbdirect_rw.c
index 1ff80c8de491..46d9b1430f35 100644
--- a/fs/smb/common/smbdirect/smbdirect_rw.c
+++ b/fs/smb/common/smbdirect/smbdirect_rw.c
@@ -105,12 +105,12 @@ static void smbdirect_connection_rdma_write_done(struct ib_cq *cq, struct ib_wc
 	smbdirect_connection_rdma_rw_done(cq, wc, DMA_TO_DEVICE);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
-					  void *buf, size_t buf_len,
-					  struct smbdirect_buffer_descriptor_v1 *desc,
-					  size_t desc_len,
-					  bool is_read)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
+				   void *buf, size_t buf_len,
+				   struct smbdirect_buffer_descriptor_v1 *desc,
+				   size_t desc_len,
+				   bool is_read)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	enum dma_data_direction direction = is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
@@ -253,3 +253,4 @@ static int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
 	kfree(msg);
 	goto out;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_rdma_xmit);
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 12989140c297..e17794999382 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -6,8 +6,8 @@
 
 #include "smbdirect_internal.h"
 
-__maybe_unused /* this is temporary while this file is included in others */
-static bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
+__SMBDIRECT_PUBLIC__
+bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 {
 	/*
 	 * Test if FRWR (Fast Registration Work Requests) is supported on the
@@ -21,6 +21,7 @@ static bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 		return false;
 	return true;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_frwr_is_supported);
 
 static void smbdirect_socket_cleanup_work(struct work_struct *work);
 
@@ -82,8 +83,8 @@ static int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *s
 	return 0;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc)
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc)
 {
 	struct smbdirect_socket *sc;
 	int ret;
@@ -107,6 +108,7 @@ static int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket
 alloc_failed:
 	return ret;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_create_kern);
 
 static int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_socket *sc)
 {
@@ -123,8 +125,8 @@ static int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdire
 	return 0;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdirect_socket **_sc)
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdirect_socket **_sc)
 {
 	struct smbdirect_socket *sc;
 	int ret;
@@ -148,10 +150,11 @@ static int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdi
 alloc_failed:
 	return ret;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_create_accepting);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
-						   const struct smbdirect_socket_parameters *sp)
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
+					    const struct smbdirect_socket_parameters *sp)
 {
 	/*
 	 * This is only allowed before connect or accept
@@ -173,18 +176,20 @@ static int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_initial_parameters);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static const struct smbdirect_socket_parameters *
+__SMBDIRECT_PUBLIC__
+const struct smbdirect_socket_parameters *
 smbdirect_socket_get_current_parameters(struct smbdirect_socket *sc)
 {
 	return &sc->parameters;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_get_current_parameters);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
-						enum ib_poll_context poll_ctx,
-						gfp_t gfp_mask)
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
+					 enum ib_poll_context poll_ctx,
+					 gfp_t gfp_mask)
 {
 	/*
 	 * This is only allowed before connect or accept
@@ -204,10 +209,11 @@ static int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_kernel_settings);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
-						 struct workqueue_struct *workqueue)
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
+					  struct workqueue_struct *workqueue)
 {
 	/*
 	 * This is only allowed before connect or accept
@@ -226,6 +232,7 @@ static int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_custom_workqueue);
 
 __maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
@@ -250,25 +257,26 @@ static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
-					 void *private_ptr,
-					 bool (*needed)(struct smbdirect_socket *sc,
-							void *private_ptr,
-							unsigned int lvl,
-							unsigned int cls),
-					 void (*vaprintf)(struct smbdirect_socket *sc,
-							  const char *func,
-							  unsigned int line,
-							  void *private_ptr,
-							  unsigned int lvl,
-							  unsigned int cls,
-							  struct va_format *vaf))
+__SMBDIRECT_PUBLIC__
+void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
+				  void *private_ptr,
+				  bool (*needed)(struct smbdirect_socket *sc,
+						 void *private_ptr,
+						 unsigned int lvl,
+						 unsigned int cls),
+				  void (*vaprintf)(struct smbdirect_socket *sc,
+						   const char *func,
+						   unsigned int line,
+						   void *private_ptr,
+						   unsigned int lvl,
+						   unsigned int cls,
+						   struct va_format *vaf))
 {
 	sc->logging.private_ptr = private_ptr;
 	sc->logging.needed = needed;
 	sc->logging.vaprintf = vaprintf;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_logging);
 
 static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
 {
@@ -634,11 +642,12 @@ static void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
 		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
 {
 	smbdirect_socket_schedule_cleanup(sc, -ESHUTDOWN);
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_shutdown);
 
 static void smbdirect_socket_release_disconnect(struct kref *kref)
 {
@@ -665,8 +674,8 @@ static void smbdirect_socket_release_destroy(struct kref *kref)
 	kfree(sc);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_socket_release(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+void smbdirect_socket_release(struct smbdirect_socket *sc)
 {
 	/*
 	 * We expect only 1 disconnect reference
@@ -682,6 +691,7 @@ static void smbdirect_socket_release(struct smbdirect_socket *sc)
 	 */
 	kref_put(&sc->refs.destroy, smbdirect_socket_release_destroy);
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_release);
 
 __maybe_unused /* this is temporary while this file is included in others */
 static int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index bfa6a8907de4..95c20b8d7ec3 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -386,20 +386,6 @@ struct smbdirect_socket {
 	} statistics;
 
 	struct {
-#define SMBDIRECT_LOG_ERR		0x0
-#define SMBDIRECT_LOG_INFO		0x1
-
-#define SMBDIRECT_LOG_OUTGOING			0x1
-#define SMBDIRECT_LOG_INCOMING			0x2
-#define SMBDIRECT_LOG_READ			0x4
-#define SMBDIRECT_LOG_WRITE			0x8
-#define SMBDIRECT_LOG_RDMA_SEND			0x10
-#define SMBDIRECT_LOG_RDMA_RECV			0x20
-#define SMBDIRECT_LOG_KEEP_ALIVE		0x40
-#define SMBDIRECT_LOG_RDMA_EVENT		0x80
-#define SMBDIRECT_LOG_RDMA_MR			0x100
-#define SMBDIRECT_LOG_RDMA_RW			0x200
-#define SMBDIRECT_LOG_NEGOTIATE			0x400
 		void *private_ptr;
 		bool (*needed)(struct smbdirect_socket *sc,
 			       void *private_ptr,
-- 
2.43.0

