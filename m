Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2367232D447
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093961; cv=none; b=pCvzmcqG3Ex4MbydxNW/N+BDV3B02R4qBNTSFMeZ7hHCJ/Cu+hUEwycl60kcW+odi1lYVvgNIxUNRMor7J3YmQiDWgX86vHsM4ZXMXMoDE+/XDHyGEoct0nrn11EWAgwCa2vnZfRah8eNHsBtibMAHEnejwXUJHHtYmTq0xzgkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093961; c=relaxed/simple;
	bh=uOpuBn40tAba1h1ZOcqK6BICCMaHPZLW5tshqz74uqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teGdc6K6H9BZB063AXr/bmfJBP67k8+U9s+fFp5VUVoWAS2C5lGVqWrA07Q0yhwwGsE1b1LYktphbe79xxkNmTAJqPXI3Q0YdY1kAMC75EOlK+mQjOFOzGUr0u2vJW/Vkr1y2jW4M5JlbCHWxaU1zQHuq2jPUm18UY4r5lo1IYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JKujkI1F; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JKujkI1F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=WTKlRogXAkY0AmY+CxIbr68CLDFidBN0WEKEg1YtkVw=; b=JKujkI1FEZXRFsdEpokFjtzAhK
	KDZZmg6AVsmGUSobPeQIyZ3ltlZpLIGuYgz6KBTa3/KSPizqU3F381m+CQkrjfxsmOlGY7KRib1H0
	PYhyNpy0le1IQvlaPTbhXc9anlnLcBpHe3+hSFhwxJWPs+WYEyjmnvDrhaCn8uGXkPW6clp2Gphyj
	R0hESsJZb+vEXR0ipjP4QzOaiZYRiTdvSWVY6Cx6PpJ5StkabagUBCwTxiyDaJYUr4n17kCE/2giw
	plI5fIKoVITSkGFi+/eVxhLdE3IuxigxEWEUGKvQwsOzpDr3dGNpPifLmGz4yMz1pqKaObVhmfWEq
	Cei44zxIqGZb5ojJIpKiZ6biaKMpKE4++FT28wkuNA+Ea+4R7XdjGBNNuzVD0FF93FuvHthM9mp+v
	MuNLCmMAtUQYlAzxyIYPc0me3dU9bk/Sd37tzdrdBbbbASFY+vPgvnoTJXosi70LoOSFL7XZIV5Jb
	lBQ8cw7a4cTelN6mpybtPjro;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxNL-00FdZ9-2n;
	Tue, 25 Nov 2025 18:02:53 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 059/145] smb: smbdirect: provide explicit prototypes for cross .c file functions
Date: Tue, 25 Nov 2025 18:55:05 +0100
Message-ID: <3e1ec313c12140105147f088b04e31443157b159.1764091285.git.metze@samba.org>
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

These prototypes are used between private .c files,
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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   |  67 ++++++------
 fs/smb/common/smbdirect/smbdirect_internal.h  | 102 ++++++++++++++----
 fs/smb/common/smbdirect/smbdirect_mr.c        |   7 +-
 fs/smb/common/smbdirect/smbdirect_socket.c    |  39 +++----
 4 files changed, 145 insertions(+), 70 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index a2ced59171ac..c9208bdfded5 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -143,8 +143,8 @@ static int smbdirect_connection_rdma_event_handler(struct rdma_cm_id *id,
 	return 0;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
 {
 	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 		"rdma established: device: %.*s local: %pISpsfc remote: %pISpsfc\n",
@@ -157,8 +157,8 @@ static void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
 	sc->rdma.expected_event = RDMA_CM_EVENT_DISCONNECTED;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
 {
 	if (unlikely(sc->first_error))
 		return;
@@ -233,8 +233,8 @@ static u32 smbdirect_rdma_rw_send_wrs(struct ib_device *dev,
 	return factor * attr->cap.max_rdma_ctxs;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_qp_init_attr qp_attr;
@@ -391,7 +391,8 @@ static int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
 	return ret;
 }
 
-static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
 {
 	if (sc->ib.qp) {
 		ib_drain_qp(sc->ib.qp);
@@ -412,8 +413,8 @@ static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
 	}
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	char name[80];
@@ -492,7 +493,8 @@ static int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
 	return -ENOMEM;
 }
 
-static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *recv_io, *next_io;
 
@@ -523,8 +525,8 @@ static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
 	sc->send_io.mem.cache = NULL;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_socket *sc)
 {
 	struct smbdirect_send_io *msg;
 
@@ -538,8 +540,8 @@ static struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdi
 	return msg;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg)
 {
 	struct smbdirect_socket *sc = msg->socket;
 	size_t i;
@@ -570,8 +572,8 @@ static void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg)
 	mempool_free(msg, sc->send_io.mem.pool);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc)
 {
 	struct smbdirect_recv_io *msg = NULL;
 	unsigned long flags;
@@ -590,8 +592,8 @@ static struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdire
 	return msg;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
 {
 	struct smbdirect_socket *sc = msg->socket;
 	unsigned long flags;
@@ -657,11 +659,11 @@ smbdirect_connection_reassembly_first_recv_io(struct smbdirect_socket *sc)
 	return msg;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
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
 
@@ -797,7 +799,8 @@ int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_wait_for_connected);
 
-static void smbdirect_connection_idle_timer_work(struct work_struct *work)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, idle.timer_work.work);
@@ -867,8 +870,9 @@ static bool smbdirect_connection_request_keep_alive(struct smbdirect_socket *sc)
 	return false;
 }
 
-static int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
-					     struct ib_send_wr *wr)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
+				      struct ib_send_wr *wr)
 {
 	int ret;
 
@@ -1342,8 +1346,8 @@ static void smbdirect_connection_send_immediate_work(struct work_struct *work)
 	}
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 {
 	struct smbdirect_socket *sc = msg->socket;
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -1384,8 +1388,8 @@ static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 	return ret;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_recv_io *recv_io =
 		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
@@ -1551,7 +1555,8 @@ static void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc
 	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 }
 
-static int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
 {
 	int missing;
 	int posted = 0;
diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index b61f2473a28b..a2018670749f 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -16,13 +16,27 @@
 #include "smbdirect_public.h"
 #include "smbdirect_socket.h"
 
-static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
-						const char *macro_name,
-						unsigned int lvl,
-						const char *func,
-						unsigned int line,
-						int error,
-						enum smbdirect_socket_status *force_status);
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
+int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
+					 const char *macro_name,
+					 unsigned int lvl,
+					 const char *func,
+					 unsigned int line,
+					 int error,
+					 enum smbdirect_socket_status *force_status);
 #define smbdirect_socket_schedule_cleanup(__sc, __error) \
 	__smbdirect_socket_schedule_cleanup(__sc, \
 		"smbdirect_socket_schedule_cleanup", SMBDIRECT_LOG_ERR, \
@@ -38,21 +52,73 @@ static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 		__func__, __LINE__, __error, &__force_status); \
 } while (0)
 
-static int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
-					     enum smbdirect_socket_status expected_status,
-					     int unexpected_errno,
-					     wait_queue_head_t *waitq,
-					     atomic_t *total_credits,
-					     int needed);
+__SMBDIRECT_PRIVATE__
+void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc);
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
+				      enum smbdirect_socket_status expected_status,
+				      int unexpected_errno,
+				      wait_queue_head_t *waitq,
+				      atomic_t *total_credits,
+				      int needed);
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
+void smbdirect_connection_idle_timer_work(struct work_struct *work);
+
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
+				      struct ib_send_wr *wr);
 
-static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc);
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg);
 
-static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc);
 
-static void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg);
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc);
 
-static void smbdirect_connection_idle_timer_work(struct work_struct *work);
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc);
 
-static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
 
 #endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index c7be46c7ffe4..ad95ee841c14 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -15,8 +15,8 @@ static void smbdirect_connection_mr_io_recovery_work(struct work_struct *work);
  * Recovery is done in smbd_mr_recovery_work. The content of list entry changes
  * as MRs are used and recovered for I/O, but the list links will not change
  */
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_mr_io *mr;
@@ -121,7 +121,8 @@ static void smbdirect_mr_io_free_locked(struct kref *kref)
 	kfree(mr);
 }
 
-static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
 {
 	struct smbdirect_mr_io *mr, *tmp;
 	LIST_HEAD(all_list);
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index e17794999382..35252aa12fe4 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -52,7 +52,8 @@ static int smbdirect_socket_rdma_event_handler(struct rdma_cm_id *id,
 	return -ESTALE;
 }
 
-static int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc)
 {
 	struct rdma_cm_id *id;
 	int ret;
@@ -110,7 +111,8 @@ int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_create_kern);
 
-static int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_socket *sc)
 {
 	smbdirect_socket_init(sc);
 
@@ -295,13 +297,14 @@ static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
 
-static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
-						const char *macro_name,
-						unsigned int lvl,
-						const char *func,
-						unsigned int line,
-						int error,
-						enum smbdirect_socket_status *force_status)
+__SMBDIRECT_PRIVATE__
+void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
+					 const char *macro_name,
+					 unsigned int lvl,
+					 const char *func,
+					 unsigned int line,
+					 int error,
+					 enum smbdirect_socket_status *force_status)
 {
 	struct smbdirect_recv_io *recv_io, *recv_tmp;
 	unsigned long flags;
@@ -593,8 +596,8 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 		"rdma session destroyed\n");
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
+__SMBDIRECT_PRIVATE__
+void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
 {
 	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 		"status=%s first_error=%1pe",
@@ -693,13 +696,13 @@ void smbdirect_socket_release(struct smbdirect_socket *sc)
 }
 __SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_release);
 
-__maybe_unused /* this is temporary while this file is included in others */
-static int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
-					     enum smbdirect_socket_status expected_status,
-					     int unexpected_errno,
-					     wait_queue_head_t *waitq,
-					     atomic_t *total_credits,
-					     int needed)
+__SMBDIRECT_PRIVATE__
+int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
+				      enum smbdirect_socket_status expected_status,
+				      int unexpected_errno,
+				      wait_queue_head_t *waitq,
+				      atomic_t *total_credits,
+				      int needed)
 {
 	int ret;
 
-- 
2.43.0

