Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C657F3321CB
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095630; cv=none; b=Ww61Sv9vRj2l34LQiHMF267oBbAkDpz7NtIJMr0tPopFknazw+zt8zT1hM5JtGOmK+xznxGkw0gspLlB/QRjvCFTZLyWwaWvkHe9FWbysswZv6cwCWHUycujLfhBoHmpr3QdadhguBiy5Qo4Kxv4OCcPKZMWiRQGS25R9VcPzLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095630; c=relaxed/simple;
	bh=OuXFGkllxG14MYI+4YQF0AntGTeRDRg0UbHbwuWu/XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES0MkLNFetZAuD1z8VYYgh4HIwXsjoDnCdKil5P9jXqZTzbJSx9xKrhAJWg5RCB1fTRzWT/IY01JEM9D22FhVBUp+QptT3PG6OwYvGqRp7kTey5TMbICZXLLcrrndxokSvvfDdkmmuKxQ0iq3bCQotjHKd37XHHAlu0ve4INa9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=W8ij/P8t; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="W8ij/P8t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4SvDUMNdXYD7PGRY9eUxoKndGtXx15wyAY6oOU4aauw=; b=W8ij/P8tgDf8A78st1MgW/Ince
	zszVU+DSPZjlsmtsU/HsBbcfGdluBORSfNBdIlyvVIrdtRKmbyJOzWq+QeaiTBKyi1Ufw9pOJ8Gr+
	6xRTlADlXrdSYOhYLUb6IGzyzfCIDsFbH82uTuQHIiJICq2qQoBgsolNtF1yLJ7p1Lz+0IZicuWAf
	RV07wEUU7+8jIaVekai4Nb3UabPT+DuZ0qwiEsKI71qgDvHauvNqQ2dAFLH7TJP5CK8z+8gTJm5ee
	g0imRbm+qsFfxGstIzW06K9X6teuQf4lwda3yPAoY1hAYRE/m5Wli076Sn3f9vpOOZEGah2O2olz1
	UwsZUQJ8QwU/Q8dbwQYfp4nOhagF/D6JOsl3mpnczmMnc9RC4JxIVXn2DZZKNS4flHJmlVHJpJlC6
	wm7MRMU3arTSvdkczAc9Dnyn7TNilqeHmQXOP9jqHDjaI2okKYSqMoLC0R3VT+waVklCRgJa/S2qS
	1H8TQ+ZMDL1lbnCedtiB6G5S;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxnT-00Fg5k-0n;
	Tue, 25 Nov 2025 18:29:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 142/145] smb: smbdirect: introduce smbdirect_socket_{listen,accept}()
Date: Tue, 25 Nov 2025 18:56:28 +0100
Message-ID: <439e17fd3606fb8664cd4d35d86098ff8802cc1f.1764091285.git.metze@samba.org>
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

These will be used by the server soon instead of using
smbdirect_accept_connect_request() together with rdma_listen().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/Makefile              |   1 +
 fs/smb/common/smbdirect/smbdirect_accept.c    | 110 +++++++
 .../common/smbdirect/smbdirect_connection.c   |   9 +
 fs/smb/common/smbdirect/smbdirect_listen.c    | 285 ++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_public.h    |   8 +
 fs/smb/common/smbdirect/smbdirect_socket.c    |  83 ++++-
 fs/smb/common/smbdirect/smbdirect_socket.h    |  40 +++
 7 files changed, 528 insertions(+), 8 deletions(-)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_listen.c

diff --git a/fs/smb/common/smbdirect/Makefile b/fs/smb/common/smbdirect/Makefile
index bae6281fdd39..b41271facfc3 100644
--- a/fs/smb/common/smbdirect/Makefile
+++ b/fs/smb/common/smbdirect/Makefile
@@ -12,5 +12,6 @@ smbdirect-y := \
 	smbdirect_rw.o		\
 	smbdirect_debug.o	\
 	smbdirect_connect.o	\
+	smbdirect_listen.o	\
 	smbdirect_accept.o	\
 	smbdirect_main.o
diff --git a/fs/smb/common/smbdirect/smbdirect_accept.c b/fs/smb/common/smbdirect/smbdirect_accept.c
index d8818a0a8286..73f87093db9b 100644
--- a/fs/smb/common/smbdirect/smbdirect_accept.c
+++ b/fs/smb/common/smbdirect/smbdirect_accept.c
@@ -6,6 +6,7 @@
  */
 
 #include "smbdirect_internal.h"
+#include <net/sock.h>
 
 static int smbdirect_accept_rdma_event_handler(struct rdma_cm_id *id,
 					       struct rdma_cm_event *event);
@@ -393,6 +394,28 @@ static void smbdirect_accept_negotiate_recv_work(struct work_struct *work)
 	 */
 	sp->max_fragmented_send_size = max_fragmented_size;
 
+	if (sc->accept.listener) {
+		struct smbdirect_socket *lsc = sc->accept.listener;
+		unsigned long flags;
+
+		spin_lock_irqsave(&lsc->listen.lock, flags);
+		list_del(&sc->accept.list);
+		list_add_tail(&sc->accept.list, &lsc->listen.ready);
+		wake_up(&lsc->listen.wait_queue);
+		spin_unlock_irqrestore(&lsc->listen.lock, flags);
+
+		/*
+		 * smbdirect_socket_accept() will call
+		 * smbdirect_accept_negotiate_finish(nsc, 0);
+		 *
+		 * So that we don't send the negotiation
+		 * response that grants credits to the peer
+		 * before the socket is accepted by the
+		 * application.
+		 */
+		return;
+	}
+
 	ntstatus = 0; /* NT_STATUS_OK */
 
 not_supported:
@@ -677,3 +700,90 @@ static int smbdirect_accept_rdma_event_handler(struct rdma_cm_id *id,
 	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 	return 0;
 }
+
+static long smbdirect_socket_wait_for_accept(struct smbdirect_socket *lsc, long timeo)
+{
+	long ret;
+
+	ret = wait_event_interruptible_timeout(lsc->listen.wait_queue,
+					       !list_empty_careful(&lsc->listen.ready) ||
+					       lsc->status != SMBDIRECT_SOCKET_LISTENING ||
+					       lsc->first_error,
+					       timeo);
+	if (lsc->status != SMBDIRECT_SOCKET_LISTENING)
+		return -EINVAL;
+	if (lsc->first_error)
+		return lsc->first_error;
+	if (!ret)
+		ret = -ETIMEDOUT;
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+__SMBDIRECT_PUBLIC__
+struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
+						 long timeo,
+						 struct proto_accept_arg *arg)
+{
+	struct smbdirect_socket *nsc;
+	unsigned long flags;
+
+	if (lsc->status != SMBDIRECT_SOCKET_LISTENING) {
+		arg->err = -EINVAL;
+		return NULL;
+	}
+
+	if (lsc->first_error) {
+		arg->err = lsc->first_error;
+		return NULL;
+	}
+
+	if (list_empty_careful(&lsc->listen.ready)) {
+		int ret;
+
+		if (timeo == 0) {
+			arg->err = -EAGAIN;
+			return NULL;
+		}
+
+		ret = smbdirect_socket_wait_for_accept(lsc, timeo);
+		if (ret) {
+			arg->err = ret;
+			return NULL;
+		}
+	}
+
+	spin_lock_irqsave(&lsc->listen.lock, flags);
+	nsc = list_first_entry_or_null(&lsc->listen.ready,
+				       struct smbdirect_socket,
+				       accept.list);
+	if (nsc) {
+		nsc->accept.listener = NULL;
+		list_del_init_careful(&nsc->accept.list);
+		arg->is_empty = list_empty_careful(&lsc->listen.ready);
+	}
+	spin_unlock_irqrestore(&lsc->listen.lock, flags);
+	if (!nsc) {
+		arg->err = -EAGAIN;
+		return NULL;
+	}
+
+	/*
+	 * We did not send the negotiation response
+	 * yet, so we did not grant any credits to the client,
+	 * so it didn't grant any credits to us.
+	 *
+	 * The caller expects a connected socket
+	 * now as there are no credits anyway.
+	 *
+	 * Then we send the negotiation response in
+	 * order to grant credits to the peer.
+	 */
+	nsc->status = SMBDIRECT_SOCKET_CONNECTED;
+	smbdirect_accept_negotiate_finish(nsc, 0);
+
+	return nsc;
+}
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_accept);
diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 31db64550424..ff38c83a61c3 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -163,6 +163,14 @@ void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
 	if (unlikely(sc->first_error))
 		return;
 
+	if (sc->status == SMBDIRECT_SOCKET_CONNECTED)
+		/*
+		 * This is the accept case where
+		 * smbdirect_socket_accept() already sets
+		 * SMBDIRECT_SOCKET_CONNECTED
+		 */
+		goto done;
+
 	if (sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING) {
 		/*
 		 * Something went wrong...
@@ -189,6 +197,7 @@ void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
 	 * We need to setup the refill and send immediate work
 	 * in order to get a working connection.
 	 */
+done:
 	INIT_WORK(&sc->recv_io.posted.refill_work, smbdirect_connection_recv_io_refill_work);
 	INIT_WORK(&sc->idle.immediate_work, smbdirect_connection_send_immediate_work);
 
diff --git a/fs/smb/common/smbdirect/smbdirect_listen.c b/fs/smb/common/smbdirect/smbdirect_listen.c
new file mode 100644
index 000000000000..dcbf1b817e2b
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_listen.c
@@ -0,0 +1,285 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *   Copyright (C) 2018, LG Electronics.
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+#include "smbdirect_internal.h"
+
+static int smbdirect_listen_rdma_event_handler(struct rdma_cm_id *id,
+					       struct rdma_cm_event *event);
+
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_listen(struct smbdirect_socket *sc, int backlog)
+{
+	int ret;
+
+	if (backlog < 0)
+		return -EINVAL;
+	if (!backlog)
+		backlog = 1; /* use 1 as default for now */
+
+	if (sc->first_error)
+		return -EINVAL;
+
+	if (sc->status != SMBDIRECT_SOCKET_CREATED)
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(!sc->rdma.cm_id))
+		return -EINVAL;
+
+	if (sc->rdma.cm_id->device)
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"try to listen on addr: %pISpsfc dev: %.*s\n",
+			&sc->rdma.cm_id->route.addr.src_addr,
+			IB_DEVICE_NAME_MAX,
+			sc->rdma.cm_id->device->name);
+	else
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"try to listen on addr: %pISpsfc\n",
+			&sc->rdma.cm_id->route.addr.src_addr);
+
+	/* already checked above */
+	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED);
+	sc->status = SMBDIRECT_SOCKET_LISTENING;
+	sc->rdma.expected_event = RDMA_CM_EVENT_CONNECT_REQUEST;
+	rdma_lock_handler(sc->rdma.cm_id);
+	sc->rdma.cm_id->event_handler = smbdirect_listen_rdma_event_handler;
+	rdma_unlock_handler(sc->rdma.cm_id);
+
+	ret = rdma_listen(sc->rdma.cm_id, backlog);
+	if (ret) {
+		sc->first_error = ret;
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		if (sc->rdma.cm_id->device)
+			smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+				"listening failed %1pe on addr: %pISpsfc dev: %.*s\n",
+				SMBDIRECT_DEBUG_ERR_PTR(ret),
+				&sc->rdma.cm_id->route.addr.src_addr,
+				IB_DEVICE_NAME_MAX,
+				sc->rdma.cm_id->device->name);
+		else
+			smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+				"listening failed %1pe on addr: %pISpsfc\n",
+				SMBDIRECT_DEBUG_ERR_PTR(ret),
+				&sc->rdma.cm_id->route.addr.src_addr);
+		return ret;
+	}
+
+	/*
+	 * This is a value > 0, checked above,
+	 * so we are able to use sc->listen.backlog == -1,
+	 * as indication that the socket was never
+	 * a listener.
+	 */
+	sc->listen.backlog = backlog;
+
+	if (sc->rdma.cm_id->device)
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"listening on addr: %pISpsfc dev: %.*s\n",
+			&sc->rdma.cm_id->route.addr.src_addr,
+			IB_DEVICE_NAME_MAX,
+			sc->rdma.cm_id->device->name);
+	else
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"listening on addr: %pISpsfc\n",
+			&sc->rdma.cm_id->route.addr.src_addr);
+
+	/*
+	 * The rest happens async via smbdirect_listen_rdma_event_handler()
+	 */
+	return 0;
+}
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_listen);
+
+static int smbdirect_new_rdma_event_handler(struct rdma_cm_id *new_id,
+					    struct rdma_cm_event *event)
+{
+	int ret = -ESTALE;
+
+	/*
+	 * This should be replaced before any real work
+	 * starts! So it should never be called!
+	 */
+
+	if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
+		ret = -ENETDOWN;
+	if (IS_ERR(SMBDIRECT_DEBUG_ERR_PTR(event->status)))
+		ret = event->status;
+	WARN_ONCE(1,
+		  "%s should not be called! event=%s status=%d => ret=%1pe\n",
+		  __func__,
+		  rdma_event_msg(event->event),
+		  event->status,
+		  SMBDIRECT_DEBUG_ERR_PTR(ret));
+	return -ESTALE;
+}
+
+static int smbdirect_listen_connect_request(struct smbdirect_socket *lsc,
+					    struct rdma_cm_id *new_id,
+					    const struct rdma_cm_event *event);
+
+static int smbdirect_listen_rdma_event_handler(struct rdma_cm_id *new_id,
+					       struct rdma_cm_event *event)
+{
+	struct smbdirect_socket *lsc = new_id->context;
+	int ret;
+
+	if (event->event == RDMA_CM_EVENT_CONNECT_REQUEST) {
+		new_id->context = NULL;
+		new_id->event_handler = smbdirect_new_rdma_event_handler;
+	} else
+		new_id = NULL;
+
+	/*
+	 * cma_cm_event_handler() has
+	 * lockdep_assert_held(&id_priv->handler_mutex);
+	 *
+	 * Mutexes are not allowed in interrupts,
+	 * and we rely on not being in an interrupt here,
+	 * as we might sleep.
+	 */
+	WARN_ON_ONCE(in_interrupt());
+
+	if (event->status || event->event != lsc->rdma.expected_event) {
+		ret = -ECONNABORTED;
+
+		if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
+			ret = -ENETDOWN;
+		if (IS_ERR(SMBDIRECT_DEBUG_ERR_PTR(event->status)))
+			ret = event->status;
+
+		smbdirect_log_rdma_event(lsc, SMBDIRECT_LOG_ERR,
+			"%s (first_error=%1pe, expected=%s) => event=%s status=%d => ret=%1pe\n",
+			smbdirect_socket_status_string(lsc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(lsc->first_error),
+			rdma_event_msg(lsc->rdma.expected_event),
+			rdma_event_msg(event->event),
+			event->status,
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+
+		/*
+		 * In case of error return it and let the caller
+		 * destroy new_id
+		 */
+		smbdirect_socket_schedule_cleanup(lsc, ret);
+		return new_id ? ret : 0;
+	}
+
+	smbdirect_log_rdma_event(lsc, SMBDIRECT_LOG_INFO,
+		"%s (first_error=%1pe) event=%s\n",
+		smbdirect_socket_status_string(lsc->status),
+		SMBDIRECT_DEBUG_ERR_PTR(lsc->first_error),
+		rdma_event_msg(event->event));
+
+	/*
+	 * In case of error return it and let the caller
+	 * destroy new_id
+	 */
+	if (lsc->first_error)
+		return new_id ? lsc->first_error : 0;
+
+	switch (event->event) {
+	case RDMA_CM_EVENT_CONNECT_REQUEST:
+		WARN_ON_ONCE(lsc->status != SMBDIRECT_SOCKET_LISTENING);
+
+		/*
+		 * In case of error return it and let the caller
+		 * destroy new_id
+		 */
+		ret = smbdirect_listen_connect_request(lsc, new_id, event);
+		if (ret)
+			return ret;
+		return 0;
+
+	default:
+		break;
+	}
+
+	/*
+	 * This is an internal error
+	 */
+	WARN_ON_ONCE(lsc->rdma.expected_event != RDMA_CM_EVENT_CONNECT_REQUEST);
+	smbdirect_socket_schedule_cleanup(lsc, -EINVAL);
+	return 0;
+}
+
+static int smbdirect_listen_connect_request(struct smbdirect_socket *lsc,
+					    struct rdma_cm_id *new_id,
+					    const struct rdma_cm_event *event)
+{
+	struct smbdirect_socket *nsc;
+	unsigned long flags;
+	size_t backlog = max_t(size_t, 1, lsc->listen.backlog);
+	size_t psockets;
+	size_t rsockets;
+	int ret;
+
+	if (!smbdirect_frwr_is_supported(&new_id->device->attrs)) {
+		smbdirect_log_rdma_event(lsc, SMBDIRECT_LOG_ERR,
+			"Fast Registration Work Requests (FRWR) is not supported device %.*s\n",
+			IB_DEVICE_NAME_MAX,
+			new_id->device->name);
+		smbdirect_log_rdma_event(lsc, SMBDIRECT_LOG_ERR,
+			"Device capability flags = %llx max_fast_reg_page_list_len = %u\n",
+			new_id->device->attrs.device_cap_flags,
+			new_id->device->attrs.max_fast_reg_page_list_len);
+		return -EPROTONOSUPPORT;
+	}
+
+	spin_lock_irqsave(&lsc->listen.lock, flags);
+	psockets = list_count_nodes(&lsc->listen.pending);
+	rsockets = list_count_nodes(&lsc->listen.ready);
+	spin_unlock_irqrestore(&lsc->listen.lock, flags);
+
+	if (psockets > backlog ||
+	    rsockets > backlog ||
+	    (psockets + rsockets) > backlog) {
+		smbdirect_log_rdma_event(lsc, SMBDIRECT_LOG_ERR,
+			"Backlog[%d][%zu] full pending[%zu] ready[%zu]\n",
+			lsc->listen.backlog, backlog, psockets, rsockets);
+		return -EBUSY;
+	}
+
+	ret = smbdirect_socket_create_accepting(new_id, &nsc);
+	if (ret)
+		goto socket_init_failed;
+
+	nsc->logging = lsc->logging;
+	ret = smbdirect_socket_set_initial_parameters(nsc, &lsc->parameters);
+	if (ret)
+		goto set_params_failed;
+	ret = smbdirect_socket_set_kernel_settings(nsc,
+						   lsc->ib.poll_ctx,
+						   lsc->send_io.mem.gfp_mask);
+	if (ret)
+		goto set_settings_failed;
+
+	spin_lock_irqsave(&lsc->listen.lock, flags);
+	list_add_tail(&nsc->accept.list, &lsc->listen.pending);
+	nsc->accept.listener = lsc;
+	spin_unlock_irqrestore(&lsc->listen.lock, flags);
+
+	ret = smbdirect_accept_connect_request(nsc, &event->param.conn);
+	if (ret)
+		goto accept_connect_failed;
+
+	return 0;
+
+accept_connect_failed:
+	spin_lock_irqsave(&lsc->listen.lock, flags);
+	list_del_init(&nsc->accept.list);
+	nsc->accept.listener = NULL;
+	spin_unlock_irqrestore(&lsc->listen.lock, flags);
+set_settings_failed:
+set_params_failed:
+	/*
+	 * The caller will destroy new_id
+	 */
+	nsc->ib.dev = NULL;
+	nsc->rdma.cm_id = NULL;
+	smbdirect_socket_release(nsc);
+socket_init_failed:
+	return ret;
+}
diff --git a/fs/smb/common/smbdirect/smbdirect_public.h b/fs/smb/common/smbdirect/smbdirect_public.h
index 7404f7e5bf52..c3647c6121ce 100644
--- a/fs/smb/common/smbdirect/smbdirect_public.h
+++ b/fs/smb/common/smbdirect/smbdirect_public.h
@@ -124,10 +124,18 @@ __SMBDIRECT_PUBLIC__
 int smbdirect_connect_sync(struct smbdirect_socket *sc,
 			   const struct sockaddr *dst);
 
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_listen(struct smbdirect_socket *sc, int backlog);
+
 __SMBDIRECT_PUBLIC__
 int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
 				     const struct rdma_conn_param *param);
 
+__SMBDIRECT_PUBLIC__
+struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
+						 long timeo,
+						 struct proto_accept_arg *arg);
+
 __SMBDIRECT_PUBLIC__
 int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
 				   void *buf, size_t buf_len,
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index b04ee8f2bd2a..ac677f1961e9 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -292,6 +292,7 @@ static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
 	 * in order to notice the broken connection.
 	 */
 	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->listen.wait_queue);
 	wake_up_all(&sc->send_io.lcredits.wait_queue);
 	wake_up_all(&sc->send_io.credits.wait_queue);
 	wake_up_all(&sc->send_io.pending.dec_wait_queue);
@@ -312,6 +313,7 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 					 enum smbdirect_socket_status *force_status)
 {
 	struct smbdirect_recv_io *recv_io, *recv_tmp;
+	struct smbdirect_socket *psc, *tsc;
 	unsigned long flags;
 	bool was_first = false;
 
@@ -358,6 +360,18 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 		disable_work(&recv_io->complex_work);
 	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
 
+	/*
+	 * In case we were a listener we need to
+	 * disconnect all pending and ready sockets
+	 *
+	 * First we move ready sockets to pending again.
+	 */
+	spin_lock_irqsave(&sc->listen.lock, flags);
+	list_splice_init(&sc->listen.ready, &sc->listen.pending);
+	list_for_each_entry_safe(psc, tsc, &sc->listen.pending, accept.list)
+		smbdirect_socket_schedule_cleanup(psc, sc->first_error);
+	spin_unlock_irqrestore(&sc->listen.lock, flags);
+
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
 	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
@@ -393,6 +407,7 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 		break;
 
 	case SMBDIRECT_SOCKET_CREATED:
+	case SMBDIRECT_SOCKET_LISTENING:
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
 		break;
 
@@ -418,6 +433,7 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, disconnect_work);
 	struct smbdirect_recv_io *recv_io, *recv_tmp;
+	struct smbdirect_socket *psc, *tsc;
 	unsigned long flags;
 
 	/*
@@ -459,6 +475,18 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 		disable_work(&recv_io->complex_work);
 	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
 
+	/*
+	 * In case we were a listener we need to
+	 * disconnect all pending and ready sockets
+	 *
+	 * First we move ready sockets to pending again.
+	 */
+	spin_lock_irqsave(&sc->listen.lock, flags);
+	list_splice_init(&sc->listen.ready, &sc->listen.pending);
+	list_for_each_entry_safe(psc, tsc, &sc->listen.pending, accept.list)
+		smbdirect_socket_schedule_cleanup(psc, sc->first_error);
+	spin_unlock_irqrestore(&sc->listen.lock, flags);
+
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
 	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
@@ -483,6 +511,7 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 		break;
 
 	case SMBDIRECT_SOCKET_CREATED:
+	case SMBDIRECT_SOCKET_LISTENING:
 	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
 	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
 	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
@@ -514,6 +543,8 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 
 static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 {
+	struct smbdirect_socket *psc, *tsc;
+	size_t psockets;
 	struct smbdirect_recv_io *recv_io;
 	struct smbdirect_recv_io *recv_tmp;
 	LIST_HEAD(all_list);
@@ -537,6 +568,14 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 		  smbdirect_socket_status_string(sc->status),
 		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
 
+	/*
+	 * The listener should clear this before we reach this
+	 */
+	WARN_ONCE(sc->accept.listener,
+		  "status=%s first_error=%1pe",
+		  smbdirect_socket_status_string(sc->status),
+		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+
 	/*
 	 * Wake up all waiters in all wait queues
 	 * in order to notice the broken connection.
@@ -579,9 +618,34 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 		ib_drain_qp(sc->ib.qp);
 	}
 
+	/*
+	 * In case we were a listener we need to
+	 * disconnect all pending and ready sockets
+	 *
+	 * We move ready sockets to pending again.
+	 */
+	spin_lock_irqsave(&sc->listen.lock, flags);
+	list_splice_tail_init(&sc->listen.ready, &all_list);
+	list_splice_tail_init(&sc->listen.pending, &all_list);
+	spin_unlock_irqrestore(&sc->listen.lock, flags);
+	psockets = list_count_nodes(&all_list);
+	if (sc->listen.backlog != -1) /* was a listener */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"release %zu pending sockets\n", psockets);
+	list_for_each_entry_safe(psc, tsc, &all_list, accept.list) {
+		list_del_init(&psc->accept.list);
+		psc->accept.listener = NULL;
+		smbdirect_socket_release(psc);
+	}
+	if (sc->listen.backlog != -1) /* was a listener */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"released %zu pending sockets\n", psockets);
+	INIT_LIST_HEAD(&all_list);
+
 	/* It's not possible for upper layer to get to reassembly */
-	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
-		"drain the reassembly queue\n");
+	if (sc->listen.backlog == -1) /* was not a listener */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"drain the reassembly queue\n");
 	spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
 	list_splice_tail_init(&sc->recv_io.reassembly.list, &all_list);
 	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
@@ -589,12 +653,14 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 		smbdirect_connection_put_recv_io(recv_io);
 	sc->recv_io.reassembly.data_length = 0;
 
-	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
-		"freeing mr list\n");
+	if (sc->listen.backlog == -1) /* was not a listener */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"freeing mr list\n");
 	smbdirect_connection_destroy_mr_list(sc);
 
-	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
-		"destroying qp\n");
+	if (sc->listen.backlog == -1) /* was not a listener */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"destroying qp\n");
 	smbdirect_connection_destroy_qp(sc);
 	if (sc->rdma.cm_id) {
 		rdma_unlock_handler(sc->rdma.cm_id);
@@ -604,8 +670,9 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 		sc->rdma.cm_id = NULL;
 	}
 
-	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
-		"destroying mem pools\n");
+	if (sc->listen.backlog == -1) /* was not a listener */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"destroying mem pools\n");
 	smbdirect_connection_destroy_mem_pools(sc);
 
 	sc->status = SMBDIRECT_SOCKET_DESTROYED;
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index beb318463a68..8d56486197c5 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -17,6 +17,7 @@
 
 enum smbdirect_socket_status {
 	SMBDIRECT_SOCKET_CREATED,
+	SMBDIRECT_SOCKET_LISTENING,
 	SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED,
 	SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING,
 	SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED,
@@ -42,6 +43,8 @@ const char *smbdirect_socket_status_string(enum smbdirect_socket_status status)
 	switch (status) {
 	case SMBDIRECT_SOCKET_CREATED:
 		return "CREATED";
+	case SMBDIRECT_SOCKET_LISTENING:
+		return "LISTENING";
 	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
 		return "RESOLVE_ADDR_NEEDED";
 	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
@@ -190,6 +193,35 @@ struct smbdirect_socket {
 		struct delayed_work timer_work;
 	} idle;
 
+	/*
+	 * The state for listen sockets
+	 */
+	struct {
+		spinlock_t lock;
+		struct list_head pending;
+		struct list_head ready;
+		wait_queue_head_t wait_queue;
+		/*
+		 * This starts as -1 and a value != -1
+		 * means this socket was in LISTENING state
+		 * before. Note the valid backlog can
+		 * only be > 0.
+		 */
+		int backlog;
+	} listen;
+
+	/*
+	 * The state for sockets waiting
+	 * for accept, either still waiting
+	 * for the negotiation to finish
+	 * or already ready with a usable
+	 * connection.
+	 */
+	struct {
+		struct smbdirect_socket *listener;
+		struct list_head list;
+	} accept;
+
 	/*
 	 * The state for posted send buffers
 	 */
@@ -540,6 +572,14 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
 
+	spin_lock_init(&sc->listen.lock);
+	INIT_LIST_HEAD(&sc->listen.pending);
+	INIT_LIST_HEAD(&sc->listen.ready);
+	sc->listen.backlog = -1; /* not a listener */
+	init_waitqueue_head(&sc->listen.wait_queue);
+
+	INIT_LIST_HEAD(&sc->accept.list);
+
 	sc->send_io.mem.gfp_mask = GFP_KERNEL;
 
 	atomic_set(&sc->send_io.lcredits.count, 0);
-- 
2.43.0

