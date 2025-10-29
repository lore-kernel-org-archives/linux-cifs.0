Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC9228B4FE
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744371; cv=none; b=OvvAm0tBHfvn2pRrcLGVX6DSdLnF6pA3wcZVPmoUj8edDiJxlytgGQWisuOmJSQLPFw33Rr67uAI7wXiSnbIdkFyA7rM7FBZksmwEd0pRjL8g7Lw5U3d+JdlcA2f4u/LNd73NTEGERf0RsQXc3/5SuzKln0b9DGYJ7okN1jBXvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744371; c=relaxed/simple;
	bh=g9mr4nHluctP69FEhDxIuVwka09FDNmLqXGi21B+KbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXoiy4NGAqplHpclX+6BfMgEaEeZbc5jjirbl+2i23U7XizrWFI2fO5euoDAv7R58UQMGzLZtF5Oil9LAvmGakQ/Hlx9ZaXaoJ+BRYgh27mwDyHoXfVWh+oILh8phKnIFl+DXM6vEiejsEz3PXppAKgn2VjVVZA0pLeST37hHak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0UR5ObdH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0UR5ObdH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=YIMh36NASiYd+FL5RkDcGP5Kf2wKsc+rLqDkTJb55xM=; b=0UR5ObdHEzpvhBDGCGE3Vw9xQN
	I547/3q1o+R0NUI7Lgg1J/l7BfpbGo+ChkrOqBR/qYJMDaIdHnmA++y06Gx5PTUq6em9o/HXs3fOy
	d+++kSOGCVCdxtd775+ralopgcyT2TIyTthzXqm26ggJs+BFs+FH4GdVErWe4iT5QNx/8H/f0G2HE
	GmYzPkEigXo32f6fexaqix61O4kNFbl7n6+HASyrrXHhLMN3FBRsyZl5SOb895L/4rN4uzIHI9M4k
	dJPCVnWBqudQOD81Q/zKMxHpRoWw3inOF7meIRyv5yX/pi0yyr2KPi9DQLt736cvDUCq0GV2ZNlXI
	zrGXoSvmPsDfmiT1XQEgRhUKHFCfmJAlg9x+FM1cN8RZ+2o8AqmLP2gfu3CyevrHbWKb6cvcD+GWP
	2djnwdgHP8focrWSGiipexDRoY5QkH+vGtCWCB6OFQcxTuFk+m1AfhJK3Se078gxaZ7tx6AY/D+PP
	g7oQgWFjaa7cVtXdMQQBBXeH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Bi-00Bbje-2E;
	Wed, 29 Oct 2025 13:26:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 036/127] smb: smbdirect: introduce smbdirect_connection_destroy[_sync]()
Date: Wed, 29 Oct 2025 14:20:14 +0100
Message-ID: <1143613c2eec793d4c4ad87d108b34dbd2fb11ec.1761742839.git.metze@samba.org>
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

This will be used in common between client and server in
order to destroy all resources attached to a connection.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 126 ++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index cea05753c80e..6fe6c53e10ea 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -24,6 +24,8 @@ static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc
 static void smbdirect_connection_disconnect_work(struct work_struct *work);
 static void smbdirect_connection_idle_timer_work(struct work_struct *work);
 
+static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 {
@@ -765,6 +767,130 @@ static void smbdirect_connection_disconnect_work(struct work_struct *work)
 	smbdirect_connection_wake_up_all(sc);
 }
 
+static void smbdirect_connection_destroy(struct smbdirect_socket *sc)
+{
+	struct smbdirect_recv_io *recv_io;
+	struct smbdirect_recv_io *recv_tmp;
+	LIST_HEAD(all_list);
+	unsigned long flags;
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"status=%s first_error=%1pe",
+		smbdirect_socket_status_string(sc->status),
+		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+
+	/*
+	 * This should not never be called in an interrupt!
+	 */
+	WARN_ON_ONCE(in_interrupt());
+
+	if (sc->status == SMBDIRECT_SOCKET_DESTROYED)
+		return;
+
+	WARN_ONCE(sc->status != SMBDIRECT_SOCKET_DISCONNECTED,
+		  "status=%s first_error=%1pe",
+		  smbdirect_socket_status_string(sc->status),
+		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 *
+	 * Most likely this was already called via
+	 * smbdirect_connection_disconnect_work(), but call it again...
+	 */
+	smbdirect_connection_wake_up_all(sc);
+
+	disable_work_sync(&sc->disconnect_work);
+	disable_work_sync(&sc->recv_io.posted.refill_work);
+	disable_work_sync(&sc->mr_io.recovery_work);
+	disable_work_sync(&sc->idle.immediate_work);
+	disable_delayed_work_sync(&sc->idle.timer_work);
+
+	if (sc->rdma.cm_id)
+		rdma_lock_handler(sc->rdma.cm_id);
+
+	if (sc->ib.qp) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"drain qp\n");
+		ib_drain_qp(sc->ib.qp);
+	}
+
+	/* It's not possible for upper layer to get to reassembly */
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"drain the reassembly queue\n");
+	spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
+	list_splice_tail_init(&sc->recv_io.reassembly.list, &all_list);
+	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
+	list_for_each_entry_safe(recv_io, recv_tmp, &all_list, list) {
+		smbdirect_connection_put_recv_io(recv_io);
+	}
+	sc->recv_io.reassembly.data_length = 0;
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"freeing mr list\n");
+	smbdirect_connection_destroy_mr_list(sc);
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"destroying qp\n");
+	smbdirect_connection_destroy_qp(sc);
+	if (sc->rdma.cm_id) {
+		rdma_unlock_handler(sc->rdma.cm_id);
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"destroying cm_id\n");
+		rdma_destroy_id(sc->rdma.cm_id);
+		sc->rdma.cm_id = NULL;
+	}
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"destroying mem pools\n");
+	smbdirect_connection_destroy_mem_pools(sc);
+
+	sc->status = SMBDIRECT_SOCKET_DESTROYED;
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"rdma session destroyed\n");
+}
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_destroy_sync(struct smbdirect_socket *sc)
+{
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"status=%s first_error=%1pe",
+		smbdirect_socket_status_string(sc->status),
+		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+
+	/*
+	 * This should not never be called in an interrupt!
+	 */
+	WARN_ON_ONCE(in_interrupt());
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"cancelling and disable disconnect_work\n");
+	disable_work_sync(&sc->disconnect_work);
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO, "destroying rdma session\n");
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
+		smbdirect_connection_disconnect_work(&sc->disconnect_work);
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"wait for transport being disconnected\n");
+		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+			"waited for transport being disconnected\n");
+	}
+
+	/*
+	 * Once we reached SMBDIRECT_SOCKET_DISCONNECTED,
+	 * we should call smbdirect_connection_destroy()
+	 */
+	smbdirect_connection_destroy(sc);
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"status=%s first_error=%1pe",
+		smbdirect_socket_status_string(sc->status),
+		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+}
+
 static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
-- 
2.43.0

