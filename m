Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14FB2BEC42
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744222; cv=none; b=qZiAPU/Kfi6b/ToofpxuabU3QetOzwaQjYSkgvwSZbpj6CD9XMcCF5Qn6aFNtvrxbus4bVBBTs9SiuVamQymKPFjYsSfbUVEZxq6Qf+QOpT+TKsp0wcAcGb7rjihbBNq1sIqCTcmVAU2XFp+kKkzLrP4Vh9BQoHqxNvOq7yQfpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744222; c=relaxed/simple;
	bh=QQf5L/9JR6blrOhX4cIO/UaRY9w+D37pvcwVMlUvR70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8mhmZOx+mnE7ePf/EkfmktuzHTXuAPy/yeVmRapzpciTat6WvJjhKWa14YohN+N1mpyekj8fvQ2V7awqpZKCe8Xh04ZAjpXMT0oVSsUeQ4XyaWShrHvrmv4RUNBY2Aua1rZk5ElOfARpOcdNSJI+pJAJ1gixUpkN3X5HoWKUJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=E3laA9mr; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="E3laA9mr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=TZmLaAXpqeIVClbdHn3MsOEzdSOfsgLafNz0xtxcogo=; b=E3laA9mrgpKO8Aggzkf9x/JTiU
	DdfY4aCWc0yriHo0pK4MzNa36O47CD2JiZYxLA7Ef1nKQunmAqq2dua19MV0nURkcZzCVLtJwAFjp
	NaCUU96vHAQdTJ2kVfGeAr4j4QjcA80TK/OYy0QhaEi6siOjgwCdWmnqcNSgz63oIJYNNJgAUiFVS
	UoMEJMy7adLCEJCeLEl6meug6ioM+xjIc0p/w4K/CWGQN4T7Mv2WAnOu2KyCoqov3IF6HYYAunHl7
	XWN9nv7cBQHqCe13B0RSYwzxS7She/pt8PKXGRTeQ0dJtOCpiZiKyYe+6Fjz5jvV2GIwWzBe9hQJp
	Uf7mnn297omLsnpuVOy6Qjz4A430Tti7b6tGh0/uPExDzPMU/YzxOE3dFtkfwwJ8KyFZba5PW9pAH
	wEFMp3/IAPIODDy8oSD7OdxcGtlJxXdqn4PqlDPqjYJ9jBzwY4DR7Ws0FVh93iE3cQzxi5kt7tbE6
	l9vqYDl2MfVgJXGUIK+fxx/U;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE69K-00BbLf-0C;
	Wed, 29 Oct 2025 13:23:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 011/127] smb: smbdirect: introduce smbdirect_connection_disconnect_work()
Date: Wed, 29 Oct 2025 14:19:49 +0100
Message-ID: <b58745db371ade63c3a49b716b0afffb38143f73.1761742839.git.metze@samba.org>
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

This is basically a copy of smbd_disconnect_rdma_work() and
smb_direct_disconnect_rdma_work() and will replace them in the
next steps.

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
 .../common/smbdirect/smbdirect_connection.c   | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 654719f4388a..ebf47baa5d25 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -6,6 +6,8 @@
 
 #include "smbdirect_internal.h"
 
+static void smbdirect_connection_disconnect_work(struct work_struct *work);
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 					    const struct smbdirect_socket_parameters *sp,
@@ -23,6 +25,8 @@ static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 	 * Remember the callers workqueue
 	 */
 	sc->workqueue = workqueue;
+
+	INIT_WORK(&sc->disconnect_work, smbdirect_connection_disconnect_work);
 }
 
 __maybe_unused /* this is temporary while this file is included in orders */
@@ -62,3 +66,67 @@ static void smbdirect_connection_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->mr_io.ready.wait_queue);
 	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
+
+static void smbdirect_connection_disconnect_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, disconnect_work);
+
+	/*
+	 * This should not never be called in an interrupt!
+	 */
+	WARN_ON_ONCE(in_interrupt());
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
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
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
+	smbdirect_connection_wake_up_all(sc);
+}
-- 
2.43.0

