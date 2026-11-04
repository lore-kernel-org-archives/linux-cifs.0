Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826775;
	b=pN/rdyHXhCS3bBcrA9SKUllz5kAKMaBq1AWYakWOpDY2bOZ2n6y4y4c0QJLw14BNJg5k
	 geT0QWRPcwVglfq0WBwPa5w7k9p20usAV+/+cxGPDWAXsqpUJQJ89+CoYuWQp0D6+spYO
	 GeTZZ+90+Wm1/uI06oXBZwteNNemSDM3SJ4YWBFKNFsGXfeTctHRNe4pllvTeTP/vPxdn
	 vf6wnLS/XzlmKYXTunVwdKJFR2p0O1gBxxUSbLRPyoX6QtYBX0ZFaQeWMUqV2XJFESVgF
	 m8Vef+jza74YOm++W/pGLlW6jgad9u82oH7YrLsd23JPFnhybOYWix/OoZQdgKQaE8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3gtS1/svOyWhkBPfL3gvfbVeg7Of2X1XI8k7rUnAoOc=;
	b=gvbt8YxUr/s/9imYQWs+6sehPpk325Sqpy8R2C86dZBBjnXQFaD/QIwSvljTorM5FQXn
	 afrjXhAZf+mWjKSlkKwAFh4Ddpsu3QvTJNsHQb55Vrq8irlItX+ilN6VR9TOpU2n4/Rh6
	 t/GmN7Bj7B6o0sV98Lm4vQCtNRUU5rmPa24YpWy/skX7C8yfEKf/+7T2J+tQY3bw1PUfV
	 oWoFqR30fAJog8xNR3c6/PYWfehnm9WJ94ClNZNVtbxbJICMD8v9pFzyF9V+xgY4lKkVy
	 yLXtgHPc3PTzV9m7ruv1wy+mz5K9H6n0c284QhBQq1yI9dn+OqQ9Lt62S6pB4dN0k0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7p0ddqn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD766071AC1;
	Wed,  4 Nov 2026 21:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7p0ddqn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CF51F00A17;
	Wed,  4 Nov 2026 21:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826775;
	bh=3gtS1/svOyWhkBPfL3gvfbVeg7Of2X1XI8k7rUnAoOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7p0ddqn+n9nUwL2wkiO408DpWgr6oSoReOuLFoLso0U8/Y0KJcGeIB6c0Gj4s6Mz
	 zKcKoWD023WJwrlBE9jF/7sbvPzIY6w5Q02sHQK2CmPBxon/1rTZYipmOC17c3dsHN
	 dUwNbEsK35z6tNewonpW8QUucBIU6OTRR0RND4YY=
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
Subject: [PATCH 7.3 005/547] smb: smbdirect: dont hand out already failed sockets in smbdirect_socket_accept()
Date: Wed,  4 Nov 2026 16:03:09 -0500
Message-ID: <20261104211038.549372433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9771444429742..e7e5eb75a5aea 100644
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
2.53.0



