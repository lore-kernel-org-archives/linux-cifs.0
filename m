Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D89306D26
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744475; cv=none; b=STGjW2EMgdRpXbhDpOjjJtj/O2IIIOmbKddERbKW/rdsnrvOpj6wHqhrBZwYnE/lKihhIDxjNcSN8McMqOztFF2r5ni61MJkYef7HZA70wrMF/S+DUUFHAqIiXfissbrryvmoZsIXnnqkrG1RImbj2QozoeeBDA7UiGnxax2RxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744475; c=relaxed/simple;
	bh=tlaWntVb1nCFIVc0XbWJnucsTzxjkBDDDYP2gOLHv/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBpYHmMT/eW+M4hpcnkCYpHRBCDDBoI9YWuLrHeXVnlEPhkZU/pSPNI2e2/KixVyMBx2fi8cxXosF/YOju3Declw068bSAnvHkRz4L4EoKH3hR40mGOdaCOZh4TIn71UEe/p7W5L1F9aZGFUa2WfegfLvUrRC5BQSJwYmj92Y3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JMyW+kcc; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JMyW+kcc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vPR/bLXD5G5fTden8umTROj7M3Dkf/4+zf10Uk57r14=; b=JMyW+kccZEfQTYLNK6070sFY77
	h3PpKMpQz6cbdpHGKgApT6QBtzEyfNDUXm5j0dBDUUvGPW1MlCWS9aV21sITMmyqdvi9Us5jP5YyQ
	Et/HOp6evfUZz5CQahPc9a6BggXKNa8s/0FMFMqkQQ5W3+axZe/rumAYPV5BBBQmvp6a7/NLOXY4i
	7S9Fo7n5ENQUGlLb/YCb2UdhOG+lmdRq0FGfWQr8AxRS0NK7o4F0Q69z0YP65ysiau5xJrdKFhBtp
	8R9FiQ0TvPEzLFDrs2Ofe47hlzcT+gaoUA4i3fbjfZcPFEwCrqOFTzZvjj2x2c4nJiJNgPX2OnjcA
	qh59nDpH/cH2btusJpym0xUUqNk7UGXEsM9BBN7x9wOn8Bci/POj1bm2OBjkJOhI6+cV9yQYX2Oiy
	Y6rsWXZHWKKBmAFuwS+lRrRK2AtELQ0gLakz9TOnAs6ldaMpZd4SpZtqVHlNKPasKEYq5ljirqUu/
	Fc76kg4ya8WUGHJvMkCEytIc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6DN-00Bc0Y-1T;
	Wed, 29 Oct 2025 13:27:50 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 054/127] smb: smbdirect: introduce smbdirect_public.h with prototypes
Date: Wed, 29 Oct 2025 14:20:32 +0100
Message-ID: <3cd3bf0806a5becccb3be1adebeed6ba4e02fe8c.1761742839.git.metze@samba.org>
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
---
 fs/smb/common/smbdirect/smbdirect_accept.c    |   7 +-
 fs/smb/common/smbdirect/smbdirect_connect.c   |  13 +-
 .../common/smbdirect/smbdirect_connection.c   | 133 ++++++++-------
 fs/smb/common/smbdirect/smbdirect_debug.c     |   9 +-
 fs/smb/common/smbdirect/smbdirect_internal.h  |   1 +
 fs/smb/common/smbdirect/smbdirect_mr.c        |  17 +-
 fs/smb/common/smbdirect/smbdirect_public.h    | 154 ++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_rw.c        |  13 +-
 fs/smb/common/smbdirect/smbdirect_socket.h    |  14 --
 9 files changed, 263 insertions(+), 98 deletions(-)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_public.h

diff --git a/fs/smb/common/smbdirect/smbdirect_accept.c b/fs/smb/common/smbdirect/smbdirect_accept.c
index c44f89f9389f..0ed3f43a7397 100644
--- a/fs/smb/common/smbdirect/smbdirect_accept.c
+++ b/fs/smb/common/smbdirect/smbdirect_accept.c
@@ -13,9 +13,9 @@ static int smbdirect_accept_init_params(struct smbdirect_socket *sc);
 static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void smbdirect_accept_negotiate_send_done(struct ib_cq *cq, struct ib_wc *wc);
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
-					    const struct rdma_conn_param *param)
+__SMBDIRECT_PUBLIC__
+int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
+				     const struct rdma_conn_param *param)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_recv_io *recv_io;
@@ -154,6 +154,7 @@ static int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
 init_params_failed:
 	return ret;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_accept_connect_request);
 
 static int smbdirect_accept_init_params(struct smbdirect_socket *sc)
 {
diff --git a/fs/smb/common/smbdirect/smbdirect_connect.c b/fs/smb/common/smbdirect/smbdirect_connect.c
index 458566c99d2e..eb8e903c9fce 100644
--- a/fs/smb/common/smbdirect/smbdirect_connect.c
+++ b/fs/smb/common/smbdirect/smbdirect_connect.c
@@ -15,9 +15,8 @@ static int smbdirect_connect_negotiate_start(struct smbdirect_socket *sc);
 static void smbdirect_connect_negotiate_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 
-__maybe_unused /* this is temporary while this file is included in orders */
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
@@ -770,9 +770,9 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
 	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_connect_sync(struct smbdirect_socket *sc,
-				  const struct sockaddr *dst)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connect_sync(struct smbdirect_socket *sc,
+			   const struct sockaddr *dst)
 {
 	int ret;
 
@@ -794,3 +794,4 @@ static int smbdirect_connect_sync(struct smbdirect_socket *sc,
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connect_sync);
diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index de87acdaf595..b102e8014fe7 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -28,8 +28,8 @@ static void smbdirect_connection_send_immediate_work(struct work_struct *work);
 
 static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
+__SMBDIRECT_PUBLIC__
+bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 {
 	/*
 	 * Test if FRWR (Fast Registration Work Requests) is supported on the
@@ -43,6 +43,7 @@ static bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 		return false;
 	return true;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_frwr_is_supported);
 
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
@@ -117,8 +118,8 @@ static int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *s
 	return 0;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc)
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket **_sc)
 {
 	struct smbdirect_socket *sc;
 	int ret;
@@ -142,6 +143,7 @@ static int smbdirect_socket_create_kern(struct net *net, struct smbdirect_socket
 alloc_failed:
 	return ret;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_create_kern);
 
 static int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_socket *sc)
 {
@@ -158,8 +160,8 @@ static int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdire
 	return 0;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdirect_socket **_sc)
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdirect_socket **_sc)
 {
 	struct smbdirect_socket *sc;
 	int ret;
@@ -183,10 +185,11 @@ static int smbdirect_socket_create_accepting(struct rdma_cm_id *id, struct smbdi
 alloc_failed:
 	return ret;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_create_accepting);
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
-						   const struct smbdirect_socket_parameters *sp)
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
+					    const struct smbdirect_socket_parameters *sp)
 {
 	/*
 	 * This is only allowed before connect or accept
@@ -208,18 +211,20 @@ static int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_initial_parameters);
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static const struct smbdirect_socket_parameters *
+__SMBDIRECT_PUBLIC__
+const struct smbdirect_socket_parameters *
 smbdirect_socket_get_current_parameters(struct smbdirect_socket *sc)
 {
 	return &sc->parameters;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_get_current_parameters);
 
-__maybe_unused /* this is temporary while this file is included in orders */
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
@@ -239,10 +244,11 @@ static int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_kernel_settings);
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
-						 struct workqueue_struct *workqueue)
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
+					  struct workqueue_struct *workqueue)
 {
 	/*
 	 * This is only allowed before connect or accept
@@ -261,26 +267,28 @@ static int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
 
 	return 0;
 }
-
-__maybe_unused /* this is temporary while this file is included in orders */
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
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_set_custom_workqueue);
+
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
 
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_connection_wake_up_all(struct smbdirect_socket *sc)
@@ -1095,16 +1103,17 @@ static void smbdirect_connection_disconnect_work(struct work_struct *work)
 	smbdirect_connection_wake_up_all(sc);
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static bool smbdirect_connection_is_connected(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+bool smbdirect_connection_is_connected(struct smbdirect_socket *sc)
 {
 	if (unlikely(!sc || sc->first_error || sc->status != SMBDIRECT_SOCKET_CONNECTED))
 		return false;
 	return true;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_is_connected);
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	union {
@@ -1170,6 +1179,7 @@ static int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_wait_for_connected);
 
 static void smbdirect_connection_destroy(struct smbdirect_socket *sc)
 {
@@ -1295,11 +1305,12 @@ static void smbdirect_connection_destroy_sync(struct smbdirect_socket *sc)
 		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
 {
 	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_shutdown);
 
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_socket_release_disconnect(struct kref *kref)
@@ -1327,8 +1338,8 @@ static void smbdirect_socket_release_destroy(struct kref *kref)
 	kfree(sc);
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_socket_release(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+void smbdirect_socket_release(struct smbdirect_socket *sc)
 {
 	/*
 	 * We expect only 1 disconnect reference
@@ -1344,6 +1355,7 @@ static void smbdirect_socket_release(struct smbdirect_socket *sc)
 	 */
 	kref_put(&sc->refs.destroy, smbdirect_socket_release_destroy);
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_release);
 
 static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
@@ -1600,11 +1612,12 @@ static int smbdirect_connection_post_send_io(struct smbdirect_socket *sc,
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
@@ -1735,9 +1748,10 @@ static int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
 lcredit_failed:
 	return ret;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_single_iter);
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
 {
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
@@ -1760,13 +1774,14 @@ static int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *
 
 	return 0;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_wait_zero_pending);
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
-					  struct iov_iter *iter,
-					  unsigned int flags,
-					  bool need_invalidate,
-					  unsigned int remote_key)
+__SMBDIRECT_PUBLIC__
+int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
+				   struct iov_iter *iter,
+				   unsigned int flags,
+				   bool need_invalidate,
+				   unsigned int remote_key)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_send_batch batch;
@@ -1845,6 +1860,7 @@ static int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
 
 	return total_count;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_send_iter);
 
 static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
@@ -2223,10 +2239,10 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 	}
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
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
@@ -2373,6 +2389,7 @@ static int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
 
 	goto again;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_recvmsg);
 
 static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
 					   struct page *page, size_t off, size_t len)
diff --git a/fs/smb/common/smbdirect/smbdirect_debug.c b/fs/smb/common/smbdirect/smbdirect_debug.c
index e7258e0d28a6..eac924164fd4 100644
--- a/fs/smb/common/smbdirect/smbdirect_debug.c
+++ b/fs/smb/common/smbdirect/smbdirect_debug.c
@@ -7,10 +7,10 @@
 #include "smbdirect_internal.h"
 #include <linux/seq_file.h>
 
-__maybe_unused /* this is temporary while this file is included in orders */
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
index f8fabddc3808..348de3ec92b4 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -13,6 +13,7 @@
 #include <linux/errname.h>
 #include "smbdirect.h"
 #include "smbdirect_pdu.h"
+#include "smbdirect_public.h"
 #include "smbdirect_socket.h"
 
 #endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index bca58eee783b..b4b43df50096 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -331,8 +331,8 @@ static int smbdirect_iter_to_sgt(struct iov_iter *iter,
  * need_invalidate: true if this MR needs to be locally invalidated after I/O
  * return value: the MR registered, NULL if failed.
  */
-__maybe_unused /* this is temporary while this file is included in orders */
-static struct smbdirect_mr_io *
+__SMBDIRECT_PUBLIC__
+struct smbdirect_mr_io *
 smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
 				    bool writing,
@@ -453,10 +453,11 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		mutex_unlock(&mr->mutex);
 	return NULL;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_register_mr_io);
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
-						   struct smbdirect_buffer_descriptor_v1 *v1)
+__SMBDIRECT_PUBLIC__
+void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
+					    struct smbdirect_buffer_descriptor_v1 *v1)
 {
 	mutex_lock(&mr->mutex);
 	if (mr->state == SMBDIRECT_MR_REGISTERED) {
@@ -470,6 +471,7 @@ static void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 	}
 	mutex_unlock(&mr->mutex);
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_mr_io_fill_buffer_descriptor);
 
 /*
  * Deregister a MR after I/O is done
@@ -477,8 +479,8 @@ static void smbdirect_mr_io_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
  * and we have to locally invalidate the buffer to prevent data is being
  * modified by remote peer after upper layer consumes it
  */
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
+__SMBDIRECT_PUBLIC__
+void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 {
 	struct smbdirect_socket *sc = mr->socket;
 	int ret = 0;
@@ -560,3 +562,4 @@ static void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
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
index 2f6a1e34e665..245d0d04bfc1 100644
--- a/fs/smb/common/smbdirect/smbdirect_rw.c
+++ b/fs/smb/common/smbdirect/smbdirect_rw.c
@@ -103,12 +103,12 @@ static void smbdirect_connection_rdma_write_done(struct ib_cq *cq, struct ib_wc
 	smbdirect_connection_rdma_rw_done(cq, wc, DMA_TO_DEVICE);
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
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
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	enum dma_data_direction direction = is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
@@ -251,3 +251,4 @@ static int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
 	kfree(msg);
 	goto out;
 }
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_rdma_xmit);
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index e44ab31ee852..65f25fc4b4a7 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -379,20 +379,6 @@ struct smbdirect_socket {
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

