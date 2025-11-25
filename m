Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E34D32AADF
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093488; cv=none; b=Xkcz3avrcYCRQLOrzm9SD77x37eIu8UgJ3sc5ACpnKCRofScFiew+uBgmnm6iKfsoxyQxmu3FXMicua+2yl3ZrC46itdomsHjRgEsQFb5ebtmkn5Obp1bcmB03MQIm53tFX58C3YUMYo712+xvbid+9p4TBpUnf/rYqErIuFSAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093488; c=relaxed/simple;
	bh=M4laf9eHpnO8JFKRGdUmJ52FUXC33bMBy8FzgeO2Usc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0SRgynprwAwLldfxUqE9btlsZv6NNyl85XgQNvzYoqO/JhE5FfrcnCfrG6Uy3tLiCX+FTThUXVUji2HUpWEN1tEkpkglbmTtAJlJlqHgcNycC3q3wi7NUqisDQy7kypOZYR6r2OuYatSbuJTPxLcACfNXH+sxStmZuIWEdE6YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=EHaOaaF6; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EHaOaaF6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=oZm05aMrBWILlRns9eYcYBhMWKmUmyljd6St4e2/qJU=; b=EHaOaaF6iBK1fXjCYXDaG4apAI
	MIzv2vzNRm+SDEVJmS+EANCXcnoClzhzkeurKBDdDvuTzgyA1s5lSz38jB6BnYRa4wniW6TNxRE+/
	eZr1AiC6OvdqcxIFdgyoxSSDVpkBTb/aupEbevduwG6yOTGdbT/L2RVADKnqXo9kl2PbhEXiefTIG
	ji/HANBjaRxRJlqirhIczMwBj5L77aE5V6uGlCGlfnSEp5lzoprBRDc4dbMMzMMMtydE6DsnyIyDE
	NDsRzp7AQjq3dbc7/RGmJ8pigAns/TIwwrM7vEQ0yBLgiAhfaUkSFs0ABmhQUmLGX4mCXYgFLEUYb
	JsJT7fRv/Z6+L6flXjOgzbXQ5RDWi5aF4xDeBcMJAqGe0gEobpa631cNLcUbUsSY95ln0s9lj6JPy
	HxP+CP1W2UKMMIl1CRAochbz9kiP9a42na7tyVQL/KRPe/0Iz5rHr0ls0NJWC/hOOEHVedoTOwKtP
	8PADe1LRMeazono24Lil7oi9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxIc-00FchX-33;
	Tue, 25 Nov 2025 17:57:59 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 013/145] smb: smbdirect: introduce smbdirect_socket_cleanup_work()
Date: Tue, 25 Nov 2025 18:54:19 +0100
Message-ID: <536df07f757d68254694ae3197d7922c8ff78042.1764091285.git.metze@samba.org>
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

This is basically a copy of smbd_disconnect_rdma_work() and
smb_direct_disconnect_rdma_work() and will replace them in the
next steps.

Differences is that a message is logged if first error is still 0,
which makes it easier to analyze problems.

And also disable any complex work from recv_io objects,
currently these are not used and the work is always
disabled anyway, but this prepares future changes.

It also makes sure it's never used in an interrupt, which is
not expected anyway...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 90 +++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index a249e758379f..2688866fffe6 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -6,6 +6,8 @@
 
 #include "smbdirect_internal.h"
 
+static void smbdirect_socket_cleanup_work(struct work_struct *work);
+
 __maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 					    const struct smbdirect_socket_parameters *sp,
@@ -23,6 +25,8 @@ static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 	 * Remember the callers workqueue
 	 */
 	sc->workqueue = workqueue;
+
+	INIT_WORK(&sc->disconnect_work, smbdirect_socket_cleanup_work);
 }
 
 __maybe_unused /* this is temporary while this file is included in others */
@@ -45,7 +49,6 @@ static void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
 	sc->logging.vaprintf = vaprintf;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
 {
 	/*
@@ -62,3 +65,88 @@ static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->mr_io.ready.wait_queue);
 	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
+
+static void smbdirect_socket_cleanup_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, disconnect_work);
+	struct smbdirect_recv_io *recv_io, *recv_tmp;
+	unsigned long flags;
+
+	/*
+	 * This should not never be called in an interrupt!
+	 */
+	WARN_ON_ONCE(in_interrupt());
+
+	if (!sc->first_error) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"%s called with first_error==0\n",
+			smbdirect_socket_status_string(sc->status));
+
+		sc->first_error = -ECONNABORTED;
+	}
+
+	/*
+	 * make sure this and other work is not queued again
+	 * but here we don't block and avoid
+	 * disable[_delayed]_work_sync()
+	 */
+	disable_work(&sc->disconnect_work);
+	disable_work(&sc->recv_io.posted.refill_work);
+	disable_work(&sc->mr_io.recovery_work);
+	disable_work(&sc->idle.immediate_work);
+	disable_delayed_work(&sc->idle.timer_work);
+
+	/*
+	 * If any complex work was scheduled we
+	 * should disable it (only happens during
+	 * negotiation)...
+	 *
+	 * Note that sc->first_error is set before,
+	 * so any future smbdirect_connection_get_recv_io()
+	 * will see it and return NULL.
+	 */
+	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
+	list_for_each_entry_safe(recv_io, recv_tmp, &sc->recv_io.free.list, list)
+		disable_work(&recv_io->complex_work);
+	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
+
+	switch (sc->status) {
+	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
+	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
+	case SMBDIRECT_SOCKET_CONNECTED:
+	case SMBDIRECT_SOCKET_ERROR:
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTING;
+		rdma_disconnect(sc->rdma.cm_id);
+		break;
+
+	case SMBDIRECT_SOCKET_CREATED:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
+		/*
+		 * rdma_{accept,connect}() never reached
+		 * RDMA_CM_EVENT_ESTABLISHED
+		 */
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		break;
+
+	case SMBDIRECT_SOCKET_DISCONNECTING:
+	case SMBDIRECT_SOCKET_DISCONNECTED:
+	case SMBDIRECT_SOCKET_DESTROYED:
+		break;
+	}
+
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	smbdirect_socket_wake_up_all(sc);
+}
-- 
2.43.0

