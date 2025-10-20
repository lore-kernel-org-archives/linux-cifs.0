Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B7AC2FB
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 14:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760969250; cv=none; b=evi7VxGoPY+dy7R9T0vU05WUE6RYZgNukXAswL3ScPBneoFDJPCd+2yyR5FvJYjbC4L2pdSsOWsHfoVSBSrwGuCKwYAZ40CFkcCXDyX51xC9kvQspkCGbZJ6sd6NKkuHoDl8ptvLByDbXffwlYTo4i0CHQWGxNpHJn+GgXG6xYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760969250; c=relaxed/simple;
	bh=EmGjWevRpaEIJ6nK1aoiYoKkjVzOTDs+zWEL0leU8Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IQVyHVntw3YAYKSL6d9DxF9LZIhvec5/uuuacDitDlXQxIkrNZ4PAkJkLK9TfZzZGTNUhPZlxlSJDFdnlZFy71uWKyKBsD2vtn0qa7K6S1rXkeLbLDpl2eVoMSwMqqvsvXd2qM9j1KT1tsqgssqFsaiayTaXbdb7lX0URJq5QAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jbIm4Hj0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jbIm4Hj0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=CKbs8F46hzWpAcLY1h695ycsojLGA5bkvcNuSHQPy5M=; b=jbIm4Hj0Hmjys4qMAGE61aUhF4
	UYZlDDBIHirVdTVooTs84pMo2Chy3bA2iCme/E+brSpPQ3EK40B/qkQBxEKjNykWD0i/1tYrKw/OV
	O4EgreN1c1gmTKEZ786umMGr48v0KKa/EXVygNqeQUqrxIddCDYyhuZIQafyT08HVXR31Ef8CZJJz
	iYy9DXW8BH16v5Lg1D8TEwxjMrl63as7c9SQns9RO8fxkWhr5lWDzcw31uob49AXuuoL5FMRaDjkG
	gn+Ncq3umFKe5xrhvOQr8yQ1Zti970MOxeF6fyhC8nTjxNnK8TXueuivKvI3auZUr1QDWZesHyzaM
	3qndarIRZ5fTpD7D/lRrNZZGDEQcpXX4hkpUz0xZnFqJ1N4YXPPciXBJF6QPdb9LdgglQizCp4Mrg
	lOshACNeTLV48h7nv4SZ3EM4exKkJgR8xLVo+T3nejtzimxEWHftMCLH7wIICOF3roz5XQpsPL+XB
	G71iDZ//DnmZyUlABpzZBin8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vAqXf-00AATL-0I;
	Mon, 20 Oct 2025 14:07:19 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH] smb: server: call smb_direct_post_recv_credits() when the negotiation is done
Date: Mon, 20 Oct 2025 16:07:13 +0200
Message-ID: <20251020140713.155001-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We now activate sc->recv_io.posted.refill_work and sc->idle.immediate_work
only after a successful negotiation, before sending the negotiation
response.

It means the queue_work(sc->workqueue, &sc->recv_io.posted.refill_work)
in put_recvmsg() of the negotiate request, is a no-op now.

It also means our explicit smb_direct_post_recv_credits() will
have queue_work(sc->workqueue, &sc->idle.immediate_work) as no-op.

This should make sure we don't have races and post any immediate
data_transfer message that tries to grant credits to the peer,
before we send the negotiation response, as that will grant
the initial credits to the peer.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Fixes: 1cde0a74a7a8 ("smb: server: don't use delayed_work for post_recv_credits_work")
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 36 ++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 90cf5ab36103..1b597f9f85e3 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -417,9 +417,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 
 	sc->ib.dev = sc->rdma.cm_id->device;
 
-	INIT_WORK(&sc->recv_io.posted.refill_work,
-		  smb_direct_post_recv_credits);
-	INIT_WORK(&sc->idle.immediate_work, smb_direct_send_immediate_work);
 	INIT_DELAYED_WORK(&sc->idle.timer_work, smb_direct_idle_connection_timer);
 
 	conn = ksmbd_conn_alloc();
@@ -1862,7 +1859,6 @@ static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
 		goto out_err;
 	}
 
-	smb_direct_post_recv_credits(&sc->recv_io.posted.refill_work);
 	return 0;
 out_err:
 	put_recvmsg(sc, recvmsg);
@@ -2205,8 +2201,8 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 		return -ECONNABORTED;
 
 	ret = smb_direct_check_recvmsg(recvmsg);
-	if (ret == -ECONNABORTED)
-		goto out;
+	if (ret)
+		goto put;
 
 	req = (struct smbdirect_negotiate_req *)recvmsg->packet;
 	sp->max_recv_size = min_t(int, sp->max_recv_size,
@@ -2221,14 +2217,38 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	sc->recv_io.credits.target = min_t(u16, sc->recv_io.credits.target, sp->recv_credit_max);
 	sc->recv_io.credits.target = max_t(u16, sc->recv_io.credits.target, 1);
 
-	ret = smb_direct_send_negotiate_response(sc, ret);
-out:
+put:
 	spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
 	sc->recv_io.reassembly.queue_length--;
 	list_del(&recvmsg->list);
 	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
 	put_recvmsg(sc, recvmsg);
 
+	if (ret == -ECONNABORTED)
+		return ret;
+
+	if (ret)
+		goto respond;
+
+	/*
+	 * We negotiated with success, so we need to refill the recv queue.
+	 * We do that with sc->idle.immediate_work still being disabled
+	 * via smbdirect_socket_init(), so that queue_work(sc->workqueue,
+	 * &sc->idle.immediate_work) in smb_direct_post_recv_credits()
+	 * is a no-op.
+	 *
+	 * The message that grants the credits to the client is
+	 * the negotiate response.
+	 */
+	INIT_WORK(&sc->recv_io.posted.refill_work, smb_direct_post_recv_credits);
+	smb_direct_post_recv_credits(&sc->recv_io.posted.refill_work);
+	if (unlikely(sc->first_error))
+		return sc->first_error;
+	INIT_WORK(&sc->idle.immediate_work, smb_direct_send_immediate_work);
+
+respond:
+	ret = smb_direct_send_negotiate_response(sc, ret);
+
 	return ret;
 }
 
-- 
2.43.0

