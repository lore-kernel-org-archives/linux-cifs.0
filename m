Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7460F4D9F77
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 18:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791225426; cv=none; b=j/wkS/Agbb+prpzSoYHomWI2MT1l2a5ASuhwDACMwA2LAUd+dMf2XV6aGkVy3PMwNovBjnsO/jBGhX9BChxfre8puvyDkuv39BlXm+6XLfbTENlv7OZnROkLLSVDA9dDbzeUE4EvZk3mEUbAII+mUt7jbuMVid2LXlTy5Ce5kM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791225426; c=relaxed/simple;
	bh=uUi2G1oFX4LYKq5stMPYjvlydNBQ1aHvRIeCN5epRvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmlHXimcog/DY4/8ENc8+Uc5YlchwHjJ9V2j/0kaft5SS8VkyquWViEXFbsCs6YvxTaqvyIq81L8J5vKTqSjmzIHkutOo//CPPeb195fJq2mmYPqI7rddwjkFMDtSHSMgY46fmPAVaSqOe9gi8C4Si/r2hk8ALdiQ4dQ2+G7CtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=FbocDQje; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="FbocDQje"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=TgfErPBJ9SL1dUKeYoklxKaLD5CEPz4qjqFU0XEzMAM=; b=FbocDQjeFlv2Bh9eQpSdY7I0lH
	dPrHF61w/7WaqnkF7NTT5bxag3m+ar5MV6NZ1cIksnAdgxkEjXw9J7pz5lBHnl4/xE2RoNgTioDS7
	FnBcHQPxrZA0We1kvfbGFF75Cf8HMdjWBBEqYkfL9utjyKNKs9tV3xrz8EsIm2ILMtLcm/ck9XNZy
	V64Yvw7l4fPrPS06n9shZC1lxzZ6BUC8jAYO2dD4976rHSETn1w8imwMp6kS13a0mB1rPmASsL8lw
	CdnASIsckh4g5/O3X+wVlge5dhDxEq/wtPldFru8l7Kl0PMSmVg2vX2cfus+31EVcCVxtQaW7j5r8
	NHD+opRRfNrQZnUEDWNSRHVyMk27eDOt7d4eP0M7/lIVNdhWi6wN1yA9pR+7HtdMlfPf6eov1/UVk
	rQeO37DZcMn7kZKEgZYbYa16YTva7+Q0/62UfkRcOv31bLXW0WFy58iWtJWGR9BN2OZVa+G2LMKif
	D5uazhzJTW4EH5SsBURX/ty3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDnXt-00000005erl-2fiZ;
	Mon, 05 Oct 2026 18:36:17 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 3/3] smb: smbdirect: don't hand out already failed sockets in smbdirect_socket_accept()
Date: Mon,  5 Oct 2026 20:35:52 +0200
Message-ID: <3f341ddacb503cc581f853c7e283f40fab6f1495.1791224972.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791224972.git.metze@samba.org>
References: <cover.1791224972.git.metze@samba.org>
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
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/accept.c | 55 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 7 deletions(-)

diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index 1da95cdd1ebd..ee16be95424d 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -834,8 +834,12 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
@@ -862,9 +866,38 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
@@ -872,6 +905,12 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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
@@ -882,12 +921,14 @@ struct smbdirect_socket *smbdirect_socket_accept(struct smbdirect_socket *lsc,
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

