Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E601E89C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155472; cv=none; b=Z3f8zOh48Dq/KUBV3OjqWe9CO3ETkCP8L69vkLPzfH6wdTE5/27z7fhrPLU7EDxCx2RxVv0dVpPn7HoIOI2JPpCCTLkw+sImnHwSgQTQXPehSCxvldoYxmtVheMUnydp5I9K8eKtQS4Pz+WOmLz/vkpa5u6UWJb901n1b5011pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155472; c=relaxed/simple;
	bh=PjKTcYLwfpW6escS9oxXwGCamLeJNcsc77y7x5dtf6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djJ8rCS/DI+uY80OP+MO4GFrDBmfh453t9Y9saI8JGsMdAcyh4s23TcrTOxkGUDxj8QesspExAVVh/iTLgNC0op/sslfHtDhFIiY+zcl/v/jRKm2Dozi+I1gMfxJBF1Nq43GNZbAHl3KH8/Cm/vqWvuhyPJqNe3T5LihNOsBStM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=o+s8spXq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="o+s8spXq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=1EZqM+C7CseZMdabrUbnoNqhM8T64V5iIdljTIxw7eo=; b=o+s8spXqZ1dJ3izrGAma3Pumif
	Vb2dUzVT0EXs+JD1IzT/7h3Hl9iOQo8oZS+iwC31Km8kYV33NM5bjh+sFa/CT9kojE6qBzKbNrKR5
	XdjHpQxH6usSCn4fyikYr8yPSjCtQEEUY3sYxFDKKIAUcNcsACNo/nexZk2mjdT15pn2Vy+Z9q2ps
	Acfr/fzLbDV2UojxnY62pVm8p7eft7OOcLAHg0kp/xCftGVn0RRAyJ6ou46VaowSpZ5M29TO18P6G
	NT46dpej5n708Z9gFy/9N4Ywn4T68ZEbvDYAqc7fD54EY1Q7mejwRs7szFxob1FCCMbscwBm8n7O6
	rmu8o345yoxaKmFm1B9G6Fen3/nQBFreeDKrD61Reo7E4PaYy6aRXgJI4XEgBlFaxuNTYivAyuy2R
	PixpeWeCRS3gbreMF400LUJDbDyj4jVuYCVr1ZBpYW0Bw/fuExXMDONyejCNMECvXMDcvUgGa7iW5
	1+YYnBuY0JKH6XYTE2r+vBPj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeGA-000mPt-1H;
	Mon, 25 Aug 2025 20:57:47 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 096/142] smb: server: make use of smbdirect_socket_init()
Date: Mon, 25 Aug 2025 22:40:57 +0200
Message-ID: <6522578c5fe66cf66cd707c11c8f6a3929a2b957.1756139607.git.metze@samba.org>
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

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index d5b01748f0c4..f41c82598e3c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -323,6 +323,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	if (!t)
 		return NULL;
 	sc = &t->socket;
+	smbdirect_socket_init(sc);
 
 	sc->rdma.cm_id = cm_id;
 	cm_id->context = t;
@@ -332,17 +333,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 
 	sc->ib.dev = sc->rdma.cm_id->device;
 
-	INIT_LIST_HEAD(&sc->recv_io.free.list);
-	spin_lock_init(&sc->recv_io.free.lock);
-
-	sc->status = SMBDIRECT_SOCKET_CREATED;
-	init_waitqueue_head(&sc->status_wait);
-
-	spin_lock_init(&sc->recv_io.reassembly.lock);
-	INIT_LIST_HEAD(&sc->recv_io.reassembly.list);
-	sc->recv_io.reassembly.data_length = 0;
-	sc->recv_io.reassembly.queue_length = 0;
-	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
 	init_waitqueue_head(&t->wait_send_credits);
 	init_waitqueue_head(&t->wait_rw_credits);
 
-- 
2.43.0

