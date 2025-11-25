Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378B132C322
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094177; cv=none; b=HmwuJqWNNzJonos/U02sN8pY2Jxw7ifFsU7KzvKY6vHtpJ5yq5zZ2UGZiDl2BI3x0K3y+nfxsgy8bEPKXoie8BA46Jabz9VqLKBmYvCXgjDWD7ZDWEtsb+ax504RoLm888FvGCByKw9DM+j3oSrJMmDJdSlbbcvaFoaM9x+sdhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094177; c=relaxed/simple;
	bh=80fDnHoNehcBfKsJL3nVVMinQ7QP9lG48k7/TC1ztBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtBcUu3FSS3JJhd0GRXKKMaMihF2EwWPj37QcydUZLT8nn09tMp+wxmimSFS34Qjv4qpdVMMTNo66fU3Iv8NUzolBEuEzJZS92+lWqEzMIestfMbzF72ELUv93KgEvLK90wNxcQRgeTfv1HjVGM/Tcm/KVV9WXfIh3ZPg35Gyp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=AoU7HFSl; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="AoU7HFSl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=95FAC3ZGdYRpXiIz4ivOxQTDqC8aL9rXP770FloPiLg=; b=AoU7HFSlmM36JxJEtVsiKL/HpX
	TRnIyY6+92zexRdc5C2JDpg/bEhBqFLhuUlcddJnMZo3mgmPUy9wz6oLA9zCQB2GfG+zTU1OCW55k
	s3nTZ8/nIiGRVYe4nj5WD+SFoF6Ro64YsIiKcFHl3aI4lsQ9n1CKT8iK0JEovY4zwA07N+SsgRexH
	Dkc+hrjwDzp4iF/htfl32pjXipVkdZWoV4OjphyWu++74Vr3GoIEv/E5A4M1tFlCk5fiXZFObU6qQ
	qnpKgK4jPxAQ4RIuWAZQw+rkQ7hmgUjbPmI8s/MGXsZTUQjowdv8OiY8A4XEPaeEbaRmb8mjleNOa
	flxZ/CThJrBdoK1fSk7kcNhXdNC0x1UnvURQqccdRCGlljxbRtEf5mcuudCwGYtAFQ1M2SpnnPVhJ
	V09IP7b/zUjv3cGWTMmm5Ccjzdt116Tiamrso2FnTxfukufGs5yUHYndy3b0b1LbS3Hk2JegZ//s2
	MaA1pjfyEPN9CGAUQ66ItMy6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxQM-00FdjJ-3B;
	Tue, 25 Nov 2025 18:05:59 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 073/145] smb: client: make use of smbdirect_connection_{create,destroy}_mem_pools()
Date: Tue, 25 Nov 2025 18:55:19 +0100
Message-ID: <5605f3afaa20a1618f4716808dd3193e06bbf1be.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The main logical differences are the following:

We now don't use smbdirect_connection_get_recv_io() on cleanup,
instead it uses list_for_each_entry_safe()...

For the smbdirect_recv_io payload we expose the whole payload including
the smbdirect_data_transfer header as documentation says data_offset = 0
and data_length != 0 would be valid, while the existing client code
requires data_offset >= 24.

The smbdirect_send_io cache includes header space for
sizeof(struct smbdirect_negotiate_resp) = 32 bytes
instead of sizeof(struct smbdirect_data_transfer) = 24 bytes.
If this ever becomes a problem, we can allocate separate
space for the smbdirect_negotiate_resp in the server.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 131 +-------------------------------------
 1 file changed, 3 insertions(+), 128 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 6c8844c4edce..30a0a2cb112c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -23,9 +23,6 @@ const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connec
 	return &sc->parameters;
 }
 
-static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf);
-static void destroy_receive_buffers(struct smbdirect_socket *sc);
-
 static int smbd_post_recv(
 		struct smbdirect_socket *sc,
 		struct smbdirect_recv_io *response);
@@ -1228,46 +1225,6 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
 	return rc;
 }
 
-/* Preallocate all receive buffer on transport establishment */
-static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf)
-{
-	struct smbdirect_recv_io *response;
-	int i;
-
-	for (i = 0; i < num_buf; i++) {
-		response = mempool_alloc(sc->recv_io.mem.pool, GFP_KERNEL);
-		if (!response)
-			goto allocate_failed;
-
-		response->socket = sc;
-		response->sge.length = 0;
-		INIT_WORK(&response->complex_work, __smbdirect_socket_disabled_work);
-		disable_work_sync(&response->complex_work);
-		list_add_tail(&response->list, &sc->recv_io.free.list);
-	}
-
-	return 0;
-
-allocate_failed:
-	while (!list_empty(&sc->recv_io.free.list)) {
-		response = list_first_entry(
-				&sc->recv_io.free.list,
-				struct smbdirect_recv_io, list);
-		list_del(&response->list);
-
-		mempool_free(response, sc->recv_io.mem.pool);
-	}
-	return -ENOMEM;
-}
-
-static void destroy_receive_buffers(struct smbdirect_socket *sc)
-{
-	struct smbdirect_recv_io *response;
-
-	while ((response = smbdirect_connection_get_recv_io(sc)))
-		mempool_free(response, sc->recv_io.mem.pool);
-}
-
 static void send_immediate_empty_message(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -1348,9 +1305,6 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	} while (response);
 	sc->recv_io.reassembly.data_length = 0;
 
-	log_rdma_event(INFO, "free receive buffers\n");
-	destroy_receive_buffers(sc);
-
 	log_rdma_event(INFO, "freeing mr list\n");
 	destroy_mr_list(sc);
 
@@ -1360,11 +1314,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	rdma_destroy_id(sc->rdma.cm_id);
 
 	/* free mempools */
-	mempool_destroy(sc->send_io.mem.pool);
-	kmem_cache_destroy(sc->send_io.mem.cache);
-
-	mempool_destroy(sc->recv_io.mem.pool);
-	kmem_cache_destroy(sc->recv_io.mem.cache);
+	smbdirect_connection_destroy_mem_pools(sc);
 
 	sc->status = SMBDIRECT_SOCKET_DESTROYED;
 
@@ -1410,81 +1360,6 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 	return -ENOENT;
 }
 
-static void destroy_caches(struct smbdirect_socket *sc)
-{
-	destroy_receive_buffers(sc);
-	mempool_destroy(sc->recv_io.mem.pool);
-	kmem_cache_destroy(sc->recv_io.mem.cache);
-	mempool_destroy(sc->send_io.mem.pool);
-	kmem_cache_destroy(sc->send_io.mem.cache);
-}
-
-#define MAX_NAME_LEN	80
-static int allocate_caches(struct smbdirect_socket *sc)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	char name[MAX_NAME_LEN];
-	int rc;
-
-	if (WARN_ON_ONCE(sp->max_recv_size < sizeof(struct smbdirect_data_transfer)))
-		return -ENOMEM;
-
-	scnprintf(name, MAX_NAME_LEN, "smbdirect_send_io_%p", sc);
-	sc->send_io.mem.cache =
-		kmem_cache_create(
-			name,
-			sizeof(struct smbdirect_send_io) +
-				sizeof(struct smbdirect_data_transfer),
-			0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!sc->send_io.mem.cache)
-		return -ENOMEM;
-
-	sc->send_io.mem.pool =
-		mempool_create(sp->send_credit_target, mempool_alloc_slab,
-			mempool_free_slab, sc->send_io.mem.cache);
-	if (!sc->send_io.mem.pool)
-		goto out1;
-
-	scnprintf(name, MAX_NAME_LEN, "smbdirect_recv_io_%p", sc);
-
-	struct kmem_cache_args response_args = {
-		.align		= __alignof__(struct smbdirect_recv_io),
-		.useroffset	= (offsetof(struct smbdirect_recv_io, packet) +
-				   sizeof(struct smbdirect_data_transfer)),
-		.usersize	= sp->max_recv_size - sizeof(struct smbdirect_data_transfer),
-	};
-	sc->recv_io.mem.cache =
-		kmem_cache_create(name,
-				  sizeof(struct smbdirect_recv_io) + sp->max_recv_size,
-				  &response_args, SLAB_HWCACHE_ALIGN);
-	if (!sc->recv_io.mem.cache)
-		goto out2;
-
-	sc->recv_io.mem.pool =
-		mempool_create(sp->recv_credit_max, mempool_alloc_slab,
-		       mempool_free_slab, sc->recv_io.mem.cache);
-	if (!sc->recv_io.mem.pool)
-		goto out3;
-
-	rc = allocate_receive_buffers(sc, sp->recv_credit_max);
-	if (rc) {
-		log_rdma_event(ERR, "failed to allocate receive buffers\n");
-		goto out4;
-	}
-
-	return 0;
-
-out4:
-	mempool_destroy(sc->recv_io.mem.pool);
-out3:
-	kmem_cache_destroy(sc->recv_io.mem.cache);
-out2:
-	mempool_destroy(sc->send_io.mem.pool);
-out1:
-	kmem_cache_destroy(sc->send_io.mem.cache);
-	return -ENOMEM;
-}
-
 /* Create a SMBD connection, called by upper layer */
 static struct smbd_connection *_smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr, int port)
@@ -1676,7 +1551,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	log_rdma_event(INFO, "rdma_connect connected\n");
 
-	rc = allocate_caches(sc);
+	rc = smbdirect_connection_create_mem_pools(sc);
 	if (rc) {
 		log_rdma_event(ERR, "cache allocation failed\n");
 		goto allocate_cache_failed;
@@ -1715,7 +1590,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 negotiation_failed:
 	disable_delayed_work_sync(&sc->idle.timer_work);
-	destroy_caches(sc);
+	smbdirect_connection_destroy_mem_pools(sc);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 	rdma_disconnect(sc->rdma.cm_id);
 	wait_event(sc->status_wait,
-- 
2.43.0

