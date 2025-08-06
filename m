Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35C729B799
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501910; cv=none; b=UVMd0x97FRJ7tju61HgNIIV8hY2eV9hGn7UEgu3QrVM14jp8IhbIvhv2olOJ35hceJXzynUTlybKxo4ypOGFzSpE0UFbQV/MQDOPr+bkuw70KZxxoVyIUbzzLd11XySGARAFqyfV0OGSiN6NRTNk/tY9TkDVs+MGghlldt1TooE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501910; c=relaxed/simple;
	bh=QrJbxV90I0xKRxa9e1+EmotCiq3u+NW+mNw4ri3vEMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tID6LCgYhA6l2tuG9dNJAq6uo3sGtQjUjjsjhZA8BI8p4p9eS8Ei+FVxTeOp3TR73i40hhXBFod8lFtIK593ydF87ijAg0rLjSWKTGiu+JWnINK5pPtiU4wulB1Lqz5JTQbPm3JEpJrvMIOBar7/4zpU4VP1ABLYYTM1kfbP5Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QSv8DxfB; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QSv8DxfB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ISw/zXgjVpMe/ohlHrZZyBZBWQbsaR8SCEQQL0dnOzY=; b=QSv8DxfBGWmmdM8wvJ4MtSK21m
	vE/5N86D7scS021FKHvyTbA4y34ZZP6fWcvspjmLkeJHxn0ewfVfzUuskvOz2PzZUwkKEoeLOigmZ
	XNZHWyqAB3AWXezXa2bjS3w6i2AESaE7RkhM1eXFKYED6yWt1/qlJy1VZ6qLpx4wRahhEHhW+xLHC
	RviRdIsnJjpi3US24X1BArvMoe1tXw7QItBql7RVcfVSGWHLZGLTLeSwOyX/eMRR0avtuXdIKh++5
	Z+5iJ7gAF5REIRXwb7N4aA2BdeNtrtn88UJEk1qHl4sawy0FPcqK7dESm3RRw9kX92BhMas9bEIYT
	O4bURGIJ9B/Ymt8Aph2DgoizNRsBvHweC/8RSxR8QqMeLCXLIGFaDT42dYSFFcvehOJ2SXRbbRfBs
	LC7wNd5lLpQO769BK+Lwq5zd/sp54w4Py24JSVruhzkkfG1bEhFFMJN5D9WR7ozv2h3BmlJOLB8sb
	IqfoZLUDB6VQ9uNDxcnsUkyl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji5o-001Oum-1Y;
	Wed, 06 Aug 2025 17:38:24 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 18/18] smb: server: make use of smbdirect_socket.{send,recv}_io.mem.{cache,pool}
Date: Wed,  6 Aug 2025 19:36:04 +0200
Message-ID: <87c9ebd9e659dba2fd00f8af963abf113058e4fd.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754501401.git.metze@samba.org>
References: <cover.1754501401.git.metze@samba.org>
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
---
 fs/smb/server/transport_rdma.c | 50 ++++++++++++++++------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index a7671db57705..b59a03e2dbcf 100644
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
 
@@ -405,7 +400,7 @@ static struct smbdirect_send_io
 	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_send_io *msg;
 
-	msg = mempool_alloc(t->sendmsg_mempool, KSMBD_DEFAULT_GFP);
+	msg = mempool_alloc(sc->send_io.mem.pool, KSMBD_DEFAULT_GFP);
 	if (!msg)
 		return ERR_PTR(-ENOMEM);
 	msg->socket = sc;
@@ -429,7 +424,7 @@ static void smb_direct_free_sendmsg(struct smb_direct_transport *t,
 					  msg->sge[i].addr, msg->sge[i].length,
 					  DMA_TO_DEVICE);
 	}
-	mempool_free(msg, t->sendmsg_mempool);
+	mempool_free(msg, sc->send_io.mem.pool);
 }
 
 static int smb_direct_check_recvmsg(struct smbdirect_recv_io *recvmsg)
@@ -1782,22 +1777,23 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 
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
@@ -1809,35 +1805,35 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
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

