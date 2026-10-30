Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362531;
	b=X8oaWwlmklryDMuyLG0SJfBsW3RVEflD3CksG9qLnaRrP+y5vw8btQOS5p0N0U7WUY6n
	 p5TISlvhReNhMNqlB50I105/B+W2vO3v+VOj/IDzPFoH0Mc7jwWBG4NVtxqyGhzp3FCuD
	 8Bbfl1pELXdhBAh2po5MdQkLu3gmW+ZHn0Wq2pdMDNKA/yldTc0+ZAfDUh+7KIEY2ehun
	 KOZOSKiAgzzgOo+XcWOy3Tu/pN37gEbDC0t5WdlStP44lvEmpc0yyH6+u8mZjR/5HVb4I
	 YblM+IZGgs4it2R3Xhl/T6vjWhoioDA+kvkYuWrKim3iXeDl9QZP3BhkOr0S/SQrnuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vCeRnsGnnvvqmvc4nw1TDOUG/pyhEzsGR71rgsCX1z8=;
	b=Q63o9/6n5DuZT3VLToSWWqaLCFanF8PK7V4XjVX7XxytgEdy7ETkBaNHw6EZeZ6oayw5
	 FMLf0hzSVv69t1iTIPa1S+evMDHwu8L3QCKW+dxQA42c1Lq0J2bopwhlJX9V+yRoAFIq8
	 l8IFPC+ZtYNmh+4kPuIwon2r8ge+s7OLiHe4wjshjDCMt9vKs1nnb/pwFDIIU+vjT7+2o
	 ASm3NzIOb2AS2yiRZWaOL2+5HWrUlkpvsath5F4CGY1W/w1HKceKW1JXN1o39+b8GyW8Q
	 g5KAEyaWpwvcW/XfEYkIXyGmUocwMsFTc0KHIILR0dJkkbUkjLb4Ui+nxv6pxov2kjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McbJ+Fxs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCC3606A335;
	Fri, 30 Oct 2026 12:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McbJ+Fxs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADCE1F0093A;
	Fri, 30 Oct 2026 12:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793362530;
	bh=vCeRnsGnnvvqmvc4nw1TDOUG/pyhEzsGR71rgsCX1z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McbJ+FxsjwUu+jWo7sRN3BGYH6a7PJfYAzozTv+CPFXcYKs8dxrTp9tWhLF1D+EVK
	 OfAGHEa9sVBkRfKBFhKWDunPb8bzd9AW7ddjFaaCJ7HvsMqedDLKR+x87iOsFA4xiY
	 84nPNoscbeb1YhtSxGgebAauZffMAbOxOgs84M7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 04/10] smb: smbdirect: dont hand out already failed sockets in smbdirect_socket_accept()
Date: Fri, 30 Oct 2026 13:15:05 +0100
Message-ID: <20261030121255.365084170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 5c171c90c446bdce80ebaecfc5ed2c410bcc7427 ]

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
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/smbdirect/accept.c | 84 +++++++++++++++++++++++++++++++++------
 1 file changed, 72 insertions(+), 12 deletions(-)

diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index 66db978bd8f73..d1bc08ac97575 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -835,7 +835,11 @@ static long smbdirect_socket_wait_for_accept(struct smbdirect_socket *lsc, long
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
@@ -845,6 +849,7 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 	struct smbdirect_socket *nsc;
 	unsigned long flags;
 
+again:
 	if (lsc->status != SMBDIRECT_SOCKET_LISTENING) {
 		arg->err = -EINVAL;
 		return NULL;
@@ -856,7 +861,7 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 	}
 
 	if (list_empty_careful(&lsc->listen.ready)) {
-		int ret;
+		long ret;
 
 		if (timeo == 0) {
 			arg->err = -EAGAIN;
@@ -864,16 +869,64 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
@@ -881,8 +934,13 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
@@ -891,12 +949,14 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
2.53.0



