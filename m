Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3F932A3CC
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093515; cv=none; b=n5g+JP3tH+wn2mQcYd9azL+qiFgvSkjrSyD+qw9fFFRAgJtOfMMB/KEhJPcqy9iCr7jYfEXxXaHMTcriuE5pEu76Guq41aHpULLnmN5auqqq7B4CblKvpbhxIX/8mAdvQxyYHiwu8IUSnwY6vVHzjwLKVKSFpWX2tdFcOD6gs7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093515; c=relaxed/simple;
	bh=FBODv2F3ZPpxenBFZvJLTt2rjafpYVCuo3LHfBTm7OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYLlGahUfFl3NzDa/M0zNl7gCyc68Vcmwx3LKGcXdT4hxZVzBfzj0B1S/629yN/lzAUXcwQxqTkUNfIbyF29eLncnVYIBSE7vXhkVesvSULQKJI8WTswxaIcPVFVTWJL4sm6jNPpVJ5soo1y85RCHjYzT5ZCBHiXbCkcShE9fOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Dt0Cn38T; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Dt0Cn38T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=9HP11oIEtYNGTRt2RrGuDZbXywFyoQoFDw9ZZl7qqJQ=; b=Dt0Cn38T3u5IaE5ktSMN7r6LIT
	iRsR8P6YvqL8AQvEOtYgs4oprzocl3OFWb0G0zQd+7hDK13F0errJYBRhZw4nJZnJdJHG3udnOa2W
	VrEtTkboXtMGRx/R7y2wbhMaUG530xB/h0bqnQ80XshFfg3rW22EZOVyXii3dOZvha4Gb9pPCUcr4
	bALS2TDGnLdvN1pIK78wOLdtoJWvzBPJ+XjLn+sYPUK9+Auz8RNTEbEqrWKkwyycU3VRESFsBDbQm
	pqu9iqi6kvWuYnUzNSMywkRU+C3i0fkPd93WlsCL8YZgErWgclnhyG3an4F2r76QRHdBdAYl2KxkZ
	R5IKJj3c1dC3SucX8lkRAz6OYQjcnxYbOcpY4xFtGBpus9hKyTXqDxBG7XX4BJrJMcc1sqIeqacGo
	JvEl7P+tix3+XFePer5knlvla8W07pny7p9ojsXj0/NATuN+WjHS3+kuTU3Z5qJOQsytpDyFjriMq
	F/NCcDbJbJ1fjXX88cp00lfk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxJ6-00Fclf-08;
	Tue, 25 Nov 2025 17:58:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 018/145] smb: smbdirect: introduce smbdirect_connection_idle_timer_work()
Date: Tue, 25 Nov 2025 18:54:24 +0100
Message-ID: <218c4d55d54305c610732df83188609d09d3389d.1764091285.git.metze@samba.org>
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

This is basically a copy of idle_connection_timer() in the client
and smb_direct_idle_connection_timer() in the server.
The only difference is that the server does not have logging.

Currently the callers set their own timer function after
smbdirect_socket_prepare_create(), but that will change
in the next steps...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 31 +++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_internal.h  |  2 ++
 fs/smb/common/smbdirect/smbdirect_socket.c    |  3 +-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index aa554527f993..f3176bb35977 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -92,3 +92,34 @@ smbdirect_connection_reassembly_first_recv_io(struct smbdirect_socket *sc)
 
 	return msg;
 }
+
+static void smbdirect_connection_idle_timer_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, idle.timer_work.work);
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+
+	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
+		smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_ERR,
+			"%s => timeout sc->idle.keepalive=%s\n",
+			smbdirect_socket_status_string(sc->status),
+			sc->idle.keepalive == SMBDIRECT_KEEPALIVE_SENT ?
+			"SENT" : "PENDING");
+		smbdirect_socket_schedule_cleanup(sc, -ETIMEDOUT);
+		return;
+	}
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+		return;
+
+	/*
+	 * Now use the keepalive timeout (instead of keepalive interval)
+	 * in order to wait for a response
+	 */
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->keepalive_timeout_msec));
+	smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
+		"schedule send of empty idle message\n");
+	queue_work(sc->workqueue, &sc->idle.immediate_work);
+}
diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 93c10b4f1ed5..7465a63118bd 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -33,4 +33,6 @@ static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 		__func__, __LINE__, __error, &__force_status); \
 } while (0)
 
+static void smbdirect_connection_idle_timer_work(struct work_struct *work);
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index a73162717ffe..37b483d8203b 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -27,6 +27,8 @@ static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 	sc->workqueue = workqueue;
 
 	INIT_WORK(&sc->disconnect_work, smbdirect_socket_cleanup_work);
+
+	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
 }
 
 __maybe_unused /* this is temporary while this file is included in others */
@@ -66,7 +68,6 @@ static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
 static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 						const char *macro_name,
 						unsigned int lvl,
-- 
2.43.0

