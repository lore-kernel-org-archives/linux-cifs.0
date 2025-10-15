Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F6B21D5B3
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760540735; cv=none; b=AEzVBiRHkkOHnXImeMEQ24plUHCBIPcOJFbBCsruqQviItIvbqjChU2aWLGB0Wgp7VF3yKCo4CVNuMYlEMXs9J9WG9wm2hVrpOLHub8ilYajfWBCFHEZv3LAVgxzooLWOqMHTk4gYnSvaGw96mz7ttsoRNDV0MVfyfC3D/IU6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760540735; c=relaxed/simple;
	bh=FimK+hJakdoVWkhUdHBtw53eE77l40lOwD9O7lCYymw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RtB1hKCJ4c+ExgdA3YLWX7Pribx1Z1kLSZeBuUP+Khrjf8ubiVFTBnXM3QsjvH2Lm25zz1XOCllyWUJ6xmeyzxb14EgZHntJgJvyyIPy8FoHTfhnK+I/a0JHw23UQgOsezb9LXGA9Hz9lCgjjLmOFVqEVYjRzguxHyB46Wp0DcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fGEPAv/R; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fGEPAv/R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=uqHfZvIPYNUj+IkuMVTh9wKXZi5q/e4ZRc+uIT8Z73k=; b=fGEPAv/Rr70eS7VenS1vPmmrGC
	16OGqcvd2PW4dLNBDy/E0J/li4heG4K7XbukZZAgdcuJ2ueOq9Zi2gwgQ6Tr2vJjMBHy2jRcV1IRT
	uWABHJ6PI6qFjaqArSA991yV2u0qd16KO3GF3shZQ4C1ei1li/MamrXmop0CiNW+kJV0gnkh5MfXb
	7AbFdbDnYx4lk7OqdCV9qYLpjrZr2cxzwmQyVLVPS9IYcGX/kAJX2Kk+RWTQE5ktbA2JEBD5APvIL
	gj8KagOhp94fy8SsbSeICxrBdg4C79We4btcjqhWg6WTy6pGq+tHx/T4p7IwrVCx2bgoY7/ruTzAw
	uElfYKFmoh2qxcaxdlQGwu1NUA4fe0TKVdRdmlnRbUVVfD6qx3oP06QY+qB5tsa8qUoI3osJrBOz0
	BmZxrRNuQ/ILuFo8AR8+9uRLtlTFxuFqzOL7gCnR6xSDzY58cGH36FJf8k26QznJfdlsrHxjjzs9f
	EWvLhFoK5k9fnreUnmsNXj3L;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v934E-009NR1-0F;
	Wed, 15 Oct 2025 15:05:30 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH] smb: server: let free_transport() wait for SMBDIRECT_SOCKET_DISCONNECTED
Date: Wed, 15 Oct 2025 17:05:27 +0200
Message-ID: <20251015150527.1109622-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We should wait for the rdma_cm to become SMBDIRECT_SOCKET_DISCONNECTED!

At least on the client side (with similar code)
wait_event_interruptible() often returns with -ERESTARTSYS instead of
waiting for SMBDIRECT_SOCKET_DISCONNECTED.
We should use wait_event() here too, which makes the code be identical
in client and server, which will help when moving to common functions.

Fixes: b31606097de8 ("smb: server: move smb_direct_disconnect_rdma_work() into free_transport()")
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index a201c5871a77..94851ff25a02 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -450,11 +450,10 @@ static void free_transport(struct smb_direct_transport *t)
 	struct smbdirect_recv_io *recvmsg;
 
 	disable_work_sync(&sc->disconnect_work);
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING) {
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
 		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
-		wait_event_interruptible(sc->status_wait,
-					 sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
-	}
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED)
+		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 
 	/*
 	 * Wake up all waiters in all wait queues
-- 
2.43.0

