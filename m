Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605B140243E
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777470240; cv=none; b=DG3A8TWz8llVrVntA5QPp0A6gHi5mQ4PsN9PomrFAOwg8f/7uMLjcdjFMjYXESdw96XVXrWbi61mNqlMzepqalE+pZshI55xE//DobC7rWW462/r9virxiMTn4Z8Bgv18rNGNnx6bURJhmAcyDuW3Olomtm2wX8y//9zBYnNAag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777470240; c=relaxed/simple;
	bh=43nHlSffDBj0VZcGJdABQnWLjhJTuvwzUBxOIgp/Zcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8xnD07S1R6JgDwaH+p5wsgy0M6qvbZffRnsKQsClSbb+Uhwp41NUu94yO6d6b65rdFOtzYiX5kf1OS9x0sTKdAYdRxtZnCMv7FprBOZE5MWgukKSkxPuXdiDd+uEwKV8BNCoIyeTYXj+Ggz591utT7sZ0d71yUPPsxO+ypMsl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=4FZKKTsq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="4FZKKTsq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=84dniJZ51MKX+Cn41tpKuh6iwfhWxHS65xtmHI/s+tM=; b=4FZKKTsqMX+knQmChuzYbUWAxz
	lAdUUmRkvIxo3yqeECpTYxts62aY1s6Oi5qxH3aDB+fHQkkJXPvxhCvLTLD853g8PEN5NrRroht+m
	ldtCPu/o7S1lejhvVnYpgbK2F8IE9Q8Do1/cATnddgC7UnmzI4DZFdGy2NJlU5ZuJfUP9c5KLZykg
	lzvppR3mS/f0YxLFZHCJQJlPK5wCOaBAKLGNcWMIe30tIdXDMNMYyPF8jzY1DgPgh662V0hl+hYjS
	ptl0O2wqXpOUCreKDv00ngf42UW7wNwhHTGt+4HL7ml7gRjiUXX7VmiAbc7lYGKd/lZgo9wHkATwA
	/5U0G4BkO++yBMA3IPe8AobG6lyAVx0orbsUcp9ysnWla6xQalCtZcgcd8KyqGj9E2ZDdBtp5CRm4
	0n80DCM0dQo6Nri6GzmTl1+d3eEwQrVHTQBJiPxj2t/+pfAcrMY8KaGzmf+L4d2pVWjn1qJ305XRR
	24kX60qKkAy4/6EIJ0U46QQg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wI5Cg-000000050Xb-0hTh;
	Wed, 29 Apr 2026 13:43:50 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Christoph Hellwig <hch@infradead.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] smb: smbdirect: make use of DEFAULT_SYMBOL_NAMESPACE and EXPORT_SYMBOL_GPL
Date: Wed, 29 Apr 2026 15:43:35 +0200
Message-ID: <4c459d366679d0c83fae4fffa5f6c04e84f6be1d.1777463800.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777463800.git.metze@samba.org>
References: <cover.1777463800.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a better solution than
EXPORT_SYMBOL_FOR_MODULES(__sym, "cifs,ksmbd") as it makes
it possible to rebuild smbdirect.ko against a
running kernel and then load the existing cifs.ko and ksmbd.ko
from the running kernel.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Link: https://lore.kernel.org/linux-cifs/aehrPuY60VMcYGU8@infradead.org/
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c      |  2 ++
 fs/smb/server/transport_rdma.c |  2 ++
 fs/smb/smbdirect/accept.c      |  2 +-
 fs/smb/smbdirect/connect.c     |  4 ++--
 fs/smb/smbdirect/connection.c  | 16 ++++++++--------
 fs/smb/smbdirect/debug.c       |  2 +-
 fs/smb/smbdirect/devices.c     |  2 +-
 fs/smb/smbdirect/internal.h    |  1 +
 fs/smb/smbdirect/listen.c      |  2 +-
 fs/smb/smbdirect/mr.c          |  6 +++---
 fs/smb/smbdirect/public.h      |  2 --
 fs/smb/smbdirect/rw.c          |  2 +-
 fs/smb/smbdirect/socket.c      | 20 ++++++++++----------
 13 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 75f9f91a7ec9..b9826185de18 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -558,3 +558,5 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 						    server->rdma_readwrite_threshold,
 						    m);
 }
+
+MODULE_IMPORT_NS("SMBDIRECT");
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index a8242c00096f..346c051e31f5 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -540,3 +540,5 @@ static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
 	.rdma_write	= smb_direct_rdma_write,
 	.free_transport = smb_direct_free_transport,
 };
+
+MODULE_IMPORT_NS("SMBDIRECT");
diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index 704b271af3a8..529740005838 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -854,4 +854,4 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 
 	return nsc;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_accept);
+EXPORT_SYMBOL_GPL(smbdirect_socket_accept);
diff --git a/fs/smb/smbdirect/connect.c b/fs/smb/smbdirect/connect.c
index 8addee43a381..cd726b399afe 100644
--- a/fs/smb/smbdirect/connect.c
+++ b/fs/smb/smbdirect/connect.c
@@ -60,7 +60,7 @@ int smbdirect_connect(struct smbdirect_socket *sc, const struct sockaddr *dst)
 	 */
 	return 0;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connect);
+EXPORT_SYMBOL_GPL(smbdirect_connect);
 
 static int smbdirect_connect_setup_connection(struct smbdirect_socket *sc)
 {
@@ -922,4 +922,4 @@ int smbdirect_connect_sync(struct smbdirect_socket *sc,
 
 	return 0;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connect_sync);
+EXPORT_SYMBOL_GPL(smbdirect_connect_sync);
diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index 8f5676158537..8adf58097534 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -706,7 +706,7 @@ bool smbdirect_connection_is_connected(struct smbdirect_socket *sc)
 		return false;
 	return true;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_is_connected);
+EXPORT_SYMBOL_GPL(smbdirect_connection_is_connected);
 
 int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 {
@@ -779,7 +779,7 @@ int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 
 	return 0;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_wait_for_connected);
+EXPORT_SYMBOL_GPL(smbdirect_connection_wait_for_connected);
 
 void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
@@ -958,7 +958,7 @@ int smbdirect_connection_send_batch_flush(struct smbdirect_socket *sc,
 
 	return ret;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_batch_flush);
+EXPORT_SYMBOL_GPL(smbdirect_connection_send_batch_flush);
 
 struct smbdirect_send_batch *
 smbdirect_init_send_batch_storage(struct smbdirect_send_batch_storage *storage,
@@ -976,7 +976,7 @@ smbdirect_init_send_batch_storage(struct smbdirect_send_batch_storage *storage,
 
 	return batch;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_init_send_batch_storage);
+EXPORT_SYMBOL_GPL(smbdirect_init_send_batch_storage);
 
 static int smbdirect_connection_wait_for_send_bcredit(struct smbdirect_socket *sc,
 						      struct smbdirect_send_batch *batch)
@@ -1263,7 +1263,7 @@ int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
 bcredit_failed:
 	return ret;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_single_iter);
+EXPORT_SYMBOL_GPL(smbdirect_connection_send_single_iter);
 
 int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
 {
@@ -1288,7 +1288,7 @@ int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
 
 	return 0;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_wait_zero_pending);
+EXPORT_SYMBOL_GPL(smbdirect_connection_send_wait_zero_pending);
 
 int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
 				   struct iov_iter *iter,
@@ -1373,7 +1373,7 @@ int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
 
 	return total_count;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_iter);
+EXPORT_SYMBOL_GPL(smbdirect_connection_send_iter);
 
 static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
@@ -1937,7 +1937,7 @@ int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
 
 	goto again;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_recvmsg);
+EXPORT_SYMBOL_GPL(smbdirect_connection_recvmsg);
 
 static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
 					   struct page *page, size_t off, size_t len)
diff --git a/fs/smb/smbdirect/debug.c b/fs/smb/smbdirect/debug.c
index a66a19d4a463..05ba7c8d165e 100644
--- a/fs/smb/smbdirect/debug.c
+++ b/fs/smb/smbdirect/debug.c
@@ -85,4 +85,4 @@ void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
 		   atomic_read(&sc->mr_io.ready.count),
 		   atomic_read(&sc->mr_io.used.count));
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_legacy_debug_proc_show);
+EXPORT_SYMBOL_GPL(smbdirect_connection_legacy_debug_proc_show);
diff --git a/fs/smb/smbdirect/devices.c b/fs/smb/smbdirect/devices.c
index 44962f221c35..7adacbdfe12e 100644
--- a/fs/smb/smbdirect/devices.c
+++ b/fs/smb/smbdirect/devices.c
@@ -238,7 +238,7 @@ u8 smbdirect_netdev_rdma_capable_node_type(struct net_device *netdev)
 
 	return RDMA_NODE_UNSPECIFIED;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_netdev_rdma_capable_node_type);
+EXPORT_SYMBOL_GPL(smbdirect_netdev_rdma_capable_node_type);
 
 __init int smbdirect_devices_init(void)
 {
diff --git a/fs/smb/smbdirect/internal.h b/fs/smb/smbdirect/internal.h
index 2d5acf2c21bc..82529b41708b 100644
--- a/fs/smb/smbdirect/internal.h
+++ b/fs/smb/smbdirect/internal.h
@@ -6,6 +6,7 @@
 #ifndef __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__
 #define __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__
 
+#define DEFAULT_SYMBOL_NAMESPACE "SMBDIRECT"
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include "smbdirect.h"
diff --git a/fs/smb/smbdirect/listen.c b/fs/smb/smbdirect/listen.c
index 143a7618d95f..2f78bcaedbf8 100644
--- a/fs/smb/smbdirect/listen.c
+++ b/fs/smb/smbdirect/listen.c
@@ -90,7 +90,7 @@ int smbdirect_socket_listen(struct smbdirect_socket *sc, int backlog)
 	 */
 	return 0;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_listen);
+EXPORT_SYMBOL_GPL(smbdirect_socket_listen);
 
 static int smbdirect_new_rdma_event_handler(struct rdma_cm_id *new_id,
 					    struct rdma_cm_event *event)
diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index 5a428ff1b369..15c6363a2f97 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -383,7 +383,7 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		mutex_unlock(&mr->mutex);
 	return NULL;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_register_mr_io);
+EXPORT_SYMBOL_GPL(smbdirect_connection_register_mr_io);
 
 void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 					    struct smbdirect_buffer_descriptor_v1 *v1)
@@ -400,7 +400,7 @@ void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 	}
 	mutex_unlock(&mr->mutex);
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_mr_io_fill_buffer_descriptor);
+EXPORT_SYMBOL_GPL(smbdirect_mr_io_fill_buffer_descriptor);
 
 /*
  * Deregister a MR after I/O is done
@@ -493,4 +493,4 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 	if (!kref_put(&mr->kref, smbdirect_mr_io_free_locked))
 		mutex_unlock(&mr->mutex);
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_deregister_mr_io);
+EXPORT_SYMBOL_GPL(smbdirect_connection_deregister_mr_io);
diff --git a/fs/smb/smbdirect/public.h b/fs/smb/smbdirect/public.h
index 50088155e7c3..d4fb36e65254 100644
--- a/fs/smb/smbdirect/public.h
+++ b/fs/smb/smbdirect/public.h
@@ -13,8 +13,6 @@ struct smbdirect_socket;
 struct smbdirect_send_batch;
 struct smbdirect_mr_io;
 
-#define __SMBDIRECT_EXPORT_SYMBOL__(__sym) EXPORT_SYMBOL_FOR_MODULES(__sym, "cifs,ksmbd")
-
 #include <rdma/rw.h>
 
 u8 smbdirect_netdev_rdma_capable_node_type(struct net_device *netdev);
diff --git a/fs/smb/smbdirect/rw.c b/fs/smb/smbdirect/rw.c
index c2f46b17731e..6fe38042cfb9 100644
--- a/fs/smb/smbdirect/rw.c
+++ b/fs/smb/smbdirect/rw.c
@@ -252,4 +252,4 @@ int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
 	kfree(msg);
 	goto out;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_rdma_xmit);
+EXPORT_SYMBOL_GPL(smbdirect_connection_rdma_xmit);
diff --git a/fs/smb/smbdirect/socket.c b/fs/smb/smbdirect/socket.c
index 1b4ab01b745e..39cca7219c4d 100644
--- a/fs/smb/smbdirect/socket.c
+++ b/fs/smb/smbdirect/socket.c
@@ -20,7 +20,7 @@ bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 		return false;
 	return true;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_frwr_is_supported);
+EXPORT_SYMBOL_GPL(smbdirect_frwr_is_supported);
 
 static void smbdirect_socket_cleanup_work(struct work_struct *work);
 
@@ -107,7 +107,7 @@ int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc)
 alloc_failed:
 	return ret;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_create_kern);
+EXPORT_SYMBOL_GPL(smbdirect_socket_create_kern);
 
 int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_socket *sc)
 {
@@ -148,7 +148,7 @@ int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdirect_so
 alloc_failed:
 	return ret;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_create_accepting);
+EXPORT_SYMBOL_GPL(smbdirect_socket_create_accepting);
 
 int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
 					    const struct smbdirect_socket_parameters *sp)
@@ -189,14 +189,14 @@ int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
 
 	return 0;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_initial_parameters);
+EXPORT_SYMBOL_GPL(smbdirect_socket_set_initial_parameters);
 
 const struct smbdirect_socket_parameters *
 smbdirect_socket_get_current_parameters(struct smbdirect_socket *sc)
 {
 	return &sc->parameters;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_get_current_parameters);
+EXPORT_SYMBOL_GPL(smbdirect_socket_get_current_parameters);
 
 int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
 					 enum ib_poll_context poll_ctx,
@@ -220,7 +220,7 @@ int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
 
 	return 0;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_kernel_settings);
+EXPORT_SYMBOL_GPL(smbdirect_socket_set_kernel_settings);
 
 void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
 				  void *private_ptr,
@@ -240,7 +240,7 @@ void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
 	sc->logging.needed = needed;
 	sc->logging.vaprintf = vaprintf;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_logging);
+EXPORT_SYMBOL_GPL(smbdirect_socket_set_logging);
 
 static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
 {
@@ -663,13 +663,13 @@ int smbdirect_socket_bind(struct smbdirect_socket *sc, struct sockaddr *addr)
 
 	return 0;
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_bind);
+EXPORT_SYMBOL_GPL(smbdirect_socket_bind);
 
 void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
 {
 	smbdirect_socket_schedule_cleanup_lvl(sc, SMBDIRECT_LOG_INFO, -ESHUTDOWN);
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_shutdown);
+EXPORT_SYMBOL_GPL(smbdirect_socket_shutdown);
 
 static void smbdirect_socket_release_disconnect(struct kref *kref)
 {
@@ -712,7 +712,7 @@ void smbdirect_socket_release(struct smbdirect_socket *sc)
 	 */
 	kref_put(&sc->refs.destroy, smbdirect_socket_release_destroy);
 }
-__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_release);
+EXPORT_SYMBOL_GPL(smbdirect_socket_release);
 
 int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
 				      enum smbdirect_socket_status expected_status,
-- 
2.43.0

