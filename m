Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28293179BD
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155337; cv=none; b=PNqp6kgFazlDTZYRmZfJcsxAztEkHXWdjQXPQOXZmrhg/sEV6pE5AFNDM7tCp5UqqutFljhRTn1CuhfX/SP6SEV0cA5Sdifj719Ifca2Z41nHKB6h8PWrzPRC5964W/9QHq/rre2COY8DjgRzZ67WhTSx7PxrxQzr6bUq46yv+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155337; c=relaxed/simple;
	bh=XHYzfuI+liqLLhx61eerOjqSzwRqV011/Hz1vYcjAVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsVcH/hOawQakwo+AvhPNLiY9yyrwaeqfuh65KgqkJlgOmThN4oUKjaB0CzdPfFv8r8PVGdMjk3pJG65PmZE9k1BXHnAGyzpn24aILUBXVQ1D3KGDSD6xnOAnHx3Tis/lqXWmNOic4XRiZiaU6X89nNeS04xIsOZKo5o1uMc4Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=F/Gdi65p; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="F/Gdi65p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=2DCoYCdXqCT7P7NedN1qefX5QK8c4d02ZWzMOciOf68=; b=F/Gdi65p5IIhpDmMLDxiaQg/on
	cUwy5yaotqeEuvpgz8kgAQP+Ka6Oa0iegfHxOfJ8kKxz8LVunsYRNd+troa65cMWf15t1Q1xrEdIa
	KIOZz3n5uAoChB1s6xb6oImiZOfqDT/Md839prN3f1QbBSEiFtcPM1t8onzc3e/aQQo7uJpc36X3y
	GP6l1C9sHjbAjqBEG9w9TWfobkKNbLtEYpf0zRWP9Xy8RFwAgzAS5G+3uj0mvPtwATyhvmf64wHp5
	rdwgjVrAcB6WA2rOs5cr1a9eXypeVE5nqYfGn4RIvclSZ6jqBz3YYco4AW7RfSqi92WWFRQdxn2cH
	OkZateIJlLKljf6fp6nzvHav9p+SR71dIsSeWz18vreRCjHfZ1aNBynRdkcfJDVvwZ4XYSRZzUbOU
	xvL3QmAAE9pLVGrY5ZqEKjD6XhjF/Wu5Kyq1NEPelDZ/1E/Bk6hYY5eRj/9VQL/yTqyORTu261shz
	lN8EKf4nL2V7NBrdQOx5bz/s;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeDv-000lwn-38;
	Mon, 25 Aug 2025 20:55:29 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 082/142] smb: server: make use of smbdirect_socket.recv_io.free.{list,lock}
Date: Mon, 25 Aug 2025 22:40:43 +0200
Message-ID: <fce2dcde3d0f5b19f6df577821214c2605a7e1c9.1756139607.git.metze@samba.org>
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

This is already used by the client and will allow us to
add common helper functions soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index edc7968d46fc..38af9a8b014c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -110,9 +110,6 @@ struct smb_direct_transport {
 	int			count_avail_recvmsg;
 	int			recv_credit_target;
 
-	spinlock_t		recvmsg_queue_lock;
-	struct list_head	recvmsg_queue;
-
 	atomic_t		send_credits;
 	spinlock_t		lock_new_recv_credits;
 	int			new_recv_credits;
@@ -222,16 +219,17 @@ static inline bool is_receive_credit_post_required(int receive_credits,
 static struct
 smbdirect_recv_io *get_free_recvmsg(struct smb_direct_transport *t)
 {
+	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_recv_io *recvmsg = NULL;
 
-	spin_lock(&t->recvmsg_queue_lock);
-	if (!list_empty(&t->recvmsg_queue)) {
-		recvmsg = list_first_entry(&t->recvmsg_queue,
+	spin_lock(&sc->recv_io.free.lock);
+	if (!list_empty(&sc->recv_io.free.list)) {
+		recvmsg = list_first_entry(&sc->recv_io.free.list,
 					   struct smbdirect_recv_io,
 					   list);
 		list_del(&recvmsg->list);
 	}
-	spin_unlock(&t->recvmsg_queue_lock);
+	spin_unlock(&sc->recv_io.free.lock);
 	return recvmsg;
 }
 
@@ -248,9 +246,9 @@ static void put_recvmsg(struct smb_direct_transport *t,
 		recvmsg->sge.length = 0;
 	}
 
-	spin_lock(&t->recvmsg_queue_lock);
-	list_add(&recvmsg->list, &t->recvmsg_queue);
-	spin_unlock(&t->recvmsg_queue_lock);
+	spin_lock(&sc->recv_io.free.lock);
+	list_add(&recvmsg->list, &sc->recv_io.free.list);
+	spin_unlock(&sc->recv_io.free.lock);
 }
 
 static void enqueue_reassembly(struct smb_direct_transport *t,
@@ -333,6 +331,9 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 
 	sc->ib.dev = sc->rdma.cm_id->device;
 
+	INIT_LIST_HEAD(&sc->recv_io.free.list);
+	spin_lock_init(&sc->recv_io.free.lock);
+
 	sc->status = SMBDIRECT_SOCKET_CREATED;
 	init_waitqueue_head(&t->wait_status);
 
@@ -345,8 +346,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	init_waitqueue_head(&t->wait_rw_credits);
 
 	spin_lock_init(&t->receive_credit_lock);
-	spin_lock_init(&t->recvmsg_queue_lock);
-	INIT_LIST_HEAD(&t->recvmsg_queue);
 
 	init_waitqueue_head(&t->wait_send_pending);
 	atomic_set(&t->send_pending, 0);
@@ -1858,15 +1857,13 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 	if (!t->recvmsg_mempool)
 		goto err;
 
-	INIT_LIST_HEAD(&t->recvmsg_queue);
-
 	for (i = 0; i < sp->recv_credit_max; i++) {
 		recvmsg = mempool_alloc(t->recvmsg_mempool, KSMBD_DEFAULT_GFP);
 		if (!recvmsg)
 			goto err;
 		recvmsg->socket = sc;
 		recvmsg->sge.length = 0;
-		list_add(&recvmsg->list, &t->recvmsg_queue);
+		list_add(&recvmsg->list, &sc->recv_io.free.list);
 	}
 	t->count_avail_recvmsg = sp->recv_credit_max;
 
-- 
2.43.0

