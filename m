Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7074ACC7A
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791229284; cv=none; b=KMoxxKyU1LJOCzbvcATt7wPuOaJyaB9O8wYHIubLWgwBlk03S/M+YhyH8qTyt4m/VA5i2NjNMKV6WbDyp4zlQ5pOPx82tADh6c+Wlqxrg4x+PV72r0InLo9YtBerJGa5PSJmIdgVXit0GJ0R18SY8qfveguOGsV+Y6qENfX1OJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791229284; c=relaxed/simple;
	bh=T1a4QMTXXr3KIEJdSNqHSxyvHmbAfRerlT6XDW98iPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVblT5rYl/D7Ck9qSryuDG81Tc+ysAfch3XQ9oOxMO+B8wzCIYZXkERgpqCAhHrKILh+C1trQOt1S9w+QjoEeWD4qTKxY/cNhmXCkmINcxhyQdcOPuB+YZQTI3UsOr8JHtrm+8EEWGvNAps1Qgg8DWVtlnbq13SP9jTKu+/ofhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=LkiM17nd; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="LkiM17nd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=woDH1gu3jmDGiZn2SkdXkmm2DhPPsSv3wZRCAUI2JTI=; b=LkiM17ndqufdrbDYpivnv8aFLR
	H23Kdvkb56gUIoyoypsApVdkOIWWkvSK/U90gNaxsnc57ErkZ+/KWFQ/TV7hJB80vXvWe+YS9u36W
	s+ilee8XyNipf26Q3BUFp4yypo/3slkm2VDr5uqVWUvqrsep17ZFUYPFQ+dPczM8fOV7Fg08WP2I/
	WV2nyM1kQ29t9a131a1D6L4yO/SZJk531rXNWra2ScM/UNdcWOxnsA55eXk/+pbxvMhtt8h8wOit5
	rPZUVWrbF/cbwPseffWXtdI8PNv0+t31u5ZLxYScRvDCwdB0GEtkeJKJSAtJpkRmKCxpgXR7w3Jq8
	t7ichw41V7oZmOBNZOvoTA9WrQKwaW8ylzkLQxQe3mt0cutJfI6mlAhXEROpA+7uMuU+vxrntH/Mf
	RnYZFVEtKc2eCTUzsKlaFpww6TYpg9l6orZtMwdmQqZSkoyd38zpqDCg2j/e+fPUBpT4RLz21zgB4
	LOkOhcYTUsQMcUuSL3gJLCGs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDoYq-00000005g3F-11jt;
	Mon, 05 Oct 2026 19:41:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 3/3] smb: smbdirect: don't hand out already failed sockets in smbdirect_socket_accept()
Date: Mon,  5 Oct 2026 21:40:48 +0200
Message-ID: <44a0c706a7722d8b776266661129857eeea76a1e.1791229120.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791229120.git.metze@samba.org>
References: <cover.1791229120.git.metze@samba.org>
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
index 1da95cdd1ebd..d901e240599f 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -826,7 +826,11 @@ static long smbdirect_socket_wait_for_accept(struct smbdirect_socket *lsc, long
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
@@ -834,8 +838,12 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
@@ -847,7 +855,7 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
 	}
 
 	if (list_empty_careful(&lsc->listen.ready)) {
-		int ret;
+		long ret;
 
 		if (timeo == 0) {
 			arg->err = -EAGAIN;
@@ -855,16 +863,51 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
@@ -872,6 +915,12 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
@@ -882,12 +931,14 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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

