Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E951EB195
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093654; cv=none; b=ESjOTVA7VfvojZLbgwgUePwT/4Ubj6PNzEeoM8nd6VVOoNSPAeixkE8Q5lSlHMLsUPKOcUbSpdzl0PpD2pAaV0Mi+0xl/qgCo2+ZBOiisgcwuVLURb8hdn3kYPhaKKLW+55THwU9qU6SXPIwMn3PlabkGX1ywf50gTdavA4fVMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093654; c=relaxed/simple;
	bh=wUefy5JjGMkubYDownZfsxD4V6ghTrRMVODQPVsTxds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTnVuFc3f6nxdf8grRvD1dvr3SZH5MdgOeiM9aHr4RsubRDnNbDmRcl9B+K2NJjF0gmB2qC/QNuWZjuDM/GwMc4Hi25Lvw3rGxAzLgPeoJe9/HbtAk7Wb3DPUInlpTCE21gbjewiKnAqRb2nxhVrCLMbY69piUTsmYAnRW7uqIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yhsqCsj5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yhsqCsj5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=46RBBjLzXFv4O4Oc85bes6AeGA6IcDQKWnX97QsPqVQ=; b=yhsqCsj5tWVbD9zbtIEjpI6Qrp
	QjbTGpg/2wm1nQ+2eoz7MqdU7g0jh54dk7cp15b3Wt6PNbsaaevSL1X03uWXUdNmbM5rm7zYVu5VJ
	SWgilhNf67n2y5xBIgDk3fpYsDwGj2xU/9d3xVBXXAMdY6gg3jlwAyML+0sF8fz31v4QjI99Rp8Uq
	qUNlTle9w2vRJMibZlwLMSQDypOIGbKv2Nospr6EAWdAeu7foPUKgOeBWI0QeBXYsprjvcT8/aRPd
	14J2hBrbKrMl1CBm6Gj9vXKCLnzl+2S4r7ue/g+5OTufOtQ90Qj38PUmE/Cg1xrKtEURRtwfM76uE
	+cLj92SDNoCcLjAuSywpqPD1ejTaPYCkErPKJcjNiSdP29QZPb+bnGaqt5uH9eYZRbr+0o5o1hQ26
	K4JSAU3Ily/1d1FTpJAbmv6JWjx8DCC4mVrKlEmhxFcxtYKHc29M1tcvrVc7BfW2eFZOPl6x+dMHe
	X0FOvNTAVk3B2YROqQivo3zB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxLK-00Fd6A-2q;
	Tue, 25 Nov 2025 18:00:47 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 040/145] smb: smbdirect: introduce smbdirect_connection_rdma_{established,event_handler}()
Date: Tue, 25 Nov 2025 18:54:46 +0100
Message-ID: <98210069af54646d2f1627b275ca962101aa34af.1764091285.git.metze@samba.org>
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

This will be used by client and server in future,
it will be used after the rdma connection is established
in order to simplify the events happening on an established
connection.

We'll also have smbdirect_{connect,accept}_rdma_event_handler
functions which will be used before the rdma connection is
established.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 110 ++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_socket.h    |   8 ++
 2 files changed, 118 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index dcaab7383e7d..5c4303093b15 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -44,6 +44,116 @@ static void smbdirect_connection_qp_event_handler(struct ib_event *event, void *
 	}
 }
 
+static int smbdirect_connection_rdma_event_handler(struct rdma_cm_id *id,
+						   struct rdma_cm_event *event)
+{
+	struct smbdirect_socket *sc = id->context;
+	int ret = -ECONNRESET;
+
+	if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
+		ret = -ENETDOWN;
+	if (IS_ERR(SMBDIRECT_DEBUG_ERR_PTR(event->status)))
+		ret = event->status;
+
+	/*
+	 * cma_cm_event_handler() has
+	 * lockdep_assert_held(&id_priv->handler_mutex);
+	 *
+	 * Mutexes are not allowed in interrupts,
+	 * and we rely on not being in an interrupt here.
+	 */
+	WARN_ON_ONCE(in_interrupt());
+
+	if (event->event != sc->rdma.expected_event) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"%s (first_error=%1pe, expected=%s) => event=%s status=%d => ret=%1pe\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			rdma_event_msg(sc->rdma.expected_event),
+			rdma_event_msg(event->event),
+			event->status,
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+
+		/*
+		 * If we get RDMA_CM_EVENT_DEVICE_REMOVAL,
+		 * we should change to SMBDIRECT_SOCKET_DISCONNECTED,
+		 * so that rdma_disconnect() is avoided later via
+		 * smbdirect_socket_schedule_cleanup[_status]() =>
+		 * smbdirect_socket_cleanup_work().
+		 *
+		 * As otherwise we'd set SMBDIRECT_SOCKET_DISCONNECTING,
+		 * but never ever get RDMA_CM_EVENT_DISCONNECTED and
+		 * never reach SMBDIRECT_SOCKET_DISCONNECTED.
+		 */
+		if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
+			smbdirect_socket_schedule_cleanup_status(sc,
+								 SMBDIRECT_LOG_ERR,
+								 ret,
+								 SMBDIRECT_SOCKET_DISCONNECTED);
+		else
+			smbdirect_socket_schedule_cleanup(sc, ret);
+		if (sc->ib.qp)
+			ib_drain_qp(sc->ib.qp);
+		return 0;
+	}
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"%s (first_error=%1pe) event=%s\n",
+		smbdirect_socket_status_string(sc->status),
+		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+		rdma_event_msg(event->event));
+
+	switch (event->event) {
+	case RDMA_CM_EVENT_DISCONNECTED:
+		/*
+		 * We need to change to SMBDIRECT_SOCKET_DISCONNECTED,
+		 * so that rdma_disconnect() is avoided later via
+		 * smbdirect_socket_schedule_cleanup_status() =>
+		 * smbdirect_socket_cleanup_work().
+		 *
+		 * As otherwise we'd set SMBDIRECT_SOCKET_DISCONNECTING,
+		 * but never ever get RDMA_CM_EVENT_DISCONNECTED and
+		 * never reach SMBDIRECT_SOCKET_DISCONNECTED.
+		 *
+		 * This is also a normal disconnect so
+		 * SMBDIRECT_LOG_INFO should be good enough
+		 * and avoids spamming the default logs.
+		 */
+		smbdirect_socket_schedule_cleanup_status(sc,
+							 SMBDIRECT_LOG_INFO,
+							 ret,
+							 SMBDIRECT_SOCKET_DISCONNECTED);
+		if (sc->ib.qp)
+			ib_drain_qp(sc->ib.qp);
+		return 0;
+
+	default:
+		break;
+	}
+
+	/*
+	 * This is an internal error, should be handled above via
+	 * event->event != sc->rdma.expected_event already.
+	 */
+	WARN_ON_ONCE(sc->rdma.expected_event != RDMA_CM_EVENT_DISCONNECTED);
+	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+	return 0;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
+{
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"rdma established: device: %.*s local: %pISpsfc remote: %pISpsfc\n",
+		IB_DEVICE_NAME_MAX,
+		sc->ib.dev->name,
+		&sc->rdma.cm_id->route.addr.src_addr,
+		&sc->rdma.cm_id->route.addr.dst_addr);
+
+	sc->rdma.cm_id->event_handler = smbdirect_connection_rdma_event_handler;
+	sc->rdma.expected_event = RDMA_CM_EVENT_DISCONNECTED;
+}
+
 static u32 smbdirect_rdma_rw_send_wrs(struct ib_device *dev,
 				      const struct ib_qp_init_attr *attr)
 {
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index eb9e498c2e2c..8d75390037fc 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -111,6 +111,12 @@ struct smbdirect_socket {
 	/* RDMA related */
 	struct {
 		struct rdma_cm_id *cm_id;
+		/*
+		 * The expected event in our current
+		 * cm_id->event_handler, all other events
+		 * are treated as an error.
+		 */
+		enum rdma_cm_event_type expected_event;
 		/*
 		 * This is for iWarp MPA v1
 		 */
@@ -487,6 +493,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_WORK(&sc->disconnect_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->disconnect_work);
 
+	sc->rdma.expected_event = RDMA_CM_EVENT_INTERNAL;
+
 	sc->ib.poll_ctx = IB_POLL_UNBOUND_WORKQUEUE;
 
 	INIT_WORK(&sc->idle.immediate_work, __smbdirect_socket_disabled_work);
-- 
2.43.0

