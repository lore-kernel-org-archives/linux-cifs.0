Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803511F0E55
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410573; cv=none; b=Vyfmj2AXTEyJmmN6WzHJHEwe9SiWHkG0lMyB1jDokI+IPLwuIY9hEcwvyZgfD+ViMH40NzPyb49g0agdvro10r8GH9I4CuLbLvBGJ6yA3Zbub8bDgFgMb4CEgZ9I1PuvpCbkOv2V3AEqURTadgQ4b3ZgMD0/OAOuREhxQNkjjjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410573; c=relaxed/simple;
	bh=+Wb0RdHxwb2yB6ha3c9+hDP33sr2u7px1NgPZWBqYMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NK9pIpFzHaOvvjO4P89r+ZORSfa5WJFy4hIKBi6stMlV1pF2AaTNbTLYUqsC4V8VVNmY5N5OJ+DTf01dDTkVsw8PKDpzSUOfJ1V2ctBPbSFyXjGrUGGM07Q32aQPP9Mo2SM9X0KR1VP5VnA7uMd5oN2rjCi4hZnDVCjMKfjuJHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=maBdnwhp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="maBdnwhp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=dTOMMUIW2KY5BfMsYCpzjFkojakrZ59i4jXt37SMiWQ=; b=maBdnwhpwUnXkf06OMIyFyrM2P
	UCKS5u3mDSHoXBI2ZpPZXIFm2HIxIhAkwKhKJ0p8RFQvyEGPN6+EZHtxJf6/h52cO2RJ0iKq+QcIp
	X9mYjQtrIzfw9YclWTLHen3X8JSPQUvUBbIjVWBTIhCbkDcigjNylxgKWnSOFnGyTy8rWD48AqHk5
	5BUGQ7devxyoq99RTQfT6++ukUeiTnF7GmJZY530xPFh2kpBn+imGFDiIghSWOi9RijZYf228mfqm
	0v7Oscr0t758RMeK5sDRr/bVC0s1VcGjEFoG+SScBa75reAsu1iKRd3+Fetg9n2rvwpgKbZHPUlEd
	5dbMbrfFNTPD+u4ET03Vwh4l38AlDR5Vg1q64UCui3K1NZNCiX6DyP1okvOKcifMNVh3PRc9HldjM
	M0JofQDVM4wJmjbiIAJlbS8X9hJys9Mzo/aDz4VrXfLTmOTlAvhuL8ka+KL60kJjGT2A7K5PatlqF
	TgfYVWALAF0C9VDbrx/JRDQM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKKc-001A3h-0q;
	Tue, 05 Aug 2025 16:16:07 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 16/17] smb: server: make use of smbdirect_socket.recv_io.free.{list,lock}
Date: Tue,  5 Aug 2025 18:13:36 +0200
Message-ID: <3a561e7581f7e5902f2b63b25e238a3252a62ea6.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
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

