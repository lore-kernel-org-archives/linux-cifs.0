Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B14E22FF37
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154986; cv=none; b=cKaln3daBCCULi42WH2MXn6N4PGTvvdFikNV8YhI4y8L27uxjEOG3A6MCElWUP0KUSQnKm+LaKDOY4TVTxU1+7ElKhr87TLFZke0Vvtts+8j6cIHNboNOlwGzqlWS55gIny9runc6Y/48+aSQcEfGMvwjZK5vth00H9zSBYfNbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154986; c=relaxed/simple;
	bh=rDqCO2qmgnwo7WyCG54SlRb6RnDVHdgxugSSwhQvYe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4kHlMgxore0vyfanqBRzGZAeA3D88WgyvlSyv7hfGdT6e4gBEi556QdglEZT2J345km2Oyfbg0m9lEroxTU9kMgZTCLsOi7aP2SM/P+7xHMJtJlxpacfzgK482OtjDbWJuPqX1DZU3Hs7M2C96X0xFfL6ei6boFcQGJgYXG62k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pQbjYdww; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pQbjYdww"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=FoNiM0rxOF5YGmfhs6wA66VCSk6fFiU7RgSOCDKFbSA=; b=pQbjYdwwDC7dlDrrm4oB9GVmrW
	iHa4TbcDEFV3PesQ4esUUntknfGa6o0WIJVQN1+l4Z1Pjs5+QrLFr7PdmSWkejwBVRKlg1/+SQbqH
	WvzIKU+yT+mjSmVuYhi350QYcqw/oEMvdfW3j21oIBoOXBgT8Ht3lyJkCGyksJu/8WCN1UBgY3ChX
	xvXq24OT6mXXaUNnyGQZhbZCNp1RZ2Cj6Y0FEufTK7CekAmYQpMar8rA7HBGACRmXqv5PA9qG6AKy
	wVhuweIWpyIYcDa9SHUjz3ORIWjoIcUSX31JLqzPPfQapee/Po/9z9s0DNOIyMdMn5Et/955sE1rL
	AHf+G9VkwV14zQvpmmLsMExLtyhYNg1brLfVtNdwliuPN84r7w9zNQ+RKsfIUHQn2lRyVigC59YeH
	MJ05E1wEZbQTI6m0e0BQE2QR7zU9lsA43875bQRp6eirwE8mj+zAahfkyHe9zcQMYwcEZQFAoHyRv
	5khdgkGbQSrYt7cZeuhFx/sX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe8M-000knd-2Y;
	Mon, 25 Aug 2025 20:49:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 048/142] smb: client: don't check sc->send_io.pending.count is below sp->send_credit_target
Date: Mon, 25 Aug 2025 22:40:09 +0200
Message-ID: <02ad437bfe57819274af80b0cd3cd4dff96fbbba.1756139607.git.metze@samba.org>
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

If we were able to get a credit we don't need to prove and wait
that sc->send_io.pending.count is below sp->send_credit_target.

This just adds useless complixity. The same code on the server
also doesn't do this, so we should remove it from the client.

This will make it easier to momve to common code later.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 28 ++++------------------------
 fs/smb/client/smbdirect.h |  3 ---
 2 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 2eaddf190354..220ebd00a9d7 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -414,8 +414,6 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (atomic_dec_and_test(&sc->send_io.pending.count))
 		wake_up(&sc->send_io.pending.wait_queue);
 
-	wake_up(&info->wait_post_send);
-
 	mempool_free(request, sc->send_io.mem.pool);
 }
 
@@ -1035,23 +1033,6 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 		goto wait_credit;
 	}
 
-wait_send_queue:
-	wait_event(info->wait_post_send,
-		atomic_read(&sc->send_io.pending.count) < sp->send_credit_target ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		log_outgoing(ERR, "disconnected not sending on wait_send_queue\n");
-		rc = -EAGAIN;
-		goto err_wait_send_queue;
-	}
-
-	if (unlikely(atomic_inc_return(&sc->send_io.pending.count) >
-				sp->send_credit_target)) {
-		atomic_dec(&sc->send_io.pending.count);
-		goto wait_send_queue;
-	}
-
 	request = mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
 	if (!request) {
 		rc = -ENOMEM;
@@ -1133,10 +1114,14 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	request->sge[0].length = header_length;
 	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
 
+	atomic_inc(&sc->send_io.pending.count);
 	rc = smbd_post_send(info, request);
 	if (!rc)
 		return 0;
 
+	if (atomic_dec_and_test(&sc->send_io.pending.count))
+		wake_up(&sc->send_io.pending.wait_queue);
+
 err_dma:
 	for (i = 0; i < request->num_sge; i++)
 		if (request->sge[i].addr)
@@ -1150,10 +1135,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	atomic_sub(new_credits, &sc->recv_io.credits.count);
 
 err_alloc:
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.wait_queue);
 
-err_wait_send_queue:
 	/* roll back send credits and pending */
 	atomic_inc(&sc->send_io.credits.count);
 
@@ -1862,8 +1844,6 @@ static struct smbd_connection *_smbd_get_connection(
 	mod_delayed_work(info->workqueue, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->negotiate_timeout_msec));
 
-	init_waitqueue_head(&info->wait_post_send);
-
 	INIT_WORK(&sc->recv_io.posted.refill_work, smbd_post_send_credits);
 
 	rc = smbd_negotiate(info);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 39a56a54f8b6..8ebbbc0b0499 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -61,9 +61,6 @@ struct smbd_connection {
 	/* Used by transport to wait until all MRs are returned */
 	wait_queue_head_t wait_for_mr_cleanup;
 
-	/* Activity accounting */
-	wait_queue_head_t wait_post_send;
-
 	struct workqueue_struct *workqueue;
 };
 
-- 
2.43.0

