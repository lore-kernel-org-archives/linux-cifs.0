Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE3B379EEF
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 19:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791313765; cv=none; b=Zk2f9g1khXQVvh04QUeMCYJ9LP2cqsRkiifpwcUEiOFLTvGs7ZNmwNQMldT8nEcuzOh0NJS626fax5xpSqxtQhR3dtjETYEM0TbMQv+7XDmcT2AeVtHLhR2PBsERkEOabeUH657z0FQsE7WOluil9U3Jf/ANbkKW6Ml5Pq3Bti0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791313765; c=relaxed/simple;
	bh=1fDOMiRlHcBFy1MLY6Ai2P1mEMqW7pFhU9ue/IqV8z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvlQJ6/5NkYx0B80XUeAg1zMy2ezUa5aCmC19jmQRDLW8MwFYXHTWtdz+sUUmtSmLodOicd10VKRELCK+YMSX/45iG4qihzFSHgKNv9QSdP1ERwjDge2tvTEMSNkKzfQiXPr/4hgQsLNHfqRvlRZ16LUf+78kBnir79gf9WCG0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=sFeHzbLa; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="sFeHzbLa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=h79AOdrxTKKNygZZCItSeFSWIpuFuSp0XJ1K/7DOZDQ=; b=sFeHzbLaetOJSTMgDFjf9rSuM3
	OBNVYJS83MdGmxQAqb16UxRKtUXGwobjTrIhWmHv1gBDMnv59tbdr6SU+xP6VvmWO+wAguhdKuv8G
	ZMV7hBMJwdR4+voZA1bf4mQmtBvEhx57sQ1GUdhKHGxcXtK4SKTSj+Q/CvBrmzizgTkxCz56rK8jg
	khSq7b+FTjaEkUv8wFBoF0L5Y17cLSxjfgd+3n1z8mp8gwOhXIDwAk4JoJFEftHBTSumw+vj1tc2y
	uDJUATqW5yF9mI2FDh35YLyc7rcw2Q8FfuwWVXQv8ofzZZSUOZLGs8geoTtRbIK0BUaQc+kc3AOlt
	ndv1empYX14KMKuKOCj+/WfH7KEYik8AtkkeLcXW6/fBJ6Q3Oow6rLbB66M4eN6Kgtz4DE9fFiBp5
	xtCvtVS+fLHooWMumh0afIb0SCvjwfu28OQZTYcTVE9AFlLW7B1Gc6ppXAsVPTx5/39kKGbvDQQ7/
	lCFYWdqV5fohOlNbNTOyrk7H;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xEAXQ-00000005yBL-40Hr;
	Tue, 06 Oct 2026 19:09:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v3 3/3] smb: smbdirect: don't hand out already failed sockets in smbdirect_socket_accept()
Date: Tue,  6 Oct 2026 21:08:57 +0200
Message-ID: <a872f06c6a1a5400a57cd2089730de94c9aa875d.1791311817.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791311817.git.metze@samba.org>
References: <cover.1791311817.git.metze@samba.org>
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
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/accept.c | 71 +++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 10 deletions(-)

diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index 9353c7647735..1ef819511f6f 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -822,7 +822,11 @@ static long smbdirect_socket_wait_for_accept(struct smbdirect_socket *lsc, long
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
@@ -830,8 +834,12 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 						 struct proto_accept_arg *arg)
 {
 	struct smbdirect_socket *nsc;
+	bool orphaned;
 	unsigned long flags;
 
+again:
+	orphaned = false;
+
 	if (lsc->status != SMBDIRECT_SOCKET_LISTENING) {
 		arg->err = -EINVAL;
 		return NULL;
@@ -843,7 +851,7 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 	}
 
 	if (list_empty_careful(&lsc->listen.ready)) {
-		int ret;
+		long ret;
 
 		if (timeo == 0) {
 			arg->err = -EAGAIN;
@@ -851,16 +859,51 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
+		orphaned = true;
+	}
 	if (nsc) {
 		WRITE_ONCE(nsc->accept.listener, NULL);
 		list_del_init_careful(&nsc->accept.list);
@@ -868,6 +911,12 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 	}
 	spin_unlock_irqrestore(&lsc->listen.lock, flags);
 	if (!nsc) {
+		/*
+		 * If we only found failed sockets,
+		 * we wait for the next one.
+		 */
+		if (orphaned)
+			goto again;
 		arg->err = -EAGAIN;
 		return NULL;
 	}
@@ -878,12 +927,14 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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

