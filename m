Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5877232B987
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093496; cv=none; b=k/SCb1MhgyNoDH8KKudxeRuudhDJfEubjOKzINMZ5KxSjm66I9CEvaAk00JcFopjgRcKwAj+b+sZqThvh3yPtRnhJb72C17ihRAZ5eJL5kikRNqPgr1EoXjduNq8a/yoOjGQ+5xxaY+iEyZVffVseY+jSPjp4lw1WsUFDc4ioZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093496; c=relaxed/simple;
	bh=+DRxn4GTnZrv8NKuXcd3kG5yf2nzWjHu4KCsKo3LYuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3FbyJ7NFDL6cU86b5FUMECeiJkKGE/iG/zTST4s+eBrpubIOMx+sidte6IvkqyL9vxXvNFIuziowSDL4ilc5MjmaWGTrAa6Lw9YjWgaun7TiHUzzJGiX+nc3ni9WbYeHp+1sTHpmsPRTYWpPJ3h0ZkrEhPKBB3x5JsICMCovXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QlqTdIUv; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QlqTdIUv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=wRnUIHVyYLcqT92m4N+lRFGCGEJ9EcjeeSuKIWQLt+o=; b=QlqTdIUvqYtSnprHlFb4skQmGJ
	Fd/XGTM98JoOpV0PIKRwLvP3wBEJl66XtDRsrSonyTG6qf5cU5SLwj5/qArWaAI6mMiYlkTbdWWAv
	mN0Ve9016jtZu+yZoDTpWlSfUsvwQq365jTtTh9L3/TeqWEwrDtzGFL/X44QBk65DxvTwHi1Fj9Ui
	+gTXL2go7cfhy1QlJXoYMrOV9yMteBKP9pCt0URnShwqt/eGnG2N9naNAM+MWlz4Cdn0SoWcgbb5a
	McjHZ56bxGnwkrlPXyXdsNeQKdecLo/wg0XZdJ1Y7ruDWP0kf5gtX4hd3Ty3aFJszYvAkOU2F16UV
	PBgMh+/UWKIZmDhfcLsmh4uxI/G0TOs75NGoXKSUZLxFI8P+dcSZ5/59SkrX44PiFWY44TqvtdHi+
	IdHyrc95Xia6WCgQQGn6YePRkKBiHdzJb8T1Nx/xBB1cF2t0bPL3Xf35VZBeBlXFVG9r73lvnFskL
	qEmav/5iDUfQK2aNBE1AzBDk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxIj-00FciI-1z;
	Tue, 25 Nov 2025 17:58:05 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 014/145] smb: smbdirect: introduce smbdirect_socket_schedule_cleanup[{_lvl,_status}]()
Date: Tue, 25 Nov 2025 18:54:20 +0100
Message-ID: <e5f7be563836812286ea5e8db709947b21c98c30.1764091285.git.metze@samba.org>
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

smbdirect_socket_schedule_cleanup() is more
or less copy of smbd_disconnect_rdma_connection() and
smb_direct_disconnect_rdma_connection(). It will replace
them in the next steps.

A difference is that the location of the first error is logged,
which makes it easier to analyze problems.

And also disable any complex work from recv_io objects,
currently these are not used and the work is always
disabled anyway, but this prepares future changes.

It also gets an explicit error passed
in instead of hardcoding -ECONNABORTED.

Beside the main smbdirect_socket_schedule_cleanup()
there are some special additions:
- smbdirect_socket_schedule_cleanup_lvl(),
  will be used for cases where we don't want
  a log message with SMBDIRECT_LOG_ERR.

- smbdirect_socket_schedule_cleanup_status(),
  will be used to specify the log level together
  with a direct final status, for the
  RDMA_CM_EVENT_DEVICE_REMOVAL and RDMA_CM_EVENT_DISCONNECTED
  cases where we need to avoid SMBDIRECT_SOCKET_DISCONNECTING
  and rdma_disconnect() in smbdirect_socket_cleanup_work().

With this we're also able to define a default
for __SMBDIRECT_SOCKET_DISCONNECT() just using:
smbdirect_socket_schedule_cleanup(__sc, -ECONNABORTED)

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_internal.h |  22 ++++
 fs/smb/common/smbdirect/smbdirect_socket.c   | 110 +++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_socket.h   |   5 +
 3 files changed, 137 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 0727b9fee879..93c10b4f1ed5 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -11,4 +11,26 @@
 #include "smbdirect_pdu.h"
 #include "smbdirect_socket.h"
 
+static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
+						const char *macro_name,
+						unsigned int lvl,
+						const char *func,
+						unsigned int line,
+						int error,
+						enum smbdirect_socket_status *force_status);
+#define smbdirect_socket_schedule_cleanup(__sc, __error) \
+	__smbdirect_socket_schedule_cleanup(__sc, \
+		"smbdirect_socket_schedule_cleanup", SMBDIRECT_LOG_ERR, \
+		__func__, __LINE__, __error, NULL)
+#define smbdirect_socket_schedule_cleanup_lvl(__sc, __lvl, __error) \
+	__smbdirect_socket_schedule_cleanup(__sc, \
+		"smbdirect_socket_schedule_cleanup_lvl", __lvl, \
+		__func__, __LINE__, __error, NULL)
+#define smbdirect_socket_schedule_cleanup_status(__sc, __lvl, __error, __status) do { \
+	enum smbdirect_socket_status __force_status = __status; \
+	__smbdirect_socket_schedule_cleanup(__sc, \
+		"smbdirect_socket_schedule_cleanup_status", __lvl, \
+		__func__, __LINE__, __error, &__force_status); \
+} while (0)
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 2688866fffe6..a73162717ffe 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -66,6 +66,116 @@ static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
+						const char *macro_name,
+						unsigned int lvl,
+						const char *func,
+						unsigned int line,
+						int error,
+						enum smbdirect_socket_status *force_status)
+{
+	struct smbdirect_recv_io *recv_io, *recv_tmp;
+	unsigned long flags;
+	bool was_first = false;
+
+	if (!sc->first_error) {
+		___smbdirect_log_generic(sc, func, line,
+			lvl,
+			SMBDIRECT_LOG_RDMA_EVENT,
+			"%s(%1pe%s%s) called from %s in line=%u status=%s\n",
+			macro_name,
+			SMBDIRECT_DEBUG_ERR_PTR(error),
+			force_status ? ", " : "",
+			force_status ? smbdirect_socket_status_string(*force_status) : "",
+			func, line,
+			smbdirect_socket_status_string(sc->status));
+		if (error)
+			sc->first_error = error;
+		else
+			sc->first_error = -ECONNABORTED;
+		was_first = true;
+	}
+
+	/*
+	 * make sure other work (than disconnect_work)
+	 * is not queued again but here we don't block and avoid
+	 * disable[_delayed]_work_sync()
+	 */
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
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
+	case SMBDIRECT_SOCKET_ERROR:
+	case SMBDIRECT_SOCKET_DISCONNECTING:
+	case SMBDIRECT_SOCKET_DISCONNECTED:
+	case SMBDIRECT_SOCKET_DESTROYED:
+		/*
+		 * Keep the current error status
+		 */
+		break;
+
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_CREATED:
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		break;
+
+	case SMBDIRECT_SOCKET_CONNECTED:
+		sc->status = SMBDIRECT_SOCKET_ERROR;
+		break;
+	}
+
+	if (force_status && (was_first || *force_status > sc->status))
+		sc->status = *force_status;
+
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	smbdirect_socket_wake_up_all(sc);
+
+	queue_work(sc->workqueue, &sc->disconnect_work);
+}
+
 static void smbdirect_socket_cleanup_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index ea269f55935d..f56f2b037a69 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -574,6 +574,11 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 #define SMBDIRECT_CHECK_STATUS_WARN(__sc, __expected_status) \
 	__SMBDIRECT_CHECK_STATUS_WARN(__sc, __expected_status, /* nothing */)
 
+#ifndef __SMBDIRECT_SOCKET_DISCONNECT
+#define __SMBDIRECT_SOCKET_DISCONNECT(__sc) \
+		smbdirect_socket_schedule_cleanup(__sc, -ECONNABORTED)
+#endif /* ! __SMBDIRECT_SOCKET_DISCONNECT */
+
 #define SMBDIRECT_CHECK_STATUS_DISCONNECT(__sc, __expected_status) \
 	__SMBDIRECT_CHECK_STATUS_WARN(__sc, __expected_status, \
 		__SMBDIRECT_SOCKET_DISCONNECT(__sc);)
-- 
2.43.0

