Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA8827FD7C
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094742; cv=none; b=qII1694sZvOkxMw2AY8luhkxfLGHZPupNLesh3NBQnRKgoYqeCAihdg8UArR9FonWIsypnNiwWmmbeQoXAf3bMLwDmRwzeM1Ew7RuUs+CUNe3L3MN5OusWKqtkJI83LpiYsReO+xHPToqxvhQzz/ugZqN3L8uQJ5X/HvjtdS/0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094742; c=relaxed/simple;
	bh=rVK2RFCOxCeBtZ2k/keKGG8VUOljfG9rocqjnybq9jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBycjWkeW5XIuRsJwlBPLZ8cVHoAHFdnvZjtIuTWnV6vAwFjJE0t4JpsTXm3LJqfMBDl2ZDlWvz4pVOJTszXxoEUr+Fo52I2s7nWIxqDvleLf2PwKLGkjKKq0fG92WoKI5iGcodY3wan0sowLS0diB7NZkzKJNB+mCHsnovqcVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=q53zH27z; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="q53zH27z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ghht5wrUIFsWjZl0MqxftkB15/dyfPbflN3Wt3owW2I=; b=q53zH27zWGswLUUS/cIoZvyrb6
	LGcEHuckrwUG2R+IKEz7UleY7Hkhx5C6JLjS1w9su6p/KYL000MP3X16z04IxKsR62WKX+f3FgUny
	dIidVLEgJwA+TMM8bxlydrLn0RYd859JvAaPO4bEzVpBk962aPzYXJSHk+6bt2Zy8x9Jl7GUsFpYK
	wTkOUCpCOl1xhqZEcBLbMkzirXoSyuzUcWbe16wzQKrgdEQAGKkj+WnpIEHVq/VPuoBWE7n59CM0M
	o88NJL6HQ0HCqUNCCkk1yPlIUbW2J29w1RYMv9uzR+ZfStp+o06o0JgeqH0z2Tv7RYyWXtyfde9eR
	Oujp+SBzzfw4lDHsHMQmJUIn3YmUAbxCy2Z60Q7AYplxNszVG+AMbW61xOkwrY6lUpHs6APWJW6qA
	k9l2cLiuPGRGKF1Rm6jmnZp2EgM9Q6NyD8pBa/JfUx7gdgdwvuRN/nXXoIcvaT+MwB/x7Zl/zuegY
	KpTmShG4GYMnjekcefhZaY0D;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxWA-00FeSy-0W;
	Tue, 25 Nov 2025 18:11:59 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 109/145] smb: server: make use of smbdirect_connection_{create,destroy}_mem_pools()
Date: Tue, 25 Nov 2025 18:55:55 +0100
Message-ID: <acb080c1751c2ce3ec6b2e2006dadc7e38f82382.1764091285.git.metze@samba.org>
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

This were based on smb_direct_{create,destroy}_pools() in the server.

The main logical differences are the following:

We now don't use smbdirect_connection_get_recv_io() on cleanup,
instead it uses list_for_each_entry_safe()...

We don't generate warnings if smbdirect_recv_io payload
is copied into userspace buffers. This doesn't happen
in the server anyway.

And it uses list_add_tail() just to let me feel
better when looking at the code...

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 78 ++--------------------------------
 1 file changed, 3 insertions(+), 75 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 3b324b42d009..6cbd81406e94 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -202,7 +202,6 @@ static inline int get_buf_page_count(void *buf, int size)
 		(uintptr_t)buf / PAGE_SIZE;
 }
 
-static void smb_direct_destroy_pools(struct smbdirect_socket *sc);
 static void smb_direct_post_recv_credits(struct work_struct *work);
 static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
@@ -259,6 +258,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 				     smb_direct_logging_needed,
 				     smb_direct_logging_vaprintf);
 	sc->send_io.mem.gfp_mask = KSMBD_DEFAULT_GFP;
+	sc->recv_io.mem.gfp_mask = KSMBD_DEFAULT_GFP;
 	/*
 	 * from here we operate on the copy.
 	 */
@@ -351,7 +351,7 @@ static void free_transport(struct smb_direct_transport *t)
 		rdma_destroy_id(sc->rdma.cm_id);
 	}
 
-	smb_direct_destroy_pools(sc);
+	smbdirect_connection_destroy_mem_pools(sc);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
 }
 
@@ -1747,78 +1747,6 @@ static int smb_direct_init_params(struct smbdirect_socket *sc)
 	return 0;
 }
 
-static void smb_direct_destroy_pools(struct smbdirect_socket *sc)
-{
-	struct smbdirect_recv_io *recvmsg;
-
-	while ((recvmsg = smbdirect_connection_get_recv_io(sc)))
-		mempool_free(recvmsg, sc->recv_io.mem.pool);
-
-	mempool_destroy(sc->recv_io.mem.pool);
-	sc->recv_io.mem.pool = NULL;
-
-	kmem_cache_destroy(sc->recv_io.mem.cache);
-	sc->recv_io.mem.cache = NULL;
-
-	mempool_destroy(sc->send_io.mem.pool);
-	sc->send_io.mem.pool = NULL;
-
-	kmem_cache_destroy(sc->send_io.mem.cache);
-	sc->send_io.mem.cache = NULL;
-}
-
-static int smb_direct_create_pools(struct smbdirect_socket *sc)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	char name[80];
-	int i;
-	struct smbdirect_recv_io *recvmsg;
-
-	snprintf(name, sizeof(name), "smbdirect_send_io_pool_%p", sc);
-	sc->send_io.mem.cache = kmem_cache_create(name,
-					     sizeof(struct smbdirect_send_io) +
-					      sizeof(struct smbdirect_negotiate_resp),
-					     0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!sc->send_io.mem.cache)
-		return -ENOMEM;
-
-	sc->send_io.mem.pool = mempool_create(sp->send_credit_target,
-					    mempool_alloc_slab, mempool_free_slab,
-					    sc->send_io.mem.cache);
-	if (!sc->send_io.mem.pool)
-		goto err;
-
-	snprintf(name, sizeof(name), "smbdirect_recv_io_pool_%p", sc);
-	sc->recv_io.mem.cache = kmem_cache_create(name,
-					     sizeof(struct smbdirect_recv_io) +
-					     sp->max_recv_size,
-					     0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!sc->recv_io.mem.cache)
-		goto err;
-
-	sc->recv_io.mem.pool =
-		mempool_create(sp->recv_credit_max, mempool_alloc_slab,
-			       mempool_free_slab, sc->recv_io.mem.cache);
-	if (!sc->recv_io.mem.pool)
-		goto err;
-
-	for (i = 0; i < sp->recv_credit_max; i++) {
-		recvmsg = mempool_alloc(sc->recv_io.mem.pool, KSMBD_DEFAULT_GFP);
-		if (!recvmsg)
-			goto err;
-		recvmsg->socket = sc;
-		recvmsg->sge.length = 0;
-		INIT_WORK(&recvmsg->complex_work, __smbdirect_socket_disabled_work);
-		disable_work_sync(&recvmsg->complex_work);
-		list_add(&recvmsg->list, &sc->recv_io.free.list);
-	}
-
-	return 0;
-err:
-	smb_direct_destroy_pools(sc);
-	return -ENOMEM;
-}
-
 static u32 smb_direct_rdma_rw_send_wrs(struct ib_device *dev, const struct ib_qp_init_attr *attr)
 {
 	/*
@@ -2116,7 +2044,7 @@ static int smb_direct_connect(struct smbdirect_socket *sc)
 		return ret;
 	}
 
-	ret = smb_direct_create_pools(sc);
+	ret = smbdirect_connection_create_mem_pools(sc);
 	if (ret) {
 		pr_err("Can't init RDMA pool: %d\n", ret);
 		return ret;
-- 
2.43.0

