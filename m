Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19EF2AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154778; cv=none; b=tIpHPUJSLmoxUS0As7bRIYf60UqBP8At/Y6fD9uFHXfOA9q38b5uZkdn7vymlL9t3KvNCYYjPouCKN/IrlW+8qWioaT2uBkxYQN52tm2HOA/3HP98nf2Fv3YwZi2ld6ASww44uzlz3k4zVf8/kjoC6ZKjNW7TLl2R2AOTLpb5zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154778; c=relaxed/simple;
	bh=NHgeKbKOxoVUXgOYbkQeB4UH4Yv4ncWfx1vQAv5WmcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjeeC27Z7vXgnJiUM5aO7Wf3zsEIxZW+677UfWG6TdtEzj1J/BtlB4J8WKVaAskCm3snXzLAbubxynB1EE1G55tk61MdGy74lXVa8GYmn30TX5LlUhsEQbq3o62gXvMMkQFiRj45MyCpM65iVyf1PnXB+GNUJW7vQfGqzPpr+A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Zjz/CkKp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Zjz/CkKp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=N6j/Y7jFfik19KVDtcSAFUMNouZd7YrU7xaiLEEFusw=; b=Zjz/CkKpyj9i1tPy7EyXU24KbJ
	jTBSJHezFoux07e2j4w9R8O1lt/+K1uD4S2ya0nKRsl2Fj6DrGkwC7u1EV9UeCQ+05lDg1uPI4R29
	wo5IlghRMD1szQFUiq2sbNw1vNAy5+Q3SqzT5XZVSYQkdD7xGFoLQ+gyPu97s0W8pcH+ZJ/PgVKXl
	mb08W14Q4OVn7vN8It6uJlvN020g4GoOZ1NV4nZeEI5CZnriNmkSb35+vKdgnjwS1YVVPrMn1ROU1
	1qnc4pmdWNuOMiEF82DWk3L+LXFbz15iiohMNZMsV0EHM3A8uFgKig2zmh4Ejuz9gQIpJ6SfnlPwP
	YFXMAe8VTXASMl8Qj0J901CsLSASOKmEkoh4fMiSukKXOc6kMfP5OTpiOLcwLz7upN3/sZVOtvpw5
	4bLDTP4/X7JftfDNBvDfyKARgHBRrDhOWtaZ79x1yebSiaaZo/bGT9lIwawEhv+CR7X+YIQAcl+gu
	MjY+SJHcInLBPW179nHsybZ4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe4z-000k3c-2e;
	Mon, 25 Aug 2025 20:46:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 026/142] smb: client: make use of smbdirect_socket.send_io.pending.{count,wait_queue}
Date: Mon, 25 Aug 2025 22:39:47 +0200
Message-ID: <91e2aff5324573c3c99590a28fb3a66c525a0bfa.1756139607.git.metze@samba.org>
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

This will be used by the server too and will allow to create
common helper functions.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c |  2 +-
 fs/smb/client/smbdirect.c  | 25 +++++++++++--------------
 fs/smb/client/smbdirect.h  |  2 --
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index beb4f18f05ef..7df82aa49e48 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -480,7 +480,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			atomic_read(&server->smbd_conn->receive_credits),
 			server->smbd_conn->receive_credit_target);
 		seq_printf(m, "\nPending send_pending: %x ",
-			atomic_read(&server->smbd_conn->send_pending));
+			atomic_read(&sc->send_io.pending.count));
 		seq_printf(m, "\nReceive buffers count_receive_queue: %x ",
 			server->smbd_conn->count_receive_queue);
 		seq_printf(m, "\nMR responder_resources: %x "
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 58db3e7d4de3..dd0e1d27e3aa 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -391,8 +391,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
-	if (atomic_dec_and_test(&info->send_pending))
-		wake_up(&info->wait_send_pending);
+	if (atomic_dec_and_test(&sc->send_io.pending.count))
+		wake_up(&sc->send_io.pending.wait_queue);
 
 	wake_up(&info->wait_post_send);
 
@@ -863,14 +863,14 @@ static int smbd_post_send_negotiate_req(struct smbd_connection *info)
 		request->sge[0].addr,
 		request->sge[0].length, request->sge[0].lkey);
 
-	atomic_inc(&info->send_pending);
+	atomic_inc(&sc->send_io.pending.count);
 	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
 	if (!rc)
 		return 0;
 
 	/* if we reach here, post send failed */
 	log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-	atomic_dec(&info->send_pending);
+	atomic_dec(&sc->send_io.pending.count);
 	ib_dma_unmap_single(sc->ib.dev, request->sge[0].addr,
 		request->sge[0].length, DMA_TO_DEVICE);
 
@@ -994,7 +994,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 
 wait_send_queue:
 	wait_event(info->wait_post_send,
-		atomic_read(&info->send_pending) < sp->send_credit_target ||
+		atomic_read(&sc->send_io.pending.count) < sp->send_credit_target ||
 		sc->status != SMBDIRECT_SOCKET_CONNECTED);
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
@@ -1003,9 +1003,9 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 		goto err_wait_send_queue;
 	}
 
-	if (unlikely(atomic_inc_return(&info->send_pending) >
+	if (unlikely(atomic_inc_return(&sc->send_io.pending.count) >
 				sp->send_credit_target)) {
-		atomic_dec(&info->send_pending);
+		atomic_dec(&sc->send_io.pending.count);
 		goto wait_send_queue;
 	}
 
@@ -1112,8 +1112,8 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	atomic_sub(new_credits, &info->receive_credits);
 
 err_alloc:
-	if (atomic_dec_and_test(&info->send_pending))
-		wake_up(&info->wait_send_pending);
+	if (atomic_dec_and_test(&sc->send_io.pending.count))
+		wake_up(&sc->send_io.pending.wait_queue);
 
 err_wait_send_queue:
 	/* roll back send credits and pending */
@@ -1798,9 +1798,6 @@ static struct smbd_connection *_smbd_get_connection(
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
 		msecs_to_jiffies(sp->keepalive_interval_msec));
 
-	init_waitqueue_head(&info->wait_send_pending);
-	atomic_set(&info->send_pending, 0);
-
 	init_waitqueue_head(&info->wait_post_send);
 
 	INIT_WORK(&info->post_send_credits_work, smbd_post_send_credits);
@@ -2101,8 +2098,8 @@ int smbd_send(struct TCP_Server_Info *server,
 	 * that means all the I/Os have been out and we are good to return
 	 */
 
-	wait_event(info->wait_send_pending,
-		atomic_read(&info->send_pending) == 0 ||
+	wait_event(sc->send_io.pending.wait_queue,
+		atomic_read(&sc->send_io.pending.count) == 0 ||
 		sc->status != SMBDIRECT_SOCKET_CONNECTED);
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED && rc == 0)
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 1c63188664df..3dbe17e8e424 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -83,8 +83,6 @@ struct smbd_connection {
 	wait_queue_head_t wait_for_mr_cleanup;
 
 	/* Activity accounting */
-	atomic_t send_pending;
-	wait_queue_head_t wait_send_pending;
 	wait_queue_head_t wait_post_send;
 
 	/* Receive queue */
-- 
2.43.0

