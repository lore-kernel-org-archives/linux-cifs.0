Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3730F188596
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093648; cv=none; b=e0L2Dwbh0v4Te7WrH7zDjXGlzwzCo0bqfCgmTcAKp3dvkQAKIZQazhnQDEmdyNdQ8m/gr2KebSzOqEJ6kZZg/7PgRsbyFYgye20urnFlynZZNaWqcfKRvUdWXy889R+E9PLgxwT9NPz/WDuI4vi0E7L2yijN9GeFozm560NhTmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093648; c=relaxed/simple;
	bh=zTj00ZwJ5ucIQrFej/k6PbNz80SEg4O5te1iiJJlycQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCFsqSmMryUtFSO/85g2j35ppEOtFsb94yYs8UdHEXHK+9Izb/O/jxDmAbIZwv9yccoKPkBCHRs8Wau6l0IFVDbfCP7ft4HYCFQMevJrTJikGBOJsOiM2o2exAXJvi/9Fa5wqKegjzdwMOJXXb+g1iFBsabJYA3Pg+zG/n9m+Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fUX2T798; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fUX2T798"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=BkzrHLtQ6ivyW1BZRQxOplaEFYBbBZHCbjgD3AHpLLk=; b=fUX2T798ppnu+DxRXrWunkDtHE
	h9PX6lWmcMV4NQ7EIWVu8UN6Yjjk3H9bvq2walsr06uIU2laeRPIE5nvz9v8hAVh37ThU+Dcmzlpf
	o/aaNpXc9QYlPqU0o5MsP5NifwOiDHCv6nEoIl2sNjEuBkRADVpHDPrqT9Ryw9L5x8To8PMXR0IIE
	hiKhB+WkZcva8iYtuZIDy7yF8TcdNHSd3ttStR+NClzIigSebWdTZFIv0lUHmX4GsZqg+julDldD7
	esEKw4zb+Ru4S7J1obOjIZQkMTgIyp3nPXbr1CPJ5cs+3WYkoe8NnJ1zT9vqDXaF4lFyochxvhfiU
	Le7yefCrHPaKHlaiKOI2uE4F/RdSZ+4cYi5NaolShZZ4WtTvlW4GGyVh5vHDT4nE0vll4sp7MfvVy
	/LUVLsf4v/3bifsKo/Oz3bkzQDy1NBuW3PxPUkH+iecBqMKl4eZTm5yj7f/etAtQGzZ1N28NG9fqg
	LNWkZw8EKjWiqyd8RykznTNp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxLD-00Fd5a-2r;
	Tue, 25 Nov 2025 18:00:40 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 039/145] smb: smbdirect: introduce smbdirect_socket_destroy[_sync]()
Date: Tue, 25 Nov 2025 18:54:45 +0100
Message-ID: <c5aaca24cab6689774d6cb77b0d2902524ba1eec.1764091285.git.metze@samba.org>
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

This will be used in common between client and server in
order to destroy all resources attached to a connection.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   |   4 -
 fs/smb/common/smbdirect/smbdirect_internal.h  |   8 +
 fs/smb/common/smbdirect/smbdirect_mr.c        |   1 -
 fs/smb/common/smbdirect/smbdirect_socket.c    | 151 ++++++++++++++++++
 4 files changed, 159 insertions(+), 5 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index c1e159b41a36..dcaab7383e7d 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -77,8 +77,6 @@ static u32 smbdirect_rdma_rw_send_wrs(struct ib_device *dev,
 	return factor * attr->cap.max_rdma_ctxs;
 }
 
-static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc);
-
 __maybe_unused /* this is temporary while this file is included in others */
 static int smbdirect_connection_create_qp(struct smbdirect_socket *sc)
 {
@@ -258,8 +256,6 @@ static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc)
 	}
 }
 
-static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
-
 __maybe_unused /* this is temporary while this file is included in others */
 static int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
 {
diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 43ef6e39f28e..ead845948089 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -40,6 +40,14 @@ static int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
 					     atomic_t *total_credits,
 					     int needed);
 
+static void smbdirect_connection_destroy_qp(struct smbdirect_socket *sc);
+
+static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
+
+static void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg);
+
 static void smbdirect_connection_idle_timer_work(struct work_struct *work);
 
+static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index d52e5b8ab71c..35dc2a6c9b89 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -6,7 +6,6 @@
 
 #include "smbdirect_internal.h"
 
-static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
 static void smbdirect_connection_mr_io_recovery_work(struct work_struct *work);
 
 /*
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 9093352d1a57..b0079c1f59aa 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -280,6 +280,157 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	smbdirect_socket_wake_up_all(sc);
 }
 
+static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
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
+	 * smbdirect_socket_cleanup_work(), but call it again...
+	 */
+	smbdirect_socket_wake_up_all(sc);
+
+	disable_work_sync(&sc->disconnect_work);
+	disable_work_sync(&sc->recv_io.posted.refill_work);
+	disable_work_sync(&sc->mr_io.recovery_work);
+	disable_work_sync(&sc->idle.immediate_work);
+	disable_delayed_work_sync(&sc->idle.timer_work);
+
+	/*
+	 * If any complex work was scheduled we
+	 * should disable it (only happens during
+	 * negotiation)...
+	 *
+	 * Note was already set in sc->first_error in
+	 * smbdirect_socket_schedule_cleanup() or
+	 * smbdirect_socket_cleanup_work(), both
+	 * before time before:
+	 * spin_lock_irqsave(&sc->recv_io.free.lock, flags),
+	 * so any future smbdirect_connection_get_recv_io()
+	 * will see it and return NULL. And we don't
+	 * need to get the lock here again, while
+	 * trying disable_work_sync().
+	 */
+	list_for_each_entry_safe(recv_io, recv_tmp, &sc->recv_io.free.list, list)
+		disable_work_sync(&recv_io->complex_work);
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
+	list_for_each_entry_safe(recv_io, recv_tmp, &all_list, list)
+		smbdirect_connection_put_recv_io(recv_io);
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
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
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
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"destroying rdma session\n");
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING) {
+		/*
+		 * SMBDIRECT_LOG_INFO is enough here
+		 * as this is the typical case where
+		 * we terminate the connection ourself.
+		 */
+		smbdirect_socket_schedule_cleanup_lvl(sc,
+						      SMBDIRECT_LOG_INFO,
+						      -ESHUTDOWN);
+		smbdirect_socket_cleanup_work(&sc->disconnect_work);
+	}
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
+	 * we should call smbdirect_socket_destroy()
+	 */
+	smbdirect_socket_destroy(sc);
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"status=%s first_error=%1pe",
+		smbdirect_socket_status_string(sc->status),
+		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+}
+
 __maybe_unused /* this is temporary while this file is included in others */
 static int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
 					     enum smbdirect_socket_status expected_status,
-- 
2.43.0

