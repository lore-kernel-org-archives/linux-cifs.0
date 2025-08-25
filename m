Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0101822128B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155378; cv=none; b=mVqHsJJSQbFc+dv7Esoy5Cn3IfQLRep49UFZBiCMiMijQmERkfKtKQbGYMjodzUeuiJpLeJORcamLaE8T9rpKRLQQNWAwsnZZUWrlZzDk5BafJ1z+k9z1fjEQhFDswyRmTzZL/ciLKXW8DSgRBM/+aY3wTtQHHMs1B3XgR+3fMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155378; c=relaxed/simple;
	bh=rCrlywUiTSzjE78DGAJh4breyz2OrR+tAJ9wULldEz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0+3oZaXFKqxW0f+CbNBdxRsgAgKj5BUsvghw1V6wmiBKxnkKEaKzlwlO1EzWXytnCSqEHmPaWCQo3xCNme38DlbSiqQTJZ4g1wA4ZQ5q1pngL43jWxIielgaz4Uv10HeWQDcl0qjoWP+NBwwLof2IK/GID9WGG8gPzf0u3P5dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=q8pfGUps; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="q8pfGUps"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=1rVpPpc5vCLrOypQU51Q9vEEJcRgwRnJejcMWDl2WV4=; b=q8pfGUpsPto3Uxfn1+CqckEjir
	F1+lMzY/jITzGl390tTFP7AXQ6WJu0utyDngWL6Nil+K+LTBjTNGed/czVVZI3CLN7zA++oM7HjQn
	a7ifrh+AbeiYlnI2JneZXw4NGCR89yDp5PvvxPsSj3GOHHYMufLYw4XhuPSLO2MFnKsvp695dh4ta
	9clwcX9meIvQfye+KOGz1mzzi8UAhD3eNerNP/iJtkvCBkyNj1zLa/DyvJjFhsN5BVit01cSAknaR
	FMEnQQQQLFH8q+E21vXuMWaYO7BcuFjBwoTNBJL2w4rgXYIK87oWzsdI94J2g12DlidY54QiDLrf1
	+RFm2ZbB0zNvejtS0PkfFrVmOTJr6qzTabcwjGdSjJUGTOz3+q5RfxEwMktafDOWP1HuSN+xLH8Gc
	1838l5nsbMTOCrDJ6jCS5zmUu4dCBJA8HrhC87QYyhbbXHpa30/mjH+zKKG3gXJwnXABWr+Gx9nFP
	kicK7mv/lwiZswev9RPl7lEE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeEe-000m4p-2k;
	Mon, 25 Aug 2025 20:56:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 086/142] smb: server: make use of smbdirect_socket.{send,recv}_io.mem.{cache,pool}
Date: Mon, 25 Aug 2025 22:40:47 +0200
Message-ID: <5a28d89e75732756437e4736f6a91769c7f76860.1756139607.git.metze@samba.org>
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

This will allow common helper functions to be created later.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 50 ++++++++++++++++------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 57e1140d488e..c20052093b36 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -109,11 +109,6 @@ struct smb_direct_transport {
 	wait_queue_head_t	wait_send_credits;
 	wait_queue_head_t	wait_rw_credits;
 
-	mempool_t		*sendmsg_mempool;
-	struct kmem_cache	*sendmsg_cache;
-	mempool_t		*recvmsg_mempool;
-	struct kmem_cache	*recvmsg_cache;
-
 	wait_queue_head_t	wait_send_pending;
 	atomic_t		send_pending;
 
@@ -412,7 +407,7 @@ static struct smbdirect_send_io
 	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_send_io *msg;
 
-	msg = mempool_alloc(t->sendmsg_mempool, KSMBD_DEFAULT_GFP);
+	msg = mempool_alloc(sc->send_io.mem.pool, KSMBD_DEFAULT_GFP);
 	if (!msg)
 		return ERR_PTR(-ENOMEM);
 	msg->socket = sc;
@@ -436,7 +431,7 @@ static void smb_direct_free_sendmsg(struct smb_direct_transport *t,
 					  msg->sge[i].addr, msg->sge[i].length,
 					  DMA_TO_DEVICE);
 	}
-	mempool_free(msg, t->sendmsg_mempool);
+	mempool_free(msg, sc->send_io.mem.pool);
 }
 
 static int smb_direct_check_recvmsg(struct smbdirect_recv_io *recvmsg)
@@ -1789,22 +1784,23 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 
 static void smb_direct_destroy_pools(struct smb_direct_transport *t)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_recv_io *recvmsg;
 
 	while ((recvmsg = get_free_recvmsg(t)))
-		mempool_free(recvmsg, t->recvmsg_mempool);
+		mempool_free(recvmsg, sc->recv_io.mem.pool);
 
-	mempool_destroy(t->recvmsg_mempool);
-	t->recvmsg_mempool = NULL;
+	mempool_destroy(sc->recv_io.mem.pool);
+	sc->recv_io.mem.pool = NULL;
 
-	kmem_cache_destroy(t->recvmsg_cache);
-	t->recvmsg_cache = NULL;
+	kmem_cache_destroy(sc->recv_io.mem.cache);
+	sc->recv_io.mem.cache = NULL;
 
-	mempool_destroy(t->sendmsg_mempool);
-	t->sendmsg_mempool = NULL;
+	mempool_destroy(sc->send_io.mem.pool);
+	sc->send_io.mem.pool = NULL;
 
-	kmem_cache_destroy(t->sendmsg_cache);
-	t->sendmsg_cache = NULL;
+	kmem_cache_destroy(sc->send_io.mem.cache);
+	sc->send_io.mem.cache = NULL;
 }
 
 static int smb_direct_create_pools(struct smb_direct_transport *t)
@@ -1816,35 +1812,35 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 	struct smbdirect_recv_io *recvmsg;
 
 	snprintf(name, sizeof(name), "smbdirect_send_io_pool_%p", t);
-	t->sendmsg_cache = kmem_cache_create(name,
+	sc->send_io.mem.cache = kmem_cache_create(name,
 					     sizeof(struct smbdirect_send_io) +
 					      sizeof(struct smbdirect_negotiate_resp),
 					     0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!t->sendmsg_cache)
+	if (!sc->send_io.mem.cache)
 		return -ENOMEM;
 
-	t->sendmsg_mempool = mempool_create(sp->send_credit_target,
+	sc->send_io.mem.pool = mempool_create(sp->send_credit_target,
 					    mempool_alloc_slab, mempool_free_slab,
-					    t->sendmsg_cache);
-	if (!t->sendmsg_mempool)
+					    sc->send_io.mem.cache);
+	if (!sc->send_io.mem.pool)
 		goto err;
 
 	snprintf(name, sizeof(name), "smbdirect_recv_io_pool_%p", t);
-	t->recvmsg_cache = kmem_cache_create(name,
+	sc->recv_io.mem.cache = kmem_cache_create(name,
 					     sizeof(struct smbdirect_recv_io) +
 					     sp->max_recv_size,
 					     0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!t->recvmsg_cache)
+	if (!sc->recv_io.mem.cache)
 		goto err;
 
-	t->recvmsg_mempool =
+	sc->recv_io.mem.pool =
 		mempool_create(sp->recv_credit_max, mempool_alloc_slab,
-			       mempool_free_slab, t->recvmsg_cache);
-	if (!t->recvmsg_mempool)
+			       mempool_free_slab, sc->recv_io.mem.cache);
+	if (!sc->recv_io.mem.pool)
 		goto err;
 
 	for (i = 0; i < sp->recv_credit_max; i++) {
-		recvmsg = mempool_alloc(t->recvmsg_mempool, KSMBD_DEFAULT_GFP);
+		recvmsg = mempool_alloc(sc->recv_io.mem.pool, KSMBD_DEFAULT_GFP);
 		if (!recvmsg)
 			goto err;
 		recvmsg->socket = sc;
-- 
2.43.0

