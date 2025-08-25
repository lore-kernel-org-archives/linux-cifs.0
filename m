Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9CC2628C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154796; cv=none; b=QhWbhz4oI9mbHUQtKqe4aKZDJNUq0vCP0lwnfosd7neEEee+cxqs0E8BkknMlyYgLl7Kq11D1MiYp+C7gfyCvoffOMpx7lXtMpg4eZe2xfmx9h+GUPgCXBM4+qNzhioisfCnQypfNTVBkC4M80QWDuT7vxrU8sCZq7HJkBWoAJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154796; c=relaxed/simple;
	bh=yl5Cieu+XSvufdP4WKAAY2nEUlBsvwCwthyqDdGYXAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apTK8Esb9cLuEq2OwSHBU+D40RGzq3gdJagOjFJUhiP//rtyxptFIYYjAh5noeyltSg9XPDcqZoKsjf1xav2vmMay6nLMcK82Mrhq/DqORY9Z1uFHQGrPYPucSTCPCzQdQsxHR/9jJf0QyHSCZTmH6egRNCKrQKAzDh74a5+NVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=cs7gmX1D; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="cs7gmX1D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Qb2fAEaHjcANocrtDk9gR/XktuPPLROzzTlTDhEBXK8=; b=cs7gmX1Dcmf7HyY5gWrzqbwHzF
	+bG2fhjV9HiQgq+RmtwDDUn4sonNwymq4RGWY7T+tyu5B/z/svOH7T6ygIZuFJOa7NPeKlxj/N6As
	xlJeEg69M+66pnNZ6eqwrTUZAaOQvDYA3d/Lrq1n3t1WrlqfQ/OU1q5D+fFvI9KR3M8noUTpq7hQI
	SOPLzArWiXrKAOTTXnO66drmQ0tAnBgari7luewBIk+LFcRB89I4cDddEWF/l/iJRk7sQheuvCy24
	svba9LbmbShVR+bhUo4LNPsm7tPG0HFNW1AA6pFrWnPO2PSkoK7SYe5BekhAQYpmYSsIi0E8eoVOF
	y8gVpgSZ5vdbMDdtfH9Biz+rQoTpnLQjqG8AMHkkAlGXoQELdNGNYEU8AkLJUqGc8KRkB0YJWEmtv
	+Wo0Inasx2L2dPH94WnrHVtOj4NOMk+DqreknCdE7IRyeedKLWszRcr/IpAgtNcurDdktBzCq5UQd
	nKbab2avHYUgd7iURYQTUw25;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe5I-000k7S-0c;
	Mon, 25 Aug 2025 20:46:32 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 028/142] smb: client: make sure smbd_disconnect_rdma_work() doesn't run after smbd_destroy() took over
Date: Mon, 25 Aug 2025 22:39:49 +0200
Message-ID: <3bd62ae3cf284c59c20ed7b756f8e619a93fb5dc.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we're already disconnecting we don't need to queue the
disconnect_work again. disable_work() turns the next queue_work()
into a no-op.

Also let smbd_destroy() cancel(and disable) queued disconnect_work and
call smbd_disconnect_rdma_work() inline.

The makes it more obvious that disconnect_work is never queued
again after smbd_destroy() called smbd_disconnect_rdma_work().

It also means we have a single place to call rdma_disconnect().

While there we better also disable all other [delayed_]work.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b9ee819aea79..eab8433a518c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -159,6 +159,18 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, disconnect_work);
+	struct smbd_connection *info =
+		container_of(sc, struct smbd_connection, socket);
+
+	/*
+	 * make sure this and other work is not queued again
+	 * but here we don't block and avoid
+	 * disable[_delayed]_work_ync()
+	 */
+	disable_work(&sc->disconnect_work);
+	disable_work(&info->post_send_credits_work);
+	disable_work(&info->mr_recovery_work);
+	disable_delayed_work(&info->idle_timer_work);
 
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
@@ -315,11 +327,13 @@ static int smbd_conn_upcall(
 		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_FAILED) {
 			log_rdma_event(ERR, "event=%s during negotiation\n", event_name);
 			sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+			smbd_disconnect_rdma_work(&sc->disconnect_work);
 			wake_up_all(&sc->status_wait);
 			break;
 		}
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		smbd_disconnect_rdma_work(&sc->disconnect_work);
 		wake_up_all(&sc->status_wait);
 		wake_up_all(&sc->recv_io.reassembly.wait_queue);
 		wake_up_all(&sc->send_io.credits.wait_queue);
@@ -1436,9 +1450,12 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	sc = &info->socket;
 	sp = &sc->parameters;
 
+	log_rdma_event(INFO, "cancelling and disable disconnect_work\n");
+	disable_work_sync(&sc->disconnect_work);
+
 	log_rdma_event(INFO, "destroying rdma session\n");
-	if (sc->status != SMBDIRECT_SOCKET_DISCONNECTED) {
-		rdma_disconnect(sc->rdma.cm_id);
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING) {
+		smbd_disconnect_rdma_work(&sc->disconnect_work);
 		log_rdma_event(INFO, "wait for transport being disconnected\n");
 		wait_event_interruptible(
 			sc->status_wait,
-- 
2.43.0

