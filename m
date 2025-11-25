Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB441C5D72
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093741; cv=none; b=IJsB+BdApA60yWnOHpUxq8LVga2KzvdedjbLKQHHRzqoCZy1fHSkJyIdKEO/YRGUt1WsTd2ZqaYXAezSmRydUSy2rMhHiLAqOhrLQ7q3OMyeWGlhmI/ouQY6uL5UVyPSWkkD1YD4rt9yYVusFx/2kmCUpcSojx7Jh5y9nnzR9hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093741; c=relaxed/simple;
	bh=dCKDCCVVmn67QTN6GX8GtVtcPHesUrzm+9LwSunQS0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC43Rzy/AtXluxT/yHNUHGuD0r0zZ7ApRQYODw7F/RdF6gIqar4drMLYKiLmUtxaTcwtAHRoFXMGJ0OduFec60C0OGf8jvQFsgGfpbE+/OGCocXdeRXateltd35M69ZKAvvclBxghRChhNFObO1piMeGnVW8lQ59qwFMVI/PVos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=HWUL+nr3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="HWUL+nr3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nUC1AhDsLqGKgrLu1gVq1YU78KdcgKCkYREB9ShQncU=; b=HWUL+nr34Pmz1bUlQMjsm9m/g/
	vo9Kswz94afLkEGfdi/vbqonp3cycj69CcLhpoHajKL83fIA10vcqqU12BGoFvi0D21Fnb0JbN1e4
	tIC6mymsk7fFVbbu4CofSbKCa+MoxfiYCQya5KMZ2o5r+dBa9JltPkkQJE38gjDXjvaGfUrkSd9DJ
	lVEeQdeKlTI6Wdb0zNAci1dXEfNZDR8apvybUHZiWmWntylEoAihiY9r5XkOQhXawc/s/chLa1O8D
	r86nlQQhqCBK7FvN62RGDLQYpT7PsuxpMSgkOAfYcjVws4qUmQ31Q5AGwjgPGQI3eWeWMKGELef3r
	UhKKjZDq5Bp0VWRq74jh5IhJxwJUfssLdhXqnBC8jHgyfQ/ZszLAb5vRdoAkIal2SSZwxMEuejpg5
	FL38rkukK3mLpn2/N2v7YFrIopxcSWczG9mQYF1nUK2003p2JyGWUztaywKVKDwifdW1CtZgiQkye
	g1JaFKKzSyLNx4gwzZ4NAcZ4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxMj-00FdMs-26;
	Tue, 25 Nov 2025 18:02:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 053/145] smb: smbdirect: introduce smbdirect_connect[_sync]()
Date: Tue, 25 Nov 2025 18:54:59 +0100
Message-ID: <d8d2065afb4148f52ba552f62bc03f230dda340c.1764091285.git.metze@samba.org>
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

This implements a fully async connect logic over
all rdma related operations: rdma_resolve_addr,
rdma_resolve_route and rdma_connect_locked
until we reach RDMA_CM_EVENT_ESTABLISHED,
followed by the smbdirect negotiation request/response
handling until we reach SMBDIRECT_SOCKET_CONNECTED.

smbdirect_connect_sync() is just a useful wrapper
around the async logic calling smbdirect_connect()
followed by smbdirect_connection_wait_for_connected(),
which only waits for SMBDIRECT_SOCKET_CONNECTED or
an error.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_all_c_files.c  |   1 +
 fs/smb/common/smbdirect/smbdirect_connect.c   | 843 ++++++++++++++++++
 2 files changed, 844 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_connect.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
index 51b2bcda5596..5df7da692df3 100644
--- a/fs/smb/common/smbdirect/smbdirect_all_c_files.c
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -20,3 +20,4 @@
 #include "smbdirect_mr.c"
 #include "smbdirect_rw.c"
 #include "smbdirect_debug.c"
+#include "smbdirect_connect.c"
diff --git a/fs/smb/common/smbdirect/smbdirect_connect.c b/fs/smb/common/smbdirect/smbdirect_connect.c
new file mode 100644
index 000000000000..0a3629dcf150
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_connect.c
@@ -0,0 +1,843 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (c) 2012,2016,2017,2025 Stefan Metzmacher
+ */
+
+#include "smbdirect_internal.h"
+
+static int smbdirect_connect_setup_connection(struct smbdirect_socket *sc);
+static int smbdirect_connect_resolve_addr(struct smbdirect_socket *sc,
+					  const struct sockaddr *src,
+					  const struct sockaddr *dst);
+static int smbdirect_connect_rdma_event_handler(struct rdma_cm_id *id,
+						struct rdma_cm_event *event);
+static int smbdirect_connect_negotiate_start(struct smbdirect_socket *sc);
+static void smbdirect_connect_negotiate_send_done(struct ib_cq *cq, struct ib_wc *wc);
+static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc);
+
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_connect(struct smbdirect_socket *sc,
+			     const struct sockaddr *dst)
+{
+	const struct sockaddr *src = NULL;
+	union {
+		struct sockaddr sa;
+		struct sockaddr_storage ss;
+	} src_addr = {
+		.sa = {
+			.sa_family = AF_UNSPEC,
+		},
+	};
+	int ret;
+
+	if (sc->first_error)
+		return -ENOTCONN;
+
+	if (sc->status != SMBDIRECT_SOCKET_CREATED)
+		return -EALREADY;
+
+	if (WARN_ON_ONCE(!sc->rdma.cm_id))
+		return -EINVAL;
+
+	src_addr.ss = sc->rdma.cm_id->route.addr.src_addr;
+	if (src_addr.sa.sa_family != AF_UNSPEC)
+		src = &src_addr.sa;
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"connect: src: %pISpsfc dst: %pISpsfc\n",
+		src, dst);
+
+	ret = smbdirect_connect_setup_connection(sc);
+	if (ret)
+		return ret;
+
+	ret = smbdirect_connect_resolve_addr(sc, src, dst);
+	if (ret)
+		return ret;
+
+	/*
+	 * The rest happens async via smbdirect_connect_rdma_event_handler()
+	 * the caller will decide to wait or not.
+	 */
+	return 0;
+}
+
+static int smbdirect_connect_setup_connection(struct smbdirect_socket *sc)
+{
+	rdma_lock_handler(sc->rdma.cm_id);
+	sc->rdma.cm_id->event_handler = smbdirect_connect_rdma_event_handler;
+	rdma_unlock_handler(sc->rdma.cm_id);
+
+	if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_CREATED))
+		return -EINVAL;
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED;
+
+	return 0;
+}
+
+static int smbdirect_connect_resolve_addr(struct smbdirect_socket *sc,
+					  const struct sockaddr *src,
+					  const struct sockaddr *dst)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct sockaddr *src_addr = NULL;
+	struct sockaddr *dst_addr = NULL;
+	int ret;
+
+	src_addr = (struct sockaddr *)src;
+	if (src_addr && src_addr->sa_family == AF_UNSPEC)
+		src_addr = NULL;
+	dst_addr = (struct sockaddr *)dst;
+
+	if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED))
+		return -EINVAL;
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING;
+	sc->rdma.expected_event = RDMA_CM_EVENT_ADDR_RESOLVED;
+	ret = rdma_resolve_addr(sc->rdma.cm_id, src_addr, dst_addr,
+				sp->resolve_addr_timeout_msec);
+	if (ret) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"rdma_resolve_addr() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+static int smbdirect_connect_resolve_route(struct smbdirect_socket *sc)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	int ret;
+
+	if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED))
+		return sc->first_error;
+	sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING;
+	sc->rdma.expected_event = RDMA_CM_EVENT_ROUTE_RESOLVED;
+	ret = rdma_resolve_route(sc->rdma.cm_id, sp->resolve_route_timeout_msec);
+	if (ret) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"rdma_resolve_route() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+static int smbdirect_connect_rdma_connect(struct smbdirect_socket *sc)
+{
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct rdma_conn_param conn_param;
+	__be32 ird_ord_hdr[2];
+	int ret;
+
+	sc->ib.dev = sc->rdma.cm_id->device;
+
+	if (!smbdirect_frwr_is_supported(&sc->ib.dev->attrs)) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"Fast Registration Work Requests (FRWR) is not supported device %.*s\n",
+			IB_DEVICE_NAME_MAX,
+			sc->ib.dev->name);
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"Device capability flags = %llx max_fast_reg_page_list_len = %u\n",
+			sc->ib.dev->attrs.device_cap_flags,
+			sc->ib.dev->attrs.max_fast_reg_page_list_len);
+		return -EPROTONOSUPPORT;
+	}
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"rdma connect: device: %.*s local: %pISpsfc remote: %pISpsfc\n",
+		IB_DEVICE_NAME_MAX,
+		sc->ib.dev->name,
+		&sc->rdma.cm_id->route.addr.src_addr,
+		&sc->rdma.cm_id->route.addr.dst_addr);
+
+	sp->max_frmr_depth = min_t(u32, sp->max_frmr_depth,
+				   sc->ib.dev->attrs.max_fast_reg_page_list_len);
+	sc->mr_io.type = IB_MR_TYPE_MEM_REG;
+	if (sc->ib.dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
+		sc->mr_io.type = IB_MR_TYPE_SG_GAPS;
+
+	sp->responder_resources = min_t(u8, sp->responder_resources,
+					sc->ib.dev->attrs.max_qp_rd_atom);
+	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
+		"responder_resources=%d\n",
+		sp->responder_resources);
+
+	ret = smbdirect_connection_create_qp(sc);
+	if (ret) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_create_qp() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		return ret;
+	}
+
+	memset(&conn_param, 0, sizeof(conn_param));
+	conn_param.initiator_depth = sp->initiator_depth;
+	conn_param.responder_resources = sp->responder_resources;
+
+	/* Need to send IRD/ORD in private data for iWARP */
+	if (rdma_protocol_iwarp(sc->ib.dev, sc->rdma.cm_id->port_num)) {
+		ird_ord_hdr[0] = cpu_to_be32(conn_param.responder_resources);
+		ird_ord_hdr[1] = cpu_to_be32(conn_param.initiator_depth);
+		conn_param.private_data = ird_ord_hdr;
+		conn_param.private_data_len = sizeof(ird_ord_hdr);
+	} else {
+		conn_param.private_data = NULL;
+		conn_param.private_data_len = 0;
+	}
+
+	conn_param.retry_count = SMBDIRECT_RDMA_CM_RETRY;
+	conn_param.rnr_retry_count = SMBDIRECT_RDMA_CM_RNR_RETRY;
+	conn_param.flow_control = 0;
+
+	if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED))
+		return sc->first_error;
+	sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING;
+	sc->rdma.expected_event = RDMA_CM_EVENT_ESTABLISHED;
+	ret = rdma_connect_locked(sc->rdma.cm_id, &conn_param);
+	if (ret) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"rdma_connect_locked() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		return ret;
+	}
+
+	/*
+	 * start with the rdma connect timeout and SMBDIRECT_KEEPALIVE_PENDING
+	 * so that the timer will cause a disconnect.
+	 */
+	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->rdma_connect_timeout_msec));
+
+	return 0;
+}
+
+static int smbdirect_connect_rdma_event_handler(struct rdma_cm_id *id,
+						struct rdma_cm_event *event)
+{
+	struct smbdirect_socket *sc = id->context;
+	u8 peer_initiator_depth;
+	u8 peer_responder_resources;
+	int ret;
+
+	/*
+	 * cma_cm_event_handler() has
+	 * lockdep_assert_held(&id_priv->handler_mutex);
+	 *
+	 * Mutexes are not allowed in interrupts,
+	 * and we rely on not being in an interrupt here,
+	 * as we might sleep.
+	 *
+	 * We didn't timeout so we cancel our idle timer,
+	 * it will be scheduled again if needed.
+	 */
+	WARN_ON_ONCE(in_interrupt());
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
+	cancel_delayed_work_sync(&sc->idle.timer_work);
+
+	if (event->status || event->event != sc->rdma.expected_event) {
+		ret = -ECONNABORTED;
+
+		if (event->event == RDMA_CM_EVENT_REJECTED)
+			ret = -ECONNREFUSED;
+		if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
+			ret = -ENETDOWN;
+		if (IS_ERR(SMBDIRECT_DEBUG_ERR_PTR(event->status)))
+			ret = event->status;
+
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"%s (first_error=%1pe, expected=%s) => event=%s status=%d => ret=%1pe\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			rdma_event_msg(sc->rdma.expected_event),
+			rdma_event_msg(event->event),
+			event->status,
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+
+		smbdirect_socket_schedule_cleanup(sc, ret);
+		return 0;
+	}
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"%s (first_error=%1pe) event=%s\n",
+		smbdirect_socket_status_string(sc->status),
+		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+		rdma_event_msg(event->event));
+
+	if (sc->first_error)
+		return 0;
+
+	switch (event->event) {
+	case RDMA_CM_EVENT_ADDR_RESOLVED:
+		if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING))
+			return 0;
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED;
+
+		ret = smbdirect_connect_resolve_route(sc);
+		if (ret)
+			smbdirect_socket_schedule_cleanup(sc, ret);
+		return 0;
+
+	case RDMA_CM_EVENT_ROUTE_RESOLVED:
+		if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING))
+			return 0;
+		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED;
+
+		ret = smbdirect_connect_rdma_connect(sc);
+		if (ret)
+			smbdirect_socket_schedule_cleanup(sc, ret);
+		return 0;
+
+	case RDMA_CM_EVENT_ESTABLISHED:
+		smbdirect_connection_rdma_established(sc);
+
+		if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING))
+			return 0;
+		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
+
+		/*
+		 * Here we work around an inconsistency between
+		 * iWarp and other devices (at least rxe and irdma using RoCEv2)
+		 */
+		if (rdma_protocol_iwarp(id->device, id->port_num)) {
+			/*
+			 * iWarp devices report the peer's values
+			 * with the perspective of the peer here.
+			 * Tested with siw and irdma (in iwarp mode)
+			 * We need to change to our perspective here,
+			 * so we need to switch the values.
+			 */
+			peer_initiator_depth = event->param.conn.responder_resources;
+			peer_responder_resources = event->param.conn.initiator_depth;
+		} else {
+			/*
+			 * Non iWarp devices report the peer's values
+			 * already changed to our perspective here.
+			 * Tested with rxe and irdma (in roce mode).
+			 */
+			peer_initiator_depth = event->param.conn.initiator_depth;
+			peer_responder_resources = event->param.conn.responder_resources;
+		}
+		smbdirect_connection_negotiate_rdma_resources(sc,
+							      peer_initiator_depth,
+							      peer_responder_resources,
+							      &event->param.conn);
+
+		ret = smbdirect_connect_negotiate_start(sc);
+		if (ret)
+			smbdirect_socket_schedule_cleanup(sc, ret);
+		return 0;
+
+	default:
+		break;
+	}
+
+	/*
+	 * This is an internal error
+	 */
+	WARN_ON_ONCE(sc->rdma.expected_event != RDMA_CM_EVENT_ESTABLISHED);
+	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+	return 0;
+}
+
+static int smbdirect_connect_negotiate_start(struct smbdirect_socket *sc)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_recv_io *recv_io = NULL;
+	struct smbdirect_send_io *send_io = NULL;
+	struct smbdirect_negotiate_req *nreq = NULL;
+	int ret;
+
+	if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_NEGOTIATE_NEEDED))
+		return sc->first_error;
+	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
+
+	ret = smbdirect_connection_create_mem_pools(sc);
+	if (ret) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_create_mem_pools() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		goto create_mem_pools_failed;
+	}
+
+	/*
+	 * Initialize the local credits to post
+	 * IB_WR_SEND[_WITH_INV].
+	 */
+	atomic_set(&sc->send_io.lcredits.count, sp->send_credit_target);
+
+	recv_io = smbdirect_connection_get_recv_io(sc);
+	if (WARN_ON_ONCE(!recv_io)) {
+		ret = -EINVAL;
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_get_recv_io() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		goto get_recv_io_failed;
+	}
+	recv_io->cqe.done = smbdirect_connect_negotiate_recv_done;
+
+	send_io = smbdirect_connection_alloc_send_io(sc);
+	if (IS_ERR(send_io)) {
+		ret = PTR_ERR(send_io);
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_alloc_send_io() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		goto alloc_send_io_failed;
+	}
+	send_io->cqe.done = smbdirect_connect_negotiate_send_done;
+
+	nreq = (struct smbdirect_negotiate_req *)send_io->packet;
+	nreq->min_version = cpu_to_le16(SMBDIRECT_V1);
+	nreq->max_version = cpu_to_le16(SMBDIRECT_V1);
+	nreq->reserved = 0;
+	nreq->credits_requested = cpu_to_le16(sp->send_credit_target);
+	nreq->preferred_send_size = cpu_to_le32(sp->max_send_size);
+	nreq->max_receive_size = cpu_to_le32(sp->max_recv_size);
+	nreq->max_fragmented_size = cpu_to_le32(sp->max_fragmented_recv_size);
+
+	smbdirect_log_negotiate(sc, SMBDIRECT_LOG_INFO,
+		"ReqOut: %s%x, %s%x, %s%u, %s%u, %s%u, %s%u\n",
+		"MinVersion=0x",
+		le16_to_cpu(nreq->min_version),
+		"MaxVersion=0x",
+		le16_to_cpu(nreq->max_version),
+		"CreditsRequested=",
+		le16_to_cpu(nreq->credits_requested),
+		"PreferredSendSize=",
+		le32_to_cpu(nreq->preferred_send_size),
+		"MaxRecvSize=",
+		le32_to_cpu(nreq->max_receive_size),
+		"MaxFragmentedSize=",
+		le32_to_cpu(nreq->max_fragmented_size));
+
+	send_io->sge[0].addr = ib_dma_map_single(sc->ib.dev,
+						 nreq,
+						 sizeof(*nreq),
+						 DMA_TO_DEVICE);
+	ret = ib_dma_mapping_error(sc->ib.dev, send_io->sge[0].addr);
+	if (ret) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"ib_dma_mapping_error() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		goto dma_mapping_failed;
+	}
+
+	send_io->sge[0].length = sizeof(*nreq);
+	send_io->sge[0].lkey = sc->ib.pd->local_dma_lkey;
+	send_io->num_sge = 1;
+
+	ib_dma_sync_single_for_device(sc->ib.dev,
+				      send_io->sge[0].addr,
+				      send_io->sge[0].length,
+				      DMA_TO_DEVICE);
+
+	smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_INFO,
+		"sge addr=0x%llx length=%u lkey=0x%x\n",
+		send_io->sge[0].addr,
+		send_io->sge[0].length,
+		send_io->sge[0].lkey);
+
+	/*
+	 * Now post the recv_io buffer in order to get
+	 * the negotiate response
+	 */
+	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
+	ret = smbdirect_connection_post_recv_io(recv_io);
+	if (ret) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_post_recv_io() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		goto post_recv_io_failed;
+	}
+
+	send_io->wr.next = NULL;
+	send_io->wr.wr_cqe = &send_io->cqe;
+	send_io->wr.sg_list = send_io->sge;
+	send_io->wr.num_sge = send_io->num_sge;
+	send_io->wr.opcode = IB_WR_SEND;
+	send_io->wr.send_flags = IB_SEND_SIGNALED;
+
+	ret = smbdirect_connection_post_send_wr(sc, &send_io->wr);
+	if (ret) {
+		/* if we reach here, post send failed */
+		smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_post_send_wr() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		goto post_send_wr_failed;
+	}
+
+	/*
+	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
+	 * so that the timer will cause a disconnect.
+	 */
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->negotiate_timeout_msec));
+
+	return 0;
+
+post_send_wr_failed:
+	/*
+	 * ib_dma_unmap_single is called in
+	 * smbdirect_connection_free_send_io()
+	 */
+	smbdirect_connection_free_send_io(send_io);
+	/*
+	 * recv_io is given to the rdma layer,
+	 * we should not put it even on error
+	 * nor call smbdirect_connection_destroy_mem_pools()
+	 * it will be cleaned up during disconnect.
+	 */
+	return ret;
+
+post_recv_io_failed:
+	/*
+	 * ib_dma_unmap_single is called in
+	 * smbdirect_connection_free_send_io()
+	 */
+dma_mapping_failed:
+	smbdirect_connection_free_send_io(send_io);
+
+alloc_send_io_failed:
+	smbdirect_connection_put_recv_io(recv_io);
+
+get_recv_io_failed:
+	smbdirect_connection_destroy_mem_pools(sc);
+
+create_mem_pools_failed:
+	return ret;
+}
+
+static void smbdirect_connect_negotiate_send_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct smbdirect_send_io *send_io =
+		container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
+	struct smbdirect_socket *sc = send_io->socket;
+
+	smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_INFO,
+		"smbdirect_send_io completed. status='%s (%d)', opcode=%d\n",
+		ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+
+	/* Note this frees wc->wr_cqe, but not wc */
+	smbdirect_connection_free_send_io(send_io);
+	atomic_dec(&sc->send_io.pending.count);
+
+	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_SEND))) {
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_ERR,
+				"wc->status=%s (%d) wc->opcode=%d\n",
+				ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		return;
+	}
+}
+
+static void smbdirect_connect_negotiate_recv_work(struct work_struct *work);
+
+static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct smbdirect_recv_io *recv_io =
+		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
+	struct smbdirect_socket *sc = recv_io->socket;
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+
+	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_RECV))) {
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
+				"wc->status=%s (%d) wc->opcode=%d\n",
+				ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+		goto error;
+	}
+
+	smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_INFO,
+		"smbdirect_recv_io completed. status='%s (%d)', opcode=%d\n",
+		ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+
+	/*
+	 * Reset timer to the keepalive interval in
+	 * order to trigger our next keepalive message.
+	 */
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->keepalive_interval_msec));
+
+	ib_dma_sync_single_for_cpu(sc->ib.dev,
+				   recv_io->sge.addr,
+				   recv_io->sge.length,
+				   DMA_FROM_DEVICE);
+
+	if (wc->byte_len < sizeof(struct smbdirect_negotiate_resp)) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"wc->byte_len=%u < %zu\n",
+			wc->byte_len, sizeof(struct smbdirect_negotiate_resp));
+		goto error;
+	}
+
+	/*
+	 * We continue via the workqueue as we may have
+	 * complex work that might sleep.
+	 *
+	 * The work should already/still be disabled,
+	 * but smbdirect_connection_put_recv_io() disables
+	 * it again.
+	 *
+	 * Note that smbdirect_connection_put_recv_io()
+	 * only moved recv_io into the free list, but
+	 * we didn't call smbdirect_connection_recv_io_refill()
+	 * yet, so it won't be reused, but the cleanup code
+	 * on disconnect is able to find it, disables
+	 * recv_io->complex_work again.
+	 */
+	smbdirect_connection_put_recv_io(recv_io);
+	INIT_WORK(&recv_io->complex_work, smbdirect_connect_negotiate_recv_work);
+	queue_work(sc->workqueue, &recv_io->complex_work);
+	return;
+
+error:
+	/*
+	 * recv_io.posted.refill_work is still disabled,
+	 * so smbdirect_connection_put_recv_io() won't
+	 * start it.
+	 */
+	smbdirect_connection_put_recv_io(recv_io);
+	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+}
+
+static void smbdirect_connect_negotiate_recv_work(struct work_struct *work)
+{
+	struct smbdirect_recv_io *recv_io =
+		container_of(work, struct smbdirect_recv_io, complex_work);
+	struct smbdirect_socket *sc = recv_io->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_negotiate_resp *nrep;
+	u16 negotiated_version;
+	u16 credits_requested;
+	u16 credits_granted;
+	u32 status;
+	u32 max_readwrite_size;
+	u32 preferred_send_size;
+	u32 max_receive_size;
+	u32 max_fragmented_size;
+	int posted;
+	int ret;
+
+	/*
+	 * make sure we won't start again...
+	 */
+	disable_work(work);
+
+	/*
+	 * Note recv_io is already part of the free list,
+	 * as smbdirect_connect_negotiate_recv_done() called
+	 * smbdirect_connection_put_recv_io(), but
+	 * it won't be reused before we call
+	 * smbdirect_connection_recv_io_refill() below.
+	 */
+
+	if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_NEGOTIATE_RUNNING))
+		return;
+
+	nrep = (struct smbdirect_negotiate_resp *)recv_io->packet;
+	negotiated_version = le16_to_cpu(nrep->negotiated_version);
+	credits_requested = le16_to_cpu(nrep->credits_requested);
+	credits_granted = le16_to_cpu(nrep->credits_granted);
+	status = le32_to_cpu(nrep->status);
+	max_readwrite_size = le32_to_cpu(nrep->max_readwrite_size);
+	preferred_send_size = le32_to_cpu(nrep->preferred_send_size);
+	max_receive_size = le32_to_cpu(nrep->max_receive_size);
+	max_fragmented_size = le32_to_cpu(nrep->max_fragmented_size);
+
+	smbdirect_log_negotiate(sc, SMBDIRECT_LOG_INFO,
+		"RepIn: %s%x, %s%x, %s%x, %s%u, %s%u, %s%x, %s%u, %s%u, %s%u, %s%u\n",
+		"MinVersion=0x",
+		le16_to_cpu(nrep->min_version),
+		"MaxVersion=0x",
+		le16_to_cpu(nrep->max_version),
+		"NegotiatedVersion=0x",
+		le16_to_cpu(nrep->negotiated_version),
+		"CreditsRequested=",
+		le16_to_cpu(nrep->credits_requested),
+		"CreditsGranted=",
+		le16_to_cpu(nrep->credits_granted),
+		"Status=0x",
+		le32_to_cpu(nrep->status),
+		"MaxReadWriteSize=",
+		le32_to_cpu(nrep->max_readwrite_size),
+		"PreferredSendSize=",
+		le32_to_cpu(nrep->preferred_send_size),
+		"MaxRecvSize=",
+		le32_to_cpu(nrep->max_receive_size),
+		"MaxFragmentedSize=",
+		le32_to_cpu(nrep->max_fragmented_size));
+
+	if (negotiated_version != SMBDIRECT_V1) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: negotiated_version=0x%x\n",
+			negotiated_version);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNREFUSED);
+		return;
+	}
+
+	if (status != 0) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: status=0x%x != 0x0\n",
+			status);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNREFUSED);
+		return;
+	}
+
+	if (max_receive_size < SMBDIRECT_MIN_RECEIVE_SIZE) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: max_receive_size=%u < %u\n",
+			max_receive_size,
+			SMBDIRECT_MIN_RECEIVE_SIZE);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		return;
+	}
+
+	if (max_fragmented_size < SMBDIRECT_MIN_FRAGMENTED_SIZE) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: max_fragmented_size=%u < %u\n",
+			max_fragmented_size,
+			SMBDIRECT_MIN_FRAGMENTED_SIZE);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		return;
+	}
+
+	if (credits_granted == 0) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: credits_granted == 0\n");
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		return;
+	}
+
+	if (credits_requested == 0) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: credits_requested == 0\n");
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		return;
+	}
+
+	if (preferred_send_size > sp->max_recv_size) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: preferred_send_size=%u < max_recv_size=%u\n",
+			preferred_send_size,
+			sp->max_recv_size);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		return;
+	}
+
+	/*
+	 * We take the value from the peer, which is checked to be higher than 0,
+	 * but we limit it to the max value we support in order to have
+	 * the main logic simpler.
+	 */
+	sc->recv_io.credits.target = credits_requested;
+	sc->recv_io.credits.target = min_t(u16, sc->recv_io.credits.target,
+					   sp->recv_credit_max);
+
+	/*
+	 * At least the value of SMBDIRECT_MIN_RECEIVE_SIZE is used.
+	 */
+	sp->max_recv_size = min_t(u32, sp->max_recv_size, preferred_send_size);
+	sp->max_recv_size = max_t(u32, sp->max_recv_size, SMBDIRECT_MIN_RECEIVE_SIZE);
+
+	/*
+	 * Note nrep->max_receive_size was already checked against
+	 * SMBDIRECT_MIN_RECEIVE_SIZE above.
+	 */
+	sp->max_send_size = min_t(u32, sp->max_send_size, max_receive_size);
+
+	/*
+	 * Make sure the resulting max_frmr_depth is at least 1,
+	 * which means max_read_write_size needs to be at least PAGE_SIZE.
+	 */
+	sp->max_read_write_size = min_t(u32, sp->max_frmr_depth * PAGE_SIZE,
+					max_readwrite_size);
+	if (sp->max_read_write_size < PAGE_SIZE) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: max_readwrite_size=%u < PAGE_SIZE(%lu)\n",
+			max_readwrite_size,
+			PAGE_SIZE);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		return;
+	}
+	sp->max_frmr_depth = sp->max_read_write_size / PAGE_SIZE;
+
+	/*
+	 * Note nrep->credits_granted was already checked against 0 above.
+	 */
+	atomic_set(&sc->send_io.credits.count, credits_granted);
+
+	/*
+	 * Note nrep->max_fragmented_size was already checked against
+	 * SMBDIRECT_MIN_FRAGMENTED_SIZE above.
+	 */
+	sp->max_fragmented_send_size = max_fragmented_size;
+
+	ret = smbdirect_connection_create_mr_list(sc);
+	if (ret) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_create_mr_list() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		smbdirect_socket_schedule_cleanup(sc, ret);
+		return;
+	}
+
+	/*
+	 * Prepare for receiving data_transfer messages
+	 */
+	sc->recv_io.reassembly.full_packet_received = true;
+	sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
+	list_for_each_entry(recv_io, &sc->recv_io.free.list, list)
+		recv_io->cqe.done = smbdirect_connection_recv_io_done;
+	recv_io = NULL;
+
+	/*
+	 * We should at least post 1 smbdirect_recv_io!
+	 */
+	posted = smbdirect_connection_recv_io_refill(sc);
+	if (posted < 1) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_recv_io_refill() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		return;
+	}
+
+	/*
+	 * smbdirect_connection_negotiation_done()
+	 * will setup all required things and wake up
+	 * the waiter.
+	 */
+	smbdirect_connection_negotiation_done(sc);
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_connect_sync(struct smbdirect_socket *sc,
+				  const struct sockaddr *dst)
+{
+	int ret;
+
+	ret = smbdirect_connect(sc, dst);
+	if (ret) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connect(%pISpsfc) failed %1pe\n",
+			dst, SMBDIRECT_DEBUG_ERR_PTR(ret));
+		return ret;
+	}
+
+	ret = smbdirect_connection_wait_for_connected(sc);
+	if (ret) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"wait for smbdirect_connect(%pISpsfc) failed %1pe\n",
+			dst, SMBDIRECT_DEBUG_ERR_PTR(ret));
+		return ret;
+	}
+
+	return 0;
+}
-- 
2.43.0

