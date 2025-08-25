Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A502AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154871; cv=none; b=b8+FRTssrhygFdoBIBqWmg5yeagMsimUbYr3KUHzRwKFgqqF1U023JWuz+VUDXuOxU58FI7ztu+joYNq13D2rXlyADjP+Ntm+0oRCs6OtHlri/4A1TzW2AtuvZT9u3lF8OFDFyhrTJdqujdUHEYIusQfCnF6buXWoZZ4IgMOBms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154871; c=relaxed/simple;
	bh=rbLYBDwSTWwN+Fr6BgiaQkbZyWjFsg6AUDZJ5Fe2Vlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWs9N5ea/6pvWa/Yjz1QUAopmjCQL6mp/7vmyAHTq3yWfChGWZGo53W3TXeTtidZ7pd7EaPlbT5UB0A4EsGxE/A6uFsMR67D55DgTGyqRQzXQQf6ljSzUwJiLqzOewmTQMxh6/zol73wMwJMczgJ3dFo40SRZUJMftRK3tzjs5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fGyEzXAJ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fGyEzXAJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xK0amEqpFLiVtkyjs21VBi0I+znd9dX3uSygRr+tco8=; b=fGyEzXAJ0HoMtg5WW3aK3iHkHE
	jXk45cXOuLzBdbtgc//CVIlrGI12Tnw2AgtpvhZOBatZjqSZ7Lch6LlHOb498aCVlY40JoQbLSyOm
	O+luKXCp41B9dwRMnzOVLCOjxC0W/nQFEw9xfuxKcAgLD03twW7OAj09awatRhcP+LHFVJ2U5qvvF
	Y3Hf/xEFrxAtJfhTqQSaG7sGtVYN2s5EqPfJWDJjPSALF3HI7KWhsqMEe/c3eQO8+6jFS18C5JW5H
	aNgr4CsysEVFhO4GLZVBxLp3QsLlcHrBj82OuBFfBNM+3gehry/9qyJP0CPOK5XlPPvhAWIaK2uo4
	J6+wPLSZqFvjjQheW/lZHeQRd7fdNoW5E3+jMwpgnqfCai/CGfYre2W64F8N6PEk1ulEArxob6zLC
	InKogNl9ahl97VKsjXZywVDOsr7uMmY2pMcp6lsubrmx5ksKb0xUAfz+FJGCIGnZbKZIk1owEyKGc
	P9IPguNQkEOgCAA/x3FCXvC+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe6V-000kP1-02;
	Mon, 25 Aug 2025 20:47:47 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 036/142] smb: client: make use of smbdirect_socket.recv_io.{posted,credits}
Date: Mon, 25 Aug 2025 22:39:57 +0200
Message-ID: <24827beb565e2e8eec7262de82c5addf2603005a.1756139607.git.metze@samba.org>
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

This will make it possible to introduce common helper functions
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c |  4 +--
 fs/smb/client/smbdirect.c  | 64 ++++++++++++++++++--------------------
 fs/smb/client/smbdirect.h  |  5 ---
 3 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 3717a0081847..e8faa5726b1c 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -477,8 +477,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "\nCurrent Credits send_credits: %x "
 			"receive_credits: %x receive_credit_target: %x",
 			atomic_read(&sc->send_io.credits.count),
-			atomic_read(&server->smbd_conn->receive_credits),
-			server->smbd_conn->receive_credit_target);
+			atomic_read(&sc->recv_io.credits.count),
+			sc->recv_io.credits.target);
 		seq_printf(m, "\nPending send_pending: %x ",
 			atomic_read(&sc->send_io.pending.count));
 		seq_printf(m, "\nMR responder_resources: %x "
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d68d95d1ef37..62c0d27ec8bc 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -168,7 +168,7 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	 * disable[_delayed]_work_ync()
 	 */
 	disable_work(&sc->disconnect_work);
-	disable_work(&info->post_send_credits_work);
+	disable_work(&sc->recv_io.posted.refill_work);
 	disable_work(&info->mr_recovery_work);
 	disable_delayed_work(&info->idle_timer_work);
 
@@ -455,8 +455,8 @@ static bool process_negotiation_response(
 		log_rdma_event(ERR, "error: credits_requested==0\n");
 		return false;
 	}
-	info->receive_credit_target = le16_to_cpu(packet->credits_requested);
-	info->receive_credit_target = min_t(u16, info->receive_credit_target, sp->recv_credit_max);
+	sc->recv_io.credits.target = le16_to_cpu(packet->credits_requested);
+	sc->recv_io.credits.target = min_t(u16, sc->recv_io.credits.target, sp->recv_credit_max);
 
 	if (packet->credits_granted == 0) {
 		log_rdma_event(ERR, "error: credits_granted==0\n");
@@ -464,9 +464,6 @@ static bool process_negotiation_response(
 	}
 	atomic_set(&sc->send_io.credits.count, le16_to_cpu(packet->credits_granted));
 
-	atomic_set(&info->receive_credits, 0);
-	atomic_set(&info->receive_posted, 0);
-
 	if (le32_to_cpu(packet->preferred_send_size) > sp->max_recv_size) {
 		log_rdma_event(ERR, "error: preferred_send_size=%d\n",
 			le32_to_cpu(packet->preferred_send_size));
@@ -509,17 +506,17 @@ static void smbd_post_send_credits(struct work_struct *work)
 {
 	int rc;
 	struct smbdirect_recv_io *response;
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
 	struct smbd_connection *info =
-		container_of(work, struct smbd_connection,
-			post_send_credits_work);
-	struct smbdirect_socket *sc = &info->socket;
+		container_of(sc, struct smbd_connection, socket);
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
 		return;
 	}
 
-	if (info->receive_credit_target >
-		atomic_read(&info->receive_credits)) {
+	if (sc->recv_io.credits.target >
+		atomic_read(&sc->recv_io.credits.count)) {
 		while (true) {
 			response = get_receive_buffer(info);
 			if (!response)
@@ -534,14 +531,14 @@ static void smbd_post_send_credits(struct work_struct *work)
 				break;
 			}
 
-			atomic_inc(&info->receive_posted);
+			atomic_inc(&sc->recv_io.posted.count);
 		}
 	}
 
 	/* Promptly send an immediate packet as defined in [MS-SMBD] 3.1.1.1 */
 	info->send_immediate = true;
-	if (atomic_read(&info->receive_credits) <
-		info->receive_credit_target - 1) {
+	if (atomic_read(&sc->recv_io.credits.count) <
+		sc->recv_io.credits.target - 1) {
 		if (info->keep_alive_requested == KEEP_ALIVE_PENDING ||
 		    info->send_immediate) {
 			log_keep_alive(INFO, "send an empty message\n");
@@ -617,15 +614,15 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 				sc->recv_io.reassembly.full_packet_received = true;
 		}
 
-		atomic_dec(&info->receive_posted);
-		atomic_dec(&info->receive_credits);
-		old_recv_credit_target = info->receive_credit_target;
-		info->receive_credit_target =
+		atomic_dec(&sc->recv_io.posted.count);
+		atomic_dec(&sc->recv_io.credits.count);
+		old_recv_credit_target = sc->recv_io.credits.target;
+		sc->recv_io.credits.target =
 			le16_to_cpu(data_transfer->credits_requested);
-		info->receive_credit_target =
-			min_t(u16, info->receive_credit_target, sp->recv_credit_max);
-		info->receive_credit_target =
-			max_t(u16, info->receive_credit_target, 1);
+		sc->recv_io.credits.target =
+			min_t(u16, sc->recv_io.credits.target, sp->recv_credit_max);
+		sc->recv_io.credits.target =
+			max_t(u16, sc->recv_io.credits.target, 1);
 		if (le16_to_cpu(data_transfer->credits_granted)) {
 			atomic_add(le16_to_cpu(data_transfer->credits_granted),
 				&sc->send_io.credits.count);
@@ -654,8 +651,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		 * reassembly queue and wake up the reading thread
 		 */
 		if (data_length) {
-			if (info->receive_credit_target > old_recv_credit_target)
-				queue_work(info->workqueue, &info->post_send_credits_work);
+			if (sc->recv_io.credits.target > old_recv_credit_target)
+				queue_work(info->workqueue, &sc->recv_io.posted.refill_work);
 
 			enqueue_reassembly(info, response, data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
@@ -916,16 +913,17 @@ static int smbd_post_send_negotiate_req(struct smbd_connection *info)
  */
 static int manage_credits_prior_sending(struct smbd_connection *info)
 {
+	struct smbdirect_socket *sc = &info->socket;
 	int new_credits;
 
-	if (atomic_read(&info->receive_credits) >= info->receive_credit_target)
+	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
 		return 0;
 
-	new_credits = atomic_read(&info->receive_posted);
+	new_credits = atomic_read(&sc->recv_io.posted.count);
 	if (new_credits == 0)
 		return 0;
 
-	new_credits -= atomic_read(&info->receive_credits);
+	new_credits -= atomic_read(&sc->recv_io.credits.count);
 	if (new_credits <= 0)
 		return 0;
 
@@ -1079,7 +1077,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
 
 	new_credits = manage_credits_prior_sending(info);
-	atomic_add(new_credits, &info->receive_credits);
+	atomic_add(new_credits, &sc->recv_io.credits.count);
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	info->send_immediate = false;
@@ -1137,7 +1135,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	mempool_free(request, sc->send_io.mem.pool);
 
 	/* roll back the granted receive credits */
-	atomic_sub(new_credits, &info->receive_credits);
+	atomic_sub(new_credits, &sc->recv_io.credits.count);
 
 err_alloc:
 	if (atomic_dec_and_test(&sc->send_io.pending.count))
@@ -1368,7 +1366,7 @@ static void put_receive_buffer(
 	info->count_put_receive_buffer++;
 	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
 
-	queue_work(info->workqueue, &info->post_send_credits_work);
+	queue_work(info->workqueue, &sc->recv_io.posted.refill_work);
 }
 
 /* Preallocate all receive buffer on transport establishment */
@@ -1466,8 +1464,8 @@ void smbd_destroy(struct TCP_Server_Info *server)
 			sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
 
-	log_rdma_event(INFO, "cancelling post_send_credits_work\n");
-	disable_work_sync(&info->post_send_credits_work);
+	log_rdma_event(INFO, "cancelling recv_io.posted.refill_work\n");
+	disable_work_sync(&sc->recv_io.posted.refill_work);
 
 	log_rdma_event(INFO, "destroying qp\n");
 	ib_drain_qp(sc->ib.qp);
@@ -1821,7 +1819,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	init_waitqueue_head(&info->wait_post_send);
 
-	INIT_WORK(&info->post_send_credits_work, smbd_post_send_credits);
+	INIT_WORK(&sc->recv_io.posted.refill_work, smbd_post_send_credits);
 
 	rc = smbd_negotiate(info);
 	if (rc) {
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index b5eeea4ddcf1..a4b368d14f51 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -45,14 +45,9 @@ enum keep_alive_status {
 struct smbd_connection {
 	struct smbdirect_socket socket;
 
-	struct work_struct post_send_credits_work;
-	atomic_t receive_posted;
-
 	/* dynamic connection parameters defined in [MS-SMBD] 3.1.1.1 */
 	enum keep_alive_status keep_alive_requested;
 	int protocol;
-	atomic_t receive_credits;
-	u16 receive_credit_target;
 
 	/* Memory registrations */
 	/* Maximum number of RDMA read/write outstanding on this connection */
-- 
2.43.0

