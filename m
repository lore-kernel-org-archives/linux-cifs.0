Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08CE6F06B
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760540718; cv=none; b=SzmJ0jZF7mtu7cVrgf334Om/YMul47/8dx+SFStsgmOkSQzRSz/2OaBOPEmSkZhw8k1D5pUF86qZTUexnIk6VF+xVz66XsVzFZ5UQPeaaw7byF0+Q6/XTrDUmZtZgkb3NFcIn2Nrc6UC13UVZL6249xy03ijvyIwUTmw62IQFOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760540718; c=relaxed/simple;
	bh=jBBxriDtReLPxsbjdQ1Ozw9s3nR6Lixqn+tZrrrfHQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HI7TeytT/a/meNw3ToWmXVmc84A6A/b1tqZH7KP1nudqR0HXz2iBSy7g1AieRV68ZIjZszNNa90dco/d8PDgskr0AlRp28Eehstz3BqcV7bxJrthREIQawgYVeTr70FsByOEvpPkAAYq86OCyUVbiaJvmyle/O3ycLkne77xfpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XwnwGvY4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XwnwGvY4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ZNWKftmubrYzpqhCtL3gCegnsbPkOp1kDN/0FRZLnh8=; b=XwnwGvY4i7Y9huZDK8S05SjtBx
	XZAO8snTqs/OMFxAbZ69x3vVrJKTEIFVhW2yyCH0BJYfPkjjKRT7syGfq8yZTN5somNCoxPoPnXev
	i7eIcx1/3HRAx/YIiSYFO146/pYiJm/eFs2UbUuR6uGqwypKDfMla6nfNSh4j+KKhtDraMlB30btt
	wbbSphZR4tpqyArlluDOjjkMQ5iHIAxJY1t93VUl0vdBmxO4Tl3vBSgSni6dV9Ydm3Kn13Ns+81D/
	aj+6rKjaVPKGRJ3L9dAVwe6H0Rn2//f7AJKIla9bXzMgflUdvIJTkHPJg589qxYnfIIEbQzE81JC/
	3Pm3qvxiF3VOVszjrwLKDxYHP/G3sDzPaoljn/ZpcEnsp5kACzKDhn7th+NEdVKnaVlf8wX0iGey+
	TRzEUXlFkNcJSf6Iam9qX/edPPlVganrYuj1JVcr+SaaSzaAkm+HGViaJHlXANEnef5NyBjDjUfHT
	KSBDvfstOZecnmgwcXfNDU7u;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v933t-009NQa-0E;
	Wed, 15 Oct 2025 15:05:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] smb: client: let smbd_destroy() wait for SMBDIRECT_SOCKET_DISCONNECTED
Date: Wed, 15 Oct 2025 17:05:04 +0200
Message-ID: <20251015150504.1109560-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We should wait for the rdma_cm to become SMBDIRECT_SOCKET_DISCONNECTED,
it turns out that (at least running some xfstests e.g. cifs/001)
often triggers the case where wait_event_interruptible() returns
with -ERESTARTSYS instead of waiting for SMBDIRECT_SOCKET_DISCONNECTED
to be reached.

Or we are already in SMBDIRECT_SOCKET_DISCONNECTING and never wait
for SMBDIRECT_SOCKET_DISCONNECTED.

Fixes: 050b8c374019 ("smbd: Make upper layer decide when to destroy the transport")
Fixes: e8b3bfe9bc65 ("cifs: smbd: Don't destroy transport on RDMA disconnect")
Fixes: b0aa92a229ab ("smb: client: make sure smbd_disconnect_rdma_work() doesn't run after smbd_destroy() took over")
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 77de85d7cdc3..49e2df3ad1f0 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1575,12 +1575,12 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	disable_work_sync(&sc->disconnect_work);
 
 	log_rdma_event(INFO, "destroying rdma session\n");
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING) {
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
 		smbd_disconnect_rdma_work(&sc->disconnect_work);
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED) {
 		log_rdma_event(INFO, "wait for transport being disconnected\n");
-		wait_event_interruptible(
-			sc->status_wait,
-			sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
+		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
+		log_rdma_event(INFO, "waited for transport being disconnected\n");
 	}
 
 	/*
-- 
2.43.0

