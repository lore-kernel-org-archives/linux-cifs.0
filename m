Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B785928F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155926; cv=none; b=TZs1qUIt922sHYcaiyBEVQrriT2XZPuj90SWOMKJvIAYLCsMSiiMcKSAlKpaySclThWWzHlQh568Hb7V740q5Bl8DzanOf9du3eB/IiWEm+gAJv0OiIbAOgvyiyKoUi6qqAXzOPaUkQfimN9azE0am3UfrXLds9JtNO6YkB25nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155926; c=relaxed/simple;
	bh=zNzH7u0set5BXkTEhUI1URLKHpH5iOxs28MJa1JGIWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/6yuVNGcc7gUeRZzmtZj8z+yv020XY6dM6dE0tVJYjmWQdV2um1VvS8KnnlWeDbt2Ffl0GiPBIVurnIdZoljdzFpSZ9OA6QIqrWFroeLvQbvtQNCnIvoLqFdyE/WUSoUY94Qf/f5oL/0v8IU+i/pbf/BVNukq4B0B9wLi/ubhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JT69m0fI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JT69m0fI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=INpyoO1XRtHhAGbRjzKhBmvbqkkvKbL05lSDGf1ltDc=; b=JT69m0fIqEkneWXAsUyVMf7gQb
	Y0uj4soQ1aqlNeuFTUdoHWKG2QXq+mM+bLHez+Qwf3acsnDjDls7ZHuOW7tLhH3Zt2C9hHlLs/J4Z
	RV/fiWEVeFE2Ewsw1TOw2l7dN4uEw9Vn1xYMHG7VcgY+RCoQUs99gWqPREaFMJi09mwNFcrKr0+ST
	R++KEOTv71p+UWppYWJZzrwUwn4t7oQIdf+/99zBwv4DZs8K1Q5vPLGYW3hUhUt/52DmbWUuWHObn
	H7YCklFcirwVRUbUozdQx3kfpOJ6XBkwhK1tF3pxmx+L3IGjPQ5QTVpoXKecD4wopLgxSAC8uy7C5
	s79cXfCT3WOnWXrOS2YaJNx+DZk3ojy+jhh2FR/6VhZ0Hljg7qcVApzA9DFlq+2c9MNcEAFkMPYqK
	nxxTH/h7frFkOKuhAXlNpflucl2nVvT6edzLXB1FIgaOjYm7b3P053aPq8bAovRrc41rVm3Q2BVHl
	ZJ29nZtfVKRiwGC3Ny8GPhYL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeNU-000nu8-0n;
	Mon, 25 Aug 2025 21:05:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 141/142] smb: server: pass struct smbdirect_socket to {enqueue,get_first}_reassembly()
Date: Mon, 25 Aug 2025 22:41:42 +0200
Message-ID: <ff4241fbe87c8715798fb5c90b3eaebb3cab551d.1756139608.git.metze@samba.org>
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
 fs/smb/server/transport_rdma.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 7f7c31326226..4c9d33ee67b5 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -180,12 +180,10 @@ static void put_recvmsg(struct smbdirect_socket *sc,
 	queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 }
 
-static void enqueue_reassembly(struct smb_direct_transport *t,
+static void enqueue_reassembly(struct smbdirect_socket *sc,
 			       struct smbdirect_recv_io *recvmsg,
 			       int data_length)
 {
-	struct smbdirect_socket *sc = &t->socket;
-
 	spin_lock(&sc->recv_io.reassembly.lock);
 	list_add_tail(&recvmsg->list, &sc->recv_io.reassembly.list);
 	sc->recv_io.reassembly.queue_length++;
@@ -200,10 +198,8 @@ static void enqueue_reassembly(struct smb_direct_transport *t,
 	spin_unlock(&sc->recv_io.reassembly.lock);
 }
 
-static struct smbdirect_recv_io *get_first_reassembly(struct smb_direct_transport *t)
+static struct smbdirect_recv_io *get_first_reassembly(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
-
 	if (!list_empty(&sc->recv_io.reassembly.list))
 		return list_first_entry(&sc->recv_io.reassembly.list,
 				struct smbdirect_recv_io, list);
@@ -386,7 +382,7 @@ static void free_transport(struct smb_direct_transport *t)
 	ksmbd_debug(RDMA, "drain the reassembly queue\n");
 	do {
 		spin_lock(&sc->recv_io.reassembly.lock);
-		recvmsg = get_first_reassembly(t);
+		recvmsg = get_first_reassembly(sc);
 		if (recvmsg) {
 			list_del(&recvmsg->list);
 			spin_unlock(&sc->recv_io.reassembly.lock);
@@ -493,14 +489,12 @@ static int smb_direct_check_recvmsg(struct smbdirect_recv_io *recvmsg)
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_recv_io *recvmsg;
-	struct smb_direct_transport *t;
 	struct smbdirect_socket *sc;
 	struct smbdirect_socket_parameters *sp;
 
 	recvmsg = container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
 	sc = recvmsg->socket;
 	sp = &sc->parameters;
-	t = container_of(sc, struct smb_direct_transport, socket);
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
 		put_recvmsg(sc, recvmsg);
@@ -538,7 +532,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		sc->recv_io.reassembly.full_packet_received = true;
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED);
 		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
-		enqueue_reassembly(t, recvmsg, 0);
+		enqueue_reassembly(sc, recvmsg, 0);
 		wake_up(&sc->status_wait);
 		return;
 	case SMBDIRECT_EXPECT_DATA_TRANSFER: {
@@ -596,7 +590,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			if (sc->recv_io.credits.target > old_recv_credit_target)
 				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 
-			enqueue_reassembly(t, recvmsg, (int)data_length);
+			enqueue_reassembly(sc, recvmsg, (int)data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
 			put_recvmsg(sc, recvmsg);
@@ -691,7 +685,7 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 		to_read = size;
 		offset = sc->recv_io.reassembly.first_entry_offset;
 		while (data_read < size) {
-			recvmsg = get_first_reassembly(st);
+			recvmsg = get_first_reassembly(sc);
 			data_transfer = smbdirect_recv_io_payload(recvmsg);
 			data_length = le32_to_cpu(data_transfer->data_length);
 			remaining_data_length =
@@ -1986,7 +1980,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	if (ret <= 0 || sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING)
 		return ret < 0 ? ret : -ETIMEDOUT;
 
-	recvmsg = get_first_reassembly(st);
+	recvmsg = get_first_reassembly(sc);
 	if (!recvmsg)
 		return -ECONNABORTED;
 
-- 
2.43.0

