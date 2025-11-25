Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308711F30A9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094955; cv=none; b=UpdcvJ2HqU6nAoHi+//ONyMM6lM/BL0FYMxviqT7UpOrFCjYRWLS011q88LpkZe72REWog63TFDuyrXscpH2O0ji5ZtkXqhPegfqQDkSUosHNrQO653/RRs3DmjnCT2Im6kI4kv10kd7/Hcdfzkhebs+JR/CPqSEtdbZDUtqYuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094955; c=relaxed/simple;
	bh=2BU0EiIfZMYKk1tipqNYTvVIC3RQnfdSvpAaMF0+tT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BapdTFJla88EyuZITvfvZ3nUQt93vx/egCYaTGfKbqEXzJQ11n6jzZGuaWsF1pMglxfmwuHM77iVNaZQGWNRwrgNZk8BD6YA0qGhJWScI64R4VBRTiwxz95EuwSmruaYYuoXWVCUSVcMN29pcaobEza0GNPcPudSvCrVio6RMZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=TfmSRY2t; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="TfmSRY2t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/V2Y++67/vRfuAhYaqQHN8gk4tEmnTYEDfg0bFUPL1E=; b=TfmSRY2tb8A/2HRTKvPCKI6igP
	/nLhEbMgBTKDUl00hSCW9IhXRKPxQPjy3kpziFR993W29AwMEE9SnSA883iDSHGFVU196w8iI5KUE
	I2ttkNzMaciiEfTscBPFrk20XBFRh3j7UPwx4IrEiM35UYkE1cuaeGthZO38EI5ux3+o5W2wdtDKU
	3rqrE7thbNhk+8u0Q1tmFwsgqs+9zlyZOYiy+6rf0LjhC1Csoa8bJ7NntHM/pRl5wEew8Aoh2DCzw
	bWFnZf6RDHdZeCGHiZnGSLSfSWVerA5jzzvMkbD54tkvMooi2mnrdmrNiskdvGXGJ9pSuzaUNziTW
	pXBuD9tbITPvT/f0ULLOzCjHyiMpOsQQvZUygrJ8FZqdQSEDPxv8V5zTY0jOCk4ax/4vyf2AV/tSe
	5p2suoMc0jjEFHxQfoi577Vst6BXquuDWiakudKEr+bonwvYgYTgJxE+LWwnO3oFU0SeauEHJzICm
	vfJhz6s2pHwZqe05sVu2iBJ/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxdO-00Ff3I-2b;
	Tue, 25 Nov 2025 18:19:27 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 116/145] smb: server: make use of smbdirect_connection_recv_io_refill[_work]()
Date: Tue, 25 Nov 2025 18:56:02 +0100
Message-ID: <27c7b12d45b5c577c31e33290b2f21ef57312b26.1764091285.git.metze@samba.org>
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

This is basically a copy of smb_direct_post_recv_credits(), but
there are several improvements compared to the existing function:

1. We calculate the number of missing posted buffers by getting the
   difference between recv_io.credits.target and recv_io.posted.count.

   Instead of the difference between recv_io.credits.target
   and recv_io.credits.count, because recv_io.credits.count is
   only updated once a message is send to the peer.

   It was not really a problem before, because we have
   a fixed number smbdirect_recv_io buffers, so the
   loop terminated when smbdirect_connection_get_recv_io()
   returns NULL.

   But using recv_io.posted.count makes it easier to
   understand.

2. In order to tell the peer about the newly posted buffer
   and grant the credits, we only trigger the send immediate
   when we're not granting only the last possible credit.

   This is mostly a difference relative to the servers
   smb_direct_post_recv_credits() implementation,
   which should avoid useless ping pong messages.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 53 +++++++---------------------------
 1 file changed, 10 insertions(+), 43 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 70a819fb1187..1c509ff2a32a 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -202,7 +202,6 @@ static inline int get_buf_page_count(void *buf, int size)
 		(uintptr_t)buf / PAGE_SIZE;
 }
 
-static void smb_direct_post_recv_credits(struct work_struct *work);
 static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
 				     struct kvec *iov, int niov,
@@ -662,38 +661,6 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 	goto again;
 }
 
-static void smb_direct_post_recv_credits(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
-	struct smbdirect_recv_io *recvmsg;
-	int credits = 0;
-	int ret;
-
-	if (atomic_read(&sc->recv_io.credits.count) < sc->recv_io.credits.target) {
-		while (true) {
-			recvmsg = smbdirect_connection_get_recv_io(sc);
-			if (!recvmsg)
-				break;
-
-			recvmsg->first_segment = false;
-
-			ret = smbdirect_connection_post_recv_io(recvmsg);
-			if (ret) {
-				pr_err("Can't post recv: %d\n", ret);
-				smbdirect_connection_put_recv_io(recvmsg);
-				break;
-			}
-			credits++;
-
-			atomic_inc(&sc->recv_io.posted.count);
-		}
-	}
-
-	if (credits)
-		queue_work(sc->workqueue, &sc->idle.immediate_work);
-}
-
 static int manage_credits_prior_sending(struct smbdirect_socket *sc)
 {
 	int new_credits;
@@ -1734,24 +1701,24 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 
 	/*
 	 * We negotiated with success, so we need to refill the recv queue.
-	 * We do that with sc->idle.immediate_work still being disabled
-	 * via smbdirect_socket_init(), so that queue_work(sc->workqueue,
-	 * &sc->idle.immediate_work) in smb_direct_post_recv_credits()
-	 * is a no-op.
 	 *
 	 * The message that grants the credits to the client is
 	 * the negotiate response.
 	 */
-	INIT_WORK(&sc->recv_io.posted.refill_work, smb_direct_post_recv_credits);
-	smb_direct_post_recv_credits(&sc->recv_io.posted.refill_work);
-	if (unlikely(sc->first_error))
-		return sc->first_error;
-	INIT_WORK(&sc->idle.immediate_work, smb_direct_send_immediate_work);
+	ret = smbdirect_connection_recv_io_refill(sc);
+	if (ret < 0)
+		return ret;
+	ret = 0;
 
 respond:
 	ret = smb_direct_send_negotiate_response(sc, ret);
+	if (ret)
+		return ret;
 
-	return ret;
+	INIT_WORK(&sc->recv_io.posted.refill_work, smbdirect_connection_recv_io_refill_work);
+	INIT_WORK(&sc->idle.immediate_work, smb_direct_send_immediate_work);
+
+	return 0;
 }
 
 static int smb_direct_connect(struct smbdirect_socket *sc)
-- 
2.43.0

