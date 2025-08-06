Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805521E5B72
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501886; cv=none; b=q4Betqs8rThN9zZ0jFKiK9laZuqP4MOE2fbxosvdAfp95nTsY7AZYObFMvOKwyWvvjU5QU04fLH0pwb2fHpWdwKMut7bL1jh+0DnhDfpFTrELf5EfZRYZl+NxLMRMSkxWRPQE+pL5lIlwXzJk9Y5JcABR7gzAee6i+OfoncJomM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501886; c=relaxed/simple;
	bh=+Wb0RdHxwb2yB6ha3c9+hDP33sr2u7px1NgPZWBqYMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyveR7tDu1mZHxcgxd0NXJClitOQMdjgqS+FZDeICO37vp2aJWMpHrrgOv1D37N4gTbVtReKbR38fuQLLRtrnM35hwpLH5Y5X3ynftbPhhucAKiJlQy20m7QtNPvbOFxbhqNBaIjJ9aFoSTh/qoV9tbDzg9pwm0D6nKfyHhG/Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=npqxkO8/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="npqxkO8/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=dTOMMUIW2KY5BfMsYCpzjFkojakrZ59i4jXt37SMiWQ=; b=npqxkO8/1nwxJhQ7ArF1ZHB0OV
	i3QAKcUWw8gJj4knNjl8S1F2EdEsIQeYuLjXTRuAc+SkgMTf+P6lz8Q7ZAiMhcx8NxQlxFjd08eyb
	Wp5aG7gnkMcW0fa8y718cljCOJeDcy/1CC/KQa72PJ5FwGYEeVkcxElKedUDLIdfYjXYTOtS1FLAV
	6RKrI1UnWtKl6TcpS6tMMiOQHlwERtjM/31XiDVEy/f30unoGs/pGhFTrABrNQeKaBbOe/ayVMPl/
	rCz6mChX9kOFFtFZ7VK/pDPHqpBCtuNvWMNJYt77F0u5QJvfJnvTnQ508KUMulsIQgchGVxmsKw/T
	a40/6Ycv6EseMTSnOkM+jsZ4p/eJtMGtKJTnR5TK3jO3kyJ39CmdhOPIn60vt76FqZGnwo5WUlr8S
	iRnqY0BHAJUWtn/Yt6ucsvf21QKEGnCPuvAQqY+x3Ws+esmEvDlyJTB12XInkVG8Qwi1AKYfGeRj9
	Fu3TsBtFvwsrJ+VbnrxEUOES;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji5M-001OoR-0h;
	Wed, 06 Aug 2025 17:37:56 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 14/18] smb: server: make use of smbdirect_socket.recv_io.free.{list,lock}
Date: Wed,  6 Aug 2025 19:36:00 +0200
Message-ID: <9aa189b1dd0b2d6730c456f7cb8361a8dfd07230.1754501401.git.metze@samba.org>
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

This is already used by the client and will allow us to
add common helper functions soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 26d70396b0c1..aebd29242a2b 100644
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
@@ -218,16 +215,17 @@ static inline bool is_receive_credit_post_required(int receive_credits,
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
 
@@ -244,9 +242,9 @@ static void put_recvmsg(struct smb_direct_transport *t,
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
@@ -326,6 +324,9 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 
 	sc->ib.dev = sc->rdma.cm_id->device;
 
+	INIT_LIST_HEAD(&sc->recv_io.free.list);
+	spin_lock_init(&sc->recv_io.free.lock);
+
 	sc->status = SMBDIRECT_SOCKET_CREATED;
 	init_waitqueue_head(&t->wait_status);
 
@@ -338,8 +339,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	init_waitqueue_head(&t->wait_rw_credits);
 
 	spin_lock_init(&t->receive_credit_lock);
-	spin_lock_init(&t->recvmsg_queue_lock);
-	INIT_LIST_HEAD(&t->recvmsg_queue);
 
 	init_waitqueue_head(&t->wait_send_pending);
 	atomic_set(&t->send_pending, 0);
@@ -1851,15 +1850,13 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
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

