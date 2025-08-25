Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A9C28F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155788; cv=none; b=AoM4Z4AwtJqrODJkwPCPpI+fWaj5wtKApNTYJ7Sba/rt72/UWLrU13CrFKcJ3MIw4EKmVYikWtMmUkMtNXcKxXSnJfAUDl5ZKt0lBdNOaa38vMv576gvMDEQOH2z2QH7aU/I02qMeCspMBp3TV6kXrjqaE1EB0xSSRmuiZBMoqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155788; c=relaxed/simple;
	bh=hux6JZKX2XPfeqm8eJ/u2KpJs6ig7pT442+bCeOW1aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZQP4UyTYPOyjkhtZQKMtqCZ/DmPIYWP5TTeZeTHrjYiR1/kCCTBZf9tBBFZrVgR9k4LJ3t/snFHEX+FiUDxG5dLOuBW5yM6IMVvY2sxw2N2r8UCdv5jgr3BIUZ/EYDQ5SHe4pot0uEzwDtxoAG0MF8Fm3QXCaInhrgh1cqA5DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jnK0mGbU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jnK0mGbU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=jrPM3Wc5Ry5k1EV23BCqF6yWgExKcQpHfp7rquAKelg=; b=jnK0mGbUZVR1zGNKMFErIfbVbw
	XPa1vc5sJGx3zJCBv2o2+if9pLx7cMfMNMZNPF5C37MQ7HlEgmWFFJnbT5SYVQjV+qGdOTZfLYbfb
	iExqO1VVD0s5souek6R0bCbZ2O99oQ091htAUONx2EZSfvM67O/SlMCm//Lm3UedLjXBazubPC2LN
	CWs7Vo2NTmb4VBkAPQ79jXWoJyaGh/qRh8j1Dg4rbGeSIGxZTFGhoJLLHmylTwkpoPGvu3r6zkuV/
	/yT9dAHwOroMOTJN52QHUOpDgP/QUWDnHmjmTltg0gUv3k/hqlMTgUh84AS7qcJbX5BYXAhAZny6Q
	pnSYr0RXWDiVihVdTq5Hb8zynr3IRgAxp0tjZRhCcnQX/JiAWP1PoQPfrWkuv954HGQLggmgK9sGb
	+FGT4xZZ8VkQzLAwK1EOt7dU/FqW4qHuaiXJW0ZPvY09siGrTrKos/1gJwJ2YlTWrtmRXKwepQ7Im
	5Xmc3Wq5tdtuviDaPaiyxE2J;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeLH-000nTO-0R;
	Mon, 25 Aug 2025 21:03:03 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 128/142] smb: server: pass struct smbdirect_socket to smb_direct_{alloc,free}_sendmsg()
Date: Mon, 25 Aug 2025 22:41:29 +0200
Message-ID: <23f90772ca0ee0be79a0d6b2d713872fb0031778.1756139607.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4551abb7bf92..95f9552ef843 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -413,9 +413,8 @@ static void free_transport(struct smb_direct_transport *t)
 }
 
 static struct smbdirect_send_io
-*smb_direct_alloc_sendmsg(struct smb_direct_transport *t)
+*smb_direct_alloc_sendmsg(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_send_io *msg;
 
 	msg = mempool_alloc(sc->send_io.mem.pool, KSMBD_DEFAULT_GFP);
@@ -427,10 +426,9 @@ static struct smbdirect_send_io
 	return msg;
 }
 
-static void smb_direct_free_sendmsg(struct smb_direct_transport *t,
+static void smb_direct_free_sendmsg(struct smbdirect_socket *sc,
 				    struct smbdirect_send_io *msg)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	int i;
 
 	if (msg->num_sge > 0) {
@@ -810,13 +808,11 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_send_io *sendmsg, *sibling;
-	struct smb_direct_transport *t;
 	struct smbdirect_socket *sc;
 	struct list_head *pos, *prev, *end;
 
 	sendmsg = container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
 	sc = sendmsg->socket;
-	t = container_of(sc, struct smb_direct_transport, socket);
 
 	ksmbd_debug(RDMA, "Send completed. status='%s (%d)', opcode=%d\n",
 		    ib_wc_status_msg(wc->status), wc->status,
@@ -838,11 +834,11 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	for (pos = &sendmsg->sibling_list, prev = pos->prev, end = sendmsg->sibling_list.next;
 	     prev != end; pos = prev, prev = prev->prev) {
 		sibling = container_of(pos, struct smbdirect_send_io, sibling_list);
-		smb_direct_free_sendmsg(t, sibling);
+		smb_direct_free_sendmsg(sc, sibling);
 	}
 
 	sibling = container_of(pos, struct smbdirect_send_io, sibling_list);
-	smb_direct_free_sendmsg(t, sibling);
+	smb_direct_free_sendmsg(sc, sibling);
 }
 
 static int manage_credits_prior_sending(struct smb_direct_transport *t)
@@ -946,7 +942,7 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 		wake_up(&sc->send_io.credits.wait_queue);
 		list_for_each_entry_safe(first, last, &send_ctx->msg_list,
 					 sibling_list) {
-			smb_direct_free_sendmsg(t, first);
+			smb_direct_free_sendmsg(sc, first);
 		}
 	}
 	return ret;
@@ -1021,7 +1017,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 	int header_length;
 	int ret;
 
-	sendmsg = smb_direct_alloc_sendmsg(t);
+	sendmsg = smb_direct_alloc_sendmsg(sc);
 	if (IS_ERR(sendmsg))
 		return PTR_ERR(sendmsg);
 
@@ -1064,7 +1060,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 						 DMA_TO_DEVICE);
 	ret = ib_dma_mapping_error(sc->ib.dev, sendmsg->sge[0].addr);
 	if (ret) {
-		smb_direct_free_sendmsg(t, sendmsg);
+		smb_direct_free_sendmsg(sc, sendmsg);
 		return ret;
 	}
 
@@ -1220,7 +1216,7 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 		goto err;
 	return 0;
 err:
-	smb_direct_free_sendmsg(t, msg);
+	smb_direct_free_sendmsg(sc, msg);
 	atomic_inc(&sc->send_io.credits.count);
 	return ret;
 }
@@ -1597,7 +1593,7 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 	struct smbdirect_negotiate_resp *resp;
 	int ret;
 
-	sendmsg = smb_direct_alloc_sendmsg(t);
+	sendmsg = smb_direct_alloc_sendmsg(sc);
 	if (IS_ERR(sendmsg))
 		return -ENOMEM;
 
@@ -1633,7 +1629,7 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 						 DMA_TO_DEVICE);
 	ret = ib_dma_mapping_error(sc->ib.dev, sendmsg->sge[0].addr);
 	if (ret) {
-		smb_direct_free_sendmsg(t, sendmsg);
+		smb_direct_free_sendmsg(sc, sendmsg);
 		return ret;
 	}
 
@@ -1643,7 +1639,7 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 
 	ret = post_sendmsg(t, NULL, sendmsg);
 	if (ret) {
-		smb_direct_free_sendmsg(t, sendmsg);
+		smb_direct_free_sendmsg(sc, sendmsg);
 		return ret;
 	}
 
-- 
2.43.0

