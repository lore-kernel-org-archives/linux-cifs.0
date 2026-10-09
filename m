Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD993DAACB
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 10:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540166; cv=none; b=CkICHRbgRvOxHX0rak+AyyX5gVReAoK1dYIeCxE5N4kDjysp7sEKu7wlsGG3AC4DRAUj3OyO+0vWdC8xgXfpe2zlVllDdVksh/BPCrbT0cy16jdB7ltK5M5uBeUmZ0qvNVokvF6Ch8o6Oi/R1SfDTj8TeloicJ1b30dN0S7OupU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540166; c=relaxed/simple;
	bh=bol/NGjazsMnslyO56LpiyEoVXF6oum/VtOT4pO34lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jf4/0SZQ2NnQcokFptvITuHi1CzkeGJStnm45WCn5+qg+Gv3Y0hC02bLesLqTa9kEjkx2QQlr059CHYydsg4YqIcc75kfuVXxz//LbRl0Nl6RKtd16P1pOOzDjYxChrHB9LmhBV6VNakIrhNvt3XL65qLDUu7Q+CmggAJTsztdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=US8XzGRK; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="US8XzGRK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=8SkaMUV+G6t/AeEjae9vUTBQyFk7Wt2ZeBAN3pJ8s1Q=; b=US8XzGRKD52QRgpDMcx7PMWHxp
	lKqJWaFnobtqFcG1jtQMsg0oNWvuyn/CaBcP4ZVaHEUXcgeCaU/vi5gO7J22WJNHJEI7/k44kZShX
	Gd7nseJMifKDltnmzUCuk3+YpMsofBdYeSZ7dmSmmkmgT2Fl7Q4tEjWKZaOtXQoPj4MkxUy9vYCGV
	OZN1dz1ASGAmB8OEA+uIP6Kvh7Ie9HaABRHgqdS8oZOI2vnts7S1YS0LsG7XV2MMmn9yhDqzCZMC1
	H4hJ7nRBRXelnO5HI4tdELKUbco+JMncdhdLX1NVPsGDP95GMltywcs8IGm8jcbREYAdCesvDM0LN
	rCtp+QO8JA2YVYF3egHr5iaEN/tK7NnZSa7+++vB5gSTn8x4FqBbv+slXcSnMvJPpsYM+7sGe1nu7
	JNKOOU9xmDZIPkJcIKf9sUMVM79ldeKQiU4jFy5q8wqMk5r2oXzcpzlIzF+dgJ6geKYsjj2rISvJd
	N1Ka33f+wZSpcfB2ZmT1V5de;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xF7R0-00000000SkQ-1N7Y;
	Fri, 09 Oct 2026 10:02:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 3/3] smb: smbdirect: don't hand out already failed sockets in smbdirect_socket_accept()
Date: Fri,  9 Oct 2026 12:02:13 +0200
Message-ID: <71ecbb828da5a3fa2c82491697922b7091d455be.1791540051.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791540051.git.metze@samba.org>
References: <cover.1791540051.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A socket on the ready list is in SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
but it may fail before smbdirect_socket_accept() picks it up, e.g.
RDMA_CM_EVENT_DISCONNECTED already moved it to
SMBDIRECT_SOCKET_DISCONNECTED.

smbdirect_socket_accept() unconditionally overwrote the status with
SMBDIRECT_SOCKET_CONNECTED and handed out the already disconnected
socket. smbdirect_socket_cleanup_work() then called rdma_disconnect()
on it again, and before the recent commit
smbdirect_socket_destroy_sync() waited forever for an
RDMA_CM_EVENT_DISCONNECTED that already happened.

Now we check first_error and change the status to
SMBDIRECT_SOCKET_CONNECTED only via cmpxchg() from
SMBDIRECT_SOCKET_NEGOTIATE_RUNNING, while we still hold listen.lock.
If the socket already failed, we move it to the orphaned list and
queue purge_orphaned_work, like smbdirect_listen_orphan_socket() does,
and try the next one. If we only found failed sockets, we wait for
the next one.

Fixes: dc691b91ad16 ("smb: smbdirect: introduce smbdirect_socket_{listen,accept}()")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1791224972.git.metze%40samba.org
Closes: https://sashiko.dev/#/bug/linux-f9dbca09-30a7-4145-9bdb-4676759982c8
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/accept.c | 84 +++++++++++++++++++++++++++++++++------
 1 file changed, 72 insertions(+), 12 deletions(-)

diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index 977144442974..e7e5eb75a5ae 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -836,7 +836,11 @@ static long smbdirect_socket_wait_for_accept(struct smbdirect_socket *lsc, long
 	if (ret < 0)
 		return ret;
 
-	return 0;
+	/*
+	 * Return the remaining timeout, so the caller can carry it
+	 * over to the next smbdirect_socket_wait_for_accept() call.
+	 */
+	return ret;
 }
 
 struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
@@ -846,6 +850,7 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 	struct smbdirect_socket *nsc;
 	unsigned long flags;
 
+again:
 	if (lsc->status != SMBDIRECT_SOCKET_LISTENING) {
 		arg->err = -EINVAL;
 		return NULL;
@@ -857,7 +862,7 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 	}
 
 	if (list_empty_careful(&lsc->listen.ready)) {
-		int ret;
+		long ret;
 
 		if (timeo == 0) {
 			arg->err = -EAGAIN;
@@ -865,16 +870,64 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 		}
 
 		ret = smbdirect_socket_wait_for_accept(lsc, timeo);
-		if (ret) {
+		if (ret < 0) {
 			arg->err = ret;
 			return NULL;
 		}
+		/*
+		 * Carry the remaining timeout over, so that a stream of
+		 * failed connections that we orphan and skip (goto again)
+		 * can't reset the caller's timeout and wait forever.
+		 */
+		timeo = ret;
 	}
 
 	spin_lock_irqsave(&lsc->listen.lock, flags);
-	nsc = list_first_entry_or_null(&lsc->listen.ready,
-				       struct smbdirect_socket,
-				       accept.list);
+	/*
+	 * Recheck under the lock.
+	 */
+	if (lsc->status != SMBDIRECT_SOCKET_LISTENING) {
+		arg->err = -EINVAL;
+		spin_unlock_irqrestore(&lsc->listen.lock, flags);
+		return NULL;
+	}
+	if (lsc->first_error) {
+		arg->err = lsc->first_error;
+		spin_unlock_irqrestore(&lsc->listen.lock, flags);
+		return NULL;
+	}
+
+	while ((nsc = list_first_entry_or_null(&lsc->listen.ready,
+					       struct smbdirect_socket,
+					       accept.list))) {
+		/*
+		 * nsc may have failed after it was moved
+		 * to the ready list, e.g. RDMA_CM_EVENT_DISCONNECTED
+		 * already moved it to SMBDIRECT_SOCKET_DISCONNECTED.
+		 * We must not overwrite that with
+		 * SMBDIRECT_SOCKET_CONNECTED and hand
+		 * out an already disconnected socket.
+		 *
+		 * Doing this under listen.lock means nsc
+		 * still belongs to us, so we can just move
+		 * a failed socket to the orphaned list,
+		 * like smbdirect_listen_orphan_socket() does,
+		 * and try the next one.
+		 */
+		if (!READ_ONCE(nsc->first_error) &&
+		    cmpxchg(&nsc->status,
+			    SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
+			    SMBDIRECT_SOCKET_CONNECTED) ==
+		    SMBDIRECT_SOCKET_NEGOTIATE_RUNNING)
+			break;
+
+		smbdirect_log_rdma_event(nsc, SMBDIRECT_LOG_INFO,
+			"orphaning failed socket status=%s first_error=%1pe\n",
+			smbdirect_socket_status_string(nsc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(nsc->first_error));
+		list_move_tail(&nsc->accept.list, &lsc->listen.orphaned);
+		queue_work(lsc->workqueues.cleanup, &lsc->listen.purge_orphaned_work);
+	}
 	if (nsc) {
 		WRITE_ONCE(nsc->accept.listener, NULL);
 		list_del_init_careful(&nsc->accept.list);
@@ -882,8 +935,13 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 	}
 	spin_unlock_irqrestore(&lsc->listen.lock, flags);
 	if (!nsc) {
-		arg->err = -EAGAIN;
-		return NULL;
+		/*
+		 * If we only found failed sockets or no socket,
+		 * we wait for the next one.
+		 *
+		 * A possible -EAGAIN/-ETIMEOUT is handled above.
+		 */
+		goto again;
 	}
 
 	/*
@@ -892,12 +950,14 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 	 * so it didn't grant any credits to us.
 	 *
 	 * The caller expects a connected socket
-	 * now as there are no credits anyway.
+	 * now as there are no credits anyway,
+	 * above we already changed to SMBDIRECT_SOCKET_CONNECTED
+	 * under the lsc->listen.lock and with cmpxchg.
 	 *
-	 * Then we send the negotiation response in
-	 * order to grant credits to the peer.
+	 * Now we send the negotiation response in
+	 * order to grant credits to the peer,
+	 * as the socket is now visible to the application layer.
 	 */
-	nsc->status = SMBDIRECT_SOCKET_CONNECTED;
 	smbdirect_accept_negotiate_finish(nsc, 0);
 
 	return nsc;
-- 
2.43.0

